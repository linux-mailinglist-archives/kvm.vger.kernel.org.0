Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9176CBF62
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 14:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbjC1Mkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 08:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjC1Mkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 08:40:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1164E86A5;
        Tue, 28 Mar 2023 05:40:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVYj/2x2RnvnRvMsFN8SbT9zEsFrUyCHeQavBm6xTjO+mXDUUX8D/RR2eXW4tmk2ndY55hQFcx2O181HvLYTaDuhUjbuBlRwI0wacmiYj/fAt7gBNWk23bxv9BZ190FwbJ95Id41AbExYajpMlFryP6KgVZTqEtz0bpSswVbPdX32qIAPJf15uNX18jauWeXAYVaL9jvjdgHh3e1xhuRh9Dwsh1x7CQWkiyDBeeKxQGb1EWkUifCPog1ChOjSvzD7/Ts9QaaOYCpCvgTtsKVK9Q9yosqY2GuFzZX3Q1zB25NKSo3fD3paPD8hm5pe95Zun1z0RW/42y1lXy214104Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Za6JcKnTjWSLWsCy+Fb1cEu2P1jM/s3tiQNMQTfTp5s=;
 b=J9EuemWpiEyCDcutU7J6WJUsV4cZTueE1znxXqsqcC+899Vt1k5iPN2fUzi1rLTHGQPPQgz1TOStunzY0lDoAnOd7OnQhL8mLAhgJ6XJ9ZZTALILH5MYNcH+TPvwmFXBYv8SELq5alqfkrHJSx/46D6DTmiuEx9zaDYgAdQjOelMgRk+21BC0K/rqKtCaq4e4tYvjm7qpk7c0CAcQ4H4gNpzeoQAX44ECJBY73TCO2gTFveWHPYk8w7/gSOAwroMdUN5I/pR5UD+rr8+Pa3cbVph41ui9Vesq1h0MCDWFG0etrevC9F/beJMloFGSO12n3ITXsMXD0Fx2qDWvnN9Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Za6JcKnTjWSLWsCy+Fb1cEu2P1jM/s3tiQNMQTfTp5s=;
 b=BZoQehOxJjoqhYDkZ0UJE+FxF9CNUuucaDTbpmqOGmUv38RrE5/TU3bDYT7keG+HFglVqYpLgYJUeab3PT+n9BcvOHebTXe9R/8zAzZAyMVQ7Abxm43FD0wfUn+kr3pVJIOg9naDoIuzIeh9PCQolquXEgNfe42dCLm1qvE09aZ9JVqVVN5zErJwXEOYJu90ljCi+0HEDJsfZcNjkGPLAHmBqWBGkQI4lcZ4wcw72uo6aV0Lt2A8ZxkuGr/meMBp83T4d6Lvf/WbY8LMzk0/wopZVac/ILZRGB3P+4du5AXGelbc68Rf8a/T8p/OkINbRBMsHoCJBTIABIB8C6Hw9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB8563.namprd12.prod.outlook.com (2603:10b6:8:165::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Tue, 28 Mar
 2023 12:40:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Tue, 28 Mar 2023
 12:40:10 +0000
Date:   Tue, 28 Mar 2023 09:40:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: Re: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Message-ID: <ZCLgKKeESkh3Cdk2@nvidia.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
 <20230327093458.44939-11-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327093458.44939-11-yi.l.liu@intel.com>
X-ClientProxiedBy: CH2PR18CA0040.namprd18.prod.outlook.com
 (2603:10b6:610:55::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB8563:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e9be98e-27cb-4172-5e3e-08db2f89918c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z5UJVksyHFx3ZswKWqFkhxVEsQ4SBwncdB1VMJrFyFfeGj0Mrn2ZPv2v5VKwx0F5TJpMvfbzWQ23hpN1ckzMEIDTWw263KIyWrEH4iXh4o1TJzdyQmrsCkptsBa83OGmX2+KRzzXxUlHyCUDwzHEcR/4Zjp/IZC6W3lB28fMW6Adt2LQ50W+x2m6hfrJ6QtBBV+J/vgMsFFvY/TEwi7Nl1CeeNUEHhLXPQkVzj9Dq4ntaYcDT6xnSk76rQEjgdniKGVeagqzL5B0OinUHk3cKnLrffm/aBdXHi830ZA4RLuKhD+eqqmmT7yLjY2/lK4IxKA6Ykk03cRH+kFKzj3uKNxzycGfUhoYEpYx56tnPYZKyFhdraRtyt5X2Q2IFsEmebq3js1i/ThL64/4knaLSqjeFgrFX0LqVtiiHzNTk8lrfSUdEfvAQmwnSf+Mf0DzRejgGtXHX28QskvJOzc0ondM5CJUYeiNQ4hXAmuajewu32AAUuZxYKFLHWlJlDFt7HRg4xZ0Clbr5G/4XwTZ6f9vOo6GAiWDkAO4gIC2bd/X9h+YfWq2/ELox3fb5ccp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199021)(26005)(6512007)(6506007)(41300700001)(186003)(6486002)(2616005)(478600001)(316002)(38100700002)(4326008)(66476007)(4744005)(7416002)(66946007)(66556008)(6916009)(8676002)(2906002)(36756003)(86362001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/7C7bY9d3rLNd6+LbPsQZEZ9h9WB+ve73EuSXnmLagHagvkGGzDhzW7VzYbE?=
 =?us-ascii?Q?afKeM+m8UMXB7H7q8qxn2cxvEXkuFHnMeVpJWtlftWJargB6UQZocEhCPGQY?=
 =?us-ascii?Q?Q3NkdHWtNp7rOO896cf2njrp5QJWA2DQj+xHn4vX1ryu9nqj5UHz9q4vibEE?=
 =?us-ascii?Q?K7W8/jhozTEz3mum9ErlJz7OLobPlD6PWv8BThMqV/8m49BzbGTQO3Hx00IX?=
 =?us-ascii?Q?qf4G7FvVsrgOZKHYz48T/hiZ338hJYuye7XEuu22hwh47HUdzkVUD0CZGuWN?=
 =?us-ascii?Q?7cJRWg8jPoBH0QdszojcFEl0tzgztWGLSzQTWs9VigGSkcKdTq56f+MNpuWC?=
 =?us-ascii?Q?wI5Yt7tqhtdQ2l48jqacmEN6hqM2z6GllgF8zJMnN2tfk8BJFBhgYHBtE1EX?=
 =?us-ascii?Q?fe79x4EAdzHlnhuyTsPS1+0P7lbdD+NcjzLyHHFtWfbPD3pOMxf6ciIyDYkn?=
 =?us-ascii?Q?ciYrMqDsBldh4rsg+dTVRK+Cs6++3j+BywvvUT6ILVUQJ8rcw2yB/o11ujY7?=
 =?us-ascii?Q?7zlB5V9ZL/Jn9/2hgnQ9tbxG/PakMzGV9kGzamNPeFYJUaGKY+tyJVzUZSZA?=
 =?us-ascii?Q?4Cexgr/w5hdMPoPk6E+7EqHtuoLctye0jdOfTAOmg6u/dHJ+6NhX6MRgLbBI?=
 =?us-ascii?Q?FO+2jm4BU0rsTlpvOTAcGnzXMoeU/cA6vR8LjW7vRj/CPNLB1Pg/qMTfmwNe?=
 =?us-ascii?Q?6TNXGwTjLayUVSyFBgCIJ8m8NZp204ofQmxlvrSN/lVjrEiWi0qo3RcqSm6X?=
 =?us-ascii?Q?z2YhUoooRA7cyiPn0y4Rd17ze9o/SFjcWqAsuaaXMSL6oHWkawku8hUi6koi?=
 =?us-ascii?Q?5243N1TQsWZcoS5WX6sJ1C798LHvzHpVs/dH6IqzJjNCAiDib8tfqMvEcyeC?=
 =?us-ascii?Q?puwPcSfR9vrgnOXXDXCOZvBqvpBfy/V0kp6i2t080IzXF7ap7jnczcAvd147?=
 =?us-ascii?Q?Kb8C2P0wYgaioCp48G86fEOLJFZF1iK6LndpK077mfO2dAOIO2RCcjuc+axS?=
 =?us-ascii?Q?6lGhE9qQhBaLGoooaLXFtuHaAW5NpvXWwoTA9Gnr0eA3QsueJrs21tI2cyjc?=
 =?us-ascii?Q?V5Q5ZCe2j0spHaJhxNG7Wgtb7gaw1g5c1rm3d3v7Z5/1GhmWk1KPWRH0nh4g?=
 =?us-ascii?Q?WwoycSdhUgOr6XvvqpfB3SOmiGKR0U2YsZUtLmh1NXOWWhUZ5XtglnkXw/AB?=
 =?us-ascii?Q?/sTtUTRprcyC4DecvlYqcmu65mcnIvkr5fL8j0jYHtRsbPXLMxV4DvIh6A9f?=
 =?us-ascii?Q?gf3dust72XLCq9O8o2tvMc3B78+fmJ6cV3gJmZtA0ZKGFXi6VC0U1XRPfdjJ?=
 =?us-ascii?Q?5NXQqFr7yser/dFjr7l5rr+HYCaW/KA+8/MjxCRD7mcl7HGAv3uLM7PNgg0Z?=
 =?us-ascii?Q?y8q9UAttRf8cboANM3vAnMcuXnT8aJF3huBEbZj5Y3GrcY4dhH6yYoyCTzvm?=
 =?us-ascii?Q?zWaFM39kYSIo+ttJtNxTsSlpafPjKTwPyRXxbbGz4bjT0uPuBGJ+5X906W5K?=
 =?us-ascii?Q?NrpUmXu/6w0i0UprsPNkJ2aYBobeEbr0hYdnmUYLD9WnS2N5xHr3jldYnTkj?=
 =?us-ascii?Q?1pdnnUdm6sAlV7Tfqt+dbRGON9aiXzb5pkC/G+1C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9be98e-27cb-4172-5e3e-08db2f89918c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 12:40:10.3205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0usAbq72WcJ6yIQBvnqs5/przNvRqhNp+mqBQmsjBhSbjTUe1vbjvZYOGz+zA0d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8563
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:34:58AM -0700, Yi Liu wrote:

> +	devices = kcalloc(count, sizeof(*devices), GFP_KERNEL);
> +	if (!devices) {
> +		ret = -ENOMEM;
> +		goto reset_info_exit;
> +	}

This doesn't need to be so complicated

> +	list_for_each_entry(cur, &vdev->vdev.dev_set->device_list, vdev.dev_set_list) {
> +		cur_iommufd = vfio_iommufd_physical_ictx(&cur->vdev);
> +		if (cur->vdev.open_count) {
> +			if (cur_iommufd != iommufd) {
> +				ret = -EPERM;
> +				break;
> +			}
> +			ret = vfio_iommufd_physical_devid(&cur->vdev, &devices[index]);


u32 device;

if (index >= hdr.count)
   return -ENOSPC;

ret = vfio_iommufd_physical_devid(&cur->vdev, &devices);
...

if (put_user(&arg->devices[index], device))
   -EFAULT

index++;

Jason
