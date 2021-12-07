Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CFF46B7FB
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbhLGJyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbhLGJyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 04:54:17 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EDCC061354;
        Tue,  7 Dec 2021 01:50:47 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso2200065pjb.2;
        Tue, 07 Dec 2021 01:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u4aqMNfwbrt7pFsqLga8iRdVxLeYWn7LNc1NBMlcDAk=;
        b=BhJaYpMdO6/IorZDH62KcUKy4y9lW4CN1O71yvCQokmpA7zIpA/YvNzoW6rssvXWNM
         furnCaAJHELljnqYyEHuxqys8cs7G1rTIy5wl1YUrtCQPih/3UWNKhDjE+n6zxYe78pU
         wLsg7oDuYACiieO2DvWNTyz1gkwh5KIlyaQH5nJvNorg1dRBVlxIn/ptKbLo0r3dJaKs
         0lgmSlvMRsT9VAC7CJR2zPZwJlgOiiSCYGEsSKH5Htm5IocT5yFfNRhF0tKyLTJvBUxf
         ckQ/0MPMizqz+K2hZPrZWPirCc+C+/7kaeVTuR8beQXh/e1nDYllCrdD4txcEekGvuwK
         V+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u4aqMNfwbrt7pFsqLga8iRdVxLeYWn7LNc1NBMlcDAk=;
        b=TbEX3+wm86XOdrYssroKh3i5EeQILg/5e1AZlMoTy6MrTRStjxeI9Wro8fJgSxw6W3
         0PShch0td15zK5DATaLCZW7wjWt2+PZfC29UC1seUd58BsrzxgRdo97vJ8YCub/Lk611
         C6dsul4xnk7JBru2NmfFbpR0+FdOLwKHF9h6sGlhlChIANtCY0JvoYHn/FSR4I/hkC8T
         nQ3+LSTme6XbOoSqOzqijv9JjLhoVAZBbsAaWAetWbS503i4PQf0c9Lo7LwmquXzfkEc
         J5IfAfTakEb8DoGzWMebaDHcPHQDfnZWmo8az9cmd6i2MFc2FizqBp1LuUTnZndi+Jr1
         24IA==
X-Gm-Message-State: AOAM531K9ulHCRn0caUwDnRxfwam4DqBBOXDNgDCVTSYrRc+noVRUyme
        P1iFBUr+9ApvqmhLNwdAIhDxuXjQ5v4=
X-Google-Smtp-Source: ABdhPJwTGe+y8gC/YA9fAkbDm91Jg3N2uW9OPmW8H9beoYdUzlzJY8VpoAcTCWguOQwqYU0HFGrRBQ==
X-Received: by 2002:a17:902:d490:b0:141:fd0f:5316 with SMTP id c16-20020a170902d49000b00141fd0f5316mr50049735plg.14.1638870646371;
        Tue, 07 Dec 2021 01:50:46 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id w19sm2121573pjh.10.2021.12.07.01.50.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Dec 2021 01:50:46 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/4] KVM: X86: Handle implicit supervisor access with SMAP
Date:   Tue,  7 Dec 2021 17:50:38 +0800
Message-Id: <20211207095039.53166-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211207095039.53166-1-jiangshanlai@gmail.com>
References: <20211207095039.53166-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

There are two kinds of implicit supervisor access
	implicit supervisor access when CPL = 3
	implicit supervisor access when CPL < 3

Current permission_fault() handles only the first kind for SMAP.

But if the access is implicit when SMAP is on, data may not be read
nor write from any user-mode address regardless the current CPL.

So the second find should be also supported.

The first kind can be detect via CPL and access mode: if it is
supervisor access and CPL = 3, it must be implicit supervisor access.

But it is not possible to detect the second kind without extra
information, so this patch adds vcpu->arch.explicit_access for it.  And
it is always set to KVM_EXPLICIT_ACCESS unless the vcpu is doing
implicit supervisor access.  This extra information also works for
the first kind, so the logic is changed to use this information
for both cases.

The value of KVM_EXPLICIT_ACCESS is deliberately chosen to include
all bits so that the calculation in permission_fault() can be
simplified.

This patch removes the call to ->get_cpl() for it integrates both
implicit supervisor access kinds into one logic.  Not only does it
reduce a function call, but also remove confusions when the permission
is checked for nested TDP.  The nested TDP shouldn't have SMAP
checking nor even the L2's CPL have any bearing on it.  The original
code works just because it is always user walk for NPT and SMAP fault
is not set for EPT in update_permission_bitmask.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h |  9 +++++++++
 arch/x86/kvm/mmu.h              | 17 ++++++++++-------
 arch/x86/kvm/mmu/mmu.c          |  4 ++--
 arch/x86/kvm/x86.c              | 20 +++++++++++++++++---
 4 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e41ad1ead721..88ecf53f0d2b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -261,6 +261,14 @@ enum x86_intercept_stage;
 				 PFERR_WRITE_MASK |		\
 				 PFERR_PRESENT_MASK)
 
+
+/*
+ * KVM_EXPLICIT_ACCESS is set to contain all bits so that the calculation
+ * in permission_fault() can be simplified and branchless.
+ */
+#define KVM_EXPLICIT_ACCESS	((u32)~0)
+#define KVM_IMPLICIT_ACCESS	((u32)0)
+
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
 /*
@@ -630,6 +638,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr8;
 	u32 host_pkru;
 	u32 pkru;
+	u32 explicit_access;
 	u32 hflags;
 	u64 efer;
 	u64 apic_base;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index b70b36734bc0..0cb2c52377c8 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -252,23 +252,26 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 				  unsigned pte_access, unsigned pte_pkey,
 				  unsigned pfec)
 {
-	int cpl = static_call(kvm_x86_get_cpl)(vcpu);
 	unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
 
 	/*
-	 * If CPL < 3, SMAP prevention are disabled if EFLAGS.AC = 1.
+	 * If explicit supervisor accesses, SMAP is disabled
+	 * if EFLAGS.AC = 1.
 	 *
-	 * If CPL = 3, SMAP applies to all supervisor-mode data accesses
-	 * (these are implicit supervisor accesses) regardless of the value
-	 * of EFLAGS.AC.
+	 * If implicit supervisor accesses, SMAP can not be disabled
+	 * regardless of the value EFLAGS.AC.
 	 *
-	 * This computes (cpl < 3) && (rflags & X86_EFLAGS_AC), leaving
+	 * SMAP works on supervisor accesses only, and not_smap can
+	 * be set or not set when user access with neither has any bearing
+	 * on the result.
+	 *
+	 * This computes explicit_access && (rflags & X86_EFLAGS_AC), leaving
 	 * the result in X86_EFLAGS_AC. We then insert it in place of
 	 * the PFERR_RSVD_MASK bit; this bit will always be zero in pfec,
 	 * but it will be one in index if SMAP checks are being overridden.
 	 * It is important to keep this branchless.
 	 */
-	unsigned long not_smap = (cpl - 3) & (rflags & X86_EFLAGS_AC);
+	u32 not_smap = (rflags & X86_EFLAGS_AC) & vcpu->arch.explicit_access;
 	int index = (pfec >> 1) +
 		    (not_smap >> (X86_EFLAGS_AC_BIT - PFERR_RSVD_BIT + 1));
 	bool fault = (mmu->permissions[index] >> pte_access) & 1;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9d045395fe8d..11b06d536cc9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4547,8 +4547,8 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 			 *   - X86_CR4_SMAP is set in CR4
 			 *   - A user page is accessed
 			 *   - The access is not a fetch
-			 *   - Page fault in kernel mode
-			 *   - if CPL = 3 or X86_EFLAGS_AC is clear
+			 *   - The access is supervisor mode
+			 *   - If implicit supervisor access or X86_EFLAGS_AC is clear
 			 *
 			 * Here, we cover the first four conditions.
 			 * The fifth is computed dynamically in permission_fault();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 78c40ac3b197..a972e3ab98ec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6651,11 +6651,17 @@ static int emulator_read_std(struct x86_emulate_ctxt *ctxt,
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u32 access = 0;
+	int ret;
 
 	if (!system && static_call(kvm_x86_get_cpl)(vcpu) == 3)
 		access |= PFERR_USER_MASK;
 
-	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access, exception);
+	if (system)
+		vcpu->arch.explicit_access = KVM_IMPLICIT_ACCESS;
+	ret = kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access, exception);
+	if (system)
+		vcpu->arch.explicit_access = KVM_EXPLICIT_ACCESS;
+	return ret;
 }
 
 static int kvm_read_guest_phys_system(struct x86_emulate_ctxt *ctxt,
@@ -6703,12 +6709,18 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u32 access = PFERR_WRITE_MASK;
+	int ret;
 
 	if (!system && static_call(kvm_x86_get_cpl)(vcpu) == 3)
 		access |= PFERR_USER_MASK;
 
-	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
-					   access, exception);
+	if (system)
+		vcpu->arch.explicit_access = KVM_IMPLICIT_ACCESS;
+	ret = kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
+					  access, exception);
+	if (system)
+		vcpu->arch.explicit_access = KVM_EXPLICIT_ACCESS;
+	return ret;
 }
 
 int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
@@ -11104,6 +11116,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
 
+	vcpu->arch.explicit_access = KVM_EXPLICIT_ACCESS;
+
 	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
 		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
 
-- 
2.19.1.6.gb485710b

