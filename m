Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E585020F6
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 05:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349145AbiDODrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 23:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348395AbiDODrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 23:47:31 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9813B42A23
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 20:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649994304; x=1681530304;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9zLVHWGBfbqvPppJVjwbOx2b6sfsMMM+C7GqeL2hz0c=;
  b=GAjksd4BzvPzGoADrgxKVhwIS6enyhV4jlw8l1Bbiij+oMsNvq0CjcS6
   tDPgOf2PEbye+lRRfkI1bkZuq/3o9avHvhyA+1S2rfbf3U/BGuYojxfBd
   oHSkc06Uf2FIOcjVvn4k9jZNZ77EY3iiAYXi+bfFOYVxNmuXtseAc8bOB
   E4wtS/Akq4fHtqPV9whAOGo3db0XwMKVyxe6YgvfvheBFuRvkzzc89yQT
   Cru+4vRfhfAeLZOhbNAF3BaTTpzl4aNKBge9lNv6BRI5Jd3zosy7dk1+Y
   BT5X/dlgICwXEsF2VyS8tc9NYEKUPVybz9VYgl5RFO3DZPjI89+EvyuWw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="250385531"
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="250385531"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 20:45:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="661625966"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga004.jf.intel.com with ESMTP; 14 Apr 2022 20:45:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 20:45:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 20:45:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Apr 2022 20:45:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Apr 2022 20:45:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KT5PU7sTgBApsNjGFkdb+qf3EMHpa1wwTHk6kRm1zT9dDmOueYBBgRVsw8l9+CkI6ZkrK4xoV+q3TQ8qLWv6idPtL1EcZn1tpN8O9hy6X7VC1z6FZGKmW4IZ499Y3Wnz/ljmzTZbJAMgmB4BYLG1vPhPPgzy/DoNUtQoxyOVYZuBao5yDvkjyih8Fk5V+pwW/tyKxhL7ePXKOAjHyXaUQGFa9iS0Txu39rZ3D40NoGoRc4DWfzKo4u/RcMbjHePxs/2jZUSA7bMrlM2gUdCuCjVOdLC+eEMNHhygd/uzNcR8XGVLCzjiAEZG/1SPe9tGIeqRu4+Gsgu69H9u6PKRgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrWUPUapqyZzLMoVrva8ssMXiRm9eOQ3sA8s43rPrmc=;
 b=U6ZwIVMv0NJkO+hUmepnikWAT4SuiZ5prdz40M5QN68aoMHCw/OrlsoaDK68HcLvA/yPKXM8vru1lg03Iuaea6TruIRJ2AkPfOqqJWD9NM4J0dmOpt7tcXkCkiwVo8iWS18RPheR2z+WXqldgwPTnmVYwH3panxL8CE4/HrhtE3sOH8OEx5g1HXfbfKPl7fikUVxdcFRB+0hY2LhSuXWd8ViPd85p0iTkWe7vZTFU15qM3yEQ2XrXUWn55pFoLLHz1iFMWeiZfrnUtfh2HIcjbMxL2I6v8qAwYJYim7598u2cj2QpznC/0tGsspSHgMIiraxXPFeKqZMxMY/Keq9jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB3452.namprd11.prod.outlook.com (2603:10b6:5:9::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.29; Fri, 15 Apr 2022 03:44:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.018; Fri, 15 Apr 2022
 03:44:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 03/10] kvm/vfio: Store the struct file in the
 kvm_vfio_group
Thread-Topic: [PATCH 03/10] kvm/vfio: Store the struct file in the
 kvm_vfio_group
Thread-Index: AQHYUC/7ia7nKOsQUUOysxBdX6dqIazwVFGA
Date:   Fri, 15 Apr 2022 03:44:56 +0000
Message-ID: <BN9PR11MB5276A8591FD649A1C42E520A8CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <3-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <3-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b8b0a30-b79e-4e53-c8e6-08da1e924ecc
x-ms-traffictypediagnostic: DM6PR11MB3452:EE_
x-microsoft-antispam-prvs: <DM6PR11MB34527A03187C2276B5414BBC8CEE9@DM6PR11MB3452.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sjbV11LwJdsn+mub1IRk8EbzUTEITe5Lx/w3mZCNXFk4lcgdf8B3LKhvaMr+lLdl4M1Il35htve+NKTfUkTUNYy8QcLnQ7+SSH6Z2EzZG9H+ThI/0eTieY+rWuPLKF92oMc4qJ/sE1V78x9dYwjFTBHn6sXLzoe/Z1W9HpzbWG+HjAdMydnxhoufgstAlkpLsRg5f9sNmDBwqA1mKinivQybilKqj5shi4cpe5burqEtVjIqHsx5Gf/aF1M85O85X+8Ti1sP/cAMfXk7FOP8dg3L31981b+4A/cdPKF9Uo7lZiwkcM+WrPPG9yeYaHkdlDkQZ0MaA3k4iMdjJvx3oa3PbIWe7AUjt+f7HihxjQiyrgT+D1u0Jyue+lvv23tWciHvCWzmRhhpHqlljSkMknWXo/jcGqdr52T4cMYmiIK6OskfT5pLcAcqzTWEpnRwNuEI1dMa2Kf0lWBkl4xdOOeUy64oisU0K5S+aHEZfEGJnv6pDgZk9DP6rMIs90lfM5uaJQkusT/MZwKygxTejrue6JxaSgC4q79MXvfj+Qd+zU0Xv5lOaGXkdTSpNG9VdvkAE5dtnakLvRc9je5rj4qhU/lJMU3ZcHiasQm3bXiSSjZUr8Vr1utbML01pYvTYPS1N7HyggOF+6bgWXyyzdAVD490kwaqoRH9FB9w3BkpIzoZI/YXvOuG8ogdJBNqNK0doElOW38hB1pJ/dsv4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(52536014)(8676002)(66476007)(66946007)(66556008)(64756008)(38070700005)(6506007)(4326008)(107886003)(7696005)(8936002)(2906002)(76116006)(71200400001)(508600001)(26005)(33656002)(86362001)(186003)(5660300002)(122000001)(316002)(38100700002)(82960400001)(83380400001)(55016003)(54906003)(110136005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cXzHJxVpNZ5/QDULWClEYRvzw54WwiltIJDT+sJhUZeZY1ivzutEA0cy2Z0H?=
 =?us-ascii?Q?BMrnZfZjt02Iy6V3swpB4Z8kThoWneZ2blIH81DEdwON0yue6WDc9CvZ3irV?=
 =?us-ascii?Q?NS8PqWYmDiUcagEruJm6/3P1/b4nmCMBm75lA35OQpzc+RuckIqb6fQItWEp?=
 =?us-ascii?Q?i6J3L1M5axjfhv4syo22ZFnFD8ZCE8Bag9Vot/iKwAulD8GcHyf7polVX8eg?=
 =?us-ascii?Q?aX8ZhEJSgMGwF5e4Ck7dlfqsfm+aMpUGu2SpqTE9l1I8QlpXoXKkHMZuEM/k?=
 =?us-ascii?Q?gz+pH4FJBwDYh9DK64jblGr8Xuo7Ormb48Wu1VoVOv9WPf+1UNhgqok0GOGw?=
 =?us-ascii?Q?viBaXbJJ7d5cqSebNPqQzrPmOs2M1CGWhJW46r4DMW1cLSEvxe8YpylA0eIX?=
 =?us-ascii?Q?jQ+BYVrELcZ5U1XXTT9bdWKTSDPYi96lSUIGWkJC1k3X67GbGUtDD0VtmY6Y?=
 =?us-ascii?Q?nxVdPjJdu27kr1PppnYfXoeGx4O3uTaPjYTA5aInHsiPOJbJVKyhIBel4EBw?=
 =?us-ascii?Q?h6UentC55jGjel2YlPhDkV1aFbrupxVcnqKodki7/Tydx0B3d5Hs0RqLb/RD?=
 =?us-ascii?Q?Iy0FI7AwYJ10dECF15NNi+ZrbKY80Ni/B3VIp6v/4f3C69G4g0JRl9i7Z4Jb?=
 =?us-ascii?Q?6uwzf2VyLYDARKR8aPOANW2Ye0oVPa+fXD0EiBWXOpW1m6+qkLFiRm0zA9kn?=
 =?us-ascii?Q?ip4gK2rMP0p+mL/WwU+Q74n5gTYmn5QHGC/i/Uxe6/VoPRFNWMEl29Ntx9C1?=
 =?us-ascii?Q?zS8BDgE6HqRIdhwdSgooP1Yd9B5gSuhxoEVdnLoTI1OQRmYfj7ZKYz+d5Pti?=
 =?us-ascii?Q?3UfwZJjtjqlbgRH/8awW7c9mZmSwqpwemebgE22fGZ8DzSarl4iWbpnd0qoN?=
 =?us-ascii?Q?NQxrsyGkIPAlx6onIjBgj1NOLfAR8hRlmVkocJDiEr/IcxfJ3u3JNTlF0LQf?=
 =?us-ascii?Q?RTuuo+4aPdJQmGzU5uRp0yE65C06s2A7g543Y2KU6lxyfvmm3kAlXggrTTVF?=
 =?us-ascii?Q?0G0pt7tujX4xCuvw88HrRUSOmODP20dDu4grJsomkFSotvFS1vkkVsgsTBVW?=
 =?us-ascii?Q?vku0MUaqVH5tCepJbfhnH/BUY7GVsU5/7HLA5pKnMHY5/c5tvwcrXeuF3Do/?=
 =?us-ascii?Q?6A388e5o76vbPOglzvqbyZXQjE/0Mo3Jx0ea50Aw04KCraACWiXccxireJ2r?=
 =?us-ascii?Q?fzgDqjyr0YIvYIr4aYtsibjO7ac1ClOyump1Ao6XRpNlX6jpSMGqKgXHjIFW?=
 =?us-ascii?Q?ZMtfLFILaOLSZ7huuHXwdcEyqxNfFUqRuVimet8XgLnIisDcAb4jzq/Y7UU7?=
 =?us-ascii?Q?vG/YCzlb9kS60N0JLJuP9bkIg32SP27W47bFfleaGDazIHaN3jrdtjJy1kfZ?=
 =?us-ascii?Q?IWn3HPqtdGTqZD7ZHfPPLQi0IGslXW6ReaYH3T3CNJ4Lz/KFe6G8h1FS/YA1?=
 =?us-ascii?Q?qJecjjTWH96RFgAcd9LSv7WPtyyTfPCM+OsTTcyYT2z4d8XvH7KJh1nG5gSG?=
 =?us-ascii?Q?bgBfw2rNGmfu6mHq6LIkd4V6thTwihYs2jWmeTq+Xg4+6LpD7VkwnzCodkB+?=
 =?us-ascii?Q?MsgFKkA9w3mvHt9phMfRXrrkkrb1cGVUt9eN/ZXWiykBh/3BRBHR6/PAcVTT?=
 =?us-ascii?Q?Kseo4oLdQ1T/FFbyPbm9igrVMWeVWCjf53YtEAbeTTl1ZWS+odd+2dhl3h8I?=
 =?us-ascii?Q?mpKofQnobuKnxanAzwIGOI3U1hFB/Ts76UQN+GEVNJTShxXZ8IqM21bojx6j?=
 =?us-ascii?Q?weGZtip+Cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b8b0a30-b79e-4e53-c8e6-08da1e924ecc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 03:44:56.1668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2zAHXrQ3pey99HkaTkmN5o1wI1QSEf7APUXVOn1+hug5xMPBX7pcl81ajvzw7C+f8NrRk7gIRs9PaedtDh7W/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3452
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, April 15, 2022 2:46 AM
>=20
> Following patches will chage the APIs to use the struct file as the handl=
e

s/chage/change

> @@ -304,10 +309,10 @@ static int kvm_vfio_group_set_spapr_tce(struct
> kvm_device *dev,
>  		return -EBADF;
>=20
>  	vfio_group =3D kvm_vfio_group_get_external_user(f.file);
> -	fdput(f);
> -
> -	if (IS_ERR(vfio_group))
> -		return PTR_ERR(vfio_group);
> +	if (IS_ERR(vfio_group)) {
> +		ret =3D PTR_ERR(vfio_group);
> +		goto err_fdput;
> +	}
>=20
>  	grp =3D kvm_vfio_group_get_iommu_group(vfio_group);
>  	if (WARN_ON_ONCE(!grp)) {

move above two external calls into below loop after file is
matched...

> @@ -320,7 +325,7 @@ static int kvm_vfio_group_set_spapr_tce(struct
> kvm_device *dev,
>  	mutex_lock(&kv->lock);
>=20
>  	list_for_each_entry(kvg, &kv->group_list, node) {
> -		if (kvg->vfio_group !=3D vfio_group)
> +		if (kvg->filp !=3D f.file)
>  			continue;
>=20

... here. Though they will be removed in later patch doing so at
this patch is slightly more reasonable.

otherwise,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
