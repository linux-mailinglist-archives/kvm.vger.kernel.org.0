Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607EF2AE8F5
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 07:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgKKGbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 01:31:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:43536 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgKKGbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 01:31:31 -0500
IronPort-SDR: rRDXnjjU7ZMIWdfPpXaeu7pyfzrT3IwukqC3zYTi/q7ViqbG5dGW3o/QgAlWppxo14OMvVrwXx
 sJRYl3sRwdMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="149951506"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="149951506"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 22:31:31 -0800
IronPort-SDR: GMpqRpbl8bq4QZhjx4v4tmlThZ+KDjZtejXGy8Z6x0katfNkAb/jXqpCSOpD/fUMINIqhqeTwt
 E8x3m2LkGpLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="323167596"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.156])
  by orsmga003.jf.intel.com with ESMTP; 10 Nov 2020 22:31:29 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 3/3] KVM: x86: Load guest fpu state when accessing MSRs managed by XSAVES
Date:   Wed, 11 Nov 2020 14:41:51 +0800
Message-Id: <20201111064151.1090-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201111064151.1090-1-weijiang.yang@intel.com>
References: <20201111064151.1090-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

When feature MSRs supported in XSS are passed through to the guest
they are saved and restored by XSAVES/XRSTORS, i.e. in the guest's FPU
state.

Load the guest's FPU state if userspace is accessing MSRs whose values are
managed by XSAVES so that the MSR helper, e.g. vmx_{get,set}_xsave_msr(),
can simply do {RD,WR}MSR to access the guest's value.

Because is also used for the KVM_GET_MSRS device ioctl(), explicitly
check that @vcpu is non-null before attempting to load guest state.  The
XSS supporting MSRs cannot be retrieved via the device ioctl() without
loading guest FPU state (which doesn't exist).

MSRs that are switched through XSAVES are especially annoying due to the
possibility of the kernel's FPU being used in IRQ context.  Disable IRQs
and ensure the guest's FPU state is loaded when accessing such MSRs.

Note that guest_cpuid_has() is not queried as host userspace is allowed
to access MSRs that have not been exposed to the guest, e.g. it might do
KVM_SET_MSRS prior to KVM_SET_CPUID2.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++++++++++
 arch/x86/kvm/x86.c     | 23 ++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aef73dd3de4f..25293a499ced 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1773,6 +1773,28 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
 	return !(val & ~valid_bits);
 }
 
+/*
+ * Below two helpers are used for XSS managed guest MSRs, accessing the MSRs
+ * should rely on these helpers to avoid latent guest MSR content overwritten.
+ */
+static void __maybe_unused vmx_get_xsave_msr(struct msr_data *msr_info)
+{
+	local_irq_disable();
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		switch_fpu_return();
+	rdmsrl(msr_info->index, msr_info->data);
+	local_irq_enable();
+}
+
+static void __maybe_unused vmx_set_xsave_msr(struct msr_data *msr_info)
+{
+	local_irq_disable();
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		switch_fpu_return();
+	wrmsrl(msr_info->index, msr_info->data);
+	local_irq_enable();
+}
+
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f0557d47c75e..409bde09b293 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -109,6 +109,8 @@ static void enter_smm(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
+static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
+static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
 
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
@@ -3575,6 +3577,16 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 EXPORT_SYMBOL_GPL(kvm_get_msr_common);
 
+/*
+ * If new features passthrough XSS managed MSRs to guest, it's required to
+ * add separate checks here so as to load feature dependent guest MSRs before
+ * access them.
+ */
+static bool is_xsaves_msr(u32 index)
+{
+	return false;
+}
+
 /*
  * Read or write a bunch of msrs. All parameters are kernel addresses.
  *
@@ -3585,11 +3597,20 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
 		    int (*do_msr)(struct kvm_vcpu *vcpu,
 				  unsigned index, u64 *data))
 {
+	bool fpu_loaded = false;
 	int i;
 
-	for (i = 0; i < msrs->nmsrs; ++i)
+	for (i = 0; i < msrs->nmsrs; ++i) {
+		if (vcpu && !fpu_loaded && supported_xss &&
+		    is_xsaves_msr(entries[i].index)) {
+			kvm_load_guest_fpu(vcpu);
+			fpu_loaded = true;
+		}
 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
 			break;
+	}
+	if (fpu_loaded)
+		kvm_put_guest_fpu(vcpu);
 
 	return i;
 }
-- 
2.17.2

