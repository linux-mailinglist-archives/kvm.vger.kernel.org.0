Return-Path: <kvm+bounces-69846-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gAHzMOWhgGni/wIAu9opvQ
	(envelope-from <kvm+bounces-69846-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 14:08:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 26066CC9BD
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 14:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7FED0303A6F5
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 13:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 502EF36657C;
	Mon,  2 Feb 2026 13:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D+aw/TuK"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E66A77F39
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 13:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770037660; cv=none; b=jJhdVeuxvP4rNIH1e9J9GpSq5hA7vcjuEj3h4JNcckbG5nbFlvQHt79A/orad+GuJjin7nPWKz9Mkn010aw0JNcEJxaMVMGw46H36CLKr3ng3OyK2tWYqA8hKlwr0Tbd9CuBC2RH010QpSgXptQO2r1HManINLjZI1Ogpq/K5XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770037660; c=relaxed/simple;
	bh=xa2sFjbzq6uDrkQ/f/ljXfRnkgUd0Ki/WhXSJpohFW8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=livgLpQ5UbbqHUdirsoCX4etePLPHtrpTmUZ6p12NNrcLF55NMkROP1o0kSrS1y4KrVIZ/0RFV7ZW40ChkMNQtPx7vQav7NpSak6sbJQmsfhjPf60KNwAI19zg2q94k/VYNaPoFrnNDO0nbW8OuUPXJ9kiSDMY/ET5rboKtyY/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D+aw/TuK; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770037646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rtRt2J+NteIme3evuIB2m7Zz3ToxciDgZMFuOP2gieE=;
	b=D+aw/TuK5ROJABoMvBj2zE/534Oz1vKJLXvEAqHUd4MV1pSHSiClseUddZQv0N7Sxaau3Q
	dQpodJOsye1tbDd5fadW9kkIegNhZA6SVB/dPRmMyzPBNi+yMtnIdGQPmP78O1gnJpVdUY
	tn9W9eJ65ExTWgYCt0d9CDAUtzFC4bs=
Date: Mon, 2 Feb 2026 21:07:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 dave.hansen@intel.com, dave.hansen@linux.intel.com, david@kernel.org,
 dev.jain@arm.com, hpa@zytor.com, hughd@google.com, ioworker0@gmail.com,
 jannh@google.com, jgross@suse.com, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mingo@redhat.com,
 npache@redhat.com, npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
 ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
 tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
 x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
In-Reply-To: <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69846-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:mid,linux.dev:dkim]
X-Rspamd-Queue-Id: 26066CC9BD
X-Rspamd-Action: no action



On 2026/2/2 20:58, Lance Yang wrote:
> 
> 
> On 2026/2/2 20:50, Peter Zijlstra wrote:
>> On Mon, Feb 02, 2026 at 07:00:16PM +0800, Lance Yang wrote:
>>>
>>> On Mon, 2 Feb 2026 10:54:14 +0100, Peter Zijlstra wrote:
>>>> On Mon, Feb 02, 2026 at 03:45:54PM +0800, Lance Yang wrote:
>>>>> When freeing or unsharing page tables we send an IPI to synchronize 
>>>>> with
>>>>> concurrent lockless page table walkers (e.g. GUP-fast). Today we 
>>>>> broadcast
>>>>> that IPI to all CPUs, which is costly on large machines and hurts RT
>>>>> workloads[1].
>>>>>
>>>>> This series makes those IPIs targeted. We track which CPUs are 
>>>>> currently
>>>>> doing a lockless page table walk for a given mm (per-CPU
>>>>> active_lockless_pt_walk_mm). When we need to sync, we only IPI 
>>>>> those CPUs.
>>>>> GUP-fast and perf_get_page_size() set/clear the tracker around 
>>>>> their walk;
>>>>> tlb_remove_table_sync_mm() uses it and replaces the previous 
>>>>> broadcast in
>>>>> the free/unshare paths.
>>>>
>>>> I'm confused. This only happens when !PT_RECLAIM, because if PT_RECLAIM
>>>> __tlb_remove_table_one() actually uses RCU.
>>>>
>>>> So why are you making things more expensive for no reason?
>>>
>>> You're right that when CONFIG_PT_RECLAIM is set, 
>>> __tlb_remove_table_one()
>>> uses call_rcu() and we never call any sync there — this series doesn't
>>> touch that path.
>>>
>>> In the !PT_RECLAIM table-free path (same __tlb_remove_table_one() branch
>>> that calls tlb_remove_table_sync_mm(tlb->mm) before __tlb_remove_table),
>>> we're not adding any new sync; we're replacing the existing broadcast 
>>> IPI
>>> (tlb_remove_table_sync_one()) with targeted IPIs 
>>> (tlb_remove_table_sync_mm()).
>>
>> Right, but if we can use full RCU for PT_RECLAIM, why can't we do so
>> unconditionally and not add overhead?
> 
> The sync (IPI) is mainly needed for unshare (e.g. hugetlb) and collapse
> (khugepaged) paths, regardless of whether table free uses RCU, IIUC.

In addition: We need the sync when we modify page tables (e.g. unshare,
collapse), not only when we free them. RCU can defer freeing but does
not prevent lockless walkers from seeing concurrent in-place
modifications, so we need the IPI to synchronize with those walkers
first.

