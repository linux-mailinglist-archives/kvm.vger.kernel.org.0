Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EE7333115
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 22:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhCIVjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 16:39:11 -0500
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:47776
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232039AbhCIVjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 16:39:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZkmL7T7d8xQwtvZ4zUrFT0uXWZXTgw1FgDF5xpUiVlLUGmqWj8h01iYhDNBELnuZIBcIZHs0ec/hBO2rUzM+yaPJ5f6ZOq9sBpMlInMLOZ6f9PQi9W/mYj3HzWQGpM/YJwlLrBHE4gGJIE8cATU11h0AztywSDUIctk0/l5z/cccBVVx6eBQkrt7POQ1+JkwVs924L9zTEZB8fjCTn5mNXv1WnjG/cUD2LCOoRPGNJjKMEJ+q5OtAGq6QlDOIlgCqlSlwekh9G54C3UCGk74dAE2VXF9wu1r53vYYyGEZ5n2MD6hxhh8P4FEYNcErhKA/8yjeaY6iknYt1M8ilqpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6Wg67zR2Nd9NFi7Dy7BBNJJIXLR52eRUOecS05SWyM=;
 b=WIln/iEYAJQUiAWWDmkD27nNFg9N4DYyupUtbWEGj5UFH3BMxVEe3spd2b1MOY1iv1xkrAbwI05WFuaTZ5ReIVZukyWZSj3enfBjveNWaabbOxRecZ3J5Z3GWcIP9SCHkYzXPYbB1wx7b0y8CEpEihLxikdDVtL4QlwHCM6zBbTCCapSXyEax9xZYZETe1H+zqMB3TLTzrU8BsEPZXvQXuwalr+Sct2lEpLPMwIqyEpCoZ9WDafD6SoIpDx5fRg9bScbMxmShH73hH5eWM0AVRJlJdEY06BD9lTVOLyFY/CZlvRLHzb4UnoLRvlgMJE7e46mkAVvEhfmT+FlahUhPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6Wg67zR2Nd9NFi7Dy7BBNJJIXLR52eRUOecS05SWyM=;
 b=cVK7Yy709gE2erhRHrRMvESwZSITgTeOMKDa6oFhGkSuoPyNVl3gwakXrCFl7YhffPYTNfJzFvdnteRhQVeof9tADWh60Us6MUAMgQ2rnqXJx3+UomLGiYxQLHrlcY2FZyPgAYAN8SgyvMFV1PIjwRMgi/0Zz3DwtgNijDV1IS0h7JbOmoIhCT/PXalrdOyeDxPrH9xMYBAv7qvdBVr/ue1MwNJUJOH7fGZ/6AS0K+e1p1KZvWMji4qm+ltPiQPLxycGEHgQlXwNzlIr1jFKZV/nXDoF3oV2e89quAV2ncp8B+6qgpSBpuWDeUUR//p4D9apw42DmWJGfmmGVRya0A==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1243.namprd12.prod.outlook.com (2603:10b6:3:74::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 21:38:57 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 21:38:57 +0000
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
Subject: [PATCH 09/10] vfio/pci: Replace uses of vfio_device_data() with container_of
Date:   Tue,  9 Mar 2021 17:38:51 -0400
Message-Id: <9-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR0102CA0048.prod.exchangelabs.com
 (2603:10b6:208:25::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR0102CA0048.prod.exchangelabs.com (2603:10b6:208:25::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 21:38:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJk44-00AVJA-Vg; Tue, 09 Mar 2021 17:38:52 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bde2340-025c-428d-f928-08d8e343be41
X-MS-TrafficTypeDiagnostic: DM5PR12MB1243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1243AB2ADB66EC62AF7918B3C2929@DM5PR12MB1243.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 69AKxiXlP4CkewChi+LUqq8gkNC7zfN2dRnXtGnjZQpmMnmvfeZd2bkpRY3UUFURErEX1GwawbvhwDTm52amdThDUUAeShn8IKpJP7mDkaQLolkB/H9dZdoM/5KS+mHKu5KmmQUbZdCtEOhYnkyu495p0z2IBX361+DTzcwVsU9sJJvbjU99Z4Pke1iF5diH/EtIkR/VKZMXvHn2TOEvZ0upvPUZ+TYQm8FoMCOd4qFCxYP0x4TmdZhwhe45X9HeSLkBGAXqsGRiFJzPDQ1AWbFrd4hQcmc1+Hla1zDFn/rB/GMNohUHSQRGP4BqBaAUup924CmkfTrnJE0uLDYkNljeUEpyvAdcxPr9Ad1QX+DNIyXaeDidnCC6H+MnaaJpV+7W1yAz7j5spwL95zaIo3m/Ac7blzHKvGQO7MjRQK9pOPK5T3GKjDX7itkPELrP9TA8z8+eCIsgI+yRiNDfe7k3/h2uuFrWAmEqgxPIBc0QX1cp9VpbIvEbTZDMZSoswXE8vpjXRl0ZJMbl/lIVqVPRXKylz51K6HhNyUqvOEc06XIr7tJUbkaz9fFqTkqa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(2616005)(83380400001)(426003)(66556008)(9786002)(66476007)(9746002)(107886003)(66946007)(8936002)(186003)(2906002)(86362001)(8676002)(26005)(36756003)(54906003)(4326008)(316002)(5660300002)(110136005)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9l+F7Gt9csU5i0SqcQutmvyUQ1cDYS0IqEL0Hrc3B5TPmFMvwZNcCqOaUQPX?=
 =?us-ascii?Q?J7qe/U4NtxyVgaDEZJWmyQyxNe2zxjSAzxPwWm1epjIF2A5a0CtqT/mTjL9b?=
 =?us-ascii?Q?e41961JLrZjzZqjGkINX45rr2Z+SCk3gQikxYCdsy+ZhtW8q7eYODgCJqYwX?=
 =?us-ascii?Q?XGgMU9qtjpoQ0vNMqboinPEqD+Rqyntc5zAQNZ0I51rGe+VuLk7XpJEOQlny?=
 =?us-ascii?Q?01Dag22J5YjDq1e7+LTI0Ana4Bvse2UUhG4GH4XQVI+i7cDOxsk0k/h70bUq?=
 =?us-ascii?Q?h6KLo9Z9B2Q2K1lvquSbm4kFVUxslq+1e0IXWcJAhAXRD4IoiT5dcCDnla2o?=
 =?us-ascii?Q?3JrC2es6ROOGPbIepW+tFhgx8VwkCC5kzJIOPeGPXTRUYCP4xa5pcQxeo4OL?=
 =?us-ascii?Q?6bcm1G3U4xqZpyCqXIwhnUb/3NAUH1xxzDP0bQP3gDaF+W1rsvmJlln1XnFH?=
 =?us-ascii?Q?JCTlqMemedeaQr4bbIIu766dgDeOV/U8CHtS56b6e3ZovryCUQkeA/eDInpA?=
 =?us-ascii?Q?dbCokSN4INyl9nY5iAWg60RE8cyUqtLHhyaMiWGpES/UV7zcZGJk0z7Vgd9o?=
 =?us-ascii?Q?wyZsB8DjvAWWf1mkNcGbrIhCgCVQiafPFraiETSjAhEf54rBp6GTlsF3Wn9G?=
 =?us-ascii?Q?VwOH2g2j22DdYgrcm+pbQyl0MBByxIWp4/AZkcG5Q01hgTfr84dmkP42Xn1r?=
 =?us-ascii?Q?/WWU3a6XQDVSe7u/j7414mX7yc4i3+g6T+cG58a0/n9sFXxZBG/5NL6zGkKD?=
 =?us-ascii?Q?V5qZFQtmBLH6pXtf2s2Nv52EeILvKCnxawxGmh1z6EJmqDFkjVpC514nh4bO?=
 =?us-ascii?Q?QigKt6L7cVWKrqcRB7WiYAWMRaj3VcuVGwqXPJwRhf/1Vfns9BjprXku+OEv?=
 =?us-ascii?Q?LrVIX5LgMmiG8jdMsd2DD9OWIdrZ6spa7R/hyM9jiPQEbCK3jdaOAjrIxGo9?=
 =?us-ascii?Q?kXuu7G1vTLNe6cbZ/VR82Z+/854lmuEiGfAQNHLY5wBjFCdp84RWWdf/w1WP?=
 =?us-ascii?Q?wpYxo7J54Oo/aA9qDYQwtMFKVsJWLRcOh4jzAUYBxBJdX+ZR6aBWlRreP3K6?=
 =?us-ascii?Q?IsTmPKLgYH/PkQ/mk2YpPMd6mLDVhs2bxzeTK79iENpAPjkUVosj5jmyvFbF?=
 =?us-ascii?Q?wF4XZpoYiiSSn+EgnM1fHr42gsNFRz2tOk+H5oDhXovd0e8ogw56p6FO5aTI?=
 =?us-ascii?Q?f/evDR1nynpuNP84gaZfCiX2mG6qgJMB0Up1nENwHxFwu3K+jkCw+gLSzW8Y?=
 =?us-ascii?Q?sHAXuqwtNutcktFv4UhisY5wldBZ6q+1uX3q7KGKCy3lKil3VUcPUXusloLe?=
 =?us-ascii?Q?TrkUyGdYhXTYi9wOZq++XmD7Lye58iImOpXFRpErIXeTIw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bde2340-025c-428d-f928-08d8e343be41
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 21:38:56.9482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7JDseyi3YtrBN83pPoTlikV1GWdgzftxl9ZLaL+41Eq4hnC5PLjZ3mp+mN8DrsBW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1243
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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c | 45 ++++++++++++-------------------------
 1 file changed, 14 insertions(+), 31 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index af5696a96a76e0..4b0d60f7602e40 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -534,7 +534,7 @@ static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev,
 		return NULL;
 	}
 
-	return vfio_device_data(*pf_dev);
+	return container_of(*pf_dev, struct vfio_pci_device, vdev);
 }
 
 static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)
@@ -794,7 +794,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 }
 
 struct vfio_devices {
-	struct vfio_device **devices;
+	struct vfio_pci_device **devices;
 	int cur_index;
 	int max_index;
 };
@@ -1283,9 +1283,7 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 			goto hot_reset_release;
 
 		for (; mem_idx < devs.cur_index; mem_idx++) {
-			struct vfio_pci_device *tmp;
-
-			tmp = vfio_device_data(devs.devices[mem_idx]);
+			struct vfio_pci_device *tmp = devs.devices[mem_idx];
 
 			ret = down_write_trylock(&tmp->memory_lock);
 			if (!ret) {
@@ -1300,17 +1298,13 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 
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
 
@@ -2094,11 +2088,7 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 	if (device == NULL)
 		return PCI_ERS_RESULT_DISCONNECT;
 
-	vdev = vfio_device_data(device);
-	if (vdev == NULL) {
-		vfio_device_put(device);
-		return PCI_ERS_RESULT_DISCONNECT;
-	}
+	vdev = container_of(device, struct vfio_pci_device, vdev);
 
 	mutex_lock(&vdev->igate);
 
@@ -2114,7 +2104,6 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 
 static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
-	struct vfio_pci_device *vdev;
 	struct vfio_device *device;
 	int ret = 0;
 
@@ -2127,12 +2116,6 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
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
@@ -2192,7 +2175,7 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 		return 0;
 	}
 
-	vdev = vfio_device_data(device);
+	vdev = container_of(device, struct vfio_pci_device, vdev);
 
 	if (vdev->reflck) {
 		vfio_pci_reflck_get(vdev->reflck);
@@ -2254,7 +2237,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 		return -EBUSY;
 	}
 
-	vdev = vfio_device_data(device);
+	vdev = container_of(device, struct vfio_pci_device, vdev);
 
 	/* Fault if the device is not unused */
 	if (vdev->refcnt) {
@@ -2262,7 +2245,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 		return -EBUSY;
 	}
 
-	devs->devices[devs->cur_index++] = device;
+	devs->devices[devs->cur_index++] = vdev;
 	return 0;
 }
 
@@ -2284,7 +2267,7 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
 		return -EBUSY;
 	}
 
-	vdev = vfio_device_data(device);
+	vdev = container_of(device, struct vfio_pci_device, vdev);
 
 	/*
 	 * Locking multiple devices is prone to deadlock, runaway and
@@ -2295,7 +2278,7 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
 		return -EBUSY;
 	}
 
-	devs->devices[devs->cur_index++] = device;
+	devs->devices[devs->cur_index++] = vdev;
 	return 0;
 }
 
@@ -2343,7 +2326,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 
 	/* Does at least one need a reset? */
 	for (i = 0; i < devs.cur_index; i++) {
-		tmp = vfio_device_data(devs.devices[i]);
+		tmp = devs.devices[i];
 		if (tmp->needs_reset) {
 			ret = pci_reset_bus(vdev->pdev);
 			break;
@@ -2352,7 +2335,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 
 put_devs:
 	for (i = 0; i < devs.cur_index; i++) {
-		tmp = vfio_device_data(devs.devices[i]);
+		tmp = devs.devices[i];
 
 		/*
 		 * If reset was successful, affected devices no longer need
@@ -2368,7 +2351,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 				vfio_pci_set_power_state(tmp, PCI_D3hot);
 		}
 
-		vfio_device_put(devs.devices[i]);
+		vfio_device_put(&tmp->vdev);
 	}
 
 	kfree(devs.devices);
-- 
2.30.1

