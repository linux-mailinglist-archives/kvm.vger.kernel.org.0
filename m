Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FDE2EB647
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 00:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbhAEXcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 18:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbhAEXcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 18:32:22 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F992C061796
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 15:31:42 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id ba10so600431plb.11
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 15:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ZyTlZ/k15y59etqIsKWXwuwdp0Ptq0PY9G2YOfirv10=;
        b=SmguYd94DqsefZDIkAqdPP7uTQvjPgC9cTP0H4eemFqpdBI1P60rgFvn9I9vphADaV
         kSP3+kxTg/EYQN90MrAPRyoC1htJekswogFgtlJL9UuydQzQ5hWkWa+J81FEkoyTCJJR
         KbVatbLypdphE1JplrNP/k6jIDwex4leD5yLbfFppMEfpvjJDrhlyKgYjBkao7ng9Bxh
         IwQDuzxi1ljbl7zO9vGvsUyM/XGCWKAkkqqb4XWb+BmxVz1Kc4wNE+XbT49yebYTrqTm
         bJ+O5XvdXc9BeuMUXM1qCQT0fs8nC9J+exRXJcw6fWgGgWg7t+iwFo/kDizNH3LYD4hW
         ApCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZyTlZ/k15y59etqIsKWXwuwdp0Ptq0PY9G2YOfirv10=;
        b=UZ2BYpTPv2wz+IzeoZFgAcPLCb0HAEAfC9wllem9OCEjUV0PRZc//5+z1Be9oVjLGO
         DAE0vmx/7uXtOQj72Bl/qtfOW5AEfs+w0BjSvat+v++w4ZGCk55182j/nFWf73ls8S2O
         vAH/WtVd9ZrNOGIMh8cgHdXEcukZZWSTFhjoTq88X7hKEFsINN7X3BYz9Z+7B9jKK2x3
         wCgL1gvtzuKbDDil3lUTC/BkxYlkCeAVrphDlO1ONUUhf6r+/oB7sK3/HcTAv+cNmDEU
         F3Kq5kBu3esRGpikdwuTzStFXiYbMSMU4EEyQjx96/imOLyMgvPEPBY/F3bmelINSkEb
         JR/w==
X-Gm-Message-State: AOAM531e8D0pCJe59faKzEbBStJ1/AnevRvE5VS5PwZdnI+mXw1Ncqe5
        3PWE81enrABloBxeVrXuh2prjRnY5W0E
X-Google-Smtp-Source: ABdhPJwZ6yAMJafxX6iur1GyjDFFCTvcv+8fp18C24zD31Xn5DRrVmLWALKKAzXWJlo8+8ZcrXKFAcB0Oc2T
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:90a:930f:: with SMTP id
 p15mr1435933pjo.73.1609889502096; Tue, 05 Jan 2021 15:31:42 -0800 (PST)
Date:   Tue,  5 Jan 2021 15:31:35 -0800
In-Reply-To: <20210105233136.2140335-1-bgardon@google.com>
Message-Id: <20210105233136.2140335-2-bgardon@google.com>
Mime-Version: 1.0
References: <20210105233136.2140335-1-bgardon@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 2/3] kvm: x86/mmu: Ensure TDP MMU roots are freed after yield
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Leo Hou <leohou1402@gmail.com>, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Many TDP MMU functions which need to perform some action on all TDP MMU
roots hold a reference on that root so that they can safely drop the MMU
lock in order to yield to other threads. However, when releasing the
reference on the root, there is a bug: the root will not be freed even
if its reference count (root_count) is reduced to 0. Ensure that these
roots are properly freed.

Reported-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
Fixes: 063afacd8730 ("kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU")
Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Fixes: 14881998566d ("kvm: x86/mmu: Support disabling dirty logging for the tdp MMU")
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 75db27fda8f3..5ec6fae36e33 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -83,6 +83,12 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 	kmem_cache_free(mmu_page_header_cache, root);
 }
 
+static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
+{
+	if (kvm_mmu_put_root(kvm, root))
+		kvm_tdp_mmu_free_root(kvm, root);
+}
+
 static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
 						   int level)
 {
@@ -456,7 +462,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
 
 		flush |= zap_gfn_range(kvm, root, start, end, true);
 
-		kvm_mmu_put_root(kvm, root);
+		tdp_mmu_put_root(kvm, root);
 	}
 
 	return flush;
@@ -648,7 +654,7 @@ static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
 				       gfn_end, data);
 		}
 
-		kvm_mmu_put_root(kvm, root);
+		tdp_mmu_put_root(kvm, root);
 	}
 
 	return ret;
@@ -852,7 +858,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
 			     slot->base_gfn + slot->npages, min_level);
 
-		kvm_mmu_put_root(kvm, root);
+		tdp_mmu_put_root(kvm, root);
 	}
 
 	return spte_set;
@@ -920,7 +926,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
 
-		kvm_mmu_put_root(kvm, root);
+		tdp_mmu_put_root(kvm, root);
 	}
 
 	return spte_set;
@@ -1043,7 +1049,7 @@ bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
 		spte_set |= set_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
 
-		kvm_mmu_put_root(kvm, root);
+		tdp_mmu_put_root(kvm, root);
 	}
 	return spte_set;
 }
@@ -1103,7 +1109,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		zap_collapsible_spte_range(kvm, root, slot->base_gfn,
 					   slot->base_gfn + slot->npages);
 
-		kvm_mmu_put_root(kvm, root);
+		tdp_mmu_put_root(kvm, root);
 	}
 }
 
-- 
2.29.2.729.g45daf8777d-goog

