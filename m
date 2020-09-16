Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7CD26CC60
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgIPUnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:43:01 -0400
Received: from mail-eopbgr760075.outbound.protection.outlook.com ([40.107.76.75]:2996
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726684AbgIPRD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 13:03:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQ4U5BpLYuN6jxoE+dARz5sbKJqxdjVGp9wtmqgGFWCkeWa/m0tKl/W+8Mq30L6q9GIIMnuAGO3gnb8AUc2pXPzdctdoRpSOM3qgUwuVZG4VpmREL7/bm3oHUpincz1QII8JQo7DSve4NkAIAvJekJBpXJcoZtIfBOzBL7rskerZM1E9gbC+NcDmRACSe9VVPtOPmtgimnl5UbxQXKfK54y1ZQnO7O8U16YkNPs9pdmQRLrWs+r+rh1IeSaZNvQwAshkqVoR46ruSRh4sIPrlVSS6B4nxECe/1DoZQK0ecr4qN+N+Xw/0ScVHJQRS06fE0xYor5+4Hxi1exRiBCgVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpSKRM86ioPT+pZyiHT/v1eK3w3T8dXlIppSo7nRgcc=;
 b=BFekCLM8qNDo5lvfeZ4eQOSPIZS/wz/8RalHtUyRHWD1SDcKrwOAjURnRf+FbidyZIEIx4HQNt1A44kcPRzbR6fl/aPuH3qF82py5bQYFH6ep2aaJ64RY/lH9pSQIpkwqE8BIlGfNJ4n0bQDa83WoctmRe8rTg8Qia/6YT1n7XhaLe6LhAUQTYj4oUFBILGeT6hWfTJ2Ui0oWG1nBGkrGiPRsDf38grmMcjvv0RJiYBC450n5jnFsEWtTmca9bZt8sI11uSVaNQl0kKvzd9/RHmQ4le7H9MN9dV9a4QnsGeUMiv75qrCtf3HVeZscvFOM60VgbWaRc95LsYl6YBtMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpSKRM86ioPT+pZyiHT/v1eK3w3T8dXlIppSo7nRgcc=;
 b=KxYQ4jOKvW0ozOFxCc2n03PA/9KDk16J5wlZsyyN8kH3riECnnZfjMTWLyHiRBeCZEus+cJHGme4GtEkSapOV+u6cvE9XvXl/Cmx298L/BRUNlNQkrliijQpyYTuIHAHcoO7YErWrgO9RTyPsbnb3niM8WdsHUVE55ORY+Y132Q=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2826.namprd12.prod.outlook.com (2603:10b6:5:76::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Wed, 16 Sep 2020 16:22:45 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 16:22:45 +0000
Subject: Re: [RFC PATCH 11/35] KVM: SVM: Prepare for SEV-ES exit handling in
 the sev.c file
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <e754f4a93c1d8d30612b7b954b043ea9b92519ab.1600114548.git.thomas.lendacky@amd.com>
 <20200915172148.GE8420@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <f2a778f6-f086-9a12-0caa-ee23ac4a517c@amd.com>
Date:   Wed, 16 Sep 2020 11:22:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200915172148.GE8420@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:3:115::29) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR11CA0019.namprd11.prod.outlook.com (2603:10b6:3:115::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Wed, 16 Sep 2020 16:22:45 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f0eb815-d47c-4466-623e-08d85a5cbeb0
X-MS-TrafficTypeDiagnostic: DM6PR12MB2826:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB282680A1902DB0762ECC1AAAEC210@DM6PR12MB2826.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NqkGbnPi48WZjGbnIA3hKu08tmQCNvK68kAgH7AFtMEA+5+YY5VMXPomjhlOIOrtrtCBHRW5n+oD91FKYqVAZTaZmusRQfjicROWJ+UEf43QtIiLigRHXx+5XTCkcgvT2CSePma0pu+GJfAhA6OXgqVhBFG70zM6Ui8rK6+F3uXW0j5cDtbGO0379QPsogNoo+jN5d3pPjlX5AO2XXNH3jM5c8OvaLpZTStfHUMXMDZytQ8a6jzfM1WCBq0xJpqaukl7sKJWB2PtAokpi2nbr6hQc2hkgj4J8T9MqDDb3kfaEL17ujyeAibjWC+9AQgn4b00FviOff6Rq7HK25nYsJe/soWRy8V/jG/768uOQVf0xXKSf9NbiW2OiGEZsJi+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(6486002)(53546011)(4326008)(8676002)(54906003)(7416002)(6916009)(83380400001)(66946007)(956004)(31686004)(186003)(26005)(8936002)(31696002)(66476007)(2906002)(16526019)(36756003)(316002)(86362001)(478600001)(16576012)(5660300002)(66556008)(2616005)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WN6bEMjaaAhzfECm974pJTQY2RqIg18QCk3CXMQy8XTgUD4RIUbWs9PgwX5ccbS5lRI7YgSpYOkTvXc5qATEeBDZPjUT9ursND6G12corv0LKnD6BqU4pTXW2sGGV3Hhb8C3iiRtYJtnL6tQdQNYx0LoFR6YmOBZKfZ54bi8+33ykvFQih0duTtRc3IXjTm8iUJ57+aEuLilv0uTEhZ7Nj85RavpnQa4nhCjplVZsCpIlqCUTUQcD0ej+9mzObQ4nfWLwfRtrIfJIvHFdnWzl3pO9sK5WvXamr+xq7AjTHp0HjvjHBepKxcgsbSg1YmwJzUvixgkWDGtGDC35sy0s+i3xXymSBx794KWQlRhjT3CXeFN79NhuuF1e40DBst1T+HCQTM7Cbyx0wu7k84F/Aa5JVcz0qHK3fdWqSl/liZuXWSx44g7z7ezHx/wj8+K/drCMjd1GwD/U7g4+2yENp6Uzcnl4eRy2zattl3nh1zIEXshuES7I3OOwEBKvT25yk1ST0k6SBA89eHlwRjVlz7QNjuiP+BQJRWOwxXIXDGLP/v/fbpDF5A/h0LxBJVFvDHiHad1LPWLdL1BdLxQ88/7RJYBfp0/ut5HwpIahCnijd52sfU5t98DUXZM0aSMfVC1MUzgahMvAQxr3Fi3Ug==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f0eb815-d47c-4466-623e-08d85a5cbeb0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 16:22:45.8035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6YgVPIHUpoBiGrKjpR+GPZ/KH02HpbTk1a1qNQHN0xOKWU1JC08tMShhUeBHwNAFci44DugyPPWV4LHETgZNrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2826
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/20 12:21 PM, Sean Christopherson wrote:
> On Mon, Sep 14, 2020 at 03:15:25PM -0500, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> This is a pre-patch to consolidate some exit handling code into callable
>> functions. Follow-on patches for SEV-ES exit handling will then be able
>> to use them from the sev.c file.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/kvm/svm/svm.c | 64 +++++++++++++++++++++++++-----------------
>>  1 file changed, 38 insertions(+), 26 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index f9daa40b3cfc..6a4cc535ba77 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3047,6 +3047,43 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>>  	       "excp_to:", save->last_excp_to);
>>  }
>>  
>> +static bool svm_is_supported_exit(struct kvm_vcpu *vcpu, u64 exit_code)
>> +{
>> +	if (exit_code < ARRAY_SIZE(svm_exit_handlers) &&
>> +	    svm_exit_handlers[exit_code])
>> +		return true;
>> +
>> +	vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
>> +	dump_vmcb(vcpu);
>> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
>> +	vcpu->run->internal.ndata = 2;
>> +	vcpu->run->internal.data[0] = exit_code;
>> +	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> 
> Based on the name "is_supported_exit", I would prefer that vcpu->run be filled
> in by the caller.  Looking at the below code where svm_is_supported_exit() is
> checked, without diving into the implementation of the helper it's not at all
> clear that vcpu->run is filled.
> 
> Assuming svm_invoke_exit_handler() is the only user, it probably makes sense to
> fill vcpu->run in the caller.  If there will be multiple callers, then it'd be
> nice to rename svm_is_supported_exit() to e.g. svm_handle_invalid_exit() or so.

Will change.

> 
>> +
>> +	return false;
>> +}
>> +
>> +static int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
>> +{
>> +	if (!svm_is_supported_exit(&svm->vcpu, exit_code))
>> +		return 0;
>> +
>> +#ifdef CONFIG_RETPOLINE
>> +	if (exit_code == SVM_EXIT_MSR)
>> +		return msr_interception(svm);
>> +	else if (exit_code == SVM_EXIT_VINTR)
>> +		return interrupt_window_interception(svm);
>> +	else if (exit_code == SVM_EXIT_INTR)
>> +		return intr_interception(svm);
>> +	else if (exit_code == SVM_EXIT_HLT)
>> +		return halt_interception(svm);
>> +	else if (exit_code == SVM_EXIT_NPF)
>> +		return npf_interception(svm);
>> +#endif
>> +	return svm_exit_handlers[exit_code](svm);
> 
> Now I see why kvm_skip_emulated_instruction() is bailing on SEV-ES guests,
> #VMGEXIT simply routes through the legacy exit handlers.  Which totally makes
> sense from a code reuse perspective, but the lack of sanity checking with that
> approach is undesirable, e.g. I assume there are a big pile of exit codes that
> are flat out unsupported for SEV-ES, and ideally KVM would yell loudly if it
> tries to do skip_emulated_instruction() for a protected guest.
> 
> Rather than route through the legacy handlers, I suspect it will be more
> desirable in the long run to have a separate path for #VMGEXIT, i.e. a path
> that does the back half of emulation (the front half being the "fetch" phase).

Except there are some automatic exits (AE events) that don't go through
VMGEXIT and would need to be sure the RIP isn't updated. I can audit the
AE events and see what's possible.

Additionally, maybe just ensuring that kvm_x86_ops.get_rflags() doesn't
return something with the TF flag set eliminates the need for the change
to kvm_skip_emulated_instruction().

> 
> The biggest downsides would be code duplication and ongoing maintenance.  Our
> current approach for TDX is to eat that overhead, because it's not _that_ much
> code.  But, maybe there's a middle ground, e.g. using the existing flows but
> having them skip (heh) kvm_skip_emulated_instruction() for protected guests.
> 
> There are a few flows, e.g. MMIO emulation, that will need dedicated
> implementations, but I'm 99% certain we can put those in x86.c and share them
> between SEV-ES and TDX.
>  
> One question that will impact KVM's options: can KVM inject exceptions to
> SEV-ES guests?  E.g. if the guest request emulation of a bogus WRMSR, is the
> #GP delivered as an actual #GP, or is the error "returned" via the GHCB?

Yes, for SEV-ES guest, you can inject exceptions. But, when using VMGEXIT
for, e.g. WRMSR, you would pass an exception error code back to the #VC
handler that will propagate that exception in the guest with the registers
associated with the #VC.

Thanks,
Tom

> 
> The most annoying hiccup is that TDX doesn't use the "standard" GPRs, e.g. MSR
> index isn't passed via ECX.  I'll play around with a common x86.c
> implementation to see how painful it will be to use for TDX.  Given that SEV-ES
> is more closely aligned with legacy behavior (in terms of registers usage),
> getting SEV-ES working on a common base should be relatively easy, at least in
> theory :-).
> 
