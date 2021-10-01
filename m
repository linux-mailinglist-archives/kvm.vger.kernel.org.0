Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D8C41F2A6
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 19:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354259AbhJARIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 13:08:09 -0400
Received: from mail-sn1anam02on2049.outbound.protection.outlook.com ([40.107.96.49]:17260
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231925AbhJARII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 13:08:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCcD/F6C4THYFh/cusJJc5qlWAmwFYSRHY6WnScd/dsw+TYaWZ2J4dt5XuCfV4fzyTIyOyHfkA26YNgtqYmG389xDycTPrX6+L9ZrTSSMfgBMc/h8883azRWtNCm3IMuvF81/77rvXuqI26TRC9EJ7yuteDBzRYdQeMPCN0eqTrN4V9RaI3WczDdBJ7OSNxuiY48bhUxOKfh+muQs3bYVt1KGJ9yCC3H4nDbq+I5PAxJNykTc91aVR3Z4jpDw0lWOEJbB/POKp7OJD4oVeA8X5R54XWMTvJMlR7fSAepCMzxVD5P/aC5D1I9nis8S9syT0aiA2sfzpFS7vbv/x4mtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqJdkPc8mU6J0O29xVgf30ebWxk4DdqbNh6EIKKJJ18=;
 b=AXYX0XblbXUs/U39vcCCUfYzAe3MQ4Yv10pL8yNZu6ju06Z7ToUU9KyiNCqLMFDtFljDXVmchE0jsZD774xQDM3E4ubDTuzhOOIZO6/R3EqwbZzShaMFOttmYcxAPa1Y7QoBxqC9wCW/deaKyog8DvGlz6H3wXs4GO7UmyhH/Frrncg2gDaa+4isBY5uqDib1fNrlUo0mPcq0V8AwhfwDXzadeVwBjoouOEb6RUz6Sx3h6dUDpcfkGd48sz37eikh7dQSHgsM82vfQyt4m4ofNg0/80IZVlNk996TUQgYTenmwGAiKfE4Z+L5kOIGLjQFPW5uqU0P69qsCfsi3GGHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqJdkPc8mU6J0O29xVgf30ebWxk4DdqbNh6EIKKJJ18=;
 b=nlbjtlw5E18tBWVZAYbMBTKIWgApVmdKJxfbtrXiq/7CQfwrEReVCgjUZ2mjBo3B98UqcaOSeSm1ZyeQjlLhtHhRCQEpdVPumrI7aYu8lYa3PEqsVm92Pk+jMamyIKNgRV3RIlFhnGhtxEVR+3UoVXeqgAj9Fk8KjtEyGNa1p/Y=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Fri, 1 Oct
 2021 17:06:22 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%7]) with mapi id 15.20.4544.022; Fri, 1 Oct 2021
 17:06:21 +0000
Subject: Re: [PATCH v2] KVM: x86: Assume a 64-bit hypercall for guests with
 protected state
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <e0b20c770c9d0d1403f23d83e785385104211f74.1621878537.git.thomas.lendacky@amd.com>
 <87cztf8h43.fsf@vitty.brq.redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3b8953c9-0611-27da-f955-c79a6fcef9ce@amd.com>
Date:   Fri, 1 Oct 2021 12:06:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <87cztf8h43.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0107.namprd13.prod.outlook.com
 (2603:10b6:806:24::22) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9PR13CA0107.namprd13.prod.outlook.com (2603:10b6:806:24::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Fri, 1 Oct 2021 17:06:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a32a7bb9-7e93-45cf-710b-08d984fdcb08
X-MS-TrafficTypeDiagnostic: DM6PR12MB5565:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB55659B661AB66FC316F2B996ECAB9@DM6PR12MB5565.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nec7gs/LHFEMbxT1M+4T6A+sLfGUhBrtSHMm62TwuF5tC06RTRVB5LnIJZdmu7og0m6np9uFu1X03S00dzw23XyTZSK3TnWPh9I5WVR7vD6IgQLw1wrHRI/H7N1YwA+aGgMH06iJAx0zSXRUd5kvJEGjgpXQLsmZD2jpHIZPP0bDh3bZ4jQ6Dj/hIGNk0Zv8re9WjFiI86wyQj2cSqm8OImpyfLYHq899QgWjJxYlFrG0NOEcSvEjSp9AC0V+SYB2yux2xSm6+rpbSR16TmKLT0AUdBLwt+VM4giMx6nlhElOsAxHmUE8H3XtLV24qC2dSG8akLpCFCQDt6YFywPE5t0VRwNJnrJnOXbWBaDxGcFoFYi/QqzERcOV968CRAvx5kvRNYc0MW02wBgHE+io0qRs8SQhK3UQwyL6oxD0Ydy0uPmp96zwFPzFBkB9JLPCROP/WSFTjyZock9SpcuVjciN2z/65FaZ2/Ku8/w53IIqjDoIpKWrh8EFDm77cOhhLm7sAxocXlVpT2l2PfaDOCChyLiGezHbMHYgnzEi0DYloIBVeLkYJ0MRQ6PB6/7hGB3mf4yIjKnFfYEBE3u/zQNfnPfqopMzmYqPmSGzYTnKX7BpMiuMXg6qqHOcLiErM+tMPciUCYo8aCmoxtgzVHkwo5OQqm69yycghPykt09zhbH9jRZsNUJT4ek9Ive7c3goWkKrpxEfXMU0K0RkxWJ+4dMQN+NCh5MAWvipghauhxBQycYe0eCLjNi/iIt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(956004)(7416002)(31686004)(316002)(31696002)(26005)(2616005)(6486002)(508600001)(4326008)(66476007)(8676002)(86362001)(83380400001)(2906002)(36756003)(8936002)(6512007)(54906003)(6506007)(53546011)(66946007)(5660300002)(66556008)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWV2TlFFSXFWeUF3SGVjZnJ4aXh6SklpNHhwaUNuQmpqMFdudzkrVUV1ZUh3?=
 =?utf-8?B?S3FOZWJtV2tKNEdpeUNnSUlTdmxmQlE4Ymw5UVFVelhwNm53eG4xYmo1cnpE?=
 =?utf-8?B?YkNTLzBmQ0tGVDM3WHV1UFI3UFpxL3JtSCs0cXlpb0ViVGo5NE44Q0NqZ092?=
 =?utf-8?B?aCs3VEF0aHpJN3ZLVUYvWHhORHQ3OVYrU2xLWW9zN2lCeEZzR0ZvUWIyb2V5?=
 =?utf-8?B?Uk1XaWM5dVBNa0d5cnVmY2dIekw3ZzVmN2ZnbER5b3RXQzhuRUZKcjUyeHpw?=
 =?utf-8?B?MGhFSUJrUTNnRmhRUWI2S2RrZkMwN0N3ZkNycGFMUXRCYnprVDlZdU1XOGR4?=
 =?utf-8?B?S1hZMXRMUW9vSlRRUlZkS0ZDV3ROVnRHSlFON1R6NHJ5YUhHam5nanE3MEVB?=
 =?utf-8?B?cGFpUkV0VmovK0VqcEJDZlBMbTl5SktRaGZiNk1iYUk4VklyaU5DR2RiakEw?=
 =?utf-8?B?S0RIZmd1bUgranBtLzg5R2FDOW0yVWNhVC80VVZvTWs0UTZoZ2FqckUrdzVi?=
 =?utf-8?B?Z3YrL3J1Nzh1cTkySnRiRE9DeGhlRnpWWno5U2ZEeWNVU2dWSFJtZ1FLWjNs?=
 =?utf-8?B?RWhsZzUvYnYwYUlhNEVQT2FuTjliaC9JbmlUMFF1aDVRbHhzYkpveStDZ2ND?=
 =?utf-8?B?bE5xaDJnbS84b0QrbVU5bDU2eDQrZXhjbTI1aTZZZ29UVGxZTGdaSjBHUzkx?=
 =?utf-8?B?eDZOcGxPc3JRcEM5aDVhYzFKLzZZTUpCaUJSU01SWjhrRlZzQmVURHV5aXRq?=
 =?utf-8?B?OStTS1hoWDI1RzM1Q0tUTW1XTE1VVktZUHNTdEFyNjZDREZiMGgxamRBTkdN?=
 =?utf-8?B?dFVycUhmVWdUbGV2eW9PN2dwaGVoT2V0cUVSQWl5VGtqOUlXRmFoeE1Sd25S?=
 =?utf-8?B?ZWxaK3oyNnZzLzdOV3p1ZkkrNGJ1UXF4NjY2MmtsMldUVUxtTTBNMThlRTFY?=
 =?utf-8?B?OTkwZXpqVm8vOXZoV01QYy9hTFRST2hLOFMzbGRFR1FxaiszL281c0RTVmRo?=
 =?utf-8?B?YzZNWElCRndEMkR1RkNOQmRpTHBpWnhqZTFPaERSVHBpSWp2VGxYTnNtcVJy?=
 =?utf-8?B?eFR6eGQranhUbFphYUdIeEk5eDNwYlJRV0JoRUJSWmlsRDhCekUra3JwZEZt?=
 =?utf-8?B?UGM3U091Y1E5SnR2dURVNmd6NDlqT0lSVUVrS2k0N0luRmk4RmJ2eDY1eUNV?=
 =?utf-8?B?K2lVZ0U3TGFFc1dXUXhIZXZ4YjNaUGFvblNTZEVzeWpRQXVhL3J1d1RPWm5L?=
 =?utf-8?B?M0Rmbjg5QmdOa1FpM1U3ZFRzWm9LRVhhNEFiL0lKM29UU1R3TGw5M1JKY3Vn?=
 =?utf-8?B?UWdwdHlPbFg4OUdxdld5QmFJOVNiWGhKelZWbTVOd1lYaFRVYkNEYzUvc1Q4?=
 =?utf-8?B?cUxJN1lramUzRzFPK0ovbVROOGs1NU9nZWNYNVdBbSt3Ym9zL3FyTWR5ZXpM?=
 =?utf-8?B?OEp0K1N0NVEvZ0FoNXJQYVE0QlVsMzhNSHZBbHVvVnN4b0UrMmwySGh1VXor?=
 =?utf-8?B?anA1ckJXS21FSllKdmpOM0x2ZkRIMExrbWJVL3FkZmdYUGliUVVYT3UrRmdx?=
 =?utf-8?B?TmFNTzRvZGpiaUpHQkFaUFRiVTY4djR1Y1phSDVRdzhSK0RCR0pNTkdpRkJs?=
 =?utf-8?B?cUhSR0ZCa3doMkdjT0x4UjQ0UmE2NzNxeWpqcEl2Wk9oekpKNW1ITmJGV2Nw?=
 =?utf-8?B?QWZHcVBkbkowdGMvR1k1T3lBODdjdE5rNVZXc2FHcUtSVXNic2JMM1QvdWxl?=
 =?utf-8?Q?iHI2az5ecWr+c1oOM5N214ELrPSa1Y0IloshGXt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a32a7bb9-7e93-45cf-710b-08d984fdcb08
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 17:06:21.8830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ag5yK9J/HC6Mb/lfu73+FO8mvhp8TpnF9yBn+giKPII/how/5prgEva2OePKlP24NobRPWPjiDTiO7CQfrvqtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5565
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/21 1:25 AM, Vitaly Kuznetsov wrote:
> Tom Lendacky <thomas.lendacky@amd.com> writes:
> 
>> When processing a hypercall for a guest with protected state, currently
>> SEV-ES guests, the guest CS segment register can't be checked to
>> determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
>> expected that communication between the guest and the hypervisor is
>> performed to shared memory using the GHCB. In order to use the GHCB, the
>> guest must have been in long mode, otherwise writes by the guest to the
>> GHCB would be encrypted and not be able to be comprehended by the
>> hypervisor.
>>
>> Create a new helper function, is_64_bit_hypercall(), that assumes the
>> guest is in 64-bit mode when the guest has protected state, and returns
>> true, otherwise invoking is_64_bit_mode() to determine the mode. Update
>> the hypercall related routines to use is_64_bit_hypercall() instead of
>> is_64_bit_mode().
>>
>> Add a WARN_ON_ONCE() to is_64_bit_mode() to catch occurences of calls to
>> this helper function for a guest running with protected state.
>>
>> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
>> Reported-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>
>> Changes since v1:
>> - Create a new helper routine, is_64_bit_hypercall(), and use it in place
>>    of is_64_bit_mode() in hypercall related areas.
>> - Add a WARN_ON_ONCE() to is_64_bit_mode() to issue a warning if invoked
>>    for a guest with protected state.
>> ---
>>   arch/x86/kvm/hyperv.c |  4 ++--
>>   arch/x86/kvm/x86.c    |  2 +-
>>   arch/x86/kvm/x86.h    | 12 ++++++++++++
>>   arch/x86/kvm/xen.c    |  2 +-
>>   4 files changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index f98370a39936..1cdf2b213f41 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1818,7 +1818,7 @@ static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
>>   {
>>   	bool longmode;
>>   
>> -	longmode = is_64_bit_mode(vcpu);
>> +	longmode = is_64_bit_hypercall(vcpu);
>>   	if (longmode)
>>   		kvm_rax_write(vcpu, result);
>>   	else {
>> @@ -1895,7 +1895,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>>   	}
>>   
>>   #ifdef CONFIG_X86_64
>> -	if (is_64_bit_mode(vcpu)) {
>> +	if (is_64_bit_hypercall(vcpu)) {
>>   		param = kvm_rcx_read(vcpu);
>>   		ingpa = kvm_rdx_read(vcpu);
>>   		outgpa = kvm_r8_read(vcpu);
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 9b6bca616929..dc72f0a1609a 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -8403,7 +8403,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>   
>>   	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>>   
>> -	op_64_bit = is_64_bit_mode(vcpu);
>> +	op_64_bit = is_64_bit_hypercall(vcpu);
>>   	if (!op_64_bit) {
>>   		nr &= 0xFFFFFFFF;
>>   		a0 &= 0xFFFFFFFF;
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 521f74e5bbf2..3102caf689d2 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -151,12 +151,24 @@ static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
>>   {
>>   	int cs_db, cs_l;
>>   
>> +	WARN_ON_ONCE(vcpu->arch.guest_state_protected);
>> +
>>   	if (!is_long_mode(vcpu))
>>   		return false;
>>   	static_call(kvm_x86_get_cs_db_l_bits)(vcpu, &cs_db, &cs_l);
>>   	return cs_l;
>>   }
>>   
>> +static inline bool is_64_bit_hypercall(struct kvm_vcpu *vcpu)
>> +{
>> +	/*
>> +	 * If running with protected guest state, the CS register is not
>> +	 * accessible. The hypercall register values will have had to been
>> +	 * provided in 64-bit mode, so assume the guest is in 64-bit.
>> +	 */
>> +	return vcpu->arch.guest_state_protected || is_64_bit_mode(vcpu);
>> +}
>> +
>>   static inline bool is_la57_mode(struct kvm_vcpu *vcpu)
>>   {
>>   #ifdef CONFIG_X86_64
>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>> index ae17250e1efe..c58f6369e668 100644
>> --- a/arch/x86/kvm/xen.c
>> +++ b/arch/x86/kvm/xen.c
>> @@ -680,7 +680,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>>   	    kvm_hv_hypercall_enabled(vcpu))
>>   		return kvm_hv_hypercall(vcpu);
>>   
>> -	longmode = is_64_bit_mode(vcpu);
>> +	longmode = is_64_bit_hypercall(vcpu);
>>   	if (!longmode) {
>>   		params[0] = (u32)kvm_rbx_read(vcpu);
>>   		params[1] = (u32)kvm_rcx_read(vcpu);
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> Thanks!

Paolo,

This got lost in my stack of work... any comments?

Thanks,
Tom

> 
