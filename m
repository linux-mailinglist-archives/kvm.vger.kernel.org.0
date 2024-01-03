Return-Path: <kvm+bounces-5520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B99822A2A
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 10:19:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9FCB2855BE
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 09:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E3FC1B28C;
	Wed,  3 Jan 2024 09:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eZqVB67v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB30E1B277;
	Wed,  3 Jan 2024 09:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704273453; x=1735809453;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+4Mk7DOZJE0cNUU4MwJYSCPV7vGGCUR+GK+N/4R4yuY=;
  b=eZqVB67vToehA2vBMq6lmRtYBjfLL0rPRhxtnakYpjT+Ul6RCIldynsK
   eGkGZYw8tH/k2YWhgqzcWI6GFgAbWLAWRP5a8jlU2HyFJA0k3/cgvwffc
   gtmhCMECXw4UqxwOFt8UU9K6QEziIkFMyYnZkYWpp+jY2WtdK5GGdAbH2
   4Fo/xCtsjCScJ4ppijWBqrRZEvhxFuf0/krnPsxPfMohO5Ye8wKhJXNQF
   fVfqmu4S699tjQ9f65QrhOOPWomlWH8Yi74hBwm8r4c60W4p5f5Dnkgyi
   KOpbhgoB36SneZvWHMf2TCMs3SheKFqARpQDnx4tcbMHE5J5SWsSrRBsO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="463387508"
X-IronPort-AV: E=Sophos;i="6.04,327,1695711600"; 
   d="scan'208";a="463387508"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2024 01:17:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="783446941"
X-IronPort-AV: E=Sophos;i="6.04,327,1695711600"; 
   d="scan'208";a="783446941"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2024 01:17:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Jan 2024 01:17:31 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Jan 2024 01:17:31 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Jan 2024 01:17:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcApZg+znUznoNF3zaFg/CWpIL9ijwNBeLO6PMsiVQIaeRHaa/4speW1Z+yUi71eh8zqeQ355wNmqMToxtIK98jzrYw0dUtCmKcEeVSHeQD4WJe81wdvznUSOHPnZ6r0cFO17rhJEHOGClq2aH0FlpA5qW6hGFj6OeXKpq3SClu9NambNarg8lcSWwbl910i10XsUQpSs705nSLBzdvVckOWyTV9kORuv8eqKd3cL5yreoNquspmONs8Idwnx/uxIsOY7xAxFHxFAC3osW4YWkWHYTIMHv04dodvLPHWcUG1BxtiRjxeZ4aMMjqlRQR6fn8VaOUq71p+5YVqcvgU3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FohPvdHvFX04imHns9gZfDuHE0O9ZRIjgPHBZ4DwdLM=;
 b=nCKrhn2C/paaY0BKqHkN+Z1qYe2gvLtbNyVxrrs8OwQKXGFQqObvopybsI6d6HMODsQxuHsEDQ00xV05+5aWlE50SojIehU+bMSp5nYYIFPFFpvA5qFwCEwF5T6i1BQP/EmPD7ren0C/apdR1K3AD9iYKUeAa2KP7L+LhWtyU8Ra8mzEnqIa6MTTFtDOeuyAiQIoIkN3wAOWcfauvd45hG8FDXfZyXkwnPl1dBotQePMPOAsLDyH9O3ewpOWzXGi5ZHLyfoB7LOFXRRZn9NQ7TjyS0KgPJE/qHHLPuNsQS+dcWXs3I1n7V6p7qoPwQntbXewp1j1PyXfQ0MFOpAZ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB7608.namprd11.prod.outlook.com (2603:10b6:510:269::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Wed, 3 Jan
 2024 09:17:29 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7159.013; Wed, 3 Jan 2024
 09:17:29 +0000
Message-ID: <961bb6f9-1d82-44ff-b63a-d7a07e3f6bd2@intel.com>
Date: Wed, 3 Jan 2024 17:17:18 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <20231221140239.4349-6-weijiang.yang@intel.com>
 <4ba9edb3f988314637052321d339e41938dfe196.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <4ba9edb3f988314637052321d339e41938dfe196.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:194::16) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: d7e5a3a8-4fd9-4b57-250c-08dc0c3cceb7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g8RhUdrsgpn66V+C3jp0aUTFnAJ2ADp7bTyRnleZF2UewuZUwqJT0Dz8JTUAsFIT2qxCbbrJAGXfLtg6eG1KoBs8jVfcmDc3RoOsi+ZoMK4oec4ov6xpV8aCCxQ0908r7bRrEbZyNKr++ZFI8bTir93wpw/QvM4/MNqv4mobhwr6nGMtxRKbtD8X+QilT8FKCyTJ/3aPsgt//EuokL3pU076IZcbuYo/au11be1yQNhv5fHyB/W+bAUC7zFto2N00V0CzJ17zLXvcE7vo0sX1sYJmeIufB5bpXKveoZcfJCzxdUFsCulCyv7dgPfMa8e0EkZlV0nj8EpxYoroAxgD8G+CiFPawRW1HaY/aLpg1tXPsBRHBaY339kWtqHwhuZu3FBT2QxFp1UOrLF3DUE8PaFwBXqx9j8ZP7ic4dyAue0K9tMK2ptGIXiHr/wlVURSTxLwrk6EMvm16JMr/R4XexYAtHNYFn72IAcYWoFx0BKkjsiHmblH9H1kzYubbPVlLdBQLNkzfW1YH15BpZb2Ik62mzIht5l7fOuR/1Nu4TG8xfL9CCrHPkYVDml2Gg46AI8OC0TBTRWphxwxibsS15zQU+yZd5ArNfHkagHhqPTRcwabyS5PWuQc0Et4hUyi/iXmJvw5OZM7DrMvExitw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(136003)(39860400002)(376002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(26005)(4001150100001)(2616005)(82960400001)(38100700002)(8936002)(8676002)(5660300002)(316002)(2906002)(4326008)(41300700001)(6666004)(6916009)(83380400001)(6486002)(66946007)(6512007)(478600001)(66556008)(6506007)(86362001)(53546011)(66476007)(31696002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTkxTGdkZXBWWm1SUi8wS1YwaHJRSXplWmhoUUVGMW9hbmRyWmxJcHlNQWhB?=
 =?utf-8?B?ZU0rWlZ1L0NDYkF5eHNGWXdPMGZyTS9UWmtxNVpST1lpUTZ2SWhpWU9ReXM0?=
 =?utf-8?B?ajB1NHpQVVRLTzk1SUtMb2p1VmVpak01TDQ2YUlUS0hYV0dCT3RXbHNBOWFn?=
 =?utf-8?B?MVdtRVlHUVBDa2YwdWJkcUU2bzFrN0VQbFl3ZW5zZUx4alRRUUx6Z29HL2hQ?=
 =?utf-8?B?Q3RLak9yR0FXb25Ca1Rhc0FBTFRoeDhBcUMyRHlvZzhFbEhLWkpMV25EWlRi?=
 =?utf-8?B?bEsxbmtoMXJ0RDczNGM4YkxkdnVsM1VocDh1SDZETnM5Z2xITVMwTXJzUU90?=
 =?utf-8?B?YlIzRUdlT0Y4R0JvVlZhejdzUUVxa2FsRU1kZDV2ck1sUmhNQWNZdU1EUTI0?=
 =?utf-8?B?RlM4YUN1SVlPcVBydWp4alB2R3E3QXdLMVE2bzdtRHZ5NzE2M2pRS1NOWHRh?=
 =?utf-8?B?bzVxUmxUTVpRb3JsMW04bzR0NmxTZnFHdW5HVS84YU53SkFVOXFPQVpPWWU2?=
 =?utf-8?B?V2plS1cwRGxuRnNJYkhtNjNFOElEZldiU211aTNvY3pqSkVTb2lPTWkxbkNT?=
 =?utf-8?B?UExkcHFMTUE5R0dDN2FpYnFHWXZVUzJQRFZmQk1BMHZBUUtpWWFUMWRqOFZG?=
 =?utf-8?B?WWY3ZnVZR2tXNEFtN3VvUFZ3bW01am1ML1l1ZmEwZHAwSUZ1aWswSDBwbk8r?=
 =?utf-8?B?TWdNU2R2a3pBN2IyRWV0MmNLdGY1V0YzaW84MFg3Z3J1UytucGExUzdSbmVL?=
 =?utf-8?B?TExMQUtZQ2hlaytSZ0w5QzVER0orK0JxQ0pIeG9PUjdjekRlYkxyRHlWbEt6?=
 =?utf-8?B?OXBQOE9KM0JXRVVNNEpIUXk5ZEpnZUF4eWxBRlVKVXlnWDdJVkMzOWpqd3o5?=
 =?utf-8?B?alJnR2FLbDFjSlZPUFFXcVpDRGZzU1NCdjNZbGVkSGRCNEdRWU5kZkpsN0Q2?=
 =?utf-8?B?aDVLQmN3TVhKRmJLTXFsUEZmeExyUEJxcWVxVk01NFRrc29IMHBsSTcraDB1?=
 =?utf-8?B?RC9uUktiVUFzMG1rNXNkQmVjNm1OZGo0VlFDakpuSDBWQ3JPVXpZM3FQdTgw?=
 =?utf-8?B?Ulc5Qm5OUkVYTHlKbTQ5dlQ1V1VMcmZxOVdxa05BbmRBS05lU0xTM3lodEEr?=
 =?utf-8?B?cGVXbVF4MXRDWnJRQzRCSnpBVTB0U0lCcmNpRFRJTWJ6dFJjbkxIZmRWalVp?=
 =?utf-8?B?WGdhMytjajJUQmp1QVdCQjRSRTdYOWNJSkU3cmhQZDI1VkZDU1dpT2U3dGdT?=
 =?utf-8?B?OGRSREFma21lWldtNm0vallWVXR1bFVOd0JvZ0YzR3kyRkdVL3BPMmFyMXQ4?=
 =?utf-8?B?NU1YOUdjN1RWbUhCejhMbXB6NEluQ3F1K3h6TWY5ZlZvNDJ3YVNYbUxzYjBj?=
 =?utf-8?B?SVVBRG05SUxnYi9Ub1U4TlU4bXN0d24wL0liNGlNMTJyMjYvNE0vNGpJTUlW?=
 =?utf-8?B?WWV2aUZxSkF0azFNVUxHRWdVMnRQUlMwWUYrRWVNbEhKUEg5Sk93azBCdlZQ?=
 =?utf-8?B?eGZ3SEpzNmo0RU80QUdRb0l1Sms0cGNxSi9iRVBFWmhUdTVsSjN5UlhOQ0xM?=
 =?utf-8?B?NlR2V0lJQk8rL3YvL09za2xtaFIxMHpjR3JPbUg1MTBtK0RjT25MQjJOQlRQ?=
 =?utf-8?B?eE1VdERlcG16MWZ5UlFneFYzUGtmNFBkOGJtTkVyYjdWUVM2VjVzWFJpN0h1?=
 =?utf-8?B?UmdsUGRMcWJ6VHVEZDNXSHh1ampXUDlrRHZJYWk4WU9YZ0M1bExVaUUyaWRw?=
 =?utf-8?B?ZDNoQWhRbTRIK3BudFhSaG5kZTJxcnFHM25Xaml0L3NvY0VINXhweCtnRjBz?=
 =?utf-8?B?aDFJWUgzUXFlNTBHZitNNUJoWXNFTTlISXpWTk9neDZFVldFK1BOSXlDOVJU?=
 =?utf-8?B?ZGZzWCt6OWJkNThoaDFmeWZiM0RMZ0ZOVEtqWG1OVHNzZzBPZUhXY1BWTTZm?=
 =?utf-8?B?aWVOWjd5UjFqQjZLemdjUGxhVjBBWURSLy9KV2ovbGJqLzUwSDNHSGdIazFu?=
 =?utf-8?B?ZzFBeGpkVkVyU0FoeU9nN1pZRFhUYkVWTURFZncvbHBIcW9CTHFlNm41b3c0?=
 =?utf-8?B?UzBPbmJOMnRCS3g2a09Uc2dUQW4zb2ZYUjl4SEFIaXlWZUpXQmJvQ0RnS0pu?=
 =?utf-8?B?ODdMTGJyN0d6NGRzTXM0Zjd0bDNsNVJKaG5qZlJLRnRhU0VkNllCSjI4TFpP?=
 =?utf-8?B?Mmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e5a3a8-4fd9-4b57-250c-08dc0c3cceb7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2024 09:17:28.9116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZc6k/HWXNd/Epnszf6xhZjhOhY7iwoFtfLqupfeGj0EsTF7Db0xZZbnrEzRNWM7bQirX8AMRS8vBmP5sXGUBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7608
X-OriginatorOrg: intel.com

On 1/3/2024 6:32 AM, Maxim Levitsky wrote:
> On Thu, 2023-12-21 at 09:02 -0500, Yang Weijiang wrote:
>> Define new fpu_guest_cfg to hold all guest FPU settings so that it can
>> differ from generic kernel FPU settings, e.g., enabling CET supervisor
>> xstate by default for guest fpstate while it's remained disabled in
>> kernel FPU config.
>>
>> The kernel dynamic xfeatures are specifically used by guest fpstate now,
>> add the mask for guest fpstate so that guest_perm.__state_permit ==
>> (fpu_kernel_cfg.default_xfeature | XFEATURE_MASK_KERNEL_DYNAMIC). And
>> if guest fpstate is re-allocated to hold user dynamic xfeatures, the
>> resulting permissions are consumed before calculate new guest fpstate.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> ---
>>   arch/x86/include/asm/fpu/types.h |  2 +-
>>   arch/x86/kernel/fpu/core.c       | 70 ++++++++++++++++++++++++++++++--
>>   arch/x86/kernel/fpu/xstate.c     | 10 +++++
>>   3 files changed, 78 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
>> index c6fd13a17205..306825ad6bc0 100644
>> --- a/arch/x86/include/asm/fpu/types.h
>> +++ b/arch/x86/include/asm/fpu/types.h
>> @@ -602,6 +602,6 @@ struct fpu_state_config {
>>   };
>>   
>>   /* FPU state configuration information */
>> -extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
>> +extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg, fpu_guest_cfg;
>>   
>>   #endif /* _ASM_X86_FPU_H */
>> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
>> index a21a4d0ecc34..976f519721e2 100644
>> --- a/arch/x86/kernel/fpu/core.c
>> +++ b/arch/x86/kernel/fpu/core.c
>> @@ -33,10 +33,67 @@ DEFINE_STATIC_KEY_FALSE(__fpu_state_size_dynamic);
>>   DEFINE_PER_CPU(u64, xfd_state);
>>   #endif
>>   
>> -/* The FPU state configuration data for kernel and user space */
>> +/* The FPU state configuration data for kernel, user space and guest. */
>> +/*
>> + * kernel FPU config:
>> + *
>> + * all known and CPU supported user and supervisor features except
>> + *  - independent kernel features (XFEATURE_LBR)
>> + * @fpu_kernel_cfg.max_features;
>> + *
>> + * all known and CPU supported user and supervisor features except
>> + *  - dynamic kernel features (CET_S)
>> + *  - independent kernel features (XFEATURE_LBR)
>> + *  - dynamic userspace features (AMX state)
>> + * @fpu_kernel_cfg.default_features;
>> + *
>> + * size of compacted buffer with 'fpu_kernel_cfg.max_features'
>> + * @fpu_kernel_cfg.max_size;
>> + *
>> + * size of compacted buffer with 'fpu_kernel_cfg.default_features'
>> + * @fpu_kernel_cfg.default_size;
>> + */
>>   struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
>> +
>> +/*
>> + * user FPU config:
>> + *
>> + * all known and CPU supported user features
>> + * @fpu_user_cfg.max_features;
>> + *
>> + * all known and CPU supported user features except
>> + *  - dynamic userspace features (AMX state)
>> + * @fpu_user_cfg.default_features;
>> + *
>> + * size of non-compacted buffer with 'fpu_user_cfg.max_features'
>> + * @fpu_user_cfg.max_size;
>> + *
>> + * size of non-compacted buffer with 'fpu_user_cfg.default_features'
>> + * @fpu_user_cfg.default_size;
>> + */
>>   struct fpu_state_config fpu_user_cfg __ro_after_init;
>>   
>> +/*
>> + * guest FPU config:
>> + *
>> + * all known and CPU supported user and supervisor features except
>> + *  - independent  kernel features (XFEATURE_LBR)
>> + * @fpu_guest_cfg.max_features;
>> + *
>> + * all known and CPU supported user and supervisor features except
>> + *  - independent kernel features (XFEATURE_LBR)
>> + *  - dynamic userspace features (AMX state)
>> + * @fpu_guest_cfg.default_features;
>> + *
>> + * size of compacted buffer with 'fpu_guest_cfg.max_features'
>> + * @fpu_guest_cfg.max_size;
>> + *
>> + * size of compacted buffer with 'fpu_guest_cfg.default_features'
>> + * @fpu_guest_cfg.default_size;
>> + */
>
> IMHO this comment is too verbose. I didn't intend it to be copied verbatim,
> to the kernel, but rather to explain the meaning of the fpu context fields
> to both of us (I also keep on forgetting what each combination means...).
>
> At least this comment should not include examples because xfeatures
> are subject to change.

Yeah, I cannot find a better place to put these annotations, but feel putting them here
is not too bad :-). How about putting them in commit log?

the examples inlined are just to make it clearer for audiences how the fields are used, surely
will remove them later.


