Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3065648410
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 15:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLIOr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 09:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiLIOry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 09:47:54 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCB355A1;
        Fri,  9 Dec 2022 06:47:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pz8PfcMFu1pGEdfW/7s88b6X6KGi0SLKngnUGJXz3oK1L74xSkqI8EGE6Wpl5JMceX9i0TbvE0SwGoKrxuAxdlczPWQAm6EdfUq7O+YMWVhGqbcH1inML6OTw2fvkH8lw/g/nZOuc+J/+i2Y7iqRsilbogwgMukuMwyjRjt3HBn+EVj47ug6EuNJ9GKOqju8sQPbR6vtACtrA5zwrcAegMslRjthJhvo7oSFhBRXHQo8m5nKgk6D1abB30n7aK34fjdEzRVdzoxf/hTztIm05H94REkClyDwOrXDcIOT9Bb+1M5cMdDjyYIFDIu6shvkVzYuBbSVo1oPDqav0NIf1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6LI51WbTuLbWWYCSR2uT7RA+99Ue47hhr9dbmO+7lPI=;
 b=j4OA6heTvW9Id2tPpdinSW/C2orNyfUeeOM2nYfz5q1wqLR2przN+8bYulES9ehKPtgil77/9R9cpLr0o5J09IT+S5qsBdJsS0TIfmc2Lf0cYPHfZCteMEkDgUVYjs9ogkMa4yDPkQ8K06j8+Y/jJ+RwsTLm98q+LwJfLmmENraNAJuxSPXpvbMfUAgUrIAJSGQLEQ2zT2uqN9ciqFpmHx/F0Jejjh0MCUR2SZUvFT7kZifSyiVQgNpAVSyUkl49BTzNv3gzss3yOjoOER51wfokXdgbbD35IRlF/e5mEcoCCrcANr4d+dKcD2pAp0AatRYWhEThi2rcuMBhHLf/zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LI51WbTuLbWWYCSR2uT7RA+99Ue47hhr9dbmO+7lPI=;
 b=XI8jQpzg/KEaPkaT6hT69WWj75cVz/WEmMnsGMyeL+KSzliZiUmy1yvR6TyDJApPwecEEbI1YAJ98RB+GArYTrPX5eStUAMpveOQ9OiygpPDNF1sjFBpHuJm6Nzw7cUcQLlIGGCGpg8tStZvvO9BocPZv25o3Hr8TGqX7PKjK+RqHv/80/TiIEPbw37Yh9cDo7iwsXQ65D1gYXXNtecuN1jMkMzJAhMImV4fS2+gBkQsqDmth+eofZxVYgtiCKpUsnPpPXEdGoCIvuvPbU7eqMxSYAdo5QOJu/8VQoOPPLKfIbJGWYHQGUv66ko3PNBXPy2SdLONZU5f2k50guTAeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6678.namprd12.prod.outlook.com (2603:10b6:806:251::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 14:47:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 14:47:50 +0000
Date:   Fri, 9 Dec 2022 10:47:49 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd 4/9] iommufd: Convert to
 msi_device_has_secure_msi()
Message-ID: <Y5NKlf4btF9xUXXZ@nvidia.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <4-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <BN9PR11MB5276522F9FA4D4A486C5F60A8C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276522F9FA4D4A486C5F60A8C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:208:c0::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6678:EE_
X-MS-Office365-Filtering-Correlation-Id: aad44971-bfc2-4143-5421-08dad9f45883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5mDOlfDkW9xYy1ayACyeOMC85u9LDyy7xzNPdslfAAxW1G9SQXMVRTwA52q8Oj8nqkfdFg6Qu28OkqjdnxQmv8HnGuQbGhoomJZ9OfylSCTQNLEXR/An1LwNzaIbitcsxzFIOBoTMe/rKyOkGCFYOaNHLaYqlcPGIgx8++pPm6QQNiOTt4t/qavLYN6K96k45/tRNVYwUZOe407zHJuQk4tuG0JHpfS5nAJL4YHfau56c/Oo/4sS9qW0cEsXQGT/NUYoM2iOyPSrK84lY45AZ+/UxLKQi55T29cqHU37E/j2FLAVA1gRZaRj4jsuHLwu9QAo4GW6P/q6CtsAfxXD7rpuH56sMy17Jky7Ut901cXXrE1x0zAFOYDiFnjHk3EYkGkcB5ZhsuIQy3tNsjoICSwXI+oWW+uyERKCPyuWu+XxiZadUJvfV+OpGXV9zSWWOIyi1B9zmvmvhY4fd1uIIA+XegtjHyheTncbEeNLToNkq2kAras+uWFuLJFajHQU8R3gBN6/eP0vjylBGalBpPJm9uePdM5x0xNHM+22hQaJxnliJ5K57tmfcH7NzvAYLBI7qk6aCV/anYXtyULA7P0XA7rSWedr/CgVaIhdYX4iz3Nv2prex3+5DO57EDXzdZydsXD+ZjCrjZnhs/JKPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199015)(66476007)(66556008)(8676002)(2616005)(41300700001)(4326008)(66946007)(38100700002)(478600001)(26005)(186003)(6512007)(6486002)(36756003)(6506007)(6916009)(316002)(54906003)(86362001)(8936002)(7416002)(83380400001)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UJXhZ8U6wa4YFvRYC6kBhvZMOS+cvykAYx2379ibhvkPDu9exyc6dOgs6d4m?=
 =?us-ascii?Q?ian333/FV512QoiuPEZyvcU6FA7aU/j0REF5+W3b4tuqQvidgMe7D3z9eaQc?=
 =?us-ascii?Q?htWY8qSQoocGnU+LRQvECItiKLCwJbTowYjy7J6wXC6ygqwr+9uZGg7bXQla?=
 =?us-ascii?Q?avbRb/sk0fPTTWMVNeeADK/UJKbYZ/C7/YlNVeTVO57h0ZGuN6TXDa0sQ5eK?=
 =?us-ascii?Q?I+UmC2ulK4ovhWeNJ+tmhWEQcRPT9iSqF8pyeHA2UHefbXGA7a/3xsX7QOSn?=
 =?us-ascii?Q?MilizPRqx2JPhrk/q/46hcWyTsvE2iGO27fangG3vVIhttYombuYWF5QbT9e?=
 =?us-ascii?Q?flJM54JnGc0mY5Nq6343acxQYc9LyXhuTEQuKL/H11xiHOhT/Jf6j4kmG3L0?=
 =?us-ascii?Q?7s8Gy2SzC9MukpGxi5eaFI65/oNidoP/7L5OisIihwRRZl55eIu5WPkvjyCM?=
 =?us-ascii?Q?3dk7YnUCrWEG4uNUgHqFPWilBvQOxlMUL9utUxr33IKOYgAzc11IqS8VrPfQ?=
 =?us-ascii?Q?h7N+zXSYCGPFLKaAJSNygYfRmt5edWY2GvD3qbyjTOzWKv9yjDBeef/nGOIJ?=
 =?us-ascii?Q?4GzWobUR1/NOx63/ud0+ILeAW2BbQy4hJ8OpFLyaAG+oCVSiUdJWgDfSOIT1?=
 =?us-ascii?Q?V2eHxGFCNWffdl2+hkIQqo0HlXttnGnGVQaPJmMHp/0Q00CMziDUSq3yrN9w?=
 =?us-ascii?Q?Z0TbQ+E9CkzZWIHECj1MZ65YpW/Vm3ZiEnbU5DiOckBLQ3mFWfqPrbPHuAEP?=
 =?us-ascii?Q?7k1VWPL8as6Ds0gbHK7nUaJ4E1bncLGR/nx/LT9soukdRh9HldXF8bD4i7W9?=
 =?us-ascii?Q?02rq+3NzfUOR4yhMN3oCbUmWHP5LnDTLhKPH20lfnpZ6YpuMyUMZGVjcgKRj?=
 =?us-ascii?Q?jmsORFUfwpGJ0Lozx9TwkwDKKC2BKgj49k6AUAJTXFxU8x9wg8ztDXhVb/gt?=
 =?us-ascii?Q?LU/NnRu3fNFRICQnR6NtuM/tpCV5N0TqIbvAFO5w20pZB+hMGxsPV8LbNC3S?=
 =?us-ascii?Q?H6nx1vWE5/8IiFu+INIneq7X25X4PvrY7A8gFewG+q/4QPJCPFdO5CjY5PwJ?=
 =?us-ascii?Q?DTaok1fpUkMRtOrWOI+gB/OAhYTVqK9cldI+hSnzBl/BIe7HsAMOv1gHMBQ7?=
 =?us-ascii?Q?ZhtJ8G0swLcMdKfMl/3Bp0aU7aKZcBuP9g9frRada/ZCCD4Q7khaZXw7Xu1E?=
 =?us-ascii?Q?6AGsCDfiO9Xf/xWUnfUN4LyvD8KrgNKRO5+xK+lr959sxSUfwWZ1EpchG5mZ?=
 =?us-ascii?Q?ktJM9m8b4XF1gLdexwaf7aQ2FwBeUMWK0OD2wgMGQXyyx7T0V2/J8NPM2NI4?=
 =?us-ascii?Q?FRbovIE2FkmZc7zjx+rumAFhog5q9hrRF5bYQsO3nWW+s0sT/hRXA1kedkS3?=
 =?us-ascii?Q?TYrYzWHgZTX9m9C7HS8ARRA5RP8tq3GC5xJ9k7anKBqmy9XHQhKFr8wEgJ1c?=
 =?us-ascii?Q?Ant69jIEpWmOB7MTvehADPk13WwpEY9JBzgX3jvMQ31EHrkLHSfXo/s90SRI?=
 =?us-ascii?Q?eR6+KhbFN9mHDmQgBDY9kQhR+gFkEW7BgNEOiwfzAMPz8kYhL2EF3o6tjJlI?=
 =?us-ascii?Q?oiTCj7LaqJgFrZBMquM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad44971-bfc2-4143-5421-08dad9f45883
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 14:47:50.8314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HRhG1qpBHKYZ2Og0wyf1fH2A6FDLnEtwnLjP8ypK6pxU36CnW4PclaXn0BE3hrLB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6678
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 06:01:14AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, December 9, 2022 4:27 AM
> >
> > @@ -170,7 +170,7 @@ static int iommufd_device_setup_msi(struct
> > iommufd_device *idev,
> >  	 * interrupt outside this iommufd context.
> >  	 */
> >  	if (!device_iommu_capable(idev->dev, IOMMU_CAP_INTR_REMAP)
> > &&
> > -	    !irq_domain_check_msi_remap()) {
> > +	    !msi_device_has_secure_msi(idev->dev)) {
> >  		if (!allow_unsafe_interrupts)
> >  			return -EPERM;
> > 
> 
> this is where iommufd and vfio diverge.
> 
> vfio has a check to ensure all devices in the group has secure_msi.
> 
> but iommufd only imposes the check per device.

Ah, that is an interesting, though pedantic point.

So, let us do this and address the other point about vfio as well:

+++ b/drivers/iommu/iommu.c
@@ -941,6 +941,28 @@ static bool iommu_is_attach_deferred(struct device *dev)
        return false;
 }
 
+static int iommu_group_add_device_list(struct iommu_group *group,
+                                      struct group_device *group_dev)
+{
+       struct group_device *existing;
+
+       lockdep_assert_held(&group->mutex);
+
+       existing = list_first_entry_or_null(&group->devices,
+                                           struct group_device, list);
+
+       /*
+        * It is a driver bug to create groups with different irq_domain
+        * properties.
+        */
+       if (existing && msi_device_has_isolated_msi(existing->dev) !=
+                               msi_device_has_isolated_msi(group_dev->dev))
+               return -EINVAL;
+
+       list_add_tail(&group_dev->list, &group->devices);
+       return 0;
+}
+
 /**
  * iommu_group_add_device - add a device to an iommu group
  * @group: the group into which to add the device (reference should be held)
@@ -992,7 +1014,7 @@ int iommu_group_add_device(struct iommu_group *group, struct device *dev)
        dev->iommu_group = group;
 
        mutex_lock(&group->mutex);
-       list_add_tail(&device->list, &group->devices);
+       iommu_group_add_device_list(group, device);
        if (group->domain  && !iommu_is_attach_deferred(dev))
                ret = __iommu_attach_device(group->domain, dev);
        mutex_unlock(&group->mutex);
