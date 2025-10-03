Return-Path: <kvm+bounces-59462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF42BB73E3
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 16:52:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E31C634671D
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 14:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650CB28313D;
	Fri,  3 Oct 2025 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RX0F19tG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EFF2459CF
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 14:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759503135; cv=none; b=AHytEmj2NcnmZoWaAmnGe9jpfDDka0Vf9juJWH9+jD0WwCt46cq7LVZuULkbjfW19wqak7Flk18CrH83KTBA43zSkY0K8zWRYHyOGPZBowEWcDu5SnVlGxUOLX0i24o74pcXnazkU25IEiwfhf8VR8wfqY1wdxaHdr5SvdxRNjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759503135; c=relaxed/simple;
	bh=4b0coGweLPmrVerXT4VS/6VDTPWKnMwazrzwdaJrH1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b1GSU5KoSdSKLiRfdxyCMEV8PjaGUs2higwtRwLsAeysRoZVeTipbduY24bkcPQWYzwYEHnIzGvEk23jR1z6lSDUsB57ONhU4lWXkGasFEZgBnipLHYRN5vzefnCLekpzB95yqwZi2KIEoWZLnnlLKz+E4m0iDvVPwHIKTCjzp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RX0F19tG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eaa47c7c8so2240509a91.3
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 07:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759503132; x=1760107932; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xpN9x5MKoIyJVB04EWmewZK/AQGVBuwB42Zza3jf0V8=;
        b=RX0F19tGIb2MEJDX7z0i77WkNRXwWMntO6bdbiNAowm6K9NlHf1budsrdlWuCI793Q
         bpWQ3JgdupE0kANZPJDHFgTpw1u0/fJkZ8qDUBXmAtkf5rFxUppc6EdVyItVt51mwKgU
         6namnLK4u7AWAqnRD6nPrxHGDR/Gn/vtMWm/es49OaEK98/fSB6NN3bxUZVO5fCS1jzx
         seAf9ORILLovIAi3Qnc+omy0oCji3xEQs2n6+7sa+HK5v69PtUIEzh+f+0Zbn3xaGajT
         YWbW1AQmI416p6siYI4mC28oUPJYPlaGD9cp+1xMBvZ9fm8ERdnpSTYIqcIhhapPRNb7
         epiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759503132; x=1760107932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xpN9x5MKoIyJVB04EWmewZK/AQGVBuwB42Zza3jf0V8=;
        b=i0/bTJmGqp8BOyPe/eapzRDd8T2ofCFNbSXUuy93lU7/TEusb3v/r1+p97I/8/Y+bO
         GyB/UihceaXrJLktMnlbKObdEz9/5AthWNGcW1qBwIUJaRVKITh8ZPYmfYgap4vdd5Z/
         If6MN05OD1uZwT8FjOASa6oRoZ54BBMnTS2FLO6KY3RitWinbmbY5H+I8sMMBFbsfwpV
         f8zH5fPglHl0pMqaTIRav5JUgT+10F2AxR4Y1hOP2IDyQ9h1lVHE6ygwp/z832QpC9I8
         sjAF13vHWb38P0JKBTPWIzIjrcRVAz66N/+Ixka0gAlC1NNxRtJp6f7/FE6umV7cE5Js
         6ong==
X-Gm-Message-State: AOJu0Yymw3PdL+RG1eEIpuWSVyF7aHcz7OBVEA41NzEWOevnNIUzuvow
	Kvvc5wKEGXNlNsUYQRMPD8wcCum/VnNjmZrc7JLHsw9PEdVboUcQExaGt6gPzJJdkUbdF8XFY4S
	si1rY0w==
X-Google-Smtp-Source: AGHT+IFOx/1HIGJBL3nY8+UsIOfKhr1DvTj0RUho954nMJOAkqUQ2/whOS9dK57jpBCvFyocW4al5BM6oPo=
X-Received: from pjyo11.prod.google.com ([2002:a17:90a:eb8b:b0:327:50fa:eff9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d12:b0:338:3789:2e89
 with SMTP id 98e67ed59e1d1-339c2720709mr4203886a91.10.1759503132338; Fri, 03
 Oct 2025 07:52:12 -0700 (PDT)
Date: Fri, 3 Oct 2025 07:52:10 -0700
In-Reply-To: <4d16522293c9a3eacdbe30148b6d6c8ad2eb5908.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <4d16522293c9a3eacdbe30148b6d6c8ad2eb5908.1747264138.git.ackerleytng@google.com>
Message-ID: <aN_jGnu2KQnxDniD@google.com>
Subject: Re: [RFC PATCH v2 32/51] KVM: guest_memfd: Support guestmem_hugetlb
 as custom allocator
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Ira Weiny <ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

Trimmed the Cc to KVM/guest_memfd folks.

On Wed, May 14, 2025, Ackerley Tng wrote:
> @@ -22,6 +25,10 @@ struct kvm_gmem_inode_private {
>  #ifdef CONFIG_KVM_GMEM_SHARED_MEM
>  	struct maple_tree shareability;
>  #endif
> +#ifdef CONFIG_KVM_GMEM_HUGETLB
> +	const struct guestmem_allocator_operations *allocator_ops;
> +	void *allocator_private;
> +#endif

This is beyond silly.  There is _one_ "custom" allocator, and no evidence that
the "generic" logic written for custom allocators would actually be correct for
anything other than a hugetlb allocator.

And to my point about guestmem_hugetlb.c not actually needing access to "private"
mm/ state,  I would much rather add e.g. virt/kvm/guest_memfd_hugetlb.{c.h}, and
in the header define:

  struct gmem_hugetlb_inode {
	struct hstate *h;
	struct hugepage_subpool *spool;
	struct hugetlb_cgroup *h_cg_rsvd;
  };

and then in guest_memfd.c have

  struct gmem_inode {
	struct shared_policy policy;
	struct inode vfs_inode;

	u64 flags;
	struct maple_tree attributes;

#ifdef CONFIG_KVM_GUEST_MEMFD_HUGETLB
	struct gmem_hugetlb_inode hugetlb;
#endif
  };

or maybe even better, avoid even that "jump" and define "struct gmem_inode" in a
new virt/kvm/guest_memfd.h:

  struct gmem_inode {
	struct shared_policy policy;
	struct inode vfs_inode;

	u64 flags;
	struct maple_tree attributes;

#ifdef CONFIG_KVM_GUEST_MEMFD_HUGETLB
	struct hstate *h;
	struct hugepage_subpool *spool;
	struct hugetlb_cgroup *h_cg_rsvd;
#endif
  };


The setup code can them be:

#ifdef CONFIG_KVM_GUEST_MEMFD_HUGETLB
	if (flags & GUEST_MEMFD_FLAG_HUGETLB) {
		err = kvm_gmem_init_hugetlb(inode, size, huge_page_size_log2)
		if (err)
			goto out;
	}
#endif


Actually, if we're at all clever, the #ifdefs can go away completely so long as
kvm_gmem_init_hugetlb() is uncondtionally _declared_, because we rely on dead
code elimination to drop the call before linking.

>  };
> +/**
> + * kvm_gmem_truncate_indices() - Truncates all folios beginning @index for
> + * @nr_pages.
> + *
> + * @mapping: filemap to truncate pages from.
> + * @index: the index in the filemap to begin truncation.
> + * @nr_pages: number of PAGE_SIZE pages to truncate.
> + *
> + * Return: the number of PAGE_SIZE pages that were actually truncated.
> + */

Do not add kerneldoc comments for internal helpers.  They inevitably become stale
and are a source of friction for developers.  The _only_ non-obvious thing here
is the return value.  

> +static long kvm_gmem_truncate_indices(struct address_space *mapping,
> +				      pgoff_t index, size_t nr_pages)
> +{
> +	struct folio_batch fbatch;
> +	long truncated;
> +	pgoff_t last;
> +
> +	last = index + nr_pages - 1;
> +
> +	truncated = 0;
> +	folio_batch_init(&fbatch);
> +	while (filemap_get_folios(mapping, &index, last, &fbatch)) {
> +		unsigned int i;
> +
> +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +			struct folio *f = fbatch.folios[i];
> +
> +			truncated += folio_nr_pages(f);
> +			folio_lock(f);
> +			truncate_inode_folio(f->mapping, f);
> +			folio_unlock(f);
> +		}
> +
> +		folio_batch_release(&fbatch);
> +		cond_resched();
> +	}
> +
> +	return truncated;
> +}

