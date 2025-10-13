Return-Path: <kvm+bounces-59858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B89BD1009
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 02:47:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A48B1893A92
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 00:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB5C1DE2AD;
	Mon, 13 Oct 2025 00:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aKcUZYhD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F14288D2;
	Mon, 13 Oct 2025 00:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760316439; cv=fail; b=ddMkvQSXRaTN/cBCRtq101p9g59e11fH4pwpRzUVqmYg3TPROmsFCTK5Ftkq8KUSBM1cVaITYTMGwOxUhx1Mk8t/1tMUxV4y4CybPCStDQG0oWXJmljrps3mlkwZ0dv6IOZRtmLvUkPRy503tkx6+5BIqMAdC3ImlHji2bdwB4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760316439; c=relaxed/simple;
	bh=oV+8qiceTBwbP6WkZRaNzRPd2DyDPPC6KB0n368A3oU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XSfe33XCLhn9X8hKBOJpau0Kgs1UdQNrsWmSw9Qy4YAErXcgmwtjd9cKkr1nwepwLLk0kvWHO+OoLR6MVB0FuMdyyKbUEpFMZ1RCskA8cucTkjK+x98QQhJ3rrd9UfAYIpAD94+m/UlDszzEpODrNDMM8JnikOWBVlFAt2dBqjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aKcUZYhD; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760316437; x=1791852437;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=oV+8qiceTBwbP6WkZRaNzRPd2DyDPPC6KB0n368A3oU=;
  b=aKcUZYhDIoD/aa/AhBuwFTc7vlHO+vevEDipyWrLCsSl0nFUZ5af0pZ6
   MbulkjoVJpmXltdn7jzVGeRW8hfNh0wqHkMvOf4viNIW3FVnZTct+OlmG
   6IqNqPw3p7H0LmNlsuXy1vCgec3gWH/WEzwsR8rOIOTdphO776wxjQ1ap
   8+tMrC468vr6sOcxwbnZUCpE/0juCvM6Lvc2vSDYYMRTj/wpZWl86X49V
   62c1n5I2YkUMUTPzeYBtHsC26WkWHEofQ7diy/uHFkpbE5JWUTyveFku1
   OczeEk0rRmvH0fC8huT2KiFJn7RnfTkNss+aD03/41/1FsATMvXYIpSPE
   Q==;
X-CSE-ConnectionGUID: 450j6/LHSTyMhu5RphZzVQ==
X-CSE-MsgGUID: hnTYzvdtQDW/ioHy/skpyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11580"; a="61488570"
X-IronPort-AV: E=Sophos;i="6.19,224,1754982000"; 
   d="scan'208";a="61488570"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2025 17:47:17 -0700
X-CSE-ConnectionGUID: 2UOoUdD7Qyaj6tWf5kbmHg==
X-CSE-MsgGUID: Dq+2fFxfQte8gBOos7nF8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,224,1754982000"; 
   d="scan'208";a="218568842"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2025 17:47:15 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 12 Oct 2025 17:47:14 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 12 Oct 2025 17:47:14 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.47) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 12 Oct 2025 17:47:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GM6Iy7gdLMctemdmrPoiQcESZInj1eT6F6q2lQ2r737pzdR7mO2gNOV8RGYmkWANhUm8OoJIWDCUDtO8csNcpysjO/hdRvk13QkmHLNG1eNN9lYH8dSnvcUrIWfM0dvUbwKyBlrgOYpOvItQ9FX5BUnLHwP8nH3hGp+SuhyBp99yExoBhfrxqvru9x8arrWVLsXSbaVspAiJCi5zBPw0Ru+sk8+fQ7QOda5sgTqQR6L78b3Xf1dQtW0iZZlIPM3uM9BPZxgCyD/a9BP708SauKJkehrC30cMzyS1pjZ2dBnnw7NmZuKzH4csT2J8wy4YerlH4mpMWJGsRURB/mcI1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEJ5fwhwRN2eCG+UwLdKw/WcTG3VAxwk+1PN93mKX1U=;
 b=Jh9XS2kzj6Sz87rb7oFYGoTAD0ZXBJoLHAywJAMHjsGQfFEbuz8lLHSkHLQCNAf53snaz1YofveAt0v6o3jsNibmM1QE8LpvRo0NKILjQ80s7900/CPxaoPzo2fS4Zbsd+lhzk4r3OtdnyKoRD/FQ9mg3kPeiCIZ7c49namZwmzoQmHaj2ZtE9Af4KqzPSzSCPCwgYithjKPRsKENzk43w8Qd/0N2mIsdToBVT27uoY/AX6gmsQcWos0cd6dqdir8Ptxp6UAIvHvPYjBT4yfZZIzef3Wcn6PIBo2TuH+T90+Zzi1jAJEJtA5EfPSy5sDhhmMxpb13KLa8/GKewd2Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW3PR11MB4683.namprd11.prod.outlook.com (2603:10b6:303:5c::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.12; Mon, 13 Oct 2025 00:47:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 00:47:06 +0000
Date: Mon, 13 Oct 2025 08:45:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <quic_eberman@quicinc.com>, <michael.roth@amd.com>,
	<david@redhat.com>, <vannapurve@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 17/23] KVM: guest_memfd: Split for punch hole and
 private-to-shared conversion
Message-ID: <aOxLl90ndWP9AinU@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094503.4691-1-yan.y.zhao@intel.com>
 <diqzecrn2gru.fsf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzecrn2gru.fsf@google.com>
X-ClientProxiedBy: SG2PR04CA0208.apcprd04.prod.outlook.com
 (2603:1096:4:187::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW3PR11MB4683:EE_
X-MS-Office365-Filtering-Correlation-Id: 355f3765-0bce-41c3-d3d6-08de09f2082f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7ArHhwBmFSUVpqf1/gtNNjcylmSqDBbiXMO/DLGOhypI/TTePkuLEEsy32hN?=
 =?us-ascii?Q?jj5tUi5vP38zhSeb46uWumh7/F0Vx54ymXdzlq0t9jRNhp+wsHLRtRVb/Seu?=
 =?us-ascii?Q?X/eb6ZQga6L6Q1Yrysz2mxiau/xc4j+jK+GXwC42tzYN5gLTMwR9FJ9wgGXC?=
 =?us-ascii?Q?oc6Iy6K+6Ye5v3agNz5xg3dqCyz5hpcY1wby+9lPYIS9K6OK4DSdT6Zqi43H?=
 =?us-ascii?Q?Bmc5nnYU9DdEs2CebD4++PmGxJtoGgCZZi5TbKEgrg8c1b/EJooLXgBJQEf/?=
 =?us-ascii?Q?ebICIujhGeQFeM83Af3VhwtXzuUFnKXQHDbJDt5A7LT+oxZp1P/dIuckdr3S?=
 =?us-ascii?Q?BRXxT6dgt0Nw4U0Sh8oD5JhodzteE+IGLluc7W/YTFXhqp5MuweSDxl059V4?=
 =?us-ascii?Q?PHI0nmJMp+07IqVzYYjDtDOGqMfl5fh4phCjZxNXllvj+BUYMi7oRN7XYRiY?=
 =?us-ascii?Q?wDPJg3GniwskNHwLRV2n6q9XqutxRkXPTDLmnunPhA3pfcoOU8zx4U0dlPDJ?=
 =?us-ascii?Q?2C5MqWmhL501hlpr6B7Enm3GdmFKNqR1yHOx9jsdsJTXRgGgDJltnlHOnBaE?=
 =?us-ascii?Q?1UFkx3sflFUXWtOH8dLr6sU6G416z6ETg5QsJDaIhgPdZ9xaZr9b746GTSWY?=
 =?us-ascii?Q?H7wiNfleVpYYlC5ITUgN6QPA1yqMHieNrT0iLvkeEPpVGnXT0xO1e0HA8g09?=
 =?us-ascii?Q?AUwGzbEAOUKoeTAycYfzWLpjFSPtGXL27AB/Ee8/D5mXRAAbvm9ACa5Wgdld?=
 =?us-ascii?Q?jGXpXczSxCcDxScc/Z265HLiJdDNCcZwmGVBMcs+1EPRfwWxlj1ACN2TSIGN?=
 =?us-ascii?Q?YjpODneLdcYDmBeyofUIHikcMHmgdA6PJhYx5adYZ3XtBC9UgviE303zAN3N?=
 =?us-ascii?Q?7rryJyUjdBPtHvKUrIy4ddN7Pl5HCh5U8ILABpLPz6LnwXkA8FeSCPrrjxyZ?=
 =?us-ascii?Q?CXyoc8fDqnGgv+i3MXwJ2gK8H56R4sFVFnLZE0cYJkJkwTpVSzHCVa93cseC?=
 =?us-ascii?Q?JepBufK66YMOj3/ECj2eVeOOv0IGI44al3sYnhFqzJMjThnv7qT+6AZ+KWMW?=
 =?us-ascii?Q?4gbU8pYtE8jtDxQc2zgkGnRXSYguEOATt7X3m29a68kRGezV5YmpYg5SUcaW?=
 =?us-ascii?Q?ewlePoSe+Oci8xfqaEbjG3BOh2E6O+XTfVNbajtyK5sQDpircPFCoxLEcKKe?=
 =?us-ascii?Q?gZIgJaaJvKjoGY2Y/Bcp9re+yll9PnYtl0X34M+z4Z+hF65Wj2Xh9YHkC8qe?=
 =?us-ascii?Q?9V3SyyLZZNU06uE6blWyu8bgYlbGnp3smC1n3QhCxvC71DLxyQEuVckhCRTH?=
 =?us-ascii?Q?tWSqWec+G8PXqLcfXh5DvsidhPIYNtBpQDgr6DaWRy8u4QIY/cZFhOaxDk3J?=
 =?us-ascii?Q?b91mqtRrVP3ecRzsttbGtgLbl64+Gb7whArVZdUSzt8sqe3kqfJ1jorKMQ2v?=
 =?us-ascii?Q?F7ZP0hrJ49HDNFqwzZ06iRG1WsySbx2c?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XghgdHZfvclrVQ0IcA9X7WtLQ7dVa+qxLhBwYvApwBFBrA5jefPHnmSjCQj4?=
 =?us-ascii?Q?beb5PSmLitRUOn2dJGQrlEskdbKbshrFcM5MW+4BAHMuOy8RxPmjn9H6RRM7?=
 =?us-ascii?Q?qdBehy3jnw/BxLz/PV2UT1he+p8CDw+ZCy/HWxKE7pMIXI2jvw8GwRMDlqSF?=
 =?us-ascii?Q?MT2ANuJRUry1hbHbTPUFOAe11ITbcXr8+VWy7MtwLInZAa0ZprLZ+oQcnvJa?=
 =?us-ascii?Q?TCp/pIpVze4d58r2O3U+BpqX+hgtvCT3rAayQnOQAwr67+Hxgtb8QBPCGw04?=
 =?us-ascii?Q?AKfVO2EQGyr16XLb9J7y0Fp5RnhXB1oglkwsvpCmB80FyGKODy+GFpo+X5h8?=
 =?us-ascii?Q?QzBSBP24PL0nolqOAzScKN82BYBFDSmjPW2YPSPdfSyhWnbkbN6liqyZH60h?=
 =?us-ascii?Q?4rqFBRpeCfrWd7rf+3C2mquKs74FiacbhDZCzGy0p72FJ7XX65BeXLO+yOTC?=
 =?us-ascii?Q?Ck1Hy8KBt2IlQ7WfKAgHQ9/aWSkfDKACUTy5Rt9t2sxGYZlLs1DcrKpB5dXl?=
 =?us-ascii?Q?gQXnux+8teXceTSGLmXnLKApB2xp8O6xHQqY84cvyRXSrqZRlw0xgo8hPAGN?=
 =?us-ascii?Q?VmOKnmiFD2s0dRIVFwu+2K2MjsP2O3gHEsKRuZAvQc256F257emiPU0zrBbw?=
 =?us-ascii?Q?sZhu24ozutNCw4WCkdsYu9xH8y1/cIwmIgP/N5rYYFp06ibxWuDLzr1Ab8Yh?=
 =?us-ascii?Q?wgxFNrxlsOMQK9eL5tDs/pj/ITjn3rufjyIkEAXgnv/kq1WUhtUV5oEVVU/i?=
 =?us-ascii?Q?vqs8Ix2rzFB8i2Pplg325TwYHsEZMyRqzWF4+jUsg3MAe4v29+0MPYUKZE8h?=
 =?us-ascii?Q?Ub3hyT3WbFWvRN/eVFzejIkta67v+pbSMwkS9cHMM+uV8Tv9G7NH1OQAjg5U?=
 =?us-ascii?Q?VsNuPsmRDMO+AUoch9Da6SkM6l15BSq9v/gjFFNf5j+ki8BzK3Ea4R/135SY?=
 =?us-ascii?Q?uC+zgqI0DzUwPghEXXB3nD2aZZzMimDORBxrCiOSNERlLdIqDXLOrE0EpThs?=
 =?us-ascii?Q?Z2GuZCXImZKLZ95OWhWtrqpn2otmGSy+Y0orqkpB49UKkDoeZIfC8oN7TFJU?=
 =?us-ascii?Q?+yjq7SboJaMIYHEWwtUUAI36VdhS7Wuy1FLRcmXH37t9ceuuA6MolrzXMhaz?=
 =?us-ascii?Q?4bx9YpiuCcLhcCTPlWPmEv6M7iu8gWF0MpZMcNMuLqSEX5ZHMTfMifxTcGJW?=
 =?us-ascii?Q?VIXdXfazzazscXTVjXTyIKNELwDxjHzIZBbmyPmxm107ayMETnhMbznhQ+Ni?=
 =?us-ascii?Q?50xGVf03OU9zJS2chXUTO5VPdw23eOruerhY5ttVuBI1QVKZ5zwVEBVEYQOw?=
 =?us-ascii?Q?c5LxJdi1rdxCm0gD+BIXHM/qRHBzW7i6gl4MPLGtFmEkkL9WqertvMozIY6N?=
 =?us-ascii?Q?CZIfw8Dlty+XNm5TP6QkOtwLrVtyfTaKpsUs7jF2qM8u89uE1ZfwAG/zt5CB?=
 =?us-ascii?Q?AbnZ7UVFQOBtI5a0xNDulrayg3+8lEfYcw9O9jDyRqO1+Qd3FhOZNnhS1W7W?=
 =?us-ascii?Q?X86mTUbf8XIXm0edUYmPzATAV59Bukpg7rvEKOMOEYClSnPPkugGONzCQ6hW?=
 =?us-ascii?Q?vu44Nt+T+3BJhxdMrAhvmzNsPtNDa7+wEqQMl+lp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 355f3765-0bce-41c3-d3d6-08de09f2082f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 00:47:05.9187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPPHKYnlGfQnLcqEK6ZbdFq8G3oSsXcoHmc6iliy34qUaUSHLaV0vuSEU8udgxakRD/7S4hLrkFTMplulS5MHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4683
X-OriginatorOrg: intel.com

On Wed, Oct 01, 2025 at 08:00:21AM +0000, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> I was looking deeper into this patch since on my WIP tree I already had
> the invalidate and zap steps separated out and had to do more to rebase
> this patch :)
> 
> > In TDX, private page tables require precise zapping because faulting back
> > the zapped mappings necessitates the guest's re-acceptance.
> 
> I feel that this statement could be better phrased because all zapped
> mappings require re-acceptance, not just anything related to precise
> zapping. Would this be better:
> 
>     On private-to-shared conversions, page table entries must be zapped
>     from the Secure EPTs. Any pages mapped into Secure EPTs must be
>     accepted by the guest before they are used.
> 
>     Hence, care must be taken to only precisely zap ranges requested for
>     private-to-shared conversion, since the guest is only prepared to
>     re-accept precisely the ranges it requested for conversion.
> 
>     The guest may request to convert ranges not aligned with private
>     page table entry boundaries. To precisely zap these ranges, huge
>     leaves that span the boundaries of the requested ranges must be
>     split into smaller leaves, so that the split, smaller leaves now
>     align with the requested range for zapping.
LGTM. Thanks!

> > Therefore,
> > before performing a zap for hole punching and private-to-shared
> > conversions, huge leafs that cross the boundary of the zapping GFN range in
> > the mirror page table must be split.
> >
> > Splitting may result in an error. If this happens, hole punching and
> > private-to-shared conversion should bail out early and return an error to
> > userspace.
> >
> > Splitting is not necessary for kvm_gmem_release() since the entire page
> > table is being zapped, nor for kvm_gmem_error_folio() as an SPTE must not
> > map more than one physical folio.
> >
> 
> I think splitting is not necessary as long as aligned page table entries
> are zapped. Splitting is also not necessary if the entire page table is
> zapped but that's a superset of zapping aligned page table
> entries. (Probably just a typo on your side.) Here's my attempt at
what is the typo you are referring to?

> rephrasing this:
> 
>     Splitting is not necessary for the cases where only aligned page
>     table entries are zapped, such as during kvm_gmem_release() where
By "page table entries", you mean SPTEs, i.e., entries in the secondary MMU,
right?

>     the entire guest_memfd worth of memory is zapped, nor for
>     truncation, where truncation of pages within a huge folio is not
>     allowed.
I think that "splitting is not required for truncation" is valid only based on
KVM's implementation where "an SPTE must not map more than one physical folio".
i.e., the SPTE entry size is <= folio size.

If KVM were implemented differently where one SPTE could cover multiple folios
(similar to IOMMU SLTP entries for shared memory, though this is unlikely to
happen), splitting would still be required before truncation.

