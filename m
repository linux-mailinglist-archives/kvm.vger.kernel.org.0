Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2893A53DA91
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350747AbiFEGow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350756AbiFEGns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:43:48 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F45048325;
        Sat,  4 Jun 2022 23:43:24 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w21so10400144pfc.0;
        Sat, 04 Jun 2022 23:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zlSXyDoUcGhenuZlmA7G7JdusXRzge3goPKj2Qa0+W8=;
        b=UXvkknmiKZQUnRF0SnnecBKU9kYMnrbzn3/WhEugctwOuwEVOMEuVIt/V3XF9EMSy+
         pjMsVhORVuq2i0x3zFUlXPOdDGSL0sWTFpMN2CX/3avtAjcmfftA1aRiu1UHGLoAKXIP
         iAJLW3lvrQ3CtsU3ODi5Gky6c1aZIkiJ6qCzqAz2Evl0MvFAIwm9PW0+NdHecqoZa9j3
         DUubP8P0neawote61chfhEJULV9jPR2PCz1838QjLHLOSo6tdKqSWD/QFki3orwaEvbB
         R/Mus2qZVNA281wrR7/5uGj5qz/owkOjentqFKqQLrgwEAZ/O5DdIowTpTj+gYioVbOp
         DMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zlSXyDoUcGhenuZlmA7G7JdusXRzge3goPKj2Qa0+W8=;
        b=Kopk+bJTJ5EDD2mn4A3fgepqzH+u9Bg0TA0FiMVj/5fmemT0Y5jFK/mJlzVL3wS9rv
         I6uU/GALyBwGPQxYkuM9jhaWa9gc6eI9PNk9g75OxMOtPs10G77FkHyg/dITggjuc3Zf
         Mq42F35euyFr8H98g4o1Br2zaRBD+tNNMN3hhCGLZDvcpqLjzqTp+lHYIwYfVE9mIJgM
         qSSftnsujILyLgpclqm3M8ijxglr5cIoCXNa6lP1LwCJqfyGB5Ss11lJL9z2g+OG7cg5
         FgkVYaJXYnMolMXSg/KljSZERVjdaHErgW3StIcuyZmUUtHE8UUkV2x2hjLEcXocr9jf
         7jsQ==
X-Gm-Message-State: AOAM532XGAiDXXAK6/41dSli6TWRrd91mNq4kXfTi27iVWxwFqQ5569l
        VO8R0VIntJC2fe43VmUMpjBpycaz2V0=
X-Google-Smtp-Source: ABdhPJwiEGRHCwKFkaS2+nPPAFGgD7d7vh1t5+UYJntCp3OZEYisn+jd8mbWcXmacXh1gPoPX2FoVw==
X-Received: by 2002:a63:82c7:0:b0:3fc:bcd9:8114 with SMTP id w190-20020a6382c7000000b003fcbcd98114mr15525207pgd.112.1654411403320;
        Sat, 04 Jun 2022 23:43:23 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id s5-20020a170902ea0500b001638a171558sm8336350plg.202.2022.06.04.23.43.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:43:23 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 08/12] KVM: X86/MMU: Remove the useless idx from struct kvm_mmu_pages
Date:   Sun,  5 Jun 2022 14:43:38 +0800
Message-Id: <20220605064342.309219-9-jiangshanlai@gmail.com>
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

The value is only set but never really used.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 65a2f4a2ce25..dc159db46b34 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1745,13 +1745,11 @@ static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
 struct kvm_mmu_pages {
 	struct mmu_page_and_offset {
 		struct kvm_mmu_page *sp;
-		unsigned int idx;
 	} page[KVM_PAGE_ARRAY_NR];
 	unsigned int nr;
 };
 
-static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
-			 int idx)
+static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp)
 {
 	int i;
 
@@ -1761,7 +1759,6 @@ static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
 				return 0;
 
 	pvec->page[pvec->nr].sp = sp;
-	pvec->page[pvec->nr].idx = idx;
 	pvec->nr++;
 	return (pvec->nr == KVM_PAGE_ARRAY_NR);
 }
@@ -1790,7 +1787,7 @@ static int __mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
 		child = to_shadow_page(ent & PT64_BASE_ADDR_MASK);
 
 		if (child->unsync_children) {
-			if (mmu_pages_add(pvec, child, i))
+			if (mmu_pages_add(pvec, child))
 				return -ENOSPC;
 
 			ret = __mmu_unsync_walk_and_clear(child, pvec);
@@ -1808,7 +1805,7 @@ static int __mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
 		clear_unsync_child_bit(sp, i);
 		if (child->unsync) {
 			nr_unsync_leaf++;
-			if (mmu_pages_add(pvec, child, i))
+			if (mmu_pages_add(pvec, child))
 				return -ENOSPC;
 		}
 	}
@@ -1816,8 +1813,6 @@ static int __mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
 	return nr_unsync_leaf;
 }
 
-#define INVALID_INDEX (-1)
-
 static int mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
 			   struct kvm_mmu_pages *pvec)
 {
@@ -1825,7 +1820,7 @@ static int mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
 	if (!sp->unsync_children)
 		return 0;
 
-	mmu_pages_add(pvec, sp, INVALID_INDEX);
+	mmu_pages_add(pvec, sp);
 	return __mmu_unsync_walk_and_clear(sp, pvec);
 }
 
@@ -1926,8 +1921,6 @@ static int mmu_pages_first(struct kvm_mmu_pages *pvec)
 	if (pvec->nr == 0)
 		return 0;
 
-	WARN_ON(pvec->page[0].idx != INVALID_INDEX);
-
 	sp = pvec->page[0].sp;
 	level = sp->role.level;
 	WARN_ON(level == PG_LEVEL_4K);
-- 
2.19.1.6.gb485710b

