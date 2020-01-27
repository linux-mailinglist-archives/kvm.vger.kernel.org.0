Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27671149F81
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 09:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgA0IKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 03:10:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56232 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA0IKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 03:10:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NSkXKOkLVFSqskr8Fv8C50qKSUgO0Fch8+tEjDsF97E=; b=F4hAZJLK7Fe2reLHo/KcRVnHz
        0Z8pBkj5nWzXnOz7AKhokwWpIjmIr+RMt6mUxbe1naCa2WJE5MDnXarGvxwFNNinfvMQqbrjEcXjy
        nLRoVrupuxBlAXhn/0MiqkhQ1G1NiDaj7IwcCKW/0JlURpDfwNnZxwfpMpZ8kRvF1fWhcuOmynjPE
        NcEFeH37cjRNaUhPuN7GBOmhQ8/sAiPatuige+3tUyGRoLMCG2qg2wESc1KELSf0u8NDu1ZhXylb/
        kmdqyd7feqDD/2g5BzYWwC9oKl1t30bva3v5s2XRn+NNWzKLVL4yqOoLrqhVS7jVngUj0xo7V+tsq
        0aqGhlCrw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivzSk-0004Vq-1F; Mon, 27 Jan 2020 08:09:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 437B2300F4B;
        Mon, 27 Jan 2020 09:07:54 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 08180203CF5D4; Mon, 27 Jan 2020 09:09:36 +0100 (CET)
Date:   Mon, 27 Jan 2020 09:09:36 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nick Desaulniers <nick.desaulniers@gmail.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] dynamically allocate struct cpumask
Message-ID: <20200127080935.GH14914@hirez.programming.kicks-ass.net>
References: <20200127071602.11460-1-nick.desaulniers@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127071602.11460-1-nick.desaulniers@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 26, 2020 at 11:16:02PM -0800, Nick Desaulniers wrote:
> This helps avoid avoid a potentially large stack allocation.
> 
> When building with:
> $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
> The following warning is observed:
> arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
> function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
> static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
> vector)
>             ^
> Debugging with:
> https://github.com/ClangBuiltLinux/frame-larger-than
> via:
> $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
>   kvm_send_ipi_mask_allbutself
> points to the stack allocated `struct cpumask newmask` in
> `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
> potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
> the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
> 8192, making a single instance of a `struct cpumask` 1024 B.
> 
> Signed-off-by: Nick Desaulniers <nick.desaulniers@gmail.com>
> ---
>  arch/x86/kernel/kvm.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 32ef1ee733b7..d41c0a0d62a2 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -494,13 +494,15 @@ static void kvm_send_ipi_mask(const struct cpumask *mask, int vector)
>  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
>  {
>  	unsigned int this_cpu = smp_processor_id();
> -	struct cpumask new_mask;

Right, on stack cpumask is definitely dodgy.

> +	struct cpumask *new_mask;
>  	const struct cpumask *local_mask;
>  
> -	cpumask_copy(&new_mask, mask);
> -	cpumask_clear_cpu(this_cpu, &new_mask);
> -	local_mask = &new_mask;
> +	new_mask = kmalloc(sizeof(*new_mask), GFP_KERNEL);
> +	cpumask_copy(new_mask, mask);
> +	cpumask_clear_cpu(this_cpu, new_mask);
> +	local_mask = new_mask;
>  	__send_ipi_mask(local_mask, vector);
> +	kfree(new_mask);
>  }

One alternative approach is adding the inverse of cpu_bit_bitmap. I'm
not entirely sure how often we need the all-but-self mask, but ISTR
there were other places too.
