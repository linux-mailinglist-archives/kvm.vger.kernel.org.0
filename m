Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C393464B8
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbhCWQPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:38 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:23521
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233160AbhCWQPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z52PHsgJzG3x6+CfYWi40CRKRts017QGfl7/yN+3NX87lEUJ2CBFwylR3sBcGynuuM6MHyzU2/qkH51dJq5WVcqABBp3d2hN6rbsqJjdlkHOqgIMnkxxZ2pREmTPRlPq3/JwD1EC0QBiIEPT1bWPdBRRO/XouX/bP1fjJJ4cYn5S4V2IeBIswdh9OYbNcjLMWnMvqwToHCnvxukn2g1otB6QntFjEOYds3py7lgJo9NNNm9mDh92puhrq+seKOoCK7Sm3b+WuwY2nlFjWl6JJohR+bX92XkXjJhIDPc2qQhadwYzwM0lsAoCJVVBKzSaOpNaSJ6aKCw6DgunEO54/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2BanRvYR4t26i+rEGhgJk449Df38w0eRIF5brcGOgw=;
 b=SkWuusn+T/w/9pJLDvvzn6H9eNjITpJ9fDmEGmu3MwRLKCP6KPQbrWgsiXcxoAK1G+QvWTD+oIKPgAqxe0a2EarRYxYD8O/Ny0unTy2UqdUCKyQB8QqnI9MMev8YCDptrO8Ntlj6QVfvDtI1wIzwXnITaOgQjvDLKwrfaSl3I70/ijaY1LRQLyZLR2KNiPz1IDx1qFryXZF4JutIXfwvmMQ9Q4Gyyh/ou3IVKIk53IwAkAVF3zUUejP0EfUUKMMcelCaoAi+GmWIM3ZOHF5pljHENsN9m7V8VL+lhIKnA21DfVk8HzOJG94tqzOjtC4LCQV35yj7BM8SQ2rfrgXo2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2BanRvYR4t26i+rEGhgJk449Df38w0eRIF5brcGOgw=;
 b=bLrzS4J/SbSkoTkZcwNSdPBT7eU6TAoPg2S0/zdh8ssg1M1cjJ1e8xXWMmXgqX6wmDmrnaFPHFYFrKKY8KRP9NIGLVQaeExY9HBQyXAamOBoR4DzbjAhYsiQGuUq2FIcIRQRPbaPJGnhcdHofpCvlY+SpBmzHrm6iQpl+8lb52oHcdTtkCBtBT93i7TcojbulRK1y8mzS/o2T/ZTnztlc6Bjmq4beSx8SrlTmfznY/1H9spFOnZwr80PNK7SDyyAzbM1B60Cx8WupdHfM8d2GLrNZXxFGYrMzPV0N0z2z/0k2mytXLnVxdSPkN/WLDaKl8tqGi1LTl99nGBdLd2xYg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 16:15:14 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:14 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v3 08/14] vfio/pci: Re-order vfio_pci_probe()
Date:   Tue, 23 Mar 2021 13:15:00 -0300
Message-Id: <8-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0263.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::28) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0263.namprd13.prod.outlook.com (2603:10b6:208:2ba::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Tue, 23 Mar 2021 16:15:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aCs-Lm; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6e89361-8dc2-43f9-4c2d-08d8ee16d4e8
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4267F45A0EE76364F72EE7ECC2649@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IPMnzQstqp889iR2OJEMWugmOzfARrDC2ne565ivS6/Sf/+4OTjYCjM0GYM96Og0KE/dScFAH1Mdp0QRDThZhELLl82o77V8sE/tfAtgAr7BS4A7Hq87yr+m1xrCkMN4DjJrmHwdSXiFmvWf+iG2Djxz70kse4gLt26MgFz0h+BQAOQObABUxXeYdgNRZuCiYx2oVrNmG2Jw0jyGCeYvVYs9CpSL1PHMi6DF0M80M8HlPTCALQpwTUpw4NxTTBce0SZBzwHcct66TUIcXrZguUnBisI6QqCCPg+bhWQiBBTe6ir/AGJmRY8FtkM8clJ4MRxNlqeJZjjUvZVNdczh1pI2lAO3lkLf4gmdj5JjBZWk2/BrTvHK16f+i9OjAW0DYXc7o1hB7T8eBqHvuuXpcAvibiv2NgId97KOaDYmYIyMVNdV6GKGeQ522HRozbvXzG3PgTdYi6Kz0sL8VDdb8HcPijQyO9xj2HU9nTJ6K5jOXbhe1MAeU6eLTPd0qFIaVRXXhwwa/PUT3m2NkfNo9hdeRdF3RRP78u4QdL0KhJfWLOZkz1AmxMsrJou5WunyypsDunXY8thpVjgNG4elWAmWfQnjtXl9KUvanKO62sv7cusqd1j6nveM9YXrPYAH+G9ibO2VfOBrcRM+gwXZ6QvpUt/AZhcDrdaLSzUDGZO/W+cZ2d372UGMApaMGnNGFDQw9tqtOH+iCxldLE1nNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(5660300002)(6916009)(66476007)(2616005)(66946007)(66556008)(2906002)(186003)(7416002)(6666004)(83380400001)(426003)(54906003)(316002)(8936002)(478600001)(8676002)(107886003)(4326008)(26005)(9746002)(9786002)(86362001)(36756003)(38100700001)(4216001)(169823001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6mYNiA8AVrP7bHnHkbdrOj1XMOHXicBmd4klqs9TmBJJ9DETzI6x4JiIou5w?=
 =?us-ascii?Q?fqKnhUjS5Qt2IbiRmBKKX4mRD3mIl31GluEGWwED2vXgk16tPucsWxOlp+jG?=
 =?us-ascii?Q?G76GRtkNA7x9NO1iTqksbQNGjFH9mV0drsYWRjp+7JvLT1wJCA1whS4n+Dgb?=
 =?us-ascii?Q?nyedGSUQp1ZE6hXEWdH7CXLBnXbeDfKHZ3GgMSXGB+yLpmliD3QLBWs1zj83?=
 =?us-ascii?Q?fV9pLoAYwf/qDBiRCNsJtrn6zR/MLKSkMFz11KgNGt+NzTU5SO/28bQ4uQA2?=
 =?us-ascii?Q?ObacHTIZzpj/xO7Mz+O0JPeZwG0Khk5s+VBKx3FDPPqU4s48b2BHJWbivCJ2?=
 =?us-ascii?Q?3O+Q4Xz9gHLc3Kpukm9zWcbUAmKR+rDnyD9xBeAGars3Dkfj93vaLPMZE+l8?=
 =?us-ascii?Q?Cd0zR1qoAGrdTT/P/aJNywkiZB8jbWc0q8nMxuVbXrHWgT97Qle0qJOL+1wG?=
 =?us-ascii?Q?5MYa2R5QKwT/CJDmIdmNgFXlGF1kuraIYgSKAM2JLT8tSvvv2RF5r4qJHsBP?=
 =?us-ascii?Q?1c2cUC8XSChRbT9hONfT1xwSiZKFxgTG+1MHZQORC3yWuxtpitLSADE9rJbJ?=
 =?us-ascii?Q?66F3JRcqy+G9pGmgxXK0G0DPUL5Uo4Z1imdggoOOZZt74dxXawh58iB6bfxD?=
 =?us-ascii?Q?YUvuWuffUyavsu8Fg1NMcv2xO8xfaqsr10uK4DUtKOOu99ioiAlIGBUyDh2z?=
 =?us-ascii?Q?1Z2Ek7c4wkjNOHNkgiZJi8r9MJ/Htq4D2Im+WIqxEhPArb+oZR2q+l0i2Ngu?=
 =?us-ascii?Q?YRXblN1UOS3wFPrF3p5/2+PGeOWSrbb/xWfoYyDe8nPxivr/VPyAgg30rN1S?=
 =?us-ascii?Q?OQoiUCSkr9900LEWWAxW0k9jn3jrSvtQX518RObKuvv1lvSj5jzTnaIBBJsI?=
 =?us-ascii?Q?mQq3S9jOptel2xtptnFdwF2vJ7XL8OykrGBC3FVgr8WsetxllyNmAUl9Ssta?=
 =?us-ascii?Q?d73YH6rL6SKAJWwf32U6vYzXwAfP1of+WACa32+Kmus1HSQPCp0M1MNS6fUF?=
 =?us-ascii?Q?Fvmtmkrk66H+hPhdpr41rZt0B8nNiCNDouLYt+ZUTMZFnIoGKes/q0K76KwE?=
 =?us-ascii?Q?I8VALFj76GmAVK/KcK4gWDe8RJuABcfAD5wIH07j4JGU9pMl06vRmZmCuHcP?=
 =?us-ascii?Q?B1f90JrZ2p9LfllWpJuT+FURm2+wX9hTb6htxqVaIWwRQus6nuhVL+SJ1b5k?=
 =?us-ascii?Q?THzACUsYgUCkoQ1TVUyyoEFdof+pRUzsFA+63O0VeoxMKXTz0VMdi0RudVhl?=
 =?us-ascii?Q?T3azI4cUJE84dBPLHhUIpmDDt/oJTL5tN1JsHrjLwt2Q54Bz0cyZiI5600on?=
 =?us-ascii?Q?AgYjtuVmDJN0fyFNId30jQep?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e89361-8dc2-43f9-4c2d-08d8ee16d4e8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:10.2889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PbaOCZqCezSYxY904xzsPR/sH2X6FYs65tAXbE9Dqpl+PvAXTfoq+HzPKB/1BcQN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_add_group_dev() must be called only after all of the private data in
vdev is fully setup and ready, otherwise there could be races with user
space instantiating a device file descriptor and starting to call ops.

For instance vfio_pci_reflck_attach() sets vdev->reflck and
vfio_pci_open(), called by fops open, unconditionally derefs it, which
will crash if things get out of order.

Fixes: cc20d7999000 ("vfio/pci: Introduce VF token")
Fixes: e309df5b0c9e ("vfio/pci: Parallelize device open and release")
Fixes: 6eb7018705de ("vfio-pci: Move idle devices to D3hot power state")
Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f95b58376156a0..0e7682e7a0b478 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -2030,13 +2030,9 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
 
-	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
-	if (ret)
-		goto out_free;
-
 	ret = vfio_pci_reflck_attach(vdev);
 	if (ret)
-		goto out_del_group_dev;
+		goto out_free;
 	ret = vfio_pci_vf_init(vdev);
 	if (ret)
 		goto out_reflck;
@@ -2060,15 +2056,20 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 	}
 
-	return ret;
+	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	if (ret)
+		goto out_power;
+	return 0;
 
+out_power:
+	if (!disable_idle_d3)
+		vfio_pci_set_power_state(vdev, PCI_D0);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
 out_reflck:
 	vfio_pci_reflck_put(vdev->reflck);
-out_del_group_dev:
-	vfio_del_group_dev(&pdev->dev);
 out_free:
+	kfree(vdev->pm_save);
 	kfree(vdev);
 out_group_put:
 	vfio_iommu_group_put(group, &pdev->dev);
-- 
2.31.0

