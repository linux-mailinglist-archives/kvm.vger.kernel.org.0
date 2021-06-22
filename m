Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3173B0C55
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhFVSGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbhFVSF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:05:29 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C39FC0698DF
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:45 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id 12-20020a05621420ecb02902766cc25115so5310939qvk.1
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ArNWygRGzFaRn0DtOEttycOemqsRGUKy10ZzfwmfjdA=;
        b=NdobaZFo1AJ5qZn1W5xQjilSWnQ10dmUjvDh3pH951/nI8D1BlNW7ygwJWUO+76xXD
         SQRhnLk3abbZKDiNMECc1ejEAKdQil/sgQMbME6jFDP8+xDucxV60AlMxNBy2VQg3J36
         fimDg2n0kzevRKnoaGffvgSQpJeY9liCcoXF5BG8oZ+Rid4XjR92TEK+Ma2veNPDYM5P
         GVcnT/ySE0CbnXEEe5XcqlshcWAOZqZS12nYHtDuD4ngMRwcaBn6o3kH88TSh3Sil3Pj
         oPwuPNWXJyMhabaHvaHtUIQsGStMu3+1d04EkfEVjBw42YFtGXTutPwA+oDAjDeY7hAS
         s6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ArNWygRGzFaRn0DtOEttycOemqsRGUKy10ZzfwmfjdA=;
        b=XwxnSvtsMzzVftwgP41+nrXAXtdBFcrDWA6OraRHkoORqay/y+ZHZ7gStswRGfEoNv
         rfBxvChYRYhKOiFo9rZPYbvG/aX41SUC16nim7jX9F4V5/gIRmRhqaArgMlZsgXI37RX
         Xo0qDU0QkSMfOC1rj+n7jgY0BKVivK2/89xznMRckvV5jrSMN8yzwzYOdcV4aTALtH8x
         D7Qqnw8keNhV9ZsbFawUnoCbyvBI2azlAV7Fd0xc4tU9maOQA6O/Eyb6iZekXm7BvkP6
         O333QZwNwUnQ1iuC6xS+T0vSfJEqPveZ3ajFFR7gPklYq2zO4UmgA9Jgm9sBmEXwjYh9
         rJRg==
X-Gm-Message-State: AOAM531voGz4cmVkhUITwkTOfJ9yStP7k548jp0ef/MvP2Usi12IHtNS
        YPV0zPZTCC8kvv/qFuket7XKsRhQGXg=
X-Google-Smtp-Source: ABdhPJyQBaWws0OZcWOnZgrxIlW0N8oEXQNvB+0eJIWd+vQYclJkJIKiQQC1jX03w/E97vYMieMW4pD8IuE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a0c:e414:: with SMTP id o20mr23096122qvl.23.1624384784294;
 Tue, 22 Jun 2021 10:59:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:32 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-48-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 47/54] KVM: x86/mmu: Add helpers to do full reserved SPTE
 checks w/ generic MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the reserved SPTE check and print helpers in get_mmio_spte() to
new helpers so that KVM can also WARN on reserved badness when making a
SPTE.

Tag the checking helper with __always_inline to improve the probability
of the compiler generating optimal code for the checking loop, e.g. gcc
appears to avoid using %rbp when the helper is tagged with a vanilla
"inline".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 23 ++---------------------
 arch/x86/kvm/mmu/spte.h | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 92260cf48d5e..34e7a489e71b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3594,19 +3594,6 @@ static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gpa_t vaddr,
 	return vcpu->arch.nested_mmu.translate_gpa(vcpu, vaddr, access, exception);
 }
 
-static bool
-__is_rsvd_bits_set(struct rsvd_bits_validate *rsvd_check, u64 pte, int level)
-{
-	int bit7 = (pte >> 7) & 1;
-
-	return pte & rsvd_check->rsvd_bits_mask[bit7][level-1];
-}
-
-static bool __is_bad_mt_xwr(struct rsvd_bits_validate *rsvd_check, u64 pte)
-{
-	return rsvd_check->bad_mt_xwr & BIT_ULL(pte & 0x3f);
-}
-
 static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 {
 	/*
@@ -3684,13 +3671,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
 
 	for (level = root; level >= leaf; level--)
-		/*
-		 * Use a bitwise-OR instead of a logical-OR to aggregate the
-		 * reserved bit and EPT's invalid memtype/XWR checks to avoid
-		 * adding a Jcc in the loop.
-		 */
-		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level]) |
-			    __is_rsvd_bits_set(rsvd_check, sptes[level], level);
+		reserved |= is_rsvd_spte(rsvd_check, sptes[level], level);
 
 	if (reserved) {
 		pr_err("%s: reserved bits set on MMU-present spte, addr 0x%llx, hierarchy:\n",
@@ -3698,7 +3679,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 		for (level = root; level >= leaf; level--)
 			pr_err("------ spte = 0x%llx level = %d, rsvd bits = 0x%llx",
 			       sptes[level], level,
-			       rsvd_check->rsvd_bits_mask[(sptes[level] >> 7) & 1][level-1]);
+			       get_rsvd_bits(rsvd_check, sptes[level], level));
 	}
 
 	return reserved;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index bca0ba11cccf..47e10dd9352d 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -293,6 +293,38 @@ static inline bool is_dirty_spte(u64 spte)
 	return dirty_mask ? spte & dirty_mask : spte & PT_WRITABLE_MASK;
 }
 
+static inline u64 get_rsvd_bits(struct rsvd_bits_validate *rsvd_check, u64 pte,
+				int level)
+{
+	int bit7 = (pte >> 7) & 1;
+
+	return rsvd_check->rsvd_bits_mask[bit7][level-1];
+}
+
+static inline bool __is_rsvd_bits_set(struct rsvd_bits_validate *rsvd_check,
+				      u64 pte, int level)
+{
+	return pte & get_rsvd_bits(rsvd_check, pte, level);
+}
+
+static inline bool __is_bad_mt_xwr(struct rsvd_bits_validate *rsvd_check,
+				   u64 pte)
+{
+	return rsvd_check->bad_mt_xwr & BIT_ULL(pte & 0x3f);
+}
+
+static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
+					 u64 spte, int level)
+{
+	/*
+	 * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
+	 * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
+	 * (this is used in hot paths).
+	 */
+	return __is_bad_mt_xwr(rsvd_check, spte) |
+	       __is_rsvd_bits_set(rsvd_check, spte, level);
+}
+
 static inline bool spte_can_locklessly_be_made_writable(u64 spte)
 {
 	return (spte & shadow_host_writable_mask) &&
-- 
2.32.0.288.g62a8d224e6-goog

