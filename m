Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DF4688E0E
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 04:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbjBCDhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 22:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjBCDhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 22:37:45 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271629020;
        Thu,  2 Feb 2023 19:37:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUKiyaDbcjrRig7e2WlgTrsZpH9sMZimAwUm0PJIl8EY2fLorfUbojTkzmYLp8ztXC1JntXVM0lNVrBvhLF+QuKw+WmRQLLyimDjORmrpKKonGwWdmDupAQEYcPrMRMhOe/5BzxSCYeenh8DnCjIzMtntyZMQLfUnf4Hu2byM1RViR9vt3OkCPbfuGzS1m2A3DtdPBz91YtBWBLa4tgBEqV+pkTcKYF4PcJW/bOUXtPRRZ5N9skcj6eMzMWYi0QsEc1I6/d0IY8Xb0Aydtita/2TTjMWBFBJXX/Uax3FyelfxeXbPN5dgiv+Dp+Jk/oEZeH+wNq1SoIsYP+Wl3+lUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AoYwmzuX6oGm4Sg9I1bPlIkk6Hadh6Lqf4AC9+U+sWA=;
 b=Mt6fv6qt2g2uHR9wNuWgkA6U26GOV3d9b0bGV+fStBbj9GvBKn/Gma2Eie2sN83NIyk/uhXL4Y+oBPUstEhe6Ht2h/RsIFnATTD8W6RIkC2bj0VqhqXWME9E32UjxrT4T/WXq+CeWNndqrfb/9yNRjYAfj7uIyO8jm2Jr0389aBb7uiFVT70zkbyFnJOAYoDQSuOhT4iN/kiSj1Nwdqsz5wJh6cpuT+93IJuGHq1Ea1sgkAnHfJiQOMWTJe6ki4NqtkrSBpl7DiutN1dARY3BJMUNFvqxhpWVp6ZfFzVNARJF32yJqabTSyjkDQqaeT3uvyUT3HA6vhUs0dPnfecCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AoYwmzuX6oGm4Sg9I1bPlIkk6Hadh6Lqf4AC9+U+sWA=;
 b=Gg93z93nBUm4PP4T/qSf5Nmp/CnptyGkhkvGSJiZgcWTgATYQ7nfndJudvvxSJ1k9zCsDdossPgWXcth0nOoZBXc0oIxYH9tJzdE4UNlbcfbfgO5X3vpmIORmoGfkXWqgQovs8xp87R/6ty0zZbw1bQ0RN5qaHTw2EbUEFvo2UU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 IA0PR12MB7578.namprd12.prod.outlook.com (2603:10b6:208:43d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Fri, 3 Feb
 2023 03:37:41 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%2]) with mapi id 15.20.6064.029; Fri, 3 Feb 2023
 03:37:41 +0000
Message-ID: <3b3a9ebc-b02e-a365-7f68-3da9189d062a@amd.com>
Date:   Fri, 3 Feb 2023 14:37:28 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Alexey Kardashevskiy <aik@amd.com>
Subject: Re: [PATCH kernel v3 2/3] KVM: SEV: Enable data breakpoints in SEV-ES
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20230120031047.628097-1-aik@amd.com>
 <20230120031047.628097-3-aik@amd.com> <Y9nL8iqhiL5+ALa2@google.com>
Content-Language: en-US
In-Reply-To: <Y9nL8iqhiL5+ALa2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5PR01CA0017.ausprd01.prod.outlook.com
 (2603:10c6:10:1f9::13) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|IA0PR12MB7578:EE_
X-MS-Office365-Filtering-Correlation-Id: d2fd4f4b-7a39-444e-83e3-08db059800d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SPkoRmLyC8lCXIRJ9Jo0/ocfYZ+b8vbuoRl6e77tT88ymdMXtZSL6Dd+ieainwLy4Q4KrCRKWrJEPOrGzmiOYmW5V2cda4iw3CI8vlIzEjIxxufCskD8euKsWbLr7TffxQ1FFbfijCO3S9oS7gSGCCIW3sdSLWBnx//bt3s0yq1ik7EHkj89OL7UVFtOT0qfu3MfCtDq31KVHbf6xcx2qHhacNWSkpz0+gBDcuq06UTwDSNj4IJcBg0TLTgY+tvmPanOxszp8k0JhmMWktsYdNYKAIozdgOOVSi3jv85YBru7EXqPEb/2CiNMgYpbVtEo1yznfGMsnR2qtC4ZjDWAmBpmCIxvroOuKiV76X17em7QRHvSUAWshlRdVwV/oMQ7sgBws86a24M3I/msCXZRZrfUsUP9m0txPGNEAUprpzTP4orZIL5E0N9MMDbNRN+o83ZI5fSijEPjo7nYexPN609BINyRGYKjOPjfkhSHddEgYgoBZZSc3B7WTs7iFg4/FmHiYOsM1DK/PHC5dJry+0LeOVugJ467ZiemOdD5kgjBP7DZZXXUZlBrgBQ9665pzdpvDBpdlzxc804u1kPYjsxIiiRyw8B/4pujRj29Fjthg4Vr99P0gts7Hkwp4xR5VoOxry7CQ+cTqhePvezhR4kD/2NL0J0ozac7Bu7VMsDfg51+LLB1fRqw6F+XUhfcAo+VbdaVQJG349aTGeCOjJ60H/UjDr3JcF7jawczOk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(451199018)(2616005)(26005)(53546011)(6506007)(7416002)(5660300002)(6486002)(478600001)(31686004)(6512007)(186003)(54906003)(316002)(6666004)(83380400001)(66556008)(66476007)(66946007)(4326008)(6916009)(8676002)(41300700001)(8936002)(36756003)(38100700002)(31696002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTNzOVdSVjJtVXZ4NGphaDR3UE1vWFhYb2F0SUtHeDVOTG0rTlhoNTlhYk5D?=
 =?utf-8?B?aC9nU2FQbW1CUEVqdWdiRHl1bFJnL01od0tuV1Avd1J6TmpYQUdiVTN6aXpp?=
 =?utf-8?B?blE3ZXlwVDZ0cWVEc1BoTG9sTWRwcTM4akRyS2xpZzFEbFYzMFNtUUVPR2JT?=
 =?utf-8?B?QTczZWUxbjY4U0t2K3BDQjI1NUc4ZGxaKy9ubzFYSlNEbDB5b09Sc0IwakFt?=
 =?utf-8?B?U0JTZ2crcGlNRkJDaVhKUlBCTzkzS253ZmpyQjdMQXlHVS9GVURCem9XSXlK?=
 =?utf-8?B?aDhOQWR3cmVlV2d0RmFWL3VxNVZvQ3NncDRhUEs2bzg4OWNsMkF5SEhPOUE2?=
 =?utf-8?B?Y1duTGg3bGVybVpQM2lwZkJncFVrZnFNTXFZUXdwVnVEZUYzeHo2MFEwOVQ0?=
 =?utf-8?B?bzM0bm5UZW9NU3NmcHN6UzNVb1RpWXg0VDVNRnhveWxWeDQ2bGR3VUdFdE1v?=
 =?utf-8?B?STNNWWRPK01NdHIwb1VvU2hHRTBCdTliUTdJQlBlS3g1am5CelR1Z2RwMUdk?=
 =?utf-8?B?c0dVRVpCRisxeGE1K2FMWFY3NjFod2lIR2ovOFoxZWoySkdXKzdnT04xT3Mx?=
 =?utf-8?B?UlBQVlc3dDU0dlhPdDlnb21PdmJNb1ZKa01tb3FoK3M5NkJTTXNKRmcyQno3?=
 =?utf-8?B?cUdkVEVUaXdoVkpUL1haNldwcU5lbU1XUldnL3NhQ2NxakdFaENLL2tvU2g3?=
 =?utf-8?B?SUxtdHRtbFJ4U29pNDU1YTlQNnZFTzBjN1VRWDd4UU5tbWtKODFzT3puMTV0?=
 =?utf-8?B?MFFJL2NnSnJORHlGUWp5VCsya0hkaXJDTXF4SXNzWTRHT3lCZ2ErV29jTkFL?=
 =?utf-8?B?d1ptS1E3ZkoydDUydnRVc2hKanpFNW5XL0ptWXcvRVFHa2ZqSnRzUjZTU3Mw?=
 =?utf-8?B?ZE10dStUNzBvRG1uUFd2a2wwcGFpZ04rUDl0YVFITUdXb2h6VXZxcGw0TFVU?=
 =?utf-8?B?WG5CV0laeGJYdGdHSmJRWnRDYzU3anVVZmloZDh2QkFHay81eXFISlpVejdD?=
 =?utf-8?B?N1BPVDZLQnBOQi82MjNiL0hHbkNYcW9RaWNqZWpVY0c0eTFWRVVZVTBMcDYx?=
 =?utf-8?B?a2hiT0xnVjhMUWVJeTZhM3Q4Qlg3Q3RkWXpXNkFPQUdxN1lIY1BLYVBGa0Jh?=
 =?utf-8?B?ZmFSaWdITmIzdnF2UWU1aVFmOWVITXFJL05OR3FvT052NGh5MHMyZSt3RC9G?=
 =?utf-8?B?azN2aWMvREw3MDdLREpRWFdaUXREYkNJUld5VWNuS1RaRUhGbEtNbmJwM3ll?=
 =?utf-8?B?cDlLdFAwU3BZT2pBWEdlWDlPRUlrSm11dmdJdTFpbEYrWkpSVVJMekYxWVpp?=
 =?utf-8?B?QkJ0bG9ad1FzU1B1R1VLS2VEQnBEMllTbzVyb05uc3RBM3VGdGhSWGtTOHZk?=
 =?utf-8?B?eDVVampwbGxzMXNHNDY4YzRieDMyOHNsdVBzK1ExSlFqeXg4WWs0RWY4QWpN?=
 =?utf-8?B?bkZsQ0k0ZGZTcXFHUTRHbklkcTZqR1UvdGtzWFJ4ZDQxR0M3M1J1Sk5LRUxs?=
 =?utf-8?B?dER3eEpnRUgyR1RWQzVpS2EwUjR3ZjUxQWZYTnhVZUlhQUZBTFJDdXlSZnJ6?=
 =?utf-8?B?UzM5ODdZdmdCVWM1R0VoSGxXSE5FQnRnVWV5UUo0SDd5cWlSRmV0M2J3ZERQ?=
 =?utf-8?B?dFMyTnFlK1pVMEpacnA4VitzMkNNV0FuRDRHb1ZlY1RTMkRGWTFJaHF4VEJs?=
 =?utf-8?B?aXNHU1dWMU5wVVE5T0l3MlBlandzcWN2emlPM01jcE9kWWxWaUFmeFVta09E?=
 =?utf-8?B?UFN3WXBIZ2lHL0VyREpUZ2hKK2dJS2lSNzBXL1BXWWJRU3B1MElyTHNZTDNo?=
 =?utf-8?B?MnJKalRVcE5kSGJBRXEzb3NKR1IwL0hmVTUvWHRTQ0FLTmk1aE9MV1JjZ3g0?=
 =?utf-8?B?YWlYZGw4R1hMZHF0bXhwRUlCMXE5ZDU1SVhFZi9sWUNBSjYrUjhTemJTazJU?=
 =?utf-8?B?a2VqMk1Ea1BHaHpQZUo4b2wyMzA3Z2NHQU9JV0Ryam5CT0g5UGNPUjZqWENj?=
 =?utf-8?B?dUt1ME1vQ2JvazBuWTZuUlhReGpqT1NLeEtJc1lYRUUyK3lBQ0ZBdkRNRWpI?=
 =?utf-8?B?UjBWRytIYjlBS1pKZ2JTcHpFNXNqNnNkOTBqL1dHWFZyMkg1NXBsRXg3ZkZZ?=
 =?utf-8?Q?nXQ/izX7/fPb/4ZNDkqXFRv/a?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2fd4f4b-7a39-444e-83e3-08db059800d4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 03:37:41.1714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TMdVpGuLxgA36j0mbTC5gkSnkDLKEgYKW14zjaLkD219jUhYXUP9xFpT7jJgWjnyz00I1AEiK5uDgeSOkoN4OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7578
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01/02/2023 13:18, Sean Christopherson wrote:
> On Fri, Jan 20, 2023, Alexey Kardashevskiy wrote:
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 4826e6cc611b..61f2cad1cbaf 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -389,6 +389,8 @@ static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u3
>>   	return test_bit(bit, (unsigned long *)&control->intercepts);
>>   }
>>   
>> +extern bool sev_es_is_debug_swap_enabled(void);
>> +
>>   static inline void set_dr_intercepts(struct vcpu_svm *svm)
>>   {
>>   	struct vmcb *vmcb = svm->vmcb01.ptr;
>> @@ -410,8 +412,10 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
>>   		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
>>   	}
>>   
>> -	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>> -	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>> +	if (!sev_es_guest(svm->vcpu.kvm) || !sev_es_is_debug_swap_enabled()) {
> 
> Looking below, doesn't this do the wrong thing if set_dr_intercepts() is called
> before SVM_SEV_FEAT_DEBUG_SWAP is set?  I.e. when this is called before LAUNCH_UPDATE?
> Seems like this should check SVM_SEV_FEAT_DEBUG_SWAP in sev_features regardless
> of when SVM_SEV_FEAT_DEBUG_SWAP is set.
> 
> And if KVM checks sev_features, then I _think_ we can avoid having to expose
> sev_es_debug_swap_enabled to svm.{c,h} (though why on earth {set,clr}_dr_intercepts()
> is in svm.h is another question for the future).


883b0a91f41a ("KVM: SVM: Move Nested SVM Implementation to nested.c") 
did that. Makes sense for things like vmcb_set_intercept() but 
{set,clr}_dr_intercepts() are still only called from svm.c so I'll move 
them there (btw do I need a separate patch for that? usually yes)

> 
> Follow-up question: does KVM _have_ to wait until KVM_SEV_LAUNCH_UPDATE_VMSA to
> set the flag?

Nope. Will repost soon as a reply to this mail.

>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>> +	}
>>   
>>   	recalc_intercepts(svm);
>>   }
>> @@ -422,8 +426,12 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
>>   
>>   	vmcb->control.intercepts[INTERCEPT_DR] = 0;
>>   
>> -	/* DR7 access must remain intercepted for an SEV-ES guest */
>> -	if (sev_es_guest(svm->vcpu.kvm)) {
>> +	/*
>> +	 * DR7 access must remain intercepted for an SEV-ES guest unless DebugSwap
>> +	 * (depends on NO_NESTED_DATA_BP) is enabled as otherwise a VM writing to DR7
>> +	 * from the #DB handler may trigger infinite loop of #DB's.
>> +	 */
>> +	if (sev_es_guest(svm->vcpu.kvm) && !sev_es_is_debug_swap_enabled()) {
>>   		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>>   		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>>   	}
>>
>> @@ -52,11 +53,21 @@ module_param_named(sev, sev_enabled, bool, 0444);
>>   /* enable/disable SEV-ES support */
>>   static bool sev_es_enabled = true;
>>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
>> +
>> +/* enable/disable SEV-ES DebugSwap support */
>> +static bool sev_es_debug_swap_enabled = true;
>> +module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);
> 
> Module param needs 0444 permissions, i.e. shouldn't be writable after KVM is
> loaded.  Though I don't know that providing a module param is warranted in this
> case.

> KVM provides module params for SEV and SEV-ES because there are legitimate
> reasons to turn them off, but at a glance, I don't see why we'd want that for this
> feature.


/me confused. You suggested this in the first place for (I think) for 
the case if the feature is found to be broken later on so admins can 
disable it.

And I was using it to verify "x86/debug: Fix stack recursion caused by 
DR7 accesses" which is convenient but it is a minor thing.



>>   #else
>>   #define sev_enabled false
>>   #define sev_es_enabled false
>> +#define sev_es_debug_swap false
> 
> This needs to be sev_es_debug_swap_enabled, otherwise things fall apart with
> CONFIG_KVM_AMD_SEV=n.
> 
> arch/x86/kvm/svm/sev.c: In function ‘sev_es_is_debug_swap_enabled’:
> arch/x86/kvm/svm/sev.c:69:16: error: ‘sev_es_debug_swap_enabled’ undeclared (first use in this function); did you mean ‘sev_es_is_debug_swap_enabled’?
>     69 |         return sev_es_debug_swap_enabled;
>        |                ^~~~~~~~~~~~~~~~~~~~~~~~~
>        |                sev_es_is_debug_swap_enabled
> 
> 
>>   #endif /* CONFIG_KVM_AMD_SEV */
>>   
>> +bool sev_es_is_debug_swap_enabled(void)
>> +{
>> +	return sev_es_debug_swap_enabled;
>> +}
> 
> ...
> 
>> @@ -604,6 +615,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>>   	save->xss  = svm->vcpu.arch.ia32_xss;
>>   	save->dr6  = svm->vcpu.arch.dr6;
>>   
>> +	if (sev_es_is_debug_swap_enabled())
>> +		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>> +
>>   	pr_debug("Virtual Machine Save Area (VMSA):\n");
>>   	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
>>   
>> @@ -2249,6 +2263,9 @@ void __init sev_hardware_setup(void)
>>   out:
>>   	sev_enabled = sev_supported;
>>   	sev_es_enabled = sev_es_supported;
>> +	if (sev_es_debug_swap_enabled)
>> +		sev_es_debug_swap_enabled = sev_es_enabled &&
>> +			cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP);
> 
> Slight preference for:
> 
> 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
> 		sev_es_debug_swap_enabled = false;
> 
> KVM does short-circuit some checks on module param values, but usually only to
> avoid additional setup.
> 
>>   #endif
>>   }
>>   
>> @@ -3027,6 +3044,18 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>>   
>>   	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
>>   	hostsa->xss = host_xss;
>> +
>> +	/* The DebugSwap SEV feature does Type B swaps of DR[0-3] */
>> +	if (sev_es_is_debug_swap_enabled()) {
>> +		hostsa->dr0 = native_get_debugreg(0);
>> +		hostsa->dr1 = native_get_debugreg(1);
>> +		hostsa->dr2 = native_get_debugreg(2);
>> +		hostsa->dr3 = native_get_debugreg(3);
>> +		hostsa->dr0_addr_mask = amd_get_dr_addr_mask(0);
>> +		hostsa->dr1_addr_mask = amd_get_dr_addr_mask(1);
>> +		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
>> +		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
>> +	}
>>   }
>>   
>>   void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 60c7c880266b..6c54a3c9d442 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1190,7 +1190,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>>   	set_exception_intercept(svm, UD_VECTOR);
>>   	set_exception_intercept(svm, MC_VECTOR);
>>   	set_exception_intercept(svm, AC_VECTOR);
>> -	set_exception_intercept(svm, DB_VECTOR);
>> +	if (!sev_es_is_debug_swap_enabled())
>> +		set_exception_intercept(svm, DB_VECTOR);
> 
> This is wrong.  KVM needs to intercept #DBs when debugging non-SEV-ES VMs.

Sorry, not following. The #DB intercept for non-SEV-ES is enabled here. 
Thanks,


> This _could_ be tied to X86_FEATURE_NO_NESTED_DATA_BP, but the KVM would need to
> toggle the intercept depending on whether or not userspace wants to debug the
> guest.
> 
> Similar to the DR7 interception, can this check sev_features directly?



-- 
Alexey
