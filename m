Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951696CEC84
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 17:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjC2POs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 11:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjC2POr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 11:14:47 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB2E1BC1;
        Wed, 29 Mar 2023 08:14:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LD7RaWqLlY8SRia0jIFNmstbfLAnhWP7J4AL1BzdE4BcSKT8lieX8l1Zkuztstd2yGC74W/plZ9tqRlLZo2snIJ5DFWytQWsLT7/+8kiKzQB6GQRK8ed7lh7uCkGsPjvYpg7uO5c1pjIyAw87lpRn8nAGkQOUCSzWE/05IKzRxcNY5RPSkwIzWnG0tnKWnOxn704ElGo5Kujkkl7f6tONh2seDyQetLeGTD800eVPitWnuW0gt7MG8aFZOmtejPOWYsPuu8kxLva3DSh+Vo2YkOdWKVHNIrLqUVyOZrxtTEDjL7bFGrlTXzWYwViZOZ9FuBxG/3jZLO5KNshOGcLnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YT+1YQJSG86sp8m9Qd84XSYcxUi7VpmCp43+RvH4FvM=;
 b=bRNjWKfoiZr+ZRYoXUQ1xfyfde1yML/cMwFFNnBK6l36LlEWDmUlw4tU4jdboeCxiH1A7onQRpSr8E2L/n91NXoDZW9Q6Yaapdtw9cLRepALXXju37I8yltGcAtETH9HE6g2ZUQHVFi0YQu4ph9sk7yYeCJWhx/K7hBCDYx+XOnSYC70IsCmux1S4ITWmM7esqBBz27p0uJ9V2z/M+POfgNUCPP47BXn+f6Hx8aIt3NsMyqhwQJH0F6Z0z/qukX7CYPHrvSzJHr86z8jPn9V/5ONxUd6R+bytoYsU0AEW9KFVDM8yra89GSJHu4fdgNupeEZ3K5MSnWp9Sv9y0N1Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YT+1YQJSG86sp8m9Qd84XSYcxUi7VpmCp43+RvH4FvM=;
 b=IVYt8OQC4abpgMbCXFbNgNsX9ncmOjk7WJbosDvyc3oQJZisOBjrC9LjH7lNcKZ+E9MhGZdCz9oBy4leBcxdgXK0j67rdC7eTgc6hNtEisrnPKf9LnTWu4dioWW4qy5TxO473UUdXxSg7HqzIaM5d9BRYKyluWBxh9Vm+z1wUHQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BL3PR12MB6596.namprd12.prod.outlook.com (2603:10b6:208:38f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Wed, 29 Mar
 2023 15:14:41 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60%6]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 15:14:41 +0000
Message-ID: <7edcf2c3-005f-04bd-7ec6-80baee236f40@amd.com>
Date:   Wed, 29 Mar 2023 10:13:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH kernel v4] KVM: SEV: Enable data breakpoints in SEV-ES
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <3b3a9ebc-b02e-a365-7f68-3da9189d062a@amd.com>
 <20230203051459.1354589-1-aik@amd.com> <ZByO9RP4IkEshOqJ@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZByO9RP4IkEshOqJ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:806:20::23) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|BL3PR12MB6596:EE_
X-MS-Office365-Filtering-Correlation-Id: 016b1b03-9a14-4bdf-0568-08db3068519c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0pmSapdhS/SRVj3DSDH3z3NcxL7BleKQzLswzbgCTRWt49B/vr6nrB+f77ZBRjzJdWqVCJhY/K2LZbHCRb6Z5Od8xWEuIVQzwdsAglXMZyONRhl+GLqGXO614fQBLn17HVUAigY4/gLbOUvfzSloyEJ1ZS1J/C+Qi1Pr1hPRPzOVm5VKJRSRZXjHZr50l7gxa6HXhyUog8y/YmoQIqSsLjO7ftySfWFCKhcka/w8L0OIcQwJJI0rZx1ufvpklfaxZjYTh+mo8IeSX39SprXkBr+piQ40cCWRjTzZjNWNrwsHqHg5IHe8fUi4elleRMHnVb3ePxyE+713w+5EwgzE/R6WmTFKAEcNUoE4SKQCoowuk0HbPsjlTWmpIwJmn6xkFQzy2cbvXPVFlNSzzAjGgML7io4AzjywQXPQT2bKWDq80831px9VNLOUwnP836WIgV7jIqgpSfhmJmBWFe9yR85kT1vmX+OwL+xgXBgrvRspp3SrQiaI1VR90LJIINmkIZ5JhXyLq3z+spqCFgTAyOPTOk9ziqQhX1gFfGsPI3IbfF/cX5qZFSagT2PosXvzGTtREQqzhBo0heTwa8qa9XdSTGweotLg7yHdt6W5+ZwonTFOabboXcJ/qMCQvWzvC+MkN80MOulOt5eTa62jfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(451199021)(8936002)(31686004)(2906002)(83380400001)(2616005)(6512007)(86362001)(41300700001)(31696002)(38100700002)(36756003)(5660300002)(6486002)(6636002)(54906003)(66556008)(478600001)(8676002)(66946007)(4326008)(66476007)(6506007)(7416002)(6666004)(30864003)(186003)(53546011)(316002)(26005)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R21kQWVsSTFOOEZTbXRzV0NZS2c4YzZ6VnN3MVl4cFcvalFnZGhvbkZORnFv?=
 =?utf-8?B?Q05ObmxCdkQ1Nlo0QXl2cFIxdjhjSW44ZFJQNW1XNHRXdlFVN3o3OFRhd2ZW?=
 =?utf-8?B?QmJDSlg4OGx0cFVibnJ0aENlcnlzUVVnRUdadjdEMGVjdHpUdzQwYkhKOGFh?=
 =?utf-8?B?eFJrdk5odlhYTFB0L0NITUgyYW9SdjhhZkJ4dUpaa3kvK2tLL3YxVmpLMk1r?=
 =?utf-8?B?VzRkVVBDSTA3R094Sk42cmREUDNMMWJKRDI0K29HR1pvdkQ4TFBqZWd0d0FU?=
 =?utf-8?B?NnJkU3U0RDRsbENtRnJveGtueUt1ZFo1OGJ0TURqemdCRlh6NktCblRIUTgy?=
 =?utf-8?B?aHRabzNtM3ZMTGJLKy8zT1R4Sk5WZCsvUTA5YTJ3bUNCZUhXMURjUXNqRDVD?=
 =?utf-8?B?RUUrR041RklGZUwydHd0aHhKZDV3UEYzcUxDbGlob3l4dDBjTlhidjlESVBv?=
 =?utf-8?B?QmRqUHYxMTdyZTlWSXJkdHdNYzdKSDBHUlN0b053QXVZbjVvbHpuWjZndHhS?=
 =?utf-8?B?bUVwRVVHZVZSUWVRMzMxcTJRcEE5SzlXaUdBWktCQVNBaGNDR0QwM2VsTTJO?=
 =?utf-8?B?aEt6NVVZZ3NjSnJVZmNxbjlYQjh5Y2dBRTh1bWlidmRsYXFYSmNYYVpSM2lw?=
 =?utf-8?B?bFFQZmEreGNYZVZzUkE5c2Erek9mZG9IeStkc1VodkUwTDhwelhKVnJkMWdN?=
 =?utf-8?B?YnErRVNIWGV5a20wcUExSDVYd2dYRW1ZMWxjNjJrdndEbnJEQkZaUmpQL1pD?=
 =?utf-8?B?Q3VSOEljYkdQMzFJZGFWcUZVQkprMWRDU05pMDJaWjlVa3o2VmJicmZIZERt?=
 =?utf-8?B?djlybWVsb25hL05wWDN6cTFaY2dKa0FYdHl2QlBWYmRVV1BBMVA2SksyT2xW?=
 =?utf-8?B?am85cmsrRm1LL05EN2h3dGJBYmRHcSsrV2o4UEhQeERGa2lhU1ZwMG5QeGJY?=
 =?utf-8?B?eCt5cG9PcURmMERobGVEUlpZemN2RG5HcURwVWlkUFVVb2EzK0NlZEdYQTFU?=
 =?utf-8?B?UktWWVhxOW9QZ3NEUThtdGN5ZlY1dGZPQUV2MHQzT3VGK1haS2xYL2puc1U4?=
 =?utf-8?B?dUoySGRxUUhJTVlwUFM1bVlMb056WklaUGozZXRhY1J3b1o5SEtqdDgrcnRk?=
 =?utf-8?B?dFJDK1JZR2daZ25GN2VaaytzeXFib25SUUFIaVN0Nnp4YWFyZzUvYjZFOVdo?=
 =?utf-8?B?WGlkNDR6RTJaVVB0MERoTXVhM056S0xReW94QzEyYVQ2bHhSTDBYT1p0NTh3?=
 =?utf-8?B?QU1uSVpDcFhucC9kVUl6QXlvd1VwSXVLVnIxalN4Y1hRUVJuS0F4Nm92RFZz?=
 =?utf-8?B?VXJPYkVlRmNYNWNvb1BlVi9LYlo0YW9MWjVYV0dIckViUFFHUXlXRHdtajNZ?=
 =?utf-8?B?Qk1xUHBUMnRsQUpwWHB2QmUxdDZHeGhrQkVrRDlhQWJUTitITGdNbVZMR3kr?=
 =?utf-8?B?dmhQb2lTU2Q4OE00bTRGeHplQmIvNWgyaFpYOTFHd3VFL25qbVdZdTZaVFU2?=
 =?utf-8?B?dDNTbDZtZTh3VEd6NVl5d2g5TGhGU0VtcThMa2NiZXcxVjQrUjk0ZjRvKzlG?=
 =?utf-8?B?dWRMbEEzNjlvaUlqZE1aYldhbWQ5UzVPUXhJbFl3anViQjAyVStJUmNxZG9Q?=
 =?utf-8?B?aXFmMTVzMWwwNnd5bE9rbkpwQTNXeHBGU0JNcFhzem0xdkI3b2FTRmlveFF1?=
 =?utf-8?B?ejlWdkZLWnNndk5lYWFGUkpjRTFLMTVUK01RL3c5Q2ZLZFY0dktTZlhWbEM5?=
 =?utf-8?B?WVRhMjF1STZBMlRtT2tqV2ljT2ZUTFN2SURNTFd5Y1p5TElnYkI5Z0ZGMUc0?=
 =?utf-8?B?VW1EUkppZTROdnVhUTRLTEg1WXpHY0hTZDZTMnFnNmNjUDU3VDZhVjQ3Yk9V?=
 =?utf-8?B?aFVGMGJHSnZTUmQrYmlEcFNidFZ0RlUrK2JZRXg3SHBVdndsNVdnQ3ZCTUkw?=
 =?utf-8?B?K3V0U3N2Nlh0Z1p0M2o1ZmVxeklZTHM0MHBBcmhYRkEyZEtQUVJndzgxZzU4?=
 =?utf-8?B?aDVPcnZRb21VbkgvdDRINlF1NmtPSm9GaFFra2FKUTJKOFIwL1dtVU05U2ds?=
 =?utf-8?B?L2p3Zlp4MVFJUkFLYkE1VVNOQnRRM3QwWUw4aVM2dWtVUHBGTGlQUTFhM05q?=
 =?utf-8?Q?X5DEXe7J2X/eM8s8EzUZHS7Mr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 016b1b03-9a14-4bdf-0568-08db3068519c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 15:14:41.0901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fDTysbCS3EewEg4Xxrnme9sIQ2wQ4Wrrch7GyiRfXqZKfKXpk87wLXH5w5r9oPnoAmPXq3wFKt1a20RgKQ2S5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6596
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/23/23 12:40, Sean Christopherson wrote:
> On Fri, Feb 03, 2023, Alexey Kardashevskiy wrote:
>> While at this, move set_/clr_dr_intercepts to .c and move #DB intercept
>> next to DR7 intercept.
> 
> Please do non-trivial code movement in separate patches unless the functional change
> is trivial.  Moving and changing at the same time makes the patch difficult to review.
> 
>> @@ -52,9 +53,14 @@ module_param_named(sev, sev_enabled, bool, 0444);
>>   /* enable/disable SEV-ES support */
>>   static bool sev_es_enabled = true;
>>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
>> +
>> +/* enable/disable SEV-ES DebugSwap support */
>> +static bool sev_es_debug_swap_enabled = true;
>> +module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);
> 
> Needs to be 0444, otherwise userspace can turn on the knob after KVM is loaded,
> which would allow enabling the feature on unsupported platforms, amongst many
> other problems.
> 
>>   void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 60c7c880266b..f8e222bee22a 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -671,6 +671,65 @@ static int svm_cpu_init(int cpu)
>>   
>>   }
>>   
>> +static void set_dr_intercepts(struct vcpu_svm *svm)
>> +{
>> +	struct vmcb *vmcb = svm->vmcb01.ptr;
>> +	bool intercept;
>> +
>> +	if (!sev_es_guest(svm->vcpu.kvm)) {
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
>> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
>> +	}
>> +
>> +	if (sev_es_guest(svm->vcpu.kvm)) {
>> +		struct sev_es_save_area *save = svm->sev_es.vmsa;
>> +
>> +		intercept = !(save->sev_features & SVM_SEV_FEAT_DEBUG_SWAP);
> 
> Blech, the VMCB vs. SEV and SEV-ES code is a mess.  E.g. init_vmcb() does
> 
> 	/*
> 	 * Guest access to VMware backdoor ports could legitimately
> 	 * trigger #GP because of TSS I/O permission bitmap.
> 	 * We intercept those #GP and allow access to them anyway
> 	 * as VMware does.  Don't intercept #GP for SEV guests as KVM can't
> 	 * decrypt guest memory to decode the faulting instruction.
> 	 */
> 	if (enable_vmware_backdoor && !sev_guest(vcpu->kvm))
> 		set_exception_intercept(svm, GP_VECTOR);
> 
> but then sev_es_init_vmcb() also does:
> 
> 	/* No support for enable_vmware_backdoor */
> 	clr_exception_intercept(svm, GP_VECTOR);
> 
> DR interception is a similar trainwreck.  svm_sync_dirty_debug_regs() bails if
> guest_state_protected is true, i.e. is a nop for SEV-ES guests, but only after
> the vCPU has done LAUNCH_UPDATE_VMSA.  IIUC, that's nonsensical because even before
> guest state is encrypted, #DB will be reflected as #VC into the guest.  And, again

A guest can't run before the LAUNCH_UPDATE process is complete, so there 
can't be a #VC before guest_state_proteced is true.

> IIUC, except for DR7, DRs are never intercepted for SEV-ES guests and so trying
> to debug from the host is futile as the guest can clobber DRs at any time.
> 
> Similarly, flowing into dr_interception() on an SEV-ES VMGEXITis just dumb.  KVM
> _knows_ it can't give the guest control of DR7, but it mucks with the intercepts
> anyways.  That the GHCB spec even allows SVM_EXIT_{READ,WRITE}_DR7 is just asinine,
> but that's a moot point.  Anyways, the GHCB spec's "suggestion" effectively says
> KVM's responsibility is purely to make a read of DR7 return the last written value.

That's not KVM's responsibility, that is the responsibility of the guest 
#VC handler. So a DR7 read, while intercepted, should never get to KVM.

> And of course KVM's disaster of a flow doesn't even do that unless the host is
> debugging the guest.
> 
>    Currently, hardware debug traps aren’t supported for an SEV-ES guest. The hypervisor
>    must set the intercept for both read and write of the debug control register (DR7).
>    With the intercepts in place, the #VC handler will be invoked when the guest accesses
>    DR7. For a write to DR7, the #VC handler should perform Standard VMGExit processing.
>    The #VC handler must not update the actual DR7 register, but rather it should cache
>    the DR7 value being written.
> 
> I bring this up because of the subtle dependency that checking SVM_SEV_FEAT_DEBUG_SWAP
> creates: set_dr_intercepts() needs to be called after sev_init_vmcb().  I believe
> this approach also fails to handle intrahost migration; at the very least, what
> exactly will happen when sev_migrate_from() invokes sev_init_vmcb() is unclear.
> And I really don't want to pile even more gunk on top of the existing mess.
> 
> So, can you (and by "you" I really mean "the folks at AMD working on SEV stuff")
> start with the below diff (not intended to be a single patch), disallow
> kvm_arch_vcpu_ioctl_set_guest_debug() entirely for SEV-ES guests (will likely
> take some back and forth to figure out how we want to do this), and then fill
> in the blanks?  I.e. get KVM to a state where all the intercept shenanigans for
> SEV and SEV-ES are reasonably contained in sev.c, and then enable the debug_swap
> stuff on top?
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c25aeb550cd9..ff7a4d68731c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2968,8 +2968,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>          svm_set_intercept(svm, TRAP_CR4_WRITE);
>          svm_set_intercept(svm, TRAP_CR8_WRITE);
>   
> -       /* No support for enable_vmware_backdoor */
> -       clr_exception_intercept(svm, GP_VECTOR);
> +       <debug register stuff goes here>
>   
>          /* Can't intercept XSETBV, HV can't modify XCR0 directly */
>          svm_clr_intercept(svm, INTERCEPT_XSETBV);
> @@ -2996,6 +2995,12 @@ void sev_init_vmcb(struct vcpu_svm *svm)
>          svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
>          clr_exception_intercept(svm, UD_VECTOR);
>   
> +       /*
> +        * Don't intercept #GP for SEV guests, e.g. for the VMware backdoor, as
> +        * KVM can't decrypt guest memory to decode the faulting instruction.
> +        */
> +       clr_exception_intercept(svm, GP_VECTOR);
> +
>          if (sev_es_guest(svm->vcpu.kvm))
>                  sev_es_init_vmcb(svm);
>   }
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e0ec95f1f068..89753d7fd821 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1209,10 +1209,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>           * Guest access to VMware backdoor ports could legitimately
>           * trigger #GP because of TSS I/O permission bitmap.
>           * We intercept those #GP and allow access to them anyway
> -        * as VMware does.  Don't intercept #GP for SEV guests as KVM can't
> -        * decrypt guest memory to decode the faulting instruction.
> +        * as VMware does.
>           */
> -       if (enable_vmware_backdoor && !sev_guest(vcpu->kvm))
> +       if (enable_vmware_backdoor)
>                  set_exception_intercept(svm, GP_VECTOR);
>   
>          svm_set_intercept(svm, INTERCEPT_INTR);
> @@ -1950,7 +1949,7 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
>   {
>          struct vcpu_svm *svm = to_svm(vcpu);
>   
> -       if (vcpu->arch.guest_state_protected)
> +       if (WARN_ON_ONCE(sev_es_guest(vcpu->kvm)))
>                  return;
>   
>          get_debugreg(vcpu->arch.db[0], 0);
> @@ -2681,7 +2680,7 @@ static int dr_interception(struct kvm_vcpu *vcpu)
>          unsigned long val;
>          int err = 0;
>   
> -       if (vcpu->guest_debug == 0) {
> +       if (vcpu->guest_debug == 0 && !sev_es_guest(vcpu->kvm)) {

This will change the current flow of an SEV-ES guest. With SEV-ES, 
vcpu->guest_debug can never be anything other than 0 and currently always 
takes this path.

So what is really needed is:

	if (vcpu->guest_debug == 0) {
		if (!sev_es_guest(vcpu->kvm)) {
			...
		}

		return 1;
	}

>                  /*
>                   * No more DR vmexits; force a reload of the debug registers
>                   * and reenter on this instruction.  The next vmexit will
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index f44751dd8d5d..7c99a7d55476 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -409,23 +409,25 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
>   {
>          struct vmcb *vmcb = svm->vmcb01.ptr;
>   
> -       if (!sev_es_guest(svm->vcpu.kvm)) {
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
> +       if (sev_es_guest(svm->vcpu.kvm)) {
> +               WARN_ON_ONCE(svm->vcpu.arch.last_vmentry_cpu != -1);
> +               return;
>          }
>   
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
>          vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
>          vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
>   
> @@ -436,13 +438,13 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
>   {
>          struct vmcb *vmcb = svm->vmcb01.ptr;
>   
> +       if (WARN_ON_ONCE(sev_es_guest(svm->vcpu.kvm)))
> +               return;
> +
>          vmcb->control.intercepts[INTERCEPT_DR] = 0;
>   
> -       /* DR7 access must remain intercepted for an SEV-ES guest */
> -       if (sev_es_guest(svm->vcpu.kvm)) {
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> -               vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
> -       }
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> +       vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);

If we never call clr_dr_intercepts() anymore for an SEV-ES guest, then the 
above two lines should be removed. They only were executed for an SEV-ES 
guest and now they would be executed for any guest.

Thanks,
Tom

>   
>          recalc_intercepts(svm);
>   }
> 
