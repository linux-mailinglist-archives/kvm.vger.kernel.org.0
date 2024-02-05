Return-Path: <kvm+bounces-7962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C5F849417
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 07:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72946281F62
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 06:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E8310A2E;
	Mon,  5 Feb 2024 06:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ro/JkNMR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AAE10A01;
	Mon,  5 Feb 2024 06:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707116339; cv=fail; b=roYOFBIllmiXQX6D8XKUuinD82uEmPwUOgD7lnJvRSAtCjKDKy8oJrLANORGqiFDXtMo2HKg9rwBF1phwgT38zdl1cQ5ApRDwZbfXUj0Vb1pg41PrKj/lSUNQed29qTdOAFOkbYGiRbXtkwjW8MkSukNymXaderHoM+EIGSJRjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707116339; c=relaxed/simple;
	bh=vMCof7zbsmPRNA0ZOzcnxQkQdFxCP6cw5QTjK5PuzdE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aMsepcj4DuTjrdJOUSHalHgn47G3rCSk2wfqm/dhdfH8n7IktxiaGsy9hAuU11DSdgiyBvR4oCR/2EO9u5imMShUcWyX5HtXoMKNld15JdSfd0Bly+Aa7iohWeG1Om+aEYnlRZ400Qu9/+QcQP4RXXHYxJWuz3ilqaxvpCKBXyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ro/JkNMR; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707116337; x=1738652337;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vMCof7zbsmPRNA0ZOzcnxQkQdFxCP6cw5QTjK5PuzdE=;
  b=Ro/JkNMR0bD9WSwnCo6VtAP04HMnqKHSXfEshyEWuDm9YyWNQRH9nrxi
   UT38yvhsiy/klH2mjq75VW3x5Zlo7ieyJ0/otQQUOtGce6IZ9y/69T9SZ
   5P/kZipc9+zmQc3r8nDk/mnrSuyz2AJ85mGE0v/+u4OCOnOZviuYLqLaR
   jTS1LqvzAypbukW40IrqcuYy9Wude+42Ib/rFJRxcZsMBdPJiYGBRMoyy
   jjWhVOlhk3hhxMJcjWB51tsCj/gRFYzLhwrqZUDNsWz3QmtmASwI4gpdv
   rFW4rm3E9YXvokf7sTV5L/GJrLaOBYF4j146z03bSqnHNXT12a75Zrz4Z
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="11554688"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="11554688"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 22:58:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="844853"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Feb 2024 22:58:55 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 4 Feb 2024 22:58:55 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 4 Feb 2024 22:58:54 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 4 Feb 2024 22:58:54 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 4 Feb 2024 22:58:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXEMakul/L63VX5Yx6TuE07v7SYE6haDrt0ZeLNmtqp6kLehNQTEC0tcUu8u6MUnyDmq2odz7waPAqOfK/pVYcJh9fc9zesqEyPl9S9N8v20zB1wYxBiIVVp5zidBaRdXWy+OjqZTNIoJ3aI3bbEN5tgKFjHooxjCLbZEPZ8OsYee5kwwcWtdT1BtQ74v/7Xtybv+zk69a8f4naopK21hclJQ+5PZA6IDWl5hKr9AKiYPnmxsxRSytx+zOh3e+PK/oVCoKjvq28QJJ1/mocpjd4TyGzqH5bxJ9NY3+iQ6pzdk3MEuZsWSe3VqdYr1uuY6stYf/CwS0H+XIUYShANZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1e/354oLrt6Vd5D8ehfBOanI1BpLS/6zj9l0e9jn8Vg=;
 b=VnJVXtkgCzDGLYVyKnEekh9ld97yc4+Td1YRwJzBdbP3j3oShUSqjGoYGoLG25e3P7R+WNFO+QRs9Kl1tAC/zYIlbIOFiBK7rbye7TslBHLeFZEo7OIjLxqR0BL26lI/IEMAR0/LEExzjBHcor8yrY8rXND/WzsAlzTUer+yCuFKapN1PaJ+cNIODeO6aW0BsV5Rd37on0t1bzTeS0cQGBmks2zVauYWBwN7C99k8yRssHhEnyZY6p9RDVP6nAPD71sy8l4hDekiZXSJ1s2EPqAYUu3ZBB2kfMTDatkkWtUV1/s63m7wf8HsKPO9DpMXFjl2DN9RIUlFs6oCmAmAaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by SA2PR11MB4795.namprd11.prod.outlook.com (2603:10b6:806:118::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.33; Mon, 5 Feb
 2024 06:58:52 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::55ed:61f6:bcd3:9e72]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::55ed:61f6:bcd3:9e72%3]) with mapi id 15.20.7249.032; Mon, 5 Feb 2024
 06:58:51 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <brett.creeley@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "yishaih@nvidia.com"
	<yishaih@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH vfio] vfio/pds: Rework and simplify reset flows
Thread-Topic: [PATCH vfio] vfio/pds: Rework and simplify reset flows
Thread-Index: AQHaUIYcXfafP7iWiUS0/Oox6wrptLD7WkUQ
Date: Mon, 5 Feb 2024 06:58:51 +0000
Message-ID: <BL1PR11MB52712B162AE5FEC2E24614F98C472@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20240126183225.19193-1-brett.creeley@amd.com>
In-Reply-To: <20240126183225.19193-1-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|SA2PR11MB4795:EE_
x-ms-office365-filtering-correlation-id: 93e20388-26c5-4fd0-eb34-08dc2617e912
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZuaMsSEI6yYlYucjjBqNwRDbNfPzRBku74bX9OGlLZYNfgV58e9B2Zy4im+zir5mA3ZXSq4l68yznPxvfWu8PeQ/mPNiQ5vv9l/Rvw3/dGP52b/W4Olbi65iCll7h6Y+gZFUpRCRw5t8vFduTj6ylCUQ9GQ/IIdKamOrNcMZcJ579Hc+03JWmDVNkbl2B+cFlt9N0D2NlyGUgRzw/b4cISURx7i2dDGyaT9w2Z4d3YQmzk/NhYQqcZlyEk36KkcINfjoTTnL5WXzvhBizMCZG+pXAmwgn4dnk8uX+WTO53ut1cofY+OKU/+R9yVE+1XmMg5HCY4X1K3mSjAkGIw4kal4AcSgfKyv/+MKUbyOQQqrqJfAoLrCEE37wIHc4tfgUYYRXHeRw0qrbIoI9Yb7nEHjEciGSXn0oVlHMCsI+GkurePtzk2CiFaICwlLANR1iuE5aGA2jc8kWHs6YEfqokAiOsNXXX8LQGufVc09pMvntgPYuJFW8lxtgdkbpOlXBC+tNE2USmoABsGABc1Aw0Ot2HTZ6ALFV8PNY3fM4eW45wQP4OCst/8WsegERPkaoD1jRMY45Feu4swlFBayy1bfvPa7XIigzZATE3zTcLVpDxU35iZyZLnsL+G2zTo9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(366004)(39860400002)(396003)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(41300700001)(55016003)(33656002)(478600001)(9686003)(38070700009)(86362001)(82960400001)(26005)(83380400001)(52536014)(316002)(71200400001)(66946007)(66446008)(5660300002)(64756008)(66476007)(6506007)(66556008)(110136005)(38100700002)(4326008)(8936002)(76116006)(8676002)(122000001)(2906002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cxa1mYF/Ed4wW/uhgo9EqemgAQ5J6xVKRL3K0JxbVryb3FeN/ygR0XBqwxNe?=
 =?us-ascii?Q?lXeN715jjm078hh4lw8QXakfnN5sG/XczQz51ecc+ayvpaZPpbpqHiaZ+kSi?=
 =?us-ascii?Q?ZPpOPLgbCGmMQFaDWXxCR3DsqEDOwFFQzsiUNVTjul5Q4lh9oatfJtlmzCIN?=
 =?us-ascii?Q?yJYWjlSDNhHnrcxS+B3HeDBkfrblGrQpLu4R+XeqFJ+78vFqma+tXy5mnZx1?=
 =?us-ascii?Q?36zwCwjMcYZHNuZ7RuWAIXjHfeeO1OzfX9WgP0h5vrn965WWw/0/MDLeCggN?=
 =?us-ascii?Q?tLxW3BJ5a0xdm6dXsI4ycch8Qg65cANIMGtVEB+oyNnwL9BNS9BHAWpO5j3x?=
 =?us-ascii?Q?/ITsy00MFoh/6IxJBONSTAyuDukpdjHvfkg4shdC+BgruHTXcgRj6fBANQvl?=
 =?us-ascii?Q?kI7Trys6MMi7vUL6/uBSV21EXPo0IMOZ/b6iGfpZIsPwZTHuua/NN7PqNNp2?=
 =?us-ascii?Q?QOSeQ4n9+J3LEK1TBsjBO3X8WqUENjHDvMKdzpGBzHcyqajE48URM984tzNY?=
 =?us-ascii?Q?9StQ9gMuVE6KiujcwxGYNPssfe/BPlO/ahEorHDmAbEuK4ZaROuH9PyDfALZ?=
 =?us-ascii?Q?n0imsu5UyU6t00IJv1jPFDbaNtiIHRWoyGD4KLQb10GfvooxJdYPsSDrfgN+?=
 =?us-ascii?Q?dpjxlu0QxS5+Xmcp5B10KTi7I8YrRSsnplKFMLbaUeGjW6J2oRLFCib3yOHR?=
 =?us-ascii?Q?r/KtWLwvZGF3fwCujHR6cR8OHFKsRD3i9Fe3FdLfPvyxz6dSv2rq4M3QYB7J?=
 =?us-ascii?Q?Fpg1pcbAvjK0kuOTbCeUrSrQoBrKuR5iLWzRU5Gr6r9snI6a+jCKXKWKgQ3D?=
 =?us-ascii?Q?06s18cwUof72h6gNcPlApVUpFeY8pYG6Ln+INshNUDRwyAK5LDVPHnx0QhL+?=
 =?us-ascii?Q?27h185Q/IG7klgDB8U4IT7/ngE9JBgcvs3l9nGFszKFB4v/80PHZZfBJUfWI?=
 =?us-ascii?Q?Nmi++Awa0Klqrib80s6GbTDxCeu1UVguSEsvI+LOzTpEddfXl1xAHqbKrFP6?=
 =?us-ascii?Q?VAwQl7YOSCoN+5IQuzueIC0hmxqWNFFAHKj2JtIznWgrzDAaLjwZ28NmflL0?=
 =?us-ascii?Q?VMYhp05kaHD4f8lX+gCxtCkWIA99RC8wEJ0TkQ2mjABf80aBxPnTxr82Z5Sb?=
 =?us-ascii?Q?ivHmprjJ5lSP+WEzx1WJAjM8Gld979DFxMZJ3MEoQup3paA7OWVXMGWyhJdO?=
 =?us-ascii?Q?up5fvgCl/RitZcPON8ESQ/YdPUg0yXcrjiBibAmdaXVfxkwYFDyLcmtyUp9E?=
 =?us-ascii?Q?AVc9HthbY965MbtdabrOlSYJAMjxhypHEc5euA3Yoz2rVpwYntf4qaVeEe77?=
 =?us-ascii?Q?gOEeuLzeKj5ps4hFgJ4wGJCocXr8wrzh5hcSg4QiKKYL+oKsfPdFD8b0WDxn?=
 =?us-ascii?Q?Z0qV8Rit2GLOpv7czyCGbvXVa4PPo4VJZ4YWc86Uxy8w0bx8Nx47bnjx+G2N?=
 =?us-ascii?Q?JN2f1C01tX45wf5U4ELUVxYPuFJaDvF/oSMwS7AxsZBzN4HqZ68ZqegYKGbP?=
 =?us-ascii?Q?aQ8zxJpH7eGvRNevLiS4fABHjI90rItbedi/bgNdM5r56Y+H0xgFzsh87IsP?=
 =?us-ascii?Q?jqzs0UQHYFWEcc9VqUbtUUTimzH03d+V7jV+uVkT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e20388-26c5-4fd0-eb34-08dc2617e912
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2024 06:58:51.6120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hzwhZbtCdbyKE6cDJ4JZh8ouLo1lNpZxNfPJ7CWxVjs+rq9o2I+WG6x+k4QpFXlJycmsvGbo9ByACyGVrODUsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4795
X-OriginatorOrg: intel.com

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Saturday, January 27, 2024 2:32 AM
>=20
> The current logic for handling resets based on
> whether they were initiated from the DSC or
> host/VMM is slightly confusing and incorrect.
> The incorrect behavior can cause the VF device
> to be unusable on the destination on failed
> migrations due to incompatible configurations.
> Fix this by setting the state back to
> VFIO_DEVICE_STATE_RUNNING when an FLR is
> triggered, so the VF device is put back in
> an "initial" pre-configured state after failures.

any reason for putting short lines (<50 chars) in commit msg?

>=20
> Also, while here clean-up the reset logic to
> make the source of the reset more obvious.

as a fix the a 'Fixed' tag is preferred and CC stable

also separate the real fix from the cleanup so stable kernel doesn't need
to backport unnecessary code.

btw the commit msg is not clear to me. It says fixing the problem
by setting the state to _ERROR for the DSC path and to _RUNNING for
the FLR path.

But looks it's already such case with old code:

pds_vfio_recovery()
	pds_vfio->deferred_reset =3D true;
	pds_vfio->deferred_reset_state =3D VFIO_DEVICE_STATE_ERROR;

pds_vfio_reset()
	pds_vfio->deferred_reset =3D true;
	pds_vfio->deferred_reset_state =3D VFIO_DEVICE_STATE_RUNNING;

pds_vfio_state_mutex_unlock()
	if (pds_vfio->deferred_reset) {
		...
		pds_vfio->state =3D pds_vfio->deferred_reset_state;
		...
	}

it's same as what this patch does:

pds_vfio_recovery()
	pds_vfio->deferred_reset_type =3D PDS_VFIO_DEVICE_RESET;

pds_vfio_reset()
	pds_vfio->deferred_reset_state =3D PDS_VFIO_HOST_RESET;

pds_vfio_state_mutex_unlock()
	if (pds_vfio->deferred_reset) {
		...
		if (pds_vfio->deferred_reset_type =3D=3D PDS_VFIO_HOST_RESET)
			pds_vfio->state =3D VFIO_DEVICE_STATE_RUNNING;
		else
			pds_vfio->state =3D VFIO_DEVICE_STATE_ERROR;
		...
	}

looks the actual functional difference is from below change:

> @@ -32,13 +32,14 @@ void pds_vfio_state_mutex_unlock(struct
> pds_vfio_pci_device *pds_vfio)
>  	mutex_lock(&pds_vfio->reset_mutex);
>  	if (pds_vfio->deferred_reset) {
>  		pds_vfio->deferred_reset =3D false;
> -		if (pds_vfio->state =3D=3D VFIO_DEVICE_STATE_ERROR) {
> -			pds_vfio_put_restore_file(pds_vfio);
> -			pds_vfio_put_save_file(pds_vfio);
> +		pds_vfio_put_restore_file(pds_vfio);
> +		pds_vfio_put_save_file(pds_vfio);

above two are changed from conditional to always.

> +		if (pds_vfio->deferred_reset_type =3D=3D PDS_VFIO_HOST_RESET)
> {
> +			pds_vfio->state =3D VFIO_DEVICE_STATE_RUNNING;
> +		} else {
>  			pds_vfio_dirty_disable(pds_vfio, false);

and this is now only for the DSC path.

need a better explanation here.

