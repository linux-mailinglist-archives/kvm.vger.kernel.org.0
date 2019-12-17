Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A2C122E7E
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 15:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfLQOVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 09:21:47 -0500
Received: from foss.arm.com ([217.140.110.172]:38616 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728573AbfLQOVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 09:21:46 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD7E31FB;
        Tue, 17 Dec 2019 06:21:45 -0800 (PST)
Received: from arm.com (e112269-lin.cambridge.arm.com [10.1.196.56])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E29473F719;
        Tue, 17 Dec 2019 06:21:43 -0800 (PST)
Date:   Tue, 17 Dec 2019 14:21:39 +0000
From:   Steven Price <steven.price@arm.com>
To:     "yezengruan@huawei.com" <yezengruan@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "maz@kernel.org" <maz@kernel.org>,
        James Morse <James.Morse@arm.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 1/5] KVM: arm64: Document PV-lock interface
Message-ID: <20191217142138.GA38811@arm.com>
References: <20191217135549.3240-1-yezengruan@huawei.com>
 <20191217135549.3240-2-yezengruan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217135549.3240-2-yezengruan@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 01:55:45PM +0000, yezengruan@huawei.com wrote:
> From: Zengruan Ye <yezengruan@huawei.com>
> 
> Introduce a paravirtualization interface for KVM/arm64 to obtain the vcpu
> is currently running or not.
> 
> A hypercall interface is provided for the guest to interrogate the
> hypervisor's support for this interface and the location of the shared
> memory structures.
> 
> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
> ---
>  Documentation/virt/kvm/arm/pvlock.rst | 31 +++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 Documentation/virt/kvm/arm/pvlock.rst
> 
> diff --git a/Documentation/virt/kvm/arm/pvlock.rst b/Documentation/virt/kvm/arm/pvlock.rst
> new file mode 100644
> index 000000000000..eec0c36edf17
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/pvlock.rst
> @@ -0,0 +1,31 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Paravirtualized lock support for arm64
> +======================================
> +
> +KVM/arm64 provids some hypervisor service calls to support a paravirtualized
> +guest obtaining the vcpu is currently running or not.
> +
> +Two new SMCCC compatible hypercalls are defined:
> +
> +* PV_LOCK_FEATURES:   0xC5000040
> +* PV_LOCK_PREEMPTED:  0xC5000041

These values are in the "Standard Hypervisor Service Calls" section of
SMCCC - so is there a document that describes this features such that
other OSes or hypervisors can implement it? I'm also not entirely sure
of the process of ensuring that the IDs picked are non-conflicting.

Otherwise if this is a KVM specific interface this should probably
belong within the "Vendor Specific Hypervisor Service Calls" section
along with some probing that the hypervisor is actually KVM. Although I
don't see anything KVM specific.

> +
> +The existence of the PV_LOCK hypercall should be probed using the SMCCC 1.1
> +ARCH_FEATURES mechanism before calling it.
> +
> +PV_LOCK_FEATURES
> +    ============= ========    ==========
> +    Function ID:  (uint32)    0xC5000040
> +    PV_call_id:   (uint32)    The function to query for support.
> +    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
> +                              PV-lock feature is supported by the hypervisor.
> +    ============= ========    ==========
> +
> +PV_LOCK_PREEMPTED
> +    ============= ========    ==========
> +    Function ID:  (uint32)    0xC5000041
> +    Return value: (int64)     NOT_SUPPORTED (-1) or SUCCESS (0) if the IPA of
> +                              this vcpu's pv data structure is configured by
> +                              the hypervisor.
> +    ============= ========    ==========

From the code it looks like there's another argument for this SMC - the
physical address (or IPA) of a struct pvlock_vcpu_state. This structure
also needs to be described as it is part of the ABI.

Steve
