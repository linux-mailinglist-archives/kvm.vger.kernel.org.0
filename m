Return-Path: <kvm+bounces-30259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C3B9B85C0
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 22:52:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50B121F21995
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE06B1CEAC6;
	Thu, 31 Oct 2024 21:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FRG5SnXp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61C718EFF8;
	Thu, 31 Oct 2024 21:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730411565; cv=fail; b=DOnnSHgua1AMWohiB5dfD0HSl2wbjb5Tkw2cmQ2QZuzbCWIXHcsQK1HSaWebjnax7CReEOGD5m8Qn4I2VZ/4oi8MtjPfWqco2d6zkmxNPSmRvvqsZuzKBRlDEVKMCeTNuT0BduRe69YCuzviALo6XeZXhCZXZQx//PlWQYMC7QE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730411565; c=relaxed/simple;
	bh=/6RIIqPRqamXkBeSS08DltknKZ27aQu0yxNUw6RMtwY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=c2SC6GJ/XZfUpZh6FC6YlNQaFt0tJLIjBi1ACHzZHkpUn48TqNTZY6PPXIKHnXdGHP3zWNyiduQK4M11IEMSLGoO56SePrWA/3cLB9+MbPqfmsL//rKldgPZWCOdkFznDPbur3YrzA363p+P0flfDJWnN43m5NiZpwhwUlW2DXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FRG5SnXp; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730411560; x=1761947560;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/6RIIqPRqamXkBeSS08DltknKZ27aQu0yxNUw6RMtwY=;
  b=FRG5SnXptlCXcnaJbCGIvOKSVftmoBKONrfIzIPpOtIC+mcMZ8zWgtqc
   FDG6akMHc73dDGIjVE0xcIsdfwHiGa6178HBxTnsBmd2vbMyITFauya88
   OSEHJSZEqrBWyapKCbZGdYHHN5sMoccJNSAJsKDk+5jTjKTgfRIXd1ghv
   UzsgLh1IhDg3q8JC//3gvEHIpJHomUo5jPQNbkFj3dMvHN2Eadhl4Cu8A
   iqVDIuHhZElFKOKfrCR4hVUt3Fg1OtMQXBMntgd+skDd6oxsh6PmdnGWv
   CaHjCGemYbyW1EuhWJRXxtqNihhgkD4jzr4ytPzYoAzqVjJ6WgYZHOGec
   w==;
X-CSE-ConnectionGUID: eLB9jfvRTROgFBLQUebegA==
X-CSE-MsgGUID: ELCp9gZXQA2QFzH+7fD8Mg==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="34109604"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="34109604"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 14:52:39 -0700
X-CSE-ConnectionGUID: NUN/+x06QaOQYZ3UIRaD0A==
X-CSE-MsgGUID: 83QmWcirQQSpRYn5FITQZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="82869888"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2024 14:52:38 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 31 Oct 2024 14:52:37 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 31 Oct 2024 14:52:37 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 31 Oct 2024 14:52:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EffVVs8obDlar9IxabVy2yfwdHswSlWlpOdYWVevbeEJ4+kCEFENZVgzGggvV2jsjRZeQ4+KGVin4tuLB5cFSh0jIeqy6mOIid1FqA+DuoXiNj9odTzOrHONZKG+vSSyAQrHhVa704jBLcgN3ClwzCP/f5p2q6uYYc+2JVYShw50lTFJkcPDlSrAQ6NwQ9Ir3jLniCMeRo+wSce8R4gDw+ZTUgqCEe2CQAcb3qPDOTMLlU83UPYfdBkSvj0rHgx20mriIr3MFdH3gfY2CXtYABbLA0GulGAGuSX+W5knXqvZg4Lw0Hh9H6wuvfo5bLbn4giUsZ6WTe0eVvbUvPNbOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQel1iZfTfDZrfVXSEcN3RqkWGketPNlIR1geBxpPWs=;
 b=Rs1N7EArDLW5FPXLTTpxqEx6trbqwTweF9qLZP3DI4Vw6ml0A2kgW272erRoUfzka3klhcxWWwjJCGa3ms69EF6zyamoekb2PJiZOi5ixTTHijcoHuscNDRMrywQraserwOJGwPs8fmCzVb9/UWnLrhWZkfJe8HSelG7+wK372Qaxn2jeX5UM9/VALd085TfzK2cMTeeKXzfcbXXnmfff6MRtBTT7SlsPOC6eFVpwfbDcqwFfrXg2JLYqk+PFjjpOO45QUhAvAA+eqg6NQXfoNJfjk1ndDULxhszb878XjiT9fQDtC/EAuNbwE6P1d9ZZBlRDx5hupAkJm/w79xzqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB6264.namprd11.prod.outlook.com (2603:10b6:8:a5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.20; Thu, 31 Oct 2024 21:52:35 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 21:52:35 +0000
Date: Thu, 31 Oct 2024 14:52:32 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Lindgren, Tony" <tony.lindgren@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kristen@linux.intel.com"
	<kristen@linux.intel.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Message-ID: <6723fc2070a96_60c3294dc@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <cover.1730120881.git.kai.huang@intel.com>
 <f7394b88a22e52774f23854950d45c1bfeafe42c.1730120881.git.kai.huang@intel.com>
 <ZyJOiPQnBz31qLZ7@google.com>
 <46ea74bcd8eebe241a143e9280c65ca33cb8dcce.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <46ea74bcd8eebe241a143e9280c65ca33cb8dcce.camel@intel.com>
X-ClientProxiedBy: MW4PR04CA0099.namprd04.prod.outlook.com
 (2603:10b6:303:83::14) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB6264:EE_
X-MS-Office365-Filtering-Correlation-Id: a077cfe7-2b22-4d45-a39c-08dcf9f65458
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VqwLoGC+1zJqa8I1r7/al3H7ChA4V141hhzaOgUO41kfWSTKo9u+NUEPPOLH?=
 =?us-ascii?Q?LxZOUX93HQbCX4v7PAz8qBKwV+aUIYPOZc4uUM4T5N4RHBpeWU+dUrSq7KuH?=
 =?us-ascii?Q?knO1os0Y2K8REK7eFVU+VEgnSqpWC0Vz5cID6MMctbZ7pAvIQ1QFKITzRXz4?=
 =?us-ascii?Q?Yso9M9lgYBJLkUD8OcPPPUToz6Tw7Fb03NW2ztTcKkDeGNOJpzY7TOBjB2d3?=
 =?us-ascii?Q?OZU2SR52N1sveVvOKPUVoUf6JY6tdhWALvSCfQf3NvPGWKqALUMtlCeivs12?=
 =?us-ascii?Q?KZy7LLDFbc50zbVi5+g4NGIClCYi0RVo4x5VxNtDaDwKGYnSOIS3jcyHNj3J?=
 =?us-ascii?Q?GOaFNQAtgDxijDT6UhLxuiogwmFWIXg6sR3TkslWTrRzaAF3OVKfop1IPAzs?=
 =?us-ascii?Q?tmlGO9xGW73Uq5RIf4H/Pa6fNVUlfjadgjUHXErJM4qMoHCtzv0MQg9DLYDX?=
 =?us-ascii?Q?u6CBGjtPPu+k+hlxBGcK00LulfRUjHTZJHNE4pr13UG++Z7f+gSrZMcjb+K5?=
 =?us-ascii?Q?rZsluNqDz8WuPIF7hF+Y5IQ9x/RXrqwXyOtZwvHy+OKX+eyOVK3WHO8ttFaD?=
 =?us-ascii?Q?y8m5js1x00txGu2Dwuy1+maeid+bRUMON+d/t7EXBVe1PTNFKIvHuC6OmXMs?=
 =?us-ascii?Q?YGl+UGySGKH8rVFWoWQfEBUbq3YagNrgyMPdccGSx9odPwqGetM93iPgqpIN?=
 =?us-ascii?Q?00JPDPJbI5D/s8HEiGVk0IAgdUrJWNAFkn44DXVkPCT4IpNhI8qGvs/asG6n?=
 =?us-ascii?Q?EMWl+b/i84GzEfIeJTd2K/CFlCHTO0iTTVUHSyOI5YUsnee4MBmOoQ7F/RwY?=
 =?us-ascii?Q?EmCZQK583KFpsliq+uoCKyEoUWhPEQ7HUcdU7yte9FhziAai9MWiEXpXKZY7?=
 =?us-ascii?Q?+7AaMB1gFb8qoQ8zm3C/eiYyyH/PFZ48/ltG/5DueybCnvgiMeHSo9wuZ1H1?=
 =?us-ascii?Q?i1b1KHSQq/PV556RCMwbILlL+6L0RJ6mgcB3URHeeBRqrmN9fmtkLIJbl1Vl?=
 =?us-ascii?Q?DEZFjBQdQlC1t8LCMh0+twKyKjbxYAQYX8Il7ZN/fKdys3iY+OszU++4wzfV?=
 =?us-ascii?Q?sH5FN0wA+TvjEE7ZSKkRsC4Lpxc/evhOvLlfIqZz47R4p1y0CmyE9viQtDSJ?=
 =?us-ascii?Q?uoIxpIVSTf4i+8IcFMjv+4ETTexfI9NW5t2CcjiKrvTapHK7bwqEtoQtqaAn?=
 =?us-ascii?Q?tFWWXp6279qFLr1Antl0vGfV2BGVMX5mOQaH7JRg6P/7ah66LTM/ftTABcW3?=
 =?us-ascii?Q?bJwtVWkru4wtjttWHkZVVrVrdcAtkzY0AgXrzd7XiNWV8ICkR19DeeTFHSZ3?=
 =?us-ascii?Q?gIRRgt4E9Kty4dur7oggNrlU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oHQmp+ZyJuUHPcFbhJcqPhlW/1+az2+yOCstwNj9VzkOtQ6hbow5R4cQUphO?=
 =?us-ascii?Q?v7x2Znc8+zRyTpQMmSoPvH2CdOIp3Kbym4MxEAcRDw5PaVhcdtWxH88QnzQ6?=
 =?us-ascii?Q?6HBSrx/sFT16Pf+vhPoR1oJAtWX+CvTJVekO4b8G5SeG0hdn2sdEJXbZb48v?=
 =?us-ascii?Q?iiX2UWh/nhYlNbBpqkK/EkPG/GNEF10TxYeP3AssL4kL/vPGwm1i8AfCkEg1?=
 =?us-ascii?Q?CL+lyl0fBJFCDTGuquQnfiGOpyeD1+E4bF64UCJCSsMP7Vgt0zgNrtEYgbTz?=
 =?us-ascii?Q?cVYrWlTkAIEw2ndX7L/ydiItpTCHLIGQssJUZNjhZIN4+TxNkbpREteDWFbc?=
 =?us-ascii?Q?uTXvN4GzsSwEPnm3+c7+N4tLtJETalcG4bLykHPFN51GTAvwTntQmEWaHn4a?=
 =?us-ascii?Q?427lMGAOoQlRTSzcxmTH3OSuU6VMfOhl+u3UTpmQbve/gCmdpjRiEXpQSFvj?=
 =?us-ascii?Q?lIiHooKDUWKu0XvJRYMD0FUVi+68jcRzYEy/Ml0+U9zke+iOWKPB2nHnDk5l?=
 =?us-ascii?Q?9HULQ7FvNfoxZ6I0cW+OwxkRZ6mbUKh3eJPgOHhXQUyCCpJg4hg+wMnA/Da+?=
 =?us-ascii?Q?QSd+mLjoqltbO01HK4DYgkB/e2ECmTwoY2xtZVawA6lf5uGlwTcg11Jo71/6?=
 =?us-ascii?Q?xVL3hKs46xcjqh5A7Bw9ih4pDSNo3wQJQvq/8OrB5OKCB0cXlsV1CJn/KnU/?=
 =?us-ascii?Q?y04tVU2vdO5kT9Q0wlAyjUkOB2jEVHTu+1wX1taLDJ2ZD136yFPtoBPGW8Ho?=
 =?us-ascii?Q?3J5mx/lT3yBKWBRco8ZsEwNPk9B3HTeIzU7cvtfUwwZjZCYje5U0i1dWrdsu?=
 =?us-ascii?Q?cQOyqQGLNP4UCl2iQ3fVny8m22V7upK3LU5F0hcgQiP9HbVipDoCb8v62cau?=
 =?us-ascii?Q?tjYlaGwNWt75HgEKDtjMhjuk7SR+tXP4r4dQPcU5pot611A00jYJh/FgmNUS?=
 =?us-ascii?Q?vs6THzhl/1h9Q3TAlWILtTVDWXiUgfTiwRhioxA1iCRkEQT1jgjrXdp092fr?=
 =?us-ascii?Q?3guccGhpLrFMY6TZBVOr313J8jJD2QwqqKBZjxOQviYFnrGtR1D8R3rMflRV?=
 =?us-ascii?Q?fDxSBZb5T+9EL9nDOfgU8l+W7NDPCSvUi2d5riBQAIJs5mBcSrS7wnM50qFm?=
 =?us-ascii?Q?//tJOb2cG34OGpebeoErwyqY7Xs+vgOISt5SjMaage6z8tRp0XZDHWvce4LL?=
 =?us-ascii?Q?0VfSfADm0cSksNTaBB6xISOmTkJ0vWfX/6bjf/AOa2jP+rm+1fon6atztQWq?=
 =?us-ascii?Q?BUx+bb1Wn/hc71M4oQ+dbg7VMcSeSthYMn8pn2hjcIp070O1FMBsiHkjNqhC?=
 =?us-ascii?Q?tk+lHO1pzoDnMpuBEKkhhA2PBVNQuUk0WBjJSAGGnJsnPrfihfmRuePL5FLt?=
 =?us-ascii?Q?k6ZkfO0Cls0E5t0peWDrcu9wokh6p7E1UnCdpeY7PiXU073KpxxEJ4+fRP0Q?=
 =?us-ascii?Q?FFJ94ww2tYbJEUf7WqDKicCpWyd7SZ4VPBNhqUEkcL56kwIe1g4YxI1NK2IT?=
 =?us-ascii?Q?FlkB9RY1QHgLqbJtYkwysuGM9ayA3sQ5rYHhwnfw6bCC0NPdQvS91Kl0x32A?=
 =?us-ascii?Q?B8CkMni+teIe+EW/qw2iJYeW7HZvI9btIp9G3ld2MD7ffmA5E5IIJ/M90w0Q?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a077cfe7-2b22-4d45-a39c-08dcf9f65458
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 21:52:35.3960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ngplVNKHDeIA1VNHZ32eJLoPzQgR/65ieYXbSEmF8TUBmtKX6a938BCtpuKRdFBrWsqv+WwiCgB3K1P98F5xs762AG4Y8R88sPGJlnLq0sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6264
X-OriginatorOrg: intel.com

Huang, Kai wrote:
> On Wed, 2024-10-30 at 08:19 -0700, Sean Christopherson wrote:
> > On Tue, Oct 29, 2024, Kai Huang wrote:
> > > diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> > > index f9dddb8cb466..fec803aff7ad 100644
> > > --- a/arch/x86/kvm/Makefile
> > > +++ b/arch/x86/kvm/Makefile
> > > @@ -20,6 +20,7 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
> > >  
> > >  kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
> > >  kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
> > > +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
> > 
> > IMO, INTEL_TDX_HOST should be a KVM Kconfig, e.g. KVM_INTEL_TDX.  Forcing the user
> > to bounce between KVM's menu and the generic menu to enable KVM support for TDX is
> > kludgy.  Having INTEL_TDX_HOST exist before KVM support came along made sense, as
> > it allowed compile-testing a bunch of code, but I don't think it should be the end
> > state.
> > 
> > If others disagree, then we should adjust KVM_AMD_SEV in the opposite direction,
> > because doing different things for SEV vs. TDX is confusing and messy.
> 
> + Dave (and Dan for TDX Connect).
> 
> Agree SEV/TDX should be in similar way.  But also I find SEV has a dependency on
> CRYPTO_DEV_SP_PSP, so perhaps it also reasonable to make an additional
> KVM_INTEL_TDX and make it depend on INTEL_TDX_HOST?
> 
> We could remove INTEL_TDX_HOST but only keep KVM_INTEL_TDX.  But in the long
> term, more kernel components will need to add TDX support (e.g., for TDX
> Connect).  I think the question is whether we can safely disable TDX code in ALL
> kernel components when KVM_INTEL_TDX is not enabled.
> 
> If the answer is yes (seems correct to me, because it seems meaningless to
> enable TDX code in _ANY_ kernel components when it's even possible to run TDX 
> guest), then I think we can just change the current INTEL_TDX_HOST to
> KVM_INTEL_TDX and put it in arch/x86/kvm/Kconfig.

I agree with Sean's later reply that kvm-intel.ko should fail if
anything that is expected to be there and not otherwise permanently
disabled fails setup.

However, I want to provide a counterpoint to this "_ANY_ kernel
component" dependency on being able to run a TDX guest. TDX Connect like
SEV-TIO offers device-security provisioning flows that are expected to
run before any confidential guest is being launched, and theoretically
may offer services independent of *ever* launching a guest (e.g. PCIe
link encrcyption without device assignment). So longer term, seamcalls
without kvm-intel.ko flexibility is useful, but in the near term a
coarse dependency on kvm-intel.ko is workable.

