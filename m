Return-Path: <kvm+bounces-29896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDBA09B3CEF
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:38:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C70C1F22DE6
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 21:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128DE1E883F;
	Mon, 28 Oct 2024 21:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xq6n26jB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC581E1325;
	Mon, 28 Oct 2024 21:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730151483; cv=fail; b=C+3vp2HkpIXvbmisUEn+YUU2Afu1YZz8OH6ysWVjD0aNndIGOvbcPmTjsLuskBpUkpBzdVwnTIasgnYpY9dKGJUXVZSuffcadKIwZq+1NRbECgXPCTl2cNDc3ayIifK7XP5XZbh7avlGbD34BvhtfauQJQnheDj6o9CwBQZrPOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730151483; c=relaxed/simple;
	bh=ZVvBbYc6mPhGtFilUefbPzl6g598rcMC8Do+SO/ixaw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bEpsea95vBjI8RaZoPvcz3RPYve6aAZ1t083jg6x4MIyrWVZT8AQqnfezKQ/kOrBqje9eKJftnNRmTqpC5jyL2AqaftbG+sfznVVHuN5MxtPS49IDThCHCzChrMvUEqRfcjHlvvV3d58AC1ARRu8NS/6w7PhCmJ4P9tdhm3GbEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xq6n26jB; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730151481; x=1761687481;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZVvBbYc6mPhGtFilUefbPzl6g598rcMC8Do+SO/ixaw=;
  b=Xq6n26jByUXxZRHG9Iln6Y8t7EYrt/UDv7GwNep+zMA9VyV1ZqGddZTE
   3QWvHCDjUqe94Bb+a38u+BYd1NMu/ZHjVwLbTezRJPkUqTgw0mhZJfwoy
   KQJTTJhYTFWTIGyihCn8w35LPejqr3PGTnwiqKDSyRwZn5SUkWm+zbZYK
   oB2AdF8pA3/Jv4zMukEUis8Ilyy4+hEVaUe12t582WrtOL1vXguS6L8fL
   +8xVWYtVUmglMQ+nIRktU+2FFkqKYuV3olomUj3u7qe2U6sP+fCl0pvhR
   oenpXDCVAkZcQ0F/2o/dYt++GyxzdZppmL/+ASDgjMZPPuli06JO16Y4H
   A==;
X-CSE-ConnectionGUID: kKiwe5U/TQGDGHUr4ywlXw==
X-CSE-MsgGUID: NT6NUhmWQTGoIVeMamJKRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="41164005"
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="41164005"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 14:38:01 -0700
X-CSE-ConnectionGUID: nyv9I3spQUeb4LnznY+j2Q==
X-CSE-MsgGUID: Xv7ZwysuQAqlvtXLuJlH0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="86538152"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 14:38:00 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 14:37:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 14:37:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 14:37:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xro9sU3wXLn3ZLAVI8aS/9flFJRfmguietOUvDR6SRgUahDn1p6eTZajVRswJilL9DXiuiVDoviZJj4SSM0/xHSZ5zDzjpAKEc4oRT3abdJYnCUidBlBC4iY3FiM35MueEaCIVEF6d9JPtt0B6z8gsz+AyMKgoF9yupmtZ/admxq5oypErcSvx2XrAJvBlZqLOLHMeLnEdLq2xu9/YpogUGHCpOXfk1ZHofE1j+h7wVyecKs5JxvB+8RKNNotJYK3Sfuf0XmmneDl3yhU2im7kuwzx13zjmI8yQldbzZlQ9hWrLa/EVWxxaswrIGb+Az5f32YENP9h7BenNG/ecxqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LaPVMKb9HsKj7V67DS8RhAz8pF3xqZts2Y4D4HfZuSk=;
 b=qW2uUj9tBwjQ8/4d7vFdlKQ8ZR47zh2rkw0XWh5qtW1WrizwszhDZm8dB5Gr+x7g7fy04HepcbfWzSwFTww3flpN82A39nGbCPrzt/t7tOb5LGtKvHuF0OznaCqkqUdFJVCfpQ+hHSpegomKR8uALGJ/x1xcExk7SJ2B0UXREzovb0y7EQzMUZnapB7oTT9ulHr3n+fhvAW9ydQ3lFB4eNSJebAB4xvNyQ/m465dx2htYtUgNo3V9Ttw5SvwHlpDhzTe0V+h8C0ods+TnJ4jqyP0j6Ezwi+ZjeB8M/8i+UYPWOa4kzikV5ET74aqyoRL3fszjspAv3j8bUz3cmsDww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB7558.namprd11.prod.outlook.com (2603:10b6:8:148::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 21:37:53 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 21:37:53 +0000
Date: Mon, 28 Oct 2024 14:37:50 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v6 02/10] x86/virt/tdx: Start to track all global
 metadata in one structure
Message-ID: <6720042edf637_bc69d29491@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1730118186.git.kai.huang@intel.com>
 <b7981f18adadf6ff60751063790b2e084d453e87.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b7981f18adadf6ff60751063790b2e084d453e87.1730118186.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4P223CA0016.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB7558:EE_
X-MS-Office365-Filtering-Correlation-Id: 82dc63c9-6eca-409f-90df-08dcf798c7a1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?M5iJrJS6WN3nTNOUsfg6I6Ykr6ZBw+zrS1Ym4lfJ/hWZ9u9ubWE86mCgahbu?=
 =?us-ascii?Q?BMFDhTPWPY6X0yxZVziyfBpqz483/R0nMpcxO3OqcbZiSCUW8UIjZQik0Va9?=
 =?us-ascii?Q?ldjdLU3xRdXj4t4E8ercvZ60p49C6MTaf6ds2nhKHwa6i7xCMC3OlEHLGFHh?=
 =?us-ascii?Q?358dob607qMLv2lv/I7Vg2luCTG/zg0icgus4Mp+AFVfEiUqMQ4qH/jpWw98?=
 =?us-ascii?Q?eZXCg5fI0IkBjFsSMH7fWIerWcePu2O9gIIV1bqN0h0GB8XK4wjQzHklqoij?=
 =?us-ascii?Q?6AbSFGTRBU0LrxKmj8ogCtgYFmnla+3WZZVkxOblnqHfCNk0A+rkpNkQw9ae?=
 =?us-ascii?Q?wmvYPqb9jPx1815WiQwB44dELb5UxbkgERT3nSSBAkZ4BchimeI7nXUZoVsL?=
 =?us-ascii?Q?wRvt6Bjqvd1JAsBuOkR2KMnlFPdnX+e830S20i6Wl3tKOOn4vdsxRyF9rrUC?=
 =?us-ascii?Q?gpzKrRe9mCuJdYOd3K61lqxt1qIH2/wOBWWPjWCGWK1aPcC9VXOEDuyZ2f6q?=
 =?us-ascii?Q?q/dFUda4cQHJBfwcrqVb6eQhz1VcLeymcfctHRjWQAgCwhmaAsQNLRokatX0?=
 =?us-ascii?Q?z8MHfJpUT2FEJhyf0U5jtTsF0k5N8YmkXsy9LzEmmorENuoh2HPmO70FkDEq?=
 =?us-ascii?Q?nDV9OFYS2ETbiherc+gWFv9jpmFzloifPSVCdpWsy0YUgUDK8SpftRd7iEob?=
 =?us-ascii?Q?rngnrKcy8TvrtgIgS3g/EXwnb2x7TayLiaitxUPHDLxf3hHaig0htGoyuZTY?=
 =?us-ascii?Q?KIdDMc8gJ6XScfMbdyExuOjTyJqrvYVQEpFwLvqJCcfdvChZ4xqK355fhFWJ?=
 =?us-ascii?Q?QjYfm1Axdn+auCaK49Btk3WBxw8SPxO1yeVhQm3CHg3vybZFYgJij5gaouAO?=
 =?us-ascii?Q?LaKf8O0sH/4jlyUD25ub7IdxMEZDwLud9qh6vh0BdTN5tFNdlDPG2dP0rC5w?=
 =?us-ascii?Q?8ItbCGVLqZf41/UjHcqEdelNS9Z6JqCYVXN/l4zBVnEC8V63KQLI3AJjt/jP?=
 =?us-ascii?Q?RJ1+OS96B/GiivnecP7/tvkBnhaR5ICxedtl+9nPK1s4bmbHTZO3HuReT1Ut?=
 =?us-ascii?Q?5hDEmVL8eeEdljTIIFZinnryfYR/oEEXu/f9gCmF826Y8h+bMOI/wYXe7KLp?=
 =?us-ascii?Q?wQro/ipwQdXRLbmWAKSuEn9bt6ppUuyuewIVqn1H6TKbXXRwAvChzRjV837R?=
 =?us-ascii?Q?q/WbnlKlWZ9nPVJmzkciU3w44F0QC8uN9/l4cY+vOpagus4MJ8sZCnzU1phS?=
 =?us-ascii?Q?RlEk3cs4NZ7kTIxSXSRJdusmd5b8TiN6eegaF3wqyjKjqbVugb5Xb4Vi9Tyo?=
 =?us-ascii?Q?rk6/JGC+1swizXYc1JT1F1UDJuuohFtAZrfV61tMM9tWEywN++NJ759TBQ88?=
 =?us-ascii?Q?erN9azQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Cj2iz6ExTaMoXIFX+ugZ8sPz8xRuvD1GhPh1H4x/WOqtnYz2OOdOnRphlxP?=
 =?us-ascii?Q?0pCIRwhRvYeSwE27Ii0kRmLFE/CdspECFLdtwSIUEzdOqp3+Q1+ls0GkM7kF?=
 =?us-ascii?Q?7tGtA8nXZocK7trhx1jarMAMkjDwp2+dl07KTh8/OGoQ3rKtp13yiiLMlNaQ?=
 =?us-ascii?Q?k+dv9qEc3ab2WMSQatWSDnG1m8MJUDnMq+Lt4yxBH/GRmF12VBbQSw1pW58X?=
 =?us-ascii?Q?v6c4FY7qGpp3LSAce0mUc2tZDftoIdVMMChyywgHipsS3dTzCy+CpGs+8ytE?=
 =?us-ascii?Q?1WHCbFpb74QDf3Uyb66YXq5DQ4S3NOVrdeAcDWFF5JDR7CA8xQ+W6h0gjplZ?=
 =?us-ascii?Q?x5QVyvZuFFocqOSr/hcE25fVy1Nln6w0DvFreXVv9QCurQGCN+mHXjKpexl3?=
 =?us-ascii?Q?ZxQY6tV2/eU7PBYr/xUnBlwR2jTS6dkGGqpMV2ZgW6xyiIlwrFlOmZ3Xq8Jz?=
 =?us-ascii?Q?UWk94RKOHK1zt2Sj1FmnUPKhonSgeL/BmQfBqQDxhc2eP2IVsNICDru+36Z2?=
 =?us-ascii?Q?c8f54GlqkocuT1+h2bMLCHx4YDQSvalWRuAUvtXISolLJfZPj1l17tIOrLmZ?=
 =?us-ascii?Q?8MCOq8or9weeRMRqnbmdShyoLWBGy+M2UCYzfxRdAnoT55Qki/cPAAyXJJkj?=
 =?us-ascii?Q?xG3nBr4/zUgbcFXRv4uzEyAAuEoa6opzJprm9dhJE+Y2zpE2fkEXgSOTmDfg?=
 =?us-ascii?Q?BDUU0Cx/2h3a9oIHdQ987AMu5xnTeQv3BMOmojb3qOS1yzJxWGNviwY2umrz?=
 =?us-ascii?Q?Ta9wXoh/NYnuPBiKVLCuaFQLthA6StzhKu0RakoXS+EQnvbRS/vTy0J2DFkI?=
 =?us-ascii?Q?wvtxpKu28AfJo1N+dZYXTidxSlhwYdo/70KphC2r33YZ5AkY5L95PfFsXcSJ?=
 =?us-ascii?Q?4yIYxLZ4PYb+6NGJXDpejpN6/vcwwonGhFhTULlnaBskF5AwJDMtXz3Ovqcn?=
 =?us-ascii?Q?wkCpkaWr2o454mjhekuNHJsNj4UnIErOSj5zPr+VskUimoD7lJjj5qvaDjf7?=
 =?us-ascii?Q?kwpzrtGDJUkDPxVQ6Ttv/zVxRSNyI09i09egZTf3JaQLjObeNfjuym/rZpNM?=
 =?us-ascii?Q?huJbYt1Rt5WFP77h1/PUsT9/MSMCixO0n5kaF7Dqq/+rmfUlGTyucBNlYsVJ?=
 =?us-ascii?Q?U5CZM40fnJzxq2dUeFTUOdrq/w7GD0voT6BCBkNLzyoJlzQrvlQ2dDtDbF7J?=
 =?us-ascii?Q?JHj2rfKxgBNRv3tD+aOxcFkNT8rGewHpXJ5mL6Q/QfxGKr9fKWLrqm2TzTnu?=
 =?us-ascii?Q?q1XN9JyvMkqOdUV6AsrIQmJvxwu43GJb6x8zAGQkpdqT2IEtnNAZT3thFSt3?=
 =?us-ascii?Q?x2X2BGuLMMEVs2ICB8wmxFlSjI2R+veKu55CAPqqllzZwoVMcFt/X0uMitFt?=
 =?us-ascii?Q?b5yffp1F7dUjR4KIMhzOa1s/60pDqQ/NUrFRAlxCEoRTOYtTvMFjZ4ByjGyU?=
 =?us-ascii?Q?tf5unZIYfAqmvsDd7Atz5oZ4M9PojdQzCn03YRTHqZVhzn9G10Voihg0mqeh?=
 =?us-ascii?Q?1M1Bun0A7/gprJI0fKHvQaNha44gkutBR5Zha5ZgASMuwq0QtbBnlDB3xwrz?=
 =?us-ascii?Q?lCXKg2SYMh2IejJ5zmLNhyNA3NppUvXqTrwwIsId8pzcU91g9GUx+np1Bzyc?=
 =?us-ascii?Q?uQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82dc63c9-6eca-409f-90df-08dcf798c7a1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 21:37:53.7730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVspqGbHZvS6jiiApmTS/ijI5sBJ1P5wiEanQCVN24IzQuMyi4lKW0dYnwY2978482nDkZbPxiw4yK5o4MivH6KGT5vqdiCq4bPIW1q4kjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7558
X-OriginatorOrg: intel.com

Kai Huang wrote:
> The TDX module provides a set of "Global Metadata Fields".  They report
> things like TDX module version, supported features, and fields related
> to create/run TDX guests and so on.
> 
> Currently the kernel only reads "TD Memory Region" (TDMR) related fields
> for module initialization.  There are immediate needs which require the
> TDX module initialization to read more global metadata including module
> version, supported features and "Convertible Memory Regions" (CMRs).
> 
> Also, KVM will need to read more metadata fields to support baseline TDX
> guests.  In the longer term, other TDX features like TDX Connect (which
> supports assigning trusted IO devices to TDX guest) may also require
> other kernel components such as pci/vt-d to access global metadata.
> 
> To meet all those requirements, the idea is the TDX host core-kernel to
> to provide a centralized, canonical, and read-only structure for the
> global metadata that comes out from the TDX module for all kernel
> components to use.
> 
> As the first step, introduce a new 'struct tdx_sys_info' to track all
> global metadata fields.
> 
> TDX categories global metadata fields into different "Classes".  E.g.,
> the TDMR related fields are under class "TDMR Info".  Instead of making
> 'struct tdx_sys_info' a plain structure to contain all metadata fields,
> organize them in smaller structures based on the "Class".
> 
> This allows those metadata fields to be used in finer granularity thus
> makes the code more clear.  E.g., the construct_tdmr() can just take the
> structure which contains "TDMR Info" metadata fields.
> 
> Add a new function get_tdx_sys_info() as the placeholder to read all
> metadata fields, and call it at the beginning of init_tdx_module().  For
> now it only calls get_tdx_sys_info_tdmr() to read TDMR related fields.
> 
> Note there is a functional change: get_tdx_sys_info_tdmr() is moved from
> after build_tdx_memlist() to before it, but it is fine to do so.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

