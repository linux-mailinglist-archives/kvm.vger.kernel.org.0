Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3668C10321A
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 04:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfKTDou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 22:44:50 -0500
Received: from mga03.intel.com ([134.134.136.65]:49028 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbfKTDou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 22:44:50 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 19:44:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,220,1571727600"; 
   d="scan'208";a="204597622"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 19 Nov 2019 19:44:48 -0800
Date:   Tue, 19 Nov 2019 19:44:48 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christoffer Dall <christoffer.dall@arm.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        borntraeger@de.ibm.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Memory regions and VMAs across architectures
Message-ID: <20191120034448.GC25890@linux.intel.com>
References: <20191108111920.GD17608@e113682-lin.lund.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108111920.GD17608@e113682-lin.lund.arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 08, 2019 at 12:19:20PM +0100, Christoffer Dall wrote:
> Hi,
> 
> I had a look at our relatively complicated logic in
> kvm_arch_prepare_memory_region(), and was wondering if there was room to
> unify some of this handling between architectures.
> 
> (If you haven't seen our implementation, you can find it in
> virt/kvm/arm/mmu.c, and it has lovely ASCII art!)
> 
> I then had a look at the x86 code, but that doesn't actually do anything
> when creating memory regions, which makes me wonder why the arhitectures
> differ in this aspect.
> 
> The reason we added the logic that we have for arm/arm64 is that we
> don't really want to take faults for I/O accesses.  I'm not actually
> sure if this is a corretness thing, or an optimization effort, and the
> original commit message doesn't really explain.  Ard, you wrote that
> code, do you recall the details?
> 
> In any case, what we do is to check for each VMA backing a memslot, we
> check if the memslot flags and vma flags are a reasonable match, and we
> try to detect I/O mappings by looking for the VM_PFNMAP flag on the VMA
> and pre-populate stage 2 page tables (our equivalent of EPT/NPT/...).
> However, there are some things which are not clear to me:
> 
> First, what prevents user space from messing around with the VMAs after
> kvm_arch_prepare_memory_region() completes?  If nothing, then what is
> the value of the cheks we perform wrt. to VMAs?

Arm's prepare_memory_region() holds mmap_sem and mmu_lock while processing
the VMAs and populating the stage 2 page tables.  Holding mmap_sem prevents
the VMAs from being invalidated while the stage 2 tables are populated,
e.g. prevents racing with the mmu notifier.  The VMAs could be modified
after prepare_memory_region(), but the mmu notifier will ensure they are
unmapped from stage2 prior the the host change taking effect.  So I think
you're safe (famous last words).

> Second, why would arm/arm64 need special handling for I/O mappings
> compared to other architectures, and how is this dealt with for
> x86/s390/power/... ?

As Ard mentioned, it looks like an optimization.  The "passthrough"
part from the changelog implies that VM_PFNMAP memory regions are exclusive
to the guest.  Mapping the entire thing would be a nice boot optimization
as it would save taking page faults on every page of the MMIO region.

As for how this is different from other archs... at least on x86, VM_PFNMAP
isn't guaranteed to be passthrough or even MMIO, e.g. prefaulting the
pages may actually trigger allocation, and remapping the addresses could be
flat out wrong.


  commit 8eef91239e57d2e932e7470879c9a504d5494ebb
  Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
  Date:   Fri Oct 10 17:00:32 2014 +0200

    arm/arm64: KVM: map MMIO regions at creation time

    There is really no point in faulting in memory regions page by page
    if they are not backed by demand paged system RAM but by a linear
    passthrough mapping of a host MMIO region. So instead, detect such
    regions at setup time and install the mappings for the backing all
    at once.


