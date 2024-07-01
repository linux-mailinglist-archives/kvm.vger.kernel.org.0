Return-Path: <kvm+bounces-20747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14DB591D5DF
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 03:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 358B82816FC
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 01:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292998BFD;
	Mon,  1 Jul 2024 01:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BKDya9Jf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD266FD3;
	Mon,  1 Jul 2024 01:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719798551; cv=fail; b=WgeN6Qbam10uKns+bugGvbk8C79BrTdjDHm8DpNGIJ7O3296+BQdi4w8ZreZIGqSj3TlCLiqGjOu2RHlxuXpnpJV8tR+ayeoyrZYuIBoY9TWnWQcULtYFKP8ZpC4kW9icgj5kG7dfLdYyO1kKn+x2ZtXw1dEYVbN9C4oF/ggNX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719798551; c=relaxed/simple;
	bh=vV33A6Gq18ml2mbAqBLCm6cx7t8uNpkb+QhJ+WFbc/M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kKNJi6V4im1B4142ZzXPHFsf93Qj+auj0rgB4X5oFDlvnHv7cbK+kNEQyh6BUncjZ4dfzCl9U/NAr2WqfFkz1o0i3AzXFUZRQv5GspVEyE0iS4gSk0jyyHBoIl6xEFtdQcDfbYFSnk51gKizDFpEoCTOhvt9Skn1mJkrZK9a+EM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BKDya9Jf; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719798550; x=1751334550;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=vV33A6Gq18ml2mbAqBLCm6cx7t8uNpkb+QhJ+WFbc/M=;
  b=BKDya9Jfd+HncELvaJYwRHTE0IdsWn6pjZV9sFs+BN22QmflEv7lM51P
   pgZHB4f5J1c+UhYFif0T3VEBqHQ44L0lgbZq297vt7MHheOdR039Vtx2A
   8V9Rffoyo01P/rlukzyLNrWQtLnpmc0qGvw347pQy1MU7nLkcmlRl6l03
   Qp/FoyHo1ONLONSXKAuLKztqNSQ9bTOW1dUca1sQNXwFKHzLUmSS3oNfh
   JcLMq8IGBe/Z/9G0gA+nB60pQxAHRUB/4pvdtW5WCUK7jf2eWSHdEVDaJ
   KLhzjcKnvLaQdUMGJyy9MHk4C+4JMNfRH252nKVw86VfcLMlnqXxECxcX
   A==;
X-CSE-ConnectionGUID: nV0/Vit9RVKX2UlRzIq1LQ==
X-CSE-MsgGUID: BtnxF3f5SNGns+y8aPvt8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="17033821"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="17033821"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2024 18:49:09 -0700
X-CSE-ConnectionGUID: NnLKcxFVRhqVULa7xXP3DA==
X-CSE-MsgGUID: MBMR4vasStaZpHg5kZWeeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="45761680"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jun 2024 18:49:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 30 Jun 2024 18:49:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 30 Jun 2024 18:49:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 30 Jun 2024 18:49:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fW+rB9bxk3S00I0FJaW4xlPl0P8QUekaA3LJraKgsp011e0rRwaHpfsUq9DHaxbnqOk0cwPN5nDg0v5094ESR6SiG/fY+QOgusbAHX3//HHl3KmQsEfK+e60Ah+LTlKO6B2kwAP/Te4b2P1p0vNLcujimvpr5BoNvXmiOUkdDOsU3hik4Oh5+/GAZnEfWMq5oUHDFrc1S6Sv5//o5PI0tFGnf6E54OQLuHJgOYIZPwdbrPWgolcmACk/MUyDuJYhoymiYQjA8nTKXYNf9qfs7nXbcTxxOc2Sotzt0SYVkq29UmG3UZKy99xLTDrwtyEQMG5i6QWZWn6/ngvk1gKUbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVYg9gymGGirA6nBwfY+jA/re78pAyOiYhZg0NToWho=;
 b=ffLoZZaRp1TtcPK6jMDLqZO2wls0lWe/QuNBcVonABk/Cvj28cwtn4Ic7qtydKtddPUw0VMcsKaCI1/lrPvLYBxMkEfH3aMJB5r6boE8SqSKqJDDYpZPulqNSwsYVsCQhIKt22VoxSk3to6rkXsKX40IY+BPtR3U8NFChxc6QipuEqRMebmH/VIpEzRr9MXIv4jog1X/r44UDDtI2uQ5umY+ZuwbCcYZAI+jb/OCHp3jiOICPG0SRVzWcqsZzzldPnpn3OrJBdDS9DTNVQfCf2P4RYtD8YlaTM5R9pABTqIHeasdp9zcMDHw9glwo7tjKRkmulKPNhNVH6a/MrA/Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.29; Mon, 1 Jul 2024 01:49:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7719.029; Mon, 1 Jul 2024
 01:49:01 +0000
Date: Mon, 1 Jul 2024 09:47:44 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <ZoIKwAhOkgkTYtyf@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <20240626133528.GE2494510@nvidia.com>
 <BN9PR11MB5276407FF3276B2D9C2D85798CD72@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
 <20240627124209.GK2494510@nvidia.com>
 <Zn5IVqVsM/ehfRbv@yzhao56-desk.sh.intel.com>
 <cba9e18a-3add-4fd1-89ad-bb5d0fc521e4@intel.com>
 <Zn7WofbKsjhlN41U@yzhao56-desk.sh.intel.com>
 <f588f627-2593-4e89-ae13-df9bb64143c4@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f588f627-2593-4e89-ae13-df9bb64143c4@intel.com>
X-ClientProxiedBy: SG2P153CA0016.APCP153.PROD.OUTLOOK.COM (2603:1096::26) To
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL3PR11MB6508:EE_
X-MS-Office365-Filtering-Correlation-Id: caf815e5-736c-4bf4-84dd-08dc996ffad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?J7tT5nwBt4HFs+StAzlaRSNOSYvgrRs1kgawfna67wjnxy5e4nqrlGA2UE+T?=
 =?us-ascii?Q?F+DNymrjC4lBs2Hfi//eEA7osGcfk9xNVtw+ct+ZTj4f9CRVn9HehHWg9TV/?=
 =?us-ascii?Q?JOdKkTnyo5sSwR9ABeoZyu17vIG76YwWAimsukwI7l5QCVgwAB37T/BSv3LQ?=
 =?us-ascii?Q?BMO2j1qX6fXEoZ1CMeWMimLHk3UbHzmIIyiVKkyKP6QjxPtwb3N2G5Cn+OVj?=
 =?us-ascii?Q?bjKEPmFyNIkC9zek92s+YtNYzyRp3BZ1F+Lt+3bV4cPnDJOEPBMQJb1gEuxP?=
 =?us-ascii?Q?+wsEVu7jM9Ot0Vjns+zKd8HjMRVccso4IyskziMoQJPlP6XWgn9W/OPP96kH?=
 =?us-ascii?Q?qzyBPnock4AUSCv0Z4g5y98kFna5D9PUSX8SAM/0WflWvsEgLyqvNHdt096h?=
 =?us-ascii?Q?xQUo3psL0uYZsn6m+Zxk9bNoHlxaKL/g+0TfdFKNMhBn0VHWtBpNJer2DJYu?=
 =?us-ascii?Q?zOGKrfnoLoYrIVnPrSabYTzDDJRvOeouUUWc453PPdf0R8HhTSQFhM7QfQf0?=
 =?us-ascii?Q?XkphOf+ehbv4Ljoba8X0jwxMtYRi5tDjJbevHODpyrSqoE9QAPOA0sGLlx5q?=
 =?us-ascii?Q?rSnPpKfY3Lh+quI/70DKuYKbiYGoXQ9YfK+lTGBtzwhYOvB88Fm6QYk6csHC?=
 =?us-ascii?Q?kO5yPkgyn8g7skk/0upEbbhptqBxyu0pD6IexUHy+mSREDSEgaQsKDuj/l5K?=
 =?us-ascii?Q?c5tLOVdvndB1nbE8bb2dM0rNKfT3Frov0GzWjg7sDPvBzdUCSPmtkFzlPMJp?=
 =?us-ascii?Q?mTR8Dn/1x2/siWmLpeQAz2KKKPaPY4ZdBMz5UoqcBEscZmVA/H5P4ISraOyc?=
 =?us-ascii?Q?ACJYO+LKPMBZLguyv6SnKePE/7uYqzhGv16aweHc2RmZYt6RoUDQUBF/IePO?=
 =?us-ascii?Q?Zf/up8R2n/G3jO0SGb5uMuwQZGKTzdEVBzXYJgcNkj2JC1PHFVWdHVSrC4q/?=
 =?us-ascii?Q?Xj90bC8164aJMVEv+1VOPkduwuT5S8zh+jAIHiJSDkzSV8xSBXVTjQfgdTdY?=
 =?us-ascii?Q?/6PLlKJsy/03qOR4B561IXDraKO8x/i2DdB9po1mxRQ0L1WLH1liYUq6XTtw?=
 =?us-ascii?Q?ottFdlfjuldXmkJA/z3FBSwXF/eSSU+y0FspbuAPyg87qlK5M1u5hI+9Ku2V?=
 =?us-ascii?Q?1heo4CmhWp4kX0BA2vm3IuUrOYUxo4tPdOMNK6yU5zCubo8lV8JpQpW3ssy8?=
 =?us-ascii?Q?acl2ByARRNPNPGEdnaWucC0iniItkztaVyQLOBRJ2vc1vSa4Dliyn2gnX/x6?=
 =?us-ascii?Q?tRh5nL42Vq9cZZKs8tnxGMWfxXtb78MtkRR87MMUDoA3i1B9+uT0rsqA4r9n?=
 =?us-ascii?Q?fTEoecQCG38aj8xEDe6xDMlpLzGzpWeE/czfYxEgQVn2Ag=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D55m3rNGiWzh0tzjq3QKMLXqTEaiogeZPZ/ashi7OcypTkuYwZxYYh+dTmwn?=
 =?us-ascii?Q?8tZavbTWxE/Z1Q1YpnFK9UsmpxztA9YgKNWc+8LmZGfxvrfbzY/v+uubvC7c?=
 =?us-ascii?Q?Rs3mqLdUeCRvwfnw9BfF8u6+GPvBeL0y46RSGTG5GtIM5FJss5Re3HvgcsFm?=
 =?us-ascii?Q?n+D/J8FBgl1BEEKLYNlATSsV2At23OEG8dmOJPhLgqpA5ULzvLEj6p6WNcQz?=
 =?us-ascii?Q?zNyEjleins6IZ1WVpxkbI7qV8gBRt+5o3A7nNztnfa3+vcaPccK5ApwU2/Sj?=
 =?us-ascii?Q?BujLUzzpM2F0HIqMJp/yGvnBXq3i1HxGqp29vWLanMFh9L9+qSyv9TE0iA4E?=
 =?us-ascii?Q?CIeANaAox9Gdo6f3WY0UoyIRxyNsiPFqQ/f+4dJrnUUjYptEc1UUdfTO22cH?=
 =?us-ascii?Q?UkwisAU+bjIFo9V7xdgZZyFAFxWpf/zMSbLO+Z8cyGW+6wAht5ppGEcOTOSy?=
 =?us-ascii?Q?aU2mweuZuPaHRCnDO/mzqjsTiWy5avG9bTXvHD7PKsEa08Dm4IzFjK/9ZBAP?=
 =?us-ascii?Q?YJiM4YkxBxFz0HE1ClSMghJc1FQd/NUUSymMeSAA4mYDpt56/ZuFGEW8S1km?=
 =?us-ascii?Q?VbSwp47PeeJfo+hOXJe08Fitk2GYvXyR36pDnlnQSLviUKPOkGNbgbV8Etk3?=
 =?us-ascii?Q?lE49VUCVw7BcEXGxkGEyJLbKjRzBwAKJL0XADL3gZ2FBa6bVbww/dw4zLMmp?=
 =?us-ascii?Q?J1+D95qj7hlWFvG3CPrd0tli2AkYdFoitGQa46qzx1H46M25KReA8QbKYNex?=
 =?us-ascii?Q?TE/PIrU9rMvZW/IA8G76PSltAaxueLE+Pxl6zE9f4PhhH3bgFfbk242Igwce?=
 =?us-ascii?Q?pZRFyPSdc0fCUk5WYhZCcuXPhOpeRkEtRGt8vk8tK8ZMlw1Z080UIdCGsn31?=
 =?us-ascii?Q?CpTVzqOwen6UNxDFzYTXo/OdQWIp7DQEG62TU6lF667z0GLS7tYcJx0XGp7N?=
 =?us-ascii?Q?odOVCfMrWHBGtj1znnkVH1Wxet9hm7GEf90GTjD++Tqni7mWwNLEIT2C3wD7?=
 =?us-ascii?Q?Ur0hT45Sy4Kx4rIUUWRoEjr43a3Au2AjlszgyrqarLZIMnqd2vfk6fLUAFI7?=
 =?us-ascii?Q?qZZprIg/P5+2PlE+sCNRtcSgvG6dOURXpTQJaG2QWjAvLIoizm35ZJdot4Lp?=
 =?us-ascii?Q?fH5w0hfc5BfgH3JetD8MPQpoilzq0JDm1+OouL35a8i2jAxIKiLQIoLSiCXr?=
 =?us-ascii?Q?L063enlzyWvrAmuV/fBxyKcVfe5pm1qa/utFGkhfwpfyyrDljnlHIIv/hVYa?=
 =?us-ascii?Q?jdGDSa4DPz+TfII9WcnNtQ+6askvS+rgM9VIVZdzuckTsowSrE3lwm0ss/+k?=
 =?us-ascii?Q?6yKCwpymhdC3J6RYTYt9D2OQGG7wCayqyH2lYwyf3ZHIW5pjI8OLmchfqx1v?=
 =?us-ascii?Q?JpKnndFNbUGIguI3nZ+mhN1OVP3FAcieqZinN2xrg4lMOfTu4be1gHR26Z/J?=
 =?us-ascii?Q?8b2sxzrDidZlgAzKDUWLO+g98BtsR/T6o+qXQnNo75Z0mXcQZxfVmB/vOuYj?=
 =?us-ascii?Q?aH0qStkuT1OmFuD0hJIslfRSh3xRFWp6+V9ksPn+gTnvfvscO1dsdaSDtuYj?=
 =?us-ascii?Q?5r/7sLXkS1ZroQEftrxxRSVws+tjF8weLReIzwMZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: caf815e5-736c-4bf4-84dd-08dc996ffad8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 01:49:00.9923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mB5gT3Wfp1UXkvg/FgLHzX4aqj6c7t0uWDdC/0MBZdcwcfboRPQW9sGHT7AOi2wDhfV+qNkHH4K8/vEkINxF/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6508
X-OriginatorOrg: intel.com

On Sun, Jun 30, 2024 at 03:06:05PM +0800, Yi Liu wrote:
> On 2024/6/28 23:28, Yan Zhao wrote:
> > On Fri, Jun 28, 2024 at 05:48:11PM +0800, Yi Liu wrote:
> > > On 2024/6/28 13:21, Yan Zhao wrote:
> > > > On Thu, Jun 27, 2024 at 09:42:09AM -0300, Jason Gunthorpe wrote:
> > > > > On Thu, Jun 27, 2024 at 05:51:01PM +0800, Yan Zhao wrote:
> > > > > 
> > > > > > > > > This doesn't seem right.. There is only one device but multiple file
> > > > > > > > > can be opened on that device.
> > > > > > Maybe we can put this assignment to vfio_df_ioctl_bind_iommufd() after
> > > > > > vfio_df_open() makes sure device->open_count is 1.
> > > > > 
> > > > > Yeah, that seems better.
> > > > > 
> > > > > Logically it would be best if all places set the inode once the
> > > > > inode/FD has been made to be the one and only way to access it.
> > > > For group path, I'm afraid there's no such a place ensuring only one active fd
> > > > in kernel.
> > > > I tried modifying QEMU to allow two openings and two assignments of the same
> > > > device. It works and appears to guest that there were 2 devices, though this
> > > > ultimately leads to device malfunctions in guest.
> > > > 
> > > > > > BTW, in group path, what's the benefit of allowing multiple open of device?
> > > > > 
> > > > > I don't know, the thing that opened the first FD can just dup it, no
> > > > > idea why two different FDs would be useful. It is something we removed
> > > > > in the cdev flow
> > > > > 
> > > > Thanks. However, from the code, it reads like a drawback of the cdev flow :)
> > > > I don't understand why the group path is secure though.
> > > > 
> > > >           /*
> > > >            * Only the group path allows the device to be opened multiple
> > > >            * times.  The device cdev path doesn't have a secure way for it.
> > > >            */
> > > >           if (device->open_count != 0 && !df->group)
> > > >                   return -EINVAL;
> > > > 
> > > > 
> > > 
> > > The group path only allow single group open, so the device FDs retrieved
> > > via the group is just within the opener of the group. This secure is built
> > > on top of single open of group.
> > What if the group is opened for only once but VFIO_GROUP_GET_DEVICE_FD
> > ioctl is called for multiple times?
> 
> this should happen within the process context that has opened the group. it
> should be safe, and that would be tracked by the open_count.
Thanks for explanation.

Even within a single process, for the group path, it appears that accesses to
the multiple opened device fds still require proper synchronization.
With proper synchronizations, for cdev path, accesses from different processes
can still function correctly.
Additionally, the group fd can also be passed to another process, allowing
device fds to be acquired and accessed from a different process.

On the other hand, cdev path might also support multiple opened fds from a
single process by checking task gid.

The device cdev path simply opts not to do that because it is unnecessary, right?


