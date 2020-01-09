Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 810D11360D5
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 20:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgAITPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 14:15:21 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57374 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728533AbgAITPU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 14:15:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578597319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MyzLxhSnUiH7m25XP0Fm5mQtrS3ll15tP0cf5FvmEFk=;
        b=Kg33pSkoWz6CEJPwsTGbEsdtdIuN+9l/g3B3AgZnWc7/YbYvd9TWmYOEzrCNicUd+Pj+hH
        m6IpirgZiyIq34HqSI0OGNQwpmipB2UE1WX+/ERjYZQ528/QXjBQaQ8P2lk/AnzSBAU3da
        fm9/qiEz5qU6hdqQDwVdesAMUGIOk50=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-IqF23LIONACRyTrq2Nfk4A-1; Thu, 09 Jan 2020 14:15:18 -0500
X-MC-Unique: IqF23LIONACRyTrq2Nfk4A-1
Received: by mail-qv1-f69.google.com with SMTP id z9so4729492qvo.10
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 11:15:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MyzLxhSnUiH7m25XP0Fm5mQtrS3ll15tP0cf5FvmEFk=;
        b=Q4YSdmncxOA45Li0py/Kmd/Rhmd6zDlFlvmA6/8IO0fl1T0x1sOVHMp1LqzD1nYTy/
         9i8ZNWwZBiDXK0OjVhPM0flFsjOp8ODy14q57JGtU6xCfCWoU52Y18Iq5ozrTVcCKVox
         rqmqgvaQpLqE5eOd9sw0ueZcOT99gzZtUXu7A0DRw+Zz86h1R805bOF6s0Jct4AS6aab
         2VZEmDd3h/cZ+qhuVa3Qfwc8xoz1iPevJCysiKHjh0JppZp0IRjljLqmuWmUfU146mAz
         m+RooeH05H63KHa02WrmnKibc3fqFyJCrK099isu7O5mvhkTAHRm0Iw3mR8UFUs0u9vQ
         vPtg==
X-Gm-Message-State: APjAAAUFACym1f0FSdakpALvrNjIwtMkF+ulEX+Zhwo54S40hdzOKtHZ
        iDB1poRvIM/zD7U3FlEXdbc+Y9AR6dIMRsVhCGBaRyyvGHkGs39N6pYHdhPTCQUwp6hIOMAh9gp
        atd/Z1LKAUi4e
X-Received: by 2002:a05:620a:101b:: with SMTP id z27mr10352321qkj.241.1578597317800;
        Thu, 09 Jan 2020 11:15:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqzszZLHcswBKUPxJC/81Xc2K1fnZzg+wcmKZOwToW0HFoJA/kXPwo63fk5gwD+aZnZ8vjQ0tw==
X-Received: by 2002:a05:620a:101b:: with SMTP id z27mr10352263qkj.241.1578597317238;
        Thu, 09 Jan 2020 11:15:17 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id g81sm3536423qkb.70.2020.01.09.11.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 11:15:16 -0800 (PST)
Date:   Thu, 9 Jan 2020 14:15:14 -0500
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
Message-ID: <20200109191514.GD36997@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200109110110-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 11:29:28AM -0500, Michael S. Tsirkin wrote:
> On Thu, Jan 09, 2020 at 09:57:20AM -0500, Peter Xu wrote:
> > This patch is heavily based on previous work from Lei Cao
> > <lei.cao@stratus.com> and Paolo Bonzini <pbonzini@redhat.com>. [1]
> > 
> > KVM currently uses large bitmaps to track dirty memory.  These bitmaps
> > are copied to userspace when userspace queries KVM for its dirty page
> > information.  The use of bitmaps is mostly sufficient for live
> > migration, as large parts of memory are be dirtied from one log-dirty
> > pass to another.  However, in a checkpointing system, the number of
> > dirty pages is small and in fact it is often bounded---the VM is
> > paused when it has dirtied a pre-defined number of pages. Traversing a
> > large, sparsely populated bitmap to find set bits is time-consuming,
> > as is copying the bitmap to user-space.
> > 
> > A similar issue will be there for live migration when the guest memory
> > is huge while the page dirty procedure is trivial.  In that case for
> > each dirty sync we need to pull the whole dirty bitmap to userspace
> > and analyse every bit even if it's mostly zeros.
> > 
> > The preferred data structure for above scenarios is a dense list of
> > guest frame numbers (GFN).
> 
> No longer, this uses an array of structs.

(IMHO it's more or less a wording thing, because it's still an array
 of GFNs behind it...)

[...]

> > +Dirty GFNs (Guest Frame Numbers) are stored in the dirty_gfns array.
> > +For each of the dirty entry it's defined as:
> > +
> > +struct kvm_dirty_gfn {
> > +        __u32 pad;
> 
> How about sticking a length here?
> This way huge pages can be dirtied in one go.

As we've discussed previously, current KVM tracks dirty in 4K page
only, so it seems to be something that is not easily covered in this
series.

We probably need to justify on having KVM to track huge pages first,
or at least a trend that we're going to do that, then we can properly
reserve it here.

> 
> > +        __u32 slot; /* as_id | slot_id */
> > +        __u64 offset;
> > +};
> > +
> > +Most of the ring structure is used by KVM internally, while only the
> > +indices are exposed to userspace:
> > +
> > +struct kvm_dirty_ring_indices {
> > +	__u32 avail_index; /* set by kernel */
> > +	__u32 fetch_index; /* set by userspace */
> > +};
> > +
> > +The two indices in the ring buffer are free running counters.
> > +
> > +Userspace calls KVM_ENABLE_CAP ioctl right after KVM_CREATE_VM ioctl
> > +to enable this capability for the new guest and set the size of the
> > +rings.  It is only allowed before creating any vCPU, and the size of
> > +the ring must be a power of two.
> 
> 
> I know index design is popular, but testing with virtio showed
> that it's better to just have a flags field marking
> an entry as valid. In particular this gets rid of the
> running counters and power of two limitations.
> It also removes the need for a separate index page, which is nice.

Firstly, note that the separate index page has already been dropped
since V2, so we don't need to worry on that.

Regarding dropping the indices: I feel like it can be done, though we
probably need two extra bits for each GFN entry, for example:

  - Bit 0 of the GFN address to show whether this is a valid publish
    of dirty gfn

  - Bit 1 of the GFN address to show whether this is collected by the
    user

We can also use the padding field, but just want to show the idea
first.

Then for each GFN we can go through state changes like this (things
like "00b" stands for "bit1 bit0" values):

  00b (invalid GFN) ->
    01b (valid gfn published by kernel, which is dirty) ->
      10b (gfn dirty page collected by userspace) ->
        00b (gfn reset by kernel, so goes back to invalid gfn)

And we should always guarantee that both the userspace and KVM walks
the GFN array in a linear manner, for example, KVM must publish a new
GFN with bit 1 set right after the previous publish of GFN.  Vice
versa to the userspace when it collects the dirty GFN and mark bit 2.

Michael, do you mean something like this?

I think it should work logically, however IIUC it can expose more
security risks, say, dirty ring is different from virtio in that
userspace is not trusted, while for virtio, both sides (hypervisor,
and the guest driver) are trusted.  Above means we need to do these to
change to the new design:

  - Allow the GFN array to be mapped as writable by userspace (so that
    userspace can publish bit 2),

  - The userspace must be trusted to follow the design (just imagine
    what if the userspace overwrites a GFN when it publishes bit 2
    over a valid dirty gfn entry?  KVM could wrongly unprotect a page
    for the guest...).

While if we use the indices, we restrict the userspace to only be able
to write to one index only (which is the reset_index).  That's all it
can do to mess things up (and it could never as long as we properly
validate the reset_index when read, which only happens during
KVM_RESET_DIRTY_RINGS and is very rare).  From that pov, it seems the
indices solution still has its benefits.

> 
> 
> 
> >  The larger the ring buffer, the less
> > +likely the ring is full and the VM is forced to exit to userspace. The
> > +optimal size depends on the workload, but it is recommended that it be
> > +at least 64 KiB (4096 entries).
> 
> Where's this number coming from? Given you have indices as well,
> 4K size rings is likely to cause cache contention.

I think we've had some similar discussion in previous versions on the
size of ring.  Again imho it's really something that may not have a
direct clue as long as it's big enough (4K should be).

Regarding to the cache contention: could you explain more?  Do you
have a suggestion on the size of ring instead considering the issue?

[...]

> > +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> > +{
> > +	u32 cur_slot, next_slot;
> > +	u64 cur_offset, next_offset;
> > +	unsigned long mask;
> > +	u32 fetch;
> > +	int count = 0;
> > +	struct kvm_dirty_gfn *entry;
> > +	struct kvm_dirty_ring_indices *indices = ring->indices;
> > +	bool first_round = true;
> > +
> > +	fetch = READ_ONCE(indices->fetch_index);
> 
> So this does not work if the data cache is virtually tagged.
> Which to the best of my knowledge isn't the case on any
> CPU kvm supports. However it might not stay being the
> case forever. Worth at least commenting.

This is the read side.  IIUC even if with virtually tagged archs, we
should do the flushing on the write side rather than the read side,
and that should be enough?

Also, I believe this is the similar question that Jason has asked in
V2.  Sorry I should mention this earlier, but I didn't address that in
this series because if we need to do so we probably need to do it
kvm-wise, rather than only in this series.  I feel like it's missing
probably only because all existing KVM supported archs do not have
virtual-tagged caches as you mentioned.  If so, I would prefer if you
can allow me to ignore that issue until KVM starts to support such an
arch.

> 
> 
> > +
> > +	/*
> > +	 * Note that fetch_index is written by the userspace, which
> > +	 * should not be trusted.  If this happens, then it's probably
> > +	 * that the userspace has written a wrong fetch_index.
> > +	 */
> > +	if (fetch - ring->reset_index > ring->size)
> > +		return -EINVAL;
> > +
> > +	if (fetch == ring->reset_index)
> > +		return 0;
> > +
> > +	/* This is only needed to make compilers happy */
> > +	cur_slot = cur_offset = mask = 0;
> > +	while (ring->reset_index != fetch) {
> > +		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> > +		next_slot = READ_ONCE(entry->slot);
> > +		next_offset = READ_ONCE(entry->offset);
> 
> What is this READ_ONCE doing? Entries are only written by kernel
> and it's under lock.

The entries are written in kvm_dirty_ring_push() where there should
have no lock (there's one wmb() though to guarantee ordering of these
and the index update).

With the wmb(), the write side should guarantee to make it to memory.
For the read side here, I think it's still good to have it to make
sure we read from memory?

> 
> > +		ring->reset_index++;
> > +		count++;
> > +		/*
> > +		 * Try to coalesce the reset operations when the guest is
> > +		 * scanning pages in the same slot.
> > +		 */
> > +		if (!first_round && next_slot == cur_slot) {
> > +			s64 delta = next_offset - cur_offset;
> > +
> > +			if (delta >= 0 && delta < BITS_PER_LONG) {
> > +				mask |= 1ull << delta;
> > +				continue;
> > +			}
> > +
> > +			/* Backwards visit, careful about overflows!  */
> > +			if (delta > -BITS_PER_LONG && delta < 0 &&
> > +			    (mask << -delta >> -delta) == mask) {
> > +				cur_offset = next_offset;
> > +				mask = (mask << -delta) | 1;
> > +				continue;
> > +			}
> > +		}
> 
> Well how important is this logic? Because it will not be
> too effective on an SMP system, so don't you need a per-cpu ring?

It's my fault to have omit the high-level design in the cover letter,
but we do have per-vcpu ring now.  Actually that's what we only have
(we dropped the per-vm ring already) so ring access does not need lock
any more.

This logic is good because kvm_reset_dirty_gfn, especially inside that
there's kvm_arch_mmu_enable_log_dirty_pt_masked() that supports masks,
so it would be good to do the reset for continuous pages (or page
that's close enough) in a single shot.

> 
> 
> 
> > +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > +		cur_slot = next_slot;
> > +		cur_offset = next_offset;
> > +		mask = 1;
> > +		first_round = false;
> > +	}
> > +	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > +
> > +	trace_kvm_dirty_ring_reset(ring);
> > +
> > +	return count;
> > +}
> > +
> > +void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
> > +{
> > +	struct kvm_dirty_gfn *entry;
> > +	struct kvm_dirty_ring_indices *indices = ring->indices;
> > +
> > +	/* It should never get full */
> > +	WARN_ON_ONCE(kvm_dirty_ring_full(ring));
> > +
> > +	entry = &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];
> > +	entry->slot = slot;
> > +	entry->offset = offset;
> > +	/*
> > +	 * Make sure the data is filled in before we publish this to
> > +	 * the userspace program.  There's no paired kernel-side reader.
> > +	 */
> > +	smp_wmb();
> > +	ring->dirty_index++;
> 
> 
> Do I understand it correctly that the ring is shared between CPUs?
> If so I don't understand why it's safe for SMP guests.
> Don't you need atomics or locking?

No, it's per-vcpu.

Thanks,

-- 
Peter Xu

