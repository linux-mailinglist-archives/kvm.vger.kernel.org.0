Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9823325820
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhBYUze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbhBYUw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:52:26 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294DDC061A2B
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:53 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v196so7617493ybv.3
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=t3kQc1ZBqIKru+8m6mAJSLgdx/h6CrwvErQeXMobocU=;
        b=JzVdifboWjjdBoabYJyKIMT1I7ZxClYgeK0/EqMu/zIUFm8T85dOsQBAnqJQlMb1gC
         rbt61hJ6mROJUic2Miy+C1Q7Bd+8RqWTlKVAKb3JO8IFV69ntjEdt57jSs+csBL94OqG
         SYhktDOMwmihM5Wr4UCYS6VBZFsktVURY9TqtaUvhTrJqVGwEvVaowtPGYH0Nl1SFimQ
         d5Tw1fYLYm2fxIKwzI47nLFm+R8vvUdgZB9/2h9nzKCi75Dqnmv//L27A6e9umsKAxgc
         ZZOFasfrV86d6740D4gwmCCDSsMs7/iGdJd8p+QFvaWVhBPWsYFA/DaHg6JJTkgIJ85W
         oOlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=t3kQc1ZBqIKru+8m6mAJSLgdx/h6CrwvErQeXMobocU=;
        b=oJ+UTewLRlfcf5UuDDwlwxqMY7Q2ANlK0ZiyD7t7DHX8MhWB1LnVGXGDR2HcL7Mmax
         0o3ODsptVlDphQx3t28nTkPsII7g89sex8Oelmss/dvsl4Oom+37pPt2fodCpBTBPAqf
         SgaJD2ENdI2yiwQSjKCGxrBpRmcmGVXTa8fgoTlou1R0qNqxo5zdPN6fQhiDUF6AWSx9
         IJmQkIXnHdCRuyawgP9BbGzDSstluXlf1+Z+ARwtoNmYmKnK6CEJUEDnJuhWSvx2346x
         qPHGpS439i71eeUOUW4FGP+Fdh/VMVL4XY8O1F7wWZF0SFlWFuinAVbUQFZx1osuPD8f
         98rQ==
X-Gm-Message-State: AOAM530ffHGeDf8EWvJE5SVC+AVBj7b/sZ2SsQPtVSGmydZaZN4hwjMy
        keNPAZvL3aVem3TLI/kSd1V3kTMOh/g=
X-Google-Smtp-Source: ABdhPJxGqwh5Gc2SUSJAX+FZVrGQ01uPxr06LB6UpPw+d7UXzvEaHnWkfch5fwCICyW4yXWzpsaZhrpgGBc=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:5ac2:: with SMTP id o185mr7236810ybb.252.1614286132332;
 Thu, 25 Feb 2021 12:48:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:45 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-21-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 20/24] KVM: x86/mmu: Use a dedicated bit to track
 shadow/MMU-present SPTEs
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

Introduce MMU_PRESENT to explicitly track which SPTEs are "present" from
the MMU's perspective.  Checking for shadow-present SPTEs is a very
common operation for the MMU, particularly in hot paths such as page
faults.  With the addition of "removed" SPTEs for the TDP MMU,
identifying shadow-present SPTEs is quite costly especially since it
requires checking multiple 64-bit values.

On 64-bit KVM, this reduces the footprint of kvm.ko's .text by ~2k bytes.
On 32-bit KVM, this increases the footprint by ~200 bytes, but only
because gcc now inlines several more MMU helpers, e.g. drop_parent_pte().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c |  8 ++++----
 arch/x86/kvm/mmu/spte.h | 11 ++++++++++-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index d12acf5eb871..e07aabb23b8a 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -94,7 +94,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		     bool can_unsync, bool host_writable, bool ad_disabled,
 		     u64 *new_spte)
 {
-	u64 spte = 0;
+	u64 spte = SPTE_MMU_PRESENT_MASK;
 	int ret = 0;
 
 	if (ad_disabled)
@@ -183,10 +183,10 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 {
-	u64 spte;
+	u64 spte = SPTE_MMU_PRESENT_MASK;
 
-	spte = __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
-	       shadow_user_mask | shadow_x_mask | shadow_me_mask;
+	spte |= __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
+		shadow_user_mask | shadow_x_mask | shadow_me_mask;
 
 	if (ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED_MASK;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 8996baa8da15..645e9bc2d4a2 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -5,6 +5,15 @@
 
 #include "mmu_internal.h"
 
+/*
+ * A MMU present SPTE is backed by actual memory and may or may not be present
+ * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11, as it
+ * is ignored by all flavors of SPTEs and checking a low bit often generates
+ * better code than for a high bit, e.g. 56+.  MMU present checks are pervasive
+ * enough that the improved code generation is noticeable in KVM's footprint.
+ */
+#define SPTE_MMU_PRESENT_MASK		BIT_ULL(11)
+
 /*
  * TDP SPTES (more specifically, EPT SPTEs) may not have A/D bits, and may also
  * be restricted to using write-protection (for L2 when CPU dirty logging, i.e.
@@ -241,7 +250,7 @@ static inline bool is_access_track_spte(u64 spte)
 
 static inline bool is_shadow_present_pte(u64 pte)
 {
-	return (pte != 0) && !is_mmio_spte(pte) && !is_removed_spte(pte);
+	return !!(pte & SPTE_MMU_PRESENT_MASK);
 }
 
 static inline bool is_large_pte(u64 pte)
-- 
2.30.1.766.gb4fecdf3b7-goog

