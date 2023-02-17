Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D8369A678
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 09:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjBQICw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 03:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBQICv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 03:02:51 -0500
Received: from smtp.smtpout.orange.fr (smtp-16.smtpout.orange.fr [80.12.242.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39565DE3B
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 00:01:58 -0800 (PST)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id SvggpHzY6ReC5Svghp1MLD; Fri, 17 Feb 2023 09:01:47 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 17 Feb 2023 09:01:47 +0100
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kvm@vger.kernel.org
Subject: [PATCH] KVM: Reorder fields in 'struct kvm_mmu_memory_cache'
Date:   Fri, 17 Feb 2023 09:01:38 +0100
Message-Id: <f9423a6ee10d91bd6bad32beefd1b96cad4d28f1.1676620879.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Group some variables based on their sizes to reduce hole and avoid padding.
On x86_64, this shrinks the size from 40 to 32 bytes.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Using pahole

Before:
======
struct kvm_mmu_memory_cache {
	int                        nobjs;                /*     0     4 */
	gfp_t                      gfp_zero;             /*     4     4 */
	gfp_t                      gfp_custom;           /*     8     4 */

	/* XXX 4 bytes hole, try to pack */

	struct kmem_cache *        kmem_cache;           /*    16     8 */
	int                        capacity;             /*    24     4 */

	/* XXX 4 bytes hole, try to pack */

	void * *                   objects;              /*    32     8 */

	/* size: 40, cachelines: 1, members: 6 */
	/* sum members: 32, holes: 2, sum holes: 8 */
	/* last cacheline: 40 bytes */
};
---
 include/linux/kvm_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 2728d49bbdf6..76af8425dbc6 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -94,8 +94,8 @@ struct kvm_mmu_memory_cache {
 	int nobjs;
 	gfp_t gfp_zero;
 	gfp_t gfp_custom;
-	struct kmem_cache *kmem_cache;
 	int capacity;
+	struct kmem_cache *kmem_cache;
 	void **objects;
 };
 #endif
-- 
2.34.1

