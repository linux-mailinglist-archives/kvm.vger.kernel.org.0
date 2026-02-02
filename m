Return-Path: <kvm+bounces-69847-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MApKCBqmgGlNAAMAu9opvQ
	(envelope-from <kvm+bounces-69847-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 14:26:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 67852CCB59
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 14:26:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6D873066319
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 13:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D89367F36;
	Mon,  2 Feb 2026 13:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Eo/8wR57"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E71D366DC5;
	Mon,  2 Feb 2026 13:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770038618; cv=none; b=skZCOX33IC3UnxPQmjs+DLPGrK2PhnUjdNU4cy4xDYigm70TyqJcz3pXGH2wj6KSRI9ZIO11I8mS7rmkFqf6ZhEnppAgm5YwsUJ2fIANvD8yK/MHHAEb7urss6jqIbeg/A0k0eb6WFU/zdEaH4Cv5ICP5T1o9pfqKf7y+I+JrD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770038618; c=relaxed/simple;
	bh=dWkJNa/iK0u6N6a1Hh9WM0uM8f7S1WySLDHjmX/aH0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tlApvbWxtK2HnufahlWTmqyRM4L10AR7NHj9yUq/RRTNCkqs7VQzRsnomr3QzaD6Y9RUEG5wpEHT9bvO4kUhng9mQ9AcMS9g4SeyCKKAEKOly8BSIsPDTDHddrPVYbU2gbYh9GKrqsyOdZ3k5r1llNGtycDQxWUwz31WGUoeN6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Eo/8wR57; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <a79a6421-ca97-4a3f-8ec3-55e88da1ec83@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770038604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Blbtt7dpKJRpfc49e1GFkumagufWOg54JBDgVKdtOyU=;
	b=Eo/8wR57GdsB4LDM8vtNREaPg+jgd1Z6kRUHgJbthTbWOdT/NJNDsAohYXREBNhqN/0k7s
	unJFWbD/w6cabBy9MCj8+62iabw6BRytmx+lEqwCE0o6a3GZmB2ewbKEBgb4XZpDtjthFN
	hZ2Awz3Jjtl7WuIQ4BvZa6vEZd5efYw=
Date: Mon, 2 Feb 2026 21:23:07 +0800
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
 <0f44dfb7-fce3-44c1-ab25-b013ba18a59b@linux.dev>
 <20260202125146.GC1395266@noisy.programming.kicks-ass.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260202125146.GC1395266@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,kernel.org,intel.com,linux.intel.com,redhat.com,google.com,gmail.com,linutronix.de,alien8.de,zytor.com,arndb.de,oracle.com,nvidia.com,linux.alibaba.com,arm.com,surriel.com,suse.com,lists.linux.dev,vger.kernel.org,kvack.org];
	TAGGED_FROM(0.00)[bounces-69847-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[37];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lance.yang@linux.dev,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 67852CCB59
X-Rspamd-Action: no action



On 2026/2/2 20:51, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 08:14:32PM +0800, Lance Yang wrote:
> 
>>>> +	/* Pairs with smp_mb() in pt_walk_lockless_start(). */
>>>
>>> Pairs how? The start thing does something like:
>>>
>>> 	[W] active_lockless_pt_walk_mm = mm
>>> 	MB
>>> 	[L] page-tables
>>>
>>> So this is:
>>>
>>> 	[L] page-tables
>>> 	RMB
>>> 	[L] active_lockless_pt_walk_mm
>>>
>>> ?
>>
>> On the walker side (pt_walk_lockless_start):
>>
>>   [W]  active_lockless_pt_walk_mm = mm
>>   MB
>>   [L] page-tables (walker reads page tables)
>>
>> So the walker publishes "I'm walking this mm" before reading page tables.
>>
>> On the sync side we don't read page-tables. We do:
>>
>>   RMB
>>   [L] active_lockless_pt_walk_mm (we read the per-CPU pointer below)
>>
>> We need to observe the walker's store of active_lockless_pt_walk_mm before
>> we decide which CPUs to IPI.
>>
>> So on the sync side we do smp_rmb(), then read active_lockless_pt_walk_mm.
>>
>> That pairs with the full barrier in pt_walk_lockless_start().
> 
> No it doesn't; this is not how memory barriers work.

Hmm... we need MB rather than RMB on the sync side. Is that correct?

Walker:
[W]active_lockless_pt_walk_mm = mm -> MB -> [L]page-tables

Sync:
[W]page-tables -> MB -> [L]active_lockless_pt_walk_mm


Thanks,
Lance


