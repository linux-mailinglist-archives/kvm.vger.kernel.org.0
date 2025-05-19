Return-Path: <kvm+bounces-46949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E77C6ABB3C4
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 06:04:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6C8F18945F7
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 04:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B1E1E834F;
	Mon, 19 May 2025 04:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="myLRI/Jo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529521F5EA;
	Mon, 19 May 2025 04:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747627453; cv=fail; b=f+pdlvTrja5MeGGrMAlxePk2fPTXRbDnZvXRQsFJX3Op7bYLknslihiu3XIPMt5vpBDLGabTNiXFFJZlWadFRCAoYh3KNhOYyrGqWSoXKr/2oBxFiPGjSqgacxKrg/+5TnKorqM2XGRkUwVSaaKrwfkU8E5sK6/M61ltv4ecgck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747627453; c=relaxed/simple;
	bh=h8F4IJlF2iQL2/MLGP3JvWo6JjTyBvSAdHcEK8MIcAY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TuBJeMmTzuAVUDVf3CHDYmb8M82Tl7n6BvWIfyX27kjBu4FEj+Ir4uH8VuTyj9LSug0JP3v83vwpSR68SsKfbNHutLqjIsMpts9Azetj+cF0WTV8wMtuHvnu52Nw8s5C13WvMSN5vrWgZ3ja2Akq+/22A+bZEjZv4++F8mNVeH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=myLRI/Jo; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747627452; x=1779163452;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=h8F4IJlF2iQL2/MLGP3JvWo6JjTyBvSAdHcEK8MIcAY=;
  b=myLRI/Jo1ZowYqfDCiQPkRwq+cq7aUaEDQjFhrQRxlGkwGedMs4h+f5B
   wX9FTO88KVzlTUPcnosBs+xXvjWFwBMGATInKQuFkVvo3ZkR099AushDB
   BIjW1BYECBqW64j5TcXgW43yEh8jDZ6JK034IchugFmx4IlX/DSYNiaLb
   2n4UROhtM0OZZWorf6q+tJKzQyrzdik6Iq8wuFJsG0Prxk+VNl+btNvvt
   Z4YYWruvNWGZiOtr74bZSAJbz47kOWboN3alhK6XEy1Bo5dij1qXet0x7
   PZjUyEUO9+ROQ9JE0iv7HAsHK2b55kZkpJ4LBV5XfvLk6CUP0qj7wlmKX
   A==;
X-CSE-ConnectionGUID: 6OZCxpWfT3mh72Z/nt38Jw==
X-CSE-MsgGUID: b3LFjjOVQMS1NYnb5UIFKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="72016731"
X-IronPort-AV: E=Sophos;i="6.15,299,1739865600"; 
   d="scan'208";a="72016731"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 21:04:11 -0700
X-CSE-ConnectionGUID: o/I7NpsFTVuCqRxs+pDaJA==
X-CSE-MsgGUID: 0bPpn2Z1TxatHa+XRB9W8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,299,1739865600"; 
   d="scan'208";a="139655703"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 21:04:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 18 May 2025 21:04:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 18 May 2025 21:04:09 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 18 May 2025 21:04:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aK8U6T2Qh6rUQRxW+scFZY6Y1A5KN+nBlPbqBb5iEl/Q1IfG/53bOjNF5VyQRFH41iluu+58z6wvCyxQRlmIR6U/cm5bcdYj1KJXZqQU7Z4ppZVQI04euH3EAW6gaaryATN2XhuMBBtUChy917Ut8ucVe/hnn+rWC9jjrTdoR3vn5By9+SnouFXCK5oBTbEHMAGPHbl3PguVtY1RmR8RLJGlyjFyIFXJMjLqnu9zvd3S/YxaHp0lcWkao/D57FudrNw3w6gk6kvpn3NfjNo7O++7rlcQlFhS2SrFrNFZXa5iyzpM8pXeeqCB6HCQ/yz8QKNM1SXsQPP4OHYabldHfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kci8OR/3p1thUpX54yVmr90xRGYXYoGj7GUyxzb1ObE=;
 b=KfFMVbh7wueY7t2LHcAloMgv4PZgMQe9YLOvXPWm5sippdyaiAGNDkXzFJENSrlfaI18DbVXO5uM0X+fA9xkFWscTQx14Ohd9+sf6sJyukGhsYFHpCIM2PKghvKHlYr4XvHu14txysCyWtdO32Afz/GxWZcChcuZinKr+qj2c0sHOpYaYMsAE7rg0xXNOciuiy0XNR/48AKU5sUxtZamvYub3wxkuYKbbyzS8qk25PdKgmoMiQCN9BzzTLKaoCh7n/QeqFyUqGK+hLLYwmdK5inm5SqpkWGJLA/A3QRQG3fvP40oFbiYKE7//ocuIMknxKNtwlp0d9Afh01TzdRS4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7532.namprd11.prod.outlook.com (2603:10b6:8:147::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Mon, 19 May 2025 04:04:05 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 04:04:05 +0000
Date: Mon, 19 May 2025 12:01:54 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 14/21] KVM: x86/tdp_mmu: Invoke split_external_spt
 hook with exclusive mmu_lock
Message-ID: <aCqtMgT3DA/AvC2s@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030744.435-1-yan.y.zhao@intel.com>
 <b5af66343b3f5d4083ee875017c7449dea922006.camel@intel.com>
 <aCcCl6nSvYpSK1A2@yzhao56-desk.sh.intel.com>
 <11de62c95f7866fcecdba4c2d9462c77bab3bf83.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <11de62c95f7866fcecdba4c2d9462c77bab3bf83.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7532:EE_
X-MS-Office365-Filtering-Correlation-Id: 764b78df-1c0f-4d9e-d6f6-08dd968a3295
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?J2TVvOYQeB7Pq4ihnQBj6IUwJrXVh3e1H+rgHlGhoxhJNCBGRGJeLIkLeMlv?=
 =?us-ascii?Q?CF7Cm57+wZ0ggNlMFu/wWfgzCIC47y3ZY8D/tmhG4eNZsR3fBwkHl7PCpEvW?=
 =?us-ascii?Q?LDX2RAUBR3zLfUVRo9xLWrWfNNmoqSgdJbywStnfstF3JwlQi3QwAQCCQz5O?=
 =?us-ascii?Q?niIS4mUhd5tTDi3El1B9vzJgiBA6YStV3o7aKWnOHzxU8fUoW3cUIebuPSFg?=
 =?us-ascii?Q?nkA4IFdE49S6tPCTeNTsHGoJcM+FjvuiFf6p9vFu6PXgIJtKaXkjeXL0xyoy?=
 =?us-ascii?Q?HyMBb9co0CPelQqh9bOoyDkDqj/tiDe3KGx1580oDV3z4c0wFZRH/J81FWGM?=
 =?us-ascii?Q?bP4dxzM9XCPCmoja8GTN1/mW6zKq989x+RxEyQY1B4UTCMxAky4nw2+etbXO?=
 =?us-ascii?Q?S7qCRFz4ggkwoec6oyMwy6SB9KLuDhoPPvWMSAdNSnnCniH5pn4FamuWF1p5?=
 =?us-ascii?Q?0oidn0I0IyHQa/qfZ4XH26F5B3+ximYpOiN4ftrXPTxDlQ/swlXLrIBndQFs?=
 =?us-ascii?Q?oL/jsCxUZP1NkfS4JNW55QiL89FV3HFfqfzmG9Jm3t25bzFNKhhP3eLx1KuT?=
 =?us-ascii?Q?KdtejsRnzJUWIYvxMGug5IMrxIJt/l6p8isVuURSj+60bvRTxexG4g0ScmRR?=
 =?us-ascii?Q?48L2+uRv7hKD6isK1m0LIkO6dKSztLKVE93RPdcsNuoXUhGZ9nwkMEsR+xSJ?=
 =?us-ascii?Q?aCYSlWLoKbGF0Nt5KDoAa7NrNyXIUUyDquxZ2X93AcMGiOidql8jRR2+eU9R?=
 =?us-ascii?Q?yQ+0LQIgoLMrWH/RD9/vzjQImoyr7xfP9KTInOEabzNnAJxe7pdwK1g+KwCk?=
 =?us-ascii?Q?7SPZ4CY+xyczs5dB2tX+0xJ2tlKJdIE7lN6qk7G5LSzR7tKy4PDQe2kcjbrE?=
 =?us-ascii?Q?msScqATyeNF6FMjfiqEEqbc34VQV/cYFttiB1WQMRHH5W05CyhDzBzTz1F7V?=
 =?us-ascii?Q?TS0SNx2AdmqG39Wn4HqjMkorwSFyDxnSg77Spbdq77gFbDJBZMQZ5yp01wky?=
 =?us-ascii?Q?aCK5IAJAeJ0oUFGm8hrgnsHA0X8zxt6yUYK4GUr4TEwEYyaTW7XkDpLlNAyI?=
 =?us-ascii?Q?WkWjNgmOxvRgWMeCXpsNOiB+mXHO+YbxyJuInqAK+Gk8bs+9QzKju+7ZRBZy?=
 =?us-ascii?Q?ijkXGwJb6Hu3bkPW4VHMnfVbDUrkc0oYOUVmEncjRhCuEivu3UriMtKk6F4B?=
 =?us-ascii?Q?vWyKrk3VN5+oklvfferL6IbZek7NE/SGVPuCwwhnYFeWoFdU4NAW9e/oeweh?=
 =?us-ascii?Q?Q8nv0vQPdIXIstXHnZMRFuDdNloSfsnEVYbPkwHyMw78zyNJ/NntSciZ8OaY?=
 =?us-ascii?Q?s9ghPW/Ak9Hwujsn3OXHYHheNh2ELvLibxJzKfXqU6I8HSUotk/gis5SdEv6?=
 =?us-ascii?Q?jn78b+ojPvYvfUGHOPhktaOYXlL6dRdT+k1E2llg47K0uQvZDQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0eJv9bExz6hv/qOyNXqxcOlna1MMkL1aduObdvzaFvkocj/l3YkjavWd9lvB?=
 =?us-ascii?Q?QIqXLbQ6qS3wcNPEsHdLFUmxAJsRUjaNjIoxrRZjiox1WogwabPoIWT2jCbb?=
 =?us-ascii?Q?rUyp/cEEo8n908BjCk1yls0NFRrYnVNauLsaXSf+StZKJUJYe/hgmaxa62ix?=
 =?us-ascii?Q?6yk4GUkjNalzwN7gydkyTfqGTRpBuVxvsbuQP0OxrC1Qt2qjBGYmKNDshEY2?=
 =?us-ascii?Q?a8CZ37cb/TzzSCDEggiMOqqT3a+C+HZX0WYi58JMwn7yqnyuIr/uV6gqup6Y?=
 =?us-ascii?Q?+WhnbKa3JooAGZu0DGfPRlZ1zxe2NYeNbONfAblk13FHHh437McrrN2dHVXt?=
 =?us-ascii?Q?nOU6LzYwUZMavDxHcw5tGm/suMB16IZKH7nkQJBy2ruDmPLgjrEv7EcauZ+H?=
 =?us-ascii?Q?UoqgWfFuQbaZHxk6keSz/pl+qL1qERYk7wd2GJ0l4QkBaTxpElGBnJRvM0SZ?=
 =?us-ascii?Q?ys5BnZPr8cOUOPrHewN1ivPOf2BddEr7jphWoaye+yOs6e4xFtAeeJf9HmBb?=
 =?us-ascii?Q?dSoGeexqVkJ2RWNCb+qD9rVRucfsUYXGv4uJpqV+HOnT/COfPOPpdXQlsxZu?=
 =?us-ascii?Q?caeti/1eY2IhmXePCzCrACf/xj007wArihtnNDkhIN8M/oWN9BAelONXGNMi?=
 =?us-ascii?Q?E4bfycA2eEgT93uP5x1hmm2a/uNOuxHPvpuKyBnkYTWYeDoSLPhvuENpBxwE?=
 =?us-ascii?Q?AWLwoPCJwWA3lp96k6Zpygym5oPdjps+WwQRqN3aLT37IIwhIWi2i1TD6NJ8?=
 =?us-ascii?Q?x7dJarXgSU5+MtvjsKk/DqJbPpuiI9pE82kAlfX3v5BYOmYscwtwt3qFpin6?=
 =?us-ascii?Q?Td/dI/zLk1z8FI2YWJaL7T6RJBKJ2UTC2mchGq3SkKstmfPlSaNN1XJcDsb1?=
 =?us-ascii?Q?7o/5obMbv7vfIbZRxrHJLD6DSlRkWjAC1qNhHNSYm7sxG9U6L0O9rDden7KZ?=
 =?us-ascii?Q?hQGEZOPARb4+9sHp92UV2ZJ5ODv2cuAyD8I2Cf+838fJpK5L3LG0zA6FW9v/?=
 =?us-ascii?Q?CpWchQTJk4RjTL2tShx5SlXqmQDybUdSTO7UA8+Uc/rjRoMOMgFtf3soJhWo?=
 =?us-ascii?Q?7mJVrjb5j60DD8xyvw05jt5eUnnQCTWVJwbrSUF0mkFQz8DIcKAhDKoUNMiR?=
 =?us-ascii?Q?g1HvU4Y+tQBOXJVZVYtgX1ta0O3y7+RHKFwTWWBxQNYCkf2Q7o52VPWLHp/1?=
 =?us-ascii?Q?VTbMPn0coO38HreQQSqP2HcOE86WrBRwUvkQ+2GSZwuG2IMmH+O0EiSIbOZn?=
 =?us-ascii?Q?iM8++ZmokbMWTVaRAD/ZrvrTlRRE57+KfmPd175orr4vuWIoTym/53af5hhQ?=
 =?us-ascii?Q?BFOVqptkeL5k91d/Mif9Altp/HOu+O1L7TWKpGZWTC9OTHZOkgKFZo17r4jq?=
 =?us-ascii?Q?wuRcendR/KPzVR4Diz7ZUBeSrSaZRAjN9ReVJiYX5g7iH93Fuulw5evvHPxt?=
 =?us-ascii?Q?cBNA7pEvEg6qrn+AWWWtSr+ChIX8ylednhS7CwSvezypxLtJ8xOv6Dz1pZD1?=
 =?us-ascii?Q?PDxiK4uRlQQ90h5vNZG3aj/3LmdptnzQBobxQbz2kRUIE1RKdTLiLlqf3APb?=
 =?us-ascii?Q?3oNzDYbzkEWGBkIjQ11MPG8MndSUCSldOZwiDZTQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 764b78df-1c0f-4d9e-d6f6-08dd968a3295
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 04:04:05.6072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XaXVmQN3VcIPPBZZ220AOF1gTFgwxycahk2Gx15EDiNhuI+oGXwsK0d9RVEVdbF4ovOOghUMRcBQfOX52Lm2JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7532
X-OriginatorOrg: intel.com

On Sat, May 17, 2025 at 06:11:59AM +0800, Edgecombe, Rick P wrote:
> On Fri, 2025-05-16 at 17:17 +0800, Yan Zhao wrote:
> > > Shouldn't this BUG_ON be handled in the split_external_spt implementation? I
> > > don't think we need another one.
> > Ok. But kvm_x86_split_external_spt() is not for TDX only.
> > Is it good for KVM MMU core to rely on each implementation to trigger BUG_ON?
> 
> It effectively is for TDX only. At least for the foreseeable future. The naming
> basically means that people don't have to see "TDX" everywhere when they look in
> the MMU code.
Hmm, another reason to add the BUG_ON is to align it with remove_external_spte().
There's also a KVM_BUG_ON() following the remove_external_spte hook.

I interpret this as error handling in the KVM MMU core, which returns "void",
so issuing BUG_ON if ret != 0.

