Return-Path: <kvm+bounces-47250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D346ABEFA0
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 11:25:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D62428C1A97
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 09:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3EF23E33F;
	Wed, 21 May 2025 09:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bnYl/1MZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F17423C506;
	Wed, 21 May 2025 09:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747819471; cv=fail; b=CMKAveNihYiHFl0RbCi2pNWVjEgquJF5fWTgdS7v4FnRN0z1rTGe5Barucra9p5z9L3flyxnlC+IZkWieP8QiqO5DJJ4f7KTgrYeMIKmLWOxEZei79pyEIMjpP+ds52cwfb4zuXZUkEYrlK4L4Fa5sPfgmUgl/oh7fZM035uxgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747819471; c=relaxed/simple;
	bh=/LZkiSiZubgwtjFUiKb1pDVtAmL+7w4gJ/r0TLX+0a8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QrMQ98QG/+MRwWAwlGMEinBfqEopN0ZDFEU9AlsbJvmJwk0ojAqTqTdJKbxgxvKFJh78tAsyCE6oMhXA5UYsmbI4Ke47vg5e1rQ4n4RBMhzrsvXUJtI0TOGsMxsecQgKVVI9muLXXNQOwqf5wNOjZi12ytainT82WUrFi1dinxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bnYl/1MZ; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747819470; x=1779355470;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=/LZkiSiZubgwtjFUiKb1pDVtAmL+7w4gJ/r0TLX+0a8=;
  b=bnYl/1MZBABQxjd6UZZvYRLwStwvk5ItFapPCqp7G8TCM3lKFFGzH2Nk
   Q9aRhQEHCQN5TxyAtqs67i8A1Wmkm3soz+oOjXxi1ScaN6B+MovbXlsK4
   EPQ6h/mZ8ntwNjFyqsiKTal6TtUTTO/W5/uAcf0cvK9E5ceFDgcOc0Wai
   /sgxJf1XY8gaETzo9z74K0sfhhv2GGLOU3NHo004v3v7OV9oqjDRy9z1S
   zWJEud0Cv/GtDfXGXCb/mYCJ797RwpsX2VF+FKQRl/PirTkB5XRrZmm+G
   50K0nfZyKZA/nhbf1vRPGEfuAr4d6rQgMLYwZjAJYed6GDh9LyVTIgX/U
   A==;
X-CSE-ConnectionGUID: D9/U/ycwRMSisTO97cl8UA==
X-CSE-MsgGUID: 3DgkFRNNRnyW/361YVwyFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="67344306"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="67344306"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 02:24:26 -0700
X-CSE-ConnectionGUID: ajTsXKdXRC6Lq9VkcMiZNg==
X-CSE-MsgGUID: 75DdKrDTShSZhU/7XKQ3zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="139841244"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 02:24:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 02:24:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 02:24:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 02:24:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tf1WTbr5X7xwKCkH5aKR8EmyjsvLrv6XDv76cjc7cotC2Y10M8bLuV4W0jALagXZr0IPn/MFsPDqcvHyXj9QpNAAZWYbRstrWHvE8M2+tlafe93PLlmWlsGb8fz+A9iplBCVbPQeeJdq5sC516kyYClw/896AZQXcXXJnSYEl+r5iquG3g1AWzfCu6cPXFSy1on9Fy42RAaLbG/5iz5VYCXmv3qGCMhIvYCHbl3FrhP7HyrehUIYPvbb7NXmpEwyJzRhWRx2fMoG9H7+j8rry1IHDzh2ZoRCX5LdjJwvYmggKsCtEciHe6QjT2c8u3HJe5FPMk9xF6EItr5WH4lL3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/LZkiSiZubgwtjFUiKb1pDVtAmL+7w4gJ/r0TLX+0a8=;
 b=d8ohD5hSbtJTHMsvzx00YvftsaEPZHa7vdOZBEbm99ITgqxHndtlJI1GDFALoBph/eDLN9WpEgPtBulDvTPG7InGTRPvk0V46ibyLm9z/8dmp8ELkJ10j5JRYr19p/JMDI8Ckm5Gwu1isCs2odDoImOuUblTZb7D6ChzzaLJa8oSdABcJfsiEejjZnGzmuk46hO8/vrPYdHfEaqqtfF6sknUpSOYeWOZLVC3G+6rBIIp0Z2QTr3IouXIH6vb1QruIFTzcUGCQdLsSGESXQLuC6YLKJGh9kzTkWv/EUnzRDtb7OfLMkWupyjbc9sCQtWcKn4KH66QFq9ZOYXdq1rwJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7242.namprd11.prod.outlook.com (2603:10b6:930:95::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.26; Wed, 21 May 2025 09:23:55 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 09:23:55 +0000
Date: Wed, 21 May 2025 17:21:46 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Maxim Levitsky
	<mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, James Houghton
	<jthoughton@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
Subject: Re: [PATCH v3 0/6]  KVM: Dirty ring fixes and cleanups
Message-ID: <aC2bKi+sdBG4NrN0@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250516213540.2546077-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250516213540.2546077-1-seanjc@google.com>
X-ClientProxiedBy: KU2P306CA0033.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3d::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7242:EE_
X-MS-Office365-Filtering-Correlation-Id: d7e2efcd-f268-437c-d855-08dd98493532
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vy4zhdoDWMIx1y06bNBUeGGWVZcmnQ6gJvCmW27nFJ4a5IFWFxZQvhyLQPSi?=
 =?us-ascii?Q?bV/A5onQaeQRcg4xpYlqx0h+OMg5JnDdcsePd5Kzjivvcsn07x5CwBsY92dI?=
 =?us-ascii?Q?ZL6/IYYjoN/KzHtsKsV807T8L2EroEaeb8w7U12IKOFJyWzQGZe6jK6FCK0H?=
 =?us-ascii?Q?UGHf1yNTPsLc61DCBksqOzcUkga0hLqmVpV7lph/Cd6FxlbS+DJ0JDgmR5Cq?=
 =?us-ascii?Q?mkmnRVCbQlTAB4zJmOM7VFWalHnT/6G4/XU0fTviHubpYv+u1XP6KfBs1rwG?=
 =?us-ascii?Q?buNn1Au7SmwTzz9H5pbq5gro6+7L4hZKMkyTVegIEPHU0Ez5MPeU8rq1chBw?=
 =?us-ascii?Q?u19eBo96g1xpAz68W5ExHJpzwJ4Xw87vWO+bkJ5+yEq1xtH8GD41fB7J86+T?=
 =?us-ascii?Q?XmWcSM89j+/4MZ0ZwUuLQgnG16T7p+gwTmxQtGwfmgiw13+2vs3H5afKOdyv?=
 =?us-ascii?Q?qNA+UkWZP5N49UkIrZCt1e8BVGNk9E9ip1Ap9Teujl5RhVUBzWZLPNrGDQvL?=
 =?us-ascii?Q?utWyDq9Kh3XeFyVOzhZZoi7UwhHEhjmlKv1kuVzrJrfGnXz6zwHXwmMSAbjt?=
 =?us-ascii?Q?X4VwfwFZ8+bsZaniEJ3GBlmboj8V653hh0mD0QSDPUUSGpN2RDacbUPA4tE7?=
 =?us-ascii?Q?vVIXnY03pZjljO/mvPZ1Kx56Z7aCox0DdSNqr2/uT1One0AEe+8pouEgPgdb?=
 =?us-ascii?Q?hoHgL0rYvjMvSVzIQcnzTWvM4DJbAH6WG85kjY2HZGKn0d2BK6KUt4dPy9Vk?=
 =?us-ascii?Q?upzMhXC/0klXZf9lAjX+xr3D+5iML+EsKxF9gAPcvg3Gv7bG8iSTUVTVT00X?=
 =?us-ascii?Q?dX/y/Dhs0S28tm0ld6AwQjEWibzrU4eiFBcStgv/YXMCuFCtCgKiAgp3sNoZ?=
 =?us-ascii?Q?qIB2NxV//4DuwpwUzzE+pmuDABQtEpiFvl9qjOpGO+eDv4zMwC2qteis4x6v?=
 =?us-ascii?Q?cQkELvSj4v94MkDgdbhpuM94ktuF7crgO64N+wPHx2VlmCUuaEejIY5sPOPA?=
 =?us-ascii?Q?6luAWGA0fs+25Y7twWLu6HO4dkGInbztruDRxLzg/kxdYsbyH8cACN6nOwBb?=
 =?us-ascii?Q?hYCFB3vIpgonS3AubNaWHy6RNhDEewyu2bvS0KKAeFo8TXJF9WjGppJ1Igg8?=
 =?us-ascii?Q?CNYeILq8kPg9BlN3ShhLuoL3WX0zmPUNWnOTxIAoHMWzvbtv6Hs64VLcbd6E?=
 =?us-ascii?Q?knNgk5R5V5Dyv+Ac7vHscH+Zsryx7CgAF0LXriHJr3rVGvr5z66Oe9LE+YyD?=
 =?us-ascii?Q?Y7Fcx66qUwHrJtI7CJvyUmQcjqc1OMGdI6mnSZERT3vSxs110GaP/LAiqGZt?=
 =?us-ascii?Q?C+O4BWHshFBIp9KhegTZOCPv/D0UCoUb2fZQl6z3Iya6wxnyGvoFFYvQBm0o?=
 =?us-ascii?Q?XkQKA5swmemx4RVsSg2DtdYKB1q5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IG77FguGjamjHNru0oGTLClCSJd0yE+oZDqF7Xt1LHOsQ6vm7N6LdXPHPoC0?=
 =?us-ascii?Q?/VRY2RVL9R6kj1091SlhuZXyBsrXyLAv3gmR1DNhLmIbWMn2F/bFcEI5h2El?=
 =?us-ascii?Q?5mzic7EvIhf690JvFs9TKeOW+JbDaBVHk8lp1R/P9cp/37uT1aghm4axpHGo?=
 =?us-ascii?Q?58nzC20gxitGqtfXqmA38dZeFqJhZuT2kaelwI5h6O6xu/y6hMBNLXuHdq33?=
 =?us-ascii?Q?Xkiypk5D7K6AYX4963eYI/uOCBtrgz6Mv8dkOptQsd+V56wREQshqdDUGuWl?=
 =?us-ascii?Q?vgDpxv9vwxk45wMUwMDAJekvZAnXSSUs6hWlCkKp1dcmkhTuAJhSOK/TIf6C?=
 =?us-ascii?Q?gV1FK7t0F6wut9uMizjlVnJQ1+QgmRTL2D4pCAWVFUDNhRjHmYXnD6IfEeRP?=
 =?us-ascii?Q?qT979HC3S+vVvQTI7Pqqhsswhul33yjp/A1yycB85UplZ4NFuXXMimk1e1QY?=
 =?us-ascii?Q?yg/R+HZq/AAlcySV36jkz96J3clcb/m/iEvXwVYjaTq+tiTDuk7FcaahtOkG?=
 =?us-ascii?Q?6BJRqxWmX2F9prlbxGBPMC/dr+UMTMqqHuW60JUMU73CEADK8CxF3AP8iMoq?=
 =?us-ascii?Q?OaoX74lqfClr3SqF74VsbCBMbpmapWpXkBxkHhWm0y4lz56mFuNaD4UkO0zq?=
 =?us-ascii?Q?BK5w6AdkKaKbnwMpipDlEqDCVWher9TTHOV2iTLUzVL7t8IXVwBef4s+h5wi?=
 =?us-ascii?Q?pML3Ushed9seqWbNGnof18O30TaGpAfDxHKPRHzGr5Ktt27sAENoVwJsLWlH?=
 =?us-ascii?Q?XhCGxKWFuE1i2p2iwwfgNo5eue1rn7em+b/r9hukRQmGnKf838nrKsrTj83v?=
 =?us-ascii?Q?K1cAU6/eAUDnlKiE4BtqsR9JiS3KVp3B64XUjL5TxKR7R1oAU+gm9Y64pCdq?=
 =?us-ascii?Q?kD/PX81oPk+5l1LSZ3GT5QPK5iX04SiC1mrbbk/19zletjMNSS9gXR3SQL5O?=
 =?us-ascii?Q?A0tDzYJiBUci33EibdcOgdzXTWFXvmmvvYRl2UM/TjhWXixfN8HBMtaMbqSJ?=
 =?us-ascii?Q?hzam0s1nfUF7+CH3RaaHLnULjNlszdaHL7wOvvKd37uXO9M1zIFgiZDMbbxn?=
 =?us-ascii?Q?xM9siaRxybOkFSFLGEedYZbpRRfst/8iK8bwAIh7bjTOECeTxdgCRPYv2KX+?=
 =?us-ascii?Q?B1TrWhl1C3QFLtCXfVQ2H7W5DXtMWDt1obw/VuA1eecw+ZginSRHNLc0arAL?=
 =?us-ascii?Q?jJkFJyEtK9oS/CDZjQZXAhATodMnlvnTKqef2CzNwiyhp9BbpWqrfEcKuglS?=
 =?us-ascii?Q?zoJkKlz+z9KLYcGXJxc2rN2cn1eJi3RsoGFxDdj9mjdt34cSQ+DZGaJ33NdR?=
 =?us-ascii?Q?SSDHhy7UOE+d/qYjzqVseDF5k/B99M7A7Tx57/lLYhYTY4EnXdOL0pPgJamK?=
 =?us-ascii?Q?bv+BV2tW34cFt5c2sD7Q2TFLG4xv5vOPgeDm9M0SY68Y1kv8zzOme0JWw1ox?=
 =?us-ascii?Q?mhhGKln5BYLdnvqFAejYwktU4GcA6j5gD6SjiS5Ng2NnQN7NhG7HDPnJXiQP?=
 =?us-ascii?Q?3KyD9aCdOB/ATJlzvDP7cF5dSt16/CYgbVM7x6Fbs3xNSqHfQ5djzZd9Ke+L?=
 =?us-ascii?Q?iFqtYHRN6+BA3okkuEViXUOMk2xHcBVEZPJWuO5k?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e2efcd-f268-437c-d855-08dd98493532
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 09:23:55.0247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fh0bKwEOWj6kV99NCuGTvTHM35uKxELKr1Ib+dJHdqjEXJ0a4CzolPdv7KiIV7IIpEBljwmQ6pf3d1VMIM+e+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7242
X-OriginatorOrg: intel.com

Aside from the nits,

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

hi Sean,
Do I need to rebase and repost [1]?

[1] https://lore.kernel.org/all/20241223070427.29583-1-yan.y.zhao@intel.com

Thanks
Yan

