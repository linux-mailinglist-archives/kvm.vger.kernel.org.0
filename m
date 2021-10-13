Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF3542C324
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbhJMOaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:30:03 -0400
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:8800
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235969AbhJMOaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:30:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dARwupc9KMz/vn3xWHQOgc/6GsN5DDYt9h8ThCEOBxoUeYx16kK2+AKBJzYWU1jo7ZhdDssu5m3Eoth7yOJemujSp8KIwEgM9mqaWC3edQxi1WEFOYJGETVBwR61pkzunjo4og/0UPX9oDrtK3Nks71zvJbjDFsVE0r/Ez7BYgPz44mHylcggt4LfW+uLB7ouxi9UQvsJmUxrkC7KW+2+mCoiK+Gmn93MCUZBzcrowRU2qw+JajCgtSKB/Mrp0nA5Flx8T3uN0s982C2y+X2BtVbkvKJiKbU6FFS1kUG4eNhMp2u0WTOdG4mAqvIqaFaeYmdWe6ohOSt5vuSqH9L2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRTVyfqgJjagox7qzl3O7iAwbq46kAWMAr7aDq6vmxg=;
 b=TNJUsEBIxxs8Qk+hVsIW+cEE2avEzHe1Q8leynlwBqe8LPuAakuPJr0N3fAOMwiGo4rfMu3jGqKI7V/3lgzVOkIGwZFonRyOHZXV/fFEk3Z+gP2m5IJaLiJpn111lXHFhvb5m2z5o+cza2QRwCbdiQhxd05CXTKdAXv8+nj5dkSXdiuZTyxa91Z1siKfO+AJ1RoY9O7VQP8cSsf+LFQXoyigqzmuxFBosNWYLuL3CVABy09TlTMpc+Xg9u0shf5bKINujzimzpS7+Myg7Mk3hGgspWD/0mCLoAuIS9JYE/f5KtVc4M9ZPO6CNNpNUyghE7aOIrqfYYB5KEw0m472XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRTVyfqgJjagox7qzl3O7iAwbq46kAWMAr7aDq6vmxg=;
 b=UJ3m9fE04gfYsr1Hivs57BLjz4F0zb0/HSkXvmfkfOa3jN+lcurd/O++t8vxzPbCvhxav/drXL2/q1jJC2N/sAVV9TqEyCh4YggtXjPzOKpRKJ7VREY7EDLMRcKQoSPKLxP0dpm8IPXifFxzakWN7o3+PqrPdW6u/YeWjqFInbcjtuaNr0gqIgcONfUJnbgjBsNsVociPQpJ9MIfA6fXZ9Q6GR+Pl9KqB086cehjSt66MmINxFVz3FMaJKnRa0nIvYGF+OBS7fuK0yYV4lnZixtgrRFNzbq59C2jXSVI0onyB3kcprKVqhBGIb8Tc50dM0jHqQRBHtfASlLIyCElSg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5287.namprd12.prod.outlook.com (2603:10b6:208:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 14:27:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 14:27:52 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v2 2/5] vfio: Do not open code the group list search in vfio_create_group()
Date:   Wed, 13 Oct 2021 11:27:47 -0300
Message-Id: <2-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT2PR01CA0029.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT2PR01CA0029.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:38::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 14:27:51 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mafEU-00EVFD-7R; Wed, 13 Oct 2021 11:27:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c21a7a33-0ee6-4b0e-1a22-08d98e55a382
X-MS-TrafficTypeDiagnostic: BL1PR12MB5287:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52874701C964BEC91C9AF5B6C2B79@BL1PR12MB5287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AIcnJ/bdYFDVpQyI7QKMeMZQ/V4L81Gv3RBocezoTm8HTkDs0ADAh9xtwlPVlWkCm0NB8eQK1u3DYlmI+gYSgAD3CplnpTETYzq/oUE82YpN/uKyKZLMTH16ZMGOrekdkilq/nuC8jIEEGhALXBxRC3ILU2ylxka3a7d0IVp5vjB/Llxl0Q4G87HtA/Gu3ejKH0z3eyJy2kPVxEu0ImGkPWdCixc0+QbDv7UqPTaO/wZWXJJgCfOkKdLK3a4WtbONfjcxCBRwAv8vijsD5k2llbVXohsjUH6743mjMGSA8IE2Z+e7x8Rr9SNTMMY+4jY5DgcxzJHwmdNVPw7gmr9a28ga8WqeRQoLPsoCzcPc0rZrD4YO0YxxSZiW4yFX9ceUL3fPmvBQGcYV52ikR9UItfzQM0Owmkix1P16A7qzysNp99efESp6Q93Y1cx3M3KH1BvxAWpw4HVlAEA2c5xDpKZ5LJ6PyW1NM8NpCs3DQXrpHPlcCS1ljTnAEC8Ihvg/at4ffOlkXUzOQVTog/YZwuRxJkJ1XFEMem1JR/1R12PFlIqq+FToE8ijhbAnDipSTgieptI8G4akACRsaLH3nGLM8NMHnMG5MG1/1RxKpHHEAp0M55wnBk0PoPuPfQ52t5hNHTv3sZ76aEJrhg6CWS++xpiYdGgO0CSKprmF3t+qyKEBpq9gSP4sVsCKsUo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(83380400001)(86362001)(186003)(9746002)(316002)(2906002)(9786002)(508600001)(66556008)(36756003)(8936002)(426003)(66476007)(110136005)(4326008)(2616005)(6666004)(54906003)(66946007)(38100700002)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnBrSnZqdHk1RXlDRGxKaStOVy96OW4wYXoxVitTWk9Cb3h0L2ZNMk8rR05n?=
 =?utf-8?B?dG84WGN4Mk11dE1sdDJEZThGd1ZBZjV5KzY5T01mdUxuSUgrZVhDQTQ2SFFr?=
 =?utf-8?B?UGJ5UzdyU25aZmVFb2ozc0xmak83ckxaaktKMnU3N3JXaWcveTVFdFdOU0Q2?=
 =?utf-8?B?N25CcVo2QVpZaitXWmtIR1lEUEt4TXVXS3QwRWRlT2dzc0dMdG90N2dKUUwz?=
 =?utf-8?B?dk1hVmNSYWE0N0Zzb0QrL0RMelNKVzFSZlFBWkcrcktlTHROQUloRzQzMVFR?=
 =?utf-8?B?a2oyVUFaQmV5bG02RXk2NWhSVDNrWFVCSEVqcmREL0FOL3V4U3pVQURadHFP?=
 =?utf-8?B?dXpCYmdnN0xoRUNuemh0RVNWU0ZKcGpNaUdSUDFrdkgzVjdwUjFmeEtYOXU4?=
 =?utf-8?B?eTJibWl4QjdhWFVhWkp2UWErM1JsWVhYOFlqcm8yL1JVSXU5OERYMDcrWXpN?=
 =?utf-8?B?SHhMdnJNNy8vdmlIY3hyNzgyZ0w5VlMrWmFpVVQ1WXplMFpxRVNXRFdEQmpF?=
 =?utf-8?B?RFBQdUp2YzdVM3dHdi9Bc2EzakRnQnBCck0rOGlKUUxkNjNGaEVpMldhdk1K?=
 =?utf-8?B?cUovVmlRZkJrZ1JBTkhhQ1RrWjdjYnNiL0RCcmRSVi9BY2hOM0tmUnZ1UGEx?=
 =?utf-8?B?TFpCb0NZWnhSdk0rUXc5cmhIRTVwTkRyQzNFL3NYbGNjM0dhd3dmYWpaT283?=
 =?utf-8?B?SjZWYWhCL1dvamdiRjMvbngwWXBUbUp3bVhUK1gxVDVGcElLLy9od04vcFlK?=
 =?utf-8?B?TEQzR2cyM1dNS0hmUXoyZXpqQ3BRcWhSMHpJVWlhZXhZclVQT0pONGMwZlhM?=
 =?utf-8?B?VkZSU2lzSFB4N0c4dUVkMU1tMkJ6TnIrd1pHa25ScU96T3c4SlNvZHVqdk1v?=
 =?utf-8?B?UW5mdTNDaTFuYVdNb2gyZ0hmandBNC9EdWk3Y3lWbWdhbjh4M2RBY0VoSjFu?=
 =?utf-8?B?QnU5TngrOWFmUzhLNkRGRVBQbXRVakVxbisxWktSZGtZYWlrVnhWRnlLekxQ?=
 =?utf-8?B?a09rL2c5NGlQeEhXVlRnWlJlZEZ4YnBZN0Z4YTlLdTZKd0ZrK3Q4eXpFYU94?=
 =?utf-8?B?aW5uZ0Y3cWxQbGxML1lYLzlTUE9JV2EzRzhPMXoyR2tKM2RyVWpheUcrTy91?=
 =?utf-8?B?eXJzOVlOZWNxNXRGNWZ3SDZ5S0VwcUdoQjYwWm11STVCWjRVdEZEaFZuZmo0?=
 =?utf-8?B?THZGa2ZqeHd1MG5ySndMT3BoWHBrOENLbHdudjBpaTIvN29YL3NWTHhDNkZk?=
 =?utf-8?B?aS9BbzI5RnZUNzYweHI2dUVsNklKNytlWXU5U1dGQk5wUEh5eW1ZcDlLNVVw?=
 =?utf-8?B?K01TY2NWSkczOU41T3QvQ0d4Z01sSUhIRzUzeTErYVdjbjFUcXNiWko5UmVK?=
 =?utf-8?B?eGxJdWJ1YnBCbFpYck83ejA0R1M4SEVMbmNRMWlOTUMxYWFCb1N6V1FKZG1l?=
 =?utf-8?B?ci9GQUNIalA1SEV4VFAyaXR3VlVXTlJZQ2k1SkRBOGlUZVRlNS9NeTRZOGNh?=
 =?utf-8?B?STlCRTBHQ3M4Q1B5TXZsMU40RUdqNjlESlRXZ3lDdkduanRHd0N0bXdPUjRz?=
 =?utf-8?B?ZjNqczJEdHFNaWpjWjQvcWxCZWp5dUJkamdMM3ptaTFENDhLcGFoQWRnQmNi?=
 =?utf-8?B?Q0p4Y3BCa2ZJS08vTThSRzRLTGFKQWRLYjNlWGhnK0hVMVdUVU95d3N3QlNi?=
 =?utf-8?B?TE9lRXFYd1dxTWpNZEhiTGJ5TFdCOTN5bTBUUjU3MkFqUmIrTFhZNVRyRkZt?=
 =?utf-8?Q?giNbbSYSlSBtKhUCldODTlhptSE0RUrBIcLuaA1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c21a7a33-0ee6-4b0e-1a22-08d98e55a382
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 14:27:52.0195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TL508iIlg2qgLa9LEig7pgjoqmDPHoskCofLGBmX1FZ6GzlOKMwT1feMEbidqaCp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5287
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split vfio_group_get_from_iommu() into __vfio_group_get_from_iommu() so
that vfio_create_group() can call it to consolidate this duplicated code.

Reviewed-by: Liu Yi L <yi.l.liu@intel.com> (✓ DKIM/intel.onmicrosoft.com)
Reviewed-by: Kevin Tian <kevin.tian@intel.com> (✓ DKIM/intel.onmicrosoft.com)
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 55 ++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 4ce7e9fe43af95..513fb5a4c102db 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -340,10 +340,35 @@ static void vfio_group_unlock_and_free(struct vfio_group *group)
 /**
  * Group objects - create, release, get, put, search
  */
+static struct vfio_group *
+__vfio_group_get_from_iommu(struct iommu_group *iommu_group)
+{
+	struct vfio_group *group;
+
+	list_for_each_entry(group, &vfio.group_list, vfio_next) {
+		if (group->iommu_group == iommu_group) {
+			vfio_group_get(group);
+			return group;
+		}
+	}
+	return NULL;
+}
+
+static struct vfio_group *
+vfio_group_get_from_iommu(struct iommu_group *iommu_group)
+{
+	struct vfio_group *group;
+
+	mutex_lock(&vfio.group_lock);
+	group = __vfio_group_get_from_iommu(iommu_group);
+	mutex_unlock(&vfio.group_lock);
+	return group;
+}
+
 static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 		enum vfio_group_type type)
 {
-	struct vfio_group *group, *tmp;
+	struct vfio_group *group, *existing_group;
 	struct device *dev;
 	int ret, minor;
 
@@ -373,12 +398,10 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	mutex_lock(&vfio.group_lock);
 
 	/* Did we race creating this group? */
-	list_for_each_entry(tmp, &vfio.group_list, vfio_next) {
-		if (tmp->iommu_group == iommu_group) {
-			vfio_group_get(tmp);
-			vfio_group_unlock_and_free(group);
-			return tmp;
-		}
+	existing_group = __vfio_group_get_from_iommu(iommu_group);
+	if (existing_group) {
+		vfio_group_unlock_and_free(group);
+		return existing_group;
 	}
 
 	minor = vfio_alloc_group_minor(group);
@@ -441,24 +464,6 @@ static void vfio_group_get(struct vfio_group *group)
 	kref_get(&group->kref);
 }
 
-static
-struct vfio_group *vfio_group_get_from_iommu(struct iommu_group *iommu_group)
-{
-	struct vfio_group *group;
-
-	mutex_lock(&vfio.group_lock);
-	list_for_each_entry(group, &vfio.group_list, vfio_next) {
-		if (group->iommu_group == iommu_group) {
-			vfio_group_get(group);
-			mutex_unlock(&vfio.group_lock);
-			return group;
-		}
-	}
-	mutex_unlock(&vfio.group_lock);
-
-	return NULL;
-}
-
 static struct vfio_group *vfio_group_get_from_minor(int minor)
 {
 	struct vfio_group *group;
-- 
2.33.0

