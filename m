Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22DC42C4D6
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 17:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbhJMPfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 11:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhJMPfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 11:35:53 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756B2C061570
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 08:33:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id g5so2095756plg.1
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 08:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w0OXKQO+EQQ/M5woV3NPH/hGk7JVf61CPOh6HhRk/m8=;
        b=sk1tTuqj/MCxcwKyXEpXPEoUQXTOIfjFXKFpcEO7e7km7L0f2uVxpAarDVbOFcPfZj
         AaOMeRbp4pC54f9RoxLmNi9V7CBYoBY1iyg9go/NhpUX6rxl/Bs7DQywRj7z7CNV4Icw
         phkGQth0VbP/e+oGfy5k2wyLOkQ9uo0cMwFuFcLpp+k+5Vt7Gp8qhcspnfT7fKxbSBfc
         yBkDFK92khyeeiGtbaLySGhojmyIoZHyBZz+pNPbLCghA75QCxHiZCuPcWG8zASdpSLp
         wkXrG5gjIQ8mY7pZDUe6GW6iu8tNFQyciIXy/X8jRSaEZUUlBRse1lVXJXHUtz1AIKN8
         gdzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w0OXKQO+EQQ/M5woV3NPH/hGk7JVf61CPOh6HhRk/m8=;
        b=LTDX6nX/IuMRGk+1dD0XUURwZpridot3JJnZkg8a7BJvxLMQtc6kIpF1zcikxyVC90
         aUvuWil8k0LNFRa07j2bpJktVwBWAsVb9S1F50wS79JvTB1szmKKwYbFJg542idX/MMM
         4Gmg5NNiWQojQ0CIMJg/7SVCAckeiVhiiT7EK4Su/e6f6l3T/mMZJJ+V3hSyrwPN9lE7
         BnbAERj4mQPVoisKnQpIyK4rjCf8CDMdKF1MhZns9XWX6JCMDXbmtXa4/ldXtB/5TkKq
         U65edEkUNoJsfqe8enHjPeimtS2e7YX1DmN90lUbwydcwGMPCWgpB6U59MgLxTwlAS2e
         ZI9g==
X-Gm-Message-State: AOAM533zaxcyg9Mwv1K7isObMKVV9hrHU2dcJ7i/i7znV3HsGnywyaK7
        oRcYRcT6yF3rr6TXtJcTeR00/w==
X-Google-Smtp-Source: ABdhPJyIpI8yklVSJGPLmwLeEm7VlfgHbKcdMxX12nXi3LKT7tczNU8dmkCQdhnCU2lfWOgycwTuYQ==
X-Received: by 2002:a17:90b:4f4b:: with SMTP id pj11mr98367pjb.4.1634139229516;
        Wed, 13 Oct 2021 08:33:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x35sm17301351pfh.52.2021.10.13.08.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 08:33:48 -0700 (PDT)
Date:   Wed, 13 Oct 2021 15:33:44 +0000
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
Subject: Re: [PATCH Part2 v5 26/45] KVM: SVM: Mark the private vma unmerable
 for SEV-SNP guests
Message-ID: <YWb8WG6Ravbs1nbx@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-27-brijesh.singh@amd.com>
 <YWXYIWuK2T8Kejng@google.com>
 <2a8bf18e-1413-f884-15c4-0927f34ee3b9@amd.com>
 <YWbufTl2CKwJ2uzw@google.com>
 <5eb61b30-e889-2299-678f-4edeada46c2d@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eb61b30-e889-2299-678f-4edeada46c2d@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021, Brijesh Singh wrote:
> 
> On 10/13/21 7:34 AM, Sean Christopherson wrote:
> > On Wed, Oct 13, 2021, Brijesh Singh wrote:
> >> On 10/12/21 11:46 AM, Sean Christopherson wrote:
> >>> On Fri, Aug 20, 2021, Brijesh Singh wrote:
> >>>> When SEV-SNP is enabled, the guest private pages are added in the RMP
> >>>> table; while adding the pages, the rmp_make_private() unmaps the pages
> >>>> from the direct map. If KSM attempts to access those unmapped pages then
> >>>> it will trigger #PF (page-not-present).
> >>>>
> >>>> Encrypted guest pages cannot be shared between the process, so an
> >>>> userspace should not mark the region mergeable but to be safe, mark the
> >>>> process vma unmerable before adding the pages in the RMP table.
> >>> To be safe from what?  Does the !PRESENT #PF crash the kernel?
> >> Yes, kernel crashes when KSM attempts to access to an unmaped pfn.
> > Is this problem unique to nuking the direct map (patch 05), 
> 
> Yes. This problem didn't exist in previous series because we were not
> nuking the page from direct map and KSM was able to read the memory just
> fine. Now with the page removed from the direct map causes #PF
> (not-present).

Hrm, so regardless of what manipulations are done to the direct map, any errant
write to guest private memory via the direct map would be fatal to the kernel.
That's both mildly terrifying and oddly encouraging, as it means silent guest data
corruption is no longer a thing, at least for private memory.

One concrete takeaway for me is that "silently" nuking the direct map on RMP
assignment is not an option.  Nuking the direct map if the kernel has a way to
determine that the backing store is for guest private memory is perfectly ok,
but pulling the rug out so to speak is setting us up for maintenance hell.

> > or would it also be a problem (in the form of an RMP violation) if the
> > direct map were demoted to 4k pages?
> >  
> 
> No, this problem does happen due to the demotion. In previous series, we
> were demoting the pages to 4k and everyone was happy (including ksm). In
> the case of ksm, the page will *never* be merged because ciphertext for
> two private pages will never be the same. Removing the pages from direct
> map certainly brings additional complexity in the KVM and other places
> in the kernel. From architecture point of view, there is actually no
> need to mark the page *not present* in the direct map. I believe in TDX
> that is must but for the SEV-SNP its not required at all.

Nuking the direct map is not strictly required for TDX either, as reads do not
compromise the integrity of the memory, i.e. don't poison memory and lead to
#MC.  Like SNP, writes via the direct map would be fatal.

The issue with TDX that is not shared by SNP is that writes through _user_ mappings
can be fatal the system.  With SNP, those generate RMP violations, but because they
are "just" page faults, the normal uaccess machinery happily eats them and SIGBUSes
the VMM.

> A hypervisor can read the guest private pages just fine, only the write will
> cause an RMP fault.

Well, for some definitions of "read".  I'm kinda joking, kinda serious.  KSM may
"work" when it reads garbage, but the same is likely not true for other kernel
code that wanders into guest private memory.  Ideally, the kernel would provide
a mechanism to _prevent_ any such reads/writes, and violations would be treated
as kernel bugs.  Given that SEV has been successfully deployed, the probability
of lurking bugs is quite low, but I still dislike the idea of latent bugs going
unnoticed or manifesting in weird ways.
