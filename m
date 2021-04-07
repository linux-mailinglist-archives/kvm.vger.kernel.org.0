Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B529356BCA
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 14:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352008AbhDGMJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 08:09:52 -0400
Received: from mail-dm6nam10on2061.outbound.protection.outlook.com ([40.107.93.61]:33952
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235268AbhDGMJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 08:09:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxxoBuyTwJOuHATdM+7HqOUlOW1LECbVSQHOWu+xFVQzYTtF89wDcWCRruNhddOIvv5ucpOU3BP8xFMpzt6L2yk434z/YgLeoX/1HsEMoYJhnrryq8gdE2Zll666/wZfh5aXPmjEQ51T3r7/2Wb/mrZKELfr3WxDR4dkMZj6ImCmVm1VaQf4CfSzgDzOcQgnodg6UE8FTlNzHZ12NGnk2fGD5p6MFJyFR4XYaOyUTigPU19M0PAG18CrybCM9gdxK9jlMUk1I08O9zaU4td8SNh6h65Qv5aLgap96NHas2dw4VBR5bQWyMk1I8aINQ/Fi6hZ1RMdzF97ffEwwKBDpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amHnrLvTvWjsynprryF/7TQPxzXdsSUM7yMqWphDQTs=;
 b=lEW2EqL8RBPy6gAbIkeA5VerDuuU7xdZDxRB+kp68NleA/YWZjHJzix2yDsK5rZkC30PE/2KVgCuDJI0z73fEZqEWyfzKs+pB0tJNptMcCxLpCxdQpjjRbix1fC2RLjCl2xLR5JgbmpmgJR8j7NHjCspdBTEO7SOWgRWchHf51MqtWIOjnZNCDTRKX6py1FSXT6Ygy/abQfway3/0Woe9d+llF6Dmm2+xKXPcy4OHBR6JIbH5CRz9EmoybUFVmnQqZDMEQIvNjS3ODaavCUOTaOPO1gPZwUftMeO1+4UzgF4BoNMIhYKQ9cUwPDFPa0X1pqBVG2CoQw9SXyFnehk8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amHnrLvTvWjsynprryF/7TQPxzXdsSUM7yMqWphDQTs=;
 b=b5PyGbzNXVRIW/YlViiwT4Zogwnp83mLxZ7g18t66E1fgmPRUgMrGLuU9nkPvqrScugksAIrE5TphFCJhuf4daQbpJPJhDj3frgn0wyvJtm2ALFHw+DnRsoDM7wJj5joHBlGKXDoaV7OF85GpQ39li9APkk+57frIHmoueUUSvpo60r/sLJejOlX+ZpNfF7d3EJZThW40nqahuMbDlxO6sjhIAtunnnmj0iuh+IES6yJ5NzIODjjqOuxHmiqfKv1RbedGgHYamKyF+PnKj+gYdCOKtPQJrkp1TkvQr5tVXe7NuyVeDwFY2jwb7MwnyCPTidZJAfClKaV0G58mek+Wg==
Received: from MW4PR03CA0140.namprd03.prod.outlook.com (2603:10b6:303:8c::25)
 by BN6PR1201MB2480.namprd12.prod.outlook.com (2603:10b6:404:b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Wed, 7 Apr
 2021 12:09:32 +0000
Received: from CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::ee) by MW4PR03CA0140.outlook.office365.com
 (2603:10b6:303:8c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Wed, 7 Apr 2021 12:09:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT025.mail.protection.outlook.com (10.13.175.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 12:09:32 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 12:09:31 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 12:09:29 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <mst@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>
CC:     <oren@nvidia.com>, <nitzanc@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 3/3] virtio_pci: add module param for reset_timeout
Date:   Wed, 7 Apr 2021 12:09:24 +0000
Message-ID: <20210407120924.133294-3-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210407120924.133294-1-mgurtovoy@nvidia.com>
References: <20210407120924.133294-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf624763-f36e-4851-7413-08d8f9be0094
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2480:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2480B95685E51CC990315753DE759@BN6PR1201MB2480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EzURaMStfhttVJIAopiXAvQauRS/pXOYV/hxUufEDb8j/PFDX/oxBUz7PeiiT9KvYJvMxKRW3GSzH3qJYIvI2i+B4P41KHMRK3RVSA7lopV7hig0JMe8X4cVCYhjzpC/qSPUX0s+2HboYDVUaGWmp3UR8SX7OzV24+nyLosAKPSRcl6Mqceu72nSE4eC7w3MGHqL6lReIvHnnUFnjRR7FQeJXvGAd5k9nJXRADIYedRg3hMCpZgHMn3y4ZPCqKh1Wv3UmH7NLjFA44F1eYCgMLQMa9PPPvDLyEAsWCj8Ev8PQZMWP4Jrgr8eFSOd/ANnvfxmTITAPgu5QzcyWeoUWXqpvNwuQnWT0JlnLjxbnRsx3y4Cm/UzsojU76EuhgbsZzVChBuM1ZLmlsuEsnrcdveXdYNWhRNbaDWFo6itDX1FWLoKUWVf/RfWNybbu6Qy7svxPdmi5xNjf8G106hq9Cl3ib5ib5caEAoLH3X8E6WERcNCGCdKOlAcQog2HxPQ5OnKxqH+Au+M9CaeaBWHEh74a6ms80OYPHJ0V4JrIpD0Un5xVFTYjxS7WhSn1XiZ5UNzh0KntUHe0hFUxOPnBB+ofjvKqUwfStq8QHI/ZQjWhL5zGLpDltV7KGTyaIb2sI6zg40S6Of5RTam3JFsG4ynM7sAfgfchuOkEnICbVM=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(36840700001)(46966006)(26005)(356005)(36756003)(2906002)(426003)(7636003)(6666004)(70586007)(110136005)(4326008)(336012)(82310400003)(186003)(70206006)(1076003)(86362001)(54906003)(36860700001)(316002)(36906005)(82740400003)(47076005)(83380400001)(478600001)(2616005)(5660300002)(8936002)(8676002)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 12:09:32.0777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf624763-f36e-4851-7413-08d8f9be0094
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2480
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable the user to set the time for waiting for successful reset by the
virtio controller. Set the default to 180 seconds.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/virtio/virtio_pci_common.c | 5 +++++
 drivers/virtio/virtio_pci_common.h | 2 ++
 drivers/virtio/virtio_pci_modern.c | 3 ++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 222d630c41fc..3a4c57839ed8 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -24,6 +24,11 @@ MODULE_PARM_DESC(force_legacy,
 		 "Force legacy mode for transitional virtio 1 devices");
 #endif
 
+unsigned int reset_timeout = 180;
+module_param_named(reset_timeout, reset_timeout, uint, 0644);
+MODULE_PARM_DESC(reset_timeout,
+		 "timeout in seconds for reset virtio device operation");
+
 /* wait for pending irq handlers */
 void vp_synchronize_vectors(struct virtio_device *vdev)
 {
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index beec047a8f8d..4760cdf74961 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -29,6 +29,8 @@
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 
+extern unsigned int reset_timeout;
+
 struct virtio_pci_vq_info {
 	/* the actual virtqueue */
 	struct virtqueue *vq;
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index dcee616e8d21..811fc1719d8c 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -162,7 +162,8 @@ static int vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
-	unsigned long timeout = jiffies + msecs_to_jiffies(180000);
+	unsigned long timeout = jiffies +
+		msecs_to_jiffies(reset_timeout * 1000);
 
 	/* 0 status means a reset. */
 	vp_modern_set_status(mdev, 0);
-- 
2.25.4

