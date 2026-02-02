Return-Path: <kvm+bounces-69865-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SGTOIAi/gGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69865-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:13:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2481ECDFE3
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:13:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F906301E225
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 15:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6546E37880C;
	Mon,  2 Feb 2026 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k01wZvwp"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1A237757A;
	Mon,  2 Feb 2026 15:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770045018; cv=none; b=nh2ughEiMsFxcIPiutjdVMdhN678Ees5Aim/yumegdLwGx64BjZgZACP61wW1XGEiLl3NNVfwSaXMiW3upu4eftjrNlmIg0/1G11WZJTow6rXL+qH4yjiVNOWH9c2owIJoCET6/SYOM3c1cdClbJDrt1owir3JxnUMjYi7bv5bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770045018; c=relaxed/simple;
	bh=ON1bfn1LNBfZJO8hAzsDB8/3qwlqIs+7eeFqNmgylCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TnSQrMu7a/x360jlW9GpWxKssPqKmHcB6Hf507DBKlrdJUr6ucpPrOmOYyy70vw5xideWlPzAue4lBWZ2fycPrV3kHovr7+ueh61MZuPIXUjroQdx5mXt4dh6xk2u9s20xFJ/H3InG4ASeqRNYOtM3IAvLdhMqRvVuoCeXB8c3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k01wZvwp; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=YhYlGq9J1U3W7iskvXcfDWdu0+Euxsweuhz3tvtjc9A=; b=k01wZvwp8VQxlykqY5Rd1ZTTs3
	Rt+jBGqWUBJbPnFvF0zgKcI2s61WtZT/Z5HD55/INFG/FnO865RN5AicoNkP/0a/2FizvO05IE0kV
	GJCOLzSmqXAulHS9WwmWuMgsHb+nVY0SGaKoxckw07L1DwOlZow+wQemz/ynHvQireP/jKT2E17O7
	UvCBgmQkTwe2kL1aymWFxp7gqO5B0rMbYSjhgRGvkJODNoxmgD4z7wzuqWgTXYVPNccc8M+wiVnZu
	DIH3myH4y89jaMbfHpqIYCoh1okEO4zUr9F/V04eVQaYFldJD/dx/h9MRz36IFoHLbC7+fPEPyogA
	xHcP8F0w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmvYt-0000000EgHu-3LpA;
	Mon, 02 Feb 2026 15:10:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1938C3008E2; Mon, 02 Feb 2026 16:09:58 +0100 (CET)
Date: Mon, 2 Feb 2026 16:09:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com,
	bp@alien8.de, dave.hansen@intel.com, dave.hansen@linux.intel.com,
	david@kernel.org, dev.jain@arm.com, hpa@zytor.com, hughd@google.com,
	ioworker0@gmail.com, jannh@google.com, jgross@suse.com,
	kvm@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
	npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
	ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
	tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
	x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Message-ID: <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
 <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
 <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69865-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[oracle.com,linux-foundation.org,kernel.org,arndb.de,linux.alibaba.com,alien8.de,intel.com,linux.intel.com,arm.com,zytor.com,google.com,gmail.com,suse.com,vger.kernel.org,kvack.org,redhat.com,surriel.com,linutronix.de,lists.linux.dev,nvidia.com];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[37];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:dkim]
X-Rspamd-Queue-Id: 2481ECDFE3
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 10:37:39PM +0800, Lance Yang wrote:
> 
> 
> On 2026/2/2 21:37, Peter Zijlstra wrote:
> > On Mon, Feb 02, 2026 at 09:07:10PM +0800, Lance Yang wrote:
> > 
> > > > > Right, but if we can use full RCU for PT_RECLAIM, why can't we do so
> > > > > unconditionally and not add overhead?
> > > > 
> > > > The sync (IPI) is mainly needed for unshare (e.g. hugetlb) and collapse
> > > > (khugepaged) paths, regardless of whether table free uses RCU, IIUC.
> > > 
> > > In addition: We need the sync when we modify page tables (e.g. unshare,
> > > collapse), not only when we free them. RCU can defer freeing but does
> > > not prevent lockless walkers from seeing concurrent in-place
> > > modifications, so we need the IPI to synchronize with those walkers
> > > first.
> > 
> > Currently PT_RECLAIM=y has no IPI; are you saying that is broken? If
> > not, then why do we need this at all?
> 
> PT_RECLAIM=y does have IPI for unshare/collapse — those paths call
> tlb_flush_unshared_tables() (for hugetlb unshare) and collapse_huge_page()
> (in khugepaged collapse), which already send IPIs today (broadcast to all
> CPUs via tlb_remove_table_sync_one()).
> 
> What PT_RECLAIM=y doesn't need IPI for is table freeing (
> __tlb_remove_table_one() uses call_rcu() instead). But table modification
> (unshare, collapse) still needs IPI to synchronize with lockless walkers,
> regardless of PT_RECLAIM.
> 
> So PT_RECLAIM=y is not broken; it already has IPI where needed. This series
> just makes those IPIs targeted instead of broadcast. Does that clarify?

Oh bah, reading is hard. I had missed they had more table_sync_one() calls,
rather than remove_table_one().

So you *can* replace table_sync_one() with rcu_sync(), that will provide
the same guarantees. Its just a 'little' bit slower on the update side,
but does not incur the read side cost.

I really think anything here needs to better explain the various
requirements. Because now everybody gets to pay the price for hugetlb
shared crud, while 'nobody' will actually use that.

