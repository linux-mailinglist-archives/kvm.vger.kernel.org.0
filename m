Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4736950D109
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 12:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239010AbiDXKTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 06:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238997AbiDXKTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 06:19:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064B34ECDE;
        Sun, 24 Apr 2022 03:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650795360; x=1682331360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jf0sdA0pfpDS78svVoTxE3uyUlT8Z1t9Z6i4qHugW48=;
  b=djZM3MvyJXW14BFboeb2S63+IP3St6NHVilkj5x1tTZsC2LYElA4UWpI
   VxEkzJjuON9oPuULohzBqrTz/fT2N1c7MDZJ52NOe6XPcjBdLX9mlBgNs
   NO7cCByzbFPVy2CtwYNqd/K2bv0kPFP2Or/PjWtkW7jAad5asjCcRcyif
   b51+ggYTFJgO64zv/nad5GHDv0XaBRdNDAai8gn+04kOZo0hemNPIexez
   dG/LcfpmbNV6vImupNv83kwlg1ShnxpEaVJcpTwTt1ObDFQdR5Bajyivg
   gc/dQ/4sQobn4qcAy68dO6ARvS+lt+pjl1rvmCNkHQxrHFyB3H/jrhvUd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="264813943"
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="264813943"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:15:59 -0700
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="616086710"
Received: from 984fee00be24.jf.intel.com ([10.165.54.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:15:58 -0700
From:   Lei Wang <lei4.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     lei4.wang@intel.com, chenyi.qiang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 2/8] KVM: VMX: Add proper cache tracking for PKRS
Date:   Sun, 24 Apr 2022 03:15:51 -0700
Message-Id: <20220424101557.134102-3-lei4.wang@intel.com>
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

Add PKRS caching into the standard register caching mechanism in order
to take advantage of the availability checks provided by regs_avail.

This is because vcpu->arch.pkrs will be rarely acceesed by KVM, only in
the case of host userspace MSR reads and GVA->GPA translation in
following patches. It is unnecessary to keep it up-to-date at all times.

It also should be noted that the potential benefits of this caching are
tenuous because the MSR read is not a hot path. it's nice-to-have so that
we don't hesitate to rip it out in the future if there's a strong reason
to drop the caching.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Co-developed-by: Lei Wang <lei4.wang@intel.com>
Signed-off-by: Lei Wang <lei4.wang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/kvm_cache_regs.h   |  7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.h          |  3 ++-
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e0c0f0e1f754..f5455bada8cd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -180,6 +180,7 @@ enum kvm_reg {
 	VCPU_EXREG_SEGMENTS,
 	VCPU_EXREG_EXIT_INFO_1,
 	VCPU_EXREG_EXIT_INFO_2,
+	VCPU_EXREG_PKRS,
 };
 
 enum {
@@ -638,6 +639,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr8;
 	u32 host_pkru;
 	u32 pkru;
+	u32 pkrs;
 	u32 hflags;
 	u64 efer;
 	u64 apic_base;
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 3febc342360c..2b2540ca584f 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -177,6 +177,13 @@ static inline u64 kvm_read_edx_eax(struct kvm_vcpu *vcpu)
 		| ((u64)(kvm_rdx_read(vcpu) & -1u) << 32);
 }
 
+static inline u32 kvm_read_pkrs(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_register_is_available(vcpu, VCPU_EXREG_PKRS))
+		static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_PKRS);
+	return vcpu->arch.pkrs;
+}
+
 static inline void enter_guest_mode(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hflags |= HF_GUEST_MASK;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 04d170c4b61e..395b2deb76aa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2258,6 +2258,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
 	unsigned long guest_owned_bits;
+	u64 ia32_pkrs;
 
 	kvm_register_mark_available(vcpu, reg);
 
@@ -2292,6 +2293,16 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 		vcpu->arch.cr4 &= ~guest_owned_bits;
 		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
 		break;
+	case VCPU_EXREG_PKRS:
+		/*
+		 * The high 32 bits of PKRS are reserved and attempting to write
+		 * non-zero value will cause #GP. KVM intentionally drops those
+		 * bits.
+		 */
+		ia32_pkrs = vmcs_read64(GUEST_IA32_PKRS);
+		WARN_ON_ONCE(ia32_pkrs >> 32);
+		vcpu->arch.pkrs = ia32_pkrs;
+		break;
 	default:
 		KVM_BUG_ON(1, vcpu->kvm);
 		break;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9c6bfcd84008..661df9584b12 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -499,7 +499,8 @@ BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
 				(1 << VCPU_EXREG_CR3) |         \
 				(1 << VCPU_EXREG_CR4) |         \
 				(1 << VCPU_EXREG_EXIT_INFO_1) | \
-				(1 << VCPU_EXREG_EXIT_INFO_2))
+				(1 << VCPU_EXREG_EXIT_INFO_2) | \
+				(1 << VCPU_EXREG_PKRS))
 
 static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
 {
-- 
2.25.1

