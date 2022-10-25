Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B2460CBF6
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 14:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiJYMgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 08:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbiJYMgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 08:36:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676B51870BA
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 05:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666701397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tUt+Atlbv9mBHchyfuhO8p/3sEluMxkz1Bw4ADj6hzk=;
        b=UeobngdCgp7sKKgukP2+OypRfRX02ICLbWbJURc+oSRxIiNy4c8elYkZBLb9gfZzs3qbAo
        lnYq65B8PP0J7FAJY65r/X79LQlNdsGTXybTt/C8+TLHGesYitRaejF4HjkcmOXLSft5U1
        DryFC2RbX9E82lvEQk3qbp77qyECXp8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-479-ubhqs6lzMzy81nOwMaMWQg-1; Tue, 25 Oct 2022 08:36:36 -0400
X-MC-Unique: ubhqs6lzMzy81nOwMaMWQg-1
Received: by mail-qt1-f198.google.com with SMTP id e24-20020ac84918000000b0039878b3c676so8832758qtq.6
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 05:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tUt+Atlbv9mBHchyfuhO8p/3sEluMxkz1Bw4ADj6hzk=;
        b=wgrHpZHw4y/8EA0COT47BW6aKl9Oy3Fh0xocttFVn+d1pFsTPelarN7fGYvvtfY4B8
         9B7fem1OZXEEmdf2ZbWJhz3tDxGDis4Neh7MO7RPe1/nfeJkB/1JiwOmsRxGSwF3ZqyJ
         MuEVxnamCxxoMR40hmstrq9ipbV/5QNqqhdfBeohgOqHZOeGYP8LaFdvzS7xyfR6n+pB
         TscirGfNUj4QOPXbRqyjDygz3bI1VK2ijlUojTWqdchlQxJCbuD8FSPPjv1v6xhb2fEt
         vgyJ9y7qHKtd5lTD8D/SJttEf00rr71R4yFAa6mmX0zkFw58MsEKVjP3JJJFCJCqUm9h
         WsQA==
X-Gm-Message-State: ACrzQf0C4DlTrBxflYvUI3ysUWk6Nnbn6/2OVG/lXvVrvtXekLlD6hyS
        t2cDPg1Hnqe3Dkwgnwc1ZDkX2xWuaF9ucRB/jR7PtnK+39un8n+3vqw5kVPPv9Qr/WwBvXVAr+W
        1t39d2hBYiYJs
X-Received: by 2002:a05:622a:cc:b0:39c:deab:1e33 with SMTP id p12-20020a05622a00cc00b0039cdeab1e33mr31738238qtw.496.1666701395912;
        Tue, 25 Oct 2022 05:36:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6xDTDLn4DQBqnKeH/eDWYYXRUDy3GWhFH68bgSvidXDeuE6ed3+KJ5jAj0gEhOUbqx+bMkEA==
X-Received: by 2002:a05:622a:cc:b0:39c:deab:1e33 with SMTP id p12-20020a05622a00cc00b0039cdeab1e33mr31738217qtw.496.1666701395599;
        Tue, 25 Oct 2022 05:36:35 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id bi24-20020a05620a319800b006eeca296c00sm2005629qkb.104.2022.10.25.05.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 05:36:34 -0700 (PDT)
Message-ID: <71cd488d-5b4f-153d-bcd3-e38c6eedf4c6@redhat.com>
Date:   Tue, 25 Oct 2022 14:36:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: vmx/nested: avoid blindly setting
 SECONDARY_EXEC_ENCLS_EXITING when sgx is enabled
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Bandan Das <bsd@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20221024124845.1927035-1-eesposit@redhat.com>
 <Y1bCwpU4a+TZhRE1@google.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <Y1bCwpU4a+TZhRE1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 24/10/2022 um 18:52 schrieb Sean Christopherson:
> "nVMX" instead of "vmx/nested"
> 
> On Mon, Oct 24, 2022, Emanuele Giuseppe Esposito wrote:
>> Currently vmx enables SECONDARY_EXEC_ENCLS_EXITING even when sgx
>> is not set in the host MSR.
>> This was probably introduced when sgx was not yet fully supported, and
>> we wanted to trap guests trying to use the feature.
> 
> Nah, it's just a boneheaded bug.
> 
>> When booting a guest, KVM checks that the cpuid bit is actually set
>> in vmx.c, and if not, it does not enable the feature.
> 
> The CPUID thing is a red herring.  That's an _additional_ restriction, KVM honors
> MSR_IA32_VMX_PROCBASED_CTLS2 when configuring vmcs01.  See adjust_vmx_controls()
> for secondary controls in setup_vmcs_config().
> 
>> However, in nesting this control bit is blindly copied, and will be
> 
> It's not "copied", KVM sets the bit in the nVMX MSR irrespective of host support,
> which is the problem.
> 
>> propagated to VMCS12 and VMCS02. Therefore, when L1 tries to boot
>> the guest, the host will try to execute VMLOAD with VMCS02 containing
>> a feature that the hardware does not support, making it fail with
>> hardware error 0x7.
>>
>> According with section A.3.3 of Intel System Programming Guide,
>> we should *always* check the value in the actual
> 
> s/we/software
> 
>> MSR_IA32_VMX_PROCBASED_CTLS2 before enabling this bit.
>>
>> RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=2127128
>>
> 
> Fixes: 72add915fbd5 ("KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC")
> Cc: stable@vger.kernel.org
> 
>> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/nested.c | 22 ++++++++++++++++++++--
>>  1 file changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 8f67a9c4a287..f651084010cc 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -6678,6 +6678,25 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
>>  	return (u64)max_idx << VMCS_FIELD_INDEX_SHIFT;
>>  }
>>  
>> +/*
>> + * According with section A.3.3 of
> 
> Avoid referencing sections/tables by "number" in comments (and changelogs), as the
> comment is all but guaranteed to become stale because future versions of the SDM
> will shift things around.
> 
> The slightly more robust way to reference a specific SDM/APM section is to use the
> title, e.g. According to section "Secondary Processor-Based VM-Execution Controls"
> in Intel's SDM ...", as hardware vendors are less likely to arbitrarily rename
> sections and tables.  It's a bit more work for readers, but any decent PDF viewer
> can search these days.
> 
>> Intel System Programming Guide
> 
> KVM typically uses "Intel's SDM" (and "AMD's APM").  Like "VMX" or "SVM", it's ok
> to use the SDM acronym without introducing since "SDM" is 
> 
>> + * we *can* set the guest MSR control X (in our case
> 
> Avoid pronouns in comments.  "we" and "us" are ambiguous, e.g. "we" can mean KVM,
> the developer, the user, etc...
> 
>> + * SECONDARY_EXEC_ENCLS_EXITING) *iff* bit 32+X of
>> + * MSR_IA32_VMX_PROCBASED_CTLS2 is set to 1.
>> + * Otherwise it must remain zero.
> 
> As a general rule, if you find yourself writing a comment and a helper for
> something that KVM absolutely needs to get right (honoring VMX MSRs), then odds
> are very good that there's a simpler/easier fix, i.e. that you're effectively
> re-inventing part of the weel.
> 
>> + */
>> +static void nested_vmx_setup_encls_exiting(struct nested_vmx_msrs *msrs)
>> +{
>> +	u32 vmx_msr_procb_low, vmx_msr_procb_high;
>> +
>> +	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2, vmx_msr_procb_low, vmx_msr_procb_high);
>> +
>> +	WARN_ON(vmx_msr_procb_low & SECONDARY_EXEC_ENCLS_EXITING);
>> +
>> +	if (enable_sgx && (vmx_msr_procb_high & SECONDARY_EXEC_ENCLS_EXITING))
>> +		msrs->secondary_ctls_high |= SECONDARY_EXEC_ENCLS_EXITING;
>> +}
>> +
>>  /*
>>   * nested_vmx_setup_ctls_msrs() sets up variables containing the values to be
>>   * returned for the various VMX controls MSRs when nested VMX is enabled.
>> @@ -6874,8 +6893,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>>  		msrs->secondary_ctls_high |=
>>  			SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
>>  
>> -	if (enable_sgx)
>> -		msrs->secondary_ctls_high |= SECONDARY_EXEC_ENCLS_EXITING;
> 
> The issue here is that I, who wrote this code long, long ago, copied the pattern
> used for enable_unrestricted_guest, flexpriority_enabled, etc... without fully
> appreciating the logic.  Unlike those module params, enable_sgx doesn't track
> hardware support, i.e. enable_sgx isn't cleared when SGX can't be enabled due to
> lack of hardware support.  As a result, KVM effectively enumerates to L1 that the
> control is always available, i.e. that KVM emulates ENCLS-exiting for L1, but KVM
> obviously doesn't actually emulating the behavior.
> 
> Not updating enable_sgx is responsible for a second bug: vmx_set_cpu_caps() doesn't
> clear the SGX bits when hardware support is unavailable.  This is a much less
> problematic bug as as it only pops up if SGX is soft-disabled (the case being
> handled by cpu_has_sgx()) or if SGX is supported for bare metal but not in the
> VMCS (will never happen when running on bare metal, but can theoertically happen
> when running in a VM).
> 
> Last but not least, KVM should ideally have module params reflect KVM's actual
> configuration.
> 
> Killing all birds with one stone, simply clear enable_sgx when ENCLS-exiting isn't
> supported.  The #ifdef is a little gross, but I think it's marginally less ugly
> than having vmx.c define a dummy boolean.
> 
> Compile tested only...
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9dba04b6b019..65f092e4a81b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8263,6 +8263,11 @@ static __init int hardware_setup(void)
>         if (!cpu_has_virtual_nmis())
>                 enable_vnmi = 0;
>  
> +#ifdef CONFIG_X86_SGX_KVM
> +       if (!cpu_has_vmx_encls_vmexit())
> +               enable_sgx = false;
> +#endif
> +
>         /*
>          * set_apic_access_page_addr() is used to reload apic access
>          * page upon invalidation.  No need to do anything if not
> 

Thanks for all the suggestions and explanations, I am going to apply
your changes and send v2!

Emanuele

