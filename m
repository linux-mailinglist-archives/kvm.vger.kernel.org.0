Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BFC53DA8E
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350869AbiFEGoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350798AbiFEGnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:43:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837BC48E4C;
        Sat,  4 Jun 2022 23:43:20 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso10235285pjg.0;
        Sat, 04 Jun 2022 23:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hP6WCCUnsgHR2skvjVke3m5tSl6/Nn31ws8pPHbQIQs=;
        b=cpWF4hZjd7n8ys3I/RUfjMbUmhxvOtTu7/OVGCgN5jobwWUu5ufojOspj2koShTqsb
         Ep6BWxnnU99WO2qmh4dSfxxpK84K/3JFXmvomfx2eN15Wo/tWM9TIsk2PcS/xoBITtaK
         gPLcns0VlBGItpvJAR4uh09q3saYnER8JPYr5oXaP4Rno/eTRDm88TLcy6q1oblFjjaC
         KbFcbtgOYUJ3mWmjUMV0ffoNhtuJxnZbeZpksDHrPPhQtFyEPVtgGY+i5DYDvEb4SklF
         qvs5+hwgJFZTbVMApxJ6otLjU+z97d7HlJlsao2PFYmtgmF8/JUbptGQtyiz3GbnOhKL
         s7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hP6WCCUnsgHR2skvjVke3m5tSl6/Nn31ws8pPHbQIQs=;
        b=bwsH3W8X/3nLxHSwukMT2Qg6y7OVTebXO8t30m/VFRLC7VNmHqj3rxASaFBTpBMHdv
         ntd8C0L5rccf3qNoXDogcIriXGTZog/hTBjyeJrVQTXw5PUtl8ZYAucQILnO3sPDJAHc
         0hPNt63xYeHiNpYvzYatI+PLDCV7JjqMOLQZ/nqBed8LX+3xurgMPLm1/cPLFVzd3q1c
         P1DUJvdRmZbaRbF0o/YUG5yW3JOIptzLMlXUKfLi0Xi21DWs1nLO/5+a9RVWvcbdrwRu
         CGzwKKJ+ka/rQ8uSqccAF/LLCYif4yq99nBm775VCubhgmrhKTeW59ZSYRs85rOjaEav
         YHeQ==
X-Gm-Message-State: AOAM532K2IV460b6VNgzd9vPhxnwsLoNbCzFzEDOB/iD7G9rZSN/6wRu
        +w9HxNj+go9mcfBlUvycxcwNdl9wpyI=
X-Google-Smtp-Source: ABdhPJyQNThK2t3saTIHCPi97vTn17IROQ3IqH6dv7P2ekERSI+4IX6SPUK91sKd9WeaOwDRLc/J5g==
X-Received: by 2002:a17:902:e94e:b0:158:91e6:501 with SMTP id b14-20020a170902e94e00b0015891e60501mr18155243pll.29.1654411399215;
        Sat, 04 Jun 2022 23:43:19 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id ru12-20020a17090b2bcc00b001cb6527ca39sm10350755pjb.0.2022.06.04.23.43.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:43:19 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 07/12] KVM: X86/MMU: Remove the useless struct mmu_page_path
Date:   Sun,  5 Jun 2022 14:43:37 +0800
Message-Id: <20220605064342.309219-8-jiangshanlai@gmail.com>
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

struct mmu_page_path is set and updated but never used since
mmu_pages_clear_parents() is removed.

Remove it.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 37 +++++++++----------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a56d328365e4..65a2f4a2ce25 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1897,39 +1897,28 @@ static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
 }
 
-struct mmu_page_path {
-	struct kvm_mmu_page *parent[PT64_ROOT_MAX_LEVEL];
-	unsigned int idx[PT64_ROOT_MAX_LEVEL];
-};
-
-#define for_each_sp(pvec, sp, parents, i)			\
-		for (i = mmu_pages_first(&pvec, &parents);	\
+#define for_each_sp(pvec, sp, i)					\
+		for (i = mmu_pages_first(&pvec);			\
 			i < pvec.nr && ({ sp = pvec.page[i].sp; 1;});	\
-			i = mmu_pages_next(&pvec, &parents, i))
+			i = mmu_pages_next(&pvec, i))
 
-static int mmu_pages_next(struct kvm_mmu_pages *pvec,
-			  struct mmu_page_path *parents,
-			  int i)
+static int mmu_pages_next(struct kvm_mmu_pages *pvec, int i)
 {
 	int n;
 
 	for (n = i+1; n < pvec->nr; n++) {
 		struct kvm_mmu_page *sp = pvec->page[n].sp;
-		unsigned idx = pvec->page[n].idx;
 		int level = sp->role.level;
 
-		parents->idx[level-1] = idx;
 		if (level == PG_LEVEL_4K)
 			break;
 
-		parents->parent[level-2] = sp;
 	}
 
 	return n;
 }
 
-static int mmu_pages_first(struct kvm_mmu_pages *pvec,
-			   struct mmu_page_path *parents)
+static int mmu_pages_first(struct kvm_mmu_pages *pvec)
 {
 	struct kvm_mmu_page *sp;
 	int level;
@@ -1943,13 +1932,7 @@ static int mmu_pages_first(struct kvm_mmu_pages *pvec,
 	level = sp->role.level;
 	WARN_ON(level == PG_LEVEL_4K);
 
-	parents->parent[level-2] = sp;
-
-	/* Also set up a sentinel.  Further entries in pvec are all
-	 * children of sp, so this element is never overwritten.
-	 */
-	parents->parent[level-1] = NULL;
-	return mmu_pages_next(pvec, parents, 0);
+	return mmu_pages_next(pvec, 0);
 }
 
 static int mmu_sync_children(struct kvm_vcpu *vcpu,
@@ -1957,7 +1940,6 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 {
 	int i;
 	struct kvm_mmu_page *sp;
-	struct mmu_page_path parents;
 	struct kvm_mmu_pages pages;
 	LIST_HEAD(invalid_list);
 	bool flush = false;
@@ -1965,7 +1947,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 	while (mmu_unsync_walk_and_clear(parent, &pages)) {
 		bool protected = false;
 
-		for_each_sp(pages, sp, parents, i)
+		for_each_sp(pages, sp, i)
 			protected |= kvm_vcpu_write_protect_gfn(vcpu, sp->gfn);
 
 		if (protected) {
@@ -1973,7 +1955,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 			flush = false;
 		}
 
-		for_each_sp(pages, sp, parents, i) {
+		for_each_sp(pages, sp, i) {
 			kvm_mmu_page_clear_unsync(vcpu->kvm, sp);
 			flush |= kvm_sync_page(vcpu, sp, &invalid_list) > 0;
 		}
@@ -2273,7 +2255,6 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 				   struct list_head *invalid_list)
 {
 	int i, zapped = 0;
-	struct mmu_page_path parents;
 	struct kvm_mmu_pages pages;
 
 	if (parent->role.level == PG_LEVEL_4K)
@@ -2282,7 +2263,7 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 	while (mmu_unsync_walk_and_clear(parent, &pages)) {
 		struct kvm_mmu_page *sp;
 
-		for_each_sp(pages, sp, parents, i) {
+		for_each_sp(pages, sp, i) {
 			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
 			zapped++;
 		}
-- 
2.19.1.6.gb485710b

