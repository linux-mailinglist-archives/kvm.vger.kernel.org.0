Return-Path: <kvm+bounces-17286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 808108C3A41
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 04:50:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3DAA1C20C90
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 02:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85725145B23;
	Mon, 13 May 2024 02:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kj8H74wF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5F3145B17
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 02:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715568575; cv=fail; b=VVsgmxhhIie2+i7DCbNJ5t2mBIdPZzvnZNmv+NiG/Trt1TX/PEp3B4KtGS5iUYHHAOdlGNTOQEtNw8+ihBZ+9E7FV1tl4kI0JKYhVp9jY2tLbtrDdnL+h/Mz4dkhsguR1TOWtBat3WQAFy9dRk8eDRE8LmJWFfq243XvEgNXi0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715568575; c=relaxed/simple;
	bh=wvjfJawOEu02y2JDen9OwbLdCcAIbphu2EkrvxSQls4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E9fGn9D/3Xtp1xGS74hQBfDYQ+Naq6y2ccHsER3Wg46i2DyHo5lLgZ3DYwDW5Pjm/wSek2qtkBwmZ24W2KJ3VYbgYF/DSg/03Ll7lrx2uNIlSbwXpzZxPVBX4dsxZlVUU0Xop93lw5hZsA1b7CsYNLTB8vsALvfdUBR4VyBfoD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kj8H74wF; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715568574; x=1747104574;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wvjfJawOEu02y2JDen9OwbLdCcAIbphu2EkrvxSQls4=;
  b=Kj8H74wF0riwiqXMuDOJqhaKIqrxrp++zxyOddpHTNy5s1nrzZgWhdFL
   wY+syizviZCHq9EfJHyLLTN4h1oMG8Nh6F8K5zVtrDOrXqy3YkgBE9mJ7
   mSJZ+wX/22e+UkMiE1otu2uKYKOhLUo0C2gmD8b2rUzof/htuLctvmd7w
   SgqK7BtERrNCqB4EvXAWCwfChjU2STiMaOXq++I9a+FlefZrfMkp8WMAa
   kJ62tWeQrlCFSz46l4wes4z0ZJGR+n9lPunmRCMF+lrhsqzXpgh1ApxDW
   +if8PrRb5L7X4Hv5/l11q77jt1JInQpmiDb4KzygcngpEDsEXlmc+oMag
   Q==;
X-CSE-ConnectionGUID: yeKr0I4eS423DXcGzEzJSA==
X-CSE-MsgGUID: KI55PXS7RHqaWcFmcM+aag==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="15296928"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="15296928"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 19:48:32 -0700
X-CSE-ConnectionGUID: 6RN6fa4nQ2qeP0st7T9r9A==
X-CSE-MsgGUID: hQS5LoaXTvqQVd4/YL3Hng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="34953895"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 May 2024 19:48:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 12 May 2024 19:48:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 12 May 2024 19:48:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 12 May 2024 19:48:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/MK7IiwRX8SVXFjO0dhRExu/OsP+DdL8gfJ3Lr3pQ69qf+4S/MvhU3lV4iMnpjMDtCYsnzcvEFTjX2zP+M/8ANHi0LR9Rgavbk86AEr10i+taacD7KhNfc4c1OyKQnvpw8A+Kag2sAwUSpL4kSJjBN2lbNe2QK8GCRERUCIDLzFOWuFoQuVeTNqTrFqQo/PuyFcVmllBEFjlBJDda9fz9o1GnohsORSzguRkn8Wl791qqrY2Ufopvb28i0QPPNYKs07YZrIyaRYy6UZXpjkV6wq1chbzyLyjb31HtQhHfKqVN6nGbLgTx1Bv55qhya4bG9JTee8az4IixfI6zSq1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPVpm/CUwqVHNtMKViL9tjCXxX/H4lkusXd1AX1CDCA=;
 b=RarJeCK7n/aTtQ6YJEDsmSTCMzR5COGGPxTbgKKOOA+F3RP4eKXHQSY+RG4Nx4z6GnvYXD7y+7LMoyqyZRIpuT7/inuHc8IIOzYHcqGuXxA0F7Jwx12FFzI6V7hcjxckwGIjgVBHpRnx0FafXtFiLNxW/CB6GIqyFTDWtOIq2KAuGBglbGckjTLbdd2jMw0+pOw7mSPQ/IFBUg4T9oYrdkr0JQjaEYNkXugbzIH3PZN4ODy9TLq1SJ+pr0DUCK9ZcKXulqyI1c09Ph0iu6rtGYUkmBgcsS9IyEaZzVfnuzWIVdFgxrwZ9rxndJtGAW+Jvjyn7T9HOlkkFVNoseLeMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB8049.namprd11.prod.outlook.com (2603:10b6:8:116::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 02:48:28 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 02:48:28 +0000
Date: Mon, 13 May 2024 10:48:21 +0800
From: Chao Gao <chao.gao@intel.com>
To: Tao Su <tao1.su@linux.intel.com>
CC: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<xiaoyao.li@intel.com>, <yi1.lai@intel.com>
Subject: Re: [PATCH v2] KVM: selftests: x86: Prioritize getting max_gfn from
 GuestPhysBits
Message-ID: <ZkF/dcrFt+mYKfXR@chao-email>
References: <20240510020346.12528-1-tao1.su@linux.intel.com>
 <ZkFwgGYV84TztUxD@chao-email>
 <ZkF0Q0uxOfWflfw8@linux.bj.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZkF0Q0uxOfWflfw8@linux.bj.intel.com>
X-ClientProxiedBy: SI1PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: 975e7848-693f-4715-b034-08dc72f72ae9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sxQ0C9giCGHEivxTEOHiHylhSGbwZT0aylL69jwNW0cfLqcIUi09U8ztKZ44?=
 =?us-ascii?Q?A/3sKLvalafHAScwG03aYoXCsSziaIj84omRxfMoakV1As1dvtDP6xrStpWr?=
 =?us-ascii?Q?CKq6y23hoOACfNpQc4lYaeM2N8p9BPhBVo87fwszUvSs9X0wUSNBjHytnBHn?=
 =?us-ascii?Q?CW4wuQQeeuDh2KEusFpGKo0d92WwYhzDNVqmZKlZkuR5TcNJW80/GYO9WZtp?=
 =?us-ascii?Q?28GdN/sYhi9cNTW1YbUVnTxVCI5C6UwlQjbeyQMSYuqkx5eOLbUMJFljX1o4?=
 =?us-ascii?Q?UsawSS0oMbdY0GsBrPyulA8AtTMh9r6UAgQOE919fe7RH6nKq9EGhHNrtJTi?=
 =?us-ascii?Q?Zjaqye5I/xOwqWsI5mRZsX8/Ue+uZ94G0XGGJO6/BIo9faABQaldNs+JPsGM?=
 =?us-ascii?Q?HQXw5oBYuDb4mM02wfUxH8IrLHyGGb+DVFNGgb1dusSzZkttYL74rM4ILlfO?=
 =?us-ascii?Q?KlmQNKtGQl5DiOtqIQ9/skVlT2T2iCFpsloSDoGKSDmh0uQGQPii+r2wx1o1?=
 =?us-ascii?Q?J7aE53Yzd+KGnrmjx7E3mK9u33RWWT3/E8/sgzvrmysS44y6l2KNnEbQKhmy?=
 =?us-ascii?Q?NqTNTj2NSTRCefA/eWJf2X7Zb5nmEVpzx8BH4nS9iGaLzr6A6256Q5wVrmRt?=
 =?us-ascii?Q?9o9C47pnI49BHS7xlwrj3rpDfxx3PIv/tbLkiG889ZGJUXbQp0EKG1BBU16O?=
 =?us-ascii?Q?z9MoH/v4J7A2doLjrTqQ6fM2iIkAjQoC7Z9mSuvjxGABN3mdQ5csHDh+tA1A?=
 =?us-ascii?Q?GJR64rz6IPgllnCSOfvuEn4E3BrcJu4YoHsVP7o5mSxpKyGidx2zfSb6xCRx?=
 =?us-ascii?Q?F5Tx40XjrMoK9ksrKLEj48ASHNJ8HRDRdk00lBpa71mMw5ED681oK5ZhEU3E?=
 =?us-ascii?Q?JOloi2erug1sGEszTaPE87tABHKQ37emA5NYf4FCjVpDjP3Vc+d2Qw7z68Jz?=
 =?us-ascii?Q?Hwubnl++j9Cm1pdIGnVgu30MI6hDeYbl++Z0fIzsCVe35jMAwMlqS51WHcOp?=
 =?us-ascii?Q?BezKQLSV/XTqZGMtyBx1RIkATcurg8Rcuh2GIBirg45KHJ1hctOEdA7nP9tP?=
 =?us-ascii?Q?9nI2sio1t1Vj337FQIJQFzvhnanBziuy0MWhiSiPJykJx/Y1c0vxDH9a37o6?=
 =?us-ascii?Q?eE+RgiU1m6J8pm/C/MgSL/gIQvV2BENM43BWOELp4Q83slqAYwGNWIOQZfLW?=
 =?us-ascii?Q?F+m8fZ+rFhJIGUo4bbno7dDZRh2evqcIoxia0de8rOHDkKrEgXRCTQs7Ykg?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tGmZfF/ZeBXilpNjiSckwO3k8oZdGeaC68BXHs1uO+4ewN2lgCaKjfu75m7A?=
 =?us-ascii?Q?8HI7EnNeQJN+Qfsx/UqLUF0iyxlIwQSoSPlgoPqAOA9XKgAqconYJme5JaIM?=
 =?us-ascii?Q?kcujFeCd+/9QP5mKkBQH4LGpfxNgkOJp0s67y5ApsTUg0JQyFHCQ4wPrkSJ/?=
 =?us-ascii?Q?/AqFi8rhCYY10DTlAW63VlXJWdp71hab9fVCRrc/fCgW3iRpM33gfcbH8vqq?=
 =?us-ascii?Q?yv47gomO9Ny/Jdz5OBw77zgR4Lrhy85zouD1EV7gH5bSGPB5HTMG7+S1F0ZU?=
 =?us-ascii?Q?L+QFW69+rGkpX9s1W3VMxILPvbUlt7toOfZaP6V6FKplM3J/GhDngztNJEhJ?=
 =?us-ascii?Q?iWnNX5hNmXK8J6im0/G5uzufpv2lMArV6Z8c/0QU10BApM+oE6NUbp5nwRmI?=
 =?us-ascii?Q?2FmxjEaSzgDzHxSbZwgG/etsYO8BrIW0s8hkPhLCspalE5bOKEKCxQNr4M9r?=
 =?us-ascii?Q?rOl9kpynAURhg2zkNkmiBNBpppkf+uJOipXG/JK7ZlByivzBkcwkSPPcPsw/?=
 =?us-ascii?Q?5tr+lnk5MC1M5iRMWsxSv8X8o+DI3w5e+NRpWPqG4hDU8Pia/DCM1LSiXkBy?=
 =?us-ascii?Q?15kAhOFUOxWTiL0KCJcuPDCJVa2LLCUzCf29KL1+EZT6xborB2qHrFRN3U/f?=
 =?us-ascii?Q?IbVTObJTydA+NCc8PTLa08/SSTMr5FHRO8VsGOFlJ8oRkzTZlaw9x17EoGlz?=
 =?us-ascii?Q?0HdTpHjSJUDBFQflukt1Fz0LiSAXyczmBMnVW/7uHjQal0eAZOp895ZQpL0l?=
 =?us-ascii?Q?r3vLF56m9FxcgWicmM/mjmmnc9kDVBAqYWFqnJGonbK4F8RUBLBGe7fIgMYR?=
 =?us-ascii?Q?f7z26BEJeWfxAw3PvP8uD0DlUIgjEmEz/434QcgrjMWuUYqJ00aJxsFPUaqa?=
 =?us-ascii?Q?vxoJ9AHPRRgJfa6rJTRBsa9ZfJUSrVTc9Giedzpr11VQojQN4yleqKAQhokM?=
 =?us-ascii?Q?yYy2XALzWpzbREVk1/5iG88UKnc3pJ02qqy8KjNxWjC7ePM4Ajw4DTwj8fkd?=
 =?us-ascii?Q?OZ2O9rpwu/gH23Rmjm585/SSdxhXBGsDWDakSUTULl66IhZlSQXzr9O9rkit?=
 =?us-ascii?Q?Is2Wq15+ryTTD+UPzPWml7rdJvdlhLAeYd2XE0+TL1TUtrbtzDnHhNOU7u33?=
 =?us-ascii?Q?e0tEMEqPGycrhPp0fgGRvLG3k8JVagxZ2RimgWhC+mrrIsQmwHv1S8Z/7pP8?=
 =?us-ascii?Q?k8jWVrZmrRekHcxAObbGZSyuDfGQMihlZLt3ecYwx0vtobDxlx/nse8m9zPs?=
 =?us-ascii?Q?6snNqmLc7lDgulwnvnQ8lDXsatmY/I88lfuOKOMIoxbRdH9fctSmfo/pPfuN?=
 =?us-ascii?Q?d627HNE+cPEr4Dh7z2KFjbZkdCDJna5jCSA2HTFd9r5fz5/B1GuQIcdiFSoe?=
 =?us-ascii?Q?5Yo5QMJSMUeBrmyUAIQGzifs3X2kEjtYNWW11/bpj7EnEWmllk79BV5tZ+rB?=
 =?us-ascii?Q?W9Z9+LsxtHxMbhZ/oDYFT0tuZe5fNqO+/AMrSSV1qGT/4DXonC0fPUa4a61j?=
 =?us-ascii?Q?+sOGVdM2dcLhLCIAiW+4xc+P3d3nbyBz4Dq2tJAyGlqZAQ5IeSr9vZuTuMOH?=
 =?us-ascii?Q?Ktp8xqPo+178sDDjhs9BUdWtU8pO4FIK1h+jLgBS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 975e7848-693f-4715-b034-08dc72f72ae9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 02:48:28.3928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bHjNYcoE0Tzj1HIC/vhxmVPJAN6gzwqtnMwy6Hv9kxbD5+n3BDjLVer0ggrf01V0cowFaP88upJl8Px9JwDvhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8049
X-OriginatorOrg: intel.com

On Mon, May 13, 2024 at 10:00:35AM +0800, Tao Su wrote:
>On Mon, May 13, 2024 at 09:44:32AM +0800, Chao Gao wrote:
>> On Fri, May 10, 2024 at 10:03:46AM +0800, Tao Su wrote:
>> >Use the max mappable GPA via GuestPhysBits advertised by KVM to calculate
>> >max_gfn. Currently some selftests (e.g. access_tracking_perf_test,
>> >dirty_log_test...) add RAM regions close to max_gfn, so guest may access
>> >GPA beyond its mappable range and cause infinite loop.
>> >
>> >Adjust max_gfn in vm_compute_max_gfn() since x86 selftests already
>> >overrides vm_compute_max_gfn() specifically to deal with goofy edge cases.
>> >
>> >Signed-off-by: Tao Su <tao1.su@linux.intel.com>
>> >Tested-by: Yi Lai <yi1.lai@intel.com>
>> >---
>> >This patch is based on https://github.com/kvm-x86/linux/commit/b628cb523c65
>> >
>> >Changelog:
>> >v1 -> v2:
>> > - Only adjust vm->max_gfn in vm_compute_max_gfn()
>> > - Add Yi Lai's Tested-by
>> >
>> >v1: https://lore.kernel.org/all/20240508064205.15301-1-tao1.su@linux.intel.com/
>> >---
>> > tools/testing/selftests/kvm/include/x86_64/processor.h |  1 +
>> > tools/testing/selftests/kvm/lib/x86_64/processor.c     | 10 ++++++++--
>> > 2 files changed, 9 insertions(+), 2 deletions(-)
>> >
>> >diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> >index 81ce37ec407d..ff99f66d81a0 100644
>> >--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
>> >+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> >@@ -282,6 +282,7 @@ struct kvm_x86_cpu_property {
>> > #define X86_PROPERTY_MAX_EXT_LEAF		KVM_X86_CPU_PROPERTY(0x80000000, 0, EAX, 0, 31)
>> > #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
>> > #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
>> >+#define X86_PROPERTY_MAX_GUEST_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 16, 23)
>> > #define X86_PROPERTY_SEV_C_BIT			KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
>> > #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
>> > 
>> >diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
>> >index 74a4c736c9ae..aa9966ead543 100644
>> >--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
>> >+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
>> >@@ -1293,10 +1293,16 @@ const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
>> > unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
>> > {
>> > 	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
>> >-	unsigned long ht_gfn, max_gfn, max_pfn;
>> >+	unsigned long ht_gfn, max_gfn, max_pfn, max_bits = 0;
>> 
>> nit: max_bits has only 8 bits. so max_bits should be uint8_t.
>
>Because vm->pa_bits is unsigned int, I'm worried that the compiler will
>complain on stricter compilation, what do you think?

@maxphyaddr (right below) is in the same situation.

And if it was a problem for the compiler, casting vm->page_shift to uint8_t
explicitly would be a better solution.

>
>> 
>> > 	uint8_t maxphyaddr;
>> > 
>> >-	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
>> >+	if (kvm_cpu_has_p(X86_PROPERTY_MAX_GUEST_PHY_ADDR))
>> >+		max_bits = kvm_cpu_property(X86_PROPERTY_MAX_GUEST_PHY_ADDR);
>> >+
>> >+	if (!max_bits)
>> >+		max_bits = vm->pa_bits;
>> >+
>> >+	max_gfn = (1ULL << (max_bits - vm->page_shift)) - 1;
>> > 
>> > 	/* Avoid reserved HyperTransport region on AMD processors.  */
>> > 	if (!host_cpu_is_amd)
>> >
>> >base-commit: 448b3fe5a0eab5b625a7e15c67c7972169e47ff8
>> >-- 
>> >2.34.1
>> >

