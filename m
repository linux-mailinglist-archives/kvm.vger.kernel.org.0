Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FED755DEFA
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244552AbiF1IDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 04:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243816AbiF1ICd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 04:02:33 -0400
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A8362CDE4;
        Tue, 28 Jun 2022 01:02:32 -0700 (PDT)
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 91B8A80191;
        Tue, 28 Jun 2022 04:02:29 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH kernel] KVM: PPC: Do not warn when userspace asked for too big TCE table
Date:   Tue, 28 Jun 2022 18:02:28 +1000
Message-Id: <20220628080228.1508847-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM manages emulated TCE tables for guest LIOBNs by a two level table
which maps up to 128TiB with 16MB IOMMU pages (enabled in QEMU by default)
and MAX_ORDER=11 (the kernel's default). Note that the last level of
the table is allocated when actual TCE is updated.

However these tables are created via ioctl() on kvmfd and the userspace
can trigger WARN_ON_ONCE_GFP(order >= MAX_ORDER, gfp) in mm/page_alloc.c
and flood dmesg.

This adds __GFP_NOWARN.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

We could probably switch to vmalloc() to allow even bigger
emulated tables which we do not really want the userspace
to create though.

---
 arch/powerpc/kvm/book3s_64_vio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index d6589c4fe889..40864373ef87 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -307,7 +307,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 		return ret;
 
 	ret = -ENOMEM;
-	stt = kzalloc(struct_size(stt, pages, npages), GFP_KERNEL);
+	stt = kzalloc(struct_size(stt, pages, npages), GFP_KERNEL | __GFP_NOWARN);
 	if (!stt)
 		goto fail_acct;
 
-- 
2.30.2

