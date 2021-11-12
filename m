Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C969944EE63
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 22:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbhKLVPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 16:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235668AbhKLVPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 16:15:24 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0E5C061767
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 13:12:32 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id b40so25398432lfv.10
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 13:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dn+bcXMxMVbConI0dzzOMHuL8/svkzu+Wwj+qbiR4x8=;
        b=EdzZWhK+twSP8CvwCQlYnN86NLSH4z6uOIKjsX+ieqtsfgIe6iwn4m5q/+wYMjmvo6
         062jaDfetxnssAtPg2E/mW7NYDChxtGhOUICnrA7EEJ9XXAMCppnsFgGyZmfJ/yKdjLs
         s2Z32/7worYPlLhueFmEQv5FTZV6YFWp1RMdOwWJEb/Bb6W+jZgQ6g7FWwJj9uSLrdaQ
         YBa2H5x5he1yz1h5IuS5JWT8EBlkiVVwdHu6BBUI4yLYa/pa4GYqIL4LegYmg1IyiLJG
         p3kAsDZK8tDm9KQPdFVvoor0H2zgZJMx9Rw01hfOViR7D8pDtJO5Uvmdy3AlsAooISbU
         9zaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dn+bcXMxMVbConI0dzzOMHuL8/svkzu+Wwj+qbiR4x8=;
        b=ABFGO+zo1qoxQENcEDQiBnxLgET1qI1O4U1h4Rs2FYNsJCsJTnoyoH0g1y0SoRrMKR
         9CB9/PxyP0vZxBLlzHQzoKXgsSjKmmgpotPxblpNQnVyX00puhwB8IX8L92crQWCA4v1
         rUkI4bNRZXEtWfh98rMvX21R4/bZaiTfQqePP22QGMAxG48ZDcy8M9bFPl2LP4crh1G1
         1yYBnU0I3LeLOWsELTXH7ZUNDVWZO/dhl7g44Du9u8JeTwgdJaZnOmsHC1S4KMVahELS
         CeTvQJvIjT0aLQyWe+rBySxF1afQb0WseulS8ByJ3US1JQZpaiuhAB5AqnH+rpsYHMK3
         afmw==
X-Gm-Message-State: AOAM530Ela/47J84+Ng/9nNqaPR/TC6yfaUBHhtiegVnJMKgVW3SqF2e
        KE3UqkLTg6tKLraQfTkXAzGMHoy6R0AE7dlWknYssA==
X-Google-Smtp-Source: ABdhPJx0zv9oZiVhO/YNxkJ7L7PIPrKlq6CA5xheWOUfHI/cpWmE7wF5mKEaWrnaVRWPNR0426TS6C177SQB4l0qALk=
X-Received: by 2002:a05:6512:39c4:: with SMTP id k4mr15332635lfu.79.1636751550683;
 Fri, 12 Nov 2021 13:12:30 -0800 (PST)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YY7I6sgqIPubTrtA@zn.tnic> <YY7Qp8c/gTD1rT86@google.com>
 <YY7USItsMPNbuSSG@zn.tnic>
In-Reply-To: <YY7USItsMPNbuSSG@zn.tnic>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 12 Nov 2021 14:12:19 -0700
Message-ID: <CAMkAt6o909yYq3NfRboF3U3V8k-2XGb9p_WcQuvSjOKokmMzMA@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 1:55 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Fri, Nov 12, 2021 at 08:37:59PM +0000, Sean Christopherson wrote:
> > Let userspace decide what is mapped shared and what is mapped private.
>
> With "userspace", you mean the *host* userspace?
>
> > The kernel and KVM provide the APIs/infrastructure to do the actual
> > conversions in a thread-safe fashion and also to enforce the current
> > state, but userspace is the control plane.
> >
> > It would require non-trivial changes in userspace if there are multiple processes
> > accessing guest memory, e.g. Peter's networking daemon example, but it _is_ fully
> > solvable.  The exit to userspace means all three components (guest, kernel,
> > and userspace) have full knowledge of what is shared and what is private.  There
> > is zero ambiguity:
> >
> >   - if userspace accesses guest private memory, it gets SIGSEGV or whatever.
>
> That SIGSEGV is generated by the host kernel, I presume, after it checks
> whether the memory belongs to the guest?
>
> >   - if kernel accesses guest private memory, it does BUG/panic/oops[*]
>
> If *it* is the host kernel, then you probably shouldn't do that -
> otherwise you just killed the host kernel on which all those guests are
> running.

I agree, it seems better to terminate the single guest with an issue.
Rather than killing the host (and therefore all guests). So I'd
suggest even in this case we do the 'convert to shared' approach or
just outright terminate the guest.

Are there already examples in KVM of a KVM bug in servicing a VM's
request results in a BUG/panic/oops? That seems not ideal ever.

>
> >   - if guest accesses memory with the incorrect C/SHARED-bit, it gets killed.
>
> Yah, that's the easy one.
>
> > This is the direction KVM TDX support is headed, though it's obviously still a WIP.
> >
> > And ideally, to avoid implicit conversions at any level, hardware vendors' ABIs
> > define that:
> >
> >   a) All convertible memory, i.e. RAM, starts as private.
> >   b) Conversions between private and shared must be done via explicit hypercall.
>
> I like the explicit nature of this but devil's in the detail and I'm no
> virt guy...

This seems like a reasonable approach that can help with the issue of
terminating the entity behaving poorly. Could this feature be an
improvement that comes later? This improvement could be gated behind a
per VM KVM CAP, a kvm module param, or insert other solution here, to
not blind side userspace with this change?

>
> > Without (b), userspace and thus KVM have to treat guest accesses to the incorrect
> > type as implicit conversions.
> >
> > [*] Sadly, fully preventing kernel access to guest private is not possible with
> >     TDX, especially if the direct map is left intact.  But maybe in the future
> >     TDX will signal a fault instead of poisoning memory and leaving a #MC mine.
>
> Yah, the #MC thing sounds like someone didn't think things through. ;-\

Yes #MC in TDX seems much harder to deal with than the #PF for SNP.
I'd propose TDX keeps the host kernel safe bug not have that solution
block SNP. As suggested above I like the idea but it seems like it can
come as a future improvement to SNP support.

>
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
