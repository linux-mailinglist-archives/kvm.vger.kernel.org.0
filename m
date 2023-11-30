Return-Path: <kvm+bounces-2910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2709D7FF01C
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:28:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4EA0281F4E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 13:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E91647A68;
	Thu, 30 Nov 2023 13:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RCpSzzN8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4D1D6C;
	Thu, 30 Nov 2023 05:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701350907; x=1732886907;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y+mIEM7jOdGR274ZmVAx52/YO4u+jAzoblsGMtfZEEs=;
  b=RCpSzzN8Qw9zgIGUlaXHYJWt0ZB5BJU8w4HHoC9tOMTTWXyLGKxi6Vjn
   4Cl/E+snxrFJQRn+HWPmP61O/VkiKiKCUlUTtLy6gD4GlS+sQpnx+cjMs
   cp0cPKcLUMmUEgqpFnZuzgUl9lhgv5CRujDoJKEC8BI8cRMKjyn0YZmb0
   r75DbpcQEgETvvJr9OxC2nWZVRijzrhvRyw3VV5RfcAvMnU3hlFiWh4/H
   Ur+1nCA17zEe88Mwvibb6EH/pVGVnUNXetB+BhOydvkeXOhdQl7ydVvP3
   AZT92sNfXL++DdKEfLD1RIgDuRIIjySG/UisQepfTbA46rjkMENOiB0vk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="390485859"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="390485859"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 05:28:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="839795075"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="839795075"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Nov 2023 05:28:23 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 05:28:22 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 05:28:21 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 30 Nov 2023 05:28:21 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 30 Nov 2023 05:28:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gukUfWPkxZ2/xTLcqrLER4FvA8HEQn/FbBv1FgKv1FJpL+i4ZfGV7D/y7FWwZcLdA9LbmxbrlZq+BDa4I57jUBrBfMvI4/+aDQdQPxw24ULnj89kk1zn8Ayljk8m6EUrXUaJfCSBX8pLJmmw5BHxgcF/8y0dnSYbpFRdeS331BoXYjyhInzGH+e45V2vFar7WkZGL3PBDER8xA55FvbguP7Hk1vcDiw5EiB2jr8ncH+Tc/Cqh3H7qc6jrQHPOPTzp20mCQa+ZLnzd9plZlnVLLu5Xg9+Dq8r+b0VVwbK4hc/Ka0oXY6sybGAdNHRCI4zYBvy5j6bjz815XG9J7owkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+mIEM7jOdGR274ZmVAx52/YO4u+jAzoblsGMtfZEEs=;
 b=AbKgON91sSV+jGQYp0kR9QNb5Qk4zV/5B4Jq1FqawSzxB2DeYrD6lnrE3TIRZ+YjQQIp2B87vzq47sxZF/ml1dzHxCwgHZAWxqgBz9HGLfKLKd2/aGL9h2tvIv9wRwcrekOrcbdlcgS0CUeYyxy19i1511troL1qPx2CNseifVxq3NP8gRSi/KUJcUPzL6Ut1LOZXTq0ObKQyObqu1htcBlwftkkz6s0hx6SLXjzqmQmLHiO6cHFGMVkt+BjiB4S+3FS0K5iLd3NURvmLN4TxHqUUb2n0Scs6AHunm8mlQUZGQ/pzuyMvtQ0BOaN8nJ8Ef0nTJRCb9otinDrlvFxpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH8PR11MB6951.namprd11.prod.outlook.com (2603:10b6:510:225::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Thu, 30 Nov
 2023 13:28:12 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.024; Thu, 30 Nov 2023
 13:28:11 +0000
Message-ID: <c7c7295a-ae5e-420a-837e-5bc6e18ee90c@intel.com>
Date: Thu, 30 Nov 2023 21:28:02 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-6-weijiang.yang@intel.com>
 <742a95cece1998673aa360be10036c82c0c535ec.camel@intel.com>
 <e8b77875-d7a2-4898-94d2-248e32b6ebf4@intel.com>
 <a8ee5217a98b261a2eace9a0b543e43796607156.camel@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <a8ee5217a98b261a2eace9a0b543e43796607156.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0012.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::8) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH8PR11MB6951:EE_
X-MS-Office365-Filtering-Correlation-Id: 77e2ad79-37d8-414c-d709-08dbf1a832d7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B/SipWWkD0j4DD+swDh/On4Q7xlDRpaJnQ48Sjjni2+LUPZqE5OaP/nAWAYvM4d87B9WV1k/BtADs6KDWRxghDRlZYV441hnVGxHTxUrxrkJq/0Jc2jeYMT8lH83NvjX9OBlJhwMIlMJmu9no/xAMtDW4lnsyuMJ3qIgNh0LiHgaqRx/gCUUh9bVX1IQju2F+EPK5Pe2ZTmeNszQphqJJyB4ePq3+y1KKLaWFqHzZc4kmljGdNKlFqpNFXlk03T7v2+SwIMGHGiR+HUhTCrfw9CoJBB4L+25UIZMu907C2LJuSFvGLi8I1TzBjtYrjHgqxqsYl2YrQEEnCDB6DUQXNE5TbgOi2yo17D1T3g9PJINJbVC1nQhoFcQ+0K4QFwjz/E1IscAHQ9BB9G3bUPk1vdwTQEXpgTsifAVlH6nC4pqP0YlrJ3YgF9lMpa0/eA/We8U1OfwGZ9uZBHEHliWjkkbTCjOE4CfDFUa+RVgd1yfkkHXE3/X5CZwqrPYdj8anyUjSS9sYSZTeH+VtTPUQM4aJGs/wGNTyyGDaci2mzSWNJLTRMDBG82EZGUrKw3zBdwKG1tNWvfyl6NyNBDBORQ5+9M2lu7J8okoL85Jqf1Avy6NyTa+5RPPVDzhBO43Fn8m1E4m5Vquh88j4M5v8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(396003)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(86362001)(5660300002)(31696002)(316002)(6636002)(37006003)(66946007)(54906003)(66476007)(66556008)(8676002)(6862004)(8936002)(4326008)(41300700001)(36756003)(4001150100001)(2906002)(26005)(2616005)(82960400001)(6512007)(53546011)(6506007)(31686004)(38100700002)(6666004)(478600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUdqbkZqNUFYeFRHMGFGcnlPVnAvRnAyYXNJZWZJZ1ozT0FpcHB1aS91UG8x?=
 =?utf-8?B?MkUraDhzN2RoeVJHNHV6ZVlmdGpkaVlCRHJEenRLbllwTllkVjdYUTBjdE82?=
 =?utf-8?B?b2dYU21tZ01sTklqVzBwZDBsL3F1b2o2NllJb0J5c3hOcGxyVTVRM3hldnRB?=
 =?utf-8?B?dm1uVENQKzBYK01qemRDaS9iamVUaW85ODlBTlhsQU1wbHQ5cVRwRCt3V1FJ?=
 =?utf-8?B?bm12SWdicmhIMVJSbnBQd3B0Z2pRL1F5bXNpZmhqNnU3dU1Ba1pMQnZwTlRh?=
 =?utf-8?B?QUx3STJxc3gzSlA4d29kSys2NC9uK3QzZDNBQ0xwa3FGcDkzalczOW8zTkQ0?=
 =?utf-8?B?Ky9XdjZTN1VkWW5EN0o1bFNjdTdlVy81aUxUK1FwcE9iQ3JlNFFTRVNrTC91?=
 =?utf-8?B?L0FyMkcxNzhoVG4rYndJVFZwYnBuTWdscGxBM2hFNythcVQ0NlEwUEpvdHRu?=
 =?utf-8?B?WVNvSi8rOHh5dVg2U0VVbTN1TGR6S0ZLcW9UMkxra2tpOVBJd2tnczQ5OEcz?=
 =?utf-8?B?WlVlazNncTgrQ1dIUHVGY2g5aDJRelA4L1RKdGw0Q2NDK0lFbFl5ZHFIcTU3?=
 =?utf-8?B?cHVjWXhzQU1oQVZPTGhRdi9hWkwwQnZXNnJtZVNpQjhnUlJmbGdOSVM2Z2x1?=
 =?utf-8?B?cmhlWEZQU0R6UmRONFlJUVJMMTg1Vml2RURRZk50Vi9PSzc0SnpBQkZJTDQ0?=
 =?utf-8?B?bXgyWjRxM2ppQ3VLOXlGSjRqN2padXZVUHZGSXBCNnRWb2hzSkM3ZURZZGNo?=
 =?utf-8?B?TWxDT2VKQTJyZFlwYkZwRytJWndaNzgwU0JNVC9lcjB5Q0ltYzJOMVV2KzVk?=
 =?utf-8?B?V0p1L3loWFM5YWQwMVQ5YzdwVGk0aG5pSU93RUlTQ1o5eDBudSs4N0o5Qk1y?=
 =?utf-8?B?aEk3QTNPRjQ5V2cvYk1Sd3hueitEditPVFRCd2pVbFR4OUVKZFh3c3RWZjZs?=
 =?utf-8?B?ZHdNaWhZMUpsSmxtYWk4T0t3QmJoVURHa3BaMTYyVW1GSzlXa0VJVlR5d3pl?=
 =?utf-8?B?SVlIWnMwWEpkSzVLWFVNaXdIK3Jua2c0U3pua2t3NGtoYjIwa2Zwem1IZEU1?=
 =?utf-8?B?SkdWUVdwVE5yUXdyazA0VDdLbUpsUktRK1VrS1dydlhuT1ZsUmNlZElrazlk?=
 =?utf-8?B?VkpyTmVaSHRTa1lkWVpqTS8wRnpzV3ZOQ2xmVlA3ZWZrc3RObzJTeENLYTN1?=
 =?utf-8?B?VnFPckowMlJxQXdTZnp3R296MGtmNVEwTmJzdnRPVWFwVkNaK2FGQ3gyOHNQ?=
 =?utf-8?B?TW96anpWVFVvZ0ZsbUJEV09XRVRpMkJldE85dlMrVkM3dUtBWTZ4dkN0Tm9K?=
 =?utf-8?B?bHdwY3NCVDVITzBaZm1OamQ1MTNWcld6TmVkcFpzVCsra3BPb2JTajErcVdM?=
 =?utf-8?B?dDVPMHVsQjkvbUY0RmpRVjRhTUpXQTBqbzJOVkxtSW5DR09LU0VqbGR3aXFJ?=
 =?utf-8?B?cSt1NkFFbnhnNm80MVBjbUMxWEMrbTVYSXdYMjlyaHF3bzd2Z0dRVXZMWStI?=
 =?utf-8?B?aENvaE9LMmZXelp5OEQvWHZibVF2TkduYTh5RGk5Z0NnTDIxQ1RKSnBqR0F0?=
 =?utf-8?B?TzBvRTFwTFNVNFZHTHFySEttUW9LY0o0UnU2YXY4ZWhleHk5dDdNZGI0eGI0?=
 =?utf-8?B?SVJYUEFXUXUrOWcxY1FoRW1kOVByOTNWQkE3WGVsakt0Q1hHcUJxUWFVZTVF?=
 =?utf-8?B?dGVPa0FMdEU0QzlRNmlNVVJJc0x0Tm4yd0pvT3FKWU16YlFGb3RoWDJ6cWpW?=
 =?utf-8?B?MFYwY0ppckNGUzdUT1pKblI0SWhSR3A4MGN3SWlKMFBra3VOMlAwVzl4a0ov?=
 =?utf-8?B?VitvcVlOMVhsQU8xbFdwdDQvRDZITk0vOWZhRzNOa1BHMEpEZy9zMGJMT2RI?=
 =?utf-8?B?ZC96SS9qRGphNHJkNW81dCtPOGE0S0RHWlN6UzlaU3NReHRXN1p5enFCUGwv?=
 =?utf-8?B?Y1JGQVZJRGFwRURKOXQ5NUN5Y1JjUFhoaW9TZ3habmZDcXZtMTNyQ0xDT0Zr?=
 =?utf-8?B?Q0JwQWVjMXc0V05va05YdHo4dXNCbWNPa0dXQyt2cW9CWVQ3SCtGdldhVDV4?=
 =?utf-8?B?V0ZoeWFVYm4xSzNIMkRoeVA4Q3QwRVlRN0Q0NnZiYTFTVS9CWWJUcEJPazdO?=
 =?utf-8?B?UW82WHJIOVZrQ0xycnRUem8xWTJzTFZjL1JvT3RWems1d2ZxaTVlT1JVODVi?=
 =?utf-8?B?TFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e2ad79-37d8-414c-d709-08dbf1a832d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2023 13:28:11.6639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xq4UEhslau6TDlPEcCXFXh5Bw+0WRJeBnUKWmCOTwlS09VdAbuVuqQUiUSZyWS+NYhD4DvsRsTjrKL7fzQDOvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6951
X-OriginatorOrg: intel.com

On 11/30/2023 1:08 AM, Edgecombe, Rick P wrote:
> On Wed, 2023-11-29 at 22:12 +0800, Yang, Weijiang wrote:
>> On 11/28/2023 10:58 PM, Edgecombe, Rick P wrote:
>>> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>>>> +       /*
>>>> +        * Set guest's __user_state_size to
>>>> fpu_user_cfg.default_size
>>>> so that
>>>> +        * existing uAPIs can still work.
>>>> +        */
>>>> +       fpu->guest_perm.__user_state_size =
>>>> fpu_user_cfg.default_size;
>>> It seems like an appropriate value, but where does this come into
>>> play
>>> exactly for guest FPUs?
>> I don't see there's special usage of this field for vCPU in VMM
>> userspace(QEMU).
>> Maybe it's mainly for AMX resulted usespace fault handling? For vCPU
>> thread,
>> it's only  referenced when AMX is enabled via __xfd_enable_feature()
>> .
>>
> In that case the "so that existing uAPIs can still work" comment seems
> misleading. Maybe "this doesn't come into play for guest FPUs, but set
> it to a reasonable value"?

Ah, I mistook it for uabi_size and added comments. Will reword it properly.
Thank you for bringing it up!



