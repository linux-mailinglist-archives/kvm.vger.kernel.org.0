Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1A81B796F
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 17:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgDXPWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 11:22:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33093 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727123AbgDXPWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 11:22:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587741718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wx6UqBc+7Fd78ffDznq1MJq+WQRq4yvKOdpl3Ke1Tvs=;
        b=E0EghZKROQh5KCE6hRSf2LgnMegdOzx9wPDGtzNV47CcY5WhejLYrI8o1RjyG0VYI4y2co
        B65xX8rGwcgg0GxYp0ONEXn7kcCUKhdS4DHk6g1UXJyEEWNOGMjFyTfEqksr/oJ5vve4Es
        8JSkmW30Oc9OOaW3GpyqGjNZ/lFTF3w=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-0hLPEJFUNWSQhVT4JClcFg-1; Fri, 24 Apr 2020 11:21:54 -0400
X-MC-Unique: 0hLPEJFUNWSQhVT4JClcFg-1
Received: by mail-qv1-f71.google.com with SMTP id et5so10106440qvb.5
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 08:21:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wx6UqBc+7Fd78ffDznq1MJq+WQRq4yvKOdpl3Ke1Tvs=;
        b=HGsb8s90baT/PF4WbB1Fr3butsdNoMYiflRSWHC7OjeKcw1AHtiDrfQ+vN5NbwNTRW
         3Ty6Xqyl3+gG7rx19Ir7YbTnE3VAv3hMEVFVBC+jUjJCNI2MuT5SsTwuuO18O5q63yYp
         IOm5xEogi9yPC6SFCPKCeDyA0qHa6Ojrq8bFwQZyHPbMmNCQw7p0B0593xDxLXId99kU
         kxBIPMdwlc6cR4ZQ4IsYPgfOaTRfd16Y0nZXXS0fAqUVFijg4TNoTA/nJASJELBou6x9
         AZRwkmueBbs6eWY6FSE2VCE8DsVT9p4weiPlFzVNtRBUna/J9nbiFCY2e0vX+pUB7KLF
         dGNg==
X-Gm-Message-State: AGi0PuZhkDuSqV6/0j9Yusds4Anok+4FlOlJGo4fGNqH7+K6VmQOP/G0
        6MeEVJPJzdGQvEYLw8TlfmfZc4jZ9PxdXiQFbSbxu+vrhnZpk6UZ6rAENTu7Bsy5WQrA+bQ7uWd
        KtKHUuD1tgNlj
X-Received: by 2002:a05:620a:22d6:: with SMTP id o22mr9336375qki.49.1587741714150;
        Fri, 24 Apr 2020 08:21:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypLQIQ4cCKKttCJu6UxYlK8vabyjhMsxG7WZoaBoQk27nV3zGbwoIRKSjA+BIEmG5/Gh77Y+cg==
X-Received: by 2002:a05:620a:22d6:: with SMTP id o22mr9336338qki.49.1587741713790;
        Fri, 24 Apr 2020 08:21:53 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 195sm3758661qkd.6.2020.04.24.08.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 08:21:52 -0700 (PDT)
Date:   Fri, 24 Apr 2020 11:21:51 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v8 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200424152151.GB41816@xz-x1>
References: <20200331190000.659614-1-peterx@redhat.com>
 <20200331190000.659614-4-peterx@redhat.com>
 <20200423203944.GS17824@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200423203944.GS17824@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 01:39:44PM -0700, Sean Christopherson wrote:
> On Tue, Mar 31, 2020 at 02:59:49PM -0400, Peter Xu wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 1b6d9ac9533c..faa702c4d37b 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9791,7 +9791,32 @@ void kvm_arch_sync_events(struct kvm *kvm)
> >  	kvm_free_pit(kvm);
> >  }
> >  
> > -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > +#define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))
> 
> Heh, my first thought when reading the below code was "cool, I didn't know
> there was ERR_PTR_USR!".  This probably should be in include/linux/err.h,
> or maybe a new arch specific implementation if it's not universally safe.

Yeah, I just wanted to avoid introducing things in common headers before I'm
sure it'll be used in the rest of the world..  We can always replace them with
a global definition when it comes.

> 
> An alternative, which looks enticing given that proper user variants will
> be a bit of an explosion, would be to do:
> 
>   static void *____x86_set_memory_region(...)
>   {
> 	<actual function>
>   }
> 
>   void __user *__x86_set_memory_region(...)
>   {
> 	return (void __user *)____x86_set_memory_region(...);
>   }
> 
> A second alternative would be to return an "unsigned long", i.e. force the
> one function that actually accesses the hva to do the cast.  I think I like
> this option the best as it would minimize the churn in
> __x86_set_memory_region().  Callers can use IS_ERR_VALUE() to detect failure.

If you won't mind, I would prefer a 2nd opinion (maybe Paolo?) so we can
consolidate the idea before I change them... (I would for sure still prefer the
current approach for simplicity since after all I don't have strong opionion..)

> 
> > +/**
> > + * __x86_set_memory_region: Setup KVM internal memory slot
> > + *
> > + * @kvm: the kvm pointer to the VM.
> > + * @id: the slot ID to setup.
> > + * @gpa: the GPA to install the slot (unused when @size == 0).
> > + * @size: the size of the slot. Set to zero to uninstall a slot.
> > + *
> > + * This function helps to setup a KVM internal memory slot.  Specify
> > + * @size > 0 to install a new slot, while @size == 0 to uninstall a
> > + * slot.  The return code can be one of the following:
> > + *
> > + *   HVA:           on success (uninstall will return a bogus HVA)
> 
> I think it's important to call out that it returns '0' on uninstall, e.g.
> otherwise it's not clear how a caller can detect failure.

It will "return (0xdeadull << 48)" as you proposed in abbed4fa94f6? :-)

Frankly speaking I always preferred zero but that's just not true any more
after above change.  This also reminded me that maybe we should also return the
same thing at [1] below.

> 
> > + *   -errno:        on error
> > + *
> > + * The caller should always use IS_ERR() to check the return value
> > + * before use.  Note, the KVM internal memory slots are guaranteed to
> > + * remain valid and unchanged until the VM is destroyed, i.e., the
> > + * GPA->HVA translation will not change.  However, the HVA is a user
> > + * address, i.e. its accessibility is not guaranteed, and must be
> > + * accessed via __copy_{to,from}_user().
> > + */
> > +void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
> > +				      u32 size)
> >  {
> >  	int i, r;
> >  	unsigned long hva, uninitialized_var(old_npages);
> > @@ -9800,12 +9825,12 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> >  
> >  	/* Called with kvm->slots_lock held.  */
> >  	if (WARN_ON(id >= KVM_MEM_SLOTS_NUM))
> > -		return -EINVAL;
> > +		return ERR_PTR_USR(-EINVAL);
> >  
> >  	slot = id_to_memslot(slots, id);
> >  	if (size) {
> >  		if (slot && slot->npages)
> > -			return -EEXIST;
> > +			return ERR_PTR_USR(-EEXIST);
> >  
> >  		/*
> >  		 * MAP_SHARED to prevent internal slot pages from being moved
> > @@ -9814,10 +9839,10 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> >  		hva = vm_mmap(NULL, 0, size, PROT_READ | PROT_WRITE,
> >  			      MAP_SHARED | MAP_ANONYMOUS, 0);
> >  		if (IS_ERR((void *)hva))
> 
> IS_ERR_VALUE() can be used to avoid the double cast.

Agreed.  But it's a context cleanup, so I normally will keep it as is (or use a
standalone patch).

> 
> > -			return PTR_ERR((void *)hva);
> > +			return (void __user *)hva;
> 
> If we still want to go down the route of ERR_PTR_USR, then an ERR_CAST_USR
> seems in order.

Sure.  But I'll still keep it kvm-only if you won't mind...

> 
> >  	} else {
> >  		if (!slot || !slot->npages)
> > -			return 0;
> > +			return ERR_PTR_USR(0);

[1]

> 
> "return ERR_PTR_USR(NULL)" or "return NULL" would be more intuitive.  Moot
> point if the return is changed to "unsigned long".

ERR_PTR_USR() takes a "long".  I can use ERR_CAST_USR(NULL) if you prefer me to
explicitly use NULL.

Thanks,

-- 
Peter Xu

