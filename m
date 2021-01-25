Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48053020E3
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 04:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbhAYD6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Jan 2021 22:58:30 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11855 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbhAYD63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Jan 2021 22:58:29 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DPGJK3ZDJz7Z5S;
        Mon, 25 Jan 2021 11:56:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 25 Jan 2021 11:57:41 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>
Subject: [PATCH] KVM: X86: use vzalloc() instead of vmalloc/memset
Date:   Mon, 25 Jan 2021 11:57:25 +0800
Message-ID: <1611547045-13669-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

fixed the following warning：
/virt/kvm/dirty_ring.c:70:20-27: WARNING: vzalloc should be used for
ring -> dirty_gfns, instead of vmalloc/memset.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 virt/kvm/dirty_ring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 9d01299..790f173 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -67,10 +67,9 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
 
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size)
 {
-	ring->dirty_gfns = vmalloc(size);
+	ring->dirty_gfns = vzalloc(size);
 	if (!ring->dirty_gfns)
 		return -ENOMEM;
-	memset(ring->dirty_gfns, 0, size);
 
 	ring->size = size / sizeof(struct kvm_dirty_gfn);
 	ring->soft_limit = ring->size - kvm_dirty_ring_get_rsvd_entries();
-- 
2.7.4

