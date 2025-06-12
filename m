Return-Path: <kvm+bounces-49231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 952AEAD68D8
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 09:22:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29BF01BC2D37
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 07:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EDF520C49E;
	Thu, 12 Jun 2025 07:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j6S5ctO/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EC31442E8;
	Thu, 12 Jun 2025 07:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749712914; cv=fail; b=kgehoQlvr4lzOsXOLG6NNlnayO5WEYh4QekqMBj9DN68nPY9+A9c8Y4AU8+rVkeZpOWSpr0fIa4rvgyMhJwDT8crOXCKBYmhh6uTnCWZSi3zQafQ7Vz3dei5O2XgPGf6BUNl30d2dTXDPQiBsdwTUMhLyy0GPKhnty1NP1Rkfno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749712914; c=relaxed/simple;
	bh=6l5rWXNQZGqlp0zi8Q1HY5kot5GwGYf7JMR6okbP3bI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H8POxFSDOZ71An1OZMwP1LJaWALRzbWYYQawand6H+JzzlH6NDpBBibqpuAX9OCNQNy1+T4hQ25IyUqli4BZhRUO4/LX2pllh6v7UAp+dgQWDCAQ8h364Bh1hYrlZdkAB/dduje4PTZDlTsXilSIishWx5pZshqiM/nAR/J0Now=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j6S5ctO/; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749712913; x=1781248913;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=6l5rWXNQZGqlp0zi8Q1HY5kot5GwGYf7JMR6okbP3bI=;
  b=j6S5ctO/BZWRpDSvujdnylen/I3juCQ3uRTxCeQFsM8x2ARsey7fLKa5
   ExjlXWmaBIiVr3vLeIllEApxL56oSfI38oHmgArqIDJdTHrrxXUsD+Q0u
   GCk+FsWUtHhqkAteev2MWx3fAN9u8xiN3aZjfR2LvdP252OUHojPaJI3G
   +YzxIep6j34I/NQhKsr6nuYJ/a0G7Pri2D7hGdsmBQEeCcq39deDs0jb8
   p/bTGwDDEB05j0hJsiNF5RBDFx7S5DrAgEezI+3wKg02tHtS6qiErrZpM
   923/eaoRl5hgZ7qCMJog+Uo6NRs2noIkh0irEm/Ud5Ii84zhzAtwvnkFp
   w==;
X-CSE-ConnectionGUID: ktFuzoPRTiGrKfEz8DT4sA==
X-CSE-MsgGUID: Z3L2xh1YSYONzpO9OsbdyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="39492718"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="39492718"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 00:21:51 -0700
X-CSE-ConnectionGUID: POgO8mYKSXa910h0kifyvw==
X-CSE-MsgGUID: pyclIYDAS1WhIOx/ojtZsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="184664606"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 00:21:51 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 00:21:50 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 00:21:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.78)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 00:21:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hhfV8fsE9ZnjMfzR1oMOG1mGP2sqjVBEl2Z2bVh0Q+lonhG2mDaZ3WOP8RtYcsFhgfBm0OfvWcNHN1xPW60WNAxos0HoVDhuEQOUtdEz8HZbtLSoS9ciQZyGvIxR4NUOsVMdeoZLf5Cryoi/3CqupmO9jdKeOJYGdml7883B3cva2ldxwBZbXBh0yi0BVoMMmvoF2hqARpkE0BHxKvKzVPTV7UZrorADiC+InOGKjsvNN60OMKGCNH2arQ5fDDlUb1iTjJ4Qng/ursn/gi25M5U0iQL1ENPBB+2exG7NCr6SuH22RBEG5NY14LrkOF+3uT20YcmhBTBRcs5h4M6BBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=df1gJVwiYqwLSUrGjzSiCkex5MeC8h5rIltEz+Z+7pw=;
 b=bEBs+kmjDlOO4HSDHzF8LLAzXe1/rVYS5gDjMav6dMJAXXRYxx+pPkrckqq3w04EcqGcs3lUTe7hrbedRzN0VkdexpFWosYdE5Cfqau0afyEQV11EfvREb84y84WEvBQntVRtxkT/hpp72PLpGHVF48Uh72A8JQ2U13pFH3UFQrcp2JPp+Kpf+pAC5UwhaeMJIOdTXtqqUCCEykPnj6hRAEqozu7Z35BCy2lXhOnfkC1gntXDWpsV/LbDpglDaAh7D7rA6xoOVGlByW+uFsdsLRdTNLwf1VhPDePpn0SlnxChk+oqvhAh4nUGSzfBH/U0txFfVG3JSyM/9zH89yTQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV8PR11MB8533.namprd11.prod.outlook.com (2603:10b6:408:1e5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.29; Thu, 12 Jun
 2025 07:21:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 07:21:35 +0000
Date: Thu, 12 Jun 2025 15:19:12 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Message-ID: <aEp/cHQqI0l09vbd@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
 <aEnGjQE3AmPB3wxk@google.com>
 <5fee2f3b-03de-442b-acaf-4591638c8bb5@redhat.com>
 <aEnbDya7OOXdO85q@google.com>
 <7de83a03f0071c79a63d5e143f1ab032fff1d867.camel@intel.com>
 <aEnqbfih0gE4CDM-@google.com>
 <2ea853668cb6b3124d3a01bb610c6072cb4d57e6.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2ea853668cb6b3124d3a01bb610c6072cb4d57e6.camel@intel.com>
X-ClientProxiedBy: KL1PR01CA0054.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV8PR11MB8533:EE_
X-MS-Office365-Filtering-Correlation-Id: 2da0ea99-04b4-4614-9324-08dda981c37a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?MLdSLHefQhbY/zvsMCKNyaQB7pigmi4tK50EJLJIr8LQersziHvTYAPl7m?=
 =?iso-8859-1?Q?rCMcbCd+8R0YQDUWt159qGeQ01wcate0GGNcDz99sUW9EzbSPo+Ij5WR56?=
 =?iso-8859-1?Q?ZD2AXr5jIWVjo/EVHOYCTueMaS98tKbTHdvtVxorNcrw76NA7VlihsewE7?=
 =?iso-8859-1?Q?uJzG3zXuK/AY7v7S9lQBg7BYFaW3khmRdju3gq3yXdL5pGwZllcETR/WZ6?=
 =?iso-8859-1?Q?4MSwSre8pwVocx2lKNZ7WgJtWgqXaYQweksmaotku2WdwucDc3rYB9xiZb?=
 =?iso-8859-1?Q?VBtdrw9UWDpHUqC9rGESMsgHt9LkXyzCzhNmOvtkOc+K+kFGaw43+AhEko?=
 =?iso-8859-1?Q?Apa2aNCWgZysffvt+pNSx///Wlu9IiLYLZQ9zF9P5EMp+EPzinUNOPULnm?=
 =?iso-8859-1?Q?V5Ys6pB7QheacK7QJTU5e8mqtohOZklhi573Ps9p3SwOqL45ahTSfK1NVN?=
 =?iso-8859-1?Q?H7eQDkbC/HzTdtn65VVM1DGdyTcAFD7X1GUp8sbhy8kESfUKgUIiJBqULk?=
 =?iso-8859-1?Q?E4S4YA+qDoIp87aEEXppN1lw48Hcy3rpgSeL8+PnbMeu2BgypYKZZhkvXc?=
 =?iso-8859-1?Q?mPU1iMUDadlK4/EOQAqdAs/OA1yJndpIYwbHu9lfF4BncDSvSKn9zxW3Ce?=
 =?iso-8859-1?Q?OpauCJTR3ckoy5/v4wwh+3mYU6mpou1cM2j/cSUfn10zuxxEOchTmdSIqT?=
 =?iso-8859-1?Q?upX8O5R7PVfuxzsEV/xOhtowqaBw41rw7W3nZRwmx7VojwC1e25zg2mzGP?=
 =?iso-8859-1?Q?Mg7AXXj8XSLXe+38Hmh6+Zm/MXmDqpNoZp4ip2By5bKpuCRZSVHxqji43B?=
 =?iso-8859-1?Q?2VOt5mmnDSYFeXhCR24Xll/txn14ZYvTd97VGJVK9tAVv8Il5ZPAbhWqQk?=
 =?iso-8859-1?Q?viKDiRzsJP391V+AkRh7ANVcOgtlq/mLwPpmiY2DpSVdGbR/GCbFBDAsCC?=
 =?iso-8859-1?Q?RwG5I/27aUWW1MmCHHTugVzEjGy9pim5/pJ8b/ZqSMquOov6g4wUmzHson?=
 =?iso-8859-1?Q?jk2DKU0C7Mg8ZWFetBw5DbNmuYfCIYiks+elVSsQ6uVaJczrYIlC1eZOwY?=
 =?iso-8859-1?Q?ptRLfd958/DgIYl6sRSDQtJg1iIYTooVwEc+Crt+EbGMIzCLw7yJVesdnB?=
 =?iso-8859-1?Q?pXGg3+qOPUUMvGTdKLLKfdv4prRD/SjSB7rLqT5slp9h2S0CvFSzw2vD3G?=
 =?iso-8859-1?Q?JlIUsRgCm7aBbeshOFbiMwWXyf7pIl0rW4yr21j9gMcXw9byAOzpERYA/G?=
 =?iso-8859-1?Q?pXNXBdkRZZy/U9Tpe2XOT6gwF3h4f+Is98+cl9AVB2moCPJzXe9hmE2YHA?=
 =?iso-8859-1?Q?4a2WN3ipsLbqbzM0EfppfKhDw6aZGmru8R8nVjF6Ott3yiWHaFp0TVErsA?=
 =?iso-8859-1?Q?RdzbkIUd9duYRQxBfM0SkPblIWWX3TybGBUJCye8CF0bBY4NE7/V14fldu?=
 =?iso-8859-1?Q?r1WNJCzWrLOCx2BXUnsNHhGfNak/Z22LGFsqo8iwcrZe26TLORfawDMFmR?=
 =?iso-8859-1?Q?E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?HwZNwejzyV/9UNq98fCW+XWHbKT1rwuQG9mQZrt8R+A1cZfTtVPWwyINkz?=
 =?iso-8859-1?Q?TYGB2A//1OBgPpr1A8QRaHLAw7OuivaRp30s3blZDfsm2DrI6ItoOhvgvg?=
 =?iso-8859-1?Q?euCkYcQZ8V681DKbLvo1Vob7+xjc7/Oi17Pfy7DDmKBsUeFW+pkOctSQuG?=
 =?iso-8859-1?Q?YGNDhZjJ9xqYXXtA1Wc7gy9/GATs7K8HvMik2ZHLf22ywKwI5FLzoSWCWj?=
 =?iso-8859-1?Q?54aPpc+u5Rnk2/7p9hsUooeivx3zsPt6BIzs+plQ6Sv5f1ZH5vpv+YK/X7?=
 =?iso-8859-1?Q?ZOpXhCngSN/q3h6OX/X7Es3c0jaO0XPN2wXGm7QkGdLyvpG2fNSRrgOUtz?=
 =?iso-8859-1?Q?B/M8xUqoBiJNr7bduj5pC7ACrK+YfiUhA3TJ44RoMCT9VOtM0P2iYoZYpA?=
 =?iso-8859-1?Q?beJIDA3PER4/35ITo1VT+zsAj0M4Gde+OQg1Pytea+LzSp4nuXjpz8pnZr?=
 =?iso-8859-1?Q?0o13b4mbYNK5jnv9NUk3YbQOqbqzsaX8I+LWFw30DRmJeRj6eZ/Zr1sJi7?=
 =?iso-8859-1?Q?jn7UphMjM8S8f7dbWSu6BZNgvncTyNFiXVhNwwSXrunNI9BFjgOuwU29H6?=
 =?iso-8859-1?Q?qeuzjfChrHxlJGI+1ZuPf7oOqa02WFwBgdC7o9TwT6BiH7mDzF0tJCr/Df?=
 =?iso-8859-1?Q?PoUu90de1EO+FplFhfVyOyhMPdoTbEZTvN0tv4B7Tz639MwF3YX4Sxi3k+?=
 =?iso-8859-1?Q?UCY5PuPTPnPBj4/86WPCgjGICdKCIjypo6/Jz9J1ts+/NkG/sNmNujCDJE?=
 =?iso-8859-1?Q?uDmTC+e6b7j04tXWQi2QS7vfEVxkbGI13eHuY+BwOw4b2+NaBMV+Oy6gqU?=
 =?iso-8859-1?Q?Fov0Hq6gYP7kRCbkhkmp3ngxVmZQXJ2ZswKKOsESvHhOsAJ4dQA14jfW3u?=
 =?iso-8859-1?Q?3WMeCTFysOwTbgNauqLBEIAr4c0jQY0IMgp4V85xjLzkyre6suSFjPrapb?=
 =?iso-8859-1?Q?q9+iHSXtvYqqO/FJ5gOBmUcsa4XeRRxsUyynYT9hqlDKmyYh30xeFKy1O6?=
 =?iso-8859-1?Q?ytTfGOBaTNWPXGWNMerB7A00iWNuHno36nAlFoAEApSp4dMVWYMvmMI7t7?=
 =?iso-8859-1?Q?hKHDFin/F7H39/sAT0YGZsJNeeKTimsb7fZxonu3DrtKQ1PD1qZR4uF522?=
 =?iso-8859-1?Q?Mq92d1LFeAQ71jIafTN51euEQal68EWDGIoTSDF0qaP68ExZcOwSqrAaIE?=
 =?iso-8859-1?Q?LoOo++9vDPXrzPVmVAIGfLoeszBzb63A5Xt3eiwMAhdQocr6075WWV+9Sd?=
 =?iso-8859-1?Q?dCpNbKUBMdMe9FwTJB1OFU6V1r0z454g31KCIDV0uHVJ7aoFD82YQqXfuf?=
 =?iso-8859-1?Q?lspMeQ0qNkDlBJfFPnYiCSPdDNPHiS1a5z/e5VjW+8+GsafX7rkDKaZQPR?=
 =?iso-8859-1?Q?/2Flml7mYTwjLJxv+fZVVJfy/vwhu+dEJtWXT5MzKzPhH+DLBMrMug5AEM?=
 =?iso-8859-1?Q?0lh3Yt78uyz6yWJQxcP2YcX0pgdd3IGEuQoGk5JZw6uIcXnyX7ZjCkk+xD?=
 =?iso-8859-1?Q?qSiRWiC5vCGAhXzroK0XcPCenndPiA3WAw133mFvTerrOQM/2uINzENBSm?=
 =?iso-8859-1?Q?eJoebJTKGezK+rvW6rjbLvOh7aNJDZHfU/RPwguEN4EVxfqiiPyYKF0Pmu?=
 =?iso-8859-1?Q?Hbv403SbcmYiozvLrFdp847CMCIWsuBax3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da0ea99-04b4-4614-9324-08dda981c37a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 07:21:35.3249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qp0UQreYZ+/mcCOzgZaOoChmBNS19BAUoeVOGTURcfnBenWd1x1LVKd2vQQdSjKjTKXyZxj2+DgvZ6q93JqF1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8533
X-OriginatorOrg: intel.com

On Thu, Jun 12, 2025 at 05:16:05AM +0800, Edgecombe, Rick P wrote:
> On Wed, 2025-06-11 at 13:43 -0700, Sean Christopherson wrote:
> > > Functionally, page_fault_can_be_fast() should prevented this with the
> > > check of
> > > kvm->arch.has_private_mem.
> > 
> > No?  I see this:
> > 
> > 	if (kvm->arch.has_private_mem &&
> > 	    fault->is_private != kvm_mem_is_private(kvm, fault->gfn))
> > 		return false;
> > 
> > I.e. a private fault can be fast, so long as the page is already in the
> > correct
> > shared vs. private state.  I can imagine that it's impossible for TDX to
> > generate
> > protection violations, but I think kvm_tdp_mmu_fast_pf_get_last_sptep() could
> > be
> > reached with a mirror root if kvm_ad_enabled=false.
> > 
> > 	if (!fault->present)
> > 		return !kvm_ad_enabled;
> > 
> > 	/*
> > 	 * Note, instruction fetches and writes are mutually exclusive,
> > ignore
> > 	 * the "exec" flag.
> > 	 */
> > 	return fault->write;
> 
> Oh, how embarrassing. Yes, I misread the code, but the way it's working is, oh
> man...
> 
> TDX isn't setting PFERR_WRITE_MASK or PFERR_PRESENT_MASK in the error_code
> passed into the fault handler. So page_fault_can_be_fast() should return false
> for that reason for private/mirror faults.
Hmm, TDX does set PFERR_WRITE_MASK in the error_code when fault->prefetch is
false (since exit_qual is set to EPT_VIOLATION_ACC_WRITE in
tdx_handle_ept_violation()).

PFERR_PRESENT_MASK is always unset.

page_fault_can_be_fast() does always return false for private mirror faults
though, due to the reason in
https://lore.kernel.org/kvm/aEp6pDQgbjsfrg2h@yzhao56-desk.sh.intel.com :)

