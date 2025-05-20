Return-Path: <kvm+bounces-47099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CBC3ABD44C
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:14:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 015803AA798
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B1326A1D0;
	Tue, 20 May 2025 10:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MH2W2gQ9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6649F1DA61B;
	Tue, 20 May 2025 10:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747736060; cv=fail; b=eKPFuNZz5xH8bBlTDZinvLajGyWgfyzdiiYtwtN7hBzZeS1wIKmtNA4OBYaAs1676DR8pqagqOGzgcq6+VHbDDA8A74H50E3BtEUxFC/OuTyQQDYKaKPrz575VjfBP1ZrXRwexhqxNr753wB0cDFiNhVhJuLTlOXzVPEX1aiU0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747736060; c=relaxed/simple;
	bh=6Fm8ZpPgw0COcxjyDUabdLXG+8G1Re0g4LWV1aso7JA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gXfxQC/oU+KHdSWSclijiygtkW3IPBoj/IZ5qr33Z98mcODSz5orGjsmQGts4nj9HMig9svoJjDfs3GhgbxqcfLVZapylcKL601jrOum+O/DYefgN/Eh3fc/OBVlT8DTEu/596+yPLDI0LTE3/nZJC4BRPeZMimVqi420wPm0yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MH2W2gQ9; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747736059; x=1779272059;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=6Fm8ZpPgw0COcxjyDUabdLXG+8G1Re0g4LWV1aso7JA=;
  b=MH2W2gQ9LMYeiwJtHaul9L2em6GKvmvScSqUTjbJuz+ClP30D9KUHgHv
   EW1AajCjngPAAkRmspL895hRgMfxgWzIXCpIzaUBeC41LE2oRVl1Hd1S0
   82VESPvKH2Tgb17hoP7K7J/B07wsmCNfAPc0Ny8PCwFjH1sV+wqooIx6B
   0z4koR0rHIYJDNrvHF0mS5gJbL5bTQExM8/edPhdaBNaMLGTL66rCrkSW
   JFOMnpKKOWOke7skeGMhaXFAF0BhiQQEKsJmfqf4CHHsz80bALaHjoo7g
   5ZOmDBngN2nqzO6PwVcylKjJrS86rLEHpDvXolxO8OIhkv0DkzLatvY6g
   A==;
X-CSE-ConnectionGUID: 4jbDPHFtQy+sfGXA2BkCiA==
X-CSE-MsgGUID: afdONMlRRvKQGxge6+YJww==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="61055720"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="61055720"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:14:15 -0700
X-CSE-ConnectionGUID: gCvcgF77TLOCgfd8AlDZlA==
X-CSE-MsgGUID: +GOjjg+WR0KxgmMQ9oQ3hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="170536290"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:14:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 03:14:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 03:14:15 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 03:14:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xBjbN8FUnrLdPtqFGhwLXRg4WK2cD4JWQ5y8i2zKij4e43pOCduHbwQbjw+6+8zcnQOfknITIXmphYdmnGDzZlf6xilHO5cXFYH1fUEr66rtv6XN6iQ+ZKLRvntJxmxc1CzpZAX2AAXLfrWBWZvIM5V8jbZmscqua5OK//TrofvYFJwz99bDpHG7srONLT4mikWoa8Hmu1yRvgPvCQnskdK3moV/zNGJ04My+TCG2oXFIMUuln/ZdvCE3QC9S6pm+sZ7qpd6XLef3BQ8miF0Wv6sYi5MhvJDx40iRZt0RExppbyKsym+smP/tHSbYDAFeITiLoAYBAqNPJRgreJ7bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VzoJar9kpEAarJ9ik6atBIaRCy8+UnzXYfaodSTxKio=;
 b=j44QESH21Mzd79P+mR/0B2Et7eIgWBoLS9muck80whJ5kqo+Yv39+SS8/xFbtYEe6mzdDwA3MDNMgO/sDgCBiYguZ+aHfIIbXUvW5qAbyRJ7/pCXxTVOWdAJDG8dOf3xX4A7DTQXKWYLg/Gmx+prWDRM74oMoh4auKntqcN8ZhAqj2vG0uOyEJrfzvVRSX90QYJQKEgCXvFwgZgnhKNd9QPTKC2rUPvQ9CeYjvjfropC1gdCXCj3V+EUFALJajo9Qsy9rPgVbUHwcIYHBktfRKGp+kHeL6BFi/3pRgEd+MkqhJjN3mJeHuEnPGTHDMsgWoV+1FVdx4pLBIwcCLp9aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7042.namprd11.prod.outlook.com (2603:10b6:806:299::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.32; Tue, 20 May 2025 10:14:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 10:14:10 +0000
Date: Tue, 20 May 2025 18:11:58 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "ackerleytng@google.com" <ackerleytng@google.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 10/21] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
Message-ID: <aCxVbq9KqAMInXNo@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030634.369-1-yan.y.zhao@intel.com>
 <9d18a0edab6e25bf785fd3132bc5f345493a6649.camel@intel.com>
 <aCa4jyAeZ9gFQUUQ@yzhao56-desk.sh.intel.com>
 <20fd95c417229018a8dfb8f3a50ba6a3bcf53e6c.camel@intel.com>
 <aCqsDW6bDlM6yOtP@yzhao56-desk.sh.intel.com>
 <eea0bf7925c3b9c16573be8e144ddcc77b54cc92.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eea0bf7925c3b9c16573be8e144ddcc77b54cc92.camel@intel.com>
X-ClientProxiedBy: SG2PR03CA0100.apcprd03.prod.outlook.com
 (2603:1096:4:7c::28) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7042:EE_
X-MS-Office365-Filtering-Correlation-Id: f9ae32eb-f345-4b0e-4fd8-08dd9787103f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?3EF24WXP7FcpEthSz4ijzfN44gPa+nMiaReAd/DnYrRMF90kPvq7NrOJL2?=
 =?iso-8859-1?Q?GABo5wk83Uj7xwTkz5Zdz77js+pZJaPf8FIw4p7Ai+cxPemO891BiIbPEd?=
 =?iso-8859-1?Q?BTdN7SGv5SsTeAw64H7Pivibkt2Jpfu8GmmHWarBpm8PPMBqROYdQfMZEX?=
 =?iso-8859-1?Q?j5fzYA50VW6Wsck45wpDn68l87o4ZxmMB8BM79sLDNEUwYjGiAXNbrRulz?=
 =?iso-8859-1?Q?1jOSh9/SI1S/+5EB1YqubF774Kd47GdSL9XvGmJ8qxF1VXXIiDunnXJs5Q?=
 =?iso-8859-1?Q?KBZ2IYHzt2Kn7XKvARDMxlRKoA2rUmSUhzDHLIqYalxhnB19YJKiG2gj0F?=
 =?iso-8859-1?Q?4g6kvP40gqH1eiEsN2i3GIJx8aj71KubdX6ccSUFpRuSE8JtAQVF9bbOBI?=
 =?iso-8859-1?Q?/nDZrAR67KyZOhxMnUlG7ZzUfuegPOGdA3a+AWTaHLNbPEs0VWHutseS4Q?=
 =?iso-8859-1?Q?lR/dPzvyq1bpic8XlQWOYh8lIahoSGijEIJxjmX3BDRLmYK6TpE9dG8zlC?=
 =?iso-8859-1?Q?TwDuUWs4ARG3bkXDpI1XtsB0zwG96XJzKJYe/87vBQt3RGMfL9yMji/MSa?=
 =?iso-8859-1?Q?7n8MQZ8E+WRFX9XLFEtUAq9/21J1gccoCGYnh8bsnN/KLNpK4A7ZOVhbm3?=
 =?iso-8859-1?Q?z3G21imsRTv/8y/cuOSphk1Bium/rsf/U4dw9lQNoD39vF3CsJXtdKqa4t?=
 =?iso-8859-1?Q?KawHwblyWPvWyxLNhwwq6c4eFuzGCMHY0MD/Rb/ruXAs/tMd3c3bQvIO/N?=
 =?iso-8859-1?Q?5sFNC1EIFf8NJzB6pzHEau1ms8RBKZ44cxO2IGmvQJncThuTtAcJ2LZqmv?=
 =?iso-8859-1?Q?j/gfWQiWGfVFwP80zIe6gGzmkQ/ERZFLFayamvoeslJc+LpN0Ly/s9yMB/?=
 =?iso-8859-1?Q?g8SmzE+Bllevb0uqEA+VqjmrCX3AJ3dCeCCDm0dGME9+buCc7I7nqbcbQQ?=
 =?iso-8859-1?Q?lyTpngwmmOALXeXYcSuGiwHUILGw7cVfZFyiMzZHNTmE9/TGrEwF0un+Fn?=
 =?iso-8859-1?Q?AARQP3e8uSJHy4XEs9h99bqXO2+PSxB2Jh+50/27UvcwDVf+X9pox/BirF?=
 =?iso-8859-1?Q?gZEhEhq3LtKcSy1CeQqL8GBwNel7cJYrYiqa/YoCQ5YFM/Qusx5lB5ZD4a?=
 =?iso-8859-1?Q?8GefTfABk6d8YO9NJE7JclB/t4x9MVdafNYn+GHxkLy0GPfkc58JLaFwHm?=
 =?iso-8859-1?Q?EAd6YE5RjTjZt66B3JmZn2lszp08IgEiYnfS9bqkklZYdX21p5c72+ibGI?=
 =?iso-8859-1?Q?FvnS4kOH/NYPfCITOB2MpVZqiV3qu3z9HsgHa2pv6yVFZiBAISEU302/jc?=
 =?iso-8859-1?Q?JIQMr5LjDsvt/8TABZf/aqxQpS6jtjCNMYg/A5aO4Q3SpuQCYjKHcvKeVr?=
 =?iso-8859-1?Q?jAjpPkzmYdzEZn1eEPkj5VLLcjos7s3EQBG35KouorEXkdigDx+eE6dbvN?=
 =?iso-8859-1?Q?JtKaCIeE78xf6taxE5DG9q2wp5purW/JIdaDUUm7anmiFuzQSh0PyKHEO/?=
 =?iso-8859-1?Q?U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?4ECdq2T+pFN2Pm3jzB0EGldraxTLKGxDncILOMtaFp0LpvwZEr+HIfbJNG?=
 =?iso-8859-1?Q?wwVm/pe71VyeaBkPk6tYbvtJ+eVoSgo40ud8uzUnLgJfMlQQp+6z/ykho9?=
 =?iso-8859-1?Q?ibjKZjH01bkm8c0y4e3EnpqUTILSQBbP4M73M/kIlOsawAWeS0kVHSSuCP?=
 =?iso-8859-1?Q?lzuKDBGEhL1A8dcW/TscAUIFDdPHYQTRClyOia2ZAKYcsz7M2nzmvxZJlf?=
 =?iso-8859-1?Q?zNEczlQqRrKZ7cMCwOMMwP9yBfHACiYrgQid+/W3APQ6tNAUGwRhakEQkm?=
 =?iso-8859-1?Q?hjfYWch1YI2QSJilpTi4YUbakaadw4cvL2aQb6o/oBk1aefaqa11w3zX9U?=
 =?iso-8859-1?Q?H0HiHN9dFtccubZw45ue8qzVzos0xP7IwmKrbOoPdICi1I1HHwwlnnLGTa?=
 =?iso-8859-1?Q?d1eNwJTECmPA/xLEpngUo6h7WBoUeZ3ZFlkcqiDUWyNU0e/w+EQ5FzcUXJ?=
 =?iso-8859-1?Q?Nq67/Qk+h9OfHRDtI+HYNx0iRkbJyDk7kWZp7IuhXf1TJdfQddxTmA2PrP?=
 =?iso-8859-1?Q?uwvn0aexN179m3nB7MT4qwJdzV25EXJswtqgstHnW/WggTVXZ96VL5//9y?=
 =?iso-8859-1?Q?Q22pyIRV3LyqHn+7jlVV1Nn31+yriSNrSk+osH0vo4dtuyweL31vmjxNiP?=
 =?iso-8859-1?Q?7E0q7AfnfgTLb1tlQNXK+rMX42nM2AHkX7R6trvlj2pEgbOgjX9tpkGpHD?=
 =?iso-8859-1?Q?3eb/ZF3O04JOF2YEoUjanAkbg6XG+23wajCMZ2X7JxdzqlLcvFOCXgRTHj?=
 =?iso-8859-1?Q?CzE8R6et0EXGtky4n2tZiCxNIjFntiwbK59cqcuHeugDPbEYA/gHgiok9G?=
 =?iso-8859-1?Q?iSRf5kfQDlao7QDhJPmnNBqY0PDpNeskOw+zD4nJH4wUUuBlQAPL8miMhf?=
 =?iso-8859-1?Q?z9PjslfJZzXDJIB4OLwNi7kr7NOI40930IkGl1wiYr7Qquv48vw1+iG7k2?=
 =?iso-8859-1?Q?KLPNcNU4Ws/qjsaj9YceRdp3m/AY7V9tsi09/Hzq/BGYK/lraNi1XVmD77?=
 =?iso-8859-1?Q?i2Vv+LmvI8WLS8uPbR1QHS/ykohYkM2ipNNptSIyUe7+7kW1XCn3rqujBe?=
 =?iso-8859-1?Q?2ZlbdeDQhfNlmcDeOstsH/es/e2Nk5au6k4PiGElR2W2rlzH/4igrxxpXb?=
 =?iso-8859-1?Q?Sz6zzRuG5JHqnNz9gPXNxG0V/VHw/+saBNR7w/o4puV/uLLjIoeMhkWROl?=
 =?iso-8859-1?Q?mpTODkxAu5jUTZ/iWCcBzA3TFh0WE9fxiF6dUN3xLGSlF4NoN8Kg2IDelt?=
 =?iso-8859-1?Q?nsrn1v8yOtgiwnh9YArncLqOL4SOmQfRHwRwPntsWbSYHTdLCDhG0mnxG/?=
 =?iso-8859-1?Q?7w7O3HvhYn414Kv9e9Q3aVzmrqRsM4BwoLCmG86EWjF58nxIj2z8E+sPo5?=
 =?iso-8859-1?Q?n8EfwU1Gqf+6XSaIoo+GY6mYl6DKdiolGMG7Hq5QC87yNAUm5Htx1NKLqe?=
 =?iso-8859-1?Q?ozw91Wkv/VOw+ezREDmvjgACqO6VAVSrI17qAWpSZwLk7Bnuoycqg5fXIm?=
 =?iso-8859-1?Q?rlnp+rZyyJk1XFvquNzD1gXT3K7EpPehmlu7baHuErqvgNXXap9yykyXjX?=
 =?iso-8859-1?Q?BRUG9WFLQCGAQlnCRBRyLK7fkyJ3123qu2b/+mCzaMkS5sJvyI04RQ8W3r?=
 =?iso-8859-1?Q?tWLJhVBACHdQFNn0IsgsE9n2Wr7g1ibkLL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ae32eb-f345-4b0e-4fd8-08dd9787103f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 10:14:10.6929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WjvJBLlWHC431mpHqLumj+SoiyVz9PsdGxE4LhXaNOWJagwb/HiN5FgMNbIjnNDoK83bEqkaYXKovDMdRmT5kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7042
X-OriginatorOrg: intel.com

On Tue, May 20, 2025 at 01:42:20AM +0800, Edgecombe, Rick P wrote:
> On Mon, 2025-05-19 at 11:57 +0800, Yan Zhao wrote:
> > Like below?
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 1b2bacde009f..0e4a03f44036 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1275,6 +1275,11 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
> >         return 0;
> >  }
> > 
> > +static inline bool is_fault_disallow_huge_page_adust(struct kvm_page_fault *fault, bool is_mirror)
> > +{
> > +       return fault->nx_huge_page_workaround_enabled || is_mirror;
> > +}
> 
> Err, no. It doesn't seem worth it.
> 
> > +
> >  /*
> >   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
> >   * page tables and SPTEs to translate the faulting guest physical address.
> > @@ -1297,7 +1302,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >         for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
> >                 int r;
> > 
> > -               if (fault->nx_huge_page_workaround_enabled || is_mirror)
> > +               if (is_fault_disallow_huge_page_adust(fault, is_mirror))
> >                         disallowed_hugepage_adjust(fault, iter.old_spte, iter.level, is_mirror);
> > 
> >                 /*
> > 
> > 
> > 
> > > Also, why not check is_mirror_sp() in disallowed_hugepage_adjust() instead of
> > > passing in an is_mirror arg?
> > It's an optimization.
> 
> But disallowed_hugepage_adjust() is already checking the sp.
> 
> I think part of the thing that is bugging me is that
> nx_huge_page_workaround_enabled is not conceptually about whether the specific
> fault/level needs to disallow huge page adjustments, it's whether it needs to
> check if it does. Then disallowed_hugepage_adjust() does the actual specific
> checking. But for the mirror logic the check is the same for both. It's
> asymmetric with NX huge pages, and just sort of jammed in. It would be easier to
> follow if the kvm_tdp_mmu_map() conditional checked wither mirror TDP was
> "active", rather than the mirror role.
You are right. It looks clearer.

> > 
> > As is_mirror_sptep(iter->sptep) == is_mirror_sp(root), passing in is_mirror arg
> > can avoid checking mirror for each sp, which remains unchanged in a root.
> 
> Why not just this. It seems easier to comprehend to me. It does add a little bit
> of extra checking in the shared fault for TDX only. I think it's ok and better
> not to litter the generic MMU code.
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a284dce227a0..37ca77f2ee15 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3328,11 +3328,13 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu,
> struct kvm_page_fault *fault
>  
>  void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int
> cur_level)
>  {
> +       struct kvm_mmu_page * sp = spte_to_child_sp(spte);
if !is_shadow_present_pte(spte) or spte is an leaf entry, it's incorrect to
retrieve child sp. So, maybe

-           spte_to_child_sp(spte)->nx_huge_page_disallowed) {
+           (spte_to_child_sp(spte)->nx_huge_page_disallowed &&
+            is_mirror_sp(spte_to_child_sp(spte))) {

Other changes look good to me.

> +
>         if (cur_level > PG_LEVEL_4K &&
>             cur_level == fault->goal_level &&
>             is_shadow_present_pte(spte) &&
>             !is_large_pte(spte) &&
> -           spte_to_child_sp(spte)->nx_huge_page_disallowed) {
> +           (sp->nx_huge_page_disallowed || sp->role.is_mirror)) {
>                 /*
>                  * A small SPTE exists for this pfn, but FNAME(fetch),
>                  * direct_map(), or kvm_tdp_mmu_map() would like to create a
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 405874f4d088..1d22994576b5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1244,6 +1244,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct
> kvm_page_fault *fault)
>         struct tdp_iter iter;
>         struct kvm_mmu_page *sp;
>         int ret = RET_PF_RETRY;
> +       bool hugepage_adjust_disallowed = fault->nx_huge_page_workaround_enabled
> ||
> +                                         kvm_has_mirrored_tdp(kvm);
>  
>         kvm_mmu_hugepage_adjust(vcpu, fault);
>  
> @@ -1254,7 +1256,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct
> kvm_page_fault *fault)
>         for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
>                 int r;
>  
> -               if (fault->nx_huge_page_workaround_enabled)
> +               if (hugepage_adjust_disallowed)
>                         disallowed_hugepage_adjust(fault, iter.old_spte,
> iter.level);
>  
>                 /*
> 
>  
>                 /*
> 

