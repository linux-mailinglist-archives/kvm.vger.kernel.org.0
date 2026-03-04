Return-Path: <kvm+bounces-72688-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IHq8F3lQqGmztAAAu9opvQ
	(envelope-from <kvm+bounces-72688-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 16:32:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E91F202C01
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 16:32:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5574A300BE06
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 15:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47ECC33509E;
	Wed,  4 Mar 2026 15:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ctThmodO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD79330D50
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 15:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772637609; cv=none; b=AjBVl0aRImo92GFRdbLUDPTieQqc+6a5Ak++2Rv1eTn2EKDlbGb+RwanW4RCy9YyEnkZttx9fmt0W/ujPQMMmbEDybHKJgkKpXdoq2T7z3vNGo+TWcBk7m1pZkhqnAiSK1wkbYKHeIvrVctEcn5d+fyXuruc+Sw/KLpdsEzhDxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772637609; c=relaxed/simple;
	bh=ymmy16BjMJcdh8G+bL7CjvElhjsLisNNHit5+UJLzlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ukfcwc2SiyOh54FDMFwdclUzymdomIF0RleW8+iR5TeUMdNIN3ILKdD0HjRQnl3mxdYqyxGdbyfDUJyfqg8a9pS2fD58knkSE16jyt3bELwuZTKhgMCbB5+lXp3LYlZ4wr7H4Suyoc4mHIgNrRn5l0ynDGBniyBd5M6v8gEpyAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ctThmodO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35984b91ffeso3415465a91.1
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 07:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772637608; x=1773242408; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fhVDxVUPn4sMysutwLd1doihcMglzApjUEnzyngJQcA=;
        b=ctThmodOTSNFb3kgmbSZ/GYMrzAfdDVaHPnzskj4iIXvOJzBmiNkroMZ3CnM6PUMcV
         RZ7xvjgNl8WufSJzbZlWKl7u20cqm913AoI4U3kmMd0yJ5hCx98XjZYQ9hiFAI2jmGkW
         pi3HufjXBi9DppljA/9eURhR3uIB361dSH1fyVjXYVZ7fhLeomZoVPyRCD3BgmBFSixA
         2tjYcQD1ORR0VMJxkwKeN+54mNFCMf7Ab0krgsoVrRfUxJiNJtfPaHfMdV2mRf9b1ppT
         Y4/Bbp7HPtwTa2fL9JWqQc1WXwcTWvVTYl3KV9PU4BSJTOo2+RW7Gog5xalFqAIz/R6J
         bC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772637608; x=1773242408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fhVDxVUPn4sMysutwLd1doihcMglzApjUEnzyngJQcA=;
        b=CezWmRzJo21P93J1IFHWTSxq7bYxDPgjxa06O24Q5kCwi4MQTDewdN0NQcdhH8yskS
         6m1s3bvAORr6aBVIxdWnsMH657EusaiYEw6xnIEg8hRvqyGL6t5UEd4vq4aXseNSReXT
         f0JvTBY59+tj5hZFk1Hp2HcyJZ6AbkchvVNBApBu07Xp5W20x0XAx46wYCpSnpGYhGEG
         PjG70XcJWG6+harZAkce9PuO9pBKki7GEb3aBrGkH0gh8rE5LqxV/X78nyGn6Jsh2Cy5
         2IZZUu5bCKNAvZfEOWeGmkoLgPtuvoKkPOVNp8YnE68r5oU/kWYMNXTAHPTr/QBFTOav
         eM2A==
X-Forwarded-Encrypted: i=1; AJvYcCWWaPgc8DIq+LJ6mfYyciGf0t6GYu7CL3LCS9++H89SBJIGR1VJtgER7L6WBujlD3xJmHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgN686nTqOBo1PCHhHkZxnkUSNO6kPzVqEs6QtdjZz3CooQsuB
	SKuSA15zDKYpgX2eN/1vVSsI8Z1+J6DTW16yvAWNwAdqSnLWqAg0NijU0+eFYm/9RsXMqYmicgT
	TzUPEjw==
X-Received: from pjbmz4.prod.google.com ([2002:a17:90b:3784:b0:358:fc29:4815])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e4d:b0:359:8ca0:308d
 with SMTP id 98e67ed59e1d1-359a6d8f5b3mr1977021a91.14.1772637607566; Wed, 04
 Mar 2026 07:20:07 -0800 (PST)
Date: Wed, 4 Mar 2026 07:20:06 -0800
In-Reply-To: <5097ff66-b727-4eac-b845-3bd08d1a0ead@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
 <20260225-gmem-st-blocks-v2-2-87d7098119a9@google.com> <5097ff66-b727-4eac-b845-3bd08d1a0ead@suse.com>
Message-ID: <aahNprLw0_Cdhzxp@google.com>
Subject: Re: [PATCH RFC v2 2/6] KVM: guest_memfd: Directly allocate folios
 with filemap_alloc_folio()
From: Sean Christopherson <seanjc@google.com>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, rientjes@google.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, fvdl@google.com, 
	jthoughton@google.com, vannapurve@google.com, shivankg@amd.com, 
	michael.roth@amd.com, pratyush@kernel.org, pasha.tatashin@soleen.com, 
	kalyazin@amazon.com, tabba@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 5E91F202C01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72688-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[35];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026, Vlastimil Babka wrote:
> On 2/25/26 08:20, Ackerley Tng wrote:
> > __filemap_get_folio_mpol() is parametrized by a bunch of GFP flags, which
> 
>                                                            FGP?
> 
> > adds complexity for the reader. Since guest_memfd doesn't meaningfully use
> > any of the other FGP flags, undo that complexity by directly calling
> > filemap_alloc_folio().
> > 
> > Directly calling filemap_alloc_folio() also allows the order of 0 to be
> > explicitly specified, which is the only order guest_memfd supports. This is
> > easier to understand,

That's debatable.  IMO, one isn't clearly better than the other, especially since
filemap_lock_folio() is itself a wrapper for __filemap_get_folio_mpol().  And there
is a cost to open-coding, as it means we risk missing something if there's a change
in __filemap_get_folio_mpol() that's beneficial to guest_memfd.

As Vlastimil said, if this greatly simplifies accounting, then I'm ok with it.
But the changelog needs to focus on that aspect, because I don't see this as a
clear win versus using __filemap_get_folio_mpol().

And if we go through with this, we should probably revert 16a542e22339 ("mm/filemap:
Extend __filemap_get_folio() to support NUMA memory policies"), because guest_memfd
is/was the only user.

> > +static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
> > +{
> > +	/* TODO: Support huge pages. */
> > +	struct mempolicy *policy;
> > +	struct folio *folio;
> > +	gfp_t gfp;
> > +	int ret;
> > +
> > +	/*
> > +	 * Fast-path: See if folio is already present in mapping to avoid
> > +	 * policy_lookup.
> > +	 */
> > +	folio = filemap_lock_folio(inode->i_mapping, index);
> > +	if (!IS_ERR(folio))
> > +		return folio;
> > +
> > +	gfp = mapping_gfp_mask(inode->i_mapping);
> > +
> > +	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);

This is a potential performance regression.  Previously, KVM would do a policy
lookup once per retry loop.  Now KVM will do the lookup 

I doubt it will matter in practice, because on EEXIST filemap_lock_folio() should
be all but guaranteed to find the existing folio.  But it's also something that
should be easy enough to avoid, and it's also another argument for using
__filemap_get_folio_mpol() instead of open coding our own version.

