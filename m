Return-Path: <kvm+bounces-1647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC2CA7EACBD
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 10:14:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FB5328114D
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 09:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB5F168A4;
	Tue, 14 Nov 2023 09:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ig+WtzH/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0798D2E8
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 09:13:50 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9E7F5;
	Tue, 14 Nov 2023 01:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699953228; x=1731489228;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r9z4xpBcUybEg7IeumYIaveCktYbbjVhL+nVVJxrvJI=;
  b=Ig+WtzH/5kwtst9rjXE7Kz7faawuhTYo8kz2R2h9ycUU/F89bhl3w5BH
   QXIUTvTF96iNeoGTx/ourLmn6NEtNtVWNgHRGVNJ81oKeiu6IWNvcenZx
   MAvPqgkRE+ZbvbqOL1wafRCNzdqHAmIDqhK94b2RFMcuevNfgA8lJTtJ1
   lJ4wwdgGj5Mdkg4jacK7H11VCAFmbvhrKZM8l9JPm1KbJ8ld/pmSDCzzS
   M+WTJaRtJ4sJvuOO4U7E1PTeNEbHz3oMJaf3JWG6/kOpw5ZTx0bnqHDh4
   I/k49phrbTh2NKKM258QKlk95sQ5PB8LEzLc85WDfvBgfLiDXhmSQYOcz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="394532371"
X-IronPort-AV: E=Sophos;i="6.03,301,1694761200"; 
   d="scan'208";a="394532371"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 01:13:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="881991163"
X-IronPort-AV: E=Sophos;i="6.03,301,1694761200"; 
   d="scan'208";a="881991163"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Nov 2023 01:13:46 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 14 Nov 2023 01:13:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 14 Nov 2023 01:13:45 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 14 Nov 2023 01:13:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0/AO3yFbrkuqbgcKwgkyJNX1o319sPrGG5E7CFdXFDJkL5qF32lx9kyU32EXF+g55koRVJm3ZpwwBOBYymczLO5LCE0U7ZBxH+DpuzELNkWIG/jo6CGDzoK/jXCkSdcL/GsudrKv8n6ITjaGez5d4lZGH9sQbRdgk7iHl4OmB776pDleFRmT1vd6KLOYO5jNyM7h2c7NZgAKiZdig0Jymcd/U+joZndrRhwMPhrlSdcXrB1g8Qd3gDDS4TLfHgUukRjWAJpmHwAnda4ApSeC7D5gOgkBZFMDx9BPEi/zOrrn4bCIReUCo6zjhKKNW0YvNHbFkN+aWRv2Yk8/lhPWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TxTEUnetpaxsGlMbCpIG1IiBEdOT9yqXdQFARDckq+I=;
 b=P7hUPew+aoXkMuH+qYTOVEvHY2zbTbn5/+bXW+inKtnD0ymARQ45/7G2FPGbVV0m/ToJOau8lFjpFoNkU2lPN6xWySEH4Q1e3k3vPYcgpl4LSX05b44p8ffYkMf+xSgzJLxn6WP0mDhZsriSmuiZvumCkZaR23bvu55J9vKT6N8okUR2AAhQGZwTphbxLcYl48P/UC05/fiqIV5qxwbtt2fGTGDMvWewyMbrErXAqg/HGBYOndv/WNYnoYPehVE2i9NNrr5lPVynYOb6wdk7pFwMeTFL1lAz7HUwKrw5LvnAT6FYvs6RBUMv/nRL6iN8n9jfO9/yPLcd+ACvU1BXAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM8PR11MB5703.namprd11.prod.outlook.com (2603:10b6:8:22::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6977.31; Tue, 14 Nov 2023 09:13:40 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7002.015; Tue, 14 Nov 2023
 09:13:40 +0000
Message-ID: <35525556-0681-453e-9528-b3a5314d1860@intel.com>
Date: Tue, 14 Nov 2023 17:13:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits when
 calculate guest xstate size
To: Maxim Levitsky <mlevitsk@redhat.com>, Sean Christopherson
	<seanjc@google.com>
CC: Dave Hansen <dave.hansen@intel.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-7-weijiang.yang@intel.com>
 <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
 <1347cf03-4598-f923-74e4-a3d193d9d2e9@intel.com>
 <ZTf5wPKXuHBQk0AN@google.com>
 <de1b148c-45c6-6517-0926-53d1aad8978e@intel.com>
 <ZTqgzZl-reO1m01I@google.com>
 <d6eb8a9dc5b0e4b83e1944d7e0bb8ee2cb9cc111.camel@redhat.com>
 <ZUJdohf6wLE5LrCN@google.com>
 <f4e2d8c79ca3f238aafd61a82a3f5ad5c2d6bcab.camel@redhat.com>
 <ZUUEnXcqgY7O0jp7@google.com>
 <a7c23f74187b5042814341ce5d2e749408d24650.camel@redhat.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <a7c23f74187b5042814341ce5d2e749408d24650.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGBP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::17)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM8PR11MB5703:EE_
X-MS-Office365-Filtering-Correlation-Id: 8817a7fb-41c5-474a-e994-08dbe4f1fd9c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lchXYXbAK+Mno30q7EK81iW5oxZlaWsSgK+OWQ/Ff+bueJQ+jBgnWZFa8xIxj31lULN/WpEp3RZv8DdPyJKdcRROZQ5dUac3kxP4Ma2YzsOztPCy7sxXHX/mQ9lnBvB+n8odPptX2DJPLiRZ/ZTUEz37oVefNbu4IB0C+dNw6LOGUJ00fewCdHTU/iBT0lU71hQkS2JcbLqSXl59Bqfz1ElzkxQMO7BB8nS1aPooswmNsSoSg4ROSokHFfIrYvprvbQHiDPgAFKw1myPYXJ+uyOen1WEHairwcaarm+ss3QUALRAElAh34aS5uOyoGw4t0xU5CfUWTgDm/rYnCItwmkci71Q2pUA3pG6e4s2+YxcCoN+ZNiOCW5dwZUWjr9E8jyC2Dg1r4oT7fC8eQZAqCUUMalpFNqxFmIxSQKSnLJbL08GYqDpS7RUcOQCQ//9bpz8x9PtupZMIg5Xnsd6fh2lsPtvdCPfrdNDnqdI9whVtOHF/nExnPsQoL28vPBOApAVnB5jDjxlBrt6xkxKQq8EmZM5VenkDG9bKsf1373oBYmeK2Ylexa3JOlEaWgKjk5WjCLoEbUpn29QAQiBij/pXxebMeLBbBXev5t89Sx/U22qa2EpKlH8LrmjzhXnz+3/cYlPOyCUQ6PEgDIhMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(346002)(136003)(366004)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(2906002)(4001150100001)(5660300002)(41300700001)(82960400001)(38100700002)(66476007)(478600001)(66946007)(31696002)(86362001)(36756003)(316002)(110136005)(2616005)(6512007)(26005)(6506007)(6666004)(53546011)(6486002)(83380400001)(4326008)(66556008)(8676002)(8936002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzlJTGNSdWRydGFiZjd6SHQyWTJpNnhSU2FXWWpMUFYycElVNVVjanhUQjZw?=
 =?utf-8?B?akRFV2ZzbUsxOHlOUjNRYXYxdHFveUwvdVk2TnJjTjFTWk5OUFJtVHp4ckZS?=
 =?utf-8?B?VFdDQmxISUNQazFrN0pZMEk3Wmh4NG9aRHBVbUw0dmhEV1lNZ3RWVjYxQ0pp?=
 =?utf-8?B?VWd3aUV4cVFMZHZrTFlIVVJBRmwrUnQ2VisrTm40QlFqM1AxNk5Ra0xlR0JR?=
 =?utf-8?B?cnFpVVBjNHdaY0t5SEtRbFB2NUc4TzRlOUpsV2h6Ym14VEdpeXZ6Z2ROdDlk?=
 =?utf-8?B?elJuZmtHS3J1MVZ6WFl1YnVETEJtcEpKc0VaNTdJWlIxL1FSVG9mSFNxSUpl?=
 =?utf-8?B?WXNZN0RBRldNZGJmVnpYQlRjc1VwcldBYklrREpINUg0dGsvaWk3bmZYZVhN?=
 =?utf-8?B?ajZVNkZRbi9ob3RjVlFhOUFLLzhhUlRLVnFRYzYzZWFnczEwOHRwUGt4Rm51?=
 =?utf-8?B?aUk4Zko1aXRSTmUydURZN2c1aHhTTXRnRG9pZ3R5TXltK0FSUWEraFpxbFlC?=
 =?utf-8?B?cVZFRktqUlhjbHdCZlA0cDRkL2w1c3I3N2JjSFNmS3RlUEZoOGliTE1McG5B?=
 =?utf-8?B?SlByc1BROSt5R3NVQXhWcTFkT0ZneUU0Z0tYVlk2Y1gxSi9tTEFWQ3VYdUFu?=
 =?utf-8?B?M2ZqczNUM3Jtb1Rqc1l0VG12RG9Od2VJRVN5b290UmwxK01GWDJBbHNZc0xy?=
 =?utf-8?B?S3A0c0dON3IvSlV5ZW9CbW5NNUN3U0wxSi82Z3NEenlQc2xPb1FJY2s5b0Jm?=
 =?utf-8?B?dGRzRWo5Tk1MS21qYkpqMFFmdHdrd2ZGVXZnem9GNkV6SVRzUjBFT1l3N1ZE?=
 =?utf-8?B?emlzbEpEeWVpSmE2bkhSZUh5cXplVnh3ZmZLcUxYNmdWVU1TUGlUMjlnQlRq?=
 =?utf-8?B?d3pZaUVaSWFnTXlQZDdHMXV4TDRLWXpDZWRPbFI3amVldmpOajFKYktkWWgv?=
 =?utf-8?B?NFI3VVg2WDcwbVNtU2Ywb1lGWlVrUWc4V1VXL1JOZWhOazVtbmV6T2ErNGZx?=
 =?utf-8?B?b3NLSjQ1K0tyTU1YOW9MN0FxVm01S2Y2ek43NmZjSVZqSkhodHhpZW1nbFlq?=
 =?utf-8?B?NzFGQ1QwMC91dGZPU0lCdDhPS1pzWmtyTzVqV0JodWh3WmUwZkw3Yk1MR3E3?=
 =?utf-8?B?Si9lcXJ1bE1ocGNXV2x1dlZ6SnNhNnRQTGdsbyt2Uk1sdnJtRzZ6SkFYNUVB?=
 =?utf-8?B?NzJNZHorVktIcHR6RGQ3Vk5SdmdzZTl2OFVRdUlObGRCMjNicVJ3RzY1SUwy?=
 =?utf-8?B?cWt5R29iR2VaaWV6NWRBNUg4bVZUajRmYzczb0ZMajNCN2pwcjh4ZElJaDRN?=
 =?utf-8?B?YUROWEtneGowVTBUQUdpU2YzdE5VdS9iQndoTXhleE1LTUJWcnAzZFl1MDlB?=
 =?utf-8?B?ZGNONTd3Qnl3OEYxMXI4R0Zpd3NERUNWRW8yWTBHb2RuRlZEeDFTWnRoTmVX?=
 =?utf-8?B?UHpyOXpDSU5GUmdRZFBiaW9Jem1KUjIzVVk3bE9oLzQrdTNkMElsd2Q4OWNO?=
 =?utf-8?B?YmdJNkNPc1NqRkgrcHU1d0lGNXRJdFd2YmJOa2xKMUVjZnZpdW1TZkxiVSs3?=
 =?utf-8?B?bXpxRFJuOWhZa3pmSFRFNXZ6VmZXUWlmWHorZHQrbVNpcTBCT0d5VW4xSUR2?=
 =?utf-8?B?Wk1EMnBIL3JhcmNJa1ZIQWRDMldqcDZkVDBZd0kzL0ZwVnltSXJhakFPUUdQ?=
 =?utf-8?B?TE9KQUhHd1ZvLzc1Y1RjZVZyUE1SSzJxOC9mc3lMMmNZWGlIUC9BbFQ4YjJN?=
 =?utf-8?B?ZXJ4Z0gwblZ5dy9Jd05zMm0rMG1HVTQ3dG55ZS8zZStMNjA5UFBHaVFwQjND?=
 =?utf-8?B?ekx1cWdXS3pKNUNuSlV5MXVGR2daRkpYV1lMSll5MlFJS2JUc1kweE1ZUGNW?=
 =?utf-8?B?ZDJPRlJBOVVJTFh6dkVRU3NPaVJmNlU0alRjMjNVVkFndnFXVDlFc0VhbW54?=
 =?utf-8?B?S3YvT2dlSUZSVTE4Zm9hM21Obi84bXhPaHBmMGs4UFpkMDgwOU5IcUlyZGtU?=
 =?utf-8?B?MUpYRzE3enRDT3dmQkhLRE40VGFVcjY4c3ZaajNXTDY0Y2RKWERmY3JmaldW?=
 =?utf-8?B?Z2dyTjlsWVkyeFcrdnBWb2ZiNmRUWGt0UXJzdE1iaXhLZFNMRTdWclJJSGll?=
 =?utf-8?B?TjU3NC9JTTNwOFBIdUhVM0lZR3h0ak9wR0hKaTlYeUlhamRQZm45dmZzMkg3?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8817a7fb-41c5-474a-e994-08dbe4f1fd9c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 09:13:40.0326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Suw+6musJB0k0u5V15EdgvTsWX57PY0FeaVLvlx7/9HNug8MTKN9/j2t9xjbLQZ3x/R9JAS3PAQ7nSc1kleqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5703
X-OriginatorOrg: intel.com

On 11/8/2023 2:04 AM, Maxim Levitsky wrote:
> On Fri, 2023-11-03 at 07:33 -0700, Sean Christopherson wrote:
>> On Thu, Nov 02, 2023, Maxim Levitsky wrote:
>>> On Wed, 2023-11-01 at 07:16 -0700, Sean Christopherson wrote:
>>>> On Tue, Oct 31, 2023, Maxim Levitsky wrote:
>>>>> On Thu, 2023-10-26 at 10:24 -0700, Sean Christopherson wrote:
>>>>>> --
>>>>>> From: Sean Christopherson <seanjc@google.com>
>>>>>> Date: Thu, 26 Oct 2023 10:17:33 -0700
>>>>>> Subject: [PATCH] x86/fpu/xstate: Always preserve non-user xfeatures/flags in
>>>>>>   __state_perm
>>>>>>
>>>>>> Fixes: 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE permissions")
>>>>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>>>>> ---
>>>>>>   arch/x86/kernel/fpu/xstate.c | 18 +++++++++++-------
>>>>>>   1 file changed, 11 insertions(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>>>>>> index ef6906107c54..73f6bc00d178 100644
>>>>>> --- a/arch/x86/kernel/fpu/xstate.c
>>>>>> +++ b/arch/x86/kernel/fpu/xstate.c
>>>>>> @@ -1601,16 +1601,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
>>>>>>   	if ((permitted & requested) == requested)
>>>>>>   		return 0;
>>>>>>   
>>>>>> -	/* Calculate the resulting kernel state size */
>>>>>> +	/*
>>>>>> +	 * Calculate the resulting kernel state size.  Note, @permitted also
>>>>>> +	 * contains supervisor xfeatures even though supervisor are always
>>>>>> +	 * permitted for kernel and guest FPUs, and never permitted for user
>>>>>> +	 * FPUs.
>>>>>> +	 */
>>>>>>   	mask = permitted | requested;
>>>>>> -	/* Take supervisor states into account on the host */
>>>>>> -	if (!guest)
>>>>>> -		mask |= xfeatures_mask_supervisor();
>>>>>>   	ksize = xstate_calculate_size(mask, compacted);
>>>>> This might not work with kernel dynamic features, because
>>>>> xfeatures_mask_supervisor() will return all supported supervisor features.
>>>> I don't understand what you mean by "This".
>>>> Somewhat of a side topic, I feel very strongly that we should use "guest only"
>>>> terminology instead of "dynamic".  There is nothing dynamic about whether or not
>>>> XFEATURE_CET_KERNEL is allowed; there's not even a real "decision" beyond checking
>>>> wheter or not CET is supported.
>>>>> Therefore at least until we have an actual kernel dynamic feature (a feature
>>>>> used by the host kernel and not KVM, and which has to be dynamic like AMX),
>>>>> I suggest that KVM stops using the permission API completely for the guest
>>>>> FPU state, and just gives all the features it wants to enable right to
>>>> By "it", I assume you mean userspace?
>>>>
>>>>> __fpu_alloc_init_guest_fpstate() (Guest FPU permission API IMHO should be
>>>>> deprecated and ignored)
>>>> KVM allocates guest FPU state during KVM_CREATE_VCPU, so not using prctl() would
>>>> either require KVM to defer allocating guest FPU state until KVM_SET_CPUID{,2},
>>>> or would require a VM-scoped KVM ioctl() to let userspace opt-in to
>>>>
>>>> Allocating guest FPU state during KVM_SET_CPUID{,2} would get messy,
>>>> as KVM allows
>>>> multiple calls to KVM_SET_CPUID{,2} so long as the vCPU hasn't done KVM_RUN.  E.g.
>>>> KVM would need to support actually resizing guest FPU state, which would be extra
>>>> complexity without any meaningful benefit.
>>> OK, I understand you now. What you claim is that it is legal to do this:
>>>
>>> - KVM_SET_XSAVE
>>> - KVM_SET_CPUID (with AMX enabled)
>>>
>>> KVM_SET_CPUID will have to resize the xstate which is already valid.
>> I was actually talking about
>>
>>    KVM_SET_CPUID2 (with dynamic user feature #1)
>>    KVM_SET_CPUID2 (with dynamic user feature #2)
>>
>> The second call through __xstate_request_perm() will be done with only user
>> xfeatures in @permitted and so the kernel will compute the wrong ksize.
>>
>>> Your patch to fix the __xstate_request_perm() does seem to be correct in a
>>> sense that it will preserve the kernel fpu components in the fpu permissions.
>>>
>>> However note that kernel fpu permissions come from
>>> 'fpu_kernel_cfg.default_features' which don't include the dynamic kernel
>>> xfeatures (added a few patches before this one).
>> CET_KERNEL isn't dynamic!  It's guest-only.  There are no runtime decisions as to
>> whether or not CET_KERNEL is allowed.  All guest FPU get CET_KERNEL, no kernel FPUs
>> get CET_KERNEL.
>>
>> That matters because I am also proposing that we add a dedicated, defined-at-boot
>> fpu_guest_cfg instead of bolting on a "dynamic", which is what I meant by this:
> Seems fair.
>
>>   : Or even better if it doesn't cause weirdness elsewhere, a dedicated
>>   : fpu_guest_cfg.  For me at least, a fpu_guest_cfg would make it easier to
>>   : understand what all is going on.
> This is a very good idea.
>
>> That way, initialization of permissions is simply
>>
>> 	fpu->guest_perm = fpu_guest_cfg.default_features;
>>
>> and there's no need to differentiate between guest and kernel FPUs when reallocating
>> for dynamic user xfeatures because guest_perm.__state_perm already holds the correct
>> data.
>>
>>> Therefore an attempt to resize the xstate to include a kernel dynamic feature by
>>> __xfd_enable_feature will fail.
>>>
>>> If kvm on the other hand includes all the kernel dynamic features in the
>>> initial allocation of FPU state (not optimal but possible),
>> This is what I am suggesting.
> This is a valid solution.

Sorry for delayed response!!

I favor adding new fpu_guest_cfg to make things clearer.
Maybe you're talking about some patch like below: (not tested)

 From 19c77aad196efe7eab4a10c5882166453de287b9 Mon Sep 17 00:00:00 2001
From: Yang Weijiang <weijiang.yang@intel.com>
Date: Fri, 22 Sep 2023 00:37:20 -0400
Subject: [PATCH] x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU
  configuration

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
  arch/x86/include/asm/fpu/types.h |  2 +-
  arch/x86/kernel/fpu/core.c       | 14 +++++++++++---
  arch/x86/kernel/fpu/xstate.c     |  9 +++++++++
  3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index c6fd13a17205..306825ad6bc0 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -602,6 +602,6 @@ struct fpu_state_config {
  };

  /* FPU state configuration information */
-extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
+extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg, fpu_guest_cfg;

  #endif /* _ASM_X86_FPU_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index a86d37052a64..c70dad9894f0 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -33,9 +33,10 @@ DEFINE_STATIC_KEY_FALSE(__fpu_state_size_dynamic);
  DEFINE_PER_CPU(u64, xfd_state);
  #endif
-/* The FPU state configuration data for kernel and user space */
+/* The FPU state configuration data for kernel, user space and guest. */
  struct fpu_state_config        fpu_kernel_cfg __ro_after_init;
  struct fpu_state_config fpu_user_cfg __ro_after_init;
+struct fpu_state_config fpu_guest_cfg __ro_after_init;

  /*
   * Represents the initial FPU state. It's mostly (but not completely) zeroes,
@@ -535,8 +536,15 @@ void fpstate_reset(struct fpu *fpu)
         fpu->perm.__state_perm          = fpu_kernel_cfg.default_features;
         fpu->perm.__state_size          = fpu_kernel_cfg.default_size;
         fpu->perm.__user_state_size     = fpu_user_cfg.default_size;
-       /* Same defaults for guests */
-       fpu->guest_perm = fpu->perm;
+
+       /* Guest permission settings */
+       fpu->guest_perm.__state_perm    = fpu_guest_cfg.default_features;
+       fpu->guest_perm.__state_size    = fpu_guest_cfg.default_size;
+       /*
+        * Set guest's __user_state_size to fpu_user_cfg.default_size so that
+        * existing uAPIs can still work.
+        */
+       fpu->guest_perm.__user_state_size = fpu_user_cfg.default_size;
  }

  static inline void fpu_inherit_perms(struct fpu *dst_fpu)
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 1b7bc03968c5..bebabace628b 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -681,6 +681,7 @@ static int __init init_xstate_size(void)
  {
         /* Recompute the context size for enabled features: */
         unsigned int user_size, kernel_size, kernel_default_size;
+       unsigned int guest_default_size;
         bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);

         /* Uncompacted user space size */
@@ -702,13 +703,18 @@ static int __init init_xstate_size(void)
         kernel_default_size =
xstate_calculate_size(fpu_kernel_cfg.default_features, compacted);

+       guest_default_size =
+ xstate_calculate_size(fpu_guest_cfg.default_features, compacted);
+
         if (!paranoid_xstate_size_valid(kernel_size))
                 return -EINVAL;

         fpu_kernel_cfg.max_size = kernel_size;
         fpu_user_cfg.max_size = user_size;
+       fpu_guest_cfg.max_size = kernel_size;

         fpu_kernel_cfg.default_size = kernel_default_size;
+       fpu_guest_cfg.default_size = guest_default_size;
         fpu_user_cfg.default_size =
                 xstate_calculate_size(fpu_user_cfg.default_features, false);

@@ -829,6 +835,9 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
         fpu_user_cfg.default_features = fpu_user_cfg.max_features;
         fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;

+       fpu_guest_cfg.max_features = fpu_kernel_cfg.max_features;
+       fpu_guest_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+
         /* Store it for paranoia check at the end */
         xfeatures = fpu_kernel_cfg.max_features;

--
2.27.0

[...]

