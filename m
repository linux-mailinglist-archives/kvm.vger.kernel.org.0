Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED9253DA70
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350732AbiFEGno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350752AbiFEGnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:43:21 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A4F48385;
        Sat,  4 Jun 2022 23:43:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so10203131pjq.2;
        Sat, 04 Jun 2022 23:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3lxuLS0NpiGO7M36E+oogOCuogXON8W2SkzS8j5kybs=;
        b=XJlSc8NRBTEnI8sPXD8yAeACQTeC35dnUtyusLLS7xfFzb4pkFk0BX5AmG/C/NS/AL
         I10lc3HAJ5nIZbHw/qoFDTKLmgfrKl4RV/g6r9XYd8Nlv7BM1eQmdZAUsZLJdmF9F4QV
         YEgycj+XYsuYt9HYfslib5+bjd4f63jhpdhDkffPMeTchXx4EbhJFw4pNSQBaaTvvG2s
         BC0MJUzkfpK2fHIvKkmzcBApQly8eGYGWrDAt/kfSn1nK7PEp0mWUrbVuy15NqP+bfBE
         H0aKyimr+LK3GCVX7ELTnv+Q5RPVgG03ttoxPjuXGHPeKBhhcDkeMy0v5Y0itJoVj8hw
         ru0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3lxuLS0NpiGO7M36E+oogOCuogXON8W2SkzS8j5kybs=;
        b=KrcZMYqs829pavZOe4USQpBK8Li20PJ0UX5bqpvmMeQfp7rQHwYfZ/AePpJzCJPZDj
         okCWMf42unbpL6npdoRdSlMFp11fJBiD0uWEMB0jSQxmBPL7xBx1sCysZ3x/L4CX2h0T
         NdGECpjnRTDVFGS0DMOSBf1ksHcKxfRnPs6q5UueeCUb1htywh9uD1Daz+9HDA+/e5tB
         wFvi73EfwIFtICQKvlfGuxVbRdVjOCto7nhdlxT/Y2ia+PDsRh/BqjNTLUo3xgUUziho
         2hn2hiPWnbdRLQeGpdoiiKwKpLmUNrrgeWq2EOygPnSorNA6jxLtL2TP24xLInYioMB+
         r6VQ==
X-Gm-Message-State: AOAM530ho2uwiNGRhh5cggX9xuQRvrt/rLonIREH0QoxVPHngSWH01F7
        jeKJAEnia2fc3RMx3jxOrkTyPItKQ2E=
X-Google-Smtp-Source: ABdhPJx/6+hlNAYkDtSpXwGcllbn9DasPqXSNG4KS0bFyet3zPTbEti/NOcfMsS3yI0nzfuBu7m97w==
X-Received: by 2002:a17:902:ccc8:b0:162:6ea:4d with SMTP id z8-20020a170902ccc800b0016206ea004dmr18186514ple.144.1654411395415;
        Sat, 04 Jun 2022 23:43:15 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902eecc00b0015e8d4eb29esm8176746plb.232.2022.06.04.23.43.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:43:15 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 06/12] KVM: X86/MMU: Rename mmu_unsync_walk() to mmu_unsync_walk_and_clear()
Date:   Sun,  5 Jun 2022 14:43:36 +0800
Message-Id: <20220605064342.309219-7-jiangshanlai@gmail.com>
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

mmu_unsync_walk() and __mmu_unsync_walk() requires the caller to clear
unsync for the shadow pages in the resulted pvec by synching them or
zapping them.

All callers does so.

Otherwise mmu_unsync_walk() and __mmu_unsync_walk() can't work because
they always walk from the beginning.

And mmu_unsync_walk() and __mmu_unsync_walk() directly clear unsync bits
now, rename it.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2446ede0b7b9..a56d328365e4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1773,7 +1773,7 @@ static inline void clear_unsync_child_bit(struct kvm_mmu_page *sp, int idx)
 	__clear_bit(idx, sp->unsync_child_bitmap);
 }
 
-static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
+static int __mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
 			   struct kvm_mmu_pages *pvec)
 {
 	int i, ret, nr_unsync_leaf = 0;
@@ -1793,7 +1793,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 			if (mmu_pages_add(pvec, child, i))
 				return -ENOSPC;
 
-			ret = __mmu_unsync_walk(child, pvec);
+			ret = __mmu_unsync_walk_and_clear(child, pvec);
 			if (ret < 0)
 				return ret;
 			nr_unsync_leaf += ret;
@@ -1818,7 +1818,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 
 #define INVALID_INDEX (-1)
 
-static int mmu_unsync_walk(struct kvm_mmu_page *sp,
+static int mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
 			   struct kvm_mmu_pages *pvec)
 {
 	pvec->nr = 0;
@@ -1826,7 +1826,7 @@ static int mmu_unsync_walk(struct kvm_mmu_page *sp,
 		return 0;
 
 	mmu_pages_add(pvec, sp, INVALID_INDEX);
-	return __mmu_unsync_walk(sp, pvec);
+	return __mmu_unsync_walk_and_clear(sp, pvec);
 }
 
 static void kvm_mmu_page_clear_unsync(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -1962,7 +1962,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 	LIST_HEAD(invalid_list);
 	bool flush = false;
 
-	while (mmu_unsync_walk(parent, &pages)) {
+	while (mmu_unsync_walk_and_clear(parent, &pages)) {
 		bool protected = false;
 
 		for_each_sp(pages, sp, parents, i)
@@ -2279,7 +2279,7 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 	if (parent->role.level == PG_LEVEL_4K)
 		return 0;
 
-	while (mmu_unsync_walk(parent, &pages)) {
+	while (mmu_unsync_walk_and_clear(parent, &pages)) {
 		struct kvm_mmu_page *sp;
 
 		for_each_sp(pages, sp, parents, i) {
-- 
2.19.1.6.gb485710b

