Return-Path: <kvm+bounces-24208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A56C2952568
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:18:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67864289B34
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D7C3149C60;
	Wed, 14 Aug 2024 22:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q8ZSbr55"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28543143C5D;
	Wed, 14 Aug 2024 22:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723673883; cv=fail; b=ijhw/bGyQiKQjgmD7NmKXh6B0+noAJZyDlD7Z6I9AFuHrcEsmit56HX9k4PgvzNUULRI2uW1ObIFqlnWfskG1SHIJTTa9l9sawcsCw874OaQEQd3cTf+CtBFD7vNoFvBXCzbUA5j86ygEVPRZyXBoocfmY71NpgAXIuFjL64xx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723673883; c=relaxed/simple;
	bh=Ed2LaId+x5l6QnaU9F6/rF2/cTO1GzfxeNbUKULOcoY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nhTM8YSajfWdlA4hx6ORFSRA03ro3q0b8hXqTFR92i0iCmj8GwTDvPpLqDC15V7Fm1mpRZlwp23I9OXg5HrF5D6SaYO8NjI4536niUkzS3GdcPbCjlGpLc0yHeXf5G1MFc9UZ2HPVXiC1jfmDBee5zS2ahaOW79Y974Zql0QroU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q8ZSbr55; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723673882; x=1755209882;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ed2LaId+x5l6QnaU9F6/rF2/cTO1GzfxeNbUKULOcoY=;
  b=Q8ZSbr55uYXiIzWV7f1kzQ2H5qLxGlJk8IWFAZv/McDgSTKcedQ1lzAA
   2EI4h3trjofnMGe1KSGO/FPG+Qn7uZy2ynkxksHEnfMl2NAaJg3V80hCp
   W5a0Q36wo5zqVDahB7kXSX5NIEx7xjlnPJoqDcJGL+jgEhN7UpoAap9x6
   dkjRRGEurLreScYdPAMvRwC+SA1gQ3ctf1Xjveb2oTmtbpTKgs4momebK
   MiK+csN1WhkhGM1PMmG5c/Q/lYwziT1NwDbmAa6VuIrjG7GyAZz33y3c9
   J4TI0KJt3pYMe7NID9Ayn7kvits8uvAClMt8GwaJA+w80j7CzNItLbG4D
   g==;
X-CSE-ConnectionGUID: O+lOnv+7T3u2qvGoTHJ4zQ==
X-CSE-MsgGUID: /qT9OLXjRmugs0uVQQBoow==
X-IronPort-AV: E=McAfee;i="6700,10204,11164"; a="22067138"
X-IronPort-AV: E=Sophos;i="6.10,147,1719903600"; 
   d="scan'208";a="22067138"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 15:18:01 -0700
X-CSE-ConnectionGUID: kHhFJ9S+REWavvEwVIWahQ==
X-CSE-MsgGUID: cSbqxNmlQ9S7ggKi52JnAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,147,1719903600"; 
   d="scan'208";a="63582200"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Aug 2024 15:17:54 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 15:17:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 15:17:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 14 Aug 2024 15:17:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 15:17:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A+2Evj/rCCC2Xhb0CzS4/CXmOhTqoEBwq/AxP6X5unKr3HgAK1nodZFZqiL+cqiOTlToLXsq+ROR1qVohNfl3w6oq4IWjmVJY+ITB5plrEeiuhyUq/LrVo5kjwBrPnFOZE1m40uPM2MvQ2O44RCZJzzIdk6gr6he5pt3Me8Zpz2Y2GtTu8boYhBiqrd7vnZ/ptcHUIAYyAngE2HclPa/UnCJbX5238D0+jKUITgYO2YpSKThzceMCfiMZ67chbSkQvaI6MEnm07o51jT9246xiBwIcAq0R9+xYnkt2LROphMdhR8BsRjeENytipMeVxy7Ivf9CiPhsBhhk8RJpSoGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vwEAje9WSE2TaCN8Aqmdlp2TyVHgFgKgY9eywtE9ZuI=;
 b=RJCuhYZbQXFiRchwPI887NEJmI1JPGtx199+mTzrY1nqA+iJ5EcgRxwJh2t9GH9ymCe+53MDUvWFkXb9bkhgXEmPFbAQi93V86BaurtoG0r48TyzAOegaY52FQ/CZKWraJ/vOpdVEQkbAQm1jMhBfMHtZ+VbKfnBoaf1dfW2rt61yxWNBVwJhpiKagFxrq2mq/d0HfVudjHnj37RGGD4Cf7ZLoPj8vZf87Q1P0+qyObIPDPaZ4R+sb06+qEtcy8EMk/tx4HovmYing3F4JdP4NEdxAQ3B7iPCm1z9jY/nFNKnWbpWYjGqHLcWm8eyLM/hzCw/9ajcgiLSp9wE97JPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6826.namprd11.prod.outlook.com (2603:10b6:806:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.30; Wed, 14 Aug
 2024 22:17:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.030; Wed, 14 Aug 2024
 22:17:50 +0000
Message-ID: <cc44c0da-4f9f-456f-84e5-87bd4fa47af6@intel.com>
Date: Thu, 15 Aug 2024 10:17:42 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] KVM: Register cpuhp/syscore callbacks when
 enabling virt
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Anup Patel
	<Anup.Patel@wdc.com>, Huacai Chen <chenhuacai@kernel.org>, Oliver Upton
	<oupton@google.com>
References: <20240608000639.3295768-1-seanjc@google.com>
 <e8db3e58-38de-47d4-ac6c-08408f9aaa10@redhat.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <e8db3e58-38de-47d4-ac6c-08408f9aaa10@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR11CA0049.namprd11.prod.outlook.com
 (2603:10b6:a03:80::26) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SN7PR11MB6826:EE_
X-MS-Office365-Filtering-Correlation-Id: fae9aa9a-51b6-4202-51ca-08dcbcaeef40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RlVxc0QwVjZOdU5tTU5HNU94dlRlOHdFN0ZwNnF2bW4vY3lsN1hvaFhOd0xy?=
 =?utf-8?B?bktzcHpYMHBnQ3ZjK3dhc3dPYzVnZUdCZUVWb0VuaVc1MC9jWnl6K081SlNO?=
 =?utf-8?B?Z1hKQzZMTkp2YWk4Y1NVenN3UTRCWEg1SnpuMlpNMW5jVlBFaUx2UmZjMXZs?=
 =?utf-8?B?ZDgzdDNyS1JOOW9QWklTNlRWSHlYWDhtb09pNklHRkpRbkc4YytXdkwyU25l?=
 =?utf-8?B?eDBSY3F2NHhlQ0ZHZ3ZaOUlTb3cxbmNBTTNncFdRVnY0RVk1RGk5VXpQZlhB?=
 =?utf-8?B?Qm5uR29CREppVC9ibzZBR0VIVlg1aHBGM1BldTlmSC92TDNtNy8rTHFSWFRi?=
 =?utf-8?B?MU9SaGExV0pqeEdWa2VES293QW0rUTJSQzRGNUhac2dhWUlZK0k4RU5NTElQ?=
 =?utf-8?B?a1FVMUJIb3ArQ1NXMk1FNlZlZWhtMVVpcXU5elRZRVozY0gvUURwczBhTFVL?=
 =?utf-8?B?Ukk1MWxCM2JkSkREdDVNUHppRmdLYjRHc2h4UWpQU1hQR20zNXZNdXJjUE91?=
 =?utf-8?B?dVcrTnJ5Y2ZOY1ZPbjU5emRxcHJVcExTemI5aGVVSCtRdnhPOU01Q1ZIY3hD?=
 =?utf-8?B?VGltVmo2ZHZpamJhRFNZNU9TcmpFdmNHOVlvYlBWTEtRNlkwU2pVcEpndTRO?=
 =?utf-8?B?WSs0YWJzWWRyZEdoUVlqT093U2NoVy9ZNWpCcThpNlhXQnVGMlJKMmlHNjh2?=
 =?utf-8?B?RlhqdE1pWDhMbDVsL1E2UTFwY0E0SVVLVW5qbEZxOFBsRFVJaGVOQi91bHBv?=
 =?utf-8?B?RDVsRXF4VEorUTBTbDdiNVNlNHlMSHBBY2JJZHVXc1Mwb3k5bVYrRk83aCtC?=
 =?utf-8?B?dWJkbG4yQ0tadytiSnBYZnN6aEVQejZQY3dJTVN6V1NqbU5EQ1VwOC9UYnpB?=
 =?utf-8?B?ejNvbDl5RVdVQU05Lzd4cHZVOVUwRVJKcFJsSXJUOW5sL1JLZkQ1Q1hNbDZ4?=
 =?utf-8?B?WFJDYkptVkRRaVA1Yk8xbkF4UjdFdTZCcEpTWDhBa0NEMFJDZ2NyWG02ZE9n?=
 =?utf-8?B?MWJvcnNUYmdabkVBUG04T21VUXNmWUVjSzRFdTFJTUlHTE5MRlJmeUdiOVVj?=
 =?utf-8?B?ODBWcmg2cW1wMzk1L0xIUXh4Z1l0aTdWeUEvcVI1aWQ2L2lId2dGR1UwK1M3?=
 =?utf-8?B?MmJCVkp5by8rT05FbVVqWDFXb0htWHZ5MWpTOUpvN3hqUnpjdkRoenpPRmcw?=
 =?utf-8?B?cXBVbWxEdHBlc2tuNm1hWFRnRExkUzA4T3dITGFNejVjbnRmSGwyTzhaaFh3?=
 =?utf-8?B?ZUx6NDRNdHF6ckRhLy82eWZNYjlCbWRwUU14eHVva2RhWmpJVDFQWjlLeFZL?=
 =?utf-8?B?YW9PcHlCQ1l5SDFsbHJ6dzJ6UjNlSnBMT2VjZ2FJNTZUVU5laUxpVkJFM2xm?=
 =?utf-8?B?MWxYQS8rTzRQREhhQ1Nxc3JESm9vaXZmZll4N1p3ZzloSmxpV2VRMEpOZ1pT?=
 =?utf-8?B?M0xvWXNCZXE0U25EbndBMFRoY2Q0QjQrajU2K3hYN0Mvamx1cTdpaUdJZEow?=
 =?utf-8?B?amUzaDJKQnNIVnJOUzRnRUNKTGpmaTYxUUt0c0RJYWE1OW5pTUxrTnlqYnJ6?=
 =?utf-8?B?VTJvanNuU29RekhEL0ttMzM5Y01JVUk4eWVaNDJpWGVzOTJvM2JKNHUwU1Rt?=
 =?utf-8?B?cExVSkIyblZWaDZvVjJoQnlvR1ZZaWlHOUg5Smtwam1oVWpRaXYvZGc1Slcr?=
 =?utf-8?B?WmNQSlVmK2hRb0tjc1FPV2YzZWwxYXhRMXFrUzYvbHBQbEo0RnJNOE5Wa01m?=
 =?utf-8?B?RXVlUWZtMDFpTUljS0dqV0hoK2FHbGVKQk8vNG55WjZHMElKU01YQXVRTDV1?=
 =?utf-8?B?aXpnN3BHRVZmUmxvNUZPZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFVmQlZoN3lPeUpCdkhTa09PbHhBRHBxdlJkRHFYN3E4TW82cmdkK1hkcnUy?=
 =?utf-8?B?ak5wcnVnUmZLdlBxTWR3cHVZVmQxejNvTW5tdnNXVVVMSW8wTnNlMC9zUUR4?=
 =?utf-8?B?RFkyaWhJeVBuNjZxUjhxZTZNSnZxaGx2V01BemN5aXdNbzVCUXRZd00yeVZG?=
 =?utf-8?B?VWREbGxKVkhOTVdxSjVJZGY5cEQyK3pTSWVBYWtiVEgxbU1jOXJXUFlmNVQ0?=
 =?utf-8?B?TlNsbWpjamcrYmM0VUludEViUXZjN2hOcUQzdmxRaFBRNnEzdEZVVWhQRFZK?=
 =?utf-8?B?SytraGRkUkVRc0U0R1NJWStEbUN4M3pzVkdxMFZNcElBMVBjQ2xZQzA0aUtw?=
 =?utf-8?B?eUZVakF0L1BjU2thbGRjVDR3Wm8yaDdTTmRoUlNLY0VUblZTT1piNDl3RlZ6?=
 =?utf-8?B?dzBoZ1VsdGZaSVlDeVZIZ29la2VFWnZlUmlRcWFvb1FvVGJmdllQODJ5Mi9v?=
 =?utf-8?B?NnBJUVlUbjEwMVhyS3ZFeUxjVjAxR3M4cFQ3d3Q4SnR5cXhJZy9TR2h4Q2tW?=
 =?utf-8?B?VFBGb29BbDZHaDFIdkhZTC9oU1FOSFI4TlVDV0JvUGZCejh4MFhoejFweXRY?=
 =?utf-8?B?N0hWZ2tqbUxZeG5YZCtOTHdYbmlmalQ2TitIb056clRTclRMSHNWeE1OWFds?=
 =?utf-8?B?M292Ty9xTzlnSjBQVi96TldPaEJ2TW1yZGlCS3c5SGVqYXhZTUVsWCtVUXZN?=
 =?utf-8?B?NDh4aVNrMTM0U1g0Y2VBckV5R01mRlJiRnRTTUlpcUdtc3AxbHRQWkc4bXdL?=
 =?utf-8?B?V3pwZWIvSVcyV0N0NmhlMTBON05NVUpON01uSDZnOEN5MExUZi9NRW9nV1Z6?=
 =?utf-8?B?V3pvajdoQm1hakZxZFRkL21sY3V1c1BvQlpickFJNjl4UDR1S1p5N05vMER3?=
 =?utf-8?B?OTArN1NQM1dHU1NSU3MvYXNZSUUxeUQyamtPV2w3ZkFacldxOEZvUzZEV3pE?=
 =?utf-8?B?TTNsWDc3YnFZcW84d2crTjlVdWRacHVjc0dZQVRTY0RJdkZ3SWExeU1STEp5?=
 =?utf-8?B?c2x6V09jOWJKaHdaWGptMFJ3dm56eFFLaVZpVkM1eWJYL0Y2QjE2V0p2TmN2?=
 =?utf-8?B?UENTbDEzMVZhdElIc0hselJNZmVQMlNIWXMwTVlmNGFaNDZTd051S2pxQmNV?=
 =?utf-8?B?aEdPWDFDY1hOVCtFWHFmcEd0VktyZldFNzBDUlI5dUtmeEZza2VwZjVweHFn?=
 =?utf-8?B?TXJMbm5oVFNjYS9FcitUbkVTMVQyTUFIMTFWU1NERHlPbUhLV1RrYUlTYWhk?=
 =?utf-8?B?dHgrUnpwenVGR080SDNjcFpoeDNTM0dHTzJmUldYME1ReEluWHpmQXZFL1dr?=
 =?utf-8?B?Vjh5SjVya3A4YTduMWt6QnllUW5pSzFrdUhmOGVhdk1XQ01RL2J1eWlKczh1?=
 =?utf-8?B?eGZDRHJpOWxRNkQ4R2g5cDlsT1FtdmlOblJ2aS92L1hENllaSGFVRno3cEdl?=
 =?utf-8?B?M2xpNFVGSDl2dGFWN1RjWG0xcFkySHhlVDUxdEVleGJ0ZmpPOWhZMGh1UDY2?=
 =?utf-8?B?bTVxTGZtdllUZG0zanlxN0RZa1FqRWRhajQ1T2RINnJuMFVJQmZCMTJtV1Rn?=
 =?utf-8?B?Wnd1b2xINXdhMTBnOEkvaVdzNmpENVI3MExUNmtHaTBYMXVvbFlhUlBRVHI3?=
 =?utf-8?B?TURNMTVpVWRQUDVib0tnVFNUVUR0SS93cGpJaGt1ZG93Y2lnVVRwSnFNSnRX?=
 =?utf-8?B?UnFQTlM2cHhrVVZ3V0xSc0F6bnBTeGxraXRXZkxndTdsZU1XaWNVRUh0cUV6?=
 =?utf-8?B?WHZuN1VsNGRUQWswamhpay8rUGFxT2dqWGhvdzB4dy9sSVEwbVMva25lSGti?=
 =?utf-8?B?QU0wV2U1cXNESWM5aHh0QU9yVXFLcFdPT0NreGVDMW10MHFreWQ2NmhQdFpz?=
 =?utf-8?B?RFp2bG15dENlTTV5b0VybkhmL0x5MkJZeWJ0dzVnY0dwc1VyZlQvTXhKYkRE?=
 =?utf-8?B?WW5IcnkyVXd5TnRNbWNCMzVXY0gyLzRvZS9GNDM3c2llZjh6YmhocjVyOHlI?=
 =?utf-8?B?VExvRTh3cElEcXhWT1g5aGNjTk9WaDlEZGpsUVdzZzhjRUpBUzZwdUJDaHBH?=
 =?utf-8?B?TFE4WW4yRzRkQmh0UU1tR3d0d2dKVUtNaTVqQnBPbjNHRk4yVVJaRGpLYytm?=
 =?utf-8?Q?pl/JsBiWQs47yqjrrAO1V+h5l?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fae9aa9a-51b6-4202-51ca-08dcbcaeef40
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 22:17:50.6073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vMQZm4GPFRLBLBJlmC2u3zozYxPvhXREkAouZpBZrohK7I4jzSetbPdRR33lnnSMYbcv39ERTQc39wbDpfE3nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6826
X-OriginatorOrg: intel.com


> Also placed in kvm/queue, mostly as a reminder to myself, and added 
> other maintainers for testing on ARM, RISC-V and LoongArch.  The changes 
> from v3 to v4 should be mostly nits, documentation and organization of 
> the series.
> 

Also another reminder:

Could you also remove the WARN_ON() in kvm_uninit_virtualization() so 
that we can allow additional kvm_disable_virtualization() after that for 
TDX?

