Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D333F399665
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 01:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFBXfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 19:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhFBXft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 19:35:49 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6F7C06174A
        for <kvm@vger.kernel.org>; Wed,  2 Jun 2021 16:33:49 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id u22so4736220ljh.7
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 16:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PTfQXWxpT7/vPk75BLaU1gGVmYZcPYEwaABzwTpX4X8=;
        b=xoIjz3sZWLuffKRVh0YALgXm6O8hnsf+f+WCDpt4AdwtSsGKBjFrDkpv6SHmOKfLvQ
         ag6Zz3+0PVbskBft46UU1iBPu+6JCm+XXaKgAsY1YTm7Ib3+vfaTARypU8kuS4DO8bU4
         4erqAmfO60o4/Y1v3inpt4u+tjLPknSeFcCnLA9KJ6i+IHoPzKxtEqsTAYOUcyv0H/ip
         1H2ACkRBA30VtVgxpEFXPfXt7aT1I0vO4gIY+bd0BjcOMeDMWrsQIC89RzVjDvUkQ6Me
         nUD6UbBJ4qa2eYALWuISCxy5eyq2hsGJQ20/+Fy776Zq2mDn6g5z5YbtJm0dl/EkdAIS
         D2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PTfQXWxpT7/vPk75BLaU1gGVmYZcPYEwaABzwTpX4X8=;
        b=mfvht6ThmnlCXCaQOrsbcMP8/bI35fMtp9C/iUIRs5nPwk/39ONtQ1i/DCfqff55hj
         LZvUu2EmunDn5FpboM7NGjgsHjyqUC6d++QhrdwbSvXQvRufB+oR+6z2yD3VJk0+FvGJ
         rGBbrrEjSXl3hbTHHGFn8neoS8Pjybj7sCFSQLaXc9Y5zL5o5JtOZh19MSfVhUhITVvq
         k6buk5KZ6QTeT3VRTdUGDvkegUTWq73rADJzxpV2LH+d/kYFRFQG1RN1hYRdQm9Pkj9r
         hwxw2fN+qeufiGm+cbA4kA40judG9a3tjX+6wyEIRTSddHEbkOFblirU1dh4Wi3y6IXy
         mvDA==
X-Gm-Message-State: AOAM532lmTZJDNqpP16eQ7RNE4TfIqeWdvo/CoAdY8CXspOO8xvaWF8X
        wg60nZmJag8ALe/TLdf3jkNfkw==
X-Google-Smtp-Source: ABdhPJyxY2uHTU5pxb90Q61I0oFx+mfHXgdsajfEDRhtoMh/thfpDCvGB+RQADYTGQ5zaZ+IYKauew==
X-Received: by 2002:a2e:a489:: with SMTP id h9mr27552130lji.21.1622676823199;
        Wed, 02 Jun 2021 16:33:43 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id p1sm132646lfr.78.2021.06.02.16.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 16:33:42 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 70984102781; Thu,  3 Jun 2021 02:33:53 +0300 (+03)
Date:   Thu, 3 Jun 2021 02:33:53 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Sean Christopherson <seanjc@google.com>
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
Message-ID: <20210602233353.gxq35yxluhas5knp@box>
References: <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
 <YH3HWeOXFiCTZN4y@google.com>
 <20210419185354.v3rgandtrel7bzjj@box>
 <YH3jaf5ThzLZdY4K@google.com>
 <20210419225755.nsrtjfvfcqscyb6m@box.shutemov.name>
 <YH8L0ihIzL6UB6qD@google.com>
 <20210521123148.a3t4uh4iezm6ax47@box>
 <YK6lrHeaeUZvHMJC@google.com>
 <20210531200712.qjxghakcaj4s6ara@box.shutemov.name>
 <YLfFBgPeWZ91TfH7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLfFBgPeWZ91TfH7@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 05:51:02PM +0000, Sean Christopherson wrote:
> > Omitting FOLL_GUEST for shared memory doesn't look like a right approach.
> > IIUC, it would require the kernel to track what memory is share and what
> > private, which defeat the purpose of the rework. I would rather enforce
> > !PageGuest() when share SEPT is populated in addition to enforcing
> > PageGuest() fro private SEPT.
> 
> Isn't that what omitting FOLL_GUEST would accomplish?  For shared memory,
> including mapping memory into the shared EPT, KVM will omit FOLL_GUEST and thus
> require the memory to be readable/writable according to the guest access type.

Ah. I guess I see what you're saying: we can pipe down the shared bit from
GPA from direct_page_fault() (or whatever handles the fault) down to
hva_to_pfn_slow() and omit FOLL_GUEST if the shared bit is set. Right?

I guest it's doable, but codeshuffling going to be ugly.

> By definition, that excludes PageGuest() because PageGuest() pages must always
> be unmapped, e.g. PROTNONE.  And for private EPT, because PageGuest() is always
> PROTNONE or whatever, it will require FOLL_GUEST to retrieve the PTE/PMD/Pxx.
> 
> On a semi-related topic, I don't think can_follow_write_pte() is the correct
> place to hook PageGuest().  TDX's S-EPT has a quirk where all private guest
> memory must be mapped writable, but that quirk doesn't hold true for non-TDX
> guests.  It should be legal to map private guest memory as read-only.

Hm. The point of the change in can_follow_write_pte() is to only allow to
write to a PageGuest() page if FOLL_GUEST is used and the mapping is
writable. Without the change gup(FOLL_GUEST|FOLL_WRITE) would fail.

It doesn't prevent using read-only guest mappings as read-only. But if you
want to write to it it has to writable (in addtion to FOLL_GUEST). 

> And I believe the below snippet in follow_page_pte() will be problematic
> too, since FOLL_NUMA is added unless FOLL_FORCE is set.  I suspect the
> correct approach is to handle FOLL_GUEST as an exception to
> pte_protnone(), though that might require adjusting pte_protnone() to be
> meaningful even when CONFIG_NUMA_BALANCING=n.
> 
> 	if ((flags & FOLL_NUMA) && pte_protnone(pte))
> 		goto no_page;
> 	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags)) {
> 		pte_unmap_unlock(ptep, ptl);
> 		return NULL;
> 	}

Good catch. I'll look into how to untangle NUMA balancing and PageGuest().
It shouldn't be hard. PageGuest() pages should be subject for balancing.

> > Do you see any problems with this?
> > 
> > > Oh, and the other nicety is that I think it would avoid having to explicitly
> > > handle PageGuest() memory that is being accessed from kernel/KVM, i.e. if all
> > > memory exposed to KVM must be !PageGuest(), then it is also eligible for
> > > copy_{to,from}_user().
> > 
> > copy_{to,from}_user() enforce by setting PTE entries to PROT_NONE.
> 
> But KVM does _not_ want those PTEs PROT_NONE.  If KVM is accessing memory that
> is also accessible by the the guest, then it must be shared.  And if it's shared,
> it must also be accessible to host userspace, i.e. something other than PROT_NONE,
> otherwise the memory isn't actually shared with anything.
> 
> As above, any guest-accessible memory that is accessed by the host must be
> shared, and so must be mapped with the required permissions.

I don't see contradiction here: copy_{to,from}_user() would fail with
-EFAULT on PROT_NONE PTE.

By saying in initial posting that inserting PageGuest() into shared is
fine, I didn't mean it's usefule, just allowed.

-- 
 Kirill A. Shutemov
