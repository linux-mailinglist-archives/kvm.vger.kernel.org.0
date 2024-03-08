Return-Path: <kvm+bounces-11355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2133875E4D
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 08:16:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 120F91C21C3D
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 07:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DA74F1E3;
	Fri,  8 Mar 2024 07:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GabeAoxL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38AAE555;
	Fri,  8 Mar 2024 07:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709882171; cv=fail; b=U44na12vIBRczHjOlNZOrLLz8FTqkaUJpv6hUFPXJ64/YQxb8Vtr9E/k8UvboOjnm1PO9vX8wDMNivKxn9DC87uoto10U7eO8G2fZZYYjL1/4I6M13YHD3ciIr2QAFDfCQHs3ImuZT58QYtDjs9Q+inC2qs19C+PV3Wkhq5aIxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709882171; c=relaxed/simple;
	bh=D7iTM9wiBvLihzLMHGbdj9/rO7pvjNc3XXdkB6Uubco=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mQy/JAWcbnTWKMCKUSw9Vt2KMcOJQTjx+phEp9oBf8jhjXyM0RaKxfwZ66Uz3v45QqtWPQX8Tazij6xIPovBx7pLToGCvUGCDHdKQdZUi+Ecx+I0trELpIB8V62KRii3sPdM24UdpmHG3g820rFd1Fix/HFfK/Idt+bKe7PhE9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GabeAoxL; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709882170; x=1741418170;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D7iTM9wiBvLihzLMHGbdj9/rO7pvjNc3XXdkB6Uubco=;
  b=GabeAoxLXjgOcbSImKIucg31loVKShqnSz5LJSM0zqvgekzewA3OfjnQ
   7hTFkcEph7Q/pUMVCFdFcYOr+Ta79a8DVxSKxEZZROdSvzNhXP9LwgrPq
   Ziivwoc9wfzBpzZ3dIm+zeVAsfj/OOUNftjbm+Z5y8oBZ9kZuMEYK5Z6V
   UPbyQFtqnMqoRwAdGbansiyHxcWk9oDeAeHuBVYksiZY2KuOLh0+1dI++
   k9Yxk2RrWJVduDJjOYREzovcaLoF5KRqk+XIsUhnuVrfVbplCNbyM1vUF
   5MoDSk7wESuHVZx71BnTS0FbO+Aed/GZtnC7qLL3wJt2dwCg/JutGw6I1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="8345112"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="8345112"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:16:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="14942678"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 23:16:07 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 23:16:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 23:16:06 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 23:16:06 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 23:16:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHktJqmLe9vgJe+B53ZgPJQgT/5TnFwlJ1/Xh2bCgGguhJfvvk55NQQm7byLhl2dHTvGI6SVnZ5q1rMzApCWRuhxnLT1Xr8DomGK8NcBabZDpe9Aok4gQtg8JzL3DxieuoMnk/UVQDJCB6kLN0uZNUUa2Q1eqmPt+0sgUl0xVK9h/SvZ7ORgXIMxFeFRr02aBQTu3VkEdbUUApZ7GzmRGFcnhWN2lSdIUEjyAdGeJjvOZKFky5E9jguhBMzSP80nd9JRu6aFkSL7tbU8Qa9ZqsoYD8/IUe0NZQ7AOFh6xUZnQFesBaJn5uj3HVZ2/RgeuC8KfXzDkZXFXR40jQiB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OoOpZ5LQNoYexNNbWvfie5rsu5M+JqczkvdB3nZK/i8=;
 b=QeUwdNzdtqsqLwFL1hnH3OuUy6vFxjbGZW36u7URxYNYLjl0vRk8IDsJtLmhziRdLSHX/GvkBkX/lTmgTwjeotDUNH0uuKvAEbVxczrTE+tDpw5owXHqNKajaypky9dw8Nb2e9cl/ywS8xMWMKKhO/A2qy6vITnbBpttw4tW58d1dHz730oAKRLf9Ohf8JcFbbTleY9vFvtPFy6z6oiKOd6c1d5z4SDdOWnItzOhHDj8UOjEG4uxuBO+l6NN0xOLycRsERiN7gfgpa2Aby+rmCLTNXh1cLYnUbs3u9zcC7EF0hVXtVBzHNocv4VH79x/3aDieBIPzHaNnteYLtcYMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5274.namprd11.prod.outlook.com (2603:10b6:408:133::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Fri, 8 Mar
 2024 07:16:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7386.006; Fri, 8 Mar 2024
 07:16:02 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/7] vfio/platform: Disable virqfds on cleanup
Thread-Topic: [PATCH 5/7] vfio/platform: Disable virqfds on cleanup
Thread-Index: AQHacAtu5tHYyH9V20C+x77q7qGRBbEtcHPQ
Date: Fri, 8 Mar 2024 07:16:02 +0000
Message-ID: <BN9PR11MB52766BAB438D1D1B782243038C272@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
 <20240306211445.1856768-6-alex.williamson@redhat.com>
In-Reply-To: <20240306211445.1856768-6-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5274:EE_
x-ms-office365-filtering-correlation-id: b4fe86bd-83c5-4ce7-5ec5-08dc3f3f9c90
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yDW5HmnU21U2yMH2wmxELCYq5ft0RAfvxFkiWNS9o0is5lQU6DbOljha7br/Jfb9XRDAc/gpVchS9fJDS51t4W9Hbc8nxNdi02GdV5DrqcAoLzJN+drSobOi6zk0R4eUYazHnNHsITFfZtpe47882M78tOMTb8aLcTU+nASd/aAO9VdAGbwaY6zdnbAW9RH5n36f1koeShyplNlassXYYBb+gXufb7avJTgrRd0Y2uzLA5n/aM9E8Ntkd9O5465vHfaeaD3XapMfWDra9aS4AlAhGHCK7pz3fWEJVB/CfqpL4vOUhvWBDlyS5sOx1fZIrwFkjkjupKsJA5eRHpCBnujfaMuA9eHWzjshjnZqTsVHI74zgCY1ygCfthzJ6zdTzqwTScslBMGAdy0SY6KxwXoH9JmaZNuqh3kXbapB/4BlYjogz2hffUZCSt1Hdynd/yyVOoKE+rLZCkmLKUDjf+MD3+7diEVEflmQFS9Uj9G2RXXQWSYKQSpttGy69BhiFpoRRJEJv2yYtVzxh9ot4ssW2Crpp9md4faGUnlW7kuEzoqSG6tIWuZfuU8M1xT00iRf/snaPG3SLJXD/uVCv87RTSWf6JEKrBw5FdgdU0un8WC7d9qb+c09U7RGwpyFy4h3FD26NbCokTZJGTacmBGml4+garljyzDAcScvrwGGs33XJryz+sEAOID0U7YG2tXcNGkfAqJr6/a1+o7llUC2ej9zn0JdpuNehqYXfLY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0McVKWmZ+IMgoZsG0cjmfRILKuu404KlvX9kHewFUOucKV052qzitT9WgrI1?=
 =?us-ascii?Q?2Bj4jS95m9KWZ+U/Pnup072RcmwveanVHi61quiLleObx0+a1KnElb1s413d?=
 =?us-ascii?Q?a4VGCG0uv+J/CS3Jq6tz7zkFtedVXcevjh5FBt7GeDRrDdamIipA7egS9k+8?=
 =?us-ascii?Q?izjJ76q6hnLAOZTkdw1ylJA757NEtX9nz4wqdk3HWVom51AOLnkynwCQszBm?=
 =?us-ascii?Q?msMhbOBNjfPtkmYBqOuzrJcTCHHYZM7/i5vfM653GKFpFPL6NQZ7BUlEwONt?=
 =?us-ascii?Q?VXqA+8rimNsM3hfa84WIQ7wHV3nn6lLhCEpaIEOdWEIxggi/340JbDQFn9WZ?=
 =?us-ascii?Q?qWZrT6w0LFCoRyAUO+4kTJma3BGqcsdOBq3QCqzAeydLmj0B5+hAq0r/wdab?=
 =?us-ascii?Q?SGJpbWgratvgvWc2wOcPbz9cNNaNspFpXROD4y0mZ2eXbvfdUSUn3ZDu0G+Y?=
 =?us-ascii?Q?EQaaGlhUtxHf9nX7p0Qg2M4h2s2haF9TmylS/s4mX0C3wVUH15oC56TVmtt/?=
 =?us-ascii?Q?BY5Kql4k1Imx/pnwoYkqbkVcy5edqMES2TV/a9DaLd5SArOHn4z+C68nZhq0?=
 =?us-ascii?Q?mVoFsTYPURiTTkghd8fA/Solv6JZRnA0xfpcEML++1HfK+gYnJL4qNP5ax1I?=
 =?us-ascii?Q?z2LbCCtEYd05UECTxnbfPrM5VN0vtRkKx6qKFSokkxbwSuLoYhlJ6BpxY7ul?=
 =?us-ascii?Q?NYHtvWrxQ8nQxFTa0Wmiu6slm+VMm1oRPt8JRdnA3a+LjIZAnrJ+dzLdchDV?=
 =?us-ascii?Q?Eyrv7M3kmLpZJRurgRxulXpbtyazp61914/RvfY2Wbq/MJXaiCIP8QC+IJff?=
 =?us-ascii?Q?4/Jrh4zFOqrIoYy4PpAHQuZpcpMQaJeyDIKg9PSKclXvfs0aI6csXlgfBdir?=
 =?us-ascii?Q?rNcHkkZsVGtXJLEVM3KDNnWi/9MZ8yx0ciumcXtwd5KUQq8VKf9qMEcCtSsM?=
 =?us-ascii?Q?C5yCu+arxqI6D55QrvLUS7BRC80jg7RD6//uPybrzrtxJdHPBstlMoqRTd5n?=
 =?us-ascii?Q?KpaNwgrn5sCPUQxCVtcILxYA08heTIvelYF2Mdydcwi7pCAuQknKbTdbiK6g?=
 =?us-ascii?Q?Y2283BueQnPdWKKWsqafXl7mWiNKXc/u1FDLj7hn6mXKQBVyipslNTEdMHPP?=
 =?us-ascii?Q?JR+EZDydHRiqfS140QtQokVj2y1316Zm9IKfEK51W9iw7pRNevXLxvZm2Cwn?=
 =?us-ascii?Q?M+pG0RobSvQPKHAresNNRggMW4yGtFVGF2x1WvLjV7KRG7m0sNhleD45UkFZ?=
 =?us-ascii?Q?bGF1Sg/5XAJConhULpkz1FhhVs3GSJ8gxrrnODPgteM4eklCUav2A+hfz+g0?=
 =?us-ascii?Q?DughBUpxfzRtuRMTMUsyu+BruCEtTpD2tEHZpZMmGzLHIMyUTxtXsRmsFZ9q?=
 =?us-ascii?Q?2oamviMsCj0bTlCYImL6LBeaGfrgaLmy1oXG3GJ1YZit/k3AoIkA8NirdfJC?=
 =?us-ascii?Q?BNcsnzFDBK9fqfVgVwdI7iXqbhlNwkxZXA6+DVCDTbCdImUXmPApaIoBmq7H?=
 =?us-ascii?Q?rujFZghvXEn7YXkK74Ywh8xw/4M4RRrrNkzAFAs9dz4R8rJZPvf9wyqZ+5UO?=
 =?us-ascii?Q?FY/M/n1kvpy1BqQBCvRPUNYlu/HfY2YyX15/sX1/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4fe86bd-83c5-4ce7-5ec5-08dc3f3f9c90
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2024 07:16:02.1901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DZn78k+co/9EXMdY7Y5/LlMOm9YB4ITfpyl8mLL6aLGsS6NwXrlaVITuvA2h7lFyIfBWK4tBpi2fKykpCl1iBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5274
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, March 7, 2024 5:15 AM
>=20
> @@ -321,8 +321,13 @@ void vfio_platform_irq_cleanup(struct
> vfio_platform_device *vdev)
>  {
>  	int i;
>=20
> -	for (i =3D 0; i < vdev->num_irqs; i++)
> +	for (i =3D 0; i < vdev->num_irqs; i++) {
> +		int hwirq =3D vdev->get_irq(vdev, i);

hwirq is unused.

> +
> +		vfio_virqfd_disable(&vdev->irqs[i].mask);
> +		vfio_virqfd_disable(&vdev->irqs[i].unmask);
>  		vfio_set_trigger(vdev, i, -1, NULL);
> +	}
>=20
>  	vdev->num_irqs =3D 0;
>  	kfree(vdev->irqs);
> --
> 2.43.2


