Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F3C276944
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 08:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgIXGuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 02:50:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727053AbgIXGun (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 02:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600930241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LIKAioeplGLyiuBbUFdtMjnI7W3D9Z3j5vefA4s4ufw=;
        b=TGjf3Mgex9r9t86KufiyJi3s851fcQxVcPOJyWPavnr42E3stSUuJjqGDTdqgsp7pWEzz/
        f/ohVWR1BRiTiUsc4lAA2REgZtVttaLbdwAGxwfliWWT/QUVfxgClvI8sfXMl3wu5wJq9X
        mOGXZEi5jO3SI7yILsvl1bEAv4vH+GY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-Sj9gq5A_MhCgKP6Hs_39kg-1; Thu, 24 Sep 2020 02:50:37 -0400
X-MC-Unique: Sj9gq5A_MhCgKP6Hs_39kg-1
Received: by mail-wr1-f70.google.com with SMTP id l9so825470wrq.20
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 23:50:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LIKAioeplGLyiuBbUFdtMjnI7W3D9Z3j5vefA4s4ufw=;
        b=sQ10Apq1KAU6ekSjsCBj/PjaFPJIErqOzsigCG//JIci7tD16WaSSt69yO5L+0Jxwg
         aDl8u2e++qMvf1b55cJOPxkjXshfHNItjwG7kvkD+8LbcsyyI1Zz7VHokgKvRZbbGaB8
         mdA4Iw4WHqMYKluIabWt4NcYlbaJnDzMBF9CgIRkLWE63f42z7HOncYa+diZp3XXoBlB
         5xxjLfKDBvM17BjgHYqv6ZlOkTgl9K6ttxNHmYP82BBk0174BZgtwYbWVEjqrNpEstgw
         BcfGfcWAm733NZrV5EW81oHK3pkydMcrbIb4vwaErrXqG38F9DgSGY60kcSnk0uZnXx0
         kvMQ==
X-Gm-Message-State: AOAM532SAzFGjlMxOZ17gcanRiko8aINz56pOzCbpJFUJwVvth3iOxoJ
        +R3TGnBz9clAh4bPkrzDeYkNMmiZPrHWbUZqqR3+2qwCE2KhvoDhX/PCIYHfqK1pGlOVMl1EE8g
        zbptOlewb8DHI
X-Received: by 2002:adf:dbc3:: with SMTP id e3mr3333438wrj.1.1600930236327;
        Wed, 23 Sep 2020 23:50:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdKgtG8a23gp9sPKCgac/G4/YiS2x4mbujGoCbXj7ZDMRA/eaMcnIrHNWJ/P8aBoLyEtKHFA==
X-Received: by 2002:adf:dbc3:: with SMTP id e3mr3333401wrj.1.1600930236064;
        Wed, 23 Sep 2020 23:50:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d80e:a78:c27b:93ed? ([2001:b07:6468:f312:d80e:a78:c27b:93ed])
        by smtp.gmail.com with ESMTPSA id m18sm2283735wrx.58.2020.09.23.23.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 23:50:35 -0700 (PDT)
Subject: Re: [PATCH] KVM: Enable hardware before doing arch VM initialization
To:     Huacai Chen <chenhuacai@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200923185757.1806-1-sean.j.christopherson@intel.com>
 <CAAhV-H6QLRh8kWyt4KfVgS64nsixx_3er+qmeph3csxpq3scdw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <11d4e52e-6bc2-934d-0487-561033b3ab87@redhat.com>
Date:   Thu, 24 Sep 2020 08:50:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6QLRh8kWyt4KfVgS64nsixx_3er+qmeph3csxpq3scdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 08:31, Huacai Chen wrote:
> Hi, Sean,
> 
> On Thu, Sep 24, 2020 at 3:00 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
>>
>> Swap the order of hardware_enable_all() and kvm_arch_init_vm() to
>> accommodate Intel's Trust Domain Extension (TDX), which needs VMX to be
>> fully enabled during VM init in order to make SEAMCALLs.
>>
>> This also provides consistent ordering between kvm_create_vm() and
>> kvm_destroy_vm() with respect to calling kvm_arch_destroy_vm() and
>> hardware_disable_all().
> Do you means that hardware_enable_all() enable VMX, kvm_arch_init_vm()
> enable TDX, and TDX depends on VMX enabled at first? If so, can TDX be
> also enabled at hardware_enable_all()?

kvm_arch_init_vm() enables TDX *for the VM*, and to do that it needs VMX
instructions (specifically SEAMCALL, which is a hypervisor->"ultravisor"
call).  Because that action is VM-specific it cannot be done in
hardware_enable_all().

Paolo

> The swapping seems not affect MIPS, but I observed a fact:
> kvm_arch_hardware_enable() not only be called at
> hardware_enable_all(), but also be called at kvm_starting_cpu(). Even
> if you swap the order, new starting CPUs are not enabled VMX before
> kvm_arch_init_vm(). (Maybe I am wrong because I'm not familiar with
> VMX/TDX).
> 
> Huacai
>>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: Huacai Chen <chenhc@lemote.com>
>> Cc: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
>> Cc: linux-mips@vger.kernel.org
>> Cc: Paul Mackerras <paulus@ozlabs.org>
>> Cc: kvm-ppc@vger.kernel.org
>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>> Cc: Janosch Frank <frankja@linux.ibm.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Cornelia Huck <cohuck@redhat.com>
>> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Cc: Wanpeng Li <wanpengli@tencent.com>
>> Cc: Jim Mattson <jmattson@google.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> ---
>>
>> Obviously not required until the TDX series comes along, but IMO KVM
>> should be consistent with respect to enabling and disabling virt support
>> in hardware.
>>
>> Tested only on Intel hardware.  Unless I missed something, this only
>> affects x86, Arm and MIPS as hardware enabling is a nop for s390 and PPC.
>> Arm looks safe (based on my mostly clueless reading of the code), but I
>> have no idea if this will cause problem for MIPS, which is doing all kinds
>> of things in hardware_enable() that I don't pretend to fully understand.
>>
>>  virt/kvm/kvm_main.c | 16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index cf88233b819a..58fa19bcfc90 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -766,7 +766,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>>                 struct kvm_memslots *slots = kvm_alloc_memslots();
>>
>>                 if (!slots)
>> -                       goto out_err_no_arch_destroy_vm;
>> +                       goto out_err_no_disable;
>>                 /* Generations must be different for each address space. */
>>                 slots->generation = i;
>>                 rcu_assign_pointer(kvm->memslots[i], slots);
>> @@ -776,19 +776,19 @@ static struct kvm *kvm_create_vm(unsigned long type)
>>                 rcu_assign_pointer(kvm->buses[i],
>>                         kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
>>                 if (!kvm->buses[i])
>> -                       goto out_err_no_arch_destroy_vm;
>> +                       goto out_err_no_disable;
>>         }
>>
>>         kvm->max_halt_poll_ns = halt_poll_ns;
>>
>> -       r = kvm_arch_init_vm(kvm, type);
>> -       if (r)
>> -               goto out_err_no_arch_destroy_vm;
>> -
>>         r = hardware_enable_all();
>>         if (r)
>>                 goto out_err_no_disable;
>>
>> +       r = kvm_arch_init_vm(kvm, type);
>> +       if (r)
>> +               goto out_err_no_arch_destroy_vm;
>> +
>>  #ifdef CONFIG_HAVE_KVM_IRQFD
>>         INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
>>  #endif
>> @@ -815,10 +815,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
>>                 mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
>>  #endif
>>  out_err_no_mmu_notifier:
>> -       hardware_disable_all();
>> -out_err_no_disable:
>>         kvm_arch_destroy_vm(kvm);
>>  out_err_no_arch_destroy_vm:
>> +       hardware_disable_all();
>> +out_err_no_disable:
>>         WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
>>         for (i = 0; i < KVM_NR_BUSES; i++)
>>                 kfree(kvm_get_bus(kvm, i));
>> --
>> 2.28.0
>>
> 

