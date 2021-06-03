Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA69C39AB0B
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 21:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhFCTtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 15:49:53 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:46958 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCTtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 15:49:52 -0400
Received: by mail-pf1-f179.google.com with SMTP id u126so1720484pfu.13
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 12:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rTqsvMxg8iY/62t/zYCdvRt2W1Pb7CHUIdhxBbw8tpE=;
        b=FW7Eb4p831muffnjSdriN3BohwIcDXxCGHVl/h5kYVtxHSY5vsuqUHE4fX1jjyDOGK
         TZDiqbncT+fDnNI2lMf033NjCx+bvmM6y/FvIdzaayiVRO3Re1rYJcQ0+OnXCCOGIN6K
         hNxXj7bYwEqcyxmjmB47B6fdBPTVfw9nIz+aR9mErx+kp9AyZ/C6/vUmhbDUpAMxqhZn
         esfYNyTGurZmxsuKGIYucGp6VjYx75UEDu2lqCTBU4ChcaZTFCSp+zM7vFzFEA7FVvLF
         s25T9WYbIi6bIzd2vB19QyjydBcYu09c0+lWNt+XHDZVFDkUy54HYH6eLxi+MADTGjJQ
         lUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rTqsvMxg8iY/62t/zYCdvRt2W1Pb7CHUIdhxBbw8tpE=;
        b=KhGviJCs2DJsDu+5orYOjvzAHAdX2ZZg5dW9xDmf1mdSuIyQBe+t7wZ4F8R0kNrH3v
         vwx6wiDuhXlMJjR/Hfa/5CwyhCT3u2oA4TgmZlmLpTSsi5Ahywzjdvi+/joOK4MvtO+l
         5bwtwNMPHl8o5Sgf+4bo2Ao+IWpSpXcfgH2LimJed59qRIZXv+gYu31GoQeGg+0h5DDe
         4VJ7p3rjIIeP0v24rK/Q3FDpYWU/vUBTklX5gcdHkItgrSWFouf1OACEstFZmlay5Vu9
         QDbez52VUdbZ97ZNMO+oyl0MsT6N6ROnLwHorjLh4jznZ0Cj+xRzuIxkxHPUo/aYDY+g
         5PRA==
X-Gm-Message-State: AOAM532EMuze8vAcGHrrah8yDBWZFaYOQ5pJbc4XS+f0e9syVhALVL+7
        4lFU09AJhXdG/wOMwt1WNgjS9g==
X-Google-Smtp-Source: ABdhPJxhF64YHsCWOyX97tbDq6G+PxckYe9jHKy8bbjgWnu7z7A7snBRu3yLRamBxVQRKXgZ0AmwpQ==
X-Received: by 2002:a65:528d:: with SMTP id y13mr1107082pgp.276.1622749617624;
        Thu, 03 Jun 2021 12:46:57 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id m134sm3035801pfd.148.2021.06.03.12.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 12:46:56 -0700 (PDT)
Date:   Thu, 3 Jun 2021 19:46:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 13/13] KVM: unmap guest memory using poisoned pages
Message-ID: <YLkxrMQ2a5aWD5zt@google.com>
References: <YH3HWeOXFiCTZN4y@google.com>
 <20210419185354.v3rgandtrel7bzjj@box>
 <YH3jaf5ThzLZdY4K@google.com>
 <20210419225755.nsrtjfvfcqscyb6m@box.shutemov.name>
 <YH8L0ihIzL6UB6qD@google.com>
 <20210521123148.a3t4uh4iezm6ax47@box>
 <YK6lrHeaeUZvHMJC@google.com>
 <20210531200712.qjxghakcaj4s6ara@box.shutemov.name>
 <YLfFBgPeWZ91TfH7@google.com>
 <20210602233353.gxq35yxluhas5knp@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602233353.gxq35yxluhas5knp@box>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021, Kirill A. Shutemov wrote:
> On Wed, Jun 02, 2021 at 05:51:02PM +0000, Sean Christopherson wrote:
> > > Omitting FOLL_GUEST for shared memory doesn't look like a right approach.
> > > IIUC, it would require the kernel to track what memory is share and what
> > > private, which defeat the purpose of the rework. I would rather enforce
> > > !PageGuest() when share SEPT is populated in addition to enforcing
> > > PageGuest() fro private SEPT.
> > 
> > Isn't that what omitting FOLL_GUEST would accomplish?  For shared memory,
> > including mapping memory into the shared EPT, KVM will omit FOLL_GUEST and thus
> > require the memory to be readable/writable according to the guest access type.
> 
> Ah. I guess I see what you're saying: we can pipe down the shared bit from
> GPA from direct_page_fault() (or whatever handles the fault) down to
> hva_to_pfn_slow() and omit FOLL_GUEST if the shared bit is set. Right?

Yep.

> I guest it's doable, but codeshuffling going to be ugly.

It shouldn't be too horrific.  If it is horrific, I'd be more than happy to
refactor the flow before hand to collect the hva_to_pfn() params into a struct
so that adding a "private" flag is less painful.  There is already TDX-related
work to do similar cleanup in the x86-specific code.

https://lkml.kernel.org/r/cover.1618914692.git.isaku.yamahata@intel.com

> > By definition, that excludes PageGuest() because PageGuest() pages must always
> > be unmapped, e.g. PROTNONE.  And for private EPT, because PageGuest() is always
> > PROTNONE or whatever, it will require FOLL_GUEST to retrieve the PTE/PMD/Pxx.
> > 
> > On a semi-related topic, I don't think can_follow_write_pte() is the correct
> > place to hook PageGuest().  TDX's S-EPT has a quirk where all private guest
> > memory must be mapped writable, but that quirk doesn't hold true for non-TDX
> > guests.  It should be legal to map private guest memory as read-only.
> 
> Hm. The point of the change in can_follow_write_pte() is to only allow to
> write to a PageGuest() page if FOLL_GUEST is used and the mapping is
> writable. Without the change gup(FOLL_GUEST|FOLL_WRITE) would fail.
> 
> It doesn't prevent using read-only guest mappings as read-only. But if you
> want to write to it it has to writable (in addtion to FOLL_GUEST). 

100% agree that the page needs to be host-writable to be mapped as writable.
What I was pointing out is that if FOLL_WRITE is not set, gup() will never check
the PageGuest() exemption (moot point until the protnone check is fixed), and
more importantly that the FOLL_GUEST check is orthogonal to the FOLL_WRITE check.

In other words, I would expect the code to look something ike:

	if (PageGuest()) {
		if (!(flags & FOLL_GUEST)) {
			pte_unmap_unlock(ptep, ptl);
			return NULL;
		}
	} else if ((flags & FOLL_NUMA) && pte_protnone(pte)) {
		goto no_page;
	}

> > And I believe the below snippet in follow_page_pte() will be problematic
> > too, since FOLL_NUMA is added unless FOLL_FORCE is set.  I suspect the
> > correct approach is to handle FOLL_GUEST as an exception to
> > pte_protnone(), though that might require adjusting pte_protnone() to be
> > meaningful even when CONFIG_NUMA_BALANCING=n.
> > 
> > 	if ((flags & FOLL_NUMA) && pte_protnone(pte))
> > 		goto no_page;
> > 	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags)) {
> > 		pte_unmap_unlock(ptep, ptl);
> > 		return NULL;
> > 	}
> 
> Good catch. I'll look into how to untangle NUMA balancing and PageGuest().
> It shouldn't be hard. PageGuest() pages should be subject for balancing.
> 
> > > Do you see any problems with this?
> > > 
> > > > Oh, and the other nicety is that I think it would avoid having to explicitly
> > > > handle PageGuest() memory that is being accessed from kernel/KVM, i.e. if all
> > > > memory exposed to KVM must be !PageGuest(), then it is also eligible for
> > > > copy_{to,from}_user().
> > > 
> > > copy_{to,from}_user() enforce by setting PTE entries to PROT_NONE.
> > 
> > But KVM does _not_ want those PTEs PROT_NONE.  If KVM is accessing memory that
> > is also accessible by the the guest, then it must be shared.  And if it's shared,
> > it must also be accessible to host userspace, i.e. something other than PROT_NONE,
> > otherwise the memory isn't actually shared with anything.
> > 
> > As above, any guest-accessible memory that is accessed by the host must be
> > shared, and so must be mapped with the required permissions.
> 
> I don't see contradiction here: copy_{to,from}_user() would fail with
> -EFAULT on PROT_NONE PTE.
> 
> By saying in initial posting that inserting PageGuest() into shared is
> fine, I didn't mean it's usefule, just allowed.

Yeah, and I'm saying we should explicitly disallow mapping PageGuest() into
shared memory, and then the KVM code that manually kmaps() PageGuest() memory
to avoid copy_{to,from}_user() failure goes aways.
