Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016C34E7F3F
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 07:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiCZGEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Mar 2022 02:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiCZGEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Mar 2022 02:04:09 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A66CDF4BF
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 23:02:32 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KQSzG0cCnzcbDR;
        Sat, 26 Mar 2022 14:02:18 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 14:02:30 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 14:02:29 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <alex.williamson@redhat.com>
CC:     <pbonzini@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <arei.gonglei@huawei.com>,
        <huangzhichao@huawei.com>, <yechuan@huawei.com>,
        Longpeng <longpeng2@huawei.com>
Subject: [PATCH v6 0/5] optimize the downtime for vfio migration
Date:   Sat, 26 Mar 2022 14:02:21 +0800
Message-ID: <20220326060226.1892-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

Hi guys,
 
In vfio migration resume phase, the cost would increase if the
vfio device has more unmasked vectors. We try to optimize it in
this series.
 
You can see the commit message in PATCH 6 for details.
 
Patch 1-3 are simple cleanups and fixup.
Patch 4 are the preparations for the optimization.
Patch 5 optimizes the vfio msix setup path.

v5: https://lore.kernel.org/all/20211103081657.1945-1-longpeng2@huawei.com/T/

Change v5->v6:
 - remove the Patch 4("kvm: irqchip: extract kvm_irqchip_add_deferred_msi_route")
    of v5, and use KVMRouteChange API instead. [Paolo, Longpeng]

Changes v4->v5:
 - setup the notifier and irqfd in the same function to makes
   the code neater.    [Alex]

Changes v3->v4:
 - fix several typos and grammatical errors [Alex]
 - remove the patches that fix and clean the MSIX common part
   from this series [Alex]
 - Patch 6:
    - use vector->use directly and fill it with -1 on error
      paths [Alex]
    - add comment before enable deferring to commit [Alex]
    - move the code that do_use/release on vector 0 into an
      "else" branch [Alex]
    - introduce vfio_prepare_kvm_msi_virq_batch() that enables
      the 'defer_kvm_irq_routing' flag [Alex]
    - introduce vfio_commit_kvm_msi_virq_batch() that clears the
      'defer_kvm_irq_routing' flag and does further work [Alex]

Changes v2->v3:
 - fix two errors [Longpeng]

Changes v1->v2:
 - fix several typos and grammatical errors [Alex, Philippe]
 - split fixups and cleanups into separate patches  [Alex, Philippe]
 - introduce kvm_irqchip_add_deferred_msi_route to
   minimize code changes    [Alex]
 - enable the optimization in msi setup path    [Alex]

Longpeng (Mike) (5):
  vfio: simplify the conditional statements in vfio_msi_enable
  vfio: move re-enabling INTX out of the common helper
  vfio: simplify the failure path in vfio_msi_enable
  Revert "vfio: Avoid disabling and enabling vectors repeatedly in VFIO
    migration"
  vfio: defer to commit kvm irq routing when enable msi/msix

 hw/vfio/pci.c | 183 +++++++++++++++++++++++++++++++-------------------
 hw/vfio/pci.h |   2 +
 2 files changed, 115 insertions(+), 70 deletions(-)

-- 
2.23.0

