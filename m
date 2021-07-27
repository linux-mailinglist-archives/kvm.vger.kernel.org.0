Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8D23D6CA8
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 05:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbhG0CoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 22:44:22 -0400
Received: from mx21.baidu.com ([220.181.3.85]:54774 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234588AbhG0CoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 22:44:21 -0400
Received: from BC-Mail-Ex26.internal.baidu.com (unknown [172.31.51.20])
        by Forcepoint Email with ESMTPS id 6EC72F514E7116C36CA5;
        Tue, 27 Jul 2021 11:24:41 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex26.internal.baidu.com (172.31.51.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 27 Jul 2021 11:24:41 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 27 Jul 2021 11:24:40 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <zhenyuw@linux.intel.com>, <swee.yee.fonn@intel.com>,
        <hkallweit1@gmail.com>, <fred.gao@intel.com>,
        <mjrosato@linux.ibm.com>, <jgg@ziepe.ca>, <yi.l.liu@intel.com>,
        <mgurtovoy@nvidia.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] vfio/pci: use "ssize_t" as a return value instead of "size_t"
Date:   Tue, 27 Jul 2021 11:24:33 +0800
Message-ID: <20210727032433.457-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex09.internal.baidu.com (10.127.64.32) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

should use ssize_t when it returns error code and size_t

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/vfio/pci/vfio_pci_igd.c     | 4 ++--
 drivers/vfio/pci/vfio_pci_private.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 228df565e9bc..3377ba379bfd 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -25,7 +25,7 @@
 #define OPREGION_RVDS		0x3c2
 #define OPREGION_VERSION	0x16
 
-static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
+static ssize_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
 			      size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
@@ -160,7 +160,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
 	return ret;
 }
 
-static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
+static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
 				  char __user *buf, size_t count, loff_t *ppos,
 				  bool iswrite)
 {
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 5a36272cecbf..bbc56c857ef0 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -56,7 +56,7 @@ struct vfio_pci_device;
 struct vfio_pci_region;
 
 struct vfio_pci_regops {
-	size_t	(*rw)(struct vfio_pci_device *vdev, char __user *buf,
+	ssize_t	(*rw)(struct vfio_pci_device *vdev, char __user *buf,
 		      size_t count, loff_t *ppos, bool iswrite);
 	void	(*release)(struct vfio_pci_device *vdev,
 			   struct vfio_pci_region *region);
-- 
2.25.1

