Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AFC50212C
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 06:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349326AbiDOEKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 00:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238722AbiDOEKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 00:10:22 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EE2A8881
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 21:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649995675; x=1681531675;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uP4f9i6SJuH2tcn9oJRb/6Nf9vCl2j5C5zmY+zR+i/U=;
  b=g2/+/lpUAZJP5Qu2jiy07X2V+jnJ9r8u95yS6aLnX/EPQociCujZkVFP
   GOAEynvCM8TpczV5ErBdq4ORHWwq2fsIFHXP2n0Bj37RDSa/LmOBu+ae0
   KjXH2j4ef/focs2ooMcAqNZtnr4K260qJCJ3yIzNu1YMbd8/V/eDa/8ai
   lC3htrTSzVtQIChurmByVf7YcLoFkMMGW27MV2/HtqcTjWZB5kep8OQ6c
   hfmBN7J0sJmSAe69JPz3qe6K/Y4vD7tlDDWnjF300zO3fjWI/6Pcz7FGR
   M3ADNgm3YaKhIal13B/fIYwsbLy58CjiaGc3vOEaSofFeX4C+BhInM6Ed
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="325993558"
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="325993558"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 21:07:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="656249709"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga002.fm.intel.com with ESMTP; 14 Apr 2022 21:07:55 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 21:07:54 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 21:07:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Apr 2022 21:07:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Apr 2022 21:07:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRGCiUA7mn3gPN6fRA60J6IpdV2V6o+MtaFBir5p3YRD3R3Dr8NqaLbVRKyQ88v33tXNZABGVZNOGPNG560Kx7cTEsh0wT5eTp4cu15idrNjLG9dQ2opFTrLJCjFyGiQzUdXhy85wuWYJ0+otXT8RPY4bqkkNLw8Xp99A2UIQR4+G85f0WfEHWEDIfpHy7safBm9OkRnAVXgv322MXRLMgF2iVt2gkdD7Er2VU81Niu39In5Z6K/eVmr8zGkTnG/5ogG6pIUKViVxdvdncAfJB+3qL95U1zfXbDdLzYV0oISOZTvABFVZAvDuxeba/0JvX+mVKZFt0b5X4WXiZx+vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dpy9pMXYaumiMmOK9kg0AmYWmmltlYD9wJdKchHa4M=;
 b=NOZEmkIOor26wSeD+4kfiGqBXCvqTE7e3uQWzd8mTnm5g0+9N2ieH5IQzzQFCIOKeHMzWmBa2vPRGepMGKuMzjdqp4bfh4nI7ZSXG0yprsYFQghwmpDw/M+28HlLOox6reN4uAH+U7lQ791ZMfjpj2416EFkubVyhomn17ySG3ISjpkIAX3H8WbsfIFfM4/89avKhZtppkBOrhe0seIiNVQ5vFLuimrxaZYH7lVsvqTq3gwuc+EPG9cTL6RA8r9bbFIZAJP8/leJEdB2iK+Zp+AKebBXvFDsSLJTb6xPwbu6Gy3FOD8PIwW/T5/DweKOY5crzVlvgcm8rYWApf0Yog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4761.namprd11.prod.outlook.com (2603:10b6:303:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Fri, 15 Apr
 2022 04:07:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.018; Fri, 15 Apr 2022
 04:07:51 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 07/10] vfio: Move vfio_external_check_extension() to
 vfio_file_ops
Thread-Topic: [PATCH 07/10] vfio: Move vfio_external_check_extension() to
 vfio_file_ops
Thread-Index: AQHYUDAIkIUMxipe40ybaDZVxgqmQqzwWxNg
Date:   Fri, 15 Apr 2022 04:07:51 +0000
Message-ID: <BN9PR11MB52761E7F5FB90976888A24088CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <7-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <7-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77270666-892c-4a10-6361-08da1e9582b4
x-ms-traffictypediagnostic: MW3PR11MB4761:EE_
x-microsoft-antispam-prvs: <MW3PR11MB47615F2FA2B60752413666488CEE9@MW3PR11MB4761.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z3SdMRz+U17AwDUU3mmZkVukv4rgTeqaQ163gW3ESg7MwJIZrvIFmQbswyFtEfkFdN3J0WjrIqCIDpeqx27wkIYJIxanrQ/suezuOI28jLapLSrLxH2HFCqhVJ4nGP6Q3KFTJybzZQrL9I4sYU1fVhh/UBewfjGK5Lt7mMuHyoTyP04WgNVUzo7ibE+dsM1J59eiQtrxRHEZpYZeIuyBF1qqsrg38AkOTyDKNA+BktzE1cgx4dgwDqOlIuaBLyKTLVKMXUDLr3roA43wgNDv51MUuonsM1aXtdhG+RoSasSIagBy1gBzboutFVtpVrqLN2v1IBixt6qLSm6hajSHWwplaVkqqdoNezp1MwUN+6UC1I2UZdN9/FT1Z+38o9A1sfHWHeD11yuHaJtEN4Oq/UN/Zj+IhvzcC8O8jKewTUUdrmnRRbq3gJJtEyT9orbYJlYN4DgsiPUq3Vw9ValZQMyB1FZfeJ7izLWu/RwWwIMF5aK0hB73oNLV2OZtRMb7N904eWVA3SGmrnHrRSaA+sGU3MQHlr0qpbsRCTVOsQH+HJ9AFHERe6w47tWBWntE17SuykBnMiOvDsx8ImCWPzHDTYMxIqBdRx2Fz/64hXV0lhtsgOSmx/e7dWgqUx9hwjYSqTQxOpt8MwtbHxK6PVbTHdqoGzyJd2hm0AqNx3tpIg0OPYIQHiPL95H9RC4qnSSz8jFPev3Pg3E1+9Xs7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(83380400001)(8936002)(33656002)(54906003)(66446008)(66476007)(66556008)(316002)(64756008)(110136005)(71200400001)(38070700005)(66946007)(76116006)(4326008)(8676002)(86362001)(508600001)(26005)(2906002)(186003)(107886003)(52536014)(55016003)(82960400001)(38100700002)(122000001)(9686003)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P32U4YhWv1uwD3OnxK/GZDfoeQW47DLF2QChd/E7XNxTdgENSqxAxtEuyzZP?=
 =?us-ascii?Q?qHBcPNLBbGxYZQWp47r9AH35KPjOqx9DNTBZ7RSITm/7cnDPU6vkw2FAN2Sn?=
 =?us-ascii?Q?Xmn4jJ2oMWU53grwGv9eSTtK2oUkPA/aXK9UVUgszQPUAGpm65etgXy73PZ3?=
 =?us-ascii?Q?hXhz6QpFvZ2M8CEZPgraQMKSOqO3qM78K9WFLw67XVYXszIGbOzmfpHTKnZf?=
 =?us-ascii?Q?h6Zd9cdTIrdJZz6s/rxern29iuuSJUFxZvJbnCl8TOJHT+Krqt6OqSJ0wboi?=
 =?us-ascii?Q?emi6w8oNS4MbB3o7rilu+2gz6RqhhM4QWPDvjsgYJJFFCeruC5meDJHRzet5?=
 =?us-ascii?Q?Mls6q/xv4qDNOv4CgmKHtTmUH748G0t+mfLi8ZyuzAybfQfV8wNEb6G3v8FD?=
 =?us-ascii?Q?PeF4eYQEcJxobkJ+rt3fzzr5xkjTtuSDwZsrx+aQFVJe/Fz9zRVcE+isR1+V?=
 =?us-ascii?Q?UNDHwCsH13kuvELmTckOeUnimMN8pJ5nnyB8vk0CQtojX0wsxBQExvOjmdbq?=
 =?us-ascii?Q?2ck+rV8nb2NrKKFxpHEfcbXbcdLVG5GtmuSHk8dTsg/oAiSrt6R4FqbFYmGK?=
 =?us-ascii?Q?nP3YIXZg+289Mr6FuLBMLt9aJCYUNrQOJh+Jo33++WfiYI+FxwlUkSxVTAaL?=
 =?us-ascii?Q?iFjOI3QlkWAXR04+j7PZZIMhaLlUDkK/gw1DZuECUHmjFE4Mb/X3WxB+QiqF?=
 =?us-ascii?Q?zVq6sXwcmoSxr3mU2GQlIF2dGOrSu6156T8fcFDVcb5WLIk9HG0IaYjbamJd?=
 =?us-ascii?Q?UB4ix5vYAF5Y4yj9Qpoj4yKq5kOreEyd1KQAQQIzCn51z+doY3ByVv09QZRd?=
 =?us-ascii?Q?vIACJQrUKr0nsgIltq1KScGl2JcaiI2BQtwULT8ZfjgPbxxSMAX8iJBxIjIY?=
 =?us-ascii?Q?ydAMAadAR0o9vCe2I7vlC504/jrkKWXIBdBz/tGbG5+YfUKopKIN5wJlZ8gi?=
 =?us-ascii?Q?6B/WfqPa5BZQD5r7t8Pg5PKEbq8/+DLdDeTwe6o4jOAgbH1IOj7FeeFekoTY?=
 =?us-ascii?Q?UzQSe26Fn1538moKQeixRNHeJduaoctawZ4cpvDu5afkHcGH9n9FW4LOzdJx?=
 =?us-ascii?Q?bPVLMOhlHgLFkWO5rdb5TycYLpi3qiNoc9eGLkRkVqQ53TzKLHFMhuEbnVuy?=
 =?us-ascii?Q?uo3IkDZ/w5BNWK9rK6IXrBS1MIzEgJGrBFZrPCAV2rg/wqDigkyx02CyuvVB?=
 =?us-ascii?Q?XI71JzR8Snd8CEnqHqkqgRPTS/CbdnALvVt5uAMqPU71kQAERz3GXYLLQe2f?=
 =?us-ascii?Q?CPakIBoAz+M1I1Q64Vfu6lghOLci37YpWLTx9myse5RnTEBMsMy2NRJyxbfr?=
 =?us-ascii?Q?5oIaBIHKRFvqNEzYi6+L5lqc0uhbA25sG/CZF5b2urlptt9a3w74z2TbV72l?=
 =?us-ascii?Q?WV6fIBetxV3N9XVvd0lZ7TssD6QFw90vHGjC8RTS+xkVnzJtB3lgPPdCDAIF?=
 =?us-ascii?Q?nolpcf2DzflQKeMugMtmKvYj5XO7LiUAQYErpIO0YvUEGJ0EgsybVtAaXlyR?=
 =?us-ascii?Q?PfbWyvcPWVhJn0q20fRacHGBjFk6q2/BElfRuqMpkNsRp1tE7N7BRwYtlAmY?=
 =?us-ascii?Q?kFD24X1lesjqu7aScwyaFlJQHP8Nk8zi67O8WgEYcsNFL20S0j+8yepCjzWt?=
 =?us-ascii?Q?tEwJqk7QE7CpsIue2Vxe993BuL6CPWiK0N/tKqylxrmrAv+LZNHxQbNMHn5W?=
 =?us-ascii?Q?Ut+J91MSem2Iejsemj3rHJ++qPV09f/GEfLWjUkPagZL8R+HqrhoIwPpEODJ?=
 =?us-ascii?Q?b4VX5q9I5w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77270666-892c-4a10-6361-08da1e9582b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 04:07:51.7229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6gCF+hFRQG6c0wkR0ubzJsb2UvcC7ArKdMaf7cl0l3koj1RgBJGPAJHmMAs8otJFGRhonuIjFGCyBYb6Cozcmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4761
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, April 15, 2022 2:46 AM
>=20
> Focus the new op into is_enforced_coherent() which only checks the

s/coherent/coherency/

> enforced DMA coherency property of the file.
>=20
> Make the new op self contained by properly refcounting the container
> before touching it.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c  | 27 ++++++++++++++++++++++++---
>  include/linux/vfio.h |  3 +--
>  virt/kvm/vfio.c      | 18 +-----------------
>  3 files changed, 26 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index eb65b4c80ece64..c08093fb6d28d5 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -2003,14 +2003,35 @@ static struct iommu_group
> *vfio_file_iommu_group(struct file *filep)
>  	return group->iommu_group;
>  }
>=20
> -long vfio_external_check_extension(struct vfio_group *group, unsigned lo=
ng
> arg)
> +/**
> + * vfio_file_enforced_coherent - True if the DMA associated with the VFI=
O
> file
> + *        is always CPU cache coherent
> + * @filep: VFIO file
> + *
> + * Enforced coherent means that the IOMMU ignores things like the PCIe

s/coherent/coherency/

> no-snoop
> + * bit in DMA transactions. A return of false indicates that the user ha=
s
> + * rights to access additional instructions such as wbinvd on x86.
> + */
> +static bool vfio_file_enforced_coherent(struct file *filep)
>  {
> -	return vfio_ioctl_check_extension(group->container, arg);
> +	struct vfio_group *group =3D filep->private_data;
> +	bool ret;
> +
> +	/*
> +	 * Since the coherency state is determined only once a container is
> +	 * attached the user must do so before they can prove they have
> +	 * permission.
> +	 */
> +	if (vfio_group_add_container_user(group))
> +		return true;

I wonder whether it's better to return error here and let KVM to
decide whether it wants to allow wbinvd in such case (though
likely the conclusion is same) or simply rejects adding the group.

Thanks
Kevin
