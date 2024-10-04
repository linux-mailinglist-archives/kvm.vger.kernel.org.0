Return-Path: <kvm+bounces-28000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B383991282
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 00:49:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8F421F23F19
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 22:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471C614C59C;
	Fri,  4 Oct 2024 22:49:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE1813A416;
	Fri,  4 Oct 2024 22:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728082157; cv=none; b=g5z0NRuvLAQj/wWnm3fD7yUS5zPjkxhoBDG0SePbDHoTIrGyjrzuLPxEI1mwVphJEMUS9mhOZ4Teu4yjZWf68VBmNXGLYUBGJYZjAN3LA2MBCxFkg55rkTVx2E6VZRxdCyJZ7b9xgChZeVgrHyDk68H0zpvdvZNc2SLexJ2rz28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728082157; c=relaxed/simple;
	bh=7gbu8TSTG4G00UJGD2ZWIOIDAk2kWtxyV0dx7BUzd4w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=chiUAIl96CqUv2bxYktWSjsQwoMMj2+LioDnJy+mqPJ0+XSY8DEaLG6uoQjRgB0wVR4/z+3N77cCr5dJ3AqM0/3z3rpHCvHJhgbMj8y8CVAPYm3KUZl3jh8hy4GR5mlyjZeedEUIqkWP36a9e+KG9WhUUJ2JtRQ7/OwyZaIEtQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0A2C4CEC6;
	Fri,  4 Oct 2024 22:49:14 +0000 (UTC)
Date: Fri, 4 Oct 2024 18:50:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Patrick Roy <roypat@amazon.co.uk>
Cc: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
 <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
 <x86@kernel.org>, <hpa@zytor.com>, <mhiramat@kernel.org>,
 <mathieu.desnoyers@efficios.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
 <quic_eberman@quicinc.com>, <dwmw@amazon.com>, <david@redhat.com>,
 <tabba@google.com>, <rppt@kernel.org>, <linux-mm@kvack.org>,
 <dmatlack@google.com>, <graf@amazon.com>, <jgowans@amazon.com>,
 <derekmn@amazon.com>, <kalyazin@amazon.com>, <xmarcalx@amazon.com>
Subject: Re: [RFC PATCH v2 06/10] kvm: gmem: add tracepoints for gmem
 share/unshare
Message-ID: <20241004185010.60807289@gandalf.local.home>
In-Reply-To: <20240910163038.1298452-7-roypat@amazon.co.uk>
References: <20240910163038.1298452-1-roypat@amazon.co.uk>
	<20240910163038.1298452-7-roypat@amazon.co.uk>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Sep 2024 17:30:32 +0100
Patrick Roy <roypat@amazon.co.uk> wrote:

> Add tracepoints for calls to kvm_gmem_get_folio that cause the returned
> folio to be considered "shared" (e.g. accessible by host KVM), and
> tracepoint for when KVM is done accessing a gmem pfn
> (kvm_gmem_put_shared_pfn).
> 
> The above operations can cause folios to be insert/removed into/from the
> direct map. We want to be able to make sure that only those gmem folios
> that we expect KVM to access are ever reinserted into the direct map,
> and that all folios that are temporarily reinserted are also removed
> again at a later point. Processing ftrace output is one way to verify
> this.
> 
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  include/trace/events/kvm.h | 43 ++++++++++++++++++++++++++++++++++++++
>  virt/kvm/guest_memfd.c     |  7 ++++++-
>  2 files changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
> index 74e40d5d4af42..4a40fd4c22f91 100644
> --- a/include/trace/events/kvm.h
> +++ b/include/trace/events/kvm.h
> @@ -489,6 +489,49 @@ TRACE_EVENT(kvm_test_age_hva,
>  	TP_printk("mmu notifier test age hva: %#016lx", __entry->hva)
>  );
>  
> +#ifdef CONFIG_KVM_PRIVATE_MEM
> +TRACE_EVENT(kvm_gmem_share,
> +	TP_PROTO(struct folio *folio, pgoff_t index),
> +	TP_ARGS(folio, index),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, sharing_count)
> +		__field(kvm_pfn_t, pfn)
> +		__field(pgoff_t, index)
> +		__field(unsigned long,  npages)

Looking at the TP_printk() format below, the pfn is 8 bytes and
sharing_count is 4. This will likely create a hole between the two fields
for alignment reasons. Should put the sharing_count at the end.

> +	),
> +
> +	TP_fast_assign(
> +		__entry->sharing_count = refcount_read(folio_get_private(folio));
> +		__entry->pfn = folio_pfn(folio);
> +		__entry->index = index;
> +		__entry->npages = folio_nr_pages(folio);
> +	),
> +
> +	TP_printk("pfn=0x%llx index=%lu pages=%lu (refcount now %d)",
> +	          __entry->pfn, __entry->index, __entry->npages, __entry->sharing_count - 1)
> +);
> +
> +TRACE_EVENT(kvm_gmem_unshare,
> +	TP_PROTO(kvm_pfn_t pfn),
> +	TP_ARGS(pfn),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, sharing_count)
> +		__field(kvm_pfn_t, pfn)

Same here. It should swap the two fields. Note, if you already added this,
it will not break backward compatibility swapping them, as tooling should
use the format files that state where these fields are located in the raw
data.

-- Steve


> +	),
> +
> +	TP_fast_assign(
> +		__entry->sharing_count = refcount_read(folio_get_private(pfn_folio(pfn)));
> +		__entry->pfn = pfn;
> +	),
> +
> +	TP_printk("pfn=0x%llx (refcount now %d)",
> +	          __entry->pfn, __entry->sharing_count - 1)
> +)
> +
> +#endif
> +
>  #endif /* _TRACE_KVM_MAIN_H */
>  
>  /* This part must be outside protection */
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6772253497e4d..742eba36d2371 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -7,6 +7,7 @@
>  #include <linux/set_memory.h>
>  
>  #include "kvm_mm.h"
> +#include "trace/events/kvm.h"
>  
>  struct kvm_gmem {
>  	struct kvm *kvm;
> @@ -204,8 +205,10 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, unsi
>  	if (r)
>  		goto out_err;
>  
> -	if (share)
> +	if (share) {
>  		refcount_inc(folio_get_private(folio));
> +		trace_kvm_gmem_share(folio, index);
> +	}
>  
>  out:
>  	/*
> @@ -759,6 +762,8 @@ int kvm_gmem_put_shared_pfn(kvm_pfn_t pfn) {
>  	if (refcount_read(sharing_count) == 1)
>  		r = kvm_gmem_folio_set_private(folio);
>  
> +	trace_kvm_gmem_unshare(pfn);
> +
>  	return r;
>  }
>  EXPORT_SYMBOL_GPL(kvm_gmem_put_shared_pfn);


