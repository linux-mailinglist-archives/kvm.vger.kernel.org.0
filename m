Return-Path: <kvm+bounces-19770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5666D90AC56
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 12:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06E15287221
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 10:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C4AA194AF2;
	Mon, 17 Jun 2024 10:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lwMnO1cq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52600194ADF;
	Mon, 17 Jun 2024 10:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718621697; cv=fail; b=q9rjM5bE/OLgN44LuGseslQV5k+dkqKldQxQcGo10K2aF8e7o0JYzY/3XZ3h5N9dXIYpQSvl9r1MAQVcmGtAxNxfOmWlfEIs+D2kHunjQjnpZ+OaV1WFPU0u3E38hEzNp59/SXVTBReFY6aI0u7cWi9pGVXxDlZYZvsmC5VfLGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718621697; c=relaxed/simple;
	bh=PqhiRC1zcb7BjsW9TDiwd9cOY4Wc3KbXKlAxLmdGN0I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lPI10u8+psxFpmz6/J2Pkf+XP5kD0SYqJO/MBG2kfmxi56CZIcXuG0YTrnkBrShD0TDx9QsSp3YtETbqA2JBFXAbCW0ZLAP3t3c7pDUMhvHX4tAw91ObgcTdeLe6oJIeu+soblkibRUYhFVywKwAiIK4UfN9I7ElfoXJ7/axIVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lwMnO1cq; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718621695; x=1750157695;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PqhiRC1zcb7BjsW9TDiwd9cOY4Wc3KbXKlAxLmdGN0I=;
  b=lwMnO1cqFWfijImwPtaVOj2F5r2y/eW/arzJ0TjMAaxa3v6/vBclDJc/
   Q0s3ehwIgaC4+WP8Aov+E88PqweQdu8vErMq3fuYh8PZOYJ41ihpU3l2W
   iEWorqekitT3CjJk/mLkpla83m+rdv1vII+lgOgPiQBcODEQNHKJdxzGi
   H3mePjxOXCTwCC7A7fKKL+w5c1cMCR9Q66QpYhwWiooHE5UBWNIP8Oxff
   XoBgp2hz+HYiVc6PDB4XvQ5yzjsyN7jJkYl3gu9KuIVNXY9vgAv3XHr7I
   FNz6mh38NM+3jkytX4CE44yT4z0HKWFfLaCgw6aeNqCrnGSDWf2e2kKNM
   Q==;
X-CSE-ConnectionGUID: hqe4+nEHS8Wk5aaNkTpyzA==
X-CSE-MsgGUID: 8PMsWFFNQMyDYTD6dc2RLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11105"; a="15212218"
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="15212218"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 03:54:54 -0700
X-CSE-ConnectionGUID: TujxnBe4SHeBnRV0Su5LOA==
X-CSE-MsgGUID: f15u2kCzRvW9FMYwO9d2vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="46088416"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jun 2024 03:54:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 17 Jun 2024 03:54:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 17 Jun 2024 03:54:53 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 17 Jun 2024 03:54:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1bfc6lLSI+PeqaUN7gah8ba/KVOG0gTy0RHWce8P/H7Kp8mQJyLNL6+27V1d17KQxLY1W67lJe1M/EUVRZ5IHzU1KjgXeB4loAxvsukAO6OQRd4MkWgyzIOWqY4pmbhKHrmGcFpAHoRcBabpSluT29AfzZ+/8l6EC/hVV90k/hLYlNbPGXh7KlL46u7jkpJGl7vflAFy9dB3Kxacam1w860oJ1eVdCFHuAHSOMhliSGo4AlDBNDtACamOA3AaaGw39efyMAxeqAfbN3AZtW5jlkgi9DDbnVvXUbk4wKU6oWSLJ7wpaSm7OtCEE8R6ueMp0c8yG/6I6470K59axSLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rrjE5+lKk3SJJpC+5V0Y7BLPeu+IHSng2Vm2/jCMMTc=;
 b=KyuVYr4JCf7pZPGYMqEyqdfxf+yKZsk3dkY+YDxFRIMfgJFCDXtOrE2t8dITdp1fCi3tXnOyfVmYFZHZ/2LUJTsTWiQbQbNnojWnBqEW77530oVDyA9KADaZrCTo/yEhy8WR7YJ2URk0aEBHWZMBMOL2ARGfCmqVBlRSulSONW9mtmoIkVHTfna6Ya+N2ODNRGV/VmgsfT47ZryPrVs7rkAv8i0J/TrQmZ10PdcmpPMEKp0vq413v9Cilhnlx2tjMH/KSWcc1E7EtqPHgcOXMC/w94xlU4YnAhcGRzdXqJvyqgj0QT9OAAFKF66G4nIQfC5pzsxtzXWRZTombZu5lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7510.namprd11.prod.outlook.com (2603:10b6:806:349::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 10:54:51 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 10:54:51 +0000
Date: Mon, 17 Jun 2024 18:54:38 +0800
From: Chao Gao <chao.gao@intel.com>
To: Kai Huang <kai.huang@intel.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>, <dave.hansen@intel.com>,
	<dan.j.williams@intel.com>, <kirill.shutemov@linux.intel.com>,
	<rick.p.edgecombe@intel.com>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<bp@alien8.de>, <mingo@redhat.com>, <hpa@zytor.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <isaku.yamahata@intel.com>,
	<binbin.wu@linux.intel.com>
Subject: Re: [PATCH 8/9] x86/virt/tdx: Exclude memory region hole within CMR
 as TDMR's reserved area
Message-ID: <ZnAV7krcGEqyHQt2@chao-email>
References: <cover.1718538552.git.kai.huang@intel.com>
 <cfbed1139887416b6fe0d130883dbe210e97d598.1718538552.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cfbed1139887416b6fe0d130883dbe210e97d598.1718538552.git.kai.huang@intel.com>
X-ClientProxiedBy: SI2PR06CA0018.apcprd06.prod.outlook.com
 (2603:1096:4:186::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7510:EE_
X-MS-Office365-Filtering-Correlation-Id: ec4fed7c-9753-4e69-e798-08dc8ebbe9b1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|7416011|1800799021|366013;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7guxNpDhwgjPD6P3HZJ/+yrXiJbrgxp0Rvny+WY4XJZIhqzSVUaFHiiM38qU?=
 =?us-ascii?Q?rtfHHxehA5xtIMT3AaQxTaKV6IGTwNHqtg3U70aS3mYw9bMOg7QH1Xzt2RII?=
 =?us-ascii?Q?vo08VUBUYDXzNyBG2jCVh8MBiGYUHkkW8JgbfFe1TPUr91Sa+2H/pXdWuSk0?=
 =?us-ascii?Q?CZ7UndYQXEVNlYEemBuoG8Pbb9EdMRJWO8leFZZw8QKvEV7/W7rHMfNeilAm?=
 =?us-ascii?Q?9Hgq8aWSlnJx2W3vRYFHqcMvBQkC4VNXpeltxyQ4+iVn/sWCUubbENd6Opbk?=
 =?us-ascii?Q?b1QLoN+P7p2vcIFyTDQLU/3ITEYfbdNzH8m43SAYKjI68VPicXIl2AhXH/NX?=
 =?us-ascii?Q?EkYg7SFGaBck20cQpTnayuz5+KVkDNsQkqaG00A/GoXA+A/fBFPX1w2mZkQP?=
 =?us-ascii?Q?zVjvMHYD3XL2Tba1w7MjvOcoA6Sihq3a52Am6+gdSkkRcoWB2H5f+wn5OCMP?=
 =?us-ascii?Q?rUjj3POgSr4mIZnWlLZ+pTIG9rQNgkCnGWeJVA2W8ydrnT4Waw5I3s1xx5dt?=
 =?us-ascii?Q?ybURpKXm2db3hmikSYAhycLPEM1+B+nZKE59CYvwnfCwpycX0atALUHaDbTW?=
 =?us-ascii?Q?JJSmtje8ddYRPvtQzgKg7gENhHBnj71UU+9BEvQcPb6JUeVfPMRZJywhZnHJ?=
 =?us-ascii?Q?l6mwFkw9sH5xdZsX8ZPEOE71AtvKB94489HKoQl/gwuJyk7471bK9ybAojRz?=
 =?us-ascii?Q?1R2xcH22cqVvXytBNqMGJPnWYpnQHXX2EiOS4Tx1TGbMmX3T/U3j63Jpxc2P?=
 =?us-ascii?Q?DJ1/hD9HVaiIW0zvDbmDpLgoJ8Vm83PTUkQ3bqYYl8S2eR+qiWhsr7himRC5?=
 =?us-ascii?Q?Jr9CgBTa6EpjixQxDEK8MC2as3eJXnpHFZxnYAahhdYYqR16SEje+0xHgOK1?=
 =?us-ascii?Q?NMoFnqxEA678xOPLdRPxBYFyes3Y6Sz8LSwwogO8aF0KeEVRgROf8VpSonwK?=
 =?us-ascii?Q?HT4EhMA2nQJ4GzHNjcuypu3ymTB4jW50N1uTY4rGOpiC93XztbwPvbu+GWtZ?=
 =?us-ascii?Q?VJ9b0CGFMS/Ahd4EGUuxOYjggAw7GIZz7tPW2ZR1IOr2pDjFyd4x+vL2zo+U?=
 =?us-ascii?Q?nZNj6msYuLAcZ46UZibShdjMf91UR9cR/zxfSIjKeoHNNVIWK8WrSBm4UhZg?=
 =?us-ascii?Q?EiW0D7q/nwe8AZG/YERgYoUDfIshN5RKMkPx0YobG0NOTGkU0xRGfb7I9t4M?=
 =?us-ascii?Q?Bf43GtvZv2IrWIRpMXG1eTH+kKaNOSzsSpcs0aYjgtO7pM69hny5z8KebEJG?=
 =?us-ascii?Q?IulCoUT5A6FQAYQ/t9SaskYX3aypsexfruWUofNu77lthS5fxCztpQm0k4UV?=
 =?us-ascii?Q?RN+Lnx1c6p4k+czl/V2wJb5X?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oafrHJ8FPDD43e7XvqyayAkBuXueTOUQxIViFw5Oz+iojYeoe4OAoIvSO3F1?=
 =?us-ascii?Q?Ezkbr82WAFI7K07cFHKewadaXlkQvkNrYda92qLHTT/NhR28ilJwilWHemSA?=
 =?us-ascii?Q?Wg9sBK/83Q9DGkQUSyhECe6PrcsFhV+UV971pyC1+/g9O84Q5xZ6N+xVtLBT?=
 =?us-ascii?Q?MsEEispZWvhFQ1wVzlPdIwB8oAB0JFwh7T8lJuAT+V4RHwhV8cTgbhRdZQTP?=
 =?us-ascii?Q?ZXFNm0fxxaTvNvoQ5mgotJaubldsJpndPAnsv0p4ifrLMEcBG8T0otltlUH/?=
 =?us-ascii?Q?h8CcEvAAINQ6YYbaIyyzqT7Erwkc0TIbXRTS3hVP7qyTTskMVZPryiXvfbmo?=
 =?us-ascii?Q?iz+FypVfIIwgLiz8+ZZk5WhuvgqF+M7fhJ6tTTrkwn+388nlCT8yYUCkAaJr?=
 =?us-ascii?Q?rteYuQ//QM4nPzh5Elu0k182VOKMA7oafHt2FxlOUvEf6PxHt82rdQh9yw+6?=
 =?us-ascii?Q?utAV0qnwdcpekbYpibfqY0ce1GIWauqTBEGC0xcGKQsk40//ZSlnCpT4HPkW?=
 =?us-ascii?Q?z3sJHgwzM9Effs2joAoZvLAs1xn/r7Ji96MESuqsv7xyVnxhwWhW4QFIIQBI?=
 =?us-ascii?Q?hLzGwhQ7Hn5Zgst5yLqlDfGUA506AtsWq+QTMGU2OsRdvdLR8YC1XcU1813p?=
 =?us-ascii?Q?oOTbWx6uIFDtje0aH0I79QvOaOnksg0LwX169SOQi4p100r2wxWglyy7aU/0?=
 =?us-ascii?Q?K2Lcv2BJNxg7/RiA66Y5vnOicHNsJdgMHdgoF8Tncfgfgkx0svc6unoiZUwU?=
 =?us-ascii?Q?9rfnYuIt/vspMMqf6PzPNfzTkKkt8JCL2DHSGSIbnm6nYYC6ZFqTRq+/II1D?=
 =?us-ascii?Q?XFaqPund6EEgsLq1xNT3ZKMOKVcdTgp1g776/Wnw611yJ6hRLafpR2Ojw3Xg?=
 =?us-ascii?Q?/5YYNsDMSS1n2V0LtFrFnqXzB5N+ImI+B5xGBuszKDpKnK/DXBWA8CtWoDyV?=
 =?us-ascii?Q?+OELglMT3IYmoDu0niBNC2zZcNNH4np7sq2HTY3IN/QxQGVZY+14pc48AP7w?=
 =?us-ascii?Q?7O7aW+foVBO6xXX6H6/pjswihPAtMpdPB9I5OCMdqquloQgzf/bSTnZNoCC7?=
 =?us-ascii?Q?fiVg3SG5KlLUDoSEqcnIN4oILC4bZ4xYsPO7bKNnCw/RdySEx0YN3F3pEWpQ?=
 =?us-ascii?Q?AjR87isAl4PLUtaYa2OEkAlBrmiuzFl8GaOAWhwMGBC//p0BijwHPmpVbyjM?=
 =?us-ascii?Q?Xs0g1N1nm1UPm0TQfcvXJ+b8ASKTqtmASrrtXIGpLHw5pOgLltJCxKiKKcbg?=
 =?us-ascii?Q?tb3HcFh02JFlxqnqyu2ZcrR2vSp9tuMInRZEluHTMzsGZE/8d0S53fbP0hoC?=
 =?us-ascii?Q?LVg26tbC8Nma9axJj7i0UbSQ4VVBvQhW7Yz3I/6PiAexb7bQsc3dgQB8bfdK?=
 =?us-ascii?Q?xCbUP/pnHoeKGxW3MTgRQAHVg2j5qbUwzgyhD15v/KGBu/X8+ZoWfZs2T5ke?=
 =?us-ascii?Q?jocG9g9N6reaoAeGhBqKX2NHmDt5KrgO/TP8lepxrmJOjDx5fsWTDJI69eUo?=
 =?us-ascii?Q?FkW38tcCaL0kislm1GVOq8rq5o6Fh9bzdFiH6e3l5fXeWyf4NryvoofVPmdA?=
 =?us-ascii?Q?7XActgs1mJ3ZDkv5T445sqrkVasaGs6BmWmQEiKF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec4fed7c-9753-4e69-e798-08dc8ebbe9b1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 10:54:51.3748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQToWMsHISOgmh9Sqj1hb/QvrH9PCLHz4YFuU5FicBlf1rTOqzz7DPm+bqVATidTbDNjszRZFjpgUuVsWLF0sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7510
X-OriginatorOrg: intel.com

>+/* Return whether a given region [start, end) is a sub-region of any CMR */
>+static bool is_cmr_subregion(struct tdx_sysinfo_cmr_info *cmr_info, u64 start,
>+			    u64 end)
>+{
>+	int i;
>+
>+	for (i = 0; i < cmr_info->num_cmrs; i++) {
>+		u64 cmr_base = cmr_info->cmr_base[i];
>+		u64 cmr_size = cmr_info->cmr_size[i];
>+
>+		if (start >= cmr_base && end <= (cmr_base + cmr_size))
>+			return true;
>+	}
>+
>+	return false;
>+}
>+
> /*
>  * Go through @tmb_list to find holes between memory areas.  If any of

The logic here is:
1. go through @tmb_list to find holes
2. skip a hole if it is in CMRs

I am wondering if the kernel can traverse CMRs directly to find holes. This
way, the new is_cmr_subregion() can be removed. And @tmb_list can be dropped
from a few functions e.g., tdmr_populate_rsvd_holes/areas/areas_all(). So, this
will simplify those functions a bit.

>  * those holes fall within @tdmr, set up a TDMR reserved area to cover
>@@ -835,7 +932,8 @@ static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
> static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
> 				    struct tdmr_info *tdmr,
> 				    int *rsvd_idx,
>-				    u16 max_reserved_per_tdmr)
>+				    u16 max_reserved_per_tdmr,
>+				    struct tdx_sysinfo_cmr_info *cmr_info)

Maybe this function can accept a pointer to tdx_sysinfo and remove
@max_reserved_per_tdmr and @cmr_info because they are both TDX metadata and
have only one possible combination for a given TDX module. Anyway, I don't have
a strong opinion on this.

> {
> 	struct tdx_memblock *tmb;
> 	u64 prev_end;
>@@ -864,10 +962,16 @@ static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
> 		 * Skip over memory areas that
> 		 * have already been dealt with.
> 		 */
>-		if (start <= prev_end) {
>-			prev_end = end;
>-			continue;
>-		}
>+		if (start <= prev_end)
>+			goto next_tmb;
>+
>+		/*
>+		 * Found the hole [prev_end, start) before this region.
>+		 * Skip the hole if it is within any CMR to reduce the
>+		 * consumption of reserved areas.
>+		 */
>+		if (is_cmr_subregion(cmr_info, prev_end, start))
>+			goto next_tmb;
> 
> 		/* Add the hole before this region */
> 		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, prev_end,
>@@ -876,11 +980,16 @@ static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
> 		if (ret)
> 			return ret;
> 
>+next_tmb:
> 		prev_end = end;
> 	}
> 
>-	/* Add the hole after the last region if it exists. */
>-	if (prev_end < tdmr_end(tdmr)) {
>+	/*
>+	 * Add the hole after the last region if it exists, but skip
>+	 * if it is within any CMR.
>+	 */
>+	if (prev_end < tdmr_end(tdmr) &&
>+			!is_cmr_subregion(cmr_info, prev_end, tdmr_end(tdmr))) {
> 		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, prev_end,
> 				tdmr_end(tdmr) - prev_end,
> 				max_reserved_per_tdmr);

