Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22B639F60A
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 14:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhFHMKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 08:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhFHMKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 08:10:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26D876128D;
        Tue,  8 Jun 2021 12:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623154101;
        bh=Qrj9tU92HeM38xkiUD69xK2JBo/0zhmtcB9lbl+Kbf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ab2mSQWtvjGkHw/vtGj/659aYipd7b/P7pK6KHESMpiOei8NoXd2HZsVcIZOFUARI
         A/lycMaSBDSKWo3iReGV4JqMh87bFwCTQ8kNgP6uq1mC7tvzBXYtdfVgET1OSpCsX/
         qjiU9LwDVEEOiOGDSsHdCydve9TQTvqGkKdZ+9gd4+Byujp8vzVjHqhkO0KGFTBsLg
         /fCf5oza6zArJxfpi+03/eYtGKu0kNAkQZO7ClYiqFiq5zLScLfdZvrXW8tZFx5gBp
         bruo0rdZjwYrRGuujJLUM0++UPcxiFK8pQ647Vlua4UQzYjq+EXv0mDtUI9sF3gmoX
         OlTuhx6ee/gnw==
Date:   Tue, 8 Jun 2021 13:08:16 +0100
From:   Will Deacon <will@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 4/4] KVM: arm64: Introduce KVM_CAP_ARM_PROTECTED_VM
Message-ID: <20210608120815.GE10174@willie-the-truck>
References: <20210603183347.1695-1-will@kernel.org>
 <20210603183347.1695-5-will@kernel.org>
 <YLk4e4hark3Zhi3f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLk4e4hark3Zhi3f@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Thanks for having a look.

On Thu, Jun 03, 2021 at 08:15:55PM +0000, Sean Christopherson wrote:
> On Thu, Jun 03, 2021, Will Deacon wrote:
> > +Enabling this capability causes all memory slots of the specified VM to be
> > +unmapped from the host system and put into a state where they are no longer
> > +configurable.
> 
> What happens if userspace remaps the hva of the memslot?  In other words, how
> will the implementation ensure the physical memory backing the guest is truly
> inaccessible?

The protection is done in the host stage-2 page-table, so it doesn't matter
how the host configures its stage-1 page-table, the underlying physical page
will be inaccessible via any mapping it can create. Does that answer your
question?

> And how will the guest/host share memory?  E.g. what if the guest wants to set
> up a new shared memory region and the host wants that to happen in a new memslot?

The way we're currently dealing with sharing is that, by default, all guest
memory is inaccessible to the host. The guest can then issue hypercalls to
open windows back to the host, so these would necessarily happen in
pre-existing memslots.

> On a related topic, would the concept of guest-only memory be useful[*]?  The
> idea is to require userspace to map guest-private memory with a dedicated VMA
> flag.  That will allow the host kernel to prevent userspace (or the kernel) from
> mapping guest-private memory, and will also allow KVM to verify that memory that
> the guest wants to be private is indeed private.
> 
> [*] https://lkml.kernel.org/r/20210416154106.23721-14-kirill.shutemov@linux.intel.com

Interesting. That certainly looks like it could make things more robust, as
we're in a pretty nasty position if the host tries to access a guest page.
We can either panic the host (which will clearly kill the system) or blow
away the guest (which hasn't done anything wrong). Consequently, whatever we
can do to avoid the host trying to access guest pages in the first place
will make the whole thing more stable.

> > The memory slot corresponding to the ID passed in args[0] is
> > +populated with the guest firmware image provided by the host firmware.
> 
> Why take a slot instead of an address range?  I assume copying the host firmware
> into guest memory will utilize existing APIs, i.e. the memslot lookups to resolve
> the GPA->HVA will Just Work (TM).

Because... initially we tried this funky idea where the firmware would
execute in-place from a read-only memslot and then get unmapped when it was
done. That didn't work out, so now that we have the copying we absolutely
can use an address range. I'll do that for the next version, thanks!

> > +The first vCPU to enter the guest is defined to be the primary vCPU. All other
> > +vCPUs belonging to the VM are secondary vCPUs.
> > +
> > +All vCPUs belonging to a VM with this capability enabled are initialised to a
> > +pre-determined reset state irrespective of any prior configuration according to
> > +the KVM_ARM_VCPU_INIT ioctl, with the following exceptions for the primary
> > +vCPU:
> > +
> > +	===========	===========
> > +	Register(s)	Reset value
> > +	===========	===========
> > +	X0-X14:		Preserved (see KVM_SET_ONE_REG)
> 
> What's the intended use case for allowing userspace to set a pile of registers?
> Giving userspace control of vCPU state is tricky because the state is untrusted.
> Is the state going to be attested in any way, or is the VMM trusted while the
> VM is being created and only de-privileged later on?

I touched a bit on this in my reply to Mark, but the idea is that we have a
firmware image which the host cannot access and which is installed by the
pKVM hypervisor when entering a guest for the first time. The state
documented here is the state in which the firmware is entered, so having
some registers populated by the VMM allows the VMM to communicate with both
the guest firmware and whatever the real VM payload is. We don't trust the
VMM to ensure the integrity of the VM's memory.

For example, let's say the VM payload is an arm64 Linux kernel and we have
u-boot as the firmware image. When the primary vCPU enters the guest for the
first time, the pKVM hypervisor will copy u-boot into the
memslot/address-range specified by KVM_CAP_ARM_PROTECTED_VM_FLAGS_ENABLE and
set the registers accordingly. U-boot will then locate the guest payload
according to what the VMM has put in the preserved registers. Let's say that
x4 points to the start of the guest kernel and x5 to the end; u-boot will
verify that the memory range is correctly signed and, if so, will then jump
to the kernel entry point. The kernel boot protocol then interprets X0-X3
(See Documentation/arm64/booting.rst), with X0 pointing to the devicetree
blob provided by the VMM.

In this example, if the VMM doesn't set X4/X5 correctly, then the signature
check will fail. The devicetree blob is untrusted and, in subsequent
patches, we will harden the guest against that (by offering, for example,
hypercalls so that the guest can opt-in to exiting back to the host on a
stage-2 translation fault).

We'd prefer not to spell out the contract between the VM, firmware and guest
payload, since this is really specific to what you're actually running.
Instead, just carving out a block of preserved registers means KVM doesn't
need to care what they're for.

> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index c5d1f3c87dbd..e1d4a87d18e4 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1349,6 +1349,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >  	bool writable = !(mem->flags & KVM_MEM_READONLY);
> >  	int ret = 0;
> >  
> > +	if (kvm_vm_is_protected(kvm))
> > +		return -EPERM;
> 
> FWIW, this will miss the benign corner case where KVM_SET_USER_MEMORY_REGION
> does not actualy change anything about an existing region.

Yeah, I think that's ok though because nothing happened.

> A more practical problem is that this check won't happen until KVM has marked
> the existing region as invalid in the DELETE or MOVE case.  So userspace can't
> completely delete a region, but it can temporarily delete a region by briefly
> making it in invalid.  No idea what the ramifications of that are on arm64.

It's probably worth stating that the current patches I have here are only
the host kernel part of the bargain. The real work is going to be happening
in the hypervisor, which will be in the charge of the page-tables and
blissfully ignorant of memslot flags. In other words, the permission checks
here are really for slapping the VMM on the wrist if it does something daft
rather then enforcing anything for security -- all that has to happen in the
hypervisor. In the case of KVM_MEMSLOT_INVALID being set when a guest exits
to the host due to a page-fault, it looks like we'll return to the VMM.

I'd just like to get some feedback on the user ABI before we commit to the
hypervisor side of things.

> >  	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
> >  			change != KVM_MR_FLAGS_ONLY)
> >  		return 0;
> 
> ...
> 
> > +static int pkvm_vm_ioctl_enable(struct kvm *kvm, u64 slotid)
> > +{
> > +	int ret = 0;
> 
> Deep into the nits: technically unnecessary since ret is guaranteed to be written
> before being consumed.

Sure thing, I can drop that assignment.

> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 3fd9a7e9d90c..58ab8508be5e 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1082,6 +1082,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_SGX_ATTRIBUTE 196
> >  #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
> >  #define KVM_CAP_PTP_KVM 198
> > +#define KVM_CAP_ARM_PROTECTED_VM 199
> 
> Rather than a dedicated (and arm-only) capability for protected VMs, what about
> adding a capability to retrieve the supported VM types?  And obviously make
> protected VMs a different type that must be specified at VM creation (there's
> already plumbing for this).  Even if there's no current need to know at creation
> time that a VM will be protected, it's also unlikely to be a burden on userspace
> and could be nice to have down the road.  The late "activation" ioctl() can still
> be supported, e.g. to start disallowing memslot updates.
> 
> x86 with TDX would look like:
> 
>         case KVM_CAP_VM_TYPES:
>                 r = BIT(KVM_X86_LEGACY_VM);
>                 if (kvm_x86_ops.is_vm_type_supported(KVM_X86_TDX_VM))
>                         r |= BIT(KVM_X86_TDX_VM);
>                 break;
> 
> and arm64 would look like?
> 
> 	case KVM_CAP_VM_TYPES:
> 		r = BIT(KVM_ARM64_LEGACY_VM);
> 		if (kvm_get_mode() == KVM_MODE_PROTECTED)
> 			r |= BIT(KVM_ARM64_PROTECTED_VM);
> 		break;

You're not the first person to mention this, so I'll look into it. We'll
still need the cap, not just for deferring activation, but also for querying
the firmware parameters.

Cheers,

Will
