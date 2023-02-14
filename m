Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC64695CFE
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 09:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjBNIca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 03:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjBNIc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 03:32:27 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CB9B77C;
        Tue, 14 Feb 2023 00:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676363546; x=1707899546;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zNXzVZ9QHa0LM7zat/3KGryCdmWaMMkxjtUv17djOjY=;
  b=Oz93xH2E+Mdui4i/IZLjdC+YZr0bT4VfaNR2QuTDGv1uwIAumgc6XrKo
   6azWYN/K3/a17nbequimVcRiplIUvTz2bquiLz8ofj0NCkmY7R0ZjfL9W
   jYeYFIsYhPhT7cy7qLwfQH9pPFYkuR6G1YP5le8nUqbS2YIchEHrjzqyJ
   e9CjfOZUawn0/j1BO6shQTMRdSpQK9GzrbCngOt7qS/kq/qev2LAJuKPt
   UUch5u9bt/FwZ6o8/O8WvIe4QpFzFFb0E2LGJFtE0eWQA7ekf7JJTjYWw
   HUP8Pf7EP/vXmy20T0E3zty6gJupiH83CUw+CNn1YbxNy7KfG5+FP7p08
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314753504"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="314753504"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 00:32:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="662475326"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="662475326"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 14 Feb 2023 00:32:24 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 00:32:23 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 00:32:23 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 00:32:23 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 00:32:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/pXk2oxOwHM6z+SpZkVztNwkT8+/CuDdS2xvT4JgQrwlUT5t5N71Mvnykd0VACHvSUED1Q1vWphUsjpU3Ea00ZZvLHlzRVJGGUyUfRKXiw2L2kczS4YoIXrrq7bCVENsOX9oSuiXFVbd7bRSp5lgHey7fx5UfvY6y5xrXaIm70xixrYVdoISvSfcOR9Sy0NcLLSswFo/aPnYWIrwG+dG8afb8/6SllTBjUAlyBWvfgHJ8TJCleWftIdj6P3gi2CaqG8kBPILHTxH0fi7/NMVInktuyykD0VxkYNuYcCcZQj3GCsc16ZSoqAkcTSyzgquCEXkFhSe4CASmEbgCO8SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cXq9Lc5WNqEgpIYL5TVeV/vsnRjrH68GEy/lr8xTBA=;
 b=cNkAh+7FSAfIotmwZJai5LFjrGhfntxIwAZEII0wC+yktpd77g2Vfw3x2G7lzWZX2+nybnHyNpPznrJURH31nk0A3C5vYRAT6/moJTRrEFhgu0c61oOVShNAwkQO5fwMqIj7dGVAGLnCFScDGHbR8Y2qC4sk6vJNJhUYohps+rog9vKWbhktJuuRUrNOpicY+XYZJdhSFbQlpso8qpnzuNFo1LqjH0E2L/S0gePygGuv0GDPC/6xNnLeUJpbgDbDu6gsI1rEpgQ348qV93DjNieuWaDnP+ZIvzwWMtOsH24WzFEdYPckT/ONgPwumuU2LKjBrN/jKsg5I1ybXBgS3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7986.namprd11.prod.outlook.com (2603:10b6:510:241::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 08:32:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 08:32:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 13/15] vfio: Add cdev for vfio_device
Thread-Topic: [PATCH v3 13/15] vfio: Add cdev for vfio_device
Thread-Index: AQHZP73SOPrC/9DQnEijcGGsf8qplq7OHaQA
Date:   Tue, 14 Feb 2023 08:32:20 +0000
Message-ID: <BN9PR11MB5276BEEE8F501E2B88F4D3238CA29@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-14-yi.l.liu@intel.com>
In-Reply-To: <20230213151348.56451-14-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7986:EE_
x-ms-office365-filtering-correlation-id: 45d365d7-4401-4051-28e5-08db0e65fd72
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ukpAK3tb4XHxGBZIqZWZ2rVlQrMGSriWGC9cU3dDGixrNtWHj3ku7ZRre+fR2qRRprCQyfoTwTHxJuKRCc55Uj496MKumZdDAvWjF5txj50QXsgAXHH00AIUdSQQFbDGzTFC/bX7xi9Peuqw/z5ROqPOluVslBoEVHZ5dXXDB1hMc1DYcUcjIMXVpl/UAJppZOaeKPFqBIu/T4+ywGfTdPVQD+mQmZYmyFP/aQ+/j0wrINjAn5gfFLsGxaGS1WzLbD3KFDcGFJzTtLXUHDHKiA076p9If3NTyyD1nBvv2o7bsiF5w1oFaeVf/aOM/oOXGSOZlVRD1a+x8cNyIYn/F008g8c45D2Eebr5U/CMW3hNTF2jM2dF1yoNPgCcaE9AIQhE8XovjMIuY6sVlesNfXqE13I5k6568JnQsZzhCItgiOg4S6WVoWA5U4imAuZB0+FwLtgRqg5JbS2vzzB3Gl71VKZrwIs2nL1ZUO2ZEtHmPJhHFhHu0yRYwiJPH4Vw6iU6bOyfusybxedlHYDL8K3dfAm5yV1zN/8rVizkb+yefdmKOFsAjv4FaKp0PvN0cdCDulJI3RdgLR4EXT+EARO2NhJN/hCh8peFhIiAD2BpPmpgEOC8cD/RrIeSYWH5HaaNFignDkb84I2B3UxKjzQzwKSYkvOJb+sSL+FdAZ7zpMDCr0ZW16y8/G23QaCCh9E+pI2QQKicqe+z0gebg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199018)(41300700001)(4326008)(76116006)(66476007)(66556008)(66946007)(64756008)(8676002)(66446008)(2906002)(82960400001)(38070700005)(7416002)(122000001)(5660300002)(52536014)(8936002)(38100700002)(4744005)(186003)(9686003)(478600001)(6506007)(26005)(83380400001)(86362001)(55016003)(110136005)(316002)(54906003)(33656002)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qI1EAbyUnoRb9sIu4a1+yTYzEnT5uenQVyyET3hf49bNQK3i8jZb6tSWy/4k?=
 =?us-ascii?Q?R34jyF1rgp/4Sfd/TeICE/mVXJRoWbuYRYfVBXnmIhxA3VkMVwVczTVTUJGF?=
 =?us-ascii?Q?bffZv9u3dVkEHFS4VY1TNdyzYE9ln1S4K0ABX9HGfj4GlXJb3zIRXX23tcje?=
 =?us-ascii?Q?Fm5HIq1SReUrhrpUSqZLc3C0m5cShE9LI2XkiC1T+ll5YzBOpToYYPqGdMCo?=
 =?us-ascii?Q?cLBOXtcNBcW/Wfsv5Vw9kt0RkR3MBN+HipnyLPdx2sOuJCYhGOVK9EYwWjTB?=
 =?us-ascii?Q?f6P7MQ8pdDtiANB9TCSILD4Xe0kvxyxRoBlEqoYUUVQRIX2YlmiaFIGysD4R?=
 =?us-ascii?Q?rkyEIGkowL3ZqYcVWpj4Fl88XtmHHqvzy0MYIowJQOQqBDUC62xJ8/Dg7/pA?=
 =?us-ascii?Q?iPdhHlY6HFZlxF/w3HHmznctaGPSAGtgqIxV73hIlDernG5D+GFDNcLUJP0j?=
 =?us-ascii?Q?djgfO6n2G+6+9QGHrBbErv64vqHdYff9zPOVzBqG+2wl8Zq5xOKDbMnoobDU?=
 =?us-ascii?Q?VhlBLsV37eSRpk9wzAPGfCgjMRjvH4oB2bdeEPVzYawPdHZOWvdxizvptiZh?=
 =?us-ascii?Q?Imm7ekuXrM949yVn/3bnEN0EE71lE30pJ7F93vOKwqwUCRx9cadpNtIinGIa?=
 =?us-ascii?Q?dD53J9nT5IhUhseK0Q6oKYJYK8tmDGpzEp5/Rk8BboygV2FJngVjBCCniPGW?=
 =?us-ascii?Q?Yx5h3ZNiKTF1KX+27b6s17fbHR4acDw6b9EmaVNHVAQigwpierw6CLFcW8WW?=
 =?us-ascii?Q?jIU3fF+2bd1lqYuaIMqiK88+9MS33a0wP+0tNSOkSB1lCeuSw6Goo7w1vmgS?=
 =?us-ascii?Q?eXO5C4YPmDmn5S3G33yOFQqMbOAHqEX6ljPUQBDvBjtwFqge+f+9ib+WtALK?=
 =?us-ascii?Q?I51yYyVqMNJ5gv5y1eUPJAypZe2joGVZUB7hNRuJeLTsBVq96LFKeKjZ4mrU?=
 =?us-ascii?Q?Ue6Je+skG8kmgF9Yk32TT8jKhafToS3IhtWLVPaS4vDr2itjNEPyUgHvvZi7?=
 =?us-ascii?Q?3bOgqQ5cczTM/ikVc4PDmQcZEViYo1OvnRCrvBwDJss89WpiXmYfUtXFFBxQ?=
 =?us-ascii?Q?4oa1LgVy+/xd1YvuFZy8hbe6Q/ZhhWZZkVs82+tEKquIFTuqN8ENH+ZHoq1E?=
 =?us-ascii?Q?oCpwYW1pcHVEJzUyMqEZOLwP2NvQY3GGH08T+U6MP+W01v6LKDTP5d4C9+pC?=
 =?us-ascii?Q?g5QkIQk1Z2n0skF6VxkcMXfLV9IfWVHq2Sqndch67SEVCjmSdwnHdbmWZDjo?=
 =?us-ascii?Q?70rzs/G2cEoGrDppDLzR1NdKYuGh/odORTcQPK7ELdyahJU18WwJBpv3kiSP?=
 =?us-ascii?Q?liJ8DX5FWWaH094rMiPkOmQ32fCQbIZw6IYFpXWJ9+U04La6z3xvlDkWBwrJ?=
 =?us-ascii?Q?X0gKFb1DTB0W4zJM0xYYGvZDr0jD8VY5SLMvzOgo6sIC7fdobvspjtOk5Ksc?=
 =?us-ascii?Q?kdlHm+EFZ28cSMs9DGgrm6HCq+JFn3vguvfQfaK+iJaht76X7xaNsl1i3Qor?=
 =?us-ascii?Q?8a5CDPx4oKPANZCx5O2HYNBMR/eOHyD5cgkVobNaBY3/9uJBkg+N3Wmb0vQl?=
 =?us-ascii?Q?pn28QzEtEOPa0g8s1vvSKZvRaBxKQBt+C0IP2Y69?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d365d7-4401-4051-28e5-08db0e65fd72
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 08:32:20.9347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dCNv5DG3hCEC/0QsOhR13nyx9RaaDO2PV2SjHG6ZnAUDg3QYfwy/vwbjVW2gtC+Bix9yQporq6Q6+MKPhJ8dTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7986
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 13, 2023 11:14 PM
>=20
> +/*
> + * cdev open op. device access via the fd opened by this function
> + * is blocked until .open_device() is called successfully during
> + * BIND_IOMMUFD.
> + */

remove "cdev open op"

> +int vfio_device_fops_open(struct inode *inode, struct file *filep)

vfio_device_fops_cdev_open()

>=20
> +static int vfio_device_add(struct vfio_device *device)
> +{
> +	int ret;
> +
> +	if (IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV))
> +		ret =3D cdev_device_add(&device->cdev, &device->device);
> +	else
> +		ret =3D device_add(&device->device);
> +	return ret;
> +}
> +
> +static void vfio_device_del(struct vfio_device *device)
> +{
> +	if (IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV))
> +		cdev_device_del(&device->cdev, &device->device);
> +	else
> +		device_del(&device->device);
> +}
> +

move to header file and have CONFIG_VFIO_DEVICE_CDEV
wrapping vfio_device_add/del() directly.
