Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8EA5B28AE
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 23:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiIHVni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 17:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiIHVng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 17:43:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDE1BF377
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 14:43:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fblgo8V/58ONn3y7HV88z6ceDH8RWGeUcPkS2NuRm+Y7P61X8h22gBeO9/hMy4cj2PMLt4kwO2qjSYTMd4GARdieF8UTJXZxVHobkmMjmcn5vBrRDiaFnhzlRS69pxgsnMff/PPbh/1VmpTQZ3H9WuqmupOoE8+g4ujOIeuMsY79q2E7FyKqZN4H00vjw9mDbNsdUB71DySQ8UJQSkvZri363Op1KWnLRnBcGTv+tbCoJ74yIEaMHSNFPQbNVeVChBNfT6tD1YKnj4HX4Tm+LMAvTlnbQkQK/soQ784l9u1jKI8Nw6vRrE6L//wjQnARkx9FXKb3gA/BG8QEUkJVlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhY8N7YhB/7en/7tlhAirRLUussIK0CrEw879KD0WrY=;
 b=bOf25Ojeb77cFlMOmbPxO9G4wE6Xain4h3gBa3IyJIx+M7yz4EFqGb7gNnGncVy6sB+kCKULgDY0NAc5I8AHjl2SjnsMo404KQu28FQ7rwvRp8oQNljefCD4M3hUJYuTt6gDOPszlQmrMGWqEgwcLkBv7GhkZbX97gcxwGSHJ5XEDJI8OnluRpqC3YR4k9s0SG0Xwn4/NvO6CcZpC2VAS14YS/RR+ofIYZFFG7Cd4/BbLP5VA+Y4l7Hn4dIsaRJql6Esd+opWqGnBIukw4RVSSSzjRlUHNaTaPe+nVZrEVatB6bm9290WeN+JsioQTuN5HiNt7dldQxqa3/P2nQ4Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhY8N7YhB/7en/7tlhAirRLUussIK0CrEw879KD0WrY=;
 b=qZIjCmnist6LIayWo7Wbd982tGpOzP4yAkjow7NeZHxsd1QPvqZIuGPtpKbE84NbmA4YrDI+v1hswj5bAeMmfgL+onN96NXTXuW1Gmj7zDlQb7zq6LRHnZZbG9ZGvYq69A4m1SUm65aDAM2O80xRyCJ6vmzF/x/XxuR9AlymDVBi0t7pTPWBUsYbpYM6Of9wsDYRWPcmSkAKnL8gy+n93i1w9PO2IasLt25hGIl9GN9QS4IYgmZUaWXawcgeKZLNCNxiLbWr12cfWWBcY7sYgAt4einHZLuyTF+MSIWDw5TrY3avTKYoVE5bU3MVeu3mXNaXDHosQ5XAKu5LRc2kVw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5674.namprd12.prod.outlook.com (2603:10b6:a03:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Thu, 8 Sep
 2022 21:43:33 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Thu, 8 Sep 2022
 21:43:33 +0000
Date:   Thu, 8 Sep 2022 18:43:32 -0300
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
Message-ID: <YxpiBEbGHECGGq5Q@nvidia.com>
References: <4-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
 <87b7041e-bc8d-500c-7167-04190e3795a9@arm.com>
 <ada74e00-77e1-770b-f0b7-a4c43a86c06f@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada74e00-77e1-770b-f0b7-a4c43a86c06f@arm.com>
X-ClientProxiedBy: BL0PR02CA0131.namprd02.prod.outlook.com
 (2603:10b6:208:35::36) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: ce86b024-d7f8-45f2-6a74-08da91e32d9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qX4oh02XLH7PEvPxzi4X1VjlrpYQmXjJqfXqX/qq+s+Lejcu5bCdQ8sReztLC50Vw1xqDzQ43rovt38jZGMh4NlY83dgWAsbRgEuzDzwWyxv9lhVqz1aUZ4v9jGWHajZ3+rNnF4Yt0eWiL2FJnUTR3XTpESYjVCqvCuFcx0+ukNP88kztslLtIwAEPMf7MHCha+oEPxfWKXVLamcUsdwNfjdnjkFD+p8YQlUvQUlXkYDeX4j7Mh9SJh2XsMVrozouK010gFjqX/a7/r0HuJqzaSKYWxYEB9AQAAb+l/cVLJZrilWWTpsDsBUl3XMrlucCqEhCMl/bm3e4uJtBu1i/N030osBzyxp+XvVLl7bjoSl5gWeo2i+viHmtxHjaW4NZpV8IuVFmxz0IW3nGBv2Jm3Kj8IwoqbVYQpmKBNM7WyiL4Q44rt3N33uRRmsOJARrqXnM08XophUpZWVbNpghjQFQfslOvsqMh+ZKxZJDB5DcTMh+YKeb/WPZsDb3x1WlmxjTho6oc1Zmi15kr+EdB7glFGSqou3y4/NoH6W3pJIbm+8ePlgZWJ7fwrA9q1t16r5SKGZl3TGiABA08iAdlgPHIb4B8GLb/x13S3WJeJ6rVvgWHk5+RQHW4uDtOsq7T0yrXlGq/4e4jhyNnQSY4ksUtfxgUgJKTdyVwkqiqefSuads6OU56/T0Z/SgHKxPMCu0C4wLCrMhBjy+vOM3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(186003)(7416002)(2906002)(2616005)(6512007)(6506007)(6486002)(5660300002)(478600001)(86362001)(36756003)(83380400001)(8936002)(41300700001)(26005)(66946007)(4326008)(66556008)(66476007)(8676002)(316002)(54906003)(6916009)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kKA9bE9UyvhZgm55vgrCR5GgbHNsFNHjQ2Ms20A8CiINjDEep0nURNcu4pn4?=
 =?us-ascii?Q?nUg0NkD5K7xSN7Tux0GGhUiIldiPHs8UvhNtRKiV+n0i9bZrAWL2eRKPkHGE?=
 =?us-ascii?Q?6NA1juczj4YBmKsFJfhY5uFIY15mvpwyH36yc4MUNtaWv0mm9cODZckBT0tv?=
 =?us-ascii?Q?OXwLX6yMkcW8tJhwJVdfg8J/3uyC1Lvf4kJ9Wo0vq3zcUr+mFc7QF235FJO1?=
 =?us-ascii?Q?JY+4epn8XpelVG4ECviZsivUdBSKXMUH8t4EqRQsK43d30CnRNbnaq/btoN6?=
 =?us-ascii?Q?1LIKophwUUwXCb9E0I/U8BWYkFVBdJ+N7exV1tFaRTg4dC+4gNOwukqtogBU?=
 =?us-ascii?Q?oJbengiCwDY5EfNI06hu1DjZFbFWsN3+24H/1nGrjKMYQ/FpXFxRb6A13vCo?=
 =?us-ascii?Q?1T8iBgA5WMudC6m50tFI+v8yKnA9LAMA5xKXGdruBafBhicI2IX5LfatrQOg?=
 =?us-ascii?Q?8RJUon0pCm/PKviBh+hRUxmU11Bl7uL20A8q9d0j1LyrLymEviBGkV66Shbh?=
 =?us-ascii?Q?gKPGNz5iwXIaeXGla1KBvebW/oNbJTFNWOY2Cp+D9j7NqLoZo93L1q7qHsW1?=
 =?us-ascii?Q?gSXq/Gz2LdhzZP8b6ucFWdHOy33hINfgR0pbFsNilCPXboRMVBLH/5WLqvb+?=
 =?us-ascii?Q?31rP5M/ftFoo1nbM7jfJ7f4dasgjAwpi9lLtKkwcAyDRR+JNFiyc7bH829bp?=
 =?us-ascii?Q?crsCXswEQPY+jmxG4sO+LnuqZ499TR5gqha1qh+epzJVDbSvxzumoEKMoKp7?=
 =?us-ascii?Q?7mA02kRrMCFzeBYc9FmdjE2mCT2p4FAQzdeDxYCBkzF03+1IDuqnFRq9L8b2?=
 =?us-ascii?Q?VtlgyagpIORxRTVr09onycPBvXjN4sBya/gCU/v1UAbvByDTEleTyfd2yIyJ?=
 =?us-ascii?Q?4Xa8qWkQLymUwxFMKJxhSJIKSprb27PWiksUeaxHX4WcYM+76PHjOAF/pCGf?=
 =?us-ascii?Q?0Esjmu255Nc35897fTwCu/K2vAb1x6qXDnELSWOIoO3Mgw51Nm0Euiv5AItn?=
 =?us-ascii?Q?LkeZaPInGFmVNUQFVLKRH1Yc2fNHVLJ6q8o3WJ8+ySc9ILAHzfmS5QCay8V4?=
 =?us-ascii?Q?vdT4kDPG6u4JmSbPJUc+YLoKeD7p2p4BfFCpo6wmVHUJlIGkNR/7Qk8K75Np?=
 =?us-ascii?Q?zDENoBrrhNJDZ/aDj6KuapusEawtiKCeUcR5Pl1n1mnP9PvY4GaAKznb3SR0?=
 =?us-ascii?Q?PboOijUxoUaOuBo5OcFKyh+oP5zKf1MYfazh4+Iwhp2xhUWogiuYmo4s8K6Z?=
 =?us-ascii?Q?sDR2EsjRzmJit0H0OvuAxDsUrSgyaUrihXqdpYPXiSzaiFaGmQ/Gje0eEavM?=
 =?us-ascii?Q?XHgDSCGp6DWL0vFf/Olbuy9qmCypOWsqmGpUgKGPOAjxbHJTYlugKCbl9aoY?=
 =?us-ascii?Q?VTN/eHgUMGVGoZAaI5VEP2nIrgcjaAmXWnTR+hnMJxK+TXqXubiwaHpT8HpC?=
 =?us-ascii?Q?ZrK3cdFf0BOoSOcy18xH6/pbSPFAKIeT7hz04qlanHB0idtk0ICtZICdY2WT?=
 =?us-ascii?Q?EFgZjEG+zogop+VVmSRtAGtjVpnC9BAM0ePzyQa3/l2Z5YStvG8OsnvDhuVx?=
 =?us-ascii?Q?a0z1UuDyg95DnULH3/ZHKfgKi89O1Wy79/+Vqsbf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce86b024-d7f8-45f2-6a74-08da91e32d9c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 21:43:33.6269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y6zrLjAnhquFwiHIy3wcQustOEytfgj5qrRX+a0zVooudBWGvhaw1OoXlPO4sa9u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5674
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 10:27:06PM +0100, Robin Murphy wrote:

> Oh, because s390 is using iommu_get_domain_for_dev() in its release_device
> callback, which needs to dereference the group to work, and the current
> domain may also be a non-default one which we can't prevent from
> disappearing racily, that was why :(

Hum, the issue there is the use of device->iommu_group - but that just
means I didn't split properly. How about this incremental:

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index c451bf715182ac..99ef799f3fe6b5 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -351,6 +351,7 @@ void iommu_release_device(struct device *dev)
 	 * them until the have been detached. release_device() is expected to
 	 * detach all domains connected to the dev.
 	 */
+	dev->iommu_group = NULL;
 	kobject_put(group->devices_kobj);
 
 	module_put(ops->owner);
@@ -980,7 +981,6 @@ static void __iommu_group_remove_device(struct device *dev)
 
 	kfree(device->name);
 	kfree(device);
-	dev->iommu_group = NULL;
 }
 
 /**
@@ -995,6 +995,7 @@ void iommu_group_remove_device(struct device *dev)
 	struct iommu_group *group = dev->iommu_group;
 
 	__iommu_group_remove_device(dev);
+	dev->iommu_group = NULL;
 	kobject_put(group->devices_kobj);
 }
 EXPORT_SYMBOL_GPL(iommu_group_remove_device);

To me it makes sense that the driver should be able to continue to
query the iommu_group during release anyhow..

And to your other question, the reason I split the function is because
I couldn't really say WTF iommu_group_remove_device() was supposed to
do. The __ version make ssense as part of the remove_device, due to
the sequencing with ops->release()

But the other one doesn't have that. So I want to put in a:

   WARN_ON(group->blocking_domain || group->default_domain);

Because calling it after those domains are allocated looks broken to
me.

Jason
