Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC4D68A2F9
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 20:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbjBCT2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 14:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbjBCT2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 14:28:36 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE08A8A1E
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 11:28:32 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id n9-20020a170902d2c900b001968dcee881so2970950plc.8
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 11:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AcI5nZSY78YItFhCkcPCsgYpVHXo4G2xX3PARLK9PNY=;
        b=jnIgJE609c2sptSoHjjd3x7jZtT7KKK/MLWWeUqiS8WA2JDk4FeRouptRJICfrxIiL
         ltXurNvSD6sG3igKDh2jIDvC139/r0ohRfJJG6pQnedSojgn6p86/PzyD7KtkRoozEMs
         kQk/oF3N032gLlif8xUP5eDhlBX1h9Xgbe6TauMdaNiztnykutoA6logtvV9fpbOhff/
         n6fE5UFqDNwzbhaTz5ygCEMGiXIgDXG7fGIjHp4wkMPYAh1YXKf21kdIrLMzALj8a3u4
         tudd1dArJcrxBZaQnyHLlr0CksaMvJ3/TD4Fet8r0s0LPkO4YK/ew1sp3r98Mpuf0rDv
         KtMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AcI5nZSY78YItFhCkcPCsgYpVHXo4G2xX3PARLK9PNY=;
        b=HgY12MGPm+nfxbXe0fBCNxbViOq8sAgVIt6NF2DkVYt5ViDhV2LY8sNErBRteNfjC6
         WgFjLYU9snZgtF9G0E8SD9PST/VYJZ3acFCW0DRvlIGtO1WllLO147G6mApGgDmNL8Tz
         6fL0TbqenTCuR8I0oCuCSe4nUi7mX1lHAIGw1BmWamTv+WKlCNtrdngdhyNVPPthxOIJ
         u1noOPdQR6Ms8+XBQb8e6OZrfxU1dpN37OwB6KQ4gkXuFOydie5srCVJqmMlu0mgnLYr
         EUPHjpGoNJftNJUM2yif3vt1EXbs+HnEatDV5c/hdZkYBf8hR5YYFgiouaAXufKiGooS
         ztyQ==
X-Gm-Message-State: AO0yUKXyn1TQ4+feORNz7CbEx8LUOfJ03IivsqaJuJ+kyulkU4M1d2fl
        VacrK7SYuYs/loFZsxwFY/IjzjKibHp2
X-Google-Smtp-Source: AK7set9zAa9sYfJsDzK4yP/WJL7nNxNfkHIisp6zMJ819xF4knFbVeKi6XawXk1CUgZr6LmYrZOoVWgl9aQn
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:ea03:b0:196:6b0d:752b with SMTP id
 s3-20020a170902ea0300b001966b0d752bmr2649815plg.19.1675452512414; Fri, 03 Feb
 2023 11:28:32 -0800 (PST)
Date:   Fri,  3 Feb 2023 11:28:21 -0800
In-Reply-To: <20230203192822.106773-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203192822.106773-5-vipinsh@google.com>
Subject: [Patch v2 4/5] KVM: x86/mmu: Remove handle_changed_spte_dirty_log()
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove handle_changed_spte_dirty_log() as there is no code flow which
sets leaf SPTE writable and hit this path.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 18630a06fa1f..afe0dcb1859e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -345,24 +345,6 @@ static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
-static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
-					  u64 old_spte, u64 new_spte, int level)
-{
-	bool pfn_changed;
-	struct kvm_memory_slot *slot;
-
-	if (level > PG_LEVEL_4K)
-		return;
-
-	pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
-
-	if ((!is_writable_pte(old_spte) || pfn_changed) &&
-	    is_writable_pte(new_spte)) {
-		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
-		mark_page_dirty_in_slot(kvm, slot, gfn);
-	}
-}
-
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, +1);
@@ -614,8 +596,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
 			      shared);
 	handle_changed_spte_acc_track(old_spte, new_spte, level);
-	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
-				      new_spte, level);
 }
 
 /*
@@ -727,8 +707,6 @@ static u64 _tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
 	handle_changed_spte_acc_track(old_spte, new_spte, level);
-	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte, new_spte,
-				      level);
 	return old_spte;
 }
 
-- 
2.39.1.519.gcb327c4b5f-goog

