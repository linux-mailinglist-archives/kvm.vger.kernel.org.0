Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3889372B06
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 11:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfGXJEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 05:04:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2747 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726070AbfGXJEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 05:04:43 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 74AC1F6E4DA912F3682E;
        Wed, 24 Jul 2019 17:04:40 +0800 (CST)
Received: from localhost (10.177.19.122) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Jul 2019
 17:04:38 +0800
From:   Xiangyou Xie <xiexiangyou@huawei.com>
To:     <marc.zyngier@arm.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [PATCH 0/3] KVM: arm/arm64: Optimize lpi translation cache performance
Date:   Wed, 24 Jul 2019 17:04:34 +0800
Message-ID: <20190724090437.49952-1-xiexiangyou@huawei.com>
X-Mailer: git-send-email 2.10.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.19.122]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patches are based on Marc Zyngier's branch
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/its-translation-cache

As follows:
(1) Introduce multiple LPI translation caches to reduce concurrency
(2) Removed the unnecessary vgic_its_invalidate_cache()
(3) Introduced vgic_cpu->pending and vgic_cpu->lowest, reducing
    vgic_cpu.ap_list_lock competition

Best Regards,

Xiangyou

Xiangyou Xie (3):
  KVM: arm/arm64: vgic-its: Introduce multiple LPI translation caches
  KVM: arm/arm64: vgic-its: Do not execute invalidate MSI-LPI
    translation cache on movi command
  KVM: arm/arm64: vgic: introduce vgic_cpu pending status and
    lowest_priority

 include/kvm/arm_vgic.h        |  18 +++-
 virt/kvm/arm/vgic/vgic-init.c |   6 +-
 virt/kvm/arm/vgic/vgic-its.c  | 201 ++++++++++++++++++++++++------------------
 virt/kvm/arm/vgic/vgic.c      |  40 +++++----
 4 files changed, 160 insertions(+), 105 deletions(-)

-- 
1.8.3.1


