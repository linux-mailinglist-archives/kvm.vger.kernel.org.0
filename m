Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC12650D111
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 12:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239062AbiDXKTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 06:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239012AbiDXKTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 06:19:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470DC4ECEA;
        Sun, 24 Apr 2022 03:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650795362; x=1682331362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xk/86zUzUAfWuppfgsBbZJ/BJPyRckuC0Nw4Y+Xr0lM=;
  b=VQkPAklW3PF/cYFvUx9sgKsFwguZVScmimCm8JjvH22s/4Htf+XFJUUT
   ooi+NZynrQQMCfwKX/4PvlrfHKV5RqF0Nhjz8h8pHt28vYCsGOYHSYSJT
   xibu4cmNdfC4AstMSFHS5kNQBbyf3Q0cMmY2TEQhM5+CnKRFZpfVBJB94
   nU+fblq86FTQFEbYhXgLp2zYwWRGcbSUljOdR8feSsuDGLodbnTKCYz/u
   UB4fYcHu5yxmVEGHB+ExbgsDvEzhQEJosiKkeD3EUah++QOeXLrMUnIV+
   CZuE1QHQUx0qUi7yxd0ZTxho6JL83AE+33G8IHyEJJmWpNMjO9+WB2/fa
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="264813948"
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="264813948"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:16:01 -0700
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="616086726"
Received: from 984fee00be24.jf.intel.com ([10.165.54.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:16:00 -0700
From:   Lei Wang <lei4.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     lei4.wang@intel.com, chenyi.qiang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 7/8] KVM: VMX: Expose PKS to guest
Date:   Sun, 24 Apr 2022 03:15:56 -0700
Message-Id: <20220424101557.134102-8-lei4.wang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220424101557.134102-1-lei4.wang@intel.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chenyi Qiang <chenyi.qiang@intel.com>

Existence of PKS is enumerated via CPUID.(EAX=7,ECX=0):ECX[31]. It is
enabled by setting CR4.PKS when long mode is active. PKS is only
implemented when EPT is enabled and requires the support of
VM_{ENTRY,EXIT}_LOAD_IA32_PKRS VMCS controls currently.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Co-developed-by: Lei Wang <lei4.wang@intel.com>
Signed-off-by: Lei Wang <lei4.wang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/cpuid.c            | 13 +++++++++----
 arch/x86/kvm/vmx/capabilities.h |  6 ++++++
 arch/x86/kvm/vmx/vmx.c          | 10 +++++++---
 arch/x86/kvm/x86.h              |  2 ++
 5 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a245d9817f72..6f78ed784661 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -117,7 +117,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_PKS))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b24ca7f4ed7c..f419bdd7f6af 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -570,18 +570,23 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
-		F(SGX_LC) | F(BUS_LOCK_DETECT)
+		F(SGX_LC) | F(BUS_LOCK_DETECT) | F(PKS)
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
 		kvm_cpu_cap_set(X86_FEATURE_LA57);
 
 	/*
-	 * PKU not yet implemented for shadow paging and requires OSPKE
-	 * to be set on the host. Clear it if that is not the case
+	 * Protection Keys are not supported for shadow paging.  PKU further
+	 * requires OSPKE to be set on the host in order to use {RD,WR}PKRU to
+	 * save/restore the guests PKRU.
 	 */
-	if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
+	if (!tdp_enabled) {
 		kvm_cpu_cap_clear(X86_FEATURE_PKU);
+		kvm_cpu_cap_clear(X86_FEATURE_PKS);
+	} else if (!boot_cpu_has(X86_FEATURE_OSPKE)) {
+		kvm_cpu_cap_clear(X86_FEATURE_PKU);
+	}
 
 	kvm_cpu_cap_mask(CPUID_7_EDX,
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 3f430e218375..cc9c23ab85fd 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -104,6 +104,12 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
 }
 
+static inline bool cpu_has_load_ia32_pkrs(void)
+{
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PKRS) &&
+	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PKRS);
+}
+
 static inline bool cpu_has_vmx_mpx(void)
 {
 	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_BNDCFGS) &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9d0588e85410..cbcb0d7b47a4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3250,7 +3250,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		}
 
 		/*
-		 * SMEP/SMAP/PKU is disabled if CPU is in non-paging mode in
+		 * SMEP/SMAP/PKU/PKS is disabled if CPU is in non-paging mode in
 		 * hardware.  To emulate this behavior, SMEP/SMAP/PKU needs
 		 * to be manually disabled when guest switches to non-paging
 		 * mode.
@@ -3258,10 +3258,11 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		 * If !enable_unrestricted_guest, the CPU is always running
 		 * with CR0.PG=1 and CR4 needs to be modified.
 		 * If enable_unrestricted_guest, the CPU automatically
-		 * disables SMEP/SMAP/PKU when the guest sets CR0.PG=0.
+		 * disables SMEP/SMAP/PKU/PKS when the guest sets CR0.PG=0.
 		 */
 		if (!is_paging(vcpu))
-			hw_cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
+			hw_cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE |
+				    X86_CR4_PKS);
 	}
 
 	vmcs_writel(CR4_READ_SHADOW, cr4);
@@ -7500,6 +7501,9 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
+
+	if (cpu_has_load_ia32_pkrs())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_PKS);
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7610f0d40b0f..997b85a20962 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -449,6 +449,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_PKS))		\
+		__reserved_bits |= X86_CR4_PKS;		\
 	__reserved_bits;                                \
 })
 
-- 
2.25.1

