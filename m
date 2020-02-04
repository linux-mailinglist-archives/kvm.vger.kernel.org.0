Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE18151AF9
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 14:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgBDNKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 08:10:11 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39631 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbgBDNKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 08:10:11 -0500
Received: by mail-oi1-f196.google.com with SMTP id z2so18331979oih.6;
        Tue, 04 Feb 2020 05:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SVaqwryK9Ch1A+cLGhauBqa2XFay6jr9KjYEvPy2h9E=;
        b=ft+Pvuif5THe08dEA+J6tSpFlOdGs7cAa+rEScp8IB9hrfHWB6GW9ba8xGLaWaxxjB
         Or5DU1AOgSlyrQr4qr/0O8UJ4G5JMvUsQFn+u3AsgaDlFyWDg5emsjhi80inIZDXnBRC
         db00B8G1aSX0yZrR3/5mR7dzQZRcft0T9qSCLQL2l6AFQ1TmJqW7jrkOO/QZH6UL8P5U
         K9WUZr0D9Uw1lI3akhV/MEO+Dg5hPAXIwi4RY53eLSwVRy9B4x0j79KMvDYlLUkwqq+q
         F1Q/SO6RMcLML9FX39M4H9jquzs40nYF/Qr55d8Zzwi/ABaltFY7T7D+lyrbqQZB4rNu
         UdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SVaqwryK9Ch1A+cLGhauBqa2XFay6jr9KjYEvPy2h9E=;
        b=swk/7kTx+tec3ZFbSr7RIFEU1hkFen655sHn4mONHehfJ9edSfDGcmKXy8tCfUYxQy
         fh5k0eoFtPrtuo7YYfdAnj8fOmrF86lClbBian594a/2s/XJLQoupH6Z4WDKvQkiNHIs
         6sNaJEvrgB5uBJXVw2mCAsHhqzyderWpL/bBXvpABe78jrPkSa2esXmSfBoa1DRVUrV/
         A14lKCSeGCWmOOZ9NDb16nXymFtSUW7PPCZ3qrQREXBhnYAMNGCnCa0ZNQEmrl1HI6Py
         B3+nThLxOxjbjdvRulB5U7cn/wIF2HN33nvLEUEn1fNCiPsiuupBaPB1ljJMvQcbHWMw
         CL+w==
X-Gm-Message-State: APjAAAXq/xvOCNpQ8xIo+E81dbXgPwJ/ozw7bQ2VHcxpWRBwCLGa6ozE
        uoOx9lEyz8M/AogiI0zaZO6BZjmlmtGb+cpSImg=
X-Google-Smtp-Source: APXvYqyH6d9P3RIwxAGPPDOQn7aOBhhAjlrTL/v9G6q3moosiXgKowmyepdspDqNsR00njTG2GGjBYbNk7Jpl8wKCMg=
X-Received: by 2002:aca:8d5:: with SMTP id 204mr3288703oii.141.1580821810530;
 Tue, 04 Feb 2020 05:10:10 -0800 (PST)
MIME-Version: 1.0
References: <CANRm+CwwYoSLeA3Squp-_fVZpmYmxEfqOB+DGoQN4Y_iMT347w@mail.gmail.com>
 <878slio6hp.fsf@vitty.brq.redhat.com>
In-Reply-To: <878slio6hp.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 4 Feb 2020 21:09:59 +0800
Message-ID: <CANRm+CzkN9oYf4UqWYp2SHFii02=pvVLbW4oNkLmPan7ZroDZA@mail.gmail.com>
Subject: Re: [PATCH] KVM: Pre-allocate 1 cpumask variable per cpu for both pv
 tlb and pv ipis
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc Thadeu,
On Tue, 4 Feb 2020 at 20:57, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Nick Desaulniers Reported:
> >
> >   When building with:
> >   $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
> >   The following warning is observed:
> >   arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
> >   function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
> >   static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
> >   vector)
> >               ^
> >   Debugging with:
> >   https://github.com/ClangBuiltLinux/frame-larger-than
> >   via:
> >   $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
> >     kvm_send_ipi_mask_allbutself
> >   points to the stack allocated `struct cpumask newmask` in
> >   `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
> >   potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
> >   the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
> >   8192, making a single instance of a `struct cpumask` 1024 B.
> >
> > This patch fixes it by pre-allocate 1 cpumask variable per cpu and use it for
> > both pv tlb and pv ipis..
> >
> > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kernel/kvm.c | 33 +++++++++++++++++++++------------
> >  1 file changed, 21 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 81045aab..b1e8efa 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -425,6 +425,8 @@ static void __init sev_map_percpu_data(void)
> >      }
> >  }
> >
> > +static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
> > +
> >  #ifdef CONFIG_SMP
> >  #define KVM_IPI_CLUSTER_SIZE    (2 * BITS_PER_LONG)
> >
> > @@ -490,12 +492,12 @@ static void kvm_send_ipi_mask(const struct
> > cpumask *mask, int vector)
> >  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask,
> > int vector)
> >  {
> >      unsigned int this_cpu = smp_processor_id();
> > -    struct cpumask new_mask;
> > +    struct cpumask *new_mask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
> >      const struct cpumask *local_mask;
> >
> > -    cpumask_copy(&new_mask, mask);
> > -    cpumask_clear_cpu(this_cpu, &new_mask);
> > -    local_mask = &new_mask;
> > +    cpumask_copy(new_mask, mask);
> > +    cpumask_clear_cpu(this_cpu, new_mask);
> > +    local_mask = new_mask;
> >      __send_ipi_mask(local_mask, vector);
> >  }
> >
> > @@ -575,7 +577,6 @@ static void __init kvm_apf_trap_init(void)
> >      update_intr_gate(X86_TRAP_PF, async_page_fault);
> >  }
> >
> > -static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
> >
> >  static void kvm_flush_tlb_others(const struct cpumask *cpumask,
> >              const struct flush_tlb_info *info)
> > @@ -583,7 +584,7 @@ static void kvm_flush_tlb_others(const struct
> > cpumask *cpumask,
> >      u8 state;
> >      int cpu;
> >      struct kvm_steal_time *src;
> > -    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_tlb_mask);
> > +    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
> >
> >      cpumask_copy(flushmask, cpumask);
> >      /*
> > @@ -624,6 +625,7 @@ static void __init kvm_guest_init(void)
> >          kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> >          pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
> >          pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> > +        pr_info("KVM setup pv remote TLB flush\n");
> >      }
> >
> >      if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> > @@ -732,23 +734,30 @@ static __init int activate_jump_labels(void)
> >  }
> >  arch_initcall(activate_jump_labels);
> >
> > -static __init int kvm_setup_pv_tlb_flush(void)
> > +static __init int kvm_alloc_cpumask(void)
> >  {
> >      int cpu;
> > +    bool alloc = false;
> >
> >      if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
> >          !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> > -        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> > +        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME))
> > +        alloc = true;
> > +
> > +#if defined(CONFIG_SMP)
> > +    if (!alloc && kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI))
>
> '!alloc' check is superfluous.
>
> > +        alloc = true;
> > +#endif
> > +
> > +    if (alloc)
> >          for_each_possible_cpu(cpu) {
> > -            zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
> > +            zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
> >                  GFP_KERNEL, cpu_to_node(cpu));
> >          }
> > -        pr_info("KVM setup pv remote TLB flush\n");
> > -    }
> >
> >      return 0;
> >  }
> > -arch_initcall(kvm_setup_pv_tlb_flush);
> > +arch_initcall(kvm_alloc_cpumask);
>
> Honestly, I'd simplify the check in kvm_alloc_cpumask() as
>
> if (!kvm_para_available())
>         return;
>
> and allocated masks for all other cases.

This will waste the memory if pv tlb and pv ipis are not exposed which
are the only users currently.

    Wanpeng
