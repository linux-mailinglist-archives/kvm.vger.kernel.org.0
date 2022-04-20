Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74645093BC
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 01:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383278AbiDTXwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 19:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243537AbiDTXwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 19:52:04 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761583A739
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 16:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650498557; x=1682034557;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MNH7vKqfqFn/pYrmYMD0DC7QeC2aczbzAk0TsTlIfBo=;
  b=feBThfRhnyILgxRP3TULvnC4/JvXRmtZH0IQgDmq+It82wpwWH2ZsTb+
   T9Zf25UsOZ45Yp6Qhowv84iC90DJfakQh7Tiq0lLtGyXFHt4w657G8hBU
   Cx0ENCdQBt578itEII2AIGu3PSEV65HAZsKc87rUw1lc2tWJ7hUt0u6EO
   27j6+j9JfbfbQ4cYts+m7mtW41ppKVdZXdw0P5J4HpvhPFxeo3MG/8DR5
   pHZAy6HymMUnZA8IdLutCGFrFIcO9CZr3quDn8PVfAlZL3FBHijJYC88Q
   8PyDZ4o6WPG9WgdepunGGkmjO+3BBcYmJ2gRkSNbFcKzJN6mppi2tBMd9
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="261782941"
X-IronPort-AV: E=Sophos;i="5.90,277,1643702400"; 
   d="scan'208";a="261782941"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 16:49:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,277,1643702400"; 
   d="scan'208";a="864665945"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga005.fm.intel.com with ESMTP; 20 Apr 2022 16:49:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 20 Apr 2022 16:49:15 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 20 Apr 2022 16:49:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 20 Apr 2022 16:49:15 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 20 Apr 2022 16:49:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyfuauj+G5xzdMiknE8w//iEJAbdCEZRmlFLaxU4wLzInOQWuTt7gYlmGnyjnnmj+WjdFkeLxQPGGytpZHlguJhnRd6TRFQATRlmrEF5XFWZzjZA0yg3O3im2YzR30Tviqrxho1IqOLdoR7RKj2BC2WlrBY2IuAsCLH5xt6Jmx3h433Ua0RYVvOFv/uJKGGMNsko+GKzdC0k5tKDgU8PXDunYWatArvkL+VSDgyy6WyYKOPPIulAzp+NYbr5FhXAhtJFIANuG81n/jGsGrTuOSZJ00V8It+f0EBZ7k89AvYnIycdG8dTm8NcWWoMmsv33KPgYbTF30C+Ry4vh368oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQBbmlOVgOe8ovZ2XUdN0ZTi5IFCDC4EMhXrjwsLtSg=;
 b=GT83aIhoitsqfKBXNKoBCJ0EM+7ggZeyfIpNLA1HsXrHnReXsAUWYv96QfAnwHqs5zOntfVTX7CV+8tk7iqePqVcXTXExoMvIsFfqKfXvxW+7aIf17XL8z0bU97cSqEePzHB77HrINqFh/eM8diHfFTaCll5bDMnLpMTseDgOqqcBZXH+1NlzRznE4e8J6M9ujX6eCj3n0hDqO56AccZB/WQ7Z5GLnIN+M0G8A4H/duotC9rQqP1ZPfNtmN6t/uUfIllq293n/6RK0V4O0iBzh3XBP+ybKRAltEN1HcRqC7kNSQE77EXmP0JGJsStP5kGKEPPn6dcry37+GBByOp3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by SN6PR11MB2752.namprd11.prod.outlook.com (2603:10b6:805:59::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 23:49:12 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3114:d1ec:335e:d303]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3114:d1ec:335e:d303%3]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 23:49:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 5/8] vfio: Change vfio_external_check_extension() to
 vfio_file_enforced_coherent()
Thread-Topic: [PATCH v2 5/8] vfio: Change vfio_external_check_extension() to
 vfio_file_enforced_coherent()
Thread-Index: AQHYVOwc8QHMMV75gUKPqgPshj3xIaz5dirw
Date:   Wed, 20 Apr 2022 23:49:12 +0000
Message-ID: <BL1PR11MB5271FB79EB608D2A221BD5D78CF59@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <5-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <5-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43806b72-99a5-4960-f4a2-08da23285f14
x-ms-traffictypediagnostic: SN6PR11MB2752:EE_
x-microsoft-antispam-prvs: <SN6PR11MB2752C57694D2BB9A5E498A1D8CF59@SN6PR11MB2752.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hr41kLBfIaLgAqz4Kk5ODLSkD4LkwxI5D1qaviVzSSmvDNbaZ2W0aoJud0ABfOqx/iUoyu0RKyZXoY+CNSWpsinQsD6rARNat2mOLDEeTeVnqsLjtR4JAhVY4DzVP4qyVW+MKIOWM8wxEuUY8onDXm0t/6UVOkcwfOrYqabctXAlbqiFx3l1TzAorUaJ2cyvAGzcGUcZmrMoypogJ3JUxQ4dCwrNVhb6bWCD5QJ8u4KvzHVaeCYYBqnDoE8YudgbYbUF1qDTTrJ5S59su6THnYAf8e0YLzbRDq6MtcWbB0DDiJgYeBADHN8uBhgkZxSYAytbTtaa0y7WvsOOqyuz0u4XLl9YERIvhyZ0TPp6XBzPqUBRGg5z8cU+nH++U1dt+8IsNdpUemXZ0HL0/joQmw0Wja7uW1MMtOfqSnmdQmpI5XNsmPybCBOojiiaa6XCnbhuLi9xGYES9vFDVqLSYz5H/QDucuHote0PIGO9f/PlP+JQKTf06wTbnoy79C5K1YPydEVTLORiUdFxG3L7vpyi3AM9cHihh0kDWnIzERamZWNGrOVL2ByuOOqU4rDYjLAUEkQ7kJYJ2iexksBgiYIVi77EPfcOD6zjQc/Fet5CzH1swP8g9M9LsrjBew/+bujs/Htj8pv5FxenCelk65a16t2dD+bp1b1SM+bLMeChSIWgwYN2zJKu/Y3sYlAgv5lSqqxUChTQct4PBPHmIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(83380400001)(55016003)(110136005)(8936002)(2906002)(76116006)(54906003)(52536014)(33656002)(316002)(66446008)(66946007)(66556008)(66476007)(5660300002)(64756008)(26005)(38100700002)(38070700005)(71200400001)(4326008)(6506007)(82960400001)(8676002)(7696005)(107886003)(9686003)(122000001)(186003)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?os9/eqZGZbGiCQmKekDk4E7ayoMTVwDYK1j4nbiPvEfL9nIIOKVFZ68pmD9u?=
 =?us-ascii?Q?m3MlQV2h7Y3rl8z2yRph791P7+uvf7bJbTDwqUWVy2eo7RDZNktKAQK7bTQW?=
 =?us-ascii?Q?SiXHG1o247DL2Yx7m0Q3mJj/cJxTzVoOjHs3wAm/JK5afFAL20yaIq1AD49C?=
 =?us-ascii?Q?ymBCwaYTNpZl6LqEWUo1mG/5ArWby5khvcS7OzwiaqPf+CQZAzd6HiRZnFbe?=
 =?us-ascii?Q?R4jNWFP85vGj7t9dEfwqkXCRf/974jJSmXPedr1f6leFt8grOebYVLXEXUsd?=
 =?us-ascii?Q?Kag4fOdubKiXS9F84oRdTbYvYEFJNuPXFXol/lunkzkwwKuW4giOG3dsEhdo?=
 =?us-ascii?Q?CpXi9Hcu+A6UaCYC6nEjsmYzugf0hS6dQzzCDxp4c4+P+tqzLy7RrTcGVj2c?=
 =?us-ascii?Q?8fEQkT38kmmXScT54P51ZODwcdcegzjcE/Ihn0xgdfRo13rzs1jSfNEUtJv+?=
 =?us-ascii?Q?6puaB1nfbk9b7ZaavOVAwRJaHf+Yk7JaeexLb6lZ6wKVo4uXtnaBbPWrFsCg?=
 =?us-ascii?Q?3yV4+0GIH6/ROxfZwTRIgzwkT3GUz88uNlUaK1le5H797ftNIEv9sXq850x1?=
 =?us-ascii?Q?aq8pCuTCQKc8PUa8vn/5ZuQG2s+3bGrNhPbwfaeQxcspXKsCHCv6FxXiczTz?=
 =?us-ascii?Q?JT3yrIiK2Cd0VoAT24SiQ8REpKx4rEtLCAMwh23OYljYOXSDINuedb/YMtzq?=
 =?us-ascii?Q?PVURAml4pCdMrod3UCw0K03Xo+Yv9Afb8XO24oTzpYMQLK5fR9ZOmF9elMjM?=
 =?us-ascii?Q?MXM+L19lMx3h0kGJ4Syvhjzx/0A/V8kh1khltMpVk87D/AfL2HqRGJuB56Kz?=
 =?us-ascii?Q?F5KzuIps0V+iQNbkvbt998jEiaPDW0LbESMrA1S+QwMNwQCQ95bGeS8Caj6w?=
 =?us-ascii?Q?iVHr7AJwkr71dObR92uh8D11LPLxyytPGx10Yr2/ang8UsfOe2LGuDsWpj/4?=
 =?us-ascii?Q?JXecuhx1tZlBdRbZhp3DTuGe9ZDgehJK2dfYw7M+qE3CMaPVpwn7M2aJ45dD?=
 =?us-ascii?Q?mjlczGzsmhRXotvKr3dplUD+XT5fSp9SfQquP+ws1Dya+HlhlnsLRJ9z41ww?=
 =?us-ascii?Q?FF1wYnm00wWZxzqt6s0a9VCnSTmJm1QGpfDZVuZmvgpxoXpeXhojXOqahW01?=
 =?us-ascii?Q?jodVX2W5+Q1NzhyziZTZ7glKdxlJysV2miyypHG7edwfI7irW5O/Gl1CA/AV?=
 =?us-ascii?Q?XVW1RUfqYQMEStHrgmAittxyDhiHbqLaDkfPmS3oTEDO7RGH/VmOLBHjAYbj?=
 =?us-ascii?Q?tmjwMZjXx3FLK0Y/LKwXGe4Izte0vX3CANi0InmwlMJbjsfXuGm9qivamZCy?=
 =?us-ascii?Q?evTaBp+ptHxVMA92IdVuY5QjAxy7FttHuzIwy9L/vReNQHBR07SMxkByVRi5?=
 =?us-ascii?Q?4BBinLUVtuvjEf1xWSLDFz8yN+Q5X54QS4sAxecWBT7IDs5d+35V92vYw+dZ?=
 =?us-ascii?Q?T6412eSGxkx+bnxpSfaOYVsQsDUvcjuCS5zH9+cfjXk2gmNP76PPEvuVbgqO?=
 =?us-ascii?Q?US6l5ziI0l+g/HXVW6grKzRoN2SPUwgQ7j5rVF0+3SZFHxj3HYCmxKSXBEHO?=
 =?us-ascii?Q?6nsdcJRcm0t0GRMQDFKlBoZ4hZ68/0AcnUmyaP7POD9w+seUVsyMS2V+Fh6C?=
 =?us-ascii?Q?Ruz+DMNvW0oaoB86ge6v6JOp2J1ePa+y7pT+VxTvx9ZHJRLVzet+xCNrdzuR?=
 =?us-ascii?Q?/Jud6T5kljXzQSS4+cREgraD+qN6fWtUh/HXoI1Dmz1dYhp2iWUxN9kG0GtE?=
 =?us-ascii?Q?PvTkOY5ijA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43806b72-99a5-4960-f4a2-08da23285f14
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 23:49:12.6906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oomOEJrhvPdVg5bdJkTbR2Z0WwYGPtQDfObBSFYrigGLoOyEzjiVfiJXaTjdLklfcbdpH6FnZg6YOI4TV95v/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2752
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, April 21, 2022 3:23 AM
>=20
> Instead of a general extension check change the function into a limited
> test if the iommu_domain has enforced coherency, which is the only thing
> kvm needs to query.
>=20
> Make the new op self contained by properly refcounting the container
> before touching it.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c  | 30 +++++++++++++++++++++++++++---
>  include/linux/vfio.h |  3 +--
>  virt/kvm/vfio.c      | 16 ++++++++--------
>  3 files changed, 36 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index c9122c84583aa1..ae3e802991edf2 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -2005,11 +2005,35 @@ struct iommu_group
> *vfio_file_iommu_group(struct file *file)
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
>=20
> -long vfio_external_check_extension(struct vfio_group *group, unsigned lo=
ng
> arg)
> +/**
> + * vfio_file_enforced_coherent - True if the DMA associated with the VFI=
O
> file
> + *        is always CPU cache coherent
> + * @file: VFIO group file
> + *
> + * Enforced coherency means that the IOMMU ignores things like the PCIe
> no-snoop
> + * bit in DMA transactions. A return of false indicates that the user ha=
s
> + * rights to access additional instructions such as wbinvd on x86.
> + */
> +bool vfio_file_enforced_coherent(struct file *file)
>  {
> -	return vfio_ioctl_check_extension(group->container, arg);
> +	struct vfio_group *group =3D file->private_data;
> +	bool ret;
> +
> +	if (file->f_op !=3D &vfio_group_fops)
> +		return true;
> +
> +	/*
> +	 * Since the coherency state is determined only once a container is
> +	 * attached the user must do so before they can prove they have
> +	 * permission.
> +	 */
> +	if (vfio_group_add_container_user(group))
> +		return true;

IMHO I still think returning an error here is better for 'user must
do so' than telling inaccurate info and leading to a situation=20
where lacking of wbinvd may incur various cache problem which
is hard to debug. Yes, it's user's own problem but having a place
to capture this problem early is still a nice thing to do.

> +	ret =3D vfio_ioctl_check_extension(group->container,
> VFIO_DMA_CC_IOMMU);
> +	vfio_group_try_dissolve_container(group);
> +	return ret;
>  }
> -EXPORT_SYMBOL_GPL(vfio_external_check_extension);
> +EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>=20
>  /*
>   * Sub-module support
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 132cf3e7cda8db..7f022ae126a392 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -143,8 +143,7 @@ extern void vfio_group_put_external_user(struct
> vfio_group *group);
>  extern struct vfio_group *vfio_group_get_external_user_from_dev(struct
> device
>  								*dev);
>  extern struct iommu_group *vfio_file_iommu_group(struct file *file);
> -extern long vfio_external_check_extension(struct vfio_group *group,
> -					  unsigned long arg);
> +extern bool vfio_file_enforced_coherent(struct file *file);
>=20
>  #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned
> long))
>=20
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 50193ae270faca..2330b0c272e671 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -75,20 +75,20 @@ static void kvm_vfio_group_set_kvm(struct
> vfio_group *group, struct kvm *kvm)
>  	symbol_put(vfio_group_set_kvm);
>  }
>=20
> -static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
> +static bool kvm_vfio_file_enforced_coherent(struct file *file)
>  {
> -	long (*fn)(struct vfio_group *, unsigned long);
> -	long ret;
> +	bool (*fn)(struct file *file);
> +	bool ret;
>=20
> -	fn =3D symbol_get(vfio_external_check_extension);
> +	fn =3D symbol_get(vfio_file_enforced_coherent);
>  	if (!fn)
>  		return false;
>=20
> -	ret =3D fn(vfio_group, VFIO_DMA_CC_IOMMU);
> +	ret =3D fn(file);
>=20
> -	symbol_put(vfio_external_check_extension);
> +	symbol_put(vfio_file_enforced_coherent);
>=20
> -	return ret > 0;
> +	return ret;
>  }
>=20
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
> @@ -136,7 +136,7 @@ static void kvm_vfio_update_coherency(struct
> kvm_device *dev)
>  	mutex_lock(&kv->lock);
>=20
>  	list_for_each_entry(kvg, &kv->group_list, node) {
> -		if (!kvm_vfio_group_is_coherent(kvg->vfio_group)) {
> +		if (!kvm_vfio_file_enforced_coherent(kvg->file)) {
>  			noncoherent =3D true;
>  			break;
>  		}
> --
> 2.36.0

