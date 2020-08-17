Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D934245E98
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 09:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHQH4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 03:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgHQH43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 03:56:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F70C061388;
        Mon, 17 Aug 2020 00:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YFe2M9qNEESzBDrGBKXESj8fKVBytShtkStVuIOD0aA=; b=vso+itO36itlX33V0OujrEVXWQ
        XWOCxai+RblU2HPFcG4y0Jc/Kkch/9519feMu5s/JjVi8kTLvzWVt8mnTUGqV4Cb0+I7Er/hrvthc
        R5N5OM5tAoW96hS2ye5pIEl5nQyNJqrubGMtqCszVVtBspv2srl07dDEa0F0G5/gUA8aGKzpkXLYw
        k2FAT2VzLtDegOEIEu/RnyZWL67Q6tIa0g3HdMf5fJsLoy7kJpkCWoMxdwZAeVACFh2c1TNo70QSF
        RrBuxRTwIiQOv2qfehbS/TwK0O9StnS8IXlzcdtzsMWBP0oe9HCdG02oaTJxZC/LAuCvtA74Y4YvV
        PaxCkggg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7ZzV-0002Uv-HF; Mon, 17 Aug 2020 07:55:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 892D0303271;
        Mon, 17 Aug 2020 09:55:33 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5DF642BFDE0AB; Mon, 17 Aug 2020 09:55:33 +0200 (CEST)
Date:   Mon, 17 Aug 2020 09:55:33 +0200
From:   peterz@infradead.org
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     linux-mips@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Burton <paulburton@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        WANG Xuerui <git@xen0n.name>,
        =?utf-8?B?5ZGo55Cw5p2w?= <zhouyanjie@wanyeetech.com>,
        Liangliang Huang <huanglllzu@gmail.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Xu <peterx@redhat.com>,
        Sergey Korolev <s.korolev@ndmsystems.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Marc Zyngier <maz@kernel.org>, Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atish.patra@wdc.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Steven Price <steven.price@arm.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/7] MIPS: sync-r4k: Rework to be many cores firendly
Message-ID: <20200817075533.GI2674@hirez.programming.kicks-ass.net>
References: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
 <20200817034701.3515721-2-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817034701.3515721-2-jiaxun.yang@flygoat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 17, 2020 at 11:46:40AM +0800, Jiaxun Yang wrote:
> Here we reworked the whole procdure. Now the synchronise event on CPU0
> is triggered by smp call function, and we won't touch the count on CPU0
> at all.

Are you telling me, that in 2020 you're building chips that need
horrible crap like this ?!?

> +#define MAX_LOOPS	1000
> +
> +void synchronise_count_master(void *unused)
>  {
>  	unsigned long flags;
> +	long delta;
> +	int i;
>  
> +	if (atomic_read(&sync_stage) != STAGE_START)
> +		BUG();

	BUG_ON(atomic_read(&sync_state) != STAGE_START);

>  
>  	local_irq_save(flags);

That's silly, replace with: lockdep_assert_hardirqs_disabled().

>  
> +	cur_count = read_c0_count();
> +	smp_wmb();
> +	atomic_inc(&sync_stage); /* inc to STAGE_MASTER_READY */

memory barriers require a comment that describes the ordering. This
includes at least 2 variables and at least 2 code paths (*) -- afaict
your code does NOT have a matching barrier, see below.

>  
> +	for (i = 0; i < MAX_LOOPS; i++) {
> +		cur_count = read_c0_count();
>  		smp_wmb();
> -		atomic_inc(&count_count_stop);
> +		if (atomic_read(&sync_stage) == STAGE_SLAVE_SYNCED)
> +			break;
>  	}
> +
> +	delta = read_c0_count() - fini_count;
>  
>  	local_irq_restore(flags);
>  
> +	if (i == MAX_LOOPS)
> +		pr_err("sync-r4k: Master: synchronise timeout\n");
> +	else
> +		pr_info("sync-r4k: Master: synchronise succeed, maximum delta: %ld\n", delta);
> +
> +	return;
>  }
>  
>  void synchronise_count_slave(int cpu)
>  {
>  	int i;
>  	unsigned long flags;
> +	call_single_data_t csd;
>  
> +	raw_spin_lock(&sync_r4k_lock);

Why should this be a raw_spnilock_t ?

>  
> +	/* Let variables get attention from cache */
> +	for (i = 0; i < MAX_LOOPS; i++) {
> +		cur_count++;
> +		fini_count += cur_count;
> +		cur_count += fini_count;
>  	}

What does this actually do? You're going to bounce those variables
between this CPU and CPU-0.

> +
> +	atomic_set(&sync_stage, STAGE_START);
> +	csd.func = synchronise_count_master;
> +
> +	/* Master count is always CPU0 */
> +	if (smp_call_function_single_async(0, &csd)) {

This is diguisting.

It also requires a comment on how the on-stack csd is correct (it is,
but it really needs a comment).

> +		pr_err("sync-r4k: Salve: Failed to call master\n");
> +		raw_spin_unlock(&sync_r4k_lock);
> +		return;
> +	}
> +
> +	local_irq_save(flags);
> +
> +	/* Wait until master ready */
> +	while (atomic_read(&sync_stage) != STAGE_MASTER_READY)
> +		cpu_relax();

This really wants to be:

	atomic_cond_read_acquire(&&sync_stage, VAL == STAGE_MASTER_READY);

Because, afaict the smp_wmb() (*) in synchronize_count_master() order
against this here and we need to guarantee we read @sync_stage _before_
@cur_count.

> +
> +	write_c0_count(cur_count);
> +	fini_count = read_c0_count();
> +	smp_wmb();
> +	atomic_inc(&sync_stage); /* inc to STAGE_SLAVE_SYNCED */
>  
>  	local_irq_restore(flags);
> +
> +	raw_spin_unlock(&sync_r4k_lock);
>  }


Furthermore, afaict there isn't actually any concurrency on @sync_stage,
so atomic_t isn't required, Using smp_store_release() to change state
might be far more natural.
