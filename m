Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEED381AAB
	for <lists+kvm@lfdr.de>; Sat, 15 May 2021 21:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbhEOTKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 May 2021 15:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbhEOTKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 May 2021 15:10:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3DDC061573;
        Sat, 15 May 2021 12:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=pOAXp/hARmNfIeDbR6g75usgQPdXixVcFAZ7QXoop+M=; b=dqkaPuuLQteMf+jPfC0ZXbRxG5
        IQyj7LffrKjDHTFYQaAqR9fzqQBXCTjECVH9MqsOSqIIbGvtNy3A3oHDgyOQT/jK5/oVyOn42K//R
        4NxbuJDmHT0TtCal31ulNTUz9ndzZytg85bQb+n53VlxsrrHgH2xhG36khk+BhZ1775g3juBNRavT
        ns9eGWacFIGsbKz9MYxLO8g6uoB+oTNNmIqM0k1ezzJGUuq5MNUKrZmqYXSDOCJq12vBGmYP0vwcY
        JzdGn2DwxhMl7U3/OrCYqb3o/+iuW1WzAsJrdymiNmJ+Lm5Lk3tQD67jAAoDEbEhBy9kaMbHuGhvP
        JM+TBeaQ==;
Received: from [2601:1c0:6280:3f0::7376] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lhzej-00Cegg-CS; Sat, 15 May 2021 19:08:57 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH] vfio/pci: zap_vma_ptes() needs MMU
Date:   Sat, 15 May 2021 12:08:56 -0700
Message-Id: <20210515190856.2130-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

zap_vma_ptes() is only available when CONFIG_MMU is set/enabled.
Without CONFIG_MMU, vfio_pci.o has build errors, so make
VFIO_PCI depend on MMU.

riscv64-linux-ld: drivers/vfio/pci/vfio_pci.o: in function `vfio_pci_mmap_open':
vfio_pci.c:(.text+0x1ec): undefined reference to `zap_vma_ptes'
riscv64-linux-ld: drivers/vfio/pci/vfio_pci.o: in function `.L0 ':
vfio_pci.c:(.text+0x165c): undefined reference to `zap_vma_ptes'

Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/pci/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20210514.orig/drivers/vfio/pci/Kconfig
+++ linux-next-20210514/drivers/vfio/pci/Kconfig
@@ -2,6 +2,7 @@
 config VFIO_PCI
 	tristate "VFIO support for PCI devices"
 	depends on VFIO && PCI && EVENTFD
+	depends on MMU
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
 	help
