Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA8C339A9A
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhCMA4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:56:33 -0500
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:30549
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232230AbhCMA4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:56:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeKE+c+tgUHXN7ZG39YRM470qeojjmEBf8itzvYT04FxF2TJpFXD5oUjP7QUVWcu91ulOUrluEGuIWhViS8i50nJ3A8EMMlnnupwgJ9mkXNvXE1445DtToQITBc0mAvXuQc7sV5ipkPKof8knH3HxoeIvyqDZJlLQHwQHmeK3lPcHZ/fxgvCh2EKpjtoAVXy9xld88X040+zdnxV9m55ZxaMf6wGzMPRDKTyFJnty5rdwtNU9bLm3wtqOB9z6hdLgIemL2Ne9d9mIDubIXds+0GEzqydWWJcWYyZShGUYek4TmxaoU+TkFoZXygkBa7YOanCEBMoc6hVBV3anLNw3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcykNrb4Yt+GfO112hOfgT7lczlqZVZMbt7s7dHujVE=;
 b=Faf4fssPk2AtmOQKvRbo6LdvFuGmmtWlqLFu6tNZyc0vakPH+SNF3LwZBjd/k90ssepZ+88n0wv3QgbXxrUGqR/UC3gOj/hMJmpMhqvzYDa1XfQfLiv/6Hu2uAtLri0+Sd52oFsck0Ixyem4SFZkZwDEfI343NTV5uByA8d0yvhndGxvqTxe4t11Efo/kd/c11w/ThDCLkh64Y+CGZlcjAFKVfgeOTxcGYWUxGZhyBxSnjR47ghG5HxtTTL7sag265xByBV0HZnsLtmVTYTb2MR0eFV+IzLaK1lwy2Y9U3c367JmhRK7d1WzV/n02CKzR+tEn5KLIS6em2AykvBFwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcykNrb4Yt+GfO112hOfgT7lczlqZVZMbt7s7dHujVE=;
 b=mSHrBngrVnIYOYnq7EL3OsJKJQzj2bc2MV2VNSgPTrDAW8tFplvyJYuVg0XbIjL2EEHixjyYXsCFYEQN035hczPe8KSyeXGxFZULTjUSY/IsgsvGIAHvYQcuMbDaEizsTajDLUnCEjZgoEkDvCY1YDuwbHqdfS2p52SGxJ0l77DXrF8uv+J4lF01SiNZRj+hC+tuvpf3StAWJ4mlBmZa3KYzP8JTzL/5XjEZ8Pj6qCIppy/u7KSHoxB+o5pkTVpah1I6DCQMad/SVCIp2F5Lf2ocI4UUnkDi4L5D046uKrBVLsIlX4aV20gASQeY19a/ZMVoUiNNztUmPjHNMZnTmA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Sat, 13 Mar
 2021 00:56:14 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 00:56:14 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v2 09/14] vfio/pci: Use vfio_init/register/unregister_group_dev
Date:   Fri, 12 Mar 2021 20:56:01 -0400
Message-Id: <9-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:208:32e::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0134.namprd03.prod.outlook.com (2603:10b6:208:32e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Sat, 13 Mar 2021 00:56:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZb-00EMBH-4a; Fri, 12 Mar 2021 20:56:07 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69b34586-c2d7-4b38-2759-08d8e5bacb4e
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2940479DDA55D3067BC0FEFDC26E9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 31PLhg0QhOSF5v5PRIFFWiqN9Tyojk7Zg+5iX1Yz1TbdEW8SpHwft/KG3IgYqelHKGhk2tAw78t12Ztn8wAoBxTVr0/R/hDfcYFvgXM6hJJiRHskw5Ufnre+RemS949u0xEmtbpbQlLhyF34aKKmmWwt1s6HOrRe5WIaj2gGJEauBg8dE8VGmdGfGNg52v/65Qv2B1YxnCeigFwX5XxGRDRea0QAadPpjRK/TIZteBKdcc5/P34nk2HtoMfOUKKNmQHfVb/l5yvA3dUkUem1dpCP0wD9dTQmKsT+GPnTt5RH3UHzf69fIKT+Lzikxavi21mldsSgMhXU99nQPbuccEO1y0UR3+fFGeHVsZ+/wtfejhB0k46sfQxXzfACcNH2NUEtUPxHqV5F8Z1cX7Kedy2G3upBEIgTyaC2wS+fv79jZdPJwF6Vser/iAUBNy2PQne0rGHaslkMcmJ7NTACef2kgxavDfU5FfILlsAw+mG9rgH//YY0sLHFNNEeMoEkrZLbRgv5pDmPzKVdN4/2Gi7w/3jTFibkd3bO/bqgjC9yEO5OVYppI6KGxJn3uT2YgVPEteNFQ/2JvF1eMy4Rp6BkpKKkPUBmIGy8/ZOFWKo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(9746002)(9786002)(8676002)(6666004)(4326008)(54906003)(8936002)(5660300002)(36756003)(316002)(110136005)(83380400001)(66946007)(66556008)(186003)(26005)(66476007)(478600001)(2906002)(426003)(86362001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O7oHwqZE9qqsOF1oF80+/CabznAE0s9JU1NxWWpMyp5QgRaYrD6eZ9Edrt91?=
 =?us-ascii?Q?GWdmVgMrqoHt0iOeloZq0AmnHa1R+XeO9hRROJJ+X/W+U31hc6IZezaYR5d3?=
 =?us-ascii?Q?VEl3F6QhlvaA8BFdrSX4euWQGuLqOpxAg6mVBC35qww5nY5xiA4xJZSzIUe1?=
 =?us-ascii?Q?caD4LKbAUgb3BzRZp1gKX83tpou99v/61nSwYQW8ePG64uGxQT6qlvoA/rSX?=
 =?us-ascii?Q?SHtkFfsIYmkNxUP37Vmq0Fwq1KKYE2XglhbAbD0wc8yTRhHeosypBiInf9sg?=
 =?us-ascii?Q?OiFvhGR7Nd1eupHj8rk4mbpsFN0Y+bG6w90NkhXA442MQ9cQ4M6KA7zvGyKn?=
 =?us-ascii?Q?+ohqAICdATiYDhC+NZJPwu1RbPoYILfbuzqzAe8Zc+q9MrZaHq9dmYi13e+r?=
 =?us-ascii?Q?SnIN9Z3APQqrQHk2FlAjojOkG4fk2RuFB45WcO9gKYTaP1ZkQStomU9ST4kU?=
 =?us-ascii?Q?FCEeuRH+OVEjiUIGQgb2kQUTDkmg2D9tUsyhHe9mjccPDhZ4Vej2Ziy5dou3?=
 =?us-ascii?Q?Z9wYUsMF7oacAKewzK0PQB5NuWQTMi4+pqRGBZH2gmPaSroUkD8MIxWJV2d+?=
 =?us-ascii?Q?eO4fnJBZTs+6llizLVV2CtPgfJywbS/Q9OCMPBUQw2p2NHg5Da+hwu1aR7ob?=
 =?us-ascii?Q?U6pSnlopP3Jd7XP96Cy86mKzWKthQpC84zcM87Tt5to3gvlOKL4zfU6hEp+G?=
 =?us-ascii?Q?EjLW2I4KlFsMORWvQTN3wHvDUhszZshVwBLWKmDd6CovQLDugTCKaYGnWeW+?=
 =?us-ascii?Q?V8kP5P5u9Vu/FzZTqBZgOiZbT6pl8Ye3VqwLzNQnhTk+jwTj8a6tdOYb6aZa?=
 =?us-ascii?Q?Vwmx+osWreUkL1xrOy1dqeAKuugMbtSna7GJxTBfBg+LTncZUSuF6bmGb8L3?=
 =?us-ascii?Q?vdbzkdcAxQze6S2i9OsC5CwQ9ftXEJTdSqYEhQtmIoeaeKIesX2noQMl3wGO?=
 =?us-ascii?Q?2+LW80AnKdfp93ULWycJ0MwK/OPYKB7e8qGg0dviJNhXayWrHNqbl50+ohTz?=
 =?us-ascii?Q?ln6Wkpt37A8cVnYmMmzK7U1hcCPm5TdzLmKZG1eVKmBDHjZnhdO/utxJTevp?=
 =?us-ascii?Q?XVw6+8tj90NAKQA3Emp19kFr4OHRfmYhJLsn2kAoka3JUcIPunTUOhezLrwh?=
 =?us-ascii?Q?JVgrLNFHKoFszUFHrg312/+YcrBaeB/fRI3QKN/+4av1ts3ee0+Hsjz97Wtv?=
 =?us-ascii?Q?z2QOK6je+CBbVuH96L0eOpmW65Vg5byUFcgI2XHHcbpemi6Lz7NkJASvr/sa?=
 =?us-ascii?Q?mp3tmnMQetAOrpQ1kAXNlFu2AjfjdVLJeQ3yHukqyOLFd+1Qq4fMG/mqgZBy?=
 =?us-ascii?Q?aIC3GB1vQ1uDVhclaHP3+ITL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69b34586-c2d7-4b38-2759-08d8e5bacb4e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:56:11.4157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h/4fB07BRfv7XluDwxw/LWAGTxlW3N8U5gXKd3zW29BxAz6/53w3BY/JeqAUAQhb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pci already allocates a struct vfio_pci_device with exactly the same
lifetime as vfio_device, switch to the new API and embed vfio_device in
vfio_pci_device.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c         | 10 +++++-----
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 0e7682e7a0b478..a0ac20a499cf6c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -2019,6 +2019,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_group_put;
 	}
 
+	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops, vdev);
 	vdev->pdev = pdev;
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
@@ -2056,9 +2057,10 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 	}
 
-	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
 		goto out_power;
+	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_power:
@@ -2078,13 +2080,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static void vfio_pci_remove(struct pci_dev *pdev)
 {
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_device *vdev = dev_get_drvdata(&pdev->dev);
 
 	pci_disable_sriov(pdev);
 
-	vdev = vfio_del_group_dev(&pdev->dev);
-	if (!vdev)
-		return;
+	vfio_unregister_group_dev(&vdev->vdev);
 
 	vfio_pci_vf_uninit(vdev);
 	vfio_pci_reflck_put(vdev->reflck);
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 9cd1882a05af69..8755a0febd054a 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -100,6 +100,7 @@ struct vfio_pci_mmap_vma {
 };
 
 struct vfio_pci_device {
+	struct vfio_device	vdev;
 	struct pci_dev		*pdev;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
 	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
-- 
2.30.2

