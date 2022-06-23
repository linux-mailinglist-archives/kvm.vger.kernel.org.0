Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEEE558AB2
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 23:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiFWV1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 17:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFWV1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 17:27:52 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2045.outbound.protection.outlook.com [40.107.101.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA2551E6A;
        Thu, 23 Jun 2022 14:27:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1FT3UTzzBlPZxO4tu3U8wVGeETizlY9r8gcnFRhQl4Dacb/B7NecLoQNeFEjaeQp5eIsEEFA3LgLVsqUYA3uqDNz9/5TRHjGNKuIZGSyOxWmPMiVlUmvcy8fu8NBN+FKhG2vUOXNnVHJ3sKv9qSFIA8chncl3oulBwOHeaOUFYQHqw+UNzM/51dmywvoBwcphUzDokTz9kNUw8Kd/U4OcpZxuzpCbUq+KuT7G6CB4XNMiY49VAIKAPjdHYQ43Qyfh0sR2JlJofSxOj7BftGAzd2vacqWo+9vR1HLaJgO5O2eJlcpuWTdHXEwLB17lCfvMGPmDUziMFrzLGqU7Gekg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GwTSXxN6XjCHZpPcbzlDLPp//BKNT86b1DixJXG5QNg=;
 b=A1h3Nl/7MeAtD9o60YDCsa3QUfwmHqHrrEQ9CW/0xaK+FDeLCcmanYQ91TsLVlPW9mnil7sW6ubleSII62x19d82UnYB78kuWgZjWSJeTQ48tQlkznNi4nkJEk0iOH2FdMxySdV0GRLfJKU+7EnphDlCmcCn5jOSh2XHwpP2qwgWosToCyQ9nesSw0H12i3BvyBdp7jenmWI/xbYB76iasC1ktEW2nPCaFu7V3QXnKtySx8p95EJSeAsdyP5ACsbTv0sqsfk33KrVKkBVgPd0+ntBBSIOZggF466pD2/iGqydXO0O1ZMTJWQcsaDfqojIkb+dWH6OBwWL4qU7YFMwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GwTSXxN6XjCHZpPcbzlDLPp//BKNT86b1DixJXG5QNg=;
 b=tkT76Ww83MldudF7UhEFZ7gM7QbYPiIBlmbed8Psc/6mcEmPzegSDA1ouH0pOFbvFq7tSw7+NDPYf66FXBXKLAlOzND0C3dkeiKYx1YRsjUmpvVlJZfIH+az0OtxuP001Za6K8uqgTiopT3rFVo8NJUxeqkIRPnwI4583My4wW5l2Qf6JSeEUWz2vd7ahBxdORmOJ1q4m9NxIcdBLxIWfIuF6JrKjjcW6EMsIaGQYO54YjVov7VPrtI5LgnQISQ0SYVYU+rP/F14tG7YCySEChuxMnDMHO9qhl7aNtBPPC2f4bSvdObNLOIMW3hYbYCIjmkcBvxMjO58c3b++VjJUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1241.namprd12.prod.outlook.com (2603:10b6:3:72::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Thu, 23 Jun
 2022 21:27:49 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 21:27:49 +0000
Date:   Thu, 23 Jun 2022 18:27:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 3/13] vfio/mdev: simplify mdev_type handling
Message-ID: <20220623212748.GC38911@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-4-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614045428.278494-4-hch@lst.de>
X-ClientProxiedBy: BL0PR02CA0089.namprd02.prod.outlook.com
 (2603:10b6:208:51::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3587df5d-f049-4371-16a7-08da555f392a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1241:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SBBh/w5PRoUKfzg43ObSKADhaJW9ALV9M2m606mw9c5Qdzc2U55y4++3Rk74aFuXNrfjQEf5yi0iHM2azOGDjH+eTBy9dgK8cAlkX9m2vi8sxyYggi5ZXqs8q/gjGjs2INAuxrKKnu9uUD2MWhsH194BQDxvi5nPgPaRpcDjrwxgfWW3nMxRZJzenQoDwDwUvUCD+MG0dsEVuoXVamq+D9u3emronPBRklhh/akABb+LKZPeDD7/HzwJb8UVJbH2/mVRw3BlA7g1DgO4MBAcS+8oKxOeoSi3AhmWFWPWXDtvM+IBb6ZXbh58R2tW/qkko65pdcIlIq9qw9R55Xd93AHv3xMBj4waQqPbcrVfItY64lb68t1ncU09J/CxZyJE1N9JAejaQdiX6qx1bx2EMZcC5sLztDj56Uiw6ZGBEdyZK3ifzSxvNm05Rct7fAXFRotKU/H4tBk67I6PP/90bE9CMhkC844fHg+H0JYJONEILbwO7AYEM9pYiE2jpIk82W+FwBQMf6LbnTUuXy6MaWwq3Y1cQEc0Pa4a2BmFP/XJPmQaSIio1lYy+01BMrzyVjN5DSw9EEPY5J+QP6TWw1aONPgg8hpgmSdWlPwQb7gNdUrUiOroIC1c+ubm0NF4A9NOT0ntdnT863xr/4o07XVmO/DsGVbGHnHwANKuWRhNEtLXLslJotstiCCAH7f/Aub6xfY16ms/TwlBav9EZHJT/gPUcixDzYREmoCDb28Pe1JmhMdULjOIoIeqbHQ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(7416002)(66476007)(1076003)(86362001)(83380400001)(54906003)(5660300002)(8936002)(66946007)(186003)(2616005)(4326008)(66556008)(2906002)(6916009)(6512007)(478600001)(38100700002)(6486002)(26005)(8676002)(36756003)(33656002)(6506007)(316002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4beHDAyhWgep6KgL8hmCjdF3G/JAdTnbmfe1OWbsRZ+00rjd5zQljtPGUK4N?=
 =?us-ascii?Q?JIAYkCdIsBrom0Ew0vooFlNe5a/cGaPoNWFn1UaaNrxi/SGfsGjOEFxAVGBw?=
 =?us-ascii?Q?8jVJBcSQSJF4Pzd/Ykvjjejrzt/qjHBNqftnduT1s1q+6sMeMO03ZnFcnVzG?=
 =?us-ascii?Q?NFr/BLmLYymlHPS/qF+GUCNQsUPmE3OXy1Vlip66bAYFAKTgI9qUuiT3GWHG?=
 =?us-ascii?Q?QievN37Af5vsfm0gguXNFUsAJufz1qAHPlV4gEo+B19xrOCrBYyVfNT/+Bp4?=
 =?us-ascii?Q?DLDBchrDnGGnN7udonJ9MZh/WT5/uuJ5yrFiym2N6UX2EQtxOt9tfSKW4rkY?=
 =?us-ascii?Q?a9MXGvuZGfABkwvzLNNcy3RGyj87kQ7qkdpSQEuQhMJHMIM4HH3409vAtaXW?=
 =?us-ascii?Q?RGVquoTWb7LyaNuAVjQwELDtOrTxe1n++JhOv/6V5Y5vzVhSUbQ+v5L/7d8x?=
 =?us-ascii?Q?M1JzsTYVFFEsQ0NtQw2wSEZodVE2O6hL+iALw2KGSQj9yNTRyuhaZCEVoLzD?=
 =?us-ascii?Q?cE3/HDpR9DzmAmnH/kMV5jVW5AwjzSGRHwXR0n1Qf4vIr7zsYcol/sg1Btxx?=
 =?us-ascii?Q?3eRtU2p+3RDxFIvrvOaFXO0ag7E33YF8+oHoqpxn/08kq/6NW3XWkaCmnG6N?=
 =?us-ascii?Q?Vqgd75Coan/pAkKSb57k09Mic1YzMbcbCTvvlvSoUyiI4dZcl0gEm/HAyOV9?=
 =?us-ascii?Q?CGkmM0woGo8qG22NbCNtzGe3PWEPsCJlfRChNAlx4CkdNsw2SAMm0Z5sMuEf?=
 =?us-ascii?Q?+E9RBybULRK/VZD9kd/3gMwCgpv4VeVb2kVEzhioKaPAcyKLoKiY4wFBebFS?=
 =?us-ascii?Q?ERQck2pVSXPVjVbv/vUniDfPbY9/rZjLZLY9IuOo0lgF/aHmN+7fjgYqtIGj?=
 =?us-ascii?Q?R6zla4ljElQlRkc6W6W6GwksiHKv9QtHFE5853RSqpeSVJAqmv8iw8V2Jzub?=
 =?us-ascii?Q?6+JfaqHX5yMzdhRnvaYrT2PpBRMySnV8Cufd+TGc9fBFmqA4vDxZrjRDORMI?=
 =?us-ascii?Q?PS4+ptT2tlVRA0C6M4En4iFy4kYLSzpMzk87RcC1Nk+LWq4J/Ux0ShfBtjUK?=
 =?us-ascii?Q?Ez/f6rHmgwhKRbih9GaiRKyHwkWq1+oqPWUug1O9LIJ+uyAb4VTD7niUEF44?=
 =?us-ascii?Q?1igAfUFf7Y9fkB07eNiZkq5vlTCS8LuB5y9aSiMJzBKm1diuTyorjZuFaipI?=
 =?us-ascii?Q?62CBAKSvzo9Qa2hkYXQIT+R57917RBHJq6kA3y1N3JOO+oeUscJS4W/lFjNa?=
 =?us-ascii?Q?dt/g3lHBGDehAyWJ5KKoPXwjY9fouZpxbz6K/XuhRkLXcHA/ue3zHG436oBk?=
 =?us-ascii?Q?l86pDkO9o20P+5lS+E9AbGwznyrYljV6e0/J1Tz4hSPz8lmqZu3PQ8VPG1FV?=
 =?us-ascii?Q?0MUBogZP0E3XGEUv6tANOfK1gqAsSMNfWZIubpyYuSl7vG0NclpfIxesPesB?=
 =?us-ascii?Q?SB5Ea52Vf8QeiSR9kZWwLOt1yAe+HwFfd14tAmJnJOZ9JhotE7kKLbAiJxbs?=
 =?us-ascii?Q?J8mzwX0mm6nCWZaqEevATMKkdEZY/sOGoDwWtJcms/xqSTu5uTBfnuMDAGEJ?=
 =?us-ascii?Q?Bet63u7eOBwA3nNx29AT18ImL8VUZ4HiUuFA2Cz3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3587df5d-f049-4371-16a7-08da555f392a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 21:27:49.7679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PaUD9DWu4MOZtBe6wbtGH0D/ek08kyBKGTZpzDIBv1hpiZW7U99YqP8Ou17n1mU4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1241
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 06:54:18AM +0200, Christoph Hellwig wrote:

> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index b71ffc5594870..09745e8e120f9 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -80,8 +80,6 @@ static void mdev_type_release(struct kobject *kobj)
>  	struct mdev_type *type = to_mdev_type(kobj);
>  
>  	pr_debug("Releasing group %s\n", kobj->name);
> -	/* Pairs with the get in add_mdev_supported_type() */
> -	put_device(type->parent->dev);

I couldn't figure out why is it now OK to delete this? 

It still looks required because mdev_core.c continues to use
mdev-type->parent in various places and that pointer was being
protected by the

   kobject_get(&type->kobj);

in mdev_device_create() through the above kref..

eg after the whole series is applied this looks troubled:

	/* Pairs with the get in mdev_device_create() */
	kobject_put(&mdev->type->kobj);

	mutex_lock(&mdev_list_lock);
	list_del(&mdev->next);
	mdev->type->parent->available_instances++;
        ^^^^^^^^^^^^^^^^^^^^^

As there is now nothing keeping parent or type alive?

I think what would be good here is to directly
get_device(type->parent->dev) in mdev_device_create() and put in
mdev_device_release() then it is really clear how parent and
parent->dev are kept alive.

It looks like we also have to keep the type around and ref'd too for
the sysfs manipulation.

But overall I think this is fine

Jason
