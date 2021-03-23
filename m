Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3237E3464B9
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbhCWQPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:40 -0400
Received: from mail-mw2nam10on2048.outbound.protection.outlook.com ([40.107.94.48]:9569
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233158AbhCWQPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gj0rZKm00egNYOdzhCj6W6Zx34lDyvgCQVN9OwwRtSYMT4b+b35ITT7wLdQxyc77IbqIy3w2AqtcbPWg5LsuSwSLaTPGTB9o6PSjzUVLfWZJxeMAL4mu5k2MfIsj0lnOdLNeVgOOxWxXVaW5eeBvssRS5vbGXKlwwHRrffyu/K3+ELj/Ke9jV0N1qvidJEC5Czv1K2z8mLFEZub2KGFK+6NV0LC3c597Jp+LNhE1SSR6DrFVxSCFDKW39u1YG0t4xwnN9LWFar2wAeF7K1VOvbaJI9/KdQXXyZEMtXy7B9a9qsjN2NpyHbkO07TYMI1+lVIPmP9mVw4nwgL7nAISNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFl0KQ7jEkK//3KiO4casjYqXGqjMU/0R4gw7ZdqNVg=;
 b=TY4iHsMzUs/26NTyWwvemYxjjI0BbbhsFlR7s3WMs494Da0QYX0ECpEFrF8w6mYnuVtSy78SUxjJsDRcyczkNXDLjgooZkmN/GYCC/FsK+6E4ISIfVp3nccydA4UdolRzvd0PR0xhh3dmjMOBE5smSOVoKkdKsgzjA6UTfnpYorwNtEvVucp8Kh2HVldQyqIhUFXhGObuim0WgdGQO40zbMAJ5oDaFxv8kUWkEBx+SkKOGOW/nAPKLEsNOANgw+KMbGZLbj/q5Cg8zYjOFQP28dnCySHaDGczOS2xSo4QyNjHuEVd8kHnTSP8Ci/kKjSBUp+dUmDq/g1P3asctTQXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFl0KQ7jEkK//3KiO4casjYqXGqjMU/0R4gw7ZdqNVg=;
 b=Txmykzpf8+lUdwycxEAnD4W+LOCQJHzcub4hD2+e1DjeNlEF+oPfRhB4oaTbvwkRTFNJGY8q7spVbdgJBVNTznrBudUFvoidtkj4KJAX7DkmDuiXP3UfXqqrdTRZ3z+YNtTR5lHwQUkX+CzK3kEvz1/Th9+AeBhzxswyMzV/wF9U0ibaJ+NXBwC47uJVCJH2TFMziZ+6vXDBCE7Mb5APGKuk/MfGEcMN4yTP5XBKqzuOTX9BdEzG9eviThFU/s9j2wG5PmADM8DB76G6B5kd5xi6qAaWEx7pesMkcNs8aWTAJ/uQYTq2+pCHvVibDqHmnkL9H34+2laHEuyDPiGMRQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2440.namprd12.prod.outlook.com (2603:10b6:4:b6::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 23 Mar
 2021 16:15:15 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:15 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v3 07/14] vfio/pci: Move VGA and VF initialization to functions
Date:   Tue, 23 Mar 2021 13:14:59 -0300
Message-Id: <7-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0193.namprd13.prod.outlook.com
 (2603:10b6:208:2be::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0193.namprd13.prod.outlook.com (2603:10b6:208:2be::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Tue, 23 Mar 2021 16:15:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aCo-Jw; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a993f366-0b02-4602-a9e9-08d8ee16d5bb
X-MS-TrafficTypeDiagnostic: DM5PR12MB2440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB24403617F55B9C83F1F9E248C2649@DM5PR12MB2440.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jCXdS1G1uEXmUSgSBZFux0iUzIvnVQV1zZXieC6cj7Kx+ysqmK5gEXXyq2Hod4go1O2RdY0x8Wrqklc6/7CG7ZAPECdyPmz555CU3zAAvlp0aMBpkOD/aROkHAolr3VYzTvu6rQVTxsjlcmM6auzczu76pvQ6mVm2wL1a9FxaSxacNzpj9EjeBasLxLZzuUY5YIKWEvlDR5b0FNR/TbjxPFP3Q16Gmq2375fNmqYZdQsIvKsWc9ns4WzZ6tMjnuU9IjPgmRLBi0SngEu3dlGh/o/+QpdukCFYOyENedeZmzDDHGALFNXxZQ/RjwGHv/YXzrdWyfW9aH2OOE2tyoW6llocUcUAZKJnwCDqTk81Qhlkk1CCK/XKYedyjGJx/RhQw8j2OZGav7OnArZyBAyezIwjlDy+I5y+c/jnzVj2J9xIJhXjjmCCFFsCvFptcpIi8W540KVYUxmNVuqX1GRtdzJ+eylhDhDO4Ng2bWHLy9/jTmgjLGkEeOXA7+wk3SzbtosmnmFj56lkrNEMZLLu9bmX70Ms07s9pdGQcDYuI0XAt+Fe+VVmsnX5mO/GWwLk3hF3Y1tr6YJGg5a249leiC8HdqC4xRE49gH7QtuX5tj3ca1zFNmO0w8+jXBcbCmpMWeQWraqwH0+SNitz+Q1Bvdch64js8lbTApORQHflbsYmm8YkWZN/jhcYColsqS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(66476007)(66556008)(186003)(6916009)(36756003)(6666004)(86362001)(38100700001)(66946007)(4326008)(107886003)(8936002)(54906003)(9746002)(26005)(478600001)(426003)(8676002)(9786002)(83380400001)(2906002)(316002)(5660300002)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zY7uHECWtf4joSMewvhczAxLJ0ztTDm0BhbYzzGTgVkG/8Av603E3ZEey/0U?=
 =?us-ascii?Q?UD3gcdo5PKXdxg7w3kiGruux5sOBC3t3Pui+C0vxvXvNWuHcgmxu+mCbZ6Sv?=
 =?us-ascii?Q?NoKCB6E6RFXjzdrF6qcGwg7POnMAAXSW8Oh4G1NfJDJ3YXqkzS0G/dB3TE0s?=
 =?us-ascii?Q?N+WjP+M4nPJSwWwKOmHss0pwjZ6M0FSin7B6vna6+rDpmhdLdOtAOPlZusbz?=
 =?us-ascii?Q?Y4MejQ5v6Fd3rHqPl+oM0KvZWWQRlKC5+3quj1kgfbzkrydOe9Db7PdK0VQ8?=
 =?us-ascii?Q?7vFn/5R4aZL+19l8PohaKmjS3tJPNhfyE2Iw/slNS1ePsKr67Gc3LaHuOQqK?=
 =?us-ascii?Q?ytUhZ7pQi0JiZ6AkK+soXwh6K2Zl+HieqPOW9fp0tOXcx2tqCdQm1Ibjxt5K?=
 =?us-ascii?Q?R+0RVdRJXV7Vfud2KgaRid5utrryQxnPW8YLAsb2Y0GA6bpuXy1nCJlNI5Se?=
 =?us-ascii?Q?7vA4Y7ni9iQGeMIINaDn+eTdKV6+vj5uIaHgDwLdpuiNQms5mUDTU+YqRr6A?=
 =?us-ascii?Q?Wonlnqw1tEca8z4TFCRzOtv5R9DGoA0VN7+VqAC2aEAXEH4soASqA+Is1+ej?=
 =?us-ascii?Q?nTqp8TQQ+QGqjxF/W+3MlBhmt8nQsX9Dg240nrSk/59klBD0Iu+gr09Vy8t7?=
 =?us-ascii?Q?EbhzLq1YSwDLzxkkbfifBzyTxIXsHDG1uugiUsKPCAgkmpChjCNTrQ6U1Mc+?=
 =?us-ascii?Q?MeXl8zCPiAIm9HskWQPIMOGgDn7TNanPp7BqtGyfHgkA4ob5ef8a1Zv++E6f?=
 =?us-ascii?Q?AeL4bZfYtgkwQHgk3ztcfoEV3LXYNHwocio1U/c/6ImBqymuE1+rZnH27YzK?=
 =?us-ascii?Q?CQhtO90sPFV4qQnaFEm6vIfCNfnWB4OVcSETBlAHHrTQiIHSq4QnwjHkTHrQ?=
 =?us-ascii?Q?/99MEC6pdFZKf6G8uGKeIIfSlK62YsybF4PbxkHQW+wZs3RlnDIufu5jC3hD?=
 =?us-ascii?Q?+XLT891wnDBUyDqx+iZsk8cb1+GuGMv3NnDY6wEbmSrxYeQz8CZ5oMVZBvgE?=
 =?us-ascii?Q?eCG0l3awaKut6tNVNc67ArJTf24tLniAyQpXleEftwPUPqjfXh6jG7OufBV2?=
 =?us-ascii?Q?3Lm1X0aJI4TG0ZLveyiApvnvzVITw+81G0YUrsYTd8bbU7RNXRRw949WFvDW?=
 =?us-ascii?Q?Is2XdwbVSh5ySvgdon65CvuvwSJ9Jb50ZfSnszsTeFVqgNNERuAOkPsJsDdf?=
 =?us-ascii?Q?/RBnHqgeQRilyNBHm9SX4pz/L/fT/ZKTUR7BE0klEbwqWnOMicDFD+ffu2lX?=
 =?us-ascii?Q?+9GzxAZcF4bWDwnYMxFNQs7fybufJhdaUkEwNK8b786XZclYn1FXHMcMa0Ic?=
 =?us-ascii?Q?4cTEUDKQY4/pGKPm5gi1HsSU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a993f366-0b02-4602-a9e9-08d8ee16d5bb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:11.7580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ObBQMx3wnXiuCw552JJJx5DuN/FyZ5DydA+fGp4ebR3W8sIRodV6X89qHD2ktNQh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2440
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_pci_probe() is quite complicated, with optional VF and VGA sub
components. Move these into clear init/uninit functions and have a linear
flow in probe/remove.

This fixes a few little buglets:
 - vfio_pci_remove() is in the wrong order, vga_client_register() removes
   a notifier and is after kfree(vdev), but the notifier refers to vdev,
   so it can use after free in a race.
 - vga_client_register() can fail but was ignored

Organize things so destruction order is the reverse of creation order.

Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c | 116 +++++++++++++++++++++++-------------
 1 file changed, 74 insertions(+), 42 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 65e7e6b44578c2..f95b58376156a0 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1922,6 +1922,68 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 	return 0;
 }
 
+static int vfio_pci_vf_init(struct vfio_pci_device *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+
+	if (!pdev->is_physfn)
+		return 0;
+
+	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
+	if (!vdev->vf_token)
+		return -ENOMEM;
+
+	mutex_init(&vdev->vf_token->lock);
+	uuid_gen(&vdev->vf_token->uuid);
+
+	vdev->nb.notifier_call = vfio_pci_bus_notifier;
+	ret = bus_register_notifier(&pci_bus_type, &vdev->nb);
+	if (ret) {
+		kfree(vdev->vf_token);
+		return ret;
+	}
+	return 0;
+}
+
+static void vfio_pci_vf_uninit(struct vfio_pci_device *vdev)
+{
+	if (!vdev->vf_token)
+		return;
+
+	bus_unregister_notifier(&pci_bus_type, &vdev->nb);
+	WARN_ON(vdev->vf_token->users);
+	mutex_destroy(&vdev->vf_token->lock);
+	kfree(vdev->vf_token);
+}
+
+static int vfio_pci_vga_init(struct vfio_pci_device *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+
+	if (!vfio_pci_is_vga(pdev))
+		return 0;
+
+	ret = vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
+	if (ret)
+		return ret;
+	vga_set_legacy_decoding(pdev, vfio_pci_set_vga_decode(vdev, false));
+	return 0;
+}
+
+static void vfio_pci_vga_uninit(struct vfio_pci_device *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+
+	if (!vfio_pci_is_vga(pdev))
+		return;
+	vga_client_register(pdev, NULL, NULL, NULL);
+	vga_set_legacy_decoding(pdev, VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
+					      VGA_RSRC_LEGACY_IO |
+					      VGA_RSRC_LEGACY_MEM);
+}
+
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct vfio_pci_device *vdev;
@@ -1975,28 +2037,12 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = vfio_pci_reflck_attach(vdev);
 	if (ret)
 		goto out_del_group_dev;
-
-	if (pdev->is_physfn) {
-		vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
-		if (!vdev->vf_token) {
-			ret = -ENOMEM;
-			goto out_reflck;
-		}
-
-		mutex_init(&vdev->vf_token->lock);
-		uuid_gen(&vdev->vf_token->uuid);
-
-		vdev->nb.notifier_call = vfio_pci_bus_notifier;
-		ret = bus_register_notifier(&pci_bus_type, &vdev->nb);
-		if (ret)
-			goto out_vf_token;
-	}
-
-	if (vfio_pci_is_vga(pdev)) {
-		vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
-		vga_set_legacy_decoding(pdev,
-					vfio_pci_set_vga_decode(vdev, false));
-	}
+	ret = vfio_pci_vf_init(vdev);
+	if (ret)
+		goto out_reflck;
+	ret = vfio_pci_vga_init(vdev);
+	if (ret)
+		goto out_vf;
 
 	vfio_pci_probe_power_state(vdev);
 
@@ -2016,8 +2062,8 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return ret;
 
-out_vf_token:
-	kfree(vdev->vf_token);
+out_vf:
+	vfio_pci_vf_uninit(vdev);
 out_reflck:
 	vfio_pci_reflck_put(vdev->reflck);
 out_del_group_dev:
@@ -2039,33 +2085,19 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	if (!vdev)
 		return;
 
-	if (vdev->vf_token) {
-		WARN_ON(vdev->vf_token->users);
-		mutex_destroy(&vdev->vf_token->lock);
-		kfree(vdev->vf_token);
-	}
-
-	if (vdev->nb.notifier_call)
-		bus_unregister_notifier(&pci_bus_type, &vdev->nb);
-
+	vfio_pci_vf_uninit(vdev);
 	vfio_pci_reflck_put(vdev->reflck);
+	vfio_pci_vga_uninit(vdev);
 
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
-	kfree(vdev->region);
-	mutex_destroy(&vdev->ioeventfds_lock);
 
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
 
+	mutex_destroy(&vdev->ioeventfds_lock);
+	kfree(vdev->region);
 	kfree(vdev->pm_save);
 	kfree(vdev);
-
-	if (vfio_pci_is_vga(pdev)) {
-		vga_client_register(pdev, NULL, NULL, NULL);
-		vga_set_legacy_decoding(pdev,
-				VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
-				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
-	}
 }
 
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
-- 
2.31.0

