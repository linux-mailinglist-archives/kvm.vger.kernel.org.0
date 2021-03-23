Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB4F3464BE
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhCWQPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:43 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:23521
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233165AbhCWQPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUtGrwfa6s4Wq3MH8uQg0dL76zTD8RnvmM39Nmwu2bXDKqbgkU/7oHIZYcJOMysNRjzl6CusUy3NOzp9ojIKWwDmaxt0o5KoiTu0DiYDF+H/OxdChxvkFymG7tmzNrJcEOkz6UbjUKSpFO2sp+3cXYXd5CFvJ2ZeVaEZM6lWl2MD9eQHJlnmvDsh0/jcS4AB4pekPXLS+tBZhqWLKfiWZzUnAahNYS1US1pCJyV/JMFAu6Xq4Gj//3uJhCErYnr0Hfj+v+YUq9C4io1nJb6wVYnCOmeoeX7Tj+l5ywmOK9zF8LcQcwKXeuREX0qEXk3KAahG4zt9t6I4ClUknRlMbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLo/UiP+k06LNuQAbMuufjeTq/JGtQ4B8qDrtHi8/+0=;
 b=CcYe279uep/g1tz8CJQxfv97AtgXdEUlHflaxJ0YT9wBtvhBiUN+kUTleNkm5a+hEbTWCLjHI1auk4N/NdWgmRpXAM5be8e8mdjkNQtuek2L84WMjY+NUYHlH8IRTIpLVQpQk+EVJKkt4Xz+fSdf1EtdNy73YOneSQ/RvMrhg2s3ODL8A2bVXX/kVwDBmIQ+bgMMe9Uzjzkz+14kQQ91TO71jNphsl59JBDvagyuzJVpwJOWfDtOO0ZKD3e6qHn86ayqKkfoQiGvjbqzr+wCTwDhM8qFB48usIPJcZEIvka5lwlGrf94f7gzKJ4BrOjmGsEw8wPsJ5HCTElZSv2bkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLo/UiP+k06LNuQAbMuufjeTq/JGtQ4B8qDrtHi8/+0=;
 b=Mk3wnjdLALi5/ch+Fo1jT2mswsJuJmRyTGnSeEjL5CAH2A5bgw/Gy3EfB5FKWAQ4/KpdEbJAtB+vK9ocTQnWPKF2G971wdmSM1AtVl+Co9RCSeZi/0ZmsggETbCmAl+2TRqA621UH/SqgFJPUPka9aYvf9ENhHhyPerP/oC+tfAYf9rtufZTmTOVnf+LtEt+X/v3zWRCmdRUzLLRSo/Uq7ebyqyZfWHkxLYIQCmBy9tKGl1ueNWgSBKP0t4g4eP1GxZcy6O1pzQK87879noJ51LfcfZ5OnAeCW3ercQi2m1zxQ1UdvCDMzzEEL04UO4DzKFwLK9fYqxMHViXj+yAHw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
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
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v3 13/14] vfio/pci: Replace uses of vfio_device_data() with container_of
Date:   Tue, 23 Mar 2021 13:15:05 -0300
Message-Id: <13-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: MN2PR19CA0009.namprd19.prod.outlook.com
 (2603:10b6:208:178::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by MN2PR19CA0009.namprd19.prod.outlook.com (2603:10b6:208:178::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 16:15:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aDB-Uv; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aaf17599-4898-480f-69c3-08d8ee16d56f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4267CED8D008CB4CB8530720C2649@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KEu+ongjVEupw00NCXJVYPkfrB8gktpl51rBagg7uZIlrXQGqsmRK1l6iGXqN8+rwKhjX5InpjwwQfiOtTDQ+rPCJ+fSebvmf7FAKXcOhqcQLr6kBFTxlcHiy5y457shujtvoldqp8R1wLnWfFaYjPo5Fnqp3JiWC1n0deH0YCCIWmTdnyiIcEXmW2mr175K0zxGUNF5os8Rf995RjSKcvMKWSyZlgilyCJ7Rfs1D7xs83IE2MBqO/IqOf0qUeItP2rpK5viRwNIZHaESD132x1HJB0syWpsXwaF1RG60C4+EShmWhK3k82kMexLVRfvkmtCjPgT8RiSP7n7Z0Hhc5QZxn8ORwNzc2KjbpPe84dj04v0/eEzU1TLZBQ7tlrP64PWeLs8y1pLatNgw41RRMxJGCcjedO4pXUCh4R4lxJQWFQZk91Ieos2LQpVDP12ZkpnhQGr10iApVptdi22ZgopfcGp/j7sE8KjCbK1dE4CK5Xv4/wT5hYi0TRMMG6TI0FrmkVwdt2DFWztPtXhT8Y3KEB+fVLssGmLCK7TkmiD2W/17uNLgOKXFFpzIgaEMHe8ct5ZDKDSWnB0P+mzUWIOr8xUHZrdMl5jOKbPL/5PIoYo4G+F+7EHVYGOnfF9VowxdwwIdzORDCLKchdIRRiHFWjxSUZ+QVegHqocrao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(5660300002)(66476007)(2616005)(66946007)(66556008)(2906002)(186003)(83380400001)(426003)(54906003)(316002)(8936002)(478600001)(8676002)(107886003)(4326008)(26005)(9746002)(9786002)(86362001)(36756003)(38100700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EsMsdfT1L8wwqSlt8pdRZeCpLI/1wfaWjcaD0Tr+h4gjcTiZeQLN85GFtIFY?=
 =?us-ascii?Q?qefZSBQHBNU+WqbxfMr2zdXfe5UxXmM7pKWJZ9Al/xUbgkw1eHGhMbLbD9Iz?=
 =?us-ascii?Q?3y3aN7ncWsbv54K7LXfLlys3jd+Wug2PBiOk0nC4qWypCqOX0SuAp08vQY19?=
 =?us-ascii?Q?Djc0+LUouLn76Nxi/bqIl5RKxd5ovQaaSMqQCmZtsYmu8qIQbpNMtiRy5Q+j?=
 =?us-ascii?Q?WTfwAz2UiHcBg9nGFmoPyYpmE/exesLJvZG61nuKhFyxoMm/vT4mEAGstid0?=
 =?us-ascii?Q?mnG2oYfMzq+cao3C/PRl+OQDGEnQvQWeQ+uLNdry4BkfSCYHt7WAGcNWKYTw?=
 =?us-ascii?Q?rzvb1GjqKhDlSPUWU+6xqkq4VuRleVk4YBcRBe+mkWHuDdOJxh2dmAhXzUcB?=
 =?us-ascii?Q?Elx5ksfMeh2xk5r4sWRGUgBwzGuvy0XN+c9CejzWxX6dzHnIr0xsFzRhhoDk?=
 =?us-ascii?Q?4Ok2PQpwZHEMARmZl/1vopLgWQ9BoNF6xK7NF/z+Ceum1fIw5bnBKTag2fZt?=
 =?us-ascii?Q?xqjhNgyMtWYy9q7Aml16O2Hb+aZg/vVipi02L99z7r3H5bpe+ACsLToNV1ae?=
 =?us-ascii?Q?7rJPvVrZVnonSeaMQvI6m/VRvCohHQF2eH1AFFaVJTAxjrql9p3fVoFPHi6u?=
 =?us-ascii?Q?dlFD+yJhg1SzkTHyXL3tCqIx6PopyR46+N3QkFWcZkEhcj6NKTDN7L8Q++XN?=
 =?us-ascii?Q?pCV1wnaKdbq/aKxb1AAyI8uHXqv2DK0X9LP9LSQAHA7O3+U1arRdwLSaMU4u?=
 =?us-ascii?Q?toJzPrZRDMKRDjr0Uk6jbn+g72zmW1Dur3xIToTffd5cdjqPtqRQ+IY5EysC?=
 =?us-ascii?Q?Z/Sev4LzrWLvEcJ9xvOdnyvcgkI0EzvRidQyrxjTOiYv5UvHGyzWEzQkMEAi?=
 =?us-ascii?Q?gkeN8VNSHc7IJzlb/CRcwC22s7wqC0S45+FABLz+zyTYrBMu50rJA7kM423q?=
 =?us-ascii?Q?mCwa7Gs8BQwNfZCjtoOI6osZt4pZuWQw6TWqU9N5a2Zp//bkrxazB6uJ6Vgf?=
 =?us-ascii?Q?jXXN2JabKFuOEu97XxTBEeR+0lNngK1LYHnUdKsJlQBHz91lV7KPCBwqgOiM?=
 =?us-ascii?Q?NDtDY7yjuyrtYpTCYnMjHf5BdEGBEvYAAPdv2b+sjvTiW/OlqzPJZDHDkT9C?=
 =?us-ascii?Q?DZgtJNoXKyBVSyrCuS9QgekoSBKqGmekjV0QahHVs3yq262fbo53rS/Z97qb?=
 =?us-ascii?Q?u8XWcUpWmfe1fBKqw5NNz3Kn+FJ3Y3r5r8wfYicWYoyBuRDCw0EbHVqIOcnq?=
 =?us-ascii?Q?YeVtfobPlMpjSLHBhmHRDXVlETGCDSLrh9v49OJJXJNOS08yxSWRX4Ljrl0S?=
 =?us-ascii?Q?No11HJfiSHKTo3QwGMbh282v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf17599-4898-480f-69c3-08d8ee16d56f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:11.2493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtsvSmRLv/oT9nukS14XzroFRx+31oF4aUNU1aGseJSiddLWzzYwHBnDAcZr2jWT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
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
2.31.0

