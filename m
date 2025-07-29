Return-Path: <kvm+bounces-53590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDC08B14569
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 02:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F231517F524
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 00:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68FAB157E6B;
	Tue, 29 Jul 2025 00:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ic80IOeV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6FB36D;
	Tue, 29 Jul 2025 00:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753749926; cv=fail; b=TeY2femboJ+rd/L+2kRz0QaNDjRXIKgfAU1qiLjCs3E67MUtMql/9zEY/VizHP89cCGkAFxWacdRkRe2qCDfeVqPWfcu5tFadAo7CwAxwee9CFII6f/6kkTPGS0OHVPFcF0gCt/fJ7TTSdAxGtbtVKDhEM1ZToTgPk9fjFnOl8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753749926; c=relaxed/simple;
	bh=QzNH8lnxEfulY+1gRb91CyMNB81HOY2OVfmCUF0Cazw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jzGls8wmetVFwwTw+P0GM5mlYp3mj8QvVPFuGdKfobNFJC89RSCEqQ98HpElVjQXGuB+RyJC+ZMNvjc6ytAKfaCL7+h+6Ft6Zkdc8TPyg1JC8JVrNep9SMDv/XAUfd8z67LdL47VcJF4kb5wKoffqdfCAXt1HseOMgd8Rv/OTmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ic80IOeV; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753749924; x=1785285924;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QzNH8lnxEfulY+1gRb91CyMNB81HOY2OVfmCUF0Cazw=;
  b=Ic80IOeVJFNw8I4Z0rKVDFDOtG0CFyxSaDJtXBIZyqi6M3kEXTmyIyCl
   f7X1zpjBw5ZPVzq4Jr7Z3laN32/v4NcMzVtaGy2991yZ3bOAEll42H5TJ
   MKEtgS3Lluf1me4wggMfYZxF+zYEiYTQ0LKFSzuRLHsJifp/74cwvWeNl
   HzMT3/RoBqXFc4Bt4CaXe3QkyJKx0GNhby/HV68B/zbVo/TSpKhM7KpcH
   E+sveLSXk6NSr6ShkokymF5biJGhD2uSpCVjqKqT0KyDbbpK1U5Vzqwst
   IMZe0MrX3tg9qioyLSh3JiVg1F1UjxugHlLOxEwmfsU1ayiIGslE/Vd78
   w==;
X-CSE-ConnectionGUID: 3ZJseaFwSYuvgX8Gdn0IYA==
X-CSE-MsgGUID: 28tRWFc6ROaGbE/S2Qdq8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11505"; a="59833867"
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="scan'208";a="59833867"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 17:45:20 -0700
X-CSE-ConnectionGUID: wPLA9ZutRMO6oDTkVsyEOA==
X-CSE-MsgGUID: YqjXx/nISR+EAliRBBk1Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="scan'208";a="193541815"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 17:45:16 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 17:45:15 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 28 Jul 2025 17:45:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 17:45:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dzaEIEr6vOpjCncraVz+k//WLO9RaBozijhHtuJA3xpTxSUyBYrt2Co9CbRSOabjDgqi4mEuFVaR7b0J76gRCGLGwjVaAjEiv0N2FzLaZ6R8wExrm0AE9ZO0vdCh7dMUbEF4Ca1SLcSO3EXnUNDa3BXezhswHazjJrS5aAV1c1Bg/cuiL222EYXYll+l2BZk7jplJ81aMVE6fwF/+hT44g3F2T8KAniujKgSSbv/tO6xgNAqqWYX33tnl4NgXXPBAXIwjYCZgZ03OdFHCXTGR1zdxyb1xplqAZAS8hU/Lhha6/SGMyhF8M1LItwhoIcyhZiJyfTw9D3KrmeTNyAiKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nn7K2dsyDy4SYlsos9cOtq80jRABWkx+ffroDGaZwdY=;
 b=rO5+Y7YakdHjzQG2xcaYWBDzvBlJPx8EZufezOCAJy7NiUDQmwzqHgzxYM2/vFafjOW+K6pup0klg8XYdWVcIwRAsQZ5MUXeAOF41LkO+56BI982KmuctLwP94L0A85ExdvOniv0nFN6eoc3dzTwi762opUjDCTqqZsKQ1zYRlyIm7YSenL1FMbtGm9LfhD//wqAEeruHS9Lv8mfEEkN1wTcUpcMe3I11gs2g6xAXlbNhVrqDF6jkyrFsxY7/ICJ9CQyxoPkOSLRJEbNpaXlrci3y5iDkHaT7kdVjqqm2+SO0avV8P0N9g5ZzxXZKxL3btQPPg+9CTl6RP8yuwmzzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Tue, 29 Jul
 2025 00:45:13 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 00:45:13 +0000
Date: Tue, 29 Jul 2025 08:45:01 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xin Li <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>,
	<weijiang.yang@intel.com>, <minipli@grsecurity.net>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v11 01/23] KVM: x86: Rename kvm_{g,s}et_msr()* to show
 that they emulate guest accesses
Message-ID: <aIgZjW2PZEdR/DYr@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <20250704085027.182163-2-chao.gao@intel.com>
 <5591ecc4-2383-4804-b3f0-0dcef692e8f6@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5591ecc4-2383-4804-b3f0-0dcef692e8f6@zytor.com>
X-ClientProxiedBy: SI1PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB4855:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c5e1338-8086-45b4-c40b-08ddce392da8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HftEfMjZpEgFWaCZ5IeKnMXfclNi4R786ap2bN6+jh7buKQMXwEjs6yMaEBA?=
 =?us-ascii?Q?MEc0WvGsHrHtrAo/sencFtU73NUYGnVL/dX6suDO/jCA0plfP7pbcNnVpLdQ?=
 =?us-ascii?Q?gRyxrkvmbY1Qe1azUx/JWuyAmSWjEje/32oytb+FbQfjX5AOmEaIRSzVvC48?=
 =?us-ascii?Q?N5qvIsVxSfKQUU4mrIdRwC5m6IcxJNX0wTtjtkTcTLYMy06QbRXEMAc27WuL?=
 =?us-ascii?Q?cn4i3l8qofYD3jEBWufePAdenLtWU1mP/9OKewq7NlZqUAVpxqn67gE7hmzb?=
 =?us-ascii?Q?+LuxCwsieBNFx+Gj/AZjpCdxEVfqrxzYM0fss58OjOSNKF/9osbZeyBoFXlv?=
 =?us-ascii?Q?RhS99pUyHPEDs8k1J0IZlJYn+BfZK78w9mLcBq/FkUAH7hpAnMumNk/+8JCj?=
 =?us-ascii?Q?DCTWuR9FbXimWPtlsLk7rpUIBiTl1DU4veg86LsmcfGhAL1if1yZht+/LHEg?=
 =?us-ascii?Q?+E7m3OdW4qqXz3T0pJ/7cwZppJkp78WB1TDy8q7X7gHeZeLGjj6fm2DyMYYX?=
 =?us-ascii?Q?xbJmsdQiW8s9HcI+yS59OCJv9XHB0eq2woS0AUSgE7kNW/P/6k/Hb2v+4Tw9?=
 =?us-ascii?Q?J1BRUDpwwvNCkst2CURVXvkJE0w4EnGEOnfE6DS4BNM7uX4lTiPt8rXkfcWn?=
 =?us-ascii?Q?cG4bg6vjpuPIVvsZ110HBCT97c2SoeZ46S6Uyzkc6bZYgmRVZz1hMYMuTo6p?=
 =?us-ascii?Q?hKW0Nd5hRObQIIJqmOKNAqaWma+Z56suMDqFQVDWHIIHeEXoWBOMpaeUP52R?=
 =?us-ascii?Q?qyLLhEY13KbqvuB5Sj4NDMHgmcsYObAFveQUCHukeC31dah3yQbHvl1ef5jn?=
 =?us-ascii?Q?2dH6T16qCJ5+rxI01msNdPOSUixKq1rGhe6t3rq9HwuGO2IqVHoZNRBO1WUS?=
 =?us-ascii?Q?u5YWuPuiXFFBNRbgZQ7efABNb7j0RYIi8Va3kxwTZDiyOpoRzFIHBK/gd/8f?=
 =?us-ascii?Q?cS/o/yM3/o8GlWvWqT50Rogr8h/aPiIlVr7o/K2S5fWBujeS1QuVLC4PZKxR?=
 =?us-ascii?Q?wUC4uNNonZ1JbBdEOfYsXq8uGGft176n91Xfp+wm1W35FR5az2NM+UGA/K1A?=
 =?us-ascii?Q?Eil/4GNaAXHZZFBJRIqiN4EcEeM3qO8K57uYKDyW34EysAwltIXdeHDcjrvL?=
 =?us-ascii?Q?7E/9d0BJO01aw9wqbK4EdjcGwC7JM6ip2aOllb3WYxmZi//Wwkf5Cw3qTXnV?=
 =?us-ascii?Q?EWlNn6k2BaJ1AlJv5bCg+2a7cHG9nzokQZ5tmW2rB80tzwFZpmntPKn1uIPU?=
 =?us-ascii?Q?l4z7XlPLueU2Rr/P+KXpM8ElN5AYVHsrk2xl6KK0pJVh9SbZzYndzNEV50Lq?=
 =?us-ascii?Q?KQ4OKcuHDfXMGBlX0/baFnjoxWM/ZvJP0ph+QMqGIFHogmOcUKCb8wTOA9qK?=
 =?us-ascii?Q?gyZ8uewCgHzMeNd0Zh8IfqvsWqApQrnkEV2j2xGeolvHQoftjrb6sV1vXyOl?=
 =?us-ascii?Q?Bmo/zkxGxIg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?owDCs2tNgYPfWtx5t/2geobxaDsE6Efa55d4/0zuUodVU6Dc/6t153f1XDmp?=
 =?us-ascii?Q?KswnxefOfpEyj10ybApCfRz8IcSgZ+5Rv3wiRXATNfeiO/odjd9OyTYJZH99?=
 =?us-ascii?Q?lLnOJTB52WmBJ/J8fNFAOjHWQg9bKFFRVhDYGOSfaqKJn34MT5LmTi0lhdm3?=
 =?us-ascii?Q?4kFVSvpRfUmLQwUW4de1uYR8PabU941esUk7ApyWkmB/bmh08xbm710NrDpy?=
 =?us-ascii?Q?wde1geJBWZwzeZ++3RCSBBTyNVFuS7oXHFmNLLyIaLKNbqz+828txX5cCXvF?=
 =?us-ascii?Q?JMEljGNTiQ8EZ8fSCUvEdcAnoMM1GjuNVD98c0oEq4VCug1pT48nxhFbDEGl?=
 =?us-ascii?Q?sS9WZpFf3bzRAwIgDmIDUBlCqOvYduSpbJrFPE7BWBNtXMB045tEC1LvyJIq?=
 =?us-ascii?Q?Q4OHhsZRKv+3GqkXAO0QrPtwLAySRQheC/VVQCkcR//3KyEm35Bqev3xaazp?=
 =?us-ascii?Q?CoB0jQ6/IFEBlxMJegWzlpxSFyFU5g1Ro/eBbmNvZuJzloNMMXpM3is7P2jX?=
 =?us-ascii?Q?A4GKtsAYpF+XM2D5XKIVZl/afwTJFogLGSedvBq8Cq8iDOuZk8ZMS/rs7aNZ?=
 =?us-ascii?Q?I29puSrMjdQOABYFbVPO79z7q9JDnvvxeMuOaKY9cmXJ9UTYMPUJV1MK7A6k?=
 =?us-ascii?Q?QmIiZZHKn+ywhDTPq9W6qRee9iSV3zsveJZYYMh+SL3teDAuonHE/1JeEJcw?=
 =?us-ascii?Q?K7HsfBYMmrJ9xVrVR5S7oVagW7tCkA9tnmx4t1n8hooMgjrriN0zte6QzZQ3?=
 =?us-ascii?Q?I/UILPvW7Anb1huK54hk/JkmWGPDIpdtJEDi0y2Tc5GVW/FQAITVv69t9yku?=
 =?us-ascii?Q?2tfDe89KAxVYarEqGwcoYqKe2TriXD5tKCGNqlNiaAnKbkFmChyL9xmmac+X?=
 =?us-ascii?Q?h+IVKGKtHF3aTnuSNlm2Uop2Gd2vWi6WDX3HZCY/JzQBd+OShP95pUAGjpdG?=
 =?us-ascii?Q?KHuEgfjx0u/uoNkZwLmrLAIeRmzzEAblIRxCRIiLak0jDjlX/yMdFFKWWEgx?=
 =?us-ascii?Q?sfrcZ6+PLUXTCxEIyWWVNNI7tx7HTmaNL0yhuBsUbwXOvu4sUxMt1Wk+X4/z?=
 =?us-ascii?Q?4wH4/3u2DbxXUB+CAKRBRGfDk2/rjgTbIHIvGNDCSJxiyBI4nIa6fm0TP0jQ?=
 =?us-ascii?Q?xdepsxuzxyiacagl+3LctAl1hamh0eHRkXO7BFWe8hBHLKh8zvF1mHE03/zN?=
 =?us-ascii?Q?8J2Kbv284K2XBKH3v8vVMVrzFLYnLEy3WL83VXx9LZRV+uJZgL1nFBLusJBF?=
 =?us-ascii?Q?3Tr4SjuSrTKGvoEDVqz1lJtpZGmWBX8MFg4pXJ8Hicx3j3zrWF45S6KFFS3n?=
 =?us-ascii?Q?o1mthZS2191IYvs/m6Z2Uz1NvD2BRQjFqm90I/qImCYlCA1dVz3K+sk3VzXh?=
 =?us-ascii?Q?IfN3hww3UxDOH29bvU6XwJVitY4qkgDFv4JL392EM8h32R7ftcD3hIHGoXxf?=
 =?us-ascii?Q?krSelNVtopN+LJKEig3l9qbnw9+r9QKj2GvdDK65hoUtmw393aLseuoTobDX?=
 =?us-ascii?Q?Er4sN4J8ldxV7ihxiktJ373R+aM/UYtAz5oKZJ3o0JfSIPxBjWpu/Nl2Z5K7?=
 =?us-ascii?Q?9Gcuq+3gFBNY187DD9qj5N3XVxvety2sBeFQpwVQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c5e1338-8086-45b4-c40b-08ddce392da8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 00:45:13.3073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +JiAKSLfisV+8+FN2mBnVfMj9HT/uxctFsN2ouyWvSm/Hg3QrfGXRbPgK9aUc4T3mcPUJTAESG9JWHADZbR9Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4855
X-OriginatorOrg: intel.com

On Mon, Jul 28, 2025 at 03:31:41PM -0700, Xin Li wrote:
>On 7/4/2025 1:49 AM, Chao Gao wrote:
>> @@ -2764,7 +2764,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>>   	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
>>   	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)) &&
>> -	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
>> +	    WARN_ON_ONCE(kvm_emulate_msr_write(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
>>   				     vmcs12->guest_ia32_perf_global_ctrl))) {
>
>Not sure if the alignment should be adjusted based on the above modified
>line.

I prefer to align the indentation. so will do.

>
>>   		*entry_failure_code = ENTRY_FAIL_DEFAULT;
>>   		return -EINVAL;
>> @@ -4752,8 +4752,9 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>>   	}
>>   	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) &&
>>   	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)))
>> -		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
>> -					 vmcs12->host_ia32_perf_global_ctrl));
>> +		WARN_ON_ONCE(kvm_emulate_msr_write(vcpu,
>> +					MSR_CORE_PERF_GLOBAL_CTRL,
>> +					vmcs12->host_ia32_perf_global_ctrl));
>
>Same here.

ack.

>
>>   	/* Set L1 segment info according to Intel SDM
>>   	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 7543dac7ae70..11d84075cd14 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1929,33 +1929,35 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
>>   				 __kvm_get_msr);
>>   }
>> -int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data)
>> +int kvm_emulate_msr_read_with_filter(struct kvm_vcpu *vcpu, u32 index,
>> +				     u64 *data)
>
>I think the extra new line doesn't improve readability, but it's the
>maintainer's call.
>

Sure. Seems "let it poke out" is Sean's preference. I saw he made similar
requests several times. e.g.,

https://lore.kernel.org/kvm/ZjQgA0ml4-mRJC-e@google.com/

