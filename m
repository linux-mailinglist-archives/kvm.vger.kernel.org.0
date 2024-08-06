Return-Path: <kvm+bounces-23305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F3F948803
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 05:44:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92BB8B22988
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 03:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E13173355;
	Tue,  6 Aug 2024 03:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XIlWaUnb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204BC41AAC;
	Tue,  6 Aug 2024 03:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722915827; cv=fail; b=U7nbBDSeHslLSMMXhGSXHrHTJ/G2arr+SCQBMVu/U20F61kBGon9LMs1j4XyLGj1gD0wpAggxw/N4dk8QKT56eWF2hfmlS/5v9gKvsNh44SfjqU0UAC72kt34y2k/VyEcOlMoxlwew5iHqxF+vQfCLqvlrxAby9D0mF+ulHKGZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722915827; c=relaxed/simple;
	bh=KXNkHRxpns4SfMAajQi0o0h7NPIilE9QL22s3oO1vgQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hcfT4vRNlBSoprFSUPQ+7MHqxFmUVGlxKEa076UTzJLUn43jPJUJ1umLmpm4EybAKBX7g8wolhLBWazsfjZ3dpFmfcENjBYeUaRCnxgRUkhLSN5rEP0Bh0C5Z794EU3FT+QIzbkluXnY9JsOeEL6bSXvUb5vwZzBIOy2bXwMmII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XIlWaUnb; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722915826; x=1754451826;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KXNkHRxpns4SfMAajQi0o0h7NPIilE9QL22s3oO1vgQ=;
  b=XIlWaUnbCdjRTbfSJe7yg0IWxfbd+PMcG+wzbRKR+hoaPWvPelafSv5I
   yoEWGGaVDoJdu/DP2soRHUeU3/+MaiVSvmbUatVR+XU/pNBMrGORQvfpq
   UWKJprRQX2kNLHo8FkuLjoRskoSz4wTKFIGqhd+UcFLoKoQcbaCEmZwHs
   fXMfvL84ukbbsUqDdUzU5XTW+ys3pG2//mbajik/bdQ0hDpUGPMSWat80
   Kcwle6MnnHroQnqvas24yPM2XJFm43KL8SdMy4awur9UUwXGVSOx7THjl
   8Y3AuZl5Q6dG9RrT8tHhkcRX5BI+xv41vt7cVRubh9d0E7VmlzugZSKcO
   g==;
X-CSE-ConnectionGUID: j9+waDoeS0q6kjJSfPOmYw==
X-CSE-MsgGUID: U4xFQRHPTYeJAz1FY/wFoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="21030571"
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="21030571"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 20:43:45 -0700
X-CSE-ConnectionGUID: jNx4946nQ9q9GvSZFHgicg==
X-CSE-MsgGUID: OTKTyBc0S2+ebZ8edBzSvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="79631535"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 20:43:45 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 20:43:44 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 20:43:44 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 20:43:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i8rncz7c4ufm5WAhPBhPxscPQJ11av7c53SHHLgbByRxEfZKrgRfGHN8ZzXmKOkkBaM/mgttIK1GLPNk4m5meMVeNPCSeVgmUfNNrrmcATSv1uUDcDmoPukHxDBQB6WElPR//JM+MxNAIPlTHLp7IJmcGX7ceQRqjoRe2bjBcgOxPM18PTeZo4/PMcSipO6ZxB6RqYiOCQdT0vkQjzvKppb0dQpOBsVLZALgjJKvIPu3uapAmELSkYP3bzcFg6ttv0gpzwYhs/UUjLHRlUpQq448eSuSjM63//h12/wj7anRb+epm9XVqHCk079Nv7WcgmfmKAYvfiAVROGcqtwKew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NQ0dQxvCZYa+jywq7TV1C9JiBvOP5mW7wrv9UjnwR3Q=;
 b=iTdAyxv5IZnjPHHQHS63ad2Bdg+qma8IiOa9OAFXgkQU/fbCfXpZ1i/OeV+2jJUIeDlpmO3nh5vk82Y2g9+ZLfzXIAvcI5a6H11cT/DZL+mZvyz6HLutUgVM4jcf7Jaig9m/NQuuaCbx2cHP605f9ohOJ94XwEDgNUgsrPnOgh/n0bvbR/VHZMRBn9VjL70popiFwuIJ1Rq1oF8JYZA5x1wC8MxGHM7AO9GFxhyeHAu+zbsimRVdoNLRGoLrBhDYNlIlz4jZjRbaasynEK+26XcZyLdXajomyi2txFs5/i6XvZruq2zQZxLr/9rZ5qZXzGmk6sU3cyJ8lFVovlMBmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ0PR11MB6621.namprd11.prod.outlook.com (2603:10b6:a03:477::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 03:43:42 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Tue, 6 Aug 2024
 03:43:42 +0000
Date: Mon, 5 Aug 2024 20:43:38 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dan.j.williams@intel.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v2 06/10] x86/virt/tdx: Refine a comment to reflect the
 latest TDX spec
Message-ID: <66b19beaadd28_4fc729410@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
 <bafe7cfc3c78473aac78499c1eca5abf9bb3ecf5.1721186590.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bafe7cfc3c78473aac78499c1eca5abf9bb3ecf5.1721186590.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR04CA0239.namprd04.prod.outlook.com
 (2603:10b6:303:87::34) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ0PR11MB6621:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b09fc6b-2165-4e1f-5f54-08dcb5c9f726
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3csLDe81hzvcJZi32B86PqKEJ65jxsmxKrjvXV5vcrX1/RbRmoCBpfAzx2iX?=
 =?us-ascii?Q?O0Q0QkL6FtmrIN3noalnolePLArukmnqCt0ovIffTfYWKlO19SrGAf7r6d8O?=
 =?us-ascii?Q?/yUUfZbG4kbZ4unQxxstckoEnU+O1HqI1Hvropm/tmnUdI3Szk+tcyjc8jAU?=
 =?us-ascii?Q?p6cC/AasbJkYTGqtCz1b/rbSVNM6juMoyalz1VMTacOluY/M2y+raZBetE7v?=
 =?us-ascii?Q?7x2GebKakCi/9sR/R2JW86B4DJsFSoiaAX7UWDe0KP0V87HshlcMpqbDnsTG?=
 =?us-ascii?Q?3ywuQMIUI4ck7Hr4PtU1pBSExGbilT01eWJjpjj2lsr0pht8eWaS6uVV8uMq?=
 =?us-ascii?Q?eVF23L85i9IFRES1Q00qvbZg2YHWZXNrJgrGRTQi0cNU+FavelrQO1CGtKtn?=
 =?us-ascii?Q?ozT8HqEh1WsNyySyaSyzA6Mw2lEBTWjS2GNBP0psvhmaYQ7IJIXVah0t9jwk?=
 =?us-ascii?Q?fks44x13f7cQlG3WxzflMnHPX2Pvq2ct1QEzfoQYRwqnu16qWSfBWRN9U6lK?=
 =?us-ascii?Q?dp28cvAaU8BZAb0wUKAxfPqTDcI5xFFNxukwixOaBhZXynBTAGsL+ZHYRpla?=
 =?us-ascii?Q?9/QCrSIHS5R2WdGk1avQDSl9+nhJvc+buhZUhyAuf2tNQ84XU6DlHayimdN/?=
 =?us-ascii?Q?YH7J8+eQGZdJ8DjkTqcbfpxR3CLx0P/u59u/KAiwmxUaD4q3ZcsbbhBxHkId?=
 =?us-ascii?Q?t9CPLxV7VAVcKR1QQgbNXZJmCMWMw1ateUa9/Rw+Xpzl1pF2C9SgHF3Z1ReY?=
 =?us-ascii?Q?ozr+xUZY/fJAurUbx05WzvjBDr3SLgaup2gBdzPPXIRZHBp+onPq0F6T1FP2?=
 =?us-ascii?Q?TUW6Cm5fKlX3C9jBtkFv1zs/o1YAP/T+WDVPNgdzpu4sABq6kpeay+9Qp92x?=
 =?us-ascii?Q?k+Bt9AuoW8de9+lenLehmWDcE4/UnqHOBc+jaFRi2cBFgEDLxNS3bF0C8Z0O?=
 =?us-ascii?Q?8Td4Txb53zWfubGpkt7HnCV4aXnG/gEGDCIv9tr9G3N0QSHPNaC4+MOqdAeU?=
 =?us-ascii?Q?IGtC6mI9RrGeFtjZbypXh5sPT7uVqWRQKIKKZ6d6slW+Wgi7faZg482MaVrq?=
 =?us-ascii?Q?gzBJrBMo1gYKXK2IWgk+QTL8eYvD9PyohVhBgMRXgutltfm8pfQ55ShP7OZS?=
 =?us-ascii?Q?D0/2kqED0ngHirqSSKXvCKRg7ZCJc8FyY3ncjUdCe2Cme+uC+UB8MkyHQVw1?=
 =?us-ascii?Q?xVCLQIJodG8fuPKUHiljDRAsiJrOllwJkmiMawFuDGkBmhcb0G5xRO6/+OPD?=
 =?us-ascii?Q?VcDRUiX3C6DGwBV2xnpKJqHgr+sLbkZeByFRs08z+zGlm09Cxyt/sOUIhNAF?=
 =?us-ascii?Q?H5pzE228NZyR2qfX+DmdEm8f5BCy/Pi5WOwpTVCGjfEnaJLNwoQggmpH629E?=
 =?us-ascii?Q?99bVj9pQXz1c2TVTB2FN++cMe+/IDuaon8pdHYG5wbhp0J88uw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0vwO2uGaFvR5J+hLclS0dnMrjizK+jyyQJpWWpE02TuGDNIBA767G+sgOuEs?=
 =?us-ascii?Q?RVyb8BRk6zIsrZb7iBTrC8QH+KVBkoIbA/9KomOrILTtOh4QzVsR0+ckWf1g?=
 =?us-ascii?Q?RRFA8CekvJogmH9knCQMtKrr4AcmHs6tt8K502QXk/8JQXAILU2KYefiQmB6?=
 =?us-ascii?Q?4ziarMsRPzNY81K4Jksz8Oa0Gcc29MgXb4L8RTU+Cwv3frBpv7bco8uwOtI2?=
 =?us-ascii?Q?dC6ut6j02xjxTgFV1xLCUTXR1ZbAb32jloyyQnXnaJeVh80olVMWTCS/U3N5?=
 =?us-ascii?Q?N+n39gdPrezRB8V3uW4bD20QCMQnM9G6C3HOgpmsooO+oIbzzj+86YJGsE2+?=
 =?us-ascii?Q?VRSvqE9fxifdcYBMLzYAOPEjjZl1Ie9yxm2I/tcCnKJoMVdeowpbzTJ0tgqB?=
 =?us-ascii?Q?HwlFHlKoK4N1JNiKgaxNl3GoEkKKp/GdymX3Oy5zVwogmAPeqebtvWLm39KM?=
 =?us-ascii?Q?uI8bUUqiE3iqQ+f1ctxmLmGhq3tmwJS19GdyMczTEmNyiWiSSEIH0mnO70IN?=
 =?us-ascii?Q?JcouEkhtnHCsSangZRFQxKIjsFabG+1Clss5zNwjiHvCvnQ6YZ3E3aEJojAr?=
 =?us-ascii?Q?oZlDjhMke8NtyS/DaY7GDboqRk65iAfOVk2zKZjqLcIAWKplUZbPjqycUmDk?=
 =?us-ascii?Q?7EfPUVvaz//L8Esl8sgONDiVlXLVNCUfG74oTVyGwBDOhQjazsQErCH5Mzip?=
 =?us-ascii?Q?6Q6cr4Nk3YhhWHrs6tf8kdKz0B+1ZdgjIl9cloGDMkcVfcVr1prX7+CPIEPC?=
 =?us-ascii?Q?1gC2lIauhi8o2MMV4fUOcgWrGTvL6G4NvetwQi5K9NTkwWscQvw2sosPNCzc?=
 =?us-ascii?Q?vwT4fODMzFeP+mXOI3aaeh6HUc/DrUzBdwFYOAt6pbTeVYMnBI2h5Alviqnx?=
 =?us-ascii?Q?GpGCbrqaLQOxXPisOmXwabSmL4h1AQZmWcQ4SpkCu8YbZ7Y65Cxw8V4cJDvs?=
 =?us-ascii?Q?KxI7uCAQ5ogcNDivgiwjWHNllKC1Xakc4ObjASM16a+AKqempyquU9nJ/n3i?=
 =?us-ascii?Q?pXti631LW10zB1/y7gOPbAjSsE4qlXJ7bqMtu+1y2vMF4qSC60fENAKaizQ3?=
 =?us-ascii?Q?0F3HPQzophpxNJhK/y4BWnuf6Oklid0Ea9yne9Jbl+QJxbrWQG/CmO3NNdyj?=
 =?us-ascii?Q?f6vjXiMqp1/+CINOF1yEF86T1CP6aInIQuEOOjKVH8TeTbsOuGm1rysUUcsb?=
 =?us-ascii?Q?BciE7eWakvxFgBJLVwX7dSlrFkx1ayzRABFmsw8exVvg+6jjTgqj+s4e0bxT?=
 =?us-ascii?Q?Y6BPFckBE1/sC4wFhh1guZjYXevjcyTgor5U09rVGIzWmqmTdnQnizn0/qP4?=
 =?us-ascii?Q?fOnNjxbeOLsllJt1VCyYA/gSZOkHsVBw1SsIyH8LJosf4zdzoIvSvLAUi3A7?=
 =?us-ascii?Q?9UKU2CdLM+IcQEcQVGlItjs0Y+V1ckPPwzswhxYHrtAy2Y82sLOPBKM11PpO?=
 =?us-ascii?Q?RuEcB6L8OdFE7NTa+WPj+EuyweA+3/AkimAhnuBD9QAQ0BhyO3QqAreHoz94?=
 =?us-ascii?Q?ywx0+DTCeoA2gX4QUmLy36sdd4MpUBJ2AH0Av26KuukrVvmJcaWcf3ukMl75?=
 =?us-ascii?Q?uYxchN4Qz/8gJGGelHczQVgw2u28zuvzXU0QRaHWNUcZoB45UGgK6h1mPOAy?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b09fc6b-2165-4e1f-5f54-08dcb5c9f726
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 03:43:42.0777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q7YJgfgdbUk/r31s4qTt910eYxAdhjtBKTOyeB2xO52Py/6lv/kx+anFLurIEQsbxMeB6MBM+8cxWZseTGXMnnNsRD36gSBRyEza5PDRvu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6621
X-OriginatorOrg: intel.com

Kai Huang wrote:
> The old versions of "Intel TDX Module v1.5 ABI Specification" contain
> the definitions of all global metadata field IDs directly in a table.
> 
> However, the latest spec moves those definitions to a dedicated
> 'global_metadata.json' file as part of a new (separate) "Intel TDX
> Module v1.5 ABI definitions" [1].
> 
> Update the comment to reflect this.
> 
> [1]: https://cdrdv2.intel.com/v1/dl/getContent/795381
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v1 -> v2:
>  - New patch to fix a comment spotted by Nikolay.
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index fdb879ef6c45..4e43cec19917 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -29,7 +29,7 @@
>  /*
>   * Global scope metadata field ID.
>   *
> - * See Table "Global Scope Metadata", TDX module 1.5 ABI spec.
> + * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
>   */
>  #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
>  #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL

Given this is JSON any plan to just check-in "global_metadata.json"
somewhere in tools/ with a script that queries for a set of fields and
spits them out into a Linux data structure + set of TD_SYSINFO_*_MAP()
calls? Then no future review bandwidth needs to be spent on manually
checking offsets names and values, they will just be pulled from the
script.

