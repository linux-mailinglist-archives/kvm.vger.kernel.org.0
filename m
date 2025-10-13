Return-Path: <kvm+bounces-59857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 79D8CBD0FB5
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 02:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B1A313471E2
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 00:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26FE519D071;
	Mon, 13 Oct 2025 00:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GLfOOmlh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DE72566;
	Mon, 13 Oct 2025 00:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760314806; cv=fail; b=qbuRP59Xd6IAvdtfRDRawHa+k81nIMJ2bZrqr0kAnxmhbsjWla3MCLBY+Q6PRi/i+kqlI8O8RwYFZQoE/lhfa41KR74ssAmqKQwWzU+Vw29gr4r8VPjReG2B9SgRY3CogXbx0vKqeRiOGfH0ALB3sX2w7SsCrdRlvtaAraFUZug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760314806; c=relaxed/simple;
	bh=5sSm09YRQ5Og2kNr04gvLDyaF28Kpjmz5J8+tBKxry8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k1O5lrapLqZIqNj5CH9o9vHO42ZzTI469PUIOaiyGGJfbmnAzh2gP/4lz599WIurWh6U41IuszybjSNvhK5wLSLmhBzBvrhkPgFBxJuAzqy6tp9X8JJVrN9Zrmykwp1S0ywUY/2r/sIcWQSL0WKdKWLzgbxpimf7FSORgTz20cE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GLfOOmlh; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760314804; x=1791850804;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=5sSm09YRQ5Og2kNr04gvLDyaF28Kpjmz5J8+tBKxry8=;
  b=GLfOOmlhgnY1d3pL4PXIkJboUBQUIiiUqN6p+be1YqgIZQAITdM7crc+
   Q5Z0mhV/OqGNBlj4vM2jeW6Wol11bheVi4G4pgbFh26NZUbFWw1kPv6r2
   EA/Z4XjJSbaeOrbZyWxl+rDiJQDxjSD8FqZXpR7w6pLKaVhg/h5mHBIkw
   l/6gfcqH/wASu1VM8XTua6GFNct5siEYNFBujWF2k1HZXa9AtuA1/Fi0I
   RkxyPPFECRExdWyyXb7y52P5W8nd7k1EoSVZfHzRwBCscXpxoTHBM0wf8
   jmebwjQ8e62xuTdA2LWf9d5RYS6afZxerRpIkGSUmLeD+Mh5XTYRcJhij
   A==;
X-CSE-ConnectionGUID: go5PInMWSOmZcvge6WPI+Q==
X-CSE-MsgGUID: tykJwB4wTqCnfRKhFPvn+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66274693"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="66274693"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2025 17:20:03 -0700
X-CSE-ConnectionGUID: i4ky3AkcTui+ccpTU5RoWQ==
X-CSE-MsgGUID: fIQCjWHpTh+Au46BfYWJgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,224,1754982000"; 
   d="scan'208";a="181472460"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2025 17:20:04 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 12 Oct 2025 17:20:02 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 12 Oct 2025 17:20:02 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.55) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 12 Oct 2025 17:20:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p0INzuQ+nX0d59tnHTsMTickV54n5JmYVc05DAsj6bxBUmRsl+00qygXF9jGhRtOI3sHRPY153uwpqdqAsjxpJX+PyIQNaoFIWGyfHRs5JrgAlX22DYKx2X88JMmbDn5pqu9c3lDHtR+E+ha4q+rktLh2w87zE0QECDoeVwl2E7V+dWZHW5SEXvAuuSn47HO8oZhR8fAdj2VWAlyadxOA9ze6cCJppHum6iNmS34q3rlveYUvfvaSyeC4kE3uhCPl5q/obKNKn98TXEwvtc6yfMf9iXqngIMl/o+U58BssoV3E+I6R3yO5JsqIkmqYNyixMCRPPNCsGyYR/y6kdNdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKo9DcfaD4k1xuKlbHa2hD961Zm9N1dyJAhSyvwM59k=;
 b=KgYAj6RCJuT2So0NPBPfYeStpCeG8jFMMCTQ8uQO1VMUi4LkQMrr0x0jSEh78komuZ9T0EiDRndpI/txTgNdL4ZUaJUFww8S+ypbMY1U4uwk/CNim7MaUvzaIZKtchgcH5t/CFLIxHRX8rVhHds3EGQRi2ve2qXC1FULKRuGLFchy7GXNUYyW8Ly0DkvWNtgQbq5jdsJJd5EbOJ9Sb5w3PYA3o/GV4PrrtLV94ns+ZU/j4U6w1+7JXm5xsLGeKLq+rsEeDtOuJJGubMCPJlbrmiP13ZL1486W8sqAyhdya1Rg2k4n6R7B9N/q/tfGMPyFcrHKpDMNV3eHaUZ8K2ucQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4993.namprd11.prod.outlook.com (2603:10b6:303:6c::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.12; Mon, 13 Oct 2025 00:19:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 00:19:53 +0000
Date: Mon, 13 Oct 2025 08:18:00 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <quic_eberman@quicinc.com>, <michael.roth@amd.com>,
	<david@redhat.com>, <vannapurve@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 17/23] KVM: guest_memfd: Split for punch hole and
 private-to-shared conversion
Message-ID: <aOxFOJrSEyZFTMDD@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094503.4691-1-yan.y.zhao@intel.com>
 <diqzh5wj2lc4.fsf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzh5wj2lc4.fsf@google.com>
X-ClientProxiedBy: PSBPR02CA0001.apcprd02.prod.outlook.com (2603:1096:301::11)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4993:EE_
X-MS-Office365-Filtering-Correlation-Id: 707e8412-2856-4425-6661-08de09ee3b3e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uUi2ajE6c0xwxd6GC8i/rd/B7bT6nA8aqR+rotqVmun73x+3IxL8pLD0yheN?=
 =?us-ascii?Q?5r0H173RrTkZ06sFS6r135PaJMTlz32p32TFJCBKjFUrBh8pyemeSqQo/Lhd?=
 =?us-ascii?Q?GI5YuEjunS7ZBaNxDNRnjoKEgeY6i9Oz/uhs45OadKDnqZJXOomM/4aE9ZoP?=
 =?us-ascii?Q?mnQD+Luk1exHqZ1RDDnR/LVoGbbcx+7+17u/FyyU8Je4ttcLldregGcxXOYg?=
 =?us-ascii?Q?ayZPVfpNjxHNTjsRLyvHvbny2Ro1FS2yM9kpX3JJ1lWNl4PbFJsy47kmmJ+C?=
 =?us-ascii?Q?7ViM1cyqjD+RJzxnoeKHpAsYoDQzj864Vq79mzbZclANTKeI97ZF4OLPJbXw?=
 =?us-ascii?Q?1Rg2Cshhjz293nzH3ZCY+ag3yyvCrp2kNanBg2rKgEtzGBshXZTnq42oZKnK?=
 =?us-ascii?Q?46x+/68pH3mP7PV1tYxyshg3dYSXV6sL1MpDV7hJRKL72guAWZ39XLeXyWcT?=
 =?us-ascii?Q?JPZudheddOyz//ANvA8jR8bS6k+7hq2qzKIsKOopXzouNkHVZZ1pjPa/Bc1K?=
 =?us-ascii?Q?893uQmv6JGH7emS/+z0bimmODpHHIETyNNSPTwI9zsq3ed/lgQbf/lzPe1Vs?=
 =?us-ascii?Q?NGvLL1LkZrg1xPyyg2cit87hDDnP0y8psKGwRtC3AE7pQHspBeAJ6F9Njw2P?=
 =?us-ascii?Q?ka4jMvCVAcp/s6ZKOtmhjaFpCpcCG5wEUHBWo9/8k0m6LcWco/n+e65wlg/P?=
 =?us-ascii?Q?oxTl0Vlh7etj065usY7xGJEkthYmf429WX5KP1mWqpUPz1GmNOmpg2e/Rh1h?=
 =?us-ascii?Q?EesKxZ+L1u5EXHBVMoOBqSJjtWFDRBACX6837HZlaHKAWERYYqy8Ggg9Vb5T?=
 =?us-ascii?Q?GQCMgbEQUtpt0wOStrIZuK3kfl6N/k4khPriDJVsI8zZvzzbvwBNTmE5Ne/G?=
 =?us-ascii?Q?2SemyhogaYBK8ow+I9KiDN0XKngDKeH2pCoYYdfQ+FdO5IWwuvfb/Yt+rewA?=
 =?us-ascii?Q?upRjV4BWibM+t3+ZP0KwNAaYGmpChjiTnOuH1DOgpLHxK+DaQC7rfJJcJ4Zq?=
 =?us-ascii?Q?uViIgKLeZHx2XoCRZ55CWEqCtoY7aS6Xb9neeAxmvHGKlWsAoBumpnfpoaTW?=
 =?us-ascii?Q?EO5wo+JzqiTrse+wFnZcXnAfOJ+50NvkNQxkgIWtcxBcY2AcK002LKEBrCRo?=
 =?us-ascii?Q?EnPmpCwo8lTGX9KROQqjKrmVesbtznifIOgO71mgJklrhCB0W5W0meC7Tf3H?=
 =?us-ascii?Q?USYkD5RmInr14TUi2M83MIvYgo18dV/zPWVPMGRSti/2ewr8mtHIsXmmSiQo?=
 =?us-ascii?Q?uwBIUS0aCFVT8c/iwNqq7xUgj22DmdppvQgjMJLaM64LzvNpMmfb2ZHHI4d9?=
 =?us-ascii?Q?Uo+his3qT8nens/dwZMivalwRgEl/b7DK+DVpwiKu+ICdKaDXUtJprxYw8oa?=
 =?us-ascii?Q?jfOZwDUDTMvUqI6b0bCkS6PFPOncEBV6mveIfpf1fkySWpZlmPzGVmx4yrfa?=
 =?us-ascii?Q?sBw6CNUqiV/b1W7ozoaOOlTzY5t+lBOQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TxRthVXax+dDwavc2LXRurproqDU3/2ChnjKCT1UEhtxUZKaYCjTlPfFajB6?=
 =?us-ascii?Q?3jgXAht0JTUw1Y6gENE44N3U88Ip54n54LLCAphdm8y5o2P84GBTH9GmipcY?=
 =?us-ascii?Q?c69LXljAll4x1TkZsjGQ9M7p/38HXC2TgbsvW4jYsdpqSaxXTtzu2c41lxe2?=
 =?us-ascii?Q?Ty8yX9qHYAuW1etreH3k+KG8RixrZE+Cvf3HXBBYb6PsqUMS+6Ei0TAZULiN?=
 =?us-ascii?Q?dgDWURhVIei1etegPRU8SixC2txo7NjfM0LamJD/8ftjBdrCwDEzRXoOpL8q?=
 =?us-ascii?Q?hQ1jyMF2ZqF6NsKT8jzyxIOv2HJW3r7aXwPjYKWHjp2fEZqaopaaItOBmgZw?=
 =?us-ascii?Q?2C6bgzX+UZP0NmfzFreZ+Rny/t7SqJ5LRInbTyiYMuW4yJpI9EzQNXKiLGlB?=
 =?us-ascii?Q?Q2cxQ5LG4emoAICfTNPXENyrINcYC0eEt8VJGub3w2e3Y9+hLQNbdoUrU1uh?=
 =?us-ascii?Q?nOnXqLwpRrG18Bg/Y3B2blANeisjdThXyz4u5E6JNMBOJKeHK5Oa78FBBdDF?=
 =?us-ascii?Q?RCZx0b9oVp2umNgXLWiseGkjeFMvHp5b0bMIs6xcsLH0RBIHmugYVD7zDVFi?=
 =?us-ascii?Q?/XCd6pgvfguT9K5/CUBiSkWlcvZUlK5sNmjUBa6X0dV8KgYXUjfWYg2f/ZxG?=
 =?us-ascii?Q?q0ao5F5Wlz0QibnpHrnaGOj6MW4TKvniHtB/0oQClOYv0JJwEdYi/jCchHXH?=
 =?us-ascii?Q?UDLim6LuwFl0cWZGsJYhilINsptW6Y09ci7SvkZBtt+X/WWcSTLGDWhBxyE+?=
 =?us-ascii?Q?122C8vy5eXi9OpyoqKH0MkwjaBKUne/DEZ0qHdhOlUXE9xr6OFIkX7HsDWhM?=
 =?us-ascii?Q?PhKIhaOwJl/ucPBlpO+Qsj+2Ahb4PTyAt5nenjkVzc+cHaarKgRMEQnHVJtg?=
 =?us-ascii?Q?1yTELt5jW8cwjza2f9E9PSAYE51TkXoT2NmWMCPhKRBWnquXzpkm2D9/M9kT?=
 =?us-ascii?Q?je/brBOk00p2BM1sKxhchEsb510cvAlgTar+vOeKKTjcjf4Q+bqFpxp1bSeS?=
 =?us-ascii?Q?Zpk8PKF1LL/HxA0puxLeR9EkFPuTrC+DJGv5glqWd5hN2Y0KwesNaAKfEthn?=
 =?us-ascii?Q?t8bbScf/+m7WDUDZWqXjylkwnq6CPp67aecbq3zV6wm5IJE4mFobXV9/K+R8?=
 =?us-ascii?Q?JLzHVwRjuElsrhsD1HnBlCExnS+6VsX7JeF3Xx+HUGDscg1QhxWrOryWuigm?=
 =?us-ascii?Q?CUvelFmEXz4xvhKlhwxDel5iepjtrks597qbr92BiHN1kceR8hwddxVO0N1k?=
 =?us-ascii?Q?XLRGcYFTosHO0a7AAJFd5a0E5lQSUXVJVenAaVsQgLMHRXnkvD0Xrc/z0BH0?=
 =?us-ascii?Q?GPDEwwjXHorE4MG0mTaTqEmfvM/mNg0ICLCnWJx4uF6jnBCoAYGt1mdFpO6a?=
 =?us-ascii?Q?xiKrlkjI2NOSSSQL8oTfNJKpBwsu6TcQwpDK8M1uIpJDvmWS0R5FnKdMd0ds?=
 =?us-ascii?Q?VPWVwywGvXxIKmg8uX3yDWdR5FVEMNYTPiMdyVtR3FOBugplLGrQ/SRL3B2x?=
 =?us-ascii?Q?NnLf3WvJK4nbc5BVV7mucqY4aagWPLb+RhWi7uUstENXg9Q2aHe9fEixU3C5?=
 =?us-ascii?Q?WhCkF+KLFtm6bqhOD6ngcg4VgIrLmoUpIDdYN1Aw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 707e8412-2856-4425-6661-08de09ee3b3e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 00:19:53.8308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQY61d7KpKLYhc+JvA7KKBQ/TxcKnTpqbV1KEfmsssEHkE7aws96CzYsaLeGMnSUAr8swr/MSme7yL2LioPNng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4993
X-OriginatorOrg: intel.com

Sorry for the delay. Just back from the vacation.

On Wed, Oct 01, 2025 at 06:21:47AM +0000, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> Thanks Yan! Just got around to looking at this, sorry about the delay!
> 
> > In TDX, private page tables require precise zapping because faulting back
> > the zapped mappings necessitates the guest's re-acceptance. Therefore,
> > before performing a zap for hole punching and private-to-shared
> > conversions, huge leafs that cross the boundary of the zapping GFN range in
> > the mirror page table must be split.
> >
> > Splitting may result in an error. If this happens, hole punching and
> > private-to-shared conversion should bail out early and return an error to
> > userspace.
> >
> > Splitting is not necessary for kvm_gmem_release() since the entire page
> > table is being zapped, nor for kvm_gmem_error_folio() as an SPTE must not
> > map more than one physical folio.
> >
> > Therefore, in this patch,
> > - break kvm_gmem_invalidate_begin_and_zap() into
> >   kvm_gmem_invalidate_begin() and kvm_gmem_zap() and have
> >   kvm_gmem_release() and kvm_gmem_error_folio() to invoke them.
> >
> 
> I think perhaps separating invalidate and zip could be a separate patch
> from adding the split step into the flow, that would make this patch
> smaller and easier to review.
> 
> No action required from you for now, I have the the above part in a
> separate patch already (not yet posted).
> 
> > - have kvm_gmem_punch_hole() to invoke kvm_gmem_invalidate_begin(),
> >   kvm_gmem_split_private(), and kvm_gmem_zap().
> >   Bail out if kvm_gmem_split_private() returns error.
> >
> 
> IIUC the current upstream position is that hole punching will not
> be permitted for ranges smaller than the page size for the entire
> guest_memfd.
In hugetlbfs_fallocate(),  the punch hole ranges are hpage size aligned.
    start = offset >> hpage_shift;
    end = (offset + len + hpage_size - 1) >> hpage_shift;

However, in the guest_memfd (at least in v2), the punch hole ranges are
just page aligned.
    pgoff_t start = offset >> PAGE_SHIFT;
    pgoff_t end = (offset + len) >> PAGE_SHIFT;
(Note, I noticed that the range calculation for invalidation is not the same as
that in kvm_gmem_truncate_inode_range(), where: 
    full_hpage_start = round_up(start, nr_per_huge_page);
    full_hpage_end = round_down(end, nr_per_huge_page);
We should probably align these two implementations for consistency).

> Hence no splitting required during hole punch?
> 
> + 4K guest_memfd: no splitting required since the EPT entries will not
>   be larger than 4K anyway
> + 2M and 1G (x86) guest_memfd: no splitting required since the entire
>   EPT entry will have to go away for valid ranges (valid ranges are
>   either 2M or 1G anyway)
> 
> Does that sound right?
If future guest_memfd code could align the punch hole ranges to page size for
the entire guest_memfd, I think it's ok.

> > - drop the old kvm_gmem_unmap_private() and have private-to-shared
> >   conversion to invoke kvm_gmem_split_private() and kvm_gmem_zap() instead.
> >   Bail out if kvm_gmem_split_private() returns error.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > 
> > [...snip...]
> > 
> > @@ -514,6 +554,8 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
> >  					   struct conversion_work *work,
> >  					   bool to_shared, pgoff_t *error_index)
> >  {
> > +	int ret = 0;
> > +
> >  	if (to_shared) {
> >  		struct list_head *gmem_list;
> >  		struct kvm_gmem *gmem;
> > @@ -522,19 +564,24 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
> >  		work_end = work->start + work->nr_pages;
> >  
> >  		gmem_list = &inode->i_mapping->i_private_list;
> > +		list_for_each_entry(gmem, gmem_list, entry) {
> > +			ret = kvm_gmem_split_private(gmem, work->start, work_end);
> > +			if (ret)
> > +				return ret;
> > +		}
> 
> Will be refactoring the conversion steps a little for the next version
> of this series, hence I'd like to ask about the requirements before
> doing splitting.
> 
> The requirement is to split before zapping, right? Other than that
> we technically don't need to split before checking for a safe refcount, right?
Yes, the split is for private-to-shared conversion.
TDX will not hold page refcount for private pages any more.

> >  		list_for_each_entry(gmem, gmem_list, entry)
> > -			kvm_gmem_unmap_private(gmem, work->start, work_end);
> > +			kvm_gmem_zap(gmem, work->start, work_end, KVM_FILTER_PRIVATE);
> >  	} else {
> >  		unmap_mapping_pages(inode->i_mapping, work->start,
> >  				    work->nr_pages, false);
> >  
> >  		if (!kvm_gmem_has_safe_refcount(inode->i_mapping, work->start,
> >  						work->nr_pages, error_index)) {
> > -			return -EAGAIN;
> > +			ret = -EAGAIN;
> >  		}
> >  	}
> >  
> > -	return 0;
> > +	return ret;
> >  }
> >  
> > 
> > [...snip...]
> > 
> > @@ -1906,8 +1926,14 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
> >  	start = folio->index;
> >  	end = start + folio_nr_pages(folio);
> >  
> > -	list_for_each_entry(gmem, gmem_list, entry)
> > -		kvm_gmem_invalidate_begin_and_zap(gmem, start, end);
> > +	/* The size of the SEPT will not exceed the size of the folio */
> 
> I think splitting might be required here, but that depends on whether we
> want to unmap just a part of the huge folio or whether we want to unmap
> the entire folio.
Ok. When that occurs, we can do the split according to the partial unmap range
info.

> Lots of open questions on memory failure handling, but for now I think
> this makes sense.
> 
> > +	list_for_each_entry(gmem, gmem_list, entry) {
> > +		enum kvm_gfn_range_filter filter;
> > +
> > +		kvm_gmem_invalidate_begin(gmem, start, end);
> > +		filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED;
> > +		kvm_gmem_zap(gmem, start, end, filter);
> > +	}
> >  
> >  	/*
> >  	 * Do not truncate the range, what action is taken in response to the
> > -- 
> > 2.43.2

