Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE57770982
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 21:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbfGVTO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 15:14:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37208 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbfGVTO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 15:14:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k0Aa1oppo5fgpAqfdlhMZ/Y4FyX3KZF6G5NCMud93Ao=; b=tFFSxg0Nh2G+2z2wXW0kiyQe9
        pI4T7G3Po/BYJUF/dTPfTtYTgQHndHYOd2T3x5vPyfQZtBEJDEV7Xt5vAcjXDgaWEw4hezIOsAWe3
        A2p+EpI6mVaVlp/IsZk/mF7nTueQPBJ6AbJtJqubeRcoEmKj/FJop4YqiSX6x8lknsw8kuXc0WRQb
        nyIaiojxTFS93l+DLFa2hieuFTcZY00msSqMv6iMkyx2kCLXLEHLo8StTtaVB+666J8E/BchkXa4r
        5Q13HKIfQNErihSnxd261MYESBOoNhZz9yo+v99LWxzP2Es2+1OW+GCzOXThbLpB1IJqJw8ZXTNka
        kw4vEbxfw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hpdlc-00068v-1I; Mon, 22 Jul 2019 19:14:36 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id D99D6980C6E; Mon, 22 Jul 2019 21:14:33 +0200 (CEST)
Date:   Mon, 22 Jul 2019 21:14:33 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 4/9] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Message-ID: <20190722191433.GD6698@worktop.programming.kicks-ass.net>
References: <20190719005837.4150-1-namit@vmware.com>
 <20190719005837.4150-5-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719005837.4150-5-namit@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 18, 2019 at 05:58:32PM -0700, Nadav Amit wrote:
> @@ -709,8 +716,9 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
>  	 * doing a speculative memory access.
>  	 */
>  	if (info->freed_tables) {
> -		smp_call_function_many(cpumask, flush_tlb_func_remote,
> -			       (void *)info, 1);
> +		__smp_call_function_many(cpumask, flush_tlb_func_remote,
> +					 flush_tlb_func_local,
> +					 (void *)info, 1);
>  	} else {
>  		/*
>  		 * Although we could have used on_each_cpu_cond_mask(),
> @@ -737,7 +745,8 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
>  			if (tlb_is_not_lazy(cpu))
>  				__cpumask_set_cpu(cpu, cond_cpumask);
>  		}
> -		smp_call_function_many(cond_cpumask, flush_tlb_func_remote,
> +		__smp_call_function_many(cond_cpumask, flush_tlb_func_remote,
> +					 flush_tlb_func_local,
>  					 (void *)info, 1);
>  	}
>  }

Do we really need that _local/_remote distinction? ISTR you had a patch
that frobbed flush_tlb_info into the csd and that gave space
constraints, but I'm not seeing that here (probably a wise, get stuff
merged etc..).

struct __call_single_data {
        struct llist_node          llist;                /*     0     8 */
        smp_call_func_t            func;                 /*     8     8 */
        void *                     info;                 /*    16     8 */
        unsigned int               flags;                /*    24     4 */

        /* size: 32, cachelines: 1, members: 4 */
        /* padding: 4 */
        /* last cacheline: 32 bytes */
};

struct flush_tlb_info {
        struct mm_struct *         mm;                   /*     0     8 */
        long unsigned int          start;                /*     8     8 */
        long unsigned int          end;                  /*    16     8 */
        u64                        new_tlb_gen;          /*    24     8 */
        unsigned int               stride_shift;         /*    32     4 */
        bool                       freed_tables;         /*    36     1 */

        /* size: 40, cachelines: 1, members: 6 */
        /* padding: 3 */
        /* last cacheline: 40 bytes */
};

IIRC what you did was make void *__call_single_data::info the last
member and a union until the full cacheline size (64). Given the above
that would get us 24 bytes for csd, leaving us 40 for that
flush_tlb_info.

But then we can still do something like the below, which doesn't change
things and still gets rid of that dual function crud, simplifying
smp_call_function_many again.

Index: linux-2.6/arch/x86/include/asm/tlbflush.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/tlbflush.h
+++ linux-2.6/arch/x86/include/asm/tlbflush.h
@@ -546,8 +546,9 @@ struct flush_tlb_info {
 	unsigned long		start;
 	unsigned long		end;
 	u64			new_tlb_gen;
-	unsigned int		stride_shift;
-	bool			freed_tables;
+	unsigned int		cpu;
+	unsigned short		stride_shift;
+	unsigned char		freed_tables;
 };
 
 #define local_flush_tlb() __flush_tlb()
Index: linux-2.6/arch/x86/mm/tlb.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/tlb.c
+++ linux-2.6/arch/x86/mm/tlb.c
@@ -659,6 +659,27 @@ static void flush_tlb_func_remote(void *
 	flush_tlb_func_common(f, false, TLB_REMOTE_SHOOTDOWN);
 }
 
+static void flush_tlb_func(void *info)
+{
+	const struct flush_tlb_info *f = info;
+	enum tlb_flush_reason reason = TLB_REMOTE_SHOOTDOWN;
+	bool local = false;
+
+	if (f->cpu == smp_processor_id()) {
+		local = true;
+		reason = (f->mm == NULL) ? TLB_LOCAL_SHOOTDOWN : TLB_LOCAL_MM_SHOOTDOWN;
+	} else {
+		inc_irq_stat(irq_tlb_count);
+
+		if (f->mm && f->mm != this_cpu_read(cpu_tlbstate.loaded_mm))
+			return;
+
+		count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
+	}
+
+	flush_tlb_func_common(f, local, reason);
+}
+
 static bool tlb_is_not_lazy(int cpu)
 {
 	return !per_cpu(cpu_tlbstate_shared.is_lazy, cpu);

