Return-Path: <kvm+bounces-69844-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EDYRHEGggGni/wIAu9opvQ
	(envelope-from <kvm+bounces-69844-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 14:01:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C0DFECC8F5
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 14:01:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 66D20305B291
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 12:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1096365A10;
	Mon,  2 Feb 2026 12:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zik0SDuK"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0D6364037
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 12:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770037174; cv=none; b=uxQrIkNmsomEbzTnfHiwXnFxESbWcsRFuIEzwOooaeafcWihb0La30WtMn0bSOkkK7hdjosti/6NZRxrfkQ0n4oQ1j6hhIhVp+msxouokY7rR+ItzzMZ9RUt1biExeYfuYBFAGj2RiQQh2PzqHjUf8C5c4MZ8+CiVtoCcfWOAjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770037174; c=relaxed/simple;
	bh=3nVTZ1fzlaNRARsu0oGUAZ66xrenIFPj2FRTVp2XZ4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bWsCHg/iXQ94EwZt3pJEKTSYXEwEsaeQpcDBNCoFtzfYjmtXpsaD6FWqFbv0VviuJTq/rUg2a53dfCaMnHCIifAJTcVuWKXmdiCg3iv2V/LZyH/48JzxOFrQlfOKFWXSnbEKFQFWXec/y1yQjK2icaPtkKer9VNf0AOG7zSTEPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zik0SDuK; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770037160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=covw2BPyK8sacnLEewv4QKBXzjC6wkJ/DzN2BwEzgJ4=;
	b=Zik0SDuKukGMkoBY4OiYAQDGvhqEL+dALU6z/drOGTInLZ1tB4ddKjX0fNVZgTzxPLQ/90
	Hq5fkhYQju6F/Kr97o4bQ5FcxNV+oH3zYlHH9q8tvYTo63d1HktRsCSlvYi7ewtgseKl7L
	vqbyPrSvvOZfEepxweap4WMtVMLr6hw=
Date: Mon, 2 Feb 2026 20:58:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Content-Language: en-US
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
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
	TAGGED_FROM(0.00)[bounces-69844-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:mid,linux.dev:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C0DFECC8F5
X-Rspamd-Action: no action



On 2026/2/2 20:50, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 07:00:16PM +0800, Lance Yang wrote:
>>
>> On Mon, 2 Feb 2026 10:54:14 +0100, Peter Zijlstra wrote:
>>> On Mon, Feb 02, 2026 at 03:45:54PM +0800, Lance Yang wrote:
>>>> When freeing or unsharing page tables we send an IPI to synchronize with
>>>> concurrent lockless page table walkers (e.g. GUP-fast). Today we broadcast
>>>> that IPI to all CPUs, which is costly on large machines and hurts RT
>>>> workloads[1].
>>>>
>>>> This series makes those IPIs targeted. We track which CPUs are currently
>>>> doing a lockless page table walk for a given mm (per-CPU
>>>> active_lockless_pt_walk_mm). When we need to sync, we only IPI those CPUs.
>>>> GUP-fast and perf_get_page_size() set/clear the tracker around their walk;
>>>> tlb_remove_table_sync_mm() uses it and replaces the previous broadcast in
>>>> the free/unshare paths.
>>>
>>> I'm confused. This only happens when !PT_RECLAIM, because if PT_RECLAIM
>>> __tlb_remove_table_one() actually uses RCU.
>>>
>>> So why are you making things more expensive for no reason?
>>
>> You're right that when CONFIG_PT_RECLAIM is set, __tlb_remove_table_one()
>> uses call_rcu() and we never call any sync there — this series doesn't
>> touch that path.
>>
>> In the !PT_RECLAIM table-free path (same __tlb_remove_table_one() branch
>> that calls tlb_remove_table_sync_mm(tlb->mm) before __tlb_remove_table),
>> we're not adding any new sync; we're replacing the existing broadcast IPI
>> (tlb_remove_table_sync_one()) with targeted IPIs (tlb_remove_table_sync_mm()).
> 
> Right, but if we can use full RCU for PT_RECLAIM, why can't we do so
> unconditionally and not add overhead?

The sync (IPI) is mainly needed for unshare (e.g. hugetlb) and collapse
(khugepaged) paths, regardless of whether table free uses RCU, IIUC.

