Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3A2339AAF
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 02:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhCMBD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 20:03:29 -0500
Received: from mail-bn8nam12on2051.outbound.protection.outlook.com ([40.107.237.51]:51809
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232255AbhCMBDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 20:03:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCoU4IaDZN3/YPsh8leAIwTtqqziyk7BI+S1Uipx2ahP5zpSPTb+ah2hxof4HK4hD8BW0o4YubBYDWcqK4AK7WOsO8WOEIxQoeau773uuotKc+/dNY/ifO9h8zMzFgQqrKD8nmMpvmzLlBAOx6fSw4daMXgHJcqs4DbTBU1OOB0j7goTu9LArMMoQZ0574xzqmWbie4NSCZ8mH5JOEn/w/JKVoUbmr9CE+AAiKaY0uPN01dLLNFfv6k1OF+nI5lBWjG7rSV797R9eNIcKMBfwouWb6YqyD8kbLssGgE1F2aRyEcg1MNudrOEzwtHyCYCuVCcEbXTVz2fi/zkri9epQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mklakhkGKcRS+LTOiHNXJp+OMFPRB5KeG2q9SWWqp9k=;
 b=Q80b4wivoOpHs7NzcoU4kiqC+jtgCybhVAFbgIAMRM8fKTRR6bWfHjViobC7SshjoGsd7qXFxfR++Kle1N0jE68pi7c7IbWsr9vQjP4rLHmJBEtE6iH8A2Q8KVCuJqyjb6PRUv4fw2fvB2HAheWRx54JC/4Fj8TqR7NDrriDwUb500No5VZaQ6JJFP5lqDxH372a6Y1tbihaZxPiy9LBfNKFgVserotcSUvyWR2ctjS2DP/Y5Z5iqC2+YjbgC31gWkiilICFkLFERp9xpYH4lKQn/dbjHWKqNsWkB3XyGjPTFU8QvwPBlyVPHwDYHj4dPVGOIb+tGC4O3dDhJN+qdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mklakhkGKcRS+LTOiHNXJp+OMFPRB5KeG2q9SWWqp9k=;
 b=MB/PueZunIaKlprP+GtOnzA1RIyB43u/DxR230sK6Ns8ZP0mrzq+IRA1OWFj3Qjxu1lDT7pOcWJAkUnWBB1tbhuCb3DaPPx4qP/9XC2W9O/3o/zzu+RKjg+kKM9Oas86InRnNz2B34uDAzdmbPkbUu/LOd63Y5U2nUd1ZRrj4jeo4oDllM6JqSjv0QfUxlKicEac4BW2N8xi53Sa1docp7UIg4+BJpd4xHig9fdEudqr0scGd7JIrKIzK4e7SVWlcJNuicNq/9EJN6RmRSgSfT1reiyGMTEartcBWbOPVUE/4kb9idzl1CAo3CQu5FIppvtDwwg1eUuKQ5f2v/j2aw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3306.namprd12.prod.outlook.com (2603:10b6:5:186::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Sat, 13 Mar
 2021 01:03:06 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 01:03:06 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 07/14] vfio/pci: Move VGA and VF initialization to functions
Date:   Fri, 12 Mar 2021 20:55:59 -0400
Message-Id: <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:208:236::29) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR05CA0060.namprd05.prod.outlook.com (2603:10b6:208:236::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend Transport; Sat, 13 Mar 2021 01:03:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZb-00EMBA-1t; Fri, 12 Mar 2021 20:56:07 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f80a649-2c6c-4c2d-095d-08d8e5bbc30e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3306:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3306F4B9F77E334780C29628C26E9@DM6PR12MB3306.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S49Q1D8mYADH5zlxpB0ygBIrPDmICCaQiKtt6k5kFH2o8mpPpzF/ecvJLZvv9W/EMJS7yo2PcDrwcjZ968iHHePEBKwS6JnupOAnt/KUG8y+eBUfwIjUId8y7kYZwm3MiGebzhGgXnGoUmG3LddMYMwl1UMf7yFEG/Eweq5lPnUvG2oHjuXbEipCWirJE+fkdi8mdNcAN9kVpXcLscJqom2qFnSS8R3oikWl71+C3PWR5wrImbeI+e8r4pDM5zoPF2RV/T8xDXlocLAxbrthhhTsdWG9LBUxsHqyii5KCWk7B6B4gpDsGOnm+0qvQbK3iwuo8rM20tFgaIMkTt3RNsLMCqo92CRyX/khLW6mAUV3851N5/2C0UuY2exybMEe2gCPunyTHbE7WrPDUIuuPhEFc1vkimJ2z876JTjqEnNKM3CcF1oUJXv/cTd640TqQ45NryvWFTB0/uVaS9GfL3NeoCJRACs1LeJWq9DqxLwFcfniXMweQZZ9jzOgH0BbcCht7VVlwGMie64NIdzsFG16znCpeVjAUjViO4I7JKwY5J4o/kTtSAbCdtp/81OF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(6666004)(8936002)(316002)(54906003)(26005)(426003)(8676002)(9786002)(66556008)(66476007)(86362001)(186003)(83380400001)(478600001)(2616005)(9746002)(4326008)(107886003)(36756003)(66946007)(5660300002)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6qk4IXju7GHAmg8Mm0N7uRfFinDaR9KVFaTdtQ8aoahnOIDyzAYOeUvMGOeR?=
 =?us-ascii?Q?pVVwVlTdc4EhqrrUb8sRYNOCmkIhdvFC3zW8ds8H/6kcaR3Yo6Ecx1MsMkVb?=
 =?us-ascii?Q?0kx6Z9OnR+CrM2ZktPzQNa3e6lgaA+eV1iuytBC3A6ZvomqyTZBzMZLHMTnR?=
 =?us-ascii?Q?yxmYnIZiYsJSFpyE9jY8NkPPkAf9AT6mPUbKoELwYc32za8mUN1m4t+GqIvL?=
 =?us-ascii?Q?AkHJg3+OOE4Fc7t1BhPhZuQj3aBJ7Ud+n0k2SoO52sgUk5lYVCBB2zGR0qH9?=
 =?us-ascii?Q?+08I2OoV1V+2IS/ys+KY+2T+/CY5rAyXdP2BelHf6hOCM2TU+vmUnsZ/iwDp?=
 =?us-ascii?Q?qtzPpPAw7D+N8+QJNlwoCmc1A5nCK6/rUPinaPx0Y6OLWW5G5n1usQ3gMFYN?=
 =?us-ascii?Q?vCBIneVYuWD2javU/OLwhmvIL0UXdDwvGTmfdUZP3vt//HYm5WEHFLqDnyBy?=
 =?us-ascii?Q?nzAq2tY3TercdCgOuCfdNd/YtYGjh+akcEM5cypYYo3zqk5P7dUk/eRaPMLr?=
 =?us-ascii?Q?z/e2qSfsjI3wUp7OdkjyCmxXovY5NXjTJuENnvq+JdMnOvGFFg3sOy7pmH8w?=
 =?us-ascii?Q?g7E2gRiB6mo4pTNRFRX7cXcaXi5phrwimpNF5r2AL0uWeS5dxlpuH2iTtAjv?=
 =?us-ascii?Q?LuUSxBycsPdMNxpvnK5f09D8RZh40Kypmi31TMPfUcI1y1HmQhnbgaZKX+1N?=
 =?us-ascii?Q?jblIEmCI7TMXJulxdVuuBCUs6QMNkR6GQIyOt+OLv/96SmGmjaQmOSA6Agve?=
 =?us-ascii?Q?vY3jFJKhvuY27XD4uVQ5KrFEV377NTat+PXfe/tIeQmG2wa25kCZ3l/gTugp?=
 =?us-ascii?Q?53wbjZI2HVNAefZeERKe1eJhEcC1XxNtDHmhqqT1SqRI68KgGpVQECbuCYk0?=
 =?us-ascii?Q?3Mi6D+p0BlQbARMk+3Ow+O94gPKAIGW1WDzDr8dilenTohhFevn+4ud/ncEz?=
 =?us-ascii?Q?Vpa/8U3IPaMYLzoiArvU3/4XjOSce23vH8BSI0M7BHnz0SPcG/l7q7tpjAlH?=
 =?us-ascii?Q?6htoeerxwlJTe7/OGYelfABWeubRW5zTfsXazTUdrMMeYbnPXt2ZOJYSjVe+?=
 =?us-ascii?Q?/7DEYWK3jXe3s6UDpLnTD4r5oaAkHn628Pi4x8i2SgGzPNQDBnI1rsM9m/XZ?=
 =?us-ascii?Q?lXadbFokxu8Chz5FmOu0XOOPXuIQ5RuG/OkCKaid/Ra2m0nKJQ2DFPFizg0R?=
 =?us-ascii?Q?4RHEgRyVnX0IrQC6RDx5V9NjHKOZbG2lRk+J1NWm5b9I9aePcqNhZIYVVgRq?=
 =?us-ascii?Q?xLFm+BjRA5Co6VZMu88+kGb2jwg0sZ0BsOqlb6mdG6KPdkresI4X2bgi6s/I?=
 =?us-ascii?Q?K+DLz0m3edT5WqkMBkoXsfw99Krl5APflA0HK3AcLl95Cg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f80a649-2c6c-4c2d-095d-08d8e5bbc30e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 01:03:06.9315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/FfjIdGlCtQ/fvzfUL9xkj7UaORGMLlXHLrjR7hm7hM7nNhQBw1L+rBf5k+JJ1P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3306
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
2.30.2

