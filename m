Return-Path: <kvm+bounces-26043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CD7196FE1A
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:46:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 445502871B8
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 22:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347B615B0E8;
	Fri,  6 Sep 2024 22:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NQKwhf1L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA942D045;
	Fri,  6 Sep 2024 22:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725662799; cv=fail; b=JzYgb+oo12LdAzW/VEl9aDdDCOEsqxYFUNRia0iQ2MFWIwFFTvhGhUoc1LRRJcUChEy1N1PQ7He4e9DuhsP4i9bXRRMSb7BiWyDZZ3nKtbX80bT6OP7eLftedMvcv0piPAfRt9uyu90dNftDw/ptul8EXw1NXkyiQLwfjpTKLB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725662799; c=relaxed/simple;
	bh=ekNR416xwl6lAtPDbRri6w2ZryHoAvXhEHqYEGbodBo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ub6hOPu6dd5HmIgutauCHDz2Di5iNEpRb8n0FBJRvIFvCxguSHytjZkXQjA4NhklncqcVie2exRt/ZUfjppdqnFmzUDmXdOCaDrJijAW/2py7EKPUb3mYm1BYDGxC2dWOQnydQ/2tZbaBWcT6t46/ccuOT1wqjEkKFD4NWjmp0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NQKwhf1L; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725662797; x=1757198797;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ekNR416xwl6lAtPDbRri6w2ZryHoAvXhEHqYEGbodBo=;
  b=NQKwhf1L73nLGkaf4vDivSk5mT9iEJ3nzBjZOYK2stGHPz4e0sFNyFHK
   NuMO5rb3LkIE1HM9+4Mb7kRb06ZMfmWZwHnF0vZiT1h3+/ZfVPZGLlCGg
   6l4BPmd2lsjn+zeq+D/BMYjxel/EU5xSIknKHw72hQ38ttvLHdtZXbGSJ
   mdOC/76hLMblYvfqyJsjibvU9HOIVD4XS3vNwoDETtP20rtWeeD/UMRjQ
   6sF8AwSP6BMJ1aR5fx5mANpR/AZXZYh5XdCinhnh0326P8HEqmnEPuoFr
   ruG6MDLz0o1ioG71ztlx2jKghCXPRjo5+KALaAdsNOCFpq0QoUVO/D4iW
   A==;
X-CSE-ConnectionGUID: DfKo4SVaTAySB9RZtvstTw==
X-CSE-MsgGUID: mLOw0/gGQHCLlgRefK09Vw==
X-IronPort-AV: E=McAfee;i="6700,10204,11187"; a="24583830"
X-IronPort-AV: E=Sophos;i="6.10,209,1719903600"; 
   d="scan'208";a="24583830"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 15:46:37 -0700
X-CSE-ConnectionGUID: R7k+qx8bSNK+My4zZJOp+Q==
X-CSE-MsgGUID: KHeldy7GS8CkM6KykzM4Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,209,1719903600"; 
   d="scan'208";a="66822754"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Sep 2024 15:46:37 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Sep 2024 15:46:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Sep 2024 15:46:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 6 Sep 2024 15:46:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Sep 2024 15:46:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RcWx1GoY9/4UEP2kfSNzV2VwSNPq298uvlW+Mduq8d3ao5QK6taKn7bURYTC86JQDARtqoGqs87P1h9M7XPXmySXgAQLpXEqKdUEdZRMsDCrVyFYIdEfrCZna/71E+OX3zBXh02fmNpR4vl7bLOD1fHLQoGarVOCL+fD17LHacyM1kaOBMyNY5BazblsXbDRy9vzYPCbXSp/mDbxeenNSsmHi9c+ELHKVvWslVT0FkClJUlC4LtVYAFrDVKAK7GGv/HOpcu/1gr6LNpZWQ7pUivJWh0Qc1bT9EB7kCgYuTwAazZGye+sato4U871ju9JBRjTAdKZczCi4XZDz+XDGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qq/SNkbbROlEoEWQqEbvAR+gl+ogeaONMW8pq48bAyA=;
 b=yI9+JASZxSB8tzVLBapHAtN7+k3HYp3tHdTFJDW8bZcybfn5iRdM6z5y6mIjsU5BvrtyIW3rMEPKThsSr9fApV6fx2zqrI6ONYnup3NjbLrQWEVrnO55PdJw08ZulFb9kZd9Z6kcFign3udn0uNrDVc1kjf4qwlGHJD18jFFEiQsVu5aecZ91V7oUm3B2952Wr05MdbEVD3p/66I/IXmJjPSpa/YMG9x/d5IpdmQcVlyWDillSih9mYthgMJksk4aZaS3F8LIQLmYbhEXVr5HwmtzZ3KvcFjsm/v4JWV0guPjR6ofNZc+9KTpeYCZSQMo/1c9lxBYuC+Cx/U2+mCNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB7794.namprd11.prod.outlook.com (2603:10b6:610:125::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.26; Fri, 6 Sep
 2024 22:46:32 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 22:46:32 +0000
Date: Fri, 6 Sep 2024 15:46:29 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <adrian.hunter@intel.com>,
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 6/8] x86/virt/tdx: Print TDX module basic information
Message-ID: <66db864597fa_22a2294ca@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1724741926.git.kai.huang@intel.com>
 <ab8349fe13ad04e6680e898614055fed29a2931b.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ab8349fe13ad04e6680e898614055fed29a2931b.1724741926.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR04CA0299.namprd04.prod.outlook.com
 (2603:10b6:303:89::34) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB7794:EE_
X-MS-Office365-Filtering-Correlation-Id: f363f31a-737d-403d-aa13-08dccec5c0f7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nlLF32JZ3vbRaBaa3GtQ10nbE3foXXeCuSAV8ZS4FDmDa4eK5B6nC15y70i8?=
 =?us-ascii?Q?EXnhOiE+tgx5tDKPno6sNcHgdlXQXDcEFOzcH+7ov4pAj3VWAAKm5HzQNYeV?=
 =?us-ascii?Q?HvOqvqEY00nk/S9m2dAxMNd5atz42iZjE9in2vwPxXjrzK7cF36OEQkCdZ3S?=
 =?us-ascii?Q?nOELn0nGGCWn1sjB3+kAjZQaEbZqUBEsjQu+oM8GOXmzs7g3u5oXbTAbGpL/?=
 =?us-ascii?Q?/aetSKtrg1Ricjca6PA9xkP8cnaS0ggnw2M1aQNKFksep5WOH3YjStzH2Ppk?=
 =?us-ascii?Q?PA4/5k2FKgy0xRVRKZF9ppxMw8ozE9sIs7TXnroyZNIyIJDBhpflFZbJ7ixJ?=
 =?us-ascii?Q?P9jjKn22gMNhQcg8hohzfpBOhfJi618zKxKPvz7Ebd1Dcaao6LeVBECmhqED?=
 =?us-ascii?Q?YGC1B9FWwVHrojaASoOi8L0PRfs/3EcSgedKTrxVIA55zTedmRaHwJADKHGz?=
 =?us-ascii?Q?ktje+VAx9zZX6a+Zfm2VKroztZxHWEnrdwVUekVKC9bBV+E95hHNAxqmQxKO?=
 =?us-ascii?Q?HYAGZvI2wZR9WtCYtQP1+HWMF180J0nobds+0APP29Ya6Vftn8/7260MFxLp?=
 =?us-ascii?Q?MuwP80HO43SL1iFKwnIq+y3uWyYA1YvbjV/9gr7iUUQALWdhwiBbSGKjM3d0?=
 =?us-ascii?Q?Aq2HVgltlyVwro1qPRE8y2YldsVNLmICwqsqtqPY8PWbhB9w3iTd//derEFE?=
 =?us-ascii?Q?7Un1oeMgc3GLd0B7Hmal9bOS9pI5+G3FYCR0Cz4QDDL0Fr9J2ler1rtVck3+?=
 =?us-ascii?Q?g84gLrMjo6pT8krMlfALTYnANct2Mh3Tuq/NDpXe9TIckcL3rWcEcbV1xdHG?=
 =?us-ascii?Q?9AA1JYofZiGdV4Jr4OucR8GdEDtT2cgexYgZCKCYZ9rgBMj2RuhuZiQJnf59?=
 =?us-ascii?Q?GNrIXUfU652ig/VgDjSbE4gWt9Bb3CrW831BTYw/lcDW49iizu6tcc7iVg2p?=
 =?us-ascii?Q?v/HwEIN4ZA37fqv4zgVSNLyb8hn7oveCQMeFEj1qtZ4cMLCr2AxdyWqAODjx?=
 =?us-ascii?Q?rlScsGIGCGua/s0cYZ3b2erKFowOXugZJBXgiuIDC+xs955XB7ie3xmEZkxl?=
 =?us-ascii?Q?GQsXXwOIeqGxsTTkaBaLyTsUw6vimxAM7b4P1MJcyWY7KGdicVWOPkZLGxAW?=
 =?us-ascii?Q?BFAo4scgXTgF5+eod60dAAieRjKh7+5J5FSu0cFvsz6fKYDFxs37OHdu7oQW?=
 =?us-ascii?Q?MYJgh2PbvIjI7qFwf/cor+OPDkV8v2ZDfoXyRxScTlOralwWuZqKUSI4i6hW?=
 =?us-ascii?Q?1R5hPLYRZKP3A9DfWw+ue0LjIWzWJXJhoS6I4b4bpi0+6g2VGXnGNb6Csn/e?=
 =?us-ascii?Q?cs4plZSn+IPCu0GhBLWGpZ28v707q2f+x9HY2jV+WpTF7Jqw8LQTuc9Sxqj7?=
 =?us-ascii?Q?KFOT/Pipuv3EyzqD8Kt0FTz24Az1?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MUXk1IqieMppveHUYdeQ0JGbDbf9Pff7kBCh6Kiwm5yXoYKcNwQqIoS66P/M?=
 =?us-ascii?Q?vmNX2Ckz++xKc6Y7z67OUjlyo5iBUapl/eUyDVMRdyqKvlFDODZqC2G+BqgH?=
 =?us-ascii?Q?sYIsJ1bh1gWZqV+4KuVEioamW8uuX41gOJQnHm5TcobqPQjxSX+QncYg0Vv+?=
 =?us-ascii?Q?CrHclV5gq2i7Gl7NRWL73QdiJU0NVn6jfXA/fmCAPKZv8POzUwJgNZDkdNJK?=
 =?us-ascii?Q?+5in+zqn2rNAV2Rf0rrN9nTfu+C9j56/9Bjt3nkyW2DuPCp/YfxYI3xbOlMu?=
 =?us-ascii?Q?teIr+5UncQLHWBRV2JuLfTQm8QEV6Ql++WV/IwIbA/8EGh6RSFIHWKzFTMry?=
 =?us-ascii?Q?0jpPXKvByqCovtVgiJ87lAMx5A2VXhxq4/0x20PM3Ami4JHGKRtbYPLocZQZ?=
 =?us-ascii?Q?CvBKtfN8mUL4kjMciVKbR45P/y6jaM/4tgzXe9zGjfLmHT7m3YQl7Le1OKaX?=
 =?us-ascii?Q?8tHsn9XaQ5I/nizWpPowDz2Zv1KxbmKmtomL+ZXVaS4HAgdd7OtSOpmX1eNB?=
 =?us-ascii?Q?w6E5Lq+DnWyh4loXyacxhXYC12XUFQserh43cm3Ebq6tS8H0Bra7QaY1s8Vc?=
 =?us-ascii?Q?Jd7FJBJXW85BVY58vMz/VOfXHulIV83iBrm8TeR62N9rHNfbZ1t/Z7fTDnpa?=
 =?us-ascii?Q?zOqJ5Zwp2q9YoJ8RSbhAwo1Is5TKPB/4lIIRJE4eoxz7+9d0j+yE6pTdnxW2?=
 =?us-ascii?Q?BcxiWKvQKQ/MCCJBqLkBQBxU4xul6IF1hOzEViUuJ9v5LKM+5++JdauxGhft?=
 =?us-ascii?Q?aneDl8GXZLzRQ68Or2xbj6KV0YCw4AhV9NnyRq6o1K3CdCfst7n+V6uku0GB?=
 =?us-ascii?Q?fPa8PgGweIVykBHDPK2Cc+3q7A9BXn+Nz0o55MOwrwWOjAGeFsGJhOt7HmO1?=
 =?us-ascii?Q?zJaLVw4fwdAZ9BXKiTZoMRwJyFGlgIC0cAgczaIQRMIh8HJozxAvV2tE3lN3?=
 =?us-ascii?Q?o8lTzrLW4ynv1/OZgf6URcANtt3mCoZpz1IGn0gCZVVpI1qAPyPhhV1QAG8J?=
 =?us-ascii?Q?rZ++HZwBAhrkzw6MQFPahRVtkQV1s79PveyYOijqbwU9rrp5sDDnNod4Kb/u?=
 =?us-ascii?Q?oS0q+fADghmhCoLKAKw+95YOXvjWppPJPD7EF997XavjvUly1nhyiIwMmzcI?=
 =?us-ascii?Q?DHn39G9tfb9nAPWjI6DwlXyLffMdwGhTNJuTQKDeYB81o0kgQW6etWgLhhQQ?=
 =?us-ascii?Q?UnnBEaU10eM8r80xAcnwySdIMpM7GygLcAgoq/Uu+Xzn5ABKtI2T0+kZyQaT?=
 =?us-ascii?Q?srT9fxySWeJGDaS46oNfpZwJb1h20k6dd2Xk3JehMZGi4r24T3Xnxv6uEqh/?=
 =?us-ascii?Q?v2ydQUIXAbczhmoKdXwnYoO+esy3/RQpKSN0F0ULYJ4tf9cgh9QMPBZUmuT8?=
 =?us-ascii?Q?JQKj1OQngyZ3KFeXmMHlEVzfKG+o1PHejb1KoNysmVDg+IyQDYU/Obz20Ybs?=
 =?us-ascii?Q?0GYFwbArL5YkyrQiUNajd/CYO475dg5LvuN6nTQsJ67HoOZSj4dYNC1hBpFR?=
 =?us-ascii?Q?x3gECg/7uRFBwffXsS8IsY5iI9GK72+mWyQSoh3iDgJMOYHGz1n9BurTY0Hy?=
 =?us-ascii?Q?OGxJbKGUVETquuuBV8mwrBwOLGIHfo/5+g1DUtuh+yRMZk+GRisr5ar0ru43?=
 =?us-ascii?Q?NA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f363f31a-737d-403d-aa13-08dccec5c0f7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 22:46:32.2851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vd/ExKojWYow8Xqznhd2mcBZicTVFmlC9ev294SjjILijFNcF1YQP/czx5V5TUyUDU8LcovRc5jMYqGx1D/2IVF5ULIzSnxG7Huk50SBeeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7794
X-OriginatorOrg: intel.com

Kai Huang wrote:
> Currently the kernel doesn't print any information regarding the TDX
> module itself, e.g. module version.  In practice such information is
> useful, especially to the developers.
> 
> For instance, there are a couple of use cases for dumping module basic
> information:
> 
> 1) When something goes wrong around using TDX, the information like TDX
>    module version, supported features etc could be helpful [1][2].
> 
> 2) For Linux, when the user wants to update the TDX module, one needs to
>    replace the old module in a specific location in the EFI partition
>    with the new one so that after reboot the BIOS can load it.  However,
>    after kernel boots, currently the user has no way to verify it is
>    indeed the new module that gets loaded and initialized (e.g., error
>    could happen when replacing the old module).  With the module version
>    dumped the user can verify this easily.

For this specific use case the kernel log is less useful then finding
a place to put this in sysfs. This gets back to a proposal to have TDX
instantiate a "tdx_tsm" device which among other things could host this
version data.

The kernel log message is ok, but parsing the kernel log is not
sufficient for this update validation flow concern.

[..]
> +static void print_basic_sys_info(struct tdx_sys_info *sysinfo)
> +{
> +	struct tdx_sys_info_features *features = &sysinfo->features;
> +	struct tdx_sys_info_version *version = &sysinfo->version;
> +
> +	/*
> +	 * TDX module version encoding:
> +	 *
> +	 *   <major>.<minor>.<update>.<internal>.<build_num>
> +	 *
> +	 * When printed as text, <major> and <minor> are 1-digit,
> +	 * <update> and <internal> are 2-digits and <build_num>
> +	 * is 4-digits.
> +	 */
> +	pr_info("Initializing TDX module: %u.%u.%02u.%02u.%04u (build_date %u), TDX_FEATURES0 0x%llx\n",
> +			version->major, version->minor,	version->update,
> +			version->internal, version->build_num,
> +			version->build_date, features->tdx_features0);

I do not see the value in dumping a raw features value in the log.
Either parse it or omit it. I would leave it for the tdx_tsm device to
emit.

