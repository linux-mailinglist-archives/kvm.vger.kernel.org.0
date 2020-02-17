Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8186161460
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 15:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgBQOQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 09:16:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46065 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727898AbgBQOQ4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 09:16:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581949015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X5owJ1Q5kyCcEn/wK666suwQNxuxUfzmbCXN/IZugIc=;
        b=Ql/QslLIYBgfgKNU7L0Xfdjyx8FBxDJ4HLpO6fHytDF2YVc/hw42J0d20hJz69sd1geY44
        tiYj9X0ud2lRGGkXm7dgjFVocdKavaaxMKDqMl0e2jq01gLKHCMgEDNwAoJyiQdGaW9hgx
        m/iCr1EGVIH+qsxZdlaxS7OMBZSn25E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-RYKALqOPOJColw7288Yrkw-1; Mon, 17 Feb 2020 09:16:50 -0500
X-MC-Unique: RYKALqOPOJColw7288Yrkw-1
Received: by mail-wm1-f72.google.com with SMTP id 7so6273938wmf.9
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 06:16:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=X5owJ1Q5kyCcEn/wK666suwQNxuxUfzmbCXN/IZugIc=;
        b=UCasv6+W8+jJtzwM4QU7d3qKkVhr/s+I76txEr0rY5+pzzrqArUfT3k3K6rJqS1xad
         PMoRnnOikvmeRu7c6dzQ3B/vFSF87ZGbunKAQzbj4lGOVOe1L4dWSreoO/EBoT1uTi+y
         Buxsqp5ca61ZhOvsH5t060zNcZ8fp3pe6xpjZe7GvJBuSClEG6PtkExA5MPUfHNVhgbs
         WQnqMwr+5R34rIbA7+SmLUXhTPiWIpB0ILxn7ZcBZOCvWGCxBuPulw3CmmtUE5sXbb+X
         RCeI/dZrnAsqQ3CE3NgggCNTa6q3W+j0XO4afbqmOadz1OAzSpeUseHN8EbarWtQ0Ds7
         WNwA==
X-Gm-Message-State: APjAAAUNCIdBJEJnXpB/wWTPXf2ypIfec6I6MZGIeUI0JETGe1QI1XmO
        o75jXxNvNXoNBCrdJl43cBFGGbvEqIwSpQ+YLm/LHfiB5po8YvfiriPza3qyOAu6pfh06HAxg7F
        grMu4kQ3g485m
X-Received: by 2002:a1c:ddc3:: with SMTP id u186mr22709060wmg.103.1581949008356;
        Mon, 17 Feb 2020 06:16:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqzY6ppV8fkLLxTSONFBrhFjjhdBJrSKf63MFZ71BdYb8RtzZ2UHi8XTjoJ9gzQ6Hi134wRxyw==
X-Received: by 2002:a1c:ddc3:: with SMTP id u186mr22709044wmg.103.1581949008070;
        Mon, 17 Feb 2020 06:16:48 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id u62sm830661wmu.17.2020.02.17.06.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 06:16:47 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: Pre-allocate 1 cpumask variable per cpu for both pv tlb and pv ipis
In-Reply-To: <CANRm+Cz_gskKwa0SU0PUhtacj3Ovm_MmBASDJHOECsnYz=jxkg@mail.gmail.com>
References: <CANRm+CxGOeGQ0vV9ueBgjUDvkzH29EQWLe4GQGDvOhm3idM6NQ@mail.gmail.com> <871rqtbcve.fsf@vitty.brq.redhat.com> <CANRm+Cz_gskKwa0SU0PUhtacj3Ovm_MmBASDJHOECsnYz=jxkg@mail.gmail.com>
Date:   Mon, 17 Feb 2020 15:16:46 +0100
Message-ID: <87y2t19u41.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> On Mon, 17 Feb 2020 at 20:46, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Wanpeng Li <kernellwp@gmail.com> writes:
>>
>> > From: Wanpeng Li <wanpengli@tencent.com>
>> >
>> > Nick Desaulniers Reported:
>> >
>> >   When building with:
>> >   $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
>> >   The following warning is observed:
>> >   arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
>> >   function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
>> >   static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
>> >   vector)
>> >               ^
>> >   Debugging with:
>> >   https://github.com/ClangBuiltLinux/frame-larger-than
>> >   via:
>> >   $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
>> >     kvm_send_ipi_mask_allbutself
>> >   points to the stack allocated `struct cpumask newmask` in
>> >   `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
>> >   potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
>> >   the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
>> >   8192, making a single instance of a `struct cpumask` 1024 B.
>> >
>> > This patch fixes it by pre-allocate 1 cpumask variable per cpu and use it for
>> > both pv tlb and pv ipis..
>> >
>> > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
>> > Acked-by: Nick Desaulniers <ndesaulniers@google.com>
>> > Cc: Peter Zijlstra <peterz@infradead.org>
>> > Cc: Nick Desaulniers <ndesaulniers@google.com>
>> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>> > ---
>> > v1 -> v2:
>> >  * remove '!alloc' check
>> >  * use new pv check helpers
>> >
>> >  arch/x86/kernel/kvm.c | 33 +++++++++++++++++++++------------
>> >  1 file changed, 21 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> > index 76ea8c4..377b224 100644
>> > --- a/arch/x86/kernel/kvm.c
>> > +++ b/arch/x86/kernel/kvm.c
>> > @@ -432,6 +432,8 @@ static bool pv_tlb_flush_supported(void)
>> >          kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
>> >  }
>> >
>> > +static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
>> > +
>> >  #ifdef CONFIG_SMP
>> >
>> >  static bool pv_ipi_supported(void)
>> > @@ -510,12 +512,12 @@ static void kvm_send_ipi_mask(const struct
>> > cpumask *mask, int vector)
>> >  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask,
>> > int vector)
>> >  {
>> >      unsigned int this_cpu = smp_processor_id();
>> > -    struct cpumask new_mask;
>> > +    struct cpumask *new_mask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
>> >      const struct cpumask *local_mask;
>> >
>> > -    cpumask_copy(&new_mask, mask);
>> > -    cpumask_clear_cpu(this_cpu, &new_mask);
>> > -    local_mask = &new_mask;
>> > +    cpumask_copy(new_mask, mask);
>> > +    cpumask_clear_cpu(this_cpu, new_mask);
>> > +    local_mask = new_mask;
>> >      __send_ipi_mask(local_mask, vector);
>> >  }
>> >
>> > @@ -595,7 +597,6 @@ static void __init kvm_apf_trap_init(void)
>> >      update_intr_gate(X86_TRAP_PF, async_page_fault);
>> >  }
>> >
>> > -static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
>> >
>> >  static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>> >              const struct flush_tlb_info *info)
>> > @@ -603,7 +604,7 @@ static void kvm_flush_tlb_others(const struct
>> > cpumask *cpumask,
>> >      u8 state;
>> >      int cpu;
>> >      struct kvm_steal_time *src;
>> > -    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_tlb_mask);
>> > +    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
>> >
>> >      cpumask_copy(flushmask, cpumask);
>> >      /*
>> > @@ -642,6 +643,7 @@ static void __init kvm_guest_init(void)
>> >      if (pv_tlb_flush_supported()) {
>> >          pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>> >          pv_ops.mmu.tlb_remove_table = tlb_remove_table;
>> > +        pr_info("KVM setup pv remote TLB flush\n");
>>
>> Nit: to be consistent with __send_ipi_mask() the message should be
>> somthing like
>>
>> "KVM: switch to using PV TLB flush"
>
> There is a lot of native ops we replace by pv ops in kvm.c, I use "KVM
> setup xxx" there, like pv ipis, pv tlb flush, pv sched yield, should
> we keep consistent as before?
>

Oh, I see, it's either one or another :-) Personally, I prefer when
subsystem is delimited with ':' so if we were to change them all I'd
prefer the "KVM: switch to using PV TLB flush" (__send_ipi_mask()
style). But this looks more like a separate patch idea, we can discuss
our personal preferences there :-)

-- 
Vitaly

