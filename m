Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A3B3D3B36
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 15:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbhGWMuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 08:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233037AbhGWMtl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 08:49:41 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A3D360EB4;
        Fri, 23 Jul 2021 13:30:15 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m6vFl-000UyF-5x; Fri, 23 Jul 2021 14:30:13 +0100
MIME-Version: 1.0
Date:   Fri, 23 Jul 2021 14:30:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        will@kernel.org
Subject: Re: [PATCH 10/16] KVM: arm64: Add some documentation for the MMIO
 guard feature
In-Reply-To: <20210721211743.hb2cxghhwl2y22yh@gator>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-11-maz@kernel.org>
 <20210721211743.hb2cxghhwl2y22yh@gator>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <60d8e9e95ee4640cf3b457c53cb4cc7a@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com, vatsa@codeaurora.org, sdonthineni@nvidia.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-07-21 22:17, Andrew Jones wrote:
> On Thu, Jul 15, 2021 at 05:31:53PM +0100, Marc Zyngier wrote:
>> Document the hypercalls user for the MMIO guard infrastructure.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  Documentation/virt/kvm/arm/index.rst      |  1 +
>>  Documentation/virt/kvm/arm/mmio-guard.rst | 73 
>> +++++++++++++++++++++++
>>  2 files changed, 74 insertions(+)
>>  create mode 100644 Documentation/virt/kvm/arm/mmio-guard.rst
>> 
>> diff --git a/Documentation/virt/kvm/arm/index.rst 
>> b/Documentation/virt/kvm/arm/index.rst
>> index 78a9b670aafe..e77a0ee2e2d4 100644
>> --- a/Documentation/virt/kvm/arm/index.rst
>> +++ b/Documentation/virt/kvm/arm/index.rst
>> @@ -11,3 +11,4 @@ ARM
>>     psci
>>     pvtime
>>     ptp_kvm
>> +   mmio-guard
>> diff --git a/Documentation/virt/kvm/arm/mmio-guard.rst 
>> b/Documentation/virt/kvm/arm/mmio-guard.rst
>> new file mode 100644
>> index 000000000000..a5563a3e12cc
>> --- /dev/null
>> +++ b/Documentation/virt/kvm/arm/mmio-guard.rst
>> @@ -0,0 +1,73 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +==============
>> +KVM MMIO guard
>> +==============
>> +
>> +KVM implements device emulation by handling translation faults to any
>> +IPA range that is not contained a memory slot. Such translation fault
>                                   ^ in                ^ a
> 
>> +is in most cases passed on to userspace (or in rare cases to the host
>> +kernel) with the address, size and possibly data of the access for
>> +emulation.
>> +
>> +Should the guest exit with an address that is not one that 
>> corresponds
>> +to an emulatable device, userspace may take measures that are not the
>> +most graceful as far as the guest is concerned (such as terminating 
>> it
>> +or delivering a fatal exception).
>> +
>> +There is also an element of trust: by forwarding the request to
>> +userspace, the kernel asumes that the guest trusts userspace to do 
>> the
> 
> assumes
> 
>> +right thing.
>> +
>> +The KVM MMIO guard offers a way to mitigate this last point: a guest
>> +can request that only certainly regions of the IPA space are valid as
> 
> certain

Thanks, all corrections applied.

> 
>> +MMIO. Only these regions will be handled as an MMIO, and any other
>> +will result in an exception being delivered to the guest.
>> +
>> +This relies on a set of hypercalls defined in the KVM-specific range,
>> +using the HVC64 calling convention.
>> +
>> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO
>> +
>> +    ==============    ========    ================================
>> +    Function ID:      (uint32)    0xC6000002
>> +    Arguments:        none
>> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
>> +                      (uint64)    Protection Granule (PG) size in
>> +		                  bytes (r0)
>> +    ==============    ========    ================================
>> +
>> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL
>> +
>> +    ==============    ========    ==============================
>> +    Function ID:      (uint32)    0xC6000003
>> +    Arguments:        none
>> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
>> +                                  RET_SUCCESS(0) (r0)
>> +    ==============    ========    ==============================
>> +
>> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP
>> +
>> +    ==============    ========    
>> ======================================
>> +    Function ID:      (uint32)    0xC6000004
>> +    Arguments:        (uint64)    The base of the PG-sized IPA range
>> +                                  that is allowed to be accessed as
>> +				  MMIO. Must aligned to the PG size (r1)
> 
> align

Hmmm. Ugly mix of tab and spaces. I have no idea what the norm
is here, so I'll just put spaces. I'm sure someone will let me
know if I'm wrong! ;-)

> 
>> +                      (uint64)    Index in the MAIR_EL1 register
>> +		                  providing the memory attribute that
>> +				  is used by the guest (r2)
>> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
>> +                                  RET_SUCCESS(0) (r0)
>> +    ==============    ========    
>> ======================================
>> +
>> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP
>> +
>> +    ==============    ========    
>> ======================================
>> +    Function ID:      (uint32)    0xC6000004
> 
> copy+paste error, should be 0xC6000005

Gah, well cpotted.

> 
>> +    Arguments:        (uint64)    The base of the PG-sized IPA range
>> +                                  that is forbidden to be accessed as
> 
> is now forbidden
> 
> or
> 
> was allowed
> 
> or just drop that part of the sentence because its covered by the "and
> have been previously mapped" part. Something like
> 
> PG-sized IPA range aligned to the PG size which has been previously 
> mapped
> (r1)

Picked the latter.

Thanks again,

         M.
-- 
Jazz is not dead. It just smells funny...
