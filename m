Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A11063FFD3
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 06:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiLBF23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 00:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiLBF21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 00:28:27 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D6D7F890;
        Thu,  1 Dec 2022 21:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669958906; x=1701494906;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FZyAjYOwZzyaGj0Qi//cI472EoYBeZINMIUYeMOulOM=;
  b=njZ/qRz0DOEXcsXmsEuolO2adiH2HyCjH94UyTdO74+OrAB8nF1QTJIB
   wyRoQfrAbLmIfJYD4RkijIXioRyMOV5EEE39VTTQIyfquXRyHoN4USe3X
   gZJF0rRTd4KJL+Q1eKt9molhzvf+jSwCowLAze9F5J6rgUueJRjUxbtVi
   IhbkxLnnKUh3LpivAdEZgULxqbDgvPNhhWzTUJtXLBIrKlqXlNsJ9vAE5
   W0drCkrUbA/b8Qdq5nKwTBqtfYYlQfukbvJIimmpA/4tuQM9nNqa1qvFB
   sAeRqYGHJXYGfL+69pSsB+xtUJxHfGN1mkXTpoo2S49Gb1D4AWW9NNein
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="296229634"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="296229634"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 21:28:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="890022723"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="890022723"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 01 Dec 2022 21:28:25 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 21:28:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 21:28:24 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 1 Dec 2022 21:28:24 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 1 Dec 2022 21:28:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+1OHs15oxAabH0NWgnPFU7rF66BqKUsDNKYgEjFMxMYbwmqz/N5g5EKgzE8xRq/rOC3EAVuK6Mwgi1W1FoF3VpC1mniK0rXr8IacZyYUwMX/kLKBE9qppQLAmCR7UoneMH9BpVHY3pYti6iv3nsqcR36yF7zQh2pRhNGL/xOAk5LjjQB+X+BMrhlji/lbRxOgMeA0pddozAvcqg6XCflEoayMbrVgvSEfFHns8KDywbDBY/QSdVjwoOgSJRk/0H34Lj8SyWLVELWMgcwPNEAhnUQAfaRIpZSY2BXNDZ0ndEZnH7GMrDLCEtCrhQMOr3wTCnsGqGX219+T6G0lt54w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cP1kF7aDQ9zWWXIDGX6wcoPoQWgsezOfyU2Ymx2Ae+g=;
 b=jcoas2TEAEr3Ra00x4b84hWgB9osDPTTOpmpLgMX9oZ9MUZkmIu68lXyw+7MSOX1hYc9UaBknhevG3Py7i/eKaUCkOqX29C9cTj7YHCTnWb2cns7Ltu+sDvMKD6qyzvXMw6wNHhkTltMiMjMn1PtYB/fkNu9JI1JEC9T4qh/G0MB6/4wrWpLzXedy305cgQuA0DYm0jK6OY9yCD8FfhkqflNk9+uRs7IAfxhhVGMiVImp7+xWY/wh/+Wb8rJg1ZbLoK0UBwE2m9zyfDIzU/Sxo7g8BFXFmKGJH54couDQ7paChubqsovgO1umFC5DWOH6ry/ezSJHIu9zPxzJ4CL+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7026.namprd11.prod.outlook.com (2603:10b6:510:209::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 05:28:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 05:28:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     ruanjinjie <ruanjinjie@huawei.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>
Subject: RE: [PATCH] vfio/mdev: fix possible memory leak in module init funcs
Thread-Topic: [PATCH] vfio/mdev: fix possible memory leak in module init funcs
Thread-Index: AQHY+v5PNbG9jfSk/kCdM8m0sVUH4a5YKr0AgAAtZtCAAUR7gIAAibBg
Date:   Fri, 2 Dec 2022 05:28:22 +0000
Message-ID: <BN9PR11MB52763DC62CE7FEB3A70356BD8C179@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221118032827.3725190-1-ruanjinjie@huawei.com>
        <20221130160622.0cf3e47d.alex.williamson@redhat.com>
        <BN9PR11MB5276BC0B7E656465950E3A558C149@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20221201141013.68d2b0cf.alex.williamson@redhat.com>
In-Reply-To: <20221201141013.68d2b0cf.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7026:EE_
x-ms-office365-filtering-correlation-id: 5b85da11-98dd-46d5-6d4b-08dad4260739
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OQESeCqFOlhw8jLRPolxitNldjOeTKnV94DlIa4yWPCzyN+2bhAoMZ+pxcwjQSwpR89+Zs+6kwwvEjtf9DcoSX/TdbpXYPc6ZXGxykoOyKi0Da9kJ1vzYS5qCkzeN1aTTwYavn5zmQMa8KBcTsXTVyJaDD4loX0uSRxhAuiTrRpvqdBjeNseQ5SP9Y3Rb27QRHcgRJZlO/m3VqUwwpmoKAqA7tUYaCF9ygE7o8o18jlz/AvjZK3zP7VoE1bwoIAQqwJE4tkglkmpTwSM2ycx7OYX6qnF7H5fkAjAiw97tunvb1N2rqIzmJZk2JU2vX0P0CWefcoupGxymH6xA+rcagVTnSyyYVdmMmATX9eHtulP/y3n0Jdam8HskHd4ds7L9WcZO3qtUNPdCTkDiGuoDPMk3zWRe4oliO5FichKrNqneCZ56OHg8pw4bu/fi9MdKTfJ5E2vpSWNNwp+HRdDtrvhA8eoLm16CKYc4L0hpPZILLQ6QttxQfwL+VTQ1QQ11D5S4ZFKioKWMvMxYk32lWb/bToj0K4PJLy54O1OVLqo1CcAosGQ7/BezLbKWBVxvV/sWMPIMv8GVjwiEY4XaNN4nSgmFBYXaJt+ZvTG4Paun7EiVaG2msHv4TLFnw3COpt61Wee17wLnA9eGjAPxRcpK5VQovQa+yDFoS1Hh/UZ8ZWihllImZP5iRUVbBJgSVs+GsA3SgMQ63RenSbXjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199015)(2906002)(316002)(8936002)(38100700002)(186003)(66946007)(33656002)(52536014)(122000001)(5660300002)(86362001)(7416002)(64756008)(9686003)(41300700001)(55016003)(8676002)(6916009)(54906003)(66556008)(66476007)(4326008)(82960400001)(66446008)(38070700005)(6506007)(26005)(76116006)(478600001)(7696005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xBVAzlTOA13tczqFWS2N4iUokKyMW+2y7PBW5Vetobg0d+qVveIfbzkqzx/L?=
 =?us-ascii?Q?j0oZ+2WL4WMbC+kg2udgennXTkM0AVDj4JBzLTq/Tk7bGwIVhzuDd+d5mMtH?=
 =?us-ascii?Q?cVxnkDYN/00GXE7DtuuOjuqVcuF2dMrmTy3/Laq9pch3ycpoa2yETcWTfFlK?=
 =?us-ascii?Q?BtJi4nFFPN93yxeeksMlq9IFaKR3Qx6B3951BRTqdzaWpVT6Gy6C/qBGGBJl?=
 =?us-ascii?Q?Oc2VeU/ncQlOJM54dImYenZqtXuB6J+YTUyByr/IULgcwy1BXp1L0LCOBgLf?=
 =?us-ascii?Q?zXoSdnczFChO9gC4PxbNOZl302xN1MajVV8VNrELJeA6cEcvuyqMWbjI5VNL?=
 =?us-ascii?Q?UF9BDUutkxrs512D3hdRE27b65uD/qG5co0n+WeKFPMvsDlneDaLrIzahwXX?=
 =?us-ascii?Q?WCp0UGHFqO5077fxEXOsOyKuUYEueNPLcMBN++o6Cypp10im9S6IpTIYjqYi?=
 =?us-ascii?Q?afjrTsCVQED2/kQdETtIgpFxQJ5LDlO41XnstG6GSnej+ad1OkUCKgyrRvNa?=
 =?us-ascii?Q?L2j6H0XH+qWuaYFG5DhUzBZ++/oXhpBRTWQYP0KX1g/7wEG2/IzwKZe26IVZ?=
 =?us-ascii?Q?gx7SxJgXrMBE2eIU1Z3knbSpLkxYxCQr2cCd4MLohzIRZj4Q/094VYRQC/dl?=
 =?us-ascii?Q?AjDtVEHJq9IxIYvOl/vgYCWMu8KC/O7+28a7Qm9/93GuOxPnWE5GXWAx898g?=
 =?us-ascii?Q?hcsYfVg/cw5iOZjChlKQN+vp5LRsES5hQI/3Yiqq0HH5JBoZAc773IB5M+uz?=
 =?us-ascii?Q?H/kpnB7OqLTD12d6SSYz0DC5IHD0pTwB3R5FFp3q+Tf+Wg7gRHRimfZX9S7s?=
 =?us-ascii?Q?Of2peVc1GAdLiOu/sl2DMGmIiRFmkr92+0mXErdLuwFv7wQdNLeihT4bP/M6?=
 =?us-ascii?Q?IHp0twEOjjwDFwJsVifjrW9mtcFCVHjUOUyDybZIQtQ2OR1I0O/PA2bNi8LS?=
 =?us-ascii?Q?8wQae2IUbJ53jRK6gMoD+74rLeC6f+N6CYQWnqqE3TrgH5xWWGssPe3emXY5?=
 =?us-ascii?Q?btf2mnV0CPZceW+k/vhNpm7DxltTmUQER+tzPJBiBq7Rvh4tCgy+OMq4oVNc?=
 =?us-ascii?Q?YETLSbrvy6rLPEGZJgXrshH6fQ2feYkr2HVLQV9qHf219N4AwKqff6xn5BtI?=
 =?us-ascii?Q?TOS3vhwBqstmFJjWK64rM1iHlZo4vun/NyeekBfPKS4vJtvqowwVR5zaHPiJ?=
 =?us-ascii?Q?0SGcRpXEQiEH0PgLfHcPOiftilWVyJ9i0OqzGbU1HdNdW9BwKWWVBh7hk8iL?=
 =?us-ascii?Q?DkpcAh8CL+K4TDFxSMelRca/yGfHbQ46iOm8QGYpo0DRDgqN7kEw+y44+s2/?=
 =?us-ascii?Q?c/A+HPRv2QBuL2sbYq6lWcgZZK9EobcIBQJbh60cHMlOtgCmHXtV7ilHOobU?=
 =?us-ascii?Q?ezH7xX4fyS+XnJYshkkLLdkAJQDeZFcvPZ2U8st6fIqM40VtX0XIHkP3NNWr?=
 =?us-ascii?Q?gmDobOTtBYmSSlp1uGeHWkWslIB1wU9mlXZ4Y0iDB6GcNGDhf0kq+W1SFuNB?=
 =?us-ascii?Q?SJ2c8L4VNnBw7HOAx5aKKPU/gNNe6AqMZAbhl2gzMjCALMo1vVNOhn0sKzzT?=
 =?us-ascii?Q?BDzUhgvSsMuOxznMx/0cPpBCPkqqam8jJKCkx4Mf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b85da11-98dd-46d5-6d4b-08dad4260739
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 05:28:22.1236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fh/SCN9ID7+rr6zab3d863W/VS8JhbRjhIW/sM63mbqf81vg1Py8Dc3DPfqQDEHp4Ax9VETVKpwdQ7yb6bC+zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7026
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, December 2, 2022 5:10 AM
>=20
> > Otherwise what this patch does looks better IMHO:
> >
> > 	ret =3D device_register(&dev);
> > 	if (ret) {
> > 		put_device(&dev);
> > 		goto err1;
> > 	}
> >
> > 	...
> >
> > 	return 0;
> >
> > err2:
> > 	device_unregister(&dev);
> > err1:
> > 	earlier_unwind();
> >
>=20
> This is essentially what was originally proposed.  It could also be
> called a "mixed model", implementing part of the unwind in the error
> branch before jumping to the common unwind.  As demonstrated below,
> every current vfio driver calling device_register() follows a similar
> goto unwind stack as found in the sample drivers, which makes it
> trivially easy to split the device_unregister() call and add a goto
> target in between.

OK. Actually looking into other users of device_register() I can
see both schemes are used, so...

>=20
> Either way, they're equivalent and I'll take whichever version
> addresses all the vfio related use cases and gets acks from their
> maintainers.  Thanks,

... agree either way is fine. Since your version fixes all vfio cases,
feel free to include:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

>=20
> Alex
>=20
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> b/drivers/s390/cio/vfio_ccw_drv.c
> index c2a65808605a..54aba7cceb33 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -199,8 +199,9 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
>  	return 0;
>=20
>  out_unreg:
> -	device_unregister(&parent->dev);
> +	device_del(&parent->dev);
>  out_free:
> +	put_device(&parent->dev);
>  	dev_set_drvdata(&sch->dev, NULL);
>  	return ret;
>  }
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c
> b/drivers/s390/crypto/vfio_ap_drv.c
> index f43cfeabd2cc..997b524bdd2b 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -122,7 +122,7 @@ static int vfio_ap_matrix_dev_create(void)
>  	return 0;
>=20
>  matrix_drv_err:
> -	device_unregister(&matrix_dev->device);
> +	device_del(&matrix_dev->device);
>  matrix_reg_err:
>  	put_device(&matrix_dev->device);
>  matrix_alloc_err:
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 8b5a3a778a25..e54eb752e1ba 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -1430,7 +1430,7 @@ static int __init mbochs_dev_init(void)
>=20
>  	ret =3D device_register(&mbochs_dev);
>  	if (ret)
> -		goto err_class;
> +		goto err_put;
>=20
>  	ret =3D mdev_register_parent(&mbochs_parent, &mbochs_dev,
> &mbochs_driver,
>  				   mbochs_mdev_types,
> @@ -1441,8 +1441,9 @@ static int __init mbochs_dev_init(void)
>  	return 0;
>=20
>  err_device:
> -	device_unregister(&mbochs_dev);
> -err_class:
> +	device_del(&mbochs_dev);
> +err_put:
> +	put_device(&mbochs_dev);
>  	class_destroy(mbochs_class);
>  err_driver:
>  	mdev_unregister_driver(&mbochs_driver);
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 721fb06c6413..e8400fdab71d 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -717,7 +717,7 @@ static int __init mdpy_dev_init(void)
>=20
>  	ret =3D device_register(&mdpy_dev);
>  	if (ret)
> -		goto err_class;
> +		goto err_put;
>=20
>  	ret =3D mdev_register_parent(&mdpy_parent, &mdpy_dev,
> &mdpy_driver,
>  				   mdpy_mdev_types,
> @@ -728,8 +728,9 @@ static int __init mdpy_dev_init(void)
>  	return 0;
>=20
>  err_device:
> -	device_unregister(&mdpy_dev);
> -err_class:
> +	device_del(&mdpy_dev);
> +err_put:
> +	put_device(&mdpy_dev);
>  	class_destroy(mdpy_class);
>  err_driver:
>  	mdev_unregister_driver(&mdpy_driver);
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 3c2a421b9b69..e887de672c52 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -1330,7 +1330,7 @@ static int __init mtty_dev_init(void)
>=20
>  	ret =3D device_register(&mtty_dev.dev);
>  	if (ret)
> -		goto err_class;
> +		goto err_put;
>=20
>  	ret =3D mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
>  				   &mtty_driver, mtty_mdev_types,
> @@ -1340,8 +1340,9 @@ static int __init mtty_dev_init(void)
>  	return 0;
>=20
>  err_device:
> -	device_unregister(&mtty_dev.dev);
> -err_class:
> +	device_del(&mtty_dev.dev);
> +err_put:
> +	put_device(&mtty_dev.dev);
>  	class_destroy(mtty_dev.vd_class);
>  err_driver:
>  	mdev_unregister_driver(&mtty_driver);

