Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D781C500A
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 10:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgEEIQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 04:16:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60561 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725833AbgEEIQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 04:16:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588666579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PLpw+0AF+YrhjhPFs8WCFBSF9TV0SgmVMW6RrggE9AY=;
        b=S36kxAa9ntyBN2fcChlLUoXWbEmYqLOtuJ3iEZm+YUGHXtJJkjCws1DaLksywgbyN42AOA
        g1fSlMD4wnit/0ebVYxCRzQglaNDgF1QbIbhlz882ARXdyp1wru/0WOOflViuDDub7D0cP
        bLjRkoLV3MCGF/Qf0Qd/MF3lT5nTMVs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-sVzrqA23M1SdyVb6jolx9A-1; Tue, 05 May 2020 04:16:17 -0400
X-MC-Unique: sVzrqA23M1SdyVb6jolx9A-1
Received: by mail-wm1-f71.google.com with SMTP id n17so505578wmi.3
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 01:16:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PLpw+0AF+YrhjhPFs8WCFBSF9TV0SgmVMW6RrggE9AY=;
        b=i9llRaNEFIXXOx8On+Ztld2nGBNdIs+jWVqyXc7sWDUXZOYdzthxLbgPbZBKtEChR5
         iTfAlT/nbT1HdPAKAVUY9IVujdHJbINMCjvnF5fd5kPs/jkogigT2HyElYjKAuhkKvTY
         +wHUjvOi2HTCp1oFebK5i2jJxKsMtymurK51CSmKlQ0K6uSUnMZHF8G86ilg7kmNTd6r
         7wVMck2ui4uqVFNmfo8ZM9OgUuIzxG33ZXeZZanbyp7dA5z2vF2VGM3NdrgqYVBXU/B0
         yubxMrOnV+YTl5mWw2i9Q0w2XlfeSNcUb8CRLPFEaxnCqJMEe/+eN5WLBUKseoHnF9v7
         x9rw==
X-Gm-Message-State: AGi0PuaqjMx4owEcgXZeXk4BbbVrzJxJZvZofl2ES3TYYQuOpbuTdo8s
        +Wx1U8Taso4aFiqV6K2o6LIjkjOH/dBmWMIKer84y+txtFmqIw3XfC7uEEAv3MASrUwlDwED1Cs
        +ziUyLHt0VjMB
X-Received: by 2002:a1c:4d17:: with SMTP id o23mr1810566wmh.47.1588666575854;
        Tue, 05 May 2020 01:16:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypLUtgQm6gLvTTvKMCOOVI0r2vbnTAko/RCspVruBrqFB7ryEUKretodCstSRgTv12PEO0zyqA==
X-Received: by 2002:a1c:4d17:: with SMTP id o23mr1810540wmh.47.1588666575596;
        Tue, 05 May 2020 01:16:15 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v10sm1883540wrq.45.2020.05.05.01.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 01:16:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Gavin Shan <gshan@redhat.com>, x86@kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf page ready notifications
In-Reply-To: <bdd3fba1-72d6-9096-e63d-a89f2990a26d@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com> <20200429093634.1514902-5-vkuznets@redhat.com> <bdd3fba1-72d6-9096-e63d-a89f2990a26d@redhat.com>
Date:   Tue, 05 May 2020 10:16:13 +0200
Message-ID: <87y2q6dcfm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gavin Shan <gshan@redhat.com> writes:

> Hi Vitaly,
>
> On 4/29/20 7:36 PM, Vitaly Kuznetsov wrote:
>> If two page ready notifications happen back to back the second one is not
>> delivered and the only mechanism we currently have is
>> kvm_check_async_pf_completion() check in vcpu_run() loop. The check will
>> only be performed with the next vmexit when it happens and in some cases
>> it may take a while. With interrupt based page ready notification delivery
>> the situation is even worse: unlike exceptions, interrupts are not handled
>> immediately so we must check if the slot is empty. This is slow and
>> unnecessary. Introduce dedicated MSR_KVM_ASYNC_PF_ACK MSR to communicate
>> the fact that the slot is free and host should check its notification
>> queue. Mandate using it for interrupt based type 2 APF event delivery.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>   Documentation/virt/kvm/msr.rst       | 16 +++++++++++++++-
>>   arch/x86/include/uapi/asm/kvm_para.h |  1 +
>>   arch/x86/kvm/x86.c                   |  9 ++++++++-
>>   3 files changed, 24 insertions(+), 2 deletions(-)
>> 
>> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
>> index 7433e55f7184..18db3448db06 100644
>> --- a/Documentation/virt/kvm/msr.rst
>> +++ b/Documentation/virt/kvm/msr.rst
>> @@ -219,6 +219,11 @@ data:
>>   	If during pagefault APF reason is 0 it means that this is regular
>>   	page fault.
>>   
>> +	For interrupt based delivery, guest has to write '1' to
>> +	MSR_KVM_ASYNC_PF_ACK every time it clears reason in the shared
>> +	'struct kvm_vcpu_pv_apf_data', this forces KVM to re-scan its
>> +	queue and deliver next pending notification.
>> +
>>   	During delivery of type 1 APF cr2 contains a token that will
>>   	be used to notify a guest when missing page becomes
>>   	available. When page becomes available type 2 APF is sent with
>> @@ -340,4 +345,13 @@ data:
>>   
>>   	To switch to interrupt based delivery of type 2 APF events guests
>>   	are supposed to enable asynchronous page faults and set bit 3 in
>> -	MSR_KVM_ASYNC_PF_EN first.
>> +
>> +MSR_KVM_ASYNC_PF_ACK:
>> +	0x4b564d07
>> +
>> +data:
>> +	Asynchronous page fault acknowledgment. When the guest is done
>> +	processing type 2 APF event and 'reason' field in 'struct
>> +	kvm_vcpu_pv_apf_data' is cleared it is supposed to write '1' to
>> +	Bit 0 of the MSR, this caused the host to re-scan its queue and
>> +	check if there are more notifications pending.
>
> I'm not sure if I understood the usage of MSR_KVM_ASYNC_PF_ACK
> completely. It seems it's used to trapped to host, to have chance
> to check/deliver pending page ready events. If there is no pending
> events, no work will be finished in the trap. If it's true, it might
> be good idea to trap conditionally, meaning writing to ASYNC_PF_ACK
> if there are really pending events?

How does the guest know if host has any pending events or not?

The problem we're trying to address with ACK msr is the following:
imagine host has two 'page ready' notifications back to back. It puts
token for the first on in the slot and raises an IRQ but how do we know
when the slot becomes free so we can inject the second one? Currently,
we have kvm_check_async_pf_completion() check in vcpu_run() loop but
this doesn't guarantee timely delivery of the event, we just hope that
there's going to be a vmexit 'some time soon' and we'll piggy back onto
that. Normally this works but in some special cases it may take really
long before a vmexit happens. Also, we're penalizing each vmexit with an
unneeded check. ACK msr is intended to solve these issues.

-- 
Vitaly

