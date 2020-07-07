Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF54C217845
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 21:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgGGTuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 15:50:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54827 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726951AbgGGTuS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 15:50:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594151417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1MyiecDX95vYDn16o1AnLNPElpX9iu/bMS7QGJmoJuA=;
        b=DSuqXa//OJtUIyVY2waQOoPCylRNyNjLfHzTrx1VG//TpiVK1sC+2iKgeGaywy5JEWqyGh
        zPx0eo4y3bOZomU8m7lG1vEH++7bI/oTGau7d0lMfP7hOfKGuUK2ysxADrf4xuZtBV7IKW
        4mnoARbhc/EuI8yEczJZK7WdWMPUAkA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-OXiK38TVOqWzzeP9kXK8Og-1; Tue, 07 Jul 2020 15:50:12 -0400
X-MC-Unique: OXiK38TVOqWzzeP9kXK8Og-1
Received: by mail-qt1-f198.google.com with SMTP id e6so30546688qtb.19
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 12:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1MyiecDX95vYDn16o1AnLNPElpX9iu/bMS7QGJmoJuA=;
        b=Qi4u+u6tUpHFUZj4ykh5ckTanNrcp7Nx3L190LfOsdAm71Cc90n9GfbOahDrWyDVCD
         RSpAun6SWzOV7c7eFyIrmSVtx/pnWRS2MTqcQWwBkia/oVDTU+xjbJf6jtAYnX3WE5QM
         3nZ0YhuNH+MWOauyU3U3WXvoi8F7I5cZn0KrGOaK75imp1PEPKXSxzeiZNlg2m7Vu3OI
         DSZ90ntoEk+czW5ELfKeiNnC9Tsy4gVYWpdYc2C96GNmH+WfnFAy3zsul811gSA7h+Ls
         rqreOyRcW0LWzva/vZZqbWZ4FdITBTtYCXvS8MTpb7I13V7p6SV/9+/q+Jei4NGk0vIU
         7hlg==
X-Gm-Message-State: AOAM532M+mrWDX6YZkQClctwdgDuyqhbCgmkAjz+WIgvBF2DMt9jvZ+k
        2mAMIJkYt/dH51ikGb/bq/qG8b3KdRbOopzLaInoUHYhhssjFHSrjWGgQHZAH8853huYk4tDIjg
        OCb+BOG2vZHgW
X-Received: by 2002:aed:2fa1:: with SMTP id m30mr41633875qtd.306.1594151412045;
        Tue, 07 Jul 2020 12:50:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQG9gFW6u6nd+w3S2m/MpDzbGYxLTlBzGT3OREctmj26wBZlUi6rIGQkS/PR/KM97vnhychQ==
X-Received: by 2002:aed:2fa1:: with SMTP id m30mr41633836qtd.306.1594151411697;
        Tue, 07 Jul 2020 12:50:11 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id o20sm28889533qtk.56.2020.07.07.12.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 12:50:10 -0700 (PDT)
Date:   Tue, 7 Jul 2020 15:50:09 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v10 02/14] KVM: Cache as_id in kvm_memory_slot
Message-ID: <20200707195009.GE88106@xz-x1>
References: <20200601115957.1581250-1-peterx@redhat.com>
 <20200601115957.1581250-3-peterx@redhat.com>
 <20200702230849.GL3575@linux.intel.com>
 <20200703184122.GF6677@xz-x1>
 <20200707061732.GI5208@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200707061732.GI5208@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 06, 2020 at 11:17:32PM -0700, Sean Christopherson wrote:
> On Fri, Jul 03, 2020 at 02:41:22PM -0400, Peter Xu wrote:
> > On Thu, Jul 02, 2020 at 04:08:49PM -0700, Sean Christopherson wrote:
> > > On Mon, Jun 01, 2020 at 07:59:45AM -0400, Peter Xu wrote:
> > > > Cache the address space ID just like the slot ID.  It will be used in
> > > > order to fill in the dirty ring entries.
> > > > 
> > > > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > Signed-off-by: Peter Xu <peterx@redhat.com>
> > > > ---
> > > >  include/linux/kvm_host.h | 1 +
> > > >  virt/kvm/kvm_main.c      | 1 +
> > > >  2 files changed, 2 insertions(+)
> > > > 
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index 01276e3d01b9..5e7bbaf7a36b 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -346,6 +346,7 @@ struct kvm_memory_slot {
> > > >  	unsigned long userspace_addr;
> > > >  	u32 flags;
> > > >  	short id;
> > > > +	u16 as_id;
> > > >  };
> > > >  
> > > >  static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index 74bdb7bf3295..ebdd98a30e82 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -1243,6 +1243,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > > >  	if (!mem->memory_size)
> > > >  		return kvm_delete_memslot(kvm, mem, &old, as_id);
> > > 
> > > This technically needs to set as_id in the deleted memslot.  I highly doubt
> > > it will ever matter from a functionality perspective, but it'd be confusing
> > > to encounter a memslot whose as_id did not match that of its owner.
> > 
> > Yeah it shouldn't matter because as_id is directly passed in to look up the
> > pointer of kvm_memslots in kvm_delete_memslot, and memslot->as_id shouldn't be
> > further referenced.
> > 
> > I can add a comment above if this can clarify things a bit:
> > 
> > +	u16 as_id; /* cache of as_id; only valid if npages != 0 */
> 
> Why not just set it?

Because the value is useless even if set? :)

You mean in kvm_delete_memslot(), am I right?  

> It's a single line of code, and there's more than one
> "shouldn't" in the above.

If you want, I can both set it and add the comment.  Thanks,

-- 
Peter Xu

