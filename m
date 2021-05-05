Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FF9373668
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhEEIkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:40:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230490AbhEEIkE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:40:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620203947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FJa5ydz4i8EsQ94xAojwWDLMbwtwM5GZrOeFOOHVi0Q=;
        b=Rj8gXCOTJ754Uzvk6f3rULCqf4ldEneHAAJGQbCVO1KXOIq/6G5aeMBR+LoSmmJ6riO8Ih
        k586tWvzdQmdpbVvbtkdw+RA5QKb9h+UwIdMFECi3vfjzIGRUfqcObYcfSHIQACStTypGe
        LN9t6Kf8o8ev40mU8ssqa54WSRZzA1Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-I6fvURwCPU-TgJj8DuhLwg-1; Wed, 05 May 2021 04:39:06 -0400
X-MC-Unique: I6fvURwCPU-TgJj8DuhLwg-1
Received: by mail-ed1-f72.google.com with SMTP id q18-20020a0564025192b02903888712212fso486123edd.19
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 01:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FJa5ydz4i8EsQ94xAojwWDLMbwtwM5GZrOeFOOHVi0Q=;
        b=kU6VtORcmXRePqgYDloSGN73b+yWfiUqY6ZVrMNkT543y3fWfxVNt3Pjjtr/okKLck
         Y+EbDnS8IdaiZoI5hpQ/uAdsQeWpNRPmHi1uOxJzWncFY8JyTwINIbsxsJYxqsK8m5Se
         QHI28/ACHQq91+f+wc5UNOPsV00Gn+7mMBuGk0rHTJnUTJ6hwgiyqWV47R6qpdnv08EX
         rzLmXAeUjYSRd2+1LISdylq4n2jmoJHv9ZLJO0h5DN29XozDWjvcdZyB3vIGhAyC+Jsl
         jMxZBcgtrQwbAlUmRSfGqxQaj6U+wAM5OssL12J9RMOSYGZ+FR/ImWmVMeJcgVBJUOGy
         BilA==
X-Gm-Message-State: AOAM531OM6+WSuYZmgNR/jANSNWOwMBAckMfJiRSLYRRfc64gYx0wref
        9pvoNZLOCv8LWGLmEqTdPWYa7YalDrSVMBjlIUVpejezvmx63sV2d93Dy52Et9whXIB2G2ajT2f
        N1HfMWtb6kn+1
X-Received: by 2002:aa7:cd8b:: with SMTP id x11mr31387349edv.87.1620203945170;
        Wed, 05 May 2021 01:39:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3m+uU9dKkJ+kklt2l/bRewI7zVD5mVPNT92N2B523Npe0ogPIXLahfcu3CQ2Lheo+iDZpHQ==
X-Received: by 2002:aa7:cd8b:: with SMTP id x11mr31387324edv.87.1620203944991;
        Wed, 05 May 2021 01:39:04 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h27sm15807054edz.1.2021.05.05.01.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 01:39:04 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/4] KVM: nVMX: Always make an attempt to map eVMCS
 after migration
In-Reply-To: <d56429a80d9c6118370c722d5b3a90b5669e2411.camel@redhat.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
 <20210503150854.1144255-2-vkuznets@redhat.com>
 <d56429a80d9c6118370c722d5b3a90b5669e2411.camel@redhat.com>
Date:   Wed, 05 May 2021 10:39:03 +0200
Message-ID: <87a6p9y3q0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Mon, 2021-05-03 at 17:08 +0200, Vitaly Kuznetsov wrote:
>> When enlightened VMCS is in use and nested state is migrated with
>> vmx_get_nested_state()/vmx_set_nested_state() KVM can't map evmcs
>> page right away: evmcs gpa is not 'struct kvm_vmx_nested_state_hdr'
>> and we can't read it from VP assist page because userspace may decide
>> to restore HV_X64_MSR_VP_ASSIST_PAGE after restoring nested state
>> (and QEMU, for example, does exactly that). To make sure eVMCS is
>> mapped /vmx_set_nested_state() raises KVM_REQ_GET_NESTED_STATE_PAGES
>> request.
>> 
>> Commit f2c7ef3ba955 ("KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES
>> on nested vmexit") added KVM_REQ_GET_NESTED_STATE_PAGES clearing to
>> nested_vmx_vmexit() to make sure MSR permission bitmap is not switched
>> when an immediate exit from L2 to L1 happens right after migration (caused
>> by a pending event, for example). Unfortunately, in the exact same
>> situation we still need to have eVMCS mapped so
>> nested_sync_vmcs12_to_shadow() reflects changes in VMCS12 to eVMCS.
>> 
>> As a band-aid, restore nested_get_evmcs_page() when clearing
>> KVM_REQ_GET_NESTED_STATE_PAGES in nested_vmx_vmexit(). The 'fix' is far
>> from being ideal as we can't easily propagate possible failures and even if
>> we could, this is most likely already too late to do so. The whole
>> 'KVM_REQ_GET_NESTED_STATE_PAGES' idea for mapping eVMCS after migration
>> seems to be fragile as we diverge too much from the 'native' path when
>> vmptr loading happens on vmx_set_nested_state().
>> 
>> Fixes: f2c7ef3ba955 ("KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit")
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/nested.c | 29 +++++++++++++++++++----------
>>  1 file changed, 19 insertions(+), 10 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 1e069aac7410..2febb1dd68e8 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -3098,15 +3098,8 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>>  			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
>>  
>>  		if (evmptrld_status == EVMPTRLD_VMFAIL ||
>> -		    evmptrld_status == EVMPTRLD_ERROR) {
>> -			pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
>> -					     __func__);
>> -			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> -			vcpu->run->internal.suberror =
>> -				KVM_INTERNAL_ERROR_EMULATION;
>> -			vcpu->run->internal.ndata = 0;
>> +		    evmptrld_status == EVMPTRLD_ERROR)
>>  			return false;
>> -		}
>>  	}
>>  
>>  	return true;
>> @@ -3194,8 +3187,16 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>>  
>>  static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
>>  {
>> -	if (!nested_get_evmcs_page(vcpu))
>> +	if (!nested_get_evmcs_page(vcpu)) {
>> +		pr_debug_ratelimited("%s: enlightened vmptrld failed\n",
>> +				     __func__);
>> +		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> +		vcpu->run->internal.suberror =
>> +			KVM_INTERNAL_ERROR_EMULATION;
>> +		vcpu->run->internal.ndata = 0;
>> +
>>  		return false;
>> +	}
>
> Hi!
>
> Any reason to move the debug prints out of nested_get_evmcs_page?
>

Debug print could've probably stayed or could've been dropped
completely -- I don't really believe it's going to help
anyone. Debugging such issues without instrumentation/tracing seems to
be hard-to-impossible...

>
>>  
>>  	if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
>>  		return false;
>> @@ -4422,7 +4423,15 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>>  	/* trying to cancel vmlaunch/vmresume is a bug */
>>  	WARN_ON_ONCE(vmx->nested.nested_run_pending);
>>  
>> -	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
>> +	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
>> +		/*
>> +		 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
>> +		 * Enlightened VMCS after migration and we still need to
>> +		 * do that when something is forcing L2->L1 exit prior to
>> +		 * the first L2 run.
>> +		 */
>> +		(void)nested_get_evmcs_page(vcpu);
>> +	}
> Yes this is a band-aid, but it has to be done I agree.
>

To restore the status quo, yes.

>>  
>>  	/* Service the TLB flush request for L2 before switching to L1. */
>>  	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
>
>
>
>
> I also tested this and it survives a bit better (used to crash instantly
> after a single migration cycle, but the guest still crashes after around ~20 iterations of my 
> regular nested migration test).
>
> Blues screen shows that stop code is HYPERVISOR ERROR and nothing else.
>
> I tested both this patch alone and all 4 patches.
>
> Without evmcs, the same VM with same host kernel and qemu survived an overnight
> test and passed about 1800 migration iterations.
> (my synthetic migration test doesn't yet work on Intel, I need to investigate why)
>

It would be great to compare on Intel to be 100% sure the issue is eVMCS
related, Hyper-V may be behaving quite differently on AMD.

> For reference this is the VM that you gave me to test, kvm/queue kernel,
> with merged mainline in it,
> and mostly latest qemu (updated about a week ago or so)
>
> qemu: 3791642c8d60029adf9b00bcb4e34d7d8a1aea4d
> kernel: 9f242010c3b46e63bc62f08fff42cef992d3801b and
>         then merge v5.12 from mainline.

Thanks for testing! I'll try to come up with a selftest for this issue,
maybe it'll help us discovering others)

-- 
Vitaly

