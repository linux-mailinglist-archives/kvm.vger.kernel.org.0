Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F421F5D66
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 22:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgFJUvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 16:51:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46956 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726219AbgFJUvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 16:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591822311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wx1Cvf9b4/zU+gybY0Ipd+7i6O1L1edxhTOVA+WWBZs=;
        b=VVcOroS7LRgHyQM5qw9zgR06UzrE/VNBTlbc3Ms8yUh0u4N3SFiwZau8tmG5qpkNm4za13
        VLkSmk2SGcQZ1hT6gKaKouXw2bNRD+I9y3C1UigzrqMZUainrhQKHrcLP0+QHwTjs5ac4k
        BojB46vlNPu7fJYI4b4TVomln3GMENE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-kkLmtWrVPeapGcTAMWwRLg-1; Wed, 10 Jun 2020 16:51:49 -0400
X-MC-Unique: kkLmtWrVPeapGcTAMWwRLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E150800053;
        Wed, 10 Jun 2020 20:51:47 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-64.rdu2.redhat.com [10.10.115.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 877771002388;
        Wed, 10 Jun 2020 20:51:46 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id DDC5A2205BD; Wed, 10 Jun 2020 16:51:45 -0400 (EDT)
Date:   Wed, 10 Jun 2020 16:51:45 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/10] KVM: x86: Switch KVM guest to using interrupts
 for page ready APF delivery
Message-ID: <20200610205145.GC243520@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com>
 <20200525144125.143875-9-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525144125.143875-9-vkuznets@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 04:41:23PM +0200, Vitaly Kuznetsov wrote:
> KVM now supports using interrupt for 'page ready' APF event delivery and
> legacy mechanism was deprecated. Switch KVM guests to the new one.

Hi Vitaly,

I see we have all this code in guest which tries to take care of
cases where PAGE_READY can be delivered before PAGE_NOT_PRESENT. In
this new schedume of things, can it still happen. We are using
an exception to deliver PAGE_NOT_PRESENT while using interrupt to
deliver PAGE_READY.

If re-ordeing is not possible, then it will be good to get rid of
that extra complexity in guest.

Thanks
Vivek

> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/entry/entry_32.S          |  5 ++++
>  arch/x86/entry/entry_64.S          |  5 ++++
>  arch/x86/include/asm/hardirq.h     |  3 ++
>  arch/x86/include/asm/irq_vectors.h |  6 +++-
>  arch/x86/include/asm/kvm_para.h    |  6 ++++
>  arch/x86/kernel/irq.c              |  9 ++++++
>  arch/x86/kernel/kvm.c              | 45 ++++++++++++++++++++++--------
>  7 files changed, 66 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
> index b67bae7091d7..d574dadcb2a1 100644
> --- a/arch/x86/entry/entry_32.S
> +++ b/arch/x86/entry/entry_32.S
> @@ -1475,6 +1475,11 @@ BUILD_INTERRUPT3(hv_stimer0_callback_vector, HYPERV_STIMER0_VECTOR,
>  
>  #endif /* CONFIG_HYPERV */
>  
> +#ifdef CONFIG_KVM_GUEST
> +BUILD_INTERRUPT3(kvm_async_pf_vector, KVM_ASYNC_PF_VECTOR,
> +		 kvm_async_pf_intr)
> +#endif
> +
>  SYM_CODE_START(page_fault)
>  	ASM_CLAC
>  	pushl	$do_page_fault
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 3063aa9090f9..138f5c5aca2e 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -1190,6 +1190,11 @@ apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
>  	acrn_hv_callback_vector acrn_hv_vector_handler
>  #endif
>  
> +#ifdef CONFIG_KVM_GUEST
> +apicinterrupt3 KVM_ASYNC_PF_VECTOR \
> +	kvm_async_pf_vector kvm_async_pf_intr
> +#endif
> +
>  idtentry debug			do_debug		has_error_code=0	paranoid=1 shift_ist=IST_INDEX_DB ist_offset=DB_STACK_OFFSET
>  idtentry int3			do_int3			has_error_code=0	create_gap=1
>  idtentry stack_segment		do_stack_segment	has_error_code=1
> diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
> index 07533795b8d2..be0fbb15ad7f 100644
> --- a/arch/x86/include/asm/hardirq.h
> +++ b/arch/x86/include/asm/hardirq.h
> @@ -44,6 +44,9 @@ typedef struct {
>  	unsigned int irq_hv_reenlightenment_count;
>  	unsigned int hyperv_stimer0_count;
>  #endif
> +#ifdef CONFIG_KVM_GUEST
> +	unsigned int kvm_async_pf_pageready_count;
> +#endif
>  } ____cacheline_aligned irq_cpustat_t;
>  
>  DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
> index 889f8b1b5b7f..8879a9ecd908 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -104,7 +104,11 @@
>  #define HYPERV_STIMER0_VECTOR		0xed
>  #endif
>  
> -#define LOCAL_TIMER_VECTOR		0xec
> +#ifdef CONFIG_KVM_GUEST
> +#define KVM_ASYNC_PF_VECTOR		0xec
> +#endif
> +
> +#define LOCAL_TIMER_VECTOR		0xeb
>  
>  #define NR_VECTORS			 256
>  
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 2a3102fee189..a075cd8fa5c7 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -4,6 +4,7 @@
>  
>  #include <asm/processor.h>
>  #include <asm/alternative.h>
> +#include <linux/interrupt.h>
>  #include <uapi/asm/kvm_para.h>
>  
>  extern void kvmclock_init(void);
> @@ -93,6 +94,11 @@ void kvm_async_pf_task_wake(u32 token);
>  u32 kvm_read_and_reset_apf_flags(void);
>  extern void kvm_disable_steal_time(void);
>  void do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address);
> +extern __visible void kvm_async_pf_vector(void);
> +#ifdef CONFIG_TRACING
> +#define trace_kvm_async_pf_vector kvm_async_pf_vector
> +#endif
> +__visible void __irq_entry kvm_async_pf_intr(struct pt_regs *regs);
>  
>  #ifdef CONFIG_PARAVIRT_SPINLOCKS
>  void __init kvm_spinlock_init(void);
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index c7965ff429c5..a4c2f25ad74d 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -159,6 +159,15 @@ int arch_show_interrupts(struct seq_file *p, int prec)
>  				   irq_stats(j)->hyperv_stimer0_count);
>  		seq_puts(p, "  Hyper-V stimer0 interrupts\n");
>  	}
> +#endif
> +#ifdef CONFIG_KVM_GUEST
> +	if (test_bit(KVM_ASYNC_PF_VECTOR, system_vectors)) {
> +		seq_printf(p, "%*s: ", prec, "APF");
> +		for_each_online_cpu(j)
> +			seq_printf(p, "%10u ",
> +				   irq_stats(j)->kvm_async_pf_pageready_count);
> +		seq_puts(p, "  KVM async PF page ready interrupts\n");
> +	}
>  #endif
>  	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
>  #if defined(CONFIG_X86_IO_APIC)
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 340df5dab30d..79730eaef1e1 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -245,23 +245,39 @@ NOKPROBE_SYMBOL(kvm_read_and_reset_apf_flags);
>  dotraplinkage void
>  do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address)
>  {
> -	switch (kvm_read_and_reset_apf_flags()) {
> -	default:
> +	u32 flags = kvm_read_and_reset_apf_flags();
> +
> +	if (!flags) {
> +		/* This is a normal page fault */
>  		do_page_fault(regs, error_code, address);
> -		break;
> -	case KVM_PV_REASON_PAGE_NOT_PRESENT:
> +		return;
> +	} else if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
>  		/* page is swapped out by the host. */
>  		kvm_async_pf_task_wait((u32)address, !user_mode(regs));
> -		break;
> -	case KVM_PV_REASON_PAGE_READY:
> -		rcu_irq_enter();
> -		kvm_async_pf_task_wake((u32)address);
> -		rcu_irq_exit();
> -		break;
> +	} else {
> +		WARN_ONCE(1, "Unexpected async PF flags: %x\n", flags);
>  	}
>  }
>  NOKPROBE_SYMBOL(do_async_page_fault);
>  
> +__visible void __irq_entry kvm_async_pf_intr(struct pt_regs *regs)
> +{
> +	u32 token;
> +
> +	entering_ack_irq();
> +
> +	inc_irq_stat(kvm_async_pf_pageready_count);
> +
> +	if (__this_cpu_read(apf_reason.enabled)) {
> +		token = __this_cpu_read(apf_reason.token);
> +		kvm_async_pf_task_wake(token);
> +		__this_cpu_write(apf_reason.token, 0);
> +		wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
> +	}
> +
> +	exiting_irq();
> +}
> +
>  static void __init paravirt_ops_setup(void)
>  {
>  	pv_info.name = "KVM";
> @@ -305,17 +321,19 @@ static notrace void kvm_guest_apic_eoi_write(u32 reg, u32 val)
>  
>  static void kvm_guest_cpu_init(void)
>  {
> -	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) && kvmapf) {
> +	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
>  		u64 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
>  
>  #ifdef CONFIG_PREEMPTION
>  		pa |= KVM_ASYNC_PF_SEND_ALWAYS;
>  #endif
> -		pa |= KVM_ASYNC_PF_ENABLED;
> +		pa |= KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
>  
>  		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
>  			pa |= KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
>  
> +		wrmsrl(MSR_KVM_ASYNC_PF_INT, KVM_ASYNC_PF_VECTOR);
> +
>  		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
>  		__this_cpu_write(apf_reason.enabled, 1);
>  		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
> @@ -649,6 +667,9 @@ static void __init kvm_guest_init(void)
>  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>  		apic_set_eoi_write(kvm_guest_apic_eoi_write);
>  
> +	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT))
> +		alloc_intr_gate(KVM_ASYNC_PF_VECTOR, kvm_async_pf_vector);
> +
>  #ifdef CONFIG_SMP
>  	smp_ops.smp_prepare_cpus = kvm_smp_prepare_cpus;
>  	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
> -- 
> 2.25.4
> 

