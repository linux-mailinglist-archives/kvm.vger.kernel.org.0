Return-Path: <kvm+bounces-4310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00B52810D74
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 10:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24F1F1C2099A
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 09:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2295C20329;
	Wed, 13 Dec 2023 09:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fnO1UKqh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018E2BD;
	Wed, 13 Dec 2023 01:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702459852; x=1733995852;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bRZgSmLANNB0dNiTIpClwV7lVHiYSnAdrG1UVZ+fK4Y=;
  b=fnO1UKqh3IzOAfU40Kv0XDhXlDOobmRxu9vxoqz77DhWdz3PeqawQNW5
   XnGwXZph7oQzQJ5TMG97jDvQx9/RXrXaKyD9aGbBFmHPaC7ytGRMKxW3f
   iPcMsKUMDMv4c3ABJIzoFNRACpbZ3N6VJIeP6J84ZZZyOaiF0xDqw8ONs
   AjT8AJhI54IsCJVfTbnCaz1jDCZUuB684UARyYW0ZUEehq7jdo2OsLQHC
   hJ/7zJUnDv7T0s6Ev6oMrAIwN7B1YiQbJcToIr2pLWwa8/mwVAMKBe+v+
   uKFb+ohRNQVB3inRWEREV7CHHKMZW51dcgsbQ4RLqL0zo1tlhMC7pxvAm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="397721793"
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="397721793"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 01:30:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="839796718"
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="839796718"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Dec 2023 01:30:46 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 01:30:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 01:30:45 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Dec 2023 01:30:45 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Dec 2023 01:30:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFwJ/F8K4xuHQkGNSd5jrsmJNKPx3fiYQrdwj9Pr23AtuTr+Gpr0dECKsY5n5T/RIfIf6yXoxYgLwucZpBC1v/GkAkkQor/7xgmSBCy+lbHsisX79fh5+6R9BISJs+eCUIISTRKPtFlJ1d11AWVGM4WV3ytsYtblfry7YPoWXnQ0r/U6QeFL/WgjlIjVgxxKjG6vwsJWN3BPUskzN2gwxYVcIlgUHJavVcOy7143KxgiFyOEXt7aEaXKT/x3VNRKlJK4jX38OZ2BgCoZF00TDBK571m/EGqY1TU59ckk+88nWh0XFjOKVCROeICPXVySyd/A1je8CkbjDRLHaRJN6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVRL5RKE8Eak3xHiE4fpmZXUEgJcMtvlVcvIifp9/8A=;
 b=Mdur+2hVEiIJez1xQ8qVnip8Bhe9q3/IvrYk9dWtwyZfD/e01ubozTJ5lB6ovu30udPfy35/ls/EzvjCmnU2NUhk8xuJcZuaIAqTIsacojKO1uoEhPEewWDy8Esnk7QcYEIAJ7QxzrjojsrT3WBrD5vcHRXHUa4JueJkXgRnN1kewHX9yfDYvTegIFuV8iNnaL1MIx3OrS5mKvHA32IMnMs+6iMKLZ80Ah+HRvyYLiWJzETr2EJmmK9uEHdKTe0uiJgvFxoe503saM75BkbAS6w/pDl+0PyLUjsWbzkZ4xhDuoss8PnqNthLGcnUh0JRkUeGDKDTnEGp7u5AHECFkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB6906.namprd11.prod.outlook.com (2603:10b6:510:202::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26; Wed, 13 Dec
 2023 09:30:35 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7068.033; Wed, 13 Dec 2023
 09:30:35 +0000
Message-ID: <917a9dc4-bcae-4a1d-b5b5-d086431e8650@intel.com>
Date: Wed, 13 Dec 2023 17:30:24 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
To: Maxim Levitsky <mlevitsk@redhat.com>, <chang.seok.bae@intel.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-3-weijiang.yang@intel.com>
 <c22d17ab04bf5f27409518e3e79477d579b55071.camel@redhat.com>
 <cdf53e44-62d0-452d-9c06-5c2d2ce3ce66@intel.com>
 <20d45cb6adaa4a8203822535e069cdbbf3b8ba2d.camel@redhat.com>
 <a3a14562-db72-4c19-9f40-7778f14fc516@intel.com>
 <039eaa7c35020774b74dc5e2d03bb0ecfa7c6d60.camel@redhat.com>
 <eb30c3e0-8e13-402c-b23d-48b21e0a1498@intel.com>
 <e7d7709a5962e8518ccb062e3818811cdbe110f8.camel@redhat.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <e7d7709a5962e8518ccb062e3818811cdbe110f8.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG3P274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::17)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB6906:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fd707bf-204f-417f-f36f-08dbfbbe291b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SaGto2yD/wBhDpM0P7DyFPQHMKloBWzBPpDk+rOy672V67opNzhDUXpnvpuD7Png+sBf2aspXkcR7QUb47BaWaWYMk3R06a4HDrycxBVv9+8SyfW8gNNaWUirkSdYp7c9+YP3806DdjSW5DoMmNZAwG43VG19kSA22+I1whvTCg4ZzNVtthcZY+CYWe9ZT+TFudXW/zzCUubRSN944HREM/fkxC40HYtHgwWreLHXMVtiDq6EnQcaX7lhsdXJc6idcNQ0Qq7Li2VDjORXm7k3WCzsKKEQRv6kKo+H7I+i+faoPydhsWpp0aNGwWadwnA/lDYQCzfGrNcUyXCPqfmATQGSIsEhMV2qWZ2r/vLrh2EVGHvKHiblT1xKR3O0bH9JD8BR5LQFCA81CWXqStP7DlJrN5oq5Ux+AoLuNPvfoNUIL3wLMWq0kF2u79Lk+RlhvlCaVmRqQs5SCd6EeOtHF5Wc9YcJeqd2y20OL4E1b6+jZirry2ZXovbIKnRRENNagwGwzNHRliIv0vTAaPFLeQQI5y2DxMCVgx6ENyJVddJbuSFZAH2zne1pgL0+RRqesnSQECotC3oWizKT5kBjyfd/iqDdWvu7kniq1VvAxlfVuE7FA2qJp4Yw700eVAHvBfjb98CIj7MQGyOyVdgfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(396003)(366004)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(26005)(83380400001)(6512007)(6506007)(53546011)(2616005)(38100700002)(5660300002)(8936002)(4326008)(8676002)(41300700001)(316002)(4001150100001)(2906002)(6666004)(6486002)(478600001)(6636002)(66476007)(66556008)(66946007)(82960400001)(31696002)(86362001)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTRHb2hWdEhsM1BrR2twUzJvRndDMmJWWWFZU2tsRGdwRGltdWpOU0xKNGgy?=
 =?utf-8?B?TG5kWG1rajd3YjBGeERYWlRiNmN3S1lkUXY4QXpSTCt1QzhxeERGUWJtbk81?=
 =?utf-8?B?Mko2L2xlWnE0NEFBWGx1UFh2QXRrRXFON2hwSklMV0d0bGdaM01XL2Nacldx?=
 =?utf-8?B?eDZmYnBwQnIxYkF6RzNLamtKUlRXVFBQVWxwOUpaaSs2TDdxU3puUXJHMUVt?=
 =?utf-8?B?UllQUWUrWHVHZjZDZTZ0UnloL1o5ejJuR2Q5RlZSOEVvcUI5d3lqV2tiMzA2?=
 =?utf-8?B?K3VYVkVaWHAwTFNHS0J2RXh6dHZpZ3JObFNIemhoeWZxNSs2eVB2NXlBS1lE?=
 =?utf-8?B?R3U4S2hQa0lUbVU5NkkrNzR5MUl6dVRSQUlnU2R2ZFFrWldqUE1yQytreEJR?=
 =?utf-8?B?dWhzVmJmbTUzc1duUmFNdDhVS0dmZFcvTGx2eVFieHhLbzdZSW9WcjhBcDNV?=
 =?utf-8?B?VFVHdWFlWFpsK3VpYnBEWDBxQ2JYL0ovQjI4ZXlkd3pIQUgrb1ZuNVlWVldS?=
 =?utf-8?B?SEMzK1ZwT0RwSjYveFNJN3FhTFlDT1hLWE0waEdBa1lFVkc5MWptbkZPbWtl?=
 =?utf-8?B?emVQSjlGRzNNTUlGYnJKSk85NmYzRXh2ejE0eTNtSktoWHVJLzJtSFFrZnVR?=
 =?utf-8?B?dUhtMm0weDRac0xrbEI3UUY2dHVEODdqR09SRWM4ci8xZTV1djJEb0JnWVlV?=
 =?utf-8?B?U1BXYXkyMHBwSWVkRzNvOWkzNzZkQk83QTlzbm9ZVDNFUUN4bWJhakc3b3lQ?=
 =?utf-8?B?c2dRRzBZMmxJQlRJaFR5Tytsajh2VmlVaTd4ZVA4QlpKRHpJTGYzWEI4Wncy?=
 =?utf-8?B?QU5oQWJMNy8xWklJaCsvRkJjM2g4b1FyZitSYjlhcFhZTkJOa05URFpGVlNi?=
 =?utf-8?B?Y3Q1ZFBtK2dsSU90a2JKY2Jhc2RrUDNSaTI5M1RuZkViTU1XdHc4S29ZV3NT?=
 =?utf-8?B?VXJMZXFCK000VEdZWHIzNGZYanB6SHQweldYL0Fsa2lVV0hDNzdBYkExN0tD?=
 =?utf-8?B?bm9tVktzb2hIU1dHOWZvczZ4QkwzWnB2MURnTnp3YW9EMndUbk53Uk1sU0I4?=
 =?utf-8?B?V1ErMWMwR3VEOG8zT3pGeTEwWUdpYmJOTUN1d2d0VTNuSXJNWjNFTUtkbWgw?=
 =?utf-8?B?ajRvUE1SMXB0a2tSRmNUS0JYbEs1K1h6eisxaVJod3Q4VzQ2N01BOXlQYVRt?=
 =?utf-8?B?cDZNbzI2T0NaNFBqZUtnNjhqbDZGTk9vTjZmTFRWL0Z3RURXaEN2WVpmZ2Fv?=
 =?utf-8?B?S2JKd1liYk1mWStIV2dGeVd0R0VUUlJrc2QxQzZtTlczT28rNUNYK0VzRWo4?=
 =?utf-8?B?WmhJN0ZUTnRxb3FzaThhMlU3am1aYUtXQ29BWTdaanF0SFRSZTVsYzBNaWVS?=
 =?utf-8?B?emNPWXRuTFFMZExaNEN3bzZxalE2STJJb1pDU1VoWldrWUYvaFgrdzFEeWg0?=
 =?utf-8?B?M0UybmNnYUR0cC9FcjBrNlpGNzlteTZaNzNzV2VuKzBQaVBldGs2eXUyaGh0?=
 =?utf-8?B?RHFKQUFFaU92WmFlYU5jOGoydi9Ic0h2THpNcm9qMjhvc0QwYnp4OVA4aUsx?=
 =?utf-8?B?TTc0Zm5tN2hMTUJIaTlWRDZkdXRJSnlvUk9yZnp4SXdSZ1kxQjJpUFNIM2Fi?=
 =?utf-8?B?MDBrV3AyN3JiK2VDeFFWYWcrN3pBZFR5eTlZSGxSTE5hNEdBdjhZb1BSMWlu?=
 =?utf-8?B?R25weXN6cHVlM0xRTDJ3eGlzdTdoMVBEV2dLSnJxcFY3c1ZZUXpsNDltZTB6?=
 =?utf-8?B?MnI3b2YzTjdNNDN0WHd3WXRZcmxRTkd5WW5weXFlL2V0Qk9ia0RJOE9aTnZs?=
 =?utf-8?B?bitHTHk1VVYyaXlCNUpqZWVYSkFjMkpINEVPZ1ZnaGdINktiSE1WQXZSZXo0?=
 =?utf-8?B?ZndCVXhkbjV4MGd6OWdkWVlFbDNkSnlaaDZEOC9ReFA3OXFVakVvckRpdHF1?=
 =?utf-8?B?TWI2QytsekVBTmxDaEFXM3lxc2pQWCt3Q2dKeHlML3lWZHkzUm0vQStRSG9F?=
 =?utf-8?B?SnBJbjEwMEt2Qk1GVDBkV0NEaWM4TnI2cUxSUStNQ0NaZTZCUDNVZE5ObjA3?=
 =?utf-8?B?RnIrMmNEWm1yV1NNRzJFT0RWMkoxMDhVWkRxdTg3N0lQSkdWNS80L3JmM1hr?=
 =?utf-8?B?SEZnZVBqV2tkaWZ1d3cybzVJd0RyVHR0NjdJU3FRZXhNY1ltOUpMVGpGOTdL?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd707bf-204f-417f-f36f-08dbfbbe291b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2023 09:30:35.8482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGkMf7Xm5RPkOy97U0G5rypEB/WEl8H8zTgQ362GC2+jUOOQAPv8jkSNWZzjvIK2F2vIItT7Y2vVPU98PEDNZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6906
X-OriginatorOrg: intel.com

On 12/8/2023 11:15 PM, Maxim Levitsky wrote:
> On Fri, 2023-12-08 at 22:57 +0800, Yang, Weijiang wrote:
>> On 12/6/2023 11:57 PM, Maxim Levitsky wrote:
>>> On Wed, 2023-12-06 at 09:03 +0800, Yang, Weijiang wrote:
>>>> On 12/5/2023 5:53 PM, Maxim Levitsky wrote:
>>>>> On Fri, 2023-12-01 at 14:51 +0800, Yang, Weijiang wrote:
>>>>>> On 12/1/2023 1:26 AM, Maxim Levitsky wrote:
>>>>>>> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>>>>>>>> Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
>>>>>>>> reflect true dependency between CET features and the user xstate bit.
>>>>>>>> Enable the bit in fpu_kernel_cfg.max_features when either SHSTK or IBT is
>>>>>>>> available.
>>>>>>>>
>>>>>>>> Both user mode shadow stack and indirect branch tracking features depend
>>>>>>>> on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
>>>>>>>> xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.
>>>>>>>>
>>>>>>>> Note, the issue, i.e., CPUID only enumerates IBT but no SHSTK is resulted
>>>>>>>> from CET KVM series which synthesizes guest CPUIDs based on userspace
>>>>>>>> settings,in real world the case is rare. In other words, the exitings
>>>>>>>> dependency check is correct when only user mode SHSTK is available.
>>>>>>>>
>>>>>>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>>>>>>> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>>>>>>> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>>>>>>> ---
>>>>>>>>      arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
>>>>>>>>      1 file changed, 8 insertions(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>>>>>>>> index 73f6bc00d178..6e50a4251e2b 100644
>>>>>>>> --- a/arch/x86/kernel/fpu/xstate.c
>>>>>>>> +++ b/arch/x86/kernel/fpu/xstate.c
>>>>>>>> @@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
>>>>>>>>      	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
>>>>>>>>      	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
>>>>>>>>      	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
>>>>>>>> -	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
>>>>>>>>      	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
>>>>>>>>      	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
>>>>>>>>      };
>>>>>>>> @@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>>>>>>>      			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>>>>>>>>      	}
>>>>>>>>      
>>>>>>>> +	/*
>>>>>>>> +	 * CET user mode xstate bit has been cleared by above sanity check.
>>>>>>>> +	 * Now pick it up if either SHSTK or IBT is available. Either feature
>>>>>>>> +	 * depends on the xstate bit to save/restore user mode states.
>>>>>>>> +	 */
>>>>>>>> +	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
>>>>>>>> +		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
>>>>>>>> +
>>>>>>>>      	if (!cpu_feature_enabled(X86_FEATURE_XFD))
>>>>>>>>      		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>>>>>>>>      
>>>>>>> I am curious:
>>>>>>>
>>>>>>> Any reason why my review feedback was not applied even though you did agree
>>>>>>> that it is reasonable?
>>>>>> My apology! I changed the patch per you feedback but found XFEATURE_CET_USER didn't
>>>>>> work before sending out v7 version, after a close look at the existing code:
>>>>>>
>>>>>>             for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
>>>>>>                     unsigned short cid = xsave_cpuid_features[i];
>>>>>>
>>>>>>                     /* Careful: X86_FEATURE_FPU is 0! */
>>>>>>                     if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
>>>>>>                             fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>>>>>>             }
>>>>>>
>>>>>> With removal of XFEATURE_CET_USER entry from xsave_cpuid_features, actually
>>>>>> above check will clear the bit from fpu_kernel_cfg.max_features.
>>>>> Are you sure about this? If we remove the XFEATURE_CET_USER from the xsave_cpuid_features,
>>>>> then the above loop will not touch it - it loops only over the items in the xsave_cpuid_features
>>>>> array.
>>>> No,  the code is a bit tricky, the actual array size is XFEATURE_XTILE_DATA( ie, 18) + 1, those xfeature bits not listed in init code leave a blank entry with xsave_cpuid_features[i] == 0, so for the blank elements, the loop hits (i != XFEATURE_FP && !cid) then the relevant xfeature bit for i is cleared in fpu_kernel_cfg.max_features. I had the same illusion at first when I replied your comments in v6, and modified the code as you suggested but found the issue during tests. Please double check it.
>>> Oh I see now. IMHO the current code is broken, or at least it violates the
>>> 'Clear XSAVE features that are disabled in the normal CPUID' comment, because
>>> it also clears all xfeatures which have no CPUID bit in the table (except FPU,
>>> for which we have a workaround).
>>>
>>>
>>> How about we do this instead:
>>>
>>> 	for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
>>> 		unsigned short cid = xsave_cpuid_features[i];
>>>
>>> 		if (cid && !boot_cpu_has(cid))
>>> 			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>>> 	}
>> I think existing code is more reasonable,  the side-effect of current code, i.e., masking out
>> the unclaimed xfeature bits, sanitizes the bits in max_features at the first place, then following calculations derived from it become reasonable too.
>
> I strongly disagree with that. Kernel already removes all features bits which it knows nothing about.
>
> There is no need to also remove the xfeatures that it knows about but knows nothing about a CPUID bit.
> For such features the kernel needs either to accept it (like FPU) or remove the feature from set of supported features.

Let me involve Chang, the author of the code in question.

Hi, Chang,
In commit 70c3f1671b0c ("x86/fpu/xstate: Prepare XSAVE feature table for gaps in state component numbers"),
you modified the loop as below:
         for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
-               if (!boot_cpu_has(xsave_cpuid_features[i]))
+               unsigned short cid = xsave_cpuid_features[i];
+
+               /* Careful: X86_FEATURE_FPU is 0! */
+               if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
                         fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
         }

IMHO the change resulted functional change of the loop, i.e., before that only it only clears the bits without CPUIDs,
but after the change, the side-effect of the loop will clear the bits of blank entries ( where xsave_cpuid_features[i] == 0 )
since the loop hits (i != XFEATURE_FP && !cid), is it intended or something else?



