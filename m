Return-Path: <kvm+bounces-36643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E87C5A1D34C
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 10:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 993A37A12BF
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 09:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F016C1FECCD;
	Mon, 27 Jan 2025 09:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C5h5Jv1u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A791FDA66;
	Mon, 27 Jan 2025 09:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737969914; cv=fail; b=W5XTbdfYd7kj/juzN8fTp7UZJjkJ+eExeipbY+s1rQl/lAk9Df5DRQ1Eu07tuE97F/r6mxfCLSnX9XAbwPstBQXA7FGDZZuZrEMbOoji9neB7EkN7GZZKYYoxIzZ/3c6CoJLnw1f6ySM0WYJ6uMjx03/Q+xtK7cjK1V3wORVuYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737969914; c=relaxed/simple;
	bh=hDmeIRdSQudd55E05vWz79fMXN10UPEgiz83G5gV0Eo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=seUoCX9XOKyVE7kwxrSDP54d+jt1GMMTiP6Z8ARf+dVng0NiiKCaqKXT52pTy89d5O+nuOEOt8r+gDeaehPagk+AwWFaBgbQv3uOqKLdvAp5+TiZA/qQ2Q0NZ2RMRHG+Bc3E/o3TXlYZbtnPk3A5ak+w5Rtu+SfjymJCFfuY4aI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C5h5Jv1u; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737969912; x=1769505912;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=hDmeIRdSQudd55E05vWz79fMXN10UPEgiz83G5gV0Eo=;
  b=C5h5Jv1uT8RhqgPb75j0fr5xAh9hPKxsoh4E+euD/fogz5gkqF0n2EQJ
   xdUYyZvHDELi8p9LMo+wToMCsmbhhIrocsJnXvHNNdvEJGS5e3AcM2TFJ
   kHukELusVQ6HP+MHOoVDNsOHG4mQ33u1c5IzHYwpxC1rxsRIE7cuaVjrB
   TIhcJ4vP5bVma60ZnQbwWTU1dn2Ziy2GeJa5ssZyKBfkvjjBcS2/37QdC
   lHyKxZtavvyAKHWrg4z+0Mv04wddvmuKkwvKj8l2LUNN5UYm01796FqiI
   4qxhrme6UuvEbRZnda2+GCbFc6MuPlMuiGHweRV7pvLQfz3XdIpYFds88
   w==;
X-CSE-ConnectionGUID: EGuxu30kQ8i6+arJtTYQMw==
X-CSE-MsgGUID: 6aCbf4ZlRnqrAjR6t6WGGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11327"; a="38674119"
X-IronPort-AV: E=Sophos;i="6.13,237,1732608000"; 
   d="scan'208";a="38674119"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2025 01:25:11 -0800
X-CSE-ConnectionGUID: /K7EtOGxT7at0oKqMzED0A==
X-CSE-MsgGUID: tv5qRwQjRrywYQicCem5+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="113521103"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Jan 2025 01:25:11 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 27 Jan 2025 01:25:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 27 Jan 2025 01:25:10 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 27 Jan 2025 01:25:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KVFCSmra/kKse1D5h4Ocp/+sUu3wY6XY/MlBNoVgwSZ5YZi+GqIuSrycR/0KRPMFsOVTJp8BPtkm0mChE+JqkUt83LxA7xDUYXKY4zST+UTyRNvwQS1aGK+ViBI5IAvVouH1I/8M/Kpb/T7uxekC35RGW3o8mto8VIFJkHdz1mynaXJ1QflMkMcp5h2I12JVzeZ01WEBPPZNUDi6H37xHVC48K250IVp63FRj8/W0YSsZwiFRrNnOrCbMrqIrQmOIlGeoEiwznlhLy0H5BXT+So/NToEWWjdOaWF4yo6gljOXqZW5eFDubqqgf3dgwBWzysEE10IU2Vc+8cGOifXiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5F3ibE0rQxbH7DQK6/7BuxrBkPFAeDpysWm2nURtkLs=;
 b=nLVjBGnvmU/osI51qF0g/RYFIRSJMZ+HDwUaaGkVcG61zFWwHgz4liEiF2ndg382euEKePiH4BIZ5G2yrBXGx50a0vhIiJVWUm3BJcUfnu13D5AcX4lNkvMO2psxxPLuQBomsdhxYfqu5j215SYCW2zYKA1nDLMVZlvZRzwYJ724BVqTRBGUc672CEfqjsirsdJLr+NVGR2RsqhvDQh+UO2topQbcFde9GpdfTY+xlRdEful29lsjeAIhF2Rox+M8vJoXUXKW6J16DVG58DPxjAvtbkuMfG5Lfp9BfoD9kXt3UBamfOzk3k+QbCXSY4SxvtY+x1CnNFiyvBniksWcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB8163.namprd11.prod.outlook.com (2603:10b6:8:165::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.22; Mon, 27 Jan 2025 09:25:09 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 09:25:09 +0000
Date: Mon, 27 Jan 2025 17:24:06 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 3/7] KVM: TDX: Retry locally in TDX EPT violation handler
 on RET_PF_RETRY
Message-ID: <Z5dQtuVO2mQfusOY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
 <20250113021218.18922-1-yan.y.zhao@intel.com>
 <Z4rIGv4E7Jdmhl8P@google.com>
 <Z44DsmpFVZs3kxfE@yzhao56-desk.sh.intel.com>
 <Z5Q9GNdCpSmuWSeZ@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z5Q9GNdCpSmuWSeZ@google.com>
X-ClientProxiedBy: KL1PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::36) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB8163:EE_
X-MS-Office365-Filtering-Correlation-Id: e8408666-452c-44d6-e9cb-08dd3eb47e20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?IVq02k/8WxHZVTO8k44cPGKU4KAJmwT+YI6QVETbCRSEBBhSSWNoS0iwdxlY?=
 =?us-ascii?Q?ROkNro0pwZCn89EffaEb454v1v51DvOc4nXmWzNk05L3Vtwv3LCNZhVa6LOL?=
 =?us-ascii?Q?EoAlccP91draeSV7SZ4PXNRtnOFunxsYSAVlpa75sRt5eLJhkgQhGI58yjLa?=
 =?us-ascii?Q?PlW97xch/2/Z7o7osal9SIfP4bcWdNUWb8l97cJBjm6niRbaqvnRQch18a4d?=
 =?us-ascii?Q?JQlAOJSsvGn6Fv7IIzk3Pbwpq/VaG7t2vvbpwgtG/sOjXYYV8PpW2SJVc45S?=
 =?us-ascii?Q?KLtWb9CnDKcIVndZxLRSFbZx+wVweszDuS9udDesSGzccvdyHqKjBjORpfv/?=
 =?us-ascii?Q?XkqjrirgHGXsxPs7+/uJy/1JHgSS43xgRI0TzVkqDRDt1r7a5dxFjGSdVdIn?=
 =?us-ascii?Q?xNZ6Zfpu4798r5mWsI6KukD5uLsVikI3QQFNMPZ8Vl8x9Pr0S+ila9bql4Ax?=
 =?us-ascii?Q?BCjKqp/IdVteMBS7Rbkk0AOQ5Y/RCoYq6O+0MHXt/PYENO4sZTnC3IFYqPEc?=
 =?us-ascii?Q?0c2BULRjutzmMtuqLruY5J5V2tWFKMf5/j4VpvHnnEUOG6aegmFLsHDLwhTf?=
 =?us-ascii?Q?1dM6VG584fuQqjG00P13UXs9cGhYl4Yw8wYLba29pHsjoG6D7q9ocTQaKoMc?=
 =?us-ascii?Q?3vnWud65PSw3fFtx9guUY+uv6hTslvPQkqR7pR77h4OUsRJNzPZCHWkIAlMj?=
 =?us-ascii?Q?WIf3YtyVkj/Xj6fA8NtiaU3EKjMYkoLSHsi6GV+8R7naGSRxa/cr29NBjy9k?=
 =?us-ascii?Q?ehNPPFeARh8AXLRDgh6iCKaf5bMuV7iKRKbe37R8j8wWkJLQlr3Yg8fPY2A2?=
 =?us-ascii?Q?vQTtii0tYKJz+n11Liv/pAsz9/eYZ239sRcHiys/O/b6SymuQAdo6vSDQb1Y?=
 =?us-ascii?Q?wyFHchoKE2wCXGnEybl2rpSJ5JDzRmaRc/DJ1T3KjksYk6TuBAC4qxDd6QEz?=
 =?us-ascii?Q?pnv96Ml0puNoGyLZpB9wdTMgTHg4IoWZJVXE37ZlGKUCLcyICuZywjzbd+17?=
 =?us-ascii?Q?n+AWwCAvg0y7VZfh3AQ4xw6GNIbXu+i4wnJefYaVkIQmF5H2mKUnvE732mpV?=
 =?us-ascii?Q?kDDaVI6IWtlkKt4EeJ5hgNUzpot5NNdUkPzvjb08lZAydkYcNElD3Ol+03lb?=
 =?us-ascii?Q?ZHBOlOnffSatk0DvNYO685vleYDm9SUJxPd3NCUsItF9ZOGVwLUhY8Rl2toL?=
 =?us-ascii?Q?3jNUXavr9i/Ku7uIcyOGOQ5sRp0kbwyUwg0Zi2yA+RiEixa3QRueRvp1HE3M?=
 =?us-ascii?Q?cs05L2QLzRjHG6PXRTgYzh6IFlt0gPbVbb8itCvG76GdS4DjtCKsmP2YIATQ?=
 =?us-ascii?Q?Ehiu5TXb/N7b7JHgnB7nZxKVQPrN7+3ABzgcDmpF255CPDrpejw6zxoIjpwa?=
 =?us-ascii?Q?rJvcukcol1UYfDmHOX8Io56FBNQG?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2q31/u1HdLPzEUu8eLb1RyrLRF/YQG3HAxn3oe5gqv9lLHrulFApeZNneOgM?=
 =?us-ascii?Q?NW8YpyBj4q9P2TPg3Uypdh/mgsTVqw+2DfgaXexcsSmLOyjP9aUkeCWVs9h6?=
 =?us-ascii?Q?ONoUzjHre5qe41L5jcTkMqcPeALd9GRbo3vzc0ewU3Yjcvv8+KNCiA1QkObb?=
 =?us-ascii?Q?+DN37aXyWsnzBf0QmkP8HjX+w5587e+ADXgGXJAlo1nAM2qXZFfDQnuU2b9K?=
 =?us-ascii?Q?oyXAvhodx0aDzH6DRdEARnv731xOJF2Z+qN+h8pcEyj59xOQSXBmovuMrh7G?=
 =?us-ascii?Q?+eTTxpOgmxlswi0jNivQNXp1670zKvRVvRQRCREbYDCVycRBdQDVRyYgnPTC?=
 =?us-ascii?Q?m78yaW8RT93qpbiIv44kkd12SWNIq3MX5C2T4ZRSS8V1Jd91G6ibhS2zsndR?=
 =?us-ascii?Q?HVOoEJeXQBRmZW1tAoqz9ZtcVH4uJpBLldislUyPT9BLNwiobfTeXaAUL8Tb?=
 =?us-ascii?Q?rfgWgKnqHIX3A5JbeF76+US5hIdvolr2/MtU493PFxVdr+2qhqjAQTvrq2Le?=
 =?us-ascii?Q?qjhsj6Eqv435T8PDHPJHY83yQO57kCXJy7h1hdw8AoW1WAiM4EHZ90xAl4Lj?=
 =?us-ascii?Q?Q9g8uYKgMoa0ZLclJN6yIdcpLqZc0bkWt4Jpy7Sk4Ta48k4C6Jbt6hoCSQLX?=
 =?us-ascii?Q?TFTc2DwFffv5jfGBt/ODYVF7feOzSDm/EMMbolKJrMWx8NiwbP/Nglw9sehE?=
 =?us-ascii?Q?LXQ3wDvdrRcoRsiAnqrBwg/DEAeKEosnbrBeB2jyX/hm8GVWxrb8CQHBHduP?=
 =?us-ascii?Q?772zKKCULOQ/xGXq5dhhtEw6FBybnIwOusMIRlb+nYAgM017q3Q+kMHUzDzz?=
 =?us-ascii?Q?XgXHn6IJVDkZIAJ9dw84HMYCh5wICGhVWSSqZQZqKbN9Guy2kZmEznoJdVTa?=
 =?us-ascii?Q?DZiuipujrHtJILg90Ph0XS3eBWQlXT3Sch0VL02KdPpUVTsrcaPPLd4EvqdO?=
 =?us-ascii?Q?iGfhy1iV+czLveA+cTGydMTikfmso6uPGuyQ2h/5TzK9EUvmih5a1JZL/qHd?=
 =?us-ascii?Q?516Viht3LfiNBWxNg8xkZjVdwxatD/EEh9QYBbNciFJ1gdL6SdLtCzMk30Ez?=
 =?us-ascii?Q?ls9R1Hhpwvv1Gi5Jnq+sS5OS2nbHVzyUCrWj24mNtaCkxdZDNAO2eAWO83sM?=
 =?us-ascii?Q?dcQuFi8I/ysjVPtkdZv6DVPIs6SRhS4faZwnZTUmqckbxRLmoo/JteFOpxtt?=
 =?us-ascii?Q?TBqwDmayazc9LlT2GTevYYoJwu4DmTT15xqbGjX85zxJRIJf1XTdkkxFZ6R4?=
 =?us-ascii?Q?7dPh6vWLOUYUq3X9v0bnBZ5V0fXwY9j7QtQr/fdAl0nBKM/aup+Z3UPqhlxq?=
 =?us-ascii?Q?WwT2IoFtynefCs2QuoKlNwa6q8CzeORva3N0irTmqnvfyafffnmLF+O95pLN?=
 =?us-ascii?Q?Qu21z6+8t/1R2kc50XATQZDsIAaBXuHrFyO8fMGmEj+0m+pVhLBlSUll/ycw?=
 =?us-ascii?Q?ZCynz+XxsjomiWbRknb5oL5GrQPh+yfn0ffn5qh/VbWtzK4+b11rARbbUcoJ?=
 =?us-ascii?Q?mX5l6mz4JxKBuFEMJ3Zdq8LODNmjjEJaDJ36MdfCN7t8KEwLlPriI5uWv/lC?=
 =?us-ascii?Q?3KlWH/AvXGNuzmf46N5K15cyefwdkXegqWkx89Jg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e8408666-452c-44d6-e9cb-08dd3eb47e20
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 09:25:08.9059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UX8cAcftF/bdstD5KStyTahjg/M8+aS75cLANSW1AGrW8mWWSxy66YXF5UyYzC1KwwZW76FAwe15svxLYysJWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8163
X-OriginatorOrg: intel.com

On Fri, Jan 24, 2025 at 05:23:36PM -0800, Sean Christopherson wrote:
> On Mon, Jan 20, 2025, Yan Zhao wrote:
> > On Fri, Jan 17, 2025 at 01:14:02PM -0800, Sean Christopherson wrote:
> > > On Mon, Jan 13, 2025, Yan Zhao wrote:
> > > I don't see any point in adding this comment, if the reader can't follow the
> > > logic of this code, these comments aren't going to help them.  And the comment
> > > about vcpu_run() in particular is misleading, as posted interrupts aren't truly
> > > handled by vcpu_run(), rather they're handled by hardware (although KVM does send
> > > a self-IPI).
> > What about below version?
> > 
> > "
> > Bail out the local retry
> > - for pending signal, so that vcpu_run() --> xfer_to_guest_mode_handle_work()
> >   --> kvm_handle_signal_exit() can exit to userspace for signal handling.
> 
> Eh, pending signals should be self-explanatory.
Ok.

> 
> > - for pending interrupts, so that tdx_vcpu_enter_exit() --> tdh_vp_enter() will
> >   be re-executed for interrupt injection through posted interrupt.
> > - for pending nmi or KVM_REQ_NMI, so that vcpu_enter_guest() will be
> >   re-executed to process and pend NMI to the TDX module. KVM always regards NMI
> >   as allowed and the TDX module will inject it when NMI is allowed in the TD.
> > "
> > 
> > > > +		 */
> > > > +		if (signal_pending(current) || pi_has_pending_interrupt(vcpu) ||
> > > > +		    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending)
> > > 
> > > This needs to check that the IRQ/NMI is actually allowed.  I guess it doesn't
> > > matter for IRQs, but it does matter for NMIs.  Why not use kvm_vcpu_has_events()?
> > Yes. However, vt_nmi_allowed() is always true for TDs.
> > For interrupt, tdx_interrupt_allowed() is always true unless the exit reason is
> > EXIT_REASON_HLT. For the EPT violation handler, the exit reason should not be
> > EXIT_REASON_HLT.
> > 
> > > Ah, it's a local function.  At a glance, I don't see any harm in exposing that
> > > to TDX.
> > Besides that kvm_vcpu_has_events() is a local function, the consideration to
> > check "pi_has_pending_interrupt() || kvm_test_request(KVM_REQ_NMI, vcpu) ||
> > vcpu->arch.nmi_pending" instead that
> 
> *sigh*
> 
>   PEND_NMI TDVPS field is a 1-bit filed, i.e. KVM can only pend one NMI in
>   the TDX module. Also, TDX doesn't allow KVM to request NMI-window exit
>   directly. When there is already one NMI pending in the TDX module, i.e. it
>   has not been delivered to TDX guest yet, if there is NMI pending in KVM,
>   collapse the pending NMI in KVM into the one pending in the TDX module.
>   Such collapse is OK considering on X86 bare metal, multiple NMIs could
>   collapse into one NMI, e.g. when NMI is blocked by SMI.  It's OS's
>   responsibility to poll all NMI sources in the NMI handler to avoid missing
>   handling of some NMI events. More details can be found in the changelog of
>   the patch "KVM: TDX: Implement methods to inject NMI".
> 
> That's probably fine?  But it's still unfortunate that TDX manages to be different
> at almost every opportunity :-(
:(

> > (1) the two are effectively equivalent for TDs (as nested is not supported yet)
> 
> If they're all equivalent, then *not* open coding is desriable, IMO.  Ah, but
> they aren't equivalent.  tdx_protected_apic_has_interrupt() also checks whatever
> TD_VCPU_STATE_DETAILS_NON_ARCH is.
> 
> 	vcpu_state_details =
> 		td_state_non_arch_read64(to_tdx(vcpu), TD_VCPU_STATE_DETAILS_NON_ARCH);
> 
> 	return tdx_vcpu_state_details_intr_pending(vcpu_state_details);
Right. That's why I asked that in the PUCK.

The "tdx_vcpu_state_details_intr_pending(vcpu_state_details)" checks if there's
a pending interrupt that can be recognized.
As in the code snippet of TDX module:

            case MD_TDVPS_VCPU_STATE_DETAILS_FIELD_CODE:
            {
                // Calculate virtual interrupt pending status
                vcpu_state_t vcpu_state_details;
                guest_interrupt_status_t interrupt_status;
                uint64_t interrupt_status_raw;

                set_vm_vmcs_as_active(md_ctx.tdvps_ptr, 0);

                ia32_vmread(VMX_GUEST_INTERRUPT_STATUS_ENCODE, &interrupt_status_raw);
                interrupt_status.raw = (uint16_t)interrupt_status_raw;
                vcpu_state_details.raw = 0ULL;
                if ((interrupt_status.rvi & 0xF0UL) > (md_ctx.tdvps_ptr->vapic.apic[PPR_INDEX] & 0xF0UL))
                {
                    vcpu_state_details.vmxip = 1ULL;
                }
                read_value = vcpu_state_details.raw;

                break;
            }

My previous consideration is that
when there's a pending interrupt that can be recognized, given the current VM
Exit reason is EPT violation, the next VM Entry will not deliver the interrupt
since the condition to recognize and deliver interrupt is unchanged after the
EPT violation VM Exit.
So checking pending interrupt brings only false positive, which is unlike
checking PID that the vector in the PID could arrive after the EPT violation VM
Exit and PID would be cleared after VM Entry even if the interrupts are not
deliverable. So checking PID may lead to true positive and less false positive.

But I understand your point now. As checking PID can also be false positive, it
would be no harm to introduce another source of false positive.

So using kvm_vcpu_has_events() looks like a kind of trade-off?
kvm_vcpu_has_events() can make TDX's code less special but might lead to the
local vCPU more vulnerable to the 0-step mitigation, especially when interrupts
are disabled in the guest.


> 
> That code needs a comment, because depending on the behavior of that field, it
> might not even be correct.
> 
> > (2) kvm_vcpu_has_events() may lead to unnecessary breaks due to exception
> >     pending. However, vt_inject_exception() is NULL for TDs.
> 
> Wouldn't a pending exception be a KVM bug?
Hmm, yes, it should be.
Although kvm_vcpu_ioctl_x86_set_mce() can invoke kvm_queue_exception() to queue
an exception for TDs, this should not occur while VCPU_RUN is in progress.

> The bigger oddity, which I think is worth calling out, is that because KVM can't
> determine if IRQs (or NMIs) are blocked at the time of the EPT violation, false
> positives are inevitable.  I.e. KVM may re-enter the guest even if the IRQ/NMI
> can't be delivered.  Call *that* out, and explain why it's fine.
Will do.

It's fine because:
In the worst-case scenario where every break is a false positive, the local vCPU
becomes more vulnerable to 0-step mitigation due to the lack of local retries.
If the local vCPU triggers a 0-step mitigation in tdh_vp_enter(), the remote
vCPUs would either retry while contending for the SEPT tree lock if they are in
the page installation path, or retry after waiting for the local vCPU to be
kicked off and ensuring no tdh_vp_enter() is occurring in the local vCPU.

Moreover, even there's no break out for interrupt injection in the local vCPU,
the local vCPU could still suffer 0-step mitigation, e.g. when an RIP faults
more than 6 GFNs.

> > > > +			break;
> > > > +
> > > > +		cond_resched();
> > > > +	}
> > > 
> > > Nit, IMO this reads better as:
> > > 
> > > 	do {
> > > 		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
> > > 	} while (ret == RET_PF_RETY && local_retry &&
> > > 		 !kvm_vcpu_has_events(vcpu) && !signal_pending(current));
> > >
> > Hmm, the previous way can save one "cond_resched()" for the common cases, i.e.,
> > when ret != RET_PF_RETRY or when gpa is shared .
> 
> Hrm, right.  Maybe this?  Dunno if that's any better.
> 
> 	ret = 0;
> 	do {
> 		if (ret)
> 			cond_resched();
Not sure either :)
This is clearer, however, brings one more check to the normal path.

> 		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
> 	} while (...)

