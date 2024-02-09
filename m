Return-Path: <kvm+bounces-8405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA0084F151
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:23:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0776DB28DA1
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023FD65BC8;
	Fri,  9 Feb 2024 08:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WwB8zcaa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402DF65BBD;
	Fri,  9 Feb 2024 08:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707467021; cv=fail; b=Np8Eb+4DwZ4X8HJb58rJvfqkoMjPmaaljQDoLE9+RNIZ0nLulC6KScyx8vFw5VSZmUJG8LMMU2wS8A++VUh/ogQdFkzK6AkqYXIZKp1Z1q9ngN+A54RPws7BptcDOXOHR2661LhP0G7mgx8A3cRN7tytre2pFCunS/oRaqTByIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707467021; c=relaxed/simple;
	bh=yukOc42m6UvOrkxk9qdZmemjJkC2HkuSIrOG8ZBvG/4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HzTWKIMYqpim/6/sZccsoErKSRed3jbHiXr3jSIIw/v0hIc0PnrBI8DpvsACILB7ME3KFmpiyapau+zxoEsyIcOShQ5NfDgkpuyD0/ZYAMrl26OJrhG5++W+4KmFy+pG9wmxQ5ohbWzZdQk1Yhe7hubGitEcoSRK9FH4rejYDI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WwB8zcaa; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707467019; x=1739003019;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yukOc42m6UvOrkxk9qdZmemjJkC2HkuSIrOG8ZBvG/4=;
  b=WwB8zcaaXtnUtTFI6P+h9pGxtKrwOzoIt5vg3juBTWRClscA8MDTjdC3
   R5QzL9CXiJfrlMfV8MZuT2ORXSaH4cwAjiUTVOWah7bwjfMGcdesHDR6O
   vZUZVnuStAep8VJERrmvIAwXf0j9Dx7bVDw0sh3rPWVLc06fMI/fQMYqB
   dISzHlkTH+uFkhA7hhKGZpt+off+z52x1bc0gfHPvlS5R01hWSHwgPl3P
   LagFT96v6HA0ku9zgpnD8Q2ZRdVPsUek65egmZmmQL0AZdn3sLaM9xWCz
   HLHUrVIrYmQjS8AM6nJbpcU2D84c5rpfU0X3xLhHQoC7v3bMwk9fKeQYx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="1543374"
X-IronPort-AV: E=Sophos;i="6.05,256,1701158400"; 
   d="scan'208";a="1543374"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 00:23:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,256,1701158400"; 
   d="scan'208";a="2105017"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Feb 2024 00:23:38 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 9 Feb 2024 00:23:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 9 Feb 2024 00:23:37 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 9 Feb 2024 00:23:37 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 9 Feb 2024 00:23:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fr0q2g/6gORTJG4DBDI22wY5UBVf2rM9i5w+w4rPcFWtFTKXoPDj/LPKtRJB1DYBjy2nBujlzAjXOg1CC7zKjQ10gYWtnIQVrzZnQe66gFWM2atTJ4/Q+Cxl64VuactYCeUqg/qRhaZLfOUOLGc9Cv8SJ+oFHVolAoLSX5fKScTQqWxvsWgU220dwtDdjAAqM8BPJGuiFcrUx0AsqjdvTvFefDN3wWr4GEae4g9ws+u69jRAnqEEmX8SqLpkTFyXnLNpR+dGQDtBt3wT8IwcfDjSjLS05CWMCheyUVYPvIVlG/Hjj1r7clptxnahltkmnNtYZ0ifXje+SZpywSE5kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rsY4DXBU68tlt63mUmOtDAGaNJZ03YuEtIIBXLYiIJw=;
 b=E+aqXyeocF3xzqt8lUZuF/yIWn+rsiUHMTN/byNvOJ+FPyVHpogvK90F3oEu6bP1aB7F+hsLqyfZP+ooZGjgHf/ufCeh2VKzg5bBUJ8zrB5sjJi5nNKM3mJGrHG+ILVY/ymVGjKOxDgjXj1spZtGQv8SpMEvRH5vkRbfGsgC5Ew+c3rrTXbzMlfm6+C8I35ohGiL9VaWRH5Toa7r8LL6NZlaXLdOAjvLbaGm9/tGwkxQKLy7l2DLL2BYX7d4KwcQZQWP+KKcgDv7g72eo+vJRdF7P9zME6YhT8WEUnOFNzTQKmqTrvzFaeI8TXlPkKqjabH+o0P2gjnGKjPSm8LrRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by PH7PR11MB7499.namprd11.prod.outlook.com (2603:10b6:510:278::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.24; Fri, 9 Feb
 2024 08:23:32 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::3987:8caa:986e:6103]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::3987:8caa:986e:6103%3]) with mapi id 15.20.7249.038; Fri, 9 Feb 2024
 08:23:32 +0000
From: "Zeng, Xin" <xin.zeng@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Topic: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Index: AQHaVSVFJ9K0TVMQD0C9btTtb+JmirD9TRgAgAQ3vqA=
Date: Fri, 9 Feb 2024 08:23:32 +0000
Message-ID: <DM4PR11MB550222F7A5454DF9DBEE7FEC884B2@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-11-xin.zeng@intel.com>
 <20240206125500.GC10476@nvidia.com>
In-Reply-To: <20240206125500.GC10476@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|PH7PR11MB7499:EE_
x-ms-office365-filtering-correlation-id: 5a1ecf9e-70e5-46a7-ae21-08dc2948672f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5GsyQuD6ykdwsaEe4Q9tzPbsXDeedwFtV8duwWY9q0BQWAXdgnmFv/h5EaQpvfEZzeCAnr5qfmWEiDjhQvAUolp4NNqdQEARRoAR2/czcnQJXDFajysKp+JFOCl6QcfSIz8OuhDntPlE3CXdw3kXhMu0rFikZIZYWaHAJzEDGsXIA6CkJeYSFRV+FPu4RjFyW6I/r28ibYuZ7Hz+RTK8GHmOQT2zzEZijRXm3U4J33AzYnhyAl139qnN+yXZRY9cJxGYjraJNz1Wv1WPlKPk8dq/EDgKjdBRdJs0H1LbrWmweqNJDxk5ZW2lCVAql7kQSkOe3J4PW8JjCoLHJaHmvlzw68N7I776QDy4z+4n8/zG6HraD9Ox2kok2ikah0xDnrJZpIhMkt64xRLGGtzLYFgu3OXWo2Ph0J//TSA9YuPXRbVQxta/zcdkZNTmyTSYJ5A65deEC6Zl6JCpKV1vH35YpCR9XPFk4WRf/91yxEIsT+8jk1jx10VCwboKqUvINwz/UxVhjxOyGWVyLlUPnYV22mCW3tFzUl8usRtQ28mpAPiX2ZhNKvDJq5se+MAjIqtL+ty0QRB4aTR4dXkxmQJarbD/aQ248SxmNTF96lxlN6wALNKu1DfRLCB2bgwm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(366004)(136003)(396003)(346002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(2906002)(52536014)(5660300002)(83380400001)(9686003)(86362001)(107886003)(33656002)(122000001)(82960400001)(38070700009)(26005)(38100700002)(53546011)(54906003)(316002)(6916009)(66556008)(64756008)(76116006)(66946007)(8936002)(8676002)(4326008)(66476007)(66446008)(6506007)(71200400001)(7696005)(478600001)(55016003)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jag/xlm1FoWkSrSNiY6EoR0WVLdZQsg1VmN/tEwtX3TfmMgn4v+ypNrv/tUl?=
 =?us-ascii?Q?SiG0Mje1vaadD9WfBs73GEcgwXqATAGi6EC0ULlIu/p7OsbNl0QlGE44RQ0E?=
 =?us-ascii?Q?T0sJGaFMULUl5KiQYOq+uuojKjDZrUNf4TAbO2x156VQoizpx0B39RtwgSyA?=
 =?us-ascii?Q?jrfQpofxNTO+RSMwu7c9HS5rzTLruxIvjrUWIH3r3i1BP//QpqQ9ZWGMwbcz?=
 =?us-ascii?Q?uSr4zJ4KdeDMCNXH1ta1IahW/rGmpLCKDnIhFskzGB41VVPji3pETMMuHSqP?=
 =?us-ascii?Q?2MS9quA9Wjzcimow06CMVvoBj4iUtUHC0K0RQJbaSmLc4z0k2LXSIpgsPwaN?=
 =?us-ascii?Q?DWRUjBaVMAI3Cex3zKge9Ot46bwO1+spar3JB2d9QuU5jfdcrYnObQA87Kg+?=
 =?us-ascii?Q?Cs0JCRnU//7ZkajWdRHrdIlmGNMFQkOZfupG2dnQ2VTui4kT/YlbDatysoaM?=
 =?us-ascii?Q?AST8FyNl1Kfxy9oEYXjVbALIPeJLexxnEAQ/bDr6szKjuxafBDcQ0ZYWhGKd?=
 =?us-ascii?Q?Ft8pPHUwukWlZXQ7CL78/du1W+v/Fz+eY7H/9cZfWT4pxQzfos/MBauIz/Ck?=
 =?us-ascii?Q?Rxb/YYZXCcMUbx7qiCyCr6kXnau0BSWKhcpdX25koz9A9m1bn5ep8Lw+/vB4?=
 =?us-ascii?Q?c+/yD5DnsTcbZ3b8uiSc+qdAPwGBVFtDun+NMK2vyuCUprYxylaYyAQ08qz2?=
 =?us-ascii?Q?X1GMBHUzVrIEwb3rGic3+ygXUWtXq5WSSwpMXo1Iloug2NPeGIMMEgtOgEK+?=
 =?us-ascii?Q?gV8iLMU/q1ymRRv5vSzaOPPGIw77CLhKJ1zw362tdSIBiIEOgvyozMh0CJ5J?=
 =?us-ascii?Q?zBJ1qYMCgSK7pc2ZTYTcSXpoTM7zV7fxjoWirhgAKX8Yx5moIGSYLfRs3EnE?=
 =?us-ascii?Q?BMLUAucpsdTgbHS9eU3BGW5wpNB25ImrRCKhO4wnK1TzJdNgkjNGMdDojH9N?=
 =?us-ascii?Q?ALWwaZ/9dajezF7SYtcZp7ss9SiQ5vqfB987YgoPU15QbZmreCiwiqwHcnQx?=
 =?us-ascii?Q?aJihytxbQ9AZYtibOjHHQpHQGGsPJmwapkgKlY/aY1AgVGLzh3gqZBLMtXET?=
 =?us-ascii?Q?+iqyzAnfBbBE2OTUMXaxFOvcyK1fBlPye2zI9k5h5ZNULMVFDCyJ6XiejkQT?=
 =?us-ascii?Q?8Js/sy9iqmtyrqJuO9B70AgIiNEuubqgclz56TZpeLo1jTAytfaWyyXbU1Pg?=
 =?us-ascii?Q?T0QGIpt9BO1zVK93ley4coANZP5Slr84bviUPS8PNQFipuDaQ292DLb0PMrD?=
 =?us-ascii?Q?dm4ugRYILTXUVrQjeArgiznUIFN2uH0s8xKMNaSQAp7inzUTmbqdmxVfSN37?=
 =?us-ascii?Q?qfZP9jNvaUi54c/bk29Xj7q9pT/fWi2JdXwRSRuIQjTGe1wSocN/q7nrsFal?=
 =?us-ascii?Q?jlXOCupUVG6oAxBsopjFaoerL9PmB5LevYxl5CXP8fXLTJ8SSL4u1PpMsyBh?=
 =?us-ascii?Q?W3zOcAVr46XgJDtntP7+0FWQ562LCNV1a3N5V7QlcuuG2stFWUWNeSWwupZs?=
 =?us-ascii?Q?n8Jj9V07OGvBWelNKCt/MJK12Wx+7s+1CJS32PnuAJEug3MG2VlZMg1bAxBh?=
 =?us-ascii?Q?2PuZQiulUQXpxkrha3HBj8lCjMZx+oFJqgXSRof6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1ecf9e-70e5-46a7-ae21-08dc2948672f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2024 08:23:32.4787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yw3MXR+2PjQXZeYBX1V+CFAekv/zC7AKwNGt2cfRNPcy17ALOwvdkUTpGKxiB+NcCU0mOKhuU2J1amwJJJyyGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7499
X-OriginatorOrg: intel.com

Thanks for your comments, Jason.
On Tuesday, February 6, 2024 8:55 PM, Jason Gunthorpe <jgg@nvidia.com> wrot=
e:
> > +
> > +	ops =3D mdev->ops;
> > +	if (!ops || !ops->init || !ops->cleanup ||
> > +	    !ops->open || !ops->close ||
> > +	    !ops->save_state || !ops->load_state ||
> > +	    !ops->suspend || !ops->resume) {
> > +		ret =3D -EIO;
> > +		dev_err(&parent->dev, "Incomplete device migration ops
> structure!");
> > +		goto err_destroy;
> > +	}
>=20
> Why are there ops pointers here? I would expect this should just be
> direct function calls to the PF QAT driver.

I indeed had a version where the direct function calls are Implemented in
QAT driver, while when I look at the functions, most of them=20
only translate the interface to the ops pointer. That's why I put
ops pointers directly into vfio variant driver.

>=20
> > +static void qat_vf_pci_aer_reset_done(struct pci_dev *pdev)
> > +{
> > +	struct qat_vf_core_device *qat_vdev =3D qat_vf_drvdata(pdev);
> > +
> > +	if (!qat_vdev->core_device.vdev.mig_ops)
> > +		return;
> > +
> > +	/*
> > +	 * As the higher VFIO layers are holding locks across reset and using
> > +	 * those same locks with the mm_lock we need to prevent ABBA
> deadlock
> > +	 * with the state_mutex and mm_lock.
> > +	 * In case the state_mutex was taken already we defer the cleanup wor=
k
> > +	 * to the unlock flow of the other running context.
> > +	 */
> > +	spin_lock(&qat_vdev->reset_lock);
> > +	qat_vdev->deferred_reset =3D true;
> > +	if (!mutex_trylock(&qat_vdev->state_mutex)) {
> > +		spin_unlock(&qat_vdev->reset_lock);
> > +		return;
> > +	}
> > +	spin_unlock(&qat_vdev->reset_lock);
> > +	qat_vf_state_mutex_unlock(qat_vdev);
> > +}
>=20
> Do you really need this? I thought this ugly thing was going to be a
> uniquely mlx5 thing..

I think that's still required to make the migration state synchronized
if the VF is reset by other VFIO emulation paths. Is it the case?=20
BTW, this implementation is not only in mlx5 driver, but also in other
Vfio pci variant drivers such as hisilicon acc driver and pds driver.
Thanks,
Xin

