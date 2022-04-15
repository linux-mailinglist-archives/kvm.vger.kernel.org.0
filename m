Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95365020EB
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 05:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349078AbiDODiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 23:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241106AbiDODis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 23:38:48 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1697975227
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 20:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649993781; x=1681529781;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TPDfvrH4FIL1GSUCzlEomv3EC/h1kNcr+x6Qb0lQzp8=;
  b=NsHC4lq9Z+YGq1rPspkvsjocPAxYvRGRnbgCl2m77un7DUExqpBNKaq1
   tmg0Y5oRtaEN07ClTqW8acc0finqaJhlqfPgqStikXUdZg3O/jiXMmmc7
   6KYZTePSas3ks4TU3LwgEMp3BYcxLIzGlEcXf+gUwwKddm4wtmaV7TW2I
   Vs7Zf3lILAYFT9NV2qEJ8pHI1LNkgOIh20Gkxd+8SFGH4mJV4dQ7XdMpK
   jPddG44YoSZpxer7sOlCvH8moDoA0Q+KgW2eNyHZoJ5yUwCVhP5GdAuSA
   IzXMs/DijtPwnWdsCUea9eK1bq8EUXuwnPIXWFXM8O7wmfdrLmQIHchMh
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="349521326"
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="349521326"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 20:36:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="624325603"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 14 Apr 2022 20:36:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 20:36:20 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 20:36:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Apr 2022 20:36:19 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Apr 2022 20:36:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7riBxHlQ/6gsDOWYvvP/fJyfJhlikZ6XYVtWVGvJlsIWema4NYpEFUEwHtyb8x1IcMoCrv13XD+juEUVUILyoaAubfg0p9olV2lNSkgCT1Av3ZS70cMFhQl5iU7jV3Dq2f5d+Bdcw3Kx8PAHwHcY8eQ8i5bCmGivswLfiuUcB+YdHowQjDamwK7eQE/CnSFQusCBXMON0VoR9y3cODn+unB6uSRZltTuRWRbSCvKky9fs5ud6Z/MaLaI27XXU8z7oua+uzgdE8HAE0P8nNzCOwyRFvkabdOnochAUFO+mFKJPS5+mjfxo61R4T2uC6e0lyW/4eBoD0PwiRMMSOSuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRLj9eef/D4xjTIvYG9RfykEJb7Wa8IxjWGEyW4/SsY=;
 b=mFnq72Wn7JDXoBhva6PGQlEytr2EnEkzXcHk53Hgu02aDqdIvXPqguXSEKZcdu/RbW3/NGSCI7H78mKDLhqadaGlVO5APA5bJmmSVX1Mha2SwgxcebGqzpS1yu2EBYljla3NXn1IMlslXzLM73fpi2RZ+A8XRARSssxOqCp13yxQGE5p1uY4A82y5aGL/LuqAFmXXRiukak2UhF18rOF6DAafQzBY4QRZ3+3TOrNqXNAT8GZh7gKrfc0umAEsaW7xYbfH699tngjOGdHsc/sko85OdN+nQBM19YwhM3c6khrHxKXcyh/Ds5Bigk5bQ6Nn4sLf9ndJodn+GuPPHD1mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4934.namprd11.prod.outlook.com (2603:10b6:510:30::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 03:36:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.018; Fri, 15 Apr 2022
 03:36:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 01/10] kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into
 functions
Thread-Topic: [PATCH 01/10] kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into
 functions
Thread-Index: AQHYUC/7cr9fMOY1jU+hF4Md1X49XazwU3Nw
Date:   Fri, 15 Apr 2022 03:36:17 +0000
Message-ID: <BN9PR11MB52760E3E75F94AB2E8897D938CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <1-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <1-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74725f72-3d88-4453-645b-08da1e911987
x-ms-traffictypediagnostic: PH0PR11MB4934:EE_
x-microsoft-antispam-prvs: <PH0PR11MB4934FA625F48E5CDC69D2DCF8CEE9@PH0PR11MB4934.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ppIshAzNEpjzae8Tqn6YCSPMC/RlXDdv65+GZrkrL2JTIlhFDpaQdKjJZbxOROOf7xVz5TrVW/xmvqoUOLXITPnpw4Xdf4s6TZB/wZJ+cJRZm0BkouOzDeOv49eo9m9oFGp5bSozxz09C1mY9I40wE3ecy1GwnPJo0WuOIomkkEo3lFa8zDkptIfJgTPVni25NNMzaMGlCy+yIl8OlP8j1Fmz3YH+WwIVa1L5Wt0KGwcRapBqo3a7A8L44gdaNc8lgo8R/TJolqzAvNkLxAdwaw0m3MBXPi/eNHoWxuRTxQ5B9TZJJ/L9189yn5gUstSS9mFI0/PZsPwZFfz7fwsyykSLbzPSsyJohlCA9Kl7YOP8JAD0tNF5AvsHZaKWnewAh1kHsksQfEXlinw/yE1hCjCrcCMbnZiP6VnK6CBZG0+YMwt2JAb70ot6ONfp93furwBJ+s3yt2tDnr6ayl10ReBZ4+x6EdVLfIB4WuM0joWHcb+quxOiVUL5rMHx8UxFuyDZHZJEIhWs2Q5P3eO7+jqwUZAH/s920DaPkwYYZVP1u2h7hx2sl7t8OCloytNLfcj4xIQ9/2t3P1CLTEr76lPl/7M+UEy6rEg4EjP4oKeM5HhzpuvJQ+QIzX7E5gqNgyBawnAAmuVCAEJMwY3uM1uUZqnGYQcq9qhQ7V2U9+JIA6mJR8cGIboQP4paTE9L194AhWE2mWtTHjsGUDM2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(33656002)(71200400001)(55016003)(4326008)(8676002)(8936002)(186003)(6506007)(54906003)(7696005)(110136005)(9686003)(5660300002)(82960400001)(122000001)(83380400001)(316002)(86362001)(38100700002)(2906002)(508600001)(52536014)(66446008)(66476007)(64756008)(66946007)(66556008)(107886003)(26005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HsADbM334x2nQMN2vm/9husYE+QyQAZNbIMImdW79TYsThgeczxhswE3OJ6e?=
 =?us-ascii?Q?oSLkzher5kL66LaglJsV6VdmolwVweDD6Dp+ZcmIoJM+zplG5+jPGrx0kuDB?=
 =?us-ascii?Q?P4F+irMG1FiYIEMywNNjO4znP86S5jGpjNRZUkXu9IhltErvk9Sl+uMgdjg+?=
 =?us-ascii?Q?v6Kmmc4rurqAvODjKkg+PMSa2h9uoWY23qbV2vChrlCOa3jqkWnMvDiPq5mH?=
 =?us-ascii?Q?evCGPjCXmfz0d4Sqt/7ZM6Qw1XmGs0RYw9q0j4vmzdSjTPsteLgjxJariQH5?=
 =?us-ascii?Q?jqLgZqiQNwg1y7kvgVaTKnmM+PXLXyExDWmwjdFRlCx7n7gdmFIwU9VSy7LP?=
 =?us-ascii?Q?Y/4nI6wJO5OEEqypBzcmyXPTxSelL3OJ2nreTaWrIycf2I465GSyYFaQjyDi?=
 =?us-ascii?Q?/0TEpERNS0tgwMT03UNGOT6KQdlSeqOsS4iMv6icbEHh3Lj4NedyhKAFm9KO?=
 =?us-ascii?Q?3DwZlVWKiz11RxDVQxcpHH/RAupLardyilrLfZySN8NyCtSQNrelYw/o8Pxp?=
 =?us-ascii?Q?KrPKZLrS770DzfXWm7t1TxD/mW1jaupymOnJ5LUvi5m1BoM8Hl3AlBXpUkof?=
 =?us-ascii?Q?Ps8GlaPtCH1N4gRQ2zGIgkxgfI+HA0MuX7Q5EojpTsFoGYe3rrJS+ABAqJYo?=
 =?us-ascii?Q?SdTzCBbHEDrqOGndrpmprk02AbFeUFOOm1Y4qhfpKne4KijXZLS1+9LCLWyr?=
 =?us-ascii?Q?/EztHIdkQchNXomI/7uE3+HIOb6ONGWJyUAcIr+MQFB39gUs3VPOyLlRALh4?=
 =?us-ascii?Q?JRdYkIr8BFqF34MLUGw2sc1Cdg5CFXDdqPZt8JY962MTJwOCQQd2SNHKs5Ek?=
 =?us-ascii?Q?rBdmAekBX8+jfCSmGYgxSKx3MnFsCM8XE6KANVW1weokII5vx/+uTiIG+gzU?=
 =?us-ascii?Q?uhKURSy+paHmkvnGyWKdXaV4zLuHiqHlEnXFGxxqMU2+aAIFIhV7s8KO8y8K?=
 =?us-ascii?Q?1ZkaL726MIvuKIHgh9uPXLwO6uQi23w4ZRXiq2WvhapbfLjZyAw9JhXth5rP?=
 =?us-ascii?Q?3x3Eu6R5FCkcPRKQSPpirEt6Tb/GR1vsIp76XIyA26C77IhDWYJlEoQq6tK9?=
 =?us-ascii?Q?B8M7cylz16J3BWybR9nxI8gzHiKnhJJAbVrIgmZ0Nc3EllvymjZs2ChNzctE?=
 =?us-ascii?Q?jBGJ+6zE9qBZBi3HMjXipG0j8WRzWWZJpEP1xEG7KRRYnAJtSJAn6YbINyXj?=
 =?us-ascii?Q?MoiVBuzM+K+E6N/I7IahCM7u/AlVB5fxFB+M0hWkgvfco+z2aMZQHVK6/0N4?=
 =?us-ascii?Q?Zb3hUf0oZpyO8SntbpnIexMFjI0v1QasERjfPwf23H8Xd94v9VugLfR0CbRg?=
 =?us-ascii?Q?KHIqwFH1/nNBwx99PQN18kIuj06nOJrhopV2dT+LJv6TC40zDy9ztJb5qw89?=
 =?us-ascii?Q?qa6mo5wq7YwkrmKeyrx+n+SvPmZfUS7wECxQpmP851YUoJ0MMdHZ4T2B/g72?=
 =?us-ascii?Q?35Jo05SlkzbEd6IfBWBSSDKWVPed5Uh4WXQaqSeZPEnSjq1aOrxkHLK7+He5?=
 =?us-ascii?Q?QLal3JVn01mrNuE74iQoCZJEKIiFxF3Sn1odbHi2HacOydetPz63BuBJbwaR?=
 =?us-ascii?Q?ViQQUazOiZOYlpQ+FnETk82lHXh/we/7E+OKHajpSBQ2YVaNT5CreM2ZLKPi?=
 =?us-ascii?Q?1cW9kyH8c61OZy3yIsED/Vpq2xz753pX70YGgSvsnlnNlxP/TFlTHluXWZfv?=
 =?us-ascii?Q?ferh5INmMo+l438c4xDDu9dsb1QLPv0+g8NHmD2J/tHvIEn9QOtjTHIeH8sK?=
 =?us-ascii?Q?y6Eju87Drw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74725f72-3d88-4453-645b-08da1e911987
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 03:36:17.2491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8tpiFJb0ewAWkD1F9XqvTlwTt2S+GHnIl39fCInl8ESlNOLN9rqat80+LYOV9ruBd9hbQ5H9lslWChkn2dE7jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4934
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
> To make it easier to read and change in following patches.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  virt/kvm/vfio.c | 271 ++++++++++++++++++++++++++----------------------
>  1 file changed, 146 insertions(+), 125 deletions(-)
>=20
> This is best viewed using 'git diff -b' to ignore the whitespace change.
>=20
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 8fcbc50221c2d2..a1167ab7a2246f 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -181,149 +181,170 @@ static void kvm_vfio_update_coherency(struct
> kvm_device *dev)
>  	mutex_unlock(&kv->lock);
>  }
>=20
> -static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg=
)
> +static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
>  {
>  	struct kvm_vfio *kv =3D dev->private;
>  	struct vfio_group *vfio_group;
>  	struct kvm_vfio_group *kvg;
> -	int32_t __user *argp =3D (int32_t __user *)(unsigned long)arg;
>  	struct fd f;
> -	int32_t fd;
>  	int ret;
>=20
> +	f =3D fdget(fd);
> +	if (!f.file)
> +		return -EBADF;
> +
> +	vfio_group =3D kvm_vfio_group_get_external_user(f.file);
> +	fdput(f);
> +
> +	if (IS_ERR(vfio_group))
> +		return PTR_ERR(vfio_group);
> +
> +	mutex_lock(&kv->lock);
> +
> +	list_for_each_entry(kvg, &kv->group_list, node) {
> +		if (kvg->vfio_group =3D=3D vfio_group) {
> +			ret =3D -EEXIST;
> +			goto err_unlock;
> +		}
> +	}
> +
> +	kvg =3D kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
> +	if (!kvg) {
> +		ret =3D -ENOMEM;
> +		goto err_unlock;
> +	}
> +
> +	list_add_tail(&kvg->node, &kv->group_list);
> +	kvg->vfio_group =3D vfio_group;
> +
> +	kvm_arch_start_assignment(dev->kvm);
> +
> +	mutex_unlock(&kv->lock);
> +
> +	kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
> +	kvm_vfio_update_coherency(dev);
> +
> +	return 0;
> +err_unlock:
> +	mutex_unlock(&kv->lock);
> +	kvm_vfio_group_put_external_user(vfio_group);
> +	return ret;
> +}
> +
> +static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
> +{
> +	struct kvm_vfio *kv =3D dev->private;
> +	struct kvm_vfio_group *kvg;
> +	struct fd f;
> +	int ret;
> +
> +	f =3D fdget(fd);
> +	if (!f.file)
> +		return -EBADF;
> +
> +	ret =3D -ENOENT;
> +
> +	mutex_lock(&kv->lock);
> +
> +	list_for_each_entry(kvg, &kv->group_list, node) {
> +		if (!kvm_vfio_external_group_match_file(kvg->vfio_group,
> +							f.file))
> +			continue;
> +
> +		list_del(&kvg->node);
> +		kvm_arch_end_assignment(dev->kvm);
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
> +		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg-
> >vfio_group);
> +#endif
> +		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
> +		kvm_vfio_group_put_external_user(kvg->vfio_group);
> +		kfree(kvg);
> +		ret =3D 0;
> +		break;
> +	}
> +
> +	mutex_unlock(&kv->lock);
> +
> +	fdput(f);
> +
> +	kvm_vfio_update_coherency(dev);
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
> +static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
> +					void __user *arg)
> +{
> +	struct kvm_vfio_spapr_tce param;
> +	struct kvm_vfio *kv =3D dev->private;
> +	struct vfio_group *vfio_group;
> +	struct kvm_vfio_group *kvg;
> +	struct fd f;
> +	struct iommu_group *grp;
> +	int ret;
> +
> +	if (copy_from_user(&param, arg, sizeof(struct kvm_vfio_spapr_tce)))
> +		return -EFAULT;
> +
> +	f =3D fdget(param.groupfd);
> +	if (!f.file)
> +		return -EBADF;
> +
> +	vfio_group =3D kvm_vfio_group_get_external_user(f.file);
> +	fdput(f);
> +
> +	if (IS_ERR(vfio_group))
> +		return PTR_ERR(vfio_group);
> +
> +	grp =3D kvm_vfio_group_get_iommu_group(vfio_group);
> +	if (WARN_ON_ONCE(!grp)) {
> +		ret =3D -EIO;
> +		goto err_put_external;
> +	}
> +
> +	ret =3D -ENOENT;
> +
> +	mutex_lock(&kv->lock);
> +
> +	list_for_each_entry(kvg, &kv->group_list, node) {
> +		if (kvg->vfio_group !=3D vfio_group)
> +			continue;
> +
> +		ret =3D kvm_spapr_tce_attach_iommu_group(dev->kvm,
> param.tablefd,
> +						       grp);
> +		break;
> +	}
> +
> +	mutex_unlock(&kv->lock);
> +
> +	iommu_group_put(grp);
> +err_put_external:
> +	kvm_vfio_group_put_external_user(vfio_group);
> +	return ret;
> +}
> +#endif
> +
> +static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg=
)
> +{
> +	int32_t __user *argp =3D (int32_t __user *)(unsigned long)arg;
> +	int32_t fd;
> +
>  	switch (attr) {
>  	case KVM_DEV_VFIO_GROUP_ADD:
>  		if (get_user(fd, argp))
>  			return -EFAULT;
> -
> -		f =3D fdget(fd);
> -		if (!f.file)
> -			return -EBADF;
> -
> -		vfio_group =3D kvm_vfio_group_get_external_user(f.file);
> -		fdput(f);
> -
> -		if (IS_ERR(vfio_group))
> -			return PTR_ERR(vfio_group);
> -
> -		mutex_lock(&kv->lock);
> -
> -		list_for_each_entry(kvg, &kv->group_list, node) {
> -			if (kvg->vfio_group =3D=3D vfio_group) {
> -				mutex_unlock(&kv->lock);
> -
> 	kvm_vfio_group_put_external_user(vfio_group);
> -				return -EEXIST;
> -			}
> -		}
> -
> -		kvg =3D kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
> -		if (!kvg) {
> -			mutex_unlock(&kv->lock);
> -			kvm_vfio_group_put_external_user(vfio_group);
> -			return -ENOMEM;
> -		}
> -
> -		list_add_tail(&kvg->node, &kv->group_list);
> -		kvg->vfio_group =3D vfio_group;
> -
> -		kvm_arch_start_assignment(dev->kvm);
> -
> -		mutex_unlock(&kv->lock);
> -
> -		kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
> -
> -		kvm_vfio_update_coherency(dev);
> -
> -		return 0;
> +		return kvm_vfio_group_add(dev, fd);
>=20
>  	case KVM_DEV_VFIO_GROUP_DEL:
>  		if (get_user(fd, argp))
>  			return -EFAULT;
> +		return kvm_vfio_group_del(dev, fd);
>=20
> -		f =3D fdget(fd);
> -		if (!f.file)
> -			return -EBADF;
> -
> -		ret =3D -ENOENT;
> -
> -		mutex_lock(&kv->lock);
> -
> -		list_for_each_entry(kvg, &kv->group_list, node) {
> -			if (!kvm_vfio_external_group_match_file(kvg-
> >vfio_group,
> -								f.file))
> -				continue;
> -
> -			list_del(&kvg->node);
> -			kvm_arch_end_assignment(dev->kvm);
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
> -			kvm_spapr_tce_release_vfio_group(dev->kvm,
> -							 kvg->vfio_group);
> +	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
> +		return kvm_vfio_group_set_spapr_tce(dev, (void __user
> *)arg);
>  #endif
> -			kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
> -			kvm_vfio_group_put_external_user(kvg->vfio_group);
> -			kfree(kvg);
> -			ret =3D 0;
> -			break;
> -		}
> -
> -		mutex_unlock(&kv->lock);
> -
> -		fdput(f);
> -
> -		kvm_vfio_update_coherency(dev);
> -
> -		return ret;
> -
> -#ifdef CONFIG_SPAPR_TCE_IOMMU
> -	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE: {
> -		struct kvm_vfio_spapr_tce param;
> -		struct kvm_vfio *kv =3D dev->private;
> -		struct vfio_group *vfio_group;
> -		struct kvm_vfio_group *kvg;
> -		struct fd f;
> -		struct iommu_group *grp;
> -
> -		if (copy_from_user(&param, (void __user *)arg,
> -				sizeof(struct kvm_vfio_spapr_tce)))
> -			return -EFAULT;
> -
> -		f =3D fdget(param.groupfd);
> -		if (!f.file)
> -			return -EBADF;
> -
> -		vfio_group =3D kvm_vfio_group_get_external_user(f.file);
> -		fdput(f);
> -
> -		if (IS_ERR(vfio_group))
> -			return PTR_ERR(vfio_group);
> -
> -		grp =3D kvm_vfio_group_get_iommu_group(vfio_group);
> -		if (WARN_ON_ONCE(!grp)) {
> -			kvm_vfio_group_put_external_user(vfio_group);
> -			return -EIO;
> -		}
> -
> -		ret =3D -ENOENT;
> -
> -		mutex_lock(&kv->lock);
> -
> -		list_for_each_entry(kvg, &kv->group_list, node) {
> -			if (kvg->vfio_group !=3D vfio_group)
> -				continue;
> -
> -			ret =3D kvm_spapr_tce_attach_iommu_group(dev-
> >kvm,
> -					param.tablefd, grp);
> -			break;
> -		}
> -
> -		mutex_unlock(&kv->lock);
> -
> -		iommu_group_put(grp);
> -		kvm_vfio_group_put_external_user(vfio_group);
> -
> -		return ret;
> -	}
> -#endif /* CONFIG_SPAPR_TCE_IOMMU */
>  	}
>=20
>  	return -ENXIO;
> --
> 2.35.1

