Return-Path: <kvm+bounces-3073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7DF98005CA
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 09:36:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B9ABB212E5
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 08:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BABA11C699;
	Fri,  1 Dec 2023 08:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uje+JAoo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7121734;
	Fri,  1 Dec 2023 00:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701419805; x=1732955805;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MCgYLcYgkOax5YtbmCdjJgLnyCnJeNlAADAWrK5xm/U=;
  b=Uje+JAooEq8wykulTUBsiK5S6YS81tbpwEnpSO02rd5exuGH/rZfsYv1
   XjanPqwPxUQJkqp4rLa5e5xGPCeiPpsHFI62BKSpoS2l5RpjCd23jzcco
   rboAmKnBbHfS0mIoYVBG19g1/OM/hxpMSAFXnBZYuJjT04XyZvtW5Jey1
   PSh7bE6yD2eGLgXLc0Yd0cJtESLeoCKgYaxfboClGVXC/rsbdRtl+Z2IW
   wFkXCjwJmRJO3GJRb+LWDyFp5Pc8VJ2CqBvjEqLFgY3mVuGvk/9U6kH0B
   kSmuOkEj7wbwgseGy2jCz5npUSBmTOqROa3Qlgz8kXNVMbH/k9LvgMxIa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="383858789"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="383858789"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 00:36:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="745921780"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="745921780"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Dec 2023 00:36:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 1 Dec 2023 00:36:35 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 1 Dec 2023 00:36:35 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 1 Dec 2023 00:36:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WB3zjnz89tYSXS/ZvxnZoMelfaQqEgUSrQYzCCPf/9208mn9WJzfGBKDjidy/voawvuylWcd+0gW781Q1HrulFIJsfBKTtK+3qSvtXMKahC3Okxct9B/JHawjyHAsz+6K4jiVn4Ar291/Z9EW0xJxAo8u66NxgXy7pZsCGwrFeH+b0zdhvzWkJfALaWzIRQ5h/AjOjs6oiptGoTtReKIu+AVOIYB+D/v6+i+gFMTBS2/KfIcNLvxbvq78KQ2qG0GY+XoL5QBE1xU0OMfTthgCgwU5dWMDnLRPvKInACumrjS/3uKlkSOcfooTQjaPep3Rx4CU7iy/mpOE4/KbgvdTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FimKDzaa/dqn+BsDlHORWANuL00hza7iwFGj4qIxFtI=;
 b=K4OLg90agjCPOAr6Gg9aMl1iNSteL5fMBkJso0CLUaE6/VUVKpxPlUT7BTBZIOPpUsdV4VzJ4is/mgngO09IHDN8gpbD4Cw+xtOGt4O+O4VddPRVCraU0in6oQu7rbaSNwhHcPpAxWVxunzzKUTylKdVumIjLj6OeHo6Ul/1ZGV4k6Lmdab7h7ZhpGb3XNYozQUOZLkqE9/7oMwTPPS1TlxAzkq31bv0UsinSMSufCTFM5J1fB8hss1vdC5fvbnpwSh6zlpOCxd6uTg3KPOMpcDiEtegH26F3e6faxCRLySPA9Z3QH0RjyRD8cCCNct+Ar7h13r/dDQn9//pPkASww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS7PR11MB7907.namprd11.prod.outlook.com (2603:10b6:8:db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.27; Fri, 1 Dec
 2023 08:36:33 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 08:36:33 +0000
Message-ID: <0112b446-ee7e-4b78-b3a4-671d3ba67299@intel.com>
Date: Fri, 1 Dec 2023 16:36:23 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/26] x86/fpu/xstate: Create guest fpstate with guest
 specific config
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-7-weijiang.yang@intel.com>
 <e1469c732e179dfd7870d0f4ba69f791af0b5d57.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <e1469c732e179dfd7870d0f4ba69f791af0b5d57.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGXP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::31)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS7PR11MB7907:EE_
X-MS-Office365-Filtering-Correlation-Id: 11b98808-49c5-4894-b95c-08dbf2489f69
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pIW9PHkNpjXwPlHm2c0J5+yrpkX6nm4Yfg2ps/wiU3KAkNskM0x7/DL4hRUP8oVRp4JPoZDcPYfv4o34LSTOnR2Kjx1FZxbGbrJBS0qG/lff6wBUI9+OokB/TbrwhKqv52nnzIvN3w19IW+XLVkGfDUZqnFyDSsfXHIx0hDUhbzLj2xRY48Mxf+eJejPa7McUmKMxZ0sJeLTh9yYLNSjZoowSdukuvaBME+aeoPvmXvyfhYF/vQWQyAX8x46BfM19wlrkkWJGvQ85iLkzKvQpZ9iKIh09Ggr9uAyXec8UQ4Zgv1kBcx48rUQBfMgpEKwVSkfujIa5OnZpejXc1qqREAlCqyuot3Hja+rNMTQF6oWCYTUX6yEVNoQYCUPjEtLJEM+IiMTh+ys4MGDN7gXYXaR4mPcvF4YQJ164zypHAge20fYRMErFWUGFVtBf3Pb2q8v10l/AnR70qDVUgxVva2z0GBFnXTHQeELCn0BGPARTJv0GrTTFE71RyrSWNfeQYEnbQLUOY7zvDm3wU78CyMMYVN0lDudniqhIkabOzgEnOYzZTIqnjs+u7+QYeoSgemhNwUZyojNp81q6OcP24UwT4PEbrh3RhTz8uIgp7CTwgPOdiMNXG/jlGLmTaRJmHv0RsTSIP++tQ6eSihSMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(136003)(396003)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(2616005)(31686004)(8936002)(8676002)(86362001)(53546011)(6506007)(83380400001)(82960400001)(6512007)(4326008)(26005)(478600001)(6486002)(6666004)(66476007)(66946007)(66556008)(6916009)(316002)(2906002)(38100700002)(36756003)(41300700001)(31696002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0EvOGhOU2tEbG40OUZ0dnNRWEpyYkdlZ3Y4SFFackl0VU9ONTI0aVZvUDJp?=
 =?utf-8?B?U2ErV0Q1QnB2UWt3NEdDL1B3Q0pFMEYwUTNObVkvQXZhR3lack5LUXliTXlI?=
 =?utf-8?B?dG0rZGtLZjlnMkR2Q1JwOW13UFg1elJIa0Q5c1RPdzIyZWtFNVhxSlU0UHZj?=
 =?utf-8?B?RnNYZnJKTys5eWN2Z0dLdThLb0dleUlJcTRUcEdHRC9SWVZtemV2NnFhU3NC?=
 =?utf-8?B?Rlp4a3VJQ0Nwcmc0UmJqQlBHblhsV3JGa1NReVZrSUdCRlMxSHZrdWVnTHRy?=
 =?utf-8?B?NDVSYU96Z0llVzJNTXpJQmRQMW1DSlorMEZUY0tMSVRZWWE1UTNtalRjaTF3?=
 =?utf-8?B?S2UrYm03MUk3aVltMW82K2IycXViVjdpc1NLYXRLY3p0Zm5IdnM2bWV0SU1Y?=
 =?utf-8?B?SHllaTM2ejRUdHJQWkc5VWROUHVoaTRoalBJb3dTNnVQZTRIbG5ncGFOK2FB?=
 =?utf-8?B?d2NWMytqWWZrN2dTZC8yMzg0N3gvUjZab3loQ3hWVE9BQXV2YmFDYzZMcUl6?=
 =?utf-8?B?V3lOMEJBUUU3VkV6L0lxZG1pMkZBQ0dtR2lqOG9SK0ttVisrcUYyekswV2dl?=
 =?utf-8?B?a1hqYmQwT3BidlYyYzJDL0dINFNuMzV3ano1R3lzZDAvUjNOa21UNGJFL1lz?=
 =?utf-8?B?OW1mb3ZSeThYano0RDl4ZmdHVGwzYjhhNEw1SlROMHRtT3lidW1rVFZuMVlw?=
 =?utf-8?B?RWxheTJnckNvUG90RU9CeW9LQVBJZUVqRHFTbVRPamtTS3U5OVRJVEZlREg3?=
 =?utf-8?B?U0tHcXN1U3l5SngxY0lhMmVHblBEeWRlSWVPVGtTa2JYU2V2ZmttN0xacVZ6?=
 =?utf-8?B?K1BZdFhqcW5aYVFsdksxK01oZWpzK2hLUWNoTGpHeW9oS25nZEVCaTdDQmV0?=
 =?utf-8?B?dHZ1Y0FPYlZ2bGVQL015cFp0dkQ2NVVJSG5MdmRpc1lQeitWMms5ZnAzNFNs?=
 =?utf-8?B?MmtGdTJSQkVsMmJ1QklibFd2YTZwa0lzaUtjVGxrNWtqVEQ3SWkzSHlzMWFS?=
 =?utf-8?B?enNaYnVSU1VCdG1HNGxmMzZUb3RHWVhFWnhqcHYvOCtsUEljL09rR0tJSWQ0?=
 =?utf-8?B?bU5hMlZVejl0REsvZU9xUHhsRllzczRyY1ZFR2cvUFJOaWw3Qlp5aXNBTVNx?=
 =?utf-8?B?N1VTS242cG1HUnE2aHYrNlQwdE9SZVhxOC80UXpCRXpiTEU0dGRWMGpMTE5v?=
 =?utf-8?B?MDFBK2J2NUVoYzlneGdRV1lHU1o3bnd6cUhjbmNQMm9QcTRySnNyRjJKR2ZN?=
 =?utf-8?B?N1VJYUpGSlZqeDUrV0dxTnJOOXZ3V2hSM1RpbnNoazhkemhYRkpRYTJLM3Ba?=
 =?utf-8?B?MnZkZkZBdFFiOWNOM3BwcWZHcit2ZTBqUUFZVjEyckt0aFhVZSt2MzFCT24y?=
 =?utf-8?B?R2lFVGprTUFRaXNSbDAwcHA0azJlUSs3UEtRa0FkYmU1RDdiTDJlRXB6MlA0?=
 =?utf-8?B?TE4xMHExa1JHblVQN0VRekN5b0J5UEdQUDlnZk4rSlZSWWFPMFl0SEY4RktZ?=
 =?utf-8?B?bS9Iak9Dakdib1dUT2JnV3VQdFNWUm8ycDd4WkhGTmZmZkFvMndMS1hISHQ1?=
 =?utf-8?B?Z2IrNHZuc05McTdwU3lKcWYvR3lVYU9KNTF1dURBR3pzdEJUSVB1T0hyVmZk?=
 =?utf-8?B?SXdJa004NTRZTWVHajV6Y2JnUmlNOUJnVmhaS3M3NHlwK0RITE5WRjRPck0x?=
 =?utf-8?B?ZDQvVWtqUzZ1SUFwTXgyd2hiYm5SZmxtbkJYMjVYK3pXcUtPbTV3SnpLalYz?=
 =?utf-8?B?Vk1melBpMkgwTDBRSWlyMjlWYnEwdHRUU2Y0REtjd2dHaHU5U3MvR1B2bGMy?=
 =?utf-8?B?RC9PbUxUSUR2YzVKcUQvc2QvUG5RMUdxMzJVUVpKUlB0dVdYbnh6ZDBXUXpu?=
 =?utf-8?B?ODJ2aFhuZDN3TVpJcDNaOUwxbVl4cmNBRTRDVUlGMExsZFlEbkg3YUFyREw5?=
 =?utf-8?B?bmQrQ1ZOQ3I3RFNQVVNRc2NCd0NxR0t3YlRKS3hlRWFHMm1iL2pPVzRwSW84?=
 =?utf-8?B?UEk1b3FLTGVReUJIMzdiVGoyWlp0TzIvdFdRR0pvclErQWZUcUcwdC9aeVFJ?=
 =?utf-8?B?VVR2ZmZCTlV1SnRvOWZBcGhjMGFTSW8wbHVxc0cyZnZrdW9INVl1NWlTMGFW?=
 =?utf-8?B?MktyK1laWDFSTmFGc2xXekR3QkEyY2pzVEx4aWhTVFNPd3ltQ0orK0VmYUJK?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b98808-49c5-4894-b95c-08dbf2489f69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 08:36:33.6413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ecfrUcTKwG3DBY2b5/b0x7X3pggVVxGx+xn0lxeMeWlq5I/pK4kO5TqKCnHVVvWoY/kP7HLMmLVIOK870RIk6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7907
X-OriginatorOrg: intel.com

On 12/1/2023 1:36 AM, Maxim Levitsky wrote:

[...]

>> +	fpstate->user_size	= fpu_user_cfg.default_size;
>> +	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
> The whole thing makes my head spin like the good old CD/DVD writers used to ....
>
> So just to summarize this is what we have:
>
>
> KERNEL FPU CONFIG
>
> /*
>     all known and CPU supported user and supervisor features except
>     - "dynamic" kernel features" (CET_S)
>     - "independent" kernel features (XFEATURE_LBR)
> */
> fpu_kernel_cfg.max_features;
>
> /*
>     all known and CPU supported user and supervisor features except
>      - "dynamic" kernel features" (CET_S)
>      - "independent" kernel features (arch LBRs)
>      - "dynamic" userspace features (AMX state)
> */
> fpu_kernel_cfg.default_features;
>
>
> // size of compacted buffer with 'fpu_kernel_cfg.max_features'
> fpu_kernel_cfg.max_size;
>
>
> // size of compacted buffer with 'fpu_kernel_cfg.default_features'
> fpu_kernel_cfg.default_size;
>
>
> USER FPU CONFIG
>
> /*
>     all known and CPU supported user features
> */
> fpu_user_cfg.max_features;
>
> /*
>     all known and CPU supported user features except
>     - "dynamic" userspace features (AMX state)
> */
> fpu_user_cfg.default_features;
>
> // size of non compacted buffer with 'fpu_user_cfg.max_features'
> fpu_user_cfg.max_size;
>
> // size of non compacted buffer with 'fpu_user_cfg.default_features'
> fpu_user_cfg.default_size;
>
>
> GUEST FPU CONFIG
> /*
>     all known and CPU supported user and supervisor features except
>     - "independent" kernel features (XFEATURE_LBR)
> */
> fpu_guest_cfg.max_features;
>
> /*
>     all known and CPU supported user and supervisor features except
>      - "independent" kernel features (arch LBRs)
>      - "dynamic" userspace features (AMX state)
> */
> fpu_guest_cfg.default_features;
>
> // size of compacted buffer with 'fpu_guest_cfg.max_features'
> fpu_guest_cfg.max_size;
>
> // size of compacted buffer with 'fpu_guest_cfg.default_features'
> fpu_guest_cfg.default_size;

Good suggestion! Thanks!
how about adding them in patch 5 to make the summaries manifested?

> ---
>
>
> So in essence, guest FPU config is guest kernel fpu config and that is why
> 'fpu_user_cfg.default_size' had to be used above.
>
> How about that we have fpu_guest_kernel_config and fpu_guest_user_config instead
> to make the whole horrible thing maybe even more complicated but at least a bit more orthogonal?

I think it becomes necessary when there were more guest user/kernel xfeaures requiring
special handling like CET-S MSRs, then it looks much reasonable to split guest config into two,
but now we only have one single outstanding xfeature for guest. IMHO, existing definitions still
work with a few comments.

But I really like your ideas of making things clean and tidy :-)



