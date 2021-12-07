Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97B546B7FE
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhLGJy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbhLGJyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 04:54:22 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071ECC061746;
        Tue,  7 Dec 2021 01:50:53 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id l64so7786453pgl.9;
        Tue, 07 Dec 2021 01:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GZRKGaTJvMIzEv9DQcbslSDicSpOvX38eEtsoJzfErQ=;
        b=iDh2+XPyuK2xrEEHZtPUNQBUAbdVLju266NlMPeknZrsH1qbHgrctKcUKe+nJ6hMAj
         d9qaADtUK39Go7LaQmdaTuybxVHUG4FzXXJxJA8JKtfdCYMxjGdoeBZmNYogqvMseIZu
         b7r/wBufyFJvYMLeidBNNJoTzcjRkFhX9R7NiDjEYnMQYn/lQIEuPKtMISs6+N+57qaY
         t/0hzWukgD6jgtykFTa5xbZGVBNjSnshKHpfYfTExBhDAkAwtLYMCNt5zSPwWtN0wfMS
         fMyj1I/weevce5bHF0nT7oSfH3qTb9SfiSxBAP05Cqc6pYMGFNEZdTbgqG6wHg6L0Cd2
         Z/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GZRKGaTJvMIzEv9DQcbslSDicSpOvX38eEtsoJzfErQ=;
        b=zTPrCJ81DNEUE9jBiEB5RP0nGd4GHKnNsRC04OnkYQ4dDgDCtCiv+hAvzFEGcP5/xh
         J0Nb7Mn9CsE0Ns/OdQgeR0hvxrvgcRnDHnHGVUinHMYmENo8+r78weQOpKHf0b2ysV0x
         7mONpXNdgMWZhPeB3dm9KIwji/lTO6ZSv4eeLmecyHme5bw78NZRQ/3NSqeZSYwbNwKN
         WPo4xyRtwsNt1cGArCr1ZlGMGQRC7YJ0Q6SSpTwAn6N30utvhJzro8lVt999QkhVxCAw
         oqP5sMy8yAh41by2A12R5mJefHoCJpOJYtCeTuHlWjxt/rRToXjQr5hCTDlL+fMWEc9e
         Rmqw==
X-Gm-Message-State: AOAM531Tt5AAu/44AdZSB6UW8SgVesm+ipzj2dFZVlVzsTeGJFsE5JiV
        H/OK3QHadmu2p5B0p8PYKqRZMurG2lY=
X-Google-Smtp-Source: ABdhPJze1xptf5mZZnIqsLsgnH5uETbSNKc250unRg96oaB6vfs1Bt+Gcvjb+euCqwYHva4x441aEA==
X-Received: by 2002:a62:be14:0:b0:4ae:d99e:8c70 with SMTP id l20-20020a62be14000000b004aed99e8c70mr9438245pff.45.1638870652391;
        Tue, 07 Dec 2021 01:50:52 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id v25sm15428859pfg.175.2021.12.07.01.50.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Dec 2021 01:50:52 -0800 (PST)
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
Subject: [PATCH 4/4] KVM: X86: Only get rflags when needed in permission_fault()
Date:   Tue,  7 Dec 2021 17:50:39 +0800
Message-Id: <20211207095039.53166-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211207095039.53166-1-jiangshanlai@gmail.com>
References: <20211207095039.53166-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

In same cases, it doesn't need to get rflags for SMAP checks.

For example: it is user mode access, it could have contained other
permission fault, SMAP is not enabled, it is implicit supervisor
access, or it is nested TDP pagetable.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu.h | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 0cb2c52377c8..70ab6e392f18 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -252,8 +252,6 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 				  unsigned pte_access, unsigned pte_pkey,
 				  unsigned pfec)
 {
-	unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
-
 	/*
 	 * If explicit supervisor accesses, SMAP is disabled
 	 * if EFLAGS.AC = 1.
@@ -261,22 +259,34 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	 * If implicit supervisor accesses, SMAP can not be disabled
 	 * regardless of the value EFLAGS.AC.
 	 *
-	 * SMAP works on supervisor accesses only, and not_smap can
+	 * SMAP works on supervisor accesses only, and SMAP checking bit can
 	 * be set or not set when user access with neither has any bearing
 	 * on the result.
 	 *
-	 * This computes explicit_access && (rflags & X86_EFLAGS_AC), leaving
-	 * the result in X86_EFLAGS_AC. We then insert it in place of
-	 * the PFERR_RSVD_MASK bit; this bit will always be zero in pfec,
-	 * but it will be one in index if SMAP checks are being overridden.
-	 * It is important to keep this branchless.
+	 * We put the SMAP checking bit in place of the PFERR_RSVD_MASK bit;
+	 * this bit will always be zero in pfec, but it will be one in index
+	 * if SMAP checks are being disabled.
 	 */
-	u32 not_smap = (rflags & X86_EFLAGS_AC) & vcpu->arch.explicit_access;
-	int index = (pfec >> 1) +
-		    (not_smap >> (X86_EFLAGS_AC_BIT - PFERR_RSVD_BIT + 1));
-	bool fault = (mmu->permissions[index] >> pte_access) & 1;
+	u32 fault = (mmu->permissions[pfec >> 1] >> pte_access) & 1;
+	int index = (pfec + PFERR_RSVD_MASK) >> 1;
+	u32 fault_not_smap = (mmu->permissions[index] >> pte_access) & 1;
 	u32 errcode = PFERR_PRESENT_MASK;
 
+	/*
+	 * fault	fault_not_smap
+	 * 0		0		not fault here
+	 * 0		1		impossible combination
+	 * 1		0		check if implicit access or EFLAGS.AC
+	 * 1		1		fault with non-SMAP permission fault
+	 *
+	 * It is common fault == fault_not_smap, and they are always
+	 * equivalent when SMAP is not enabled.
+	 */
+	if (unlikely(fault & ~fault_not_smap & vcpu->arch.explicit_access)) {
+		unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
+		fault = (rflags ^ X86_EFLAGS_AC) >> X86_EFLAGS_AC_BIT;
+	}
+
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkru_mask)) {
 		u32 pkru_bits, offset;
-- 
2.19.1.6.gb485710b

