Return-Path: <kvm+bounces-69212-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOsyKZBseGlSpwEAu9opvQ
	(envelope-from <kvm+bounces-69212-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 08:43:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C41190CCC
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 08:43:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 70CFC3008266
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 07:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72559331221;
	Tue, 27 Jan 2026 07:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l4P2rI8I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62394502A;
	Tue, 27 Jan 2026 07:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769499786; cv=fail; b=mbsHGqSQb+oDxEVKsRzomG0t6XLhHtOlhDmxgdGnGatH2bwT9X2tjWIOCe2BEYNQNinz6nPmhYVqt7AYIDpbJWpVG8gc1GY0PstLwHWrEbHpzRNodSF5p0eW4xfrx9JX+KivriDBAoWVFnUCHeuTTMBWyeeNmXMSPE1dLVGR1uQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769499786; c=relaxed/simple;
	bh=hPV3ZIuLKjJ00K6FBFWzAusht8bJGOo8OpO5xKlZdD8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I0b2rVGcg92IpDcvlHgASh1v63KU6lGzmSqs3g35N0mvscyK+neGVWveudX5mAfDmT5m6KI0IUodDMG8x/4S2i60DB+cnjzi06YiJbT8aSsZbxaPxaQvAjyoi98lTn1CHrS9ORmXE1zSMSaqmqa7MV3sd2+9CgOf3Lg6YlWpRnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l4P2rI8I; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769499784; x=1801035784;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hPV3ZIuLKjJ00K6FBFWzAusht8bJGOo8OpO5xKlZdD8=;
  b=l4P2rI8Ia+FCH40oa75NjndlSbDzGUQRh3Qvu9yo4eDl3BJRbvcXZ08I
   sBlXurraoacYcUQgbJxoPGm7WaDz0tgYTzNk2eyaGsyllyPthsLRIsQ09
   fMsR7kbj5wM6Z8JPoX8Vaj8D2n8/uyfViduzNvZQBmNdENWSaP0dFbch4
   sZMy4MdaTMbSWm8PrejeMQ+NBk5D4gM3AuT1F03xFzl6xaCCGPy39kkS3
   ypSgq0rOVdIklfHhzGgU2XBkjOWnM3glSYrxfodvDg3VMSqD3gPlUMt06
   UKfDz371A2Ih7yjVvb+kVLxw072euCqliykVgpFa/yfBckAb1xVUvPHjC
   w==;
X-CSE-ConnectionGUID: mmmLMnlhQbKPfynWXUMGkg==
X-CSE-MsgGUID: oEXVU/KsQz+93QK2DVEU2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="82055882"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="82055882"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 23:43:03 -0800
X-CSE-ConnectionGUID: XFd4uecgSMaEyxnmjdcTXw==
X-CSE-MsgGUID: qYisCbFgSf269Zl4CsyTYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="212450767"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 23:43:03 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 23:43:02 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 23:43:02 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.19) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 23:43:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iYcqKusrs7Imeetr4t88G7CG9xAB+sOEeOnohohJfknZC+Ue/3SJlGRaztfgZ0mF1vrVOgAUwqs14hqN11uQD64HSHayyDBz+mgeaZvIbfcvmHC+QYvkSWm6xvOtS/x2T8S8kCsmNhJ6BOr/FjI7AE9eB9seLYuEZRW4x+3WUsY6gQn8PxAadJHlMQejFwO/WL6/M0PzTrLrnCYc9ETYRtuHKqjAVweDFvpgYT4mws/HKflpjcMclPmGBsCv7w1tOHHQMO65197mCz3e/vLMkVrEbQXsyCysbHsdKyRI4CDpi+pqcGHn62SkMmZ+TIKOoXdv1nByR3u3qF2LTDCX/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fn5jUHVCH186bcLTX1bjQLJzF2+n0da0RDTqAfzy/qU=;
 b=WMBQ9hhrUSMR0WW7XX6foLz0IpGnFAfEHZp6FTKWUyvMwm67SXbixbkqcaDzCnUgpdyxHSteRz5qp5G3yLcRjpCKw5rCwrP8tM+MgJnMYTsH1W7/LTlkv9ZGSPZKtoI6/K9LJwLKLNqsVqY7RyAuqm7U9SUMoQaJj5NnBpAtKX97JWojTNja1dXwjFXAilMLz5YMnAtUjOAT2Zok8CFTA57h6DhnfzsQCV9LtKO+fbt4mTcLQtfMaPV2cZ+sq7lg5DoTuoHd/7pUgMuBk3KbnOmYiO41B/RYc7m4l7ncZ7SgQcGW+1ASCo5P1y38zivwur4W20opPidiW9E3tuu18Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB5172.namprd11.prod.outlook.com (2603:10b6:303:6c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 07:43:00 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 07:43:00 +0000
Date: Tue, 27 Jan 2026 15:42:48 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Mathias Krause <minipli@grsecurity.net>,
	"John Allen" <john.allen@amd.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao
 Li <xiaoyao.li@intel.com>, "Jim Mattson" <jmattson@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Finalize kvm_cpu_caps setup from
 {svm,vmx}_set_cpu_caps()
Message-ID: <aXhseOthqSEQvjKp@intel.com>
References: <20260123221542.2498217-1-seanjc@google.com>
 <20260123221542.2498217-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260123221542.2498217-2-seanjc@google.com>
X-ClientProxiedBy: KU0P306CA0100.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:22::7) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB5172:EE_
X-MS-Office365-Filtering-Correlation-Id: 7049ca30-f9e3-4048-4dfd-08de5d77b1a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?BN4HJ0kAOGVfUYAp1LPesLJvVhraMTU/HIJGMYjmBboGQgzw3uEPlcou2KT+?=
 =?us-ascii?Q?fi8/Ya93BEyCkjOBXbhjYbTx31fUK3+3FFEV8yX1h0f8IoKY2b1Vd6DMkYCV?=
 =?us-ascii?Q?aEhxtDqo7UKJmgywQdbMGRcTCHRE++vnUrYQkQ1hr+wX+t2y8IXFnDASKQ6Z?=
 =?us-ascii?Q?0w5LN+x00OSu1p2oExZCwnLlPCVzUFGPrZHtTISIhNSC6Ofuetsg9UckZZXz?=
 =?us-ascii?Q?pclU47fQDlsbVA7q8B16Ug9hjfXtA9GwXF2eZrDSkRCTlAsfmn+dXVMO6Mpm?=
 =?us-ascii?Q?aN6Vrrc6kLbl9RTyLCMiLgu67NbyjxibWn6SUq4VmTwgdHex/Su+/crStkVm?=
 =?us-ascii?Q?AdgZMOo7Upsn36KOFXfSEWmwwpII5MzQBraOfjmEZuLzivzjvzsqSK+oAPP1?=
 =?us-ascii?Q?yr4ckoQZ5+BKST9vLkFFdvXZ5qHqaU/aLgTCp6nO2oiCDEND2e72A50Zd1XG?=
 =?us-ascii?Q?IY0SSq8QBuXDLIjBq7zlcfaqaevMtexpEgHWUd7DRkz7unSGD5nXas79jnvF?=
 =?us-ascii?Q?2ubWdukXYfVS4lA2bqYmpKNuM/Khd8L8f84EuxuAuBNlnWqPouvdfO+G9NZ+?=
 =?us-ascii?Q?R61IG8vF4P3w0hc9bK4DTahbIIGjHzHhwgyP6EvCpydh1lZecMZcceLDQB2o?=
 =?us-ascii?Q?OIEm16VNhjPZ+zyW6r0Wy75P3NjAAxwogCzMaQ/D0Rrm3ZsT8VHaEExmT4Oa?=
 =?us-ascii?Q?QquxZEpaldcJ8vPgAgtNwj4+C/lf0bEJJEUICzQUgw+817Lf5vcZjiWnOQx7?=
 =?us-ascii?Q?KcGUrEivlMfgZ2piGMNB2bFt8IlvoA0GsO+IgxfQonA8qo4bxT65qTCKhmMn?=
 =?us-ascii?Q?Dj//P+H/YJ3DT4TKwaBy9jTlbN9rDkikARNSeKhlZvlVoRdhqEYSS2QnSTeU?=
 =?us-ascii?Q?IDru21IMbbJ/iHvaJsgVJubLipM+VHJ6FcZkQZk7rDKcb7QhRHQvaLqU/+gs?=
 =?us-ascii?Q?Uc1d4i4MSJ1S4Vdd6qgzLU/gdbV76F9QbynjgfTvOqQ4jnc5LQhW22vGnaI7?=
 =?us-ascii?Q?o5s0N4rgHtzE5/GygsAjh71m4TEYNR7hFb7GZ5FIUb2DgXjZ7vvyUy4saIiY?=
 =?us-ascii?Q?vEwPCjZ9CbSmsMcuoKIAr0VLOfz+tj8nxdI3tOqc2an5cEm1pyg85U08iXtv?=
 =?us-ascii?Q?yDaQYdcTTMTQFj6MJ34NL7THP0sncRhN36NzqVBnyWZdZUdlcqX/09QT1Pgn?=
 =?us-ascii?Q?Ti3fUONKPqTPJc3q1Tc7NeIq29efaPW4tiwQ/PjAvdopitQTk04Udgq3vPgl?=
 =?us-ascii?Q?HnZu5j4FK1eBuh9xKcNstc56bBLuHyq8FAYmBsWe6YRJhYixE6+qpW7oN341?=
 =?us-ascii?Q?x08uoPL0HpsXRKeKuFcS9Ay1L5CALLUfwFxJS3Tpi/XtFSbCkVwWxie+Akmq?=
 =?us-ascii?Q?auj1ejZ+7bvt1aPCPKz3/STQBGU5WNeahd36hGNnwIE9coL1cDZsDkGvaq4u?=
 =?us-ascii?Q?x8YGvwVPOKS5FgrS5Sw8RT5s8qJB7s+VHi+ZIZ+oC+Fbj+SttvsMjSKMysYb?=
 =?us-ascii?Q?DcwlGa/xpP0JFn9hKAdxk4tfhOL5IF4dwdWvZnH9eBHfMbY3yH8GfAGewcdR?=
 =?us-ascii?Q?gnLEPez7KChQNjISnFw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?66yCCwrrpiLhbU/IlrEOhSF1USEWiMekmKIHMcct45EOG1jGxUz9jmaPDjzE?=
 =?us-ascii?Q?05JMaDUEoDBeKNJrwgTtgd7TvQbnxUsoxD/7zh0X+3g6zm60yPtnqh4qOv2b?=
 =?us-ascii?Q?PJE3BUPWt0cH2KXFPWgeFz4m4VvESDK4g+/fz5uqJr3z6J5sDShuECihY/NK?=
 =?us-ascii?Q?mYjtOiosXzMjzfgP8vM0vaZsR2c+zGr+XwRtah2GlyDNExezN3NxLbBhnqmd?=
 =?us-ascii?Q?lzAPZ2r1WVDol/hdrBn1WdhC0ciBBT1k3q56ybcDWzeA9cAiv/4DpmXD2QKv?=
 =?us-ascii?Q?tstU75SyqPl5v0yUFlMn0eqgKPBdAEZGJGTO9cTO2JjmRwEw2Nu34vCOh+7D?=
 =?us-ascii?Q?t2Ul68tOg1MDeEOrp73iNl1mqc9Xap+F9ctdv1x32TPmJkG/+AJtnB7Ecygf?=
 =?us-ascii?Q?FJoWFsrQJlOpwYv4o9QdZKyP7ibSpZhPwo/QfYcDCIeyFK2qE1Cw/7juyx3O?=
 =?us-ascii?Q?iP//5108Xvr15GKxR4zmIBWS/H+KyLN/xE3Fvac6bL+tXjkygmOa2o3FF+Gx?=
 =?us-ascii?Q?ksh233TpygEp2QSRQvCYwgnW4UrPw1/K+dQdGf/VS5ydeUEfeSVtizRYSfer?=
 =?us-ascii?Q?vz2LYefFdMzI5BgxA8zX2aTyRozQ/KyFPpkZkBE+Mmu04+1tWRFdIoNONWIb?=
 =?us-ascii?Q?2OSY56Q+aT8zrK24NNnl7DBfMF2qRgp9JskqdGZ1T1Wu5HRgdDYrQKU+2oY4?=
 =?us-ascii?Q?DhWaaiD3mWgqT/WKl/KBmod2+3NsfcLI1l51mokKUGR9fFeesu9maNEMQ/D6?=
 =?us-ascii?Q?kJksWSAQ+EqwtD46bS3JoGHQJLS39RlHeqTHyV/d/gqs1UXXgE8EwguZNxk9?=
 =?us-ascii?Q?B4eqb8fg5u51LYwM67pUrlO5tBRPJHPSDt9fnl4Ii23LZuMwTY+/cNljYABR?=
 =?us-ascii?Q?hkAC810vgsU4cOCKzeH+y3YCVI1cgDbxZydd999ip9r4WZNebEMkgqIj2ujI?=
 =?us-ascii?Q?0Fja+yjYlR87XX/TJqfn+Isk7Rt+45+n5wu/ekok3CoiYK+VJjOx4rkBIQI4?=
 =?us-ascii?Q?g1GxgqOD9aakTfOrfmoRnl/1o+kvARDaH7VlG1V2FmmyGpZhev+EB7Zc5YLY?=
 =?us-ascii?Q?YJiRmFzimGGsMWY8pPpuvaCCXGM84XOEg+1lU5GVST4WFx6J8MD5FWs/ZKY8?=
 =?us-ascii?Q?qJYmL0goWrCZT4VxQ14hhX5/y+EhDy2QykCfXSblJMCmooziZ1WZpHmfTDlb?=
 =?us-ascii?Q?jUyz/0/trcJzv56o9auO7K8ateSrzxvsL2YE+MUON2EKgLFgc3kgxBKtyj6t?=
 =?us-ascii?Q?trpUPSrowJj3/l1sx8mea81414B8sTeVoLtcwHsLtZeHBw5hHo0l1bNvvHE3?=
 =?us-ascii?Q?eg1GAxf+MJ908OgSksUIgVE8LckFVcgXERP9c9rHpxO0vmoiMXlz2f4tgfCV?=
 =?us-ascii?Q?htyLKSjPga3a0UuYql+xCCRAitr+d9CRJESBvaMLwBhkt4WIL1tuoHmpDmOD?=
 =?us-ascii?Q?gZUDj4yVtpTa5z6BPKCLxvwjQkO/d3IZUHfI0l4GnjL9YEOdile+rF5Fa63P?=
 =?us-ascii?Q?5clfctAz2nVlWeePVsM91jdjL1gUUom5bBFqfqBDe8AzaM5EaaVOCdFNsAT8?=
 =?us-ascii?Q?La2eBaMnsCwlTiFlhQmOCylnIcQjM8iBJlVRjtjKesMCjF1W2Cw/7hRlZCIh?=
 =?us-ascii?Q?493rGJHvPMPuqvadMV+5olT6igHutTPw/8VGeLrJMRk+INUP+ktD0qung4Bn?=
 =?us-ascii?Q?PBV3WgCjKEIr30AZCK2Gv1i+PhLHhuXbTOtXZ+fpqoxcIiYeVskNXn6tyaTC?=
 =?us-ascii?Q?jzSovwYr6w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7049ca30-f9e3-4048-4dfd-08de5d77b1a1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 07:43:00.0012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIhG/Ju1bHAH6BfvZ2Gs3DtR0zgPmAvMGvoHorgdpnvwcBPX9HMdsgXA14UCYxG5GWI++KXsyXN1pNBrPlLSaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5172
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69212-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:email];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 0C41190CCC
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 02:15:40PM -0800, Sean Christopherson wrote:
>Explicitly finalize kvm_cpu_caps as part of each vendor's setup flow to
>fix a bug where clearing SHSTK and IBT due to lack of CET XFEATURE support
>makes kvm-intel.ko unloadable when nested=1.  The late clearing results in
>nested_vmx_setup_{entry,exit}_ctls() clearing VM_{ENTRY,EXIT}_LOAD_CET_STATE
>when nested_vmx_setup_ctls_msrs() runs during the CPU compatibility checks,
>ultimately leading to a mismatched VMCS config due to the reference config
>having the CET bits set, but every CPU's "local" config having the bits
>cleared.
>
>Note, kvm_caps.supported_{xcr0,xss} are unconditionally initialized by
>kvm_x86_vendor_init(), before calling into vendor code, and not referenced
>between ops->hardware_setup() and their current/old location.
>
>Fixes: 69cc3e886582 ("KVM: x86: Add XSS support for CET_KERNEL and CET_USER")
>Cc: stable@vger.kernel.org
>Cc: Mathias Krause <minipli@grsecurity.net>
>Cc: John Allen <john.allen@amd.com>
>Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
>Cc: Chao Gao <chao.gao@intel.com>
>Cc: Binbin Wu <binbin.wu@linux.intel.com>
>Cc: Xiaoyao Li <xiaoyao.li@intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

