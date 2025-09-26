Return-Path: <kvm+bounces-58844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A17BA2473
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 05:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CACE7627897
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 03:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0960262FC7;
	Fri, 26 Sep 2025 03:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jbTz+vFW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73591A295;
	Fri, 26 Sep 2025 03:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758856198; cv=fail; b=b7YKUtJ7H3RS5Dvo/l90vUZdC3LQfEaOk9xkwagwpNg6WcYf+AvPxJacnzjzDmbnq7WVCT+ckI+IeyGOypxpktc6pBaAqq0e+PR5/KRbYirrqT61KV9bk25Yl97HjnCV8OiVMBjXKKxo4Kj4SWrV4rk5BOFuta2C2AgOUnOIU0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758856198; c=relaxed/simple;
	bh=aN1xm1SbCZnabgraAtI2ShOApZbQ8KS7qA3YmFf76sE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UxE5GBIFF1Xo5h2kdPQcApk2O/lNoX7M3XZvrdFKPzreOCznLdPh9LVIixxoTNZ8YdSbtbN+JFgJtpcrsLElikzlmGEJIBljpE10Ck0JfCfWTrvmuBCbCK1b2B6MWQmOT92mdSybhKat0S21/uYtHEMa35hmdUD33okNRpp1RIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jbTz+vFW; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758856196; x=1790392196;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=aN1xm1SbCZnabgraAtI2ShOApZbQ8KS7qA3YmFf76sE=;
  b=jbTz+vFWBGjqXJ3IhzpWjrtjYO7AiyM4s+zhPYj5ff5V3Mot6jTn75sE
   +wFi7qv82B8yAxQDFoQOSoo0FiFCZc86yL/jtTzVDy6f8cK/+y4OonYqi
   P6sjpyvB743Thft2g4H+HtFpkoLQtJzP4nXQftiwfNK/Ztjq8PszKczA5
   oD62/IkNyTmUqGI5HLbjiykkczNQnwMokd91cH9NwnuN+2Oy7zR+oxpcF
   8n4HlQFhmmDsQ8eoo2GTXL1zrJoMQQy522PMTf7fx75zMIJNnLiO+5IJa
   rJp6sEqAnJ+5ps4iwZgv9BKIXUXM6eKahRjA1Hca9CYCNteOQjO59b/qX
   g==;
X-CSE-ConnectionGUID: T0GlttZxT8+khUF7ZjPK3A==
X-CSE-MsgGUID: YsWGNy/0SZCBnTgs9PJ7bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61138911"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61138911"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:09:53 -0700
X-CSE-ConnectionGUID: txLhBJOMSvGKD+rMeRhv+w==
X-CSE-MsgGUID: WPlcDO9TTL+ViTOYpeNh0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="177546765"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:09:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 20:09:51 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 20:09:51 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.41) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 20:09:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HYdq7Hayo+Qn7FVqDyjrYa2y8fCA/prCPCDIoN/ghkRKIUTE3WYqtvC7+x3bUyc6cCF+3saOGVE3BST6hxuX56+N7i+OwQMBnDxGlo1VYk2rhrCeR/CBK1alDPxPYie/P/l6JvVz4QCqiDZZ9szEePi6ViI5rh6yxiBVglBrjJDHD/CY4etOFuI3r8skGF06cU2+ReotlaO7mOAH+0EexHi0kFCUK1SDnalE1eM6LAtEi6LB5c8HwkseXvvle6yZuah2syK9j4JIDwpal4JVCaQmQCFbZ3v1xIqsTbwipB80jgqy1XGY6BdAQiNgvhn+0CxLGokG2EzIK4GiebAeyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/LuwopMRR+LSK3RdagwTlouYMupNfoJEsaNcLUQW2Ic=;
 b=X+RC4mbz0dpGis56ZZ3C4txHIm5LJj9xxTD5DKozZWGxHDpPS3sOyY82zN/hZ3Wezewa/9AKsNPYBSH2nGOhx9fxty9tmxCpaFoWTk6p1vwt/zFfZ+2XWV2sAehGKvB0oAsW5QqQRWFqOmLBAUMMf87iLZybfLs9G/OtQq7etL80bxxuSENTMgnNyV6neKiJp8p2i9UEmRmvumHVp3fZU7c3z+3d+oHNgn/Wp8QqLSGbfJ/FhxsoHN21Viq7OVDjEanVtt2+2fVNzVUU5CQVItL72IHiXsX4y69CFmd1SMu0VpWW1XSbFJbtq+zAZVfMgYmm3KZL/aQNJmx4TGBHGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA4PR11MB8891.namprd11.prod.outlook.com (2603:10b6:208:56d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Fri, 26 Sep
 2025 03:09:43 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 03:09:43 +0000
Date: Fri, 26 Sep 2025 11:08:38 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: selftests: Test prefault memory during
 concurrent memslot removal
Message-ID: <aNYDtn1FJ65aDC0T@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250924174255.2141847-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250924174255.2141847-1-seanjc@google.com>
X-ClientProxiedBy: SG2PR04CA0202.apcprd04.prod.outlook.com
 (2603:1096:4:187::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA4PR11MB8891:EE_
X-MS-Office365-Filtering-Correlation-Id: c61a60c6-58b5-4905-92c9-08ddfcaa23de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qMSHOs/evU+KQq0qxlZr5W8AgSCZA33RNq2M50hWWCbrbwNkMhcw3aqqP+5F?=
 =?us-ascii?Q?7is2r98FTV3eH4UD6SbC48PyNpQtuvEaOKUFnGsc9c795uOqj7faWGXTqp1a?=
 =?us-ascii?Q?/8h6VM0Tkx+sC8M1zHND9vsQXNN4zZjoDLYes2Iimtx4gk2Zki91hpL63jNc?=
 =?us-ascii?Q?jmyvoxn91sYNtnF6bTnUbgshDNcxzM2n+YvQGzPFx3g9tW8lmRjMM7pIcRhh?=
 =?us-ascii?Q?KIEltLNFocAt/sGqtTFdUwpxs4Oh46SgPiK+BHxWh+MblBaQwUrvVagOv15w?=
 =?us-ascii?Q?oj9hCl4Dpg+WTJKFRwxOTs21nxgdIQz9oYIOjkDK68OayDmAVqpeJh5P3vSW?=
 =?us-ascii?Q?V40dkoKpwyUArj3Sisk78iFyu6zc3vNfyUhT4zx/7vfBf/AIdppR1ZOSHeie?=
 =?us-ascii?Q?mAZCr94Imq0U2udtc4VOtUCbQzV6sk4z8RWkwz16zLwMMoK3oQvhOfVRg4VT?=
 =?us-ascii?Q?jzH33TxsowvPcz4mHq3JMVXfvhnv0XEwjxcB6ROU4eTFPvPUDuJzQaRRyq1/?=
 =?us-ascii?Q?N1OhwRnnRBMTLV3SK+qg7Ngu3toRZBR5LelayoDsz+O/uh8AI9DFXThfInM8?=
 =?us-ascii?Q?R82MuaYhihH485ddKgfMzwjmQciyefUIcCjniLXSrrmdWHZfqsmlnrPqbHRZ?=
 =?us-ascii?Q?RoMbysliMDI9VvUziGSE6i9i8Bb7BMSECfT+HsgHlaa1qrg5hoD7CgJCTRVZ?=
 =?us-ascii?Q?Znyd/uUC+qhhBgf4OFBoDWgXNcv9fH4hrzf32jXU9o2YeWNR7EgtCUxHqVVI?=
 =?us-ascii?Q?ydvsOHSD/nYsuT2muM46235iV1C5aGdiP0fH9Sq1eTaC/WFenfMLoTfVtSPW?=
 =?us-ascii?Q?h122F/nqdW8fZxvH7rKkfGfEOG0J5NK9cp/ji2A9aE1O7Ndy0EpOSzGPaDJN?=
 =?us-ascii?Q?0bTCI53Eo9BIVMpjBRf2g8thqE+wTR0P6tzLPhNrv+5ZOPVqBsheoL02yzq6?=
 =?us-ascii?Q?WL5V0adrEW57aHpFiGM+9bVNxYkG7Pt2t94CXFuoC06rBAmSaozStsApVMWl?=
 =?us-ascii?Q?kmM66aSMvUbr/f6bfMVFgVeU3edHvWOXs7b4atjTHx92uVtJldAnenh6vJ1+?=
 =?us-ascii?Q?JNCr6tTln0z6PN13xo4et+C9rpgtnsP0eJo6VSTBKVndDXOxGKGvXOVnDiHx?=
 =?us-ascii?Q?fH81lI4RclLt/gkRvE3dJ7nOzuFgFRSIT6oXcb43VfLOIKPg20TceiUp1CO4?=
 =?us-ascii?Q?5aBMcOYR+McMykLli8ffj2uCrUIx42yOL8TTYe8SLOc5D7LebnJz8a+xAozT?=
 =?us-ascii?Q?aDStoBGM3MaXcLMRGhdVDj2kAv2coe6GKmxhjhWgsmKeT5zdZl78EowiH7uw?=
 =?us-ascii?Q?xqQyfcYqJ8JWBKZK5cF0P5yR9qW5RrtZdFK9pwK4b2Iuw0rCdYeQ231sRA3M?=
 =?us-ascii?Q?Ao5CFYo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QJ1n/uS6ERaPmv9zGfa/qn687zwy55xUDtyu+Tvk+oKHbf8ltEQ6dCQboQG6?=
 =?us-ascii?Q?/pSLD1otVcjCZMEfn5BxjokGzx25h55UDHLxPOvJpFWFJv0ZAJjkkPbSnflB?=
 =?us-ascii?Q?q2d0G7AKzx1OGBP6G+GO1gbcYVJ6eFPIrOdpVA0CSAIET5S5T5nM1D976Dks?=
 =?us-ascii?Q?IWeYBNxGq1/x3AO8yMaWdrY8Bl5/90H3a6EYpuCm3zsQSik092PZwe6iXbbX?=
 =?us-ascii?Q?plhdMZOmrAO8nvZZDHpxn334kHwouHUGm9KSphKqq4ShOMO0OZorp2DAzf2x?=
 =?us-ascii?Q?4RQT+rk/LmvcpuAjBRiWHYoQN0vaUsVhvegLlTJIKrfva1NH+9rb+jXmbGb1?=
 =?us-ascii?Q?v7B4O3sjZGdqd40GveeeYnLLrxdSTSAAfwrzfDh2RxrDLdkLuaXGuCes4Y2P?=
 =?us-ascii?Q?Bf3SmPYIEkrfKWWqx5e1xomw2XBNupmA0m2RyO6/ww7tzdk8yEDoDGk9MfkR?=
 =?us-ascii?Q?dRUqG5xF0jOe4Gr1t/N/SVEuAV0bSl0YxeZqtG+nT+xFq1VzlIjYWpGgJtBf?=
 =?us-ascii?Q?VggTrFsWbFj3DGaWvFHHvjlzxlrqOivVcbHpfzmixZbt83m4UVAowH5aRKmL?=
 =?us-ascii?Q?9zVGbQi8uAnGH+2+LWQkC/XYTSddJXmWQGJmpUlsdyRkYDvxDUjfQe5iVqK6?=
 =?us-ascii?Q?KauDHn6dKgpz/y23s8hyJhVKyYOH022exnjnD7/cPvHfs4cpgTz7jykrF/aU?=
 =?us-ascii?Q?7iDW7YlQOcfDU++jfzyXdu21eJcOs1nEO7xnp+xIbXNxMW343VcecUn4QfrX?=
 =?us-ascii?Q?85uq6ISJWROTCzZlJ/qmQyZwSN7bkpGJXGv40UHAcxO0UzSkdXO0lVXsmefh?=
 =?us-ascii?Q?tIN512QzDe/IBbzDKDvY4SxKe1UDg6zPWSTlpC6KkurkmLPRI4GQz1Ke6dMj?=
 =?us-ascii?Q?aCyk/pZPbaiz/DSXsvi7pzSdI0+yYJ9/YZnflOrOOdByQeInpv3oQdcFXYCd?=
 =?us-ascii?Q?wdv71VglbiTSGcx4oS99A28mK09EG9F5Ty9cXrTRZ4TTDzdAA1KA9fweY+jT?=
 =?us-ascii?Q?C4+OlYC88Oah8wVgff/f5XmWnKmlK0xzLllh7tA+8NjFyakWNiysltjm2nyt?=
 =?us-ascii?Q?M6GyH3d4NSO9fagrE30exOResLS4BwKY2KU9SiXCwxjSlfxFzlTZ4EXu5OWj?=
 =?us-ascii?Q?obLh/TLcaeO5A0KkAuXDuQRggV9dHaXt8CMS5aeVwNvgB9bFQqPpPVT1oQ1i?=
 =?us-ascii?Q?pqx3CB7mA9FMCOwLMhfzgRKAdcSL4VyAWEktLne8iyN+AQ+vu4bthxF9AWpD?=
 =?us-ascii?Q?d5I1PBkOirWonLXvPvtup62Yl9NwXVo0yKtJIm38dCWPhh3Bx3waTiujXV3w?=
 =?us-ascii?Q?ZR/2tSMViLhCfNFiGxJOSgiEby/Gd9M1hPriYC1MMX8FZoaqMQrA6CG+5CTP?=
 =?us-ascii?Q?o0ZdeMiBdWImSABK0R9xp7iHqdgwuepWRG9AnJGVryondtCej4CkdT9UFjh1?=
 =?us-ascii?Q?bLOw1v3tEAUR4gNO/7ufm6Zuh7+4y+9b9SGYPna98eTh8b2yfyO6ToiLvoLP?=
 =?us-ascii?Q?FIFgeLbGXPP0jaz/uSa408xMPO8hg47UXY7BRhcOl4ZV38CxsGs9Pc2x83Pu?=
 =?us-ascii?Q?xrOf01IcRxNKO7NpJP+k/Fih2/3dG6D+tibfTKyR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c61a60c6-58b5-4905-92c9-08ddfcaa23de
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 03:09:43.5269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/0MNxqCNPjtShmRYaaLEsUhf5m2uOXjlp0gcOrhBOhL1iFUPjBWnP2H1bpPqmNQLnD5TfZ7CjY6dTq7AXmfMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8891
X-OriginatorOrg: intel.com

Thank you, Sean!
It looks good to me.
Testing passed on my side.

On Wed, Sep 24, 2025 at 10:42:55AM -0700, Sean Christopherson wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Expand the prefault memory selftest to add a regression test for a KVM bug
> where TDX's retry logic (to avoid tripping the zero-step mitigation) would
> result in deadlock due to the memslot deletion waiting on prefaulting to
> release SRCU, and prefaulting waiting on the memslot to fully disappear
> (KVM uses a two-step process to delete memslots, and KVM x86 retries page
> faults if a to-be-deleted, a.k.a. INVALID, memslot is encountered).
> 
> To exercise concurrent memslot remove, spawn a second thread to initiate
> memslot removal at roughly the same time as prefaulting.  Test memslot
> removal for all testcases, i.e. don't limit concurrent removal to only the
> success case.  There are essentially three prefault scenarios (so far)
> that are of interest:
> 
>  1. Success
>  2. ENOENT due to no memslot
>  3. EAGAIN due to INVALID memslot
> 
> For all intents and purposes, #1 and #2 are mutually exclusive, or rather,
> easier to test via separate testcases since writing to non-existent memory
> is trivial.  But for #3, making it mutually exclusive with #1 _or_ #2 is
> actually more complex than testing memslot removal for all scenarios.  The
> only requirement to let memslot removal coexist with other scenarios is a
> way to guarantee a stable result, e.g. that the "no memslot" test observes
> ENOENT, not EAGAIN, for the final checks.
> 
> So, rather than make memslot removal mutually exclusive with the ENOENT
> scenario, simply restore the memslot and retry prefaulting.  For the "no
> memslot" case, KVM_PRE_FAULT_MEMORY should be idempotent, i.e. should
> always fail with ENOENT regardless of how many times userspace attempts
> prefaulting.
> 
> Pass in both the base GPA and the offset (instead of the "full" GPA) so
> that the worker can recreate the memslot.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> v3 of Yan's series to fix a deadlock when prefaulting memory for a TDX
> guest.  The KVM fixes have already been applied, all that remains is this
> selftest.
> 
> v3: Test memslot removal for both positive and negative testcases, and simply
>     ensure a stable result by restoring the memslot and retrying if necessary.
> 
> v2: https://lore.kernel.org/all/20250822070305.26427-1-yan.y.zhao@intel.com
> 
>  .../selftests/kvm/pre_fault_memory_test.c     | 131 +++++++++++++++---
>  1 file changed, 114 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> index 0350a8896a2f..f04768c1d2e4 100644
> --- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
> +++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> @@ -10,6 +10,7 @@
>  #include <test_util.h>
>  #include <kvm_util.h>
>  #include <processor.h>
> +#include <pthread.h>
>  
>  /* Arbitrarily chosen values */
>  #define TEST_SIZE		(SZ_2M + PAGE_SIZE)
> @@ -30,18 +31,66 @@ static void guest_code(uint64_t base_gpa)
>  	GUEST_DONE();
>  }
>  
> -static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
> -			     u64 left)
> +struct slot_worker_data {
> +	struct kvm_vm *vm;
> +	u64 gpa;
> +	uint32_t flags;
> +	bool worker_ready;
> +	bool prefault_ready;
> +	bool recreate_slot;
> +};
> +
> +static void *delete_slot_worker(void *__data)
> +{
> +	struct slot_worker_data *data = __data;
> +	struct kvm_vm *vm = data->vm;
> +
> +	WRITE_ONCE(data->worker_ready, true);
> +
> +	while (!READ_ONCE(data->prefault_ready))
> +		cpu_relax();
> +
> +	vm_mem_region_delete(vm, TEST_SLOT);
> +
> +	while (!READ_ONCE(data->recreate_slot))
> +		cpu_relax();
> +
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, data->gpa,
> +				    TEST_SLOT, TEST_NPAGES, data->flags);
> +
> +	return NULL;
> +}
> +
> +static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
> +			     u64 size, u64 expected_left, bool private)
>  {
>  	struct kvm_pre_fault_memory range = {
> -		.gpa = gpa,
> +		.gpa = base_gpa + offset,
>  		.size = size,
>  		.flags = 0,
>  	};
> -	u64 prev;
> +	struct slot_worker_data data = {
> +		.vm = vcpu->vm,
> +		.gpa = base_gpa,
> +		.flags = private ? KVM_MEM_GUEST_MEMFD : 0,
> +	};
> +	bool slot_recreated = false;
> +	pthread_t slot_worker;
>  	int ret, save_errno;
> +	u64 prev;
>  
> -	do {
> +	/*
> +	 * Concurrently delete (and recreate) the slot to test KVM's handling
> +	 * of a racing memslot deletion with prefaulting.
> +	 */
> +	pthread_create(&slot_worker, NULL, delete_slot_worker, &data);
> +
> +	while (!READ_ONCE(data.worker_ready))
> +		cpu_relax();
> +
> +	WRITE_ONCE(data.prefault_ready, true);
> +
> +	for (;;) {
>  		prev = range.size;
>  		ret = __vcpu_ioctl(vcpu, KVM_PRE_FAULT_MEMORY, &range);
>  		save_errno = errno;
> @@ -49,18 +98,65 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 gpa, u64 size,
>  			    "%sexpecting range.size to change on %s",
>  			    ret < 0 ? "not " : "",
>  			    ret < 0 ? "failure" : "success");
> -	} while (ret >= 0 ? range.size : save_errno == EINTR);
>  
> -	TEST_ASSERT(range.size == left,
> -		    "Completed with %lld bytes left, expected %" PRId64,
> -		    range.size, left);
> +		/*
> +		 * Immediately retry prefaulting if KVM was interrupted by an
> +		 * unrelated signal/event.
> +		 */
> +		if (ret < 0 && save_errno == EINTR)
> +			continue;
>  
> -	if (left == 0)
> -		__TEST_ASSERT_VM_VCPU_IOCTL(!ret, "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
> +		/*
> +		 * Tell the worker to recreate the slot in order to complete
> +		 * prefaulting (if prefault didn't already succeed before the
> +		 * slot was deleted) and/or to prepare for the next testcase.
> +		 * Wait for the worker to exit so that the next invocation of
> +		 * prefaulting is guaranteed to complete (assuming no KVM bugs).
> +		 */
> +		if (!slot_recreated) {
> +			WRITE_ONCE(data.recreate_slot, true);
> +			pthread_join(slot_worker, NULL);
> +			slot_recreated = true;
> +
> +			/*
> +			 * Retry prefaulting to get a stable result, i.e. to
> +			 * avoid seeing random EAGAIN failures.  Don't retry if
> +			 * prefaulting already succeeded, as KVM disallows
> +			 * prefaulting with size=0, i.e. blindly retrying would
> +			 * result in test failures due to EINVAL.  KVM should
> +			 * always return success if all bytes are prefaulted,
> +			 * i.e. there is no need to guard against EAGAIN being
> +			 * returned.
> +			 */
> +			if (range.size)
> +				continue;
> +		}
> +
> +		/*
> +		 * All done if there are no remaining bytes to prefault, or if
> +		 * prefaulting failed (EINTR was handled above, and EAGAIN due
> +		 * to prefaulting a memslot that's being actively deleted should
> +		 * be impossible since the memslot has already been recreated).
> +		 */
> +		if (!range.size || ret < 0)
> +			break;
> +	}
> +
> +	TEST_ASSERT(range.size == expected_left,
> +		    "Completed with %llu bytes left, expected %lu",
> +		    range.size, expected_left);
> +
> +	/*
> +	 * Assert success if prefaulting the entire range should succeed, i.e.
> +	 * complete with no bytes remaining.  Otherwise prefaulting should have
> +	 * failed due to ENOENT (due to RET_PF_EMULATE for emulated MMIO when
> +	 * no memslot exists).
> +	 */
> +	if (!expected_left)
> +		TEST_ASSERT_VM_VCPU_IOCTL(!ret, KVM_PRE_FAULT_MEMORY, ret, vcpu->vm);
>  	else
> -		/* No memory slot causes RET_PF_EMULATE. it results in -ENOENT. */
> -		__TEST_ASSERT_VM_VCPU_IOCTL(ret && save_errno == ENOENT,
> -					    "KVM_PRE_FAULT_MEMORY", ret, vcpu->vm);
> +		TEST_ASSERT_VM_VCPU_IOCTL(ret && save_errno == ENOENT,
> +					  KVM_PRE_FAULT_MEMORY, ret, vcpu->vm);
>  }
>  
>  static void __test_pre_fault_memory(unsigned long vm_type, bool private)
> @@ -97,9 +193,10 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
>  
>  	if (private)
>  		vm_mem_set_private(vm, guest_test_phys_mem, TEST_SIZE);
> -	pre_fault_memory(vcpu, guest_test_phys_mem, SZ_2M, 0);
> -	pre_fault_memory(vcpu, guest_test_phys_mem + SZ_2M, PAGE_SIZE * 2, PAGE_SIZE);
> -	pre_fault_memory(vcpu, guest_test_phys_mem + TEST_SIZE, PAGE_SIZE, PAGE_SIZE);
> +
> +	pre_fault_memory(vcpu, guest_test_phys_mem, 0, SZ_2M, 0, private);
> +	pre_fault_memory(vcpu, guest_test_phys_mem, SZ_2M, PAGE_SIZE * 2, PAGE_SIZE, private);
> +	pre_fault_memory(vcpu, guest_test_phys_mem, TEST_SIZE, PAGE_SIZE, PAGE_SIZE, private);
>  
>  	vcpu_args_set(vcpu, 1, guest_test_virt_mem);
>  	vcpu_run(vcpu);
> 
> base-commit: ecbcc2461839e848970468b44db32282e5059925
> -- 
> 2.51.0.536.g15c5d4f767-goog
> 

