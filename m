Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6AB339A9B
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhCMA4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:56:35 -0500
Received: from mail-dm6nam12on2081.outbound.protection.outlook.com ([40.107.243.81]:44481
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232257AbhCMA4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:56:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3QmvPvZuZdXgxlsPsvfdnDGJYY7xhf2rIHGEmo1LtvZRFkIa3Uvksdy+Y8py+U6W/i8ivZ86OiabXLlVBAKTSXtyirEe2V68yStYKSAuQPw5+1ONhb0Cu8hPDX1hXxjElDBLPPxaTPyGhVAZS1A2GfclJdFSGg2xHFWVV90bcCXSW8uMI3r+8Pyam7kYs0eogQ9I5z51p6tcQJbRYp/gbA2KU4uyb1ts68XjggpWHln3lSlEIzlhDcbRwfjtmE3TwZsW11mgiWnwo3HA9b6rCsnC6hv1WnoU/wx1bwQ5MYgYCYJ3MEXwo1DMAVM2EDlg3Tfjsp0ZhNPGoOF7LJrqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiIyIwO7kq0WsbP/stKbgYgvl/RRRz075uzNy8ghGqU=;
 b=Yusi/BdGc2akABjOLKui1IBb5TqUHZV5DtpvlSPqAmJVSrZR8oxg/21EhviiZ0W2akYLpHtaLuPCSCBzhZnYhURtVnGtmOsuMsovnEoWOA0ioWFnn4sj049nxelfHtRDYvl7CUhQZNU1QonizcUau1+7lMfGwxzCj3TTkQwhf79F4oxCpCLs1+69ml0Cr4/TKT9uUut6XtW1ETFJa2DNOS7E6az563Pv7s2L/jw4So03ZOj3MDUBAGYr7vqIM6U3VpwWkVN+dNQEAxCBagjIozU8qb/CYJ16+6kH2F0+g9BsJnLpb05OghyWq0tTfomgIYgsRWHBV0fs5LBysTcrPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiIyIwO7kq0WsbP/stKbgYgvl/RRRz075uzNy8ghGqU=;
 b=GZrlcfB+rmd5+arvlLiMNmImeH5/8uM8dYY6OZhr4t+2hJoqmFO4TIWFexYQdNeOzrLQZ2YjkRX6Of3a3ES/4gJvFmIgcaqaIT0orQVCAFkOAUbHRT0INkMbtcghoD0+2OYSzNulJSeO1My/cYcEw45uorugCgO2GiZEcWoYVJFY9JURETupu2cwIr8rRXWykx0Usu46e/5AcS2xgG77FsRI4qlYEUdRO/QNjJl7MjozdO2VBa6HElY0PCAWvwS6bf4X/ZzOnIar+DlMgY+J8Er6UoUMNHnd3R2ugS5lzXTD2G635cNJYH7z3Frg9Rc1RZUubK11wpcD6g8Kk2P0TQ==
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
Subject: [PATCH v2 01/14] vfio: Remove extra put/gets around vfio_device->group
Date:   Fri, 12 Mar 2021 20:55:53 -0400
Message-Id: <1-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0167.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0167.namprd13.prod.outlook.com (2603:10b6:208:2bd::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend Transport; Sat, 13 Mar 2021 00:56:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZa-00EMAl-O2; Fri, 12 Mar 2021 20:56:06 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2f89a1e-ddc2-483b-fbaf-08d8e5bacc0f
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2940B7CD961EF9AD5020EA52C26E9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OkbSiz5DKmDdxxixlQ5D3NEd6SQhl4Nwr9MsPqZ0jORR6+QSQ4vt2e/7APctEMNl1OQpaBVlaQoAz4FOYr538uDCan18v2gObs7SHumkF2dLY6gkFz4gPhtqdnGBoaAqSnevOoRWJ+a2LjlIIrwfdVUabqngpV2Op84ZMS40FQNl5y3C9Bm19D1AFYrzkAzZp+UtR4XEuf6avJbGEVsNNwp2Glm7b+GtkCmyXQCL+pAjoGeqWVqUtuJU+4gK6hds9iplKjlhXGUY1LHH0vdYcJhk6SpAUjbR9hYDQcEQlqh0tKxB5AVAXEhkWIm7o6opSJcRxe5QT1RPDPyK1+AxO4xRU8NVGDvy2igphmF5xtGjvNO37fMq7WjeVveQEHa7Yy1+vDAxR2E8kLsSsooCEqnJcJDF/Ddyf8WUX/ZWfJD15X4+Z5IKxpVliEkoUeFRCgicGqDiSwxP7AL7/TyAiQkVDb+Tiz+H3MFHbRpUsQD+9nldnPPcRphlE3Ixd0DM2Ob4XZoIbbK3sSzqgNByY1CfFqrq2aQdGVZFL3v8VT2y3IoWNNAlPmTMW/4Ea5wrrubySEhc1q1QhDC7+1WQa+nPSWwSTL390S7YfL2MrdA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(9746002)(9786002)(8676002)(6666004)(4326008)(107886003)(54906003)(8936002)(5660300002)(36756003)(316002)(110136005)(83380400001)(66946007)(66556008)(186003)(26005)(66476007)(478600001)(2906002)(426003)(86362001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?q7xFN+pQ/7yjY26wP2x2FkSGX2sGIUD806jRqr2TiOxkt9c0KxwP84Pdguma?=
 =?us-ascii?Q?AnOx8Pr1/fTC7tIjEXOwpV9cOmIBGySN+eeNuDiRaxQWrM8XT96UW1MCaE/p?=
 =?us-ascii?Q?IwclpHh61zx/iD6kifii/55emoAqtcybS6LIC2g8lMyOoGaklM0+QgG5RXbf?=
 =?us-ascii?Q?jVlhffFedeppuvjaqIFEHWw6eERzRqoexDY10fPrCfF+iLLIklqP5AUTl8ha?=
 =?us-ascii?Q?zXXzkKerYlb7xi2tNcJUoXLdZOjdNiI/VT4i95BicCFDZ+hQQZmJ9TTkA1FH?=
 =?us-ascii?Q?Z4SFp1CIkY6ODgY7EqerQ8fuWCmPZn0i29ru4ek+4WjH1X6fkGoZ3ZZT2yCV?=
 =?us-ascii?Q?x3bOkypCSQkKZ/v2dw05fGrHnF+UcWe2wlkGjOG38+MIjrC/Qp3zDHqyTIH5?=
 =?us-ascii?Q?Ox4IMNHuJpu5OYJXg/0n+QNJiV82scO3RjE0gg9s/z4xsnsMT1djkt1Mmzw9?=
 =?us-ascii?Q?afELRgUf/TexPVntBJwyvON73DG+Oq4Pmztsta52xc8HprWv8c96XZFY/Qf/?=
 =?us-ascii?Q?paM4jta8rTdpDBNc9yqhLh58Eo+xO/tyKDY9vpCNhdZgcb+Zq1jVMmE9cOEk?=
 =?us-ascii?Q?up5M0AJoFt5NzzAA962N0yNSBDnDcg4F2CHK5FhHBfq2NRnfq3jcX2bKlpmJ?=
 =?us-ascii?Q?uvWrn9y4SD3kXmpMOdW0l2qhJA2HjHVl3GBeLaYOZM1ZuTmC4kbEZFaHIl5D?=
 =?us-ascii?Q?DjylxdnUEq/5ZZ61YRBTsih9aztEqlyBeAnUmktSLUslaQpbmRYztq8a/EC7?=
 =?us-ascii?Q?mI7OG+Ogdx5C8pIc6xQDCIDU0eeoNV6/dGgfkAgDUyMPF6XuoHJzt/rmJWzB?=
 =?us-ascii?Q?mcTTQbOWr9gbOn9Kmw3qq09qbHkoPOWfmal03fRWCjiEBC9rZUOMtARwV35N?=
 =?us-ascii?Q?8b3e0m1KE7v3MVBpWBWxFJ7AGhGEC2GySL7UTNJ92VLcFlWTjXe8yN4GORk9?=
 =?us-ascii?Q?3bXW1GIi0RmQvVkMuPv1juLnfGi2+rrQv5pq3pPYuhGF1l9t9jIgVpsWdHhl?=
 =?us-ascii?Q?zfaor/QkA5uado7njiOFkrbj4/vxBCDau7iJMOYGAMRkhRAIV66Nb6N0u4hE?=
 =?us-ascii?Q?zxs1Bh4kYgno0BMr8ijKyH3Qy+iztPLfNdYn8NRmU6EY8UWIcba/yXGBl4BA?=
 =?us-ascii?Q?gGM4kykdEwQ1oLhGB5KIPsORY41M1rX+gIswd0baEAG28UMOogyH2nbcWqZf?=
 =?us-ascii?Q?ExIn97V84jlGfOWp/jcTzGN3MkwtQehMCb7qn2+ct0xfX+ROszZbSu2+29dS?=
 =?us-ascii?Q?C827LsHocERxRAsbnQNuRUJFCP3KseUdasVcWCEXAVlimq/NjaipnI+I71kh?=
 =?us-ascii?Q?Uv4TfR25p3MFoLPw3rNzjpbT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2f89a1e-ddc2-483b-fbaf-08d8e5bacc0f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:56:12.6290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ROdzgl/WGRpkVez3rSzhCh4zGo4a/Tz9JDvVkJkcqq1pC3jSpmegI+WDbKbLRy2T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_device->group value has a get obtained during
vfio_add_group_dev() which gets moved from the stack to vfio_device->group
in vfio_group_create_device().

The reference remains until we reach the end of vfio_del_group_dev() when
it is put back.

Thus anything that already has a kref on the vfio_device is guaranteed a
valid group pointer. Remove all the extra reference traffic.

It is tricky to see, but the get at the start of vfio_del_group_dev() is
actually pairing with the put hidden inside vfio_device_put() a few lines
below.

A later patch merges vfio_group_create_device() into vfio_add_group_dev()
which makes the ownership and error flow on the create side easier to
follow.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 38779e6fd80cb4..15d8e678e5563a 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -546,14 +546,12 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
 
 	kref_init(&device->kref);
 	device->dev = dev;
+	/* Our reference on group is moved to the device */
 	device->group = group;
 	device->ops = ops;
 	device->device_data = device_data;
 	dev_set_drvdata(dev, device);
 
-	/* No need to get group_lock, caller has group reference */
-	vfio_group_get(group);
-
 	mutex_lock(&group->device_lock);
 	list_add(&device->group_next, &group->device_list);
 	group->dev_counter++;
@@ -585,13 +583,11 @@ void vfio_device_put(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
 	kref_put_mutex(&device->kref, vfio_device_release, &group->device_lock);
-	vfio_group_put(group);
 }
 EXPORT_SYMBOL_GPL(vfio_device_put);
 
 static void vfio_device_get(struct vfio_device *device)
 {
-	vfio_group_get(device->group);
 	kref_get(&device->kref);
 }
 
@@ -841,14 +837,6 @@ int vfio_add_group_dev(struct device *dev,
 		vfio_group_put(group);
 		return PTR_ERR(device);
 	}
-
-	/*
-	 * Drop all but the vfio_device reference.  The vfio_device holds
-	 * a reference to the vfio_group, which holds a reference to the
-	 * iommu_group.
-	 */
-	vfio_group_put(group);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_add_group_dev);
@@ -928,12 +916,6 @@ void *vfio_del_group_dev(struct device *dev)
 	unsigned int i = 0;
 	bool interrupted = false;
 
-	/*
-	 * The group exists so long as we have a device reference.  Get
-	 * a group reference and use it to scan for the device going away.
-	 */
-	vfio_group_get(group);
-
 	/*
 	 * When the device is removed from the group, the group suddenly
 	 * becomes non-viable; the device has a driver (until the unbind
@@ -1008,6 +990,7 @@ void *vfio_del_group_dev(struct device *dev)
 	if (list_empty(&group->device_list))
 		wait_event(group->container_q, !group->container);
 
+	/* Matches the get in vfio_group_create_device() */
 	vfio_group_put(group);
 
 	return device_data;
-- 
2.30.2

