Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E89B4D5BF0
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 08:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347026AbiCKHEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 02:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347017AbiCKHEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 02:04:40 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AAD8CD99;
        Thu, 10 Mar 2022 23:03:35 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id b8so7390763pjb.4;
        Thu, 10 Mar 2022 23:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1SspowByuYtxnkXztepy/bbI50kGwBeecLIqB1iWiGQ=;
        b=WBQEJdUxZXhBNRNf9qSemWXKaqhsC2DiqY9cac7cZOvRGEaxLBD1taZBW6GfqMuu6q
         00Ph991jsOaEma0cfegVYsLbaSPlXCvKz/qQ9CqJrm3Fmli0kY7DOQ1iro7/hINLGjI8
         fsUZSEvgon70R9pMW+mnTJRjzQ/mdkrolSsU0mr3mvUQYxPXwuN7bWVLp4ltZiK8/XYY
         mciFN8wIVNAKZcMKOioSf7z33I5gAfUnudGnPNAj6Xm63C4wVb5n0bMDm3cB0Msf+k5u
         /xOHcCDxxQ1GNdZhj1HhWW1e5ihlhHbil4+URB4sNjajj6Wc4CtnwwKDwKBjk5zxOg/9
         UERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1SspowByuYtxnkXztepy/bbI50kGwBeecLIqB1iWiGQ=;
        b=6dSuzYSMXONXMpVynZwRpvzuH8Nd8zpw694f5TpVIUB6BQUaWJO9KNvhM52kMWyP3E
         gGDEDtZfqIrzuQCR9OzIOvKx25kUwN/Zgk8+Ztk/TQ1CtqRFIZfLlkfVazZJ7PBcS6UV
         x0tjhE85Fkuc1pHxh4UNCVX4yQw01i+/LcyEqaYzddJcMfaLyPLJ5nCSbjFEtjMLhqBz
         kgvPUpIE7tY/X3O9zUrZwEy5fTGnhldsuC4C5Ri6LtolC6AvIAeKS4xz1ZKEsY8UijKz
         GboewerTFvJjJSG477QXeDH6yQw5+n1eH20NkUfEFS3tZEd4f4LZdWB6/uNLxRK5e3kg
         WEbw==
X-Gm-Message-State: AOAM532h/JD6G59BSGX4jjwPxaOsIkrO3QygS+QpmpRUVivRLY0fkpT+
        jZ3VsGT+rJViObrMsTjIFnoqY5QaDhE=
X-Google-Smtp-Source: ABdhPJyDQBwD2oHMqAG7OLbwJK3eatIkHjLg+PHJUgBni5RdQLHyiQQk9yuFSLOE4n4X6ABYXqpl4g==
X-Received: by 2002:a17:902:eb84:b0:151:c730:c9a3 with SMTP id q4-20020a170902eb8400b00151c730c9a3mr9020651plg.144.1646982215222;
        Thu, 10 Mar 2022 23:03:35 -0800 (PST)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id k21-20020a056a00169500b004f65bbfca3asm9515531pfc.57.2022.03.10.23.03.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Mar 2022 23:03:35 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH V2 4/5] KVM: X86: Handle implicit supervisor access with SMAP
Date:   Fri, 11 Mar 2022 15:03:44 +0800
Message-Id: <20220311070346.45023-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220311070346.45023-1-jiangshanlai@gmail.com>
References: <20220311070346.45023-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

There are two kinds of implicit supervisor access
	implicit supervisor access when CPL = 3
	implicit supervisor access when CPL < 3

Current permission_fault() handles only the first kind for SMAP.

But if the access is implicit when SMAP is on, data may not be read
nor write from any user-mode address regardless the current CPL.

So the second kind should be also supported.

The first kind can be detect via CPL and access mode: if it is
supervisor access and CPL = 3, it must be implicit supervisor access.

But it is not possible to detect the second kind without extra
information, so this patch adds an artificial PFERR_EXPLICIT_ACCESS
into @access. This extra information also works for the first kind, so
the logic is changed to use this information for both cases.

The value of PFERR_EXPLICIT_ACCESS is deliberately chosen to be bit 48
which is in the most significant 16 bits of u64 and less likely to be
forced to change due to future hardware uses it.

This patch removes the call to ->get_cpl() for access mode is determined
by @access.  Not only does it reduce a function call, but also remove
confusions when the permission is checked for nested TDP.  The nested
TDP shouldn't have SMAP checking nor even the L2's CPL have any bearing
on it.  The original code works just because it is always user walk for
NPT and SMAP fault is not set for EPT in update_permission_bitmask.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.h              | 24 +++++++++++-------------
 arch/x86/kvm/mmu/mmu.c          |  4 ++--
 arch/x86/kvm/x86.c              |  8 ++++++--
 4 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index edffcf7f9c2d..565d9eb42429 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -248,6 +248,7 @@ enum x86_intercept_stage;
 #define PFERR_SGX_BIT 15
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
+#define PFERR_IMPLICIT_ACCESS_BIT 48
 
 #define PFERR_PRESENT_MASK (1U << PFERR_PRESENT_BIT)
 #define PFERR_WRITE_MASK (1U << PFERR_WRITE_BIT)
@@ -258,6 +259,7 @@ enum x86_intercept_stage;
 #define PFERR_SGX_MASK (1U << PFERR_SGX_BIT)
 #define PFERR_GUEST_FINAL_MASK (1ULL << PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK (1ULL << PFERR_GUEST_PAGE_BIT)
+#define PFERR_IMPLICIT_ACCESS (1ULL << PFERR_IMPLICIT_ACCESS_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 24d94f6d378d..4cb7a39ecd51 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -218,25 +218,23 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 {
 	/* strip nested paging fault error codes */
 	unsigned int pfec = access;
-	int cpl = static_call(kvm_x86_get_cpl)(vcpu);
 	unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
 
 	/*
-	 * If CPL < 3, SMAP prevention are disabled if EFLAGS.AC = 1.
+	 * For explicit supervisor accesses, SMAP is disabled if EFLAGS.AC = 1.
+	 * For implicit supervisor accesses, SMAP cannot be overridden.
 	 *
-	 * If CPL = 3, SMAP applies to all supervisor-mode data accesses
-	 * (these are implicit supervisor accesses) regardless of the value
-	 * of EFLAGS.AC.
+	 * SMAP works on supervisor accesses only, and not_smap can
+	 * be set or not set when user access with neither has any bearing
+	 * on the result.
 	 *
-	 * This computes (cpl < 3) && (rflags & X86_EFLAGS_AC), leaving
-	 * the result in X86_EFLAGS_AC. We then insert it in place of
-	 * the PFERR_RSVD_MASK bit; this bit will always be zero in pfec,
-	 * but it will be one in index if SMAP checks are being overridden.
-	 * It is important to keep this branchless.
+	 * We put the SMAP checking bit in place of the PFERR_RSVD_MASK bit;
+	 * this bit will always be zero in pfec, but it will be one in index
+	 * if SMAP checks are being disabled.
 	 */
-	unsigned long not_smap = (cpl - 3) & (rflags & X86_EFLAGS_AC);
-	int index = (pfec >> 1) +
-		    (not_smap >> (X86_EFLAGS_AC_BIT - PFERR_RSVD_BIT + 1));
+	bool explicit_access = !(access & PFERR_IMPLICIT_ACCESS);
+	bool not_smap = (rflags & X86_EFLAGS_AC) && explicit_access;
+	int index = (pfec + (!!not_smap << PFERR_RSVD_BIT)) >> 1;
 	bool fault = (mmu->permissions[index] >> pte_access) & 1;
 	u32 errcode = PFERR_PRESENT_MASK;
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 781f90480d00..9b593e67717a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4580,8 +4580,8 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
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
index c85e48dc8310..df8b05740080 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6844,7 +6844,9 @@ static int emulator_read_std(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u64 access = 0;
 
-	if (!system && static_call(kvm_x86_get_cpl)(vcpu) == 3)
+	if (system)
+		access |= PFERR_IMPLICIT_ACCESS;
+	else if (static_call(kvm_x86_get_cpl)(vcpu) == 3)
 		access |= PFERR_USER_MASK;
 
 	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access, exception);
@@ -6896,7 +6898,9 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u64 access = PFERR_WRITE_MASK;
 
-	if (!system && static_call(kvm_x86_get_cpl)(vcpu) == 3)
+	if (system)
+		access |= PFERR_IMPLICIT_ACCESS;
+	else if (static_call(kvm_x86_get_cpl)(vcpu) == 3)
 		access |= PFERR_USER_MASK;
 
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
-- 
2.19.1.6.gb485710b

