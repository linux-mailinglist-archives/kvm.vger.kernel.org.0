Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDD92EB7B7
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 02:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbhAFBg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 20:36:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726145AbhAFBg6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Jan 2021 20:36:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609896931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hfo2Cvq3ATvx2T/cgdPX/GnBQ6IRxGdJrImGfK4T+dA=;
        b=SaYxcMoj64K7e7Prv38M0ls5TYLH1jXb0xdy7gP7RDtZQKe+pBjpOQAuhoD7kjWMUzLClU
        16KFv4GYvlT6PJjyC+6/Q2fWGV909vuuTtP4Z33qstK/EzDhNucf4ynguQckjGSSldX51Z
        CWG6ZRd051tUn5YT3/NqXeWFiGh4YAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-S0RL1n1-Ng6rSVE22t9dEQ-1; Tue, 05 Jan 2021 20:35:29 -0500
X-MC-Unique: S0RL1n1-Ng6rSVE22t9dEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A79FC180A089;
        Wed,  6 Jan 2021 01:35:28 +0000 (UTC)
Received: from [10.10.112.14] (ovpn-112-14.rdu2.redhat.com [10.10.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF1B860BE2;
        Wed,  6 Jan 2021 01:35:27 +0000 (UTC)
Subject: Re: [PATCH] Revert "KVM: x86: Unconditionally enable irqs in guest
 context"
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        w90p710@gmail.com, pbonzini@redhat.com, vkuznets@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
References: <20210105192844.296277-1-nitesh@redhat.com>
 <X/UIh1PqmSLNg8vM@google.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Organization: Red Hat Inc,
Message-ID: <e2ecdb77-a6ec-c73f-db66-a9eb4ca1dffd@redhat.com>
Date:   Tue, 5 Jan 2021 20:35:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X/UIh1PqmSLNg8vM@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/5/21 7:47 PM, Sean Christopherson wrote:
> +tglx
>
> On Tue, Jan 05, 2021, Nitesh Narayan Lal wrote:
>> This reverts commit d7a08882a0a4b4e176691331ee3f492996579534.
>>
>> After the introduction of the patch:
>>
>> 	87fa7f3e9: x86/kvm: Move context tracking where it belongs
>>
>> since we have moved guest_exit_irqoff closer to the VM-Exit, explicit
>> enabling of irqs to process pending interrupts should not be required
>> within vcpu_enter_guest anymore.
> Ugh, except that commit completely broke tick-based accounting, on both Intel
> and AMD.

I did notice some discrepancies in the system time reported after the
introduction of this patch but I wrongly concluded that the behavior is correct.

I reported this yesterday [1] but I think I added your old email ID in
that thread (sorry about that).

>   With guest_exit_irqoff() being called immediately after VM-Exit, any
> tick that happens after IRQs are disabled will be accounted to the host.  E.g.
> on Intel, even an IRQ VM-Exit that has already been acked by the CPU isn't
> processed until kvm_x86_ops.handle_exit_irqoff(), well after PF_VCPU has been
> cleared.

Right that also explains the higher system time reported by the cpuacct.stats.

>
> CONFIG_VIRT_CPU_ACCOUNTING_GEN=y should still work (I didn't bother to verify).

For the cpuacct stats that I have shared in the other thread, this config was
enabled.

>
> Thomas, any clever ideas?  Handling IRQs in {vmx,svm}_vcpu_enter_exit() isn't an
> option as KVM hasn't restored enough state to handle an IRQ, e.g. PKRU and XCR0
> are still guest values.  Is it too heinous to fudge PF_VCPU across KVM's
> "pending" IRQ handling?  E.g. this god-awful hack fixes the accounting:
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 836912b42030..5a777fd35b4b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9028,6 +9028,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>         vcpu->mode = OUTSIDE_GUEST_MODE;
>         smp_wmb();
>  
> +       current->flags |= PF_VCPU;
>         kvm_x86_ops.handle_exit_irqoff(vcpu);
>  
>         /*
> @@ -9042,6 +9043,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>         ++vcpu->stat.exits;
>         local_irq_disable();
>         kvm_after_interrupt(vcpu);
> +       current->flags &= ~PF_VCPU;
>  
>         if (lapic_in_kernel(vcpu)) {
>                 s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
>

I can give this a try.
What is the right way to test this (via cpuacct stats maybe)?

[1] https://lore.kernel.org/lkml/12a1b9d4-8534-e23a-6bbd-736474928e6b@redhat.com/

-- 
Thanks
Nitesh

