Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C6844F04F
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 01:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbhKMA42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 19:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235168AbhKMA41 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 19:56:27 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0F3C0613F5
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 16:53:36 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id v20so9750724plo.7
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 16:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K0ej+1tfThZ98QHdCkt5YQB5r/oSm3/M9hAu6wXCK3U=;
        b=pQew5/HXAnO8TXdgTdtaTK36LBnEF12hxJvzN5pABi2kpGIwdP0jSSYCyOaDFbqs6t
         bwKAugb0mq4C8boLMRoGPo/eficKE+A1dS2ELJ3rbRBCIEoqskUK6pb7xBKsSUaqMuD2
         OBdEVbYxwv0wuphazwB+sjYizVyaVYqt+wv/NVYFUAevjGsJC5qS0p6UD0z26mJhPN/w
         Jfcz6+V2TMsIkfuCPNpshKpBU8GkVMeAaQlGvf/pZhVWc85pyMndF1HZ7gd70OPakshN
         WrrHW1ILeczlxTQ1xV4SVMUlFtnOKABW6qeH567/akB/5B9ThfR6VIOS8kZgPVxwH0z9
         Bcdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K0ej+1tfThZ98QHdCkt5YQB5r/oSm3/M9hAu6wXCK3U=;
        b=Y7yoiIHZm8LGx+qdTZtYvlcvd4T/gh1ytR8nJ0ZSvfosuvWFXhdJZFirFFjE2xqgO4
         Co+EO+sbzomDW1TigNf7iLoUOw0fXEe26RQdk0kXHflV0DBFlaeB+egTR//GJ3miOvO/
         1wmg9SJrm3Uuh9Gh547QOluMdwOlVrZuC4Wd+DJ6fj0YAyAPYUL1AaR5HZ4X4RV4fAfJ
         5BRD4Zxvw3ZONKkR597L9Qw8/ewWL2FzTKOLP0F9quJQUJ4WGzrnDT8n/43Lfqr159pV
         yRmkq8JrxcwuCxkToFp+KEjAmHJxB6fAniNIC1CrZiVsE9KOn5A0bBw1eta9GeghL5Du
         ZPeg==
X-Gm-Message-State: AOAM532O2FA4BitGg8qj03kgjGYuZ6A6Kc2SyUMIkG5UI86P3sxJ9/Lt
        xLdNf47A9TTLdgLghmCdrMDiMw==
X-Google-Smtp-Source: ABdhPJzvaH9/WtuKy8InOeWLfYciuK7YuNRtWO721BjQxWRj8KMrcbTnMuwbW71a1EwS+pwmgFUfDw==
X-Received: by 2002:a17:90a:e005:: with SMTP id u5mr41085100pjy.17.1636764816001;
        Fri, 12 Nov 2021 16:53:36 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n7sm7518229pfd.37.2021.11.12.16.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 16:53:35 -0800 (PST)
Date:   Sat, 13 Nov 2021 00:53:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     Marc Orr <marcorr@google.com>, Andy Lutomirski <luto@kernel.org>,
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
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YY8Mi36N/e4PzGP0@google.com>
References: <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com>
 <CAA03e5GwHMPYHHq3Nkkq1HnEJUUsw-Vk+5wFCott3pmJY7WuAw@mail.gmail.com>
 <2cb3217b-8af5-4349-b59f-ca4a3703a01a@www.fastmail.com>
 <CAA03e5Fw9cRnb=+eJmzEB+0QmdgaGZ7=fPTUYx7f55mGVXLRMA@mail.gmail.com>
 <CAMkAt6q9Wsw_KYypyZxhA1gkd=kFepk5rC5QeZ6Vo==P6=EAxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6q9Wsw_KYypyZxhA1gkd=kFepk5rC5QeZ6Vo==P6=EAxg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021, Peter Gonda wrote:
> On Fri, Nov 12, 2021 at 2:43 PM Marc Orr <marcorr@google.com> wrote:
> >
> > On Fri, Nov 12, 2021 at 1:39 PM Andy Lutomirski <luto@kernel.org> wrote:
> > > Let's consider a very very similar scenario: consider a guest driver
> > > setting up a 1 GB DMA buffer.  The virtual device, implemented as host
> > > process, needs to (1) map (and thus lock *or* be prepared for faults) in
> > > 1GB / 4k pages of guest memory (so they're not *freed* while the DMA
> > > write is taking place), (2) write the buffer, and (3) unlock all the
> > > pages.  Or it can lock them at setup time and keep them locked for a long
> > > time if that's appropriate.
> > >
> > > Sure, the locking is expensive, but it's nonnegotiable.  The RMP issue is
> > > just a special case of the more general issue that the host MUST NOT
> > > ACCESS GUEST MEMORY AFTER IT'S FREED.
> >
> > Good point.
> 
> Thanks for the responses Andy.
> 
> Having a way for userspace to lock pages as shared was an idea I just
> proposed the simplest solution to start the conversation.

Assuming you meant that to read:

  Having a way for userspace to lock pages as shared is an alternative idea; I
  just proposed the simplest solution to start the conversation.

The unmapping[*] guest private memory proposal is essentially that, a way for userspace
to "lock" the state of a page by requiring all conversions to be initiated by userspace
and by providing APIs to associate a pfn 1:1 with a KVM instance, i.e. lock a pfn to
a guest.

Andy's DMA example brings up a very good point though.  If the shared and private
variants of a given GPA are _not_ required to point at a single PFN, which is the
case in the current unmapping proposal, userspace doesn't need to do any additional
juggling to track guest conversions across multiple processes.

Any process that's accessing guest (shared!) memory simply does its locking as normal,
which as Andy pointed out, is needed for correctness today.  If the guest requests a
conversion from shared=>private without first ensuring the gfn is unused (by a host
"device"), the host will side will continue accessing the old, shared memory, which it
locked, while the guest will be doing who knows what.  And if the guest provides a GPA
that isn't mapped shared in the VMM's address space, it's conceptually no different
than if the guest provided a completely bogus GPA, which again needs to be handled today.

In other words, if done properly, differentiating private from shared shouldn't be a
heavy lift for host userspace.

[*] Actually unmapping memory may not be strictly necessary for SNP because a
    #PF(RMP) is likely just as good as a #PF(!PRESENT) when both are treated as
    fatal, but the rest of the proposal that allows KVM to understand the stage
    of a page and exit to userspace accordingly applies.

