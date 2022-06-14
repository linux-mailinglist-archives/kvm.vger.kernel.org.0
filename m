Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F0C54AD71
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 11:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241587AbiFNJei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 05:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiFNJeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 05:34:36 -0400
X-Greylist: delayed 122 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Jun 2022 02:34:32 PDT
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C2D369D8;
        Tue, 14 Jun 2022 02:34:32 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id JHV00124;
        Tue, 14 Jun 2022 17:32:24 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201602.home.langchao.com (10.100.2.2) with Microsoft SMTP Server id
 15.1.2308.27; Tue, 14 Jun 2022 17:32:25 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] KVM: Use consistent type for return value of kvm_mmu_memory_cache_nr_free_objects()
Date:   Tue, 14 Jun 2022 05:32:22 -0400
Message-ID: <20220614093222.25387-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   202261417322409c0f72d9200304032c44b936001c900
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The return value type of the function rmap_can_add() is "bool", and it will
returns the result of the function kvm_mmu_memory_cache_nr_free_objects().
So we should change the return value type of
kvm_mmu_memory_cache_nr_free_objects() to "bool".

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c20f2d55840c..a399a7485795 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1358,7 +1358,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
-int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
+bool kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
 void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a67e996cbf7f..2872569e3580 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -394,9 +394,9 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 	return 0;
 }
 
-int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
+bool kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 {
-	return mc->nobjs;
+	return !!mc->nobjs;
 }
 
 void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
-- 
2.27.0

