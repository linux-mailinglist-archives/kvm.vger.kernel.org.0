Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12F753DA90
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350883AbiFEGoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350858AbiFEGoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:44:01 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8956E4991C;
        Sat,  4 Jun 2022 23:43:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id a10so10434766pju.3;
        Sat, 04 Jun 2022 23:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XmFX5FJYjWQ43Zgix1LgnK1s4hmtFFAjCX8rn0TCV50=;
        b=pi2Lr73UbY5js8cUjD+Th9u3vCul0jEnLzyIoRuCxONsBeaVOgB06fxb7waPakU9BE
         2ZzrdWelecAC3+hn4Mby9jn6XUuupt+KfaqA2qyuI2WEgpD5DotpD/ABjtxepFjjGMBB
         na27DodlJUsh8IzPP5Z4EDO0bwbrzz+TLHxmpXrINvS4iiKBSTnzzHMxIyZDiWs9YJ6b
         YCLrrnDscANGp1OT2uzgeiBmZzoNkJhbcp4181J+kv+ssj2Gh/gRzt2WO49cvJb2xUOC
         3WxPY3Gx28ER2uomYIm5996H4yTxLBaCc24tMVjIYER18Ge1E0KwFc9AKex1TZAdk4ew
         yCBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XmFX5FJYjWQ43Zgix1LgnK1s4hmtFFAjCX8rn0TCV50=;
        b=jWvD3/W30aRWizT+kruRGjR1O3QmN63YlNH2kiL3DTdrk8vM7TYMltz9M5dh3nDnCh
         lP38WbWR2QfLG0PDKt+a3fL7XBj0+/vVoJ+QEQ6qbKgx6vAP6QmDnf+7jgiTfsxt8UWu
         oVaByDJ9QSBUO1gRNYXvxS5zFyDFqTMkP/06iwfwSt4jihJUpv5YapofLz1hG3M6jUmm
         kcSzCqhlAVvIeeNoFPaAgTYqPcpEK6p0jrfsyNZpXOOH0p95qfeQx8T4oQt/EwS7IKcE
         B9GkjiaEQpJA7q+JabIK8rdFw0nQiT3ixeDNzONP2qbtzwDZ7O5BYYUHSB0bqqE8rShN
         yjvg==
X-Gm-Message-State: AOAM533pXPA8Lq0Vk2tcUi8JJ/S5Jb4yrkZnm6y8mS6DQ3Rn40YKuqrT
        1CLue/YDFnjd+LKkjIxf9dgY7h9wva8=
X-Google-Smtp-Source: ABdhPJzxRsiy8SjNjG8fGJcksOwJAI/F/EEjP52FiPNOF81hQFciWs40AKgDDv5b5R8CXcuZoHIkVw==
X-Received: by 2002:a17:903:130d:b0:164:17f5:9de5 with SMTP id iy13-20020a170903130d00b0016417f59de5mr18749719plb.132.1654411418474;
        Sat, 04 Jun 2022 23:43:38 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id i27-20020a056a00005b00b0050dc7628171sm8359144pfk.75.2022.06.04.23.43.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:43:38 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 12/12] KVM: X86/MMU: Rename struct kvm_mmu_pages to struct kvm_mmu_page_vec
Date:   Sun,  5 Jun 2022 14:43:42 +0800
Message-Id: <20220605064342.309219-13-jiangshanlai@gmail.com>
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

It is implemented as a vector and variable names for it are pvec.

Rename it to kvm_mmu_page_vec for better describing it.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7cfc4bc89f60..64e0d155068c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1742,12 +1742,12 @@ static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
 
 #define KVM_PAGE_ARRAY_NR 16
 
-struct kvm_mmu_pages {
+struct kvm_mmu_page_vec {
 	struct kvm_mmu_page *sp[KVM_PAGE_ARRAY_NR];
 	unsigned int nr;
 };
 
-static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp)
+static int mmu_pages_add(struct kvm_mmu_page_vec *pvec, struct kvm_mmu_page *sp)
 {
 	int i;
 
@@ -1768,7 +1768,7 @@ static inline void clear_unsync_child_bit(struct kvm_mmu_page *sp, int idx)
 }
 
 static int __mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
-			   struct kvm_mmu_pages *pvec)
+			   struct kvm_mmu_page_vec *pvec)
 {
 	int i, ret, nr_unsync_leaf = 0;
 
@@ -1808,7 +1808,7 @@ static int __mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
 }
 
 static int mmu_unsync_walk_and_clear(struct kvm_mmu_page *sp,
-			   struct kvm_mmu_pages *pvec)
+			   struct kvm_mmu_page_vec *pvec)
 {
 	pvec->nr = 0;
 	if (!sp->unsync_children)
@@ -1885,7 +1885,7 @@ static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
 }
 
-#define for_each_sp(pvec, sp, i)					\
+#define page_vec_for_each_sp(pvec, sp, i)					\
 		for (i = 0; i < pvec.nr && ({ sp = pvec.sp[i]; 1;}); i++)
 
 static int mmu_sync_children(struct kvm_vcpu *vcpu,
@@ -1893,14 +1893,14 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 {
 	int i;
 	struct kvm_mmu_page *sp;
-	struct kvm_mmu_pages pages;
+	struct kvm_mmu_page_vec pvec;
 	LIST_HEAD(invalid_list);
 	bool flush = false;
 
-	while (mmu_unsync_walk_and_clear(parent, &pages)) {
+	while (mmu_unsync_walk_and_clear(parent, &pvec)) {
 		bool protected = false;
 
-		for_each_sp(pages, sp, i)
+		page_vec_for_each_sp(pvec, sp, i)
 			protected |= kvm_vcpu_write_protect_gfn(vcpu, sp->gfn);
 
 		if (protected) {
@@ -1908,7 +1908,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 			flush = false;
 		}
 
-		for_each_sp(pages, sp, i) {
+		page_vec_for_each_sp(pvec, sp, i) {
 			kvm_mmu_page_clear_unsync(vcpu->kvm, sp);
 			flush |= kvm_sync_page(vcpu, sp, &invalid_list) > 0;
 		}
@@ -2208,15 +2208,15 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 				   struct list_head *invalid_list)
 {
 	int i, zapped = 0;
-	struct kvm_mmu_pages pages;
+	struct kvm_mmu_page_vec pvec;
 
 	if (parent->role.level == PG_LEVEL_4K)
 		return 0;
 
-	while (mmu_unsync_walk_and_clear(parent, &pages)) {
+	while (mmu_unsync_walk_and_clear(parent, &pvec)) {
 		struct kvm_mmu_page *sp;
 
-		for_each_sp(pages, sp, i) {
+		page_vec_for_each_sp(pvec, sp, i) {
 			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
 			zapped++;
 		}
-- 
2.19.1.6.gb485710b

