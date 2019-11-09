Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C55A2F5E00
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2019 09:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfKIIIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Nov 2019 03:08:12 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:42444 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbfKIIIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Nov 2019 03:08:12 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B6BAE3EF9E53F500D491;
        Sat,  9 Nov 2019 16:08:10 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sat, 9 Nov 2019
 16:08:00 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: MMIO: get rid of odd out_err label in kvm_coalesced_mmio_init
Date:   Sat, 9 Nov 2019 16:08:20 +0800
Message-ID: <1573286900-19041-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

The out_err label and var ret is unnecessary, clean them up.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 virt/kvm/coalesced_mmio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 8ffd07e2a160..00c747dbc82e 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -110,14 +110,11 @@ static const struct kvm_io_device_ops coalesced_mmio_ops = {
 int kvm_coalesced_mmio_init(struct kvm *kvm)
 {
 	struct page *page;
-	int ret;
 
-	ret = -ENOMEM;
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page)
-		goto out_err;
+		return -ENOMEM;
 
-	ret = 0;
 	kvm->coalesced_mmio_ring = page_address(page);
 
 	/*
@@ -128,8 +125,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	spin_lock_init(&kvm->ring_lock);
 	INIT_LIST_HEAD(&kvm->coalesced_zones);
 
-out_err:
-	return ret;
+	return 0;
 }
 
 void kvm_coalesced_mmio_free(struct kvm *kvm)
-- 
2.19.1

