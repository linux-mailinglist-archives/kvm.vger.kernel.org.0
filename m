Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB7C42CAB2
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 22:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhJMUM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 16:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhJMUMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 16:12:25 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB11C061749
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 13:10:21 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id 21so2556836plo.13
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 13:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=x1LbBin+3giaISRnECjj9ym7k3KwVa5JtFi86EOVr/U=;
        b=QDCwnlgrMzfzTJO2pUJLtu7nG00gr1hza14ldZPiMdaKHgFwF4SXNeVU3mY98HXsC9
         OU26/0D3oks/kHUGsc3RYZWTSkdbVJMH3cqGsg6S/kOLm5uGSlbA7uGRO9InDb8rJOp/
         zZfaVSpfjeMg6nZbHv1OH1ZzJ8Kk0q0yEs616ejBQv6HQdTG8KQolJJMZVNxGy8nFDAm
         INdYjQnMguxFHMCCQSXWtn/GZC7cbbuz/iVozreHj2rq5G3TmpjIZEf9A233O1t6TRlX
         4SwX0YAYtJPOvzVN5QrMQ10zrnlQK0gvhrWH1H6fXXQf5HuB8G5naQ115F+0a9umJB9e
         LXdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=x1LbBin+3giaISRnECjj9ym7k3KwVa5JtFi86EOVr/U=;
        b=NystYbJPCFfMwsh0296Vy7NkT2/vvtR38kb0gCHShmkAknu/635w4YasC1Fc20ERRg
         dw1ZOW1d8F24zFQZFMMEsnJzUKhd5Q+kJhM7rGBQYAPg2jvB1yhw0P16X6BCe6iEKTdA
         xzJB2joBvhy9GxSpYThPS8Os4zyajeBAFZMcJO347/iTzobxlGTZ25+XLkqJinTdmuHC
         nTjezU9l+HeonJiQk4Rl9GDQFLTPJQ2syU2RvNBVp9dsOknQDpqQdS0wm8XeJp8HBbSh
         OyPLpbtQbfbu92dx0nb50VROUjlhCO+HSdekL032MgmyA71qWKxWactUKc1AZ4ZcQ5ms
         4Ipg==
X-Gm-Message-State: AOAM530BgVPYhxTyw/6qO7YVo/0SR4M0Mpul8FqdBWWnIEfAE+F9XqAB
        kwVi6jOV981/63sEFJVe7XHWIg==
X-Google-Smtp-Source: ABdhPJwrMztjMpB1VLcp74m0YwjBj8njZMHQfsLZuHu+FNwvxHkPE/McM+Eqb0ufZNt4AIE6TMKqNg==
X-Received: by 2002:a17:90a:d190:: with SMTP id fu16mr1564938pjb.14.1634155821020;
        Wed, 13 Oct 2021 13:10:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id kb15sm330965pjb.43.2021.10.13.13.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 13:10:20 -0700 (PDT)
Date:   Wed, 13 Oct 2021 20:10:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn
 map and unmap
Message-ID: <YWc9KL8gghEiI48h@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-40-brijesh.singh@amd.com>
 <YWYm/Gw8PbaAKBF0@google.com>
 <94128da2-c9f7-d990-2508-5a56f6cf16e7@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94128da2-c9f7-d990-2508-5a56f6cf16e7@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021, Brijesh Singh wrote:
> 
> On 10/12/21 5:23 PM, Sean Christopherson wrote:
> > On Fri, Aug 20, 2021, Brijesh Singh wrote:
> >> When SEV-SNP is enabled in the guest VM, the guest memory pages can
> >> either be a private or shared. A write from the hypervisor goes through
> >> the RMP checks. If hardware sees that hypervisor is attempting to write
> >> to a guest private page, then it triggers an RMP violation #PF.
> >>
> >> To avoid the RMP violation, add post_{map,unmap}_gfn() ops that can be
> >> used to verify that its safe to map a given guest page. Use the SRCU to
> >> protect against the page state change for existing mapped pages.
> > SRCU isn't protecting anything.  The synchronize_srcu_expedited() in the PSC code
> > forces it to wait for existing maps to go away, but it doesn't prevent new maps
> > from being created while the actual RMP updates are in-flight.  Most telling is
> > that the RMP updates happen _after_ the synchronize_srcu_expedited() call.
> >
> > This also doesn't handle kvm_{read,write}_guest_cached().
> 
> Hmm, I thought the kvm_{read_write}_guest_cached() uses the
> copy_{to,from}_user(). Writing to the private will cause a #PF and will
> fail the copy_to_user(). Am I missing something?

Doh, right you are.  I was thinking they cached the kmap, but it's just the
gpa->hva that gets cached.

> > I can't help but note that the private memslots idea[*] would handle this gracefully,
> > e.g. the memslot lookup would fail, and any change in private memslots would
> > invalidate the cache due to a generation mismatch.
> >
> > KSM is another mess that would Just Work.
> >
> > I'm not saying that SNP should be blocked on support for unmapping guest private
> > memory, but I do think we should strongly consider focusing on that effort rather
> > than trying to fix things piecemeal throughout KVM.  I don't think it's too absurd
> > to say that it might actually be faster overall.  And I 100% think that having a
> > cohesive design and uABI for SNP and TDX would be hugely beneficial to KVM.
> >
> > [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20210824005248.200037-1-seanjc%40google.com&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7Cd1717d511a1f473cedc408d98ddfb027%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637696814148744591%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3LF77%2BcqmpUdiP6YAk7LpImisBzjRGUzdI3raqjJxl0%3D&amp;reserved=0
> >
> >> +int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *token)
> >> +{
> >> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> >> +	int level;
> >> +
> >> +	if (!sev_snp_guest(kvm))
> >> +		return 0;
> >> +
> >> +	*token = srcu_read_lock(&sev->psc_srcu);
> >> +
> >> +	/* If pfn is not added as private then fail */
> > This comment and the pr_err() are backwards, and confused the heck out of me.
> > snp_lookup_rmpentry() returns '1' if the pfn is assigned, a.k.a. private.  That
> > means this code throws an error if the page is private, i.e. requires the page
> > to be shared.  Which makes sense given the use cases, it's just incredibly
> > confusing.
> Actually I followed your recommendation from the previous feedback that
> snp_lookup_rmpentry() should return 1 for the assigned page, 0 for the
> shared and -negative for invalid. I can clarify it here  again.
>
> >> +	if (snp_lookup_rmpentry(pfn, &level) == 1) {
> > Any reason not to provide e.g. rmp_is_shared() and rmp_is_private() so that
> > callers don't have to care as much about the return values?  The -errno/0/1
> > semantics are all but guarantee to bite us in the rear at some point.
> 
> If we look at the previous series, I had a macro rmp_is_assigned() for
> exactly the same purpose but the feedback was to drop those macros and
> return the state indirectly through the snp_lookup_rmpentry(). I can
> certainly add a helper rmp_is_{shared,private}() if it makes code more
> readable.

Ah rats.  Bad communication on my side.  I didn't intended to have non-RMP code
directly consume snp_lookup_rmpentry() for simple checks.  The goal behind the
helper was to bury "struct rmpentry" so that it wasn't visible to the kernel at
large.  I.e. my objection was that rmp_assigned() was looking directly at a
non-architectural struct.

My full thought for snp_lookup_rmpentry() was that it _could_ be consumed directly
without exposing "struct rmpentry", but that simple, common use cases would provide
wrappers, e.g.

static inline snp_is_rmp_private(...)
{
	return snp_lookup_rmpentry(...) == 1;
}

static inline snp_is_rmp_shared(...)
{
	return snp_lookup_rmpentry(...) < 1;
}


Side topic, what do you think about s/assigned/private for the "public" APIs, as
suggested/implied above?  I actually like the terminology when talking specifically
about the RMP, but it doesn't fit the abstractions that tend to be used when talking
about these things in other contexts, e.g. in KVM.
