Return-Path: <kvm+bounces-4910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4770B819A66
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 09:26:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C83C1C21181
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 08:26:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D2D01D53D;
	Wed, 20 Dec 2023 08:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LBe2sSQn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2083.outbound.protection.outlook.com [40.107.212.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FFE1D528
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 08:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXyc4Q+WlfzajXPIgV2Pqwh+AYo/IQ7PhFFo25lPie3c+S+1qfN4a0BxbOcwfi2eEAi635Gx+Gm5MKAKVfMQQJFKXedfmkXs7F9tULKcQdUm+nIhtPyhrycNaHBqOsRUgZ/cl55JTzhw9WVrGvXFKl5hYKM7SlJfFWKAxDupYIkvOQvtXDgf5yZB79XtXgVI7OUQiDC+yhsTH9mFhg2F/nTOvtHG34qBl2hsFR8thsI99pU4R9a6o5rAZLsod1F8jP7faaR3n3e3QeSuD/tdA6LXYa/pKlDAPYwlyfd4xEt0Uj2Ln7H8LqHIYflipwAvxc/Cvp7UkmGqERwpM2vjAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R4BXFObIHHjUGDOQQORBMYx/uJWGh251hZMEyFgD9jc=;
 b=BhZ+EcQR5AZMo7n2lp9itzwGh9OohVeUhWuq/8a1avhWV2P9YWWEuvapBLA40aozTkqFkEjWARrIT31WNS4+k9t26rqRgtTvXaakCBC618QJ7fxxcwR6o7qtu9UJT1Bj1+X/ffZoI6/Qfc8Z1Wecc+G/ZE9WJV6BIj70z6JPfW64IYdXbN62rF4ib8Kx48lXkN8SUs1IWNzQR6qS9Jdzs/UVwQR9oKaTMbYKv1knq9QXPDd+qZEe7PBA4K5/WSLDxhiudRtivxFSnaBxzio49q4T7g2Y0BgXOUdHqyPN5AT8o/iutghSctNfKfk6PyfNip8A4I9953MUCJlZ5xwglQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R4BXFObIHHjUGDOQQORBMYx/uJWGh251hZMEyFgD9jc=;
 b=LBe2sSQned0j6OFEfOzfMJg1wBgjhMhnVOfXnfwWxhvvZmlI2h91S166jIFhHFSouT3FVibM1NzkazVHOJuMQTOmhJz5nYSjw6fDVtx9lofhW0yShvWkvu6l/mJMRibQfrdZWyD9T7+ETm1LuMy3ht8Y7lNPYQg4K7SYzcX9kuwul2MbXTDhkIq0ZWZLPTnJpi2p1hMv+SsoWfhlgzMb7aGc2KUcn//kkUAs+tXmA3sKJnxfSEratu9MC+HGay3OkeMTGoccefYZYhaSAsrt5oLgUmcszAs1T0wLFh1zF+7EMf6Pt/9fr+flHVOu2aI6kCtHNrEj9z0xAaX+4SXkOw==
Received: from CH5P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1ef::19)
 by DM6PR12MB4564.namprd12.prod.outlook.com (2603:10b6:5:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 08:25:46 +0000
Received: from SA2PEPF00001506.namprd04.prod.outlook.com
 (2603:10b6:610:1ef:cafe::3b) by CH5P220CA0021.outlook.office365.com
 (2603:10b6:610:1ef::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Wed, 20 Dec 2023 08:25:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00001506.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 08:25:46 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 20 Dec
 2023 00:25:34 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 20 Dec
 2023 00:25:34 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Wed, 20 Dec
 2023 00:25:32 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <mst@redhat.com>, <sfr@canb.auug.org.au>,
	<yishaih@nvidia.com>
Subject: [PATCH vfio] vfio/virtio: Declare virtiovf_pci_aer_reset_done() static
Date: Wed, 20 Dec 2023 10:24:56 +0200
Message-ID: <20231220082456.241973-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001506:EE_|DM6PR12MB4564:EE_
X-MS-Office365-Filtering-Correlation-Id: aeb98a83-50d2-4571-b05c-08dc013543fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4u0lsVkv81jPHwUBJhUmPqaHifhWOmg6492m33hgfka+ido61e6EPImaKoo+LMs8e6OJ9aKSfazISq+ayZxIC64pnNoQD1duolZ+wftCyPKypn/lVEfo+nU9bWvVb/fmFo4wk+c+N99d4J3px8w4P8Pz8qNHfBbNAGF3MqO7g5SHy7L6YDDbR0PEHHhKNQxKQt46NC9rCeOwMBh69eqdGr1JdRCI3D0gUj/qZlA/w4gr8WjRHXBOd0UKId5iLb1FDy8nXT1h9COZgpL4CFYL/5PuyBJKMWI6OFy111jMGssuvmPtlSyBs+WOicX9RgAwtNbBvTfq6E00ik0lnNpXY7RSAuCBmhKD+/mqi+NKH4iDG5yHJsK2mp2UgkHt15xpybCsscRyi0rezjEpBTv88n3Z2mgkt/tqEiBJvUUAtVj13TggwGdGOq9mQ8h9NMBTelq8CyS2l0XEz5MMGdtEr6VxxiJN70XTOX/QxGaNmsGeBWClqfZFcbfNSZCzAPEpcGbt/zj34yrlkugwNEGxNwmW3k5mzafAmax6HiIPYRbM18kMdhXk0e9Q2p6XLAIXZqjGaPXh5u/Dq31hU90/lCUHVcs1Oe5IrZGWz9+6iOmSVQU7Bfu5CWjm6n9t1ASdxWr6dPzFfbiDIpF3+IKL10bMAhmJN3sXJmS9U4MFQ5ZHujK+QItJEQ3b6mnA5RXruQWk3HDfjOZyqU2oWxK5IGiD7SdQLEooF961M+gFJsYRa16jbOFFSPAkytmzy0Pl1tg06wF6DAGuBxT0J6Z1jDYrQ8ZN7bllcXb+rygHtsJgajEWeJjmZrmFCJGxeP2E
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(396003)(39860400002)(230173577357003)(230273577357003)(230922051799003)(1800799012)(451199024)(82310400011)(186009)(64100799003)(46966006)(40470700004)(36840700001)(7636003)(356005)(82740400003)(7696005)(41300700001)(86362001)(36860700001)(26005)(36756003)(83380400001)(336012)(426003)(47076005)(2616005)(107886003)(1076003)(5660300002)(2906002)(8936002)(8676002)(4326008)(6916009)(316002)(70206006)(70586007)(54906003)(478600001)(40480700001)(966005)(40460700003)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 08:25:46.3889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aeb98a83-50d2-4571-b05c-08dc013543fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001506.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4564

Declare virtiovf_pci_aer_reset_done() as a static function to prevent
the below build warning.

"warning: no previous prototype for 'virtiovf_pci_aer_reset_done'
[-Wmissing-prototypes]"

Fixes: eb61eca0e8c3 ("vfio/virtio: Introduce a vfio driver over virtio devices")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/lkml/20231220143122.63337669@canb.auug.org.au/
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/virtio/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
index 291c55b641f1..d5af683837d3 100644
--- a/drivers/vfio/pci/virtio/main.c
+++ b/drivers/vfio/pci/virtio/main.c
@@ -547,7 +547,7 @@ static const struct pci_device_id virtiovf_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
 
-void virtiovf_pci_aer_reset_done(struct pci_dev *pdev)
+static void virtiovf_pci_aer_reset_done(struct pci_dev *pdev)
 {
 	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
 
-- 
2.27.0


