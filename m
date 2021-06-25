Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515FD3B46B5
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 17:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhFYPgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 11:36:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229873AbhFYPgl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 11:36:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624635260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GAefR5jsv2aB5x5SE+QJ86SlCiYChLGRfggmJlDrXNo=;
        b=FE0AIKLwVwVZoti+GERVLQlivLLsbGysy6w4O1fTXuRu+ZoTmwZFQU70xDrFDQErU4LhKh
        s5v2foMUIq5MXX3vKyEw3HMlfekKfveZMWRbnIjBlej9SJ16bN+Rg1aQxgdbvwY39BQNnH
        ExsIHtzGVXzMFgQJ/UL4qVCCa+m0CqY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-d9qejar_O3aFtgrDrULiiA-1; Fri, 25 Jun 2021 11:34:19 -0400
X-MC-Unique: d9qejar_O3aFtgrDrULiiA-1
Received: by mail-il1-f199.google.com with SMTP id g14-20020a926b0e0000b02901bb2deb9d71so6380432ilc.6
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 08:34:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GAefR5jsv2aB5x5SE+QJ86SlCiYChLGRfggmJlDrXNo=;
        b=hi5tUhV+2FmyT4HxWcJ0dxG8PoSFst7CY2eVubzBOw0dLc1YqXqynX4cF0m1+x5Ss4
         pvMV8pYLaUiBO0UH63SquhttCUOr4eOgKgtpzx9lX8onR1xW3uzAmI/QiBaLG4bKvmau
         2nNZa/8W7U6MBZ8+uRYQ/8M9PBD4DJTk3FINZOgPOtfemqIqosIXbgbCSk4XjxSnLv0Y
         dhqT+JyvuZ+hfJGGTBsLUu7VEl+nYg4aMmw9Iw2BKTYn5hU2YFjMAHFz2ypoTufymOn+
         vJ/UNxomBOB4huaHzYHvz3G2DwdLkgpKfa5RAdjRD21ViI7FafCk6hA8xZXSDeUDwxp6
         Yc4A==
X-Gm-Message-State: AOAM533ibppQSyMbPiy1X+C/hrbJIHg1hPUC/OYPf1JS8W9FevtsYL/A
        1d54aM5bKkH+FnYm5bPkeXVhXnUhFDMqfIrI7259p5wAxIOPIKDClQ2kdo8URHSjXZdD+eHLUkd
        Lx2Lu3snx4Tt5
X-Received: by 2002:a02:84a3:: with SMTP id f32mr10034952jai.63.1624635258713;
        Fri, 25 Jun 2021 08:34:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxq6qUS4K3DVs2P9SSjKenQ7FRjhcE3FWO4HRIgVDFbE6V1/5UvoM18/9G/9bY7GwfogG12eA==
X-Received: by 2002:a02:84a3:: with SMTP id f32mr10034937jai.63.1624635258511;
        Fri, 25 Jun 2021 08:34:18 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id x11sm3863687ilg.59.2021.06.25.08.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:34:17 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com, Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 8/9] KVM: X86: Optimize pte_list_desc with per-array counter
Date:   Fri, 25 Jun 2021 11:34:15 -0400
Message-Id: <20210625153415.43620-1-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210625153214.43106-1-peterx@redhat.com>
References: <20210625153214.43106-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a counter field into pte_list_desc, so as to simplify the add/remove/loop
logic.  E.g., we don't need to loop over the array any more for most reasons.

This will make more sense after we've switched the array size to be larger
otherwise the counter will be a waste.

Initially I wanted to store a tail pointer at the head of the array list so we
don't need to traverse the list at least for pushing new ones (if without the
counter we traverse both the list and the array).  However that'll need
slightly more change without a huge lot benefit, e.g., after we grow entry
numbers per array the list traversing is not so expensive.

So let's be simple but still try to get as much benefit as we can with just
these extra few lines of changes (not to mention the code looks easier too
without looping over arrays).

I used the same a test case to fork 500 child and recycle them ("./rmap_fork
500" [1]), this patch further speeds up the total fork time of about 14%, which
is a total of 38% of vanilla kernel:

        Vanilla:      367.20 (+-4.58%)
        3->15 slots:  302.00 (+-5.30%)
        Add counter:  265.20 (+-9.88%)

[1] https://github.com/xzpeter/clibs/commit/825436f825453de2ea5aaee4bdb1c92281efe5b3

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9b093985a2ef..ba0258bdebc4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -138,10 +138,15 @@ module_param(dbg, bool, 0644);
 #include <trace/events/kvm.h>
 
 /* make pte_list_desc fit well in cache lines */
-#define PTE_LIST_EXT 15
+#define PTE_LIST_EXT 14
 
 struct pte_list_desc {
 	u64 *sptes[PTE_LIST_EXT];
+	/*
+	 * Stores number of entries stored in the pte_list_desc.  No need to be
+	 * u64 but just for easier alignment.  When PTE_LIST_EXT, means full.
+	 */
+	u64 spte_count;
 	struct pte_list_desc *more;
 };
 
@@ -893,7 +898,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 			struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
-	int i, count = 0;
+	int count = 0;
 
 	if (!rmap_head->val) {
 		rmap_printk("%p %llx 0->1\n", spte, *spte);
@@ -903,24 +908,24 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		desc = mmu_alloc_pte_list_desc(vcpu);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
+		desc->spte_count = 2;
 		rmap_head->val = (unsigned long)desc | 1;
 		++count;
 	} else {
 		rmap_printk("%p %llx many->many\n", spte, *spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-		while (desc->sptes[PTE_LIST_EXT-1]) {
+		while (desc->spte_count == PTE_LIST_EXT) {
 			count += PTE_LIST_EXT;
-
 			if (!desc->more) {
 				desc->more = mmu_alloc_pte_list_desc(vcpu);
 				desc = desc->more;
+				desc->spte_count = 0;
 				break;
 			}
 			desc = desc->more;
 		}
-		for (i = 0; desc->sptes[i]; ++i)
-			++count;
-		desc->sptes[i] = spte;
+		count += desc->spte_count;
+		desc->sptes[desc->spte_count++] = spte;
 	}
 	return count;
 }
@@ -930,13 +935,12 @@ pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
 			   struct pte_list_desc *desc, int i,
 			   struct pte_list_desc *prev_desc)
 {
-	int j;
+	int j = desc->spte_count - 1;
 
-	for (j = PTE_LIST_EXT - 1; !desc->sptes[j] && j > i; --j)
-		;
 	desc->sptes[i] = desc->sptes[j];
 	desc->sptes[j] = NULL;
-	if (j != 0)
+	desc->spte_count--;
+	if (desc->spte_count)
 		return;
 	if (!prev_desc && !desc->more)
 		rmap_head->val = 0;
@@ -969,7 +973,7 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
 		prev_desc = NULL;
 		while (desc) {
-			for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i) {
+			for (i = 0; i < desc->spte_count; ++i) {
 				if (desc->sptes[i] == spte) {
 					pte_list_desc_remove_entry(rmap_head,
 							desc, i, prev_desc);
@@ -993,7 +997,7 @@ static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
-	unsigned int i, count = 0;
+	unsigned int count = 0;
 
 	if (!rmap_head->val)
 		return 0;
@@ -1003,8 +1007,7 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
 
 	while (desc) {
-		for (i = 0; (i < PTE_LIST_EXT) && desc->sptes[i]; i++)
-			count++;
+		count += desc->spte_count;
 		desc = desc->more;
 	}
 
-- 
2.31.1

