Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3E557914B
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 05:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbiGSDZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 23:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiGSDZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 23:25:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3261626DB;
        Mon, 18 Jul 2022 20:25:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b83MhlYjFS82Ux4NMBHZ6FXR/9ppGKyRL/dpkhMFUbdgLcftmIfzhXKGNOxTIowcbj3Ttx555K1+2XUZEz8HFy5EPvb6gPx7L2OWQhl6zkzZTVGXqGf6I3UYcZju8Q/vv2qsb9RWf5ZdUkKS9BbLbhnX4QA/p6nim5BjDz1hsfjDyL+AhCxEpTJIM+ipb7PvbG25HuJHrmNarqaI0DVfpeecDxbNijO7ZOw/SAqAQz1cg/IOTKIqUL+CQs27pZMlh4Fn0w6JqmTklAmMrcfjYBHJMau5o2V5MTjUYH1fRJ4wuScgIv5B6fFiNSlwHsgre1lsTtDFhyLMbJvkifGNUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1l16gadAlCSFRH9rhkBU+R83lw9HXyMVcsXpuCaYrk=;
 b=gHlHSq+ZvLs2kX0OVFBVm/uuF1vdM2uqmrhqpVtib/bx8xkqJccsWIiD+Gf1DgQQphlAgXkLJ0VQ8seAPuWvylptM3k5bz+754E2I4ZWceP7cHC7lgViI4mSN3PQZ0otryx46a07vQ57EuAijlpkCn01OVYN2VZZxjBYZ89zyIOUjTnSJKeShpThNOESjlinkX/uYnaUTkWkfZ4beKq2xVHIhYM5/t3Fj4jHe5o05EwX1ktAuZsDBQQKL0g6p0aTHVVQmgBUF1pPmU60gdLn9sZ0qRon05SlBR68NfrSnR+F0mEmY1N0JzKpPMQ+bYe8WN4LjuIt3AcYbDsRsSX0Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1l16gadAlCSFRH9rhkBU+R83lw9HXyMVcsXpuCaYrk=;
 b=nVSoRRbGvLxiY2ozXaJPsSJPY0m1s7cTQ0PYgq7SazkMRsYSyEhNls+g322YxRQ9d5RHaeJCwG2a0MMhmlnrupwjX4W1cStaYxLaupH0eC1EmioZ6lW8fuQ+T9AuFms6eODtvmhdC26dNmpFvdXFEI1yL2lsT6h4/2XffWwuM/c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MN2PR12MB4797.namprd12.prod.outlook.com (2603:10b6:208:a4::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.13; Tue, 19 Jul 2022 03:25:08 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::d4af:b726:bc18:e60c]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::d4af:b726:bc18:e60c%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 03:25:08 +0000
Message-ID: <40b6f9e6-90c5-ca42-13d7-5e81ff4990c6@amd.com>
Date:   Tue, 19 Jul 2022 10:24:58 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] KVM: x86: Do not block APIC write for non ICR registers
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, jon.grimm@amd.com,
        Zeng Guang <guang.zeng@intel.com>
References: <20220718083913.222140-1-suravee.suthikulpanit@amd.com>
 <YtWYL6mvN72kaDOi@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <YtWYL6mvN72kaDOi@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0181.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::13) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c66c18a-6ff5-43d3-9c3e-08da69364797
X-MS-TrafficTypeDiagnostic: MN2PR12MB4797:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3iT8jJ3Esyz1/ZJs/wxtT34/mhCBi4romedW8aztSJxbQ5ps1ehncuYmukWvusHvAqzoJG9TQmuNnhLyZ9jvysXrJGAaEvnhXXXPZC7AOQAS6WybyYneyjtbuNqqIsZ23BFXs/wyy9N/bfzpl+1HgHRzu80qV0GXSfr7oYRCuKRreNbYVYq50/hYFKe3Ll++nyj0u3F2/uVdpdIZXsq2+OyVKa5NXUSjpl2rB4Bz6Gfm6GhJcT9ujXTtZClZqDK7kN8/7wXyJjtbE5RQhrpF6KYo3HEv9anGwN8hw5fSrEW7HpHYQB+7zNJ1hHYhBWaa5RVnZx9OnRQA4LD5EvbJNgW5IhIOk9xdjIMbMxEfxHYF8fS8pS/ukfHuM80xBIQDc/uwB7FTd7AfSEd/Sp+wgCOV9o5PAP5bf/5ABu00xGxFJOtCuKDAtIo6J2LsVnlug/LocqVPTd2s1KmRQZ6g5ECZBvX2u5VOK4AtREu/Vmi7YeBtmSRr2eFN8t9LKummESqBTFCh1h9iQV4GquTr+2jD2fzZ/09qd/lgDLDGIcn/NJ3GOqYsgMxZrzgDCyWDXVrJnWdoS7m4ftTr9nzDhW3LogIuwbNTfcdRw8F+BDbkE8JGbQL2++da+2aBVCbSjTTLUfB/rX4RbJQ6TOnNLZd8JJGysPTRQxJU1I5pX1gFTVD3rnIzJqc7tquTfSsMGPPpaf0TxHPnad67yX9OhZXbb+R+L4/S2pK/c9vJvrJ4S+btmdw+a7ZsHnFqpde5AmY4j0CWr/lgEo8j2o/Pcxke8x7du+xWX7r774iMIojStZV4YoK8+GZkPQaVYyO3GNirsyezpnykJXHoDVaC5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(478600001)(6666004)(2616005)(186003)(31686004)(41300700001)(26005)(5660300002)(6486002)(6512007)(86362001)(83380400001)(66476007)(66556008)(66946007)(4326008)(8676002)(8936002)(31696002)(38100700002)(53546011)(2906002)(36756003)(6916009)(6506007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjZ1NFgyTHFoam5IcDRudUV1WmRLZWtkSHkzbmxnNkZGK05LQWxvRHZLTCs4?=
 =?utf-8?B?ODdNMnVDYmFrTTZMUXZhWW4zZzdveCtqSDM3bWFYa0EvNlFIeXozWmJ0Z2k3?=
 =?utf-8?B?cGZPaTdXVHZkL3U0cDBTQ3JBN3EvY213MVUrRVhESXZVZk50US9zTlhiSkU4?=
 =?utf-8?B?UTFraExLaUR6WDhTL3RhaTNITnJXb3FJU3kzWW1RcW5sV0N0NWhiZ3hLRGtG?=
 =?utf-8?B?NWRaTnpCMVV3R3c4cEJCNS9va3JXb2lBK1FOU3ViVjU5R2FONjRaRVE2SDhM?=
 =?utf-8?B?cnN1TFlEeTM3MmkxTUVqZ0dVMUlzLys2c1NQajMwRXVFTm03K1dvZEkyTi9n?=
 =?utf-8?B?TVFWSnczN0hmVjZoUUJRMWlHV2RnWGwyTnZ0MWFITlUzSHJLNmpwOG8veXV6?=
 =?utf-8?B?RVRRdWRvM2E2MTVpby9hU2cwUWc2Q28xSS9qc01NV2s2bXk5UlBsWkdZcDFt?=
 =?utf-8?B?V3NFcVBVQ0U2eTZVTEpOR3ErN0hZdTVXaStxRC80NUlRVGNKdWM4bzRxQi9F?=
 =?utf-8?B?OStIdjNlb0s5SU9ROGRydzBqN2FGTnhzTE5JVmE1WmJqNEZGWFBtaDJxRUxX?=
 =?utf-8?B?T0tGQU1EbHdOeExyYmlCNFVJYVpvdkpkY2Vva1lwTC9pZGttSEp0OVlyMUtK?=
 =?utf-8?B?c3o1TDR1RHhSd1Fja3VMSWMzeE9XK1ZSNHE1R0lsdENxRStZY2gzcFd4R1lv?=
 =?utf-8?B?NWFnWjA0bVQ0K0haQlJEam13dnhBVmhkdzduOGJhVDIxWWlSdkpNcXRhRldr?=
 =?utf-8?B?dXdoZUk3dVNDU3oxSG1nYTlGOUE2LzZ6NFA5eUdjcGZxSEREeDVtcjZxZG0r?=
 =?utf-8?B?K042Ymcwd3EvRFdhdHpmSFlmV2RQbGJjMmU1cmRVcUlsSHA4RktmQWlTOHdD?=
 =?utf-8?B?WmVSSkE1VFY5bnpzVW5EcGkwb1hTNFBVQ0k1Q2lzdkZOZG12bHF0MlF4UWNB?=
 =?utf-8?B?UkZvWHFFc2FXQUh1cm1qcEZjcW50WkQ3OWRiek1ickRNNDZ4VW9ESFZhVkox?=
 =?utf-8?B?V3pCRVhBTVhNckxjK0JXYVlHTXp5RmFsTjExem5BekY5c2NaZzRpNWNlVEJi?=
 =?utf-8?B?VXJVTWNEQktqM25RcjkzOGJUSVEwZC9PMG10elk0ajJEVHpmdGhzRC8yVmVB?=
 =?utf-8?B?V3pnbmxreEFwYUlrcE15ZFlqU3Bhb2JwMkNCT1dCTEtmeXFiYVhTNGN2cElL?=
 =?utf-8?B?MnBqRmFxdU9lWDAzTmVQNE1PVmJoRHI5U1JYMnZVcitYWk9wK3lyYXJ0ZkRh?=
 =?utf-8?B?cXdwN0MyeVZ0Zm9iL1FhOW9GRklkMWlPbUtlTU5GOHNFMkNCSS8yZ0FZR0hn?=
 =?utf-8?B?bXA1ZjcvVzVLN2tkdjdWWTdmRGwyTCtEMTJxd29hbFRBWDJQN1dnb2RZRVNG?=
 =?utf-8?B?a2w2VDFmS1pmQXdnZ3U3TGVYdW54NU1rcVVsUnUrQXF5c3dCSTI2NlFtTkVt?=
 =?utf-8?B?eVk3cWtSbGpScTVrSDhWemJSV1dJRlk5T2dxaHlGanNzQ1F6bWpFdU53dDVE?=
 =?utf-8?B?TGNlbDg1QmJhQlVqWkVQekc2NjUyS3Z6Skxob0VXZ014MmhmRFFpb01TdW5D?=
 =?utf-8?B?cUJabldTSHJIYS9tUmQ5Q0tyZVBnZlhsdEc1R3BsK2pkQllFU2Y5SG5qRUZi?=
 =?utf-8?B?eStUQ3pCV3p4T3pmbmFXb2NOT0VLcWhkQ2llb3NvTXBuZ3FNT0pVeldaSmRs?=
 =?utf-8?B?Zlo5WnRWZHRoK3U5dmF0ZGVFcm13azI3UFkwdzVQd0QrZkVpZGltMlhnamJQ?=
 =?utf-8?B?d3cyd09UblZIMzdtMitDZmhTTHY5a0NHcGJXRXN0dGhpU0tKM2N4dG5SQlNy?=
 =?utf-8?B?RDhSdnY1Ui9jcXc3WC96c3A0czBwa25FZXQwSUM4cVRiM1lxNlg0allzQity?=
 =?utf-8?B?WjVkWFJRNzAzaHJ2K2gwdmg1RVFBZHFSVVU5aGlqNjNVWFBOdFhVZEJiMVV0?=
 =?utf-8?B?VW5iVjJGeWRING1idU5VRGlKVnpZaVIrdmxVb05lbnRLY3BPanZSZm1VUEdT?=
 =?utf-8?B?MDNwUHc4L1pHc2JlSmU5OVo2U3UwZWs4ZW1ScmRWUklta1B0VS9CVHFqS2Zh?=
 =?utf-8?B?QzBaS21TUEYyZVg2emxrSHZZWjYzQkFCdFVCdFh1M0ZGSTlsOFpBTVUrQi9y?=
 =?utf-8?Q?R5YoRJSGB/esq8Y8QnWfL+gU/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c66c18a-6ff5-43d3-9c3e-08da69364797
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 03:25:07.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4eeQnHxK1wo7e2JOiszGbEVlyTpbTSHaPfWy+B7N6oXInDNzwgKRGrf9wMDsN82klpUkaIAK608iEdDHbb82g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4797
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean,

On 7/19/2022 12:28 AM, Sean Christopherson wrote:
> On Mon, Jul 18, 2022, Suravee Suthikulpanit wrote:
>> The commit 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write
>> VM-Exits in x2APIC mode") introduces logic to prevent APIC write
>> for offset other than ICR. This breaks x2AVIC support, which requires
>> KVM to trap and emulate x2APIC MSR writes.
>>
>> Therefore, removes the warning and modify to logic to allow MSR write.
>>
>> Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
> 
> This tag is wrong, I believe it should be:
> 
>    Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
> 
> And that absolutely matters because this should not be backported to older
> kernels that don't support x2avic.

The commit 5413bcba7ed5 is the one that modifies the logic in the kvm_apic_write_nodecode().
I understand your point that the 5413bcba7ed is committed later than 4d1d7942e36a and being
affected by the change. However, if there is a case that only x2AVIC stuff is being backported
w/o the virtualize IPI stuff, then this fix is not needed. Hence, I would say the fix is for
the 5413bcba7ed5 as specified in the original patch.

>> .....
>>   		 */
>> -		if (WARN_ON_ONCE(offset != APIC_ICR))
>> +		if (offset == APIC_ICR) {
>> +			kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
>> +			trace_kvm_apic_write(APIC_ICR, val);
>>   			return;
>> -
>> -		kvm_lapic_msr_read(apic, offset, &val);
>> -		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
>> -		trace_kvm_apic_write(APIC_ICR, val);
>> +		}
>> +		kvm_lapic_msr_write(apic, offset, val);
> 
> Because this lacks the TODO below, what about tweaking this so that there's a
> single call to kvm_lapic_msr_write()?  gcc-11 even generates more efficient code
> for this.  Alternatively, the ICR path can be an early return inside a single
> x2APIC check, but gcc generate identical code and I like making x2APIC+ICR stand
> out as being truly special.

That sounds good.

> Compile tested only.
> 
> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Mon, 18 Jul 2022 10:16:02 -0700
> Subject: [PATCH] KVM: x86: Handle trap-like x2APIC accesses for any APIC
>   register
> 
> Handle trap-like VM-Exits for all APIC registers when the guest is in
> x2APIC mode and drop the now-stale WARN that KVM encounters trap-like
> exits only for ICR.  On Intel, only writes to ICR can be trap-like when
> APICv and x2APIC are enabled, but AMD's x2AVIC can trap more registers,
> e.g. LDR and DFR.
> 
> Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
> Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Zeng Guang <guang.zeng@intel.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/lapic.c | 21 ++++++++++-----------
>   1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9d4f73c4dc02..95bb1ef37a12 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2283,21 +2283,20 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>   	struct kvm_lapic *apic = vcpu->arch.apic;
>   	u64 val;
> 
> -	if (apic_x2apic_mode(apic)) {
> -		/*
> -		 * When guest APIC is in x2APIC mode and IPI virtualization
> -		 * is enabled, accessing APIC_ICR may cause trap-like VM-exit
> -		 * on Intel hardware. Other offsets are not possible.
> -		 */
> -		if (WARN_ON_ONCE(offset != APIC_ICR))
> -			return;
> -
> +	if (apic_x2apic_mode(apic))
>   		kvm_lapic_msr_read(apic, offset, &val);
> +	else
> +		val = kvm_lapic_get_reg(apic, offset);
> +
> +	/*
> +	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
> +	 * xAPIC, ICR writes need to go down the common (slightly slower) path
> +	 * to get the upper half from ICR2.
> +	 */
> +	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
>   		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
>   		trace_kvm_apic_write(APIC_ICR, val);
>   	} else {
> -		val = kvm_lapic_get_reg(apic, offset);
> -
>   		/* TODO: optimize to just emulate side effect w/o one more write */
>   		kvm_lapic_reg_write(apic, offset, (u32)val);
>   	}
> 
> base-commit: 8031d87aa9953ddeb047a5356ebd0b240c30f233
> --

Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Suravee
