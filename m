Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E85A114F461
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 23:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgAaWQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 17:16:43 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31548 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726163AbgAaWQn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 17:16:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580509002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vNWAMFUjo2BxvgCqYLA09WvnKRsNZUCV/NyH0B71vPw=;
        b=cJToakrMoYYh4Y/qTnKLvU1c70LxnQWG9aaDAVeIOctQReXHaXPKpVCdauUkNVGEchL8Yg
        AR9NDF0PsfX/yhCgiHtD9jnm4NJjOIXv99pcKDAMDo/FeBsq5ViRjJNxFNWpcEvW9DWsLQ
        mzZkv2oNf+j0Zu7zIKMqDfQhofx2/Ls=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-JeZMIDMqNeOEUiOplAmXHA-1; Fri, 31 Jan 2020 17:16:40 -0500
X-MC-Unique: JeZMIDMqNeOEUiOplAmXHA-1
Received: by mail-qk1-f197.google.com with SMTP id p3so5118430qkd.11
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 14:16:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vNWAMFUjo2BxvgCqYLA09WvnKRsNZUCV/NyH0B71vPw=;
        b=Ndn9+nUmeDKRi8ALqv9AyadmPyK69cEPDgmZvJEj53cyvQ9xBgz9+h0g38yxGpWU7D
         vtXP89KfyQVWcTFixAuDRQGbtrP+v5svVDQCJrWFbAHrfyM5Dnf5qgFa/HBqfMIdx/r7
         YvtASDGa6vamqT6/a3UCYMnF065rDtf4fjAhdZniwLK4WAT6Zjmpq89mb7xBWSXgwJEb
         B0Wr8wqeGL5OqSHTbMyRvo+A/9xVcukDShWW3HiigNs+ZPn5aB03CMkoqDE81WRSlYQJ
         VQXfKRaRG8c4YY2twgmQSObJTgvwiyJUk89O34epzFrTDXCGBCiLUs3sUrduP39Il2Yb
         BGFg==
X-Gm-Message-State: APjAAAW8pG6/2qsMZTyQtMJhW0xFY9ECgeABc6ufnbA4Y6o84fH/NKsT
        37jjjVVsYLV9pTCNA/ogWtqq++f8fwzV/+TRj6fEtDVWk/tHVNpKZx6iCIHqaUKfXND0zvofVeQ
        G+y6y2b7Riw4U
X-Received: by 2002:a05:620a:9d9:: with SMTP id y25mr12995295qky.41.1580508999713;
        Fri, 31 Jan 2020 14:16:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqyFBEIl/LpAFBCeYudTZUb4k/rDVnIohho0H6H5nDgOCPBmQQeP0I4pvYuc2vcz1diZHlcEEw==
X-Received: by 2002:a05:620a:9d9:: with SMTP id y25mr12995274qky.41.1580508999416;
        Fri, 31 Jan 2020 14:16:39 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id u24sm5247491qkm.40.2020.01.31.14.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 14:16:38 -0800 (PST)
Date:   Fri, 31 Jan 2020 17:16:37 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v3 09/21] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200131221637.GC7063@xz-x1>
References: <20200109145729.32898-10-peterx@redhat.com>
 <20200121155657.GA7923@linux.intel.com>
 <20200128055005.GB662081@xz-x1>
 <20200128182402.GA18652@linux.intel.com>
 <20200131150832.GA740148@xz-x1>
 <20200131193301.GC18946@linux.intel.com>
 <20200131202824.GA7063@xz-x1>
 <20200131203622.GF18946@linux.intel.com>
 <20200131205550.GB7063@xz-x1>
 <20200131212928.GH18946@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200131212928.GH18946@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 31, 2020 at 01:29:28PM -0800, Sean Christopherson wrote:
> On Fri, Jan 31, 2020 at 03:55:50PM -0500, Peter Xu wrote:
> > On Fri, Jan 31, 2020 at 12:36:22PM -0800, Sean Christopherson wrote:
> > > On Fri, Jan 31, 2020 at 03:28:24PM -0500, Peter Xu wrote:
> > > > On Fri, Jan 31, 2020 at 11:33:01AM -0800, Sean Christopherson wrote:
> > > > > For the same reason we don't take mmap_sem, it gains us nothing, i.e. KVM
> > > > > still has to use copy_{to,from}_user().
> > > > > 
> > > > > In the proposed __x86_set_memory_region() refactor, vmx_set_tss_addr()
> > > > > would be provided the hva of the memory region.  Since slots_lock and SRCU
> > > > > only protect gfn->hva, why would KVM take slots_lock since it already has
> > > > > the hva?
> > > > 
> > > > OK so you're suggesting to unlock the lock earlier to not cover
> > > > init_rmode_tss() rather than dropping the whole lock...  Yes it looks
> > > > good to me.  I think that's the major confusion I got.
> > > 
> > > Ya.  And I missed where the -EEXIST was coming from.  I think we're on the
> > > same page.
> > 
> > Good to know.  Btw, for me I would still prefer to keep the lock be
> > after the __copy_to_user()s because "HVA is valid without lock" is
> > only true for these private memslots.
> 
> No.  From KVM's perspective, the HVA is *never* valid.  Even if you rewrote
> this statement to say "the gfn->hva translation is valid without lock" it
> would still be incorrect. 
> 
> KVM is *always* using HVAs without holding lock, e.g. every time it enters
> the guest it is deferencing a memslot because the translations stored in
> the TLB are effectively gfn->hva->hpa.  Obviously KVM ensures that it won't
> dereference a memslot that has been deleted/moved, but it's a lot more
> subtle than simply holding a lock.
> 
> > After all this is super slow path so I wouldn't mind to take the lock
> > for some time longer.
> 
> Holding the lock doesn't affect this super slow vmx_set_tss_addr(), it
> affects everything else that wants slots_lock.  Now, admittedly it's
> extremely unlikely userspace is going to do KVM_SET_USER_MEMORY_REGION in
> parallel, but that's not the point and it's not why I'm objecting to
> holding the lock.
> 
> Holding the lock implies protection that is *not* provided.  You and I know
> it's not needed for copy_{to,from}_user(), but look how long it's taken us
> to get on the same page.  A future KVM developer comes along, sees this
> code, and thinks "oh, I need to hold slots_lock to dereference a gfn", and
> propagates the unnecessary locking to some other code.

At least for a user memory slot, we "need to hold slots_lock to
dereference a gfn" (or srcu), right?

You know I'm suffering from a jetlag today, I thought I was still
fine, now I start to doubt it. :-)

> 
> > Or otherwise if you really like the unlock() to
> > be earlier I can comment above the unlock:
> > 
> >   /*
> >    * We can unlock before using the HVA only because this KVM private
> >    * memory slot will never change until the end of VM lifecycle.
> >    */
> 
> How about:
> 
> 	/*
> 	 * No need to hold slots_lock while filling the TSS, the TSS private
> 	 * memslot is guaranteed to be valid until the VM is destroyed, i.e.
> 	 * there is no danger of corrupting guest memory by consuming a stale
> 	 * gfn->hva lookup.
> 	 */

Sure for this.

-- 
Peter Xu

