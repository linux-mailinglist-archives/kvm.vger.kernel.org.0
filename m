Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB985502125
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 06:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349323AbiDOEE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 00:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349310AbiDOEE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 00:04:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510C6AAC89
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 21:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649995351; x=1681531351;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A7G/DZBUymXnqqP31TglNV+h/aQm8A4a4z0hadSvmGQ=;
  b=je1gy3aMxAKVOHjz7ZbGTfrxWCQNIpKCo+8I1vtytAQG7xknO5UdTe/C
   KoN02btZ2upHY4Z2x5GIE+5M+zG23IsqFVaS9gPPuBgca1lG9jgU1lQ+0
   O58tHrClcIQIOKtVnTkL/Fz/qTZ5w5jpnsRL5VjLP0BLh9X3Vv00WW1LB
   DNl5MFy5uoEHmnQGOspYETZmt/UzwybRJQO5kEA8qjrzx0qiyws7Aza/j
   rKaBFTzDy4vcOSL69LJ/PF4upR24o9N65fhxJJYTzf8PF7PVNQms8uVsa
   E2rqhvDmC8+qYVQOtLDDmUwg5lqZ1lnj5YSYvE23GCZGHhJMs6Er5lAvj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="263266306"
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="263266306"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 21:02:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="508669844"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 14 Apr 2022 21:02:30 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 21:02:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 21:02:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Apr 2022 21:02:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Apr 2022 21:02:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvWcmXk8chZZhL9SOZJ/r9BaAYCYefnLttFH0QPHE9Wy2DpgTypv6hgy3MQOp3Gquu15KV1Z2D927W5Zuah1sD0sOpU+aujMx2OA8KXoJx6LE7etQHtWKwzEokIjVTj/HRybL9/D61PghFDudS0iToZrpQKDhDkQ2dUEgbbYjTK7Lf99B+ouXS1hF4lnBRE2M1pvBb+vvfGewBon6f01Tl9RUU7B59BIaEB6LaXhCrXnZ1ey8cSHkwIyWz2UiAJzHDYFSSaJ1Mjkv8ZrBD/RRqNo5j5LF9ncFINwYDoGEd+qGgaC7tkpE8+k6unrFDJTJWeynb3UZTDR9I8CJ4a3/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3IRIQrJ2Lk/XglLiU5md23q3ygZg4x0huUgFZfgbJEM=;
 b=alomrJ/6VJ6MyrUTMjw1hYJxucfjAP2CTjecf5+we7pQxzujhzpjMVNnWPp28OShXAX1b6QMRWKcJmkv4b48W+W737htm/y/kn1Cv4h12/w8oSm88gR3EyPYUMMbKLbKqjvCOEswveR0077JusEo3i0JV/CsrU2CK76sYugFK/gwRPAvyKPUT7jlFhhuzlf8SiEqaW8olpFLq9TufoyUd//XzNb+zomOI/5qoqf17KQujEzoJGsl/jSfywaVdQb7ARnMRDVa6LwXBMaj1eOrl1PuBLkOQIqVhBFsR4cCdCygMk6aoG6kxwIh7hWFY/86H4v+Tmjb01FCTBiS4XbTjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB4924.namprd11.prod.outlook.com (2603:10b6:806:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 04:02:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.018; Fri, 15 Apr 2022
 04:02:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 06/10] vfio: Remove vfio_external_group_match_file()
Thread-Topic: [PATCH 06/10] vfio: Remove vfio_external_group_match_file()
Thread-Index: AQHYUC/18z3q15hzgEi2bp9zt+SXUazwWsOQ
Date:   Fri, 15 Apr 2022 04:02:27 +0000
Message-ID: <BN9PR11MB5276697DBD0977C9819339BC8CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <6-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <6-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd48a5e8-5e42-4361-86d3-08da1e94c177
x-ms-traffictypediagnostic: SA2PR11MB4924:EE_
x-microsoft-antispam-prvs: <SA2PR11MB4924DC5A8482120B1BFC3DF28CEE9@SA2PR11MB4924.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hKjZQvQ2xyJGHf6Tf7fpIsXBoUhIOBN5rj3Pod7K+SZd99bQjLvzh/wPAcyPswSP4YRvvsvyfg5IiaBDrc7iBMch+7QRkx+pAdSV2swn0PSuaQPBH7UubRVZCfEjsZsBh+rwHqOrQJF6NJ7NeanqKMqSf8q6/8Xpu7Pfa+62htABsmSS33ykjyXaHm15NL58CU6cUzLRx2wJ8kYiLMmhvyA2mRAcqo0GE3Hhz+GqfPma6kqqIv37Q7AP6w+J/5Lj8FTlaRk9BM6UQfQMHsRbDhOhHB6LAt3+DlJ604el4uG0m3BJK2YL1J/Uc5NQSi7T00pSRr8x+4AyrOHFTmIs+wld/gHe/U3hFWux2AHa6p+IR6XTl5lTCeSYJPgUVJ+y45Es9mGig+bjY1f/kHHUIX8qfG/gb624LcEDoVa5r5LNwz9eg2Tg9O3MAb6TG4y2xJAOOYuC5dhm6lY2HOKsC4R+Dn5pgj5IE68vEToCUZoAVi/M+rBCbevM9fH3iied43PVzZwkFoJe5gInCUIQ5Ea4TF7TP1jDN6l5v1EvZ+seOjIEPeGoWj0xd74lmSv/NdWZKVwafkFGia+fN723zlQg9aal98tLdsiNzOxj0xd59PwZc4KDa7BdT1X2f/simV20c4JosRTAu5mnMY8zqWyVNCtk7oZ7o9th1TZiWDYT0hZRqdcrkW1XkCR3vwxfg1YDBIpWJwqNJ3BHqH0bZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66556008)(8676002)(5660300002)(33656002)(71200400001)(107886003)(8936002)(64756008)(82960400001)(52536014)(66446008)(122000001)(4326008)(66946007)(316002)(55016003)(76116006)(110136005)(38100700002)(38070700005)(54906003)(7696005)(6506007)(86362001)(508600001)(83380400001)(2906002)(26005)(186003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LGte/KAP+fnk7MwWXGPvtrJdoaiH5LD8GbTVn4oDnRrndDFaTpN1kwbmTJqd?=
 =?us-ascii?Q?6+9qlq0z4yrJbrR9Ugb1r2mmIqTSC/lt3jFqA/q+PNdDmd2gkIIiGseFQVMi?=
 =?us-ascii?Q?bBerdc6blcl7bhGL8R7EVb8uxATUp+rKC5Eqk+u6xg2iyRcauUhHPzWa2XPk?=
 =?us-ascii?Q?VJBlPGpZUgkpgnOv6TAOS6DRaaACRz9PTY6PRhRJHvboEZi3Rcs8FM9HyTCr?=
 =?us-ascii?Q?DKk5VQ3CpBmy7LMonqrU3DoZM0wwXyyWOcus2oyLB1tENJhmrjkWR+kpmeRa?=
 =?us-ascii?Q?nbxd5hYcOqqqLw90A6mWeG2Qi3x3c9KoVqy33a0DhCxwJDlngtS9SXhIUDdD?=
 =?us-ascii?Q?krAdjxHNAZi8cMyDFPyT+Ofyg1DLdghQoeaW6nEomcsA3KiVxPn+Sde12Xhd?=
 =?us-ascii?Q?x+fhUrMUooSLY/Ll2gLAfRaHgXFSurXA4iH4a89pxi06z3ox2KBMHKeze4PR?=
 =?us-ascii?Q?RYCTSwfZ1Qn8YK53os1o5Zrt8F0COW3zWyXBxOjUpWpgTJJGE+Yv0g3Exs/M?=
 =?us-ascii?Q?4bCqQoo/TWAQ3WGVgQ6zkB39E1sADlrJ6E7TRXy0wTR4PyChxVVrZDFDPUp1?=
 =?us-ascii?Q?q0sRRzNjLfciWjAdZV85p5f750hQghELi2MJWJTKeTe8tiJOU/HQ+Nl9xaqk?=
 =?us-ascii?Q?WfoeWdbP1FKDKBe/xSlxI2yTwdlY4JKiUoPE0YaAnXKa6NBZJwYU3oF3Szo8?=
 =?us-ascii?Q?5+6ots2aH2g6sWhuL+GVpAw8FUb6YxGx18ER2eQfBkftzJcrMjnCV81M44h0?=
 =?us-ascii?Q?6ZT3vWCASnuc2vmjtcna4Xp/00CxBgqFFlWvP4WtGxwDbF8PVEut7R6Rz3kg?=
 =?us-ascii?Q?w66afUyKlPta2VYZHq8U2L/3W/MM1dLWqlXZIqpK0N36srlPAp10MaklcteO?=
 =?us-ascii?Q?HnCVk5o5veARFV9Bx2Fj8Y0qZ0969yg+WarMw0A0oPy34poLBf4K5kQTObgv?=
 =?us-ascii?Q?KG22yy1qYBmNegnGlsiXXeMvzsKGwftgh4oyWYiku2tfQHDP06nBbBbAhXvO?=
 =?us-ascii?Q?dg64bScTDnNMW8Jr1PAq+KbAQxRrJ/uRji0q1KA0byptV+54i+Yrs+8Ox/Ey?=
 =?us-ascii?Q?4nbFZWXg4SUtCumwbh9C4GhpJKgOQYkk9+sFbUqvxlAF5TjALUXpYkstOJE8?=
 =?us-ascii?Q?jZe5UWtf/dq5VghSwqdLSwDw0vcbqxt+oeMj8vxK1o8876diZbD3sSj3aol+?=
 =?us-ascii?Q?uPq+CAMEzXwBbH7XZdkT1DB5yzSNyHCqTCHinxL7FxzEfoKCiJGnzK+FIrpv?=
 =?us-ascii?Q?dDE2WSeHr/VRS1/Fiejm0r/PZMDA7CJ1C24ygjda6wVH223cnq7ElSw3JYIB?=
 =?us-ascii?Q?MEaDpxrqTJSFRxALgY+OaRETAuYfKlDHzzJV+B476zSPFgUv6ioxY7wnj1KE?=
 =?us-ascii?Q?R0cOnL4i9psf0QxgFbJJUZxeI9LmoB3S3dAd0wyAA+lMSehJ5OAPQlEklCD+?=
 =?us-ascii?Q?fLOvnGGzbbDPfgU6f89A4ikGA25N7xbzHG156w73h4tO8bLTQj9PhQVLjMe8?=
 =?us-ascii?Q?UGr5ZNwUta8thHwKTxfOR7q64mWJbOItPOv81AHtmZf9T/zD1/E8avcmcjpK?=
 =?us-ascii?Q?i5DdAFSWY9IyN3aU6Z/XxAlv/SE/TtHWIZV25iPpqi5Z4xPn8IBkQu59jpgP?=
 =?us-ascii?Q?v3VgOlhGDt8MJ+B+/QGTRiHRh5/N7qp/2SLfsEUgDjQMxgKQ6anhB9PAr8LP?=
 =?us-ascii?Q?bdFd3hIFqCb8xKDyQISgVJpVO9zF6MyEhkcr2yPMXNZvi3Beclo4q9WaJcC8?=
 =?us-ascii?Q?3yz/6XGSHQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd48a5e8-5e42-4361-86d3-08da1e94c177
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 04:02:27.5394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZDir24QsaHEijzgdBtqLzizCOAxC8FC/SIBbFQpT83jiaiHuv1LsN6BOe6S5JOH4agSm0NvSt5k/22+DOHuCIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4924
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
> vfio_group_fops_open() ensures there is only ever one struct file open fo=
r
> any struct vfio_group at any time:
>=20
> 	/* Do we need multiple instances of the group open?  Seems not. */
> 	opened =3D atomic_cmpxchg(&group->opened, 0, 1);
> 	if (opened) {
> 		vfio_group_put(group);
> 		return -EBUSY;
>=20
> Therefor the struct file * can be used directly to search the list of VFI=
O
> groups that KVM keeps instead of using the
> vfio_external_group_match_file() callback to try to figure out if the
> passed in FD matches the list or not.
>=20
> Delete vfio_external_group_match_file().
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c  |  9 ---------
>  include/linux/vfio.h |  2 --
>  virt/kvm/vfio.c      | 19 +------------------
>  3 files changed, 1 insertion(+), 29 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 4d62de69705573..eb65b4c80ece64 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1989,15 +1989,6 @@ void vfio_group_put_external_user(struct
> vfio_group *group)
>  }
>  EXPORT_SYMBOL_GPL(vfio_group_put_external_user);
>=20
> -bool vfio_external_group_match_file(struct vfio_group *test_group,
> -				    struct file *filep)
> -{
> -	struct vfio_group *group =3D filep->private_data;
> -
> -	return (filep->f_op =3D=3D &vfio_group_fops) && (group =3D=3D test_grou=
p);
> -}
> -EXPORT_SYMBOL_GPL(vfio_external_group_match_file);
> -
>  /**
>   * vfio_file_iommu_group - Return the struct iommu_group for the vfio fi=
le
>   * @filep: VFIO file
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e5ca7d5a0f1584..d09a1856d4e5ea 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -145,8 +145,6 @@ extern struct vfio_group
> *vfio_group_get_external_user(struct file *filep);
>  extern void vfio_group_put_external_user(struct vfio_group *group);
>  extern struct vfio_group *vfio_group_get_external_user_from_dev(struct
> device
>  								*dev);
> -extern bool vfio_external_group_match_file(struct vfio_group *group,
> -					   struct file *filep);
>  extern long vfio_external_check_extension(struct vfio_group *group,
>  					  unsigned long arg);
>  const struct vfio_file_ops *vfio_file_get_ops(struct file *filep);
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 743e4870fa1825..955cabc0683b29 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -60,22 +60,6 @@ static struct vfio_group
> *kvm_vfio_group_get_external_user(struct file *filep)
>  	return vfio_group;
>  }
>=20
> -static bool kvm_vfio_external_group_match_file(struct vfio_group *group,
> -					       struct file *filep)
> -{
> -	bool ret, (*fn)(struct vfio_group *, struct file *);
> -
> -	fn =3D symbol_get(vfio_external_group_match_file);
> -	if (!fn)
> -		return false;
> -
> -	ret =3D fn(group, filep);
> -
> -	symbol_put(vfio_external_group_match_file);
> -
> -	return ret;
> -}
> -
>  static void kvm_vfio_group_put_external_user(struct vfio_group
> *vfio_group)
>  {
>  	void (*fn)(struct vfio_group *);
> @@ -244,8 +228,7 @@ static int kvm_vfio_group_del(struct kvm_device
> *dev, unsigned int fd)
>  	mutex_lock(&kv->lock);
>=20
>  	list_for_each_entry(kvg, &kv->group_list, node) {
> -		if (!kvm_vfio_external_group_match_file(kvg->vfio_group,
> -							f.file))
> +		if (kvg->filp !=3D f.file)
>  			continue;
>=20
>  		list_del(&kvg->node);
> --
> 2.35.1

