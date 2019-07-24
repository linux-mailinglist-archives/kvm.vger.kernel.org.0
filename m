Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 050A872B0C
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 11:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfGXJEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 05:04:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58566 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726741AbfGXJEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 05:04:52 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 430EAFC4DDA07AF281AB;
        Wed, 24 Jul 2019 17:04:46 +0800 (CST)
Received: from localhost (10.177.19.122) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Jul 2019
 17:04:41 +0800
From:   Xiangyou Xie <xiexiangyou@huawei.com>
To:     <marc.zyngier@arm.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [PATCH 2/3] KVM: arm/arm64: vgic-its: Do not execute invalidate MSI-LPI translation cache on movi command
Date:   Wed, 24 Jul 2019 17:04:36 +0800
Message-ID: <20190724090437.49952-3-xiexiangyou@huawei.com>
X-Mailer: git-send-email 2.10.0.windows.1
In-Reply-To: <20190724090437.49952-1-xiexiangyou@huawei.com>
References: <20190724090437.49952-1-xiexiangyou@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.19.122]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is not necessary to invalidate the lpi translation cache when the
virtual machine executes the movi instruction to adjust the affinity of
the interrupt. Irqbalance will adjust the interrupt affinity in a short
period of time to achieve the purpose of interrupting load balancing,
but this does not affect the contents of the lpi translation cache.

Signed-off-by: Xiangyou Xie <xiexiangyou@huawei.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 792d90b..66e93ab 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -907,8 +907,6 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	ite->collection = collection;
 	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
-	vgic_its_invalidate_cache(kvm);
-
 	return update_affinity(ite->irq, vcpu);
 }
 
-- 
1.8.3.1


