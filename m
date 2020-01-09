Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087101361AA
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 21:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgAIUTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 15:19:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48801 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729493AbgAIUTW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 15:19:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578601160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xRmMUmkxFLwDnIC2NJrxvA86Eun+PiOxEnnGKDbXJ20=;
        b=E7eE+CfrdmP4lUVtvonmtbeJ6lDi7vRsxWeuOnUz8dxARE9bVemF9g9LQsSh38tJItqP1k
        40PpwKan3pNhdc5Z60tkrpZ+1p7LU5hXnV/OjkAtx0ikYWTbNzfhcD8QGlCHLjbkT0SOUn
        ROpwVU9UOTG6T34bxBL9fFo+dtbwDqc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-JdjPFoJYPZq9SCMgfTPoYQ-1; Thu, 09 Jan 2020 15:19:19 -0500
X-MC-Unique: JdjPFoJYPZq9SCMgfTPoYQ-1
Received: by mail-qv1-f70.google.com with SMTP id l1so4866143qvu.13
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 12:19:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xRmMUmkxFLwDnIC2NJrxvA86Eun+PiOxEnnGKDbXJ20=;
        b=B+tjh7sUomOI0lRtuDYLcgJezI7/Le6dbpk+7KWeNX+NkuTw1dGCiK5oogeAZ34GZi
         nj5Pc4GOgk7HAEONg4Y8/eD0PvSc09L3hSOwVRMUW+hSflRC+R+gdCtOg5JIGzptW8yN
         e3jyKkg4RSgpzk307glZfwSV0FbZK/M0eikRNsSWJNXA5A+e16ttnBaBjpXntfz7RHX/
         tslAlCGJXoYO3+zzxab24tGHRO8V1uN9S53WutyY+hAd/fA3EgpzRi17Chlm9NsO0pcX
         oOcti60YeKlkBeu0ckI+qdlDc1aA1IB3LCpFJcaZg54SNI4KPuu6jZGpAz3KIGL/usGP
         gAtg==
X-Gm-Message-State: APjAAAXFw23ieARKmoj5I87zUKpwkmN3X9+FlegW0h9zefSvhYCdI7hp
        oYvUiwfmRmcLtvtOXT6r8nReB6Ifn/i1P15kUyettCBLOLTgp8LevmJkRT2K3gSnR7I0LhA2sXf
        2kWxF9OxsTGO7
X-Received: by 2002:a05:620a:14bc:: with SMTP id x28mr11162815qkj.494.1578601158767;
        Thu, 09 Jan 2020 12:19:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqxEIqYHGQUVPi+klS+m/mjrcBgk86zbrs4bfr92JwFFD/0gW01rdhfCi1Q/7OATxPl0IP/REQ==
X-Received: by 2002:a05:620a:14bc:: with SMTP id x28mr11162777qkj.494.1578601158313;
        Thu, 09 Jan 2020 12:19:18 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id s1sm3517948qkm.84.2020.01.09.12.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 12:19:17 -0800 (PST)
Date:   Thu, 9 Jan 2020 15:19:16 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200109201916.GH36997@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109191514.GD36997@xz-x1>
 <20200109141634-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200109141634-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 02:35:46PM -0500, Michael S. Tsirkin wrote:

[...]

> > > I know index design is popular, but testing with virtio showed
> > > that it's better to just have a flags field marking
> > > an entry as valid. In particular this gets rid of the
> > > running counters and power of two limitations.
> > > It also removes the need for a separate index page, which is nice.
> > 
> > Firstly, note that the separate index page has already been dropped
> > since V2, so we don't need to worry on that.
> 
> changelog would be nice.

Actually I mentioned it in V2:

https://lore.kernel.org/kvm/20191221014938.58831-1-peterx@redhat.com/

There's a section "Per-vm ring is dropped".  But it's indeed hiding
behind the wall that the index page is bound to the per-vm ring...
I'll try to be more clear in the cover letter in the future.

> So now, how does userspace tell kvm it's done with the ring?

It should rarely tell unless the ring reaches soft-full, in that case
the vcpu KVM_RUN will return with KVM_EXIT_DIRTY_RING_FULL.

> 
> > Regarding dropping the indices: I feel like it can be done, though we
> > probably need two extra bits for each GFN entry, for example:
> > 
> >   - Bit 0 of the GFN address to show whether this is a valid publish
> >     of dirty gfn
> > 
> >   - Bit 1 of the GFN address to show whether this is collected by the
> >     user
> 
> 
> I wonder whether you will end up reinventing virtio.
> You are already pretty close with avail/used bits in flags.
> 
> 
> 
> > We can also use the padding field, but just want to show the idea
> > first.
> > 
> > Then for each GFN we can go through state changes like this (things
> > like "00b" stands for "bit1 bit0" values):
> > 
> >   00b (invalid GFN) ->
> >     01b (valid gfn published by kernel, which is dirty) ->
> >       10b (gfn dirty page collected by userspace) ->
> >         00b (gfn reset by kernel, so goes back to invalid gfn)
> > 
> > And we should always guarantee that both the userspace and KVM walks
> > the GFN array in a linear manner, for example, KVM must publish a new
> > GFN with bit 1 set right after the previous publish of GFN.  Vice
> > versa to the userspace when it collects the dirty GFN and mark bit 2.
> > 
> > Michael, do you mean something like this?
> > 
> > I think it should work logically, however IIUC it can expose more
> > security risks, say, dirty ring is different from virtio in that
> > userspace is not trusted,
> 
> In what sense?

In the sense of general syscalls?  Like, we shouldn't allow the kernel
to break and go wild no matter what the userspace does?

> 
> > while for virtio, both sides (hypervisor,
> > and the guest driver) are trusted.
> 
> What gave you the impression guest is trusted in virtio?

Hmm... maybe when I know virtio can bypass vIOMMU as long as it
doesn't provide IOMMU_PLATFORM flag? :)

I think it's logical to trust a virtio guest kernel driver, could you
guide me on what I've missed?

> 
> 
> >  Above means we need to do these to
> > change to the new design:
> > 
> >   - Allow the GFN array to be mapped as writable by userspace (so that
> >     userspace can publish bit 2),
> > 
> >   - The userspace must be trusted to follow the design (just imagine
> >     what if the userspace overwrites a GFN when it publishes bit 2
> >     over a valid dirty gfn entry?  KVM could wrongly unprotect a page
> >     for the guest...).
> 
> You mean protect, right?  So what?

Yes, I mean with that, more things are uncertain from userspace.  It
seems easier to me that we restrict the userspace with one index.

> 
> > While if we use the indices, we restrict the userspace to only be able
> > to write to one index only (which is the reset_index).  That's all it
> > can do to mess things up (and it could never as long as we properly
> > validate the reset_index when read, which only happens during
> > KVM_RESET_DIRTY_RINGS and is very rare).  From that pov, it seems the
> > indices solution still has its benefits.
> 
> So if you mess up index how is this different?

We can't mess up much with that.  We simply check fetch_index (sorry I
meant this when I said reset_index, anyway it's the only index that we
expose to userspace) to make sure:

  reset_index <= fetch_index <= dirty_index

Otherwise we fail the ioctl.  With that, we're 100% safe.

> 
> I agree RO page kind of feels safer generally though.
> 
> I will have to re-read how does the ring works though,
> my comments were based on the old assumption of mmaped
> page with indices.

Yes, sorry again for a bad cover letter.

It's basically the same as before, just that we only have per-vcpu
ring now, and the indices are exposed from kvm_run so we don't need
the extra page, but we still expose that via mmap.

> 
> 
> 
> > > 
> > > 
> > > 
> > > >  The larger the ring buffer, the less
> > > > +likely the ring is full and the VM is forced to exit to userspace. The
> > > > +optimal size depends on the workload, but it is recommended that it be
> > > > +at least 64 KiB (4096 entries).
> > > 
> > > Where's this number coming from? Given you have indices as well,
> > > 4K size rings is likely to cause cache contention.
> > 
> > I think we've had some similar discussion in previous versions on the
> > size of ring.  Again imho it's really something that may not have a
> > direct clue as long as it's big enough (4K should be).
> > 
> > Regarding to the cache contention: could you explain more?
> 
> 4K is a whole cache way. 64K 16 ways.  If there's anything else is a hot
> path then you are pushing everything out of cache.  To re-read how do
> indices work so see whether an index is on hot path or not. If yes your
> structure won't fit in L1 cache which is not great.

I'm not sure whether I get the point correct, but logically we
shouldn't read the whole ring buffer as a whole, but only partly (just
like when we say the ring shouldn't even reach soft-full).  Even if we
read the whole ring, I don't see a difference here comparing to when
we read a huge array of data (e.g. "char buf[65536]") in any program
that covers 64K range - I don't see a good way to fix this but read
the whole chunk in.  It seems to be common in programs where we have
big dataset.

[...]

> > > > +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> > > > +{
> > > > +	u32 cur_slot, next_slot;
> > > > +	u64 cur_offset, next_offset;
> > > > +	unsigned long mask;
> > > > +	u32 fetch;
> > > > +	int count = 0;
> > > > +	struct kvm_dirty_gfn *entry;
> > > > +	struct kvm_dirty_ring_indices *indices = ring->indices;
> > > > +	bool first_round = true;
> > > > +
> > > > +	fetch = READ_ONCE(indices->fetch_index);
> > > 
> > > So this does not work if the data cache is virtually tagged.
> > > Which to the best of my knowledge isn't the case on any
> > > CPU kvm supports. However it might not stay being the
> > > case forever. Worth at least commenting.
> > 
> > This is the read side.  IIUC even if with virtually tagged archs, we
> > should do the flushing on the write side rather than the read side,
> > and that should be enough?
> 
> No.
> See e.g.  Documentation/core-api/cachetlb.rst
> 
>   ``void flush_dcache_page(struct page *page)``
> 
>         Any time the kernel writes to a page cache page, _OR_
>         the kernel is about to read from a page cache page and
>         user space shared/writable mappings of this page potentially
>         exist, this routine is called.

But I don't understand why.  I feel like for such arch even the
userspace must flush cache after publishing data onto shared memories,
otherwise if the shared memory is between two userspace processes
they'll get inconsistent state.  Then if with that, I'm confused on
why the read side needs to flush it again.

> 
> 
> > Also, I believe this is the similar question that Jason has asked in
> > V2.  Sorry I should mention this earlier, but I didn't address that in
> > this series because if we need to do so we probably need to do it
> > kvm-wise, rather than only in this series.
> 
> You need to document these things.
> 
> >  I feel like it's missing
> > probably only because all existing KVM supported archs do not have
> > virtual-tagged caches as you mentioned.
> 
> But is that a fact? ARM has such a variety of CPUs,
> I can't really tell. Did you research this to make sure?

I didn't.  I only tried to find all callers of flush_dcache_page()
through the whole Linux tree and I cannot see any kvm related code.
To make this simple, let me address the dcache flushing issue in the
next post.

Thanks,

-- 
Peter Xu

