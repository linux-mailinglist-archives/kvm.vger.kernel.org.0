Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5C8695CBB
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 09:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjBNISv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 03:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjBNISt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 03:18:49 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A03206B4;
        Tue, 14 Feb 2023 00:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676362728; x=1707898728;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XfC2T6YoM+Eb7pr+eZ1WMNiTPKjbkEfMoQtkIip4xHw=;
  b=DAHoION4gwCepVnUBHXNCwGeg/lEQ4vnnPNygvGaau1XQ5cq3a8fYpeY
   CxXLoKO+at63OCNVLn+rsMvG0bfHT2Ruw8Xha8yJwHtRL0B50lIoOsiYi
   lEH8hjmKwnmR3HqBlQFznes7LelJ2mRj/BOhZWr/J3WJyVidwNjQOQR6o
   P4hCp9u00FBBeHoE21IFIaWByKZ6lotdgQuYFYHLR10+h0sdFWW357h/c
   vAqtGfI80Jj9vtjFR0Vw+i2DPP8E3dgJJ+Ly3bPgdZUbMOgu/G+DEvhkh
   LzlGVhhdGHJ3W/zrCR/TNk0I7rUdkVbZuLKhZf4HJvQcJbGpvjj4oYXH6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="358519114"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="358519114"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 00:18:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="732801626"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="732801626"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2023 00:18:47 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 00:18:46 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 00:18:46 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 00:18:46 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 00:18:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhXDQPV8QnDppL46p+opybxvRtQ+SNXtXHMrQFw7JRwd//mXol50LQ9r/HOiZGtZUUDsu9ah5L0mJR21wHHldOv227YOusbA1gKBUJ3MMSet6ieQxWeWP/YGNvEhvzE5x/pWiD/o69IQtyydERzh2pirCnaUob2zvGRqvqqTW92275vc+DxiDZyuT/IkEUQUqHqdO4eWHDf1piq0EiARsDIJh09qLEniJ8d+z46DX6TimBjit86tfkkaD7aZcZ5EdOk6CzDw60XqjpJoMMd2LJLIgB4bqdTyAj1g5FlNWg2FqJC0oMOExHeR3krbQVQZlCOJltOr8rU7aMwFI9dpfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hNgtBE5KeZEJr/cV/FUlBHSU9xIrTZRjEniUT2839cw=;
 b=MNzmxJljEny3ZRU0ut66Uri4R9VNod3cCBXS26HDaPzyS9EN/FnP54uZ5WAMWpx2d27pS6efQ0YcZmRXxgBlqOcX05zNJBxkqIRuDQRZ/ZA1NCN2C8B8i+zo8+5zyXySBx6tWei7rWQjPT8QW22/SoPyAd1UQeyC67bTIcZmkqcBGsAIK+qBbFA/DMJC98HXg42IcPvXsqkEI91LsUevJ8l16lzOEdTsx2hzu5RFDcChsBEuo+tMHv277DP5kRj3+ycxqdyTFvd1F54lnoXI4x7rrQ+2yExW03XUiGV0XDARGnytM2Djh0hSnhUrB9yKqogqhE6wlgPcAFHmBu4NAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7509.namprd11.prod.outlook.com (2603:10b6:806:346::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 08:18:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 08:18:43 +0000
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
Subject: RE: [PATCH v3 11/15] vfio: Add cdev_device_open_cnt to vfio_group
Thread-Topic: [PATCH v3 11/15] vfio: Add cdev_device_open_cnt to vfio_group
Thread-Index: AQHZP73SnNj5I1R/vkyXA91XWppiPa7OGjGQ
Date:   Tue, 14 Feb 2023 08:18:43 +0000
Message-ID: <BN9PR11MB5276C7C8EF1A47CC5B8955038CA29@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-12-yi.l.liu@intel.com>
In-Reply-To: <20230213151348.56451-12-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7509:EE_
x-ms-office365-filtering-correlation-id: 78266ae7-0614-43ae-38c0-08db0e641625
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v4uJw/gPPBKN2Ln6SIgvXbQte7DvFv8t0xPX1nUxf3FLucPXxagSkzh5BJ5MHNrk1R9RZyNJQ+y0xhlYaM+FNW37/PIprYZMLsz+L3BDh/8ojjzZWG+KyDuesFk/rPpl5rSt6tY30aTPJlPribVxAZ1W0c7zvef7LbdDf1bMWE8VXa7kVdtdoZkzOZlnzgA0Bh9oI1ndUUHd0pQ3qxN2zjEbSeMszzjodFY8et/UoVlm3cC9umhxcmPPNB9fiZrbMiKQ2HOL+TSZreiTB5fM0i/INDIixDg5gIO4i9LTUKbY8snwdX7up5cncGsWmY4ALbjvQIH+P60EtrhO4sB89iNdapZ71Slpo9GUKEewmhQCOS9Q3rYHvQ3u66S7VMrCb5vQ1Nj/zbE+yrUVIKl+2luGw8M8x+MX7odfduy5lnydvaj89zqQ+YkcdG0kw1TmOhJfIq6nHuhfsLFCTeagR9LCf23Is65BsIyUB7pHnZdsuhB/vgBHAhlYbf+jqxUKLw97UganqAtMqMdUgI+QVfQKsYTR1Z9lrCfwYtbR9vRpQ6m6FtLjLr6Dij1nsnKJDO4GNItzyjgr9XjSX7Ac+exXQMurQ8dw6ALcrZmxJ/1or++Pkf/gkzZyylBtDyorGm4A15lUPpAnz1IzT6pe9/EKSdZJl/ARwgRG2zqfI3MDOvQWuBv+P0JhTlJXLcwAgQoM2w4jhk+dVXfdAGd59A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199018)(41300700001)(71200400001)(33656002)(66556008)(66476007)(76116006)(64756008)(66946007)(4326008)(8676002)(122000001)(66446008)(52536014)(55016003)(26005)(6506007)(186003)(9686003)(38070700005)(2906002)(5660300002)(8936002)(7416002)(82960400001)(7696005)(54906003)(316002)(83380400001)(38100700002)(110136005)(86362001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Sz1APFM1nLl+Q518SnKxJ+2EDIHlXPlB+DzZs2fUwRcW0IP0B6NHv6trYlXZ?=
 =?us-ascii?Q?JZmrRQpB8FqVLX1fEX258OmNtJKJMD5Tn1yF3G8MU+TUN8V5q7L+GHbutVvW?=
 =?us-ascii?Q?yFb/yqxeJv5TmUom3nVxBS9O8QdVse0Yl9t1G+84qWOGv9Ik0/Tw+t64nuPE?=
 =?us-ascii?Q?KS5fNb+bgcbKJLzkKY6oKFaBMMfwwBCBP3UDPPniOKy6MIIqlTlHYZBmiZNp?=
 =?us-ascii?Q?Y7IDAoVarfVQIYM+8Opai/z2BW5+56MTGuUqqziRu8wGQ3hm6xlCmtgwhuLz?=
 =?us-ascii?Q?HV+2hZLrZbk7F8OUNeHpJTTIdd3+IWzqXMzb0l8VshHV2VmOV4dh+ISTe2yM?=
 =?us-ascii?Q?c5HEObrKfJp10J95dAHZGVVqsNSM6wvoJ7AwPlom6+IZjCYuiLp80we3AiSS?=
 =?us-ascii?Q?J4vXZSAgH4yeybD7UHNFmkSdsI+76GknDmDlog8LE4XZl572FB3uKcx3StGd?=
 =?us-ascii?Q?S5CLNVgRWIBWfL/uRp8uSt8y+EDbdV6HXa7fKHkMPsDHafCTZcV+afW6JWT1?=
 =?us-ascii?Q?shT9jSp0n/Iz2A7clpgGNqnyFM8rk2f1i3ACnFl4lvFtGq2XFSp9FwMi8JVJ?=
 =?us-ascii?Q?mvtyAKUyZECli0dDDSbJDJaTSYUXjMrI7sn3TfDjMFsDbmcA71P8yRdMDaIw?=
 =?us-ascii?Q?XKlvSi/eKFYhZ77oJ0F/Wijrlqi9tbHqHvYDZXhcbOZslkbL7RZUtYjdme0J?=
 =?us-ascii?Q?PXO7XPf59CT6Qnt0B3+10Es23CiFsZHsF+AttdKh4aPTaxrYi5JtLm4d7iED?=
 =?us-ascii?Q?k8fARSBb+4n5eIiWolpAx7TXHqoKx0Ugc7Nzb+8wUS9ZGXfwfAc8FHa0Ddxw?=
 =?us-ascii?Q?m0FslbEg57LAR69Uxhka8gso/VD840CJoAhzUxJ3US3Xh9/dI26yBXbCb/iz?=
 =?us-ascii?Q?vxaACo5D2l2siefnFeea9KGq7PBealPtmAeMN+xMKaks6ZKgq6y35jrg+Xpu?=
 =?us-ascii?Q?xYPqCblQNmsq/TIRvHS7ehkR3J+01G4fCDPddxYusSoFW/w6LHSbxUvQ1ybX?=
 =?us-ascii?Q?JBQd+IxKCGDoDHwiu4KQTBAOXSmVwaYrqrsle6g8eSkYxjNaIaEXNp+tyyyl?=
 =?us-ascii?Q?aUr5gfmpJH7nSBFNuJsZbob/+3kH1paLkXPuAACJthUB+rfUSpIUZ54N+1ad?=
 =?us-ascii?Q?RDy3CFpp/BhiXiqYR6gMEPEhWk6R6SB1yhkeMRYtH5cmLP61DvE0FcRftk+a?=
 =?us-ascii?Q?9dbQuvj07Qy5i38qG7qRCwSkwv90Io1wIXoNa61o3qCg9rvl5cM5Xd9ibqB5?=
 =?us-ascii?Q?M72GdUVTu9gNRxZwsPKKZ5TC3ruG0D1FZv671qexWPtqJXuYilHMUk5Y5KPJ?=
 =?us-ascii?Q?2GHtUQ4uPev5zgWLCI1JsScUyMfC9HzmGu5Lj6RrOVuCIU3W2I2IPxTMv5NB?=
 =?us-ascii?Q?wEhWKQMxtjApvsM2F13YqUftSNxSWTqzlN0NU5H1mVHecw0uyZAKkgfbbVGI?=
 =?us-ascii?Q?JmRaOjICTrPznQDxr8FBwXqHnGod0ZFckF3jHMQ/QfDOAafK8b9PAW7a5BOM?=
 =?us-ascii?Q?2hwCGyuswHFgvDCekiw27f20GwCem+tmAIwNIrX2hGpu2E2QiCbKNFLmk3ZQ?=
 =?us-ascii?Q?P5k7bO8smUEsFNMBh0Dudt0Dbl8w/5DVJD3W9ef2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78266ae7-0614-43ae-38c0-08db0e641625
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 08:18:43.3645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bv3e8AyNlzl4Jc1l40lSIkAEY7/Pf2JrIeaEkvfaG283eEqIeOakwe3NqmlLumZbtnYPZrLJlcqokdKsVfZZGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7509
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 13, 2023 11:14 PM
>=20
> for counting the devices that are opened via the cdev path. This count
> is increased and decreased by the cdev path. The group path checks it
> to achieve exclusion with the cdev path. With this, only one path (group
> path or cdev path) will claim DMA ownership. This avoids scenarios in
> which devices within the same group may be opened via different paths.

please move vfio_device_claim/release_group() from patch 14 into
this patch to make the exclusiveness part complete.

>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c | 5 +++++
>  drivers/vfio/vfio.h  | 1 +
>  2 files changed, 6 insertions(+)
>=20
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 9f3f6f0e4942..f3f5f4589cdd 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -403,6 +403,11 @@ static int vfio_group_fops_open(struct inode *inode,
> struct file *filep)
>  		goto out_unlock;
>  	}
>=20
> +	if (group->cdev_device_open_cnt) {
> +		ret =3D -EBUSY;
> +		goto out_unlock;
> +	}
> +
>  	/*
>  	 * Do we need multiple instances of the group open?  Seems not.
>  	 */
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 6f063e31d08a..7a77fb12bd2c 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -84,6 +84,7 @@ struct vfio_group {
>  	struct blocking_notifier_head	notifier;
>  	struct iommufd_ctx		*iommufd;
>  	spinlock_t			kvm_ref_lock;
> +	unsigned int			cdev_device_open_cnt;
>  };
>=20
>  int vfio_device_set_group(struct vfio_device *device,
> --
> 2.34.1

