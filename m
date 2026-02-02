Return-Path: <kvm+bounces-69856-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CNupIv20gGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69856-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 15:30:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A0FCD604
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 15:30:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 01161302AF32
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 14:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E24436D50D;
	Mon,  2 Feb 2026 14:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xa/s9WA2"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ABD36CE04
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 14:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770042584; cv=none; b=JgsbieD6TJxHBtdKw7mtwnabuf46wjggU3YMWS4CrCFzVm3xd8cVFodpKazqfzAiGOCo1vWVl3y2MeKAFJSzesHL1wcRcmRUqUu9FrhDQCmwLAdNX07LGNl5qeriAR0dAVWHnOhq5Mg1Jajd6Qsh5jaASnX5yxkHAaNA/KqsPzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770042584; c=relaxed/simple;
	bh=nYi4m+o2VxRuDkq+4h0mjs8Svw38acK9eHCM64IveUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WNMyiFbTeNPmlgajBUMGiT/6umhzw3GlgrB02VXruwyJEoD0RS8tb3dbTU6tfesutxKPDnmxGfAYBlw7FfrtbA4dchbVHQdwKznWL+C7gqYrx5yOK39aJqXOjgVHZ5IZMS8WJIdwkRKtwz8qz1pOqHLykABRVU0U8LwI6NfjxmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Xa/s9WA2; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <4a928cbe-d4d2-4af3-bb3c-e57074d385e0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770042570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5LNr0+fZCzfcBa5F60oDM1uqpqeQaPLlDr7VaXJZk/g=;
	b=Xa/s9WA2Y/6hJdCO94IgSQKVCT302nt2S50MHJ9ILaoPbQLI4iZyxn5gBI4T6fGHmtVz6r
	MJz2s+U9tbczDM0Mzz/W+mR9Z6NJe/Ir1uF1+sKQ9ngTGoPzAkdG0YbaJeaIkh2GVH+Xi8
	IU0zekLg3nAy9G5jJ0xUExxfwrPFGUk=
Date: Mon, 2 Feb 2026 22:28:47 +0800
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
 <a79a6421-ca97-4a3f-8ec3-55e88da1ec83@linux.dev>
 <20260202134233.GG1395266@noisy.programming.kicks-ass.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260202134233.GG1395266@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69856-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:mid,linux.dev:dkim]
X-Rspamd-Queue-Id: 14A0FCD604
X-Rspamd-Action: no action



On 2026/2/2 21:42, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 09:23:07PM +0800, Lance Yang wrote:
> 
>> Hmm... we need MB rather than RMB on the sync side. Is that correct?
>>
>> Walker:
>> [W]active_lockless_pt_walk_mm = mm -> MB -> [L]page-tables
>>
>> Sync:
>> [W]page-tables -> MB -> [L]active_lockless_pt_walk_mm
>>
> 
> This can work -- but only if the walker and sync touch the same
> page-table address.
> 
> Now, typically I would imagine they both share the p4d/pud address at
> the very least, right?

Thanks. I think I see the confusion ...

To be clear, the goal is not to make the walker see page-table writes 
through the
MB pairing, but to wait for any concurrent lockless page table walkers 
to finish.

The flow is:

1) Page tables are modified
2) TLB flush is done
3) Read active_lockless_pt_walk_mm (with MB to order page-table writes 
before
    this read) to find which CPUs are locklessly walking this mm
4) IPI those CPUs
5) The IPI forces them to sync, so after the IPI returns, any in-flight 
lockless
    page table walk has finished (or will restart and see the new page 
tables)

The synchronization relies on the IPI to ensure walkers stop before 
continuing.

I would assume the TLB flush (step 2) should imply some barrier.

Does that clarify?

