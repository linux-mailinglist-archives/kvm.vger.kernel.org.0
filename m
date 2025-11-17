Return-Path: <kvm+bounces-63363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AED3DC63E19
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:43:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E7E344EE442
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 11:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6626032AADD;
	Mon, 17 Nov 2025 11:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WhEi3Had"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3D0328274;
	Mon, 17 Nov 2025 11:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763379508; cv=fail; b=EVo2QmYlI7bqbqzbpQmqQQv7y7Q6GhmnxtcsPKHeccB4mwLpzCXW3pAoWCYd3faYWSgQ7N1LqdSjzYqMz68g0/SP45UijhmPIGb/y1Duns/5DefGKqIZ7+8ay2XlBMOZB0lv3T+MZaISGtCrwec3/j0IVhrie0QKWimbnm6csOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763379508; c=relaxed/simple;
	bh=gHriLir+21RhOFNvFM0g2abjeOc3viUqI51AksrIb5Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JPNRefNxgsozR8qr1hEbvYhNHN1PADHrJANyEp8h3RHJ47RD34vvE89MASWj0WFrlOiQDiMmGBD4JXArx/iB0jPZtsHe4vtcGVmeDrGGEs/qKE9BaazQ/E1Et+TyY+5Io14I96yc0+civqkmLyFOD8Pg+ngVNYG+Yk8QeuatCJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WhEi3Had; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763379507; x=1794915507;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=gHriLir+21RhOFNvFM0g2abjeOc3viUqI51AksrIb5Q=;
  b=WhEi3HadNX9yY+YTPxOxZPVMWCMp0NC4NKnS6G+8sSCwcSf59bRoEloM
   eY/EFTl4c96Vb0b7WLZ5/FVJ2WAZRdtdjI2/54oZkfcN27yakEV4HQ70w
   zqkgqj7EjYo0thdHRXGMRAq04fsa+DX3xVcDBRvisA08TJuObksDYaPFc
   cHvAbTvDw/WkWO1xdYWfE7cuomXA4AHSk68l5QlEY+irG63FaQvsl9fjV
   6uUoFGQLz3PlMzX9kgLOxtYiNJiXHMARrEhx7cy1sOb63K3DMEUGyHB6e
   kC3xusQM0sELAbt9lsuFmlgSoMohBNJbaxrcKsKkKxonq49WjZxncXWrt
   Q==;
X-CSE-ConnectionGUID: 54C2TWlOQYedkM7M8j1mvA==
X-CSE-MsgGUID: A5qH+3WWRhmpG5X38O41wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="83001810"
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="83001810"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 03:38:26 -0800
X-CSE-ConnectionGUID: kfR4YDAJSzWXIsFBlkCDAw==
X-CSE-MsgGUID: 4Zz4HFBYTmmPUoRdQi7nqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="190226773"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 03:38:26 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 03:38:25 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 03:38:25 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.5) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 03:38:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qZ85SePKdpbtYmonoQ0HMdqxkV9cVTQQaiApRNQhwP2CDL+D0rdJ6STwsqv3jVqf/UKU8aDUh8weyf9/aCRMz2WckpbZTbpSU7jZtWBVYUGGX1RalLeaLDk3MQz1dRQK2+0R73CUxzaKM4/m28CLWTCMtLWkFlO52xxzWIZB5ie64WnOJsfTH4yhVRARUAW9xBtfqElmuo9mlaA29CPlcBQ5PMrp7P2b0THbNO/pHevuXfpBhd8bssM8IlhOUeeh913ndfV8ibw7xaNXv37Dk5+mQPlVVuUO8emVbBUwwdsorjprRpXd/9Q8lzS06D8XBJ+kVQeUQv8OYu0KUiAfAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bURfSFcMLTX96LDeJYNd1WJ/ZWpevn++l0Jx+MkRWuU=;
 b=uj8X7j9muXD5tza/XXGqHXFb1GvqpoZQ5kl3rPlm8w9tGvSRYSaX+gzaIqPlj1hAUN82893rAh+eYzhcXxzv2mgjOTK51uG+t4Ghfey9t/WU+nAknrKcJYzChg777ApP4lnGTHeP8eAiJH+CKkLnRZfwusZ3XFrO56fTswhO2WGKOzjLUpWFidVl3b3u2o0AHhBaOo1vB2mvzUU79HGME0Y8RjIHTzlhK9ZdGWBnVIa0kTptdBJlyLU3XJ0W3NYzzaG79vpbKm3j7pny5e425RRRIfHTme/pPMQOZV8eGLMKIwMEwA3UtBl7hb41hYUJPRWMatnQXxYLsy30hvFxPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH8PR11MB9484.namprd11.prod.outlook.com (2603:10b6:610:2c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 11:38:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9320.013; Mon, 17 Nov 2025
 11:38:23 +0000
Date: Mon, 17 Nov 2025 19:36:18 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH] KVM: guest_memfd: Elaborate on how release() vs.
 get_pfn() is safe against UAF
Message-ID: <aRsIstNXu0Bl0oID@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113232229.1698886-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251113232229.1698886-1-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:54::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH8PR11MB9484:EE_
X-MS-Office365-Filtering-Correlation-Id: c8989448-5e15-409f-d4f5-08de25cdd069
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+7HULAZAxfm82xE05KozE8zNHZh7sB79q2l8Ga7cAEaeb/ITOEZIeSZ7eSvc?=
 =?us-ascii?Q?dwjDwuIMdoAx5mTgVIu/68ovNYyROgod7coArMMTD7A1hc73JkFpJlMN6ZmS?=
 =?us-ascii?Q?HU1uGzGcRCLC/Dluis4HVHiJZg6/gUAbKsFahKPeHbjyz9H98ZJFWcXITh51?=
 =?us-ascii?Q?QkSRBm+/jf2JjNEQkNuYiZJlvTL3fAgCJiBfFFyByISq66mRRj92Wfwcjtr7?=
 =?us-ascii?Q?UQ7XXn5lYvIc7X1Uu2/jwy+RGrAv3LTtl+LXMOlZa5I9OIU0PgSNduh/b9y4?=
 =?us-ascii?Q?R4ueHfygTVD3tlhHgLY+psamJNV04WXGeP08zFUJiO9dQR8grYK31apM1Fjc?=
 =?us-ascii?Q?vN6BBaAQ9uItklNHJx3D/zk7Kql3vs1tcxbOkt31RfAMCJSxDmKYU1KVPLJE?=
 =?us-ascii?Q?OSiBa7oA8grbsITSJTB1wn8R0BFwMpH+xQmWyqCSe+F+wSWt2HwEmKN3pofH?=
 =?us-ascii?Q?PHr3zH/NSYQF56c0cjpmIzgrctEB6I8jpOtgF16ajT4qrt6nEPLeKHnAd1Pc?=
 =?us-ascii?Q?wCNuVH16DyYKe5zEXvPhvtTTju/ZRv5+Db94mGRXUDoT3M6v+G2zH/aA/nwP?=
 =?us-ascii?Q?fluzAED2tAPeIPFufWWTNEZDpOZw5NrooZxtJpTCpj18IG0XLGG3ssRbvadA?=
 =?us-ascii?Q?TxNGXdjuu7346dQBvvVcFekBYj2iR1EnW8bE81mAF1ir0/C7cLsuCuGkZb13?=
 =?us-ascii?Q?pvueBiTA7+Afjjv62Pp6HrNEQhTkFB0QFoerUh621EWMcoIGf0gsqncGwFq2?=
 =?us-ascii?Q?i86vxdAVxs5zrcVXh4mNlKsJuoda6uKQ/jmG+FtryH9VPOABFqIQei9inI6A?=
 =?us-ascii?Q?Y3kByipQj/m4Ni0h93OEl+4Gn4vyi4zaSUkhc7vlqmyKidTUX7zm5BhLHOgL?=
 =?us-ascii?Q?ADRUc5f406bLE9NEB2EaxhUfRv/0e3JbYYt0J1JAJO/NXkRu9md0Vf1hfjWm?=
 =?us-ascii?Q?4GgvqLgScdLRx1XwmtvYoSgjo8G9KpBv9mlI/WLjFr4FpJCSEtKvrPIMqL6k?=
 =?us-ascii?Q?6118pvmecH88Ebj/xMoZn2A5hNB4CHDxk7C4Y40VQcapcSRANZA7S/qMyk0L?=
 =?us-ascii?Q?WBGdb0zbyz0pHGvKVYhJphKfUhkqwT7ribeYHm5jejCpsXKhY8JjxAKFue6f?=
 =?us-ascii?Q?eYTDsQZxcoBWEAsoDhH/k9Krgxmwe8i1AdtCph6w/6PLpU/fwfoaqxR32E70?=
 =?us-ascii?Q?ATKe9MGbcvRBCXqplEWmCk6S67QWnzba3aJlCfyh0DbAsEQ/UDUgTbTOdtr9?=
 =?us-ascii?Q?gCpadHaYoYk76Sdu8+9xh2MaXZO16WWzFwOHe85iBOME+D+bIHpkfkyPaWLk?=
 =?us-ascii?Q?ePDsk72pOAnvnfggB06Fuoc8cTTrrBk9KuoNVMHNay6+WcQKTBKGEb2X1Yzj?=
 =?us-ascii?Q?LL0/2UNfCwarP0W22/uBacvbJEt8uzgGNdGyE2nTCKmm30+yjTOye/idNIWa?=
 =?us-ascii?Q?EkaRbY4BZxzRn3eV2SzPh52GHAP5OAUD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VUgGr/QB6C98ndgV/zvudh938HthEnGjfqwMMAXIcty3E4W+mWf1s37VMsYI?=
 =?us-ascii?Q?daJTUSRQQtkf87RLbzJzHtbTdlg0KbV/XG2KfricupKncXrRoFUKV7hptGrJ?=
 =?us-ascii?Q?zoyJHXkmQStj4wrTDRfjCP5HUZ+FSh7yDOvkffuQ8z3wywjOxwKSNk9mm8VH?=
 =?us-ascii?Q?l/IApteykj2J7JPnVUV6hxBb7xKBEMKirbjzOyNlLT/8Q8tatT5mHMD9YNdF?=
 =?us-ascii?Q?czV0gx/mceaD3TCeKESDEzHvttuUkZEWdm8SdXmiGsZkdAohQvzqQFp1jsiQ?=
 =?us-ascii?Q?kQT0txzLYyXPfxnpHd2BBO808JuxfenPcegatIjVdnUgBBbCSlqO3RKsDEmO?=
 =?us-ascii?Q?/KoSx80Q6bv8tkzu/RhU9/LdMj/RhjpwcWGH7TrDXKbW+XYzedapVj7xI5Kf?=
 =?us-ascii?Q?5JghXScBWXu3cHw3lAHyW3P5D9oh8HwojoKRtNLT/SNSJoA0qCmtwyMGngU/?=
 =?us-ascii?Q?B1kcCPczOi0joa3LoLESYpRElv8XY+dliAah6jVXj6CjSWhcte7+GDsX1ePo?=
 =?us-ascii?Q?ws81SlVz6jVTWUagSbNvBw6M4wWgQgBuk6xEVd7/GMxzeh52YKTuAFme90rV?=
 =?us-ascii?Q?xXrZZ1HcxAGw97hVm8EKvmj2ky7QSgBIq6utsHrWfbKkIysGDVmPP4vgB+FF?=
 =?us-ascii?Q?t/WQjfOoLbOfFSh5a1PYz6LrR2xAOV1uiUWgH1uwCEc0HRzmSs6yuW4wu+Dc?=
 =?us-ascii?Q?wqUcjLe8M8ZaUalckQcXz65pQyIyj/bcIlbvill2wGdaCfGt7wifveEdTFg/?=
 =?us-ascii?Q?k5TYF1g5z0/04PmQvshzdsAS2+2Ci5BOw2Mj32QB0rS1zMHRYxPY12qkrbQl?=
 =?us-ascii?Q?Ds9wBY2tBw7ss/SHXBJ1iqxRH6XRX5C9knR+tFkfcbSUR0JdqZG7anmoejwN?=
 =?us-ascii?Q?91XnIRUr3L1BHk3HH8vy44LL38hIXzKS0muwKmGSgaL7gf8KfHhlm9GwoohI?=
 =?us-ascii?Q?sOQrospNjVImGMODj3R11Yxl7ujRR7ryTaaySGNH6nybfrs2o4o/aTH5jC5C?=
 =?us-ascii?Q?Ou8r/ZF7uAT9Jkr3flBfkRfo0mcUsP7P9RrB5s2ubIUOQyuMQhXfA5nUAeoQ?=
 =?us-ascii?Q?j+WIWeGGhXVeCnTGZJVY9lBS2/O5EZXBozONFc7GbGVrxR/z8bWS7BqEi5/w?=
 =?us-ascii?Q?LnVpVbvUcVxNXvdaY/u+jan4gxL3W0Fr45dclB9qm7oaxu7YHY0O5DFGM9lG?=
 =?us-ascii?Q?XvKFZcxTgCM3Q1WBrNBXpcL1IOzhVpLgzeM7ODGS/2xTAvjI4qs+MGQ870hu?=
 =?us-ascii?Q?GH+Dqs4NuXrpB3KofcBR3kicLlmAUa9SGbSN6owbH3fKaU5JfYxJPMvnjZjc?=
 =?us-ascii?Q?Y1e+ZCra1gqUqUVegT6623sTvRRfDAaMNfXHLp9Zb8AvDiFxKi0fq2B6b4J9?=
 =?us-ascii?Q?t71IZ3/lHacADFdcFwQWEjgj6Pv5WeHxp1kAARmTWk/Rdkr8X2Y3/H9+TzdR?=
 =?us-ascii?Q?YHjThBLLHNxQcDyaSmR+Qb9y4r0wi+B6KUezuEbH6vZ54rNqhADgec+yDOVI?=
 =?us-ascii?Q?XilUGUFAD8E6h+Py/gZTC94nC5n+MKbCyn74LEUW5U+ba+p48iSzJNSKgL6v?=
 =?us-ascii?Q?PPp/iqPjSbt5aTVFPBydNJ8Zq6gEmDrzqFw6+uXk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8989448-5e15-409f-d4f5-08de25cdd069
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 11:38:23.0982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MGNNv1OmWqwYlnJ6jXlPdoPliJ85gSuBnknxBODxSTg0y6ToosopRCam+aDL3DkIvVlULFvXautZsc7olQuO/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR11MB9484
X-OriginatorOrg: intel.com

On Thu, Nov 13, 2025 at 03:22:29PM -0800, Sean Christopherson wrote:
> Add more context and information to the comment in kvm_gmem_release() that
> explains why there's no synchronization on RCU _or_ kvm->srcu.  Point (b)
> from commit 67b43038ce14 ("KVM: guest_memfd: Remove RCU-protected attribute
> from slot->gmem.file")
> 
>       b) kvm->srcu ensures that kvm_gmem_unbind() and freeing of a memslot
>          occur after the memslot is no longer visible to kvm_gmem_get_pfn().
> 
> is especially difficult to fully grok, particularly in light of commit
> ae431059e75d ("KVM: guest_memfd: Remove bindings on memslot deletion when
> gmem is dying"), which addressed a race between unbind() and release().
As mentioned in commit ae431059e75d ("KVM: guest_memfd: Remove bindings on
memslot deletion when gmem is dying"), unbind() and release() are mutually
exclusive, i.e., both protected by slots_lock, mentioning "race" here is
confusing. So, that commit addressed the mishandling in unbind() after
kvm_gmem_get_file() returning NULL?

> No functional change intended.
> 
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/guest_memfd.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fdaea3422c30..2e09d7ec0cfc 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -338,17 +338,25 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>  	 * dereferencing the slot for existing bindings needs to be protected
>  	 * against memslot updates, specifically so that unbind doesn't race
>  	 * and free the memslot (kvm_gmem_get_file() will return NULL).
> -	 *
> -	 * Since .release is called only when the reference count is zero,
> -	 * after which file_ref_get() and get_file_active() fail,
> -	 * kvm_gmem_get_pfn() cannot be using the file concurrently.
> -	 * file_ref_put() provides a full barrier, and get_file_active() the
> -	 * matching acquire barrier.
>  	 */

>  	mutex_lock(&kvm->slots_lock);
>  
>  	filemap_invalidate_lock(inode->i_mapping);
> 
> +	/*
> +	 * Note!  synchronize_srcu() is _not_ needed after nullifying memslot
> +	 * bindings as slot->gmem.file cannot be set back to a non-null value
> +	 * without the memslot first being deleted.  I.e. this relies on the
> +	 * synchronize_srcu_expedited() in kvm_swap_active_memslots() to ensure
> +	 * kvm_gmem_get_pfn() (which runs with kvm->srcu held for read) can't
> +	 * grab a reference to slot->gmem.file even if the struct file object
> +	 * is reallocated.
Do you mean that
as kvm_gmem_get_pfn() can't find a stale slot, it can't grab reference to stale
slot->gmem.file, even if slot->gmem.file has been set to a different value,
i.e., after invoking unbind(), bind() ?

But I'm not sure why to put the kvm_gmem_get_pfn() relying on
synchronize_srcu_expedited() in kvm_swap_active_memslots() in the comment of
release(). 
Without the guard of kvm_gmem_get_file(), kvm_gmem_get_pfn() may need to
provide some RCU read-critial section too for release() to wait by
synchronize_srcu()?

So
	 * Since .release is called only when the reference count is zero,
	 * after which file_ref_get() and get_file_active() fail,
is still helpful?

> +	 *
> +	 * file_ref_put() provides a full barrier, and __get_file_rcu() the
> +	 * matching acquire barrier, to ensure that kvm_gmem_get_file() (via
> +	 * __get_file_rcu()) sees refcount==0 or fails the "file reloaded"
> +	 * check (file != NULL due to nullifying the file pointer here).
> +	 */

>  	xa_for_each(&f->bindings, index, slot)
>  		WRITE_ONCE(slot->gmem.file, NULL);
>  
> 
> base-commit: 16ec4fb4ac95d878b879192d280db2baeec43272
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

