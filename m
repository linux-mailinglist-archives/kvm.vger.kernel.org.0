Return-Path: <kvm+bounces-56276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38EF3B3B8B9
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 12:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACCFA3B6A46
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 10:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C05E3090C4;
	Fri, 29 Aug 2025 10:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e2EUaVto"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C92302CBA;
	Fri, 29 Aug 2025 10:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756463413; cv=fail; b=k24KrJeuWcpsWrsllAUH3FXVjunFfo1GNoJaQ053qbAIa047aqACw7BuYjMynvilBFfqOS9AfjeYSILLXd8GalYFlnHKA6YtbJ8RNr/b6gAIFvmatNWhk+i9pO81EjAEEuDCbypiOYXXTcqLO2HV82vEbWFa+5TSTYtL97AmIZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756463413; c=relaxed/simple;
	bh=V2+fWauVM7R7AgLBCWmRwUbjrYezfSXGkhgqavvAJq0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rdeP5U3cA4eE4PNdvSeqSiZa/01UXUCABhHEIjBXFl5+bbMRCOvYP3Hqw95pLw5u89Ob/0ZnMWhsBNfVUVpmjIV3wwoeQ0CpKSkXy58AGRDiaOXvpjpURZMbagd6WbBqE1VCTVq3NRuEeDKqAAn/snYWE538EyD5/7/39YuDXWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e2EUaVto; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756463412; x=1787999412;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=V2+fWauVM7R7AgLBCWmRwUbjrYezfSXGkhgqavvAJq0=;
  b=e2EUaVto4chM8bptybunrJDCzvyTyBJGojVQpMycMcBzyuymg/ms1pFw
   mOKsx4LKh1PybeCSAMtTXOYwVoMv3yExDTyihvyVWZDa2+q5ri9geOImd
   FOv13PojKqJKXaSu8+u6ILC2h7fMD3+wm2nN0+kyQ9qLdSiQC+0RCCmBC
   hFsqxdqICgKLicorQRJTYNpX5IYT7sYaRsdW8RRZZbLsuxh2iBgZqQrg4
   orY67gtyLWXetaKpQ1RTqsaPZuHZFx3VOrkPdGs1xRel589KAXAEhpEpQ
   cWSEEW1owIvwVbptH2NJRbpvgr3QPHqUVXy9E11XXyxu8R9m8LFuWcba0
   g==;
X-CSE-ConnectionGUID: fGWbL8EPSXGHLfNJwSV7og==
X-CSE-MsgGUID: 5OmyWyjFS9+Wjl1KuvUy9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="46316233"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="46316233"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 03:30:06 -0700
X-CSE-ConnectionGUID: L7ol4Zq9S4y+YsUtYhdxdg==
X-CSE-MsgGUID: 99QcDe0ESS2S8ymhdjmYyw==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 03:30:06 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 03:30:05 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 03:30:05 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.46)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 03:30:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QkJ8X8Nj5QGUoTsWbi9Lu9IQ0yl+ODdEugVNNW01V6swtNWceVNA+XN5JHceTMyFiP24xcc7So0CO22QFD4zONmjEro14SSJRP603pOzgq9IO59YZkclj7Y+kZHB0Sppi+SGJmEZ84KrT0HVfrA7DaRJaLcFigNm7Q0x9gFwf/ABm4gYQvtEFdfFg46xeAFkVVgx7O62BmU+TwweHcELC2HDOp/AhyLQVOpJ05L7RB5NqTsRQlj+AMR2M0qN5JxeuAqd0rcmM7sqR95bpdCrIZkSLdrBfil+DU7lAVLNwfAo/7FGEqj2xRpfPk3kItFbXX4ifuOVRO04JXxblXqBGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDM9QH3UUsfq5VmLCrKzSS1O7CJqrpk7SbNhfi7cuGI=;
 b=w+/HTz+WF7OLqDjR+uipgzv43O7z8ik3QnEM0LmS2ME0UYbST3/e9VlXJCEYrFv8/YAUaUiV5/GF/a4BuBDL7tXNg6+Cuo2McARpvNzUmDYVWHH0n9d2vlxkBpscnkZ118FfqEBIZ/SNgz6UnX/TqiwlSeZpIXEqIcOYLksqt5T5r+Xr7kXgb4AZFZjUIWe474mCwx1BcrRixVtDCrXmhjEKGkpFIB4pGyqfhSC0WXlBfyBA4CMb+qe4dglqKKesulJa5sqnRtF0HJWgEag9m09sszaO9Di+8kNiOEzaKR/USxPgjOb3GbJk5ekcD3cCUFujf3RqSzedYUuiuSQQUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB6040.namprd11.prod.outlook.com (2603:10b6:8:77::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.16; Fri, 29 Aug 2025 10:29:52 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9073.016; Fri, 29 Aug 2025
 10:29:52 +0000
Date: Fri, 29 Aug 2025 18:29:40 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <john.allen@amd.com>,
	<mingo@redhat.com>, <minipli@grsecurity.net>, <mlevitsk@redhat.com>,
	<pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<tglx@linutronix.de>, <weijiang.yang@intel.com>, <x86@kernel.org>,
	<xin@zytor.com>
Subject: Re: [PATCH v13 04/21] KVM: x86: Initialize kvm_caps.supported_xss
Message-ID: <aLGBFBHNredIWKLH@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-5-chao.gao@intel.com>
 <3eedb2f8-4356-45e9-87d6-579ca30aaa35@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3eedb2f8-4356-45e9-87d6-579ca30aaa35@intel.com>
X-ClientProxiedBy: SI2P153CA0019.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f7e3d38-8423-4c86-0071-08dde6e6fd56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VgdTRlMWThTGuExagFul+Mvhf7eHWZLkY0ZswaMqrsiHXbfpwPpOH0cA9mEx?=
 =?us-ascii?Q?Mh1IkYDJv/UP0bP/o0dSD4x39Ac3Pe0zB0Rmdaytw8AE+YK0So64atyo7Y8F?=
 =?us-ascii?Q?AzYBvpqjR2R4+fc7VHxoDW21SXNnG2brgccu7GN0BG3htDD9av9RmTnwgc8h?=
 =?us-ascii?Q?8LXqLoJgmooDcDG0ayNpH65X/7r3m1Ul3Fskxp7rr6MvboU3Tuk1Hs9/Avnm?=
 =?us-ascii?Q?v3OrMH4d1ErbOl6Rj1HxbYbM6FHsdKHdCF7e7jFEggI3DIT+I6T7WWkNJGRE?=
 =?us-ascii?Q?ZMLRoqRStD3fJzdMQ43K/b/qRGA1OLGY3jDj+HiP/FEGU+E/NEpdhtkRtitY?=
 =?us-ascii?Q?p5qlRbDoV2NwaYaaqLpfj+9ZMyy8bcDxMH39OUQRcmRwQeFreo/WWlc86mg7?=
 =?us-ascii?Q?en9sj4iV0UEgOYAOE2LesOjyPvIXBJYsqpkUJtZtaZFiSlYRwZrumAif2eld?=
 =?us-ascii?Q?qF7tY5Cd40EVruThRIAoWFm3W3EFhofmpGdiQxuHhUYJ2fv1HJVoDOk7EGwB?=
 =?us-ascii?Q?Yfx9Rbp3GEjJNC6H4sK4Ab6DAzAvCY3Qh7QMpyhZmGZRLXW8Yjr464eT69b1?=
 =?us-ascii?Q?/WXZrKgsFjC9DVZPIpzHMW6jriIQ/tHF0gSTOXWFmZwgfihLZlHt9YzIii+m?=
 =?us-ascii?Q?mGlju6KDWSA1dejgt18AKouiJHd7MGOtFxuTl5TnapnXqGi1HoCmh8G1gDd5?=
 =?us-ascii?Q?Pg58iDkYxKArhqeEr2/yf9wFISQ33jpbn8ceZlVs/OB3XKYiPVyYOmV9mY4p?=
 =?us-ascii?Q?J+uSUXiO9dYC33HhJMSyok2K3fY0YEZavx/z29CSJzH6HCXzGT+xQtXRuI9A?=
 =?us-ascii?Q?qZY/PgpHrjbbxbGp+pkuddPMbIM7O8i2tm2hlJRo1gsPStf/4nNd+EMiVIMT?=
 =?us-ascii?Q?gk338VPeWb0caI8aCXHyjGbmBdmlzLpBZDqA+knBCrXfQeociP52GxHqQSMU?=
 =?us-ascii?Q?rd+DKeirUYlVJCze1OpCOdO8dBfnEeOYtHPaB6ZvQDBlwCmtucIwggJzMXSE?=
 =?us-ascii?Q?cJG2T2ZSkVg3vk4QHwGxwMj9bgSaAahaEylyzRmgG0g365XXVxf+7bLdaCp7?=
 =?us-ascii?Q?Pi0kUCyC2rcI6bvu8oGF0CghQpr9Q6ieuQoWOMLYhGfX6D5CvkC2LZl2VzIV?=
 =?us-ascii?Q?o+qqu0a09DYz7hLt1i6WDZhObG9Bkvg9LSnvGHCkc0F4jJcv25LBnv5zH1Yz?=
 =?us-ascii?Q?Rx6H1OEb1MTr72ILW4yZAlUoeMW/fllcFj+uQTJY+mqKeAiqNRJp7jyXg8/G?=
 =?us-ascii?Q?8Z/D3e+oVv/QMkprh8ot6/1Lsbv/kYlFUc3tlL43B1HfCnxskny2fpfjIkjm?=
 =?us-ascii?Q?Tw2cugo+LUCgzqchUrE1zLMMZCaOWuOmOn7EXFZNoRTi0uU3rnNmfp/x6mN1?=
 =?us-ascii?Q?j0Kdm/8+3P2T7VHYXwwbjUUG8Kj9qBdytjwiuyLPB9Wvv9uEoOSzeUc3ZgJo?=
 =?us-ascii?Q?ithDTbPelLA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BaDTUA0KlYrXB2mUJzxfhFFNLikOVbwRJpWL3/98FU4Ai0xsxl3zyayae+jS?=
 =?us-ascii?Q?uzhvalelZ2qD+Ro2XfQWCp+rVgc3+EOPt69wMH4gH5rVFfezLw18M0EYBTk/?=
 =?us-ascii?Q?Fu4RzTq8c2SpXZVNnFwioK+RMgIHuQJJ5tF+MpwVxQbheQXf7AXqPjg3csq6?=
 =?us-ascii?Q?9cYhncoDBQlCetTj7+5MBTm4qsfpWEyG+Ew8A1IxNBJTKSyUs8oHsLXemXkt?=
 =?us-ascii?Q?14Hd9I2yrZxjtiC+DoGddZ6ZWrFQeL+yOexaLHaZNRjDxbI8B2gE6q8GILjW?=
 =?us-ascii?Q?1c4J0ztIJHHwaS5Tm/BSeFAZXqUYb+sUlGf9oVq9+wVaCvxyQDpf6z8T85gT?=
 =?us-ascii?Q?4D6s4aUZyVy1RiVyFh6sKR9htVxQCIdzShWenLgFa8KdMYLRj1ufoXD4+vmc?=
 =?us-ascii?Q?I/K5XpIwzSPWdYkVjr5W+uxQiIhOi2oigEkMjTNrRg/4gOtiuVvIXBK6Rj/n?=
 =?us-ascii?Q?gb8Mk8nPklIFFCG//IX/1cehGWGhd8t+joNhKNaxWTFN99dLmtUte7wdhzx5?=
 =?us-ascii?Q?m9m0gEgFY2jyrX8Zyxo5va5sjXl1CYZ/CSVkZYnJOUY9TIcQ4l9zzUjuXoKW?=
 =?us-ascii?Q?tnodaihwhFPZHdKpiI13HErap9yhXXgvtu+4wgnShSG1n6h7oGeAsPajB3Ee?=
 =?us-ascii?Q?uKePetEVxm4szql8tqGv9Oqt4kYC8y9nd5DPJkaVSP229GR7yH9o6pWdrSoR?=
 =?us-ascii?Q?FbF1VAQwWYZ2TJRkyvxgZhfc2nLi4B5gpGLLEk8/UqlSokdIaebBCsY4yy1F?=
 =?us-ascii?Q?/l4XkncmLt5kuLWGrRG8m//PnkwO0+9cmiu5SQvxW8/t/sod9Sar1DLB1nRC?=
 =?us-ascii?Q?LeNpgLBx086a5E17b/8E5UvVGsZssIqehLKuLa8K6PMR1FhBgBT4YGGKOuEc?=
 =?us-ascii?Q?Ty3PMvOcb5y7gbGsUbDPSkg8+Hbxz7pgi+Vva/9CvVuFhNHn6cmYHYe+DQGc?=
 =?us-ascii?Q?BEpPV7B8jKcLM3OEoTeThXNQuF+JWWruxf8K/5/DxRaZ0NCDx8m4cPPeQiNS?=
 =?us-ascii?Q?hbLZwsqNDTaiO8QbeDFs8vCDyRAn0ewgLdpe8O3xtmgAqXNINKVKIrSfs5JN?=
 =?us-ascii?Q?Gyeexn7cFURqwJ84lIWKiSX1JZ+5D19dUGYIWg6l+pRzecjT6qYl+UyoEqTa?=
 =?us-ascii?Q?qDpJbfY0jM8Wkgq7H8WB49etmbWbkPOZVCfKoUtBwli2J9DAPR3TYWHCI+PM?=
 =?us-ascii?Q?mt7K5+dPcNumE2gkHGIvoFkpTplMVSJ7DGMKXGu+FmYbaZYMKw9VVizaLpTn?=
 =?us-ascii?Q?y7PGd5ebJ6M8Xuavr1sUBdntVseUZNAPfkmaARtdZLhJlqT1U1kgbdOKSgFQ?=
 =?us-ascii?Q?/M3bJ3Q+TEuwMkJZXkqc/MpvWdS0ZrGwLPndQZLQmDoEZ5oJKwVJaaWhGrW2?=
 =?us-ascii?Q?sCpKkD4gJtim82gLBzYvZ+LS4Xw/R+oDm6ydzUkIauQbylNLN317UkRXncMM?=
 =?us-ascii?Q?SkhrJja4YooeRKX5e6LZlmxcO3u5EcHHh/1+qAfh+le+b5/UKmZnqSRDK5oF?=
 =?us-ascii?Q?ei2NPgSXOfE2cs/Ce8pjtG3NAUFALLzevTqjVUgWmSF1OpC7J+8oECSJfoTy?=
 =?us-ascii?Q?Xxz+EEOufJQAJIDOKklnfcr1vNHIiDjP02Pu2jLO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f7e3d38-8423-4c86-0071-08dde6e6fd56
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 10:29:52.6073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o1LgJhtkK8sbl5RFVIDJpOpmV9wXRNNYMFgOmYHxxWRvtkKlHLY0N/tUpmKT4j6aLbWOjp+JCZxdoTQzlcqnxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6040
X-OriginatorOrg: intel.com

On Fri, Aug 29, 2025 at 03:05:01PM +0800, Xiaoyao Li wrote:
>On 8/21/2025 9:30 PM, Chao Gao wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>> 
>> Set original kvm_caps.supported_xss to (host_xss & KVM_SUPPORTED_XSS) if
>> XSAVES is supported. host_xss contains the host supported xstate feature
>> bits for thread FPU context switch, KVM_SUPPORTED_XSS includes all KVM
>> enabled XSS feature bits, the resulting value represents the supervisor
>> xstates that are available to guest and are backed by host FPU framework
>> for swapping {guest,host} XSAVE-managed registers/MSRs.
>> 
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Reviewed-by: Chao Gao <chao.gao@intel.com>
>> Tested-by: Mathias Krause <minipli@grsecurity.net>
>> Tested-by: John Allen <john.allen@amd.com>
>> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> ---
>>   arch/x86/kvm/x86.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 75b7a29721bb..6b01c6e9330e 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -220,6 +220,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>>   				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>> +#define KVM_SUPPORTED_XSS     0
>> +
>>   bool __read_mostly allow_smaller_maxphyaddr = 0;
>>   EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
>> @@ -9793,14 +9795,17 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>>   		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>>   		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
>>   	}
>> +
>> +	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
>> +		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
>> +		kvm_caps.supported_xss = kvm_host.xss & KVM_SUPPORTED_XSS;
>> +	}
>
>Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>
>Btw, since we now have KVM_SUPPORTED_XSS to cap the supported bits, it seems
>we can remove the
>
>	kvm_caps.supported_xss = 0;
>
>in both vmx_set_cpu_caps() and svm_set_cpu_caps().

This will enable SHSTK for SVM before SVM's CET series is merged.

>
>>   	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
>>   	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
>>   	rdmsrq_safe(MSR_EFER, &kvm_host.efer);
>> -	if (boot_cpu_has(X86_FEATURE_XSAVES))
>> -		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
>> -
>>   	kvm_init_pmu_capability(ops->pmu_ops);
>>   	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
>

