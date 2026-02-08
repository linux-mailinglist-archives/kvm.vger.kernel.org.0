Return-Path: <kvm+bounces-70548-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oDXbEoJdiGlwowQAu9opvQ
	(envelope-from <kvm+bounces-70548-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 10:55:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D353410846E
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 10:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9A5CA3014C0F
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 09:55:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AF934678C;
	Sun,  8 Feb 2026 09:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWSbWdyb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66C5487BE;
	Sun,  8 Feb 2026 09:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770544498; cv=none; b=P2eDOs1Yha7LlVZXOkW4rOlwjcwLMgvEFEd4Jlk/OSz9TWZQE/HFDSyjjZxczx6UGKxSlDHEXekkAquP6k6/jNTHfVoBKUtptUvDP2pw3g8JagTGalYbfG5qvV8u7OwykdC7pKDij3LUcBSr0Ud29caQ06vyXZmMjb2nRsuFw1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770544498; c=relaxed/simple;
	bh=VAJOqVbp2qDpQlX5+DAiOZoQgjFgIQczf/wGGbbFMDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SdZYmLH58sM86WDJjVH1UkdWu1fR2h0odKI3LvtcDGlh3yvwfcylAEMfWKdv7QRNkkYe1LIheBH4AYNEktlKsl56yUBMQNt/QORokb7cxMcwz3GQZvk9Gdrlng0lkJb9XRCb0paTe+xfwAsFDvF6jNLFrbDTwDp/NF9WZ2dXLKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWSbWdyb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B95C4CEF7;
	Sun,  8 Feb 2026 09:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770544498;
	bh=VAJOqVbp2qDpQlX5+DAiOZoQgjFgIQczf/wGGbbFMDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CWSbWdybgY7UKB8egp0AumFhSehROCOkw9ZwBvyaB6Cr22MlGdRfkppkARTv7xewS
	 CpHNebSqqlIlT+2SLxibHqkFfNvB/3ZZdew3XlQvCFNnuqqPmhBfuFp7R9CySFXrfm
	 298DS+S+pzIs5+sr4C9vPi49Cy65bixVDgtAu9fri2TmVXOjSpVLLVq0g1xGb3KAy/
	 cxKSP6KyriklgEyw6h2yYqJ1VyqiJTYr+y0Dlp7/qYd+3DvUc5p6FSoOtF1xV/oNnk
	 p+S/n7dVe31j+VtH3WAvWIKC5ZWWfkwmqRMyDS3y1ZOJQLH2kXNHqk0KZGtvpD/W/h
	 eGXZnCMt9eVXA==
Date: Sun, 8 Feb 2026 11:54:47 +0200
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
Subject: Re: [PATCH RFC 04/17] userfaultfd: introduce mfill_get_vma() and
 mfill_put_vma()
Message-ID: <aYhdZ_fOrkmAsSEX@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-5-rppt@kernel.org>
 <aYEb1RlGWBJWKXNg@x1.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYEb1RlGWBJWKXNg@x1.local>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70548-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[23];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rppt@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: D353410846E
X-Rspamd-Action: no action

Hi Peter,

On Mon, Feb 02, 2026 at 04:49:09PM -0500, Peter Xu wrote:
> Hi, Mike,
> 
> On Tue, Jan 27, 2026 at 09:29:23PM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Split the code that finds, locks and verifies VMA from mfill_atomic()
> > into a helper function.
> > 
> > This function will be used later during refactoring of
> > mfill_atomic_pte_copy().
> > 
> > Add a counterpart mfill_put_vma() helper that unlocks the VMA and
> > releases map_changing_lock.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  mm/userfaultfd.c | 124 ++++++++++++++++++++++++++++-------------------
> >  1 file changed, 73 insertions(+), 51 deletions(-)
> > 
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 9dd285b13f3b..45d8f04aaf4f 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -157,6 +157,73 @@ static void uffd_mfill_unlock(struct vm_area_struct *vma)
> >  }
> >  #endif
> >  
> > +static void mfill_put_vma(struct mfill_state *state)
> > +{
> > +	up_read(&state->ctx->map_changing_lock);
> > +	uffd_mfill_unlock(state->vma);
> > +	state->vma = NULL;
> > +}
> > +
> > +static int mfill_get_vma(struct mfill_state *state)
> > +{
> > +	struct userfaultfd_ctx *ctx = state->ctx;
> > +	uffd_flags_t flags = state->flags;
> > +	struct vm_area_struct *dst_vma;
> > +	int err;
> > +
> > +	/*
> > +	 * Make sure the vma is not shared, that the dst range is
> > +	 * both valid and fully within a single existing vma.
> > +	 */
> > +	dst_vma = uffd_mfill_lock(ctx->mm, state->dst_start, state->len);
> > +	if (IS_ERR(dst_vma))
> > +		return PTR_ERR(dst_vma);
> > +
> > +	/*
> > +	 * If memory mappings are changing because of non-cooperative
> > +	 * operation (e.g. mremap) running in parallel, bail out and
> > +	 * request the user to retry later
> > +	 */
> > +	down_read(&ctx->map_changing_lock);
> > +	err = -EAGAIN;
> > +	if (atomic_read(&ctx->mmap_changing))
> > +		goto out_unlock;
> > +
> > +	err = -EINVAL;
> > +
> > +	/*
> > +	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
> > +	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
> > +	 */
> > +	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
> > +	    dst_vma->vm_flags & VM_SHARED))
> > +		goto out_unlock;
> > +
> > +	/*
> > +	 * validate 'mode' now that we know the dst_vma: don't allow
> > +	 * a wrprotect copy if the userfaultfd didn't register as WP.
> > +	 */
> > +	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
> > +		goto out_unlock;
> > +
> > +	if (is_vm_hugetlb_page(dst_vma))
> > +		goto out;
> > +
> > +	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> > +		goto out_unlock;
> > +	if (!vma_is_shmem(dst_vma) &&
> > +	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> > +		goto out_unlock;
> 
> IMHO it's a bit weird to check for vma permissions in a get_vma() function.
> 
> Also, in the follow up patch it'll be also reused in
> mfill_copy_folio_retry() which doesn't need to check vma permission.
> 
> Maybe we can introduce mfill_vma_check() for these two checks? Then we can
> also drop the slightly weird is_vm_hugetlb_page() check (and "out" label)
> above.

This version of get_vma() keeps the checks exactly as they were when we
were retrying after dropping the lock and I prefer to have them this way to
begin with.
Later we can optimize this further after the dust settles after these
changes.

-- 
Sincerely yours,
Mike.

