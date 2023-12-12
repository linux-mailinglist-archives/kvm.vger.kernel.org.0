Return-Path: <kvm+bounces-4158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDF6D80E6F2
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 09:56:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 742AE281371
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 08:56:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641F95810F;
	Tue, 12 Dec 2023 08:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W+Kee37r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E361109;
	Tue, 12 Dec 2023 00:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702371389; x=1733907389;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pKlauC39CUaMXyGCNCBqWr8aS44wSrGDSowg63gB7y0=;
  b=W+Kee37rkeh1ZJYI2jMzXNNd7mq4xra7WOZIyc8Y49CqP5BzuuQzWGjG
   lEG8R8sSv/ytBmrBvZh6bXE6fvuD+kzHkNPM5iEwnVvgEJW70bK38qMsC
   EEbBQtnE72s7Vd6eNuUZc6zFmLn51rEUQmWIWLkRLWANFiYr33vd5BXt1
   8ruV5jW+/bRCe1t3W/7UTuxxKMXgcB7VecfjQDDZVPFRnCMgC+w5eBsg1
   cE+sWHT1gwKvYxgc7Lqhw9Odf/64wIS7YUkUFxTM5dve3/i41PMN691z9
   4vrwGYipK/6oaVIV5iBwA1n5RUF5q86aqtsoPPIYAPckOsSxjuQtlkRdV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="13467003"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="13467003"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 00:56:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="896835763"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="896835763"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Dec 2023 00:56:27 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Dec 2023 00:56:27 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 12 Dec 2023 00:56:27 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 12 Dec 2023 00:56:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVdz3SzmlvgxDtiAj0BV0svyzH2bAU6teSmb5lL7n3ejFdjsuP2u0WYwc7+ACTt2B1nqET1wQ2MKSxHf3ZseTkr4lO4VwkaR6cFc3GNXoUrl+8rMCllcgZ8ppdrioU6onjwEY6y1sA5gw7DKNnhD6MMrAu1M4fb+IvCQ+AbfORj+aUUY+0z9wk0Dg4LQhzP8xGjU54kw5PStq3opBa7Y90agxYk/N+y+LKuXNVVbxFEAF6d7IQQ9jyCgzDrkRE0j1TWXDvQiOGeMXwv5vLQ4rLX4oLmwP/F+zOFaE4h+LqeI1y3nR3GHq4sW5JjtEZEL0RbVGnhMs47NxuRpTSk/SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOqyJaXmPr5hvr+kRN7oBJsR+0spU5N2DdKQ7tPuKxI=;
 b=FJ5+0+dGVosAQVIDZetIvpvjq1vxAPnPqCQ2Xo8qq6vgh2a40Rinqt8/hAbnaLTKehNtpposVftMy/jMA2PXYq4XnGUmo0xz+AcXsyCNq46hkApcFDFBS3Dbu9uyFMihMhMcBGc1qE+xaV//oeJaKU8J9fIuiZtsGfW9qbBn31nr8c/TQoFy8z4r533MnXbYfU5MR5rHQ4m3lD4+zxx3knUYe66O+gIqLQufOYg1401ReljBRSsN7TO+mPmBLbHaZcTHeKNcykwiSU7xlMvTz3eh1+/lw6gh6C0cuot34y87omAsShZOSCMaja5ECFTHOEpG9FVsNL9ldIxuy5QrNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB5117.namprd11.prod.outlook.com (2603:10b6:a03:2d0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.33; Tue, 12 Dec
 2023 08:56:24 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7068.033; Tue, 12 Dec 2023
 08:56:24 +0000
Message-ID: <307dea63-ff53-4116-8752-f717d385cb9e@intel.com>
Date: Tue, 12 Dec 2023 16:56:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 26/26] KVM: nVMX: Enable CET support for nested guest
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-27-weijiang.yang@intel.com>
 <2e280f545e8b15500fc4a2a77f6000a51f6f8bbd.camel@redhat.com>
 <e7d399a2-a4ff-4e27-af09-a8611985648a@intel.com>
 <8a2216b0c1a945e33a18a981cbce7737a07de52d.camel@redhat.com>
 <73119078-7483-42e0-bb1f-b696932b6cd2@intel.com>
 <53a25a11927f0c4b3f689d532af2a0ee67826fa8.camel@redhat.com>
 <26313af3-3a75-4a3c-9935-526b07a6277d@intel.com>
 <06298f6200aa0b6e9eaf1d908d8499bb50467fe0.camel@redhat.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <06298f6200aa0b6e9eaf1d908d8499bb50467fe0.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 97709384-21e3-407b-2509-08dbfaf037c7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zmyddVtrRHQu8c2G/vlaTm5oKHD0HUMBPxwZsIUWtw6YhnGnqoZvxDRlZta63DXeclz8nCHI9vS9rLKfxceAkjdz1Xzl0jmh4Tj4mwOCIYBVwgKaFTsdal1LXJ/oFJsRb4GwMJ9B8ZBfWrvyVb6YpCNm3y1kadkjW7Ql9+7GGLE85ErgQexHKvpqesOhQE/al01X2j8xAC9LxjgGhkqvHM1wecD6TWRPTCbSEYj8jJbW96auuIp0q1+gFFI8sIqthwsji/zSfcJg2W3Fc7SbhUzZNazq7GNmPugGtRPFaaThKXT5KHCbINXFxf0DJ6jU/vwFZF+1HLzORI9yc7ugt99pnI7GUpTOjldW85etcdRv9gZqM9DQVrFD3oPPkXjnQa77nWtmqrsZYLzhFB/k9/FdZwxa4UeeZHEMurZj6o6Hn3N/nRbXYIcVF3ryO1gKadJ8vxXvRBiXGhWYeS4NBKroxDLqrGK0UTcFIP5nFOZvZReI83Y8rBOgor7Foe3gvCJ44z0XPKnjauTBqBOOpSmYz0SamumgBCjgigGlUR7fxFWruc2vCvdgm6TFVzpA2epklAKt48LhjzJGFZRvvfMdVjFVIwI9hrfhtxq8V0lnmuzA8KCi7MZ36Cb1GpIktCuRlgn1HlWDZSnVULrgZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(26005)(2616005)(6506007)(6666004)(6512007)(53546011)(83380400001)(5660300002)(4326008)(2906002)(41300700001)(8676002)(478600001)(6486002)(8936002)(316002)(6916009)(66946007)(66476007)(66556008)(82960400001)(36756003)(86362001)(31696002)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDQ0ZCtrT2loMjIyMjBERGdva3ByYmJjeTc3NWN4b0hhMzkybkxKR0VqVkpG?=
 =?utf-8?B?TGVrQW01ZnVxSVB0SFlkcWNhYTFYamloS2YxS1RLR2R5bzYxcEJzSno3Y05K?=
 =?utf-8?B?YzI1Uk9xSWRmczFQUjhENlZXLzlVTzFRTmhRV285VEJ0K1J4MlBqQ21VOW00?=
 =?utf-8?B?UnplVXJDRkR1VmtRUVFDOWhqZEVpb2dzRzRHNjRuSmVKZURaSkhORDZKYi9L?=
 =?utf-8?B?d2EzbkE0aXBobnNjOTh5eEVjWDQwaElJbWFSTEZYWUZZRjVBSFh5NHMzVXpm?=
 =?utf-8?B?MXBuRHZRTHMvRlExdlVQRDN1bGdUWjJjajlTSnRDcVRHbC9aalZ1WnhxaW9G?=
 =?utf-8?B?ODZwb2l1SkNObVdyemtnK0ZFUFlRN3pQa2x4Mmw4RWFOMzlTOFdzdmFoMnBV?=
 =?utf-8?B?VDhsc0dSU05NU3F3YXhFNXQwaG45QzdXZEl2RldOWG9IMGNBL1hFTkduMG9T?=
 =?utf-8?B?VDgyeExjczR0Y1krSmt0cWpGTkpOaVliVjg5bkcyMVVTbzBwNHU2cm5ma1Bj?=
 =?utf-8?B?N2lLaEszdXpVWDJBeFA0dXdaeHhIcVJKRmtXT05hOFZaVmMvU2wwOWZoS0J6?=
 =?utf-8?B?bkQ3MlR1OWVIa3NKYlNEb1RWQndKM1AzaDVZQkw1Qk5DN09jMVgvYnlQZkNh?=
 =?utf-8?B?OU1kbURqTjB0NGFpMGV5TXdEWVJnU0xQcU9iUWJKV2YwWFBwL0pZekRxVzRX?=
 =?utf-8?B?RVVQQ1pkbmlHL3lxSUhpQ1RSOGhGWWREM2FGUm1QeENodFV2Tk0xN2VFNEJz?=
 =?utf-8?B?aFZoZzBZbml4ck1SNHNraGt5TU0zeFFuczI5Rm9xVVJSTlFVTWtTRVh6VzFz?=
 =?utf-8?B?Sng3ampaelRPaFIyb3MwUEV2L09rSFFmMGZpNU8xb0d3djFxVER3MVpvTzZo?=
 =?utf-8?B?ZTN2RUFpc09OckVBMkFvVWdWbUU0a3lsc0hKaWtxQUtJRXdHRWNacXV2SWtO?=
 =?utf-8?B?ejgzQVZLMlI3MWQ1YklzbDIwdUJTM2RxZ3V4aFdVRFUwVlRBZHVOd3N6MElV?=
 =?utf-8?B?OCtFNkYvbUZ1M2IwYWYyQ1FLeDE4T0NPdTJYcGNpL1ZndHA4eG01UXZCTGJr?=
 =?utf-8?B?M01Fd09YdzVJR3Y4R0tOYmtlQi9uV010bGJKSXJoSHdxYkRFK2dwTUxMUm8x?=
 =?utf-8?B?SEloN2JkajdXMTBkUy9WWGQxRFJZT1JIUEJ6b2daRE9iSkpadThsd0tWRUhF?=
 =?utf-8?B?RXU5R0k5bFo1TDQzcFB3dlJpTXJJNW1NMmV5OXJtNEFoN0wwamlrYTJ6bllQ?=
 =?utf-8?B?cmN2R0pHRDNvTHl1TVYxeEdPd1BOSXBGMW1oUHhPcnNWVFBHUGpzVjhCMWZl?=
 =?utf-8?B?M0lyQXNBbmE2dlh1YVFsTlRiMkVRNm0rVDk2MjkrODJCOW81OTFJTkkxeDlQ?=
 =?utf-8?B?QXpycWNCckZaQXhkNXZkMzB4QVNFNkVOQVRkTkR6V2YrMjgrN3d0bXZLQmNP?=
 =?utf-8?B?eVlkTFhqdDdRS2hRYXZYL09BM2JIWXVpMm5pVGFDcWtiQ1FvTXRHQTZXSmFU?=
 =?utf-8?B?UFNzOERNQXIrUGNRQVE2VmJmRjZSV1dkZ1IzRStGbTJGaVNPQUFkWkJUQ00r?=
 =?utf-8?B?aGxNQjRTaTFCMnBCeHFKWW0zWms2OW05RmwxUks4TkErZ1d6RVR2ZFhOMzlp?=
 =?utf-8?B?eFlTeUluVDRkbU42SGFIdkZCYk1wTzNub2VvcDZ5dmhjS09ZZkpHZWlUL3Mw?=
 =?utf-8?B?V05RdWorTUhjL3A5SjJ4dlFYZEtCV1Ivb0FOWVNub1kxMlQ1WHJid29vMjdX?=
 =?utf-8?B?dmFlYnVTeS9mZTVpTGZ0Z1orZk1NS1F0ZVNPNWpBYXpCYjJvL1lyd1BaM1ZZ?=
 =?utf-8?B?dWxLUEh6VDUvR25mUzZpeWpRc2tmVS8rMExURkR2UGpRbXBrYWFHc25PR3pt?=
 =?utf-8?B?Z2NsUXZFNHhsTmRIcGRRcjlsMGFiT1E3dTFjTnRsRzE1dWZXS2h0U1kwRnVX?=
 =?utf-8?B?TFFIOWhKZlpqVm10dVhmU1hyMEZ4OG5SYW56V0xEVDNmV3R5THJBckgyVitz?=
 =?utf-8?B?VmkxRVVRdURhTFYyRjh4SmtrVDFEVVJQVU1YazFqUjNjNFJHSjZwRUJjc1Jm?=
 =?utf-8?B?NVBNOVlNdUZFUUJWQ20rN25aNDlFMStFWnFHMGVWUWRCek4waW1MUVFSY21V?=
 =?utf-8?B?ZWZ1NkkwK291QVlJVmowRkFhVTlYbEkyeHlUMGltZ09WeVA2SWZtZzd4enFJ?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97709384-21e3-407b-2509-08dbfaf037c7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2023 08:56:24.1136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XiSV4GPsJ8YoQLjqYlQ15v3/fv5Tc5UFvSS17PrjCg6yqR4qWok++l0roxIqRAPaOYi2/v/yHhGXiZXCf7bZwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5117
X-OriginatorOrg: intel.com



On 12/8/2023 11:22 PM, Maxim Levitsky wrote:
> On Fri, 2023-12-08 at 23:15 +0800, Yang, Weijiang wrote:
>> On 12/7/2023 1:24 AM, Maxim Levitsky wrote:
>>> On Wed, 2023-12-06 at 17:22 +0800, Yang, Weijiang wrote:
>>>> On 12/5/2023 6:12 PM, Maxim Levitsky wrote:
>>>>> On Mon, 2023-12-04 at 16:50 +0800, Yang, Weijiang wrote:
>>>> [...]
>>>>
>>>>>>>>      	vmx->nested.force_msr_bitmap_recalc = false;
>>>>>>>> @@ -2469,6 +2491,18 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>>>>>>>>      		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
>>>>>>>>      		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>>>>>>>>      			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
>>>>>>>> +
>>>>>>>> +		if (vmx->nested.nested_run_pending &&
>>>>>>> I don't think that nested.nested_run_pending check is needed.
>>>>>>> prepare_vmcs02_rare is not going to be called unless the nested run is pending.
>>>>>> But there're other paths along to call prepare_vmcs02_rare(), e.g., vmx_set_nested_state()-> nested_vmx_enter_non_root_mode()-> prepare_vmcs02_rare(), especially when L1 instead of L2 was running. In this case, nested.nested_run_pending == false,
>>>>>> we don't need to update vmcs02's fields at the point until L2 is being resumed.
>>>>> - If we restore VM from migration stream when L2 is *not running*, then prepare_vmcs02_rare won't be called,
>>>>> because nested_vmx_enter_non_root_mode will not be called, because in turn there is no nested vmcs to load.
>>>>>
>>>>> - If we restore VM from migration stream when L2 is *about to run* (KVM emulated the VMRESUME/VMLAUNCH,
>>>>> but we didn't do the actual hardware VMLAUNCH/VMRESUME on vmcs02, then the 'nested_run_pending' will be true, it will be restored
>>>>> from the migration stream.
>>>>>
>>>>> - If we migrate while nested guest was run once but didn't VMEXIT to L1 yet, then yes, nested.nested_run_pending will be false indeed,
>>>>> but we still need to setup vmcs02, otherwise it will be left with default zero values.
>>>> Thanks a lot for recapping these cases! I overlooked some nested flags before. It makes sense to remove nested.nested_run_pending.
>>>>> Remember that prior to setting nested state the VM wasn't running even once usually, unlike when the guest enters nested state normally.
>>>>>
>>>>>>>> +		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
>>>>>>>> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>>>>>>>> +				vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
>>>>>>>> +				vmcs_writel(GUEST_INTR_SSP_TABLE,
>>>>>>>> +					    vmcs12->guest_ssp_tbl);
>>>>>>>> +			}
>>>>>>>> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>>>>>>>> +			    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT))
>>>>>>>> +				vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
>>>>>>>> +		}
>>>>>>>>      	}
>>>>>>>>      
>>>>>>>>      	if (nested_cpu_has_xsaves(vmcs12))
>>>>>>>> @@ -4300,6 +4334,15 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>>>>>>>>      	vmcs12->guest_pending_dbg_exceptions =
>>>>>>>>      		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>>>>>>>>      
>>>>>>>> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>>>>>>>> +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
>>>>>>>> +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
>>>>>>>> +	}
>>>>>>>> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>>>>>>>> +	    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT)) {
>>>>>>>> +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
>>>>>>>> +	}
>>>>>>> The above code should be conditional on VM_ENTRY_LOAD_CET_STATE - if the guest (L2) state
>>>>>>> was loaded, then it must be updated on exit - this is usually how VMX works.
>>>>>> I think this is not for L2 VM_ENTRY_LOAD_CET_STATE, it happens in prepare_vmcs02_rare(). IIUC, the guest registers will be saved into VMCS fields unconditionally when vm-exit happens,
>>>>>> so these fields for L2 guest should be synced to L1 unconditionally.
>>>>> "the guest registers will be saved into VMCS fields unconditionally"
>>>>> This is not true, unless there is a bug.
>>>> I checked the latest SDM, there's no such kind of wording regarding CET entry/exit control bits. The wording comes from
>>>> the individual CET spec.:
>>>> "10.6 VM Exit
>>>> On processors that support CET, the VM exit saves the state of IA32_S_CET, SSP and IA32_INTERRUPT_SSP_TABLE_ADDR MSR to the VMCS guest-state area unconditionally."
>>>> But since it doesn't appear in SDM, I shouldn't take it for granted.
>>> SDM spec from September 2023:
>>>
>>> 28.3.1 Saving Control Registers, Debug Registers, and MSRs
>>>
>>> "If the processor supports the 1-setting of the “load CET” VM-entry control, the contents of the IA32_S_CET and
>>> IA32_INTERRUPT_SSP_TABLE_ADDR MSRs are saved into the corresponding fields. On processors that do not
>>> support Intel 64 architecture, bits 63:32 of these MSRs are not saved."
>>>
>>> Honestly it's not 100% clear if the “load CET” should be set to 1 to trigger the restore, or that this control just needs to be
>>> supported on the CPU.
>>> It does feel like you are right here, that CPU always saves the guest state, but allows to not load it on VM entry via
>>> “load CET” VM entry control.
>>>
>>> IMHO its best to check what the bare metal does by rigging a test by patching the host kernel to not set the 'load CET' control,
>>> and see if the CPU still updates the guest CET fields on the VM exit.
>> OK, I'll do some tests to see what's happening, thanks!
>>>>> the vmcs12 VM_ENTRY_LOAD_CET_STATE should be passed through as is to vmcs02, so if the nested guest doesn't set this bit
>>>>> the entry/exit using vmcs02 will not touch the CET state, which is unusual but allowed by the spec I think - a nested hypervisor can opt for example to save/load
>>>>> this state manually or use msr load/store lists instead.
>>>> Right although the use case should be rare, will modify the code to check VM_ENTRY_LOAD_CET_STATE. Thanks!
>>>>> Regardless of this,
>>>>> if the guest didn't set VM_ENTRY_LOAD_CET_STATE, then vmcs12 guest fields should neither be loaded on VM entry (copied to vmcs02) nor updated on VM exit,
>>>>> (that is copied back to vmcs12) this is what is written in the VMX spec.
>>>> What's the VMX spec. your're referring to here?
>>> SDM.
>>>
>>> In fact, now that I am thinking about this again, it should be OK to unconditionally copy the CET fields from vmcs12 to vmcs02, because as long as the
>>> VM_ENTRY_LOAD_CET_STATE is not set, the CPU should care about their values in the vmcs02.
> I noticed a typo. I meant that the CPU should't  care about their values in the vmcs02.
>
>>> And about the other way around, assuming that I made a mistake as I said above, then the other way around is indeed unconditional.
>>>
>>>
>>> Sorry for a bit of a confusion.
>> NP, I also double check it with HW Arch and get it back.
>> Thanks for raising these questions!

I got reply from HW Arch, the guest CET state is saved unconditionally:

"On the state save side, uCode doesn’t check for an exit control (or the load CET VM-entry control), but rather since it supports (as of TGL/SPR) CET,
  it unconditionally saves the state to the VMCS guest-state area. "

> Thanks to you too!
>
>
> Best regards,
> 	Maxim Levitsky
>
>>> Best regards,
>>> 	Maxim Levitsky
>>>
>>>
>


