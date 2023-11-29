Return-Path: <kvm+bounces-2763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC8AD7FD904
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A738F282E10
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7793034B;
	Wed, 29 Nov 2023 14:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d6m/+nIh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE19CA2;
	Wed, 29 Nov 2023 06:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701267196; x=1732803196;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0DH5UH5DBZXJ2utKvvIDBd+JXJbeL2uy/mkveTJDAn0=;
  b=d6m/+nIhLmadrzPe/LDiCzKIycGb0nJ1BuypBcsJiM+0finOwiTDa8Sf
   vzEeXd8b+r4VNzX9NgTg3p8TTyQOQIalzZWzQCppYPCrNU6XWfUHhg9um
   FIenN1yqAzGMsOBYA243aNmVr2abbKcFkmzkPlJnoos7B0nKbe6/8IuX7
   fxkgDD4H6R0e+jsOTbI8wqf1yYLFP0Q7Jmsyi8BhmOZH4+R2/II3euL0i
   tB8nqAoSOJl167vnQKiZjcrfptpD64weZC6IRxBvbnA1PHAITyTo2A5eV
   EpvxhT+PjkL+UrhwM1BCJefat2j+XsPWjFr/8N1mEZgAT4LNAS+GoPdmG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="392032328"
X-IronPort-AV: E=Sophos;i="6.04,235,1695711600"; 
   d="scan'208";a="392032328"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 06:13:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="892462446"
X-IronPort-AV: E=Sophos;i="6.04,235,1695711600"; 
   d="scan'208";a="892462446"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Nov 2023 06:13:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 29 Nov 2023 06:13:15 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 29 Nov 2023 06:13:14 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 29 Nov 2023 06:13:14 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 29 Nov 2023 06:13:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZznBxjEUQ6b9xHQfHUN+F+1mG7EXda7dxr3be0oPKmdAK4faK8x7EyB9V2YNnTBIlCagjmcCZb7EG3/j1x2Kn1RMYALfhc98vacYXRFzgcC5fc4x6QRXhFZ4dWUxI5pVbsLEA5L+hIcNKOuwlJwz8PZJJ+V20lEsq2S4Ann1nCEaI+oE2egL7iWfCubtXtNX72Diagb9K6ttK2jiTMhBNddxirmBSvJF37vpkDJ+TNMz65z2W/He1XDVPl8B2GFyp6bBe1+BWEwOra38SvkTMmy9AKzXfheYWayW6OD75V0tMnxq3TspVfMirBd6H/QYQ9pYroTRCaKtZ9HMXSEVQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0DH5UH5DBZXJ2utKvvIDBd+JXJbeL2uy/mkveTJDAn0=;
 b=I4AGdU03ZM6mbXk2PWIwDemRdLCbq/SMTGjpe7iZkhcQGhDOxEcbjzpflldNXPHe9z9d2+6VTJxjD9Ftl1N2F82Bu/vphfeuLT6sEffHigfEg76u4nWJkC4soHfzfWcbk9FtVoMn37nYRXRPlLpt7r/mFyS2YW97PqfGfQxUFAjLMwowtq75zj1NRN9oD3dPQSrKkNwjkFnptl9SVtkvvZBELJWS3slbH1RxD8hDnr6rSSuW/AgKbTbqQ5F0OvN0yTCdW0hUv66VmAOlJbXmVcsTiTNA3lv7TzIGvlMC+k91+zF0SNopFA+AspsZnRjkQBzpIqH+853e0ySi+O3cgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH0PR11MB8167.namprd11.prod.outlook.com (2603:10b6:610:192::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23; Wed, 29 Nov
 2023 14:13:11 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.015; Wed, 29 Nov 2023
 14:13:09 +0000
Message-ID: <e8b77875-d7a2-4898-94d2-248e32b6ebf4@intel.com>
Date: Wed, 29 Nov 2023 22:12:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "john.allen@amd.com"
	<john.allen@amd.com>, "peterz@infradead.org" <peterz@infradead.org>, "Gao,
 Chao" <chao.gao@intel.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-6-weijiang.yang@intel.com>
 <742a95cece1998673aa360be10036c82c0c535ec.camel@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <742a95cece1998673aa360be10036c82c0c535ec.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0041.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::10)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH0PR11MB8167:EE_
X-MS-Office365-Filtering-Correlation-Id: c7d5ea84-5936-4e84-00b3-08dbf0e5503f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a2oo9w8GmTFFxjh3U/eUOEXcC+C2lV3DNqLm+4sBP+Ael0dQBypFtHZOecL3wR/e785AfpbdI5nAQ1hc1OionXK3alhRR5079O2j1MwknbDTdtjC7knfv05YgDk3uhG8kZUpyg9+z/T4hwWws9e6mGVKXiPwUhZnM3rS5gS/KgoSGO74iVzSJrilfuzfvuBHrw/1dm2RANDcvDyjxoHSjhYxBKeWQ1Q/64YFSV2XTx3NqMWebZO8PJOq3NopfcrXY5lVsDzLCsb6kG/rIoX0PWj7bNK/SnoHKDyY2kUE0Vq2GfwJU61VdzG6bAmlAxV09OrkERa6xbS/FQOgVOi9Z2tWypklGuhBB4RU1tusrW5+6TDydbnQJWfe2fwzl58RIT4/gkBY+oEgQVU2PvOfMRRjth32VctoRfgEnTjHKKeWkXuvnj7zs2d3nFiYFi7YPI/8fxzOM5E0dKMIESXECf4SUZTN5rxhoPlsnbuvIf0nsMfP4IlQ/uf4reQUYn2NPk+dU3muUx/ObwslwAw0RxplJuGmlEUtF0gH5KzBlJXjmrhzfJb6pyKFcGnCqeKM/JyeatcuT2UIgfmgLqS3fFO9d4f3cSBmIQ8qQ7+8XWI1t3OO2n+dh9sYQN3MWnoozWcfBAf5+EXbh1YOb6dIqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(39860400002)(376002)(136003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(31686004)(478600001)(2616005)(26005)(6486002)(6666004)(53546011)(6512007)(6506007)(82960400001)(38100700002)(31696002)(86362001)(36756003)(41300700001)(5660300002)(54906003)(66946007)(66556008)(66476007)(6636002)(2906002)(4744005)(4001150100001)(8936002)(6862004)(4326008)(8676002)(316002)(37006003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0Vkbm1wTUV3M0IyakhzQnJNUmRVYlkzRm5QczdReDV1c0ZOWm1tMjFkYU1x?=
 =?utf-8?B?VTZxMm5aQmZVelBBYldPYUxGeE5URkg1cmNTWVhSNC9KMjFuaVdXZ09kUFBV?=
 =?utf-8?B?OXc1ZGxlSWJNTmZyQjlaRTJsVjlwdFFTb3JqTzdmZUNCQURYMDR0dmlwU3lp?=
 =?utf-8?B?UzV3dURwTndTbElwQXVsS2J6RFNaYVFTSndmYUtqdjJQajluU0EweWYyQjVC?=
 =?utf-8?B?S1NaTFk1ZEdtMFJTajVTRyt6WFFhRSs2ZkFsQzJQZG9JZ3RzVmRSNTB5dVoy?=
 =?utf-8?B?V2I2LzE5cnJ1Qmd2eWtRZjNNOTEyTk4zaEF6V214eWtZdGZqMC9BbkdQRkg3?=
 =?utf-8?B?aVg1VGRicU9vUU9xZUVGSDZmRTNPUEQ0OXZQTk9MNWc4Y3AvTE5lYUY1Nmhs?=
 =?utf-8?B?NmtETUVmSVViYXk5ZXlZNkhuMkdJZTUvTDRDblJoUVlIVzlBa00zV0Jld1JU?=
 =?utf-8?B?UE0zcFZxbGZzUk51b3o1c2tHSnhvQjZJSSs2WWpHK0E0S0RmQUVlRjhDMHhl?=
 =?utf-8?B?ZmxiZEtUamdsd0h0dTRnVmdDN1JaS0Y3a1N2QlkyU1htKzYrRW5UcWhVeXoy?=
 =?utf-8?B?UXhKNXZSbENZM2JFN0wyczdHQnE4OXo1UUlsZjJ5SDl6SW1icGh4TUxtcmxB?=
 =?utf-8?B?MXg0YmdSbnYrbTN2aFdpTGpHVVM2RG9kNzZpblBoTTVSV0tCZU9LMHlURXgv?=
 =?utf-8?B?WVFXZHhtbUdjYldqUUF3TVh0T1ovWkVtQmFvcTVWdGVYb21LWHFyNmF0UDNJ?=
 =?utf-8?B?SUtVVndqaGJiZVpwU3o5cWgyMnFzZEc2NHhvaU1tSGxWdHYxVnZzUGFTbWhR?=
 =?utf-8?B?bFBORjlYc0VKaUY5T3Z5bEdCQ1VkanNwUHZySFZkUExTQ2tQK3NqUGVLa2lz?=
 =?utf-8?B?V0piMFFHRDRWTTFXYm14elhyeDBsMUI5c3c2bHNUQmxlSm5CT3JaNEVFM0hT?=
 =?utf-8?B?d3FuRVY5L2c0NCs2dzRvQ1k2M1JCcUQrbzc1YnQxSUg4WTByVG1yYUNRa0g0?=
 =?utf-8?B?Skp5SCtMK1llaU94QUJrcWFDY1VZMFZWckIrbjdhWUVHUHhqNEpIZ00zYThQ?=
 =?utf-8?B?QW9DQnl6NlpwcnkzdVRYT2RQZ2Q0cVpMRG5FVnZLRkJSckdSL2QrazNocThC?=
 =?utf-8?B?QVpPYnF5OUJ5SlRWWG1NeDBVWEtoSm9vNjE4SVlZcUZoZW1wM090U3lrTHFQ?=
 =?utf-8?B?OHB3RWxKTGpadElnTUk3Q05QRGI3U2xBZnYxb1BDd3o2NGNxSjZabmVtdXIx?=
 =?utf-8?B?blNkWFFYdjViUzFUamlTeTYyekxLNGRhLzZ1bzNYb3NiOXRRSU9kNUcvVmJ3?=
 =?utf-8?B?MVdMbERRVlFvbVA3am9zcjU0VndkOWU3ZlJsbE9xYjNoYjlTNHdRVnp2TUQ1?=
 =?utf-8?B?eUdhaVZsbnYvcjc1Z2J5ZG16ZmpLamhLWjRvUG5pZTdvWVBJcHRvT2hxRHc0?=
 =?utf-8?B?cWFjNnozb0p6clN5alRvUDM1a0I0QmNYSXk5UGNJZXpiN1RqMlNqRC91WVZQ?=
 =?utf-8?B?ajNCOFZEbWszdzVBN1I3ZXlXZ2FKeDhXRUd2V1hLdXFNZzlCRmhtU25aQTkv?=
 =?utf-8?B?TTVQT0lVK2FnUER3bWlnbk5FRll2Z2lLN2hUTk0xWXVUQ25lbDRjYm9HdThS?=
 =?utf-8?B?VzN6ci84MHVycWt6SHRFRStrU3NUTTFsa1JwWkcyODZxZGt4ek94ODZBbXhF?=
 =?utf-8?B?dk5vOU5SY0h4bEplMTErdXY3L1dDYllUMmFMTkd6eEt2REhRZXIxWGJxVFF2?=
 =?utf-8?B?UFpobWlmMTVlR25qVG5pSjVYc2p3Zm5HbWJXK1B6dHFwK1B5T3I0R0U5VEJL?=
 =?utf-8?B?NU5HUnpKbUJHZk96OG0xOWNpR1dNUmRCQWp4RXVGSWRYY1NBNkFWUUhyYUxH?=
 =?utf-8?B?MFN5OFlnY3VxUkFzTnJtZ0RVZlk4VGtZNE5ybVRjSEFBczJtc0VLcGN2MVNs?=
 =?utf-8?B?VUZZOFU1MFcwUG1nc2Zxbk1DT2dKY1AxYTdLMkluODJIOFAvOCsvVUFxTkE5?=
 =?utf-8?B?TlVIditlbW5FTW9KTXhadFJSS05JaVZxcERWazdqMGpQa0szcWlid3FMK2tp?=
 =?utf-8?B?QjFFMTRsTDNYQnB1UFpOLzVzM1J4ZDVQZ3l6Tk5mOGU3ak1ZMW5ab1pXR3VY?=
 =?utf-8?B?bG5YR2FzYU1XTUpCR0QralBrZk9oTTlwYnpwWFdqZDVQaXkyaFM0Smg3cXZ0?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d5ea84-5936-4e84-00b3-08dbf0e5503f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 14:13:09.2358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wp5HgZp4bV4bo4lav2+d0P6LSEyIqjWnDjuZBZPxxVEx3e4DpAMuQ/O2KrpEd2G3NrcQBN89rMJ7GVovIWUEmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8167
X-OriginatorOrg: intel.com

On 11/28/2023 10:58 PM, Edgecombe, Rick P wrote:
> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> +       /*
>> +        * Set guest's __user_state_size to fpu_user_cfg.default_size
>> so that
>> +        * existing uAPIs can still work.
>> +        */
>> +       fpu->guest_perm.__user_state_size =
>> fpu_user_cfg.default_size;
> It seems like an appropriate value, but where does this come into play
> exactly for guest FPUs?

I don't see there's special usage of this field for vCPU in VMM userspace(QEMU).
Maybe it's mainly for AMX resulted usespace fault handling? For vCPU thread,
it's only  referenced when AMX is enabled via __xfd_enable_feature() .



