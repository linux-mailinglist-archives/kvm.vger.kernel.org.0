Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8404C333116
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 22:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhCIVjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 16:39:13 -0500
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:47776
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232047AbhCIVjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 16:39:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ya/U+euTkTXWUyibPqSE2EXLqtQs8adqnCZQKeC3VWTlbPR02NxqgGQb0onLGQvhvINkxvkyfhhXcqX63TP9zbzvu9vtcvXuXBGqV2PtdT3XTkJQUpIeYPAY/vjEjNRdOCEOVhKTDHsTsQdUOjTYeDpJYC+GTIXuZVBSEYoM7nEyxBriQMrbCuGrOmPoMWFQuIJrVeQvuhL7rx0jw6GIKzytXTg/scbSsDttRMnFQjndYl43RMpAdDwl8H1cw0rCDRoq/WD8gueotVKe+Qpm+1YmRMHAffI86rbe4/zfgxmN9aQArp61WuVh4Cc5/N5f11sXCB0Nh81/VdSJtTUFHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QCnuUv9jJ4dH+FM81j7kPIA7zBllj/9wThcH0AZB0OU=;
 b=FrhHV+OmRKvRnSD9JphX25mzxGDA1UuFZ3/6oylHuzrqrV9S2ED5e8q/34nZr3C552TdHjLbTZlFv+g6cBf3lo84qs6oScUgLC8upbQwPsk+JRrI8WiCs2gC9rt0JnMP9h2A3YDwEUiRWtZq7rVEnGxq/YlJcbVhbJeKgYOyAcjComtRGeVCha0/orlvvJC3Txfp+GQc/7LNpydbnAS/nJlg6q3cUi9u7EfBXcHFfGebF6LHcSD79aRAfQXTqoD4k+Hh4/WjgrTmwA4KVN0N13q3BkL3mA+ZiTCgzc7m8zU2v49P0fgW3A0zoGeFoGZj+BEs/KJNhblQ3pCFaSezHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QCnuUv9jJ4dH+FM81j7kPIA7zBllj/9wThcH0AZB0OU=;
 b=dB3hK5q1a9ZZjApxUpKaUqQT9B4LCePdAy95ZgfhRH1yPtdUkpztD4G0l2s1qZWde1+VG6wQRziJwEUhkhLj/qKU1gT4LNa4jhz/Tcr9Fpx3dCwnp4H+/4vETPe7Uvm2w0tlFDOZpSKS4NlXRAkpFwfpvTPfMiUw20ia35fTXgLmxX/aNjfqIIsOt34JRFpsFzymPlxplWVg+JyX1QxgasTpSefi2sNRBraRLHPUqgYXWFSRANeA2hpv96hNuGdO/V0im76otNzq4AtXzHO4pK/rqwlQfwa+elRdYzezAM1jAEWC6oh3y2Ps0BqF5MbWJ5brfiMMNTKxqE+WqX0TLQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1243.namprd12.prod.outlook.com (2603:10b6:3:74::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 21:38:59 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 21:38:59 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 05/10] vfio/pci: Use vfio_init/register/unregister_group_dev
Date:   Tue,  9 Mar 2021 17:38:47 -0400
Message-Id: <5-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR20CA0020.namprd20.prod.outlook.com
 (2603:10b6:208:e8::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0020.namprd20.prod.outlook.com (2603:10b6:208:e8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 21:38:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJk44-00AVIr-RP; Tue, 09 Mar 2021 17:38:52 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e066bd65-7600-47b0-3d97-08d8e343bf0f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1243C36B699248C83072D043C2929@DM5PR12MB1243.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2r0UYsi9s+CTa3xuYsdrNPGfCKzm1e/N9u2psySgDBCwzEJ/dr/J9MwkiQRvbgUV3/byYXKE1JZHy7JlrFU05nin+meWN0NlNMPZDcEHLT9e8/7mKa9f5/GywdkWH0daPhdncl8YqXuTQdmBj1XUdRcWOYGixlFQKQFhdFP3XcswswY89J0vTqw68TiYvj1xjMWNJkPCXma0DU3HXny24GcA9HRnlpP2JYbRzTvYMBfuHiW/XJesKVg/0nRjLBAnmjhGh2WAG2CQ1kxoOlxcq47TPRU3N3FLvrQyDrjS2dLU5GxUcWamuDg6RzAUVUAd1gsrl39OWbWuKedARlKa6EXWDHkngandYatgoRYqWTMqW+prDbQ5LRGIVAcrIxKIQdiAf2IpqY0E5kttgzJ1yjkdgD0Hq2cZX10AFYzbJPgKh7dGSRdGgROtYPNKUAISAP8X3hWQYASbmtz59LK9vAys3Wu77kh17Mg9vozoBY1v4oJAKLelKWkuS5+iWSBvb9Mm4jeZhLcI8bJvmWMdRCZtdFKx9aVYhMhZK1r8mihfk6uut34maTQuTkeXLlsg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(2616005)(83380400001)(426003)(66556008)(9786002)(66476007)(9746002)(107886003)(66946007)(8936002)(186003)(2906002)(86362001)(8676002)(26005)(36756003)(6666004)(54906003)(4326008)(316002)(5660300002)(110136005)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?G3b6wXREGRFhmBv9hVoEs3nmc9DVkgOAh51pcV0jYeesoDoofiNRuPDL3HVw?=
 =?us-ascii?Q?SZr/zijgaSS9jYlSfa/r+fNi7NRPBnNOYrukxO09wdv1KvP9aKAzAsO4wcPX?=
 =?us-ascii?Q?jpoNdyJ3STCZQiCdGJNV4OuBrHBwPIR3MjGT09fm2ewZvlNm0IGr4JFzSQ3o?=
 =?us-ascii?Q?T3LWs83p2YkMOLx9y3ivNboi451b8q0EeXGas4WWt2/DQulhjRT1mVNqHxg7?=
 =?us-ascii?Q?JhOYm3TtogxvFNXAErafPO9LfjV2xSbVTRSl3bTQAr6GUOZXhA8UxqLDzb72?=
 =?us-ascii?Q?R7n0l3aCUBCW3yeWV2N6WNGzW6UwEl24TkkoZ4PVnbFyIlW3aLqK4pE2xNEc?=
 =?us-ascii?Q?svcV6PMDFS0qvJhMmgYFmXWWX1DaoA3pS2EYXLEu9tM19kni1kTEFNaGJwiM?=
 =?us-ascii?Q?eqIRGVcGUXm8SRKMEbH7zBzyyoblXfB6TwcO8Brn4cnZ8FNzw/6rnnaUZRSd?=
 =?us-ascii?Q?CCVOARG0LB876fJP9kpR8IkIvyJb/PO8XASIwdYCxAb+kg15b7jHoNBDWKW5?=
 =?us-ascii?Q?tg2wSjKrEM2ZyY2rwdIyMlCAllpFu9utWNccYu5lD226OlFvywYv9Pqbsb8T?=
 =?us-ascii?Q?fwiC7x4td05iZbWp7RJtGL0FNADue/0Pv/JaznqUobIwlbsYpZuWiYBrB88n?=
 =?us-ascii?Q?4IRoeBUd0+mRh5bHNfXDdMzuhexFxN5mqf0QU88u+cbMFyhbO2S2Udr2RLAp?=
 =?us-ascii?Q?wkFQ7Uu1hcqVE7yaZQrVyPK8TShWxsMpv9zmFEefwh/TKlx6aKzuCKYBi6i+?=
 =?us-ascii?Q?WgYZdWlSpGhqhj2XkdJNtky2ZW1WD9l16DCZD+6QkZqYS2gYpUzi1AttaON3?=
 =?us-ascii?Q?2gpB1bSTLmzod37miHrceK009ue9ftH604W5J5n7nVcmlrNZhow8ZzVGdBuC?=
 =?us-ascii?Q?aMNU5w7DWdSggVzXgmUV5DVsg9L6/zIJn37jZSYz3clsKY2PrIW+zIu8lcJF?=
 =?us-ascii?Q?LxccAr1wGBCzJXfuCvGSyeFY1LA/MJUoQl7laSQhrSxdZ3cbCz7HEj728Ayv?=
 =?us-ascii?Q?8jhz4xn+u0sVkbRs0CeeczGIWf/XEjkcgTIQVAXLsBtwFjIp8Gm2gw8fL4Oy?=
 =?us-ascii?Q?+1vj4bnbGAzokoHnxlQka2cMuLcLMDVvh5p+Z2b8S7dmUk6QZCZS43HNmVn8?=
 =?us-ascii?Q?8gzSuMXkWG6Spvdh3FmAqI7pqQEJziyCrZEe5gK9XLj7SdFzWFisYpQmDKJC?=
 =?us-ascii?Q?FFZtOWJSHZjlwp/7hQRuQCY15XuwL4asF/juTNgN5zwgtEyUQvUanfpCQvVY?=
 =?us-ascii?Q?HO+49ALVQYah6I1bPNQHQaRFCIGlwCdIt/xYN4XfgplRoiP6hxXvdyWC8gxe?=
 =?us-ascii?Q?ToCPdaVRGllVSURKuFBmzhbnK6mg9FuIy08KKf/F7y7oIw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e066bd65-7600-47b0-3d97-08d8e343bf0f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 21:38:58.4344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFcxI7nwpuTA6zVm6xJ6fkMMFHLvzrv5cVmhl9daBjjDptMo5SBK8HXW9hCX1j+x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1243
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pci already allocates a struct vfio_pci_device with exactly the same
lifetime as vfio_device, switch to the new API and embed vfio_device in
vfio_pci_device.

Add a note the probe ordering is racy.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c         | 17 +++++++++++------
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 65e7e6b44578c2..fae573c6f86bdf 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1957,6 +1957,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_group_put;
 	}
 
+	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops, vdev);
 	vdev->pdev = pdev;
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
@@ -1968,7 +1969,12 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->vma_list);
 	init_rwsem(&vdev->memory_lock);
 
-	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	/*
+	 * FIXME: vfio_register_group_dev() allows VFIO_GROUP_GET_DEVICE_FD to
+	 * immediately return the device to userspace, but we haven't finished
+	 * setting it up yet.
+	 */
+	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
 		goto out_free;
 
@@ -2014,6 +2020,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 	}
 
+	dev_set_drvdata(&pdev->dev, vdev);
 	return ret;
 
 out_vf_token:
@@ -2021,7 +2028,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 out_reflck:
 	vfio_pci_reflck_put(vdev->reflck);
 out_del_group_dev:
-	vfio_del_group_dev(&pdev->dev);
+	vfio_unregister_group_dev(&vdev->vdev);
 out_free:
 	kfree(vdev);
 out_group_put:
@@ -2031,13 +2038,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static void vfio_pci_remove(struct pci_dev *pdev)
 {
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_device *vdev = dev_get_drvdata(&pdev->dev);
 
 	pci_disable_sriov(pdev);
 
-	vdev = vfio_del_group_dev(&pdev->dev);
-	if (!vdev)
-		return;
+	vfio_unregister_group_dev(&vdev->vdev);
 
 	if (vdev->vf_token) {
 		WARN_ON(vdev->vf_token->users);
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
2.30.1

