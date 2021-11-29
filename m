Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13E2460D9D
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 04:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376894AbhK2Dsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 22:48:52 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27308 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376900AbhK2Dqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 22:46:50 -0500
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J2WR20spjzbj8L;
        Mon, 29 Nov 2021 11:43:26 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 11:43:31 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 11:43:31 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <pbonzini@redhat.com>
CC:     <cornelia.huck@de.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arei.gonglei@huawei.com>,
        Longpeng <longpeng2@huawei.com>
Subject: [PATCH] kvm/eventfd: fix the misleading comment in kvm_irqfd_assign
Date:   Mon, 29 Nov 2021 11:43:28 +0800
Message-ID: <20211129034328.1604-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

The comment above the invocation of vfs_poll() is misleading, move
it to the right place.

Fixes: 684a0b719ddb ("KVM: eventfd: Fix lock order inversion")
Signed-off-by: Longpeng <longpeng2@huawei.com>
---
 virt/kvm/eventfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2ad013b..cd01814 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -406,12 +406,12 @@ bool __attribute__((weak)) kvm_arch_irqfd_route_changed(
 
 	spin_unlock_irq(&kvm->irqfds.lock);
 
+	events = vfs_poll(f.file, &irqfd->pt);
+
 	/*
 	 * Check if there was an event already pending on the eventfd
 	 * before we registered, and trigger it as if we didn't miss it.
 	 */
-	events = vfs_poll(f.file, &irqfd->pt);
-
 	if (events & EPOLLIN)
 		schedule_work(&irqfd->inject);
 
-- 
1.8.3.1

