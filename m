Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F29451D7E
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 01:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349192AbhKPAai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 19:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346132AbhKOT36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:29:58 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91151C04C34F
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 11:15:12 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u11so15330663plf.3
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 11:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y6OLQ3pmyLU/AZ8mF6RNILhOeEW50lkatnqGQxIhBPM=;
        b=NE9Q7X3JQ8LUyUWzz9DeIgL8OoW6QfsSl8vnkAy3xBAwWAiJcKASkCUUxhcuo6wGyj
         z0tTg0V02jsjXd11PJgj5pF2sV6adXai4Cr/YnvZX6P2JywIyZqrgMvIK1o4b4n3CR4U
         kb1rRvSa9srpZSUM73KrRPAW7WF63brJAF7P+m9rZj00jlEp1gmZnXael/2ixsugtcfF
         5ypgZuP4pQNZdnFB+tzrTmgfKrUWEuMx2G8v8dc03lWFP5lJXYJ/csad9Fg7klPM3GOB
         tMQ6yZKMaygcUZXi1oP+i64HY5Cs9C48DJy9vo9/LqSUFte0HE75KGuv45yY5HXtL2KK
         KeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y6OLQ3pmyLU/AZ8mF6RNILhOeEW50lkatnqGQxIhBPM=;
        b=ylVPYCzhbP25GaWM0ZjqRGeCR0ZEfKR1t6QF2yAtbET/2CSjgjW2g6ecorfFA+zL6V
         LxpxV378BJkigqnw65pGk0lBJih6Vw7pZ4oHN8jXjmRYW5zrD2EEe29GTi+oMa63ybld
         +1bviWk6HFGqV5NdE9niVpyrHhiJrpskI9VPX4ATnHsubQVleFglnsYPu5IhdWYg9wcs
         x0jgSIz36K2rIuAvNswL5brAqnyic9gItWiOEEckFU26lVJ6gsR2hgpyVBBVu/Sr52In
         mF0O/fAO8J+tjuUB+E8cc+7qSig9EZcI4bN61Sc80rK5+nWIMh+L8gIGZ/K1mGyo1pGi
         lW7w==
X-Gm-Message-State: AOAM530wwRZ7hhv3ujCmoQpNqq0LUq7PfzM+vQThpP7/db/BfOpPUTt0
        zeAhWjsj9/xc8CiB5YzvfWXg6A==
X-Google-Smtp-Source: ABdhPJwIFe7bp49F+hbCo4lJVLh4GeyP1ulE3zxQubU+9fPyf7wjxXFI+ZxzYa7IzMeEdwHA9OfIBA==
X-Received: by 2002:a17:902:f24a:b0:141:c6fc:2e18 with SMTP id j10-20020a170902f24a00b00141c6fc2e18mr38537915plc.55.1637003711772;
        Mon, 15 Nov 2021 11:15:11 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h10sm17329094pfc.104.2021.11.15.11.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:15:11 -0800 (PST)
Date:   Mon, 15 Nov 2021 19:15:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Orr <marcorr@google.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
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
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZKxuxZurFW6BVZJ@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YZJTA1NyLCmVtGtY@work-vm>
 <YZKmSDQJgCcR06nE@google.com>
 <CAA03e5E3Rvx0t8_ZrbNMZwBkjPivGKOg5HCShSFYwfkKDDHWtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5E3Rvx0t8_ZrbNMZwBkjPivGKOg5HCShSFYwfkKDDHWtA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+arm64 KVM folks

On Mon, Nov 15, 2021, Marc Orr wrote:
> On Mon, Nov 15, 2021 at 10:26 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Nov 15, 2021, Dr. David Alan Gilbert wrote:
> > > * Sean Christopherson (seanjc@google.com) wrote:
> > > > On Fri, Nov 12, 2021, Borislav Petkov wrote:
> > > > > On Fri, Nov 12, 2021 at 09:59:46AM -0800, Dave Hansen wrote:
> > > > > > Or, is there some mechanism that prevent guest-private memory from being
> > > > > > accessed in random host kernel code?
> > > >
> > > > Or random host userspace code...
> > > >
> > > > > So I'm currently under the impression that random host->guest accesses
> > > > > should not happen if not previously agreed upon by both.
> > > >
> > > > Key word "should".
> > > >
> > > > > Because, as explained on IRC, if host touches a private guest page,
> > > > > whatever the host does to that page, the next time the guest runs, it'll
> > > > > get a #VC where it will see that that page doesn't belong to it anymore
> > > > > and then, out of paranoia, it will simply terminate to protect itself.
> > > > >
> > > > > So cloud providers should have an interest to prevent such random stray
> > > > > accesses if they wanna have guests. :)
> > > >
> > > > Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.
> > >
> > > Would it necessarily have been a host bug?  A guest telling the host a
> > > bad GPA to DMA into would trigger this wouldn't it?
> >
> > No, because as Andy pointed out, host userspace must already guard against a bad
> > GPA, i.e. this is just a variant of the guest telling the host to DMA to a GPA
> > that is completely bogus.  The shared vs. private behavior just means that when
> > host userspace is doing a GPA=>HVA lookup, it needs to incorporate the "shared"
> > state of the GPA.  If the host goes and DMAs into the completely wrong HVA=>PFN,
> > then that is a host bug; that the bug happened to be exploited by a buggy/malicious
> > guest doesn't change the fact that the host messed up.
> 
> "If the host goes and DMAs into the completely wrong HVA=>PFN, then
> that is a host bug; that the bug happened to be exploited by a
> buggy/malicious guest doesn't change the fact that the host messed
> up."
> ^^^
> Again, I'm flabbergasted that you are arguing that it's OK for a guest
> to exploit a host bug to take down host-side processes or the host
> itself, either of which could bring down all other VMs on the machine.
> 
> I'm going to repeat -- this is not OK! Period.

Huh?  At which point did I suggest it's ok to ship software with bugs?  Of course
it's not ok to introduce host bugs that let the guest crash the host (or host
processes).  But _if_ someone does ship buggy host software, it's not like we can
wave a magic wand and stop the guest from exploiting the bug.  That's why they're
such a big deal.

Yes, in this case a very specific flavor of host userspace bug could be morphed
into a guest exception, but as mentioned ad nauseum, _if_ host userspace has bug
where it does not properly validate a GPA=>HVA, then any such bug exists and is
exploitable today irrespective of SNP.

> Again, if the community wants to layer some orchestration scheme
> between host userspace, host kernel, and guest, on top of the code to
> inject the #VC into the guest, that's fine. This proposal is not
> stopping that. In fact, the two approaches are completely orthogonal
> and compatible.
> 
> But so far I have heard zero reasons why injecting a #VC into the
> guest is wrong. Other than just stating that it's wrong.

It creates a new attack surface, e.g. if the guest mishandles the #VC and does
PVALIDATE on memory that it previously accepted, then userspace can attack the
guest by accessing guest private memory to coerce the guest into consuming corrupted
data.

> Again, the guest must be able to detect buggy and malicious host-side
> writes to private memory. Or else "confidential computing" doesn't
> work.

That assertion assumes the host _hypervisor_ is untrusted, which does not hold true
for all use cases.  The Cc'd arm64 folks are working on a protected VM model where
the host kernel at large is untrusted, but the "hypervisor" (KVM plus a few other
bits), is still trusted by the guest.  Because the hypervisor is trusted, the guest
doesn't need to be hardened against event injection attacks from the host.

Note, SNP already has a similar concept in it's VMPLs.  VMPL3 runs a confidential VM
that is not hardened in any way, and fully trusts VMPL0 to not inject bogus faults.

And along the lines of arm64's pKVM, I would very much like to get KVM to a point
where it can remove host userspace from the guest's TCB without relying on hardware.
Anything that can be in hardware absolutely can be done in the kernel, and likely
can be done with significantly less performance overhead.  Confidential computing is
not a binary thing where the only valid use case is removing the host kernel from
the TCB and trusting only hardware.  There are undoubtedly use cases where trusting
the host kernel but not host userspace brings tangible value, but the overhead of
TDX/SNP to get the host kernel out of the TCB is the wrong tradeoff for performance
vs. security.

> Assuming that's not true is not a valid argument to dismiss
> injecting a #VC exception into the guest.
