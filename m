Return-Path: <kvm+bounces-17742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 918A18C9804
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 04:47:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3F421C20D59
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 02:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A660C2FD;
	Mon, 20 May 2024 02:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="heZQcz0y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FF0C2ED;
	Mon, 20 May 2024 02:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716173214; cv=fail; b=D/j4BR1WTXlk9MyuYVYUAT33AnFGgfCBpq4twfGnkOI4yUfFzspqqD+PSBvEafb0eMmWQj5QFuMfBLbv2L6O8uT/GKJaOBOwyA9xpzwi9Wff1njxY5Odko2tn7Tx540sZqv006t5sWGxmTuhcoamyk8AeaHrII6yA4wTKvmuoaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716173214; c=relaxed/simple;
	bh=SWFNI2n9PN40fOzsCyg9TNk8ZVIImTEDEsbZJHtOIvY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PvMv+GidEHot2Xgxz1amN9X02UxqcGnZvJog89VItGifeNspySE+q/CZBJVmjKS+oKR8Q/GNaEykt53iktljeQX1jAvnO3h6m1/NKRtZErT8C4k5d+SNNT9TnZ+hHCawmcMHLgvZicrhkFLhXJLcMzXom+5vuHJqk6CxSN3qteE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=heZQcz0y; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716173213; x=1747709213;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=SWFNI2n9PN40fOzsCyg9TNk8ZVIImTEDEsbZJHtOIvY=;
  b=heZQcz0yJ0Xm+RThRkm95BBARt2tqkyzSOw6GEYk/hnT32NSPINWZ8cp
   Vi59gGQkZwcDUHlkXa6yQYscFnZ7yLk1k+4uBZaCkaObQptxlU7WDHudM
   U5jVOeZQvf+wS6dKVMGeYVRe0ik+zVQhg7g6n6xY9kP+2vdpmPDgzbXru
   x/EerrvgiaEHl4OoDEq+3P+B5wan1zd24WBzU3y0CjtqHNHIKxIfm1ZUS
   9COBTu5QYRcO0n8i2jzkkhSkxZ/lPxqIQp41uUTsy7CEDXhFq1JIg94Wp
   SwPeud1OfTxTboKYIiUUD7pzD18gaAF759w6BJmYiPxjsWEDjO5/a63QN
   A==;
X-CSE-ConnectionGUID: /XQ1JtdBR62LuGEYNwekzQ==
X-CSE-MsgGUID: LgM6mgxSQOKnnK/9mJnHwQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11077"; a="29794109"
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="29794109"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2024 19:46:52 -0700
X-CSE-ConnectionGUID: TZfO+EmRTDy9D4452D6y9A==
X-CSE-MsgGUID: C/6LLDtOT6KsStqGCpssrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="32289827"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 May 2024 19:46:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 19 May 2024 19:46:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 19 May 2024 19:46:51 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 19 May 2024 19:46:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVDks3BfGC4lCksxwf76pjHIp8M7MoxqFj/JfSruZ1GXZx/yYvOUJ7dEvuSfArbYwVn2GS4yWJ2BdpLww+gE2wUhKqfoOVD1Sib1qGswlFEwAgYluURBGlViaGMi2BMP3aAUc1LzrudN0pC+RhwRr1vAxb6yG9ZLqSvp/T1cWFac43xALjK+nSG2hVT10Kly2K5Ww7LQCOBPvK0c62Rt5GWSsr3tpH+98IBU9veJKP37PZ7IfoSdIAlkVyK+0D6oKfbq7+ydsyACUr3VoDVx+vid4b43Gb5gMPWwIshWp2gyhRgOeBtyLZ+xh1b60bdKwD792iwpnxnFXD05UN0nHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Vx9YKag2fUGdnIL4LQ89g01w50wT8kxc5Ho5KyDIjU=;
 b=dpTc6tQ68ydyK7RTOpUQMnxHk3CfBYF4t464qTJLH5xVq6auMb+LTpSOEiZVGZ6BBY/13U7CsfsWqRDQy7nXqa0Qh91gCij80XCM3ZsdAJ1wi6gU4OjwGusKrmAuEv5OLUACfV11/zL/1gtNbTq9mQXafIzqLOsY8JeN/4ePaYvcPDS6d+dX9B6w7O8SDm46OwZY4lXjuouOdG6WGVjFWBz9CtpOMZEn0/H2bjVmVey4Ly7o+c9TemiHxu2JwBRsFtM3+4wGfi/HjcIctxVrE9B09ZIeuQ3/Qomq5LK8z1w2AR21x/lLJz89CYXvd+upmN5UWTisSPCVQsyB2cwy+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7197.namprd11.prod.outlook.com (2603:10b6:208:41a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.35; Mon, 20 May 2024 02:46:48 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 02:46:48 +0000
Date: Mon, 20 May 2024 10:45:56 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<iommu@lists.linux.dev>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
	<corbet@lwn.net>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <Zkq5ZL+saJbEkfBQ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507062212.20535-1-yan.y.zhao@intel.com>
 <20240509141332.GP4650@nvidia.com>
 <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
 <20240510132928.GS4650@nvidia.com>
 <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
 <ZkN/F3dGKfGSdf/6@nvidia.com>
 <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
 <ZkUeWAjHuvIhLcFH@nvidia.com>
 <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
 <20240517170418.GA20229@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240517170418.GA20229@nvidia.com>
X-ClientProxiedBy: SI2PR04CA0003.apcprd04.prod.outlook.com
 (2603:1096:4:197::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7197:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b663876-1d9a-491a-fa9e-08dc78771870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cxBkUpmkLD9q3ejuBkkwWl8lgbEHqtqYTwR3kWlbk4hibksGkBmTKJ70etdJ?=
 =?us-ascii?Q?CXHwtCn5sO9d7BEF1xiivuNR5+C343BgA1v9RRUGIVd2vWYzII7p5WIvfxAg?=
 =?us-ascii?Q?dPIc3ceGCHlmvC4xdrly8pgR0OD1qf+5QkoEjMJWJQHsSonBGpyGzdjVVUQ2?=
 =?us-ascii?Q?dj+/iXO7ay+a7B0tIzk6iyBL3kbNEUUPHkzZfQn7XDG6B/EtvMpBfOPV+ycQ?=
 =?us-ascii?Q?JmV/+1f+Wa3mXAk+AfNO1WnaZ93QZXGHRtARBX/ToWpjvei3DRqmXDxXpuEu?=
 =?us-ascii?Q?qK1jv/VWzPp8/noFtC5tUk0iq5Qene2b42yz8lRIPRiC3tfRCGdF8kubDIZw?=
 =?us-ascii?Q?AQnLayB53GFvB8SPPMWcT+ONkL6C60Mci6zvWKmEpfqHrdjdFiFqYJO8Gu2Y?=
 =?us-ascii?Q?24HWGL4hWT1w2j6xrZl6XkxEaNpYgCC/HFSAA9RvMDI6qq7Tt0Ys41Iw69fo?=
 =?us-ascii?Q?Il6bMpoC3oRuXrxaj1mmJNDD47MbH3fzuCUZKEYrlpKBNDsM+fg6zJJwVjVC?=
 =?us-ascii?Q?OYd5VA6drvU1lOS3q7PhF/RYZ/yVYRYSiljmA5inw9v4HyHlXzkYa6keaCd0?=
 =?us-ascii?Q?G7ANDe+ykrLSW1vPCP0gF6xo7SZzFizbbm83WpDvmP3T5qt2a926Q8qNP4fQ?=
 =?us-ascii?Q?KXGW9CJ01wBoxko0L1ZYy9+dv6yr4EWhvxLZspgnv+YtWrzEC7sRsG6i3jDj?=
 =?us-ascii?Q?qjplOQjU+2mlwUNXSdJNYrkSDRdW+zvEakTW4t0DBxwL3xCS8DNZYdZz+xUX?=
 =?us-ascii?Q?SD+Yi3t9sWfOeaLvHtp8MjI6EOM9W3P9QfZVzxZMXnFgzGparTJyiCrHhADt?=
 =?us-ascii?Q?HxtrucapZmoykxLIXo0pOMJuWeQVIVNbDG/LTveILw/KLujUfHf0Ik2sMwzl?=
 =?us-ascii?Q?uAn5yAdJor0NOoJhDrxM1jSeqHR1NbA4XCXt575ZM3MXqknTPTHzbYtF85PU?=
 =?us-ascii?Q?bIbCgFEdDEr9hEixjFv+UM020pFOOdDKhMfa+6OGbqYn+kU+uRVlGRXwM4WZ?=
 =?us-ascii?Q?qMP0V1Sh2nK35ia026DFEBGEweqp4nSr11mzfJeNaXvcmnT2GoTEauRiHtjo?=
 =?us-ascii?Q?zDld5KjyBh9IL3coeLgZs/rCGJy0ub9wTx3tfZONpgXWOroBN9EPHpiCftYu?=
 =?us-ascii?Q?LuBjs9F3GLgCTsaBDspS1TKBCAlbItWG5yjysWbvhFj+CnQYBrn5AtSr1pwI?=
 =?us-ascii?Q?WVn3MXJeorF6WTgaGfiazsvV85HUZuFrTNdt4bROT/gAKIjy2xvI4tLJepkr?=
 =?us-ascii?Q?BzFb/H/ZUQ0fXcWjBrs7gKfxQDCClzNbleKc60rKTA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VWvVRxiNqO9o0ZJ1CkYi8vPUOSZNsPKVSIjdMsKuN18y1GIYqouJdJDNiZ1b?=
 =?us-ascii?Q?XUJWeZO55jqExMXWmxkSQ+puDz6Li+1IOWCO8s8MCH5atd8SY+BKTZPmtl7W?=
 =?us-ascii?Q?AfAuyEBK7ombhRGX40qBayoZtf1BpftBFKsS1wH719zGPReP8m8uCx0Uj+Ke?=
 =?us-ascii?Q?rFQa9IkgNE9Eh5VfZ0vZmHEEMYFr5w5ZjlZpHiQTD6ohQ2ICcEY0wYg4iqXO?=
 =?us-ascii?Q?sa9auU3RMwW50YkL2ErvarOiOsEe6z3bMIj8y8jY91iFW7y9vp29K/WYwvMj?=
 =?us-ascii?Q?sjg8ctCbBdexjfwq+YbBC0+naBWnj8eHjBr5+v0LGRgvA4NkcbClvnsVHxPB?=
 =?us-ascii?Q?DcnAgur3xn/MaedVVszmdWnaVfAtOkgaQQzfRVEq8CXqgbBpQ5Y7cHhVmyXw?=
 =?us-ascii?Q?3bVeBxmJk4/1+Ki52fp1RPct1D7QmHdfiBhkqjhCPgkx5v1sK7VH7lH0Qbla?=
 =?us-ascii?Q?yl5u2/lHPjVzjRpC8eQSoMznl8gUHPAn89okqm7F+1R9aPtaLNZZRuBDArh7?=
 =?us-ascii?Q?jKKbkLphnA+ng5kOPSJqe30yE73ra1PUxQg33gWCtkHZjedAzZ9UOpu8AyZp?=
 =?us-ascii?Q?pAgdk4Fsxz0Escofc3f1o0+/BS+zl4CU8tp5HvYzDerwghIFYdKX8L5DpFWt?=
 =?us-ascii?Q?rrMP1JdIyAxEN0kgFKdxlrJiyTb3ajkZlc+Irk3YBpyasVF3T/KwXOTDm69v?=
 =?us-ascii?Q?yh/+q3t0obI9O6YgMeVpqtpnW0eFZjJlOinF5O3sgi/F9HuX9zDgdkz9BAQT?=
 =?us-ascii?Q?TeDLtWlr2epCCWqb2ZXOhgsbVCwaP2uKkSlwdtxUQd9EtsGyp5SbZflvkY/z?=
 =?us-ascii?Q?Rgcsuh/3yRNLHGWgT1EHt1NwnBPH8Q6/G2xmz+C6hMVJDMqAQhTIUvHFA2EJ?=
 =?us-ascii?Q?WoWSAbpuqPyoR7wDIOliXAVEp5EgMRV9OtK8/rCGDI2FjB0ItDo3Nb5WNZOn?=
 =?us-ascii?Q?piH2vKO44IxB0B3R1rpMXDlMFG7Pj1vS26JEVZ3UIFiv+06bdQS/dW2l6UtJ?=
 =?us-ascii?Q?l0QO8Oam8D9Aro3gFGs0jTSP0XtIdI4lmHk8VwMCkPwZ5Q1TTMvEPIHH4j0q?=
 =?us-ascii?Q?XC1kO66VkndOBo0lig8m/Mc07BWxR7UCktTG4HRCi+TZrOPlUVfDpnz9gg8I?=
 =?us-ascii?Q?bQlkh5/qdrmorxdvkneRnamzywVRf62zInzewXQrvWhsCqG0i249wjuZB5JQ?=
 =?us-ascii?Q?keCRjQrc6LAAWJjkzVvXJWhY5t4M1G24HgL000uqArx20SO8Ko2ODjd9el4i?=
 =?us-ascii?Q?6jutnniKSV6S32Ez57t5iPYOhWFiTQ7337/AtL7L6EoVAHyRg5Num+Rgq0J0?=
 =?us-ascii?Q?TPEYb21+VKVfTGeIXGFJCz2dq1SnZGpP9I1P+DKZStBiHHNLFZIMiLzxJeXL?=
 =?us-ascii?Q?1nEsrl6AJ8zjn+rw8A0xnXx/NWSR6KYOlcMCyME0j0ZvufMiemlEtuSYqZ4I?=
 =?us-ascii?Q?eIHgF+3YJFgB2P1ZWRyaSwt7ZP4ZZYiXqmbJz0PH+4tc4Ljox/Xq6a+S1w9t?=
 =?us-ascii?Q?Q+S45T5Q8i27AQ+TcM9ey7IX7C/EnxqOd4PkdedQKgqcCXGSxVwYhQ/ooM27?=
 =?us-ascii?Q?/D6UjhEObYOXKbwv/RHBvG1UsZsWOYWS6WIwXS/S?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b663876-1d9a-491a-fa9e-08dc78771870
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 02:46:48.8236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9658j8Lxw/887nXu7YuSExchcTYNj8Hk0T/FjWRv3ng5J9tnCVNdPKvdfcu7uES867tWzA2yIQbAmcxdayhXJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7197
X-OriginatorOrg: intel.com

On Fri, May 17, 2024 at 02:04:18PM -0300, Jason Gunthorpe wrote:
> On Thu, May 16, 2024 at 10:32:43AM +0800, Yan Zhao wrote:
> > On Wed, May 15, 2024 at 05:43:04PM -0300, Jason Gunthorpe wrote:
> > > On Wed, May 15, 2024 at 03:06:36PM +0800, Yan Zhao wrote:
> > > 
> > > > > So it has to be calculated on closer to a page by page basis (really a
> > > > > span by span basis) if flushing of that span is needed based on where
> > > > > the pages came from. Only pages that came from a hwpt that is
> > > > > non-coherent can skip the flushing.
> > > > Is area by area basis also good?
> > > > Isn't an area either not mapped to any domain or mapped into all domains?
> > > 
> > > Yes, this is what the span iterator turns into in the background, it
> > > goes area by area to cover things.
> > > 
> > > > But, yes, considering the limited number of non-coherent domains, it appears
> > > > more robust and clean to always flush for non-coherent domain in
> > > > iopt_area_fill_domain().
> > > > It eliminates the need to decide whether to retain the area flag during a split.
> > > 
> > > And flush for pin user pages, so you basically always flush because
> > > you can't tell where the pages came from.
> > As a summary, do you think it's good to flush in below way?
> > 
> > 1. in iopt_area_fill_domains(), flush before mapping a page into domains when
> >    iopt->noncoherent_domain_cnt > 0, no matter where the page is from.
> >    Record cache_flush_required in pages for unpin.
> > 2. in iopt_area_fill_domain(), pass in hwpt to check domain non-coherency.
> >    flush before mapping a page into a non-coherent domain, no matter where the
> >    page is from.
> >    Record cache_flush_required in pages for unpin.
> > 3. in batch_unpin(), flush if pages->cache_flush_required before
> >    unpin_user_pages.
> 
> It does not quite sound right, there should be no tracking in the
> pages of this stuff.
What's the downside of having tracking in the pages?

Lazily flush pages right before unpin pages is not only to save flush count
for performance, but also for some real problem we encountered. see below.

> 
> If pfn_reader_fill_span() does batch_from_domain() and
> the source domain's storage_domain is non-coherent then you can skip
> the flush. This is not pedantically perfect in skipping all flushes, but
> in practice it is probably good enough.
We don't know whether the source storage_domain is non-coherent since
area->storage_domain is of "struct iommu_domain".

Do you want to add a flag in "area", e.g. area->storage_domain_is_noncoherent,
and set this flag along side setting storage_domain?
(But looks this is not easy in iopt_area_fill_domains() as we don't have hwpt
there.)

> __iopt_area_unfill_domain() (and children) must flush after
> iopt_area_unmap_domain_range() if the area's domain is
> non-coherent. This is also not perfect, but probably good enough.
Do you mean flush after each iopt_area_unmap_domain_range() if the domain is
non-coherent?
The problem is that iopt_area_unmap_domain_range() knows only IOVA, the
IOVA->PFN relationship is not available without iommu_iova_to_phys() and
iommu_domain contains no coherency info.
Besides, when the non-coherent domain is a storage domain, we still need to do
the flush in batch_unpin(), right?
Then, with a more complex case, if the non-coherent domain is a storage domain,
and if some pages are still held in pages->access_itree when unfilling the
domain, should we get PFNs from pages->pinned_pfns and do the flush in
__iopt_area_unfill_domain()?
> 
> Doing better in both cases would require inspecting the areas under
> the used span to see what is there. This is not so easy.
My feeling is that checking non-coherency of target domain and save non-coherency
in pages might be the easiest way with least code change.


