Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AECD31A8FE
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 01:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhBMAwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 19:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhBMAv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 19:51:58 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4873C06178C
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:28 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 11so1515984ybl.21
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Xy8pCiIvuQawQkMclMW43HMKCXEyM/TQwcT6KDk/2UM=;
        b=wAQXnTKYjLxM1KYKu3MpoFcyTfkTRoWBI/P4nnUbtn5uFdGazTlZ/tQmAEDPSN5e4f
         2Qw8cmxwdgv1EX2K7PAHEJKBwFzo7EquKs8O3k4PnRz3TZlsDFntv0rsaUobpVkVQymQ
         Muir3noWpX10lSYdLXkmj0GB5z2n4VcE80nwlnPhWZiI7mXNEzEIT2IDP+CRytEUxg4f
         +k0OUV480QFbzGGqHkod6rO364qj6ok5PwjyQMBvoYQXXkCna5kgqS+JjttwZdMRwNgK
         BGinmZ64cdSJXMHL8um8Y4vQSRdmykd2r7NexzT94OH48N96aCEec9ddZ6fWqeEMaeju
         Fi3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Xy8pCiIvuQawQkMclMW43HMKCXEyM/TQwcT6KDk/2UM=;
        b=q5f2vMchwwYo35HFyIO5ONHppsgrGtlH5OM/OTqAc4a7VrJew5e+vohaOQD0kK4A3M
         SGd0xo4FeEbI95D4scCc5RYYXVv2bkfHDEqu+NlbqqJimecEFWxjfyZs5hjNciEmWpMg
         ZyVWeXdmip33Oql9vdnGZEEQmxvkMG/Qyv1pnwM+m1903tWM9JqKKZLesTbZ17rc4HmN
         k455RD4WLaPXGNCfcRJPb1ZBUHfHUfEidDhZqT/abJjUhQxJiOpS25HUXKDs8NmoKbdy
         PKmHRKU5M6Ay6bapn2CDUYULd/hxa932cK0Qj2Vn4yrADluHeqs4dpmGjmdDcvJz19qM
         bdyA==
X-Gm-Message-State: AOAM531FSsfURisFXfIpp7113a/GY8TiDLhycNuC7aZqkapKLP2a7fNE
        ux1zfCyUKeAUDZVVCKhbCSvB9TMg9Fc=
X-Google-Smtp-Source: ABdhPJwipfwSvALM02NbIZU9hDEBvvc702cNbC3lBfKrkGF50eyli8r9WWdXlfcLpzEkVEMNgm685llCU3c=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a5b:410:: with SMTP id m16mr8127952ybp.451.1613177428230;
 Fri, 12 Feb 2021 16:50:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 16:50:04 -0800
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Message-Id: <20210213005015.1651772-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210213005015.1651772-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 03/14] KVM: x86/mmu: Split out max mapping level calculation
 to helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out the logic for determining the maximum mapping level given a
memslot and a gpa.  The helper will be used when zapping collapsible
SPTEs when disabling dirty logging, e.g. to avoid zapping SPTEs that
can't possibly be rebuilt as hugepages.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 37 ++++++++++++++++++++-------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 ++
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 24325bdcd387..9be7fd474b2d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2756,8 +2756,8 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
-static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
-				  kvm_pfn_t pfn, struct kvm_memory_slot *slot)
+static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+				  struct kvm_memory_slot *slot)
 {
 	unsigned long hva;
 	pte_t *pte;
@@ -2776,19 +2776,36 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 	 */
 	hva = __gfn_to_hva_memslot(slot, gfn);
 
-	pte = lookup_address_in_mm(vcpu->kvm->mm, hva, &level);
+	pte = lookup_address_in_mm(kvm->mm, hva, &level);
 	if (unlikely(!pte))
 		return PG_LEVEL_4K;
 
 	return level;
 }
 
+int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_memory_slot *slot,
+			      gfn_t gfn, kvm_pfn_t pfn, int max_level)
+{
+	struct kvm_lpage_info *linfo;
+
+	max_level = min(max_level, max_huge_page_level);
+	for ( ; max_level > PG_LEVEL_4K; max_level--) {
+		linfo = lpage_info_slot(gfn, slot, max_level);
+		if (!linfo->disallow_lpage)
+			break;
+	}
+
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	return host_pfn_mapping_level(kvm, gfn, pfn, slot);
+}
+
 int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 			    int max_level, kvm_pfn_t *pfnp,
 			    bool huge_page_disallowed, int *req_level)
 {
 	struct kvm_memory_slot *slot;
-	struct kvm_lpage_info *linfo;
 	kvm_pfn_t pfn = *pfnp;
 	kvm_pfn_t mask;
 	int level;
@@ -2805,17 +2822,7 @@ int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!slot)
 		return PG_LEVEL_4K;
 
-	max_level = min(max_level, max_huge_page_level);
-	for ( ; max_level > PG_LEVEL_4K; max_level--) {
-		linfo = lpage_info_slot(gfn, slot, max_level);
-		if (!linfo->disallow_lpage)
-			break;
-	}
-
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	level = host_pfn_mapping_level(vcpu, gfn, pfn, slot);
+	level = kvm_mmu_max_mapping_level(vcpu->kvm, slot, gfn, pfn, max_level);
 	if (level == PG_LEVEL_4K)
 		return level;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 9e38d3c5daad..0b55aa561ec8 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -138,6 +138,8 @@ enum {
 #define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
 #define SET_SPTE_SPURIOUS		BIT(2)
 
+int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_memory_slot *slot,
+			      gfn_t gfn, kvm_pfn_t pfn, int max_level);
 int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 			    int max_level, kvm_pfn_t *pfnp,
 			    bool huge_page_disallowed, int *req_level);
-- 
2.30.0.478.g8a0d178c01-goog

