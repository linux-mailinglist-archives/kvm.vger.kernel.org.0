Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512EA44F48D
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 19:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbhKMSbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Nov 2021 13:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235988AbhKMSbO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Nov 2021 13:31:14 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7923EC061767
        for <kvm@vger.kernel.org>; Sat, 13 Nov 2021 10:28:22 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 188so10847060pgb.7
        for <kvm@vger.kernel.org>; Sat, 13 Nov 2021 10:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5Ycmt8tegHM9+iX2tw5kVKKQzYyX28cv7Zc0okImoEE=;
        b=S0fC6nUpGsYzMDkH2fwRs2kslWGsA0ZT433CI4HTX9RKW5R96rXkcQ/0Zyd00TxgsA
         3JKbKipk4vpz56yCcFNbQIuQqjsCczhrMCYx00uSOjXMxpUjSj60DkNqZl/Yb225PSb1
         ShrqJF6fxpJ5JQxJQ9HImAZL1hsIkrWX/d0+TBsWu80+W91/3jdRmWD8pieJYmU5r9jr
         uAvF4Qcy0159z4xAvQagHfO2T4J4m+CDLVYDN+KmSL7qR6s06QYrglpM4qsrqLdlkY2M
         GkaQeb87LHzjh3U0dSuftpxx1AU4Vhurn/wCS3UhRblDyYA0/UZuZzO8jmOr4uRfUC7P
         iLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5Ycmt8tegHM9+iX2tw5kVKKQzYyX28cv7Zc0okImoEE=;
        b=j0uGoJKmAvcYu/r4pgILaCsHFq1wgieuUUGbdH5eUBUzeVJHNrpyEVBbGg+f+PcFmX
         mDjVWT2wnBjoaO3At/K7XoE7EIEk2164bSxutQRT/MeHN9ozqgYJV/R7z0mhlJRfID2p
         vLDIktpdfzVqgYbb5puTN7Q0qfdV2wuSEnK/J2+V8UrCfokx6WyB8NmfoY2xTet0eQaG
         ViJu0TYC9DAEbvAO/P1bfI53t63Bm+TApfKABJ9yjND20ioUOl52n9xWFcK/PsXWpLXY
         LiUuh+aEEJ3PTCqCrgtk6vigiiLf45SIKTc3t81ujaxNOAShyhyGaPnwlI6nybTjQCR5
         LANQ==
X-Gm-Message-State: AOAM530yArE7QuTdh4xEwjd6hPprJtJb2XzyP1abHd307myna9Qfe1uE
        wSmpN/+WqCGq1+yKA5nx2Oi1uA==
X-Google-Smtp-Source: ABdhPJwd0lZ9M5eG7/pjsaMsb0UCHSKrCM/hqTbMkiLkRbr2swjCDNY5Edw8/HsS2qWXhggajuV/kw==
X-Received: by 2002:a62:1b86:0:b0:47b:d112:96d4 with SMTP id b128-20020a621b86000000b0047bd11296d4mr22281236pfb.52.1636828101667;
        Sat, 13 Nov 2021 10:28:21 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z13sm10074099pfg.36.2021.11.13.10.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 10:28:20 -0800 (PST)
Date:   Sat, 13 Nov 2021 18:28:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Orr <marcorr@google.com>
Cc:     Peter Gonda <pgonda@google.com>, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZADwHxsx5cZ6m47@google.com>
References: <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com>
 <CAA03e5GwHMPYHHq3Nkkq1HnEJUUsw-Vk+5wFCott3pmJY7WuAw@mail.gmail.com>
 <2cb3217b-8af5-4349-b59f-ca4a3703a01a@www.fastmail.com>
 <CAA03e5Fw9cRnb=+eJmzEB+0QmdgaGZ7=fPTUYx7f55mGVXLRMA@mail.gmail.com>
 <CAMkAt6q9Wsw_KYypyZxhA1gkd=kFepk5rC5QeZ6Vo==P6=EAxg@mail.gmail.com>
 <YY8Mi36N/e4PzGP0@google.com>
 <CAA03e5F=7T3TcJBksiJ9ovafX65YfzAc0S+uYu5LjfTQ60yC7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5F=7T3TcJBksiJ9ovafX65YfzAc0S+uYu5LjfTQ60yC7w@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021, Marc Orr wrote:
> On Fri, Nov 12, 2021 at 4:53 PM Sean Christopherson <seanjc@google.com> wrote:
> > On Fri, Nov 12, 2021, Peter Gonda wrote:
> > > Having a way for userspace to lock pages as shared was an idea I just
> > > proposed the simplest solution to start the conversation.
> >
> > Assuming you meant that to read:
> >
> >   Having a way for userspace to lock pages as shared is an alternative idea; I
> >   just proposed the simplest solution to start the conversation.
> >
> > The unmapping[*] guest private memory proposal is essentially that, a way for userspace
> > to "lock" the state of a page by requiring all conversions to be initiated by userspace
> > and by providing APIs to associate a pfn 1:1 with a KVM instance, i.e. lock a pfn to
> > a guest.
> >
> > Andy's DMA example brings up a very good point though.  If the shared and private
> > variants of a given GPA are _not_ required to point at a single PFN, which is the
> > case in the current unmapping proposal, userspace doesn't need to do any additional
> > juggling to track guest conversions across multiple processes.
> >
> > Any process that's accessing guest (shared!) memory simply does its locking as normal,
> > which as Andy pointed out, is needed for correctness today.  If the guest requests a
> > conversion from shared=>private without first ensuring the gfn is unused (by a host
> > "device"), the host will side will continue accessing the old, shared memory, which it
> > locked, while the guest will be doing who knows what.  And if the guest provides a GPA
> > that isn't mapped shared in the VMM's address space, it's conceptually no different
> > than if the guest provided a completely bogus GPA, which again needs to be handled today.
> >
> > In other words, if done properly, differentiating private from shared shouldn't be a
> > heavy lift for host userspace.
> >
> > [*] Actually unmapping memory may not be strictly necessary for SNP because a
> >     #PF(RMP) is likely just as good as a #PF(!PRESENT) when both are treated as
> >     fatal, but the rest of the proposal that allows KVM to understand the stage
> >     of a page and exit to userspace accordingly applies.
> 
> Thanks for this explanation. When you write "while the guest will be
> doing who knows what":
> 
> Isn't that a large weakness of this proposal? To me, it seems better
> for debuggability to corrupt the private memory (i.e., convert the
> page to shared) so the guest can detect the issue via a PVALIDATE
> failure.

The behavior is no different than it is today for regular VMs.

> The main issue I see with corrupting the guest memory is that we may
> not know whether the host is at fault or the guest.

Yes, one issue is that bugs in the host will result in downstream errors in the
guest, as opposed to immediate, synchronous detection in the guest.  IMO that is
a significant flaw.

Another issue is that the host kernel, which despite being "untrusted", absolutely
should be acting in the best interests of the guest.  Allowing userspace to inject
#VC, e.g. to attempt to attack the guest by triggering a spurious PVALIDATE, means
the kernel is failing miserably on that front.
