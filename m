Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEAA31CA6A
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 13:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhBPMMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 07:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhBPMMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 07:12:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB45C061574;
        Tue, 16 Feb 2021 04:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qydaGrdRobsyV5LaMgil96UsQSn4K3xiCgp4dxh0juc=; b=W1OSaSNnkgJkSGPTgy8i13Fnth
        Q3yMBTUQI35ZC32HOj6lyR72QpKJCByW9IX627qEuospypeWxHjJGIexIeRPMxqE0ne9uQQtNhjrq
        bpoTv7CK6Y9Cg9FFNDqGjoFa67aUgp2jyFviMRH0o/L4iQMLWden+bu1eFoSy6H1so5yKTP+0qufM
        SbTdZckJ2IAXD57Vh/FXcxwpn5F8FXBRV1s8PxB45PtPKblZ4qOdDNxWQBJdHGBMLZWA/6dB/GbRW
        Ryy2BGjIC60/A5VLY8h27Nsvwue8yeJOw2/C9GZKFS6+uYPlFf8abXeJ8FKrixF4vTrxoLGrcBvM1
        rJh/I4Uw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lBzBS-00GpyS-Qf; Tue, 16 Feb 2021 12:10:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BCFB13059DD;
        Tue, 16 Feb 2021 13:10:25 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A5D6B2B9C6CCA; Tue, 16 Feb 2021 13:10:25 +0100 (CET)
Date:   Tue, 16 Feb 2021 13:10:25 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Nadav Amit <namit@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: [PATCH v5 4/8] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Message-ID: <YCu2MQFdV4JTrUQb@hirez.programming.kicks-ass.net>
References: <20210209221653.614098-1-namit@vmware.com>
 <20210209221653.614098-5-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209221653.614098-5-namit@vmware.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 09, 2021 at 02:16:49PM -0800, Nadav Amit wrote:
> @@ -816,8 +821,8 @@ STATIC_NOPV void native_flush_tlb_others(const struct cpumask *cpumask,
>  	 * doing a speculative memory access.
>  	 */
>  	if (info->freed_tables) {
> -		smp_call_function_many(cpumask, flush_tlb_func,
> -			       (void *)info, 1);
> +		on_each_cpu_cond_mask(NULL, flush_tlb_func, (void *)info, true,
> +				      cpumask);
>  	} else {
>  		/*
>  		 * Although we could have used on_each_cpu_cond_mask(),
> @@ -844,14 +849,15 @@ STATIC_NOPV void native_flush_tlb_others(const struct cpumask *cpumask,
>  			if (tlb_is_not_lazy(cpu))
>  				__cpumask_set_cpu(cpu, cond_cpumask);
>  		}
> -		smp_call_function_many(cond_cpumask, flush_tlb_func, (void *)info, 1);
> +		on_each_cpu_cond_mask(NULL, flush_tlb_func, (void *)info, true,
> +				      cpumask);
>  	}
>  }

Surely on_each_cpu_mask() is more appropriate? There the compiler can do
the NULL propagation because it's on the same TU.

--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -821,8 +821,7 @@ STATIC_NOPV void native_flush_tlb_multi(
 	 * doing a speculative memory access.
 	 */
 	if (info->freed_tables) {
-		on_each_cpu_cond_mask(NULL, flush_tlb_func, (void *)info, true,
-				      cpumask);
+		on_each_cpu_mask(cpumask, flush_tlb_func, (void *)info, true);
 	} else {
 		/*
 		 * Although we could have used on_each_cpu_cond_mask(),
@@ -849,8 +848,7 @@ STATIC_NOPV void native_flush_tlb_multi(
 			if (tlb_is_not_lazy(cpu))
 				__cpumask_set_cpu(cpu, cond_cpumask);
 		}
-		on_each_cpu_cond_mask(NULL, flush_tlb_func, (void *)info, true,
-				      cpumask);
+		on_each_cpu_mask(cpumask, flush_tlb_func, (void *)info, true);
 	}
 }
 
