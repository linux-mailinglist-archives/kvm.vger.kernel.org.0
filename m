Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BAF32582F
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 22:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhBYU4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbhBYUwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:52:37 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDBFC061A2E
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:55 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id u1so7581460ybu.14
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=pSgzcPeZf7CkEyKNT+UwT5BWJSvRnduOvKwxLFb/Sls=;
        b=TBmuXSjKcURclFdq9gj6ZPJwNEOkGFuZvmeiwtuR2iDyfiEmsbnL8B5qNH/rXy1JR+
         VHjplhHdfNYXbHEM6d0jXneCHW194c8TZWVoNojdTEP37fblNS8FL9jCmab23FWu45Ns
         nwKvDJn+4RqTWofvtjmhRtLSmEtc0G0f5c8qCesLctd5jL7cMDlquUyyXEAPEpm0yUMf
         u/Nu3R2Kv7jsMqzskDLe48jDtCgVS9dZk4jZigwRa0qh1/8OcjN8lFxWoMqrR2ruE50n
         qTVYV363Yjhh9nEmBgKGyQvvECRNe87Va7VU60vD6OZjtrdq0JteJ/3XOe3FUIIzsjRc
         HsOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=pSgzcPeZf7CkEyKNT+UwT5BWJSvRnduOvKwxLFb/Sls=;
        b=b2l3okkaRaIA5Q6S/qeRQNSHZzrGzcsrtbfbG/VCUTSmAZwDjGeFMIE98GpdFS+u04
         awHLIS7Q5JWqkz7Q1fltLZd7zqWUe5eVEpvMjyoo8BawD7cSvXDj83eP/gyJDzmiHres
         hz5GTdNVO6MEdeiW17raSWvxSVDkjanMj86jKRp6936jLQ/opNe/sgpr1vLKRt24exb5
         ot5P5J0Unx+74ZkARYHrO+ZmGD9p2cun3K7mogyaAEf1Wb8i0KtuRTuKJMeWZDv9k8S5
         4G782bLXFpF4GcfZx837xPYOO9Dgcst0rPki3lHSbOcnoTwygqkxfyYsgHohuA5nGRBI
         AluA==
X-Gm-Message-State: AOAM533gRz6BZGvKH/xtTOE5pdNcuUnoCl08iw5uFvICt1QUv75jrAP5
        57Rc+aYh31qZyiSQeblNgtGWpcqusbM=
X-Google-Smtp-Source: ABdhPJzM+tP1BCqhl0RNwjgmMOiVVSkdZlGjTMGi6o07If4pYkbeB92gckA1zO0PISIf9TNUDxKRApSkHSs=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:af52:: with SMTP id c18mr7183399ybj.196.1614286135191;
 Thu, 25 Feb 2021 12:48:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:46 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-22-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 21/24] KVM: x86/mmu: Tweak auditing WARN for A/D bits to
 !PRESENT (was MMIO)
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

Tweak the MMU_WARN that guards against weirdness when querying A/D status
to fire on a !MMU_PRESENT SPTE, as opposed to a MMIO SPTE.  Attempting to
query A/D status on any kind of !MMU_PRESENT SPTE, MMIO or otherwise,
indicates a KVM bug.  Case in point, several now-fixed bugs were
identified by enabling this new WARN.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 645e9bc2d4a2..2fad4ccd3679 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -209,6 +209,11 @@ static inline bool is_mmio_spte(u64 spte)
 	       likely(shadow_mmio_value);
 }
 
+static inline bool is_shadow_present_pte(u64 pte)
+{
+	return !!(pte & SPTE_MMU_PRESENT_MASK);
+}
+
 static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 {
 	return sp->role.ad_disabled;
@@ -216,13 +221,13 @@ static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 
 static inline bool spte_ad_enabled(u64 spte)
 {
-	MMU_WARN_ON(is_mmio_spte(spte));
+	MMU_WARN_ON(!is_shadow_present_pte(spte));
 	return (spte & SPTE_TDP_AD_MASK) != SPTE_TDP_AD_DISABLED_MASK;
 }
 
 static inline bool spte_ad_need_write_protect(u64 spte)
 {
-	MMU_WARN_ON(is_mmio_spte(spte));
+	MMU_WARN_ON(!is_shadow_present_pte(spte));
 	/*
 	 * This is benign for non-TDP SPTEs as SPTE_TDP_AD_ENABLED_MASK is '0',
 	 * and non-TDP SPTEs will never set these bits.  Optimize for 64-bit
@@ -233,13 +238,13 @@ static inline bool spte_ad_need_write_protect(u64 spte)
 
 static inline u64 spte_shadow_accessed_mask(u64 spte)
 {
-	MMU_WARN_ON(is_mmio_spte(spte));
+	MMU_WARN_ON(!is_shadow_present_pte(spte));
 	return spte_ad_enabled(spte) ? shadow_accessed_mask : 0;
 }
 
 static inline u64 spte_shadow_dirty_mask(u64 spte)
 {
-	MMU_WARN_ON(is_mmio_spte(spte));
+	MMU_WARN_ON(!is_shadow_present_pte(spte));
 	return spte_ad_enabled(spte) ? shadow_dirty_mask : 0;
 }
 
@@ -248,11 +253,6 @@ static inline bool is_access_track_spte(u64 spte)
 	return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
 }
 
-static inline bool is_shadow_present_pte(u64 pte)
-{
-	return !!(pte & SPTE_MMU_PRESENT_MASK);
-}
-
 static inline bool is_large_pte(u64 pte)
 {
 	return pte & PT_PAGE_SIZE_MASK;
-- 
2.30.1.766.gb4fecdf3b7-goog

