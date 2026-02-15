Return-Path: <kvm+bounces-71114-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBHoHToGkmnNpQEAu9opvQ
	(envelope-from <kvm+bounces-71114-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 18:45:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CBCA313F48C
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 18:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 125063016EC5
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 17:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB1C2F12A1;
	Sun, 15 Feb 2026 17:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BG+JR1Dy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8148E281532;
	Sun, 15 Feb 2026 17:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771177515; cv=none; b=py0o6qucLEHzt7tZ/5iergYRdY5fLBuypKqsA6LatZipsM1iZZ5VoWOdPdIYeTLGTxcHXrsQai9beRfSiRVA0OZH7RY3z6JDwo982UrIwLH3UT0kcPlGo21E0NkYzJpLpWk0NjHml1RTcJNJC4ma+kSHRjqif1wfHte24VAaamE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771177515; c=relaxed/simple;
	bh=8+vsibyilKDKEZUlnlJrlviFTSx+hiIe6MQ75WXS7Rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pdHC6xNAgkUavojOajT8wEGVfL1Sad9zm4Mv3IgD6JgWb9dipzN5D3mEotc9m5a8Cp8WMkvheIei/8Xe4RpU33HDEljq/Vtr1G8Jxn8l/0PrrVzPukFfuNMSU62OBB/dWGLhVlAcja3F3QvcAcKIJmmhaScxlg+FdUJAduNTbWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BG+JR1Dy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7335BC4CEF7;
	Sun, 15 Feb 2026 17:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771177515;
	bh=8+vsibyilKDKEZUlnlJrlviFTSx+hiIe6MQ75WXS7Rk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BG+JR1Dyi5VqlUUTMQf5o+IiWg/T2f3iM50oVhUC5iCYomQGcsnmguUIxywRlub2p
	 egB1quc0DK4f9M6/YLQTkMXWoMuBxZURAiXTZJqY4zFmhsg0k951pvj6wr8eH9F8wU
	 AM5JBmF6GY00arsIj/PxFJgo7GvSr9q2JubVLEHPAeo7A8BtVruoSMUZ7BFkzRhuog
	 Ex2bquQwk1LKEv9t0ST+8RVfYCe9ouxUlpG0FOs2qowxphlyDvx+mfSzVM+KgqcIxV
	 mUUtlI+5N1rCjkyk4hN+zdv8vjrFDLhhO5ln9E5kcqJad0eDxPxQ4gCLobLT56qZZr
	 ODkw7iWdblQ1w==
Date: Sun, 15 Feb 2026 19:45:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 10/17] shmem, userfaultfd: implement shmem uffd
 operations using vm_uffd_ops
Message-ID: <aZIGIH9--qOamaMe@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-11-rppt@kernel.org>
 <aYIzCuh8cjd09zrP@x1.local>
 <aYhm_4difwN5XXxe@kernel.org>
 <aYzf-hS4pUY9ulss@x1.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYzf-hS4pUY9ulss@x1.local>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71114-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rppt@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CBCA313F48C
X-Rspamd-Action: no action

On Wed, Feb 11, 2026 at 03:00:58PM -0500, Peter Xu wrote:
> On Sun, Feb 08, 2026 at 12:35:43PM +0200, Mike Rapoport wrote:
> > > > +static void shmem_mfill_filemap_remove(struct folio *folio,
> > > > +				       struct vm_area_struct *vma)
> > > > +{
> > > > +	struct inode *inode = file_inode(vma->vm_file);
> > > > +
> > > > +	filemap_remove_folio(folio);
> > > > +	shmem_recalc_inode(inode, 0, 0);
> > > >  	folio_unlock(folio);
> > > > -	folio_put(folio);
> > > > -out_unacct_blocks:
> > > > -	shmem_inode_unacct_blocks(inode, 1);
> > > 
> > > This looks wrong, or maybe I miss somewhere we did the unacct_blocks()?
> > 
> > This is handled by shmem_recalc_inode(inode, 0, 0).
> 
> IIUC shmem_recalc_inode() only does the fixup of shmem_inode_info over
> possiblly changing inode->i_mapping->nrpages.  It's not for reverting the
> accounting in the failure paths here.
> 
> OTOH, we still need to maintain accounting for the rest things with
> correctly invoke shmem_inode_unacct_blocks().  One thing we can try is
> testing this series against either shmem quota support (since 2023, IIUC
> it's relevant to "quota" mount option), or max_blocks accountings (IIUC,
> "size" mount option), etc.  Any of those should reflect a difference if my
> understanding is correct.
> 
> So IIUC we still need the unacct_blocks(), please kindly help double check.

I followed shmem_get_folio_gfp() error handling, and unless I missed
something we should have the same sequence with uffd.

In shmem_mfill_filemap_add() we increment both i_mapping->nrpages and
info->alloced in shmem_add_to_page_cache() and 
shmem_recalc_inode(inode, 1, 0) respectively.

Then in shmem_filemap_remove() the call to filemap_remove_folio()
decrements i_mapping->nrpages and shmem_recalc_inode(inode, 0, 0) will see
freed=1 and will call shmem_inode_unacct_blocks().
 
> Thanks,
> 
> -- 
> Peter Xu
> 

-- 
Sincerely yours,
Mike.

