Return-Path: <kvm+bounces-18101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C5968CDFA2
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 05:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68E7C1C21764
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 03:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B7B836AEC;
	Fri, 24 May 2024 03:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F9x17PTy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C076C224CE;
	Fri, 24 May 2024 03:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716520144; cv=fail; b=RzpKro3WCJRT4fLVGmBsO3+644Sdv56trFZcv2EEf7f911YKmSDWQ7mhhEHSniqW79h+XC8vlhJAoMoU5uZ+JeDhQkoSGHARdWDd94pwFNTVPsyS4EQZg5oAjnKE7QO4c/G79vPCffrsUEGAxuEw7OpndcnyQ1h3Kc7QTO5f8bM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716520144; c=relaxed/simple;
	bh=3lEZm39Lqh514oLPY4FVFw/6S8kyCdtkuO/ghIEPfjY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sd/4SMeBD/VFaUTXVBgwUOtIa3zEisOJNml5TCyH+11IWR/5/m1uMyuRq2GpCfYQHfgI/I6gYVJkCNBbBWhqGa+R6hCTlshjlKZqLXZFpD7BYvNSBVWipOjGS6ZVpPWPkOi471fxAfl+M9fz7Cwv07W+oFlE+VXge6BlKSTLglc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F9x17PTy; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716520143; x=1748056143;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=3lEZm39Lqh514oLPY4FVFw/6S8kyCdtkuO/ghIEPfjY=;
  b=F9x17PTy6sZCBSKjCG7DayofuJkmSFjO7kbv7bOS/8WdaN6O2U+qW6Op
   2Wo7Iyq1fzNmZnQj/zLBhFnp4RQ7fGm2V2B4Ebr4K3uAdz72ThXKBAFR/
   xa1xQI4Tw/tbRVw//az/XOsLkzYEiVDjDcQn8JShcjptm5jKldB0QO7v6
   mqwJxGec7pgpyuqxOQmnTmEPiYKVyBhGHUr61vlxq2hxAYjOF4yDX4nex
   e5cW0y5A+gY1NDFWeAt4AEaF0ZZ5h1i4kCTjXjY3yyP11FegfHLAJcpKU
   8brknj42vcTLmHBhfqi94NStz01J0A0aOS9uKJcFilmCFe/+KalXvC2x+
   g==;
X-CSE-ConnectionGUID: 2O1Go/cnSgW11RMGgPAOzQ==
X-CSE-MsgGUID: CUG2dyPYRaSZGWr2WfRVBg==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="12729780"
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="12729780"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 20:09:03 -0700
X-CSE-ConnectionGUID: EdKPUGIXRrinIcND0w1TlA==
X-CSE-MsgGUID: Bob8m/VhQ42Ck6VfeXDfGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="38874950"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 20:09:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 20:09:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 20:09:01 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 20:08:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGfuLebeBJRzv5CNKJHDUe/468FZN/5309nmVczXgtk5kEwCe9S+xf1HfGsMjz7UKOvYZPsZqeXhy1oX+KJx/lpI2oN8IWvZhlbjT3kOtf3bqGtJBu/Yzt0U876GuUPXfyg0ubP/KK5QDBWbu6WfbLtVjFfOCTUXJWZPeZCD/0UzSvVGLXE+Iq0kZMfqYgg+OjLJ4QbFk2EUFcwJyE7RbAl5bp7evXN5+AAs5V8XC7Q0Ktnm63qGKSuOWA33kh2VHxtLXEEO9O+6zjxzTkvLFv7oHuDF7Vf7YGqkBzdc4l/Fo9+muZUY5WE/En9JJBS64UnxF9A/DDAInaVCF5wQyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DpTGk7nsCG/GY9AQnZ3T7CRg9grrVnyu+NXv7jiuw7s=;
 b=F6iHq8oENMmFElp8uy+c4hE5tRB2pz3sj7IXbKI3gnYEP/SHjr3xFEdiL8dTJzrE7t8bmkY9BTOdi3mejqQzlRbkvuAtuLXelfgxrMxaJqaREjUdpjjTAYf2/1rWdsaYtNjieTWU9MDoNxToIs0YwxRPzUfrktUM8TOMEzmU9VAAibhvoMQYxfPmi3Nw4u0dHqa5ZjVitKl0kERhlE2ICt427SdBUg/JjIffx+4GzWjS6WCOz8i9SHXTFiYEzY8NdHWyV4WIdbj9/sxg/ZVnWsyjtfSOhK2SNUV721zIw5atP1SsOTq96uImwwZJLSlAof9WnpZUBox9AwGRL3ubKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8273.namprd11.prod.outlook.com (2603:10b6:510:1ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.38; Fri, 24 May
 2024 03:08:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 03:08:49 +0000
Date: Fri, 24 May 2024 11:07:56 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "Tian, Kevin"
	<kevin.tian@intel.com>, "Vetter, Daniel" <daniel.vetter@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <ZlAEjMIpSG8PoMnc@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
 <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240516143159.0416d6c7.alex.williamson@redhat.com>
 <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
 <20240521163400.GK20229@nvidia.com>
 <Zk1lZNCPywTmythz@yzhao56-desk.sh.intel.com>
 <20240522122605.GS20229@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240522122605.GS20229@nvidia.com>
X-ClientProxiedBy: SI2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:194::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8273:EE_
X-MS-Office365-Filtering-Correlation-Id: 97b5dfe9-3c37-4a8c-70eb-08dc7b9ed56e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eJHwAU+Cm+aImiKYVl3doMasNct8U9OGg7RA+CeKzkyez0y13PsVVoIs5rGY?=
 =?us-ascii?Q?W0jQsejCUayRtZzxE7gAazhMkqLMawLQ2DQC6Y3m/I7Io6UTgMZ7DuB02Xal?=
 =?us-ascii?Q?uIXaUHezM48fT8pEjvMswz9dnhtFCpVzEFWu69TwfpMUYq0+/c4KcNTE+C3K?=
 =?us-ascii?Q?D5jMXPtrydhvuEM0s/i6eIdjMgQhsozqrydUWC2O0DZlYbdSQoFiHQxRrEod?=
 =?us-ascii?Q?9qhRpKYAHBuO5t9JRhcgptnPA5PW53RgqA9E38OG2slrrgQ/dmbl4n5ImzQK?=
 =?us-ascii?Q?0OzKYFF3V/pDgrD8KJ7EopInefinhWSTVOEzXxHl/qnoLUkWS5AjSeA2s0tc?=
 =?us-ascii?Q?XmxTAqf1+6YNp3eJRYbgpviQXDTGmfdu1vUdGnyqY0clOIBwygdj3TZBC0MR?=
 =?us-ascii?Q?sCcwMWq1BJxskZ/izyoEsiiywnubPGXcb8VIew2I5TUR+s4INoPXYit7h8dk?=
 =?us-ascii?Q?Qk+mZvdY9X4Nlkd1WxDVPp9qhvCjwYx0DOM+2N+FR39LnuGnL+cM2uGX/ngC?=
 =?us-ascii?Q?uNStCfOUkBfVEja4U9Ck6RP0bJn6nhJzj3QwvU5liavsqRSpP+041FLrtPc7?=
 =?us-ascii?Q?NJBvo63Os3kU3jGb7E9IWmAx8ljrTchGdMWd/kGjXm5FBWkrctaCOBKQa64f?=
 =?us-ascii?Q?K5bRSttvZKT/E0NoEGE9OkPTcs7XB4FYJaAKPxq+IQGLv21oeX7Z2k38n7OJ?=
 =?us-ascii?Q?QrTjrgzmW6RXyDKKv7A6e3BxfW7FvAzbLjrzDf7sPKykG11h0u8FDJzkP0cU?=
 =?us-ascii?Q?8S7KhuBcYWt9smlpJrpLgPhwQ01AQgjJinkBZHq/j9HNiICC1NMcrUP3UuOs?=
 =?us-ascii?Q?GFmtylJvVqrGMUGIT7jQkPbna86IYRrWqljzzNMgYiNXAeTV2Pn/zS7Zx4Gd?=
 =?us-ascii?Q?AXdmSMiKfQKsjB6T8Ak7zVGEIBeuGEZ8qXWoQehmmtMl7Ka1scVXnXd1BdWR?=
 =?us-ascii?Q?wJwZFz68eY4+etXQlIxl1sGdEwk9ceIpCarkIhPzokZureIRHX87ht+I+2Ul?=
 =?us-ascii?Q?ckP4IGFxw+uMhAI6l4igm6WOl4zGpl3OLWt/TTY8zqe+xm8Dn5T5Wx3Oubss?=
 =?us-ascii?Q?1RQBg2huAfVBSaGYGkjkgihwxwpLeHk/XlRQbS6HVc8uOFf+osb80qujjV9U?=
 =?us-ascii?Q?wIOug4/Xg+vTC3FFSM3fJEGlLC9VQX90rzWm5kQI99Y3j3qohoiN7hWI56vH?=
 =?us-ascii?Q?78+XuOwvhczDZ8eSIgybOcDVtnKpxyaib2zRYCFfrR+zQIErJODJA1lQZDev?=
 =?us-ascii?Q?chxT4GCGO0lQZJ9vnGCaHsanBCSxoyu000onk1Rafw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N0f0j4qFH4pIwrHdGhudZxBU9NKEFQOSnCgj6EOUm6ktjUgFasTuSdoDbvoi?=
 =?us-ascii?Q?uD/CLa7wV8zZLx3DCdKJVk+lv2LrG+JkS1qeIfV88WE5fVEYKDadm5ajb9Ed?=
 =?us-ascii?Q?xQydPjzbsVfk9umLLC2Gg1haOyTd01fLFU9HZXxAeqLvWTnK0tjM5Tm//0in?=
 =?us-ascii?Q?E+4nUhGX0luZSwzOSIrpN+V/bKIdaLLkh5eqmunBc2DfqVGo7McERUrvJqC8?=
 =?us-ascii?Q?hwwsqikBUm5KAZWYeeUrSJ9MsduSWyotdd5S4LHMcA305ZijCiAecBuqKQr9?=
 =?us-ascii?Q?AhpPCGZ2a3euGT4ACp8bq8CEVU8w35ZU4AP8ixyrqapkWfBlSD/5SDrO0K5G?=
 =?us-ascii?Q?DCyxPHV2RDKDCt1K76ZT7uWI6k1BV3HjQj5ASoV6F1AQ/sFb/LOcTqhEKJtH?=
 =?us-ascii?Q?WLDkkSSjW+eUo5fhedloyVQ/OVxmq13oRJVlO1lp39/57b7uHFxBk78scp2B?=
 =?us-ascii?Q?aQP2c5qv4CQsyOZeyqY6n9hauNmVEM2zkR+OCrG9xnMwLmY92qL8cXBHc+jC?=
 =?us-ascii?Q?om7azgMNvSg1gaky3s4tw9f0buB1CuOA4RrM0RRljWUDbdCAWYWXH/6wBf8w?=
 =?us-ascii?Q?OiN7PG9pQty/BBamII4JLyat/SUZH8bG4So+jNE4j/nJJ45OS/1Tupm9VPwz?=
 =?us-ascii?Q?l0OBzu0yN896p/iQupJils6+aX4g/03kePcTLmRDTTCPeu2F/XrV4Er1FwYJ?=
 =?us-ascii?Q?9GX2vHJcemkv8Y+8n7SfnBoiteYoin/QMSskSFV7OOtCco1sO582wZXXsZHc?=
 =?us-ascii?Q?CwwFqtDZx+z1jIRPoCp/cWnk1lknM18LWImr1Py+S0Jcbrna5o4FNErPM3g0?=
 =?us-ascii?Q?a41TL7HNYxZ4X/vuhuDpnKHkxbvrnjSULvzOHa0n4lC87lxOzusCuxFiyqBo?=
 =?us-ascii?Q?uEcA0kAp62EvBXXqWohKCHET+f+qRR8zhosNgpLX3hvBSgCi9UnMlmLvOG12?=
 =?us-ascii?Q?1H9zice79cFxlBf300cWHR2+2FVonlZq5bq/EndynWqnl7cNh4wQ/kx/kMdO?=
 =?us-ascii?Q?yuzpuU+HKC339wHmCCTrrMFWEVWa2LMeEBmat29TRlpEfGK6izF6VyHWhj5/?=
 =?us-ascii?Q?c42clHFl0GkrYN2vvL8yQAcV0+hCE4ifONtqOdbMm6S+wlpMmbSRa6WH9rG4?=
 =?us-ascii?Q?juIHCZB9Bg/eplRquXFPb1OWB5PfmY+LLeKrLSOOrYX7w7cK06Y7A6frW2Bw?=
 =?us-ascii?Q?Kbt69kSxSUqLoHle0DgQL/cUkqIWA+MIj/pp7UieI5TdgqW5UvFeiFzYCz66?=
 =?us-ascii?Q?DTCS+kHnH/UCi4PgbGfH/OEh0xoNArYXaWqmiahzYy7gkpbDjf1edgetwV73?=
 =?us-ascii?Q?JgtXfxXytBSS8Z3pYJn8rBWdAf7KL4yyKLtorkV+KknWbQUM7LFtLWtGUurb?=
 =?us-ascii?Q?EECOccZeJpP4OL/DFdmSaglQP/Ie6Fa5vG1IAYVGVacBqzFn6DL8Ig41crWJ?=
 =?us-ascii?Q?pYME6waMgNDTLJ/u3hJZAE+PxWNB0y+4gOP+pEWolBgdRTaiVgJOoYrbrgIF?=
 =?us-ascii?Q?s8IgzDqf2lAOIin94dVWVRsKJGnvRhKcOLiiRG/cxgisz4juSKEQnbjTpR/R?=
 =?us-ascii?Q?sgpYTCVqczDVAREuPCCEP3RQyYpoOC36X3KoRpm8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97b5dfe9-3c37-4a8c-70eb-08dc7b9ed56e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 03:08:49.7537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SC2t6naCXjAo4VSqDfLurV13FqjlVCbKqppqKlDpugSytmTCTikr219OKPIJceYiQAIDzwxHLkSWGUMTJNmOUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8273
X-OriginatorOrg: intel.com

On Wed, May 22, 2024 at 09:26:05AM -0300, Jason Gunthorpe wrote:
> On Wed, May 22, 2024 at 11:24:20AM +0800, Yan Zhao wrote:
> > On Tue, May 21, 2024 at 01:34:00PM -0300, Jason Gunthorpe wrote:
> > > On Tue, May 21, 2024 at 10:21:23AM -0600, Alex Williamson wrote:
> > > 
> > > > > Intel GPU weirdness should not leak into making other devices
> > > > > insecure/slow. If necessary Intel GPU only should get some variant
> > > > > override to keep no snoop working.
> > > > > 
> > > > > It would make alot of good sense if VFIO made the default to disable
> > > > > no-snoop via the config space.
> > > > 
> > > > We can certainly virtualize the config space no-snoop enable bit, but
> > > > I'm not sure what it actually accomplishes.  We'd then be relying on
> > > > the device to honor the bit and not have any backdoors to twiddle the
> > > > bit otherwise (where we know that GPUs often have multiple paths to get
> > > > to config space).
> > > 
> > > I'm OK with this. If devices are insecure then they need quirks in
> > > vfio to disclose their problems, we shouldn't punish everyone who
> > > followed the spec because of some bad actors.
> > Does that mean a malicous device that does not honor the bit could read
> > uninitialized host data?
> 
> Yes, but a malicious device could also just do DMA with the PF RID and
> break everything. VFIO substantially trusts the device already, I'm
> not sure trusting it to do no-snoop blocking is a big reach.
There are minor differences between the two trusts though.
With no-snoop, the page is possible to be critical data previously used by
kernel core.
But with a fake RID, a malicious device can at least access memory allowed
for other devices.

