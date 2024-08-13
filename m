Return-Path: <kvm+bounces-24070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C19CF951069
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:19:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC6D51C213BE
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 23:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 191E51ABEA8;
	Tue, 13 Aug 2024 23:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RWVZI0zJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D617C153BF6;
	Tue, 13 Aug 2024 23:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723591141; cv=fail; b=mg7nz4RjXA13ntx8RUcABzKt31l1S4BR70obBEOa+HMUkJHzmKnlI9Ma5IDfBwh4cXiX3Kqdh1sbqR37aNYh9cCcXLzIVvQsQi6UrDSFGQHItF2SZew/m36RieXbtD0/iUYnKdZqguLQjFafjjTrFMBTXcTynhDOxQoBP/iJRCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723591141; c=relaxed/simple;
	bh=h6od+mWH+wavgVsrrTxDq2Hj5J3QpAN1B9g9gbgJx6I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DvlFFJb7DfHH5qPNl1HMcA7ViEO7Xnhpq0YhCNk74TsgqCygwPzYAzn1mCF5TaEfRzdwoAAmVFcWRjoC1xQ5Qpj4uGk1ftLUCsL8TAT0SmrW2N5fgfBAi+zj6vbs8+KQvNwyPCa1MOL0SvadTS6jWxqJfb7HFsJ8msB8HLtMXlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RWVZI0zJ; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723591140; x=1755127140;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h6od+mWH+wavgVsrrTxDq2Hj5J3QpAN1B9g9gbgJx6I=;
  b=RWVZI0zJDxjtyOIBeUxUM7MKoeMwMIxs8OrIGMgdQC2iKdY+QVZoPt9E
   aJhrEp2+3IMj+jGfZSvZpbEnf+Cb3BUAtaoWfVuQXnrI2LyhRQrbEQKqd
   aJ7V/ZFKgFg3Yt+Q5lfpqAdOguf6H4XPVTki0yh0zPJt676CcEgoEd3pQ
   XNERqY7JRmlGlB78GYzN/17rod59cj85FscA7OPpoCFZUFpl3vXrbtKKS
   +2vB8gssHe7/MnyJGGRgTArAmjLjS38dUCn6v8Np48LZQ85evqSJBnOIe
   brK1GVPLwSfXl8rrxLRCiTHRU16G+OnoyVaDpoC8qTXcuLy0/9xPeGktI
   w==;
X-CSE-ConnectionGUID: o77CTkTcSz6oRrW/dwaPEw==
X-CSE-MsgGUID: KtiMfSCPRraxoeOvqBAwJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="32929330"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="32929330"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 16:18:59 -0700
X-CSE-ConnectionGUID: 8D8bGdjcQmOOiknhYtdOvg==
X-CSE-MsgGUID: gUZfWywsTXm9xtSXIMecYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="63229700"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 16:18:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 16:18:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 16:18:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 16:18:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lXGCaIwYFjgL47sPRspQjsu6hNM+GyO80Xt2lBoEIbn+MXf31s98rN5f+yjErNmwPqqJMm3beJjB6SvslH5sfPHyoinCvGb+hGLxZUbdqrugZQcl7YVjLKkQczeRvBl5t4dszLKhKhAIlYU9ReMBxzHIwHf/T8RXRXn/z3m0JP0oYIuKwUoI3NxPVYGes0W2tvjJR6V2GB7vOF3iybTT+Pbl2ITSafMSe+tA7yNDnoCVA/6ZIf59WTC3SU1Z2Z2za002Sz/PKcKckFoVLIJF0T2SIumkIG8V8K8UmtXCIlfPENrI8UumO9vIjZxJ6RpxhQGLQp8I7u9zeAXffIjoKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCB9NA7AF1aEWrYj3W4hYH451P1IeOdfKOIqqCmTMoY=;
 b=HLw+1/ctYu9x86lwxVTxHf7I16pp1Q/N3pN9z4ED+9GhCzvNcRxd0xvzZXfzwVG+1ykRjvTPCxRK7Bc+n+iSCxsa/Nsj8O3j9OnZEJZPQbYN1fpMqkRStP2kgBOAiZ4ad+Zoh6FWCWNoTrfGkeUdjNYxIDlzY5xhke8wg7EscRMbguGTawsXJbjFQ5A9XQE4Otixe6e332uS9OaRkBQJPfCDfYBbbJ4LwVTgCaUVmnayRm0WrgIKrxCWDd6SLv/nKRvo5eu7n5FT8novsoZxIM484e0c1GyXfSusNDEubTgZ5gHmoBCKuPRlYbf9a/zLGFaohC6onf/IUUwgTFa6VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4867.namprd11.prod.outlook.com (2603:10b6:303:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.32; Tue, 13 Aug
 2024 23:18:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.030; Tue, 13 Aug 2024
 23:18:55 +0000
Message-ID: <0b27494f-7ce0-4ca7-8238-cb95999b3142@intel.com>
Date: Wed, 14 Aug 2024 11:18:47 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: x86: Use is_kvm_hc_exit_enabled() instead of
 opencode
To: Binbin Wu <binbin.wu@linux.intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <isaku.yamahata@intel.com>,
	<rick.p.edgecombe@intel.com>, <michael.roth@amd.com>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-3-binbin.wu@linux.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240813051256.2246612-3-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0279.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::14) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CO1PR11MB4867:EE_
X-MS-Office365-Filtering-Correlation-Id: 295ee0d5-2c2c-4c9e-25d3-08dcbbee4d1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MHlvODA2dXZualJncWZjbEVEUXlTN0srZ2RnZTYrZU5KY3FoUWc5c282OWxa?=
 =?utf-8?B?dTN5UlhWeVBwc1hmQmRaanFxak9IdFhUZE02ZFpwem9VOTlLbzZSWEFzVDh2?=
 =?utf-8?B?cnhlckI5cTZQZDREN3Job2ZReE5KTm5zOW5jNXRjNHF5U096NkJydUltMGNG?=
 =?utf-8?B?NGhUWm1yaUkrTkVER25uMEZpektwMjNOeFc3MElIMnhrUWJET09zWkw3QnlJ?=
 =?utf-8?B?N2tvc3pJSVRKUFd1a0YvZWZxK3pzTXdZaXF3ejBpTTMyMUcwRVMyTEZMWDBJ?=
 =?utf-8?B?WXRlSzFBTEhCVFRlVGNEdE1hcVRiUjNqNHliVk1maTZ4VDlkY0p6YW9CQVAz?=
 =?utf-8?B?MzZoTmZyK2ZyeExiWTRWT0NDdG4rOWRxekx2WHJ2dVJjaWF3anN1b1QzTDN6?=
 =?utf-8?B?cENocE9OL3FzNDh4Zzc0d2hldmUraC91YWcwR3NtNFlKclA2akFnMnE1aGVU?=
 =?utf-8?B?UmJZSkxQajhTQ0M5cHNaVHQwZS85ekFhRnVMUjIyS1J3QUNYZEJsTVU2RkMx?=
 =?utf-8?B?VGJHUG9LeTd3emVkMHZ3UHlURVBJTzVwdWt3SXhZUGIwa0RVZU9Dd2hhb0M2?=
 =?utf-8?B?ektzYVVQc1Qra3QwN3ZUdXNrS3ZuK0dTaFVlbWs2MmdSMlZGRVRzb1Q4eVZO?=
 =?utf-8?B?S1Z2cDBLa05Zd2t5S21sMDFka1V0Q2c4S1JRSHBYZ29FejFseEh5eHB1dkl2?=
 =?utf-8?B?eFp1eEQ5ckQrQUZ0R2I2ajRsR0JXVWhXK1R1TCsxYWQ4YVJOdkM2cWZBcURD?=
 =?utf-8?B?blgzUE03U29UeFJSdlB2YldtVjM5ODliUjAzSjJldXBuaXozRE9zRWFPekRH?=
 =?utf-8?B?MlBuamdOMm5rVkVMRTJPaklJZUNTZVUrYThWODVoRjR2VUZWMFpTMWdQSDRI?=
 =?utf-8?B?UXN4V3ZHZ0ozRGZaMEhtME9qVGxBMExnMU92cUZlOU1IZW16N2s1RXhkSVlG?=
 =?utf-8?B?cjFJY2Zxanp3WU5uTVdlc3lnRFBTdk1CejdZc3Q1Zys5S3VTVjh6a05FUEZB?=
 =?utf-8?B?Q0hpTExqeEN3M0dsSDVoNk1qdlBzbG9PWHV0bC9TeTNKQWY1RkRTQklVRDly?=
 =?utf-8?B?MVlqcUVNd040Q05ZdW0yaVZ1YURrWHg2RHo5cTgzMEM0bUpmZThRMUx1Yy9s?=
 =?utf-8?B?NEZnNTZMOXZnK0VuM25WSTI4SVEyckpwRkVoWGJ3NlFWaTA1NjRzSXY1eDgw?=
 =?utf-8?B?YW5HdzdXU2VxNlBSMG9SaWRnN1lPWVlsOUFQa2JOU3BNSVZMVW4rTWszTVZJ?=
 =?utf-8?B?enZxOEFhTVd2dStPNEhSN1M1M1ZnbVhQM3YxazJkWW1uVkdOTFo4bDVWV3hV?=
 =?utf-8?B?cUVSWDJ4MG5ORzM3a2F3Z3VhR0x4VThhR2doMFUyVy9WZlZXR0FNNTUzZXBI?=
 =?utf-8?B?cnZFb0k4NmkwV0tQT0NleDE1aXdOR21Vb2UyRHZpcG1BVFhORHdiZWZJeE5S?=
 =?utf-8?B?Slp3Tk91SzAwaGJWcEdwTWE5MlJ4N3pLNHZyZkJlUXBEOWxJMUdGbmUzdEVY?=
 =?utf-8?B?R0ZRK1ljazV6czAzd2ZubkdFWThUSldhTjF2MlRNNk85MlozYVBhdUE5cmtH?=
 =?utf-8?B?VTFaVDdSVkhLM1JjMWlaWlpML2pWbGhrR2kvd1BNVmJ6Q1dDV2dTVkg0Y1gw?=
 =?utf-8?B?aExqdkRMb2lkdTVUbXZXTC9UZWFpM0FFQlMvejZHeWdrM2d0TnZ6N0FVa0t2?=
 =?utf-8?B?UVJFU1YxT3B0Z1ZsTHZHTDl3WWNnNmlKNDRhcmUxN3p5d3dUT0hrb3h4UDNI?=
 =?utf-8?B?T3RaNDZnbmZUc1Y4LzhDTERrdFBWYXRGK1dYS3FKQnBnV0NaVVlDakNqQ3U2?=
 =?utf-8?B?aVZ1RlF6Q1dIcS9aMUljZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnVDZWh0QUU3eGdxQ1dteHRCMHh6WVBxNzV5dU9ONVFZR3pFUEE2S2xYMGNT?=
 =?utf-8?B?TCtpU3pEOE1GZ1VSRmttUjZwNFhHU3F4OTA4RFNsN1lxaThKeXJZaklWY3A5?=
 =?utf-8?B?dU1tcFhSVDNRei85bm5DaWp3Q0xRZG5Fd296NE44Z1lnYnN3ZXFrKzZQN1Rj?=
 =?utf-8?B?ZGxhZFJ1Wms2RnVFYWRCcnQ4NUJvK1VzRFJqSzlYeEZuVGhJcjBjUEZ1SVFZ?=
 =?utf-8?B?cEhLSmhxMHU0UlBoL2dOcElIS1Zwdm9ITEJLYVJnbFFLR0VZRkFBeUhEbkNP?=
 =?utf-8?B?cnZ3WC9IZXhheDkycHpIR3dsbkJMTEhiWmZuUit2KzB4WXU0Vkx3bjhHOTZU?=
 =?utf-8?B?akpWdjYxUVU4UW1kZFIvc3BqOHBSUlJKaUdkQlErbW42UUFCeTIzeUFzZ1hp?=
 =?utf-8?B?TzhVN0pWNkt5ZTQzWmo1TUZwVHhyakFsY0pJTUZBV0Q5OXVsTEowTTROKzI1?=
 =?utf-8?B?WXdsK2NwVnJmcjd0WFc0TTNsTTRuRnQ0ajhoSUpCUVU4TjBkRnQwaVZpK1d2?=
 =?utf-8?B?OHVmcTBYbVNvaisvUlVjdXpOd0JyNGloM0ZHMTdWK211c1BLRHY5UG5vRjht?=
 =?utf-8?B?VmdlZWtQaXJDK2I5djM4bUpHZmdpMkxZNzJQSG84SGxVRXJnbHUvbUlYb2Nq?=
 =?utf-8?B?ZHNqZ2xYaHhuUURCWHhhTjJJYmhPcmNBd2JtL3Z0bjBkandRRmNVRi9oVjZi?=
 =?utf-8?B?Z3hISHpyL2NUZkZiQ0w4SkRpWVlXOEVxNmcvSmh4V1EyWVlEc1B4TjZublpC?=
 =?utf-8?B?eFZxYlJHNG5mUnhSdU1Ob0Zqam9jdVFVVnAwRXBQTUxZQTFPSXBTNHRiSHdC?=
 =?utf-8?B?SDNySWo0OUtOT0JZR1VPNC90c3ZZaXdENXFUVjg2RzRGN2dhTTVsaGk4ZXNW?=
 =?utf-8?B?N0crbHBLaHlOY1RsQ2FweHBuN1FnZ3lpd0lhYXNFK1BaenhjYXd6N3hWL1JO?=
 =?utf-8?B?azhXQW5xcWE2cytHbkZCMXVwMDA0dVNQVGZnVytrM01WcWxXZ3lhcEY2Qksy?=
 =?utf-8?B?UkJ0SEZxWTdkVE9Fejl6RTFJLytMMGlBRE9LZFp4eWxTZkZBSWxUeTZsRkJ6?=
 =?utf-8?B?Z2Nrd3krQ1ZlbVowODExZTNGa25rd3Q3TjJDenFIdHh2NHBieVBEQ3U0OGVR?=
 =?utf-8?B?NDQxTzh1OWdLWThnbzkyWXF1UzRiYnVxWEJGMWs1dk9qYnFobHdqWTFSVVh1?=
 =?utf-8?B?Zkd0eStvYjlBR0pzMDF3V09sZ0w0NEh0U0FkRGZmWHAyTE1ValYrWjluR3VE?=
 =?utf-8?B?endESUJ2L3FVeTkzQXgzbmlkV0lPU1JPdjVmaHlEMGNPSTZxakVMT01lZmtT?=
 =?utf-8?B?QkkycitraDlraWYxWStkRStMNjFiVkNqTmcvblhaZ1ZkWmtOQ1QrODlQalRX?=
 =?utf-8?B?RnN3ampETXNiK1BTSGFicU04TXBLeUp1dXNOUUhSYTBrdENLMU8xQkxTNFc5?=
 =?utf-8?B?Y21IbnN3NmROZXg4UExFMU53ZEZXdjdwblQvSG5XOUJkOXBpcGtEenYrQXYz?=
 =?utf-8?B?Y1VUaVBuNDl4WVN1RU04RUhIWjZueE5CZ1U3WEFnZkVuT2xzVVlTczMzcFZH?=
 =?utf-8?B?RWd1U1BSTXRtVFA5V0RDZFI2d3Judng4bXRuQVRRbEowamN5SG5teWhRUE5h?=
 =?utf-8?B?ajVnREFEU1JDSnk2amNLa1RVbG9NbENlSndhcHllNXBVblQzQ05qY05Mb24z?=
 =?utf-8?B?NWp3eThhQlBhbjhCdjlJSmdTNDJqM1htOHRyd0FCa2gvRnZSNWh5UFdkaC9V?=
 =?utf-8?B?QlJUTHFoWlYwQkJnWmFUSHlNMHl2dTNzSDNPSDN3bWxVWkdqU3YzSGNSYlBO?=
 =?utf-8?B?UnQybEVKRDUzb2RFbk45UlZOekoxMFVWSzExdVJyeURpZXovL1JNNXdjQ3Jk?=
 =?utf-8?B?Q1h6YWlDUzNuTmZLeHRQQ1dPN1pQMGZ3amdIUDN4Q2ZlRjNPQlp4UnZqWGdJ?=
 =?utf-8?B?SHI5MkIwbGNYRFk3UEdOWkR2ZDhRdWlMNlIyR29lMFBWR3hlYVVGaDJUQ3d4?=
 =?utf-8?B?aUFTWkxUZnBYODRna1QrMlNNMkVmNTNFL2xINXB4akxJVE9oaEpqUWxNUEdv?=
 =?utf-8?B?RndOU1FFVVptL3NUTmRPWWdaR05TcFZZL3VOQWFEZFl1Q004WkgwV3VDTU4z?=
 =?utf-8?Q?FIpQw0XS3i+Y6R7RZ05UsSGiI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 295ee0d5-2c2c-4c9e-25d3-08dcbbee4d1d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 23:18:55.2241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjQLb2RkWAwNzxVnLNJl9rLKHNbaEAIhaU/19APQeMCDoYOtTsmmK6Tyng6nL63rZ142ZYjsdWjaQzg2FlojiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4867
X-OriginatorOrg: intel.com



On 13/08/2024 5:12 pm, Binbin Wu wrote:
> Use is_kvm_hc_exit_enabled() instead of opencode.
> 
> No functional change intended.

It would be helpful to mention currently hypercall_exit_enabled  can 
only have KVM_HC_MAP_GPA_RANGE bit set (so that there will be no 
functional change).

> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>

Reviewed-by: Kai Huang <kai.huang@intel.com>

