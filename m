Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2433D0063
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhGTQ7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 12:59:01 -0400
Received: from mail-bn8nam11on2042.outbound.protection.outlook.com ([40.107.236.42]:51968
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232210AbhGTQ6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 12:58:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zb2d6jYiZjpJlf4kGV/oETrVVxV7d2VnQpzDFBL43T1fWhlIkBnfLLyKkTqBqqcd8Qc8sxcEoZrTtHt2nDMCykZfnIX3/XvpNDh0tETCyyQ2V+aO1OBtBZUD77axAXiPFOp7x6mrSRc+Cd5dXoYjK1ydW7TdofPRl5gafAC+mPd4bvuyrGwWvnwN+bL+6//OaJSgorrN/caR9ZcMwLnLgaQxmp8bjImCydy9ae6TBLIyivSywEQ4eu0qrSx63Hb+AQGloExu3FkXe8xYRpEWeRI+inv6RJC6xX9bpMoiFoedtEW+Y169xcNdQRFxDRuNKMisZJsHqDfHok2HFLg8Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0duJnZDLgHYC4eZkqV8uhw67GbyE7WkxFrqEBYQFElg=;
 b=Uts1DzCBDQ2oi8BfRaZhPrhjZbDmNN3XcQlMfuHOcMoPnxsv+5hyCQwUkL4zLUyqM24spnmb5EgpMZ66bD0mn7nqMKAn3IuBbKveFiJvw5KfmFhyBieGlXonu3gTCA0l3MiRnfU3CzTZPhq0a6Ju3encak1CiKHbbzFWIFlWpFUpxGAsMdvsnBBhigXb0TJ2vSpJAsuuZNLZk+px8lFSPvRJPCb6OMIdpVgukG9aNjG5LhUGWhzcgNOzrZKA/B6DyQ58wt79b2xepgETvFrdLkQhGCBCDSFIfC8dr6qupaycDMZBD+EbOBxcPyHVsg2MIxiSZxXzQE5gSG6o5+i4IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0duJnZDLgHYC4eZkqV8uhw67GbyE7WkxFrqEBYQFElg=;
 b=IL8yeE4Izb6Pugdb1MAWGSNKrdQsNBflBP986Hn9OvQUMSjXRRg9iZBYQHmBXoGFJw3FoxN3zVetLUaV5CnZUn1nQivrP5LAQeUaYGipuDWsJ9uvKrHe7JsFdgXX0xiZsbgcx+8G6VgtjMQu5laZ1aiy+4nSEQFJ7YC9DNgH+UmSmH40QnfHF3UEkinVC18fcf3qVD+FKue/568ULbf9xCGifUzfEHrBeeNCoNM0OHPmmuGzVYFTdlbaGSt2OzJKCe8/IHwvC+hdltcEBmsTZc46xxHU9OznAO8qGwL0azCydQvQDdcZkWNXAWdSQ/JniF9CO1Z1kK6Vw40gaHxOBA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5335.namprd12.prod.outlook.com (2603:10b6:208:317::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.31; Tue, 20 Jul
 2021 17:39:14 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 17:39:13 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH] vfio_pci_core: Make vfio_pci_regops->rw() return ssize_t
Date:   Tue, 20 Jul 2021 14:39:12 -0300
Message-Id: <0-v1-cfc4743f1f6e+fefd-vfio_rw_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0047.namprd20.prod.outlook.com
 (2603:10b6:208:235::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR20CA0047.namprd20.prod.outlook.com (2603:10b6:208:235::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Tue, 20 Jul 2021 17:39:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m5ti4-00515v-On; Tue, 20 Jul 2021 14:39:12 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60e126ab-b241-4a77-e804-08d94ba54a3e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5335:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5335A3F999D85C7776B515F6C2E29@BL1PR12MB5335.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UgigfTW5bcEUvBPYZmvOoTF8xLJbdg+IhPsvj6klKKG+G+099EYHM33kmbkWDvokQndI1pdCFVh69tExB4NFkxoxHtAM5bM0aSw6dGgIU5CkGRL+ntQFN2IxYQYLgoIsJutLlfUvLfTesEJqiuk50pel9KvkAgYpetkBiT5OC+MGWepx1d2IFM/4cvtyUH1Lm3EDCUIhzHQOZ76/6EdORA/aJhoVeFK5NQXLWquRDbwQ53Xnlsk11JfYTEiEHPJhLNTwUce1XziUEwP11UAavnzU61wd7HCnP+rUBI1mMw4+Cylb4xOqn19mp+4w0IzF8082WeuvXKHBEzqWuOVxhA2eztQypvoAjYNWLDI2tMGrMHzoGaye/yO7/jz4M0kpKJOq+vV2f/wxGY+5N81NHjTqc4QheYgY+cPDkCYUziEBYr87M3WKK/AIldpoSmJC/U6XPv0CgXjKPz9HF34MqHDvt9UxzQws2iAnwXy7aotHYsVjvY3/W+sX+nrR9QuJE3TTQ3bgNQZM0uHE6f4ch3uI7SHHJaJEqj/ny2oafcT+WaVzZc8dR+719X0HAC5hwHQn5fDHLq2CK89MJkjp/oK5cb0rW9pYU4mJhK8XaEX5DwA2xta6JFY6xJd8vIGQFskThOVx/3vXLndh1HcFgTlLio26xRN04XENWvQm+/1NPtmMbY3oPb/BFSB7+CLG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(366004)(136003)(376002)(83380400001)(9746002)(9786002)(2616005)(316002)(54906003)(86362001)(2906002)(426003)(8676002)(478600001)(38100700002)(66946007)(186003)(4326008)(5660300002)(8936002)(66476007)(36756003)(66556008)(26005)(107886003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hWMHYkYXYfsGYIBNoJX/PgbSbbuWCGvgaJ3TWfL8is3gRD65WbKVdy9iXl86?=
 =?us-ascii?Q?L2bI0ipxnZDrym/qk0ys500reh8JJi/HW+XSO5b5flzffjqaw23GKEjbiB4s?=
 =?us-ascii?Q?uzGTw0kPyKxRVcTU7uYTLBm1C/X5Cs40lDrnk7oFpimBzDkSFd0s7yZ1oNtb?=
 =?us-ascii?Q?g/xGs7af1vAaajiilIHv80f3sew8exq7lqgF+2d4TRVwf9YJ2QgW8Hou3L0y?=
 =?us-ascii?Q?60wQm1HF7Br3b8iq/x25jnmiqN1WomMBx0nIxGj3HdTvZpPaV9QD2TCypWKU?=
 =?us-ascii?Q?A5DEKCTOKAXOcJlugLRuP4Xh7RLv+iTqu41ybe0QCyx4avwwiXbQ6iQ6Cx9B?=
 =?us-ascii?Q?sPq5AD+ARZ5oRK1f9O5YWCNhBdSTXgFp29D13h2SfnTIJvihKO8iTaJH+cvn?=
 =?us-ascii?Q?p4y8LRXELBxBURZFSnYlGD2vw4kUu/EGyJHZ9+qQ0M/A6GPg7SWETuxVh2DO?=
 =?us-ascii?Q?Wqa+4ThxubaxcAQOw2owor4AEkFG1Yqeh+jUOaM+WLRg4Wyh8YJeJ/agyP0y?=
 =?us-ascii?Q?7a2LXFrOt6fngjd8xXn4WOScLJxj/ux7IfIazqNT7MtO1VkjBwgSR7GY4kbT?=
 =?us-ascii?Q?xc/J83pKYAokxljz8Ju266VTNc92i8d2XO5pi05Z9MYXMT89HlX/3GmE5NLE?=
 =?us-ascii?Q?+992XUYpYHyXkTnHuAy3Iq2Qq1if5VWk71YYuRW/aSWtZUEkRF4VmzxPx5V+?=
 =?us-ascii?Q?A6tqWLwT4s+WtUZMfm8SbD9TuP2eVB9Xjfa79c1DrF552F6S2cf1KGANMJVF?=
 =?us-ascii?Q?SI8o08q2onpIvVJ8aq1kWBgST930B2iuEkV1uj+6qSJr31VtPgt3vmqwihGt?=
 =?us-ascii?Q?amiLKdbTv88K1014xxayzO6Rbszr9704mIKcjp50dTXGf0kuGC0EoiapteQ/?=
 =?us-ascii?Q?P7kLbbWWi4mOyEGBx/UCF2Bp70CP5f/F1arzAEJLbwxwcS3YoCMWs8PRO39h?=
 =?us-ascii?Q?4dPxC65+I7GnbbW9ZOMgQBQEI/E4u/UMqXinAdRfbYgBllr46VaQZ/Su+2H4?=
 =?us-ascii?Q?ojbjywsyZRMtg4XwY0wR7uuYOByxaQIjz93vcwI/MmGsc5NKaVEtcSlxN/d6?=
 =?us-ascii?Q?+YnwlnuqV/WiiW6PkUBE/ojU9U4eAuf+rH0bVdb7Z0iZ/q08PQb5tA13Vq0T?=
 =?us-ascii?Q?Ly8zzkRl+aoEMe5GMQ1wyqFDDeUaEiEdNozVv4yU1cfpYPMIE4f3ZcN0xAMS?=
 =?us-ascii?Q?a8Olpc2LKIpoKsBWUxm+rcd64PuYZHnRnCYdWoQitB30tLscFTQ8xR882Wx7?=
 =?us-ascii?Q?OMkeGdx4RVERZpDbenvOCND64MxcmfBNK1uNrC6dGRk1lNkLB206dTP6znod?=
 =?us-ascii?Q?7ifgYjjD6cB/IIOPSNMviMvo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e126ab-b241-4a77-e804-08d94ba54a3e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 17:39:13.8632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PGYkFDBuSlEL3J+gd6U5hdTucJlyW/DbTxiFFpvPl0y9IZKatWAq4wHPVL1wKGh5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5335
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

The only implementation of this in IGD returns a -ERRNO which is
implicitly cast through a size_t and then casted again and returned as a
ssize_t in vfio_pci_rw().

Fix the vfio_pci_regops->rw() return type to be ssize_t so all is
consistent.

Fixes: 28541d41c9e0 ("vfio/pci: Add infrastructure for additional device specific regions")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_igd.c | 10 +++++-----
 include/linux/vfio_pci_core.h   |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index f04774cd3a7ff0..8d07f0fc365c21 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -25,8 +25,8 @@
 #define OPREGION_RVDS		0x3c2
 #define OPREGION_VERSION	0x16
 
-static size_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev, char __user *buf,
-			      size_t count, loff_t *ppos, bool iswrite)
+static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev, char __user *buf,
+			       size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
 	void *base = vdev->region[i].data;
@@ -160,9 +160,9 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_core_device *vdev)
 	return ret;
 }
 
-static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_core_device *vdev,
-				  char __user *buf, size_t count, loff_t *ppos,
-				  bool iswrite)
+static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_core_device *vdev,
+				   char __user *buf, size_t count, loff_t *ppos,
+				   bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
 	struct pci_dev *pdev = vdev->region[i].data;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 0a51836e002e1e..fb5add3bded0ac 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -57,7 +57,7 @@ struct vfio_pci_core_device;
 struct vfio_pci_region;
 
 struct vfio_pci_regops {
-	size_t	(*rw)(struct vfio_pci_core_device *vdev, char __user *buf,
+	ssize_t	(*rw)(struct vfio_pci_core_device *vdev, char __user *buf,
 		      size_t count, loff_t *ppos, bool iswrite);
 	void	(*release)(struct vfio_pci_core_device *vdev,
 			   struct vfio_pci_region *region);
-- 
2.32.0

