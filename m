Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB2C3464B0
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhCWQPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:35 -0400
Received: from mail-mw2nam10on2048.outbound.protection.outlook.com ([40.107.94.48]:9569
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233132AbhCWQPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ItPLBrK3bn1IT4x00vSBt5zNbkjHHyKtZVf7hRvB+utrkHsRJxZcayLSkqUt5qPO58rM2di0BROtXTUI2RQ6o791m2ujLXytp84rrn796VtNJ1R5kA+RjAt4pkUoqGe6CCHqffQu2xLWgk44UeqInzoC4XWPj+9ozV8uU8cDAanJgPIOdBDnF8W33JeoF68zti7kLsEc3CH0FzAY+hWEDJL201uPy+l8uc1rSCP+vx7tPDSEXWXvCSPdtWeNeSkkMbsllObPhw7sqPz0Kyx4Dt9Ym3PDXnKxu+HudPB3eJsQF3Th9+zry1Zm4DinCNgBsRYwSBTbsBKc2bPtiZbzoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0iRN/VSy2CWTtwWkvSUA0AnLu+cLQXXHj8mJqZo+SY=;
 b=VIO7HS6L9vzl4Oj0IRi0+7yLWmw8iUH49MrOPqwvthqCnqjnLc2Pl1pFI1OwvfYlWLWbX8qhOVuF3A514MMhbkQ1mfKdbjah0sBMjEbOlVsn/7W1EOCT266SbFMXvhJosihKyLwtfH6+qHLYtTawySbj4OijqX2B/YzQI3XWpYtGCiVk6rTEArKg9POBKREuPi/mxADM/N1TLkGscqrDKDchNVk93h+QZAqeLmpgcVTmCKtzvMrAR0xkyAB9uNnoxL2Z+vNXHnZGsWUJgx4ESU77kO5/a+HM1stLC55imoAHw6h5+aSSVpZvpYMJmcWxce6Hm2vPDqnjzL2gWxfTjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0iRN/VSy2CWTtwWkvSUA0AnLu+cLQXXHj8mJqZo+SY=;
 b=LKdGbLqhv7pOwf4MA6ma2NeAYFa1qPgnLj+VAwfMgDouqrz0N5Tf1LthzADk+LoMaXL2nTootv6Px1RL4Tm3jk+3WeFsaWTXAh2UyqmrmHJG4iLGkGOSGrYTudHRmMf1JL2YzJ6m1TN6GK9n2FC/C4wTEKmfllsVePIjFn0PHTXpE1fyvCIvUvtcZ5jP4O8KDWBeY6wWYLa2j6LUc5SHB6iTgwG/0IZoIdGemBq28DLdHL4TPoe7ZV9dTsBY+mi3QtdV4zwsW/kFXgIlNpSpxjazyq/PaLg35qtvjagIRp8dRvWiCpUOM+ntPCbRr8f/57Q8L3C3cgd8VoheQhB7Gw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2440.namprd12.prod.outlook.com (2603:10b6:4:b6::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 23 Mar
 2021 16:15:08 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:08 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v3 01/14] vfio: Remove extra put/gets around vfio_device->group
Date:   Tue, 23 Mar 2021 13:14:53 -0300
Message-Id: <1-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: MN2PR19CA0031.namprd19.prod.outlook.com
 (2603:10b6:208:178::44) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by MN2PR19CA0031.namprd19.prod.outlook.com (2603:10b6:208:178::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 16:15:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aCP-Ae; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cae0e79a-52c2-45b0-c9c7-08d8ee16d376
X-MS-TrafficTypeDiagnostic: DM5PR12MB2440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2440F8B43D80340F8302C415C2649@DM5PR12MB2440.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3/li3MepplDXlga7QVIvMuQBVwImJl8aRKMcgD1Q4RzyO/249jcZuJv7ZXl8Bi59XM5LFDtEC12HEA5NzBzNjCoTNoRd2DYNvPUHNNbrPCgnTyW75f9X7HuQ9ovtC0tS8oqsl1x3vyuXcg+4m6waPMdUWgshPSuGaY0NoQgfRPDuFK4qawY4nTvArlMvZrAwpw7L/2HjmBBYqonZouGt6LlEzbyE30/+1TZqxieCm2pC5qDfq9Lt4nnd1GdF0fvJ8zVMrLLbKyfRIAaJsFBzpbCbRflmcntIjk1LTFIRnPHzROfKeZ2cgilQmQm+xMgsiXGaZdH44EUORCBNXAg2o0xrA8/A49wf2I4CtFL8U4WDHMY5Qq66AvqAU1UE41OwCZmaUg1W1szBWNyU+ZxIhYIx2q4eYQs+4mVPTQMKxqErLTL4i39T6iKh3RFHAbrLj6lif9zkmaotLawJDEs5HQ6lb6iCDOU9n2EfDK1GtLbM7zczWAtC782V/6bmn1zVvEd63D7p+2DKyzsgiczqsX2ikKmRkvJajXz1+L88lbbINikmTEvjsEHvpvfbpRbkGqcH8gUMtvKrfvNaZBgSngBu+20kVR18ro6SfRTdosoyjStb0goBEaPn/ySt2QLSUF8BjFujnF0VZROFhJEAKtX48BKOn1tVPuxJclM4p2+oryWJxCecKMh9IjnuamIr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(66476007)(66556008)(186003)(36756003)(6666004)(86362001)(38100700001)(66946007)(4326008)(107886003)(8936002)(54906003)(9746002)(26005)(478600001)(426003)(8676002)(9786002)(83380400001)(2906002)(316002)(5660300002)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DdOGWTl+2osOuO2jpsAZSJQNEZCxvS++1CCeDDwolmtlBMY2hgjREpuyH39P?=
 =?us-ascii?Q?e81ICZTu6lPim4TrBjs8vvUbVmSsdAV9b/E302nR1yqc8XkIsWe91hODMX7O?=
 =?us-ascii?Q?MDXrxmsDuUwf9ObNkHXRU+Ikjk1/pa/pJajznIrRUIWIruIQtonv0Ydg6Muc?=
 =?us-ascii?Q?A1XZCCNxnct4fZBuzOH0s2SO8w7kmTmdvmrMwIxwb0mDjIWw2qUpyskR1Ru0?=
 =?us-ascii?Q?0Xhr6JfcSYGWcHlhRiuyy/z0Zc/73T7Y29G/seEw4hpsyXy7WE7h5GfIEgod?=
 =?us-ascii?Q?/h+4Z9LpXDMFswdV0zol7hv40Mvw9mbUaUr5SlZywQ4UIyQLjhVntYov/Rux?=
 =?us-ascii?Q?WnhsXfpDd5b9s4KMNSOQ/7zxH92SmLWDqugDVtod2dCaaPIXY0ClDTWByxBZ?=
 =?us-ascii?Q?/g+yroTOv5xI9tcXmo//PTicuwoN9H7nuuLZTv7F/6wYEpHaKbGL6ioO7YtO?=
 =?us-ascii?Q?76DdSYAdXJJWKTpluJL+Eg6gbTDeq232Gxrw51FGwZYwmCN0Y5jpFJXWnyVi?=
 =?us-ascii?Q?TD2NMY49O31H/PUvsl4pfu1E15UUCnFSzTDK6hEflXuGrOmm58n0SCj94R3H?=
 =?us-ascii?Q?EBAMJ/vcHn6gMLT7QDGj5evrB1/ShxhnArLnGV6PxCV1Bl2nqQfnESicFBMH?=
 =?us-ascii?Q?YisG4J4lQBOhvZAP8il75f7teBoDYHHXfohsHkSlTs7wjtIL8QJ2aD4LnkKK?=
 =?us-ascii?Q?cc6HuPu6x9cN+wrfF+q6jCC3h+K1hKLRiw99mnc3SxtoQqJ3JcQ0pkjZqbcK?=
 =?us-ascii?Q?JS8rdryEDK7UkXYPOW3iiZxGe3V/5qF3jWkKbQIxGZTZbjYz4JBuAkJDWeYo?=
 =?us-ascii?Q?hrV3KS+04vaq1HyDdv0Fw7ctxFSPSIzLPmXDq1JLziP52HJx94hNTqTQbi5f?=
 =?us-ascii?Q?DT41cAC6GVRAjjDNisd9RD68M5RIVQxFol85VQGNAA8iCEzNR8W2Zi1yNL93?=
 =?us-ascii?Q?fmt3LJT8O5cKnDlJtEvYb7wtFpjwokdhwyclTk9NXPFfZn44Sn3vCJmnB+TL?=
 =?us-ascii?Q?BSmtgTuuzdUi24T8rruxhVhyiOhhUsHQTJjudMVDL21ZnsMarSPqjDRFNein?=
 =?us-ascii?Q?Ul6YSKXQcVa0bSA3WU1t3Dx6Im2BmBpzjBWJO8q6qETq6bDpY4M8q4YmjAqk?=
 =?us-ascii?Q?vZkWknwyCdWZy1S+JynYbTANlM8SFnw8xaFBLutKoduD+ljH7iJoDPt7j9Wi?=
 =?us-ascii?Q?6yxqvp9TMe+cVv8soOf4Z6OhOgl8NLRogNKjPqbLpBswcKLvmzVieYcYXXHJ?=
 =?us-ascii?Q?6SythdzLYp4rAfVcuUfH2hqsd9seQE6GVkSLwnP8Hp/+pm/Uk0Ip62LFXq9/?=
 =?us-ascii?Q?jG3AMvYArZuH5KLtMO+gEDep?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cae0e79a-52c2-45b0-c9c7-08d8ee16d376
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:08.0731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Kl3xHtr1LhdumUQ/z6aXi5XXReij1IF0Nbe12Go8+uYotfh92SO/oXiYLEaAfhE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2440
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
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
2.31.0

