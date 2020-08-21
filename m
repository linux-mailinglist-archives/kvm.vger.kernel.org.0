Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABACC24C9A1
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 03:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgHUBqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 21:46:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57533 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726835AbgHUBqf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 21:46:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597974394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GLmCKZgr3b1tSy1Gjcxl9scoffP4gQg5bODIFLHH+RI=;
        b=UJiTVBb01tLYK8EXrvMFJyaObpc4MDNftVj4vrFHGHivcaQEHgwc4+CorLKX+vxbW/B4VB
        +ynZBESWL+VfY5b65DhVzCMhSP0VgFWzO4Yr0IWHtMNX65W8tbC36Wm/kUx40fwvWgF+6S
        yghAQGVfnrA5qVoZDFWCM2fzkBGRTK8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-9q35XT-JNj-yE9G3iP7Z_w-1; Thu, 20 Aug 2020 21:46:32 -0400
X-MC-Unique: 9q35XT-JNj-yE9G3iP7Z_w-1
Received: by mail-qt1-f200.google.com with SMTP id d2so140515qtn.8
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 18:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GLmCKZgr3b1tSy1Gjcxl9scoffP4gQg5bODIFLHH+RI=;
        b=UzL458aRywE2r13zqRDT3nRvLLG9+5AaCOO9c/cuw//uokSgLXTtMHP99gl3FCTOdh
         Ae9xf7AFNWdyn12QkmtF4BKexKlOLf4gjAh5zsASU3hHfAKa/2HMurK2iTIrY9L/dSTv
         yVkuXjYM+SgdiNEspo+Uo0HOMGbjK+6Q1C/9gq+Q7rUYtZU5PipoV5ZsIyr/NBneeys6
         fMiupUur6/ni/FaIcUhtVu4fdoWthuX7S99tKIbw1cpbTmdf3KZNrwNOVNlkfFrTY81K
         rO6TTpIkiTVdIil4qy/Z/FINiibhiqBchIix7kSQfSW8MBlhUfM92LJSUQPt6Qco+BlP
         KalQ==
X-Gm-Message-State: AOAM531aJozFpKJOauWncx95nc231UO8ziuGsUQsH5eCjiCO0b+tVEsf
        1h3xprpTdrRtOmrpwqc30SNqGQQw2/L5syHd/kNYbtIqaaDim/jMC6+Y2lTnKK+0aWAItvAfD6a
        8iyDWDcur8Zxd
X-Received: by 2002:ad4:4aa5:: with SMTP id i5mr519427qvx.179.1597974392187;
        Thu, 20 Aug 2020 18:46:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrlFMy+84phcbTZX0JBOmoAL1qg1oqQYDrKrHvnBQYxhl6Ynsyk4M9JlvVmeSM4LO9CKHZYw==
X-Received: by 2002:ad4:4aa5:: with SMTP id i5mr519405qvx.179.1597974391929;
        Thu, 20 Aug 2020 18:46:31 -0700 (PDT)
Received: from redhat.com (bzq-109-67-40-161.red.bezeqint.net. [109.67.40.161])
        by smtp.gmail.com with ESMTPSA id 73sm453194qtf.74.2020.08.20.18.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 18:46:30 -0700 (PDT)
Date:   Thu, 20 Aug 2020 21:46:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: x86: introduce KVM_MEM_PCI_HOLE memory
Message-ID: <20200820214407-mutt-send-email-mst@kernel.org>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200807141232.402895-3-vkuznets@redhat.com>
 <20200814023139.GB4845@linux.intel.com>
 <20200814102850-mutt-send-email-mst@kernel.org>
 <20200817163207.GC22407@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817163207.GC22407@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 17, 2020 at 09:32:07AM -0700, Sean Christopherson wrote:
> On Fri, Aug 14, 2020 at 10:30:14AM -0400, Michael S. Tsirkin wrote:
> > On Thu, Aug 13, 2020 at 07:31:39PM -0700, Sean Christopherson wrote:
> > > > @@ -2318,6 +2338,11 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> > > >  	int r;
> > > >  	unsigned long addr;
> > > >  
> > > > +	if (unlikely(slot && (slot->flags & KVM_MEM_PCI_HOLE))) {
> > > > +		memset(data, 0xff, len);
> > > > +		return 0;
> > > > +	}
> > > 
> > > This feels wrong, shouldn't we be treating PCI_HOLE as MMIO?  Given that
> > > this is performance oriented, I would think we'd want to leverage the
> > > GPA from the VMCS instead of doing a full translation.
> > > 
> > > That brings up a potential alternative to adding a memslot flag.  What if
> > > we instead add a KVM_MMIO_BUS device similar to coalesced MMIO?  I think
> > > it'd be about the same amount of KVM code, and it would provide userspace
> > > with more flexibility, e.g. I assume it would allow handling even writes
> > > wholly within the kernel for certain ranges and/or use cases, and it'd
> > > allow stuffing a value other than 0xff (though I have no idea if there is
> > > a use case for this).
> > 
> > I still think down the road the way to go is to map
> > valid RO page full of 0xff to avoid exit on read.
> > I don't think a KVM_MMIO_BUS device will allow this, will it?
> 
> No, it would not, but adding KVM_MEM_PCI_HOLE doesn't get us any closer to
> solving that problem either.

I'm not sure why. Care to elaborate?

> What if we add a flag to allow routing all GFNs in a memslot to a single
> HVA?

An issue here would be this breaks attempts to use a hugepage for this.


>  At a glance, it doesn't seem to heinous.  It would have several of the
> same touchpoints as this series, e.g. __kvm_set_memory_region() and
> kvm_alloc_memslot_metadata().
> 
> The functional changes (for x86) would be a few lines in
> __gfn_to_hva_memslot() and some new logic in kvm_handle_hva_range().  The
> biggest concern is probably the fragility of such an implementation, as KVM
> has a habit of open coding operations on memslots.
> 
> The new flags could then be paired with KVM_MEM_READONLY to yield the desired
> behavior of reading out 0xff for an arbitrary range without requiring copious
> memslots and/or host pages.
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 852fc8274bdd..875243a0ab36 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1103,6 +1103,9 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
>  static inline unsigned long
>  __gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> +       if (unlikely(slot->flags & KVM_MEM_SINGLE_HVA))
> +               return slot->userspace_addr;
> +
>         return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
>  }

