Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F316A4BD845
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 09:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346831AbiBUIGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 03:06:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346815AbiBUIGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 03:06:20 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F20C21B;
        Mon, 21 Feb 2022 00:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645430758; x=1676966758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=bQS4lZ96m57YbacKYWmxwktghmoyo+/heYviDldSwgE=;
  b=D5uZm4iYWKG658D314cU5nML/r6AIeCBUkuF77f7/naYQuXWfVrclWoG
   dFL7i8/OCefhkxPkThtpICElaPVRQ2caEYOA0O56g0ynjPpnWMLHkIgp6
   E2q6++4Ld4c8onI+SWr/MXaf8eo5vd46/uPtFNqLeqN34R2h2f2UP/k7L
   s5knPYiNaHldn3ouFRlh85W7r940u99DJ9GgchyT04o4XkWPMzEB0dErO
   5Tq/f2TCSFHpLJrFYUufkV4XedVHqOT7YAOHrZuyye8cfO6EBTbSTej8c
   m3glDV2bTyEf1iDmDT8YUfwHn2HhgkyLN2hIEfpjQssSGMJ5yXQVWS91N
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="250277855"
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="250277855"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 00:05:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="638472260"
Received: from unknown (HELO chenyi-pc.sh.intel.com) ([10.239.159.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 00:05:41 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/7] KVM: VMX: Add proper cache tracking for PKRS
Date:   Mon, 21 Feb 2022 16:08:35 +0800
Message-Id: <20220221080840.7369-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220221080840.7369-1-chenyi.qiang@intel.com>
References: <20220221080840.7369-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add PKRS caching into the standard register caching mechanism in order
to take advantage of the availability checks provided by regs_avail.

This is because vcpu->arch.pkrs will be rarely acceesed by KVM, only in
the case of host userspace MSR reads and GVA->GPA translation in
following patches. It is unnecessary to keep it up-to-date at all times.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/kvm_cache_regs.h   |  7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.h          |  3 ++-
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1384517d7709..75940aeb5f67 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -177,6 +177,7 @@ enum kvm_reg {
 	VCPU_EXREG_SEGMENTS,
 	VCPU_EXREG_EXIT_INFO_1,
 	VCPU_EXREG_EXIT_INFO_2,
+	VCPU_EXREG_PKRS,
 };
 
 enum {
@@ -632,6 +633,7 @@ struct kvm_vcpu_arch {
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
index 4ac676066d60..0496afe786fa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2269,6 +2269,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
 	unsigned long guest_owned_bits;
+	u64 ia32_pkrs;
 
 	kvm_register_mark_available(vcpu, reg);
 
@@ -2303,6 +2304,16 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
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
index 7f2c82e7f38f..da5e95a6694c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -500,7 +500,8 @@ BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
 				(1 << VCPU_EXREG_CR3) |         \
 				(1 << VCPU_EXREG_CR4) |         \
 				(1 << VCPU_EXREG_EXIT_INFO_1) | \
-				(1 << VCPU_EXREG_EXIT_INFO_2))
+				(1 << VCPU_EXREG_EXIT_INFO_2) | \
+				(1 << VCPU_EXREG_PKRS))
 
 static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
 {
-- 
2.17.1

