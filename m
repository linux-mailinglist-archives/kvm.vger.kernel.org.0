Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A523991F0
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 19:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhFBRwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 13:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhFBRwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 13:52:50 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55011C061574
        for <kvm@vger.kernel.org>; Wed,  2 Jun 2021 10:51:07 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u7so1496382plq.4
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 10:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zkOJFfkTCTVQxqMmrj4ZWVfnOWEp4RXFr0NhsSAyeV8=;
        b=dhlXwZXUl+ds8DakYE+hrD4smEvnIIxco8nmRTKqI3WZAG/iy5ars2LIaEalrGkKMh
         wd6Jc4PL7OWyM9+pAxVSBG6Dwir5wdIMP6frXsEOg+yy9rfgdTAD0ZRqbKo6UDirJ7b2
         TRo5qlUISVd+ikiFE4t4LlP7w1O8UnhXc4/1VHkc4gLuyz055y+VHM5N7oMKfEH/YAOQ
         Oe7ST609RtGLMOmuh4ixsP4WFSQjMrOOMrFbrBhi1IXw5KH19myYayHGIYGWBuBIEs1p
         ASNTbRy2VWY/7Cpmh7HOERqln73nSb0RsQVYDJ6H6q3u0wZwjX57eO+BTt76JdJhQ4Ka
         LzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zkOJFfkTCTVQxqMmrj4ZWVfnOWEp4RXFr0NhsSAyeV8=;
        b=A6Nj+MuUc8JXAiEtYgMcRh42n8oqmbAXPH3YliDWohFu1UJVTigd5h6MxrJNUk5H57
         Z60IxfKk0NgBuSpF/xRfnj44Yfif1bSdZiRqbvbU8VBtsRdRNysvuqxG5swuCZ87YpmN
         GGuneuot9BnK9k9zom/HtdN2DDBcj0PK6MB6YOtBiBargU+9bfOU8dSbFX+O5YOA9q/b
         aZ6p3p0mby6kIhmbMbjM5kRmeYA3b0dhpHafWHxn4uaENCwF8TFK1ij4iu+Hns7CGl29
         OWaYmfeptD6MAtHV+BdtAdqlbvgXypo8+eJwULEjkXNxYbJu+biI2o5GWkhKVDkxG/cx
         3CFA==
X-Gm-Message-State: AOAM530Y929veygIZU+MPUsDOCDrWXGrTZVx2Kzs4/Grc5jmU7D68a3K
        mRTDfMFp2kOut3mXVwcK+mjhnQ==
X-Google-Smtp-Source: ABdhPJx95iN/xpxAC65h1nNQekOXUL6OKO0DFWy5yQwk+UTa8NT0wKbAu7E0PT1yCaWzI36k//yvKQ==
X-Received: by 2002:a17:902:6546:b029:101:abf0:d882 with SMTP id d6-20020a1709026546b0290101abf0d882mr24761050pln.73.1622656266627;
        Wed, 02 Jun 2021 10:51:06 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t124sm410746pgb.38.2021.06.02.10.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 10:51:05 -0700 (PDT)
Date:   Wed, 2 Jun 2021 17:51:02 +0000
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
Message-ID: <YLfFBgPeWZ91TfH7@google.com>
References: <YH2pam5b837wFM3z@google.com>
 <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
 <YH3HWeOXFiCTZN4y@google.com>
 <20210419185354.v3rgandtrel7bzjj@box>
 <YH3jaf5ThzLZdY4K@google.com>
 <20210419225755.nsrtjfvfcqscyb6m@box.shutemov.name>
 <YH8L0ihIzL6UB6qD@google.com>
 <20210521123148.a3t4uh4iezm6ax47@box>
 <YK6lrHeaeUZvHMJC@google.com>
 <20210531200712.qjxghakcaj4s6ara@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531200712.qjxghakcaj4s6ara@box.shutemov.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 31, 2021, Kirill A. Shutemov wrote:
> On Wed, May 26, 2021 at 07:46:52PM +0000, Sean Christopherson wrote:
> > On Fri, May 21, 2021, Kirill A. Shutemov wrote:
> > > Inserting PageGuest() into shared is fine, but the page will not be accessible
> > > from userspace.
> > 
> > Even if it can be functionally fine, I don't think we want to allow KVM to map
> > PageGuest() as shared memory.  The only reason to map memory shared is to share
> > it with something, e.g. the host, that doesn't have access to private memory, so
> > I can't envision a use case.
> > 
> > On the KVM side, it's trivially easy to omit FOLL_GUEST for shared memory, while
> > always passing FOLL_GUEST would require manually zapping.  Manual zapping isn't
> > a big deal, but I do think it can be avoided if userspace must either remap the
> > hva or define a new KVM memslot (new gpa->hva), both of which will automatically
> > zap any existing translations.
> > 
> > Aha, thought of a concrete problem.  If KVM maps PageGuest() into shared memory,
> > then KVM must ensure that the page is not mapped private via a different hva/gpa,
> > and is not mapped _any_ other guest because the TDX-Module's 1:1 PFN:TD+GPA
> > enforcement only applies to private memory.  The explicit "VM_WRITE | VM_SHARED"
> > requirement below makes me think this wouldn't be prevented.
> 
> Hm. I didn't realize that TDX module doesn't prevent the same page to be
> used as shared and private at the same time.

Ya, only private mappings are routed through the TDX module, e.g. it can prevent
mapping the same page as private into multiple guests, but it can't prevent the
host from mapping the page as non-private.

> Omitting FOLL_GUEST for shared memory doesn't look like a right approach.
> IIUC, it would require the kernel to track what memory is share and what
> private, which defeat the purpose of the rework. I would rather enforce
> !PageGuest() when share SEPT is populated in addition to enforcing
> PageGuest() fro private SEPT.

Isn't that what omitting FOLL_GUEST would accomplish?  For shared memory,
including mapping memory into the shared EPT, KVM will omit FOLL_GUEST and thus
require the memory to be readable/writable according to the guest access type.

By definition, that excludes PageGuest() because PageGuest() pages must always
be unmapped, e.g. PROTNONE.  And for private EPT, because PageGuest() is always
PROTNONE or whatever, it will require FOLL_GUEST to retrieve the PTE/PMD/Pxx.

On a semi-related topic, I don't think can_follow_write_pte() is the correct
place to hook PageGuest().  TDX's S-EPT has a quirk where all private guest
memory must be mapped writable, but that quirk doesn't hold true for non-TDX
guests.  It should be legal to map private guest memory as read-only.  And I
believe the below snippet in follow_page_pte() will be problematic too, since
FOLL_NUMA is added unless FOLL_FORCE is set.  I suspect the correct approach is
to handle FOLL_GUEST as an exception to pte_protnone(), though that might require
adjusting pte_protnone() to be meaningful even when CONFIG_NUMA_BALANCING=n.

	if ((flags & FOLL_NUMA) && pte_protnone(pte))
		goto no_page;
	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags)) {
		pte_unmap_unlock(ptep, ptl);
		return NULL;
	}

> Do you see any problems with this?
> 
> > Oh, and the other nicety is that I think it would avoid having to explicitly
> > handle PageGuest() memory that is being accessed from kernel/KVM, i.e. if all
> > memory exposed to KVM must be !PageGuest(), then it is also eligible for
> > copy_{to,from}_user().
> 
> copy_{to,from}_user() enforce by setting PTE entries to PROT_NONE.

But KVM does _not_ want those PTEs PROT_NONE.  If KVM is accessing memory that
is also accessible by the the guest, then it must be shared.  And if it's shared,
it must also be accessible to host userspace, i.e. something other than PROT_NONE,
otherwise the memory isn't actually shared with anything.

As above, any guest-accessible memory that is accessed by the host must be
shared, and so must be mapped with the required permissions.
