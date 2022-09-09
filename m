Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048AF5B38E2
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 15:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiIINZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 09:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiIINZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 09:25:47 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FADF134605
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 06:25:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bB0r+0ZYFeD8TeDn7erclrmwTkb8xqcAczDDIA77yXebLQkeJRvm8AHoFVDZt+TfkqKSZ3DLlpqmCARUHXgDJ6NTspm3vIADwN/tvcZ8Kbn+qhTBN5IbH29s1DyN4nGa2UNrVnpdCkWtx52y/OXYed3+9lMWJgyS1B2Fkf6X2TZZTdN1rRM8PSvStwNOG8Vj90SzXb8EsLGDMgOY574Rcg2loVTxdpK4AW3AYwivg1VWYNi4MmUuMzkC4x1+B0hpjIdZWuZCTRnWoj4zIrBIGwvZIcMlK4jSfM1jhvBWNmIbItoxpu+Ho75CRrYOlbRUmvyHQy8lmTcKfj2U/VXRGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=za3RZD2509gx7FP2ckhbG6RnHqajx/Ydr3Jp89gYHhc=;
 b=Q8J179yhSRcvjJEvXdpQOiR+0eIE+IwKD1+OSCssS5nATP2hKKRFVp0DbGVhn+HsQCSnQ6LuSnHVH5czTNljg20CyByyVrpX2pQIiUnUIgEfjp5ux3MNtSrMC6vYh6AoJaclmX2zB+jSx6dpy/8E5fO3YZ884JXGhz86HM+g+hOhLKFtQ8c3UB57NDTd68GJIgVYEMeOPkWT+f18YUy5YA6hC+mI4Kxe1cSo8p/ZF7qWulES+1cEhOpQTIH9C5hlo2FEt82eSUCrP2Xk7f0jie8M8M50PCiXbY06HtaTFmOlqDlL5NV4b/xM98SrP/eQI29CNqqXkjqRFdzCKIqQZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=za3RZD2509gx7FP2ckhbG6RnHqajx/Ydr3Jp89gYHhc=;
 b=khlzbu29u2dQgWXeRALqofB39Jv3fZmt1mEb9N5rE4xkEyUb6jnAJE+Otv3SsnfChbnde6gbtfhXAlb3zJAv0et4Vl4Qbeiqqhevpqpo/0YczMLLlvHfeVLceMKrK9U9fskZicQnfoDzdttz+8I2O5WPpGLx3HHMnvPXvrOmkCk7Ye8q/ytgGtc4l14yTP2slne1MJJTRw3XzUSgzkcWkgXPbq5eKXOGJgaI2WK3XwZlbjoUmv5yAuN2Dp2JIyiZ24Fw6w2F3Rw7Sb8X0xuCdtbvQJW4xyWaFE5j8uBK3RMYY3f0/68MDWooSXipMGcFvB3oM41gB8Be50EOxPLFHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS7PR12MB5958.namprd12.prod.outlook.com (2603:10b6:8:7d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Fri, 9 Sep
 2022 13:25:43 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 13:25:43 +0000
Date:   Fri, 9 Sep 2022 10:25:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Qian Cai <cai@lca.pw>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH 4/4] iommu: Fix ordering of iommu_release_device()
Message-ID: <Yxs+1s+MPENLTUpG@nvidia.com>
References: <4-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
 <87b7041e-bc8d-500c-7167-04190e3795a9@arm.com>
 <ada74e00-77e1-770b-f0b7-a4c43a86c06f@arm.com>
 <YxpiBEbGHECGGq5Q@nvidia.com>
 <38bac59a-808d-5e91-227a-a3a06633c091@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38bac59a-808d-5e91-227a-a3a06633c091@arm.com>
X-ClientProxiedBy: MN2PR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:208:fc::36) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DS7PR12MB5958:EE_
X-MS-Office365-Filtering-Correlation-Id: 2102d1af-3060-4a05-4f19-08da9266cbc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qvtO0KqDvwyQuNoGAIvERfWS/borz5Mabi6yLmJdbvwkbukqMBPF8k797dmllqSUmehG75XUa/ylgCDET8qPPA6oiHpOxYAx3M+mzb/xu2JUFlB+ToLFNQ/ndi8hw9s3xLbWas0NylDYvVjL/s6khj2x2HSzKjX497lFpflRaiEnR8GLKR5Uip3vP/lFvboPsgDsIHymzT/bfEOFKPkfYHeFVH1s0v7lK/gxqsPvtfVtd838VLJcVR93v9N9JxW97bkGdip5fCDGKypQhIRH85hsMERWVbPwn6O7Sb0L3Af5iJGkAVvkEl6xuhzARrMMuHhzNQFgbOra0KoH9UCzQtwK53+mnOn/uSNvgciV8bGAO+0FkZnUptNflesqu554CuWx6pEAD9rYZ9NnovH41tyRYtZrD8GhxZnEaZbto6efqvOw2Zu2Rq0h3zADGliJHncCWhZHD/HhP81mw/nAMYGUYA2mQrFkE3Z8J8HB5RcqkP51hTIgaAntjqYlp2W03r8CurFxfPCQTojMDAzJ18d0MSOywj9SFhfzfgqxrmhXGHT9dNx27IUUwVPD/ciukWEE9gxg6tO8dqvlZWXTl28IeXFuMlfxZ9R2qpgb2YYUd4l771XG3fagU1z+eBaLmCoP4d0DKJhelhhDzKMxYfTZcbFmYYtZLKAk4bJ3BiuaJ5gyDlljqO/5HCwVD6vvTZwDkJGwlBa+/OR9gXZCUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(6916009)(2906002)(86362001)(316002)(54906003)(66476007)(8936002)(66556008)(66946007)(5660300002)(7416002)(478600001)(8676002)(4326008)(36756003)(2616005)(38100700002)(83380400001)(186003)(6486002)(6512007)(41300700001)(26005)(53546011)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g06s34C8TYtB5/e0wX8lD+c1jllJFN6HdsJMXvOgGK3P27W5iZFvMTCMtLGO?=
 =?us-ascii?Q?qmtDrawEuvE5an+CXAvisQ43/oQzqFrAXKLyeUYLHc42D0hTBJwMVYqLOhaT?=
 =?us-ascii?Q?gN25GrTJyGq2DgAR2yXQRlZzL1oVRB74eguFSo3u2k/J5HNa650oLUcfDkXq?=
 =?us-ascii?Q?OD/zoxy/667fdaoYgVBf4jniJDPalQvGJ8Xru5NeAEpPP1qpl5uJWdDX9M5Z?=
 =?us-ascii?Q?hCqGO2MOgLEvVGu17mMNsaeIb1I/+m70kglbCB2vR/fLGAg0EXLpq3poMPA1?=
 =?us-ascii?Q?MpZO8tFHXPM3aAUfLnfIEpxo5vnjmDWbdVbpWIcv6Ue2TUpTnXyo7KKxhzgp?=
 =?us-ascii?Q?ty3pxiNF+x3Ny7Uva5gsQE3on34t6H1goUUymre5f5qZ44ij0giTSqQ5cjUL?=
 =?us-ascii?Q?q1yFcePrCChc9QqLxY1LPtp4WQDeck3ABJEgw85t1IA7bYsxkO45cksx4Vhf?=
 =?us-ascii?Q?R+AE7fqsr2TrLwhDBf6mDISPGP2aXF59HmI6IZd67iQqVfl5ux9wE18jyRZ2?=
 =?us-ascii?Q?B1Qo5KaceM7IGbgxS0UiMwqKLyRaKi61wSpAYJi+iPKVuat9AUCznATHck62?=
 =?us-ascii?Q?rOOkGP084GRmaowWCQFdXs1SzJ2HD8oYcc/cU6PeLjs97UjHqEkyZoURUY78?=
 =?us-ascii?Q?xDxrc2xQn9LR7OrVIgrM5P3bhSUizP9xkDExJq9xHXEzMHwH0K7gCN8QXMqL?=
 =?us-ascii?Q?bgsi4OeCwIgoIJFgyTNNBKkr/96FI8KwbHDoLdhFtKoXuuMNVTbbYx/Wcsfb?=
 =?us-ascii?Q?auwKyHmeXDn2q5ODFdmJsstdLi3uvUdCHlV+WiNE9ysikxl90zFw/7w56dIf?=
 =?us-ascii?Q?S/GBc/9UdoXDIcQoRHkPNaNE09fqxOVvYN2FpmqJgAZZBV8nQKUfePuOHUxS?=
 =?us-ascii?Q?UyCmZWoP6pqLEW1zkpo8JRpoDHoQR4JslFMtauj4Upt58FDQft0Hh4W3H9rM?=
 =?us-ascii?Q?vtNf1UxhPDQgE34nlHNckqz4gKuoVpdvPjZ4apRfi3TxGZkGnpRSYLLuvN4o?=
 =?us-ascii?Q?BnxwmQiTTESj3HLxB8gS8tpSSB3Ik0HHGLZBq/B1ktQVJFzb0HEjnPK1d3cF?=
 =?us-ascii?Q?7NTY/6ag4zZPhIuGbDFRu0gn5dvlkG37IgvQbJfrm3seZf2M6lXt3ZdJH/35?=
 =?us-ascii?Q?8OaM75CNkIuSnpzJvOWdjv0kMwtnD0bKBU7JWNm/R5oqPCNNMe+mBEIR0Rx0?=
 =?us-ascii?Q?/NjVWiiLgEeQ3/Xm9WjJeoPFrLGH4hmFW0+NZfHfCIUAfF+OBqp2FFv8BzsR?=
 =?us-ascii?Q?7SZtxVyf1sVhyeXgqUJgQYUZDM/KJSDh4iByRPWYGLNya0BAMXLxVVWGowE/?=
 =?us-ascii?Q?r5as3AttgHnyuijiewQoThpQf9iGLj2qOiaJZVB9RL1SDVZefB6+0OVSObn9?=
 =?us-ascii?Q?+KTPRDrNfzGdeqXzIQxzRqEaceqNL1qo+Fw2MqiBFkhBBhaO5tzkCZPBL4ex?=
 =?us-ascii?Q?QTFbhhfziu7JvkK6Zq3GlCOqGEVG5aajK9Ffeo01NEb2UF7RS9DGx+dWKiJv?=
 =?us-ascii?Q?MqhCYuSCGdG861tGZcfxrpmTajFJWpMXIu/e4AgC/w9O/Cdd5oOY9mIZ83pO?=
 =?us-ascii?Q?ZW/i5E6wGsSb1gtE2FxEzvF/hVlrW39IyP/1wulU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2102d1af-3060-4a05-4f19-08da9266cbc9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 13:25:43.1039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BdBze5fcVvtViy989vwRltuc1CliHpbm3y7l43EshiVS88uyrVdpPyTXcqBzZnD3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5958
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 10:05:58AM +0100, Robin Murphy wrote:
> On 2022-09-08 22:43, Jason Gunthorpe wrote:
> > On Thu, Sep 08, 2022 at 10:27:06PM +0100, Robin Murphy wrote:
> > 
> > > Oh, because s390 is using iommu_get_domain_for_dev() in its release_device
> > > callback, which needs to dereference the group to work, and the current
> > > domain may also be a non-default one which we can't prevent from
> > > disappearing racily, that was why :(
> > 
> > Hum, the issue there is the use of device->iommu_group - but that just
> > means I didn't split properly. How about this incremental:
> 
> That did cross my mind, but it's a bit grim.

Actually, also in my morning, I think it may not even be necessary.

Keep in mind the start of the series fixes VFIO.

The bug that S390 is trying to fix is that VFIO didn't put back the
group ownership, it just left its own iommu_domain attached and called
release().

But now, at least for single device groups, VFIO will put owenership
back and zdev->s390_domain == NULL when we get to release_device()

> That then only leaves the issue that that domain may still become
> invalid at any point after the group mutex has been dropped.

So that is this race:

        CPU0                         CPU1 
   iommu_release_device(a)
      __iommu_group_remove_device(a)
			         iommu_device_use_default_domain(b)
                                 iommu_domain_free(domain)
                                 iommu_release_device(b)
                                      ops->release_device(b)
      ops->release_device(a) 
        // Boom, a is still attached to domain :(

I can't think of how to solve this other than holding the group mutex
across release_device. See below.

> > And to your other question, the reason I split the function is because
> > I couldn't really say WTF iommu_group_remove_device() was supposed to
> > do. The __ version make ssense as part of the remove_device, due to
> > the sequencing with ops->release()
> > 
> > But the other one doesn't have that. So I want to put in a:
> > 
> >     WARN_ON(group->blocking_domain || group->default_domain);
> > 
> > Because calling it after those domains are allocated looks broken to
> > me.
> 
> I might be misunderstanding, but that sounds backwards - if a real device is
> being hotplugged out, we absolutely expect that to happen *after* its
> default domain has been set up.

See below for what I mean

iommu_group_remove_device() doesn't work as an API because it has no
way to tell the device to stop using the domain we are about to free.

So it should assert that there is no domain to worry about. For the
vfio and power case there is no domain because they don't use iommu
drivers

For FSL it does not use default domains so it will also be OK.

Also, I think FSL is broken and it should not be trying to remove the
"PCI controller" from a group. Every PCI device behind an IOMMU should
be linked to a group.

The only reason I can think someone would wanted to do this is because
they ran into trouble with the VFIO viability checks. But we have a
robust solution to that now that doesn't require abusing the group
like this.

Jason

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 780fb70715770d..cb83576b1877d5 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -90,6 +90,10 @@ static int iommu_create_device_direct_mappings(struct iommu_group *group,
 static struct iommu_group *iommu_group_get_for_dev(struct device *dev);
 static ssize_t iommu_group_store_type(struct iommu_group *group,
 				      const char *buf, size_t count);
+static struct group_device *
+__iommu_group_remove_device(struct iommu_group *group, struct device *dev);
+static void __iommu_group_remove_device_sysfs(struct iommu_group *group,
+					      struct group_device *device);
 
 #define IOMMU_GROUP_ATTR(_name, _mode, _show, _store)		\
 struct iommu_group_attribute iommu_group_attr_##_name =		\
@@ -330,18 +334,50 @@ int iommu_probe_device(struct device *dev)
 
 void iommu_release_device(struct device *dev)
 {
+	struct iommu_group *group = dev->iommu_group;
 	const struct iommu_ops *ops;
+	struct group_device *device;
 
 	if (!dev->iommu)
 		return;
 
 	iommu_device_unlink(dev->iommu->iommu_dev, dev);
 
+	mutex_lock(&group->mutex);
+	device = __iommu_group_remove_device(group, dev);
 	ops = dev_iommu_ops(dev);
+
+	/*
+	 * If the group has become empty then ownership must have been released,
+	 * and the current domain must be set back to NULL or the default
+	 * domain.
+	 */
+	if (list_empty(&group->devices))
+		WARN_ON(group->owner_cnt ||
+			group->domain != group->default_domain);
+
+	/*
+	 * release_device() must stop using any attached domain on the device.
+	 * If there are still other devices in the group they are not effected
+	 * by this callback.
+	 *
+	 * The IOMMU driver must set the device to either an identity or
+	 * blocking translation and stop using any domain pointer, as it is
+	 * going to be freed.
+	 */
 	if (ops->release_device)
 		ops->release_device(dev);
+	mutex_unlock(&group->mutex);
+
+	__iommu_group_remove_device_sysfs(group, device);
+
+	/*
+	 * This will eventually call iommu_group_release() which will free the
+	 * iommu_domains.
+	 */
+	dev->iommu_group = NULL;
+	kobject_put(group->devices_kobj);
 
-	iommu_group_remove_device(dev);
 	module_put(ops->owner);
 	dev_iommu_free(dev);
 }
@@ -939,44 +975,69 @@ int iommu_group_add_device(struct iommu_group *group, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_group_add_device);
 
-/**
- * iommu_group_remove_device - remove a device from it's current group
- * @dev: device to be removed
- *
- * This function is called by an iommu driver to remove the device from
- * it's current group.  This decrements the iommu group reference count.
- */
-void iommu_group_remove_device(struct device *dev)
+static struct group_device *
+__iommu_group_remove_device(struct iommu_group *group, struct device *dev)
 {
-	struct iommu_group *group = dev->iommu_group;
-	struct group_device *tmp_device, *device = NULL;
+	struct group_device *device;
+
+	lockdep_assert_held(&group->mutex);
 
 	if (!group)
-		return;
+		return NULL;
 
 	dev_info(dev, "Removing from iommu group %d\n", group->id);
 
-	mutex_lock(&group->mutex);
-	list_for_each_entry(tmp_device, &group->devices, list) {
-		if (tmp_device->dev == dev) {
-			device = tmp_device;
+	list_for_each_entry(device, &group->devices, list) {
+		if (device->dev == dev) {
 			list_del(&device->list);
-			break;
+			return device;
 		}
 	}
-	mutex_unlock(&group->mutex);
+	return NULL;
+}
 
+static void __iommu_group_remove_device_sysfs(struct iommu_group *group,
+					      struct group_device *device)
+{
 	if (!device)
 		return;
 
 	sysfs_remove_link(group->devices_kobj, device->name);
-	sysfs_remove_link(&dev->kobj, "iommu_group");
+	sysfs_remove_link(&device->dev->kobj, "iommu_group");
 
-	trace_remove_device_from_group(group->id, dev);
+	trace_remove_device_from_group(group->id, device->dev);
 
 	kfree(device->name);
 	kfree(device);
-	dev->iommu_group = NULL;
+}
+
+/**
+ * iommu_group_remove_device - remove a device from it's current group
+ * @dev: device to be removed
+ *
+ * This function is called by an iommu driver to remove the device from
+ * it's current group.  This decrements the iommu group reference count.
+ */
+void iommu_group_remove_device(struct device *dev)
+{
+	struct iommu_group *group = dev->iommu_group;
+	struct group_device *device;
+
+	/*
+	 * Since we don't do ops->release_device() there is no way for the
+	 * driver to stop using any attached domain before we free it. If a
+	 * domain is attached while this function is called it will eventually
+	 * UAF.
+	 *
+	 * Thus it is only useful for cases like VFIO/SPAPR that don't use an
+	 * iommu driver, or for cases like FSL that don't use default domains.
+	 */
+	WARN_ON(group->domain);
+
+	mutex_lock(&group->mutex);
+	device = __iommu_group_remove_device(group, dev);
+	mutex_unlock(&group->mutex);
+	__iommu_group_remove_device_sysfs(group, device);
 	kobject_put(group->devices_kobj);
 }
 EXPORT_SYMBOL_GPL(iommu_group_remove_device);
