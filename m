Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B7B339A95
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhCMA4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:56:30 -0500
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:30549
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231597AbhCMA4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:56:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jz5vUzdfz4kGiWcjPcmHLWdC0X0bPTbVKNLuLsgpm70EbS+EwtegX8OATBZcRW7WOyyWYgjFUN+D0DZFGZaSuOBYZDE9I5PNkwSHb8rC9Hs4qPIUVdqCJYZXCpuEKPpNJgED9j/D+f7eD1C9/3NiI2fWd0Rbfp/zpxjMAxOparn8vcrZSJ4/Vg0r4jVtMRazVJ//tCKhqXPwRH9cd9u6iyrLGVzT0lh2V0Dl+OqXfom41PHtZG2rlDFicpfOUeoc5xQtHS7/r9Lll42eWuGp51b03t4Ix3NtyxsLuAnS+AmcUPOjR9U0JmHzG6ZBngwOK4IWq82XhNEvrONLC0qspQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uX3iHO2TsjNAMjEE7/PTWoH92GnhcRu1UOzdlyPi36A=;
 b=KyztrSKy8jUOiCJMGynGdC31v6WNLmAYzbPKPjI75Sg6JVb32DsDrcjEPwaMpo31UHrVY79dfjeexnNYWJpAFDElUGmT15nuhkMeEXJqbbNd7QplF9XX+wqVDvb4J9mg5NIvwZuqpE0h4y22T2DrywlQ3YbOG239ZsUxDDs86pcpGI/hiFIwsf1uuTtlaKPqWU79W2IDzlAaOaQL2yOwQcUyK69ZhBLVCZgq0aNF8TnXsEXPS+O5+JU+db65QCGOe1GoGEcLgI1UAoJeBRNp/pEJ3PjRN+JmOHc5Wj9D25hveYnDJaqg9iKTSUY9a2qTN/07zH6gjdlJihD+fns/8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uX3iHO2TsjNAMjEE7/PTWoH92GnhcRu1UOzdlyPi36A=;
 b=CqZunHGHvzXYpwLOUjRjUaLrjfyA6fY//ilzoEEO0yqbY8jka3ZQ18ezGezfRGlyZN0wfRPh7ZtG93VDCznmaT68l1/t/7MnyRyZ6PS/d+UY3HsQ6fV4Nm8HJbj0RO0krry5Mfg++Bnt+I84By+pw0aCC2KN6AVYyZ9r7H14HcWus+FHW1fyF6MhUoLS0RGMx0LPVULM9CBXRvFAbkcSzslzy7VB/ih/UcQtX0Idywhq3Hz0zpucDCjS2De/LTGSejf7JzO/XIVepzyImun78GVOr9XgGOVfDvs0wcpG3Z9wMotnRB2s/bOhLFOMKnh4sa2T/qRW609hWSFTseBKxA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Sat, 13 Mar
 2021 00:56:10 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 00:56:10 +0000
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
Subject: [PATCH v2 08/14] vfio/pci: Re-order vfio_pci_probe()
Date:   Fri, 12 Mar 2021 20:56:00 -0400
Message-Id: <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR06CA0021.namprd06.prod.outlook.com
 (2603:10b6:208:23d::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR06CA0021.namprd06.prod.outlook.com (2603:10b6:208:23d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Sat, 13 Mar 2021 00:56:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZb-00EMBE-3d; Fri, 12 Mar 2021 20:56:07 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9ceae5b-3d80-4dd2-cb3f-08d8e5baca5f
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB294030D9AA452FF38A6DC1F9C26E9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p1LF9XdQq3IV31DDKe8XB5Nmx5vykgQN+ogVJk9Fp8KOe8YgwEsVvqk9NdJLdYFpnyl6XASHOaRUSk3V7Eyr14ymh3UXjxa6QDebFBQOixaCUw2bQOFRDCfOCFLYCZK9CHvONRpZrs3Kiiuj6FvNJgesTKqtKpFxkJpJj5hyUj7j9hvt0iRfEUV7HD8Vlg58GaEhJoZtXXGOyEQymPdCOdLtNaOyGQ7QA4W8M8YYVdbmpoGl5ibvuKStdCuD4FznbLTWJCDqHNJyHIO3sW73XXU2+nEcl+wVvXb/LjCLMRXYS9/RmYuRVW856ZN6YwslxIGaqvqqd4B8mOIIn4dQvCN/XxDbLA8DNO/rh1o2Ovy5kZlMjd08xIR5msHh3M5nXFkivp6p08eoTp8e8xq4pLU/Znuu+1dU7c/RhxH/nSNDlWdQX4LBiFZNI9G7eed2wEIESo91CwF+NFvSC3/GyiRq1u9GTOMY/PbBEU+tRKJVaYmNxCl9k/sEWInQJSrzTCicsisXkiryUd1bs2lv4Ws6TnfBwYPila7Pf6UhvCHOqQpm6APFxU+PwHXFKYg+8mHX3BH6g/DxpFFO91BAFEz5RT/0Erfo2qbt0riFWD9shJsnxWemOLzhcXLiArcxrNdKSyTBI5bjT3bWgKeieQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(9746002)(9786002)(8676002)(6666004)(4326008)(107886003)(54906003)(8936002)(5660300002)(36756003)(316002)(83380400001)(66946007)(6916009)(66556008)(186003)(26005)(66476007)(478600001)(2906002)(426003)(86362001)(7416002)(2616005)(4216001)(169823001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XZRp9GpNPB7yLBlJsPMbi5nQeGQEfs5ycAacz6fKiLeaGTWQN+GP8ACPZNtz?=
 =?us-ascii?Q?TEaEhg8ogtN6upsmzXxZgjsUD02px0z1b8BhTG5a0uZHAQpwfWB2mBI6As7l?=
 =?us-ascii?Q?BZS9tg9VerFlbtSECKx3L9Mr9EUlfX1Q64KVZ/Pv89+/f16GFBZwBStyIelS?=
 =?us-ascii?Q?ooxTPyx3lB0poBJs9JafkDnQRCkuGVMblNh5lxUxhoscfYuQKSKNI+0c6Uq1?=
 =?us-ascii?Q?vzUibzzk2llF0xmdtZzI504njfLW5Yv37tZpe2m8yXkG59CTqQ8pWZgMBjt4?=
 =?us-ascii?Q?2/7Cpk6JyP5CI6y1sZ9d6TvV9EYZqiBll4peyegDxKgA3bxGMsdDQlOwfIuW?=
 =?us-ascii?Q?LZVz5+XLDznoU7ArEIZdjVe6djGNxqVsQTYIaXg7TcRTc/GfsVjR4ekGZCfZ?=
 =?us-ascii?Q?x6LoYzaFAMydEJsoBy5etz/RkCRYOJ84viMGCM1wSG3w6iVYWWxajDrGEDji?=
 =?us-ascii?Q?GMPLybbVs0tz8dsXWwngMTLTojtUNeBxiFSxT6zYlScQXbeclJSaRYLrdTl9?=
 =?us-ascii?Q?hTMMMCCcT6UVudqvhLoTHOl7o6gVy+W2rYhi8G5eCQHALzODGYoU7U64EB1s?=
 =?us-ascii?Q?U7GGj0XWU0tz9u79Sw1/PFGjlmYdmCxysROOdzbMMo0hMCqe7MKnvMShjQqW?=
 =?us-ascii?Q?MZHAjJ18Y0fh5d+q0h6BlW3UdXrs+olBpltr3Hsojylav07IyJ3Y7mVjOWYG?=
 =?us-ascii?Q?p7gXXccGJuCcL/Heaueb9gd/n3eEH7nxBm4XkCP+M+XciN9UTxmLUWpPGlsx?=
 =?us-ascii?Q?i+qIBrUdOOztxJnKmwa7vTqsRGGsPjonO4qNT/xAGvkkt6fIimrLjwHXWTqT?=
 =?us-ascii?Q?LoOsz0NBYsZhhbbo78iXqY9MbJ4uytlueoYVe4sKyXbFdKdgRjJ516Oo/CPW?=
 =?us-ascii?Q?3Nm208gGKeM7GaUIa/z1SQJb41+FVwfbkujdG+lydpcSGZPqTWyyMQ2ETifG?=
 =?us-ascii?Q?CRRS+NyqztmT7RCTzRThzp718LVn9LQDzeqwGf3/2aouFAJahaMWSBp6Ob2J?=
 =?us-ascii?Q?oafFX0YqKNbHU/28BBGnhRcpRcmLEzJ2FF/Q7fRooD8BMA2j1peBisPfWDWy?=
 =?us-ascii?Q?DxtlpYCP7R4ILdiLo+o3lFqNTBvHtUhSeEZ5kOEufaelW+QZHrlI0IZVOLtk?=
 =?us-ascii?Q?ulDXpzwxTORWtXkklrmXNsC0g4oFk/tixSqDJmf81sQrOeYUmMRrlhOZ56mu?=
 =?us-ascii?Q?uSeiUQq1BP4O64hlGzggOgqPx4KJyBiiuCLZZKS9C3FqVligXM852BQcH3Hn?=
 =?us-ascii?Q?jwisGfaW2+f4WYUNTEN7TQHAEWJQazybhOzUKhly5ObS6BVsKVB+UdBODMxZ?=
 =?us-ascii?Q?TpjQXi9YdVFi1Nl4j824X9AalfL14Y/JtCyUkiHalIHzeQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ceae5b-3d80-4dd2-cb3f-08d8e5baca5f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:56:09.8306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZNcUyno0lRL4dekpMEiOpCXOjS3cJHSubn8osLY+B8QJ6jjcLkIFHtjcqv0u+J9Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
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
2.30.2

