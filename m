Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38EC38E6B0
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhEXMg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:36:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232486AbhEXMgq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:36:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621859718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PpgAUyiKcsxyyDpd43AlLz5pN+mpE43cHu+cRRsUC+8=;
        b=JRGenMJtm2mFA5wVL7ljyY47DPgCM3PsceNh8S/dwZsDnSphtu8r23L6ReeCaH35hW3mLC
        tTmbvl5BewDuIgbe51P8qKZzL+35jG3oeRrjWFuYH+KrlfB81XSVInZ81aKgmGNOcAG02c
        /hCqQ1nb4zJQHatYDLmVgAAjhWGctrQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-LWy9e_PFNX-4klg8F9OBEQ-1; Mon, 24 May 2021 08:35:16 -0400
X-MC-Unique: LWy9e_PFNX-4klg8F9OBEQ-1
Received: by mail-wr1-f69.google.com with SMTP id v5-20020adf9e450000b029010e708f05b3so13075926wre.6
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 05:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PpgAUyiKcsxyyDpd43AlLz5pN+mpE43cHu+cRRsUC+8=;
        b=PrleIY6hTK/1ZL8IlysPlpN/ElHft/WyU2X1r6j1Ob+vFDDPbGMW2Neyb2Fn2X3Jzc
         SCYE0AC74LL4A4ZA/Cqh6g7UJ444HLfRz+mfn9b0UWpa8hgWYGXCjh0yDSo0BWLAr4sW
         ++V0x6uIiqllL4xYXhGsL43lFIbQsJVZ8iBRdMzDp4eHT/dvHYlFPbhu5N2uyZyw21UA
         uF/vJH0ootGO1F7toZt8YVNtdzVxBjjJwfa09VU0XXCdsz13QOT4gU9hBySZ7ulW5/I+
         lejCP/T9nA5P+6mT6Oku4VBQzHtlzA24iE5xLdVfO6Ks9WX+9RGFdGLwt7YebH/vmn2F
         oefA==
X-Gm-Message-State: AOAM530w5JFUU9Wv6pTjVtuLhp88LycqqeVlxRcNR3rfhHS0u3RldDdR
        d73D+uHWBcFIY8KFHWIjmyFwIvxPFDX5oynouE267IV8OKtmNCeq8/FHPIbMz7K/BLnzcyDPa0e
        kF1Xbh0g8JXQq
X-Received: by 2002:a5d:4fce:: with SMTP id h14mr21536321wrw.239.1621859715729;
        Mon, 24 May 2021 05:35:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJaSdc2G2JIlQi2ysSOdWJOO94g1Ez7aGhHWhFsXXKj8SOWwzwrCkMWWBxRFqpEPku9GxM5Q==
X-Received: by 2002:a5d:4fce:: with SMTP id h14mr21536302wrw.239.1621859715485;
        Mon, 24 May 2021 05:35:15 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t11sm12357620wrz.57.2021.05.24.05.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 05:35:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] KVM: nVMX: Introduce nested_evmcs_is_used()
In-Reply-To: <80892ca2e3d7122b5b92f696ecf4c1943b0245b9.camel@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
 <20210517135054.1914802-2-vkuznets@redhat.com>
 <80892ca2e3d7122b5b92f696ecf4c1943b0245b9.camel@redhat.com>
Date:   Mon, 24 May 2021 14:35:14 +0200
Message-ID: <875yz871j1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Mon, 2021-05-17 at 15:50 +0200, Vitaly Kuznetsov wrote:
>> Unlike regular set_current_vmptr(), nested_vmx_handle_enlightened_vmptrld()
>> can not be called directly from vmx_set_nested_state() as KVM may not have
>> all the information yet (e.g. HV_X64_MSR_VP_ASSIST_PAGE MSR may not be
>> restored yet). Enlightened VMCS is mapped later while getting nested state
>> pages. In the meantime, vmx->nested.hv_evmcs remains NULL and using it
>> for various checks is incorrect. In particular, if KVM_GET_NESTED_STATE is
>> called right after KVM_SET_NESTED_STATE, KVM_STATE_NESTED_EVMCS flag in the
>> resulting state will be unset (and such state will later fail to load).
>> 
>> Introduce nested_evmcs_is_used() and use 'is_guest_mode(vcpu) &&
>> vmx->nested.current_vmptr == -1ull' check to detect not-yet-mapped eVMCS
>> after restore.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/nested.c | 31 ++++++++++++++++++++++++++-----
>>  1 file changed, 26 insertions(+), 5 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 6058a65a6ede..3080e00c8f90 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -141,6 +141,27 @@ static void init_vmcs_shadow_fields(void)
>>  	max_shadow_read_write_fields = j;
>>  }
>>  
>> +static inline bool nested_evmcs_is_used(struct vcpu_vmx *vmx)
>> +{
>> +	struct kvm_vcpu *vcpu = &vmx->vcpu;
>> +
>> +	if (vmx->nested.hv_evmcs)
>> +		return true;
>> +
>> +	/*
>> +	 * After KVM_SET_NESTED_STATE, enlightened VMCS is mapped during
>> +	 * KVM_REQ_GET_NESTED_STATE_PAGES handling and until the request is
>> +	 * processed vmx->nested.hv_evmcs is NULL. It is, however, possible to
>> +	 * detect such state by checking 'nested.current_vmptr == -1ull' when
>> +	 * vCPU is in guest mode, it is only possible with eVMCS.
>> +	 */
>> +	if (unlikely(vmx->nested.enlightened_vmcs_enabled && is_guest_mode(vcpu) &&
>> +		     (vmx->nested.current_vmptr == -1ull)))
>> +		return true;
>> +
>> +	return false;
>> +}
>
>
> I think that this is a valid way to solve the issue,
> but it feels like there might be a better way.
> I don't mind though to accept this patch as is.
>
> So here are my 2 cents about this:
>
> First of all after studying how evmcs works I take my words back
> about needing to migrate its contents. 
>
> It is indeed enough to migrate its physical address, 
> or maybe even just a flag that evmcs is loaded
> (and to my surprise we already do this - KVM_STATE_NESTED_EVMCS)
>
> So how about just having a boolean flag that indicates that evmcs is in use, 
> but doesn't imply that we know its address or that it is mapped 
> to host address space, something like 'vmx->nested.enlightened_vmcs_loaded'
>
> On migration that flag saved and restored as the KVM_STATE_NESTED_EVMCS,
> otherwise it set when we load an evmcs and cleared when it is released.
>
> Then as far as I can see we can use this flag in nested_evmcs_is_used
> since all its callers don't touch evmcs, thus don't need it to be
> mapped.
>
> What do you think?
>

First, we need to be compatible with older KVMs which don't have the
flag and this is problematic: currently, we always expect vmcs12 to
carry valid contents. This is challenging.

Second, vCPU can be migrated in three different states:
1) While L2 was running ('true' nested state is in VMCS02)
2) While L1 was running ('true' nested state is in eVMCS)
3) Right after an exit from L2 to L1 was forced
('need_vmcs12_to_shadow_sync = true') ('true' nested state is in
VMCS12).

The current solution is to always use VMCS12 as a container to transfer
the state and conceptually, it is at least easier to understand.

We can, indeed, transfer eVMCS (or VMCS12) in case 2) through guest
memory and I even tried that but that was making the code more complex
so eventually I gave up and decided to preserve the 'always use VMCS12
as a container' status quo.

-- 
Vitaly

