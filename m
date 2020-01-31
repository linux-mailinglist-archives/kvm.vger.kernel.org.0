Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A505B14F377
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 21:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgAaUz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 15:55:56 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51704 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726102AbgAaUz4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 15:55:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580504155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ut6romTePPKAlxPx0bm/6CAtIIIuPyUqVjspVOVMDwY=;
        b=WnNmfhRhQCrsoaIb4PTxQ55LmY7ddzg1jEKxBy+RT05XfD398zgU3CI/jQcNTH7pCs0gjr
        weGYIjNs0saxYKyU12M1a8o9yH+P+WOgUttRg8cPvGI/IOe+d8MOxuCMiCjhq5tph4WWRH
        oj7RpAqPsZ9VlnmA6D8PbMAqQCPfkOM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-SWtUYQ7pOIiYq-4rj1cZSQ-1; Fri, 31 Jan 2020 15:55:53 -0500
X-MC-Unique: SWtUYQ7pOIiYq-4rj1cZSQ-1
Received: by mail-qk1-f197.google.com with SMTP id t195so4900539qke.23
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 12:55:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ut6romTePPKAlxPx0bm/6CAtIIIuPyUqVjspVOVMDwY=;
        b=qmtuJbsYak+n+pRwgWyL+BRuh7e/KJttRpPepU9ngcxfP41UmueIZVZmJDAWRZpCEH
         lZYqzClNI4Q693rK2CsLZjmg0KHpC8xqi9v9UAjii+HzlatDzSdXLrONuUqIQzuEnnl6
         3WRhXc50So051SfLG5ZuI6R6IZqsevhx9d67E6qFenfDZd2Dc5RvfKVzgg72pXdxTBjd
         lUTU0T97KOgkTTZYRKf/B9UKc1NZdnqtshLjgs5kV+svNCaVASvjENccwAZNb56nfwRr
         wxQt/4DMUX8J9+HsWQ9XP3C12T+uXheKw8YD3YwqnohA10PD/2E+LiU9oxamMLGJH4uE
         hWyg==
X-Gm-Message-State: APjAAAX8jyI1O+fN1pvvCtxZsYcTEcvqKK4dLfnaOqjEY5x+hINIh/qV
        uJkb1OU6BdRkidxs/sKw0oIo4xj+KTUCsANUIFLwRWjhvo6t97/pLquw8/scKJKaHBOx6eE5kOz
        AjxevYx+AUlmT
X-Received: by 2002:ac8:2afb:: with SMTP id c56mr13088641qta.112.1580504153160;
        Fri, 31 Jan 2020 12:55:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqyaA7bAFg1JFtB0SyHo7ynkFLIiM6zJ2BC1R4vbGlAt1l1DTroAhqPEKc24L2YMfsbwGA0UAw==
X-Received: by 2002:ac8:2afb:: with SMTP id c56mr13088615qta.112.1580504152755;
        Fri, 31 Jan 2020 12:55:52 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id b9sm5049656qkh.83.2020.01.31.12.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 12:55:52 -0800 (PST)
Date:   Fri, 31 Jan 2020 15:55:50 -0500
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
Message-ID: <20200131205550.GB7063@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-10-peterx@redhat.com>
 <20200121155657.GA7923@linux.intel.com>
 <20200128055005.GB662081@xz-x1>
 <20200128182402.GA18652@linux.intel.com>
 <20200131150832.GA740148@xz-x1>
 <20200131193301.GC18946@linux.intel.com>
 <20200131202824.GA7063@xz-x1>
 <20200131203622.GF18946@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200131203622.GF18946@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 31, 2020 at 12:36:22PM -0800, Sean Christopherson wrote:
> On Fri, Jan 31, 2020 at 03:28:24PM -0500, Peter Xu wrote:
> > On Fri, Jan 31, 2020 at 11:33:01AM -0800, Sean Christopherson wrote:
> > > For the same reason we don't take mmap_sem, it gains us nothing, i.e. KVM
> > > still has to use copy_{to,from}_user().
> > > 
> > > In the proposed __x86_set_memory_region() refactor, vmx_set_tss_addr()
> > > would be provided the hva of the memory region.  Since slots_lock and SRCU
> > > only protect gfn->hva, why would KVM take slots_lock since it already has
> > > the hva?
> > 
> > OK so you're suggesting to unlock the lock earlier to not cover
> > init_rmode_tss() rather than dropping the whole lock...  Yes it looks
> > good to me.  I think that's the major confusion I got.
> 
> Ya.  And I missed where the -EEXIST was coming from.  I think we're on the
> same page.

Good to know.  Btw, for me I would still prefer to keep the lock be
after the __copy_to_user()s because "HVA is valid without lock" is
only true for these private memslots.  After all this is super slow
path so I wouldn't mind to take the lock for some time longer.  Or
otherwise if you really like the unlock() to be earlier I can comment
above the unlock:

  /*
   * We can unlock before using the HVA only because this KVM private
   * memory slot will never change until the end of VM lifecycle.
   */

> 
> > > Returning -EEXIST is an ABI change, e.g. userspace can currently call
> > > KVM_SET_TSS_ADDR any number of times, it just needs to ensure proper
> > > serialization between calls.
> > > 
> > > If you want to change the ABI, then submit a patch to do exactly that.
> > > But don't bury an ABI change under the pretense that it's a bug fix.
> > 
> > Could you explain what do you mean by "ABI change"?
> > 
> > I was talking about the original code, not after applying the
> > patchset.  To be explicit, I mean [a] below:
> > 
> > int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size,
> > 			    unsigned long *uaddr)
> > {
> > 	int i, r;
> > 	unsigned long hva;
> > 	struct kvm_memslots *slots = kvm_memslots(kvm);
> > 	struct kvm_memory_slot *slot, old;
> > 
> > 	/* Called with kvm->slots_lock held.  */
> > 	if (WARN_ON(id >= KVM_MEM_SLOTS_NUM))
> > 		return -EINVAL;
> > 
> > 	slot = id_to_memslot(slots, id);
> > 	if (size) {
> > 		if (slot->npages)
> > 			return -EEXIST;  <------------------------ [a]
> >         }
> >         ...
> > }
> 
> Doh, I completely forgot that the second __x86_set_memory_region() would
> fail.  Sorry :-(
> 
> > > > Yes, but as I mentioned, I don't think it's an issue to be considered
> > > > by KVM, otherwise we should have the same issue all over the places
> > > > when we fetch the cached userspace_addr from any user slots.
> > > 
> > > Huh?  Of course it's an issue that needs to be considered by KVM, e.g.
> > > kvm_{read,write}_guest_cached() aren't using __copy_{to,}from_user() for
> > > giggles.
> > 
> > The cache is for the GPA->HVA translation (struct gfn_to_hva_cache),
> > we still use __copy_{to,}from_user() upon the HVAs, no?
> 
> I'm still lost on this one.  I'm pretty sure I'm incorrectly interpreting:
>   
>   I don't think it's an issue to be considered by KVM, otherwise we should
>   have the same issue all over the places when we fetch the cached
>   userspace_addr from any user slots.
> 
> What is the issue to which you are referring?

The issue I was referring to is "HVA can be unmapped by the userspace
without KVM's notice".  I think actually we're on the same page too
here, my follow-up question is really a pure question for when you say
"kvm_{read,write}_guest_cached() aren't using __copy_{to,}from_user()"
above - because that's against my understanding.

-- 
Peter Xu

