Return-Path: <kvm+bounces-40832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B84BA5E0CE
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 16:45:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F22591889072
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 15:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26D83253322;
	Wed, 12 Mar 2025 15:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hXWkyMkq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542F823BD0C
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 15:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741794346; cv=none; b=L+IQQ3hYMihbcoCJz7InzhnmkXhopPteOnycAn4yZzl6e+WQWEmxp1IEMc2BdoRAVzuaFJqMjK6vpE3iPc2lbAVGJc5npFYW9oiHOAMKT3WPaNtaIkX7BHviKHzJqN9+JIp79PVoR93RD+rxih/sCbmvY99cZD3PHOFs/UhSu24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741794346; c=relaxed/simple;
	bh=D/wZ1TUBH9NL6fkDzSIbr43ucRHs/N+gCZnO6yydIP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeCK73XQnRur2M8kb4aRjWmUN+x5fgEa/Aw6QJn9x5G98B1PtDk7JU8e42lxad53+z+MbPv9ER06lGCwe0SeAFQWwvsa9rC8uvbGekivEhJ7JRAAyeHfoHgoHmiEF2VASOn6Au43n+NliC19E9aod2m70rA5BwGLwCZC5X1YoQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hXWkyMkq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741794343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ut4pbapSzhs8uCjUUCSZVy14MK3K3nRSMdDH7UTR4MM=;
	b=hXWkyMkq1IgxdVm3S7pDcoQceimXRKyxBlwZHCUWjsjZthykOQmttKg/EvTaB3rsxezTUS
	Zx4J0pF/ND5iCY28Gf9TDC/mio2x9dDB6yPy/Xk6RubtxRIRUoJqcM25NvJY5pDBTb7GKF
	Vyxa7aRVUBsH9kL6ML3WMVPGJOexwO0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-R9TEX-7iOS20hcU1Zz6bNA-1; Wed, 12 Mar 2025 11:45:42 -0400
X-MC-Unique: R9TEX-7iOS20hcU1Zz6bNA-1
X-Mimecast-MFC-AGG-ID: R9TEX-7iOS20hcU1Zz6bNA_1741794341
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c53b4b0d69so1296228485a.2
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 08:45:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741794341; x=1742399141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ut4pbapSzhs8uCjUUCSZVy14MK3K3nRSMdDH7UTR4MM=;
        b=O9p/5Ku7XqXQZFCRpAZyXzd/9/FqKyUxGeNMEPrKr3WTatb/NSxCIqoR8IiyCHp41v
         n+XPSfHwPbpd8RNGn6fMnj8aKjW/Q1EQr5fzByexGLMGGATl7YvHJqwuTalA97978x4O
         kn62/3VEoa/I9kgr6LicTDK+yOQJVB2yz3rKHBPbAOf+D4yvy07XzYIlKntR3nTDxL3k
         gYMfWryQNJ/BZMgJ8ZMIQEQUaM3etqoma8e9HuFHUkt5+oArmOE4ast1FnPj9qAJlmUX
         YvvNGM93COrNxjgoKDvyc8FMES+qx1Rb0tjHW6HhlSpDqZx1WTgqjvqClObSV8k68qQj
         iSug==
X-Forwarded-Encrypted: i=1; AJvYcCWF7VHJz6toFFsDaoTHx69y0luyHmwk68YcaMeI9j7TjXu/xVjmHie/v6+57uyZrWM78G0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7f/81nuuJd1zSLVYIgOxh9xRPS6IZVE83qabpTQgLi8og6by7
	6TAd4z8tMu+AjRD1kejA2/4YbLDsPifb8YBd2MCXl69s2BNhzQzfOOwZrKMLQXUHwFabqkeAW5A
	At5EEBaENGu8stGbHiFh25V/Fq0T/R8vmuo/wNi+0kjasgLSugw==
X-Gm-Gg: ASbGnctfLXnK3naXf8IF818gQb7CMhDFF2zcJvp8XC9gwrVLP8g2Y1kgmEjIgA5uyCD
	YFsjRs2ZPDBAG6AvjzxZ3p5+RaWg9EzP6QDHs5tL3+naooYT4vx6Ph3f+bpOerF6Qp+xdg4eYJv
	nc0Gw0Ry8aYz9sfSizwP3cmI/HEX9zz1OGWZSHwiPktFhJ8zg3gbcVQLoeWnaTJsnEGi6lJj23b
	WJz5I0tV9S/Q/PKY5yRcCW5ozidoI+ByM/fEtYZ9uxX9OcSV+o0DOGWnKqmDYK6ovQBoFp2jvpw
	Qvo/rrs=
X-Received: by 2002:a05:620a:26a3:b0:7c5:5692:ee91 with SMTP id af79cd13be357-7c55692f028mr1679141585a.23.1741794341495;
        Wed, 12 Mar 2025 08:45:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFeUONLhGbcchFtsON6vku9vRaOBMh9M5T52ggQTNZ6v7izQr/2SjLlIdPk6U0xKsrrhbgKhA==
X-Received: by 2002:a05:620a:26a3:b0:7c5:5692:ee91 with SMTP id af79cd13be357-7c55692f028mr1679137385a.23.1741794341075;
        Wed, 12 Mar 2025 08:45:41 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c545fd5772sm634042685a.35.2025.03.12.08.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 08:45:40 -0700 (PDT)
Date: Wed, 12 Mar 2025 11:45:36 -0400
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: James Houghton <jthoughton@google.com>, akpm@linux-foundation.org,
	pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, david@redhat.com,
	ryan.roberts@arm.com, quic_eberman@quicinc.com, graf@amazon.de,
	jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com,
	nsaenz@amazon.es, xmarcalx@amazon.com
Subject: Re: [RFC PATCH 0/5] KVM: guest_memfd: support for uffd missing
Message-ID: <Z9GsIDVYWoV8d8-C@x1.local>
References: <20250303133011.44095-1-kalyazin@amazon.com>
 <Z8YfOVYvbwlZST0J@x1.local>
 <CADrL8HXOQ=RuhjTEmMBJrWYkcBaGrqtXmhzPDAo1BE3EWaBk4g@mail.gmail.com>
 <Z8i0HXen8gzVdgnh@x1.local>
 <fdae95e3-962b-4eaf-9ae7-c6bd1062c518@amazon.com>
 <Z89EFbT_DKqyJUxr@x1.local>
 <9e7536cc-211d-40ca-b458-66d3d8b94b4d@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e7536cc-211d-40ca-b458-66d3d8b94b4d@amazon.com>

On Tue, Mar 11, 2025 at 04:56:47PM +0000, Nikita Kalyazin wrote:
> 
> 
> On 10/03/2025 19:57, Peter Xu wrote:
> > On Mon, Mar 10, 2025 at 06:12:22PM +0000, Nikita Kalyazin wrote:
> > > 
> > > 
> > > On 05/03/2025 20:29, Peter Xu wrote:
> > > > On Wed, Mar 05, 2025 at 11:35:27AM -0800, James Houghton wrote:
> > > > > I think it might be useful to implement an fs-generic MINOR mode. The
> > > > > fault handler is already easy enough to do generically (though it
> > > > > would become more difficult to determine if the "MINOR" fault is
> > > > > actually a MISSING fault, but at least for my userspace, the
> > > > > distinction isn't important. :)) So the question becomes: what should
> > > > > UFFDIO_CONTINUE look like?
> > > > > 
> > > > > And I think it would be nice if UFFDIO_CONTINUE just called
> > > > > vm_ops->fault() to get the page we want to map and then mapped it,
> > > > > instead of having shmem-specific and hugetlb-specific versions (though
> > > > > maybe we need to keep the hugetlb specialization...). That would avoid
> > > > > putting kvm/gmem/etc. symbols in mm/userfaultfd code.
> > > > > 
> > > > > I've actually wanted to do this for a while but haven't had a good
> > > > > reason to pursue it. I wonder if it can be done in a
> > > > > backwards-compatible fashion...
> > > > 
> > > > Yes I also thought about that. :)
> > > 
> > > Hi Peter, hi James.  Thanks for pointing at the race condition!
> > > 
> > > I did some experimentation and it indeed looks possible to call
> > > vm_ops->fault() from userfault_continue() to make it generic and decouple
> > > from KVM, at least for non-hugetlb cases.  One thing is we'd need to prevent
> > > a recursive handle_userfault() invocation, which I believe can be solved by
> > > adding a new VMF flag to ignore the userfault path when the fault handler is
> > > called from userfault_continue().  I'm open to a more elegant solution
> > > though.
> > 
> > It sounds working to me.  Adding fault flag can also be seen as part of
> > extension of vm_operations_struct ops.  So we could consider reusing
> > fault() API indeed.
> 
> Great!
> 
> > > 
> > > Regarding usage of the MINOR notification, in what case do you recommend
> > > sending it?  If following the logic implemented in shmem and hugetlb, ie if
> > > the page is _present_ in the pagecache, I can't see how it is going to work
> > 
> > It could be confusing when reading that chunk of code, because it looks
> > like it notifies minor fault when cache hit. But the critical part here is
> > that we rely on the pgtable missing causing the fault() to trigger first.
> > So it's more like "cache hit && pgtable missing" for minor fault.
> 
> Right, but the cache hit still looks like a precondition for the minor fault
> event?

Yes.

> 
> > > with the write syscall, as we'd like to know when the page is _missing_ in
> > > order to respond with the population via the write.  If going against
> > > shmem/hugetlb logic, and sending the MINOR event when the page is missing
> > > from the pagecache, how would it solve the race condition problem?
> > 
> > Should be easier we stick with mmap() rather than write().  E.g. for shmem
> > case of current code base:
> > 
> >          if (folio && vma && userfaultfd_minor(vma)) {
> >                  if (!xa_is_value(folio))
> >                          folio_put(folio);
> >                  *fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
> >                  return 0;
> >          }
> > 
> > vma is only availble if vmf!=NULL, aka in fault context.  With that, in
> > write() to shmem inodes, nothing will generate a message, because minor
> > fault so far is only about pgtable missing.  It needs to be mmap()ed first,
> > and has nothing yet to do with write() syscalls.
> 
> Yes, that's true that write() itself isn't going to generate a message. My
> idea was to _respond_ to a message generated by the fault handler (vmf !=
> NULL) with a write().  I didn't mean to generate it from write().
> 
> What I wanted to achieve was send a message on fault + cache miss and
> respond to the message with a write() to fill the cache followed by a
> UFFDIO_CONTINUE to set up pagetables.  I understand that a MINOR trap (MINOR
> + UFFDIO_CONTINUE) is preferable, but how does it fit into this model?
> What/how will guarantee a cache hit that would trigger the MINOR message?
> 
> To clarify, I would like to be able to populate pages _on-demand_, not only
> proactively (like in the original UFFDIO_CONTINUE cover letter [1]).  Do you
> think the MINOR trap could still be applicable or would it necessarily
> require the MISSING trap?

I think MINOR can also achieve similar things.  MINOR traps the pgtable
missing event (let's imagine page cache is already populated, or at least
when MISSING mode not registered, it'll auto-populate on 1st access).  So
as long as the content can only be accessed from the pgtable (either via
mmap() or GUP on top of it), then afaiu it could work similarly like
MISSING faults, because anything trying to access it will be trapped.

Said that, we can also choose to implement MISSING first.  In that case
write() is definitely not enough, because MISSING is at least so far based
on top of whether the page cache present, and write() won't be atomic on
update a page.  We need to implement UFFDIO_COPY for gmemfd MISSING.

Either way looks ok to me.

> 
> [1] https://lore.kernel.org/linux-fsdevel/20210301222728.176417-1-axelrasmussen@google.com/T/
> 
> > > 
> > > Also, where would the check for the folio_test_uptodate() mentioned by James
> > > fit into here?  Would it only be used for fortifying the MINOR (present)
> > > against the race?
> > > 
> > > > When Axel added minor fault, it's not a major concern as it's the only fs
> > > > that will consume the feature anyway in the do_fault() path - hugetlbfs has
> > > > its own path to take care of.. even until now.
> > > > 
> > > > And there's some valid points too if someone would argue to put it there
> > > > especially on folio lock - do that in shmem.c can avoid taking folio lock
> > > > when generating minor fault message.  It might make some difference when
> > > > the faults are heavy and when folio lock is frequently taken elsewhere too.
> > > 
> > > Peter, could you expand on this?  Are you referring to the following
> > > (shmem_get_folio_gfp)?
> > > 
> > >        if (folio) {
> > >                folio_lock(folio);
> > > 
> > >                /* Has the folio been truncated or swapped out? */
> > >                if (unlikely(folio->mapping != inode->i_mapping)) {
> > >                        folio_unlock(folio);
> > >                        folio_put(folio);
> > >                        goto repeat;
> > >                }
> > >                if (sgp == SGP_WRITE)
> > >                        folio_mark_accessed(folio);
> > >                if (folio_test_uptodate(folio))
> > >                        goto out;
> > >                /* fallocated folio */
> > >                if (sgp != SGP_READ)
> > >                        goto clear;
> > >                folio_unlock(folio);
> > >                folio_put(folio);
> > >        }

[1]

> > > 
> > > Could you explain in what case the lock can be avoided?  AFAIC, the function
> > > is called by both the shmem fault handler and userfault_continue().
> > 
> > I think you meant the UFFDIO_CONTINUE side of things.  I agree with you, we
> > always need the folio lock.
> > 
> > What I was saying is the trapping side, where the minor fault message can
> > be generated without the folio lock now in case of shmem.  It's about
> > whether we could generalize the trapping side, so handle_mm_fault() can
> > generate the minor fault message instead of by shmem.c.
> > 
> > If the only concern is "referring to a module symbol from core mm", then
> > indeed the trapping side should be less of a concern anyway, because the
> > trapping side (when in the module codes) should always be able to reference
> > mm functions.
> > 
> > Actually.. if we have a fault() flag introduced above, maybe we can
> > generalize the trap side altogether without the folio lock overhead.  When
> > the flag set, if we can always return the folio unlocked (as long as
> > refcount held), then in UFFDIO_CONTINUE ioctl we can lock it.
> 
> Where does this locking happen exactly during trapping?  I was thinking it
> was only done when the page was allocated.  The trapping part (quoted by you
> above) only looks up the page in the cache and calls handle_userfault().  Am
> I missing something?

That's only what I worry if we want to reuse fault() to generalize the trap
code in core mm, because fault() by default takes the folio lock at least
for shmem.  I agree the folio doesn't need locking when trapping the fault
and sending the message.

Thanks,

> 
> > > 
> > > > It might boil down to how many more FSes would support minor fault, and
> > > > whether we would care about such difference at last to shmem users. If gmem
> > > > is the only one after existing ones, IIUC there's still option we implement
> > > > it in gmem code.  After all, I expect the change should be very under
> > > > control (<20 LOCs?)..
> > > > 
> > > > --
> > > > Peter Xu
> > > > 
> > > 
> > 
> > --
> > Peter Xu
> > 
> 

-- 
Peter Xu


