Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D39295DFE
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 14:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897846AbgJVMGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 08:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897841AbgJVMGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 08:06:48 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5B5C0613CF
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 05:06:48 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a4so1623307lji.12
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 05:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VKJlaic7DNxFEvXPjwxg38aEC5FAN/PkBBIN9e6QrXw=;
        b=FAoTPilUR+FAnKd0OhFEOG+djamc+uOm7EfZfnqCFzVg+HPqejkiPb77RR2pW4vfaK
         PtywIAp2g4udgVl2lrkawa447f3LiDLO3tgViO8vWCLIc+GVhTBc5xJhTdqQqyQoN/WS
         ZNQGKcnzy913BymaoHrONk2Cm3DUm/H+M66FbTE56pRWZAL1izkoswHnvDkO++9Dj3sY
         p3okGbHS+8XafoOWQEv/M7uEbl0EGo+JpQAeI2lNrXXEAB6bNVN3FmVpIh8bkhr3muPR
         R/Dr/Zqz6vgvGu9+MNe7d8BGRvUwnS08+882xuRwfP13nkINCHlZ+trFhMpJhPaJAxuG
         i1RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VKJlaic7DNxFEvXPjwxg38aEC5FAN/PkBBIN9e6QrXw=;
        b=WhKi2ixDhjVBrVIjv+uuNvR/vhhQqjLaxDXhkihXKDR6i1pS7SaZ38Pfq7jvcFvZ2n
         SrMkpTjBIHjt4TVHAncRI+AGRcDqwAgMKC95VeEjnfABY/zo9b3N64k0eXsST/2imPwY
         QOVxTtouR+gnXgWxQzAdG5fV2pCODSpdNAtejFSVNJW6xIuylVXo6G3u1oZFeRKBLF94
         GVHfvvfh3h9S7PuaQzLyg+vXQ+CRM/yZFFemB3INTbENXe7+jVxwS5U8iid/W3FteL/4
         zebv0JG76qaD33232eATNHnqCobTkgl0Lr/JZRKRRXgw0Ervtpr12FHDN5o1HGJBELva
         0tNw==
X-Gm-Message-State: AOAM531nijkh2ZQ0NPvWO42f+tlruyeK+hjkix9mNEhkOZNImoBs6kkg
        szcwf+GBu/cFJ5FLGmQ2P6htfg==
X-Google-Smtp-Source: ABdhPJxa+yGQU8bmkk4mUNmRB457D2NmD4IUrHk4Zlb7inEaAmVoDkF6fw+Wmro9EuJKmKmMPbLCdg==
X-Received: by 2002:a2e:9dd1:: with SMTP id x17mr778531ljj.219.1603368406779;
        Thu, 22 Oct 2020 05:06:46 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id x18sm241582lfe.158.2020.10.22.05.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 05:06:45 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 83BC7102F6D; Thu, 22 Oct 2020 15:06:45 +0300 (+03)
Date:   Thu, 22 Oct 2020 15:06:45 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "peterz@infradead.org" <peterz@infradead.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "wad@chromium.org" <wad@chromium.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [RFCv2 14/16] KVM: Handle protected memory in
 __kvm_map_gfn()/__kvm_unmap_gfn()
Message-ID: <20201022120645.vdmytvcmdoku73os@box>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-15-kirill.shutemov@linux.intel.com>
 <8404a8802dbdbf81c8f75249039580f9e6942095.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8404a8802dbdbf81c8f75249039580f9e6942095.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 06:50:28PM +0000, Edgecombe, Rick P wrote:
> On Tue, 2020-10-20 at 09:18 +0300, Kirill A. Shutemov wrote:
> > @@ -467,7 +477,7 @@ void iounmap(volatile void __iomem *addr)
> >  	p = find_vm_area((void __force *)addr);
> >  
> >  	if (!p) {
> > -		printk(KERN_ERR "iounmap: bad address %p\n", addr);
> > +		printk(KERN_ERR "iounmap: bad address %px\n", addr);
> 
> Unintentional?

Yep. Will fix.

> > @@ -2162,15 +2178,20 @@ static int __kvm_map_gfn(struct kvm_memslots
> > *slots, gfn_t gfn,
> >  			kvm_cache_gfn_to_pfn(slot, gfn, cache, gen);
> >  		}
> >  		pfn = cache->pfn;
> > +		protected = cache->protected;
> >  	} else {
> >  		if (atomic)
> >  			return -EAGAIN;
> > -		pfn = gfn_to_pfn_memslot(slot, gfn);
> > +		pfn = gfn_to_pfn_memslot_protected(slot, gfn,
> > &protected);
> >  	}
> >  	if (is_error_noslot_pfn(pfn))
> >  		return -EINVAL;
> >  
> > -	if (pfn_valid(pfn)) {
> > +	if (protected) {
> > +		if (atomic)
> > +			return -EAGAIN;
> > +		hva = ioremap_cache_force(pfn_to_hpa(pfn), PAGE_SIZE);
> > +	} else if (pfn_valid(pfn)) {
> >  		page = pfn_to_page(pfn);
> >  		if (atomic)
> >  			hva = kmap_atomic(page);
> 
> I think the page could have got unmapped since the gup via the
> hypercall on another CPU. It could be an avenue for the guest to crash
> the host.

Hm.. I'm not sure I follow. Could you elaborate on what scenario you have
in mind?

-- 
 Kirill A. Shutemov
