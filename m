Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3ABF39F604
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 14:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhFHMIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 08:08:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232294AbhFHMIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 08:08:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0081160FDB;
        Tue,  8 Jun 2021 12:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623154012;
        bh=szHxzIi0roevoqKfazzQiVRpREg75Q1zH65M51z19xM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X6PGuCn19pZRTaq4LmYkkSPIFYciDjpNRne40QQLuwDNqVNv/CtZdN7eQTzFor/Ns
         x+a16zyRcQFPEXEy5l3EpniIuKQABpTutruJAjSymJfAj3NF6BQ65m0FbCZlViWhao
         5csPWnJCGskVDEPFhUX5sauXY3a2g6B4NvOlunsQVnVKMZD6y8Oggbq6+9A025x4Qe
         dsAfQVXy8ZT8x9Xygcw9M7gmSIW8DAfftMiKd353BawwOd1yrpISbBrMt/JBYMrl0i
         jmmvSY66fFkWo07eUJs/oEvrBte0Kjd9tNKd5FMs99kFAs3HsrriR0YK/oWhUUMDmw
         5uousyqtR6Psw==
Date:   Tue, 8 Jun 2021 13:06:46 +0100
From:   Will Deacon <will@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Brazdil <dbrazdil@google.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 4/4] KVM: arm64: Introduce KVM_CAP_ARM_PROTECTED_VM
Message-ID: <20210608120645.GD10174@willie-the-truck>
References: <20210603183347.1695-1-will@kernel.org>
 <20210603183347.1695-5-will@kernel.org>
 <20210604144110.GD69333@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604144110.GD69333@C02TD0UTHF1T.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021 at 03:41:10PM +0100, Mark Rutland wrote:
> On Thu, Jun 03, 2021 at 07:33:47PM +0100, Will Deacon wrote:
> > +7.26.1 KVM_CAP_ARM_PROTECTED_VM_FLAGS_ENABLE
> > +--------------------------------------------
> > +
> > +:Capability: 'flag' parameter to KVM_CAP_ARM_PROTECTED_VM
> > +:Architectures: arm64
> > +:Target: VM
> > +:Parameters: args[0] contains memory slot ID to hold guest firmware
> > +:Returns: 0 on success; negative error code on failure
> > +
> > +Enabling this capability causes all memory slots of the specified VM to be
> > +unmapped from the host system and put into a state where they are no longer
> > +configurable. The memory slot corresponding to the ID passed in args[0] is
> > +populated with the guest firmware image provided by the host firmware.
> 
> As on the prior patch, I don't quite follow the rationale for the guest
> fw coming from the host fw, and it seems to go against the usual design
> for VM contents, so I fear it could be a problem in future (even if not
> in android's specific model for usage).

Hopefully my other reply helps here. As I say, it would be trivial to extend
the interface to make this optional.

> > +The first vCPU to enter the guest is defined to be the primary vCPU. All other
> > +vCPUs belonging to the VM are secondary vCPUs.
> > +
> > +All vCPUs belonging to a VM with this capability enabled are initialised to a
> > +pre-determined reset state
> 
> What is that "pre-determined reset state"? e.g. is that just what KVM
> does today, or is there something more specific (e.g. that might change
> with the "Boot protocol version" below)?

Yes, it's the KVM reset state as described by KVM_ARM_VCPU_INIT, as I state
later in the sentence:

> > irrespective of any prior configuration according to
> > +the KVM_ARM_VCPU_INIT ioctl

    here ^^^

So I should probably reword it. How about:

  | All vCPUs belonging to a VM with this capability enabled are initialised to
  | a pre-determined reset state according to the KVM_ARM_VCPU_INIT ioctl,
  | irrespective of any prior configuration, with the following exceptions
  | for the primary vCPU:

?

> > with the following exceptions for the primary
> > +vCPU:
> > +
> > +	===========	===========
> > +	Register(s)	Reset value
> > +	===========	===========
> > +	X0-X14:		Preserved (see KVM_SET_ONE_REG)
> > +	X15:		Boot protocol version (0)
> 
> What's the "Boot protocol" in this context? Is that just referring to
> this handover state, or is that something more involved?

It's just versioning this state, in case we have to change/extend it in
future. If you prefer, I can just say:

	X15-X30		Reserved (0)

instead?

> > +	X16-X30:	Reserved (0)
> > +	PC:		IPA base of firmware memory slot
> > +	SP:		IPA end of firmware memory slot
> > +	===========	===========
> > +
> > +Secondary vCPUs belonging to a VM with this capability enabled will return
> > +-EPERM in response to a KVM_RUN ioctl() if the vCPU was not initialised with
> > +the KVM_ARM_VCPU_POWER_OFF feature.
> 
> I assume this means that protected VMs always get a trusted PSCI
> implementation? It might be worth mentioning so (and worth consdiering
> if that should always have the SMCCC bits too).

"trusted PSCI implementation" might be stretching it, but the idea is that
you can at least ensure that vCPUs won't start executing until the guest is
ready for them. I don't think we need any particular SMCCC revision for
that.

> > +
> > +There is no support for AArch32 at any exception level.
> 
> Is this only going to run on CPUs without AArch32 EL0? ... or does this
> mean behaviour will be erratic if someone tries to run AArch32 EL0?

It means that we don't permit creation of 32-bit vCPUs, or exception return
to an AArch32 guest from EL2. Of course, if the guest itself decides to try
this and the hardware happens to support it then there's not a lot we can
about it. But that's the guest being silly, so we don't need to care.

> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index 24223adae150..cdb3298ba8ae 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -402,6 +402,15 @@ struct kvm_vcpu_events {
> >  #define KVM_PSCI_RET_INVAL		PSCI_RET_INVALID_PARAMS
> >  #define KVM_PSCI_RET_DENIED		PSCI_RET_DENIED
> >  
> > +/* Protected KVM */
> > +#define KVM_CAP_ARM_PROTECTED_VM_FLAGS_ENABLE	0
> > +#define KVM_CAP_ARM_PROTECTED_VM_FLAGS_INFO	1
> > +
> > +struct kvm_protected_vm_info {
> > +	__u64 firmware_size;
> > +	__u64 __reserved[7];
> > +};
> 
> Do you have anything in mind for those 7 fields, or was this just a
> number that sounded big enough?

I just padded it to a cacheline, as that's plenty enough space to version
the thing if we need to.

> I wonder if it's worth adding an size field, and having a size argument
> to the ioctl, so that you can discover the full size if we need to grow
> this, but you can always get a truncated copy if you just need the early
> fields.

Possibly, but the rest of the KVM UAPI doesn't seem to be designed like
that, so I followed what was there already. I defer to the KVM maintainers
on this one...

Will
