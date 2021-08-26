Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6A73F800E
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 03:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbhHZBxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 21:53:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:15724 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235823AbhHZBxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 21:53:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="214522460"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="214522460"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 18:52:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="494838105"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 25 Aug 2021 18:52:20 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 18:52:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 25 Aug 2021 18:52:19 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 18:52:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVZT5XDjI8cTixhscbyBR4jqyxBFNWTq7PiAXACIG/RhYBKxBjns/a4fE4s3fwbTjBfHusMPJTnZNB5pcKI72qVbU3o111BWgyDR1zMyBPB4xQuTPX/vUc8vnpGuKoggAiP+99n7PbwGvNQAVexElG6KFTMiplrUmVnL43j7ioxW2ApVpnQE553pgMV/5DzVD6UzjBtWMLT0r8i0cGVz7x+IV7udPfDqPBBTahO9YfRtagzlYmwoz0j+yhkqUROpaFOvkFeih9wznmjl6it9ZGq1f+VbeCNDUITv5wM2+sJw2cnNa8oX93LvORvb2QvuIwt8LW5n9ET9pH77Vo7UHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uN0o/6RYoLFbSi9v2pWukLxdHql6lV98xrCRiHoU3NQ=;
 b=dO1ZQeLJwc+O5PiUicLZ7ySyp73DPGYLzFL2mlOf9UnwGhkR6ec8w86nWEANOxqsP6A6gAdwBDDBfUzh0Cb1UUWZrWdKYku6EYtgwAB2+8V2VbhapRbkUtmR2gEqARI24DDh9/IqCANe4a5ZBD0+/DkKeEqM2JGgFZqCab73dR05UMDtFoIpZ29LK2Mg/oX7zOHEBpJw5X7hp3ouVlIyf5ZZviGd/GASJyNEovdU5fjx+SNPlsW2gS22gleH3tQLx49wSDWwNBl3hTm2D0iJEn05txE1HPxuR2K1s41cQhMbKygrDGyarimlLFE2DQ3+q61nsJpJ7CdjcLc64UNSDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uN0o/6RYoLFbSi9v2pWukLxdHql6lV98xrCRiHoU3NQ=;
 b=PQYAPy1hb094cvJmwTHsAeKT/l4tlQPcxKfWSChwNmLtbF/Sj99oepAUYY13+6Daseh+w1ff/03qmfxto4fhsy0f6AF4n4gph1AGkss30fVRNEs+RZlkR0vPxDcgO87XHFod/D9KyFtIaPgBgG870odD5BEEXI5yktYUkQufWlQ=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 01:52:13 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 01:52:13 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 03/14] vfio: remove the iommudata check in
 vfio_noiommu_attach_group
Thread-Topic: [PATCH 03/14] vfio: remove the iommudata check in
 vfio_noiommu_attach_group
Thread-Index: AQHXmc4cqTHkK5XKsEaIrfMTgKWOaKuFBbqg
Date:   Thu, 26 Aug 2021 01:52:13 +0000
Message-ID: <BN9PR11MB5433C79BCC88F6E477EB14C38CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-4-hch@lst.de>
In-Reply-To: <20210825161916.50393-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85aec15d-a1fd-4e9a-c6c7-08d968341fed
x-ms-traffictypediagnostic: BN8PR11MB3762:
x-microsoft-antispam-prvs: <BN8PR11MB376271797FF30FF10002CBE98CC79@BN8PR11MB3762.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kfjI5hgspUgUdRf4IMtV79VyRfgKuPvbNxMdDwfpmCDuKyhFhY+UDfjbEA/X1hVHiqKwt0mklrUJQ87Pd9jCEOVFcBAKt2Vv/19MmZN2D3XX1U7yPZq3phoSXuC0xjZEDPqTT0a7NUfivrK2EpewwupRGQ1jWn2BohE+yeh0u9FMU9hifnSawfZzVAu0ICxaRngMw8FjN7JFRvLo267G8KyIclWvXb6zCW7y/TFILpNVJnUCxsq8LQifBgzy3OHTkaYQh02jMnCBLTMd3zM4xWhw5kzfE4T45YErR3kMa6/z9muMuZm85+PeOz0OidVdi1cnhZpzBaqCk+q8o6Pk2VInYELFXrfAZAFfiKoRaeJQDZGuZX9hRncIoREIk3F+yAear4eUmcZ4kV3qBqIQb1K6o7O1QO7JyF3Y4LaLqM/DK33Eb7uUgdUkWZK+HErtwkpUt4P61E4IuaXHFV0RJ9EXPs0tDqw1FzfnIr2IXaYjXKvnL73mvfhIIU9MplH526xxBZs+ZZUcqB4kx7WlrGEmc2EoZU6XVzPRgDcDCd5BsOW11X02PP9iPRbJrdjEAvlOrgX8aU9Hwp7J6Atk3cx2TOaGJkrHFWEsvu6RtIug8/ymH+sYV1NkLljlxaBnk6tRXWShdRNudgTTWQihUnF+ZOffQplF2p0iAU4P1cA937eu1Gg0ktSGk6hUX0hQVv32sS/Zuh9mRCi7h+OwTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(186003)(38100700002)(86362001)(478600001)(38070700005)(6506007)(4326008)(26005)(122000001)(71200400001)(83380400001)(8936002)(2906002)(55016002)(9686003)(316002)(66446008)(76116006)(66556008)(66476007)(52536014)(66946007)(33656002)(110136005)(54906003)(7696005)(64756008)(5660300002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B6OPI7gUhHzGEQyeTcPwSWQhJGJcrO0H/SbOj+4gKTAXOGUBln9Z7eqLIKOX?=
 =?us-ascii?Q?MJTBLNaMX+oRNxHqIJLIKUbMAjYcnM9Ywy+QyX5J/8FUJ5YBHj+dhSARX3Qr?=
 =?us-ascii?Q?LRPdVbS1/h1RrvgjbASO030z1DHgaSuMC3OMEzGYUfUZzCu7x9BLZ01XaaNz?=
 =?us-ascii?Q?izXqN+pGIwjs6Yav74kqrZ0wEOoVjwHw4uGVwNFsK5OILt+lizJX0yqDPB1u?=
 =?us-ascii?Q?i5qkeV9UnVMoKkmxjNTBXuQa38wz4d6PXzD54MIt8nNrLifeNerfC9h2WqtQ?=
 =?us-ascii?Q?Vgz+vT+iT33/Ske3d68eNK1kJw19/Ii1il30plAmtxfgH9PoCHa8yYK3R8Gd?=
 =?us-ascii?Q?ID6VLtxYJfM+DLP9jTTKy0OaSLSH/yeMAkrPasxnFN4nAgGf7nc/YrvkGG4w?=
 =?us-ascii?Q?I5hGYv3ExqwBcDC+hm72K7jUrXRRE9C7q1ghNqyDbJmtzGPStCozvx6YtgaZ?=
 =?us-ascii?Q?jorauNNWmiuyJfTndjCd5htIVQyv3sRMHe4aOfl4uBzins3Xo6Bn2YnQIUed?=
 =?us-ascii?Q?du4hT6hl7Z+YRlWf0654k0WbOtVUXEr11TTk4FYXPyUoV9GcPQrMfP0i9TDm?=
 =?us-ascii?Q?PL5ZR45Lsq/UkxumopBu9u6sX6V55Yg3zlMuaPngjF5ZDZI4g75JO4UIMf6S?=
 =?us-ascii?Q?DizlC1Gbjq+zDRPPcPJ9MgDxUxv0DXCRWfF76pX20semLNOSRiXoJClnZQVA?=
 =?us-ascii?Q?ZHyrYKu+MGNfYor+fLfatHT19huaPlUnZg5v4iS1PQXebYkY50fvMGocouKq?=
 =?us-ascii?Q?YQTQQ2nQTVIP68d65w+xGe6SFPcyMoISYF6MJRhmkrlpkZ94Zq2rOAADkFsl?=
 =?us-ascii?Q?uySsTvh+9VhmANfaN6ZFuoPk0VAyk1NvkKYDh8XWA/VsyW2zl5Mz9L/aGCEM?=
 =?us-ascii?Q?Zaj6aG7N6xXovej+5TPrf82HgYrt5DsoTQ0NnIqmu/mlgROLqe7esJXIGIAp?=
 =?us-ascii?Q?2zqRTUNW8DFvQ7XBaX1OgFChzHOY+q+YrDP7e7F/E+KluxbPHxY2jRrl3gGf?=
 =?us-ascii?Q?K/buJolW6S7qYadudhpBqVYEf4Ceg7h6S1Pyb8X0AmX50w8v4Wopqi0DM/RF?=
 =?us-ascii?Q?6IDoybmDCotbU/Qf6+yz6JTHLP9CokJSQAlwz5Tz4vBkj9PTrfZ6PsjSYRqq?=
 =?us-ascii?Q?cCZa2G/7XvUDE1X1lQgyUzCBLmL5UFiyoIoBgm8AZlv45q1j+nnruuTdkvDv?=
 =?us-ascii?Q?knSdbx1XToTCGRbkbJLKvsrfQH9lcFtIySzDqTOVaUWQ1Gee+RMebQRM/7rz?=
 =?us-ascii?Q?nSyc78tY+Ut5nvlbzaTnggfBqExZt0YoNFWXqxKIVECG+mCqafxntAUklIjA?=
 =?us-ascii?Q?FauGnUqQ/T6AQ4uERpX1ERKb?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85aec15d-a1fd-4e9a-c6c7-08d968341fed
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 01:52:13.1685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: igPPKEE48olOI8OedJfh3yRX240T26FZDEYq+OXtK6GijyRb4Co3qPc4Ljy1P44SctaZzfWgUhpiDAjrfdXxlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3762
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
> vfio_noiommu_attach_group has two callers:
>=20
>  1) __vfio_container_attach_groups is called by vfio_ioctl_set_iommu,
>     which just called vfio_iommu_driver_allowed
>  2) vfio_group_set_container requires already checks ->noiommu on the
>     vfio_group, which is propagated from the iommudata in
>     vfio_create_group
>=20
> so this check is entirely superflous and can be removed.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 6705349ed93378..00aeef5bb29abd 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -250,7 +250,7 @@ static long vfio_noiommu_ioctl(void *iommu_data,
>  static int vfio_noiommu_attach_group(void *iommu_data,
>  				     struct iommu_group *iommu_group)
>  {
> -	return iommu_group_get_iommudata(iommu_group) =3D=3D
> &noiommu ? 0 : -EINVAL;
> +	return 0;
>  }
>=20
>  static void vfio_noiommu_detach_group(void *iommu_data,
> --
> 2.30.2

