Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12A23A42FD
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 15:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhFKN00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 09:26:26 -0400
Received: from foss.arm.com ([217.140.110.172]:58272 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhFKN0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 09:26:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B1EAD6E;
        Fri, 11 Jun 2021 06:24:23 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B86953F73D;
        Fri, 11 Jun 2021 06:24:21 -0700 (PDT)
Subject: Re: [RFC PATCH 4/4] KVM: arm64: Introduce KVM_CAP_ARM_PROTECTED_VM
To:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20210603183347.1695-1-will@kernel.org>
 <20210603183347.1695-5-will@kernel.org> <YLk4e4hark3Zhi3f@google.com>
 <20210608120815.GE10174@willie-the-truck>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <64dd2c13-defd-f01c-f06d-13b2d9d3a88a@arm.com>
Date:   Fri, 11 Jun 2021 14:25:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608120815.GE10174@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On 6/8/21 1:08 PM, Will Deacon wrote:
> Hi Sean,
>
> Thanks for having a look.
>
> On Thu, Jun 03, 2021 at 08:15:55PM +0000, Sean Christopherson wrote:
>> On Thu, Jun 03, 2021, Will Deacon wrote:
>>> [..]
>>
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index 3fd9a7e9d90c..58ab8508be5e 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -1082,6 +1082,7 @@ struct kvm_ppc_resize_hpt {
>>>  #define KVM_CAP_SGX_ATTRIBUTE 196
>>>  #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
>>>  #define KVM_CAP_PTP_KVM 198
>>> +#define KVM_CAP_ARM_PROTECTED_VM 199
>> Rather than a dedicated (and arm-only) capability for protected VMs, what about
>> adding a capability to retrieve the supported VM types?  And obviously make
>> protected VMs a different type that must be specified at VM creation (there's
>> already plumbing for this).  Even if there's no current need to know at creation
>> time that a VM will be protected, it's also unlikely to be a burden on userspace
>> and could be nice to have down the road.  The late "activation" ioctl() can still
>> be supported, e.g. to start disallowing memslot updates.
>>
>> x86 with TDX would look like:
>>
>>         case KVM_CAP_VM_TYPES:
>>                 r = BIT(KVM_X86_LEGACY_VM);
>>                 if (kvm_x86_ops.is_vm_type_supported(KVM_X86_TDX_VM))
>>                         r |= BIT(KVM_X86_TDX_VM);
>>                 break;
>>
>> and arm64 would look like?
>>
>> 	case KVM_CAP_VM_TYPES:
>> 		r = BIT(KVM_ARM64_LEGACY_VM);
>> 		if (kvm_get_mode() == KVM_MODE_PROTECTED)
>> 			r |= BIT(KVM_ARM64_PROTECTED_VM);
>> 		break;
> You're not the first person to mention this, so I'll look into it. We'll
> still need the cap, not just for deferring activation, but also for querying
> the firmware parameters.

I had a look at the series that rejects unsupported VCPU features from a protected
VM [1], and it got me thinking. With this ABI in mind, it will be permitted for an
userspace VMM to do the following:

1. Create a VM -> success.

2. Check the KVM_CAP_ARM_PMU_V3 (cap chosen randomly) on the **VM fd** -> it's
available.

3. Set the VCPU feature and create the VCPU -> success.

4. <do other initialization stuff>

5. Turn the VM into a protected VM -> failure, because KVM_ARM_VCPU_PMU_V3 was
part of the VCPU features.

To me, that looks a bit strange. On the other hand, if KVM knew right from VM
creation time that the VM is protected, KVM could have told userspace that that
VCPU feature is not supported **for this particular type of VM**. I think that
makes for a much cleaner userspace API. Yes, it would still be possible to check
the cap on the KVM fd and get success, but we could make the argument that those
capabilities represent the capabilities that KVM supports for any type of VM, not
this particular type.

This can also be used for discovering new features added to pKVM. How do you
intend to do that with the current ABI? By adding a version field to struct
kvm_protected_vm_info, where each version comes with a fixed set of features that
are supported?

[1] https://www.spinics.net/lists/kvm/msg245882.html

Thanks,

Alex

