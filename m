Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9222C8B8A
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 18:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387754AbgK3RmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 12:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728499AbgK3RmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 12:42:13 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2507AC0613D3
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 09:41:33 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id l11so6897686plt.1
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 09:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BsDePY71l0NLhvDaTy8fIL8SZo/2TV0ypfJS9+JlCvs=;
        b=SvTWPpI351hbuFvUDiH/M3SQ984PBGjRq+nlrAoR2IiQYy8z5lQ/pezxby0oxaDRWk
         8YE4TKvuhbdkVyti6RKeG129UY8dnUpYtYipsuZ7+PsOMluy4C+0miirV8sMR5G4QE79
         9t1kvUlaTIgpj3I1Y5zAft8iZaRRodtWUrfKPuwWjBISdVkbjaLcM/84e+plBz3T+Vz9
         oPr9GSq8H8qeJDR/P5kxlJ31WUsq5A/WsSLyZumoF9faKKid0HfhQscUth+GenBaNb6Z
         VTe16+cIwyYNwDKobNbsp/IgJq7ManAa5O+RIzIzPrpyDQAX9V+PZ5euL1jyn103dpTJ
         6b0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BsDePY71l0NLhvDaTy8fIL8SZo/2TV0ypfJS9+JlCvs=;
        b=gHvvBH6HBtBcukqg9qzMAOTRBovNjV4fluOp0F6PlAmN+8Wq9dnWaTbYLDVLsK2Gde
         lezjbpn/6jP8o1Cel/2Aw7KM9iFXiWwnqM75l2PjrM9D+MzW1HmE/K3m/Gy0sh0kjj9C
         NtfcWTKa5xUVlJ6kcnzIy/jnwExmjrTxZVeZc/cV8LBBBe+x13FddhIGHZMR7awsed0k
         RhT1DKcdlmUw8l/CDqFwjuSXIPRwzA8ZisMc9+G7gdv532u/Okd1KosPgxSOI6FSm6ka
         1IOEOYerrlgaCqKOzMFucmWwtoVERjwFs/xVwWud0HpbQpCXcKcfkbHMvrQV1m21oyH1
         JgIg==
X-Gm-Message-State: AOAM533cDqRNcuexnnF98buSFD8/wcJqVnz7u4g2RNRDABQJdzRMHxk2
        K6ZDY25AYj8wEWXhMTM9wAHfDA==
X-Google-Smtp-Source: ABdhPJwxxw/kUT4PLLb+HevJXnWfPnh1F4uPCzjIXQHiGfignYzjpcDo69fVQKHixpFKMlujGIkBjQ==
X-Received: by 2002:a17:90a:62c8:: with SMTP id k8mr27902507pjs.33.1606758092369;
        Mon, 30 Nov 2020 09:41:32 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id 21sm17032171pfj.134.2020.11.30.09.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 09:41:31 -0800 (PST)
Date:   Mon, 30 Nov 2020 17:41:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@qumranet.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] kvm/x86/mmu: use the correct inherited permissions to
 get shadow page
Message-ID: <X8Uux62rJdf2feJ2@google.com>
References: <20201120095517.19211-1-jiangshanlai@gmail.com>
 <20201126000549.GC450871@google.com>
 <0724aeb9-3466-5505-8f12-a5899144e68f@redhat.com>
 <CAJhGHyApvmQk4bxxK2rJKzyAShFSXyEb2W0qyFcVoUEcsMKs_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyApvmQk4bxxK2rJKzyAShFSXyEb2W0qyFcVoUEcsMKs_w@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 28, 2020, Lai Jiangshan wrote:
> On Sat, Nov 28, 2020 at 12:48 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 26/11/20 01:05, Sean Christopherson wrote:
> > > On Fri, Nov 20, 2020, Lai Jiangshan wrote:
> > >> From: Lai Jiangshan <laijs@linux.alibaba.com>
> > >>
> > >> Commit 41074d07c78b ("KVM: MMU: Fix inherited permissions for emulated
> > >> guest pte updates") said role.access is common access permissions for
> > >> all ptes in this shadow page, which is the inherited permissions from
> > >> the parent ptes.
> > >>
> > >> But the commit did not enforce this definition when kvm_mmu_get_page()
> > >> is called in FNAME(fetch). Rather, it uses a random (last level pte's
> > >> combined) access permissions.
> > >
> > > I wouldn't say it's random, the issue is specifically that all shadow pages end
> > > up using the combined set of permissions of the entire walk, as opposed to the
> > > only combined permissions of its parents.
> > >
> > >> And the permissions won't be checked again in next FNAME(fetch) since the
> > >> spte is present. It might fail to meet guest's expectation when guest sets up
> > >> spaghetti pagetables.
> > >
> > > Can you provide details on the exact failure scenario?  It would be very helpful
> > > for documentation and understanding.  I can see how using the full combined
> > > permissions will cause weirdness for upper level SPs in kvm_mmu_get_page(), but
> > > I'm struggling to connect the dots to understand how that will cause incorrect
> > > behavior for the guest.  AFAICT, outside of the SP cache, KVM only consumes
> > > role.access for the final/last SP.
> > >
> >
> > Agreed, a unit test would be even better, but just a description in the
> > commit message would be enough.
> >
> > Paolo
> >
> 
> Something in my mind, but I haven't test it:
> 
> pgd[]pud[]  pmd[]        pte[]            virtual address pointers
>  (same hpa as pmd2\)  /->pte1(u--)->page1 <- ptr1 (u--)
>          /->pmd1(uw-)--->pte2(uw-)->page2 <- ptr2 (uw-)
> pgd->pud-|           (shared pte[] as above)
>          \->pmd2(u--)--->pte1(u--)->page1 <- ptr3 (u--)
>  (same hpa as pmd1/)  \->pte2(uw-)->page2 <- ptr4 (u--)
> 
> 
> pmd1 and pmd2 point to the same pte table, so:
> ptr1 and ptr3 points to the same page.
> ptr2 and ptr4 points to the same page.
> 
>   The guess read-accesses to ptr1 first. So the hypervisor gets the
> shadow pte page table with role.access=u-- among other things.
>    (Note the shadowed pmd1's access is uwx)
> 
>   And then the guest write-accesses to ptr2, and the hypervisor
> set up shadow page for ptr2.
>    (Note the hypervisor silencely accepts the role.access=u--
>     shadow pte page table in FNAME(fetch))
> 
>   After that, the guess read-accesses to ptr3, the hypervisor
> reused the same shadow pte page table as above.
> 
>   At last, the guest writes to ptr4 without vmexit nor pagefault,
> Which should cause vmexit as the guest expects.

Hmm, yes, KVM would incorrectly handle this scenario.  But, the proposed patch
would not address the issue as KVM always maps non-leaf shadow pages with full
access permissions.

> In theory, guest userspace can trick the guest kernel if the guest
> kernel sets up page table like this.

I doubt any kernel is affected.  Providing a RO or NX view by splitting the VA
space at the PMD level is doable, but it would be much more awkward to deal with
than splitting the VAs at the PGD level (kernel vs. userspace)

E.g. Linux uses constant[*] protections for page tables, with different constant
protections for kernel v. userspace.

[*] Ignoring encryption, which is technically an address bit anyways.

> Such spaghetti pagetables are unlikely to be seen in the guest.
> 
> But when the guest is using KPTI and not using SMEP. KPTI means
> all pgd entries are marked NX on the lower/userspace part of
> the kernel pagetable. Which means SMEP is not needed.
> (see arch/x86/mm/pti.c)
> 
> Assume the guest does disable SMEP and the guest has the flaw
> that the guest user can trick guest kernel to execute on lower
> part of the address space.
> 
> Normally, NX bit marked on the kernel pagetable's lower pgd
> entries can help in this case. But when in guest with shadowpage
> in hypervisor, the guest user can make those NX bit useless.

This NX use case won't be affected.  The example above requires ptr2 and ptr4 to
use the same PGD and PUD.  If ptr2 and ptr4 use different PGDs, i.e. kernel vs.
userspace, KVM will use different shadow pages for the two PGDs, and the kernel
variant will have role.NX=1 in the leaf SPTEs.
 
> Again, I haven't tested it neither. I will try it later and
> update the patch including adding some more checks in the mmu.c.
> 
> Thanks,
> Lai
