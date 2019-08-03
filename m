Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8459A805E9
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 13:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389416AbfHCLN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 07:13:59 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:36016 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389332AbfHCLN7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Aug 2019 07:13:59 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1htrys-00079D-8V; Sat, 03 Aug 2019 13:13:46 +0200
Date:   Sat, 3 Aug 2019 12:13:43 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Steven Price <steven.price@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, peter.maydell@linaro.org
Subject: Re: [PATCH 1/9] KVM: arm64: Document PV-time interface
Message-ID: <20190803121343.2f482200@why>
In-Reply-To: <20190802145017.42543-2-steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
        <20190802145017.42543-2-steven.price@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: steven.price@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Aug 2019 15:50:09 +0100
Steven Price <steven.price@arm.com> wrote:

[+Peter for the userspace aspect of things]

Hi Steve,

> Introduce a paravirtualization interface for KVM/arm64 based on the
> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
> 
> This only adds the details about "Stolen Time" as the details of "Live
> Physical Time" have not been fully agreed.
> 
> User space can specify a reserved area of memory for the guest and
> inform KVM to populate the memory with information on time that the host
> kernel has stolen from the guest.
> 
> A hypercall interface is provided for the guest to interrogate the
> hypervisor's support for this interface and the location of the shared
> memory structures.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  Documentation/virtual/kvm/arm/pvtime.txt | 107 +++++++++++++++++++++++
>  1 file changed, 107 insertions(+)
>  create mode 100644 Documentation/virtual/kvm/arm/pvtime.txt
> 
> diff --git a/Documentation/virtual/kvm/arm/pvtime.txt b/Documentation/virtual/kvm/arm/pvtime.txt
> new file mode 100644
> index 000000000000..e6ae9799e1d5
> --- /dev/null
> +++ b/Documentation/virtual/kvm/arm/pvtime.txt
> @@ -0,0 +1,107 @@
> +Paravirtualized time support for arm64
> +======================================
> +
> +Arm specification DEN0057/A defined a standard for paravirtualised time
> +support for Aarch64 guests:

nit: AArch64

> +
> +https://developer.arm.com/docs/den0057/a

Between this file and the above document, which one is authoritative?

> +
> +KVM/Arm64 implements the stolen time part of this specification by providing

nit: KVM/arm64

> +some hypervisor service calls to support a paravirtualized guest obtaining a
> +view of the amount of time stolen from its execution.
> +
> +Two new SMCCC compatible hypercalls are defined:
> +
> +PV_FEATURES 0xC5000020
> +PV_TIME_ST  0xC5000022
> +
> +These are only available in the SMC64/HVC64 calling convention as
> +paravirtualized time is not available to 32 bit Arm guests.
> +
> +PV_FEATURES
> +    Function ID:  (uint32)  : 0xC5000020
> +    PV_func_id:   (uint32)  : Either PV_TIME_LPT or PV_TIME_ST
> +    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
> +                              PV-time feature is supported by the hypervisor.

How is PV_FEATURES discovered? Is the intention to make it a generic
ARM-wide PV discovery mechanism, not specific to PV time?

> +
> +PV_TIME_ST
> +    Function ID:  (uint32)  : 0xC5000022
> +    Return value: (int64)   : IPA of the stolen time data structure for this
> +                              (V)CPU. On failure:
> +                              NOT_SUPPORTED (-1)
> +

Is the size implicit? What are the memory attributes? This either needs
documenting here, or point to the right bit to the spec.

> +Stolen Time
> +-----------
> +
> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
> +
> +  Field       | Byte Length | Byte Offset | Description
> +  ----------- | ----------- | ----------- | --------------------------
> +  Revision    |      4      |      0      | Must be 0 for version 0.1
> +  Attributes  |      4      |      4      | Must be 0
> +  Stolen time |      8      |      8      | Stolen time in unsigned
> +              |             |             | nanoseconds indicating how
> +              |             |             | much time this VCPU thread
> +              |             |             | was involuntarily not
> +              |             |             | running on a physical CPU.
> +
> +The structure will be updated by the hypervisor periodically as time is stolen

Is it really periodic? If so, when is the update frequency?

> +from the VCPU. It will be present within a reserved region of the normal
> +memory given to the guest. The guest should not attempt to write into this
> +memory. There is a structure by VCPU of the guest.

What if the vcpu writes to it? Does it get a fault? If there is a
structure per vcpu, what is the layout in memory? How does a vcpu find
its own data structure? Is that the address returned by PV_TIME_ST?

> +
> +User space interface
> +====================
> +
> +User space can request that KVM provide the paravirtualized time interface to
> +a guest by creating a KVM_DEV_TYPE_ARM_PV_TIME device, for example:
> +
> +    struct kvm_create_device pvtime_device = {
> +            .type = KVM_DEV_TYPE_ARM_PV_TIME,
> +            .attr = 0,
> +            .flags = 0,
> +    };
> +
> +    pvtime_fd = ioctl(vm_fd, KVM_CREATE_DEVICE, &pvtime_device);
> +
> +The guest IPA of the structures must be given to KVM. This is the base address

nit: s/guest //

> +of an array of stolen time structures (one for each VCPU). For example:
> +
> +    struct kvm_device_attr st_base = {
> +            .group = KVM_DEV_ARM_PV_TIME_PADDR,
> +            .attr = KVM_DEV_ARM_PV_TIME_ST,
> +            .addr = (u64)(unsigned long)&st_paddr
> +    };
> +
> +    ioctl(pvtime_fd, KVM_SET_DEVICE_ATTR, &st_base);

So the allocation itself is performed by the kernel? What are the
ordering requirements between creating vcpus and the device? What are
the alignment requirements for the base address?

> +
> +For migration (or save/restore) of a guest it is necessary to save the contents
> +of the shared page(s) and later restore them. KVM_DEV_ARM_PV_TIME_STATE_SIZE
> +provides the size of this data and KVM_DEV_ARM_PV_TIME_STATE allows the state
> +to be read/written.

Is the size variable depending on the number of vcpus?

> +
> +It is also necessary for the physical address to be set identically when
> +restoring.
> +
> +    void *save_state(int fd, u64 attr, u32 *size) {
> +        struct kvm_device_attr get_size = {
> +                .group = KVM_DEV_ARM_PV_TIME_STATE_SIZE,
> +                .attr = attr,
> +                .addr = (u64)(unsigned long)size
> +        };
> +
> +        ioctl(fd, KVM_GET_DEVICE_ATTR, get_size);
> +
> +        void *buffer = malloc(*size);
> +
> +        struct kvm_device_attr get_state = {
> +                .group = KVM_DEV_ARM_PV_TIME_STATE,
> +                .attr = attr,
> +                .addr = (u64)(unsigned long)size
> +        };
> +
> +        ioctl(fd, KVM_GET_DEVICE_ATTR, buffer);
> +    }
> +
> +    void *st_state = save_state(pvtime_fd, KVM_DEV_ARM_PV_TIME_ST, &st_size);
> +

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
