Return-Path: <kvm+bounces-69841-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MJTfFSmWgGnL/gIAu9opvQ
	(envelope-from <kvm+bounces-69841-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 13:18:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C8187CC47F
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 13:18:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 43888302C350
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 12:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE403659EB;
	Mon,  2 Feb 2026 12:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c43ucQG9"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20883659F7
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 12:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770034502; cv=none; b=fUVhnGKQIk8r9S76U8YcLiPTw8WmwvImgyZU6VQqVtwUQMkyyyHG2cRHMpjysxYCeEyIOSD9S8+vyTbnaAqLrlLZBhI4u7fuCsWCU6JN4XBcZF2vDb5hGfuS04nFWZtTM7okM+5uXthuqSf8EDLRYkK99yENuoD4EbYlyJ4iHgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770034502; c=relaxed/simple;
	bh=fIZA7nOzhZsk4YFg+si9gOmduydVH6FX3wBjfbu7xWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IoGalHKMBO9ZIVupwX02Z/Wi36B9Qpqw9j1DiIiDypE7ywPTb7NvagRY2fArs/FjTiSkaNmy9YAJwGVVxmgmPopq8KBY1z9GcWggOokY9r0n6QAf+I1D4FEud8m4gm3+Lc7TPxSr7Y2TDJ+ZLwxHdccIQwXwhgmPtU8Izww3ZVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c43ucQG9; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <0f44dfb7-fce3-44c1-ab25-b013ba18a59b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770034495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jituq4TCCBnJRRiPEJzrUjf8Tl3pN0KvOPn2lg/6vfc=;
	b=c43ucQG9ejToxHXbWiUtSl7n+JmaAbVKsyyyHJ67d+OURnCrLJ1c7JPyZwM8bBK+3f7Xbx
	WcuCypGqT3+1lpn5LaGRnO61hbdZX5On3WJ1PuhqJicfTM70UlMTt2ktFd2ZJ/Cy+RtXxT
	d+dpXXZfc5SXdF6be85Pzf8UNBt0izw=
Date: Mon, 2 Feb 2026 20:14:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 1/3] mm: use targeted IPIs for TLB sync with lockless
 page table walkers
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260202074557.16544-1-lance.yang@linux.dev>
 <20260202074557.16544-2-lance.yang@linux.dev>
 <20260202094245.GD2995752@noisy.programming.kicks-ass.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260202094245.GD2995752@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69841-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,kernel.org,intel.com,linux.intel.com,redhat.com,google.com,gmail.com,linutronix.de,alien8.de,zytor.com,arndb.de,oracle.com,nvidia.com,linux.alibaba.com,arm.com,surriel.com,suse.com,lists.linux.dev,vger.kernel.org,kvack.org];
	RCPT_COUNT_TWELVE(0.00)[37];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lance.yang@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:email,linux.dev:dkim,linux.dev:mid]
X-Rspamd-Queue-Id: C8187CC47F
X-Rspamd-Action: no action

Hi Peter,

Thanks for taking time to review!

On 2026/2/2 17:42, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 03:45:55PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Currently, tlb_remove_table_sync_one() broadcasts IPIs to all CPUs to wait
>> for any concurrent lockless page table walkers (e.g., GUP-fast). This is
>> inefficient on systems with many CPUs, especially for RT workloads[1].
>>
>> This patch introduces a per-CPU tracking mechanism to record which CPUs are
>> actively performing lockless page table walks for a specific mm_struct.
>> When freeing/unsharing page tables, we can now send IPIs only to the CPUs
>> that are actually walking that mm, instead of broadcasting to all CPUs.
>>
>> In preparation for targeted IPIs; a follow-up will switch callers to
>> tlb_remove_table_sync_mm().
>>
>> Note that the tracking adds ~3% latency to GUP-fast, as measured on a
>> 64-core system.
> 
> What architecture, and that is acceptable?

x86-64.

I ran ./gup_bench which spawns 60 threads, each doing 500k GUP-fast
operations (pinning 8 pages per call) via the gup_test ioctl.

Results for pin pages:
- Before: avg 1.489s (10 runs)
- After:  avg 1.533s (10 runs)

Given we avoid broadcast IPIs on large systems, I think this is a
reasonable trade-off :)

> 
>> +/*
>> + * Track CPUs doing lockless page table walks to avoid broadcast IPIs
>> + * during TLB flushes.
>> + */
>> +DECLARE_PER_CPU(struct mm_struct *, active_lockless_pt_walk_mm);
>> +
>> +static inline void pt_walk_lockless_start(struct mm_struct *mm)
>> +{
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	/*
>> +	 * Tell other CPUs we're doing lockless page table walk.
>> +	 *
>> +	 * Full barrier needed to prevent page table reads from being
>> +	 * reordered before this write.
>> +	 *
>> +	 * Pairs with smp_rmb() in tlb_remove_table_sync_mm().
>> +	 */
>> +	this_cpu_write(active_lockless_pt_walk_mm, mm);
>> +	smp_mb();
> 
> One thing to try is something like:
> 
> 	xchg(this_cpu_ptr(&active_lockless_pt_walk_mm), mm);
> 
> That *might* be a little better on x86_64, on anything else you really
> don't want to use this_cpu_() ops when you *know* IRQs are already
> disabled.

Ah, good to know that. Thanks!

IIUC, xchg() provides the full barrier we need ;)

> 
>> +}
>> +
>> +static inline void pt_walk_lockless_end(void)
>> +{
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	/*
>> +	 * Clear the pointer so other CPUs no longer see this CPU as walking
>> +	 * the mm. Use smp_store_release to ensure page table reads complete
>> +	 * before the clear is visible to other CPUs.
>> +	 */
>> +	smp_store_release(this_cpu_ptr(&active_lockless_pt_walk_mm), NULL);
>> +}
>> +
>>   int get_user_pages_fast(unsigned long start, int nr_pages,
>>   			unsigned int gup_flags, struct page **pages);
>>   int pin_user_pages_fast(unsigned long start, int nr_pages,
> 
>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>> index 2faa23d7f8d4..35c89e4b6230 100644
>> --- a/mm/mmu_gather.c
>> +++ b/mm/mmu_gather.c
>> @@ -285,6 +285,56 @@ void tlb_remove_table_sync_one(void)
>>   	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
>>   }
>>   
>> +DEFINE_PER_CPU(struct mm_struct *, active_lockless_pt_walk_mm);
>> +EXPORT_PER_CPU_SYMBOL_GPL(active_lockless_pt_walk_mm);
> 
> Why the heck is this exported? Both users are firmly core code.

OK. Will drop this export.

> 
>> +/**
>> + * tlb_remove_table_sync_mm - send IPIs to CPUs doing lockless page table
>> + * walk for @mm
>> + *
>> + * @mm: target mm; only CPUs walking this mm get an IPI.
>> + *
>> + * Like tlb_remove_table_sync_one() but only targets CPUs in
>> + * active_lockless_pt_walk_mm.
>> + */
>> +void tlb_remove_table_sync_mm(struct mm_struct *mm)
>> +{
>> +	cpumask_var_t target_cpus;
>> +	bool found_any = false;
>> +	int cpu;
>> +
>> +	if (WARN_ONCE(!mm, "NULL mm in %s\n", __func__)) {
>> +		tlb_remove_table_sync_one();
>> +		return;
>> +	}
>> +
>> +	/* If we can't, fall back to broadcast. */
>> +	if (!alloc_cpumask_var(&target_cpus, GFP_ATOMIC)) {
>> +		tlb_remove_table_sync_one();
>> +		return;
>> +	}
>> +
>> +	cpumask_clear(target_cpus);
>> +
>> +	/* Pairs with smp_mb() in pt_walk_lockless_start(). */
> 
> Pairs how? The start thing does something like:
> 
> 	[W] active_lockless_pt_walk_mm = mm
> 	MB
> 	[L] page-tables
> 
> So this is:
> 
> 	[L] page-tables
> 	RMB
> 	[L] active_lockless_pt_walk_mm
> 
> ?

On the walker side (pt_walk_lockless_start):

  [W]  active_lockless_pt_walk_mm = mm
  MB
  [L] page-tables (walker reads page tables)

So the walker publishes "I'm walking this mm" before reading page tables.

On the sync side we don't read page-tables. We do:

  RMB
  [L] active_lockless_pt_walk_mm (we read the per-CPU pointer below)

We need to observe the walker's store of active_lockless_pt_walk_mm before
we decide which CPUs to IPI.

So on the sync side we do smp_rmb(), then read active_lockless_pt_walk_mm.

That pairs with the full barrier in pt_walk_lockless_start().

> 
>> +	smp_rmb();
>> +
>> +	/* Find CPUs doing lockless page table walks for this mm */
>> +	for_each_online_cpu(cpu) {
>> +		if (per_cpu(active_lockless_pt_walk_mm, cpu) == mm) {
>> +			cpumask_set_cpu(cpu, target_cpus);
> 
> You really don't need this to be atomic.
> 
>> +			found_any = true;
>> +		}
>> +	}
>> +
>> +	/* Only send IPIs to CPUs actually doing lockless walks */
>> +	if (found_any)
>> +		smp_call_function_many(target_cpus, tlb_remove_table_smp_sync,
>> +				       NULL, 1);
> 
> Coding style wants { } here. Also, isn't this what we have
> smp_call_function_many_cond() for?

Right! That would be better, something like:

static bool tlb_remove_table_sync_mm_cond(int cpu, void *mm)
{
	return per_cpu(active_lockless_pt_walk_mm, cpu) == (struct mm_struct *)mm;
}

on_each_cpu_cond_mask(tlb_remove_table_sync_mm_cond,
			tlb_remove_table_smp_sync,
			(void *)mm, true, cpu_online_mask);

> 
>> +	free_cpumask_var(target_cpus);
>> +}
>> +
>>   static void tlb_remove_table_rcu(struct rcu_head *head)
>>   {
>>   	__tlb_remove_table_free(container_of(head, struct mmu_table_batch, rcu));
>> -- 
>> 2.49.0
>>

Thanks,
Lance


