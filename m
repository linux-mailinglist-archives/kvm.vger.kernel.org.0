Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B67A33B9
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 11:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfH3JWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 05:22:43 -0400
Received: from foss.arm.com ([217.140.110.172]:56928 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbfH3JWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 05:22:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB8EC344;
        Fri, 30 Aug 2019 02:22:41 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E6983F718;
        Fri, 30 Aug 2019 02:22:41 -0700 (PDT)
Date:   Fri, 30 Aug 2019 11:22:40 +0200
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 01/10] KVM: arm64: Document PV-time interface
Message-ID: <20190830092240.GA5307@e113682-lin.lund.arm.com>
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-2-steven.price@arm.com>
 <20190827085706.GB6541@e113682-lin.lund.arm.com>
 <37eaf54b-8a22-8483-a372-419bfa1475f1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37eaf54b-8a22-8483-a372-419bfa1475f1@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 01:09:15PM +0100, Steven Price wrote:
> On 27/08/2019 09:57, Christoffer Dall wrote:
> > On Wed, Aug 21, 2019 at 04:36:47PM +0100, Steven Price wrote:
> >> Introduce a paravirtualization interface for KVM/arm64 based on the
> >> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
> >>
> >> This only adds the details about "Stolen Time" as the details of "Live
> >> Physical Time" have not been fully agreed.
> >>
> >> User space can specify a reserved area of memory for the guest and
> >> inform KVM to populate the memory with information on time that the host
> >> kernel has stolen from the guest.
> >>
> >> A hypercall interface is provided for the guest to interrogate the
> >> hypervisor's support for this interface and the location of the shared
> >> memory structures.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> ---
> >>  Documentation/virt/kvm/arm/pvtime.txt | 100 ++++++++++++++++++++++++++
> >>  1 file changed, 100 insertions(+)
> >>  create mode 100644 Documentation/virt/kvm/arm/pvtime.txt
> >>
> >> diff --git a/Documentation/virt/kvm/arm/pvtime.txt b/Documentation/virt/kvm/arm/pvtime.txt
> >> new file mode 100644
> >> index 000000000000..1ceb118694e7
> >> --- /dev/null
> >> +++ b/Documentation/virt/kvm/arm/pvtime.txt
> >> @@ -0,0 +1,100 @@
> >> +Paravirtualized time support for arm64
> >> +======================================
> >> +
> >> +Arm specification DEN0057/A defined a standard for paravirtualised time
> >> +support for AArch64 guests:
> >> +
> >> +https://developer.arm.com/docs/den0057/a
> >> +
> >> +KVM/arm64 implements the stolen time part of this specification by providing
> >> +some hypervisor service calls to support a paravirtualized guest obtaining a
> >> +view of the amount of time stolen from its execution.
> >> +
> >> +Two new SMCCC compatible hypercalls are defined:
> >> +
> >> +PV_FEATURES 0xC5000020
> >> +PV_TIME_ST  0xC5000022
> >> +
> >> +These are only available in the SMC64/HVC64 calling convention as
> >> +paravirtualized time is not available to 32 bit Arm guests. The existence of
> >> +the PV_FEATURES hypercall should be probed using the SMCCC 1.1 ARCH_FEATURES
> >> +mechanism before calling it.
> >> +
> >> +PV_FEATURES
> >> +    Function ID:  (uint32)  : 0xC5000020
> >> +    PV_func_id:   (uint32)  : Either PV_TIME_LPT or PV_TIME_ST
> >> +    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
> >> +                              PV-time feature is supported by the hypervisor.
> >> +
> >> +PV_TIME_ST
> >> +    Function ID:  (uint32)  : 0xC5000022
> >> +    Return value: (int64)   : IPA of the stolen time data structure for this
> >> +                              (V)CPU. On failure:
> >> +                              NOT_SUPPORTED (-1)
> >> +
> >> +The IPA returned by PV_TIME_ST should be mapped by the guest as normal memory
> >> +with inner and outer write back caching attributes, in the inner shareable
> >> +domain. A total of 16 bytes from the IPA returned are guaranteed to be
> >> +meaningfully filled by the hypervisor (see structure below).
> >> +
> >> +PV_TIME_ST returns the structure for the calling VCPU.
> >> +
> >> +Stolen Time
> >> +-----------
> >> +
> >> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
> >> +
> >> +  Field       | Byte Length | Byte Offset | Description
> >> +  ----------- | ----------- | ----------- | --------------------------
> >> +  Revision    |      4      |      0      | Must be 0 for version 0.1
> >> +  Attributes  |      4      |      4      | Must be 0
> >> +  Stolen time |      8      |      8      | Stolen time in unsigned
> >> +              |             |             | nanoseconds indicating how
> >> +              |             |             | much time this VCPU thread
> >> +              |             |             | was involuntarily not
> >> +              |             |             | running on a physical CPU.
> >> +
> >> +The structure will be updated by the hypervisor prior to scheduling a VCPU. It
> >> +will be present within a reserved region of the normal memory given to the
> >> +guest. The guest should not attempt to write into this memory. There is a
> >> +structure per VCPU of the guest.
> >> +
> >> +User space interface
> >> +====================
> >> +
> >> +User space can request that KVM provide the paravirtualized time interface to
> >> +a guest by creating a KVM_DEV_TYPE_ARM_PV_TIME device, for example:
> >> +
> >> +    struct kvm_create_device pvtime_device = {
> >> +            .type = KVM_DEV_TYPE_ARM_PV_TIME,
> >> +            .attr = 0,
> >> +            .flags = 0,
> >> +    };
> >> +
> >> +    pvtime_fd = ioctl(vm_fd, KVM_CREATE_DEVICE, &pvtime_device);
> >> +
> >> +Creation of the device should be done after creating the vCPUs of the virtual
> >> +machine.
> >> +
> >> +The IPA of the structures must be given to KVM. This is the base address
> >> +of an array of stolen time structures (one for each VCPU). The base address
> >> +must be page aligned. The size must be at least 64 * number of VCPUs and be a
> >> +multiple of PAGE_SIZE.
> >> +
> >> +The memory for these structures should be added to the guest in the usual
> >> +manner (e.g. using KVM_SET_USER_MEMORY_REGION).
> >> +
> >> +For example:
> >> +
> >> +    struct kvm_dev_arm_st_region region = {
> >> +            .gpa = <IPA of guest base address>,
> >> +            .size = <size in bytes>
> >> +    };
> > 
> > This feel fragile; how are you handling userspace creating VCPUs after
> > setting this up,
> 
> In this case as long as the structures all fit within the region created
> VCPUs can be created/destroyed at will. If the VCPU index is too high
> then the kernel will bail out in kvm_update_stolen_time() so the
> structure will not be written. I consider this case as user space
> messing up, so beyond protecting the host from the mess, user space gets
> to keep the pieces.
> 
> > the GPA overlapping guest memory, etc.
> 
> Again, the (host) kernel is protected against this, but clearly this
> will end badly for the guest.
> 
> > Is the
> > philosophy here that the VMM can mess up the VM if it wants, but that
> > this should never lead attacks on the host (we better hope not) and so
> > we don't care?
> 
> Yes. For things like GPA overlapping guest memory it's not really the
> host's position to work out what is "guest memory". It's quite possible
> that user space could decide to place the stolen time structures right
> in the middle of guest memory - it's just up to user space to inform the
> guest what memory is usable. Obviously the expectation is that the
> shared structures would be positioned "out of the way" in GPA space in
> any normal arrangement.
> 
> > It seems to me setting the IPA per vcpu throught the VCPU device would
> > avoid a lot of these issues.  See
> > Documentation/virt/kvm/devices/vcpu.txt.
> 
> That is certainly a possibility, I'm not really sure what the benefit is
> though? It would still lead to corner cases:
> 
>  * What if only some VCPUs had stolen time setup on them?
>  * What if multiple VCPUs pointed to the same location?
>  * The structures can still overlap with guest memory
> 
> It's also more work to setup in user space with the only "benefit" being
> that user space could choose to organise the structures however it sees
> fit (e.g. no need for them to be contiguous in memory). But I'm not sure
> I see a use case for that flexibility.
> 
> Perhaps there's some benefit I'm not seeing?
> 

So this is now mostly moot as you said you were going to change this,
but overall I think the assumption that it's trivial to maintain an
interface such the one proposed here to never be an attack vector for
the host is not as easy as it may sound.  In the past, we've had
numerous bugs related to things like calculating an offset into some
region based on some index and a size, because suddenly someone changed
how an index is calculated, and it had unintended side-effects etc.

So if an API is used to specify something which is effectively per-CPU,
it's better to use the per-CPU handles (VCPU fds) to directly describe
this relationship.


Thanks,

    Christoffer
