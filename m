Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCEC453AB3
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhKPUMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240263AbhKPUMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:12:06 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B193C06120E
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:08:55 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 28so139252pgq.8
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dT6i/qZSkcfW3Sm2DrxjWBtaFkbKPAwDsa4TWP0ZGP8=;
        b=c3xWLP/kE/cbpxDROR/8A7dsnqGQXPN3XeRoShkWVLrHb+Oxk7cq2G++jOqgeqAvsR
         J+BB2FX6ObPHnRRpf4A4w/MOe3aTWYo0JRvjghCEphalnXusUchV6X5YQ79mAT5bSZQN
         r0nCJTqAfsKTRVWa3TIX2JclEvqgMRqFyd0j2C1DcZcax55ibCUo1EizAosO8HhUURnC
         CK7XmEEub08KDSrI5qBq0PaXGKrzTK2bP51TA7Fyhs9elcpRUkAkZyeujc27qAioKQa7
         9lRyz5K27tgIHNUIWpK2qsPaEXWe5IGAtzV1dWGZJ2TTpqvE3Zn3AlMNimL8lclJblGr
         gPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dT6i/qZSkcfW3Sm2DrxjWBtaFkbKPAwDsa4TWP0ZGP8=;
        b=S+RY6+HRpFGfkQbmoBTrxztPVLSEQuaYuIs0lyrDk4gkj2ZPiZEOZ6+XM5cCzyg1RW
         dYi+V55viYynM3WBl74bEo/UKzjivuiIpE7MQW9IXFJmguDoMBSdR5Mh27dAcgw3U8wv
         CgEYavovRD9kcXEDM7F18wORNvZVm6dqI6RmxgtZ1FkavIkGQ7k6BzO7qaM1DPNJBoJ3
         dyiYIlQyUPYOhc2QmHNdpoQ9Q3VXKFe93NJ5oDleyysZ2kQSuwsEFTZ2iPzZs8G5O1Ui
         gguOvA5Q1PIOtAHiw7SDvKc8ld8voI3547iMqPJ2sYafZEbxKMY5xdnrUIsQXHdUh9F3
         pV6Q==
X-Gm-Message-State: AOAM533SaprayjjrTZbSfIl/yq2iplDiDcA4lzS8pqwXeqfJ59OvV3fI
        V211QuXmrUUgM37pd0yBT38QOg==
X-Google-Smtp-Source: ABdhPJwBsN8U5Krw60xMJJqILBkH8X4VC7je13qIK/kdw/gzDDAA9hIvMF8G/O1BR5V196/SpLhoWQ==
X-Received: by 2002:a63:354:: with SMTP id 81mr1203571pgd.364.1637093334058;
        Tue, 16 Nov 2021 12:08:54 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g21sm20130074pfc.95.2021.11.16.12.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 12:08:53 -0800 (PST)
Date:   Tue, 16 Nov 2021 20:08:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZQP0T5vMiQ/MUOX@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YZJTA1NyLCmVtGtY@work-vm>
 <YZKmSDQJgCcR06nE@google.com>
 <YZOrziJfGWHnBh++@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZOrziJfGWHnBh++@suse.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021, Joerg Roedel wrote:
> On Mon, Nov 15, 2021 at 06:26:16PM +0000, Sean Christopherson wrote:
> > No, because as Andy pointed out, host userspace must already guard against a bad
> > GPA, i.e. this is just a variant of the guest telling the host to DMA to a GPA
> > that is completely bogus.  The shared vs. private behavior just means that when
> > host userspace is doing a GPA=>HVA lookup, it needs to incorporate the "shared"
> > state of the GPA.  If the host goes and DMAs into the completely wrong HVA=>PFN,
> > then that is a host bug; that the bug happened to be exploited by a buggy/malicious
> > guest doesn't change the fact that the host messed up.
> 
> The thing is that the usual checking mechanisms can't be applied to
> guest-private pages. For user-space the GPA is valid if it fits into the
> guest memory layout user-space set up before. But whether a page is
> shared or private is the guests business.

And that's where we fundamentally disagree.  Whether a page is shared or private
is very much the host's business.  The guest can _ask_ to convert a page, but the
host ultimately owns the state of a page.  Even in this proposed auto-convert
approach, the host has final say over the state of the page.

The main difference between auto-converting in the #PF handler and an unmapping
approach is that, as you note below, the latter requires an explicit action from
host userspace.  But again, the host kernel has final say over the state of any
given page.

> And without an expensive reporting/query mechanism user-space doesn't have the
> information to do the check.

The cost of exiting to userspace isn't all that expensive relative to the cost of
the RMP update itself, e.g. IIRC updating the RMP is several thousand cycles.
TDX will have a similar cost to modify S-EPT entries.

Actually updating the backing store (see below) might be relatively expensive, but
I highly doubt it will be orders of magnitude slower than updating the RMP, or that
it will have a meaningful impact on guest performance.

> A mechanism to lock pages to shared is also needed, and that creates the
> next problems:

The most recent proposal for unmapping guest private memory doesn't require new
locking at the page level.  The high level idea is to treat shared and private
variations of GPAs as two unrelated addresses from a host memory management
perspective.  They are only a "single" address in the context of KVM's MMU, i.e.
the NPT for SNP.

For shared pages, no new locking is required as the PFN associated with a VMA will
not be freed until all mappings go away.  Any access after all mappings/references
have been dropped is a nothing more than a use-after-free bug, and the guilty party
is punished accordingly.

For private pages, the proposed idea is to require that all guest private memory
be backed by an elightened backing store, e.g. the initial RFC enhances memfd and
shmem to support sealing the file as guest-only:

  : The new seal is only allowed if there's no pre-existing pages in the fd
  : and there's no existing mapping of the file. After the seal is set, no
  : read/write/mmap from userspace is allowed.

It is KVM's responsibility to ensure it doesn't map a shared PFN into a private
GPA and vice versa, and that TDP entries are unmapped appropriately, e.g. when
userspace punches a hole in the backing store, but that can all be done using
existing locks, e.g. KVM's mmu_lock.  No new locking mechanisms are required.

> 	* Who can release the lock, only the process which created it or
> 	  anyone who has the memory mapped?
> 
> 	* What happens when a process has locked guest regions and then
> 	  dies with SIGSEGV, will its locks on guest memory be released
> 	  stay around forever?

> And this is only what comes to mind immediatly, I sure there are more
> problematic details in such an interface.

Please read through this proposal/RFC, more eyeballs would certainly be welcome.

https://lkml.kernel.org/r/20211111141352.26311-1-chao.p.peng@linux.intel.com
