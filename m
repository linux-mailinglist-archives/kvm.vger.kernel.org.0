Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5604E364A24
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 20:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238333AbhDSSy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 14:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbhDSSy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 14:54:27 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0622C061761
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:53:56 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id r22so29930210ljc.5
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+X4D2n9RFMWw8zjzh3E9FVsIFGWzECSAEPhHZI5vCug=;
        b=PKRW/7grIxILIqQsK8h20q83oHtONy15VxwtEa46HHMPKMLvgfSwOc/ocz5gMW5UF1
         JXZ3sixgGt7FqkeYJNqj8cCgCtgKNz+s5k6ZSXhHuN1T29+4JyAD5zNHptCnSK5C+Vtb
         OThPJPzlqvud0YZHViZXPUIRp4FU6bh+H5+aefuZTo3WY6LChygih0ftfFO1q12z1c3N
         Sjv+D/H0MaDHSaZ5mYVlOuB6xZgQ6z3kwlBS0hLPB0HfMm4uXkLTyDuO9DkdumtI+cWF
         J6DAtW1wzC+iYCpgmdedDOtCTSaugPuBJ3qUgRh9QKt8ytE6JiBmjAwFG2EHExWpsFEW
         9ctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+X4D2n9RFMWw8zjzh3E9FVsIFGWzECSAEPhHZI5vCug=;
        b=S4EptmaqoZC8YsZk//U4agwfiQrdtX5rXJQFg11oCzUQdAse7OP6lDI07GFiiOT88T
         U9xR2eqQM0xpCTVsA6+a/qlPC14uyb4BMa/wgPdVFQ99qEHY5ugHxKusgiXL0HVza1zi
         ehfIUJ1Am9machsCikBacKQdNtp4zxsvhcNgaxNP69YZvagf8FGUU+E/XaEGtCw45LbA
         Ijk2jPU+30VdRSWg7pB/LkQCQvZRA52Y59HERnX7HECjgib2iX0RA6l6/IsXf6Qjz1sw
         KHEj2i0jHqXUvRye350rCNltpNK7HwYiP88IwpwPeq5cZp2kkklk0478DK3nVc23LKSz
         LShg==
X-Gm-Message-State: AOAM530ljsx9W/ztzjMzGwJzhjIxCywBPV3DlnPImkgmG3GSpewI2vJh
        YttYcL5LySMGxLhWtdOa9s8ABQ==
X-Google-Smtp-Source: ABdhPJxD9mbt35DuFIVbuQCWztN4w/y9QKN+wH06/RwHSBIJ/Q8BxsA9a5YbLE87w6jRvlmzB7eXkQ==
X-Received: by 2002:a2e:964e:: with SMTP id z14mr12543091ljh.150.1618858435261;
        Mon, 19 Apr 2021 11:53:55 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id s21sm1914950lfs.261.2021.04.19.11.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 11:53:54 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 28FB8102567; Mon, 19 Apr 2021 21:53:54 +0300 (+03)
Date:   Mon, 19 Apr 2021 21:53:54 +0300
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
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 13/13] KVM: unmap guest memory using poisoned pages
Message-ID: <20210419185354.v3rgandtrel7bzjj@box>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
 <YHnJtvXdrZE+AfM3@google.com>
 <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
 <YH2pam5b837wFM3z@google.com>
 <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
 <YH3HWeOXFiCTZN4y@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH3HWeOXFiCTZN4y@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021 at 06:09:29PM +0000, Sean Christopherson wrote:
> On Mon, Apr 19, 2021, Kirill A. Shutemov wrote:
> > On Mon, Apr 19, 2021 at 04:01:46PM +0000, Sean Christopherson wrote:
> > > But fundamentally the private pages, are well, private.  They can't be shared
> > > across processes, so I think we could (should?) require the VMA to always be
> > > MAP_PRIVATE.  Does that buy us enough to rely on the VMA alone?  I.e. is that
> > > enough to prevent userspace and unaware kernel code from acquiring a reference
> > > to the underlying page?
> > 
> > Shared pages should be fine too (you folks wanted tmpfs support).
> 
> Is that a conflict though?  If the private->shared conversion request is kicked
> out to userspace, then userspace can re-mmap() the files as MAP_SHARED, no?
> 
> Allowing MAP_SHARED for guest private memory feels wrong.  The data can't be
> shared, and dirty data can't be written back to the file.

It can be remapped, but faulting in the page would produce hwpoison entry.
I don't see other way to make Google's use-case with tmpfs-backed guest
memory work.

> > The poisoned pages must be useless outside of the process with the blessed
> > struct kvm. See kvm_pfn_map in the patch.
> 
> The big requirement for kernel TDX support is that the pages are useless in the
> host.  Regarding the guest, for TDX, the TDX Module guarantees that at most a
> single KVM guest can have access to a page at any given time.  I believe the RMP
> provides the same guarantees for SEV-SNP.
> 
> SEV/SEV-ES could still end up with corruption if multiple guests map the same
> private page, but that's obviously not the end of the world since it's the status
> quo today.  Living with that shortcoming might be a worthy tradeoff if punting
> mutual exclusion between guests to firmware/hardware allows us to simplify the
> kernel implementation.

The critical question is whether we ever need to translate hva->pfn after
the page is added to the guest private memory. I believe we do, but I
never checked. And that's the reason we need to keep hwpoison entries
around, which encode pfn.

If we don't, it would simplify the solution: kvm_pfn_map is not needed.
Single bit-per page would be enough.

> > > >  - Add a new GUP flag to retrive such pages from the userspace mapping.
> > > >    Used only for private mapping population.
> > > 
> > > >  - Shared gfn ranges managed by userspace, based on hypercalls from the
> > > >    guest.
> > > > 
> > > >  - Shared mappings get populated via normal VMA. Any poisoned pages here
> > > >    would lead to SIGBUS.
> > > > 
> > > > So far it looks pretty straight-forward.
> > > > 
> > > > The only thing that I don't understand is at way point the page gets tied
> > > > to the KVM instance. Currently we do it just before populating shadow
> > > > entries, but it would not work with the new scheme: as we poison pages
> > > > on fault it they may never get inserted into shadow entries. That's not
> > > > good as we rely on the info to unpoison page on free.
> > > 
> > > Can you elaborate on what you mean by "unpoison"?  If the page is never actually
> > > mapped into the guest, then its poisoned status is nothing more than a software
> > > flag, i.e. nothing extra needs to be done on free.
> > 
> > Normally, poisoned flag preserved for freed pages as it usually indicate
> > hardware issue. In this case we need return page to the normal circulation.
> > So we need a way to differentiate two kinds of page poison. Current patch
> > does this by adding page's pfn to kvm_pfn_map. But this will not work if
> > we uncouple poisoning and adding to shadow PTE.
> 
> Why use PG_hwpoison then?

Page flags are scarce. I don't want to take occupy a new one until I'm
sure I must.

And we can re-use existing infrastructure to SIGBUS on access to such
pages.

-- 
 Kirill A. Shutemov
