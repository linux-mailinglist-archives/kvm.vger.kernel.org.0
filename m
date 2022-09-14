Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E135B8CA8
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 18:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiINQPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 12:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiINQPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 12:15:34 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A319F6F275
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 09:15:33 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so14913466pjh.3
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 09:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=8A1QBrYdNqwfKSHedR+VNWdvV9LDIo8DjOKUwjNPjrY=;
        b=mvQUfDz6ojr7ZAMyHwdFbIr04Tib8sObkLdz585rF4NjcanR41FcX6tQ1gqbYu4Ttl
         Fu0XNYqOA8b4p4ooruVgUBMH4SpJKWDKtJPt3NmQ5qog6dHoc6uVRsUrx/4AJhyTV8BP
         hwwv0WhgV9E9N1JqLQqd/gOzzw/SfL68NBvgFd2yeSjoSquzbymUv9jmX+bDZCpbrcqE
         IWV85+8F1DZwNxLu7gvOFZS12gaZb6YWoH30BucapjCD5UHnBfWByH/12R4gijybVh8Z
         6rzxzDR1nASgbMYDhAOKQnFfdGeCOT2I1IGFSdLfRmwD7NpQfKB6kdhW0x/vCA2l/emH
         spRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8A1QBrYdNqwfKSHedR+VNWdvV9LDIo8DjOKUwjNPjrY=;
        b=wfXC0l7h9d8H0JZU2PYqKqiBTyOfOJM75hbdBeFSV7naPgKJ3rkkEj/RIJ27xvQo8X
         j/DjDeQBqql7577yPGTvJYAc/h0a/j8zgSO6KusF1rMdND4sl9voEKYHC1G9nfGlJEuv
         Cr6ThimaNFByubhAPzV1zMtADlfgi8zzADduMuyE+JJllgvb/zm+FEmP0n94C0UvVAj5
         /tP+D/xweMVAGRKQwMUIBxjTT9rEF7TD+bFNdvzehOzmNOj9zlElEUuq0ZzliiIgHn7k
         EfKEJ8N/yw5PpnUhtNDJd5YFahkpGFwGYQS54zY0ahCYWE9mm/m41+aJrs5uWrpBSLYU
         kmqA==
X-Gm-Message-State: ACrzQf0j96mCJV8+PQWTZM0LenjVAXzfxn91mumLFwLMfAnJaIwt+VKa
        Z+4i2LfMZiU5hZd7jTMXWgw2I6AaLjOumw==
X-Google-Smtp-Source: AMsMyM6ZMbUkdU2hvrYoAOYSfAQjC5fDqY7KXcHPFAReC2+/kiHDQz57mmIFmmqzXPEbSlfzjbs+eA==
X-Received: by 2002:a17:90b:1e0d:b0:202:91ec:e167 with SMTP id pg13-20020a17090b1e0d00b0020291ece167mr5542131pjb.174.1663172132830;
        Wed, 14 Sep 2022 09:15:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m3-20020a638c03000000b0042bd73400b6sm9925334pgd.87.2022.09.14.09.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 09:15:32 -0700 (PDT)
Date:   Wed, 14 Sep 2022 16:15:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Orr <marcorr@google.com>
Cc:     Michael Roth <michael.roth@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>, jarkko@profian.com
Subject: Re: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn
 map and unmap
Message-ID: <YyH+IGpBBsjfHdDC@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-40-brijesh.singh@amd.com>
 <YWYm/Gw8PbaAKBF0@google.com>
 <YWc+sRwHxEmcZZxB@google.com>
 <4e41dcff-7c7b-cf36-434a-c7732e7e8ff2@amd.com>
 <YWm3bOFcUSlyZjNb@google.com>
 <20220908212114.sqne7awimfwfztq7@amd.com>
 <YyGLXXkFCmxBfu5U@google.com>
 <CAA03e5H-V+axMiXTLXi7bf+mBs8ZMvaFZTSHSfktZDTSfu=HZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5H-V+axMiXTLXi7bf+mBs8ZMvaFZTSHSfktZDTSfu=HZQ@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 14, 2022, Marc Orr wrote:
> On Wed, Sep 14, 2022 at 9:05 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Sep 08, 2022, Michael Roth wrote:
> > > On Fri, Oct 15, 2021 at 05:16:28PM +0000, Sean Christopherson wrote:
> > > So in the context of this interim solution, we're trying to look for a
> > > solution that's simple enough that it can be used reliably, without
> > > introducing too much additional complexity into KVM. There is one
> > > approach that seems to fit that bill, that Brijesh attempted in an
> > > earlier version of this series (I'm not sure what exactly was the
> > > catalyst to changing the approach, as I wasn't really in the loop at
> > > the time, but AIUI there weren't any showstoppers there, but please
> > > correct me if I'm missing anything):
> > >
> > >  - if the host is writing to a page that it thinks is supposed to be
> > >    shared, and the guest switches it to private, we get an RMP fault
> > >    (actually, we will get a !PRESENT fault, since as of v5 we now
> > >    remove the mapping from the directmap as part of conversion)
> > >  - in the host #PF handler, if we see that the page is marked private
> > >    in the RMP table, simply switch it back to shared
> > >  - if this was a bug on the part of the host, then the guest will see
> >
> > As discussed off-list, attempting to fix up RMP violations in the host #PF handler
> > is not a viable approach.  There was also extensive discussion on-list a while back:
> >
> > https://lore.kernel.org/all/8a244d34-2b10-4cf8-894a-1bf12b59cf92@www.fastmail.com
> 
> I mentioned this during Mike's talk at the micro-conference: For pages
> mapped in by the kernel can we disallow them to be converted to
> private?

In theory, yes.  Do we want to do something like this?  No.  kmap() does something
vaguely similar for 32-bit PAE/PSE kernels, but that's a lot of complexity and
overhead to take on.  And this issue goes far beyond a kmap(); when the kernel gup()s
a page, the kernel expects the pfn to be available, no exceptions (pun intended).

> Note, userspace accesses are already handled by UPM.

I'm confused by the UPM comment.  Isn't the gist of this thread about the ability
to merge SNP _without_ UPM?  Or am I out in left field?

> In pseudo-code, I'm thinking something like this:
> 
> kmap_helper() {
>   // And all other interfaces where the kernel can map a GPA
>   // into the kernel page tables
>   mapped_into_kernel_mem_set[hpa] = true;
> }
> 
> kunmap_helper() {
>   // And all other interfaces where the kernel can unmap a GPA
>   // into the kernel page tables
>   mapped_into_kernel_mem_set[hpa] = false;
> 
>   // Except it's not this simple because we probably need ref counting
>   // for multiple mappings. Sigh. But you get the idea.

A few issues off the top of my head:

  - It's not just refcounting, there would also likely need to be locking to
    guarantee sane behavior.
  - kmap() isn't allowed to fail and RMPUPDATE isn't strictly guaranteed to succeed,
    which is problematic if the kernel attempts to kmap() a page that's already
    private, especially for kmap_atomic(), which isn't allowed to sleep.
  - Not all kernel code is well behaved and bounces through kmap(); undoubtedly
    some of the 1200+ users of page_address() will be problematic.
    
    $ git grep page_address | wc -l
    1267
  - It's not sufficient for TDX.  Merging something this complicated when we know
    we still need UPM would be irresponsible from a maintenance perspective.
  - KVM would need to support two separate APIs for SNP, which I very much don't
    want to do.
