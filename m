Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A720C1E3EE7
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 12:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbgE0KYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 06:24:04 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:55399 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729781AbgE0KYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 06:24:04 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49X6PY4P1Nz9sSd; Wed, 27 May 2020 20:24:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1590575041; bh=VVcDtWS7h80i30YV0OfUbb0gXVwEngQnBUR9NRnRJfw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SOrOgp/DbKjCWGJEmRT4JHH1mKILqt9KgNoLKRh7rvKKj4Sqm5pO8lJRFcdvq48Dx
         ti0b+Ccb8SsT3SEiyZJEIdbhrZXYdsNzNSgKeNo4N+EKbW8dQQBF337P0QR7YteV9U
         iPxIQryP6Tw/BsbYPPrt04gydI+eiQ+y5YHCPXWSOFnoxtXkjQSLCuQaZJEHa7F4zB
         xhiI86troJbVbYOsgC3jeUvLOf8GCA9xtK7iEso5K4fRndyendZe96buPSVrhqa14M
         ZIpkw792NoWEERhAVMtpcKTKSqZ+VyLYwcDRu18FujuVnQ8Hrb0Ckiy8FDzJdQKpFP
         Q1EAVfzYnGvwA==
Date:   Wed, 27 May 2020 20:23:53 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 4/4] KVM: PPC: Book3S HV: Flush guest mappings when
 turning dirty tracking on/off
Message-ID: <20200527102353.GH293451@thinks.paulus.ozlabs.org>
References: <20181212041430.GA22265@blackberry>
 <20181212041717.GE22265@blackberry>
 <58247760-00de-203d-a779-7fda3a739248@redhat.com>
 <20200506051217.GA24968@blackberry>
 <e7aae742-d189-2882-5c41-3dd993c029bb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7aae742-d189-2882-5c41-3dd993c029bb@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Laurent,

On Wed, May 06, 2020 at 10:24:48AM +0200, Laurent Vivier wrote:
> On 06/05/2020 07:12, Paul Mackerras wrote:
> > On Tue, Apr 28, 2020 at 05:57:59PM +0200, Laurent Vivier wrote:
> >> On 12/12/2018 05:17, Paul Mackerras wrote:
> >>> +	if (change == KVM_MR_FLAGS_ONLY && kvm_is_radix(kvm) &&
> >>> +	    ((new->flags ^ old->flags) & KVM_MEM_LOG_DIRTY_PAGES))
> >>> +		kvmppc_radix_flush_memslot(kvm, old);
> >>>  }
> >>
> >> Hi,
> >>
> >> this part introduces a regression in QEMU test suite.
> >>
> >> We have the following warning in the host kernel log:
> >>
> > [snip]
> >>
> >> The problem is detected with the "migration-test" test program in qemu,
> >> on a POWER9 host in radix mode with THP. It happens only the first time
> >> the test program is run after loading kvm_hv. The warning is an explicit
> >> detection [1] of a problem:
> > 
> > Yes, we found a valid PTE where we didn't expect there to be one.

I have now managed to reproduce the problem locally, and I have an
explanation for what's going on.  QEMU turns on dirty tracking for the
memslot for the VM's RAM, and KVM flushes the mappings from the
partition-scoped page table, and then proceeds to fill it up with 64k
page mappings due to page faults as the VM runs.

Then QEMU turns dirty tracking off, while the VM is still running.
The new memslot, with the dirty tracking bit clear, becomes visible to
page faults before we get to the kvmppc_core_commit_memory_region_hv()
function.  Thus, page faults occurring during the interval between the
calls to install_new_memslots() and kvm_arch_commit_memory_region()
will decide to install a 2MB page if there is a THP on the host side.
This will hit the case in kvmppc_create_pte() where it wants to
install a 2MB leaf PTE but there is a page table pointer there
already.  It calls kvmppc_unmap_free_pmd_entry_table(), which calls
kvmppc_unmap_free_pte(), which finds the existing 64k PTEs and
generates the warning.

Now, the code in kvmppc_unmap_free_pte() does the right thing, in that
it calls kvmppc_unmap_pte to deal with the PTE it found.  The warning
was just an attempt to catch code bugs rather than an indication of
any immediate and obvious problem.  Since we now know of one situation
where this can legitimately happen, I think we should just take out
the WARN_ON_ONCE, along with the scary comment.  If people want to be
more paranoid than that, we could add a check that the existing PTEs
all map sub-pages of the 2MB page that we're about to map.

There is another race which is possible, which is that when turning on
dirty page tracking, a parallel page fault reads the memslot flags
before the new memslots are installed, and inserts its PTE after
kvmppc_core_commit_memory_region_hv has flushed the memslot.  In that
case, we would have a 2MB PTE left over, which would result in coarser
dirty tracking granularity for that 2MB page.  I think this would be
very hard to hit in practice, and that having coarser dirty tracking
granularity for one 2MB page of the VM would not cause any practical
problem.

That race could be closed by bumping the kvm->mmu_notifier_seq while
the kvm->mmu_lock is held in kvmppc_radix_flush_memslot().

Thoughts?

Paul.
