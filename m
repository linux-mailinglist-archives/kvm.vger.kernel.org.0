Return-Path: <kvm+bounces-25878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0ECA96BBFE
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:23:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A21ECB2129F
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 12:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2262B1D7E5B;
	Wed,  4 Sep 2024 12:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hf/iPhH7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9BD1D2F69;
	Wed,  4 Sep 2024 12:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725452361; cv=fail; b=YW2WwRYfxdsQGof/hi1hTKSMANXDa6+8E6yQTxkO8omlT3ZUT7qV2z2j48wKcVHkRI6+ameuEbHy23h0cIcPDQzKKXYdNAYGK/roiERlXsemz7K0JzjNej+DtFmCsntyOkqVZMR1rfDmxVWd+rmv5hs4SrJGS9r7SX+IstqvJQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725452361; c=relaxed/simple;
	bh=1jDgnUOQQVo0B9w4t0gCScbY0+HsT/PwHFNTD99W0e4=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UZQ5q2isZaUeDao8VaQAGNTlz5eFQoGIshBq8ruDGCqpdMPhYx80ODuLerNt9iu83ZSQa4Owmum0si9ap8+HMP/SF92euizjToiBKN9+/8Jirx5CRzOWh+g3QJVqXi/k5Xsn6uBeoR8myf2JEJ0KnXBhrJ3skilR+TIojPyIYbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hf/iPhH7; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725452359; x=1756988359;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=1jDgnUOQQVo0B9w4t0gCScbY0+HsT/PwHFNTD99W0e4=;
  b=Hf/iPhH7y3sB3qBAPiuKQLvRVp3wMkip/wGBJnyTxsKpEbac5t9edKE5
   Q2v34Ju5CYioypOQ4/rtxUgIkoZTCZaxdKrh9gJGlyh0mKEO1KANZAWzi
   7aQWrOxc+/tUWxTz1p3H1Mk6SbE6Qu3jL6FZi66ehuvwWVP91Owrg12+q
   ULQIBg+HOuchwU0PvBmxbIUaDXRywnns7x0vHnDN9s6Kx8BbHMwiWqJ5I
   FWk+Hr2SlEHoxbrfac+BQO8Zuw2kFbzDPLPNNqyA+PKV5VQi0iGjbh9u8
   OoUx2vjTZEAy1CzT7iW2U9wA5PFFr0hBnfOOV+f7BlyLAep+tN6KFQZzD
   Q==;
X-CSE-ConnectionGUID: bFZiwlaQS6+Nvatbtrb/yA==
X-CSE-MsgGUID: 5Oy2Ke4USHiWAqrh79Ui4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="24299754"
X-IronPort-AV: E=Sophos;i="6.10,201,1719903600"; 
   d="scan'208";a="24299754"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2024 05:19:17 -0700
X-CSE-ConnectionGUID: 6x6Cwb/ZQzW+/y/y/w/LsQ==
X-CSE-MsgGUID: 66H6eq+BSyS3itCvb3S+Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,201,1719903600"; 
   d="scan'208";a="65241779"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2024 05:19:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Sep 2024 05:19:16 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Sep 2024 05:19:16 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Sep 2024 05:19:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JWdjI8A1904mqhGvGDF6imuRgVGb+HOlxcB2b054tifMiYtzqS4UZISJ1wOKVtZtk6Sp11S/ec3znbIFMPEFYQw/CxkGGGDu9UWSQrfRhDOSIEGqe6ZYMtZ8rW0/t8cNVg1WIJLhUYnnB83buVnTdTChe+KiQQKZ5lSnrNfCEuhMLiDJvl5iC5qvQWbfoN4NpdRUmJmjHK22/M+u0CnOWa3zIj8I0q4jcCBMQcYaEzKn4qDvkvJ3JzyFhYmtKFx8S/jlJsONR0PyHbRTG8uAHvRmyzvy+/MR6kyDKA9g35sgmGwW20+E7XJcclN/8fuq3C60gtAThHgcUDwRvGIjeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNI74Bf4cWQOAkKZvGNmZ88cbJOXcvd/dhOWnFO7MlA=;
 b=E+CL8J4Yq2gbIixtWMXJ6kXwt7R1xtSzMxXul/GrwIsdmFEf/TEDtWpgGDH/9h3DEEdUQiDY1gGIEW20zVsj+FRU7jMlbNED8dgvx96iA4YJind68rgGHYknx4yemtosZ0bvX84uq5xP/ORmwF+mc2YtO2kpVUZ8icTX4afKA0lfY3PqsRE8lkYBx241Y71z5XX0ka+OfMMv5XOtOW1/7lZ2ke8apjB2vw5coJ/ceB2DaB8O8z1jS7UvHeku4TLaOWTPPgkjWNR49FR0fECZz8sv/jTSwywfsB3FJS2r+L4FvWepwsZDV/jptFYTJRJKkWlXlDXqZvN7UMD4oHqNLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8313.namprd11.prod.outlook.com (2603:10b6:610:17c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Wed, 4 Sep
 2024 12:19:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 12:19:11 +0000
Date: Wed, 4 Sep 2024 20:17:16 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <rcu@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kevin Tian <kevin.tian@intel.com>, "Yiwei
 Zhang" <zzyiwei@google.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E.
 McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <ZthPzFnEsjvwDcH+@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
 <877cbyuzdn.fsf@redhat.com>
 <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
 <871q26unq8.fsf@redhat.com>
 <ZtUYZE6t3COCwvg0@yzhao56-desk.sh.intel.com>
 <87jzfutmfc.fsf@redhat.com>
 <Ztcrs2U8RrI3PCzM@google.com>
 <87frqgu2t0.fsf@redhat.com>
 <ZtfFss2OAGHcNrrV@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZtfFss2OAGHcNrrV@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI2PR01CA0035.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8313:EE_
X-MS-Office365-Filtering-Correlation-Id: e7d49bd8-612a-4d61-c851-08dcccdbc8ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?E9JtXsyoa2XlTd3ukw5G82Rd3vOGTfTF4hvo1j8Nx/RNQAn5Fbdd20OvIbHF?=
 =?us-ascii?Q?pNn7B3BWJMuq5kBQjfAaazf+ZKrAD10VEu5WLBTIBhOch+V0oZpz3QiVUPKS?=
 =?us-ascii?Q?shUACTOSyWiRUaMkWBbfiEr+z7tc2B3VVVtFD9BYXK98+mAkSlptMUE0szVa?=
 =?us-ascii?Q?HSft6hz713TQS5qQj2XjlPalCIkl4W0PaSngHtgovDfPANbu/wPRY1991ej/?=
 =?us-ascii?Q?AKrgQE7utUSN1Na3yfbdyVsMLVqOhEiNGRSLgE7OO3uHZfqh4hcfHGYntmc2?=
 =?us-ascii?Q?HgikKytIb4xR98rtgODN8DfqwEZ+pxguvV/iK/MUhWpZVOSyCDcCixgDImKu?=
 =?us-ascii?Q?U+D3ykoTj7WbP9jsWnb+BCliMZUNKYmNfPqfQ0JsDEBGGPzvAzUlZPrxgjGb?=
 =?us-ascii?Q?Hk39ryjWd7lDAue0LfkOicA3/8vNPiUnR0WHSYJkdx0o/G61zFwX/cL/WPjV?=
 =?us-ascii?Q?ULqMoFEgYBU/KkVBHi6x2IngMgFoeFYANmDiWMUVPExSF9441G2vPGqp0MDE?=
 =?us-ascii?Q?WV2dkTPBd950QjMe1iNW0PjJSMKbzVw0lE1wSPdhQiGWQzXCAY1YtOF9JP3t?=
 =?us-ascii?Q?VjH7Rr3WD5Jf1fGt3J3gRO7l/tKfxL+ZcgHK37kKAc5+WMOd+sGv9YymRGv+?=
 =?us-ascii?Q?HOzXZ9x3iIZvdzt3r6YjrKxk7TBSGc2PNnClhSrsdcxgy8i+VjlNed3kxHFi?=
 =?us-ascii?Q?p5SGlV8s2tRdSpqfhhSGEmdh09RYLHeCwx9UkK7daCKOxSaCacdIuCCRWcun?=
 =?us-ascii?Q?CZsklzbu3y8NA0viPGzqcBMQA41EY89aOh3czHEIr6+s+xd5WbU3WDH4Dw36?=
 =?us-ascii?Q?sxL9ntu/FQGaqRA7ycKMtX0jOD8fPjxwNpuVv2JqwIVZFp7KI1AlMMdC82n4?=
 =?us-ascii?Q?kGhvzR3B1LO6sXt+AbhHlSjHO82j857/YkeaiEZ7nOiZGioBzNqjv6aUfImR?=
 =?us-ascii?Q?3D/2FI8n4ZGpjBcdaVSK1Y/k4us3R7Yw+zkWmqW/JsUNhBRj3EoN8K2/bh3k?=
 =?us-ascii?Q?mPJjr0dsu8UgRVgoJSQzwMwImICJu/sAOKDqlGL/JCnVCvn40sGYZz2ktF0k?=
 =?us-ascii?Q?Qtn6xqd4Z4MkyN3IZR9mqOqPRqXG0xIQl1bY2ZYogMAlvH3vWUK0ZdpCdyya?=
 =?us-ascii?Q?UkW1DFERCyd2ke7d/idu1xZWv0O6PTa2Jjvjpz6nVKZEjXppc96nhiyNhCwn?=
 =?us-ascii?Q?OMWbdnn1ILlfJNO7Z+fWx4pNycZ99wowfwNwq1i991MUEjA8uCqq6GoUpu5H?=
 =?us-ascii?Q?eV3b/qeih06b0r23AMHsBERuNfYc5hxHq93MMXUTk1a5Q2xdWfqJs0sxFG1n?=
 =?us-ascii?Q?OEp5yw38iA1oDHYCwwP9DhdGYkfE6/FwZdgHh3Ux61hpiDyuuE/5R6DbHEpp?=
 =?us-ascii?Q?A6HDGIKOPpBsZEYsj4iAWWnlYlyv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UEAZnQgcYE4PLdHnGNC6dHrUCrMHxlZrIIci05H6LHC2Xas/UcYtqnpdsgs/?=
 =?us-ascii?Q?RBF7V9QXX4558yQ5uHRo7I0ltTalwSbHRwJaFMxBjm36UwsIYw+Fnjv1urAf?=
 =?us-ascii?Q?NVNSeAXBCuYMvjewP1aI5VfnHzkrmrEKkv2deQGGPN6VqV8+4AEsdX1Vy6jG?=
 =?us-ascii?Q?Hy5GH6+VYYbbPue2sSqFzPhXOeVqg9ylDwe5wsbbD7Vvq8m1jFxqNGs3HOMi?=
 =?us-ascii?Q?eoqlyrhq/wqyNoieuNnYadhK+v014NgRiRZr0j86ZWXiipWRdxpIG6f3x6JF?=
 =?us-ascii?Q?BLuvdoZNJ6lJ0yIBE3H7YQSaXQNWeeGwE+/+topB2q+tzWE0vm/Ze5d7EZsH?=
 =?us-ascii?Q?iyOWuGbtfwyzTdyvTb8aCmS0MDOWQzcdbRocJqYzwP1Dd0RIFBirFhpDtBeL?=
 =?us-ascii?Q?nL1YNI2Beudk2Whqj0T+2iiL0t1FRWu/53uaMlhnliMydGPiKOYCCF77U9mk?=
 =?us-ascii?Q?PSVZjongZotRAvbDLhqBcZkxNg+ksof44CUs2qUvfTmXKsgbnhiLHu5Nn340?=
 =?us-ascii?Q?fnq/t6rHaFXBSRtRUvmfVudf5qiISn579iNQk8/l9gSn07iLgRb0sVI815uX?=
 =?us-ascii?Q?K6F/ale0CIkoGCC4/0qJ+EpqneMXrp3++Lk2+KxmH2Gk/scJ7RJbn0YKnpVU?=
 =?us-ascii?Q?KkcR+AJpN/S7ez0qRWeZaJ2ZtC6e3+kJKidOCINJqQ6E94KpLOe6RrkKEUo4?=
 =?us-ascii?Q?APulRNlCAAO6oI1wMAYqiWRomZ+/UZ194iwpbwcGWLjoRVzrsN1qD7WuZIfj?=
 =?us-ascii?Q?xN6r/Bqo9KagUEUSJPoZ+dRpSfZIwT6belAAvz648A+1vZmi9D4yh4/zk4f2?=
 =?us-ascii?Q?p1FRkWpOvnTjpkf+axysYo2SqO6iLI3XOg/N82AN2Z0QBFaY3duaG4QMy/By?=
 =?us-ascii?Q?C212PQ4OdT+G3CITIdUz63xFWpjd982RJtnAQU/h6VwKsgOqueztBxE9um+0?=
 =?us-ascii?Q?1QL1FPNdQRXM9VBQdq/7PFFLSIfvdFE6gT6HZLCYkP7YbalO17Yzaddiqx3Y?=
 =?us-ascii?Q?BSSA2c10a0cDuAowOWmsGtiAq4YNCxYJGzfpqO4JY9TsVNofhCUoqe5M9nnK?=
 =?us-ascii?Q?gh+UBzgVxuyDTuxU/W+voz9F8mDc1i+zSPgn89Vfx27bR3Q1yCbTwId9LuaM?=
 =?us-ascii?Q?HZTZNicTaoca8Xpv+tz6ilDBcKIU+bSLUxHGEFGAMOiXWPvgTg+CmYMDJVJi?=
 =?us-ascii?Q?Xqz4qYGe+LNhYsXZkmLYkzZS8P08WfFO21sQYxvs40Ql1dcrIeXqOkxi1aDN?=
 =?us-ascii?Q?MsVIstkB/2C1wx6nz+85NBdRigL+xS2amwCVA/DeM1ze9AWyQLZkK29Pp4Pj?=
 =?us-ascii?Q?sRgLpW53pVzabb/wxLv/KPOeYy5ZXvXVYln8xOrxuiRWoxJFq6N5bX2ZUGnc?=
 =?us-ascii?Q?Cpw1JGwhnsV+fAQMdGO64tLiqzXuJaL55+3kxoOAB+9WRPf8o15cwrkiUj51?=
 =?us-ascii?Q?jKiVk9s/HI3+W2+xe99A7Y/UoitPWgncQ97yiKFJAeMwCcTpQRmaVziL6U+p?=
 =?us-ascii?Q?xHSjNrvwoDJ4kAVQcXJqkHKTV+vqfCkYXexL6wJ6CLVsP2aYl8hPIKRB0QES?=
 =?us-ascii?Q?sF7TbwHL2nP/8NhAB004fa5U95BVI5ZP9KSY2jZ5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d49bd8-612a-4d61-c851-08dcccdbc8ac
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 12:19:11.8041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O+rIGAHbOqLSiV2FoaMYOc9/ZuuPrACfg7RwVwSd1IxbEU5zhLa+vpesArIoAMYiEvBIZQYm/lPeqAkzvZWjHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8313
X-OriginatorOrg: intel.com

On Wed, Sep 04, 2024 at 10:28:02AM +0800, Yan Zhao wrote:
> On Tue, Sep 03, 2024 at 06:20:27PM +0200, Vitaly Kuznetsov wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> > 
> > > On Mon, Sep 02, 2024, Vitaly Kuznetsov wrote:
> > >> FWIW, I use QEMU-9.0 from the same C10S (qemu-kvm-9.0.0-7.el10.x86_64)
> > >> but I don't think it matters in this case. My CPU is "Intel(R) Xeon(R)
> > >> Silver 4410Y".
> > >
> > > Has this been reproduced on any other hardware besides SPR?  I.e. did we stumble
> > > on another hardware issue?
> > 
> > Very possible, as according to Yan Zhao this doesn't reproduce on at
> > least "Coffee Lake-S". Let me try to grab some random hardware around
> > and I'll be back with my observations.
> 
> Update some new findings from my side:
> 
> BAR 0 of bochs VGA (fb_map) is used for frame buffer, covering phys range
> from 0xfd000000 to 0xfe000000.
> 
> On "Sapphire Rapids XCC":
> 
> 1. If KVM forces this fb_map range to be WC+IPAT, installer/gdm can launch
>    correctly. 
>    i.e.
>    if (gfn >= 0xfd000 && gfn < 0xfe000) {
>    	return (MTRR_TYPE_WRCOMB << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>    }
>    return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> 
> 2. If KVM forces this fb_map range to be UC+IPAT, installer failes to show / gdm
>    restarts endlessly. (though on Coffee Lake-S, installer/gdm can launch
>    correctly in this case).
> 
> 3. On starting GDM, ttm_kmap_iter_linear_io_init() in guest is called to set
>    this fb_map range as WC, with
>    iosys_map_set_vaddr_iomem(&iter_io->dmap, ioremap_wc(mem->bus.offset, mem->size));
> 
>    However, during bochs_pci_probe()-->bochs_load()-->bochs_hw_init(), pfns for
>    this fb_map has been reserved as uc- by ioremap().
>    Then, the ioremap_wc() during starting GDM will only map guest PAT with UC-.
> 
>    So, with KVM setting WB (no IPAT) to this fb_map range, the effective
>    memory type is UC- and installer/gdm restarts endlessly.
> 
> 4. If KVM sets WB (no IPAT) to this fb_map range, and changes guest bochs driver
>    to call ioremap_wc() instead in bochs_hw_init(), gdm can launch correctly.
>    (didn't verify the installer's case as I can't update the driver in that case).
> 
>    The reason is that the ioremap_wc() called during starting GDM will no longer
>    meet conflict and can map guest PAT as WC.
> 
> 
> WIP to find out why effective UC in fb_map range will make gdm to restart
> endlessly.
Not sure whether it's simply because UC is too slow.

T=Test execution time of a selftest in which guest writes to a GPA for
  0x1000000UL times

              | Sapphire Rapids XCC  | Coffee Lake-S
--------------|----------------------|-----------------
KVM UC+IPAT   |    T=0m4.530s        |  T=0m0.622s
--------------|----------------------|-----------------
KVM WC+IPAT   |    T=0m0.149s        |  T=0m0.176s
--------------|----------------------|-----------------
KVM WB+IPAT   |    T=0m0.148s        |  T=0m0.148s
------------------------------------------------------

