Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5E2325826
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhBYU4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbhBYUww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:52:52 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069A7C0610CB
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:49:02 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v62so7555658ybb.15
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wygaDEDOrN320QX+DWUCOdywurQj1DTKqvUyYvvMFVc=;
        b=XBC/vyeLmlxmeTcNjRlbqndRFXV+OZIx4QATdTRaHc1LavPxAbhNt3VVKMB9y3UVST
         1tpr+Hi90L0/JFgKAzP4XqkVHr8L3PP8fjUn7CUwzfeiS7KYy+QonEMof+4S0Rc8xPj+
         kP7bjvKDGpSZQXG/IUUY+IJzoqcvjUskD/Ye24nnzM9VHLhVVxQ91yd5E5AtcjTHzCdk
         nKNL5qO+xSHMZyLjXkhhNmc8IlsQ3hFFBYBZIll65QqzbADKcYbHTRnw92DgrqQ88DB6
         jO+kb/ADc4XSnonJlCOjR24kcqI/o9XmUcw0bp0z8ZHNHSjnb51y2qS17+zOkNn6RnCr
         z38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wygaDEDOrN320QX+DWUCOdywurQj1DTKqvUyYvvMFVc=;
        b=MHMos+vpQqsm9w+fxuXGFVdnyUaSnfVN9eZdcFuYoLj+X+x5epfViMHH3K2ZUVjS4O
         SwCnFcGWPppUTdY2elnzQ2bfJHBDv+XvrxtNbyr1j+naovbqvkhwqFDu5avr4sQV0yBO
         0uaoBR26oZzcWKjobvmOEwigwSA5b0fci65lceOXqxQs/6vu2RlpvrCxtQtcVcaRnbyq
         TSdj1j2Nksg265a2ov14Vlq5t38Juuedqj797ECRIJrkgU6N0WGW2H+hoJo9MHMM8G/1
         KXcQjskYwTzNOIs2fo0AN9iWTGyWNQ0YRhJTEBO2ZyenSjBPjvKu08yeBkJlHa4pU6re
         pE4Q==
X-Gm-Message-State: AOAM531iaX/uIPlnvKO4FqmSHcvponVWHpY7r5/nsXWoGVt1kWsuuXTA
        37NxlYNRA8w+cKT84yvQenq1nAEz3ns=
X-Google-Smtp-Source: ABdhPJzLHrCi7n/k+RGSDGErQ6Z/2NGtl3jE/sgHMSbkuQMSHmfEfyHVaWh3au5M/Qq0b4enfZio+I+VsQE=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:9108:: with SMTP id v8mr6916513ybl.321.1614286140867;
 Thu, 25 Feb 2021 12:49:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:48 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-24-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 23/24] KVM: x86/mmu: Use low available bits for removed SPTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use low "available" bits to tag REMOVED SPTEs.  Using a high bit is
moderately costly as it often causes the compiler to generate a 64-bit
immediate.  More importantly, this makes it very clear REMOVED_SPTE is
a value, not a flag.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 11 ++++++++++-
 arch/x86/kvm/mmu/spte.h | 11 +++++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index e07aabb23b8a..66d43cec0c31 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -277,7 +277,16 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 				  SHADOW_NONPRESENT_OR_RSVD_MASK_LEN)))
 		mmio_value = 0;
 
-	WARN_ON((mmio_value & mmio_mask) != mmio_value);
+	/*
+	 * The masked MMIO value must obviously match itself and a removed SPTE
+	 * must not get a false positive.  Removed SPTEs and MMIO SPTEs should
+	 * never collide as MMIO must set some RWX bits, and removed SPTEs must
+	 * not set any RWX bits.
+	 */
+	if (WARN_ON((mmio_value & mmio_mask) != mmio_value) ||
+	    WARN_ON(mmio_value && (REMOVED_SPTE & mmio_mask) == mmio_value))
+		mmio_value = 0;
+
 	shadow_mmio_value = mmio_value;
 	shadow_mmio_mask  = mmio_mask;
 	shadow_mmio_access_mask = access_mask;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 2fad4ccd3679..b53036d9ddf3 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -174,13 +174,16 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  * non-present intermediate value. Other threads which encounter this value
  * should not modify the SPTE.
  *
- * This constant works because it is considered non-present on both AMD and
- * Intel CPUs and does not create a L1TF vulnerability because the pfn section
- * is zeroed out.
+ * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
+ * bot AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
+ * vulnerability.  Use only low bits to avoid 64-bit immediates.
  *
  * Only used by the TDP MMU.
  */
-#define REMOVED_SPTE (1ull << 59)
+#define REMOVED_SPTE	0x5a0ULL
+
+/* Removed SPTEs must not be misconstrued as shadow present PTEs. */
+static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
 
 static inline bool is_removed_spte(u64 spte)
 {
-- 
2.30.1.766.gb4fecdf3b7-goog

