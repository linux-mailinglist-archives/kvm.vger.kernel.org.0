Return-Path: <kvm+bounces-18264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 327438D2D62
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 08:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 568891C25311
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 06:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6076715EFDA;
	Wed, 29 May 2024 06:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z58qW0x0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B8715A878
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 06:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716964521; cv=fail; b=RRgsTrM5umsfC94z48y2P1Ui7PaDcOWKPvRr2sF0sPIiKl3p4aNAXEpZaaRMfuHZEPvu7XSZ5duuLg1PeXeAfAyaNqqPLMbwbDk220IL2YE5cVQxI4Wz1fq8CwaMcmQmgcSrorEhnuBgQZKee1NTyMryRCas6hoQFaGLJ/aNGaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716964521; c=relaxed/simple;
	bh=zH7yjKSMLCOsds2bDOcrr9eKiPJ1iH0w7jd5Wl79G2w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CvgHad4gZZ9X1wyqWzPb+OItbG1iEeMByjs55Heup3m4t/rRELvIS7fb7OS2sHBfqKxZVK8qLynodsQpuKoF807VXaxnnx/RgsiCK2B0/X2/wralWK36bdONKYEaMTeES1JPav/d+6hb8yf+AIWFnWiv4TOUoimTF5aYugB6SiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z58qW0x0; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716964519; x=1748500519;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zH7yjKSMLCOsds2bDOcrr9eKiPJ1iH0w7jd5Wl79G2w=;
  b=Z58qW0x0U4GpYeRK/JQtKIAHzo9Tig4IPFRrlnqF+JsyhKAohugR4865
   mbCo3ACPNzu3wCs1Nw9y3oYZFRFEbc899F6Xvpa1EREDlMBg9mV8vDs1W
   cleLBi//qQnUZT5fMBjwcc+xopQGQDPzp9xDoBLilm7OOultjjdJlbttR
   k21awFAhyKRbSafvyEc20OhItjuQiphkzULgIS9gAeFI/eRnohYb6GNYD
   kT2cvodMt+XygSk1EuqTR6Q1Go1lGOYtnLIz3zCJGlPvo4nGKtM1VbWXb
   1AzHIzNaz9makiubwsYeOmPvm4F64OIrSabnUmCDHiYlR+822/jMTZ/W4
   A==;
X-CSE-ConnectionGUID: +NLP4GfzSta/mq7p4AR0hQ==
X-CSE-MsgGUID: 1rkPUygwRSag/9No3dnuEQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="23958071"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="23958071"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 23:35:19 -0700
X-CSE-ConnectionGUID: PmCfagQUS4GR2gLUvg+LFw==
X-CSE-MsgGUID: vwTOEg7fTWaoiceMHua4uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="39769157"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 23:35:19 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 23:35:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 23:35:18 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 23:35:18 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 23:35:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Supu55FGYCUsftSctN9zc02NODyLkbU+emhYmczH225MdZ0V0lDHvVXGrWcKjevOaK3402Ye9iPb/8RveOC7hlLI6J4UwFS2sAZMqUvpbonkjJ9q+zqnnkOlVSdTnau0zILIWUg+uW5bA9ijXO6SWQY1LGR3ZRNbBZqwuz0yUf+gztxzvxU8ihIDJneI2tWp5mDs6r/qM9jDNQr49hcO49kFtpord9rUPfYSGfFgvcVHS6Xoz7HpHzCQThHbs9YDZHsWB9fZmqTwy4L81eB+GQv8qOmbz761NYYfpg6ZCWwHMdz1PDNSRk4+wSFNIcCP9zVTBB2puVdwEELOGC0ziA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avMLdqzFASu65JlRmtA6RU8F1n9vU4aVRg240N2joGM=;
 b=FNpL5w5kmdG9wR3LxFoHnQTdtx49sNAoul5xtOAI2Q5iXdUBypux+gTVZaATxR6GxiNkMpCKC2Nv1Xix3JqBYGYEW+tIcdO05voKlxgAgDL4U1D88e9ggpfI7sjH1VJvetUzD2c/ptKbHwMs/U7aKX7kUUJf9LyXHBKNFkD1HpT+THPx9+GufpWIXnCJ8wiaYwWU8T0x8wQOfYAonAk01oKjVAhYq9PoySKQREKADR9r4nDnk8Y5a/WOrtSk6a+qjmFmli1UJA8uZo1vECI2XlPo/AXsKt/fRVIEUxsXWT8ADXHFZCGXtuhzg2AYbkdAKis3WcJZdLKDj4ex3xnuKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB8197.namprd11.prod.outlook.com (2603:10b6:208:446::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Wed, 29 May
 2024 06:35:16 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 06:35:15 +0000
Date: Wed, 29 May 2024 14:34:23 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Peter Xu <peterx@redhat.com>, <kvm@vger.kernel.org>,
	<ajones@ventanamicro.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <ZlbMb9F4+vNwTUDf@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-3-alex.williamson@redhat.com>
 <Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com>
 <Zk_j_zVp_0j75Zxr@x1n>
 <Zk/xlxpsDTYvCSUK@yzhao56-desk.sh.intel.com>
 <20240528124251.3c3dcfe4.alex.williamson@redhat.com>
 <ZlaTDXc3Zjw9g3nG@yzhao56-desk.sh.intel.com>
 <20240528211200.1a5074e3.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240528211200.1a5074e3.alex.williamson@redhat.com>
X-ClientProxiedBy: SI2PR01CA0033.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB8197:EE_
X-MS-Office365-Filtering-Correlation-Id: 15e744c2-a360-48d6-30c6-08dc7fa98036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mwcl6IIcRsAa+soHMtq00AIE27hSWjlsU6cci2EChlJ47qTARoZ9UauGPEuv?=
 =?us-ascii?Q?19M3mQ16UKwZQ8NeAqbkaeC6dENkhwt3RXFyTQEHfVFHA/ZE2bjsEgAItmIY?=
 =?us-ascii?Q?8yUL7WC3yKXwkarFMBO0i9qY2MdwsdtktAC0WCjdk5CyGYPD+EUqu+YpP/JW?=
 =?us-ascii?Q?FKDmdg1Eab1BKQ3W+vFe89u3qerR8qC3fKCd97GVnWnRhJs9dtQ6KuVrDGda?=
 =?us-ascii?Q?0+rfMVm/IVo/YseXibx7q5bLq7TBz7EKR8No/WCexh1akOivNOEPXFOfFJ+A?=
 =?us-ascii?Q?DEyxAJ7ybO3Q+3hoB818KxT27mSpxwOP/QVkH3nTpIu1wHoF0eP4l2qPDwwJ?=
 =?us-ascii?Q?itHFzL/6Lb+O9mVx2lWHmjy7j/bNxG30WEGs8o7D9lmxSCa+iK4vVKfFV4Ol?=
 =?us-ascii?Q?6Zxfn8BbXX3kH8+ItgyXUPHi3OVxM9513efUsFEfo+l1gWOzPJMmKZepiEVU?=
 =?us-ascii?Q?EvsA4LXHywT1/WUb6smGzSQO35iO6Gydj5W7TDPlSIahJlFKpa4V2+IDrtxY?=
 =?us-ascii?Q?bihEOq7WifE6MPT+37zJvVTySVS/+Jo7H1HJJNnDOm/FKKCul9UHoKz48x2n?=
 =?us-ascii?Q?S6jAFFfJ8V/UfXdx0vpwre4DKLz3X/crDumo5jGbziPV3HeyO9lyYr7Hr4sj?=
 =?us-ascii?Q?uWb2Qi5C9+eOFMtfuLIIXCtt3WhsjEA8Wf0gLI2ww6sCobySf7b6RXD7RM8p?=
 =?us-ascii?Q?12epQcBsu5vwiTSkEeiZUA7u8IGygiVFqrhnV6KYTzOV+T24Dfjsx15IfVt9?=
 =?us-ascii?Q?o3YlCrMJQuSu9Z+Io7E4a+5Rn6og3TCzjjmenyEvh7YbEFfxiY02gfOBMehl?=
 =?us-ascii?Q?z9XpLbbV7O/MTFPU7knpWlUk/N5X//ru9pH8uW76rkckwljeziOY/GG4Qta3?=
 =?us-ascii?Q?XbDAP51eW9QkwDo30cx7ZeAQUkVVrf8hDSmttum0zWQ18geMLYQ1Mc0REQcX?=
 =?us-ascii?Q?L9CRA1ag9ibeUNz6hcv5uvGsLzx+XWV5je+D/FCuiHNxjh97QOn+Ur1l0dbd?=
 =?us-ascii?Q?kkTih6s6dgawjQwzgsdaDbc5EvmMqcGq2PeP1KYY+82eno1LicxttxxvPmqx?=
 =?us-ascii?Q?lMyZGAprtc1JRPOIsRREocjo4OswxTGjK0WumEYC00caMyuXkKOGCkMqzMaE?=
 =?us-ascii?Q?q6J+tGoZwy5fsFC/gxlzoohyFHaPZcP+Qye2EyP4yICx3C7OsZhninGm56oi?=
 =?us-ascii?Q?O7XKJyQJ1tSYGcC4azoqjfeJzxhHvnQCdNc+XSoQRB/KVqtW+sGK2mshc9o?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FrjJClMOF4KPA/kQC/IBBXNVhiQm3567i5EaP/OuO68svKEIAkL7F2dvSaN0?=
 =?us-ascii?Q?qESV2kwpj9TcF04aqMsxT3DLBe7qrrR3+KaDe6EFoZrzmtQxELGaRXfOQb9/?=
 =?us-ascii?Q?XfkpWvrC/Ki/3c6jeVas2rnMg+lYZ5ZAjESIRDUXrunI72TWbm3jiDxHRegA?=
 =?us-ascii?Q?wM8PY4/hL4Q/Z2yLnyomLh9c/weNjQo2jPfK2IT5lb5nmEAU5uWG6A0m30BP?=
 =?us-ascii?Q?+YBTafvEfBE8Gea/Mqte/d9oMrlUqL52p+pCFVOwJNKOhE/I6z8i6bS8Rius?=
 =?us-ascii?Q?lG+egSjsQv6E0dIGB6/wPmlTpW6LNyxrityfPdTFB4N/nvOq0K+FGYqNZF0t?=
 =?us-ascii?Q?QPoI3XFn3zx1p0J2N1g5iawW74cwrDTtWmvclXc43pP8WCXdHbf7W7JKsOup?=
 =?us-ascii?Q?jb75nI5JgwBnNbuRsDuSGEWHc+Jl1VGZh3fQKRiI3sUidUP4nJB8geok48v0?=
 =?us-ascii?Q?T+QekxfLpl0uVhCFbjMWPAmtTbSOtfX1RAUxBmyHov5kJkzGz7nMV19+d2UQ?=
 =?us-ascii?Q?RJR+qoiADTHPxrWq8oY7DVYIp4zAqoH5M7CACcXmj0GBs1nqwYdnl7jhyyEd?=
 =?us-ascii?Q?ZEzFoJmfZDkAIyDNbKGSPwP4xR+gImD1jB0XZjfCRUZ/3LQqqwD3CRQzWXe4?=
 =?us-ascii?Q?CBMFFjsF7LjgVE+mk/Zn1YFgVm/QTT7Qmdk2tf//sOgsBzBNTff1tLn0k2iJ?=
 =?us-ascii?Q?sSiqJtbPOFJZ4HuWdRMr3cu6oiH9Q+5nmvvieVJXPB6YuCQUgfKUEsxqFfQ2?=
 =?us-ascii?Q?BdUwFVyhlDIxpFPKLJd78bV9Nq4DT1CT4bK8lSl4TTpPNYqwWARxbYINswbp?=
 =?us-ascii?Q?Scux/B4D3wXuCiSQEKljjpgUGMN5EgMZIf7h6jMSwcHIs/EJSRdUxPb6rejA?=
 =?us-ascii?Q?MrFE9FCRwwz88HuTElpxmZZbDUP4Mwh/0wJ6zkCx3rjp3iDcG3GghGdJsaD6?=
 =?us-ascii?Q?O63kgRQbstl+czPTh/9aRN6jVmKJqbhwzxh/DYEWmbjSXbsN2r0LtrSQRxiR?=
 =?us-ascii?Q?QyvaLs6Hh0cPWBjfdS39aMXuFXxaLtx1Z2qsT2mYQBG3P0i50G/1Owhungou?=
 =?us-ascii?Q?AO9co9+ygpVBMW+qt62fpKu67U68MtgKO4mrx8wcHkTvY6+JwtlH+wi4GugZ?=
 =?us-ascii?Q?kiEryxRTnQWQ8aT1N6WnXICuyP5jy4akl0ISVYgEsnmS93lO7Zw5gxj3XEmG?=
 =?us-ascii?Q?PqK+EgFv9qIV30pEqWdJ+q/hVYPwRFcL3PfnBJSVqrqmUA9Lxq107XTmbXYP?=
 =?us-ascii?Q?FI7pSWIrFbGUrfdwyw9vHVqpgTDae3707jGaQgPmTmgdILBySR9vfZk1nON+?=
 =?us-ascii?Q?YWupVIXXPHee/YsQVtsWyVAZchiFyFC2/bo6Ezk6by+JN1mOPZGZqr2L2H1R?=
 =?us-ascii?Q?p1z3VwO3GgGvpE+9W2A2xYkS4Nq27dWs0L/sBSKuGGpf8dW9ePaCjjE9GBPW?=
 =?us-ascii?Q?ey5ia/VDWb089gk0SKRbBfcI0pNGluSycrUiIcOblKcK16QmMxP+1GNfMTXW?=
 =?us-ascii?Q?0fiWHn2TbHmkBmI4tiu1vkLNxC7KsLqc+f78TZV8P/24RSIpbCXnZeoPbdX9?=
 =?us-ascii?Q?nDy3oVnTqepWmG29Rvbklxpj7p+5isecUfnD/hPb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e744c2-a360-48d6-30c6-08dc7fa98036
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 06:35:15.8562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQjHmdBZuqJVgROpqkXc/seXz2nopFs9k8g3gneNG1aQox2GoZatxItFrQEpoN2gynLE0y2NbwXsC7VxFMROUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8197
X-OriginatorOrg: intel.com

On Tue, May 28, 2024 at 09:12:00PM -0600, Alex Williamson wrote:
> On Wed, 29 May 2024 10:29:33 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Tue, May 28, 2024 at 12:42:51PM -0600, Alex Williamson wrote:
> > > On Fri, 24 May 2024 09:47:03 +0800
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >   
> > > > On Thu, May 23, 2024 at 08:49:03PM -0400, Peter Xu wrote:  
> > > > > Hi, Yan,
> > > > > 
> > > > > On Fri, May 24, 2024 at 08:39:37AM +0800, Yan Zhao wrote:    
> > > > > > On Thu, May 23, 2024 at 01:56:27PM -0600, Alex Williamson wrote:    
> > > > > > > With the vfio device fd tied to the address space of the pseudo fs
> > > > > > > inode, we can use the mm to track all vmas that might be mmap'ing
> > > > > > > device BARs, which removes our vma_list and all the complicated lock
> > > > > > > ordering necessary to manually zap each related vma.
> > > > > > > 
> > > > > > > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > > > > > > unmap_mapping_range() to zap a selective portion of the device fd
> > > > > > > corresponding to BAR mappings.
> > > > > > > 
> > > > > > > This also converts our mmap fault handler to use vmf_insert_pfn()    
> > > > > > Looks vmf_insert_pfn() does not call memtype_reserve() to reserve memory type
> > > > > > for the PFN on x86 as what's done in io_remap_pfn_range().
> > > > > > 
> > > > > > Instead, it just calls lookup_memtype() and determine the final prot based on
> > > > > > the result from this lookup, which might not prevent others from reserving the
> > > > > > PFN to other memory types.    
> > > > > 
> > > > > I didn't worry too much on others reserving the same pfn range, as that
> > > > > should be the mmio region for this device, and this device should be owned
> > > > > by vfio driver.
> > > > > 
> > > > > However I share the same question, see:
> > > > > 
> > > > > https://lore.kernel.org/r/20240523223745.395337-2-peterx@redhat.com
> > > > > 
> > > > > So far I think it's not a major issue as VFIO always use UC- mem type, and
> > > > > that's also the default.  But I do also feel like there's something we can    
> > > > Right, but I feel that it may lead to inconsistency in reserved mem type if VFIO
> > > > (or the variant driver) opts to use WC for certain BAR as mem type in future.
> > > > Not sure if it will be true though :)  
> > > 
> > > Does Kevin's comment[1] satisfy your concern?  vfio_pci_core_mmap()
> > > needs to make sure the PCI BAR region is requested before the mmap,
> > > which is tracked via the barmap.  Therefore the barmap is always setup
> > > via pci_iomap() which will call memtype_reserve() with UC- attribute.  
> > Just a question out of curiosity.
> > Is this a must to call pci_iomap() in vfio_pci_core_mmap()?
> > I don't see it or ioremap*() is called before nvgrace_gpu_mmap().
> 
> nvgrace-gpu is exposing a non-PCI coherent memory region as a BAR, so
> it doesn't request the PCI BAR region and is on it's own for read/write
> access as well.  To mmap an actual PCI BAR it's required to request the
Thanks for explanation!
So, if mmap happens before read/write, where is page memtype reserved?

> region and vfio-pci-core uses the barmap to track which BARs have been
> requested.  Thanks,

