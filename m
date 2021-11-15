Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85107452767
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 03:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244393AbhKPCYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 21:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbhKORZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 12:25:16 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C01C07978B
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 09:16:44 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id n85so15613962pfd.10
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 09:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3NVKLepWYzLSq9Cpv5qCJO3VSr1f5SzOwcseFg0x0pY=;
        b=ViN8wyNqVHdH+Hf9uZiVt6rzm1zmo2rrXKAIKjHBt08UAFUv9BJAAWNuMofRgCUGQ3
         pSvTt7NJ6bDoFBPiaYn8UdmOLOhoCBRC9mz4/pdqJcKbq7uz+rJ0AQkNnz+4KO1DLs0Q
         HU5a5hhkU5p7C2S0n9dF5y8Mk3j+BCuMBOIblS2P7zdESzvV5Y9HVMDTDykC83v6Qk0i
         Fn1IMf5XPZ/ppn+OHgMAEheBtO3CvwWvP5wks+OYQAmdJn6WqO2qeWGXP1DoUiP3tBIj
         0bYE43Iqf38tJRkO+DgbWI4wdtkRUx2Mf6ROzMGAY9Pa79Spx5521xjH6LTLH67cXDFl
         LNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3NVKLepWYzLSq9Cpv5qCJO3VSr1f5SzOwcseFg0x0pY=;
        b=13m5TKevevtEoKwz5GSkZJqQcsDEfehm2YN76tg8Io285dRy5SI3x3iM84GprOOuLj
         D0kgzHA3+0k9Rejr/aD+ccod3j39ugPZCqlkdlrQHQnGnN2+OfpIy8yAhGw/Mg6zI8Le
         x1lTjdxLxdJCtPff+LlrK6j2uiQZXf5XqrNWLagj/JzCDDlFYvHoHSv3Q2BTA/l7USsB
         lWaAqPphiQ43DcLYEUC0rBiZiYm8MjgUlzswxcAWfg5JQksA5KctGe6Tt23IOp3LPI5U
         kSUCUvoqAJTHqwlVbmlhpqn40OloFf1X3cU/lKCfCPQcox0C7tUq4g+RHAKd0hCvRCv6
         2B+w==
X-Gm-Message-State: AOAM531hfj0WL9LMbC9lCUl9dfI+y/OkapyOaV2JCNZzto9pHh/FAJEC
        5rahNgvDy8p00nJSDxdiQHr8bA==
X-Google-Smtp-Source: ABdhPJyKc9UQWUIc7Wr3sPqTISPItmNSDSwgcqkezQohZCsJMhsK1Nvfuw30uGNo+HWmOQFuW461xA==
X-Received: by 2002:a63:4d3:: with SMTP id 202mr328555pge.36.1636996603928;
        Mon, 15 Nov 2021 09:16:43 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o28sm3060761pgn.85.2021.11.15.09.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:16:43 -0800 (PST)
Date:   Mon, 15 Nov 2021 17:16:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Orr <marcorr@google.com>
Cc:     Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>,
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
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZKV9zo25l3LKahi@google.com>
References: <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com>
 <YY7USItsMPNbuSSG@zn.tnic>
 <CAMkAt6o909yYq3NfRboF3U3V8k-2XGb9p_WcQuvSjOKokmMzMA@mail.gmail.com>
 <YY8AJnMo9nh3tyPB@google.com>
 <CAA03e5G=fY7_qESCuoHW3_VdVbDWekqQxmvLPzWNepBqJjyCXg@mail.gmail.com>
 <YZAFTBXtC/yS7xtq@google.com>
 <CAA03e5Hhmji-uhv4eh4cgyu0XBf9=C5r8MtGtWcB480eaVGvSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5Hhmji-uhv4eh4cgyu0XBf9=C5r8MtGtWcB480eaVGvSg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 13, 2021, Marc Orr wrote:
> On Sat, Nov 13, 2021 at 10:35 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Nov 12, 2021, Marc Orr wrote:
> > > > > > If *it* is the host kernel, then you probably shouldn't do that -
> > > > > > otherwise you just killed the host kernel on which all those guests are
> > > > > > running.
> > > > >
> > > > > I agree, it seems better to terminate the single guest with an issue.
> > > > > Rather than killing the host (and therefore all guests). So I'd
> > > > > suggest even in this case we do the 'convert to shared' approach or
> > > > > just outright terminate the guest.
> > > > >
> > > > > Are there already examples in KVM of a KVM bug in servicing a VM's
> > > > > request results in a BUG/panic/oops? That seems not ideal ever.
> > > >
> > > > Plenty of examples.  kvm_spurious_fault() is the obvious one.  Any NULL pointer
> > > > deref will lead to a BUG, etc...  And it's not just KVM, e.g. it's possible, if
> > > > unlikely, for the core kernel to run into guest private memory (e.g. if the kernel
> > > > botches an RMP change), and if that happens there's no guarantee that the kernel
> > > > can recover.
> > > >
> > > > I fully agree that ideally KVM would have a better sense of self-preservation,
> > > > but IMO that's an orthogonal discussion.
> > >
> > > I don't think we should treat the possibility of crashing the host
> > > with live VMs nonchalantly. It's a big deal. Doing so has big
> > > implications on the probability that any cloud vendor wil bee able to
> > > deploy this code to production. And aren't cloud vendors one of the
> > > main use cases for all of this confidential compute stuff? I'm
> > > honestly surprised that so many people are OK with crashing the host.
> >
> > I'm not treating it nonchalantly, merely acknowledging that (a) some flavors of kernel
> > bugs (or hardware issues!) are inherently fatal to the system, and (b) crashing the
> > host may be preferable to continuing on in certain cases, e.g. if continuing on has a
> > high probablity of corrupting guest data.
> 
> I disagree. Crashing the host -- and _ALL_ of its VMs (including
> non-confidential VMs) -- is not preferable to crashing a single SNP
> VM.

We're in violent agreement.  I fully agree that, when allowed by the architecture,
injecting an error into the guest is preferable to killing the VM, which is in turn
preferable to crashing the host.

What I'm saying is that there are classes of bugs where injecting an error is not
allowed/feasible, and where killing an individual VM is not correct/feasible.

The canonical example of this escalating behavior is an uncorrectable ECC #MC.  If
the bad page is guest memory and the guest vCPU model supports MCA, then userspace
can inject an #MC into the guest so that the guest can take action and hopefully
not simply die.  If the bad page is in the guest but the guest doesn't support #MC
injection, the guest effectively gets killed.  And if the #MC is in host kernel
memory that can't be offlined, e.g. hits the IDT, then the whole system comes
crashing down.

> Especially when that SNP VM is guaranteed to detect the memory corruption and
> react accordingly.

For the record, we can make no such guarantees about the SNP VM.  Yes, the VM
_should_ do the right thing when handed a #VC, but bugs happen, otherwise we
wouldn't be having this discussion.
