Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 634FB151C32
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 15:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBDO1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 09:27:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53185 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbgBDO1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 09:27:48 -0500
Received: from [187.32.88.249] (helo=calabresa)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1iyzB0-0001Ay-EI; Tue, 04 Feb 2020 14:27:44 +0000
Date:   Tue, 4 Feb 2020 11:27:33 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: Pre-allocate 1 cpumask variable per cpu for both pv
 tlb and pv ipis
Message-ID: <20200204142733.GI40679@calabresa>
References: <CANRm+CwwYoSLeA3Squp-_fVZpmYmxEfqOB+DGoQN4Y_iMT347w@mail.gmail.com>
 <878slio6hp.fsf@vitty.brq.redhat.com>
 <CANRm+CzkN9oYf4UqWYp2SHFii02=pvVLbW4oNkLmPan7ZroDZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CzkN9oYf4UqWYp2SHFii02=pvVLbW4oNkLmPan7ZroDZA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 04, 2020 at 09:09:59PM +0800, Wanpeng Li wrote:
> Cc Thadeu,
> On Tue, 4 Feb 2020 at 20:57, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >
> > Wanpeng Li <kernellwp@gmail.com> writes:
> >
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > Nick Desaulniers Reported:
> > >
> > >   When building with:
> > >   $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
> > >   The following warning is observed:
> > >   arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
> > >   function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
> > >   static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
> > >   vector)
> > >               ^
> > >   Debugging with:
> > >   https://github.com/ClangBuiltLinux/frame-larger-than
> > >   via:
> > >   $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
> > >     kvm_send_ipi_mask_allbutself
> > >   points to the stack allocated `struct cpumask newmask` in
> > >   `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
> > >   potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
> > >   the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
> > >   8192, making a single instance of a `struct cpumask` 1024 B.
> > >
> > > This patch fixes it by pre-allocate 1 cpumask variable per cpu and use it for
> > > both pv tlb and pv ipis..
> > >
> > > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > ---
> > >  arch/x86/kernel/kvm.c | 33 +++++++++++++++++++++------------
> > >  1 file changed, 21 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > > index 81045aab..b1e8efa 100644
> > > --- a/arch/x86/kernel/kvm.c
> > > +++ b/arch/x86/kernel/kvm.c
> > > @@ -425,6 +425,8 @@ static void __init sev_map_percpu_data(void)
> > >      }
> > >  }
> > >
> > > +static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
> > > +
> > >  #ifdef CONFIG_SMP
> > >  #define KVM_IPI_CLUSTER_SIZE    (2 * BITS_PER_LONG)
> > >
> > > @@ -490,12 +492,12 @@ static void kvm_send_ipi_mask(const struct
> > > cpumask *mask, int vector)
> > >  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask,
> > > int vector)
> > >  {
> > >      unsigned int this_cpu = smp_processor_id();
> > > -    struct cpumask new_mask;
> > > +    struct cpumask *new_mask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
> > >      const struct cpumask *local_mask;
> > >
> > > -    cpumask_copy(&new_mask, mask);
> > > -    cpumask_clear_cpu(this_cpu, &new_mask);
> > > -    local_mask = &new_mask;
> > > +    cpumask_copy(new_mask, mask);
> > > +    cpumask_clear_cpu(this_cpu, new_mask);
> > > +    local_mask = new_mask;
> > >      __send_ipi_mask(local_mask, vector);
> > >  }
> > >
> > > @@ -575,7 +577,6 @@ static void __init kvm_apf_trap_init(void)
> > >      update_intr_gate(X86_TRAP_PF, async_page_fault);
> > >  }
> > >
> > > -static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
> > >
> > >  static void kvm_flush_tlb_others(const struct cpumask *cpumask,
> > >              const struct flush_tlb_info *info)
> > > @@ -583,7 +584,7 @@ static void kvm_flush_tlb_others(const struct
> > > cpumask *cpumask,
> > >      u8 state;
> > >      int cpu;
> > >      struct kvm_steal_time *src;
> > > -    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_tlb_mask);
> > > +    struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
> > >
> > >      cpumask_copy(flushmask, cpumask);
> > >      /*
> > > @@ -624,6 +625,7 @@ static void __init kvm_guest_init(void)
> > >          kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> > >          pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
> > >          pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> > > +        pr_info("KVM setup pv remote TLB flush\n");
> > >      }
> > >
> > >      if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> > > @@ -732,23 +734,30 @@ static __init int activate_jump_labels(void)
> > >  }
> > >  arch_initcall(activate_jump_labels);
> > >
> > > -static __init int kvm_setup_pv_tlb_flush(void)
> > > +static __init int kvm_alloc_cpumask(void)
> > >  {
> > >      int cpu;
> > > +    bool alloc = false;
> > >
> > >      if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
> > >          !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> > > -        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> > > +        kvm_para_has_feature(KVM_FEATURE_STEAL_TIME))
> > > +        alloc = true;
> > > +
> > > +#if defined(CONFIG_SMP)
> > > +    if (!alloc && kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI))
> >
> > '!alloc' check is superfluous.
> >
> > > +        alloc = true;
> > > +#endif
> > > +
> > > +    if (alloc)
> > >          for_each_possible_cpu(cpu) {
> > > -            zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
> > > +            zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
> > >                  GFP_KERNEL, cpu_to_node(cpu));
> > >          }
> > > -        pr_info("KVM setup pv remote TLB flush\n");
> > > -    }
> > >
> > >      return 0;
> > >  }
> > > -arch_initcall(kvm_setup_pv_tlb_flush);
> > > +arch_initcall(kvm_alloc_cpumask);
> >
> > Honestly, I'd simplify the check in kvm_alloc_cpumask() as
> >
> > if (!kvm_para_available())
> >         return;
> >
> > and allocated masks for all other cases.
> 
> This will waste the memory if pv tlb and pv ipis are not exposed which
> are the only users currently.
> 
>     Wanpeng

I am more concerned about printing the "KVM setup pv remote TLB flush" message,
not only when KVM pv is used, but pv TLB flush is not going to be used, but
also when the system is not even paravirtualized.

Cascardo.
