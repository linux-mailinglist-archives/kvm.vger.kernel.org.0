Return-Path: <kvm+bounces-33462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C00D9EC17D
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 02:27:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1DD4284D3E
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 01:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2310133987;
	Wed, 11 Dec 2024 01:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jgY0E0vQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90EB179BD;
	Wed, 11 Dec 2024 01:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733880417; cv=fail; b=rmYQMBRYBGRgqa0sif0kPzYD2bKGlRRLAzYJxr66bbKeQP1u6bnC/rFKoW2HNazPVbPcI4cDUv+FMkoIuv5d7KkZZNRa/jVb+D1BrI6koKEKzoy7k3KWgKFPM1Da1T3GYpD7Da/y9wzADlgG6Ojd3Re8cB07U+pBxsYWc4FeW/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733880417; c=relaxed/simple;
	bh=EMY3WM6pOXqGE0W15ljtOmPuuwHNs1M3+5YoQK523hQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DeDMJkJSz3jNnmCdyS81WsG9HmLyDS2G8hR06vzj64CXPYNLL/Sp6olQv2Hv3t1MbH3v7CV3UdLmbXg3aWHmQ4CG+pU1vt62StYxIGlYF2fH3natxnAPHP7YW77rEQmy6nXvNagfm1uO/uslC3s8a+bRcJhdkQIM+H0H0/3gkzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jgY0E0vQ; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733880416; x=1765416416;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=EMY3WM6pOXqGE0W15ljtOmPuuwHNs1M3+5YoQK523hQ=;
  b=jgY0E0vQG2Wo9ddnOhpjxMbqua7ltmo/ce+xS4nP/508k3mt/YcJcVWO
   5DPyOgRRioTC4kYaSd1VmRbtdAkFQkA3pOhgIbCSKXBRjWUmBeFs2188O
   Pwc+vIrqRgTjW0KAv9ELpzhT+xvpFbYSB914j5ywkuCfIKJcfznnxpgJr
   O7/wcwumrmaSF1ZxYiVjKbWrckUj2cDm5pjyYYXewy4AXXWUsVmtus7b2
   Z2FqWP9i8WcCb8P5tY7ZDbyWx+vUchK2j8mG08DoNtQDHVxi5ksvKs48x
   sQijjqyTc/uK1MhZhCE2vx8VEG/70cYM28+fzdkPUEbcF89my+05A6IwT
   A==;
X-CSE-ConnectionGUID: CAvTSrZuSiuorPbIVpReSQ==
X-CSE-MsgGUID: 207dO6j7TIquDTTljE8KEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="33582806"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="33582806"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 17:26:55 -0800
X-CSE-ConnectionGUID: 8l59tqQzSgKoKtquuTvaAg==
X-CSE-MsgGUID: RoRFw3rgS4uI4XTRpH2i3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="100657341"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Dec 2024 17:26:54 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Dec 2024 17:26:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Dec 2024 17:26:53 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Dec 2024 17:26:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jQTabPVQOXyp2A2fWMsbGkgI0INUlXzeDdR6ToEnN3p5i+fs+8dkUi4amQQJTv84e5D0Z0fdeWxFcaTSwEZuy+Ry9yck1lho/mqdwObyEeKgmHjrv/C59p1HWPMe8BIGsygvo3bxiItE+GcGmhoETomWbQMUftkzNgNn0j3425p/+3LhKijDAlN5+3Q/83JdRe2dYNSZTjHirq1SMplRYsiaDZA86AKp4HdjMRmRNfzP3o2OnOOf5FlmN643LMrxSZ/BFWi0UuI989dVMiH7Xus9Sg4b9k9xR916tmGIlXgOYgQv8qo2PiGn04sPKIjlW3C+3myMckSFOtXtghK52Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOa3lNVBO7AsdlzFnnHXY1nlH73hXD0gCMSfyNIEZ18=;
 b=yF0C9x8eNBTai++Clytf3UrPRuQhAb3VA6cODPrcmJxHgt5PalOYcBkjEScbJqiCuOOQGmhwB4HawWgDBdY5RBOdev+y16Goes3iOsZdelXIIZrVm4CEjoKKN7k8tl6z0QNMGJQYS91IN2OmjQK1sHHmZ+oN/2Hr7TBEzn+dXRSllQqntoriaguFvYoZhFLMuEqssNPMtOzeISnGNCK0PY5Th0V0iZFwbBxHdjhlil1dEmGpfAfBLBalO4mV1PSAdkLa/7kfDqI9CvqhDX3oAc6SOqSYq+eF9DANjqAXu4SWIZfuQ2yDeV0SRRs9/jSiNjYIGT8FQ4ZKIWet07mk9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CYXPR11MB8690.namprd11.prod.outlook.com (2603:10b6:930:e5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.18; Wed, 11 Dec 2024 01:26:50 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8230.016; Wed, 11 Dec 2024
 01:26:50 +0000
Date: Wed, 11 Dec 2024 09:23:59 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<dave.hansen@intel.com>, <isaku.yamahata@gmail.com>, <kai.huang@intel.com>,
	<linux-kernel@vger.kernel.org>, <tony.lindgren@linux.intel.com>,
	<xiaoyao.li@intel.com>, <x86@kernel.org>, <adrian.hunter@intel.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: Re: [RFC PATCH v2 4/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 page cache management
Message-ID: <Z1jpr7baxGJDj7Ur@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
 <20241203010317.827803-5-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241203010317.827803-5-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SI2PR01CA0021.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CYXPR11MB8690:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d98917a-c6f0-4996-1e2a-08dd1982e2fc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?s8nq6F+PpNrDPNri099785MtMScc/KgajCFsdkjQzpTFfLgf3h9U9jSy9gLO?=
 =?us-ascii?Q?gJiBxx8JoMYiVUrHZwYVusLliDpxyxkZ1ZD+CqxGXTGdQlR+oqNMbnmg1ix+?=
 =?us-ascii?Q?ThoUxXZZtEVWifiem/BAYtnjxOISwwqZwSC6xWtfp8JFPjFGiBfN/ppaSXV1?=
 =?us-ascii?Q?QX2vTbHYTAf7NfuoSOnYXvOcqZ9Anl9zt7EXIoLnHgdag5119W1Cv2jheJxJ?=
 =?us-ascii?Q?MNpVcAapX0d3++s7nUKQY9lnCTjYqtlPw+ZuI1AtrEpqtIn5PVwRZkm05uFq?=
 =?us-ascii?Q?l4Nh+Wy4YqChIzu/9S7aedmLCQTG/t74+Wq2tk61S4LWpMyRJhXWCzozGgGo?=
 =?us-ascii?Q?eb/gcRi4VI9H6LSRvPw7TAYDZeL9qC/1FEHvANVm4KfsCEVosQs8gelirnfY?=
 =?us-ascii?Q?UYEPPTFndMuySUOInfMYeQT1ZplHvTVJI2ENSsXkPHAUj+4jZRs+V0VdCmyK?=
 =?us-ascii?Q?aNnfj2BxdGLXeUZIUZa7ODVpgX09E0T7ami7Gm+1ov+lXCeqP9SfYZIPv3zg?=
 =?us-ascii?Q?0HwUQsS993RUBHhNL2LPyJbqU5DCPoKVwFLfsRLfLWm1s6sPRyFFV4ImRys3?=
 =?us-ascii?Q?85C4i2D1FM7ZJsR5icos8RtqNUF+IXWtrEnlp8UI9OLWrWemZAg/3fsd3qlD?=
 =?us-ascii?Q?+uKBklftVlMeEkCEjuK81qmA4zjET0qXCc9x7/XydSEsHePbT5Y4UBqruwT4?=
 =?us-ascii?Q?J++HNf3IGyE56AkvH27ZCxkyxVSsHbgzyymYIwQOg3luDowyzn+SRuND/Nkq?=
 =?us-ascii?Q?AzUtcKr10PtsO2MoaoA20Q1rT94OIGjcZjZKy9hYgq47wpLhLBkaykbDHA+T?=
 =?us-ascii?Q?V/m4Wq9azXZV8LG6GrY1aS+g5hbF3WLVX/I2vk0fE3ofrkJxCZilr/TH0AM6?=
 =?us-ascii?Q?YacT1658qITIjbqNKD6Ji/AfHj73kGiRqelIUm679xiKhDHuaLB8GMtZxB9W?=
 =?us-ascii?Q?3zBnm4zgbZqGrSq7W1e1UTXmSbK+UhjdhuDZWkzJgghlevRVfzFAtiSoz4xn?=
 =?us-ascii?Q?+z1Uj3ZfyUSMHR+x3f/nQ4QST/k1v+xxnfpAn/VW4IseXCFV+xAVFL5tTliR?=
 =?us-ascii?Q?aCgMKr1a5/9z1S1u9IJcCjlrGMoq8Gkt9fs4prKPSPvMSlQwNyJdkRxorcry?=
 =?us-ascii?Q?PnIy6HqEU5i2LhgJjOv98/wr/EetGkcY2R83hove4afZ9ItaD/WlWE7ZZxh9?=
 =?us-ascii?Q?d542l5/uP11D7Hq2YJFIrKU3XIHKEoHjalNqlESpDqHGMoT0UxhoLNz/OuV0?=
 =?us-ascii?Q?pnX+qMHy/r0m5zEAg4Vo6yr41eVVgUpk1i8hJsQlMNohTNElwLkHuE7pm8Nw?=
 =?us-ascii?Q?m1H+pI5cARDkNvRE1DvJ+Pk9ZURVDuqwLoXd6370k5Q6Ag=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ux4XGyrAhNxNwn7pCuQEGZaZ0jWitA2b0MNY7TwSHfxwhYwBY/46XEpMLtJ3?=
 =?us-ascii?Q?KEUng2OJA5Uc34I5QawefN9P73FPtwXkj1fCMjlJ94CREJx/FTCHWxl/gAN+?=
 =?us-ascii?Q?XHG9//CuYnho+G6y0/crKREXJMz72bmby3KAZUPxH9m7Fhh7cEpouuuLFcm/?=
 =?us-ascii?Q?nNqqi4mez30oU5nJcghHle2X1NeoC8bbjNE7LBT4X4urkskZ5k3fgFZA5Ncq?=
 =?us-ascii?Q?wteXAmc6flfehfSmKYJ70E1x2xAyw0KwHIVJGIwQ3Befr3SMDMZOD3F3uoXL?=
 =?us-ascii?Q?dUvVRZEdNpj5yZ+LZ8k13ZMWFOV9e69mYU0UvzwaR1Gg4dVFNzhJQnezONvu?=
 =?us-ascii?Q?9TJDPAs8XNEDEnyas1q/7jLHUgRFpTz8Pef+fjnMW9RzLYbn5YUAdrSTKpeC?=
 =?us-ascii?Q?W6W2AqxHLadkLsBrW0/SxjjvdLzYTPwYYggcuPcKFyfIHNRcet+/+LCS1YWW?=
 =?us-ascii?Q?pMN+vZm4vjWT4GVI8Tk76Z3qzHChAJVfFYvMoeTw7JBBTcqQ/ltcIXt6G3aB?=
 =?us-ascii?Q?SyFu6Gx+VgjNeV44HMmXp82G8QPL8uqTL6/Ocsb9RcdqtwJWZC2snttoWFFc?=
 =?us-ascii?Q?8R4mXD/gINOy3ann1595VbzmsDMicLXaJ1rLSvH9UMm8ffC4Mexc8ArAjdjZ?=
 =?us-ascii?Q?0bV2hRiTFfjCyVajISEFibjKj7qEIsrWuuSbYkOuFbudp4yixQFWAIFhTu9x?=
 =?us-ascii?Q?weC0v2jr2kJi9xH72LlL6ns1n4pMMdSrvW00ZUu6p2N/zHzV6dCCU+KDUIkv?=
 =?us-ascii?Q?gDYfHJwhKWZzT7mhgAOtL81BFSfNAXCCkTATcihSmq0/Dz4eRCNLNwQoLFAr?=
 =?us-ascii?Q?BszSanTGL2awSyEwzZJBx3gUH3EDObN+VtqzsWGWFMsbUgMoUf9nDTqO5yHa?=
 =?us-ascii?Q?TS5Xv7+tGSaHFTNeNR158XWpYTUZKRdhUAqPnyOexrNL7iQw4qEXvStOKKdS?=
 =?us-ascii?Q?SmK9Rcd0llf6Vet5X3cNC1b6pPnX/jK1QuGivd1rbhgDrJFOL7Norpnoa1I0?=
 =?us-ascii?Q?KvbA59dToUYve8CyjkGE/ozy03tVqW+bgVchEZs358G3S7ggWYH5VKy3r9Wk?=
 =?us-ascii?Q?cjqZCsUjW59sXvxBcn+JZnS7rGeZrTS18HHzWzp616VrNnhIyHBTgoitrdMW?=
 =?us-ascii?Q?hFS1hUAC9RTAfASdvnkLVHLL1aT/m4mwWQPakSzaOL6jbZYSqQEZgOhSVa8v?=
 =?us-ascii?Q?AHiyYDwqxPhGp60Vu4S3nWPO92hn8PJlru7nyxUOYVCVPhW45chSX6IJNn1r?=
 =?us-ascii?Q?s2gcnqqlTg1ZDoZv9XsBAyIw0OWasiSrZ9IlRpmsDexwLnPveCxGMtCu9RIx?=
 =?us-ascii?Q?K93gF+Xi1R7gDCrbTcgt/kOv9xeeeR8+vQgW3bNXtVdVhk+6rDoBMH60FmY8?=
 =?us-ascii?Q?zXqL6RgP0eSqgWIgf6B0aLg9IXaBPLT5U0cbBWsbVBFYatIPT6E1epP91Ann?=
 =?us-ascii?Q?Y2HQ5ReFaLvf4RXnU+sr7IJP6ka1zGWmdS54TV78HvmtwQ3LLoCcGlNtHoZd?=
 =?us-ascii?Q?07iAmrX5dE5+3+ZlerIQnSAStmaJBW1rdqZizil2+9nEKkOViR2jQ44XuPXc?=
 =?us-ascii?Q?U+hN3VYUZcQmlEoe30YZjO3jZ3RwHxMZXF9BXGb4X7MUnyiSkyXbx8OQXNhL?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d98917a-c6f0-4996-1e2a-08dd1982e2fc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 01:26:50.2955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CjIR/7f3kWyGrnvl2eq3b7T1RDK5QqLBsYOS2KYY/JQv7bcEwwtI2SYgtbutH+jfO1QU7Tdfkpu4a6MEQKKtqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8690
X-OriginatorOrg: intel.com

On Mon, Dec 02, 2024 at 05:03:14PM -0800, Rick Edgecombe wrote:
...
> +u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
> +{
> +	struct tdx_module_args args = {};
> +
> +	args.rcx = tdx_tdr_pa(td) | ((u64)tdx_global_keyid << boot_cpu_data.x86_phys_bits);
> +
> +	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
> +}
> +EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
The tdx_global_keyid is of type u16 in TDX spec and TDX module.
As Reinette pointed out, u64 could cause overflow.

Do we need to change all keyids to u16, including those in
tdh.mng.create() in patch 2,
the global_keyid, tdx_guest_keyid_start in arch/x86/virt/vmx/tdx/tdx.c
and kvm_tdx->hkid in arch/x86/kvm/vmx/tdx.c ?

BTW, is it a good idea to move set_hkid_to_hpa() from KVM TDX to x86 common
header?

static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
{
        return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
}

