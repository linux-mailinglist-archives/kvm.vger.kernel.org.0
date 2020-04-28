Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5161BB983
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 11:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgD1JI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 05:08:56 -0400
Received: from foss.arm.com ([217.140.110.172]:48100 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgD1JIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 05:08:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A83B30E;
        Tue, 28 Apr 2020 02:08:55 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A8743F305;
        Tue, 28 Apr 2020 02:08:53 -0700 (PDT)
Subject: Re: [PATCH][kvmtool] kvm: Request VM specific limits instead of
 system-wide ones
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
References: <20200427141738.285217-1-maz@kernel.org>
 <d27e4a14-34b8-7f3d-1e58-ef2ae13e443b@arm.com>
 <7ac17890-72d1-1c81-e513-5d4f7841ca9d@arm.com> <20200427183331.48f411f5@why>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9305b65b-8431-e609-6756-07f1960ff95e@arm.com>
Date:   Tue, 28 Apr 2020 10:09:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427183331.48f411f5@why>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/27/20 6:33 PM, Marc Zyngier wrote:
> On Mon, 27 Apr 2020 16:00:58 +0100
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
>> Hi,
>>
>> On 4/27/20 3:44 PM, Alexandru Elisei wrote:
>>> Hi,
>>>
>>> On 4/27/20 3:17 PM, Marc Zyngier wrote:  
>>>> On arm64, the maximum number of vcpus is constrained by the type
>>>> of interrupt controller that has been selected (GICv2 imposes a
>>>> limit of 8 vcpus, while GICv3 currently has a limit of 512).
>>>>
>>>> It is thus important to request this limit on the VM file descriptor
>>>> rather than on the one that corresponds to /dev/kvm, as the latter
>>>> is likely to return something that doesn't take the constraints into
>>>> account.
>>>>
>>>> Reported-by: Ard Biesheuvel <ardb@kernel.org>
>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>> ---
>>>>  kvm.c | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/kvm.c b/kvm.c
>>>> index e327541..3d5173d 100644
>>>> --- a/kvm.c
>>>> +++ b/kvm.c
>>>> @@ -406,7 +406,7 @@ int kvm__recommended_cpus(struct kvm *kvm)
>>>>  {
>>>>  	int ret;
>>>>  
>>>> -	ret = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION, KVM_CAP_NR_VCPUS);
>>>> +	ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_NR_VCPUS);
>>>>  	if (ret <= 0)
>>>>  		/*
>>>>  		 * api.txt states that if KVM_CAP_NR_VCPUS does not exist,
>>>> @@ -421,7 +421,7 @@ int kvm__max_cpus(struct kvm *kvm)
>>>>  {
>>>>  	int ret;
>>>>  
>>>> -	ret = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION, KVM_CAP_MAX_VCPUS);
>>>> +	ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_MAX_VCPUS);
>>>>  	if (ret <= 0)
>>>>  		ret = kvm__recommended_cpus(kvm);
>>>>    
>>> I've checked that gic__create comes before the call kvm__recommended_capus:
>>> gic__create is in core_init (called via kvm__init->kvm_arch_init), and
>>> kvm__recommended_cpus is in base_init (called via kvm__cpu_init ->
>>> kvm__{recommended,max}_cpus).
>>>
>>> The KVM api documentation states that KVM_CHECK_EXTENSION is available for the vm
>>> fd only if the system capability KVM_CAP_CHECK_EXTENSION_VM is present. kvmtool
>>> already has a function for checking extensions on the vm fd, it's called
>>> kvm__supports_vm_extension. Can we use that instead of doing the ioctl directly on
>>> the vm fd?  
>> Scratch that, kvm__supports_vm_extension returns a bool, not an int.
>> How about we write kvm__check_vm_extension that returns an int, and
>> kvm__supports_vm_extension calls it?
> That, or we just change the return type for kvm__supports_vm_extension,
> and hack the only places that uses it so far (the GIC code) to detect
> the error.

Yep, whatever you prefer.

Thanks,
Alex
