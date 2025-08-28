Return-Path: <kvm+bounces-56025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A997DB3931D
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 07:44:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA55C1C22B8C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 05:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4A8E272807;
	Thu, 28 Aug 2025 05:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JZItfoCS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3641270577;
	Thu, 28 Aug 2025 05:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359859; cv=fail; b=o8M4awUCIbRLyEu2WiWk2cFIPQoLi/Vo9GP10aUcdNwgASH+GnFnbEAQCvtedcuytpmYgTD1rft9Xj/CPVGUgzGNNY+0RKMZZ3TnokprL52qoiVABOsVPWg1A3MpV+xbQco9Bh0NY+J8AuU7yeM9Kmg3cCD/KfIi8CoLhLkssjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359859; c=relaxed/simple;
	bh=Pm4ZIJomgLYK2P0jQdoAqZdJRKXNtAhgOygfxmNJQQ8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GlNYeCXmBaYLvP12ibBzEPHMZAonE3cPkxvlhNuA89aCLiomXMBOzvePJZfOWTFPRr5nJCWTl5hio+Aro8vYWbq4iOo1efo1R3OwHI6B0724Ity5GlN17kbyAKIgqcNL+PSJFKC0Fn47E7iEo7g8c+G/ydVVb/EBYJy4PttsF78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JZItfoCS; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756359858; x=1787895858;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Pm4ZIJomgLYK2P0jQdoAqZdJRKXNtAhgOygfxmNJQQ8=;
  b=JZItfoCSjuy3x3v6rWB3oZBgu3ZcNm62CXyT+a4l+ObwTjWl123AEACz
   6Pyg4dSWMvunBAhgpwgMr3fehv0cH1QsN7W9GuPwTJIHFuAR8dt/49slz
   3ivYE/nSRxBxGbpT3tPxyGFS02biHJa2RFQHIiqRA6vh+uz/AsirUmxqH
   b9wtMG2zrpJnyLmhKfxp7GCO8c9X6kCbFDAF9PWOM/b6cEejzgeXtcxHi
   0kSt4LjmUPCbZJLDC+7LX2EGFH6q+F1Vn8P/Ad6KzmjfiukIsrI1iE8/3
   smgn/5JBP30dykh/qwaTS1oUsgkGSdXCBmYJ5CXWp6QpYHr/TZvlqNfLe
   A==;
X-CSE-ConnectionGUID: GPeFgSKuR3agYXWi8BE0cw==
X-CSE-MsgGUID: OpMrwRpDT1GqvexIAZ2SYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81211600"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81211600"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 22:44:16 -0700
X-CSE-ConnectionGUID: +89PowjFTdKR0DosgdsYfA==
X-CSE-MsgGUID: qZTsZ4KUTB6YoSvxmFVGVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169944026"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 22:44:16 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 22:44:15 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 22:44:15 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.69)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 22:44:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tJF7MtblbOou0l+47j7C/4sfF5I54nBEyOd6YoB3rjRR6EnRJgHvBpolyhczIxPguqYMt7ZmYmMofzyeVq+3o69TV9Y/Emj7S4xq3VzQh7nsXgtGkKhVQuNVZ24ad9/UMmeb2Vl1vgabZ8KPb0l3WTv3AWtC2QbA5HtU75RkA7oaH1ldrN6/WDYidIqzbm68e9ifFrdh6NFAF+QcoQYXn54b8JA9LRqZVfQ5yrS0eNBwgPK1qN9b/re9ioD+RwXKOaDdK8quwtg7DQFdoRSSFEhV/7MGQhU3QFhbcAyo5pWuGbF+Hjk8qfTdOGNub528576fmLkMDqeLK2Q7ZXJWnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODbYIWjG7d62A1zA8jLQKdQLpTQ19/Bca1XUo1jN1So=;
 b=Mc7eUi5+RHIyVs5z6vkdTcF9D8nucYRypIUFpYED1RqmGHYT/CbZaf8qaJcrevpUf9i+C/bo+SSPF9QfoPBR9krpM0+GVk3cxZoT81+xLBk1/QGbeY8mVdU0JfTxYjii3ArSfGncX01z6f1QGvEq6sK2nJfmMIY1xi57Bybn903XyAomVFHWN3gGB0eBa44GTN+/1o3n/AD3al8395CfSS25Vxxqizp15wCPi2o/3I5JhVoEofU6W5ti5rGK6LLR9kVBETXtnHnkHVZF2NGlpaM35NP0K/8NZlXCvQxc/+WSqVP8TRivtKAULsri/vBSaVZy96g6iBGZi+cuELUCJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB4928.namprd11.prod.outlook.com (2603:10b6:a03:2d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 05:44:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Thu, 28 Aug 2025
 05:44:08 +0000
Date: Thu, 28 Aug 2025 13:43:18 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Message-ID: <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com>
 <aK9Xqy0W1ghonWUL@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aK9Xqy0W1ghonWUL@google.com>
X-ClientProxiedBy: SG2P153CA0027.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::14)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB4928:EE_
X-MS-Office365-Filtering-Correlation-Id: 82411c50-104e-4592-b633-08dde5f5e810
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Q4Ef/uUpHTCID72oZ6m5fERWI6gCJ4ZDChvr/qbc64bgJS4e5b0LQDV9HOzd?=
 =?us-ascii?Q?ZxLU7nNH1BUwoTsUgneN1vsjn9Yg0CjS7l24nvMMC85MCT2rWuDH6S7hPePl?=
 =?us-ascii?Q?xnIHo3I4Q2AotE/S4oNPqqp+Arcbj3iMSyo5s3EyKiICNx85JGzoOPgP+W6R?=
 =?us-ascii?Q?2FMSrdyj32xnkgpOiDNpC3bCkkKhXV9RBOVrsAVdDALv05r9ydxj/5kz+yqH?=
 =?us-ascii?Q?1QEE88Xc2mFVCjHK/MKjWOAiQBFULisXATaSxAo0H1Ba2sj2PeqvyMEY2ROl?=
 =?us-ascii?Q?ZhRGJyCwimiLmRoCWA6ZBmkvAtuQjASH2jvAqhvGFaFp4JncFUWvISuetRs0?=
 =?us-ascii?Q?FMVe1147LUhcs82o8RSAbASBVVFEjLBRd1TvmZ52tU0zYLxxD1EbOZ22P6Yy?=
 =?us-ascii?Q?bD7wwaLqdLfQqw5F07Sy40xRW/ms7EtS/Cs4V/OiUuedOrIX/F8DqRwoAr5H?=
 =?us-ascii?Q?HnV+HrRGesFCqiznc3CbI3kqvRX74eTp1w4evBxDfUyXLXDngqS+jf4YN3mJ?=
 =?us-ascii?Q?AK6ulV7s/2XkrjKAG5kQIMC3nWO7p5+lTyEBLAl30HxqCIMvy4E0cCjyh87E?=
 =?us-ascii?Q?eyd6rkKDJ8V7i/ZaqvcfJQXHa8IorcmBI84vaMmF/gSkDyKLay80Meu7jzoK?=
 =?us-ascii?Q?2E4srtI4+efRD/RPH5nL0/jjNMI3L1KIVffpTppFKW6e4Q+7nZ/MThV+nCru?=
 =?us-ascii?Q?5AyO8ymhmL9DPEa/ba/n8LM95OelZYoZl6MGQMX52q54QQwbKNgE/IkUkJqD?=
 =?us-ascii?Q?344ioPB7RzxXnpeKTrwC83MTGZ68O3mQ7Zsa0VMtGlaE2QGQmWsKfsNeI2FF?=
 =?us-ascii?Q?WPCL0tjulr7K9atSWxqH/ccdzc3K3sheDoNH2kgWBBCbvOj/Eo0tClYJZUjy?=
 =?us-ascii?Q?wj3sCJToIv16p/LLBMIGzR4nzxGS08w+8wgdAi6QNBs8OCHMSgHn4UNkK4Ib?=
 =?us-ascii?Q?65MPZquJge1z1FFrrEKLFfWOAOPCP6Ph9UVgL9/UKaaO8ja23HE3gYV5QPXh?=
 =?us-ascii?Q?ziE8Y4nC4yO9XQhhq61FURUjnvreZWSZrflrk0PyCe0Tkn3GiRRez5Y/5LKe?=
 =?us-ascii?Q?oiNapS3odaBjKKJzk86YDEkESPUGGIu2UVhFrDOYw4uFM5+09zfdQYdvY+wT?=
 =?us-ascii?Q?LQbL3xXpcwDFkL4vggPZizf2+aTSQSyTVYfhjDn9nvq33wqPdDnal0EyGB0U?=
 =?us-ascii?Q?IL5YFZV0JG1mwq1iFnhYJb7WqGjYV3LqolxZQVZ6QlBW9Glm7yE4r6OtriGO?=
 =?us-ascii?Q?D+9lwZQR2QQjmpuEy1wzT/ll0FPJF2UeffPFAPmN/SRsbEy2XcBvNn8Aq78U?=
 =?us-ascii?Q?8zmRwVhYX0yYnAVSkU5iWKKNdW+YZsbywtEj1GPMxlaogewlGCHwo7ks+r2a?=
 =?us-ascii?Q?NAnXJFb1cWs3WsCfzo5r9EnVXM2HptTwA5iADuXygBOYuQrErmY6ygT6Om//?=
 =?us-ascii?Q?rD88JJ/kM/o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZHq56qoHhyZoNGM3zJSPvBos9X/1xJInDNuIm/eQf8orCSNX+IjdDcSpEvRr?=
 =?us-ascii?Q?sXXUkq/NPH9EnNdjcEIVT3uHHEKekLkz4PM9hsEBSKosMV+O6k8QS1LDyiSk?=
 =?us-ascii?Q?21Rh7pbH4bFgzA4sMXC96WIjXzhQ3Wl3TnmAA2lfwoU9fRdfU16dejAfx4DO?=
 =?us-ascii?Q?wxARfoF73Sa/vX+ufWXLfygPLUBZiLP44GsLFE5+EKJrMsrTWOnfPILO/NoF?=
 =?us-ascii?Q?xUcVnzBRlcj5QmA37CcCplI9cgt7i/ztklLx6Uc1g3Ku2qJgWGklMicbpsKi?=
 =?us-ascii?Q?sqdt0aNSxVVIcvEM2elKljj1sv8RQ/POjfhtBsSWOkEOGwxT+G18440IEG65?=
 =?us-ascii?Q?wwvjJTFijSMkxz1LxK9w6G9/y6HqWkjvL+jDz24HGQRP5vl0LrJSOA9vgxjC?=
 =?us-ascii?Q?QX3bIkr9Z9SsaElKKPOsgbLAimgXMyeAz+SxvDmczQChcvVo0hjdzTZlo002?=
 =?us-ascii?Q?iK3u0fsnn5YVO0U6HFcQNcMySCmGfVQi7OZgBM52oBtogxEsNoirFgrzKEET?=
 =?us-ascii?Q?eRQqUkkWypGB4cM8+q/5U+MWzm2eJWNTfVFLfwol1Nnum42ZS1TVc5sB83hl?=
 =?us-ascii?Q?3GZ3HZycYNaEM7czNCFCJ8BKUeDZX9v99j4O+Qve8KnTMc0cqStG/O6j5/K0?=
 =?us-ascii?Q?+9yG0VDP87pG+qxw2OXdRo5bPJ3QfF8AiGe95dWRDOfsj5UFKOd0VanE3WFC?=
 =?us-ascii?Q?/nreKNGoQWP7+ua0vKlq+oN6rwjuQ+VV5u4Qnbq9gQfjgksNLBMD/NQy9qOM?=
 =?us-ascii?Q?/ON6KspLPEdNVE+nvGdy2QpWb3DrkUSCYKP39nUWVEvlgKhrPvaNHejKoVUA?=
 =?us-ascii?Q?bOPB39a0ya4E8wPN71y44RRNhB3sZXNdkBo93/4za5Ogw/H8UaPvcQSQnwRB?=
 =?us-ascii?Q?YFz/SKhRsPiuaKSjXmu6USDja1qigKOF4hXb2zUGCgn0mH4GWhb5QS/VSM1a?=
 =?us-ascii?Q?XjaZ5tCZgjv3iWhC8wAJ3jxylGPVFMRUn2AzIQvEeHwUNTQyrMR7InHZmuFa?=
 =?us-ascii?Q?eZ07NlBsPdMFeD14bair2HdckjlRUxzXG7fuYv+S7uHipjoPp8IosCK7mIt9?=
 =?us-ascii?Q?yGheIPm0ix59R2S/GOSisOGXBzynSE3iSu/xtYHPEokg24s2vLGylI2K7nlA?=
 =?us-ascii?Q?0x6glCOQPvOucQ3TqwuhOB1QgTIX9da4S6uSeTdZETj3lcVG4WCyQFOwvsOa?=
 =?us-ascii?Q?vondHPwJz9aP8TI4bZ9o+ygWQlxRBiuCPICTo19zSeC0pkaBtH0WHDyLiT0C?=
 =?us-ascii?Q?pwzmVg2V66dnCHHQyEZ0l/xLVTlGJWgVrtLKPCJkrhnn708F6shBk4mEKnS7?=
 =?us-ascii?Q?WJUm3VO1AJrbyhWWSOws1znlzkHuaDGOq9AjO7CLizIhSkMdECRNr1b8kKGy?=
 =?us-ascii?Q?lMLQA6QnFba6c3uAi6xPpC6ogtxjbW0Xwc+i2nhHZHp/2UWGLkT4La8DPmWF?=
 =?us-ascii?Q?a1ZISo8YA4vRPnH5mW15I6CF/V+QzLDa4mUuhyyLURWgKdTTt+KwwKcssTEY?=
 =?us-ascii?Q?jWhvIdseO4pVNlhx/0FdcuGs3/rTL5pQa9I3qjf2jH5ibPS2dzsJQuz6vykV?=
 =?us-ascii?Q?xwua8BqN8FrDmrEW3aqqnZXFVFkJrYysNGfIAVHg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82411c50-104e-4592-b633-08dde5f5e810
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 05:44:08.1872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+J5Asx/lE7a55mSWtJwkzyuNXxxuNA+DrMXFx8aTv4ERBIPlF0+hSwGIkPUZWzdL0jORhDPciYQDqjiw72MPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4928
X-OriginatorOrg: intel.com

On Wed, Aug 27, 2025 at 12:08:27PM -0700, Sean Christopherson wrote:
> On Wed, Aug 27, 2025, Yan Zhao wrote:
> > On Tue, Aug 26, 2025 at 05:05:19PM -0700, Sean Christopherson wrote:
> > > @@ -1641,14 +1618,30 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> > >  		return -EIO;
> > >  
> > >  	/*
> > > -	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
> > > -	 * barrier in tdx_td_finalize().
> > > +	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
> > > +	 * before kvm_tdx->state.  Userspace must not be allowed to pre-fault
> > > +	 * arbitrary memory until the initial memory image is finalized.  Pairs
> > > +	 * with the smp_wmb() in tdx_td_finalize().
> > >  	 */
> > >  	smp_rmb();
> > > -	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> > > -		return tdx_mem_page_aug(kvm, gfn, level, pfn);
> > >  
> > > -	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
> > > +	/*
> > > +	 * If the TD isn't finalized/runnable, then userspace is initializing
> > > +	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
> > > +	 * pages that need to be initialized via TDH.MEM.PAGE.ADD (PAGE.ADD
> > > +	 * requires a pre-existing S-EPT mapping).  KVM_TDX_FINALIZE_VM checks
> > > +	 * the counter to ensure all mapped pages have been added to the image,
> > > +	 * to prevent running the TD with uninitialized memory.
> > To prevent the mismatch between mirror EPT and the S-EPT?
> 
> No?  Because KVM bumps the count when installing the S-EPT and decrements it
> on AUG, so I don't see how nr_premapped guards against M-EPT vs. S-EPT issues?
Hmm, I think there must be some misunderstanding.

Before userspace invokes KVM_TDX_FINALIZE_VM,
=======
1. the normal path (userspace invokes KVM_TDX_INIT_MEM_REGION).
   (1) KVM holds slot_lock and filemap lock.
   (2) KVM invokes kvm_tdp_map_page() (or kvm_tdp_mmu_map_private_pfn() in
       patch 2).
       KVM increases nr_premapped in tdx_sept_set_private_spte() to indicate
       that there's a page mapped in M-EPT, while it's not yet installed in
       S-EPT.
   (3) KVM invokes TDH.MEM.PAGE.ADD and decreases nr_premapped, indicating the
       page has been mapped in S-EPT too.
       
   As the name of nr_premapped indicates, the count means a page is pre-mapped
   in the M-EPT, before its real mapping in the S-EPT.
   If ADD fails in step (3), nr_premapped will not be decreased.

   With mere the normal path, nr_premapped should return back to 0 after all
   KVM_TDX_INIT_MEM_REGIONs.
      

2. Expected zap paths (e.g. If userspace does something strange, such as
   removing a slot after KVM_TDX_INIT_MEM_REGION)
   Those zap paths could be triggered by
   1) userspace performs a page attribute conversion
   2) userspace invokes gmem punch hole
   3) userspace removes a slot
   As all those paths either hold a slot_lock or a filemap lock, they can't
   contend with tdx_vcpu_init_mem_region() (tdx_vcpu_init_mem_region holds both
   slot_lock and internally filemap lock).
   Consequently, those zaps must occur
   a) before kvm_tdp_map_page() or
   b) after TDH.MEM.PAGE.ADD.
   For a), tdx_sept_zap_private_spte() won't not be invoked as the page is not
           mapped in M-EPT either;
   For b), tdx_sept_zap_private_spte() should succeed, as the BLOCK and REMOVE
           SEAMCALLs are following the ADD.
   nr_premapped is therere unchanged, since it does not change the consistency
   between M-EPT and S-EPT.

3. Unexpected zaps (such as kvm_zap_gfn_range()).
   Those zaps are currently just paranoid ones. Not found in any existing paths
   yet. i.e.,
   We want to detect any future code or any missed code piecies, which invokes
   kvm_zap_gfn_range() (or maybe zaps under read mmu_lock).

   As those zaps do not necessarily hold slot_lock or filemap lock, they may
   ocurr after installing M-EPT and before installing S-EPT.
   As a result, the BLOCK fails and tdx_is_sept_zap_err_due_to_premap() returns
   true.
   Decreasing nr_premapped here to indicate the count of pages mapped in M-EPT
   but not in S-EPT decreases.

   TDH.MEM.PAGE.ADD after this zap can still succeed. If this occurs, the page
   will be mapped in S-EPT only. As KVM also decreases nr_premapped after a
   successful TDH.MEM.PAGE.ADD, the nr_premapped will be <0 in the end.
   So, we will be able to detect those unexpected zaps.
   

When userspace invokes KVM_TDX_FINALIZE_VM,
=======
The nr_premapped must be 0 before tdx_td_finalize() succeeds.

The nr_premapped could be 0 if
(1) userspace invokes KVM_TDX_INIT_MEM_REGIONs as in a normal way.
(2) userspace never triggers any KVM_TDX_INIT_MEM_REGION.
(3) userspace triggers KVM_TDX_INIT_MEM_REGION but zaps all initial memory
    regions.

For (2)and(3), KVM_TDX_FINALIZE_VM can still succeed. So, TD can still run with
uninitialized memory.

> > e.g., Before KVM_TDX_FINALIZE_VM, if userspace performs a zap after the
> > TDH.MEM.PAGE.ADD, the page will be removed from the S-EPT. The count of
> > nr_premapped will not change after the successful TDH.MEM.RANGE.BLOCK and
> > TDH.MEM.PAGE.REMOVE.
> 
> Eww.  It would be nice to close that hole, but I suppose it's futile, e.g. the
> underlying problem is unexpectedly removing pages from the initial, whether the
> VMM is doing stupid things before vs. after FINALIZE doesn't really matter.
Are you referring to the above "case 2 Expected zap paths"?

It's equal to that userspace never triggers any KVM_TDX_INIT_MEM_REGION.
We can't force userspace must invoke KVM_TDX_INIT_MEM_REGION after all.

I don't think there's a hole from the guest point of view. See below.

> > As a result, the TD will still run with uninitialized memory.
> 
> No?  Because BLOCK+REMOVE means there are no valid S-EPT mappings.  There's a
> "hole" that the guest might not expect, but that hole will trigger an EPT
> violation and only get "filled" if the guest explicitly accepts an AUG'd page.

If TD runs with unintialized memory,
- for the linux guest, it will cause TD to access unaccepted memory and get
  killed by KVM;
- for non-linux guest which configured with #VE, the guest will see #VE and
  be informed of that the page must be accepted before access. Though the guest
  should not be able to run without any initial code, but there's not any
  security problem.


> Side topic, why does KVM tolerate tdh_mem_page_add() failure?  IIUC, playing
We don't. It returns -EBUSY or -EIO immediately.

> nice with tdh_mem_page_add() failure necessitates both the
> tdx_is_sept_zap_err_due_to_premap() craziness and the check in tdx_td_finalize()
> that all pending pages have been consumed.

tdx_is_sept_zap_err_due_to_premap() detects the error of BLOCK, which is caused
by executing BLOCK before ADD.

> What reasonable use case is there for gracefully handling tdh_mem_page_add() failure?
If tdh_mem_page_add() fails, the KVM_TDX_INIT_MEM_REGION just fails.

> If there is a need to handle failure, I gotta imagine it's only for the -EBUSY
> case.  And if it's only for -EBUSY, why can't that be handled by retrying in
> tdx_vcpu_init_mem_region()?  If tdx_vcpu_init_mem_region() guarantees that all
I analyzed the contention status of tdh_mem_sept_add() at
https://lore.kernel.org/kvm/20250113021050.18828-1-yan.y.zhao@intel.com.

As the userspace is expected to execute KVM_TDX_INIT_MEM_REGION in only one
vCPU, returning -EBUSY instead of retrying looks safer and easier.

> pages mapped into the S-EPT are ADDed, then it can assert that there are no
> pending pages when it completes (even if it "fails"), and similarly
> tdx_td_finalize() can KVM_BUG_ON/WARN_ON the number of pending pages being
> non-zero.
tdx_td_finalize() now just returns -EINVAL in case of nr_premapped being !0.
KVM_BUG_ON/WARN_ON should be also ok.

> > > +	 */
> > > +	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE)) {
> > > +		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
> > > +			return -EIO;
> > > +
> > > +		atomic64_inc(&kvm_tdx->nr_premapped);
> > > +		return 0;
> > > +	}
> > > +
> > > +	return tdx_mem_page_aug(kvm, gfn, level, pfn);
> > >  }
> > >  
> > >  static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> > > -- 
> > > 2.51.0.268.g9569e192d0-goog
> > > 

