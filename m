Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AC4213FC2
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 21:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgGCTC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 15:02:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51832 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726258AbgGCTC5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 15:02:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593802974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=twCkwjE0ryMOZi8fpz1SnT5K9pmvk7PL5PT5FftWV/0=;
        b=CtJaKG5dMWZsU7SZn5EBApnMn7s58x70BSjZmecY+b+EZugUyF6s8rc4mlSwvDmUGKtcBW
        YpIeyA3Q9VK2lEG3yj3fuqNEjVi/PoXqVNPapMETi/p9ZGxZBBNzc5XQm530kwZIpEAOT0
        CMvc0vk5EdxNPRbyCcvdNHMJ3UvQ6Bo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-iYSb60_oPbKd8WHG_DGlQg-1; Fri, 03 Jul 2020 15:02:51 -0400
X-MC-Unique: iYSb60_oPbKd8WHG_DGlQg-1
Received: by mail-qk1-f198.google.com with SMTP id 13so10346378qkk.10
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 12:02:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=twCkwjE0ryMOZi8fpz1SnT5K9pmvk7PL5PT5FftWV/0=;
        b=jujQJT6xlpxQ/YFjsimXnjRzc2tme50yLEKIICZP0uP2u9DBNljGaDgMGGEhdyfK4t
         +G8SRupFg3BatondBFQBjQvS9mtsX1QpxPGa0ywSm9sQS4lsikzTTnKXX/ltCA2Ss9A6
         x80fKtfRvLEYd+pZMcO786pgm7Fb+6CEaHE8SgYtTAhPYeApOXjvyCQXrZeYJxcPuoJO
         aTXER0VXylbCWKiMYLirWmr3vPjZMONCcyVlwf7oqkQFWUB3XDV8UK+F1gvnYYxjkhUk
         +aopmJi8RbfG5Qjdl0qcMhCNDG3dyZ/B9j0RcHOtICZkYR9hM7r9kx6JzC/bpy191R5x
         y+rQ==
X-Gm-Message-State: AOAM5327NHKB1XNo+6zQp2T/Ws1G6+RWxdMeDkMU1l7UH+MAS7XRlwcU
        JVfxCsZM8+1gHfddlMrmFiR3906s37AF397iRFK/kNBOah+E3XT0D+sSlR8jjwx40XHljWlPsi9
        FKQNExrUZxU1o
X-Received: by 2002:a05:6214:1882:: with SMTP id cx2mr37285511qvb.240.1593802970305;
        Fri, 03 Jul 2020 12:02:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9utD0D8BS338JK3zldVLP/DumaDiDAvSmzpYFOet+EDIzmo1/XzuAyJnljqPxWQ2+i8nViA==
X-Received: by 2002:a05:6214:1882:: with SMTP id cx2mr37285481qvb.240.1593802970018;
        Fri, 03 Jul 2020 12:02:50 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id t65sm8946800qkf.119.2020.07.03.12.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 12:02:49 -0700 (PDT)
Date:   Fri, 3 Jul 2020 15:02:47 -0400
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
Subject: Re: [PATCH v10 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200703190247.GG6677@xz-x1>
References: <20200601115957.1581250-1-peterx@redhat.com>
 <20200601115957.1581250-4-peterx@redhat.com>
 <20200703000557.GM3575@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200703000557.GM3575@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 02, 2020 at 05:05:57PM -0700, Sean Christopherson wrote:
> >  	/* Set up identity-mapping pagetable for EPT in real mode */
> >  	for (i = 0; i < PT32_ENT_PER_PAGE; i++) {
> >  		tmp = (i << 22) + (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |
> >  			_PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_PSE);
> > -		r = kvm_write_guest_page(kvm, identity_map_pfn,
> > -				&tmp, i * sizeof(tmp), sizeof(tmp));
> > -		if (r < 0)
> > +		r = __copy_to_user(uaddr + i * sizeof(tmp), &tmp, sizeof(tmp));
> > +		if (r) {
> > +			r = -EFAULT;
> 
> Another case where capturing the result is unnecessary.  I don't have a
> preference as to whether the result of __copy_{to,from}_user() is returned
> directly or morphed to -EFAULT, but we should be consistent, especially
> within a single patch.

OK, I'll clean all these __copy_to_user() callers in the next version.

> 
> >  			goto out;
> > +		}
> >  	}
> >  	kvm_vmx->ept_identity_pagetable_done = true;
> >  
> > @@ -3532,19 +3525,22 @@ static void seg_setup(int seg)
> >  static int alloc_apic_access_page(struct kvm *kvm)
> >  {
> >  	struct page *page;
> > -	int r = 0;
> > +	void __user *r;
> > +	int ret = 0;
> >  
> >  	mutex_lock(&kvm->slots_lock);
> >  	if (kvm->arch.apic_access_page_done)
> >  		goto out;
> >  	r = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
> >  				    APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);
> 
> Naming the new 'void __user *hva' would yield a smaller differ and would
> probably help readers in the future.

OK.

> >  	} else {
> > -		if (!slot || !slot->npages)
> > -			return 0;
> > -
> >  		/*
> >  		 * Stuff a non-canonical value to catch use-after-delete.  This
> >  		 * ends up being 0 on 32-bit KVM, but there's no better
> >  		 * alternative.
> >  		 */
> >  		hva = (unsigned long)(0xdeadull << 48);
> > +
> > +		if (!slot || !slot->npages)
> > +			return (void __user *)hva;
> 
> My clever shenanigans got discarded, so this weirdness happily is gone. 

I'll see what I get when I rebase.  This series is easy to encounter conflicts
during previous rebases for misterious reasons.  I guess I'll just repost less
frequently so I suffer less from rebase too. :)

Thanks.

-- 
Peter Xu

