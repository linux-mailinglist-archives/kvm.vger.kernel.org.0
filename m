Return-Path: <kvm+bounces-23184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36957947512
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 08:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85A5BB215C2
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 06:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06209142904;
	Mon,  5 Aug 2024 06:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QBNn7gDS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0B638385;
	Mon,  5 Aug 2024 06:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722838345; cv=fail; b=jEl4b9ZWUWvTYObElpRibpnEem4sxwoBH9SKxXHzPtYXc2rNSI/bHbnB8v4Ysov7DJQS2gqU8J/6BCeOqIYIawIOv/T50hmR+IwWD00kqDi18CuYjZBt0mgpfPkGy6whdSRkxIG1CyzZ0uojByZc4trpKUoskMmqWNUA8gcpjyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722838345; c=relaxed/simple;
	bh=N4uy1fJGoqVkvO+hpj4BcGCLGDkZzXFTs7uDLknTTyk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QqcIe7UKWhgEffk/yC+FPn8AbVMuajBkXJQgliOofZ1V9fMixnXocmia6IyLCYafYgSecTMtwvDXziUtL1sBsVCpGBSXLRVh+jFdAE/dRzwS5rgdp+HbuTUpcr9subMNVKsRIuJcj34I35GxjQFcQvIO5PUjznUvtFR8k5EJ43I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QBNn7gDS; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722838343; x=1754374343;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=N4uy1fJGoqVkvO+hpj4BcGCLGDkZzXFTs7uDLknTTyk=;
  b=QBNn7gDSadXWW7QWciTwnjsFPRVJGeByCsS73Gy9NGxF3eqwGIy6AfUE
   oeJFr3xRRzDbgWlXM8lc3KxYvut0B0xtox+W92FxDnzbwcraAhfjBqq1i
   wmRwcwakHCyTUZYyFfGj2pYx21oI0LlUXmciNLPmUvDGD9nGpFR4gvGO9
   9RnvDOLaOAo3HwC7B2Sa/937GDjM8UsDzCtAoI0xR+FBqWgp3slw/fc57
   z8esEfXwS01xy1WvTYz6uGurTLFls9USPwyMeXVij3379dFVMAJvdoSqK
   NDOMFG87V3ioJ1EYkOADjqvGS9fwDHlVimK1U8bkZ3Uq3Iq/x26jdTPC7
   Q==;
X-CSE-ConnectionGUID: nItcxbr7RN+VRu4KsmGjHg==
X-CSE-MsgGUID: ItJzmKBITKuUEI+ViPoQnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11154"; a="20626513"
X-IronPort-AV: E=Sophos;i="6.09,263,1716274800"; 
   d="scan'208";a="20626513"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2024 23:12:23 -0700
X-CSE-ConnectionGUID: 25PSy8naTM6sxVU5gzcaNQ==
X-CSE-MsgGUID: 27YbOaGjQn+7JgJDjg4rPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,263,1716274800"; 
   d="scan'208";a="60421926"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Aug 2024 23:12:22 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 4 Aug 2024 23:12:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 4 Aug 2024 23:12:21 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 4 Aug 2024 23:12:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WZpHw4fY8RdIvQqT77mGoNmfTXXP5ppwrWeWh9PQFV+ND8ErAcp4jlO6CRjfIQDQiby1jfY+sj6NfYSSBod2p1r8T12ReEOShc0/DF3Jki8twE2DeRHw683O/YkEuAVBVlNpXZX3j/2nKMazqY2ZpeS1lzFP0L0dnVLeMXytLuaWg/CLfNMIsk2zIWN6//pcC6RSYrOKDReXSGbOx6Qs4lIOUoShYYo2Geuw8kMTHYZV2rLaQOQwUZRQSOnVofcbqFDTt5CsS2rDboUlNfLf3ju2XDgd/FMOUykw5BBDlcBrmEFIpUnQC20qn+W0CQuVGbhWB/YPILx+kZfE5MZrJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aKeRrGNiUSCMy2kD2Cpc+Q73oWANLJPqv1Gg4I7RDI4=;
 b=LA8JOL6Ye3ZecFzbUb//W73JaepLCC8TzJJ6qlLRQf4qAg5aRCKc4BOnlonimEO3+1676pbZu8E8H4DGU4FblAtZgO41c+2vk1d6e/o8v8VFPJ+06/JlA9qgdkgW/6UcXFl+mHi5jDFz/nMyQ9kfHBKRz8zYwFijaPVA+/krcR/ZBqDpxjIPMG5UvDAWuxHmxiCDhdC9mT10TUVE38yJt6AgHOYJJdzGUdA/kuApaf0lE8pAKuj1rfDibJGcwvYONvqA5lheV4chH9PXKDcu2issTWcqAUOKjHuwrFFdL3tXOi1MAjO7ZqckWOSGwYBHMCaNa4Rj+UsP6AbqtSsi7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 SA1PR11MB5945.namprd11.prod.outlook.com (2603:10b6:806:239::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.30; Mon, 5 Aug
 2024 06:12:19 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955%6]) with mapi id 15.20.7828.023; Mon, 5 Aug 2024
 06:12:19 +0000
Date: Mon, 5 Aug 2024 14:12:08 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Maxim Levitsky <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar
	<mingo@redhat.com>, <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: relax canonical check for some x86
 architectural msrs
Message-ID: <ZrBtOAzZurwvWKZM@chao-email>
References: <20240802151608.72896-1-mlevitsk@redhat.com>
 <20240802151608.72896-2-mlevitsk@redhat.com>
 <Zq0A9R5R_MAFrqTP@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zq0A9R5R_MAFrqTP@google.com>
X-ClientProxiedBy: SGAP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::27)
 To DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|SA1PR11MB5945:EE_
X-MS-Office365-Filtering-Correlation-Id: e2366a9f-1722-48f5-7e92-08dcb5158fce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RdQr6kgU3E8ZZ8WThJSCbKVcsCR+DpU4YSGjVcMMobEYzhY9Z8J6es9tiCDb?=
 =?us-ascii?Q?P1qZTexXB1UHs1uehFXXC35Rr6H7qmwGntN7MGQ51Okhz8/aQ3/kJzyNwcjC?=
 =?us-ascii?Q?AF3WVBbBVxqih7CfqMjtzVTvxz0NQ41nA25qWFgr4Zl3BsIrdqhXZ0EWWcWD?=
 =?us-ascii?Q?dRW8Z5h6zo78fhBZs1TkMEySGdFQJlc6l9JGqhPj5zKgSlsZob+XQ0WTGS5+?=
 =?us-ascii?Q?ytRhX3cN8pWH9yh/UbqKfR7Ou9dSzJr4F+b9Dp6hNmbpwdUnuTjoH69GKFlk?=
 =?us-ascii?Q?3XCdAr/oTd5/k3rp7HAbQjiJAyc3UFX8hw5JjmzwZ8Rvv945aL0gjflKLwC4?=
 =?us-ascii?Q?+deXF89F2g8Twc+rh4jEpZa9wzvD6yJcFnVXOOPgjLOUbWdRJbEXkwaNsdRa?=
 =?us-ascii?Q?hOd3mRVtq9zXFmnoPvVH5Gm2906Xufv053bPDXiMXxuLAUPlmlFlOTj5BULq?=
 =?us-ascii?Q?6VcdKNOxAVesdaqJoc9TBZq3JUiGW1UhAqOi1xbu3lhJsQb4BZS6J5LqkKe1?=
 =?us-ascii?Q?93pRNmo4nWMjCCW1TBe9kETQeEA/6FLrJrMx6EsPzSpobUFlBFOEHfR2OxN6?=
 =?us-ascii?Q?5f1RwzekqMt3F+5p/bDxDt/U8kcPsO01hS+ebhXnuh7k0ICCdP9TB1QM09UU?=
 =?us-ascii?Q?oga7tuLOvOOAeBRrJ/ohs5ccsmBmh7pdsueAsYpUHqVDwotuO3FZbgPirjl/?=
 =?us-ascii?Q?VPzlB+ExytctH/FfSbtw0tQ/cifmk9xPHjS6PgABd7i09wO7aMRAzNdYtb5W?=
 =?us-ascii?Q?UN7O5gq+dcsMznrVc/tPuUHs3gPUyTGnWK7JxIW6kskM0MrgFwQrVO6NirZE?=
 =?us-ascii?Q?zIo6FLzOQyuh6LKQM2NLHKuQa9fi4QLbbSeIxE6GL09cjJ//olBvwEfbb8/B?=
 =?us-ascii?Q?LtMfmI0If0GZPrRiGb0Z8/3XIGmZj+cerX99B5UwAe0R3CKgH9TvU4jPSuiu?=
 =?us-ascii?Q?LZbu1SFE1gn+3Ch7RaS0Y1p35lEbOWbvtVsc84UsLVq54Byg/Wt4djTX4M+k?=
 =?us-ascii?Q?L+cJbi02CDm/IMukwkG7Jptqw/pGnpUuSNG3pVHW++lmsLmW0+NMQAckCQW4?=
 =?us-ascii?Q?0cK1/itw9/TUaZijHZfIDjlYNO37mXbDUYui4UIB9kAVb20ZENWSHfa7Vsoq?=
 =?us-ascii?Q?Q5I2EYbFks5bJLrLwmpXTH6lSeSOKiDn7zYpfgvwQ1NmXG/4Mfr4qgM9Bu8d?=
 =?us-ascii?Q?MgZI7hTgIpjStkBhFbYAfQmzjRiC+PE5dbrKD3ezdK6sLJM+zWM1oCBE7iwZ?=
 =?us-ascii?Q?xrq0Uad/1lb/SvFN7e3KZFhf/l4WulWfyEqu6UlKz7cyBtv1zrOWpZF6FgPf?=
 =?us-ascii?Q?U39mvAYPd8etMHvrkUMO+IvC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TTe2P25hiRbmKRL0/6Y5jYkUPOpQ2QqRcC69CqswzXfa8FYwj28rMIQnAiYJ?=
 =?us-ascii?Q?Dif6vo7Ltt9241tcsmD3+LEO18bhzQ+sf7s99UtJvSeK5NvEYHCC5wlNVUxN?=
 =?us-ascii?Q?KTWeRsc9zVbe0rcrOsuOKxMvkP4pc3N409Bm1n6AAKaQb6A9hPfSVCfB8QX7?=
 =?us-ascii?Q?9Pzz0Ouhz1NS2wXbyzNcWtvIFgXY4gPvlDB9MundfOHIJCIcGh/d+5NkIh4t?=
 =?us-ascii?Q?oG/AQCwgdTgex0LM403CmDJI25hppjTR0YL1qnTonmMm4c/oA/jr+bgVZPhe?=
 =?us-ascii?Q?tZZQ7tgXQAudnymlu5WBdo6qJQc9z9b/IBGC61I0Il7VmFOXJfXN5EQIQGE8?=
 =?us-ascii?Q?uLPlMEI+m8vKLBclaWJLbSNxQvG6WQ0RWS3WThLERr688HsT3HnfAhC5sxUE?=
 =?us-ascii?Q?z6AKEj/u8A283afb3u4kNevD5L+N49ZkkBO19MsZmv9yRH9u98yqueez1EDu?=
 =?us-ascii?Q?09nTRqb1+M0F66raOtnXtIuDGugFAMUtwLKHnLDwa/uESmxoZA/WRsdY6jbt?=
 =?us-ascii?Q?GSwLAeXnGBryUciRrim0GHFMAaReayJgQWby/zaLLg0QIEE3hv9iWvyZmWxd?=
 =?us-ascii?Q?h9g933eMG5TLqPjgq0FEmRoA/DyZK+OUpcmAYKvnRCdcUYEhDiY9YgdA5Wc5?=
 =?us-ascii?Q?uopBiILi2zx9SXH8Bt7NgOVikz4f2jo5HVEoGpTj7UkQKnN9KjQqdUJYG5jR?=
 =?us-ascii?Q?Q2wGqCIbCbj4LInE7DmWMiuyOmkHTxNvRFyz3Lpor77HLc2rV2Mo+RvYgb8Q?=
 =?us-ascii?Q?lZIdpgom0v95TCfQBwDSLgAvj3MTpC/fqlzQYZgBJU8UU1LcqnIXLEFElEJ1?=
 =?us-ascii?Q?wFU33iqkYBRgWG7diVRnOYixWNb/QKT212MPi46d3ejP/PrIcUWtSkMzzaj7?=
 =?us-ascii?Q?OyMn/NTWpiOa998FpCWbZTS4KYZdYDNtV0TNKpR69PtfsRFUDhyDFypfrKKq?=
 =?us-ascii?Q?T+4GQLj4MSwOQmtgEhQ3evuaQI95G0QIYwZhfGa1ELRkUiNq5Y3VqC1ZpxFb?=
 =?us-ascii?Q?ChjvNlxKuhUbIFfFteIvYlSGEiBQce3ZqBc6YcTzciLcDMzdqVBiZZzpRtGn?=
 =?us-ascii?Q?dhuuO0Itgc06t/Z0vp3ctRO7JhU4g0xKdC+EyuhkhVUdJgIKuHKNPwWGcVGF?=
 =?us-ascii?Q?TYwa4vsRW3GBpLbtBtcM+fkTa/jEQw33oxfxzWn6+5ABvAoX1dpsHLUoDj5g?=
 =?us-ascii?Q?YBkY3cpK+s9fcz61QOnxU4cg1x4WszzAX+H0UvTgCKV6rkalNnjyZq6gozbn?=
 =?us-ascii?Q?qqPxdiqCSeKgYnxplUDR4pd7BYGzsLRH/5oh609RM4+5c+Pl4fw7YlCXqfCX?=
 =?us-ascii?Q?SRTE72QyVs1iWFn3c041FebznVjGAADeAgDPmlUP2B+sbpPbOHj/3+jUkGzH?=
 =?us-ascii?Q?DHTAKV/KHCxWy//RtzrsZoR5JBVmupgjoqJHPMWsGk3wDDqL6Ehq2kI1zElF?=
 =?us-ascii?Q?muH8Kt5UDj/kXH1JafKzg5v+XBk4XwWgWcBEEYex+nq+h+Zu7ek48owdrJnm?=
 =?us-ascii?Q?TO6qAPa0qyn0Yy83/x5/rIIofLg/5OVTFCt8JXO0mO673fZ/JWmj7Qo2d0nA?=
 =?us-ascii?Q?V/G8n1A/eDcqSEMOH4LOINAiwNkYPvyE3YI2POIH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2366a9f-1722-48f5-7e92-08dcb5158fce
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 06:12:19.4819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cdM+7vnqKRfnDQ691C9Q4HIVJfSz0ylodlE9LnF+JjiiOBKtTYe01Hcmp5pqUrJlNf17++AJw2e3AkekCe7plg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5945
X-OriginatorOrg: intel.com

>Checking kvm_cpu_cap_has() is wrong.  What the _host_ supports is irrelevant,
>what matters is what the guest CPU supports, i.e. this should check guest CPUID.
>Ah, but for safety, KVM also needs to check kvm_cpu_cap_has() to prevent faulting
>on a bad load into hardware.  Which means adding a "governed" feature until my
>CPUID rework lands.
>
>And I'm pretty sure this fix is incomplete, as nVMX's consistency checks on MSRs
>that are loaded via dedicated VMCS fields likely need the same treatment, e.g.
>presumably these checks should follow the MSR handling.
>
>	if (CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
>	    CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
>		return -EINVAL;
>
>
>	    (CC(is_noncanonical_address(vmcs12->guest_bndcfgs & PAGE_MASK, vcpu)) ||
>
>So I think we probably need a dedicated helper for MSRs.

+1

>
>Hmm, and I suspect these are wrong too, but in a different way.  Toggling host

Actually they are wrong in the _same_ way because ...

>LA57 on VM-Exit is legal[*], so logically, KVM should use CR4.LA57 from
>vmcs12->host_cr4, not the vCPU's current CR4 value.  Which makes me _really_
>curious if Intel CPUs actually get that right.

... according to Section 3.1 in 5-level paging whitepaper[1], on VM entry, the
canonicality checking about the host/guest state (except guest RIP) is also
based on whether the CPU supports 5-level paging, i.e., host or guest CR4.LA57
isn't checked.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/671442?fileName=5-level-paging-white-paper.pdf

>
>	if (CC(is_noncanonical_address(vmcs12->host_fs_base, vcpu)) ||
>	    CC(is_noncanonical_address(vmcs12->host_gs_base, vcpu)) ||
>	    CC(is_noncanonical_address(vmcs12->host_gdtr_base, vcpu)) ||
>	    CC(is_noncanonical_address(vmcs12->host_idtr_base, vcpu)) ||
>	    CC(is_noncanonical_address(vmcs12->host_tr_base, vcpu)) ||
>	    CC(is_noncanonical_address(vmcs12->host_rip, vcpu)))

not sure how host_rip should be handled because it isn't documented in that
spec.

>		return -EINVAL;
>
>[*] https://lore.kernel.org/all/20210622211124.3698119-1-seanjc@google.com

