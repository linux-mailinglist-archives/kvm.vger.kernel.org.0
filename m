Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A0448E0E6
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 00:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238228AbiAMXaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 18:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238190AbiAMXa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 18:30:29 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC25C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 15:30:29 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id y15-20020a17090a600f00b001b3501d9e7eso11424629pji.8
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 15:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=56rgy4oAyIu0qQhJLuWwTDz6sSfSd/R7QcLnRVQwjhM=;
        b=lkJLPJWKDbLx4RVpqictGfi0pZJRCPovTyBfIanW9ysxbQhfi7QtWhzoDFyIYhpp3n
         mgdpzUCqAb+1wSZlOK3JeWmyD9qpV9DK8iInCdNX4I4CLOPMTjqtXGlmo3g4uw/uTsod
         Yjc+RYEel6XGpfv2WGhiUXhtgeauFD67whbofrD2fWB2m6yx4h9J0EFP8LPCSQTLefbX
         KwNB2CiXBKYapGSZbKfK2Ly/ocE3rour4E4WMPXzoHqdB1qJTjwpf7UyiYKKQdvdr+12
         ec2ht+uVyEqg1NIfTVNw6B5jyoUSISjm8daakGHbttdmsUp/+ToQD40a1gt4WLohocK5
         P1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=56rgy4oAyIu0qQhJLuWwTDz6sSfSd/R7QcLnRVQwjhM=;
        b=MGp9MpCAfq/DkTZcULtAngF1BTts/0oxbYDB0tcfbCmCs5lSm/8vIsvs2OI0nJU7wp
         xKma7hfYWU2bfIa3jhKYGdgL/tJPQHVBq6G0nS1MdD1M25coIjYxpDouWJLt/b7wbcwt
         Bb6yHJOs6tWiO6B15ipW+Ocf8TIgkPBkr0vySWAU6FzSEtOJbDG5Fo8ryWj9ROZga8Q6
         UyXOssRGz3tVACPTrmZqf3N6bdPg5C1vxmM+xhzbMnZ1+K9+Ax6s3cD1q8SlzzG+Ws4w
         EzhIcNqWgTK6F+0dD3n9dopZ7/prVo8CeSJahSVqrOdBDp33wY7nU8318i+jIXvYMwIY
         M08Q==
X-Gm-Message-State: AOAM5316SVRZGf0fBoPWCFMP/oTOv6evAnpYneHsNt37sUCNiGpzsyqr
        RL3g4bU3ajg1kz/kcwu1Tx5gM1t1G3+Vyg==
X-Google-Smtp-Source: ABdhPJyq9+2wV0pEU7h0g581rjRltoXxzUwvtS/oJRsCX2ioW+Ke5Gc9XzaKibIuRZo0bhovTS3LV7SuPiwLrg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a63:694a:: with SMTP id
 e71mr5901681pgc.37.1642116629233; Thu, 13 Jan 2022 15:30:29 -0800 (PST)
Date:   Thu, 13 Jan 2022 23:30:19 +0000
In-Reply-To: <20220113233020.3986005-1-dmatlack@google.com>
Message-Id: <20220113233020.3986005-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20220113233020.3986005-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 3/4] KVM: x86/mmu: Document and enforce MMU-writable and
 Host-writable invariants
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SPTEs are tagged with software-only bits to indicate if it is
"MMU-writable" and "Host-writable". These bits are used to determine why
KVM has marked an SPTE as read-only.

Document these bits and their invariants, and enforce the invariants
with new WARNs in spte_can_locklessly_be_made_writable() to ensure they
are not accidentally violated in the future.

Opportunistically move DEFAULT_SPTE_{MMU,HOST}_WRITABLE next to
EPT_SPTE_{MMU,HOST}_WRITABLE since the new documentation applies to
both.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/spte.h | 42 +++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a4af2a42695c..be6a007a4af3 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -60,10 +60,6 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 
-/* Bits 9 and 10 are ignored by all non-EPT PTEs. */
-#define DEFAULT_SPTE_HOST_WRITEABLE	BIT_ULL(9)
-#define DEFAULT_SPTE_MMU_WRITEABLE	BIT_ULL(10)
-
 /*
  * The mask/shift to use for saving the original R/X bits when marking the PTE
  * as not-present for access tracking purposes. We do not save the W bit as the
@@ -78,6 +74,35 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 					 SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
 static_assert(!(SPTE_TDP_AD_MASK & SHADOW_ACC_TRACK_SAVED_MASK));
 
+/*
+ * *_SPTE_HOST_WRITEABLE (aka Host-writable) indicates whether the host permits
+ * writes to the guest page mapped by the SPTE. This bit is cleared on SPTEs
+ * that map guest pages in read-only memslots and read-only VMAs.
+ *
+ * Invariants:
+ *  - If Host-writable is clear, PT_WRITABLE_MASK must be clear.
+ *
+ *
+ * *_SPTE_MMU_WRITEABLE (aka MMU-writable) indicates whether the shadow MMU
+ * allows writes to the guest page mapped by the SPTE. This bit is cleared when
+ * the guest page mapped by the SPTE contains a page table that is being
+ * monitored for shadow paging. In this case the SPTE can only be made writable
+ * by unsyncing the shadow page under the mmu_lock.
+ *
+ * Invariants:
+ *  - If MMU-writable is clear, PT_WRITABLE_MASK must be clear.
+ *  - If MMU-writable is set, Host-writable must be set.
+ *
+ * If MMU-writable is set, PT_WRITABLE_MASK is normally set but can be cleared
+ * to track writes for dirty logging. For such SPTEs, KVM will locklessly set
+ * PT_WRITABLE_MASK upon the next write from the guest and record the write in
+ * the dirty log (see fast_page_fault()).
+ */
+
+/* Bits 9 and 10 are ignored by all non-EPT PTEs. */
+#define DEFAULT_SPTE_HOST_WRITEABLE	BIT_ULL(9)
+#define DEFAULT_SPTE_MMU_WRITEABLE	BIT_ULL(10)
+
 /*
  * Low ignored bits are at a premium for EPT, use high ignored bits, taking care
  * to not overlap the A/D type mask or the saved access bits of access-tracked
@@ -316,8 +341,13 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
 
 static inline bool spte_can_locklessly_be_made_writable(u64 spte)
 {
-	return (spte & shadow_host_writable_mask) &&
-	       (spte & shadow_mmu_writable_mask);
+	if (spte & shadow_mmu_writable_mask) {
+		WARN_ON_ONCE(!(spte & shadow_host_writable_mask));
+		return true;
+	}
+
+	WARN_ON_ONCE(spte & PT_WRITABLE_MASK);
+	return false;
 }
 
 static inline u64 get_mmio_spte_generation(u64 spte)
-- 
2.34.1.703.g22d0c6ccf7-goog

