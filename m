Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3494F52E4F1
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 08:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345806AbiETGZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 02:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiETGZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 02:25:27 -0400
X-Greylist: delayed 907 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 23:25:25 PDT
Received: from mail-m973.mail.163.com (mail-m973.mail.163.com [123.126.97.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04ABA14C765;
        Thu, 19 May 2022 23:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=EDLaB
        jALBZshwxMN5oSHQMdP+5yMRSPM50LnskauBiI=; b=ZLThMmtfDaLxrmpAqjeXi
        QH3+pNFbEKqCDU4f3pgmMJeYX5ijiaoqUaYPpxQ/dFMltEmFc6XgtnJZ2Q821gWS
        ZHiFdmA6OSJpOmEgkvq/s4PxFrwxj+yFLqY11xzzxeKj0gsuoTOrygVLVPsgSglq
        8evm833vcpAuKq2UhL5Ggs=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by smtp3 (Coremail) with SMTP id G9xpCgA3TJyqMIdizyGuDg--.28397S2;
        Fri, 20 May 2022 14:09:47 +0800 (CST)
From:   Yun Lu <luyun_611@163.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: optimizing the code in mmu_try_to_unsync_pages
Date:   Fri, 20 May 2022 14:09:07 +0800
Message-Id: <20220520060907.863136-1-luyun_611@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgA3TJyqMIdizyGuDg--.28397S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw1DXFWxAF18trWfKr43GFg_yoW8GrW7pr
        ZrGrsIyr45GrsIq3s7Cw4kC347uws7KF48GryUWas8Zwn7K3s3ta4rKw4ftrs3XrWrGr1a
        va1ruF43WF18Jw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UJ8nrUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: pox130jbwriqqrwthudrp/1tbiMgwHzlWBzeFtBQAAsn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need to check can_unsync and prefetch in the loop
every time, just move this check before the loop.

Signed-off-by: Yun Lu <luyun@kylinos.cn>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 311e4e1d7870..e51e7735adca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2534,6 +2534,12 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
 		return -EPERM;
 
+	if (!can_unsync)
+		return -EPERM;
+
+	if (prefetch)
+		return -EEXIST;
+
 	/*
 	 * The page is not write-tracked, mark existing shadow pages unsync
 	 * unless KVM is synchronizing an unsync SP (can_unsync = false).  In
@@ -2541,15 +2547,9 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 	 * allowing shadow pages to become unsync (writable by the guest).
 	 */
 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
-		if (!can_unsync)
-			return -EPERM;
-
 		if (sp->unsync)
 			continue;
 
-		if (prefetch)
-			return -EEXIST;
-
 		/*
 		 * TDP MMU page faults require an additional spinlock as they
 		 * run with mmu_lock held for read, not write, and the unsync
-- 
2.25.1


No virus found
		Checked by Hillstone Network AntiVirus

