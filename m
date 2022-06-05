Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85AC153DA8F
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350726AbiFEGoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350825AbiFEGn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:43:59 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683DE483AF;
        Sat,  4 Jun 2022 23:43:28 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n8so9866005plh.1;
        Sat, 04 Jun 2022 23:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ZPEYVPT8lSmzrFfSReWUpWaXzCkp32kYLA9BRd9poo=;
        b=ZNn0WASDiHjxRFywP5TR73R8wJiC3ZSdxxKyspy9RLQdrkXYFta3MBrcxf84vmim5j
         c7nJdyx85YRp8jUZtcteGz6fD50M36c5Ew2w92iQNUcmZYxVQpDEHSJrUQpMaK82xbBh
         W+hVKL0c6cZlEAk5NNfLEgoGU17jUZpJDgCDvq71EMHFkyGbCPy5LJ6//gTetBajJuqp
         4QqIqKQVAHPWWcXNgAgx91QaVoI19hKygJCUL5E2j1f1NhNcUzbU/eviuqaPJBEL23i+
         3h+Fw42rkQcH56WMnHbdDMyh6IK0lSYJmBnsKfNTfj9IPdzRyFA358b7SKt/ZNzoixO0
         69Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ZPEYVPT8lSmzrFfSReWUpWaXzCkp32kYLA9BRd9poo=;
        b=16RKKU+NALGwjRymfBld11/H8mHWMg9Uxoz4YGJjq2HEpvzdtjv/RBhr2N7ZBN8YK1
         nTKLU0DfNJz3pNYwc/8193zzJdUsr6V1T1KtjtXO2caODJ+oeV7LvJ+k4y/blIxzRax6
         eqF8KfJItlt5KUkdHoX5qcM7GEmIVOINpTse5kllJ5EyCirHXuCfrQnPoq/gMDZWhlCN
         vQLSz5L3uwUt0KI87RNDRtPPHWAYKqb09KJ2EA/o/tnh4wcjrYpVUcTlT86xACIEDUtf
         kemeGVa1ncFeZmPUh7yOWNddiBo8udCFh9JZs5Y2qOMNqWiAHV+8k8ArsxLm38K44eSd
         b6wQ==
X-Gm-Message-State: AOAM530b39jOa1cNdRlIyxJvN6GZ0Kbp6gbKgD7+sZcV0o+c1/K1Xjba
        bg+3nshPgPEWm4JcLGcMRVaPX2XqYIE=
X-Google-Smtp-Source: ABdhPJw1Z0TMC5z7R5ZNgBNj1jdkxTHk0RywS567SkssZrZ/sO+fyc07fWQO7eJOE0kxP0hwV3dChg==
X-Received: by 2002:a17:90b:4a92:b0:1e8:2ba1:64bf with SMTP id lp18-20020a17090b4a9200b001e82ba164bfmr12833283pjb.41.1654411407330;
        Sat, 04 Jun 2022 23:43:27 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id js24-20020a17090b149800b001df3a251cc2sm10376609pjb.4.2022.06.04.23.43.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:43:27 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 09/12] KVM: X86/MMU: Unfold struct mmu_page_and_offset in struct kvm_mmu_pages
Date:   Sun,  5 Jun 2022 14:43:39 +0800
Message-Id: <20220605064342.309219-10-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220605064342.309219-1-jiangshanlai@gmail.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

struct kvm_mmu_page *sp is the only field in struct mmu_page_and_offset.

Unfold it.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dc159db46b34..a5563e5ee2e5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1743,9 +1743,7 @@ static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
 #define KVM_PAGE_ARRAY_NR 16
 
 struct kvm_mmu_pages {
-	struct mmu_page_and_offset {
-		struct kvm_mmu_page *sp;
-	} page[KVM_PAGE_ARRAY_NR];
+	struct kvm_mmu_page *sp[KVM_PAGE_ARRAY_NR];
 	unsigned int nr;
 };
 
@@ -1755,10 +1753,10 @@ static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp)
 
 	if (sp->unsync)
 		for (i=0; i < pvec->nr; i++)
-			if (pvec->page[i].sp == sp)
+			if (pvec->sp[i] == sp)
 				return 0;
 
-	pvec->page[pvec->nr].sp = sp;
+	pvec->sp[pvec->nr] = sp;
 	pvec->nr++;
 	return (pvec->nr == KVM_PAGE_ARRAY_NR);
 }
@@ -1894,7 +1892,7 @@ static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 #define for_each_sp(pvec, sp, i)					\
 		for (i = mmu_pages_first(&pvec);			\
-			i < pvec.nr && ({ sp = pvec.page[i].sp; 1;});	\
+			i < pvec.nr && ({ sp = pvec.sp[i]; 1;});	\
 			i = mmu_pages_next(&pvec, i))
 
 static int mmu_pages_next(struct kvm_mmu_pages *pvec, int i)
@@ -1902,7 +1900,7 @@ static int mmu_pages_next(struct kvm_mmu_pages *pvec, int i)
 	int n;
 
 	for (n = i+1; n < pvec->nr; n++) {
-		struct kvm_mmu_page *sp = pvec->page[n].sp;
+		struct kvm_mmu_page *sp = pvec->sp[n];
 		int level = sp->role.level;
 
 		if (level == PG_LEVEL_4K)
@@ -1921,7 +1919,7 @@ static int mmu_pages_first(struct kvm_mmu_pages *pvec)
 	if (pvec->nr == 0)
 		return 0;
 
-	sp = pvec->page[0].sp;
+	sp = pvec->sp[0];
 	level = sp->role.level;
 	WARN_ON(level == PG_LEVEL_4K);
 
-- 
2.19.1.6.gb485710b

