Return-Path: <kvm+bounces-69872-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OCIeCjrKgGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69872-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 17:00:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D28CE923
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 17:00:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D60B630773CC
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 15:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4162512F5;
	Mon,  2 Feb 2026 15:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LHO+UJ4a"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62CB24BD1A
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 15:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770047579; cv=none; b=nzPIY8/vwWJoUjt++Hh8vJDO+oVx69APxSmqz6APqZ6lDn3A5ytTgikir5klZ5fewhPuqSEpEi+j8zU00zFS+8HSWRSW2dgoDoaEL/ajDK84SVclfr8ptIw7GGfwT8FwUMfd/oDznSN8Tx6AuEt3c9YV3QOhmjCuk4oimsE9H8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770047579; c=relaxed/simple;
	bh=+2Jc+VhLkXt3QqoavVsTTpgtI4ILB8bGtNf8GUb/dGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ghcahLVxf/FLBJQA3cmoLlvIc+Wh0a/Ll7eaj0rC56DqCvRO83V9/uUlICaxqRTn1WlcOdNYVQzdDBOprmJ9cAUxdUDwq1QskKW6eu43pYjZNV63xY47qXKoGsayiGbsgLHLZko7M42/jwdpU7Ynm2vFCQKNY1yYCQdZDxVk/rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LHO+UJ4a; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770047565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PduxyDODlH9YHL0rneveZmMdter31WXHAeGzrsiCre4=;
	b=LHO+UJ4aR+t9zhuFaEeNktv85tisbUgqgGP+452qgxwu8pe3VAbJyWwRwIMkIkhrW3CiiU
	amX509lg1rXTP7Wtltg3TnQsfApgqjp0Blp35vsPn2YE5n3hsGAPY5Q6ckZZXKljWJkLo7
	a+vSwZ8/xCaiyucTyGL4QbFRUgmLY+s=
Date: Mon, 2 Feb 2026 23:52:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>, david@kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 dave.hansen@intel.com, dave.hansen@linux.intel.com, dev.jain@arm.com,
 hpa@zytor.com, hughd@google.com, ioworker0@gmail.com, jannh@google.com,
 jgross@suse.com, kvm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
 npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
 ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
 tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
 x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
 <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
 <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
 <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69872-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[oracle.com,linux-foundation.org,kernel.org,arndb.de,linux.alibaba.com,alien8.de,intel.com,linux.intel.com,arm.com,zytor.com,google.com,gmail.com,suse.com,vger.kernel.org,kvack.org,redhat.com,surriel.com,linutronix.de,lists.linux.dev,nvidia.com];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:mid,linux.dev:dkim]
X-Rspamd-Queue-Id: E3D28CE923
X-Rspamd-Action: no action



On 2026/2/2 23:09, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 10:37:39PM +0800, Lance Yang wrote:
>>
>>
>> On 2026/2/2 21:37, Peter Zijlstra wrote:
>>> On Mon, Feb 02, 2026 at 09:07:10PM +0800, Lance Yang wrote:
>>>
>>>>>> Right, but if we can use full RCU for PT_RECLAIM, why can't we do so
>>>>>> unconditionally and not add overhead?
>>>>>
>>>>> The sync (IPI) is mainly needed for unshare (e.g. hugetlb) and collapse
>>>>> (khugepaged) paths, regardless of whether table free uses RCU, IIUC.
>>>>
>>>> In addition: We need the sync when we modify page tables (e.g. unshare,
>>>> collapse), not only when we free them. RCU can defer freeing but does
>>>> not prevent lockless walkers from seeing concurrent in-place
>>>> modifications, so we need the IPI to synchronize with those walkers
>>>> first.
>>>
>>> Currently PT_RECLAIM=y has no IPI; are you saying that is broken? If
>>> not, then why do we need this at all?
>>
>> PT_RECLAIM=y does have IPI for unshare/collapse — those paths call
>> tlb_flush_unshared_tables() (for hugetlb unshare) and collapse_huge_page()
>> (in khugepaged collapse), which already send IPIs today (broadcast to all
>> CPUs via tlb_remove_table_sync_one()).
>>
>> What PT_RECLAIM=y doesn't need IPI for is table freeing (
>> __tlb_remove_table_one() uses call_rcu() instead). But table modification
>> (unshare, collapse) still needs IPI to synchronize with lockless walkers,
>> regardless of PT_RECLAIM.
>>
>> So PT_RECLAIM=y is not broken; it already has IPI where needed. This series
>> just makes those IPIs targeted instead of broadcast. Does that clarify?
> 
> Oh bah, reading is hard. I had missed they had more table_sync_one() calls,
> rather than remove_table_one().
> 
> So you *can* replace table_sync_one() with rcu_sync(), that will provide
> the same guarantees. Its just a 'little' bit slower on the update side,
> but does not incur the read side cost.

Yep, we could replace the IPI with synchronize_rcu() on the sync side:

- Currently: TLB flush → send IPI → wait for walkers to finish
- With synchronize_rcu(): TLB flush → synchronize_rcu() -> waits for 
grace period

Lockless walkers (e.g. GUP-fast) use local_irq_disable(); 
synchronize_rcu() also
waits for regions with preemption/interrupts disabled, so it should 
work, IIUC.

And then, the trade-off would be:
- Read side: zero cost (no per-CPU tracking)
- Write side: wait for RCU grace period (potentially slower)

For collapse/unshare, that write-side latency might be acceptable :)

@David, what do you think?

> 
> I really think anything here needs to better explain the various
> requirements. Because now everybody gets to pay the price for hugetlb
> shared crud, while 'nobody' will actually use that.

Right. If we go with synchronize_rcu(), the read-side cost goes away ...

Thanks,
Lance

