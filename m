Return-Path: <kvm+bounces-13513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1391897D5E
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 03:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D326F1C24456
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 01:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85F2DDBC;
	Thu,  4 Apr 2024 01:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UhYnmaqH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB158F48;
	Thu,  4 Apr 2024 01:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712193914; cv=fail; b=ZN67fHUY9+wVxgtPxxJeMFfJCGbsLIZtdV6itNENxhNbyCEKfqJemHVLk/K1jWe9lWFd69rJ7cIvBdvKliP1l+cLty3OyZxxdfTeZZzRPmnSucyRhEFVudXbAhP6N1n63x9n3Rj7KWl6zF3Uwqvb8rXswMzNUjXLk52WKHDxTio=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712193914; c=relaxed/simple;
	bh=svfaGIvHVceMNCeqLt6it/23iobeW9NAuEVIEQfMRUI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S4vxj0FtkI9ssbCtMyuGnjaHMs6eg0knBe8Tx4EuvpCs8lN0GTG7q5VnhSHPvj49pMMBmTKOJo7kq5IDL6+I/B/lpEcVdXdZ6dLEdqZoql+v4JmHQGgFrHUWtXF/Dt2WyJhtoZdrl/cbQjtC5/5n9hz1XXYO6gXusokNG0cKMyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UhYnmaqH; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712193912; x=1743729912;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=svfaGIvHVceMNCeqLt6it/23iobeW9NAuEVIEQfMRUI=;
  b=UhYnmaqHMR9kDqDhhahOEb2+tdZ+RfCiFX2g5Z0AFWITcQ5fog40Qnjt
   GdCKiBApy3WzGlA4PazdZyESmYZkh7K7JyaT6Sm76Gs8RJUfWcY/imQOn
   kLnpetIj2MBXkaw/rWR+IRPaHfoIbrY/RK8AWzX0+0O8BWw0Te0Gkpivb
   UGFTpLswzCr2Gpy0jlKL+InxWfhkqLH1EGD4VIhhyAsuMBasaCDuTLBQn
   WoA5Tjpa7jwiTq8C0ydP2jXuZMN7So9TnKgrXO+bSYaoQKuPJh3QKQCaB
   FJEuGbfRelQD6c3h/+z6Vqtiri7DHI+srebwJT7PfbFByHKoMeCzqCdql
   g==;
X-CSE-ConnectionGUID: +0Yzns+cSaK20lfvyqcaYA==
X-CSE-MsgGUID: bOeeeYm7R+iWc/7ojD+M6w==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7326995"
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="7326995"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 18:25:11 -0700
X-CSE-ConnectionGUID: CTx22DW/ScOggefaRLnrjQ==
X-CSE-MsgGUID: 2Ymy9fNeRqyLfu4nxEW0qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="18653792"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Apr 2024 18:25:11 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Apr 2024 18:25:11 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Apr 2024 18:25:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Apr 2024 18:25:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCTTjALE+9ASukYGVLdQwOkM1Qs7/Aj3dqROddAsWP8TAQqu7u5C3SKonA3QjbytxflPfuOm2TaprRESTRmop3MxZJNOlYSDHSteW5XaHzTDVGEBp9+O7CYLCrBJzIXN4i0MFqzgwmyMVTLI0cLNmXfyRRwHT3vbgg9LjMR8ZDYfUm9Xof8xje8J+jObu1A3ToRcprDpTZr9sy5m182cf+n6JTsv5BF1am1LaAtyCj9Rv6ViC5NdydpG/LEAhett4MBnJFZSNqBmHO2LyfvXNBYWMJwxB6EuuCKkViyqYHzD327AdRQZUQth9gUV8nW7xoF3ZV3QW+Q099PzBTYKoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+maEXeYjtwOh+5h6zF/uSG9Q7EATxFiboxl0o4IDxHA=;
 b=mami4e81797SutGDUMVN/3/EGeSTIxLqY11CJKtbkzIE2ICFaNTjF45kAgfkA1inE64AL6CdqLTjNUH/R3sbOFEAfar67Iqjk+9hEnZs7gwmrFQga4yXAya2NQrksf1lwSVvw8Qw2XsnCG0oTzTg4MM9CL5cm42KLtvqsCJdQ9BBhCc1rewxeadPX841okc05TgLF/bVfxJt15V9Cqqi0I3FGu4lrkvw32UgFVRzzOLAn2RyoDghklXYO9yIdRi7alWg7xtUKey1G0ZSgyHePPu4fMquBaqNSPCWS5doL0yRMjQCwjg9UuRKjAgTPkj0C3JvaUtDpc84QDyXL2A/Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5230.namprd11.prod.outlook.com (2603:10b6:5:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Thu, 4 Apr
 2024 01:25:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Thu, 4 Apr 2024
 01:25:08 +0000
Message-ID: <484636a4-d48f-4411-8db4-f0295a1560d6@intel.com>
Date: Thu, 4 Apr 2024 14:24:56 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
To: Chao Gao <chao.gao@intel.com>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>,
	"Sagi Shahar" <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>, "Yuan,
 Hang" <hang.yuan@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>, "Sean
 Christopherson" <sean.j.christopherson@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <ZfpwIespKy8qxWWE@chao-email>
 <20240321141709.GK1994522@ls.amr.corp.intel.com>
 <58e0cf59-1397-44a3-a6a0-e26b2e51ba7b@intel.com>
 <Zg38dcrwMg1a7iJT@chao-email>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zg38dcrwMg1a7iJT@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:303:b7::33) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DM4PR11MB5230:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pGPL4h2nESRMQgWybxao3nNFlMlSw8oDxZbnK/twFDMxCV/vPI5kjXuNmEugl+tPEXlF1RJS5Uj/cYX+kNRWUwFDj48n+57tK/dGPsMyzdJg6QCX2RXz727abKd9D8sdrtjvsA45NnUQVR1kJfqbSbyhwz2CAUr1R9ZntauZFFibNI5+VYRwoepA7zWQAEcdcvbhRdbCXyWKD6//v+ViWLqfoW9aTj8VTns2Adr+mhj9QTyzArsxhCQ//E+sRup2eK0RVLClE6VB7wNHdb58hv/3hLG9Z0GwkjamvWaH9+mHqJbpWat2q6YGFcdqxyz7OYyPTyBsAkbq16AtlIFm9kGXhh8KudH6l5vKC9Wcj+0uUh8LEYXn+ijoTKfDb2I1XLIyeN+2ntCc6jimsnSzbIueihcSXXEj4yNo9lUuIgBi9Z9OVVC8tAF21MQyTHBK5f5QGe6FcxEbuD6Ba4ohw+4UbPoYMxkeCuJGvuipeU+CLa0i3GhOPw24XI4vAxCtVmLtm1uO8QaP9Nw6ZYn/fB8DqCY/4lqkOd1O1qXYgi72SWsUGO11COlIYylOuKK1D22fKZqAmz4FWVfhnhT0KQ0+2Erou72H3d6empaQ4POf/+i1lzy18YuhBLFRXdnX8Q9tAR8fBiIebOWlry3Zz/2ToTrJ8A+5ZQgj8TmqcHw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWZTeVAxS0Y1RC9hTVp6RHVZSzhlQ0I0TTg0V3U3clFTaWUyYTM3Q2VnVnFP?=
 =?utf-8?B?T0NOQzJtKzNhYURyS3lZRGppVVVOSklCL3YwUkVhTWVXRkZBb1VmVWd4TExW?=
 =?utf-8?B?dW5WVjgrRWhEbEhsRjFzSTR4Z1d6UjZlWGM4R1IzMTJTZXVZMDMrMzdpRUg4?=
 =?utf-8?B?Vm9GcVJGSW1kTWh5eDlheC9XM1l4TEdGTGJXR1YyTi9Bam9jcGNTczlEUUZ6?=
 =?utf-8?B?ZHF6RDk0cEhVUmtlSzhjUFB2ODMvRnBxcytaZTlDN0FqN2JUYmgzVDE4cktK?=
 =?utf-8?B?a3Z6UW5mL0I5NllJQ1U2TXRtbitzNmgyZUJnL1E1TVBUR2JsZ3BYcmtsaU54?=
 =?utf-8?B?SFJVYmExUEJ4QjNoNE44VzB5ZlFIaDZKaEZrYitVM0c3R2kvMWxBdDMveElP?=
 =?utf-8?B?TFhkdDZhZ1pDZ2FTQlhzVFJHSkFXU2lJck5kVFhBRytIWnRSMGJzTHdLd0pp?=
 =?utf-8?B?MThWbkV4ZURpam1zb2NsUkNLTVdGMUR6NlkyMWNYUmszaHdyaEJZeEg0WDkr?=
 =?utf-8?B?NmZtY1RmcnFjUEFUNUhOV2pNUzBmMVRlaVQvZTFrYUZrTHVuR3BjU2hEOERG?=
 =?utf-8?B?YWNncHRtaUJ4YjhkR3Z2TWl4UzNtSXFKYzRLcCtYNmNEZTcxSXF6bW5Wckpl?=
 =?utf-8?B?M1hOV2dHSlNvYzRRejlRMDlCSEpnMHd3UWV4MU80aFdxL20yemVna3ZXSnFK?=
 =?utf-8?B?cHZDY0xvRStEU0x5YUNXbWEyMTkyd1dnUGYzek1IR0kxYi90SWxwVDV2QW5x?=
 =?utf-8?B?NFpSS0hWZDVKZUhiVk5MbmIrSzlBeDgwbnpieEVKYlMyNmNxWXBtTnpzOXRz?=
 =?utf-8?B?T2RpYzd3dWZtYWZqSCt3VWFKVjlEK3ZQbVVRZjZ0OVgwcXFtSzRka0ZHQW40?=
 =?utf-8?B?aG5BNDUrSm5yR2lWVkpiZEM0V1E4MldScERCNlAvWkdFYVJiQ2hnSytOMU5n?=
 =?utf-8?B?MnVha1ZYMjhiOFJnUUIzRnFpVzEwZFBUQkliRnlGZXNNcENMTUN4SkRTNHJs?=
 =?utf-8?B?T2M4eVl6MFplUWNxSUFRaTBQdmdLQjcvcENGdmEzUmcrY2w5UDhkZjVyQVRO?=
 =?utf-8?B?YUIvWTI1eHcvcitOQithU21PbHlKbHR3V1RZWjIrby9qbkZhczBxMnlXQmNS?=
 =?utf-8?B?WDYrMnpFR1lQZ05qRkRlcGNvVDVrQ1hOciszeWJHMjZuUnZPTmQ4Z0VRTHFk?=
 =?utf-8?B?aFBXand6Y2xRZHZKL2NkMU5Jd0UwM2IrM0dWeERqWEcwOEhCZVJFd2JxNDFE?=
 =?utf-8?B?S25sZ2VnUjdCazRaL0NCakpHSjdPZFh3YWpEa1phWWtyY3Y4SEk2TU5IcllH?=
 =?utf-8?B?cWxyZVl2QXQ3c21yKzNpU1RwZ0xhQzNNbEIwQWJXcDlvdkZzclN2SjZDNFc5?=
 =?utf-8?B?U2lMSEMwdkV4bU1HM0pyNVBLdnFRTDhJMnhoVnZuTVJNQy9XVDRCdFk2Z3hs?=
 =?utf-8?B?UHNHMlh3MXBUbWtBWGFnUElFbUdjTjlmQ1RacU1YeHpBMk44UWQ3MklaNlFv?=
 =?utf-8?B?SjAyY1kwSUg3b0FvWE9nOWRDQVRTSndab2lXL2wyRExSbGtheE1HNjRjVlVl?=
 =?utf-8?B?VjAzUmNaaDd4UXA4d2NIRTZSUGxiLzU3ZXR0M0dUNCs5SUl2azFjQ3FNaHlM?=
 =?utf-8?B?MHlwKzBKN1JHNjZ5YVVCSENGNWs1UC9sd3RZVW1oclNhY3BRa3RRRkNHaUkw?=
 =?utf-8?B?dnpRbHBEUEtlM0U3ZXVBNWJTU2JqbkxzUGxYR2gwaERmMC91L01reGVKQ0JP?=
 =?utf-8?B?N2xuMzNuTUxiamx5Z1NGV0k3OXhFcElaTWpFYnFEUExNbXJpM0tQUFhnOFB6?=
 =?utf-8?B?NXpiY3NZOUVqVHFNdkp4aW1TZysvOUhRZ2FaNmtsN1VKMmpTL3o3KzNERk5K?=
 =?utf-8?B?OGhjR0NvcDZQZEJNNm1WWSt6UTFFSGtmbFMvaktuRnYwMzRiL1ByTXcvRFBy?=
 =?utf-8?B?Q1lBeENuZDU2QTlKd1cvUC92N0psTHoyNk0zRGovaGlqWUpCSEtONEhQbXNv?=
 =?utf-8?B?WlBzSEF4d1h4MVBtSFhXdmNCWE15UW1xa2gzTFIyOXp4Y1gvb1k0WlpQRjJm?=
 =?utf-8?B?Qm03UG9QTnRnZjdOK2ZES2dOc0F1YjdHZTZ5Ukk0NmRXQ0h5RU1yYXlBRmRh?=
 =?utf-8?Q?k2fhwck9ONLLqya7mZ302u1bQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7993ad33-2b48-4851-f29f-08dc544610d9
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2024 01:25:08.8878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9t9fIfPqwvND7uTHgOKAtlc5EVVTznEE8rKqDAAhiCm/SA+hoJKA5gTgTcqrexS3Nx9xVynZH+VsMxQzoue6SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5230
X-OriginatorOrg: intel.com



On 4/04/2024 2:03 pm, Chao Gao wrote:
> On Thu, Apr 04, 2024 at 11:13:49AM +1300, Huang, Kai wrote:
>>
>>
>> On 22/03/2024 3:17 am, Yamahata, Isaku wrote:
>>>>> +
>>>>> +	for_each_online_cpu(i) {
>>>>> +		int pkg = topology_physical_package_id(i);
>>>>> +
>>>>> +		if (cpumask_test_and_set_cpu(pkg, packages))
>>>>> +			continue;
>>>>> +
>>>>> +		/*
>>>>> +		 * Program the memory controller in the package with an
>>>>> +		 * encryption key associated to a TDX private host key id
>>>>> +		 * assigned to this TDR.  Concurrent operations on same memory
>>>>> +		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
>>>>> +		 * mutex.
>>>>> +		 */
>>>>> +		mutex_lock(&tdx_mng_key_config_lock[pkg]);
>>>> the lock is superfluous to me. with cpu lock held, even if multiple CPUs try to
>>>> create TDs, the same set of CPUs (the first online CPU of each package) will be
>>>> selected to configure the key because of the cpumask_test_and_set_cpu() above.
>>>> it means, we never have two CPUs in the same socket trying to program the key,
>>>> i.e., no concurrent calls.
>>> Makes sense. Will drop the lock.
>>
>> Hmm.. Skipping in cpumask_test_and_set_cpu() would result in the second
>> TDH.MNG.KEY.CONFIG not being done for the second VM.  No?
> 
> No. Because @packages isn't shared between VMs.

I see.  Thanks.

