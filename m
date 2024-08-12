Return-Path: <kvm+bounces-23877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0501494F6C1
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 20:32:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29BE91C211DF
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 18:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3789A1917CD;
	Mon, 12 Aug 2024 18:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HSbIYrXX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C782178381
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 18:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723487456; cv=none; b=a+3psXhjpr1iRDfOYclGHo0vPRFJsq6pq78f57O2b86uuUowiBjTYm1SwtGFLDHqZdUOc3XfwzJIZCTlHH9QMjiLynETne1jr/v9lvvMVBuMjnOq76XLKX2BB5WOnNJSPhUHvR6OVVMDltl7KVcXYSv2To89Yl5v4LeDpcRrmOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723487456; c=relaxed/simple;
	bh=Zn57kG3fHkqhYjr0Vb+8fA7GL+EkzEs46JqrGXATWlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+mvDVoxKWb1jCLCEKXe4y6PvdMQl5fyD74DjDFmH0YI2h+Mv0pR5QYvYUfIws5azWY2CjbvAiX5vSia1DDSjYYIGVM6VVOeSsBNNydMaz2GUmd8fNpnim6aTF7Sca49s4p7VcqMiFcwdQgkC/o+70ilp27iS55GHLpD2YfLvm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HSbIYrXX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723487453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3lzHa+4oPgNh0JbtSfXdnixp3cbcHkW2yBVpxgt+hHU=;
	b=HSbIYrXXHZz5UpHxJGGfI2PxN9cXnnpwA1Jx+j927VyzmWqkhIRO3SKbPHH+z1DIbn6bHD
	53bsaRRdXX/Lo4jAIIIucyZBNkIRQSMVd3m68douih8byMhRDViql85iF01ziSOFxokqkc
	jMidpDzksFDbI3SHmGowXMt9u3uLRKk=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-5YcEkiwENRGsouL01FjfQQ-1; Mon, 12 Aug 2024 14:29:52 -0400
X-MC-Unique: 5YcEkiwENRGsouL01FjfQQ-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-49291c389b9so195883137.2
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 11:29:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723487391; x=1724092191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3lzHa+4oPgNh0JbtSfXdnixp3cbcHkW2yBVpxgt+hHU=;
        b=jhBIcl5UX/5wUnyceVaz/f9w2A6so0AgkyII8ODMIaojWk1ephjlUZiPE1sA5zEhCj
         je9KzMO/A7+BLlGX2pIwR6eUh9wd9UzIinDR0WCsvxNH3kfVrDRcTURRD0/88d+JF950
         zAnps3BPGHEYgbqz8JZI5fGwCYAWLEPBymZo3XPzmMPbg559OhbqlWF8mp+SjsuWM+RK
         +x6jaJjy9XP7lLl46A2cyAGuawZs4iCI9T1Rfs5DX2D7lOkhZwR8YxS9ApzuMtJjDO7p
         PcneddXI+vvsJYljBA0OAsaZlHvHCgadDTaUwx9Sv9HFoCeHVikQXklJZaaBIarUHIh2
         V3nw==
X-Forwarded-Encrypted: i=1; AJvYcCWtmh9HIlYOn9+T47Q8f6v7eGAXLOXuyDDtL2z1XMY7gtzPX5fEsSIhqQRKmWMehaWlR+g=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbtia1tZkqzysO0H/kM/DD1u7OsJRhmvygKOd9L6BPiKzxijKW
	3Y7UckCHMeJWNustMJTwBXU8+mNQR2vWsLVRd0ITtsrn+B2Y8G8yDq1i4MKcSPru9xp4MZODphG
	Ec5bBWI1eZCHXTM9uOXrD8tyX9YkrdnA82WVm77XNu2I0AjNwLg==
X-Received: by 2002:a05:6102:38d1:b0:493:31f9:d14e with SMTP id ada2fe7eead31-4974398cf6amr814418137.2.1723487391384;
        Mon, 12 Aug 2024 11:29:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgRvFG1AyF51iCR4QUK+iwha9x9ZVtk0r/+P1oFdTeH6YoJu+ZSYhqn/ax3TJ2lpn0JjOZGQ==
X-Received: by 2002:a05:6102:38d1:b0:493:31f9:d14e with SMTP id ada2fe7eead31-4974398cf6amr814391137.2.1723487390933;
        Mon, 12 Aug 2024 11:29:50 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4531c26dc23sm25342021cf.75.2024.08.12.11.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 11:29:50 -0700 (PDT)
Date: Mon, 12 Aug 2024 14:29:47 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 07/19] mm/fork: Accept huge pfnmap entries
Message-ID: <ZrpUm-Lz-plw_fZy@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-8-peterx@redhat.com>
 <d7fcec73-16f6-4d54-b334-6450a29e0a1d@redhat.com>
 <ZrZOqbS3bcj52JZP@x1n>
 <8ef394e6-a964-41c4-b33c-0e940b6b9bd8@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8ef394e6-a964-41c4-b33c-0e940b6b9bd8@redhat.com>

On Fri, Aug 09, 2024 at 07:59:58PM +0200, David Hildenbrand wrote:
> On 09.08.24 19:15, Peter Xu wrote:
> > On Fri, Aug 09, 2024 at 06:32:44PM +0200, David Hildenbrand wrote:
> > > On 09.08.24 18:08, Peter Xu wrote:
> > > > Teach the fork code to properly copy pfnmaps for pmd/pud levels.  Pud is
> > > > much easier, the write bit needs to be persisted though for writable and
> > > > shared pud mappings like PFNMAP ones, otherwise a follow up write in either
> > > > parent or child process will trigger a write fault.
> > > > 
> > > > Do the same for pmd level.
> > > > 
> > > > Signed-off-by: Peter Xu <peterx@redhat.com>
> > > > ---
> > > >    mm/huge_memory.c | 27 ++++++++++++++++++++++++---
> > > >    1 file changed, 24 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > > index 6568586b21ab..015c9468eed5 100644
> > > > --- a/mm/huge_memory.c
> > > > +++ b/mm/huge_memory.c
> > > > @@ -1375,6 +1375,22 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> > > >    	pgtable_t pgtable = NULL;
> > > >    	int ret = -ENOMEM;
> > > > +	pmd = pmdp_get_lockless(src_pmd);
> > > > +	if (unlikely(pmd_special(pmd))) {
> > > > +		dst_ptl = pmd_lock(dst_mm, dst_pmd);
> > > > +		src_ptl = pmd_lockptr(src_mm, src_pmd);
> > > > +		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
> > > > +		/*
> > > > +		 * No need to recheck the pmd, it can't change with write
> > > > +		 * mmap lock held here.
> > > > +		 */
> > > > +		if (is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd)) {
> > > > +			pmdp_set_wrprotect(src_mm, addr, src_pmd);
> > > > +			pmd = pmd_wrprotect(pmd);
> > > > +		}
> > > > +		goto set_pmd;
> > > > +	}
> > > > +
> > > 
> > > I strongly assume we should be using using vm_normal_page_pmd() instead of
> > > pmd_page() further below. pmd_special() should be mostly limited to GUP-fast
> > > and vm_normal_page_pmd().
> > 
> > One thing to mention that it has this:
> > 
> > 	if (!vma_is_anonymous(dst_vma))
> > 		return 0;
> 
> Another obscure thing in this function. It's not the job of copy_huge_pmd()
> to make the decision whether to copy, it's the job of vma_needs_copy() in
> copy_page_range().
> 
> And now I have to suspect that uffd-wp is broken with this function, because
> as vma_needs_copy() clearly states, we must copy, and we don't do that for
> PMDs. Ugh.
> 
> What a mess, we should just do what we do for PTEs and we will be fine ;)

IIUC it's not a problem: file uffd-wp is different from anonymous, in that
it pushes everything down to ptes.

It means if we skipped one huge pmd here for file, then it's destined to
have nothing to do with uffd-wp, otherwise it should have already been
split at the first attempt to wr-protect.

> 
> Also, we call copy_huge_pmd() only if "is_swap_pmd(*src_pmd) ||
> pmd_trans_huge(*src_pmd) || pmd_devmap(*src_pmd)"
> 
> Would that even be the case with PFNMAP? I suspect that pmd_trans_huge()
> would return "true" for special pfnmap, which is rather "surprising", but
> fortunate for us.

It's definitely not surprising to me as that's the plan.. and I thought it
shoulidn't be surprising to you - if you remember before I sent this one, I
tried to decouple that here with the "thp agnostic" series:

  https://lore.kernel.org/r/20240717220219.3743374-1-peterx@redhat.com

in which you reviewed it (which I appreciated).

So yes, pfnmap on pmd so far will report pmd_trans_huge==true.

> 
> Likely we should be calling copy_huge_pmd() if pmd_leaf() ... cleanup for
> another day.

Yes, ultimately it should really be a pmd_leaf(), but since I didn't get
much feedback there, and that can further postpone this series from being
posted I'm afraid, then I decided to just move on with "taking pfnmap as
THPs".  The corresponding change on this path is here in that series:

https://lore.kernel.org/all/20240717220219.3743374-7-peterx@redhat.com/

@@ -1235,8 +1235,7 @@ copy_pmd_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 	src_pmd = pmd_offset(src_pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (is_swap_pmd(*src_pmd) || pmd_trans_huge(*src_pmd)
-			|| pmd_devmap(*src_pmd)) {
+		if (is_swap_pmd(*src_pmd) || pmd_is_leaf(*src_pmd)) {
 			int err;
 			VM_BUG_ON_VMA(next-addr != HPAGE_PMD_SIZE, src_vma);
 			err = copy_huge_pmd(dst_mm, src_mm, dst_pmd, src_pmd,

> 
> > 
> > So it's only about anonymous below that.  In that case I feel like the
> > pmd_page() is benign, and actually good.
> 
> Yes, it would likely currently work.
> 
> > 
> > Though what you're saying here made me notice my above check doesn't seem
> > to be necessary, I mean, "(is_cow_mapping(src_vma->vm_flags) &&
> > pmd_write(pmd))" can't be true when special bit is set, aka, pfnmaps.. and
> > if it's writable for CoW it means it's already an anon.
> > 
> > I think I can probably drop that line there, perhaps with a
> > VM_WARN_ON_ONCE() making sure it won't happen.
> > 
> > > 
> > > Again, we should be doing this similar to how we handle PTEs.
> > > 
> > > I'm a bit confused about the "unlikely(!pmd_trans_huge(pmd)" check, below:
> > > what else should we have here if it's not a migration entry but a present
> > > entry?
> > 
> > I had a feeling that it was just a safety belt since the 1st day of thp
> > when Andrea worked that out, so that it'll work with e.g. file truncation
> > races.
> > 
> > But with current code it looks like it's only anonymous indeed, so looks
> > not possible at least from that pov.
> 
> Yes, as stated above, likely broken with UFFD-WP ...
> 
> I really think we should make this code just behave like it would with PTEs,
> instead of throwing in more "different" handling.

So it could simply because file / anon uffd-wp work very differently.

Let me know if you still spot something that is suspicious, but in all
cases I guess we can move on with this series, but maybe if you can find
something I can tackle them together when I decide to go back to the
mremap() issues in the other thread.

Thanks,

-- 
Peter Xu


