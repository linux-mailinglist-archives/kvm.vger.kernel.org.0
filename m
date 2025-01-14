Return-Path: <kvm+bounces-35355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 05E32A101D6
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 09:14:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 600D57A2F6B
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 08:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC3802500DE;
	Tue, 14 Jan 2025 08:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cZnsJCYT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4307024635B;
	Tue, 14 Jan 2025 08:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736842486; cv=fail; b=pkpMb5qVF/5lCIf2t3UbHWT65QCmuUEboOI6MmReQstYtsR6Bqnwp/OMQfZjNoacZ19YK4TMx0nsBr6ezanxsrVoURheO4ywcmObeGdCoKyxqP6X8Th/hWoAnW9W3hXvxux9qdPOsSinNOouTkPIV6ywRuuiaangqzO6iODVrLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736842486; c=relaxed/simple;
	bh=JmgJK/JCh1AQnpFc3kWgOblvycW4Z9sNZWFHb+g/iiU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ILqM9IoNYnpRGIJUczKieRt1U7xOuoUOYdMgp3uoLtuwdN2W/smP4lj6qzvvoKS16/comgzG16keZVygmsLsikv9/qKnk6Nv5Vo0BGZRiOLYdxfhGMoxWIqCrbZIMyn5KCCGUKtZyj1AxIorSly0o04IH7SEmnbBzCMNcK+hSlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cZnsJCYT; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736842484; x=1768378484;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=JmgJK/JCh1AQnpFc3kWgOblvycW4Z9sNZWFHb+g/iiU=;
  b=cZnsJCYT4U/uMXdwY89I3kLuvUZFOeuG1MRQ5FyhIsKFtyhVjZ5lNbGW
   +bDs0voBGtjwiCDOXRGFQeuAXuZV4HbYwJKc/bPsF73UOH+Slm/mrdO9e
   WO8/8PK6CznCi/XonjcQC8HlfuQMYgernSub0qBlP3QeORKrP+IzjWEiP
   YyrqbfxLW0VhSuriu+wpici58sm+HFn4p7L4/uJ5oWuaRWkbwrZt067CG
   Qp2WlqZUscOdFf2EdpuPZJML+3MGilMoxaN7YiPJpvr2b7IxJam29IbD4
   ofBFQ27/0EAbyDXZZ1n7OJXPYNHuuz1xQxXhkHtxYbzoWWHMv60QMIKt0
   g==;
X-CSE-ConnectionGUID: PJGSrteXQEyN3WwU07ge0A==
X-CSE-MsgGUID: LiUhr3jQSJ2I15QbBpKBuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="48513488"
X-IronPort-AV: E=Sophos;i="6.12,313,1728975600"; 
   d="scan'208";a="48513488"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 00:14:36 -0800
X-CSE-ConnectionGUID: OZ8JLqITTw23NUuXyt/NUg==
X-CSE-MsgGUID: KmdbEFy2R/CmOYz/QOoL0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="135611354"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 00:14:10 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 00:14:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 00:14:09 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 00:14:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xM9xi92kAG32tjwzgd193q8YgZ32vy8yp/WusFekDBF9YL5k9C0WWsQ1cEEUShzi2OK8gBMSqpRQJVxnrERisLtMNbjtgHEr4gaA1zyptC8rBnifNDob1enC1sOvTYwyccC9BXJ1e7+jcUwBD4ukhs0D+ZYVDOhFwD+fjCxHXUylTkifVK+sQUDiNRq/D85q04l+rMQq7WrlyMV6VGXaWsQgVfJXZcDRg4iiqF73qwH9Pfd1Acy1TxpSF7m9qnIt99ePnJ7Jc5jgPZ/t1YIarV+DD1Dmz5lAXRR/OQkpixf1BpT74Ors8ZNfzSnCaKY0NHIZTQ93tIObVbopIhiWVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c85NciR8Esia1OPvJ9qEcTe7FccqzfZeZ6NOGzfnWoY=;
 b=Q55wGtI/Bm02T0j1ZxmEKh5xNJY5mdUjxSmfgUoJ4h3hRKzIueExQ27AIloUtIukvgM3MHUj9o4dD9LmV+xPFX+gWg9aBAsvblgjWpPNYaJr7+khX4WuXui92PQIb/uRtzsn0PpgqUHALsQiaQ5AO/7/gj1ptxosYxDSw1gfHR3u9ZYjtuS5CcJj2DvescPlEQ4OjGYqCh3rJ9N124CFzxM42wUm+1nXqAXhXn6k2a/A7M/D1gEA2md4HdEL2Ituf1+wKrYLwTj46TLsTBIaMtHYQdzF7kuiJNhWf4OPMoTBRCIN+kx45eS9x3c7t1AwkbpuxGa+5GTelfV5a8FlEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA0PR11MB4701.namprd11.prod.outlook.com (2603:10b6:806:9a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.18; Tue, 14 Jan 2025 08:14:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 08:14:05 +0000
Date: Tue, 14 Jan 2025 16:13:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Maxim Levitsky
	<mlevitsk@redhat.com>
Subject: Re: [PATCH 4/5] KVM: Check for empty mask of harvested dirty ring
 entries in caller
Message-ID: <Z4YcmXQEt99FXIid@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250111010409.1252942-1-seanjc@google.com>
 <20250111010409.1252942-5-seanjc@google.com>
 <Z4TrQedpUgNrW2OB@yzhao56-desk.sh.intel.com>
 <Z4VD3AaQskK7IkYU@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z4VD3AaQskK7IkYU@google.com>
X-ClientProxiedBy: SG2PR03CA0113.apcprd03.prod.outlook.com
 (2603:1096:4:91::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA0PR11MB4701:EE_
X-MS-Office365-Filtering-Correlation-Id: 9400230e-a1a3-4d53-a730-08dd347369cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?IK/7/EsZHoE1cn+/sXhqaT/4XWf+j993Xt8SUZcjr7PxrS9wQ2eMTfTv8qny?=
 =?us-ascii?Q?ZaW9zRVjM4uiU/EErfq0KDS3YA0UWxByYVKa2+VQ1KzQ8UDnk8p+aQuy163M?=
 =?us-ascii?Q?s7D3HBDsj2au7m3FLlKaRvj+GP30xZWSIhX1UsLpwwCacb/98jbyaTx677IT?=
 =?us-ascii?Q?RB3dbtZaGcLBxKyo7rDgtJW0BMavCwgN2/4zyBP7j2aPmkbvvfpM5P1H5yUa?=
 =?us-ascii?Q?KLc2gcknmgejrQy975n5VO2OJxtvZ30gHPefA5A2eiw8TAfqIUUmJe1NLWmV?=
 =?us-ascii?Q?rRAM/d0t2iCaJftNm6mnkYU4qlVxjHPw8xQes0RqKlwkes5cjNYLSSKzQwJz?=
 =?us-ascii?Q?SbJ6xhCGuGlpT+7BlJLpFAHUEySQEp4evZVHpZFl1UZ8Y4ob4ZWbBDezVehv?=
 =?us-ascii?Q?s/aslisWW11R29LQyvmnjH7kicAG5v1YZr8aE5tFm3d21eN1vgDznzgQ/zgb?=
 =?us-ascii?Q?e4ISWDezda6X/LW12SAGfR7kpSh2vAPXNNAYfgh495JZgXuD/V7tjDUgWXZR?=
 =?us-ascii?Q?h5ssup/8MmmIOXrCC6spqhqSbOVShdn3yubIgna4LljRodoPu+8WNjJERMc/?=
 =?us-ascii?Q?Lq0T+RL5XIqnFDkZKcVL1UnZKk+4o+jQiHf+SWZFkZkm4mWiL+DBaEebXqlk?=
 =?us-ascii?Q?cc1qK4qrghEMyzYxRMDm9vuOlbY1fFhMLDJMkvpnhph+8h+C3v/VNkwYbPTz?=
 =?us-ascii?Q?HBo9GHooPGSbjUvDtxrONXd6WcZl2u8afBxgcXU37Sy+4ToRm8HURcWelT1e?=
 =?us-ascii?Q?KDrPWw4HiRDLJqcMf/3ePJzJQ9Ru2Rl5uIzH+52wxWG4dNkQbKgxNjy5HkLs?=
 =?us-ascii?Q?neSvQCey0NlPpZCkng5g1hJykvZvUBuSjBKk4zcexYYZNhcyYdasT9ErLK2f?=
 =?us-ascii?Q?GGdmsTWK8YOSwl898tSEdJyiM+nDUmKaoHoHi4Sq7VfYn+hf0FT+rkgBKmnT?=
 =?us-ascii?Q?d1jBLA3ZNVbs6MflaiqSqpdH3eB6VeNB4ETeAQT6y8HwQdigxZnzTU1f8RUJ?=
 =?us-ascii?Q?oqXHcZD9eACn7DTm/lykCrCu558pR+qVQ2O9kYcgCXtvfC7dJgEHz/bkcePC?=
 =?us-ascii?Q?TRRq1pE2aFwCXJZxNdyhyetCnydgzB/hB97nJ5g744GSFArLyQSz/gv+f0Pt?=
 =?us-ascii?Q?G6dx6OdomcPa+z8ibV32X2aRW+BSb/L8n0QVdPowQILkToRuONSQdg+3V3qO?=
 =?us-ascii?Q?zmaHSelmOWelmFRuniMVA7bQro4RX3ec554Vo1Iknr6InATF6HKfamxyItjU?=
 =?us-ascii?Q?1g4+GVi8duIDpG20HbJdX6OMfOmLE6OAFXNxoqmaUWPYBPGvE04EauaeDeof?=
 =?us-ascii?Q?ZBIfm5zGp+frE1SEeJIL6+yLqlhyM6aUHc5dYfbb8G5bzhrMeAjB3MxQYQ3O?=
 =?us-ascii?Q?q5VIAICB1A95eGUv8fDtRtTDHGQn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ee5IPix2wRNsq1nt+MHNUH8mZ8N9ZQ254AquZmBStFQKFQypRYKNvh6Dexqv?=
 =?us-ascii?Q?npsEGWtVn9jqQgU4szLp7PANFh5w6ZPh33WycfoTxp4A89TJaXtcy8dyptsa?=
 =?us-ascii?Q?mXKVLix3PciStj++hlPEmkG7UgDVNJMi6N00jk+pSFUi2BaHzxVwApUZ12LC?=
 =?us-ascii?Q?U+YYUUElM2q/9gbDHBOFV061q66HzR0M1Mt1TLajy6ViGDrTrhB2moZiFonu?=
 =?us-ascii?Q?XORAT9L3yOQdMWjXuYWOd9jbfSdANxCNFzEdw6KUmlWlAzOCNXBjRoikSivn?=
 =?us-ascii?Q?HaTRqAHKSLWPbBTJWvpzygdmdzQRZ2BknrwLWwNJtj+PqQ6/oBZGFKvayrso?=
 =?us-ascii?Q?vwOqBhmHUT39Ml5FlZunPctDt7Y3Xw6Rljf9kAKiojVeBvVQbS/z4i0Q8PeX?=
 =?us-ascii?Q?Xby6i6hNB2HHwiXS+1DGgPNiRvgAEyLNXtAX7PS+grjTrWs+BrutC2mo17L4?=
 =?us-ascii?Q?Wm2rwH2nbFe8jyicdF9BCq8JK5orkbN9SZji31lzXH9uWsRoUVeaIhBGJ0bm?=
 =?us-ascii?Q?XF6EGhUFPhxstUPp28u1EK27nxvM03zxVm3vQHQIHBXY4mh3SbOroiwskcbi?=
 =?us-ascii?Q?LhwTY6zKsj9JqTYfTgFdwed4dJtr5C8oWyEOPcnUb65GbZqymfwy5iyIjYmG?=
 =?us-ascii?Q?C76HXNtuguYdL7jolfp0HNIfvu8oZCVkKYwdXH7DIsrZ976s949LPBA8Rt9r?=
 =?us-ascii?Q?NUOu3vRhXJ6cqIENrzX5b+/I7wmCJgSd+BiZEY3ytD9ngwbqDFRJRL9/d7LS?=
 =?us-ascii?Q?jFfFY+aCjSwAL2x4IrHNjEsf6Y2wRW+UhrEQFS0SG4GWNyTx9qpftzwfx1Jd?=
 =?us-ascii?Q?ld6B8ZGY0+u6GSYcUV8pp3yzQFlwct+TFfb+H3hDnsxeu6oi3TsP1d/N85VU?=
 =?us-ascii?Q?EeR/i+j/Fe6gxOo7+7cLjWuTCT1JR9yyMRYHURgQbKw6uoghn1v6126AsppL?=
 =?us-ascii?Q?Yl6Kk22A7CeJR9Eqeu7ZrbXHhIrcd+Qw9IfERrAREXUnMxTLjHZ2wRRHnj02?=
 =?us-ascii?Q?vNfl+0ZA1BL6lw4LAgFjXm3lAoMiNtg1EnSNsCGyt+WtMxDMS0tIGYhidMtI?=
 =?us-ascii?Q?0041wJNawouCNM74+Z58/eN7B07z/iyexB1DW8e0o/8bNSJWVCFnka+vwlTi?=
 =?us-ascii?Q?jfdwpqVQStlNjSVfti7fGOXyl07hQug4gkaAXyBDGJYi4eWDQ5kBG7mXvWIT?=
 =?us-ascii?Q?01JDNHrwe9RlqqPFMjShmgpongGxcFYk1jR4kK7dsbsWynQ5Z/V4XgdIRIWx?=
 =?us-ascii?Q?CklOn0dOREICnLd5X1Lc1UAAUpGIBS0119usFH41soV18P0zVnkoa5k5MhU/?=
 =?us-ascii?Q?2ytBfqobBTP+snPcQlbtBx+1dDltHeayEgqNdw9SzeGU/AGZhA28+G1IEqSR?=
 =?us-ascii?Q?VmGRDsM5SkmLSrRZfE8rALUG5/MEHtVZbTzETrq/kbzlasSTR0opDfWxWIAY?=
 =?us-ascii?Q?WMT+N92Erg32X7Y4MYg1MQ9xW/SLwqAh2dKRHhxt56UaYPabb1gdC9kCrgt1?=
 =?us-ascii?Q?j7Tg6hGK1CG2c/U3LTVoH1tjR9dtwB54ZIj8ELq9+i9DD7dU5xY/wTe2f2j6?=
 =?us-ascii?Q?6px8zC6IQ+tLpbE0WHBNP7T6daQbA6+SmwvfZHpv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9400230e-a1a3-4d53-a730-08dd347369cb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 08:14:05.8381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dqba1Vq1gyEtmIxAa9LoSK2qnGD/ihTmagc4X/jfW4PyFpJiuR3cFm9LNQooj3VjCDGpXfTEwUBocMF4Kj4kBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4701
X-OriginatorOrg: intel.com

On Mon, Jan 13, 2025 at 08:48:28AM -0800, Sean Christopherson wrote:
> On Mon, Jan 13, 2025, Yan Zhao wrote:
> > On Fri, Jan 10, 2025 at 05:04:08PM -0800, Sean Christopherson wrote:
> > > @@ -163,14 +157,31 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> > >  				continue;
> > >  			}
> > >  		}
> > > -		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > > +
> > > +		/*
> > > +		 * Reset the slot for all the harvested entries that have been
> > > +		 * gathered, but not yet fully processed.
> > > +		 */
> > I really like the logs as it took me quite a while figuring out how this part of
> > the code works :)
> > 
> > Does "processed" mean the entries have been reset, and "gathered" means they've
> > been read from the ring?
> 
> Yeah.
> 
> > I'm not sure, but do you like this version? e.g.
> > "Combined reset of the harvested entries that can be identified by curr_slot
> > plus cur_offset+mask" ?
> 
> I have no objection to documenting the mechanics *and* the high level intent,
> but I definitely want to document the "what", not just the "how".
> 
> > > +		if (mask)
> > > +			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > > +
> > > +		/*
> > > +		 * The current slot was reset or this is the first harvested
> > > +		 * entry, (re)initialize the metadata.
> > > +		 */
> > What about
> > "Save the current slot and cur_offset (with mask initialized to 1) to check if
> > any future entries can be found for a combined reset." ?
> 
> Hmm, what if I add a comment at the top to document the overall behavior and the
> variables,
> 
> 	/*
> 	 * To minimize mmu_lock contention, batch resets for harvested entries
> 	 * whose gfns are in the same slot, and are within N frame numbers of
> 	 * each other, where N is the number of bits in an unsigned long.  For
> 	 * simplicity, process the current set of entries when the next entry
> 	 * can't be included in the batch.
> 	 *
> 	 * Track the current batch slot, the gfn offset into the slot for the
> 	 * batch, and the bitmask of gfns that need to be reset (relative to
> 	 * offset).  Note, the offset may be adjusted backwards, e.g. so that
> 	 * a sequence of gfns X, X-1, ... X-N can be batched.
> 	 */
Nice log.
> 	u32 cur_slot, next_slot;
> 	u64 cur_offset, next_offset;
> 	unsigned long mask = 0;
> 	struct kvm_dirty_gfn *entry;
> 
> and then keep this as:
> 
> 		/*
> 		 * The current slot was reset or this is the first harvested
> 		 * entry, (re)initialize the batching metadata.
> 		 */
> 
> > 
> > >  		cur_slot = next_slot;
> > >  		cur_offset = next_offset;
> > >  		mask = 1;
> > >  		first_round = false;
> > >  	}
> > >  
> > > -	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > > +	/*
> > > +	 * Perform a final reset if there are harvested entries that haven't
> > > +	 * been processed. The loop only performs a reset when an entry can't
> > > +	 * be coalesced, i.e. always leaves at least one entry pending.
> > The loop only performs a reset when an entry can be coalesced?
> 
> No, if an entry can be coalesced then the loop doesn't perform a reset.  Does
> this read better?
> 
> 	/*
> 	 * Perform a final reset if there are harvested entries that haven't
> 	 * been processed, which is guaranteed if at least one harvested was
> 	 * found.  The loop only performs a reset when the "next" entry can't
> 	 * be batched with "current" the entry(s), and that reset processes the
> 	 * _current_ entry(s), i.e. the last harvested entry, a.k.a. next, will
> 	 * will always be left pending.
> 	 */
LGTM!

> > > +	 */
> > > +	if (mask)
> > > +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > >  
> > >  	/*
> > >  	 * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
> > > -- 
> > > 2.47.1.613.gc27f4b7a9f-goog
> > > 

