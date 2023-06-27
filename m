Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56F673F2E4
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 05:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbjF0DkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 23:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjF0Dja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 23:39:30 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721ED30F4;
        Mon, 26 Jun 2023 20:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687836780; x=1719372780;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gyA3MN2Wnkbqr3hyjC4vZEb4NYItsIADHZEN3QpdZQk=;
  b=gh+AW9xNV1xGGwXgbjUYpjM2JU7Z1ePVCy3McHelcuHKXFtCFkdwYT9W
   twNZKJmtMaTWAyg+b1Qvb17fhI6pqdoZlEceIVle9FwRFscmssxK+iS2l
   0kkx+hOqkqsnGb9/w2gkNQPeqskn1biP9FZ4E4U7J9rflgkbwl34R/huF
   ewtCZYt3GzbZeyDW1QsMbhkZt1f7Yo76JJY1c/KJ0QQFaZY9cup+afiv6
   GBeDkMnt7aNR739uIr75N0bfALuZEFDm+BpTVeHX2LpTxPsUdq4ffrByA
   XKPWFdqc2KMngItDY2BobiYQ31KqeiFvC1QXBGv7p9Azfa1ZGDdnhIwEJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="425127593"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="425127593"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 20:32:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="786420978"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="786420978"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jun 2023 20:32:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 20:32:58 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 20:32:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 20:32:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 20:32:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+ulHdyT2YJ9de7cPhlXs79i/3iz7m3T+vturH6FLv+kVQuDtqomOh/CwqYwzByAM88T34Mchb8mN9kHUs3WapQvBQ8KHRRxofDSNq3kkzVC8JvzoglBEmWdsySv+KNEWkq9SKeJs3a5Cf8p20jxIX1b4eZ5dYiGtwiUoRA10JM9ORq1ThmffHz9ntJM1wIg9wayT0q5LsLuipbOSESvh0HNbN4fuzZmAESj0eIIbJpNvE9fC5QnZBl3TfijxXZ4WHTPsAyjy9j5Ya/ix0iClBGDd1c+p2MXGwN9kp0MRXw9rQ1+ypzJXHEQLip1JwJ27OZU61yplt01+s+cqp8c7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUSeInYMb/VWuT/0OK+qCGMh2nwTRCDBs6nVj1MTbdw=;
 b=f/AYRqD5w6D/gA89bFfg+ID5TZm8cwn7tyZ3UuOWju6xwkjGTq+tDQmS+OM2LJ9ewfBWjfTpmdXOYQjgfGfHv6d2NEq7twmfUrIS/h92Leqbn1yFhqMpV5W6rk6VIvIHenvaDASi2wtIoob4r9hChlRMIcezZzwNHsX+rEebz8SaR1li9YkOI/e2PJDhs66LidLAn4R6uH4zbXq0Dy9P/bFMIaXkoJL2j2cNTlJqn7ubjf1s+1zedsHkGa1JBCFPgoJif+gsvF4Ii9ced5NgCjp6V7MymI3KKn3DAnxjqoxe/jxf6DwrE9OBGaQcyZ1tJvay+KOw8E0+SbIf+OIS4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB7944.namprd11.prod.outlook.com (2603:10b6:208:3d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Tue, 27 Jun
 2023 03:32:55 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6521.023; Tue, 27 Jun 2023
 03:32:55 +0000
Message-ID: <44d59b64-716f-fa58-67ee-d66beb9132d2@intel.com>
Date:   Tue, 27 Jun 2023 11:32:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-14-weijiang.yang@intel.com>
 <ZJYwg3Lnq3nJZgQf@google.com>
 <9b12207f-7aec-7d46-9b7a-99355bc9d38d@intel.com>
 <ZJn/4qC35eFjfqJv@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJn/4qC35eFjfqJv@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB7944:EE_
X-MS-Office365-Filtering-Correlation-Id: 20f0bdca-33eb-4dae-e198-08db76bf31ed
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hh7XHtPj0n+4P5RB2m5qXaoGnHRAyoBWQgGUOysq9qSzrjjbxXK2x5Z6qOWtTmP1ck+gTnUWdidQCghGn/IYFgkIrNeIZFwJOabceSzg0YOK6JJeK9zikD+d2ZooVl0b09MDTyP4tDB/8KV8vJQImi0tWwxHm+Fh9K7gCvCjtyjxNiOXnlZq21Cp4hLJRTNkTmuFld3B1Ad8/C2HiKsqzAt3utIPzQWI5OPo5eIP50eWNtdqOFs0G0SBky2SyTEgHNwCczm5Orj6he1S3ni6HoBBj3eCxqDrcvkeI2oaq17nwTIUCbH4EprwctipxhnNgSR7hpZVwsivyUbnUVwBqsgx0J3vQTa/65bU4cW+mHnR5/7Tdq2eOP48JdxmpYJ7dR6O2tC2xoZ/np9cbabbYIT7dtB6JHxicybELdi3BqiPpD/zJZicPd9sGsj2pGtCGoWJOZM9uFp58+a6R6Ma9YMgU7h/uf/Tifm7gFkalOZaKlXQYJB4td1V357LlnPKraUwudjcF2+oOqvLrvf/z8L2qg2uIrqhHSH5GVDxtvUIlUSoU+CAyi9PD2b67Gxci+z1vlyz7FJJd4vrxwA0CeK5E6urVWFq0isyWXQNJ38D+VXnSD6ldQdlfnS4U6L+5oShulNE1JVNoQGL0EJGFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(8676002)(66946007)(8936002)(41300700001)(66556008)(316002)(53546011)(26005)(66476007)(6506007)(186003)(6512007)(4326008)(6916009)(6486002)(2616005)(6666004)(2906002)(5660300002)(82960400001)(478600001)(38100700002)(36756003)(31696002)(86362001)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emF2ZzhMTWhqcFhYZmZhYXp1cGdoQ0FLVTBGZ2JOV0srbjBEMlZqcXdYY1Rs?=
 =?utf-8?B?bG9oWjAxcXdhTkwyMzk4NU50S2EwekoralArbjRwaWRUSWhrbS9YK2J5dHQw?=
 =?utf-8?B?MWJCN2l5bjN5akVzQTM3QmNRQnQ4WFRjMkN2STF5MGNPcFJxN3RmMjNxdmEv?=
 =?utf-8?B?cENKdzNaVmdUWWp2bGZOcy91d1ozOWh2YWRnb1oyQnkrejFmWUFLa0VEN0xs?=
 =?utf-8?B?WVNTRHJTQ2V0djZUSnVvbE9tQlZrOG9qZG9DNjdTenNxRlJYaU9MRnRzaWNQ?=
 =?utf-8?B?QVBQWGxhV2FENWhIUHkzekN4bHRRbkpvQnhaMUtNeE41R0xNTFZGM2wxaFFK?=
 =?utf-8?B?RnJ0TmRDYjVWd2l0RDNBbUY0alhCeGZVQk1NMGJ0MWx6VkorbitzNlhBckZO?=
 =?utf-8?B?Y2NPNWhJTmNaZ3VnRzdndlBod1NneUZWYkhXNnVVbzcwVEo1ZnByTmU4amNH?=
 =?utf-8?B?Zjd3Zks2TS9rUU42a21UV0VFeHUwc3VsSXpZVmhZMFJpUTlUOVFpejN6cHBl?=
 =?utf-8?B?QWVVOHdLUEVhV3Nvb0lVS0dqd0dFbjJYenU2U1I1dDJWSndhVWwwcjVpREM2?=
 =?utf-8?B?SzdhbnZYRnNFRVprS0NTWDBwZzhMTW5MNzdyWFcwRU5tQmFxNkMzMzB6emdC?=
 =?utf-8?B?aHNmVHEzRGg2VmtKa3kyV2lEVVV6d3U0UTRhVzkrMFgyRTF5bHMybDc1UzBo?=
 =?utf-8?B?Tk9YZ0tzNHljcittdEdBWTVMaDEvdmNuUW92QTZQbktaL1RSWU9WTEdzeTl6?=
 =?utf-8?B?UnI3bHBGWVdGaHlkL1lxY3BQYzVac2NQazlubjg2T0t0eW5iZUVEVFltSUU2?=
 =?utf-8?B?cy9yMHlDSittM0NZRm9ZdFg5WTNKZVVXWjh0a3NaRW13T1k3LzA0akZYQlZs?=
 =?utf-8?B?WEJNWGFDU2JsL0l6RW1KTXNteFJyMXhZcnVpOU95Yk9acVlaRjhjT0s0ZndZ?=
 =?utf-8?B?d01NY2MwMzUxa1FDNCsvbzl2WlV6TGUzUk9IRlVpY1RHNi9IVmJsRDFKS3V6?=
 =?utf-8?B?R2FlSmU5S1VWTzVyWHdPNU5CblhzdUc1a2Y5bCtTNHliN3ZIQU1UcWN3Z1h3?=
 =?utf-8?B?R3pyS1hQSjVQenFaRHB2eXVObDU2L2FYWi9kRVhzZVJUV2JqZTFjeGZBZ29j?=
 =?utf-8?B?SWF3TzJ6QTk0OTlyUkFpWDRkRUVaem1TSTd4Vk5KOXNJWGgvNUE0Z2ZzWU1C?=
 =?utf-8?B?WVc5Wlo1WkNBNDdtWWFzcGptL2hXdmo0cjUxMnZFYndFODQzSmNFZmdZL01r?=
 =?utf-8?B?WmFTV1cvRWNVQ0Y4cHdYZTBnYlZBOU9scnh2RURpOVI2U2JySWFvMkVOc0xF?=
 =?utf-8?B?Z0luZ2lMakRncHhrcHdKaDZKbitEakVNNUZnWXlndjFjMGRqSlZMSjRYNVhr?=
 =?utf-8?B?K3BpQ2U4TGRlOXA4dis0ZVNHYlVER0xTZmZJZEJnZWFGZm90UlJBMEV0VUd3?=
 =?utf-8?B?ZlZ4QXAwQkU5TDViSUJ6ZUx4bjdKb2hML2ozckp4Z2cwc0grYVRzamtSSmpP?=
 =?utf-8?B?c0dmRitPSnd0UDZ6bGZwMzQvU3k4aHkwdjNKNFBxa05ycXhsVWhlemNXKzFV?=
 =?utf-8?B?TVBzdXE1d2pweHFZUm56Z1k0WFRxRkgyTHNILzhEWW1RYmtDVzc1SmM4QXRr?=
 =?utf-8?B?VjB4RE1XZ3doNnFOV3JBMVkyZEJQQWludDc4SkxNU05kbVgyeWVzK2hwc2tW?=
 =?utf-8?B?UFBEREx0OEZlRnRjMmlHTlVuT0ozYWJscGZ3bS90MzU3VlFSSHBGRUkwQW5i?=
 =?utf-8?B?TndjU1FTdUhubGRjNGFlTnpjNXMxc1FrZGZ4Mm0vYlhRM3piNXJka0NJaDI4?=
 =?utf-8?B?VC9tVVV5UmpKTFltcVI0NWxaVEhFY25DRk1zK2lCMDhSRTYwakNCOU92V0xH?=
 =?utf-8?B?M3FDVDFmbmJuU3QyRHoyUlZFdENSV2FadDA3RGYvMWFjZDFJUVluWFVPM0tE?=
 =?utf-8?B?MDE0SUp1SHV6djBhVy9WNGpRVk9NTTA2UFkzdHNjd1p4b1NyNFBpYlVIWnFt?=
 =?utf-8?B?SzJZci9IL3dUa1JtbEFyUmxHVmszRzVxRGdacXVCRWNZNTBOc3B6Ynk0Ykdr?=
 =?utf-8?B?Z0t5UXI3cklodWhqeG1vamdLSExCRTV2VjYrYkYxQkE3c1Q3V1FIYUlXWGF0?=
 =?utf-8?B?U3NjdHBCVkRRUUN4TVhSZzRrbGFtaXdZQ1FnQWRSMXcyb09ycmZLbmVKUWdR?=
 =?utf-8?B?ZXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f0bdca-33eb-4dae-e198-08db76bf31ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 03:32:55.4611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kIfRTlwMrnRJzai5Kg83Kgb4k8Kyg9GIWDegVwVF0M07BcjGs/RWr/CqojT+BERCfbMiS5jUuXqCWrlS7wW5Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7944
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/27/2023 5:15 AM, Sean Christopherson wrote:
> On Mon, Jun 26, 2023, Weijiang Yang wrote:
>> On 6/24/2023 7:53 AM, Sean Christopherson wrote:
>>> On Thu, May 11, 2023, Yang Weijiang wrote:
>>> Side topic, what on earth does the SDM mean by this?!?
>>>
>>>     The linear address written must be aligned to 8 bytes and bits 2:0 must be 0
>>>     (hardware requires bits 1:0 to be 0).
>>>
>>> I know Intel retroactively changed the alignment requirements, but the above
>>> is nonsensical.  If ucode prevents writing bits 2:0, who cares what hardware
>>> requires?
>> So do I ;-/
> Can you follow-up with someone to get clarification?  If writing bit 2 with '1'
> does not #GP despite the statement that it "must be aligned", then KVM shouldn't
> injected a #GP on that case.

OK, will consult someone and get back to this thread.

>
>>>> +			return 1;
>>>> +		kvm_set_xsave_msr(msr_info);
>>>> +		break;
>>>>    	case MSR_IA32_PERF_CAPABILITIES:
>>>>    		if (data && !vcpu_to_pmu(vcpu)->version)
>>>>    			return 1;
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index b6eec9143129..2e3a39c9297c 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -13630,6 +13630,26 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>>>>    }
>>>>    EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>>>> +bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>>> +{
>>>> +	if (!kvm_cet_user_supported())
>>> This feels wrong.  KVM should differentiate between SHSTK and IBT in the host.
>>> E.g. if running in a VM with SHSTK but not IBT, or vice versa, KVM should allow
>>> writes to non-existent MSRs.
>> I don't follow you, in this case, which part KVM is on behalf of? guest or
>> user space?
> Sorry, typo.  KVM *shouldn't* allow writes to non-existent MSRs.
>
>>> I.e. this looks wrong:
>>>
>>> 	/*
>>> 	 * If SHSTK and IBT are available in KVM, clear CET user bit in
>>> 	 * kvm_caps.supported_xss so that kvm_cet_user_supported() returns
>>> 	 * false when called.
>>> 	 */
>>> 	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
>>> 	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
>>> 		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_USER;
>> The comment is wrong, it should be "are not available in KVM". My intent is,ï¿½
>> if both features are not available in KVM, then clear the precondition bit so
>> that all dependent checks will fail quickly.
> Checking kvm_caps.supported_xss.CET_USER is worthless in 99% of the cases though.
> Unless I'm missing something, the only time it's useful is for CR4.CET, which
> doesn't differentiate between SHSTK and IBT.  For everything else that KVM cares
> about, at some point KVM needs to precisely check for SHSTK and IBT support
> anyways

I will tweak the patches and do precise checks based on the available 
features to guest.

>>> and by extension, all dependent code is also wrong.  IIRC, there's a virtualization
>>> hole, but I don't see any reason why KVM has to make the hole even bigger.
>> Do you mean the issue that both SHSTK and IBT share one control MSR? i.e.,
>> U_CET/S_CET?
> I mean that passing through PLx_SSP if the host has IBT but *not* SHSTK is wrong.

Understood.

>
>>>> +		return false;
>>>> +
>>>> +	if (msr->host_initiated)
>>>> +		return true;
>>>> +
>>>> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
>>>> +	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
>>>> +		return false;
>>>> +
>>>> +	if (msr->index == MSR_IA32_PL3_SSP &&
>>>> +	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
>>> I probably asked this long ago, but if I did I since forgot.  Is it really just
>>> PL3_SSP that depends on SHSTK?  I would expect all shadow stack MSRs to depend
>>> on SHSTK.
>> All PL{0,1,2,3}_SSP plus INT_SSP_TAB msr depend on SHSTK. In patch 21, I
>> added more MSRs in this helper.
> Sure, except that patch 21 never adds handling for PL{0,1,2}_SSP.  I see:
>
> 	if (!kvm_cet_user_supported() &&
> 	    !(kvm_cpu_cap_has(X86_FEATURE_IBT) ||
> 	      kvm_cpu_cap_has(X86_FEATURE_SHSTK)))
> 		return false;
>
> 	if (msr->host_initiated)
> 		return true;
>
> 	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
> 	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> 		return false;
>
> 	/* The synthetic MSR is for userspace access only. */
> 	if (msr->index == MSR_KVM_GUEST_SSP)
> 		return false;
>
> 	if (msr->index == MSR_IA32_U_CET)
> 		return true;
>
> 	if (msr->index == MSR_IA32_S_CET)
> 		return guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
> 		       kvm_cet_kernel_shstk_supported();
>
> 	if (msr->index == MSR_IA32_INT_SSP_TAB)
> 		return guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
> 		       kvm_cet_kernel_shstk_supported();
>
> 	if (msr->index == MSR_IA32_PL3_SSP &&
> 	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> 		return false;
>
> 	mask = (msr->index == MSR_IA32_PL3_SSP) ? XFEATURE_MASK_CET_USER :
> 						  XFEATURE_MASK_CET_KERNEL;
> 	return !!(kvm_caps.supported_xss & mask);
>
> Which means that KVM will allow guest accesses to PL{0,1,2}_SSP regardless of
> whether or not X86_FEATURE_SHSTK is enumerated to the guest.

Hmm, the check of X86_FEATURE_SHSTK is missing in this case.

>
> And the above is also wrong for host_initiated writes to SHSTK MSRs.  E.g. if KVM
> is running on a CPU that has IBT but not SHSTK, then userspace can write to MSRs
> that do not exist.
>
> Maybe this confusion is just a symptom of the series not providing proper
> Supervisor Shadow Stack support, but that's still a poor excuse for posting
> broken code.
>
> I suspect you tried to get too fancy.  I don't see any reason to ever care about
> kvm_caps.supported_xss beyond emulating writes to XSS itself.  Just require that
> both CET_USER and CET_KERNEL are supported in XSS to allow IBT or SHSTK, i.e. let
> X86_FEATURE_IBT and X86_FEATURE_SHSTK speak for themselves.  That way, this can
> simply be:

You're right, kvm_cet_user_supported() is overused.

Let me recap to see if I understand correctly:

1. Check both CET_USER and CET_KERNEL are supported in XSS before 
advertise SHSTK is supported

in KVM and expose it to guest, the reason is once SHSTK is exposed to 
guest, KVM should support both

modes to honor arch integrity.

2. Check CET_USER is supported before advertise IBT is supported in KVM  
and expose IBT, the reason is,

user IBT(MSR_U_CET) depends on CET_USER bit while kernel IBT(MSR_S_CET) 
doesn't.

>
> bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
> {
> 	if (is_shadow_stack_msr(...))
> 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> 			return false;
>
> 		return msr->host_initiated ||
> 		       guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> 	}
>
> 	if (!kvm_cpu_cap_has(X86_FEATURE_IBT) &&
> 	    !kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> 		return false;

Move above checks to the beginning?

>
> 	return msr->host_initiated ||
> 	       guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
> 	       guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> }
>
>>>> + * and reload the guest fpu states before read/write xsaves-managed MSRs.
>>>> + */
>>>> +static inline void kvm_get_xsave_msr(struct msr_data *msr_info)
>>>> +{
>>>> +	fpregs_lock_and_load();
>>> KVM already has helpers that do exactly this, and they have far better names for
>>> KVM: kvm_fpu_get() and kvm_fpu_put().  Can you convert kvm_fpu_get() to
>>> fpregs_lock_and_load() and use those isntead? And if the extra consistency checks
>>> in fpregs_lock_and_load() fire, we definitely want to know, as it means we probably
>>> have bugs in KVM.
>> Do you want me to do some experiments to make sure the WARN()ï¿½ in
>> fpregs_lock_and load() would be triggered or not?
> Yes, though I shouldn't have to clarify that.  The well-documented (as of now)
> expectation is that any code that someone posts is tested, unless explicitly
> stated otherwise.  I.e. you should not have to ask if you should verify the WARN
> doesn't trigger, because you should be doing that for all code you post.

Surely I will do tests based on the change.

>
>> If no WARN() trigger, then replace fpregs_lock_and_load()/fpregs_unlock()
>> with kvm_fpu_get()/
>>
>> kvm_fpu_put()?
> Yes.
