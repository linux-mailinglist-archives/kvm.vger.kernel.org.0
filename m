Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08DC691F08
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 13:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbjBJMYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 07:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBJMYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 07:24:34 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3964170CFD;
        Fri, 10 Feb 2023 04:24:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTMxjOYgXkIFEoalxXVhgkAC7H/poREluVAlK2L7qvX3ioO/MLWzJtYx6jRPvwsvP4RZR6SHTM4XfuR9clKviYPZPtx7DI5yo1pIQm9Jprc5V5lMDjY16s5D+RZPJtZ0qhLwisq7M3NebKi9TI5k8J/8mY2iTsTOkeoY9sBwTmh+hCIfKQ5unwgkLSzFx1bBMn9gh8+znNRciMWWh15av/RIs4ify5Yj1xS+dxxsL0AIPsGMBRb+uW3+4nKj9VvuhrKPymJJ5jDh2XJRCVmPfPv6cy3zF8vM8wSvBFf+Caof+ftIfnX9IxsnKcgejKXQEWKQvraBN3BiT+2I3w1EYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ZdLpIWFmy0CuZTm+Q0EEyNUrC3/LigkK1uujgKaFiM=;
 b=MwZVI1BjRhah9OefA6NSOZWSrX7hMj0/8u/88yxMPl4JcYeqMz2JKI2A+GSkEoVvRK9NzketQhgb6mlyOnwdLsjrD/a+Fc192uusD++ukIkOkFJXclj/MIQvlAMeQpfKpXU4WL+QAD5TotBA7h7hu7QNK1G2yNo6pyYAu4bCiQwlDoMIei4qWDM0I3xh2v800iGkFnceVQEjiXmaW+BE/ySWMZN0MscdCqK/6Ysof5dL9iLRDHZkN37sU8QjaN8+34VJnVfq+hc+IrDYgzAlEjOq8V7wZnmIaVd8308SDkT9YnyzqlsofuzH/uMHaVUziX9IOdGfHgzPqMZY0C941w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZdLpIWFmy0CuZTm+Q0EEyNUrC3/LigkK1uujgKaFiM=;
 b=adobj+Z7gQtSjtvCkp93gSoHPQsurTVXstfQMu/d8h0Aj4LJ24b5zXSnysIsdLdamR4rRMOfrVnBvP8phzpfx1fTawPVBy4I+B4k4Z9q2NG2mbIwGLlpMs9rJQU4/BWolQb1s66NESVAx+TC2Ya3t6WsPaalJzbr74JUl/XfrwY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6305.namprd12.prod.outlook.com (2603:10b6:208:3e7::16)
 by IA1PR12MB6553.namprd12.prod.outlook.com (2603:10b6:208:3a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.20; Fri, 10 Feb
 2023 12:24:25 +0000
Received: from IA1PR12MB6305.namprd12.prod.outlook.com
 ([fe80::1eac:a719:2b3c:b4c1]) by IA1PR12MB6305.namprd12.prod.outlook.com
 ([fe80::1eac:a719:2b3c:b4c1%7]) with mapi id 15.20.6064.036; Fri, 10 Feb 2023
 12:24:25 +0000
Message-ID: <439a8cfc-fe2d-436d-2ea2-b795eb983b9a@amd.com>
Date:   Fri, 10 Feb 2023 17:54:09 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 10/11] KVM: SVM: implement support for vNMI
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Santosh Shukla <santosh.shukla@amd.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-11-mlevitsk@redhat.com> <Y9mwz/G6+G8NSX3+@google.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <Y9mwz/G6+G8NSX3+@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0100.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::9) To IA1PR12MB6305.namprd12.prod.outlook.com
 (2603:10b6:208:3e7::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6305:EE_|IA1PR12MB6553:EE_
X-MS-Office365-Filtering-Correlation-Id: a96a0269-5b74-4096-c1d3-08db0b61bf50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T7/4iQ+hyhy1jaEutXgK+5MWGApQNHvz/wlYzBBQNl5XdIl3GVUiB/NIaO7DLJ4F4Sx1YRa2y33tGzpfMdr+ey8FiyStVI8Qkk6kgLakJ3luzDDcqFNclw75UKZ/tz7k2VmiXE0oKMP5srzAyHhzsvuIWdpe7ZsJEneq6UoOsO9jGgnVKS0k2yZayi6EwNXWsbnSeUubchM7bzgT5rlQQs5YgFSlY0L2Y9JU+tvg/vgWKNLpy0M0cY4HQA+DxX16kPRs4l9uXhMJLVYumgFv0Geio4N+Zev5685U9ROVUymBVTnSGJbSFLgPU2DLdxtUj7+KTTSU3v7lCXZpn3vFG0eeCgMflxSIv8IVVrCyNnUXdgFF6XQc/QoWD+bgtwsxplfMmwPzDbrQ9YMt8etBxiGp6+QpwMP14T/yrPgJnTj0YmXnVvseXjqm2ftb4v2Tdooutpp+wc4eHlG5Ai8TLiqlV4Pm2Yei5WUuDKV+erJZsxdSo8jY9zKzmN1Zt3c0BlDpseTfH/O0RhcBvKQR3HnFV2ELzh7xr12EZsA0mTLiYXJ7wJjZpHLmFePvV5oRESeeoyOK9yizrUPcQZmVB08sI1qYhi8uput6353wV4liR6kLYWvfiPJHDVwnx9oe5shm6PWprB5On41Hf8KVJCD2Y4Gmyx3eVj9DQlAvXtkLC8DAB0dtP2+fuVUO/ki7e8hm88ujSAVa2qFzzqbThwCchv2Cc2Zat51HtwzwkQc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6305.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199018)(66899018)(31686004)(31696002)(86362001)(36756003)(38100700002)(83380400001)(2616005)(26005)(186003)(6512007)(6666004)(6506007)(478600001)(53546011)(55236004)(6486002)(316002)(8936002)(41300700001)(5660300002)(110136005)(44832011)(30864003)(54906003)(2906002)(7416002)(4326008)(8676002)(66946007)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2pWT2JmVnhpcWtEaERhSE03R1RNNVloeUVMd293dXIyOEg5TWxVZEo2dERp?=
 =?utf-8?B?dHJKeFlHZlpycHZmblhqNTRUQmM0aHVFc0l2QW1oS0tRTEsyWXR1ZGdvWDRl?=
 =?utf-8?B?UnJGQlVhY0IralIwM1lpMkR2cWJVZG9sSjdMSUdrKzZkR3doSGhzekgxRlNT?=
 =?utf-8?B?bFhYL3RaVURjUndEMHRId0tEdVBiYkFqVHdIZkdtWlFsNnFxcU9lLzRHM1g0?=
 =?utf-8?B?WEhPbFdMMzkxWHpvWEhDR1Z0UTNndEc1dTBReENOdnZRN3FVR214TGE3ZllK?=
 =?utf-8?B?M1hWT3hNc3dxWHdVaHdFTVBuYVdlTHZxZDQxS3pvQWRuOE1nbWU3WEgvcVFq?=
 =?utf-8?B?N3ozRHBYcW9qWllrbkhObVlDeXp5RnNiVEdOdHBVYjQzQ3FISlpINWIrREZX?=
 =?utf-8?B?VmF4cDRZcndBQmp3eTZRSTJFaWpsQnUxRzg3cG4zeDI1Vytud0N5WjZVeUZx?=
 =?utf-8?B?Yzh6VHh3d3VsU0VjR0l5cnp1b2hRWlZtaU5PdXZmcG5rWjJuc3I1dlBTR2lj?=
 =?utf-8?B?cEtKQW5JZWpvMldSeW54SnJsQUd0L05NOWIxdVRualRpTVJDb1A0ck9RN2dv?=
 =?utf-8?B?WjBFRmVHR04wNUJZUUxNMUNVR0dHbHFjTmhMaXgrUWU4MmJMK0JoaEY2Y09k?=
 =?utf-8?B?Y2kyYmMrMWkrcFZFam9iODZYaXQ2Y3hFWnVqWFpJTkh2cEROdFUwQi8xT3pE?=
 =?utf-8?B?aU1sYXBOaDUyQlNOTXdnbHJaWE51K3d1RWVKMkJDZDhsNzRnWS95ajBsZ3VY?=
 =?utf-8?B?T1c3MGNOa2ljQUZKVWt4SmdMQURhd3hSam4rcFI3V0xlZmpGWU1EL3ZhS2VL?=
 =?utf-8?B?aXZWVnRFTVdjTit4R252ZXVzTyt4RWJ1UWZQNDlISXhFRUNDUC9XelNxSTR1?=
 =?utf-8?B?RzJINHJyRWdRZ0RzR21oUzVwcEIvWTQ3a0RNazRXb0s2QUlGN3IzTWYrWktz?=
 =?utf-8?B?SHZoMlN4ZEEyK1ZIWENBODkzU1YyNnFUZkFHM29UT0M1MUE2dGxSYUhUNkMr?=
 =?utf-8?B?QjBERkN0bzdXcnlhVldPdjFPZTNSVVE5aFJyc2R2dnJ6Q0NkT2w0dEtBZktJ?=
 =?utf-8?B?NE5ibVE4ZCt4L3VJcXQwbTBOSVY0QzdwdmIvVlRSempQS0d5c0RTdEM5ZTVz?=
 =?utf-8?B?MEFGNEtmVzRNU3ZWWGRMWXplQmpVZ012SElnVUtLc2MwR0hlWTFnaW9JR3N5?=
 =?utf-8?B?VmErSmxSYkhHblA1T3pMMlNYbmxyY2FGbmVUTEJJWUNPaEl6L2tERlVhRVZs?=
 =?utf-8?B?WkdmVGlkRXBmMlc5ZHM5dm9ONTVBOGphYnVmNk51RU1JMnhiYjJ3TjNSZUdK?=
 =?utf-8?B?ZjdnN2JlbVc0eXUrUktSY0lydEJacGJQZ0J3ZkdTVmtSWkY4L0tSZnRweHRQ?=
 =?utf-8?B?RnVVeHg5TFJzVFE1UGdra1VYSkkwMmdZYWR1VHU1NXlEcUdPbUFBcnRwT2JP?=
 =?utf-8?B?QmpMTEV5c2ZBRnpJQjVoaG5GbTVCYlp0TW1pcjd0NDBlK2VDekhxTjdyMFZZ?=
 =?utf-8?B?VTdvWHp1dXhEN1RCbW1xandoNzRPeEdIWS9HWHFVWjUxTlV6MGxuaVQrMjRr?=
 =?utf-8?B?SDVpZi9wTXFDblpVUVM3MHRlMTdLNFlieFM0dm10K3BUMWpvSU41ZXNrMFhD?=
 =?utf-8?B?RVlUNEU5dGZkSWN2TDVsL1JVOXJSMHJxOUxxVlJNV2dxV3lPRWpKK3ZhZzg0?=
 =?utf-8?B?VWpNYmpLRkNvV2o3VkwzWkY5Z1NhbFkrRjh5YVVVeUMyT0dMbTJXVGJUZ3lQ?=
 =?utf-8?B?MUFCZ0lpNDliQ3YrcG56d3NNOCtPZjJTKzdzd0hOcytBVGxBTCtFRmZZN2VT?=
 =?utf-8?B?eHFMa1NHUThNM004L3FYV0sxQ0E5cWgyaENJaWhrWTFpQUFBWFphYjdFZ2FY?=
 =?utf-8?B?cktqeGZKaVJRdzZvUkJnMlptaE1aTGZLMWZSMWF0OXdUcDJwTzUvVzdtL0cw?=
 =?utf-8?B?SG5vSDF6dEJoRzNTcmhOVlUyblkxMlVEL0s5clZpcHkvdDFtWXMyN0FTWlhx?=
 =?utf-8?B?bm04b1ZTaGJPTUI0a3VWZzBiSmhFWG8rTnFDLzhLV1plMmVPcmg2YjdCYU4w?=
 =?utf-8?B?bkpkdWVxSU8ydUlpQitESmhDaGcycUN6MFdUSzYrSU53ZU5vUHVxTXYvc1ZK?=
 =?utf-8?Q?rbjNLY2Z9QRDZzHIgHwZVNkvy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a96a0269-5b74-4096-c1d3-08db0b61bf50
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6305.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 12:24:25.6270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Ob65sZjye1LamVsOiOPECW1hWgIj98hrJzKX+KabcTUXsHkcQ7xt/f05czz7GHp58Dq6ZkwTwVZAy4enXtyOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6553
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/2023 5:52 AM, Sean Christopherson wrote:
> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
>> This patch implements support for injecting pending
>> NMIs via the .kvm_x86_set_hw_nmi_pending using new AMD's vNMI
> 
> Wrap closer to 75 chars, and please try to be consistent in how your format
> things like changelogs and comments.  It's jarring as a reader when the wrap
> column is constantly changing.
> 
>> feature.
> 
> Please combine the introduction, usage, and implementation of the hew kvm_x86_ops,
> i.e. introduce and use the ops in this patch.  It's extremely difficult to review
> the common x86 code that uses the ops without seeing how they're implemented in
> SVM.  I believe the overall size/scope of the patch can be kept reasonable by
> introducing some of the common changes in advance of the new ops, e.g. tweaking
> the KVM_SET_VCPU_EVENTS flow.
> 
>> Note that the vNMI can't cause a VM exit, which is needed
>> when a nested guest intercepts NMIs.
> 
> I can't tell if this is saying "SVM doesn't allow intercepting virtual NMIs", or
> "KVM never enables virtual NMI interception".
> 

I think, It meant to say that vNMI doesn't need nmi_window_exiting feature to
pend the new virtual NMI. Will reword.

>> Therefore to avoid breaking nesting, the vNMI is inhibited while
>> a nested guest is running and instead, the legacy NMI window
>> detection and delivery method is used.
> 
> State what KVM does, don't describe the effects.  E.g. "Disable vNMI while running
> L2".  When a changelog describes the effects, it's unclear whether the effects are
> new behavior introduced by the patch, hardware behavior, etc...
> 
>> While it is possible to passthrough the vNMI if a nested guest
>> doesn't intercept NMIs, such usage is very uncommon, and it's
>> not worth to optimize for.
> 
> Can you elaborate on why not?  It's not obvious to me that the code will end up
> more complex, and oftentimes omitting code increases the cognitive load on readers,
> i.e. makes things more complex in a way.  vNMI is mutually exclusive with NMI
> passthrough, i.e. KVM doesn't need to handle NMI passthrough and vNMI simultaneously.
> 
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> SoB chain is wrong.  Maxim is credited as the sole Author, i.e. Santosh shouldn't
> have a SoB.  Assuming the intent is to attribute both of ya'll this needs to be
> 
>  Co-developed-by: Santosh Shukla <santosh.shukla@amd.com>
>  Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>  Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> if Maxim is the primary author, or this if Santosh is the primary author
> 
>  From: Santosh Shukla <santosh.shukla@amd.com>
> 
>  <blah blah blah>
> 
>  Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>  Developed-by: Maxim Levitsky <mlevitsk@redhat.com>
>  Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 

Will sort those in v3.

>> ---
>>  arch/x86/kvm/svm/nested.c |  42 +++++++++++++++
>>  arch/x86/kvm/svm/svm.c    | 111 ++++++++++++++++++++++++++++++--------
>>  arch/x86/kvm/svm/svm.h    |  10 ++++
>>  3 files changed, 140 insertions(+), 23 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index e891318595113e..5bea672bf8b12d 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -623,6 +623,42 @@ static bool is_evtinj_nmi(u32 evtinj)
>>  	return type == SVM_EVTINJ_TYPE_NMI;
>>  }
>>  
>> +static void nested_svm_save_vnmi(struct vcpu_svm *svm)
> 
> Please avoid save/restore names.  KVM (selftests in particular) uses save/restore
> to refer to a saving and restoring state across a migration.  "sync" is probably
> the best option, or just open code the flows.
> 

ok.

I chose to open code that way I don't need to consider using svm->nmi_masked which should be
used for non-vNMI case.

>> +{
>> +	struct vmcb *vmcb01 = svm->vmcb01.ptr;
>> +
>> +	/*
>> +	 * Copy the vNMI state back to software NMI tracking state
>> +	 * for the duration of the nested run
>> +	 */
>> +
>> +	svm->nmi_masked = vmcb01->control.int_ctl & V_NMI_MASK;
>> +	svm->vcpu.arch.nmi_pending += vmcb01->control.int_ctl & V_NMI_PENDING;
> 
> This is wrong.  V_NMI_PENDING is bit 11, i.e. the bitwise-AND does not yield a
> boolean value and will increment nmi_pending by 2048 instead of by 1.
>

Right.
 
> 	if (vmcb01->control.int_ctl & V_NMI_PENDING)
> 		svm->vcpu.arch.nmi_pending++;
> 
> And this needs a KVM_REQ_EVENT to ensure KVM processes the newly pending NMI.
> 

Ok.

>> +}
>> +
>> +static void nested_svm_restore_vnmi(struct vcpu_svm *svm)
>> +{
>> +	struct kvm_vcpu *vcpu = &svm->vcpu;
>> +	struct vmcb *vmcb01 = svm->vmcb01.ptr;
>> +
>> +	/*
>> +	 * Restore the vNMI state from the software NMI tracking state
>> +	 * after a nested run
>> +	 */
>> +
>> +	if (svm->nmi_masked)
>> +		vmcb01->control.int_ctl |= V_NMI_MASK;
>> +	else
>> +		vmcb01->control.int_ctl &= ~V_NMI_MASK;
> 
> As proposed, this needs to clear nmi_masked to avoid false positives.  The better
> approach is to not have any open coded accesses to svm->nmi_masked outside of
> flows that specifically need to deal with vNMI logic.
>
ok.
 
> E.g. svm_enable_nmi_window() reads the raw nmi_masked.
> 
>> +
>> +	if (vcpu->arch.nmi_pending) {
>> +		vcpu->arch.nmi_pending--;
>> +		vmcb01->control.int_ctl |= V_NMI_PENDING;
>> +	} else
> 
> Curly braces on all paths if any path needs 'em.
>

ok. 

>> +		vmcb01->control.int_ctl &= ~V_NMI_PENDING;
>> +}
> 
> ...
> 
>> + static bool svm_set_hw_nmi_pending(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +
>> +	if (!is_vnmi_enabled(svm))
>> +		return false;
>> +
>> +	if (svm->vmcb->control.int_ctl & V_NMI_PENDING)
>> +		return false;
>> +
>> +	svm->vmcb->control.int_ctl |= V_NMI_PENDING;
>> +	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
>> +
>> +	/*
>> +	 * NMI isn't yet technically injected but
>> +	 * this rough estimation should be good enough
> 
> Again, wrap at 80 chars, not at random points.
>

ok.
 
>> +	 */
>> +	++vcpu->stat.nmi_injections;
>> +
>> +	return true;
>> +}
>> +
> 
> ...
> 
>>  bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vcpu_svm *svm = to_svm(vcpu);
>> @@ -3725,10 +3772,16 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>>  	/*
>>  	 * Something prevents NMI from been injected. Single step over possible
>>  	 * problem (IRET or exception injection or interrupt shadow)
>> +	 *
>> +	 * With vNMI we should never need an NMI window
>> +	 * (we can always inject vNMI either by setting VNMI_PENDING or by EVENTINJ)
> 
> Please honor the soft limit and avoid pronouns.  There's also no need to put the
> blurb in parantheses on its own line.
> 
> As for the code, I believe there are bugs.  Pulling in the context...
> 
> 	if (svm->nmi_masked && !svm->awaiting_iret_completion)
> 		return; /* IRET will cause a vm exit */
> 
> Checking nmi_masked is wrong, this should use the helper.  Even if this code can

Right,.

> only be reached on error, it should still try its best to not make things worse.
> 
> 	if (!gif_set(svm)) {
> 		if (vgif)
> 			svm_set_intercept(svm, INTERCEPT_STGI);
> 		return; /* STGI will cause a vm exit */
> 	}
> 
> 	/*
> 	 * Something prevents NMI from been injected. Single step over possible
> 	 * problem (IRET or exception injection or interrupt shadow)
> 	 *
> 	 * With vNMI we should never need an NMI window
> 	 * (we can always inject vNMI either by setting VNMI_PENDING or by EVENTINJ)
> 	 */
> 	if (WARN_ON_ONCE(is_vnmi_enabled(svm)))
> 		return;
> 
> This is flawed, where "this" means handling of NMI windows when vNMI is enabled.
> 
> IIUC, if there are back-to-back NMIs, the intent is to set V_NMI for one and
> inject the other.  I believe there are multiple bugs svm_inject_nmi().  The one
> that's definitely a bug is setting svm->nmi_masked.  The other suspected bug,
> which is related to the above WARN, is setting the IRET intercept.  The resulting
> IRET interception will set awaiting_iret_completion, and then the above WARN is
> reachable (even if the masking check is fixed).
> 
> I don't think KVM needs to ever intercept IRET.  One NMI gets injected, and the
> other is sitting in INT_CTL.V_NMI_PENDING, i.e. there's no need for KVM to regain
> control.  If another NMI comes along before V_NMI_PENDING is handled, it will
> either get injected or dropped.
> 
> So I _think_ KVM can skip the intercept code when injecting an NMI, and this WARN
> can be hoisted to the top of svm_enable_nmi_window(), because as stated above, KVM
> should never need to request an NMI window.
> 
> Last thought, unless there's something that will obviously break, it's probably
> better to WARN and continue than to bail.  I.e. do the single-step and hope for
> the best.  Bailing at this point doesn't seem like it would help.
> 
>>  	 */
>> +	if (WARN_ON_ONCE(is_vnmi_enabled(svm)))
>> +		return;
>> +
>>  	svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
>> -	svm->nmi_singlestep = true;
>>  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
>> +	svm->nmi_singlestep = true;
>>  }
> 

Ok.

So you mean.. In vNMI mode, KVM should never need to request NMI window and eventually
it reaches to NMI window then WARN_ON and cont.. to single step... so modified code change
may look something like below:

static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
{
        struct vcpu_svm *svm = to_svm(vcpu);

        /*
         * With vNMI we should never need an NMI window.
         * and if we reach here then better WARN and continue to single step.
         */
        WARN_ON_ONCE(is_vnmi_enabled(svm));

        if (svm_get_nmi_mask(vcpu) && !svm->awaiting_iret_completion)
                return; /* IRET will cause a vm exit */

        if (!gif_set(svm)) {
                if (vgif)
                        svm_set_intercept(svm, INTERCEPT_STGI);
                return; /* STGI will cause a vm exit */
        }

        /*
         * Something prevents NMI from been injected. Single step over possible
         * problem (IRET or exception injection or interrupt shadow)
         */

        svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
        svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
        svm->nmi_singlestep = true;
}

Does that make sense?

Thanks,
Santosh

> ...
> 
>> @@ -553,6 +554,15 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
>>  	       (msr < (APIC_BASE_MSR + 0x100));
>>  }
>>  
>> +static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
>> +{
>> +	/* L1's vNMI is inhibited while nested guest is running */
>> +	if (is_guest_mode(&svm->vcpu))
> 
> I would rather check the current VMCB.  I don't see any value in hardcoding the
> "KVM doesn't support vNMI in L2" in multiple places.  And I find the above comment
> about "L1's vNMI is inhibited" confusing.  vNMI isn't inhibited/blocked, KVM just
> doesn't utilize vNMI while L2 is active (IIUC, as proposed).
> 
>> +		return false;
>> +
>> +	return !!(svm->vmcb01.ptr->control.int_ctl & V_NMI_ENABLE);
>> +}
>> +
>>  /* svm.c */
>>  #define MSR_INVALID				0xffffffffU
>>  
>> -- 
>> 2.26.3
>>

