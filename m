Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1B2325832
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 22:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbhBYU4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbhBYUwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:52:22 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409CDC061A29
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:50 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id h126so5479540qkd.4
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VQspKyDp0Y0bfUsoSaP1PhHsDNHINEZk5uD+rHqlY2E=;
        b=IZBYHYQfGJBK9xJr7u9zaCocq6/mmkfADPR6KYiGkiyLFM8Jw/0INEI+nrHiJUagYF
         ugGIWXM0e+i3iqj1v94hAFZAATedTdn2piEMBZNy4kTJ2Kp/pSq3sG4hRmRKiP1P9/jb
         zuE9S3tnHG/zbtLsFtSWD0Ev0T1K1KGuU9XQs/eDKvUK+lO1BJdcnt1xKdqSfCrLR+jD
         I8r+YhcrasZSP4Ut07O6zMRKl/fNySb98ghcR5H8A5Q2WYhZFBGAaKiOklfwVybR8Beq
         z8WrACwELHujWK+dk9NKuSc6o0PhxtlBYClB1lOcXwJlVKw9y8icv3vTHKaCti0COKr2
         h0nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VQspKyDp0Y0bfUsoSaP1PhHsDNHINEZk5uD+rHqlY2E=;
        b=R4/Zp0YOVLj8k4IYB3ZOM3XtGimLa2sKi7jQW/QqxkSCia3W8c6ptZZp4Oz6DBZIEv
         iyC+jQTUG96YWz/izS0FlqR3D2qtwbGs1KhABXXf8Fl/cKtyyVixwpDBZ8L+GgtzSTyy
         Hc96TIKu5eP8suLFRmi1uKb49RJAsmJTh6weNZ0r9uox6HyMuOnNV+HtVbGefexRu+uA
         CkZixzeSo2Pi8yXJjIThJsdNjL7Exb7OY+bMO2a1oksoe+8fUWHdSwjdXPqNhWyHzApp
         g1H+gc/tV5fqT1Ug+df3DG8LJkVEOHAWKJ6SXCzOvn1RRCBX4NVwDueDUkpg2WhTfHpp
         qFBw==
X-Gm-Message-State: AOAM530hJWSO/Zt5H/Eap2sfHwpeL7Y8/XWYnuuLv+v/00GARx3GuWW6
        FcSEfEBkdz3/+SAB+lUp2lbPGpf138w=
X-Google-Smtp-Source: ABdhPJxSykM6u5auDhmdjhlL+DY0Hl39os4RzwegNpJDrCglpAo/ecE+BK1bC/4gTQO7OZf243wn16zjsEk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a05:6214:bce:: with SMTP id
 ff14mr4625737qvb.26.1614286129441; Thu, 25 Feb 2021 12:48:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:44 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-20-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 19/24] KVM: x86/mmu: Use high bits for host/mmu writable masks
 for EPT SPTEs
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

Use bits 57 and 58 for HOST_WRITABLE and MMU_WRITABLE when using EPT.
This will allow using bit 11 as a constant MMU_PRESENT, which is
desirable as checking for a shadow-present SPTE is one of the most
common SPTE operations in KVM, particular in hot paths such as page
faults.

EPT is short on low available bits; currently only bit 11 is the only
always-available bit.  Bit 10 is also available, but only while KVM
doesn't support mode-based execution.  On the other hand, PAE paging
doesn't have _any_ high available bits.  Thus, using bit 11 is the only
feasible option for MMU_PRESENT.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c |  3 +++
 arch/x86/kvm/mmu/spte.h | 48 ++++++++++++++++++++++++++++-------------
 2 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 2329ba60c67a..d12acf5eb871 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -295,6 +295,9 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
 	shadow_me_mask		= 0ull;
 
+	shadow_host_writable_mask = EPT_SPTE_HOST_WRITABLE;
+	shadow_mmu_writable_mask  = EPT_SPTE_MMU_WRITABLE;
+
 	/*
 	 * EPT Misconfigurations are generated if the value of bits 2:0
 	 * of an EPT paging-structure entry is 110b (write/execute).
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 287540d211a9..8996baa8da15 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -57,8 +57,39 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 
-#define DEFAULT_SPTE_HOST_WRITEABLE	BIT_ULL(10)
-#define DEFAULT_SPTE_MMU_WRITEABLE	BIT_ULL(11)
+/* Bits 9 and 10 are ignored by all non-EPT PTEs. */
+#define DEFAULT_SPTE_HOST_WRITEABLE	BIT_ULL(9)
+#define DEFAULT_SPTE_MMU_WRITEABLE	BIT_ULL(10)
+
+/*
+ * The mask/shift to use for saving the original R/X bits when marking the PTE
+ * as not-present for access tracking purposes. We do not save the W bit as the
+ * PTEs being access tracked also need to be dirty tracked, so the W bit will be
+ * restored only when a write is attempted to the page.  This mask obviously
+ * must not overlap the A/D type mask.
+ */
+#define SHADOW_ACC_TRACK_SAVED_BITS_MASK (PT64_EPT_READABLE_MASK | \
+					  PT64_EPT_EXECUTABLE_MASK)
+#define SHADOW_ACC_TRACK_SAVED_BITS_SHIFT 54
+#define SHADOW_ACC_TRACK_SAVED_MASK	(SHADOW_ACC_TRACK_SAVED_BITS_MASK << \
+					 SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
+static_assert(!(SPTE_TDP_AD_MASK & SHADOW_ACC_TRACK_SAVED_MASK));
+
+/*
+ * Low ignored bits are at a premium for EPT, use high ignored bits, taking care
+ * to not overlap the A/D type mask or the saved access bits of access-tracked
+ * SPTEs when A/D bits are disabled.
+ */
+#define EPT_SPTE_HOST_WRITABLE		BIT_ULL(57)
+#define EPT_SPTE_MMU_WRITABLE		BIT_ULL(58)
+
+static_assert(!(EPT_SPTE_HOST_WRITABLE & SPTE_TDP_AD_MASK));
+static_assert(!(EPT_SPTE_MMU_WRITABLE & SPTE_TDP_AD_MASK));
+static_assert(!(EPT_SPTE_HOST_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
+static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
+
+/* Defined only to keep the above static asserts readable. */
+#undef SHADOW_ACC_TRACK_SAVED_MASK
 
 /*
  * Due to limited space in PTEs, the MMIO generation is a 20 bit subset of
@@ -128,19 +159,6 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  */
 #define SHADOW_NONPRESENT_OR_RSVD_MASK_LEN 5
 
-/*
- * The mask/shift to use for saving the original R/X bits when marking the PTE
- * as not-present for access tracking purposes. We do not save the W bit as the
- * PTEs being access tracked also need to be dirty tracked, so the W bit will be
- * restored only when a write is attempted to the page.  This mask obviously
- * must not overlap the A/D type mask.
- */
-#define SHADOW_ACC_TRACK_SAVED_BITS_MASK (PT64_EPT_READABLE_MASK | \
-					  PT64_EPT_EXECUTABLE_MASK)
-#define SHADOW_ACC_TRACK_SAVED_BITS_SHIFT 54
-static_assert(!(SPTE_TDP_AD_MASK & (SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
-				    SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)));
-
 /*
  * If a thread running without exclusive control of the MMU lock must perform a
  * multi-part operation on an SPTE, it can set the SPTE to REMOVED_SPTE as a
-- 
2.30.1.766.gb4fecdf3b7-goog

