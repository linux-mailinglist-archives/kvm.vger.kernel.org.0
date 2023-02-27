Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA316A47BA
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 18:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjB0RST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 12:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjB0RSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 12:18:17 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A77E96EB0;
        Mon, 27 Feb 2023 09:18:15 -0800 (PST)
Received: from vm02.corp.microsoft.com (unknown [167.220.196.155])
        by linux.microsoft.com (Postfix) with ESMTPSA id A6B2F20BC5E7;
        Mon, 27 Feb 2023 09:18:13 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A6B2F20BC5E7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1677518295;
        bh=fknedrBN9SwzuVi6ot1s6RGt4uHR8qcI6hAfSyjoEfM=;
        h=From:To:Cc:Subject:Date:From;
        b=ThR2HyTEPb8Z4zjVX+cn1Rno45lCerw0KQn0uxlZNWM1DtDzFCX+sAc8fK61cK1Rn
         0lcaY50yjzua3uHlxiKwxCunnqxlbws+KanjnafbyzzZGWhxLCRufKHaSxGPOAU6XE
         JJUGO1/hJdQ0CZUWDtOoClvOXhMDOWonCG1rmTQo=
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
Date:   Mon, 27 Feb 2023 17:17:51 +0000
Message-Id: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDP MMU has been broken on AMD CPUs when running on Hyper-V since v5.17.
The issue was first introduced by two commmits:

- bb95dfb9e2dfbe6b3f5eb5e8a20e0259dadbe906 "KVM: x86/mmu: Defer TLB
  flush to caller when freeing TDP MMU shadow pages"
- efd995dae5eba57c5d28d6886a85298b390a4f07 "KVM: x86/mmu: Zap defunct
  roots via asynchronous worker"

The root cause is that since then there are missing TLB flushes which
are required by HV_X64_NESTED_ENLIGHTENED_TLB. The failure manifests
as L2 guest VMs being unable to complete boot due to memory
inconsistencies between L1 and L2 guests which lead to various
assertion/emulation failures.

The HV_X64_NESTED_ENLIGHTENED_TLB enlightenment is always exposed by
Hyper-V on AMD and is always used by Linux. The TLB flush required by
HV_X64_NESTED_ENLIGHTENED_TLB is much stricter than the local TLB flush
that TDP MMU wants to issue. We have also found that with TDP MMU L2 guest
boot performance on AMD is reproducibly slower compared to when TDP MMU is
disabled.

Disable TDP MMU when using SVM Hyper-V for the time being while we
search for a better fix.

Link: https://lore.kernel.org/lkml/43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com/t/#u
Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
---
Based on kvm-x86-mmu-6.3. The approach used here does not apply cleanly to
<=v6.2. This would be needed in stable too, and I don't know about putting
fixes tags.

Jeremi

 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/mmu/mmu.c          |  5 +++--
 arch/x86/kvm/svm/svm.c          |  6 +++++-
 arch/x86/kvm/svm/svm_onhyperv.h | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 5 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4d2bc08794e4..a0868ae3688d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2031,7 +2031,8 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 
 void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
-		       int tdp_max_root_level, int tdp_huge_page_level);
+		       int tdp_max_root_level, int tdp_huge_page_level,
+		       bool enable_tdp_mmu);
 
 static inline u16 kvm_read_ldt(void)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c91ee2927dd7..5c0e28a7a3bc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5787,14 +5787,15 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 }
 
 void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
-		       int tdp_max_root_level, int tdp_huge_page_level)
+		       int tdp_max_root_level, int tdp_huge_page_level,
+		       bool enable_tdp_mmu)
 {
 	tdp_enabled = enable_tdp;
 	tdp_root_level = tdp_forced_root_level;
 	max_tdp_level = tdp_max_root_level;
 
 #ifdef CONFIG_X86_64
-	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
+	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled && enable_tdp_mmu;
 #endif
 	/*
 	 * max_huge_page_level reflects KVM's MMU capabilities irrespective
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d13cf53e7390..070c3f7f8c9f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4925,6 +4925,7 @@ static __init int svm_hardware_setup(void)
 	struct page *iopm_pages;
 	void *iopm_va;
 	int r;
+	bool enable_tdp_mmu;
 	unsigned int order = get_order(IOPM_SIZE);
 
 	/*
@@ -4991,9 +4992,12 @@ static __init int svm_hardware_setup(void)
 	if (!boot_cpu_has(X86_FEATURE_NPT))
 		npt_enabled = false;
 
+	enable_tdp_mmu = svm_hv_enable_tdp_mmu();
+
 	/* Force VM NPT level equal to the host's paging level */
 	kvm_configure_mmu(npt_enabled, get_npt_level(),
-			  get_npt_level(), PG_LEVEL_1G);
+			  get_npt_level(), PG_LEVEL_1G,
+			  enable_tdp_mmu);
 	pr_info("Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
 	/* Setup shadow_me_value and shadow_me_mask */
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index 6981c1e9a809..aa49ac5d66bc 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -30,6 +30,11 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 		hve->hv_enlightenments_control.msr_bitmap = 1;
 }
 
+static inline bool svm_hv_enable_tdp_mmu(void)
+{
+	return !(npt_enabled && ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB);
+}
+
 static inline void svm_hv_hardware_setup(void)
 {
 	if (npt_enabled &&
@@ -84,6 +89,11 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
 }
 
+static inline bool svm_hv_enable_tdp_mmu(void)
+{
+	return true;
+}
+
 static inline void svm_hv_hardware_setup(void)
 {
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c788aa382611..4d3808755d39 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8442,7 +8442,8 @@ static __init int hardware_setup(void)
 	vmx_setup_me_spte_mask();
 
 	kvm_configure_mmu(enable_ept, 0, vmx_get_max_tdp_level(),
-			  ept_caps_to_lpage_level(vmx_capability.ept));
+			  ept_caps_to_lpage_level(vmx_capability.ept),
+			  true);
 
 	/*
 	 * Only enable PML when hardware supports PML feature, and both EPT
-- 
2.25.1

