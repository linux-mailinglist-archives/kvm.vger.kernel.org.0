Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C098131DD5F
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 17:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhBQQbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 11:31:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233084AbhBQQa6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 11:30:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613579372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ogjeFLx6f8wS8oULOo5urcfaXCqjTKbtarJ5n6850Gk=;
        b=V1J8j/dYDN3kx1FVAv+f436QCyT0AmzVZunL8mm1JERGVrWcMQekMEHqtPJezIUNPWrUm2
        /uF5/0ixZ3kNlNe0EV+ggZomAyLIQCGe1jy36SRrnDC7AhefDAtPoHj/B8qDxgjhsD0VX6
        jAsfDUb61RHl4XrEmF5qtO74uUIBPNo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-0j2Usa0AO_-sDGl0stM_JA-1; Wed, 17 Feb 2021 11:29:30 -0500
X-MC-Unique: 0j2Usa0AO_-sDGl0stM_JA-1
Received: by mail-wm1-f69.google.com with SMTP id u186so2234635wmb.0
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 08:29:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ogjeFLx6f8wS8oULOo5urcfaXCqjTKbtarJ5n6850Gk=;
        b=jy4p9oRZzqFcfCuQeCCVFHOlKghEpxb5Qe7rtNDUSSuzW9o2MXBOV6WMmZrRgPxBEv
         sa1BXV38aaJLB+NRyi1hCwRtwEwRODTvAjlLGH4sr13vFgboCsleQEfIeodMNjiagNAq
         bRyODPIYLwejsWerOKadVSteJnKKeDbLlsYrCugUzXhhtQ35OTUFQf3jEeUNMsg0OPi7
         NegVPABBYyVNzY0fQuctIFGUzZTY9Dk2rkeNvGcNdDkf5N3sVNENv5VS20XOY9+yFXbA
         JSfCzoONfdPRyIHG5FShvVt3iNR/du4QNIhzXLxdgeZA66EnUCvF9zIx0N3zLb3yjYlp
         VibA==
X-Gm-Message-State: AOAM532eSLgWpl2b1ECbd5SlqDxTiXOLAWQVsmsrHg/ElTRUIr9ExsUz
        nekMaqze6uR6kxidKoY6QEjVbokKfDdbHP79JDDU+vfn55FKJeWC+R62pwMcf7ex/ZRFLbShj5j
        ZVRwR786VSdDN
X-Received: by 2002:a5d:66c5:: with SMTP id k5mr67292wrw.302.1613579369181;
        Wed, 17 Feb 2021 08:29:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyGiKt9ZaoBvLpCf/2NQOYGBsJJzApNDzwuDqPtEiFGGB8EW6xroD1eYyxOkbO4a1JPNMNw8g==
X-Received: by 2002:a5d:66c5:: with SMTP id k5mr67272wrw.302.1613579368980;
        Wed, 17 Feb 2021 08:29:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s23sm3820305wmc.29.2021.02.17.08.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 08:29:27 -0800 (PST)
Subject: Re: [PATCH 1/7] KVM: VMX: read idt_vectoring_info a bit earlier
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
 <20210217145718.1217358-2-mlevitsk@redhat.com>
 <09de977a-0275-0f4f-cf75-f45e4b5d9ca5@redhat.com>
 <666eb754189a380899b82e0a9798eb2560ae6972.camel@redhat.com>
 <YC1Cljte2ozGSKV/@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <26f7ee7b-568f-c838-d0e0-db125cfbd4e5@redhat.com>
Date:   Wed, 17 Feb 2021 17:29:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YC1Cljte2ozGSKV/@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/21 17:21, Sean Christopherson wrote:
> On Wed, Feb 17, 2021, Maxim Levitsky wrote:
>> On Wed, 2021-02-17 at 17:06 +0100, Paolo Bonzini wrote:
>>> On 17/02/21 15:57, Maxim Levitsky wrote:
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index b3e36dc3f164..e428d69e21c0 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -6921,13 +6921,15 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>>>   	if (unlikely((u16)vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY))
>>>>   		kvm_machine_check();
>>>>   
>>>> +	if (likely(!vmx->exit_reason.failed_vmentry))
>>>> +		vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
>>>> +
>>>
>>> Any reason for the if?
>>
>> Sean Christopherson asked me to do this to avoid updating idt_vectoring_info on failed
>> VM entry, to keep things as they were logically before this patch.
> 
> Ya, specifically because the field isn't valid if VM-Enter fails.  I'm also ok
> with an unconditional VMREAD if we add a comment stating that it's unnecessary
> if VM-Enter failed, but faster in the common case.

It's okay, just good to know!

Thanks,

paolo

