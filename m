Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BECA1C6B6F
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 10:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgEFITo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 04:19:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:35417 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbgEFITm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 04:19:42 -0400
IronPort-SDR: iXEZ8oeZurQ47CGS6msqWshgqNJJKDXGwaKao2EHUK+VM4KdHGVIrDf6xdLYcIlxSYhNCki1Dd
 V0nSzKWNrXog==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 01:19:42 -0700
IronPort-SDR: /jQbMcQDdS+SfK3xYG6bTZ3poUfrMtl5T3GShpwxiaybZ7LxaTiGayXSaLmvLMpDYd8J1+KSVe
 AfDGgYvbNCSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,358,1583222400"; 
   d="scan'208";a="260030101"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2020 01:19:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 05/10] KVM: x86: Load guest fpu state when access MSRs managed by XSAVES
Date:   Wed,  6 May 2020 16:21:04 +0800
Message-Id: <20200506082110.25441-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200506082110.25441-1-weijiang.yang@intel.com>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

A handful of CET MSRs are not context switched through "traditional"
methods, e.g. VMCS or manual switching, but rather are passed through
to the guest and are saved and restored by XSAVES/XRSTORS, i.e. in the
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
 arch/x86/kvm/x86.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c866087ed0ef..50f80dcab3a9 100644
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
@@ -3267,6 +3269,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -3277,11 +3285,20 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
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

