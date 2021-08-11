Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B8C3E8E0D
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 12:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbhHKKHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 06:07:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:49605 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236898AbhHKKHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 06:07:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="215083920"
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="215083920"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 03:07:15 -0700
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="484785704"
Received: from chenyi-pc.sh.intel.com ([10.239.159.88])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 03:07:12 -0700
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
Subject: [PATCH v5 2/7] KVM: VMX: Add proper cache tracking for PKRS
Date:   Wed, 11 Aug 2021 18:11:21 +0800
Message-Id: <20210811101126.8973-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210811101126.8973-1-chenyi.qiang@intel.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
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
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/kvm_cache_regs.h   | 7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 4 ++++
 arch/x86/kvm/vmx/vmx.h          | 3 ++-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..c2bcb88781b3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -173,6 +173,7 @@ enum kvm_reg {
 	VCPU_EXREG_SEGMENTS,
 	VCPU_EXREG_EXIT_INFO_1,
 	VCPU_EXREG_EXIT_INFO_2,
+	VCPU_EXREG_PKRS,
 };
 
 enum {
@@ -620,6 +621,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr8;
 	u32 host_pkru;
 	u32 pkru;
+	u32 pkrs;
 	u32 hflags;
 	u64 efer;
 	u64 apic_base;
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 90e1ffdc05b7..da014b1be874 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -171,6 +171,13 @@ static inline u64 kvm_read_edx_eax(struct kvm_vcpu *vcpu)
 		| ((u64)(kvm_rdx_read(vcpu) & -1u) << 32);
 }
 
+static inline ulong kvm_read_pkrs(struct kvm_vcpu *vcpu)
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
index 927a552393b9..bf911029aa35 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2273,6 +2273,10 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 		vcpu->arch.cr4 &= ~guest_owned_bits;
 		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
 		break;
+	case VCPU_EXREG_PKRS:
+		if (kvm_cpu_cap_has(X86_FEATURE_PKS))
+			vcpu->arch.pkrs = vmcs_read64(GUEST_IA32_PKRS);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index db88ed4f2121..18039eb6efb0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -447,7 +447,8 @@ static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 				  | (1 << VCPU_EXREG_CR3)
 				  | (1 << VCPU_EXREG_CR4)
 				  | (1 << VCPU_EXREG_EXIT_INFO_1)
-				  | (1 << VCPU_EXREG_EXIT_INFO_2));
+				  | (1 << VCPU_EXREG_EXIT_INFO_2)
+				  | (1 << VCPU_EXREG_PKRS));
 	vcpu->arch.regs_dirty = 0;
 }
 
-- 
2.17.1

