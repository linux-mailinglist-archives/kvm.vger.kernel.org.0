Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA634E32F9
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiCUWti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiCUWtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:49:22 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60504759F1
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:06 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id w3-20020a17090ac98300b001b8b914e91aso282066pjt.0
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=u4JgM+75AZti27lWXqtslukLZQOfvOSzkXisiK6DciE=;
        b=O3iLZaJFpBD2w8/KBPwwtdSPS3VW/mW+S1HIPBHLXcwgAJ4BjjapYoLUcZEAthI5CM
         8pg6yLMvfbQfStqh4mPuZwedjV4YTYq5XoMkdOgLw3CW9MvcGCEK2TFcZT3csUGPf6GV
         4Ffa1CQEmHjLFXFLB+W15T2iQBD9TnMIYYMGyQcAxVhffbp2lf9atPSu3uuUkW+HjxcU
         U41z6fnybdcxtkbHs0+h3m28ei5FXR8FoVvb4T7lu/3rssBKeMct+czWbQK1qIW59mP3
         n9RF3DR+RUFh4gAbrQXcMXDZBIZvnLvAfmk9RC/grvCY7vmD52esqOFUZo3eAP4m+omR
         z0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=u4JgM+75AZti27lWXqtslukLZQOfvOSzkXisiK6DciE=;
        b=3c4vgLpbk2Q9M4o3DVNFbuFsdSpWLd5G8uzXqoyJOk+ebBmiBotka7jgRd7jkxbvLm
         KxlaCyah1SA5L0PoL09Rq4dglRiJ+QtFrNrz51yHprMXOG29UqrO/fLbpCgdFsiSFDcJ
         3Pt8mJk2Js1b7kzSHPyMMETnIVVJk2ECIfq8u9U961CBmpXA9opfDAcxTu2/VicXZRpd
         5fdcX3I/+t03nVVQhM4Fm/PE/ZqOGd573VXdA/Px+M5d5dKfZdF65xNsz8boQyN6hK76
         CDiR7gQVUTQk8n4Owse0zSak8umZMppPvguVn2laS6jXw6ncfP3oX7pNIT4d4kAHDftk
         7TFQ==
X-Gm-Message-State: AOAM5326M0AV+vaV/GksnDXkK/trrDtiXgBKI6xKYw/3ZSm11iddI/EP
        2LfEbFYQfSYHiiB3gjaJgQKjZjjEmqHc
X-Google-Smtp-Source: ABdhPJzjrjlRXuCSKs/r2vXduiSUY2+WMaIe9AiFUfDVX2HOaPToQVhD+JfsRG79K2Fz+le1NG7UYlGRPRjA
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:1596:b0:4f9:f992:9f69 with SMTP
 id u22-20020a056a00159600b004f9f9929f69mr25497286pfk.7.1647902646189; Mon, 21
 Mar 2022 15:44:06 -0700 (PDT)
Date:   Mon, 21 Mar 2022 15:43:51 -0700
In-Reply-To: <20220321224358.1305530-1-bgardon@google.com>
Message-Id: <20220321224358.1305530-3-bgardon@google.com>
Mime-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 2/9] KVM: x86/mmu: Factor mt_mask out of __make_spte
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In service of removing the vCPU pointer from __make_spte, factor the memory
type mask calculation out of __make_spte.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/spte.c | 12 ++++++++----
 arch/x86/kvm/mmu/spte.h |  3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index d3da0d3d41cb..931cf93c3b7e 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -93,7 +93,8 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 const struct kvm_memory_slot *slot, unsigned int pte_access,
 		 gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
-		 bool can_unsync, bool host_writable, u64 *new_spte)
+		 bool can_unsync, bool host_writable, u64 mt_mask,
+		 u64 *new_spte)
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
@@ -130,8 +131,7 @@ bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
-		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
-			kvm_is_mmio_pfn(pfn));
+		spte |= mt_mask;
 
 	if (host_writable)
 		spte |= shadow_host_writable_mask;
@@ -197,8 +197,12 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte)
 {
+	u64 mt_mask = static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
+						       kvm_is_mmio_pfn(pfn));
+
 	return __make_spte(vcpu, sp, slot, pte_access, gfn, pfn, old_spte,
-			   prefetch, can_unsync, host_writable, new_spte);
+			   prefetch, can_unsync, host_writable, mt_mask,
+			   new_spte);
 
 }
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 3fae3c3124f7..d051f955699e 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -413,7 +413,8 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 const struct kvm_memory_slot *slot, unsigned int pte_access,
 		 gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
-		 bool can_unsync, bool host_writable, u64 *new_spte);
+		 bool can_unsync, bool host_writable, u64 mt_mask,
+		 u64 *new_spte);
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-- 
2.35.1.894.gb6a874cedc-goog

