Return-Path: <kvm+bounces-13497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB9F1897A83
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 23:17:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62BEC1F24FDA
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 21:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31101156670;
	Wed,  3 Apr 2024 21:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I2WmZPlv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD45B2F24;
	Wed,  3 Apr 2024 21:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712179055; cv=fail; b=t4QsijLAPCCN5apAnLuUULaOI3IRgg5tvJfe0BoRfn8W2UDb/wrlB9PIZ0Ehvx1D1ROJ1DZ47Ro4rXkMuSorBuSLXfwzNkayUJP8rpSeenHFELq5JvaksuYWcJT7ntJKzxH1ejLoFkTDJ2jlNcrLGWy86OgOoz1WOSu6aPHfoWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712179055; c=relaxed/simple;
	bh=oI/2CBJKNhDIMH2V9V9IbKoxe76RG1tBMarz+m7VtC8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YaL/OWhrR/12tYhEkqiM8piDF7cs1GqkyPCXIR4UHDX7CRAn6qhRtK00wmbuatL04ftZhOrdUQXcns4103euqxAuiWQgIjzl5dr3friesbcv4jJ3tsem57SpGSvxnrmdWNkwfZAoczJ7AaLyj3q2cbftPf4Luw91n2W8ecvzMOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I2WmZPlv; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712179054; x=1743715054;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oI/2CBJKNhDIMH2V9V9IbKoxe76RG1tBMarz+m7VtC8=;
  b=I2WmZPlvzfYoUZcL+IRkDPZ0CvyKwTEuq3j5jGglmH8fNEQWHHwaF+OH
   wYJZ/6QdUVUhbeg4iPPqlYXKK2pZJ7+UYBazCb08F3x9hU/6uoj4X7IpD
   I7HIq147OOxviNUEP8OMZy0XxrTkoIjLSt7TkGgKkl4shQ2j7niYxZ1Eu
   77LMArpHEmPEeo4CldYwYLxOYaIFYSxK/rsS/EiM9MZzrJOuuRpQpWi86
   TFh48JNJlWL/kuJxKhY26TTxIZl8T7jnKNt+hUk/B2wsVSV6jw9TEdr9X
   IuIdA3xBF6G64HCstR9BfihvBmLBOYUwryPNjC9Qa9F7z6ynLfuOVYRBO
   A==;
X-CSE-ConnectionGUID: 0draSeiWRbak7sYpvZY8Dg==
X-CSE-MsgGUID: eJCRORX0Tdmxr8Rhkl0VUg==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="24945205"
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="24945205"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 14:17:33 -0700
X-CSE-ConnectionGUID: E3u76sfmRmyenE3jgkL6Kw==
X-CSE-MsgGUID: kGDNF2IqR1GDtrLPPJ9hfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="41731354"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Apr 2024 14:17:32 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Apr 2024 14:17:32 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Apr 2024 14:17:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Apr 2024 14:17:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Apr 2024 14:17:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YeaoITqX2RxOuZ9fAyfH3wW6XXgggatCrhKMDOXlWOCmGvG6wsxrfEWN7QsoVd9dOil/s6FnThYJ0+DiV8e8LIDYPhMS2n2rvdf+DDuVKeQXwbabpel2G+Q2MgAdh+S/qy3LLMRIteCkZYK+fdFmF9bQYDr8mL2SqbhGBQtJWDnOrUBxLMVrlXeHfALfsaBBzniqKYNply8FBztKN4YE0XDPLVweFhSPO0X+Vn/YepnXf9fTdLzZEeU8XC1we72brd/WDBR04swnw8qVtiyU4WS2veTsuGvlHQn7U6d8f11QhskzKprKNMVpYlpB6QHjSi3uzCOKmnV1EzKJTQ7VSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/aQddAwH15cJ+S5kFYe12TjKi+h8gsZLAVga77N9L7o=;
 b=nRAV94HbCMtPMoQZHAR52z/HmZH7DddWaKTEwn2owYJRegq4lNxRAQLB7SxEAVWIyOFSujm0bGlogY347DOCjQObHrc2zDvKE1AxfbO/L/T8PuvaOmT5WRPFb7HG5+ADFvrSFCXEb+nqHWijeguxX6BDuLgn5BApp+2gTvo18TOPjpPXPM7dsgJEP8Tgh9IJ2IUGFf8vZVzt7a59LZTE8tnf0W0y9jqPxILHPCqp+526gotPh/H3vEUt3PdlBIi4t7htSkkh9sCQvHswVxg3wCOYQ6/kucLNXMdGs5VQ7to1oJ1GL1kuYaO63lHh+uwJ7bVWEBh06lRKAQhbu5oU8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8592.namprd11.prod.outlook.com (2603:10b6:610:1b1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Wed, 3 Apr
 2024 21:17:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Wed, 3 Apr 2024
 21:17:27 +0000
Message-ID: <ee54cd65-6fb7-4b59-a4bf-d7f661110a07@intel.com>
Date: Thu, 4 Apr 2024 10:17:17 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/9] x86/cpu: KVM: Add common defines for architectural
 memory types (PAT, MTRRs, etc.)
To: Sean Christopherson <seanjc@google.com>
CC: "luto@kernel.org" <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, Xin3 Li
	<xin3.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Shan Kang
	<shan.kang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-2-seanjc@google.com>
 <2a369e6e229788f66fb2bbf8bc89552d86ba38b9.camel@intel.com>
 <Zg2msDI9q_7GcwHk@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zg2msDI9q_7GcwHk@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::33) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH3PR11MB8592:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lvufPekjgoajDO/LJehfOHnAkLE0Oi/mj/WWbM3aRoECETWJxMMV3tB6U1Rp/rnHj789b4dK1pEvZ/NZFYKVYRM3n77sCwlttfja93ZlkripLKvto0IgEfJ3PTdjW//Tyq18dY48DR64sZVy4uyku6kKH1pjlgdmXsEhsXb1Pbf/uqVnIccoT3nXB98YPURjhFbi++6uroN1PdiYbXo+P3w5avHc88XpY4Oz6NK4IvRqLte48RJxf68HQCcGO+kanl6ligFfdANm0jHVDemMlgv93VBTxxdVlXUBiH82huMZreCiuwI9Cnhl80bSHf/7kOOnUUHS9csq6zq1YwQjWFV3IjLRuH7bMv58KUHs5CKTdUVGwkO1NxjgBWuOy7YnDDSX1vTQuh2z7Ubbfs/6pTcmd/LWqrR6lQHjWsdVZdIcuubeMrEfrChtVunRvnmy96rkT5iLKly7bCKD2uaP4alO8hCU7SfxUMxhzCvc9hyYT7qlYBTUCRUlyaBwTIUpqjMETk/LoTntskGKxDEjNhRmxnxUN/VvuDz9H3jyv2xfTOHlxSwJqSbrUiy6AJnTPSAuig2UaohTj1xKRN4m5e8N/ZkPnSdhliZ5DD4EueALtiv0a1zzLdm0f4rzSyBZymnUKrnIhAaCSTqVdJW4GslNvP+ZrkxSJqI8ID+nE3o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWIyWTg2WFpwTDRpdS81ajNMMkNraWVMc05XdEIvUXpxd0ltckJHYWs4REF2?=
 =?utf-8?B?aHpaQ3lPV3JKQ0tsQkE1dGJzOXFhenFDWll4RmNXbGZ0d0cvSmNnY215YVJz?=
 =?utf-8?B?b3plUFA2cGNsQ29MZmw0RU9oUU01a1Fab0ZYWGNnR3JEcExENXpxYlVUcjhI?=
 =?utf-8?B?T0pnM1d2TUg1M2pyRWlIM3JXZWtWOWg4YTloYldjRW9FMldhNnFHbGZuWm85?=
 =?utf-8?B?dytqNTBCVFdiZVFhZGYrMllJOWlodlFKbDBGS2FOcVVKbWF3RGRzRnFRRFJR?=
 =?utf-8?B?UGhWRXYxSnBkS0xZaTdIekdFUHJoZFRtNVA2ZjliY0tTeWI1aUF3eW1ReTU0?=
 =?utf-8?B?Rjl1ZHFCVHhpZlBvNjFSYTFIYk9ZSWpFUmhlVWd2U1FwTDNZS0R6ZzdXY2Nr?=
 =?utf-8?B?b1JIRnNTV29ZSk51aTdVTnJwRXdNZWxpVmJSWmliOXVUbHVKcjJlcm5BSlhR?=
 =?utf-8?B?WDBPYlFrZEpNU0JDem1JSU0wTHl5L3QzODQzRTlXQlBFZHI2TDF5QkJhNktu?=
 =?utf-8?B?dE42MEdlUzA3Z1NHSktyYTlYcjB6YUIzU1ZZcWF2US96bnFLN1hDUURSanIr?=
 =?utf-8?B?OXVhZTd6VUZtR0hHTFN6MGRZbm8wT3VzZXNNM1JoV3VCUzh0eVRjdm9CVXFk?=
 =?utf-8?B?UXAzODBnK0NOVUdQb1B2VXhYWDJvY0lVeUwvYzdjMWZDZVMyUmg3dHVuTHVU?=
 =?utf-8?B?Z01MelplMlBydHB6Z3V0WE9qYk9zS0JieW4yY0hMdFc3YXZoM0M2ZytFeHVk?=
 =?utf-8?B?WUlSOWUzN1lHWTFZdXI1VkxrSzhwL1dxd014d2w4VDZoU0lTcVU1UUhsOHB5?=
 =?utf-8?B?UVpMUkMyYUc2aGt5cEY1SjZDTytQNmxNWU5LKzIzRTBqTEtHaGlFeFR5WFlq?=
 =?utf-8?B?dEJJY1dLYU9sQWQ5N1QzM2pCekluMUx1dmpNa3Z6b2FzTWJYU2FKUkhXWENk?=
 =?utf-8?B?RHRRMDFYczRaU2c2dlU0cXAwOHl4UmIrMlduRHphVjg3Y1hiUCtudWxpeDhX?=
 =?utf-8?B?K3NQaXVQMEduckVITWlkMU11cTYrN2w3cE9xWFN0b2xNdGFWSmQvU2VRSDNS?=
 =?utf-8?B?K2hBS3FsaklqbkZyTHRJVnh4YlF5aWdyNkhKNnQrd2llcDNjZzB3QTdzQ3o2?=
 =?utf-8?B?ODY0SmkzaE5BZ1pWRjcyYytyL20vUExWejVpS1hVQjROdHNqbWYydnNyR0ox?=
 =?utf-8?B?YU93c2lOb05INGFhS0l0aWdHVzdMWkhTTk5hbUtJK0wzOWNLSENCZGViUzNJ?=
 =?utf-8?B?SWQ3K0dibzJBK3lYWGIzZjA1VUpZd1czdEptSTJCeVl1MzhvbTNvZ1BHaTdp?=
 =?utf-8?B?REZOMDhwVkd0OXhhUnZDVGVTQjIzdG9UTGlOa2gvaE11NXRCdzg1QlViZld6?=
 =?utf-8?B?RzUwWlp4RE1JNjlUMTZBcmFzTFJvTno1dllrY24xY1NGSyswNWxBOHNORnZq?=
 =?utf-8?B?YUtxT0M2bUhuU1RQaG9mMWFudHlCK0lHUnREbWJJM2xaWmY0bkFwc2ZGaXhG?=
 =?utf-8?B?aDRwQnlTSlJZOUhZUURYVHJlRjY0SENZQ0t4eldLSi9JeGltM3hlOHdLS1Br?=
 =?utf-8?B?SWdVS0xhU1pXTEU4Slp0YkNnb0FET3MvV0RaMzNvQjR4K21ya0Q5TnZHSnFt?=
 =?utf-8?B?Zmg1c1dLNk5uVi9HZWF1bjdOK3ZOd1NWanQyUnk0clZjaWpnOUlSaUtYdDNS?=
 =?utf-8?B?YWc0UVJtT2lLL3pSNTNBVnRqejRJRXE3Y3JsV1g1eTdiK2ZhK1ducnNiekNj?=
 =?utf-8?B?d1FjSzduVThQRDgwdDh3RDdLRDlET2I3aEhkK2MvWGgwUEF4MWZUMkhFMndh?=
 =?utf-8?B?MzZFdk5aV0FMRzB0SndnR3FGZS9wdC9jTWhGdTA5ZDNpKzY5VVhsSTZ3eWlN?=
 =?utf-8?B?ZzdWbFgrV2FRZWhYcTlCeExDVGR3ZnlPWmI3WEw4WjVPWmNGaVZxSXY0M1Bs?=
 =?utf-8?B?dytNbGFxR0I3U0k5OEJVUHdDaGFRQkhrRGxrMWRDOGhZcmlRL0Q1VWJITnlU?=
 =?utf-8?B?dXRzNlIrTVhpeStCNTgzUzUxV0JIa3Noc0VWYU0vc3g3Si8wVFMvay9XNmFv?=
 =?utf-8?B?Vm02YlRhTC9SZ2JoNUlGWjdtWWRmZjRjVUJmQ1gzUzB1cG8rWUVjZnVVRy9O?=
 =?utf-8?Q?OxpYeNmVBY5lyIeLq3GITuhYo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 25faca2c-f89a-4727-5982-08dc542376b2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 21:17:27.3725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PNv75SASzkkkYpNyH8O+Ym7UePRdIZXD3X4ZJNQJVbTxrIegfshFq0IkOlodFetAl4flhjJxrWGXNqPhUXficg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8592
X-OriginatorOrg: intel.com



On 4/04/2024 7:57 am, Sean Christopherson wrote:
> On Wed, Mar 27, 2024, Kai Huang wrote:
>> On Fri, 2024-03-08 at 17:27 -0800, Sean Christopherson wrote:
>>> Add defines for the architectural memory types that can be shoved into
>>> various MSRs and registers, e.g. MTRRs, PAT, VMX capabilities MSRs, EPTPs,
>>> etc.  While most MSRs/registers support only a subset of all memory types,
>>> the values themselves are architectural and identical across all users.
>>>
>>> Leave the goofy MTRR_TYPE_* definitions as-is since they are in a uapi
>>> header, but add compile-time assertions to connect the dots (and sanity
>>> check that the msr-index.h values didn't get fat-fingered).
>>>
>>> Keep the VMX_EPTP_MT_* defines so that it's slightly more obvious that the
>>> EPTP holds a single memory type in 3 of its 64 bits; those bits just
>>> happen to be 2:0, i.e. don't need to be shifted.
>>>
>>> Opportunistically use X86_MEMTYPE_WB instead of an open coded '6' in
>>> setup_vmcs_config().
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>>
>>
>> [...]
>>
>>>   
>>>   #include "mtrr.h"
>>>   
>>> +static_assert(X86_MEMTYPE_UC == MTRR_TYPE_UNCACHABLE);
>>> +static_assert(X86_MEMTYPE_WC == MTRR_TYPE_WRCOMB);
>>> +static_assert(X86_MEMTYPE_WT == MTRR_TYPE_WRTHROUGH);
>>> +static_assert(X86_MEMTYPE_WP == MTRR_TYPE_WRPROT);
>>> +static_assert(X86_MEMTYPE_WB == MTRR_TYPE_WRBACK);
>>> +
>>>
>>
>> Hi Sean,
>>
>> IIUC, the purpose of this patch is for the kernel to use X86_MEMTYPE_xx, which
>> are architectural values, where applicable?
> 
> Maybe?  Probably?
> 
>> Yeah we need to keep MTRR_TYPE_xx in the uapi header, but in the kernel, should
>> we change all places that use MTRR_TYPE_xx to X86_MEMTYPE_xx?  The
>> static_assert()s above have guaranteed the two are the same, so there's nothing
>> wrong for the kernel to use X86_MEMTYPE_xx instead.
>>
>> Both PAT_xx and VMX_BASIC_MEM_TYPE_xx to X86_MEMTYPE_xx, it seems a little bit
>> odd if we don't switch for MTRR_TYPE_xx.
>>
>> However by simple search MEM_TYPE_xx are intensively used in many files, so...
> 
> Yeah, I definitely don't want to do it in this series due to the amount of churn
> that would be required.
> 
>    $ git grep MTRR_TYPE_ | wc -l
>    100
> 
> I'm not even entirely convinced that it would be a net positive.  Much of the KVM
> usage that's being cleaned up is flat out wrong, e.g. using "MTRR" enums in places
> that having nothing to do with MTRRs.  But the majority of the remaining usage is
> in MTRR code, i.e. isn't wrong, and is arguably better off using the MTRR specific
> #defines.

Yeah understood.

But the patch title says we also "add common defines for ... MTRRs", so 
to me looks we should get rid of MTRR_TPYE_xx and use the common ones 
instead.  And it also looks a little bit inconsistent if we remove the 
PAT_xx but keep the MTRR_TYPE_xx.

Perhaps we can keep PAT_xx but add macros?

   #define PAT_UC	X86_MEMTYPE_UC
   ...

But looks not nice either because the only purpose is to keep the PAT_xx..

So up to you :-)



