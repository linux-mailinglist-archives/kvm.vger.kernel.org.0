Return-Path: <kvm+bounces-73363-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MOLkEj8qr2mzOgIAu9opvQ
	(envelope-from <kvm+bounces-73363-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 21:14:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E5C29240C06
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 21:14:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 99F22300A31F
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 20:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E78036894E;
	Mon,  9 Mar 2026 20:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WgRGBO0+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754D0368264
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 20:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773087291; cv=none; b=iZaPfh5EkvUGViliK30NFb7xR9MVO929dEv57rq6mnRrXm5fY7nfaAb+WXQj4hgt3ghAmippcPbY8y7iI3RJeuEz0/vgZsjMouZXNK4/ksmqEdH1cD/eVZ+PkOTsooEe0WuMyddqTvb/GcixL4raTw5oPENNbfGPHgTeE1jr00k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773087291; c=relaxed/simple;
	bh=t2ELUrTRrIA43qxN6ICa2HlQbYlezzntw2IcTVfori8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=egyChrDnJmomtTX6hpb6LF1Z6RpNWpoJ7ewhoJ1s24YVPFM2h7OeEvy9D2aYP0Ww6jXrSj4RDrWcEuTbdiMmgo5g+cYOh/kgSdw3GvZ9B6URh4vEcDrJiGuPGoIMT2B0C5xbT9Y0cjH4UP991qTPVu1ZfkxnmAbqhcy2bCikEM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WgRGBO0+; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82984468f85so2498252b3a.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 13:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773087289; x=1773692089; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vcDGw75J1CjJnpglqCPC5b33UOnC1+NDU+DgqlhrL+E=;
        b=WgRGBO0+3RQ6BaSZPMkHwYilzNG8yrke4nzj1NAESScOp4X6GEQis6YsI7ISlipbAL
         yYDFZ4mOXT/QRu9wc2T/xvZ8Y2aLoOvC0U0TWM7WF4GyVMktCEYHpV/hrwNt+Egi27aH
         7nl//d2I8E4pn1k3m/k8A5KjlHiBo5VY+AQSNigeWV1OWhb+MEPI5LpBP5flJe3JdFyW
         1QF9eoPbQOW/PFrTLUkIuz54K0UiBeFz6FRHkCS52qu7bWKuBjghOLVz7Vfz8PR7o7a2
         YoTQ+3opfFU3Itul/vLveK0qLdmz8WYTSdT3Z6bsZ+bEfdRJoNYQq+0X2XTnI0RD1ZSD
         KNuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773087289; x=1773692089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vcDGw75J1CjJnpglqCPC5b33UOnC1+NDU+DgqlhrL+E=;
        b=rzADp3lpHToZD4kgX29P/XLnOn7lP2He8mPBVDHY6atYtxPVhNqjbyQ7lnp7VdtZ2B
         1RNJIv9L3kSchpo9QVWw1kJycgoz/SPXTgay11za0c5lwGawWKblTh6Yf4RDDKqhqgVQ
         sYUqGXNr4YMpFOQ6FKe3e/QvNQavkkLgT0I49DbwBIqHY+qXxXbR6vAT7JGm5ZszQ4Dj
         TY+bzKAexoEcjmDIfEHpKI8NPPDXJpIXXUe//uESZNsLmq3yiKvhc2iyX/epKbDEeBOe
         3One9JDbm3wtZA/SO03JVi/msxg4pXa6SkMGkP8AAkbRI+K1RK8U65s2wFWh9b8KqT4A
         9qYg==
X-Forwarded-Encrypted: i=1; AJvYcCXPKgEu0cs+KDUHCdSimbK9pAzcI5Fq8QDGhtIGlKRqdmd89pQDx2oFIaCLtHiiW9N8Mjc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzByStmt87KQyrZAuOQfkD6iYGsH2ARaiTClOLR3e9PQSVr4/G
	pHGduMKXfJw1W+kNtwjQFZbabGvIEvzY4asuuCmdHeTQqio29oNnocqk1AdIO4h9xhXoBq14epD
	n0CXWoA==
X-Received: from pfqz27.prod.google.com ([2002:aa7:9e5b:0:b0:821:82a1:fe7d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4519:b0:821:8ea4:480e
 with SMTP id d2e1a72fcca58-829a2d88f61mr11174600b3a.10.1773087288647; Mon, 09
 Mar 2026 13:14:48 -0700 (PDT)
Date: Mon, 9 Mar 2026 13:14:47 -0700
In-Reply-To: <CAEvNRgHhFoyh__shK_YefhUOTP4RaG-sivUH=4Gj-2iy1HX+tw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
 <20260309-gmem-st-blocks-v3-1-815f03d9653e@google.com> <577c4725-7eda-4693-a55a-413572541161@kernel.org>
 <CAEvNRgHhFoyh__shK_YefhUOTP4RaG-sivUH=4Gj-2iy1HX+tw@mail.gmail.com>
Message-ID: <aa8qNz_52Qe6x1Kv@google.com>
Subject: Re: [PATCH RFC v3 1/4] KVM: guest_memfd: Track amount of memory
 allocated on inode
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	rientjes@google.com, rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	shivankg@amd.com, michael.roth@amd.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: E5C29240C06
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73363-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 09, 2026, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
> > On 3/9/26 10:53, Ackerley Tng wrote:
> >> The guest memfd currently does not update the inode's i_blocks and i_bytes
> >> count when memory is allocated or freed. Hence, st_blocks returned from
> >> fstat() is always 0.
> >>
> >> Introduce byte accounting for guest memfd inodes.  When a new folio is
> >> added to the filemap, add the folio's size.  Use the .invalidate_folio()
> >> callback to subtract the folio's size from inode fields when folios are
> >> truncated and removed from the filemap.
> >>
> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >> ---
> >>  virt/kvm/guest_memfd.c | 14 ++++++++++++++
> >>  1 file changed, 14 insertions(+)
> >>
> >> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> >> index 462c5c5cb602a..77219551056a7 100644
> >> --- a/virt/kvm/guest_memfd.c
> >> +++ b/virt/kvm/guest_memfd.c
> >> @@ -136,6 +136,9 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
> >>  					 mapping_gfp_mask(inode->i_mapping), policy);
> >>  	mpol_cond_put(policy);
> >>
> >> +	if (!IS_ERR(folio))
> >> +		inode_add_bytes(inode, folio_size(folio));
> >> +
> >
> > Can't we have two concurrent calls to __filemap_get_folio_mpol(), and we
> > don't really know whether our call allocated the folio or simply found
> > one (the other caller allocated) in the pagecache?
> >
> 
> Ah that is true. Two threads can get past filemap_lock_folio(), then get
> to __filemap_get_folio_mpol(), and then thread 1 will return from
> __filemap_get_folio_mpol() with an allocated folio while thread 2
> returns with the folio allocated by thread 1. Both threads would end up
> incrementing the number of bytes in the inode.
> 
> Sean, Vlastimil, is this a good argument for open coding, like in RFC v2
> [1]? So that guest_memfd can do inode_add_bytes() specifically when the
> folio is added to the filemap.

Heh, I assumed that was going to be _the_ argument, i.e. I was expecting the answer
to my implicit question of "if this greatly simplifies accounting" was going to be
"trying to do the right thing while using __filemap_get_folio_mpol() is insane".

> An alternative I can think of is to add a callback that is called from
> within __filemap_add_folio(). Would that be preferred?

Probably not.  Poking around, it definitely seems like guest_memfd is the oddball.
E.g. as David pointed out, even shmem participates in disk quota stuff, and HugeTLB
is its own beast.  In other words, I doubt any "real" filesystem will want to hook
__filemap_add_folio() in this way.

So as I said before, "if this greatly simplifies accounting, then I'm ok with it".
And it sounds like the answer is an emphatic "yes".  And again as I said before,
all I ask at this point is that the refactoring changelog focuses on that point.

P.S. In future versions, please explain _why_ you want to add fstat() support,
i.e. why you want to account allocated bytes/folios.  For folks like me that do
very little userspace programming, and even less filesystems work, fstat() not
working means nothing.  Even if the answer is "because literally every other FS
in Linux works".

