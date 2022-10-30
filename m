Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4ED6127A2
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiJ3GG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiJ3GG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:06:58 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4A7BB;
        Sat, 29 Oct 2022 23:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667110017; x=1698646017;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SKKTo8TzbznI6hgFz/zzlPZwDQTXytKsTxsuoq1WX0s=;
  b=gD9Cuaz7ZUHG7Bc0VepcTYDpt59Af0/t2nCZp/F/FARmyACVuSx7Q4fp
   Il5htbM7M1I/BeLaMNcB0dBy+WPVEqtEPcLHwOJGkbxyBCu7xRrhLZgpQ
   YEcyJxMulsoe3zWyhyk1qhB4XcxxLTZwcifdyVdqr+OvGx7TDX/XpzCYy
   i17FGIHlAyIdPSUXOeQU6vR4CU3+OwBaDLBC0I/WfQSk03WCqphT3sdHK
   3abHUMYJhaDm1pVGB+61uxGhaS/CpA+wKpQmwaxuRQ4IOF7Rqa9z14xkT
   77Z5fADEH7iyee6CqVKsqfg9d5RokWmczMzMlfwsTPWEbWqAAm+ZlzuLO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="309803031"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="309803031"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:06:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="635715884"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="635715884"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 29 Oct 2022 23:06:56 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 23:06:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 23:06:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sat, 29 Oct 2022 23:06:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sat, 29 Oct 2022 23:06:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnXe9XvvARix4p3hUhRWfIlfDkf+VXOALaF02MH405FHfD07c1MAc/jZMaWlKeLD+C6MUQI6w/3dStl3Og5tnOHjHFzkTU5zto46jSLQ6+Ebr546EszrokkyPwchmQYf2Mh4k16Bg3G3ZW1su7U+uqfKVAIhwCmLSKwgezWiOHIY2by/BhbOKRMGsCf/DV40e8RrX0UMUauEGk0inB8W24pdDar51oQFiMWXSIAZjk5775+u/vJQRCkX0S6WVpd6zAsN94CLXezLJqZpGNDAGT7j6j3ysEadW+hXWthy7G0VYkK914zSzPvWerrDP4+/jIoguRW9pxsLVz3/aCRcaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKKTo8TzbznI6hgFz/zzlPZwDQTXytKsTxsuoq1WX0s=;
 b=ZnWvHVtZCJiSVpdeZZzwH4UJZofcVYXxyEY44i69jT7lcfXEhO8rsI4aZKVMzRWs4DPJqGuIJuyOWwUncvkdrXNcop+5/o/yfLy6rc023O11PTfyme4Aw9VPq6zq+I399UvT2c/dHGSM2ZT5OIR5NubMjYBCNfnKJZ5+IhV9ILUn/V4p3FHrl6uB98gaZwOekjhO1slXrwlOdfrBmnt14dJajE8n+MZaKYUarRmQmzWLYE4c9nrr3/fnZHy+NqD0x7S91jgDCHZtr+2yYUoOEmtFx1bmYrmzGxk9+nqyR74XlICFlKhsvF8t6CdSpZd3K26WZSFkkhJYXP5GYCJLGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BL1PR11MB5319.namprd11.prod.outlook.com (2603:10b6:208:31b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Sun, 30 Oct
 2022 06:06:53 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::afad:ad49:28f6:57f5]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::afad:ad49:28f6:57f5%7]) with mapi id 15.20.5769.018; Sun, 30 Oct 2022
 06:06:53 +0000
Message-ID: <8615d3a3-6d1c-2982-7dd8-4e831ae42ce7@intel.com>
Date:   Sun, 30 Oct 2022 14:06:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 00/15] Introduce Architectural LBR for vPMU
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
 <YxDAa6sV1CUyGpoN@google.com>
 <8b484c6e-915c-a7f6-d2a7-cf80ff67b63e@intel.com>
 <c44cbee1-663e-4bc3-357d-d683c4721565@intel.com>
In-Reply-To: <c44cbee1-663e-4bc3-357d-d683c4721565@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0041.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::10)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BL1PR11MB5319:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cc38def-0452-484a-7bdb-08daba3cf0df
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TbKEnV7TD0hzG4uo/OhkupPyh10Ev7j2/SBpntAqIobPRgjDsEHtacn4nu10jTc/43GoSmzJU9hf/dxJ4S0ojowP3P/p/yeXiwwOGVMar0u/zXOlBpkZN8rsDKVdXXy4BFPvDOhi3PR05DQdDKyE5f7MWkbLh138TABD6eWXJIEnksUQeHzQHBpmZ8JapVLquLrhPxKfs68r3yzMRnon/dLk+EDZHnBR36vCz6S9QetJZ9LDMdDMTZTvXt3f4biati+9ejmTnR1zm8wuwTPzOkux/8wekscdbh2AKvw05OK9coCNtbPToiBJ41yJZT0JWNcsqgO3xnx+2ZNPsF1moT8XUcXAkngw61vBOzl2QD+dCWaIagIGbgp5zYqOdfcozw8iQ5f7fUobqQMZtkSYlfToGs8Mk54OBZvqgnFV5xkKaL1SVZZYbOL5L1c/NMJkvWpnCzKIxLLsr8usHVudUFEOayx6iho3b1ALF7tOTJhxuwiPRPrAYFC6SPilnyDg2WoE8REp6ul3pZffImBhYLJe33D5IOcsCIoy9W1LNkTdJlR4paFKWzZ6sGI1PbPAzt288sTqJFvdfMmeLhJ7OfnSCwMy9ASt+ubNbg0j/1h2+trCndcYQ5NHM8GBCBvxqgL2i2aaheh/4VOXFTIE5ocYVmAE8MmVBG3WuKndCG4Mag+lwlHj1XPDBEL8/MnXL+dlDP55TCYRf33EWmBZG04OaEmpSLxUaW4JKZChK0pn9iHCguGDHTcwD257+OJa208xF7GQrNOtzB+bv5lv/KcW/3ec8s3Ba5FXxc6Aoaw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199015)(6486002)(41300700001)(5660300002)(2906002)(38100700002)(6916009)(316002)(54906003)(4326008)(66946007)(8676002)(66556008)(8936002)(2616005)(186003)(83380400001)(66476007)(86362001)(31696002)(478600001)(6506007)(26005)(6666004)(31686004)(6512007)(53546011)(82960400001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TU5kZ1hFVWFWYzcxU0hMaVUyKzlWd0tTZ0IxVEU2b0EveWNmaWVsK21wSnBQ?=
 =?utf-8?B?dnZOVHoxTGw4dy9vaVd2MlNWbUdNSjVhMHZzdEw5UFVQdHpMNGdYbzZ4dlYz?=
 =?utf-8?B?SnhOUFBUemRqZE1KYStJQ2ZTRTRTZEJSRkpkNEFtK1dTVXM5Z3oxeXpxWEY3?=
 =?utf-8?B?dVlDWFhCNnBIL2F5RG50V0pFbE5xZ3FiYUU3SlVwNEdsZktsQ0Iwakp3SzBk?=
 =?utf-8?B?WlJLUnlhZmJmbzgwVjQyNjFSdDJIV2dMWnNXNzJpUmFYWExYZk9aUzVKeDZ0?=
 =?utf-8?B?Tyt2dzVVQlpTNEtpNnRkdG9WZlk0NXJyanRKUGgzZkZZSExHK2crT1pXQUc0?=
 =?utf-8?B?c0p4bjBkaU1IZURlcVY5RXY5bHZMUGRtZllxMEFHZ2FVdHlvK0JSMzZ2VFVo?=
 =?utf-8?B?QnE3ek1GWHRmUnVsTThpdlI1bU8xd2xuSWt6NVU2bGlpdXNyZmJOVmlYRGho?=
 =?utf-8?B?ZXdRWTdMOVNiUUxsKzBrRmVsYkdKZXBDb3locnpJK2JZWVJzWEpXeFl0TFQ0?=
 =?utf-8?B?ZFpKTDN2NTJmZSt3N1M0K0FXamR4QlpaWlJpeXNlcG5pNWdPZitkbGlEcEtR?=
 =?utf-8?B?MDEya04wbzdoUEo3S2s1VjFINHhnNmxvdmdrbFFvdDFjaitZcmNET1FBMXhK?=
 =?utf-8?B?OENhV3VyalVpbUk4MkErT1RGa1JwVzRqa2NhbXBWU25hTmpxcjcxS0prbkpt?=
 =?utf-8?B?MDVtc3BNcE1UZDFQZWxhUFRmRlJjYUhXSjVTejJkY0haaTAxWnI4RlNrYmRL?=
 =?utf-8?B?VDVOYmNkVlZ2eG1YeTlrR3BHaHZNbEUzWmtoVzcvcFcwa3F5L21iOVhWQUdx?=
 =?utf-8?B?U2pWb0l6aVZQSzkvVnRBMUtNZ09KdEpReE5PSlpIZGMrYUZJeStHYVptdC83?=
 =?utf-8?B?ZkdXV2FyYklsYXB2MU4xaVpVSnREU0Q0aUxxMTZaZDVoVVhIQ3ZreEhlVHFw?=
 =?utf-8?B?TSszN3Z1MWRiMkJUN2ptczgyMkx2aktUTi9LcnpKWEYvMTdTWXEweE1aK0pY?=
 =?utf-8?B?T2I5aE5OQTd1Z2x0bEZoSHpKS2VteWZYaHFxVnhEU2VUY3E0WWpSYWttY0Q3?=
 =?utf-8?B?UFdMVFgvVkV6VXdwUHhJR3c4S0Z3bnVabVpJMG1zK3FRQ0ZrVWZ0ODlGNUVF?=
 =?utf-8?B?QmVMSnU0R21sV0xTNXU5V2cvN21UMHVwV0tMd0U3ZmVrMUJXa2xQb0MvRGhD?=
 =?utf-8?B?b3dETnl6UE5RMzZQejBqU0s5Ym5kZ0Ira0tuYWx6QjdjSWpnL2NuYWhqakF0?=
 =?utf-8?B?VlJmTzB3d3FwVVMxUENBL2Fhc2xRMmVtSzlYdFpDQ3FyUmpQdDdxYkJucXhK?=
 =?utf-8?B?NjJoa01PWUxzZTByTVpEV2FhSjRtVGRkU1RwMmhOWkZkeVhuMDFGY2pJN28x?=
 =?utf-8?B?d1dNRmlhR1duaEdQRHRhNml2ZU8rRmY5VVI5cE1pNENkNzhRdkQ5UHFUdU9Q?=
 =?utf-8?B?SysxSlgvRjJkR2pWazRVQzZvL0NhZmVDMy82WTZHTjFQdzR4ZmFLdWt3ejdV?=
 =?utf-8?B?RHRHbXp6Y1VPT0ZkRDFpWExZM1l3U2hzTS91ZDRNV1hZNXV0am4yN2dlV2lL?=
 =?utf-8?B?SDVVNUg1YlhERjBoZmtidnlsZUs2M0xJQkJVUzZ4Z3NkVHZMdmRkRU52QS9G?=
 =?utf-8?B?S3hBOWRybi9BT2pNc3hIbUZwbnZ5K0pEQUxPQVRwT29zQTJqOHNXMkIrMzFr?=
 =?utf-8?B?aVp0QUhrbEp4MnlidkVqNnRXdEt3UUhDMGdrenpnOXZHSGhOQXQzamhOVVh1?=
 =?utf-8?B?VUwwZ0hKdzZKM2h5TWliTk9NSnRQMlZETllueWRCV3ZXY1orakhSaXViTkRl?=
 =?utf-8?B?WVBaMU1tTUJkbmsyU1VocEt4THZaR0ZReDBIYkgwcHdpbG5xNlNKb2owMEcw?=
 =?utf-8?B?M1RLajY5UXFCbDVEb3F5TWh2Y1BKYTIrSXhnVWIrdVJpcXVnY09FQ2lGTzJG?=
 =?utf-8?B?Mktvd0VzbkpYN0J3NXRSQ00rVjM2VEhqYVVMa1FzZ1F4SzNnWVF6VkZEQ3cz?=
 =?utf-8?B?b0U3dHJUZmNLZDdGNlVEa09rcDEvTDcySlk4azJ1TUxtbnRPYW9IeWFSdmpP?=
 =?utf-8?B?amVkS2dMazB0Y0ZuSXZlZlVieFVkZm5zL0pGOFJrT015dmJLdk1MS0NuTzVJ?=
 =?utf-8?B?cFFXSE9Cd2xuTjFoSnE3c1JWMUFXeHMrSW1oYVpZYklPM0lWeExaUmM3eCsw?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cc38def-0452-484a-7bdb-08daba3cf0df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 06:06:53.2859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWUktauXqvp/0n2a/pFDUsNxHjq8BEUL1lk8/RN3z9TvognxZTPpxnrLTj9bVSK55ZUe1wLyO5hIH4A6jIXo0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5319
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/21/2022 10:14 AM, Yang, Weijiang wrote:
> On 9/2/2022 11:44 AM, Yang, Weijiang wrote:
>> On 9/1/2022 10:23 PM, Sean Christopherson wrote:
>>> On Wed, Aug 31, 2022, Yang Weijiang wrote:
>>>> The old patch series was queued in KVM/queue for a while and finally
>>>> moved to below branch after Paolo's refactor. This new patch set is
>>>> built on top of Paolo's work + some fixes, it's tested on legacy
>>>> platform
[...]
>> What are fixed in this series:
>>
>> 1.  An missing of -1: if ((entry->eax & 0xff) != (1 << (depth_bit - 1)))
>>
>> 2.  Removed exit bit check in  cpu_has_vmx_arch_lbr(void), moved it to
>> setup_vmcs_config().
>>
>> 3.  A redundant check kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) in
>> kvm_check_cpuid().
>>
>> 4.  KUT/selftest failures due to lack of MSR_ARCH_LBR_CTL and
>> MSR_ARCH_LBR_DEPTH in kvm_set_msr_common() before validate pmu msrs.
>>
>> 5.  Calltrace in L1 when L1 tried to vmcs_write64(GUEST_IA32_LBR_CTL,
>> 0) in vmx_vcpu_reset(), use cpu_has_vmx_arch_lbr() instead.
>>
>> 6.  Removed VM_ENTRY_LOAD_IA32_LBR_CTL and VM_EXIT_CLEAR_IA32_LBR_CTL
>> from exec_control in nested case.
>>
> Hi, Sean,
>
> Could you kindly review this post and give some comments on the series
> so that I can prepare next version?
>
> Thanks!

Ping...

In case you missed previous email...


>
