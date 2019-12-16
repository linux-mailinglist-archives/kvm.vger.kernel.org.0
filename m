Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEC612016F
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 10:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfLPJrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 04:47:52 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32406 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727086AbfLPJrv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 04:47:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576489669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x4F0S6F+puErRf/9qNGD3qSr4YnaGP1lnAVzdVRgZvU=;
        b=Jy+o8ZQuRmQ8vKzrcpvwvJd+xs2mCiWaZEeCTCpdvwaiD07b7Z+7zIbztGLvwlsiZkINJU
        6amBgNC/CprrQI6ymKmHkChmBgmIyhbCRkVuseeEtlo3YIN/2DtO6hQRVnE9eroUs7AYD9
        68j/U64C8mFRoWxP8ZY83xvAjwr+rco=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-_9ZehERyOFypDcgpSOsFPA-1; Mon, 16 Dec 2019 04:47:43 -0500
X-MC-Unique: _9ZehERyOFypDcgpSOsFPA-1
Received: by mail-qv1-f71.google.com with SMTP id w13so4966178qvb.4
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 01:47:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x4F0S6F+puErRf/9qNGD3qSr4YnaGP1lnAVzdVRgZvU=;
        b=OJoLNZXJxLtYUSwYq++02itPGhRX+6IQJpMxzV0qDfCztCZL7Rr/zpTH9gTBmG2gui
         zSSCtaWY6a3gCsErvYvICnAcaUr9zUAa4LZdhL7MrWR83bNKJ3NflAHrHtlo1pAGRjdf
         VtON0/1vxYCMzKWRggJJn38nwQoLDkqfiYLP2Kcfw0ZcsmFRFmFhH7PUmEfZx/0sDNmS
         B5KZjAwDMecEuZZTfGPijjy8bLUyH9Wje+WI8E4Ztkgjop4zBNO/qGx7JtSKmMsWC+Z4
         pTb8aFf/iRi31addZgZB6vtEpJk48A/UofqH4A1+8mM8FTBpNDQiP6ZVQmuPtaMbEA1J
         ByOA==
X-Gm-Message-State: APjAAAUWFevl1QPTiE1TA5pxbvMkh7yRkO5rIM3yUXCsDoAZYMqnIV2+
        y6Cq9lr84hodM494fG1cpivsrOdhET3U+631LuuRw4cep7j8u+udtyzZtDNw7K7iuxrWmZX1mwY
        x8C/1KZaoLqoy
X-Received: by 2002:aed:256f:: with SMTP id w44mr7069752qtc.331.1576489663040;
        Mon, 16 Dec 2019 01:47:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqxIZNYdabqmI0CG0aOJ0NQEhESVmckgU7vVqS63tN6mOzzA5VFGb+hnjE+Zgtxy3Azad9N/Jw==
X-Received: by 2002:aed:256f:: with SMTP id w44mr7069748qtc.331.1576489662780;
        Mon, 16 Dec 2019 01:47:42 -0800 (PST)
Received: from redhat.com (bzq-111-168-31-5.red.bezeqint.net. [31.168.111.5])
        by smtp.gmail.com with ESMTPSA id r10sm5762779qkm.23.2019.12.16.01.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:47:41 -0800 (PST)
Date:   Mon, 16 Dec 2019 04:47:36 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191216044619-mutt-send-email-mst@kernel.org>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191211063830-mutt-send-email-mst@kernel.org>
 <20191211205952.GA5091@xz-x1>
 <20191211172713-mutt-send-email-mst@kernel.org>
 <46ceb88c-0ddd-0d9a-7128-3aa5a7d9d233@redhat.com>
 <20191215173302.GB83861@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191215173302.GB83861@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 15, 2019 at 12:33:02PM -0500, Peter Xu wrote:
> On Thu, Dec 12, 2019 at 01:08:14AM +0100, Paolo Bonzini wrote:
> > >>> What depends on what here? Looks suspicious ...
> > >>
> > >> Hmm, I think maybe it can be removed because the entry pointer
> > >> reference below should be an ordering constraint already?
> > 
> > entry->xxx depends on ring->reset_index.
> 
> Yes that's true, but...
> 
>         entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
>         /* barrier? */
>         next_slot = READ_ONCE(entry->slot);
>         next_offset = READ_ONCE(entry->offset);
> 
> ... I think entry->xxx depends on entry first, then entry depends on
> reset_index.  So it seems fine because all things have a dependency?

Is reset_index changed from another thread then?
If yes then you want to read reset_index with READ_ONCE.
That includes a dependency barrier.

> > 
> > >>> what's the story around locking here? Why is it safe
> > >>> not to take the lock sometimes?
> > >>
> > >> kvm_dirty_ring_push() will be with lock==true only when the per-vm
> > >> ring is used.  For per-vcpu ring, because that will only happen with
> > >> the vcpu context, then we don't need locks (so kvm_dirty_ring_push()
> > >> is called with lock==false).
> > 
> > FWIW this will be done much more nicely in v2.
> > 
> > >>>> +	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> > >>>> +	if (!page) {
> > >>>> +		r = -ENOMEM;
> > >>>> +		goto out_err_alloc_page;
> > >>>> +	}
> > >>>> +	kvm->vm_run = page_address(page);
> > >>>
> > >>> So 4K with just 8 bytes used. Not as bad as 1/2Mbyte for the ring but
> > >>> still. What is wrong with just a pointer and calling put_user?
> > >>
> > >> I want to make it the start point for sharing fields between
> > >> user/kernel per-vm.  Just like kvm_run for per-vcpu.
> > 
> > This page is actually not needed at all.  Userspace can just map at
> > KVM_DIRTY_LOG_PAGE_OFFSET, the indices reside there.  You can drop
> > kvm_vm_run completely.
> 
> I changed it because otherwise we use one entry of the padding, and
> all the rest of paddings are a waste of memory because we can never
> really use the padding as new fields only for the 1st entry which
> overlaps with the indices.  IMHO that could even waste more than 4k.
> 
> (for now we only "waste" 4K for per-vm, kvm_run is already mapped so
>  no waste there, not to say potentially I still think we can use the
>  kvm_vm_run in the future)
> 
> > 
> > >>>> +	} else {
> > >>>> +		/*
> > >>>> +		 * Put onto per vm ring because no vcpu context.  Kick
> > >>>> +		 * vcpu0 if ring is full.
> > >>>
> > >>> What about tasks on vcpu 0? Do guests realize it's a bad idea to put
> > >>> critical tasks there, they will be penalized disproportionally?
> > >>
> > >> Reasonable question.  So far we can't avoid it because vcpu exit is
> > >> the event mechanism to say "hey please collect dirty bits".  Maybe
> > >> someway is better than this, but I'll need to rethink all these
> > >> over...
> > > 
> > > Maybe signal an eventfd, and let userspace worry about deciding what to
> > > do.
> > 
> > This has to be done synchronously.  But the vm ring should be used very
> > rarely (it's for things like kvmclock updates that write to guest memory
> > outside a vCPU), possibly a handful of times in the whole run of the VM.
> 
> I've summarized a list of callers who might dirty guest memory in the
> other thread, it seems to me that even the kvm clock is using per-vcpu
> contexts.
> 
> > 
> > >>> KVM_DIRTY_RING_MAX_ENTRIES is not part of UAPI.
> > >>> So how does userspace know what's legal?
> > >>> Do you expect it to just try?
> > >>
> > >> Yep that's what I thought. :)
> > 
> > We should return it for KVM_CHECK_EXTENSION.
> 
> OK.  I'll drop the versioning.
> 
> -- 
> Peter Xu

