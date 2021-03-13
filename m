Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CB6339A9C
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhCMA4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:56:34 -0500
Received: from mail-dm6nam12on2081.outbound.protection.outlook.com ([40.107.243.81]:44481
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232311AbhCMA4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:56:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgpIcrCNLYCceNJRx1G89n1KkhUTaMaUsInL1cua609+WDYN1swNaPArfODzU8Zuo8qH6KfqKr7mzbeG/1+Yle1qcfe9n4/LkQcYG36svemTqHSlbLgQV0hMt4PrWs0eeNtPfCkOcGwfXkbUdrLkNhaJfXzPtKqe49e8akzpmuTywe4mA3KCfH1KmzsIXcxN8NDodT1avfPIPj/pdPsUMGbk/DGVWbrhPJejuJKPobEAvclFw1zNEQRwN8ha/Vm16A/s/PjhzTw4iwWftrpYmYv54pJ1N7LF+G1coG/eag/ZdFWHX2Pn4KPpeAAviKh9BXIyu5Q1/GFRhcZU8fToyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehNlWmtZtgb6mG0WAwYxqr1bT1zfvPDosiqeUW1pctA=;
 b=n/MOIpClgTWo8srAkWw+C2+9QY7FFxfmZMTB3yvNljZNFCXbJGsIaz89bJ4KDbdEW7jsqtRWf4tOTL2PVpe5FubtsB9jWwKiVIXxNlXu0aqQ0nPm8U/ihXnehcEXGMc0Lbl3BfsbF9j6byvi7//Irxu2XnyWl/QwKVCDX6bWW9sy7+JOegwZRzOJHg+x0X7G5jA3TllPL3XjecQnyJBhb1Imdq5GDpzRWCdurHcyVmcQAD3DK64snGuTP5/tIBsVLqKPfKyKUylLsnREFXVrhvfI1O2F3jk3R8PQlWJ4jXHLgAkc8Yb54KOfiwCQstRxSxNBkMtBL8xQqSJwpncp+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehNlWmtZtgb6mG0WAwYxqr1bT1zfvPDosiqeUW1pctA=;
 b=rKfeOysExRaV08/3EtJJ6ApS34vxDTuldbpsudYKGCKScwjx2KcRNAC9Va8BS4BNShU4zxNpgoCW4umSnwb2okKW4osi4stfFVQSev3cm7UqJPSpjjtpTBam14kZip3E86uK51Y8oUSWX7agyxBYKxZEx5ZTbEddY5qNEH+V6Ll5JwXopke5rchF7M4erO9zXfPA3EhurBZ143bNktuJwfEFXWfIjFLTjA7B9agL53B5Vd/CyIuPZ/EvCaVkqhy9VxpAi3i7UtyJs+t378H3B+Mg0MfiqgaJZ4eQ4QB3GkHlvFbynbzbx8cg2hcEdTJCoDCM0og9HbRyWDSyxMWiBQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Sat, 13 Mar
 2021 00:56:15 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 00:56:15 +0000
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
Subject: [PATCH v2 13/14] vfio/pci: Replace uses of vfio_device_data() with container_of
Date:   Fri, 12 Mar 2021 20:56:05 -0400
Message-Id: <13-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR22CA0019.namprd22.prod.outlook.com
 (2603:10b6:208:238::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR22CA0019.namprd22.prod.outlook.com (2603:10b6:208:238::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Sat, 13 Mar 2021 00:56:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZb-00EMBX-91; Fri, 12 Mar 2021 20:56:07 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d34369f9-6eee-4234-19bf-08d8e5bacc14
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2940608DAF72CAA3C1B65A32C26E9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L/33DNewqPErMzXXDP93FT3rx2dABJ9QG4GkNj0lo2o8LlpiEZsVQtyC3qoX2AiZgwb9vdxe7X4aqib/lkfKBKIyufLzPfQFdYoXJVtHT2X4RkCtRyO7NuVO0W4CFI10l5IiQFw+BYULlsKz8mHiLFW2AniuZCKWXoBMeQCSaWVNiq1S/r9f3cDrUryScDUaYL8vfUan1me4RMIzDuyNRMGwUKuOzSVY+GY3qVhgpMdFZqt0a50yWo4J+5cyk4sEL18WSpUauGN0HyFDG4LayuhTCeHZkYsLFaeVlhQAbhIGkshawrm5IOX3jKnEIrucpa7InwQ9vaf90HMXukWYw/5AmXGD0rbVzUkYcxVDjTp1iAzrFtXoj+J6T9PWr8u8YBdHYVjgXylgLW99hh205L50kVKqpAZkVHliZXL9lYVrEZOlwjxnwYa9FcrjfaW//ed28G3wneTkphA2KQNQY3sluuVr3ctagexYn8l9/4nZ0GpzVMAxXAfM0rs9nmg49L19G4EBYIEntDPNJ6VhwqaVtWUTfjTPZb3lvNWjmDkL/1qSDo1PIyVtHTmP8QnN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(9746002)(9786002)(8676002)(4326008)(107886003)(54906003)(8936002)(5660300002)(36756003)(316002)(110136005)(83380400001)(66946007)(66556008)(186003)(26005)(66476007)(478600001)(2906002)(426003)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xEZc8o3ogkTLnDGA6Yzxb7BdMWK9/qsPqts9hfj9KJIhziwwT0MI9Nl9V1vU?=
 =?us-ascii?Q?Oc8evm0qhT+hrsKkNg2MtRjQp5KjDgCl8fW+7YGLXtYPwT/d+SbzcbHkKpde?=
 =?us-ascii?Q?lmc3YFgzAzbFCpSesJX250ktxJqhkERCwaK4Yw7ynRfUdrshueQ8ovVvCQ04?=
 =?us-ascii?Q?uDBRTU9BEbfOsmRhVTu5f6/ddwvz5r2ROnTnyjcQvGQmeR63yzTb/rVDWjGZ?=
 =?us-ascii?Q?Fdkn+Y3rS0snv08xDute6qadCgC7js5FOuEwO+7dRMQXPRTNVtVlYcZE4kBh?=
 =?us-ascii?Q?AWArCwwroUlhiX/g3zOWkE5eW8pedmZztfy/nnm+meqOF30f8ejTlmOo/Ayj?=
 =?us-ascii?Q?C2HYhmQdxi0h7F71986Aq1pEo3AqWtUy9vYquzIIxapa5Vy8sB0vzqMGrQ86?=
 =?us-ascii?Q?w6ngH930IMLEamokw3rVAmN5HAj5cFVHR4x+8zLDAngKBAL3hDp+QQcMkWEW?=
 =?us-ascii?Q?wBVWPLamqpW6H2y/WZku+enbtcklHEzYZzA7R0zAL3ljm8JjMUS4o/jl6qMG?=
 =?us-ascii?Q?LViLDTZy5yj7RxuXrFja1/xR8bGvC+WPGNVG4GUTYO4XWXzw75QL4lNpc3DF?=
 =?us-ascii?Q?4EceUZpI5KRXiTiT34QLFuUZ6TXg46Za5AM+YDeAZEtB538y+asXO7oqr3Hs?=
 =?us-ascii?Q?iFSjBPULpI1zE+qgQDRUbA8IqA12/fWLRUNXHtg/Wck8XeC12coktFEm3a5i?=
 =?us-ascii?Q?k8vaQPyOp1b0kmGzDK9RQfuOBx0GKfzJ//tejyvXcw6cNoupBx8obWjSYPF9?=
 =?us-ascii?Q?laPWhaGOd3j8qRJo5E5QF77AJZAcvk5QxGfI/U4+CYPL/PoEDAFF6WzfPQ4i?=
 =?us-ascii?Q?b6PW5pK3MexSV7nGEvzXvehLLwGVGlqrQ/2uFaae0Gb8JRHKVnwerH7TUYY1?=
 =?us-ascii?Q?zIZqvjnvW/zGVO+PxsLW72hRKzz/2gHkY+jfJ0/ZLeTimUlvmrlr/nvOU1ZX?=
 =?us-ascii?Q?e51nhcpI2JolZQ096idsD7szKwhvF6DJSdpbZoCtjdCWvU4KcUNnXRHPFyXz?=
 =?us-ascii?Q?YsRSlw9eMnlJoFk/Js46gnqazgpWrSB2tr00iF37jbPvY5aEUJoo34Try3dS?=
 =?us-ascii?Q?Z2WImrsIdUGeEpqpmpJQ+zgysAy0thVgzwqkKJS6ks3Gu42BSqhTkEOcJym1?=
 =?us-ascii?Q?Ch1xtJQIQD3UCjGupBzOQb6GK5XImsRa/tT6eE5NgvLCcl1l/V6IIgSKP4Xd?=
 =?us-ascii?Q?zt0eTnH/mLXPNr03RJTtwk0iac5pyOhOV7IKqPNve7TXTx8HMmYkJXe9G0g4?=
 =?us-ascii?Q?dvtdB5CWqeBeZP9c7daHXJsJNMpRxOOJlp/pMC32oIMoVTRPXAVTL+tGk/37?=
 =?us-ascii?Q?+v8NrsvHivmTyl8sIgg8KnTg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d34369f9-6eee-4234-19bf-08d8e5bacc14
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:56:12.6760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n6Ru3bxAla8KxxFpO4QCG8LDlOJNW93GBhzo2pLGsU6FcLXgvayiUYVY8bOwydCO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This tidies a few confused places that think they can have a refcount on
the vfio_device but the device_data could be NULL, that isn't possible by
design.

Most of the change falls out when struct vfio_devices is updated to just
store the struct vfio_pci_device itself. This wasn't possible before
because there was no easy way to get from the 'struct vfio_pci_device' to
the 'struct vfio_device' to put back the refcount.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c | 67 +++++++++++++------------------------
 1 file changed, 24 insertions(+), 43 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 5f1a782d1c65ae..1f70387c8afe37 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -517,30 +517,29 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 
 static struct pci_driver vfio_pci_driver;
 
-static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev,
-					   struct vfio_device **pf_dev)
+static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *physfn = pci_physfn(vdev->pdev);
+	struct vfio_device *pf_dev;
 
 	if (!vdev->pdev->is_virtfn)
 		return NULL;
 
-	*pf_dev = vfio_device_get_from_dev(&physfn->dev);
-	if (!*pf_dev)
+	pf_dev = vfio_device_get_from_dev(&physfn->dev);
+	if (!pf_dev)
 		return NULL;
 
 	if (pci_dev_driver(physfn) != &vfio_pci_driver) {
-		vfio_device_put(*pf_dev);
+		vfio_device_put(pf_dev);
 		return NULL;
 	}
 
-	return vfio_device_data(*pf_dev);
+	return container_of(pf_dev, struct vfio_pci_device, vdev);
 }
 
 static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)
 {
-	struct vfio_device *pf_dev;
-	struct vfio_pci_device *pf_vdev = get_pf_vdev(vdev, &pf_dev);
+	struct vfio_pci_device *pf_vdev = get_pf_vdev(vdev);
 
 	if (!pf_vdev)
 		return;
@@ -550,7 +549,7 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)
 	WARN_ON(pf_vdev->vf_token->users < 0);
 	mutex_unlock(&pf_vdev->vf_token->lock);
 
-	vfio_device_put(pf_dev);
+	vfio_device_put(&pf_vdev->vdev);
 }
 
 static void vfio_pci_release(struct vfio_device *core_vdev)
@@ -794,7 +793,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 }
 
 struct vfio_devices {
-	struct vfio_device **devices;
+	struct vfio_pci_device **devices;
 	int cur_index;
 	int max_index;
 };
@@ -1283,9 +1282,7 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 			goto hot_reset_release;
 
 		for (; mem_idx < devs.cur_index; mem_idx++) {
-			struct vfio_pci_device *tmp;
-
-			tmp = vfio_device_data(devs.devices[mem_idx]);
+			struct vfio_pci_device *tmp = devs.devices[mem_idx];
 
 			ret = down_write_trylock(&tmp->memory_lock);
 			if (!ret) {
@@ -1300,17 +1297,13 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 
 hot_reset_release:
 		for (i = 0; i < devs.cur_index; i++) {
-			struct vfio_device *device;
-			struct vfio_pci_device *tmp;
-
-			device = devs.devices[i];
-			tmp = vfio_device_data(device);
+			struct vfio_pci_device *tmp = devs.devices[i];
 
 			if (i < mem_idx)
 				up_write(&tmp->memory_lock);
 			else
 				mutex_unlock(&tmp->vma_lock);
-			vfio_device_put(device);
+			vfio_device_put(&tmp->vdev);
 		}
 		kfree(devs.devices);
 
@@ -1777,8 +1770,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 		return 0; /* No VF token provided or required */
 
 	if (vdev->pdev->is_virtfn) {
-		struct vfio_device *pf_dev;
-		struct vfio_pci_device *pf_vdev = get_pf_vdev(vdev, &pf_dev);
+		struct vfio_pci_device *pf_vdev = get_pf_vdev(vdev);
 		bool match;
 
 		if (!pf_vdev) {
@@ -1791,7 +1783,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 		}
 
 		if (!vf_token) {
-			vfio_device_put(pf_dev);
+			vfio_device_put(&pf_vdev->vdev);
 			pci_info_ratelimited(vdev->pdev,
 				"VF token required to access device\n");
 			return -EACCES;
@@ -1801,7 +1793,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 		match = uuid_equal(uuid, &pf_vdev->vf_token->uuid);
 		mutex_unlock(&pf_vdev->vf_token->lock);
 
-		vfio_device_put(pf_dev);
+		vfio_device_put(&pf_vdev->vdev);
 
 		if (!match) {
 			pci_info_ratelimited(vdev->pdev,
@@ -2122,11 +2114,7 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 	if (device == NULL)
 		return PCI_ERS_RESULT_DISCONNECT;
 
-	vdev = vfio_device_data(device);
-	if (vdev == NULL) {
-		vfio_device_put(device);
-		return PCI_ERS_RESULT_DISCONNECT;
-	}
+	vdev = container_of(device, struct vfio_pci_device, vdev);
 
 	mutex_lock(&vdev->igate);
 
@@ -2142,7 +2130,6 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 
 static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
-	struct vfio_pci_device *vdev;
 	struct vfio_device *device;
 	int ret = 0;
 
@@ -2155,12 +2142,6 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 	if (!device)
 		return -ENODEV;
 
-	vdev = vfio_device_data(device);
-	if (!vdev) {
-		vfio_device_put(device);
-		return -ENODEV;
-	}
-
 	if (nr_virtfn == 0)
 		pci_disable_sriov(pdev);
 	else
@@ -2220,7 +2201,7 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 		return 0;
 	}
 
-	vdev = vfio_device_data(device);
+	vdev = container_of(device, struct vfio_pci_device, vdev);
 
 	if (vdev->reflck) {
 		vfio_pci_reflck_get(vdev->reflck);
@@ -2282,7 +2263,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 		return -EBUSY;
 	}
 
-	vdev = vfio_device_data(device);
+	vdev = container_of(device, struct vfio_pci_device, vdev);
 
 	/* Fault if the device is not unused */
 	if (vdev->refcnt) {
@@ -2290,7 +2271,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 		return -EBUSY;
 	}
 
-	devs->devices[devs->cur_index++] = device;
+	devs->devices[devs->cur_index++] = vdev;
 	return 0;
 }
 
@@ -2312,7 +2293,7 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
 		return -EBUSY;
 	}
 
-	vdev = vfio_device_data(device);
+	vdev = container_of(device, struct vfio_pci_device, vdev);
 
 	/*
 	 * Locking multiple devices is prone to deadlock, runaway and
@@ -2323,7 +2304,7 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
 		return -EBUSY;
 	}
 
-	devs->devices[devs->cur_index++] = device;
+	devs->devices[devs->cur_index++] = vdev;
 	return 0;
 }
 
@@ -2371,7 +2352,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 
 	/* Does at least one need a reset? */
 	for (i = 0; i < devs.cur_index; i++) {
-		tmp = vfio_device_data(devs.devices[i]);
+		tmp = devs.devices[i];
 		if (tmp->needs_reset) {
 			ret = pci_reset_bus(vdev->pdev);
 			break;
@@ -2380,7 +2361,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 
 put_devs:
 	for (i = 0; i < devs.cur_index; i++) {
-		tmp = vfio_device_data(devs.devices[i]);
+		tmp = devs.devices[i];
 
 		/*
 		 * If reset was successful, affected devices no longer need
@@ -2396,7 +2377,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 				vfio_pci_set_power_state(tmp, PCI_D3hot);
 		}
 
-		vfio_device_put(devs.devices[i]);
+		vfio_device_put(&tmp->vdev);
 	}
 
 	kfree(devs.devices);
-- 
2.30.2

