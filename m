Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFCC6A7246
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 18:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCARtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 12:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCARtb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 12:49:31 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FC61BAC3;
        Wed,  1 Mar 2023 09:49:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3QplulTtxmpfCm/46qToVfzRlwIJ1phCpH5Z7BzVC3qSILyjw8tmMCYOWxDx2B3ezBWyCah9N9g05zn8oX2qIPHpNNdmc/KFcEEAjNzP0sHcfeqaxJFCTnecIjQF0AGpayxhy/bn10xFMLKT/O0hkLv+213i8SQD/lUTdE2BxUkrl0DDQirkjY52gfhc4ZSl6kQypFPS0m+rrlTrlEBYEOrL06/18RQMEMbLZ+gIOQosPmJ3tcGhC8JGkHbespdy2eieTxABIuWNQQuS2RcQCUVZ/lAF3Y5hgcmVvxMIWEOFzJqHlax8W0fVoRn52WlBsCShjdwPPFtuCgXVJfSuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+cJDkr1y/gB1vRokOH8601SdTG8JVS1zQNGWMhZ4JE=;
 b=UQO2gJsWDl5SzuPr6cdqz4ffvc6Yf4v6PJZklZP6oroQ3ec0OZUbHdJeMv42KeIzaHvIfM7uU9kC8ikehHhjoTiTH51qaXVUD6dh1s79DE73xQ7bzP3XnuU1yme1/ywTDZ5FxDv9tL4LhAAjuQ7NQrQcJdlLnTUL3J+eVxq1ruH6bHpRTEDMuRnbhqHnc69PHhwYPEZWKQDTjJyu0EnAglq3cUANB3h7igbGZ+bpi/MR5YGOjJXRd4yjCoJJTLa2pMJS7tWUDURjX2GHs63yVvbDkNY+jQ1b3S3t3MCzrnjXMzkOlbLZwqPe++C+S4UyqwOTiMk0QDSto/dS2zkl9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+cJDkr1y/gB1vRokOH8601SdTG8JVS1zQNGWMhZ4JE=;
 b=JRO+yHwTKpnVZGZM2hFXyWvKow8EjtK4KOEhIK0bo3c+7GopqqhHWsvQCoQFhUk8J/96td1C7IioCMtWHBRLoyCa6ltf5H1+SzeW2mzLfZT+F+xKvQjsFX+SgyF0uZ7iGqp7fsLMsuBNPWaEIxZ4nptPKFkN/g+xoLtZzAKyUAvMQvBl1LatUar754hnc0xwrKUbNxilqf8N8udOBCXJ5gFGjwttpiP1spLBtyTWhAqpi3xFLG1NS2rp5gGBGAb4UwnYTiiFN73zd/4cjBK9Yo37NeaaBGCeQpneQQwTEd+3YxsSGEbjIRefCg9qcP9GtoCz7xdgZixgZR3ssriwIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7218.namprd12.prod.outlook.com (2603:10b6:930:5a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Wed, 1 Mar
 2023 17:49:27 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Wed, 1 Mar 2023
 17:49:27 +0000
Date:   Wed, 1 Mar 2023 13:49:23 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Message-ID: <Y/+QIz3VT7iD0jZ5@nvidia.com>
References: <Y/30TEk3t7q/D0Ho@nvidia.com>
 <DS0PR11MB752931AD2B92DE9A1A574375C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/35ZTi69p9cCuPn@nvidia.com>
 <DS0PR11MB7529B6647B5F4B7691FFFBEBC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4AzJbjeR4R2rcO@nvidia.com>
 <DS0PR11MB7529175CF279A820C5E5E091C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4FDP8H1qRdgVrL@nvidia.com>
 <DS0PR11MB75293E34AB7C53F7ABFC0E36C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4R2SRFKoRFg4qK@nvidia.com>
 <DS0PR11MB7529E456C277723146A09E2FC3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529E456C277723146A09E2FC3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR11CA0062.namprd11.prod.outlook.com
 (2603:10b6:a03:80::39) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7218:EE_
X-MS-Office365-Filtering-Correlation-Id: 9555bf38-149a-409f-dd94-08db1a7d4d39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Z1OovjO+14HDSxqAeDTNz6jBVrx0ig4yYPIHi8cotsl2AWnPBsrtpp4wmQRpWvKcgKsH7NXTmqi4nXSh6cBE2iXTFnk5qYYs0tP75v4O7BWCnA5UlHqN8L5nvO2u9/4ko3ChuXBH5tfF7jlfnRnaQh6OR5Mt4bDvx6dInifC7xrqeRgPGbr8NuLpHUIlN7tK/QIgGhtjPCPQFiES7liRsgVwtfdg3gpFK5mtyMz08QE5yRokOvporW2UUEdT/Q6YXrQCwcHaL9H7XlOq5WMPcHssNGqsSB+O9aKWTIkwBAE2NeRj+zrsP7t0jOyzxw4q8k0PzMOz97pbGrCAyxPnv9k0bT+F0Hx/Y1d5Xhdn4V6OJKRbmHLKIF4W4N+4PwHChOvaYz7p0ONrnTPOVQOH//vX/Az/NT3/I5I5gDpRnSzF+28LeoU5iOdvchkvf0YqJu9erIAoVWpiJ6HtPcUrcKodJw8QiIk3gHjphXWEiRkdxRrlK3dbQb2NV+AOooHRpvoVYwuzJ+WFVGAhmShh//TBq6t0fX5h0q67tpRFWJS+mtRYQnUXuq2Hz/lIv0eHPn7RE6qr0IIMryeJ7/k0AnMOvMywC4243RaDzmLhNKrWKi+7NTDjoI2VDSRzfPbWJo4NIICFWOPqFA2qpKF6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(451199018)(26005)(83380400001)(316002)(54906003)(86362001)(36756003)(6486002)(6916009)(8676002)(5660300002)(7416002)(6506007)(478600001)(4326008)(41300700001)(2906002)(6512007)(8936002)(66946007)(2616005)(6666004)(186003)(66556008)(66476007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CYF46MKU4Nk1PRkyOMBatujcnSHnzVTeBFRhDaFjHOVE61LtHV2x2TpBMASP?=
 =?us-ascii?Q?TklOMzUc6Xxa8kYSo+zo+W0JnHn7pNpQuejuepsH3rNLPPpR8ir1i3l9OPob?=
 =?us-ascii?Q?WVrTs6cIpzY1CDbkX9LQv6YVcoW/Rwz+6GPYKbI+ZrgM+NH/L6fNRQGF8RON?=
 =?us-ascii?Q?NsQBX/9VA+zPnydYN9JE6tmq8XbL3Gcx0KHRaE4HeIxsFHSEIXhfFNa5mFPE?=
 =?us-ascii?Q?lKl3NtYTnYvzFUSLTyedNZTz07ynwU8g59n/uVsx4oDvNueUtvsDaAnWtgD8?=
 =?us-ascii?Q?kF4n4Qrn7ob+8FIS2JttXODZsN+HdzaUeFUT5/OxWDU/sG+GNfOkQoFxDOWT?=
 =?us-ascii?Q?KwX9vb6UZGKp4+HUGbIe9CSDOSRTFZP1fklBfvHeINiFcAaMtfeksPUYI2pY?=
 =?us-ascii?Q?jsr3SGAr5y8V17ka/wiBm2TJc4vy9uxqmldERaWaDMw6a6z+FSgRoUWj2KiM?=
 =?us-ascii?Q?WIApp5638XE/2Qwc+xhWfrw+rpDnis/iE5rhMYcGxAJYAM0ocsUNx79+UDj4?=
 =?us-ascii?Q?Ou6OF56jFO6kCe01sGm/Q1Nvc9WWYiquRos49/1U3gDk34nENBzj8fXrkals?=
 =?us-ascii?Q?bR012HwmZ1sOGoB9D2KLDwfK0BuAXPOmGa01yjQBDpyqT0VHHVBg6mCW4gxu?=
 =?us-ascii?Q?xSGz73BzwXaIf2h9ruHYmIFirbEOuHLiJJ/PfvHumwVlLOfxDYvmeuQu9dsR?=
 =?us-ascii?Q?BZA2nZwyzUrnf4WfNWXAKLbmlT9u/g4dgMhpA7MaZ5wYDi54IRXBRhPzpmdz?=
 =?us-ascii?Q?InpiZ+x1H9vXczZEB+3k92bsAnxSTwLOl0ObewHJRwZNcv64M8Rejmnjn72l?=
 =?us-ascii?Q?an/dL9umhlOkAaq8dEd+TUJpypcl/Of6CriLJvn4scnNqPuQ6nx7LxlpKWX2?=
 =?us-ascii?Q?7R+hUoU4CyNwvlqkCADOoAbDB7ci4qUng7A0zLm+0TNv6/Z2SpuTVyRBkG90?=
 =?us-ascii?Q?qtiJMq4eNBBzPkGoCiHyKq/FML7FBLR5QgWQ4beOfWs55wmea0tizBREfOJ4?=
 =?us-ascii?Q?iGQUFz4Wxj7yG/OxDoK+cpkvvOLZR7rDDixPzPBweSCrE2Bj/jEOeNuTpGRH?=
 =?us-ascii?Q?ovbEtjmtv0Mb8cWmmAtj5nHOSyjcC6p4szJofmvF9nKJmsoq2qocRhoKJZ4y?=
 =?us-ascii?Q?/otIzhvbGh52nfv+rxoweJOaw7vU+228fukh8iIj6RhS7qmaDkReGmANDiLn?=
 =?us-ascii?Q?DYRoZtzN/OAAMhO3NXxkBpG4aSrli8sqpWSY0Ow3J155HLGWAXhcdv2E3sSJ?=
 =?us-ascii?Q?/SROhNF4f4mgdAtZAzWUpUS6fppA/y8uDyqvsOEOfq8vRH65HslPsQFsUBaV?=
 =?us-ascii?Q?QbZr9bdV/wM3lHW3kVst3Hm74GFA6P3U3DVBNxOJwvy61UlgOk6GUWkscq0l?=
 =?us-ascii?Q?IoJxMhU0Lw0nZCXMWNsCDsfr58KA/XH/WW9VUCnZkzHXCaDJsFM4XKDsNktH?=
 =?us-ascii?Q?UewMF9L9Z+A7v12tlXjeXAVTFJFHqsPT5kQRTlyr3g2h2VDzzdYH/KmTiaNO?=
 =?us-ascii?Q?QbbruLJhtgtWfzBQrvb0T04atzH+UL/4+XWBM8/byrTSLMP8UucUwkT4NlHt?=
 =?us-ascii?Q?vXouJtQwyrtfx9sPTsv8/ow1NsS1Fo8X04awbrYx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9555bf38-149a-409f-dd94-08db1a7d4d39
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 17:49:27.4428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xIq15F7wyGdvxE5mMnnS+X3BVCma+tNpwcAjUNGjHJ7xgDSf98xBEFk9+et6CeY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7218
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 02:04:00PM +0000, Liu, Yi L wrote:
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 2a13442add43..ed3ffe7ceb3f 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -777,6 +777,11 @@ void vfio_device_group_unregister(struct vfio_device *device)
>  	mutex_unlock(&device->group->device_lock);
>  }
>  
> +bool vfio_device_group_uses_container(struct vfio_device *device)
> +{
> +	return READ_ONCE(device->group->container);
> +}

As I said this should take in the vfio_device_file because as long as
a vfio_device_file exists then group->contianer is required to be stable.

> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 121a75fadceb..4b5b17e8aaa1 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -422,9 +422,22 @@ static int vfio_device_first_open(struct vfio_device_file *df)
>  	if (!try_module_get(device->dev->driver->owner))
>  		return -ENODEV;
>  
> +	/*
> +	 * The handling here depends on what the user is using.
> +	 *
> +	 * If user uses iommufd in the group compat mode or the
> +	 * cdev path, call vfio_iommufd_bind().
> +	 *
> +	 * If user uses container in the group legacy mode, call
> +	 * vfio_device_group_use_iommu().
> +	 *
> +	 * If user doesn't use iommufd nor container, this is
> +	 * the noiommufd mode in the cdev path, nothing needs
> +	 * to be done here just go ahead to open device.
> +	 */
>  	if (iommufd)
>  		ret = vfio_iommufd_bind(device, iommufd);
> -	else
> +	else if (vfio_device_group_uses_container(device))
>  		ret = vfio_device_group_use_iommu(device);

But yes, this makes alot more sense..

Jason
