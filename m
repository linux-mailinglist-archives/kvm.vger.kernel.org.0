Return-Path: <kvm+bounces-16704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0E848BCA9C
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5772283D48
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4931A1422DE;
	Mon,  6 May 2024 09:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R2pnKAIT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B4F1422A7;
	Mon,  6 May 2024 09:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714987605; cv=fail; b=L5C2XMJHw0uZgIMg64k0zKbzP0m3lX8ZnF1+rMbUhNGnRK7tig/h3M/Ykectras2iPxiora2yWKgbBsW+puvnp2SItna/sjv9DjC+7K5iZF3lFkVEIu4bcTUkBuZ0aYlhwy/G103wYxap5GAKkuzlZfHSvNkuNCwGZGm+dWit3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714987605; c=relaxed/simple;
	bh=PXvqoP+m31nd9rA06pBy5eZkrQyj/ClrGWb2fHPBI4k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OEk56faeKbv3Szu/mKJK4tqatvu0FCtHNAouR0us+mIuRnA4ag6d2Fy1o5INSLDiAvehfH/oRFVDH8pQrL0Ach9OoI81Cdk8bYYZjAnNB3qW9AC6XyMErNZwyUAUO2+xUBUhS4MGR5nPXgKQwCCMVBvYIKyR4FRxtEP2ZxuhI+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R2pnKAIT; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714987604; x=1746523604;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PXvqoP+m31nd9rA06pBy5eZkrQyj/ClrGWb2fHPBI4k=;
  b=R2pnKAITkY0SdxznXupjTRrgKmOwMA6KcWr+uivHHJbyywSv5SVdJJv1
   Q/N4R/Of1eV0KUzCmWmfOYxXVL6EubVbQuy60hQKYDYJq7Z98cCZOqeai
   +quOPQbMS2pdT0/haVHpeZr/wuVuCSZpN7rsCJkLpxqaInDBzQ8tXKcQ/
   C1zOBPfSsqMWyQhqf89aTafBZU2FMZr+9paq/CkUfQjB+mo3MCGbvR20q
   UCdGOpuna1WOPFy8h//cmngtFo/5mXjYWklKRb/d7Q20uq0GDhTvbWGLu
   +WjVM1fa3dYrNTPSWwfQLVcluPBUC9ru51WQJyBZV+CQHuEj7Vy+NW2G/
   w==;
X-CSE-ConnectionGUID: E2a4hL4WR+WxkcPF5BH9lg==
X-CSE-MsgGUID: RoB0L7baTqeh/ODW/tqcwQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="21879946"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="21879946"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 02:26:43 -0700
X-CSE-ConnectionGUID: GyQLOU4oSsa8VUDqR4VenQ==
X-CSE-MsgGUID: rAv01JzJT1uq+aUEYg+2bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28624178"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 02:26:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 02:26:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 02:26:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 02:26:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVH/t54vZeXWrrR3PqQL8xKlkpNoU5ZqeipaZSQmj8Ln9GTcKKWq8WRL3JF1Y3BEN2qMlklEB7E/ofWICERfouafk+9Hl1vCCM6KRKDZVNtSO78WMmPiO6KxVUCItuYP0AUnJ5eBKbpx1J5lLF1rQ6etKfInywq9Ylt+r/flKavkJq9alF/+GT3GF2J4qZ3nz/BKIKZEP2CdrdX2nQfRarj6oPkiTPpDs5Pe/IogAO7qzos/0AdYV2W5nvyXClpkdiR9IYyywVVzVby8jCFt4RZNBOIAzKRvpcnOEQd3Hybt2DgF0XtCRPldU43GP0iVSacY7/vSRt/YXhngGiiMxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXvqoP+m31nd9rA06pBy5eZkrQyj/ClrGWb2fHPBI4k=;
 b=QMDHzVQylf6SpjS5JI/X03jdnG956iBJeCzNyH5v+2+rZV1J36P6K7hWDlkg/kzY88rk0vty5Ljj0i3eNvqCB24rJyYz/TFUu5mSuplv17mz2UObrl8GrkhJbfqcuKfT/cXatIB+AfGwqkJh4cm8Nmk5s9C0kbFkXU/4gAi1lXOqvF3wRS/BZHIib1GZmTK5JYNnaIYQeqMwWLppzfPGrnPzbT1cyrO0FIfCcl5Qm6BGTc99iei99CYS+xPPJe6b2SkweL54HAOaAWJ/X/ovN/YNYUUFWDVkNfmOt8YHwDHG+FGbCra0DlGi8KeXxLvwSJE4N+op52VqJQPvcVaoZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB7248.namprd11.prod.outlook.com (2603:10b6:208:42c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Mon, 6 May
 2024 09:26:41 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Mon, 6 May 2024
 09:26:41 +0000
Message-ID: <98fab4fd-e7a7-4b1d-aa8c-4c49c4dc7e66@intel.com>
Date: Mon, 6 May 2024 17:26:32 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 27/27] KVM: x86: Don't emulate instructions guarded by
 CET
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-28-weijiang.yang@intel.com>
 <ZjLPJzh2OmrYW-JN@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjLPJzh2OmrYW-JN@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:196::16) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB7248:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f5c2ff8-cf6e-4586-592a-08dc6daea314
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RUdxZHRIenZ5YkYrd1JHWnovSjBrR1U3bERHb000QnRFYkpTY3ZYcFFSTUZm?=
 =?utf-8?B?a1VuaWlQSmh6RU1jNzc3WkZNY3RSanBLZTd4NG1ERUprZGlUMXhMMkF6dkl1?=
 =?utf-8?B?OG42TnlsWHg1YlJTWEVNOTNvRjJZSVFVZm5zTWl5c21oUUpma2JnSC8yWE9i?=
 =?utf-8?B?UTVkQzI5UzduTThhR3FlYkJrQ2tiN3N3Nm5mY1dzZkxUUW4vb3NMNU9ScUND?=
 =?utf-8?B?WDNkSEcrRGlPcE1JVFcvaGsrMk5LMzBTenYrUm1GcHRMakI1TmZkZ1hnTkM4?=
 =?utf-8?B?UmtUWmI3MXJkT2ZXMmM2bGtmQzIxRk1UdVk2KzF2QitDc3Y3VnlSUFgxOThX?=
 =?utf-8?B?bnFNbGhIenUrdHc5cytHNW1oUmNHcklYdy9YRXpyU1R5YkR2cUIrSTVBVHVX?=
 =?utf-8?B?SUZvZ21CSGE0akpxNWR5WGJyaUNyK3J0VHdjUmlpbUl0NzJOd2szS2ZFLzZK?=
 =?utf-8?B?OFZRN2ZpU21NK05MWHZaRk5lYy9aUkRhS21hVTAwMjljalhxb1o3ZjBoczhW?=
 =?utf-8?B?YVpwaWdvMGJFYlE1Zk0wNzRsb3NWMUxqN0lRRHFCK2J0U0U1ZmFGblJXMFRN?=
 =?utf-8?B?UHZiQUlIc1FOSkF1dis4SWRBblI0SlBadHNOdXo4ZUc2WWRLTjlSQUJmVXlw?=
 =?utf-8?B?ZVZsa20zZ3pncyt5aVVOZ0x5Z1ZEUDFkdFcxNGYxaDArYnlwWlBvSmtvL1M3?=
 =?utf-8?B?ekRBZlp2NHZjUURuQktBc0tkRU1OU1dHOE5jZVdqTWZVWkJXQnR3cjRuMTZT?=
 =?utf-8?B?RDNmcTdxZG5FbitDTk5hUmRzM0gwL3JwdVdtNDdodlFHbnE1Z2JsZTlHT2dw?=
 =?utf-8?B?R2U0allhQTZOaENrVjJxa084eExmcjlvdDZTZ2hmYjIybEJoU3ErSDJIWk1J?=
 =?utf-8?B?KzVsS05OZENyb21RRjRKOU9pV09xRHhMNHlmckMvUnFaVno1UENmaVBWbHFm?=
 =?utf-8?B?Sk5FQmxKTkN2SzVGZ1FRRHBPTmYxQVRSTktKVUk4eDVRUGhFWTUzNncxM0NL?=
 =?utf-8?B?RjMxYytFYk93SkdjTk1qZCs1OHgxdWhkTGd4dHBYK0hzQm4xVFlUMjM2VXNy?=
 =?utf-8?B?Mjc5Y0x0TlEyc2RNaTVzNkhaTnNORjhBSjhIRjd0dWVET2d6YzRScEdsT01Z?=
 =?utf-8?B?VTEyNzNOQmgzUXlRT2dOMWcrT0lwbkdBR21YYjBGbzZsS1JqeW1XK0JTaFRn?=
 =?utf-8?B?alBxV3BtZ0Z0YzMrNHdEYVhsaVFyOGpORHFmNjYvd2VIRks3ZS9ONm1Ya1ZI?=
 =?utf-8?B?Q2FQa09OMURGUWh2Yy9EYWhtRUF4WWszdi8wSmUxdklmMlNkQi9ldVNTdDF0?=
 =?utf-8?B?aDFHejE5R0tVVVczS2h4d0Nwb1FHLzVpa0VRQjNseG9hT1BnOXRWaGNvNXV2?=
 =?utf-8?B?Z3VwUVdZaENIeUgya3NNSHhQbWdrd2lKYUpnQ0xCTFhGajNoZ2doNC9mU1F6?=
 =?utf-8?B?ZnBGWHBubFdhN0NVRnkzNTFlckdpN1BueVBxMjZ1Z1Y2R2ZhcGZQaFQraTIv?=
 =?utf-8?B?VEhnbFJML1NpUWVTZlorTnovcHk5UTBNMUdZSTYxZ2xTd2NPRmUwdHRTd1hJ?=
 =?utf-8?B?UmhnMkErVjd0dWxCeC9MVGJvSVJzWVdncHArc3dEbDRWTmJYbEZBQ3B4bU5K?=
 =?utf-8?B?R3l3K0Nrd2pFVFpweHFtS0phMlBVTWV0cEJwM3ZSL2I3RnFyVlhpSDFtUXRn?=
 =?utf-8?B?enllbnJOMHE4TlJGQ1pMbWd3Y05RN1JjaVNvZnowcHJSR2x2OWNvU3pBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2tWWE5Ib2Y5RkowazNGNWp6M3dabDgzeDY1b0pGbm5iS2dWd3YwTnBYaVZl?=
 =?utf-8?B?MDhSdVFQa3VaQ3ZHREVsMTNXeWRldXp3TWJ0WVJMbDlRR2ZiS1NvRjM5MFVo?=
 =?utf-8?B?d3MzRFA5L0s2dnBsMDczdG1tVzZiSk52aVdOUFk3MEdGUnk3YWVaazdjSGhv?=
 =?utf-8?B?Vi9HMHBKdEdadjVxR01hL0NJTEorRFpPNGhHS01WVGp4cmxVTWVyVWoxZUox?=
 =?utf-8?B?aEs4clRxTExPOExzeFh4V2JILzY0TEtzaWsyVjQvbUJTUUYrN25BeENTcEdI?=
 =?utf-8?B?ZnYwb0ZLa20xS2IwbjZzcE55dk4zMEpnSG5ERmExSjRWY1h0bWtDcDNhVzJh?=
 =?utf-8?B?VW1YOUQ1Z2NnU0cwRTB6N09UWnNzNXVzQytlY2R6MUNpQVVVa1IwNUkvaEVK?=
 =?utf-8?B?NXI5Uk1TRmsxZ3JqdVhmV2hUY3pTa29qQ1ZIWjJITWd4MnlyWGJRMGc0TVRK?=
 =?utf-8?B?ayt4NVhyTEQyYlBpZ1JXTjNMYnBMQ2dZb0xMT3QyU1BtdS8zUGpqOXpRMGNH?=
 =?utf-8?B?djA1RWx1UVUwejBGYURWanpmcHg3TUQwS0NrOTJLRWVxRkZSVDlmNlIzcEhz?=
 =?utf-8?B?bE5KUm9Tb1pHYVl2K2V4dVZXdHltRFBRcHdJQ2hvSEFTM0srVGk1WVltelNa?=
 =?utf-8?B?eHhUbzVISlBLcmhHV1kwTzRQRVp4UGxvWnZhR0NUZXNRMDNvMFRWK3ZBVDlw?=
 =?utf-8?B?RVVSYmFtZzhGdnZrUWt6d2xZQlBDblp3T0RpZHI4YzRjRmVxMCtoUlNVR3Nh?=
 =?utf-8?B?VXIvbVRVQWhzNllqdnc3d0k0RWVqVHNkUmJXSTl0VnNhVnZWRjl1VDZRd3Er?=
 =?utf-8?B?ajZnUUxMOU01QXd6b295aVFBaVhEZnlsYlpseUtNRWg1VDhCVEZkSUNpeTNq?=
 =?utf-8?B?WEU4M050VFpHcU5Qc1J3RWNnU0FEWEtIMTR3b0Ryd2ZYalBnMVY0ZnJid2xK?=
 =?utf-8?B?Q2ZBT1VlazdvL3lScXMyd0E5ekRSZzQ0UzdQQnhRMEpITmVpRnVDKzBwTSsy?=
 =?utf-8?B?dG1kTDJVYWx1V0E5OU9vNVJ0ZmpLZDhhR0JKZ0xUQWpaNkdPVEJEaUFGQW5n?=
 =?utf-8?B?dDljSzZWTUhFVTBUMWhGRHV3RDJnTytFNS9zamxmOGtSVGtEV1JIWWxaNHJu?=
 =?utf-8?B?azJTNmJsNk4wMnMxdDlWK2lORGp3elRxSzc5NUZOZGtNYSsyczZNTWRZVm0z?=
 =?utf-8?B?eHZsSU9OOWV1ZzU0cEZCbXNIRDVCVG52Y2xtY1EwZW9jSk42bGMzVVdPNDA4?=
 =?utf-8?B?dy9jd1FnTzNVdTNsREpvbzZIdVdlRHVxVm1FWFRTU0Z6anVMZGxvTDgrbTJ0?=
 =?utf-8?B?MCszTzhTSE9WcUE4VnF3S01KcmtlNk02eVlkYkcyTUVLdlA5NWJER0xKNmxW?=
 =?utf-8?B?S0ZDaWVocG16SE1uYXVFNzJUdFJXTVRDd1h3V2ViMXRoR1c0YkFweXcvcEM1?=
 =?utf-8?B?Mzh2UVBmcUlPeGJoams1Sm9pcDZpVGFTSDhuQ1A1WVlrWWtSQmY3aWlheXB0?=
 =?utf-8?B?Ky9jMDBRYVhCZjg5NFVpNTVBZ1lwd0pFUVZUQXNJcG9lUGdQbk1WNld1UENr?=
 =?utf-8?B?Rkg0QmpVWWlzb0xMcitDME56bVliMWJDQko1ZW1qaTlXRC95S2dvM3dyeHRK?=
 =?utf-8?B?V2FsWGkrRXB6T0svTEtxTnhZV251NnRDOHpxcmRBcTlUYzZEcHYyYWprbHRs?=
 =?utf-8?B?M3djRCtNb2wwdmFHc2FDTU5xY3lZNDFza0U4QlIveHZYZ1E5NExHR21HQlhM?=
 =?utf-8?B?MXRUZmlVV1l1bHRXUGp5dUg0TlFFc2xzMDZVZC9nSWRVenY5Snp1K2NlME9y?=
 =?utf-8?B?NjFlalpRMjVEazlPT1JwR2gvSlU1cTRUYThWd0pnS3p6aS8zRmxVR2VDME5K?=
 =?utf-8?B?ajVWSEVjVWhNd3FqZWxsZnUwUENQbXVwT0x4eGxQcnJGa1BvL1l3SER4K0VK?=
 =?utf-8?B?a1RYcnpJSnkrZkdiNmZINDNrYlBBY2s3SHFwYzFMSmowWGxRWWs5eWVjR1pY?=
 =?utf-8?B?b2xLUHQyNnlCc0FNVzlyS2dhMzBMSjY0RVhqUHMwT0R6N2Y0bDdlNGVGcUVl?=
 =?utf-8?B?SXhCTTVOTHZHdFJVODJidzdHWFBGUHIvdWhpeFUvUURvTEd6UWNaYWY4dWxa?=
 =?utf-8?B?YmE0amk2VEc0WUFpVUNFRXN2amNTa1dGdjA2b0VyVGZkeDRHRDhSS1RhZDBl?=
 =?utf-8?B?eWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5c2ff8-cf6e-4586-592a-08dc6daea314
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 09:26:41.0153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 29DC26MpK5xXZ3GkqHUoIax/qLHDp4bV/Ug68Ki6hK2v6sq4RzDu0dtlzs2LHc1knzPUV3ZdkSBP8ex7fBbPIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7248
X-OriginatorOrg: intel.com

On 5/2/2024 7:24 AM, Sean Christopherson wrote:
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>> Don't emulate the branch instructions, e.g., CALL/RET/JMP etc., when CET
>> is active in guest, return KVM_INTERNAL_ERROR_EMULATION to userspace to
>> handle it.
>>
>> KVM doesn't emulate CPU behaviors to check CET protected stuffs while
>> emulating guest instructions, instead it stops emulation on detecting
>> the instructions in process are CET protected. By doing so, it can avoid
>> generating bogus #CP in guest and preventing CET protected execution flow
>> subversion from guest side.
>>
>> Suggested-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
> This should be ordered before CET is exposed to userspace, e.g. so that KVM's
> ABI is well defined when CET support because usable.

Sure, thanks!



