Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFA9312B06E
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2019 03:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfL0CHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Dec 2019 21:07:34 -0500
Received: from mga17.intel.com ([192.55.52.151]:38924 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbfL0CHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Dec 2019 21:07:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Dec 2019 18:07:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,361,1571727600"; 
   d="scan'208";a="223675049"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 26 Dec 2019 18:07:32 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 6/7] KVM: X86: Load guest fpu state when accessing MSRs managed by XSAVES
Date:   Fri, 27 Dec 2019 10:11:32 +0800
Message-Id: <20191227021133.11993-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191227021133.11993-1-weijiang.yang@intel.com>
References: <20191227021133.11993-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

A handful of CET MSRs are not context switched through "traditional"
methods, e.g. VMCS or manual switching, but rather are passed through
to the guest and are saved and restored by XSAVES/XRSTORS, i.e. the
guest's FPU state.

Load the guest's FPU state if userspace is accessing MSRs whose values
are managed by XSAVES so that the MSR helper, e.g. vmx_{get,set}_msr(),
can simply do {RD,WR}MSR to access the guest's value.

Note that guest_cpuid_has() is not queried as host userspace is allowed
to access MSRs that have not been exposed to the guest, e.g. it might do
KVM_SET_MSRS prior to KVM_SET_CPUID2.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b27d97eaec24..6dbe77365b22 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -104,6 +104,8 @@ static void enter_smm(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
+static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
+static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
 
 struct kvm_x86_ops *kvm_x86_ops __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
@@ -3129,6 +3131,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 EXPORT_SYMBOL_GPL(kvm_get_msr_common);
 
+static bool is_xsaves_msr(u32 index)
+{
+	return index == MSR_IA32_U_CET ||
+	       (index >= MSR_IA32_PL0_SSP && index <= MSR_IA32_PL3_SSP);
+}
+
 /*
  * Read or write a bunch of msrs. All parameters are kernel addresses.
  *
@@ -3139,11 +3147,22 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
 		    int (*do_msr)(struct kvm_vcpu *vcpu,
 				  unsigned index, u64 *data))
 {
+	bool fpu_loaded = false;
 	int i;
+	const u64 cet_bits = XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL;
+	bool cet_xss = kvm_supported_xss() & cet_bits;
 
-	for (i = 0; i < msrs->nmsrs; ++i)
+	for (i = 0; i < msrs->nmsrs; ++i) {
+		if (vcpu && !fpu_loaded && cet_xss &&
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

