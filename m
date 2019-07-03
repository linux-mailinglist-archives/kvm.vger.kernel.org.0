Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89CB55E5FA
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 16:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfGCOEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 10:04:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:60202 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbfGCOEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 10:04:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B1869AE14;
        Wed,  3 Jul 2019 14:04:22 +0000 (UTC)
Subject: Re: [PATCH v2 4/9] x86/mm/tlb: Flush remote and local TLBs
 concurrently
To:     Nadav Amit <namit@vmware.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190702235151.4377-1-namit@vmware.com>
 <20190702235151.4377-5-namit@vmware.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <d89e2b57-8682-153e-33d8-98084e9983d6@suse.com>
Date:   Wed, 3 Jul 2019 16:04:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190702235151.4377-5-namit@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.07.19 01:51, Nadav Amit wrote:
> To improve TLB shootdown performance, flush the remote and local TLBs
> concurrently. Introduce flush_tlb_multi() that does so. Introduce
> paravirtual versions of flush_tlb_multi() for KVM, Xen and hyper-v (Xen
> and hyper-v are only compile-tested).
> 
> While the updated smp infrastructure is capable of running a function on
> a single local core, it is not optimized for this case. The multiple
> function calls and the indirect branch introduce some overhead, and
> might make local TLB flushes slower than they were before the recent
> changes.
> 
> Before calling the SMP infrastructure, check if only a local TLB flush
> is needed to restore the lost performance in this common case. This
> requires to check mm_cpumask() one more time, but unless this mask is
> updated very frequently, this should impact performance negatively.
> 
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: x86@kernel.org
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: linux-hyperv@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: kvm@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>   arch/x86/hyperv/mmu.c                 | 13 +++---
>   arch/x86/include/asm/paravirt.h       |  6 +--
>   arch/x86/include/asm/paravirt_types.h |  4 +-
>   arch/x86/include/asm/tlbflush.h       |  9 ++--
>   arch/x86/include/asm/trace/hyperv.h   |  2 +-
>   arch/x86/kernel/kvm.c                 | 11 +++--
>   arch/x86/kernel/paravirt.c            |  2 +-
>   arch/x86/mm/tlb.c                     | 65 ++++++++++++++++++++-------
>   arch/x86/xen/mmu_pv.c                 | 20 ++++++---
>   include/trace/events/xen.h            |  2 +-
>   10 files changed, 91 insertions(+), 43 deletions(-)

...

> diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
> index beb44e22afdf..19e481e6e904 100644
> --- a/arch/x86/xen/mmu_pv.c
> +++ b/arch/x86/xen/mmu_pv.c
> @@ -1355,8 +1355,8 @@ static void xen_flush_tlb_one_user(unsigned long addr)
>   	preempt_enable();
>   }
>   
> -static void xen_flush_tlb_others(const struct cpumask *cpus,
> -				 const struct flush_tlb_info *info)
> +static void xen_flush_tlb_multi(const struct cpumask *cpus,
> +				const struct flush_tlb_info *info)
>   {
>   	struct {
>   		struct mmuext_op op;
> @@ -1366,7 +1366,7 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
>   	const size_t mc_entry_size = sizeof(args->op) +
>   		sizeof(args->mask[0]) * BITS_TO_LONGS(num_possible_cpus());
>   
> -	trace_xen_mmu_flush_tlb_others(cpus, info->mm, info->start, info->end);
> +	trace_xen_mmu_flush_tlb_multi(cpus, info->mm, info->start, info->end);
>   
>   	if (cpumask_empty(cpus))
>   		return;		/* nothing to do */
> @@ -1375,9 +1375,17 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
>   	args = mcs.args;
>   	args->op.arg2.vcpumask = to_cpumask(args->mask);
>   
> -	/* Remove us, and any offline CPUS. */
> +	/* Flush locally if needed and remove us */
> +	if (cpumask_test_cpu(smp_processor_id(), to_cpumask(args->mask))) {
> +		local_irq_disable();
> +		flush_tlb_func_local(info);

I think this isn't the correct function for PV guests.

In fact it should be much easier: just don't clear the own cpu from the
mask, that's all what's needed. The hypervisor is just fine having the
current cpu in the mask and it will do the right thing.


Juergen
