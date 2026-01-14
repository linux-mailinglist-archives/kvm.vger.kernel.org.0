Return-Path: <kvm+bounces-67997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 236B2D1BD40
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 01:36:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9A68F30124C7
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 00:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87EE121D3F6;
	Wed, 14 Jan 2026 00:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uxbo5mRN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A953C38;
	Wed, 14 Jan 2026 00:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768351009; cv=fail; b=rEv4xlzkJ43wqPo0I/nxyOK7sihqj4fuC0cyuw0vPTyViCLN9Y4ht4LEt8S1592wwkgoeGeYES95aBhnX93I03x4tFXQRvqmX7ZT/TmEdGrKVZKz5aommGQQBTsp7q+JB+NjmJ7ln6/oh7x8YEGzreT8nvhW/Uc6I5McPOgWH/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768351009; c=relaxed/simple;
	bh=BeFaj9dzzF3tmDuuKIAM3m7TYn3NmoMlVX365BS32BE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AOMzGCMuQdmBDhfbtQ20yFGOtDXhFaUVZ8wjwMhtOIF/FRu9CQFo11lbpmzFbId6qRjgqp4HaYm2Q+sc0mQAyfCdYK5GQj6833o6xuhyNrHQO9az0ZZl06rz7xAqFmMZV/lYevyYJWPD6IFhN76CZDUqXJdslWrz4LKOLAL256c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uxbo5mRN; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768351008; x=1799887008;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=BeFaj9dzzF3tmDuuKIAM3m7TYn3NmoMlVX365BS32BE=;
  b=Uxbo5mRN/AJ1HaZIaPJfxtwrZrsSKoeuNpzCLh3TXxK4SwsNIQmXRg19
   DjCCtauDtf6J9svH12p8zF/Lel2QsLFk5iCJpKbFJQrXGnEK6tMktdc6c
   GaweJVwB/J0hKqQCvys3cOHsx7A87oFtArZoCzaglyKx6bAwmFatii+Ne
   6lLTt5nvfa38uUYvzIk/taxAoMsrqovOsGXg9Zf1/BHfURJOEK8f9BTTx
   XVHtxspgGcGeN/BoonaLcvf9l8ZZzCMqJde5DqcqRTmc835xxUL7Lo0zQ
   gFgukegR5N3yV9WD623LgyYUByGk4A0k6IGlR3xV4mpzId01p6qk6w4Ig
   g==;
X-CSE-ConnectionGUID: xCemA9GtTYWSNT5Jxs4Lng==
X-CSE-MsgGUID: OxfqP+k9TeSUjXmoQyuWBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="69382711"
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="69382711"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 16:36:47 -0800
X-CSE-ConnectionGUID: Fb2K3VSDQx+/igUB03jDZw==
X-CSE-MsgGUID: bpOBfivnSXy1f5qNf5MF9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="204321341"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 16:36:46 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 16:36:45 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 16:36:45 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.29) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 16:36:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bhxXNLN//BAe3i5W/JlLlQgbegCjdIvo5C4JrajCPIlWKHKKzDTiwvCl1ChMHTyVYlPy1CQxD+NxPta9ZuBJJj0Qxzy3PBFHyBm7hyheReaIJkIyudLuLRyjZ/SpGU83iyQ7JaG/YHZGKrhdVie2RNcs3tefz8Q3ck8WAom+ZVckAYOuXFlTa996V5cBPwa8BNQYCbAMWyp8sHt4vMU5L1OPaupt1wfW5PyDbAXe9HnK2od8RZopWxnk2W8m0/6GGz+0DaF52MeOlw/TKFCfrIETZlQmbbbaLTdPreTVz06koGQqDpMidlTcizJGzmpvnBIXO7D5STRQu1k4z7kkhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5zehjHP79V46HpgVglQPbHeghp00W35jbnYbYrHHBw=;
 b=HGaiaBOlvfrWSyQa2kCv/kdKOY6jXDxFnZv73u4eoL5UrsMjjVb3Boa9/e4Khryj6hLwre0nUJkClNUmtwRIeg0H0Pfhic1jN9tHJHxjNlhfp7ilW3Vlsk868DnvuL7jnV3HZhS0qcMBS3+icTLnEVAfZkt5s72cCisnel2Igf+7u7GDcpyvQ6Ba6NvUja2eeqUFFGVpgqad4tgJPiA1j+ZZqLO6SXc97mVvKEUQm3uoq9wkmlbKirKCtLd+ZqSz4riQawXsKfUDly7MCL+kUjTQeCUgmQf+CEDKeasqHZXo4m4AzCJ56KAKLZbzM/hYH0FNfxtaG5VQ5SVZBSSI5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 00:36:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.005; Wed, 14 Jan 2026
 00:36:35 +0000
Date: Wed, 14 Jan 2026 08:33:53 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Sean Christopherson <seanjc@google.com>, Vishal Annapurve
	<vannapurve@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <michael.roth@amd.com>, <david@kernel.org>,
	<sagis@google.com>, <vbabka@suse.cz>, <thomas.lendacky@amd.com>,
	<nik.borisov@suse.com>, <pgonda@google.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <francescolavra.fl@gmail.com>, <jgross@suse.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<kai.huang@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>,
	<chao.gao@intel.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Message-ID: <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com>
 <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com>
 <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
X-ClientProxiedBy: SI2PR04CA0006.apcprd04.prod.outlook.com
 (2603:1096:4:197::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB8369:EE_
X-MS-Office365-Filtering-Correlation-Id: 15c8bf22-77db-48f9-fc58-08de5304f8d0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?upWH1ncGmX4vJYfhPnhy0J4EjKIxVgHW3J7G9pptzxSLRxuvJXHrcEGvbJ8g?=
 =?us-ascii?Q?0RnhmtINBKskbWQItQKfN1dRZy0DfPXiAwIpFZ6V/P535AsMtuiHFN5KNl+p?=
 =?us-ascii?Q?AMHo/Z8/iIOR1niv0+smoJAy7qU5V9awqWjoFr3QQ3MFNlKUaucQRKZfVWyt?=
 =?us-ascii?Q?yi09xBXhepbfyNtWjVbpvP/gObF7JBztxEhC25drRNMgl4sxpm9inkV7pOUw?=
 =?us-ascii?Q?At0MhoN61FVB0eH5aOX5ZQnnpT8JXhM4znbo5c5LMYBREGhjOVaCJcEfiRpO?=
 =?us-ascii?Q?ZUto0+61jKsfvPHjIQSYOMpUplzTNIl2iJxJvyUhFU62m3bfEfO1rwdUI5yN?=
 =?us-ascii?Q?9brSbLWdmBLycEIrJoZz4m+0abqEuR62Z863R1a3uXqXVORoFpmLXKy4IZfA?=
 =?us-ascii?Q?cUPGgRViDXxiTEfBAgiM9aovbhXJRGppTlBODgLN66fHmYg9Xl1kqFk349u2?=
 =?us-ascii?Q?FMxaKc/M30JvdM22IwTNI+74jL99ydRmsZdC/kkKr7Mr7cDXPEiUze4/krMo?=
 =?us-ascii?Q?1ncwp9smL/09VXrgQK64my3dG5DXsT+H+TH04JL5kAncI+rjAFOrAJHGAvyP?=
 =?us-ascii?Q?YuMijmOnKG20LewPnXqT67MfktOJHNoJ6wDMVj0N6B9nsKb+aMQI0mJwW83k?=
 =?us-ascii?Q?SmDlEkA1zPwabWUOuLve0Ql//rAZkjxYxjSkjI89kq16igiycDUWlvHo71Jt?=
 =?us-ascii?Q?LwhJa9nIXbNDm1Sdag9IQiueDRyiGA0bIzJrbr1sec0L7KdiLAbUy2fBdBtD?=
 =?us-ascii?Q?pu4AF4oXViE9/UdXF5jVm1Ys42qmFcODbN+gAJVefbpKis+F9Xo+/2VkLLpx?=
 =?us-ascii?Q?G25dW5zxWLQx5cn43YJ6UMqcDLMFEUY1d/JOgwlE/y43kBjMEj7BO82u/kXn?=
 =?us-ascii?Q?X5lti8TLKlFLkPnTa5xopqP2NOh+1HGHsDll7JGbJNweHRZrBCFcQXB4JvNe?=
 =?us-ascii?Q?Dqm+n/th01WyD456Vkkogane5fdOwdzqASA7MsjIAQ7mTLFfznpMISnL5R2L?=
 =?us-ascii?Q?6R5ROxx9BtykeX+IvissCRlNWzXaAJ5OVdsl+/A1IBcjGReHqzNVBU7ia++Y?=
 =?us-ascii?Q?HOrTuxv9zQwowvXXEMTPz5eRAZWxFmS0s0gZj1M7DJLbMSPBp90wSuJ4Du7T?=
 =?us-ascii?Q?TsrzE+cU0poPBv3a1m/6rX+UZrZgBEo1X7VFfAePdgV10XdfUXBfCFyvMurH?=
 =?us-ascii?Q?sj9wjcMrbtwJox3ERJ2GnAxxvsx9jYWyfqoRU1p8vb32kzAemsWqqu/m2dPr?=
 =?us-ascii?Q?DvOY5ENDYxIrH9owG2KGG4k4806w/rMbCh9duN6j4Ndd5cj21bnmhR3iovQY?=
 =?us-ascii?Q?x+68SGE/WMtnjlG9Baas/dlkH2Yo9/JDeupyWL8TUuqaiic+8OXydTCdXUop?=
 =?us-ascii?Q?ghFaMV6/gI5L3GLRnaBN1axH6AymgpUvjdGUCBD82OI0CIk+sa2ryeiIEI0d?=
 =?us-ascii?Q?XBGSulbB04l2dFBxNI5xJeKAGj8S6bBa?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mjm8nbb0z3/4E4hzyCwpNZ7WpdQaKrBmpnOy1bOPhZ4lUBZAt1D1sh9lTp3a?=
 =?us-ascii?Q?QeaByGTx62pakTmDjhFG6jhvdhwaW7M5l5mlKRCMQNhjSY+s3y8lwcU25cRK?=
 =?us-ascii?Q?DAm/d525tmO9jFXI9geeN14GFXaBZqGHnxr6YAAw5otm6l4psmVfTDKIfDr/?=
 =?us-ascii?Q?mso07R6MGB7Paql/NmBNJWM3G5JKcC9EIJDjNeKGtWg94sjPW5E8nxgFlRqu?=
 =?us-ascii?Q?1Xsu4iwuWhQoSW66VfTntjpYVJMJ45xMi148cEo53ZzP6nprFRyxRMbpapMH?=
 =?us-ascii?Q?lOdVEG2rJsbJwHSVgVOhzj8isenojUlA6dKGmdSZvvPu75iLh8cmXt9tILuS?=
 =?us-ascii?Q?pvmVfREn2XmaMfWgSTz396MTYTeJxzHXcgnoLQ9zRwPelduAARDuZZL896fw?=
 =?us-ascii?Q?rVBQQOdVu4PSPPSDKi9BKJ1U4pAMt1txs96k9Am3KAtEDqpjjL0GRY4oWLhC?=
 =?us-ascii?Q?it98WIzFaMVOov2dL/PoSmHH58qW77aqHyQ3BC6cZdsk5qYNcqNUr9CbHlLF?=
 =?us-ascii?Q?eeLuFBo8kcJM6uC+0PiuHOW8VKTD+DyCWPPzH4nPuuQ8QBCFCnT2sebZlSS1?=
 =?us-ascii?Q?ozv5TKYub0S42BzCbYiNfxcrgzf9vDnUivXojAIMvPesb3EnplCJ2oz554oA?=
 =?us-ascii?Q?mkM3/cWCzHs1SCJfMRaRRnWqAER5uEruwt3I4lYi5niJrxanZlfL6oVlwi+Q?=
 =?us-ascii?Q?KIObPLMLZuzpJA6hAfcZNcHdKze+Ld7RR07GDSEg10txRGA2Q/zXUJTT4klC?=
 =?us-ascii?Q?Hy57486aMsPeDKfv9QU27Eo0p+1f6z8SEDgSZQMNdbOCnXk8zPc7HDwIks47?=
 =?us-ascii?Q?VJWZQSxlr6HzYN479+jFSYAp4EHmsUlqmKhSooNVgZJFywIou8Kihxznvdfp?=
 =?us-ascii?Q?BARYIeNJhIP3M1w+MdgVY5/s3/cWuWFyKxXBS1aDDL9mn5AIEOPeBiBv07p/?=
 =?us-ascii?Q?W50D1U5wcGO91Wmp35GPNcgHCUX8fpfPbInErZfP8bDloAb0iF2gmhuSwCvb?=
 =?us-ascii?Q?Txgz64y1TbJ0RVTT95xE2mlF3KhsCPQLMhleG23GGhqKYzruTsLHqjgnIxwd?=
 =?us-ascii?Q?+ohmI3ZqEf+mkvU+I+PIb3SpXBuYgkEbCkq2dDsHcYtZ4okIJ49+mEyg+FgC?=
 =?us-ascii?Q?04UTxO9ca2QdjOZYP8SXJy7+livIt40L/443p+QnanUBDxyJ50NErOikIpTX?=
 =?us-ascii?Q?KEh2MWfIuEF4eypRLqXposRKrp9J+HjnI2Hb3De2wPcXqEHgHjv382+KFdbE?=
 =?us-ascii?Q?+F1G/iOObBNE1Ilfird+WoB9jQ5FDR+bQ1/gLHhOOQwVjyAx6kcd+SYCaYd/?=
 =?us-ascii?Q?6iwVDGkIRTfy6/bnw7MOSHK7Zc4xC+vym70/FL4636NzYZ2VDbiujFK2ljXP?=
 =?us-ascii?Q?GqhAzkPOfEW1nCXPPnaq6fM5qbeMiQRLSGC6YS1kwkaw07Vl1Wg+JpT285/B?=
 =?us-ascii?Q?i44/MaqiWU/V60eIeGznxxca3ATxZh0Tov8uCl9asMJPuXxLesge/XaQ2VVQ?=
 =?us-ascii?Q?+FFL1L+wZg2quhNi66+I7SSB0gt4rDERGzA665NNE0eenHv8PcEv9vCpvymU?=
 =?us-ascii?Q?QDXP57T3Wy9oosuzCqpioYCTijH10pNbGPESgEm5l8buIyua7TP/I3n7jUwq?=
 =?us-ascii?Q?HLTKWC8cfhasmjGr7xjEmcQS8OV2aeuAMUCTA1oGJWKAd1JdN9jhavsT/v0Y?=
 =?us-ascii?Q?X8vPw+q3GBpBupVjCvKcVFhc8qJ856BbEIf6gKILAxChziI8VhL1Ula2DcSH?=
 =?us-ascii?Q?9Oo+w286Eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c8bf22-77db-48f9-fc58-08de5304f8d0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 00:36:35.4533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mjdn9SntRVHjNgZf+7q9h9Ubh2DnPfKus+XP2ITfZOAAT+tpyWvhC0VZEasBQ4rFiZMPccPFZFGJqgW+0bhamA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8369
X-OriginatorOrg: intel.com

On Mon, Jan 12, 2026 at 12:15:17PM -0800, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Mapping a hugepage for memory that KVM _knows_ is contiguous and homogenous is
> > conceptually totally fine, i.e. I'm not totally opposed to adding support for
> > mapping multiple guest_memfd folios with a single hugepage. As to whether we
> 
> Sean, I'd like to clarify this.
> 
> > do (a) nothing,
> 
> What does do nothing mean here?
> 
> In this patch series the TDX functions do sanity checks ensuring that
> mapping size <= folio size. IIUC the checks at mapping time, like in
> tdh_mem_page_aug() would be fine since at the time of mapping, the
> mapping size <= folio size, but we'd be in trouble at the time of
> zapping, since that's when mapping sizes > folio sizes get discovered.
> 
> The sanity checks are in principle in direct conflict with allowing
> mapping of multiple guest_memfd folios at hugepage level.
> 
> > (b) change the refcounting, or
> 
> I think this is pretty hard unless something changes in core MM that
> allows refcounting to be customizable by the FS. guest_memfd would love
> to have that, but customizable refcounting is going to hurt refcounting
> performance throughout the kernel.
> 
> > (c) add support for mapping multiple folios in one page,
> 
> Where would the changes need to be made, IIUC there aren't any checks
> currently elsewhere in KVM to ensure that mapping size <= folio size,
> other than the sanity checks in the TDX code proposed in this series.
> 
> Does any support need to be added, or is it about amending the
> unenforced/unwritten rule from "mapping size <= folio size" to "mapping
> size <= contiguous memory size"?
The rule is not "unenforced/unwritten". In fact, it's the de facto standard in
KVM.

For non-gmem cases, KVM uses the mapping size in the primary MMU as the max
mapping size in the secondary MMU, while the primary MMU does not create a
mapping larger than the backend folio size. When splitting the backend folio,
the Linux kernel unmaps the folio from both the primary MMU and the KVM-managed
secondary MMU (through the MMU notifier).

On the non-KVM side, though IOMMU stage-2 mappings are allowed to be larger
than folio sizes, splitting folios while they are still mapped in the IOMMU
stage-2 page table is not permitted due to the extra folio refcount held by the
IOMMU.

For gmem cases, KVM also does not create mappings larger than the folio size
allocated from gmem. This is why the TDX huge page series relies on gmem's
ability to allocate huge folios.

We really need to be careful if we hope to break this long-established rule.

> > probably comes down to which option provides "good
> > enough" performance without incurring too much complexity.

