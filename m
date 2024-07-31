Return-Path: <kvm+bounces-22722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6267F94260C
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 07:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D7AE2848D8
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 05:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2767959B71;
	Wed, 31 Jul 2024 05:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gwl4CIkC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8D719478;
	Wed, 31 Jul 2024 05:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722405349; cv=fail; b=KWFyXMZCo/xvoiVJszErazARcpJqXyrq/xPDTjpKOqmabuP+M2lIkWP6zxadRetoMlqeWebGmicN+Aexb6n1EGRcmSnqM4HH0QlB7hTOlxyUnAKXwQjH6cm0+mBGJKph4o1SdTWF9uaUbS7rro3YIarDpId+FWioTuYeZnMSu2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722405349; c=relaxed/simple;
	bh=ylmjs5NEjeP5IW1mL1n9mdap33J15G6fqdhq/5553hM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=li1m24fnbIhbALpGi4Wvs/nHsMLIsx17tt1n9d7lr7avFsMM0NiMW+c2NWFhvKuo0GHs6vyQlor8dgPYwczeK+Igbw1eWe1nxA2h+jD6DEj/PTWITAqvTU9A/WZOT/IHmeYLM3T0ndjhxfqB3fmeAnMjmWJHZYtCDTGjLhMu+0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gwl4CIkC; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722405347; x=1753941347;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ylmjs5NEjeP5IW1mL1n9mdap33J15G6fqdhq/5553hM=;
  b=Gwl4CIkCtv9YqeidlO+C2dPwsnP+bc9/Ojxv2tzQJJSPeP5KoHcaHkRd
   +Xl6DHNCxrwK+up1kBbbQJV2+tou646+zUwTDfvAl0LIXObfLC7ohtfYo
   MK+NRA6voAlyEZl54fLRqQ7dowS9wPM/IZ1Nlfq1ldcGMPubDcmVdA/0+
   G6AgGQGj2/CERu81q4w5dd1HJUt0DBKwQv5/HEmaW96AhBu29s6qPusqa
   iPyzvNN7tGA0z4KnKT0q6iaFc6K+Pk9fiRi1dLk6xji/BcWu4NjB718gw
   4C4jxtP2EYVo1YJt7xjDtTRG5t01Bz6lA3t5OUE+ASHcxH4yEyatIAJpm
   A==;
X-CSE-ConnectionGUID: 2fHIET5iQPuuCKPLY957mw==
X-CSE-MsgGUID: v2BhWINPT6+RObkbjehzsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11149"; a="24024313"
X-IronPort-AV: E=Sophos;i="6.09,250,1716274800"; 
   d="scan'208";a="24024313"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2024 22:55:47 -0700
X-CSE-ConnectionGUID: R1EBTPgrQ5eu7JIySYskgQ==
X-CSE-MsgGUID: rOmHrV+bSLuKVm07GHDTzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,250,1716274800"; 
   d="scan'208";a="54447430"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jul 2024 22:55:45 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 30 Jul 2024 22:55:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 30 Jul 2024 22:55:45 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 30 Jul 2024 22:55:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CXo7tUjXPjRQhgPTrfYSPwnH/V7QcUxoZN174YclGtblyt6Lea0XJNyi9XwvD0WLfHLDOFjyiIfZffd0CsxeJKp6jA4kNvr/kmLLYlNCn3ccmkBnaH3PGUEY5ul7fTcYrkqkfNotAO/4PASZkJjZVycKKy0O2njVrfTDeo3voGpkc5xWqjxPVkr/JgKIs23EQMuSkghzFyph4AUHebthKVkUooH/kme5o9w3k5rJjjqC6DsfodekuVINWOdJG8rKwcsDo2IFZCIUb9F/ckaRmuI9X+jTgwxvdKank6EJBsX1IJBS9aNkNkZsDu1vJU5aK7ECRr3SdVxJvHWmU1Qqsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylmjs5NEjeP5IW1mL1n9mdap33J15G6fqdhq/5553hM=;
 b=G/vd3wM9DoFtFozLGHnPxxnDjAY3LTuftml8mUHHii/uEkBtIBbaNiWccpxwWMS9UWMZ+GdKUJA6kxt5KENXWbD14cCzQNSbly2b0fHax8HaQ2Cxwli0CqgvhgBeqY1aRHFCXQMD8JnHozZUntaW+wwRL8LvgRkAjwdpbcNU4eJeL96LzmjpKODCngOqfS8cavuo+MUej1gD5bjuABCcPweic1pd5H/PfJjzu6DcUAM4iDrJ9qERSOP7keB8cpDeMfFnZA81BQWSqEXuIA0Tkq+8sUWNrNwFhQUAGIjpd200O3iHHxK+Si3Ud220Ml6yW4WnkvGZTQC915qPkxN8Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6473.namprd11.prod.outlook.com (2603:10b6:510:1f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.30; Wed, 31 Jul
 2024 05:55:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7807.026; Wed, 31 Jul 2024
 05:55:37 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "linux@treblig.org" <linux@treblig.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio/pci: Remove unused struct 'vfio_pci_mmap_vma'
Thread-Topic: [PATCH] vfio/pci: Remove unused struct 'vfio_pci_mmap_vma'
Thread-Index: AQHa4D6DMUa8MtOvLkmHQ3ulw9iHQbIQW/MQ
Date: Wed, 31 Jul 2024 05:55:37 +0000
Message-ID: <BN9PR11MB52761C614BC8F09D6A1F21B98CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240727160307.1000476-1-linux@treblig.org>
In-Reply-To: <20240727160307.1000476-1-linux@treblig.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6473:EE_
x-ms-office365-filtering-correlation-id: e4db033d-09dc-43bb-6afe-08dcb12566c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?+6UOQO32LZy5R3T8WmpvzApUxMBIsymfmWJVH1t7ZpIKhfVCcb4bpyrQMC6q?=
 =?us-ascii?Q?PmhlescFb5m2NXirWS6T6Tr8OvloxB4Rfj66rkdpbitUHt58YAivKjJ0sTUQ?=
 =?us-ascii?Q?yvP/5wjwNsVyY5ChkP5aKH5ccDqNtUOnFrAxh5HdzrDuFzQpaqnKMGUuEouz?=
 =?us-ascii?Q?mVUXu9Jc9KHTPJXbS7hYFNKPu1VNnZXEOe0Lj7ybmXekB05fOIF1wnqlyDll?=
 =?us-ascii?Q?0sJUHeN3hFKeMrOZdcW8YqjBQmAnaGASLwoh4i5fyFpvS+CZpa+B9hgx0dJF?=
 =?us-ascii?Q?zHBuRKMCaW2iqc9nMiEUH0VC1e2X7QSQ3FRlGZF27h+diluQZAuQCQykz8iF?=
 =?us-ascii?Q?xwv2Y5LJ5ZKzErnLeYs+sx+N85+qMAWkUY9cR9XcJR0brNWtb8F0kgMIHXmS?=
 =?us-ascii?Q?Ol2FJL2vsy/KaO5f2BOk/dcztq83+JUaYHpo+y6fZBbAT1/Tki/XPYDKI+HS?=
 =?us-ascii?Q?aEwfRRZ6WScfviJLdbYWaZUJp9vLCY61lVgx6jnJ7EH3EFJ8aL+8NSO1oqEs?=
 =?us-ascii?Q?mDEu+wFnREBoelRYNitLU74/qO+wD9T/3JXdq4IPswzkvcvPwaqITL/pUO6B?=
 =?us-ascii?Q?n2oAXtnLhqfFr+fc4OmArsu5GikAXBKK/eps5sAN2rPYWpeamrhzEqpps6r8?=
 =?us-ascii?Q?55wNNd0LXZVQlWLEKYfEs+YekyuGghb6V9wmOPdEFMj4eC9wfOrfFXzpJFQX?=
 =?us-ascii?Q?hgKyoTwFyzu6Y5WWCFSF5RpBt+xWno73eC+apZccXHNoGOAp4rNDYaIKIhDn?=
 =?us-ascii?Q?ausHTOxktA1YgOQlvdKJXNs7DKsaUuQaxa9vDptl/7xcjKZh8yOEiCxAKu12?=
 =?us-ascii?Q?7KXfKf44LNP6jtHPyD07JRFn1cIzNeO6O1YZuD7s6dTHynZ8TOorBQLoPhAB?=
 =?us-ascii?Q?oo8IZRkm/ULPoO2EqS7j5hf9HX53WGc7w7xDfF+IUGxufz1gg0SEY1vwuZG7?=
 =?us-ascii?Q?udLBndkbIluECKHXxzd4uvevmq9ZMqmJBcFcD/M+V3FfGy0yLtQhLu3Ktqfq?=
 =?us-ascii?Q?rd9wjrDvoi2hPcDlFiThp584kOeWW84vlmxvfQhetU4ibDOX07OrW7BdQc7g?=
 =?us-ascii?Q?9ZICfdh/Y1sJxX1KxUeBf213VAKdvrgkcEAaoBrDPaicaYV4ilRA1h6Cmu62?=
 =?us-ascii?Q?dY/LjbGsXIfB2vzmq2cMwyWFdg4m+WBX1MWl4khnN9B5zL7+RKKyznU39odN?=
 =?us-ascii?Q?UOfAbvRDlMYj90w5gEjyI0wLmgMU/ZOsfn68TWsXc6IjseKcnzhB53cve5GM?=
 =?us-ascii?Q?+azWk+SKDmQFSPpx6K28OHiJgAn7pKzo7P+uZcANYthKo63BHO6mRTSOTdC9?=
 =?us-ascii?Q?Z7G7hSHVPwf5adJWxYe5D0ojAZoA2KLpB14llohuyLJa6uLDhodMVMiIoQS/?=
 =?us-ascii?Q?MfO3zvtxW2KWw6E9GgXAd/tWgEtMs84fOWjm2wXxcjfTWcP+Jg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RYN21Zs8cQ/X09IbN9k5Jk3PDwIuiJFSxbQ36tB730GOaPei4eGdHE6KY16W?=
 =?us-ascii?Q?9l5VyKXdzYjU8CqTUY5vJ1HwO3SxUQ9VGyn3o39oKpREFCVfCoW0x/YvJKC3?=
 =?us-ascii?Q?fkWIbjUgPM94RyOBWzm/SzdluYP+HaBmShuCK8PJmW/B9pu+o2PsVV2GRngj?=
 =?us-ascii?Q?m/alPfor4IYj2SJKtM1XSFPulT+sa4LDdYyTWpjHAbQk10hd612F0yl+T3KF?=
 =?us-ascii?Q?866ovwMjNa8AxoxnGQ9J9UbxvSiVPsUMVJR6G2k5DObonFoI7crdWkrZF31z?=
 =?us-ascii?Q?h5gE3G60lYPLAGrxF5YHS8jg5ysUzQVhzA2tTCZQQZA+talE2bZKmXTmRYOc?=
 =?us-ascii?Q?/4tPcOEA8/qPvqN5pJxkLDt2Lx6f50GN5ZJULoALCGU9RSg046/neBsyQu4u?=
 =?us-ascii?Q?eEkKr0l3FTziwU2C/in1adlT7CAqdEGIHIz03vqvXXjDJKYncpV4SqULPWMP?=
 =?us-ascii?Q?dUtJGVzi1NBc2o2SvU2Joo+HTlO92GbkPoeM5NY8c40BW7cu0Z63HIMiNshF?=
 =?us-ascii?Q?tgalVTjR5DUC3Oxwd5ebBRBq4VNSEcoyO9k2hxpxZFpNWOfnuAa6sjB7T3Ms?=
 =?us-ascii?Q?V6muhar105hA5KGFg/te6II5H85JlkUI4vhE1oJ/cZ8q6rpbg+rtUrs6oxKv?=
 =?us-ascii?Q?DVDKQvPia5YCNBjgdgsSV6YlGLvp3+/Rx1Ttd6UPYSQtGES57reBbGmeZkmc?=
 =?us-ascii?Q?DYCn4w0Jmoor5XayeSi0K1GyQDj7fJUJq0SodbXPhxSjJqPzpjgmvBTAHqDv?=
 =?us-ascii?Q?yuv83xefWhNPSVko+9vP7SvyX/RskhZ+xbuKbDCKrfIgpT6F+eD4LJmDeb63?=
 =?us-ascii?Q?7G1nZcfBv0MB5UlkQqBZZDmdnUARb0Vhazp6+7PQ9uL1sTAF6w637NmsRMlH?=
 =?us-ascii?Q?7vL6kp8UNDx8Qmg1PI/PA220ywgjgfVccYUPB/SfR3Ef5/z9YP1uwNSCb4NE?=
 =?us-ascii?Q?bfYGnkTRpQlQZTwI/NT5u/CjCluWYyDG+d3pLtxXo1FyPBq1e0sxd7kTAl/c?=
 =?us-ascii?Q?Xebs7i1e3DqYNMCNsYlDsuVSgc8nleJEU/CB04dLqgLF9kqFoxiyE/iWEOi+?=
 =?us-ascii?Q?dDCe+5IM1+2srRvVnZ9RtLZKqIL/5hIEZjjsyDke6ZwthZwLDx1+c7PjqNmG?=
 =?us-ascii?Q?dgPyyUN2UcVV3FyHwdwWhfLGXWseJhDIZxr+Y8EwIlyibm3QgpK0pDjiLWxM?=
 =?us-ascii?Q?F4GXsT5OuRQ9T00ck3MPXIV8EhGd4wLr1DjywR7MSiBAmG7Hq7gi5cABi7m8?=
 =?us-ascii?Q?MSBWTWoAlsalQWoQgXP9X9ADYHv7JaHqifLrXpSBBiSvdkbdTG87xOnZ7xVo?=
 =?us-ascii?Q?9I6ca+ZwHd4tgYaqPePQiK+M127yyD35ShZsYsBLbTviajJ9BlVG50Kl65zl?=
 =?us-ascii?Q?7jpvofKAi9S1KtkJek2fAnGyP8ZGS3X8q2wguII5vi5YoczBUNqv1khXGwid?=
 =?us-ascii?Q?JfDPXIYFMIRtqt1V/JVGlry6e0oBUl335A/cGbMOcpO+FvKyexUmfi+Dvg5W?=
 =?us-ascii?Q?EPtO3a9I6EKUTkAsAtlfHQerLNs2zvfx3caXwnCgQeRLMpKp0PphJ7Xqxj50?=
 =?us-ascii?Q?KOfLkYozbofQcGFY5s5X77HmZjCcdEaw0hR6MvzS?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e4db033d-09dc-43bb-6afe-08dcb12566c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2024 05:55:37.5860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rUYpS1tqsHkuZt5vLOC9clYlrHc+leNXWFecw+9nrHbkrT5t9XmrWXBKLeeacOgx/Jx0e6a57QPukeB5VBkswA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6473
X-OriginatorOrg: intel.com

> From: linux@treblig.org <linux@treblig.org>
> Sent: Sunday, July 28, 2024 12:03 AM
>=20
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
>=20
> 'vfio_pci_mmap_vma' has been unused since
> commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()")
>=20
> Remove it.
>=20
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

