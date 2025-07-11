Return-Path: <kvm+bounces-52098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34633B01575
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:07:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FFB17B69C9
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13476200BBC;
	Fri, 11 Jul 2025 08:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k6seDfwM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953DA1FE451;
	Fri, 11 Jul 2025 08:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752221174; cv=fail; b=pQZmb81yNvBoScFRbE7+9X7T8ZjsyCB1ZGFlZ/f5CZ/lYqE8ce4fuqNHzum2m1+wB3vpp8UQbrMywGW7/PTqC4CdtWjnXJHD/r7B0y+4OTJP5uWLVjVtHqkKsZz0q3oawqFSTuE+HyeAxnUSpKlDJQHuug4DPEf8HVYVhGLXW3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752221174; c=relaxed/simple;
	bh=J2fzZFAZBduISYJ3VL0As+KklMYMzUtzfcATWCHRAYk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ap34MEP/YUZTbvW8olwWE6OUJLEwJxoeL05Q7FkGctOphbub1dv874ETjRrBFK+yFxsQP5gM3kfovSEh8m7DbtZ1ZBbuJp3FWgWAqug1PauDK5EpWe4zaYsz2raeJkZpqdi7bUyseYQf+n4AYZIE88ouD9p1L3qK5aZYT3iQlYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k6seDfwM; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752221172; x=1783757172;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=J2fzZFAZBduISYJ3VL0As+KklMYMzUtzfcATWCHRAYk=;
  b=k6seDfwMlm//ZAqqW7Edx1ZDqgWA4iJb416Bz38PqxvnmWpCJ4c7QvXd
   CIXb65lu9NOcZm+rPBRags00nuvWcITG/MAxVHjJCIV4qNdPwu3tpfpKP
   mqsg31jeclNolBMxB6eSVXMjOhB6dw6tVi7lwGf5x9SIoBhkpmpPDKzCR
   rNhq4iRUizpeuqQC3rub4DOd228hajFgTERf4BZG7g11vsMSee6w1zbfL
   HJVsdUsn0nSEzrjyFoXpc/FZW6F+IqMDYUlo1Ug/1yVI/RpAqTak1L/fr
   e1NE7xviz1gYSE9FWnQ4gNSHR1z2jGE8NwR6TyrfGbI2XAS8fXWcxwxVR
   A==;
X-CSE-ConnectionGUID: uTdFYyUFSwamDz4vbndQ8Q==
X-CSE-MsgGUID: Rwcuy1WXSNeiX8fC2KhyTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="53619828"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="53619828"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 01:05:03 -0700
X-CSE-ConnectionGUID: TL04DqPaQ2azYxr/zmFP0w==
X-CSE-MsgGUID: iRISG3zoRqyLuxdjy/Vq1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="156798215"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 01:05:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 01:05:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 11 Jul 2025 01:05:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.44) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 01:05:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P1AOUqJxctYLkUVPi1/NuaXw4AtX4HJK8XX+hmAtR65GKhWttMPU8dlC0GzaTLh0/T3625CyUK+zePNyCInopsI+1kAcv18HW4+8as/FhpfOIa80CCO+gOdTuNH0YPapwRsiurRE45GEb5gKfjNWBeWwuTL05lhOpxVQHdENw8ygTB4GMElyAtRBryl+Uko/I1sQNUNN2+dNYeeUZEYID0g/49UH1jig4mhbAhK3wYKEQ9+MJD6wEv3lCm1Ym6WfvDZWpGtIdmKbaSW8RHjozCUMG6lhI2Fks+PI4ePPVaJmucR7RzK2y2gQywgaruo8RdEWfRk/bOu8eqncmKBGXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wnsviIkezmwmwqoucEqZSfJHjhKcNS7v6+spNwvbjWk=;
 b=adhrCEwQoNfUDpErU63L5YDlZmFnZhBT7iEQYOv1mpEv1l7A4PAsXFijsjpCBQxR50nFhoFWb+OdTq4oiljVowuXraZCTnS44QFxM9MDosu8JHWnHaI8XIMUYqin5cu+dt44cNAGhuXX7v+pqgUauo+50ujsQMCINJXBIV2tGrvlquTEwlMgbgcprW/FUdRcmhOIU70SJ9edTsX7rBf7s/CHG4l82yILXkXQ7uevu1kU//uQijjet5MQNmeKXvfBMkoKk0a2rUP975EIffg4nLgdCvAcSs6xY6XstQpsxIlo8EqZBvGQCgwK1F4pR1n3Je2zw8KWLSkjnE6xWlqDRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB7291.namprd11.prod.outlook.com (2603:10b6:930:9b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Fri, 11 Jul
 2025 08:05:01 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.8901.024; Fri, 11 Jul 2025
 08:05:01 +0000
Date: Fri, 11 Jul 2025 16:04:48 +0800
From: Chao Gao <chao.gao@intel.com>
To: <linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<paulmck@kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <eddie.dong@intel.com>,
	<kirill.shutemov@intel.com>, <dave.hansen@intel.com>,
	<dan.j.williams@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <elena.reshetova@intel.com>,
	<rick.p.edgecombe@intel.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
	<mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	<linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 00/20] TD-Preserving updates
Message-ID: <aHDFoIvB5+33blGp@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
X-ClientProxiedBy: SG2PR02CA0134.apcprd02.prod.outlook.com
 (2603:1096:4:188::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB7291:EE_
X-MS-Office365-Filtering-Correlation-Id: e2182920-cc8c-4d0d-a3b0-08ddc051a2a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wQw2tlasQgo0kcCtdo3Ln3WnxuCzWnRefv2DPwX5TWn6yzgJIkZrCyMpxqrE?=
 =?us-ascii?Q?5WoO0q0LW1Kx1l3Cd1CY26PCatyA/BprGbckD38Jj9J7iG6Gx03ARZQ1uzYf?=
 =?us-ascii?Q?Mq2HI59Y3SLjioChs8VyqDwsFwlOLxSsmTlZQ9yUIkva76IdfvwrpyrPbcx4?=
 =?us-ascii?Q?ArUNwzCI5+JIp2dhCWfda8IBFLUS+kfLkR2EEx8fvp/YFQJeXr28yM7oE2JL?=
 =?us-ascii?Q?F30dBDYiUEjTIHN35pzaPhesHE1pzFIaMyD+YU0PYm16JKCqT0t8C3WlCyd9?=
 =?us-ascii?Q?qxJJMQhHdt2bDIrlKUs7c8VM6eN2lige+rtNnwQExoND0UDUaINNciz+3dJ+?=
 =?us-ascii?Q?Dz33SQ8Ri33M2uPPac0ux+8HyKml06jFXJjyMwAKqEOjCN3fcj45kxdaUrIs?=
 =?us-ascii?Q?zxc2qP89WFOHYLtC5WbfAC4EMX9O1j4T+4zmxiFJo/irIfN+cvJqvaI5izSR?=
 =?us-ascii?Q?gVIgpkWp+7ttrRZ7Um/JG1X6Dq19K8N3SuTbuokC5OLMC+xduI3/ujEY1hb0?=
 =?us-ascii?Q?vz3pzJUOBZnx/bRDQC1+hGegcEisHk1di3rkeyHYEtjoJbefFftfsiWHMeqO?=
 =?us-ascii?Q?BS5wLV3Zvpq98LTXaybHp4LIMlw/k42PU5TQb8ek6dqhXoAv6ShT1PjKJVFs?=
 =?us-ascii?Q?KQuiIcy39lu1nBvIXO3S0C9DSQ88bm9+LEani2BydlJjnjLay5aYwTo5fzRh?=
 =?us-ascii?Q?zFy8KjDh/5t5UIN8tC/4LaVZY5YyQCHREUFYuuxU0wqhB81l27Qo8o1NmTGm?=
 =?us-ascii?Q?JPPyLGNc3xp8AjzunjN0j7n/VamKnefTx7yk67UmmHuMtghNP/lMyNw0FSUx?=
 =?us-ascii?Q?GOnQJTJwWVMsazY10gnPF5f8OjmhvYTMtxBhYWZvt6wY2Lw+Hob9fKbc7M0B?=
 =?us-ascii?Q?jCNv0Mc+7D+SlFCRHz3qgYYTtxTF5DukvIIfIcokrOGumssNZxkHzKA2LY5k?=
 =?us-ascii?Q?XP3KmQfOdAX/iYPFTkVlQhTvLUEGQn4lWA5RfOFkUeTOoBCI3SMMP0VARkoe?=
 =?us-ascii?Q?YjcT5OqVPPqFlnA2Ut1QNByQZ1aPf2xGGiMPd1QQRGOj6xSAQpvzR8l1lR5T?=
 =?us-ascii?Q?ACuv17CAq69sEWvMT9lzvjJKtJF8GVVAbEE4YBfLCTNIzmcX5v/iTPcWzpAu?=
 =?us-ascii?Q?UZwPKdvApH4Aeo6odtxYov2GVG561XzgwgBwOuKU2yFgy4mik8OazsTL4Y4F?=
 =?us-ascii?Q?u+mPFQkUc6OuITMPGoEzqG2q976jF/5B49ZakQ+XTtBM3RtkTpoiHxhA0ml4?=
 =?us-ascii?Q?TDNVFAf1DbETCcRz+oGRlfDRYPHJyam8QGs4NLIKPkQk2NINqYE7NSoaK5Ei?=
 =?us-ascii?Q?a7jLtCqQS+l6hddYWFqSzwzuPhv1rvuKN83ESw45zXPrWwDmDiy/XtNowxx7?=
 =?us-ascii?Q?Glh8kmN3D32+ce1INkrCdfBxYQOKL2HlkEjSm0iIE8X86NErAx5FlORkxs9k?=
 =?us-ascii?Q?WnLqkyeA6YA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jbkk7VXrTYTVVPaz2+ysmFcQyYSUyD2sHiuPrRWiGw510ld+TpXleWDD57OS?=
 =?us-ascii?Q?+9TcPxVsaFBI0R1YwjV7z7WoE/8Tp3Puq3nz0MsosVgOQ8HkliqxJ36v3aui?=
 =?us-ascii?Q?y3/s1cl1BUhJGCug438LtZUzsjTMqZWejTuDmmvtnh03dWP4CRQAraNsIvJo?=
 =?us-ascii?Q?fPueGdpm45LJM1E3SoAavcIyBOPY6SGSUG8GqfOgSaS24uQDeNFfN1UwAExB?=
 =?us-ascii?Q?OlN7Jl9PQFABLyWvtVkXMzh2APeqoJYcyhbG4CJOUm8o9G1iKsIxJ0C2m3ah?=
 =?us-ascii?Q?4Fib9leUoYHor94yS5xRgUt0w9RNlTm8YWEpA/XohrpjCJ2Ksifo6CUaFumI?=
 =?us-ascii?Q?fOpC11vILXEZ+4YQrdeIvRnERjGHU4YbiELlcFljfJKNuRZ8AkYTs73Krkd6?=
 =?us-ascii?Q?BRjn6qw/zuqMMMQzDjuoMyN8Rk3PYTOW+1IO85k6/S5PkwHk/t4oNFgGyV0Y?=
 =?us-ascii?Q?WmZpCn6bsTR3Ies1bbOhGk0T34dCfiAZirIpUdZlCZVp2bQdpih+YeQ3W/JL?=
 =?us-ascii?Q?kMrCb6GJ9x8mrSgpgZZDdWCKwYvUDvHanQUAVxGtL27VVdT5sCmOjl8cZvgQ?=
 =?us-ascii?Q?vK/jMZLLcncDFJggaSpADp3k3JEean0paroQTmG00aqAXMQwbBFiA8mvoPuY?=
 =?us-ascii?Q?Y0/SFspOkm06ra3+kOl5L8MMLLss4IpAX4IguM6d86CTBeLuumyJazmMt/Tz?=
 =?us-ascii?Q?FMv0RyCSsXxh/DZmHOhHSPZtnnKZ7U3pT5YnWnRjLWdmaEOtjDChvmp2s/s1?=
 =?us-ascii?Q?VBi1TnX34SQD3/v+wHUTLnJ9tNmtDZvCWL7YkfESvM0879vUB0OW9UkJ/X+u?=
 =?us-ascii?Q?hi4Cg+cLilK9Uj8NWFH1nASzWLnbyjKOx6fQMuCVZf54nCAsYG2B5Lkma/c9?=
 =?us-ascii?Q?hzcHwsumKQkkHN/K0g2zjI+07x4U+WYHyDLA7n5yDYHpHIrTZvwGkrxI5N2l?=
 =?us-ascii?Q?vn7MTxYxTFDt8CWpC3QgvLgDjRZUKItz+4lHCdcd4YZ0+ExnjhpMhasfH11X?=
 =?us-ascii?Q?AeamG0NZUDMXPMG2u0sy5OZ48S4QVE6xpw4biirX7olqukKd4ZCClQbsXPoZ?=
 =?us-ascii?Q?JFEYIioXEiP/06EZBU5W5s76BxMXtApGox0Kf91II7Euhxq3xcPdUbrlubMF?=
 =?us-ascii?Q?jHHdvdBjJoC0Umy2nO07wR+i3NR83tLy5Hra1tlkNeZcM7k2FIzY6Iq42uqw?=
 =?us-ascii?Q?EVD7TU+4V2wZvriA76ef1hZ0YbCZwf4QszV/i4EYwWSgs1su8IuJow6fN2Hj?=
 =?us-ascii?Q?IxvG8OquKJDWiAcT204ONkUNGFXLZTsqovdUKYWhhbZDWKmxCMrG4e+20Zim?=
 =?us-ascii?Q?uRLxJAjtadKh/TgkEkostOb0Oj9AtXOUkmYy0ktr6T6MubHTb2IKxC2feMYA?=
 =?us-ascii?Q?3IWf9nEoNWfRpDuzjwpbYWtn2BMt2/OJ+SZpbxfI08OtezJ534rTAuQzYBX2?=
 =?us-ascii?Q?lGCB+vqP1LJ1Y6pqK6vYlxp+Pk6Eb9FAnFYq/qqfQL0GwrgS3/jgI5WMPqCV?=
 =?us-ascii?Q?DCVaQOk5S3rkR6kMzhQDQibKiruJ1Uctv9ozknQJRpEJXgiS5s2CqUiswyKG?=
 =?us-ascii?Q?hfkdX0J4NzCGxaNCKQUxv0ZGS01gcsZdJnKqonam?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2182920-cc8c-4d0d-a3b0-08ddc051a2a8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 08:05:01.2304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SIcjxQLHbnfuQgjtOBN4lo0RDJyft4rKDeVqtQmg9lKNBQRZD/i2EJpqvSgRAZV4ozrQ5t3lDmlTntpScmwxtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7291
X-OriginatorOrg: intel.com

On Fri, May 23, 2025 at 02:52:23AM -0700, Chao Gao wrote:
>Hi Reviewers,
>
>This series adds support for runtime TDX module updates that preserve
>running TDX guests (a.k.a, TD-Preserving updates). The goal is to gather
>feedback on the feature design. Please pay attention to the following items:
>
>1. TD-Preserving updates are done in stop_machine() context. it copy-pastes
>   part of multi_cpu_stop() to guarantee step-locked progress on all CPUs.
>   But, there are a few differences between them. I am wondering whether
>   these differences have reached a point where abstracting a common
>   function might do more harm than good. See more details in patch 10.
>
>2. P-SEAMLDR seamcalls (specificially SEAMRET from P-SEAMLDR) clear current
>   VMCS pointers, which may disrupt KVM. To prevent VMX instructions in IRQ
>   context from encountering NULL current-VMCS pointers, P-SEAMLDR
>   seamcalls are called with IRQ disabled. I'm uncertain if NMIs could
>   cause a problem, but I believe they won't. See more information in patch 3.
>
>3. Two helpers, cpu_vmcs_load() and cpu_vmcs_store(), are added in patch 3
>   to save and restore the current VMCS. KVM has a variant of cpu_vmcs_load(),
>   i.e., vmcs_load(). Extracting KVM's version would cause a lot of code
>   churn, and I don't think that can be justified for reducing ~16 LoC
>   duplication. Please let me know if you disagree.

Gentle ping!

There are three open issues: one regarding stop_machine() and two related to
interactions with KVM.

Sean and Paul, do you have any preferences or insights on these matters?

