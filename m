Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E8637B6B5
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 09:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhELHQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 03:16:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56633 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230011AbhELHQJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 May 2021 03:16:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620803701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AXFTE7PJi+lvpeYy5c9eIvb8OVfNqNtGNLIpDwSvSsI=;
        b=C+M32w6C/sZGuOZlYxaAIvXAVoEOZMDPQQpMk+EOt8SJeQLXubfwQWsgnZ1FQBj6oNl8r0
        v224HGkj9cIuyKoI+q3xMSmYR/WtuTJreHyfCtYlB77ma+MBxv1BRqodCU5k5t5sL4Vqny
        xe1Cy2TY5cYYIg14fPqlRhdbfU7/lRM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-T-iA5wemPfeuPeafreUWZA-1; Wed, 12 May 2021 03:14:59 -0400
X-MC-Unique: T-iA5wemPfeuPeafreUWZA-1
Received: by mail-wm1-f69.google.com with SMTP id l185-20020a1c25c20000b029014b0624775eso205861wml.6
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 00:14:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AXFTE7PJi+lvpeYy5c9eIvb8OVfNqNtGNLIpDwSvSsI=;
        b=PD1uyCkJYywFvjc5H6D4eEIXeVx/eA7mOalVVdm4iIPj3EbsukSfVWJjGl2gTvlR+n
         21G9qbDs8rtnYMHcs7W5LzckJmyp+C7sFW36vWC/+TFojMGer1fuk8FCsoOAV9okNA+S
         83e16dEbYXDCgrplaspBql5jPgFS5tivK/56EHesaFa2RTIjk4J9TwG7gS7YupmTFr1E
         DobFby3L6CgzzFM/WRNnbo4CQ3M6XFtI6Mhq7mQmJtwBDysbyWdlSvcZ7oQjWzRf61dQ
         7Dg2nr7O5fCAM7YZIswkJ88ZfLaDmxDXi2iB5dysNNy/DD/DtYk2i/nsZzseoNsnEAzC
         4myA==
X-Gm-Message-State: AOAM532om1RJHB0teFhlO53XkaUh/dkqJfn406l2ugcCglQ/UW3QOb2N
        k4aD36DmhTKY3cd7BKRtVt0j2jvKujnYaDhnJXHvv6pOCb4GRRwfTHA3tzzRYSAn2BXEs4coZpA
        o1So0BG45iw00
X-Received: by 2002:adf:e8c4:: with SMTP id k4mr43671531wrn.262.1620803698478;
        Wed, 12 May 2021 00:14:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8+TpIL+jbLqGy87WoayUMJGUDPjdx9/HH0UWUN15jKA6+I25Ud6sP1w0JPnCCEngQeZpc9A==
X-Received: by 2002:adf:e8c4:: with SMTP id k4mr43671513wrn.262.1620803698277;
        Wed, 12 May 2021 00:14:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r7sm23718330wmq.18.2021.05.12.00.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 00:14:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 3/7] KVM: nVMX: Ignore 'hv_clean_fields' data when eVMCS
 data is copied in vmx_get_nested_state()
In-Reply-To: <YJqytyu7+Q7+bqeG@google.com>
References: <20210511111956.1555830-1-vkuznets@redhat.com>
 <20210511111956.1555830-4-vkuznets@redhat.com>
 <YJqytyu7+Q7+bqeG@google.com>
Date:   Wed, 12 May 2021 09:14:56 +0200
Message-ID: <87eeecwhhr.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, May 11, 2021, Vitaly Kuznetsov wrote:
>> 'Clean fields' data from enlightened VMCS is only valid upon vmentry: L1
>> hypervisor is not obliged to keep it up-to-date while it is mangling L2's
>> state, KVM_GET_NESTED_STATE request may come at a wrong moment when actual
>> eVMCS changes are unsynchronized with 'hv_clean_fields'. As upon migration
>> VMCS12 is used as a source of ultimate truce, we must make sure we pick all
>> the changes to eVMCS and thus 'clean fields' data must be ignored.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/nested.c | 43 +++++++++++++++++++++++----------------
>>  1 file changed, 25 insertions(+), 18 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index ea2869d8b823..7970a16ee6b1 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -1607,16 +1607,23 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
>>  	vmcs_load(vmx->loaded_vmcs->vmcs);
>>  }
>>  
>> -static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
>> +static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, bool from_vmentry)
>>  {
>>  	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
>>  	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
>> +	u32 hv_clean_fields;
>>  
>>  	/* HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE */
>>  	vmcs12->tpr_threshold = evmcs->tpr_threshold;
>>  	vmcs12->guest_rip = evmcs->guest_rip;
>>  
>> -	if (unlikely(!(evmcs->hv_clean_fields &
>> +	/* Clean fields data can only be trusted upon vmentry */
>> +	if (likely(from_vmentry))
>> +		hv_clean_fields = evmcs->hv_clean_fields;
>> +	else
>> +		hv_clean_fields = 0;
>
> ...
>
>> @@ -3503,7 +3510,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>>  		return nested_vmx_failInvalid(vcpu);
>>  
>>  	if (vmx->nested.hv_evmcs) {
>> -		copy_enlightened_to_vmcs12(vmx);
>> +		copy_enlightened_to_vmcs12(vmx, true);
>
> Rather than pass a bool, what about having the caller explicitly specify the
> clean fields?  Then the migration path can have a comment about needing to
> assume all fields are dirty, and the normal path would be self-documenting.
> E.g. with evmcs captured in a local var:
>
> 	if (evmcs) {
> 		copy_enlightened_to_vmcs12(vmx, evmcs->hv_clean_fields);
> 	} else if (...) {
> 	}
>

I like the idea, thanks! Will incorporate into v2.

>>  		/* Enlightened VMCS doesn't have launch state */
>>  		vmcs12->launch_state = !launch;
>>  	} else if (enable_shadow_vmcs) {
>> @@ -6136,7 +6143,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>>  		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
>>  		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
>>  			if (vmx->nested.hv_evmcs)
>> -				copy_enlightened_to_vmcs12(vmx);
>> +				copy_enlightened_to_vmcs12(vmx, false);
>>  			else if (enable_shadow_vmcs)
>>  				copy_shadow_to_vmcs12(vmx);
>>  		}
>> -- 
>> 2.30.2
>> 
>

-- 
Vitaly

