Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21E2674EDD
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 09:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjATIDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 03:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjATID2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 03:03:28 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3D040D6
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 00:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674201803; x=1705737803;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8hiQpiyi5F5LQH13f5e88fz15354VmyP5iFSIoYRwk4=;
  b=JQpk3Dg9zo0dZV2g6tZ5TtI6g3HaLnRHtTQ3DN8VBb1SziHUJYUY3g7i
   qQc0gUQT3N7LQE9xXh4rvnOA5pK06x9kzGYLLm7c2+oLNq91ROPgMrZ03
   3cRIQXoxatSQrK7hIkLhT0JB73wCS8udQQV/DmRI/uYlH0PQxRWcYxsNz
   Z4U90Ei/D01rxSvVkvNRrTyt5kPFXcOflMahwWyMo8pq8CQ1XPrqHmOka
   usH/o9xAbCQpb4Co6b+0Lae+QIwobDyCjinw/TjpAxDSejliVdRFZlqO/
   uIFh+CyKUwMuq4VzeWlTwntxhYd2LjyCfvdltmlsAO1LGKz2l6SahWbNi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305201959"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="305201959"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 00:03:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692785052"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="692785052"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 20 Jan 2023 00:03:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 00:03:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 00:03:22 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 00:03:22 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 20 Jan 2023 00:03:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEhUJm/e/9z0/2RWiWr43NpNO62gRX9QIxcq5qdj124LG6JEKOE2p15GJKuwDVnlXgrUo3YJRDACBSP6Z0bNLjyWgueFTiv7gn+v5w3rY1VCPyaNLY/Y55KnPSfiptLh5/LgjQeNxFceOfu792yf8i2UHQg0rrjuCbA0kBN5GeyIYMONkP+a3oTQVCwCLOa7NMij8Ni/9jW7eIvWQTa/xCfZxlVOXK1bMb8aYmpIBJ34S3QKFwZG8nrf+nS5SSGH9FLP3kUoGM1lBLxsJsPdGtTZb+ezGi8Wn2or3VJs5I8vg87wNe5cJgcWzmRhrvGck+MaszZJ5IOb2kUFooIsRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60lWR+BfFFdANXHpFHFLYXfRCAwBI+R0N1WMIOJiq6Y=;
 b=nK/ufpu+w4+rl9vcP5pyWjMqp+gx7OuV9yCm3r6Tmv9J4B1u5GBDUC3IhVBu/TT5ykUYuPf/VcbR9B6fbuEUYd39gSb8P70ONo8lR5S6PhjjKL9FawH+pA8M8sYarjYNnn8ZIgzSYBy63kaeuptiG8ORljDeoQOdLbPMQTc55PRd+sacqW2DDLx/zp3hYIaMO0v9BRwgTb+Ek5VXxtuFtEpmrA2VoPcKIhpxA65X+r2fkGPn2azaEQu/gYk3fN6p/goJa5vrs7UfTEpd/KwDkULfAXDEfbmymzy7FRidH5TUdOw90rbmFo/a5LJDZ9N+/7wAoby+cRSYyCs4b5QQMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB7703.namprd11.prod.outlook.com (2603:10b6:a03:4e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Fri, 20 Jan
 2023 08:03:19 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6002.025; Fri, 20 Jan 2023
 08:03:19 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 12/13] vfio: Add ioctls for device cdev iommufd
Thread-Topic: [PATCH 12/13] vfio: Add ioctls for device cdev iommufd
Thread-Index: AQHZKnqcdx7eOsm1NkmNAiFwdJw9yK6m85Uw
Date:   Fri, 20 Jan 2023 08:03:18 +0000
Message-ID: <BN9PR11MB527653190DB88471BD39FD978CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-13-yi.l.liu@intel.com>
In-Reply-To: <20230117134942.101112-13-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB7703:EE_
x-ms-office365-filtering-correlation-id: 3d0031ab-bee5-47bb-019e-08dafabccac8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p+CygBZn034otRHeZAXWnXbORWRtzUjxi7QLB5VJvjANjEjEUaQfaQwNKRqMfsTBPv4Wv8VPMmu6SyFWSIa4MokZrQVnEYLVKlkmMrbkiS+uyXgety6UsWlIMaTNN4tCUfsuYwyFQ4ce5QT4ZHds/ov2NEtnukIHqQD1I6Co7RuyARFzqY+rcGL4iV+pEOGpzzDZO+BRpqutHY+aNkUkBilW7U2snxJu2KRyxRWlzJCHOGgJqxfYa7P4IfRyv/bl3djKpspUUbzODvF5HbA6yMPJbywiFNdnu9NmVKd97h2XGJ2J/+E68AdDMp4oFCg7RMap4h+smNqBhoz4cuN5M3211NwRru1cZlx3o8mzyNDZIgcOz1jcvdathZq520UIN136+GdtHvR8sa7IWEC/X81T04y7WudQP9KywE/TVDw9lcjyRC/kg9WPyCwn/J7gv9hiNFNti+0Pw6fnNCuFUoCG9OTVPMCCb1lnTL785DYVJ0SA2wOkpozvJVxUxdQ+TXEQr3bPaaRGB2lkmi7j5qDdEQaP8fmvGyy4jKarL3qagnipx4J1588ZlI30wRtGI3peJ+djDBx1c+ej4ddRsNMXD7wtlFpSqVQooi6jPCcboFnq1cevJEsy4Qxwi4x94kCUFzQRCtfpgSF5BzKQdZqppKLUoOGQO5TlwKVLW8Pw3OfjswQxGgn/Z7jH+b3ajt2cFemh0G+3+EHNu7hXjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199015)(38070700005)(6506007)(478600001)(71200400001)(7696005)(26005)(9686003)(186003)(316002)(110136005)(54906003)(64756008)(8676002)(66476007)(76116006)(66946007)(66446008)(4326008)(66556008)(86362001)(41300700001)(38100700002)(33656002)(5660300002)(7416002)(52536014)(8936002)(122000001)(82960400001)(55016003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/nq94cCkk2jp5Qn33qYuDwERRidC+o0tIIsgRAHPbbe+PkFGW4+q0FUNgoq+?=
 =?us-ascii?Q?F143+jzkuv9ldTgPCZKxrT1kQOzXmrHU9g1OczWChp2q1z1JlRe+YiddAYxH?=
 =?us-ascii?Q?tOcaifOkyu7ET2BOJ05rEw6oMl1YigcvOxE7sM5DK8gsQEjLKE/wrrr3lYHY?=
 =?us-ascii?Q?u3YMCrHCYrU2aTu626rI7/eAW7hH7Zv7FUq6Ic8NFKx48uI3WQwJC5mFk0mm?=
 =?us-ascii?Q?8wn0sPe9Dfo4trd1R8S+JithXQYtM7UaUR0sZ+fy4vQM8ZZIqosK4aVL4wGw?=
 =?us-ascii?Q?u5lhGvDbBTC1nKB7PGOVjSF1tKkQ19FKp+GD8m/E4aU/G74BxW+t3LU9Yusz?=
 =?us-ascii?Q?eXkYoBbBm99N1bKfpLGnawQWJX6d7J3VmuP4CBtzG5YhTyWlXkic2u/wD7Cz?=
 =?us-ascii?Q?V37QT0Fcit+RVuQfezb8BPbFqneLkaGelLzS7ZMAJ57xyjxsy1rT5rNXpIup?=
 =?us-ascii?Q?kDfjW38i4N13bdguH9Xj2mkZHOGtp51l6yy2bGNEI93/oY0Tc0wMPgjeEqab?=
 =?us-ascii?Q?YwgqnwaLqJL4b4Rk2vSNyRsX5meWCo1YF0d1FDh0QOECC8UiGOgJDiRJnqBH?=
 =?us-ascii?Q?MQVZO1iBDWIcb45oivRQhga+tU2SWdvCVWFIU0lAGJ4xTlEEuHWRo+vvv953?=
 =?us-ascii?Q?iFZJu50vjxiSGB7OaZqLf7HxJhbEQLFzd4/9BheFLFKFTfa8ftxSUMFxjhPw?=
 =?us-ascii?Q?X8Ckite2qdlOujwPRt5Rv5BN9maZsQ8sG2dMBQ19Eu9dtV/aPviivqKQcNQx?=
 =?us-ascii?Q?tb7r3l6oAk5i+kPPxmmfNKQKnKyJFMV3L57rd79q1z+suXld35kszVeDsTao?=
 =?us-ascii?Q?8Ym359I8olXbj3ET/oLN2SO26ixBeyL0FXXpl4+VzV46eyPHOMBUYD+8PrSj?=
 =?us-ascii?Q?FkemlEkU6WGh6Dkl58MPdLUw3DPsOoPDbjjiH6vj6wVJXqyf2hF561Z+i2yK?=
 =?us-ascii?Q?/5V4RGK5/nUKCDOo1W2+3zArGr8CY64D8ZjyezUNsIlb9w4TKziMl2Co35A5?=
 =?us-ascii?Q?FGk1TDRIDD4Vg+mCT0fQPN/fzXchnljKKPcwv56Ud694MskCFpt2YdioX8O8?=
 =?us-ascii?Q?AShrp6oFCwGcy1pTs2ZD81nwzcnlVKWYbGwNkc4UOlwD087YsSUYO9kQHSZD?=
 =?us-ascii?Q?v7oQ0QwTsLt3LfAsCExrF6kHGujKMtBSK2VNIGTMXbPJQWagr0g2POa17Fnx?=
 =?us-ascii?Q?qOoCqCG3CNxgBEpl90hXkkgWWe2+2yWywxDAVi2+0b3SyauN6/aYJrL9x82+?=
 =?us-ascii?Q?7SiVIHIJX0OHQhMhsrhEhIS9YsUUw1O0OTGMCilsKtj/pcIdHUoh9vQ+rvhA?=
 =?us-ascii?Q?rMXHFX+W2L1B0BnYoDM+587d6QAFRCNItWlJjA8c6w8OZN82s+O8TKg3qgBs?=
 =?us-ascii?Q?C7EOUyZrYFsX7U4LidzHi1L3ThHPxbaRrSzFONLPb/CtxKx4SH7xgPM4bH7Y?=
 =?us-ascii?Q?AAuQHuFrRLVYtkIO84OoeVQvnuBn54dNDbBMvq/ll9RjavdX649v4o14EChL?=
 =?us-ascii?Q?GlNgI7o3tF7KC6BKykTdRolzZg+dNq+SNUu8V+gqZRleEuLOH/9G+U4kHkzg?=
 =?us-ascii?Q?WG4EcC4bUWg9klbQ9RDIPNgaQOYhyejcyWXMcDjA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d0031ab-bee5-47bb-019e-08dafabccac8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 08:03:18.8934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XzJNkgoagsjZwCt1qSEJIy9XWqV2fQcfa2DjrVF7v+8ZlGJtJEIgigfyCipfI6hUB5EbV4yafeiE4qq59YpHYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7703
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, January 17, 2023 9:50 PM
>=20
> This adds two vfio device ioctls for userspace using iommufd on vfio
> devices.
>=20
>     VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain
> DMA
> 			      control provided by the iommufd. VFIO no
> 			      iommu is indicated by passing a minus
> 			      fd value.

Can't this be a flag bit for better readability than using a special value?

>     VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach device to ioas, page tables
> 				   managed by iommufd. Attach can be
> 				   undo by passing IOMMUFD_INVALID_ID
> 				   to kernel.

With Alex' remark we need a separate DETACH cmd now.

>=20
> +	/*
> +	 * For group path, iommufd pointer is NULL when comes into this
> +	 * helper. Its noiommu support is in container.c.
> +	 *
> +	 * For iommufd compat mode, iommufd pointer here is a valid value.
> +	 * Its noiommu support is supposed to be in vfio_iommufd_bind().
> +	 *
> +	 * For device cdev path, iommufd pointer here is a valid value for
> +	 * normal cases, but it is NULL if it's noiommu. The reason is
> +	 * that userspace uses iommufd=3D=3D-1 to indicate noiommu mode in
> this
> +	 * path. So caller of this helper will pass in a NULL iommufd
> +	 * pointer. To differentiate it from the group path which also
> +	 * passes NULL iommufd pointer in, df->noiommu is used. For cdev
> +	 * noiommu, df->noiommu would be set to mark noiommu case for
> cdev
> +	 * path.
> +	 *
> +	 * So if df->noiommu is set then this helper just goes ahead to
> +	 * open device. If not, it depends on if iommufd pointer is NULL
> +	 * to handle the group path, iommufd compat mode, normal cases in
> +	 * the cdev path.
> +	 */
>  	if (iommufd)
>  		ret =3D vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
> -	else
> +	else if (!df->noiommu)
>  		ret =3D vfio_device_group_use_iommu(device);
>  	if (ret)
>  		goto err_module_put;

Isn't 'ret' uninitialized when df->noiommu is true?

> +static int vfio_ioctl_device_attach(struct vfio_device *device,
> +				    struct vfio_device_feature __user *arg)
> +{
> +	struct vfio_device_attach_iommufd_pt attach;
> +	int ret;
> +	bool is_attach;
> +
> +	if (copy_from_user(&attach, (void __user *)arg, sizeof(attach)))
> +		return -EFAULT;
> +
> +	if (attach.flags)
> +		return -EINVAL;
> +
> +	if (!device->ops->bind_iommufd)
> +		return -ENODEV;
> +

this should fail if noiommu is true.
