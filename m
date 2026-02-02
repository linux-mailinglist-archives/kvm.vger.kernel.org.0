Return-Path: <kvm+bounces-69824-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2I9IMbNxgGkw8QIAu9opvQ
	(envelope-from <kvm+bounces-69824-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 10:43:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B21CA383
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 10:43:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D70593006166
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 09:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B2B333A9FF;
	Mon,  2 Feb 2026 09:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fkusEo0w"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259B921FF48;
	Mon,  2 Feb 2026 09:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770025386; cv=none; b=kTPbV/umljbqKmbs9rNLTwkLO7U8S0iQJvtZrUvZBVHdvn+Ywhds8qmy8FI9B7nWMC2e4fuSJgwE1alEJL+gVsjyMURDfJZgHCy/tAkGCO8QIbmQ4T5MKSdLEsrfivEC4hyA9u6s6ooRzIjZfiwKCURNSzKPKcEL/cNU+Biluls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770025386; c=relaxed/simple;
	bh=tLA+tzw5u4QKG+h1GZMJP0ghvsHnZtO9Od7wqNAsb/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ALH0Uz1Ryl8k052f0hEu0LLW30cqqWbi0xeItquCG3JoH5D8/QrNMW2A0C3yJ4gPQbhrNwJ0TsyH9TE07b4OosL7k3RFqmwVvL7Zaz3ZS4TO0eqvUmA5CFVCzegiw9TB9pXmaNVZDEWCSGk+9t5K63+9bnQJWC7q4ACa/puoJs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fkusEo0w; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oA2mTx9XxUiJSxogtOuiyEA+2ImHcX6vZMJQITNKwPc=; b=fkusEo0wd83Wa+L6nS30Qd162p
	ooargwvzx45CzCG/9menBx8zHXd/kf6ILBhmg/+4byhOZPPH5/5T229MsFqHRvyq8F3qMK625FUKz
	YCh8TbBO0DrR1CYh+BQbEsCLhgDP0yLcCtPQCHQt/yiKFVDA5ABlds80znO+r3NqzqNtmQ6R8ibD1
	5mPJJ+k2cYE8/eek30ShsvYFdJhMh9rAVO8BY6GgcdSxiCpNAkjyyWAr1MyHaJHJv3ZOBFlygNuD6
	OY/ALWvrbTQ9kSq3L/XI6B77BZk5qppABWQ1pt4kPrw+SE2tjjbeAZwxzfuezIZS1NeTUS1MLI6gY
	/cypfgGw==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmqSE-0000000EBfi-1iKT;
	Mon, 02 Feb 2026 09:42:46 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3A4FC303047; Mon, 02 Feb 2026 10:42:45 +0100 (CET)
Date: Mon, 2 Feb 2026 10:42:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com,
	riel@surriel.com, jannh@google.com, jgross@suse.com,
	seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH v4 1/3] mm: use targeted IPIs for TLB sync with lockless
 page table walkers
Message-ID: <20260202094245.GD2995752@noisy.programming.kicks-ass.net>
References: <20260202074557.16544-1-lance.yang@linux.dev>
 <20260202074557.16544-2-lance.yang@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202074557.16544-2-lance.yang@linux.dev>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69824-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[linux-foundation.org,kernel.org,intel.com,linux.intel.com,redhat.com,google.com,gmail.com,linutronix.de,alien8.de,zytor.com,arndb.de,oracle.com,nvidia.com,linux.alibaba.com,arm.com,surriel.com,suse.com,lists.linux.dev,vger.kernel.org,kvack.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[37];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,noisy.programming.kicks-ass.net:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: B2B21CA383
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 03:45:55PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> Currently, tlb_remove_table_sync_one() broadcasts IPIs to all CPUs to wait
> for any concurrent lockless page table walkers (e.g., GUP-fast). This is
> inefficient on systems with many CPUs, especially for RT workloads[1].
> 
> This patch introduces a per-CPU tracking mechanism to record which CPUs are
> actively performing lockless page table walks for a specific mm_struct.
> When freeing/unsharing page tables, we can now send IPIs only to the CPUs
> that are actually walking that mm, instead of broadcasting to all CPUs.
> 
> In preparation for targeted IPIs; a follow-up will switch callers to
> tlb_remove_table_sync_mm().
> 
> Note that the tracking adds ~3% latency to GUP-fast, as measured on a
> 64-core system.

What architecture, and that is acceptable?

> +/*
> + * Track CPUs doing lockless page table walks to avoid broadcast IPIs
> + * during TLB flushes.
> + */
> +DECLARE_PER_CPU(struct mm_struct *, active_lockless_pt_walk_mm);
> +
> +static inline void pt_walk_lockless_start(struct mm_struct *mm)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	/*
> +	 * Tell other CPUs we're doing lockless page table walk.
> +	 *
> +	 * Full barrier needed to prevent page table reads from being
> +	 * reordered before this write.
> +	 *
> +	 * Pairs with smp_rmb() in tlb_remove_table_sync_mm().
> +	 */
> +	this_cpu_write(active_lockless_pt_walk_mm, mm);
> +	smp_mb();

One thing to try is something like:

	xchg(this_cpu_ptr(&active_lockless_pt_walk_mm), mm);

That *might* be a little better on x86_64, on anything else you really
don't want to use this_cpu_() ops when you *know* IRQs are already
disabled.

> +}
> +
> +static inline void pt_walk_lockless_end(void)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	/*
> +	 * Clear the pointer so other CPUs no longer see this CPU as walking
> +	 * the mm. Use smp_store_release to ensure page table reads complete
> +	 * before the clear is visible to other CPUs.
> +	 */
> +	smp_store_release(this_cpu_ptr(&active_lockless_pt_walk_mm), NULL);
> +}
> +
>  int get_user_pages_fast(unsigned long start, int nr_pages,
>  			unsigned int gup_flags, struct page **pages);
>  int pin_user_pages_fast(unsigned long start, int nr_pages,

> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 2faa23d7f8d4..35c89e4b6230 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -285,6 +285,56 @@ void tlb_remove_table_sync_one(void)
>  	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
>  }
>  
> +DEFINE_PER_CPU(struct mm_struct *, active_lockless_pt_walk_mm);
> +EXPORT_PER_CPU_SYMBOL_GPL(active_lockless_pt_walk_mm);

Why the heck is this exported? Both users are firmly core code.

> +/**
> + * tlb_remove_table_sync_mm - send IPIs to CPUs doing lockless page table
> + * walk for @mm
> + *
> + * @mm: target mm; only CPUs walking this mm get an IPI.
> + *
> + * Like tlb_remove_table_sync_one() but only targets CPUs in
> + * active_lockless_pt_walk_mm.
> + */
> +void tlb_remove_table_sync_mm(struct mm_struct *mm)
> +{
> +	cpumask_var_t target_cpus;
> +	bool found_any = false;
> +	int cpu;
> +
> +	if (WARN_ONCE(!mm, "NULL mm in %s\n", __func__)) {
> +		tlb_remove_table_sync_one();
> +		return;
> +	}
> +
> +	/* If we can't, fall back to broadcast. */
> +	if (!alloc_cpumask_var(&target_cpus, GFP_ATOMIC)) {
> +		tlb_remove_table_sync_one();
> +		return;
> +	}
> +
> +	cpumask_clear(target_cpus);
> +
> +	/* Pairs with smp_mb() in pt_walk_lockless_start(). */

Pairs how? The start thing does something like:

	[W] active_lockless_pt_walk_mm = mm
	MB
	[L] page-tables

So this is:

	[L] page-tables
	RMB
	[L] active_lockless_pt_walk_mm

?

> +	smp_rmb();
> +
> +	/* Find CPUs doing lockless page table walks for this mm */
> +	for_each_online_cpu(cpu) {
> +		if (per_cpu(active_lockless_pt_walk_mm, cpu) == mm) {
> +			cpumask_set_cpu(cpu, target_cpus);

You really don't need this to be atomic.

> +			found_any = true;
> +		}
> +	}
> +
> +	/* Only send IPIs to CPUs actually doing lockless walks */
> +	if (found_any)
> +		smp_call_function_many(target_cpus, tlb_remove_table_smp_sync,
> +				       NULL, 1);

Coding style wants { } here. Also, isn't this what we have
smp_call_function_many_cond() for?

> +	free_cpumask_var(target_cpus);
> +}
> +
>  static void tlb_remove_table_rcu(struct rcu_head *head)
>  {
>  	__tlb_remove_table_free(container_of(head, struct mmu_table_batch, rcu));
> -- 
> 2.49.0
> 

