Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E032D7E40
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 19:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731408AbfJOR44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 13:56:56 -0400
Received: from foss.arm.com ([217.140.110.172]:44770 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbfJOR44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 13:56:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15214337;
        Tue, 15 Oct 2019 10:56:55 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E5813F6C4;
        Tue, 15 Oct 2019 10:56:53 -0700 (PDT)
Date:   Tue, 15 Oct 2019 18:56:51 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 01/10] KVM: arm64: Document PV-time interface
Message-ID: <20191015175651.GF24604@lakrids.cambridge.arm.com>
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-2-steven.price@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011125930.40834-2-steven.price@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Steven,

On Fri, Oct 11, 2019 at 01:59:21PM +0100, Steven Price wrote:
> Introduce a paravirtualization interface for KVM/arm64 based on the
> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.

I notice that as published, this is a BETA Draft, with the explicit
note:

| This document is for review purposes only and should not be used
| for any implementation as changes are likely.

... what's the plan for getting a finalised version published?

> This only adds the details about "Stolen Time" as the details of "Live
> Physical Time" have not been fully agreed.

... and what do we expect to happen on this front?

AFAICT, the spec hasn't changed since I called out issues in that area:

  https://lore.kernel.org/r/20181210114047.tifwh6ilwzphsbqy@lakrids.cambridge.arm.com

... and I'd feel much happier about supporting this if that were dropped
from the finalised spec.

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
>  Documentation/virt/kvm/arm/pvtime.rst   | 77 +++++++++++++++++++++++++
>  Documentation/virt/kvm/devices/vcpu.txt | 14 +++++
>  2 files changed, 91 insertions(+)
>  create mode 100644 Documentation/virt/kvm/arm/pvtime.rst
> 
> diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm/pvtime.rst
> new file mode 100644
> index 000000000000..de949933ec78
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/pvtime.rst
> @@ -0,0 +1,77 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Paravirtualized time support for arm64
> +======================================
> +
> +Arm specification DEN0057/A defines a standard for paravirtualised time
> +support for AArch64 guests:
> +
> +https://developer.arm.com/docs/den0057/a
> +
> +KVM/arm64 implements the stolen time part of this specification by providing
> +some hypervisor service calls to support a paravirtualized guest obtaining a
> +view of the amount of time stolen from its execution.
> +
> +Two new SMCCC compatible hypercalls are defined:
> +
> +* PV_TIME_FEATURES: 0xC5000020
> +* PV_TIME_ST:       0xC5000021
> +
> +These are only available in the SMC64/HVC64 calling convention as
> +paravirtualized time is not available to 32 bit Arm guests. The existence of
> +the PV_FEATURES hypercall should be probed using the SMCCC 1.1 ARCH_FEATURES
> +mechanism before calling it.
> +
> +PV_TIME_FEATURES
> +    ============= ========    ==========
> +    Function ID:  (uint32)    0xC5000020
> +    PV_call_id:   (uint32)    The function to query for support.
> +                              Currently only PV_TIME_ST is supported.
> +    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
> +                              PV-time feature is supported by the hypervisor.
> +    ============= ========    ==========
> +
> +PV_TIME_ST
> +    ============= ========    ==========
> +    Function ID:  (uint32)    0xC5000021
> +    Return value: (int64)     IPA of the stolen time data structure for this
> +                              VCPU. On failure:
> +                              NOT_SUPPORTED (-1)
> +    ============= ========    ==========
> +
> +The IPA returned by PV_TIME_ST should be mapped by the guest as normal memory
> +with inner and outer write back caching attributes, in the inner shareable
> +domain. A total of 16 bytes from the IPA returned are guaranteed to be
> +meaningfully filled by the hypervisor (see structure below).

At what granularity is this allowed to share IPA space with other
mappings? The spec doesn't provide any guidance here, and I strongly
suspect that it should.

To support a 64K guest, we must ensure that this doesn't share a 64K IPA
granule with any MMIO, and it probably only makes sense for an instance
of this structure to share that granule with another vCPU's structure.

We probably _also_ want to ensure that this doesn't share a 64K granule
with memory the guest sees as regular system RAM. Otherwise we're liable
to force it into having mismatched attributes for any of that RAM it
happens to map as part of mapping the PV_TIME_ST structure.

> +
> +PV_TIME_ST returns the structure for the calling VCPU.
> +
> +Stolen Time
> +-----------
> +
> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
> +
> ++-------------+-------------+-------------+----------------------------+
> +| Field       | Byte Length | Byte Offset | Description                |
> ++=============+=============+=============+============================+
> +| Revision    |      4      |      0      | Must be 0 for version 1.0  |
> ++-------------+-------------+-------------+----------------------------+
> +| Attributes  |      4      |      4      | Must be 0                  |
> ++-------------+-------------+-------------+----------------------------+
> +| Stolen time |      8      |      8      | Stolen time in unsigned    |
> +|             |             |             | nanoseconds indicating how |
> +|             |             |             | much time this VCPU thread |
> +|             |             |             | was involuntarily not      |
> +|             |             |             | running on a physical CPU. |
> ++-------------+-------------+-------------+----------------------------+
> +
> +All values in the structure are stored little-endian.

Looking at the published DEN 0057A, endianness is never stated. Is this
going to be corrected in the next release?

Thanks,
Mark.
