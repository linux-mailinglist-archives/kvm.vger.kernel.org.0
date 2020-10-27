Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D906529CB2D
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 22:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373866AbgJ0VYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 17:24:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:56185 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373803AbgJ0VXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 17:23:55 -0400
IronPort-SDR: xym8sBF/GXmtfisPENrn1CK8QwrHfQwrZZt71N3mHutqWWU2++1lCpODNXHFSE+scDYCpgOcet
 dmdMhXiAtBYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="155133712"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="155133712"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 14:23:51 -0700
IronPort-SDR: wuwGtIlXxI9tKeWTdszwyjGPEbWXNONNeIX6qxWIC5MhE4S5EPqNSGWBQ3lFeoeSMz2yVyny12
 f5J1NyTWku9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="524886402"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga006.fm.intel.com with ESMTP; 27 Oct 2020 14:23:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/11] KVM: VMX: Define Hyper-V paravirt TLB flush fields iff Hyper-V is enabled
Date:   Tue, 27 Oct 2020 14:23:44 -0700
Message-Id: <20201027212346.23409-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027212346.23409-1-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ifdef away the Hyper-V specific fields in structs kvm_vmx and vcpu_vmx
as each field has only a single reference outside of the struct itself
that isn't already wrapped in ifdeffery (and both are initialization).

vcpu_vmx.ept_pointer in particular should be wrapped as it is valid if
and only if Hyper-v is active, i.e. non-Hyper-V code cannot rely on it
to actually track the current EPTP (without additional code changes).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 ++++-
 arch/x86/kvm/vmx/vmx.h | 4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b684f45d6a78..5b7c5b2fd2c7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6955,8 +6955,9 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
 	vmx->pi_desc.sn = 1;
 
+#if IS_ENABLED(CONFIG_HYPERV)
 	vmx->ept_pointer = INVALID_PAGE;
-
+#endif
 	return 0;
 
 free_vmcs:
@@ -6973,7 +6974,9 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 static int vmx_vm_init(struct kvm *kvm)
 {
+#if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&to_kvm_vmx(kvm)->ept_pointer_lock);
+#endif
 
 	if (!ple_gap)
 		kvm->arch.pause_in_guest = true;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index cecc2a641e19..2bd86d8b2f4b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -276,7 +276,9 @@ struct vcpu_vmx {
 	 */
 	u64 msr_ia32_feature_control;
 	u64 msr_ia32_feature_control_valid_bits;
+#if IS_ENABLED(CONFIG_HYPERV)
 	u64 ept_pointer;
+#endif
 
 	struct pt_desc pt_desc;
 
@@ -295,8 +297,10 @@ struct kvm_vmx {
 	bool ept_identity_pagetable_done;
 	gpa_t ept_identity_map_addr;
 
+#if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_tlb_eptp;
 	spinlock_t ept_pointer_lock;
+#endif
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
-- 
2.28.0

