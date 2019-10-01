Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C4FC3E70
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 19:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbfJARTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 13:19:42 -0400
Received: from foss.arm.com ([217.140.110.172]:54982 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbfJARTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 13:19:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B28001570;
        Tue,  1 Oct 2019 10:19:40 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0BF1A3F918;
        Tue,  1 Oct 2019 10:19:32 -0700 (PDT)
Subject: Re: [RFC PATCH 2/2] kvm/arm64: expose hypercall_forwarding capability
To:     Heyi Guo <guoheyi@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, wanghaibin.wang@huawei.com,
        Peter Maydell <peter.maydell@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1569338454-26202-1-git-send-email-guoheyi@huawei.com>
 <1569338454-26202-3-git-send-email-guoheyi@huawei.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <bd2c398b-7703-03a2-052b-1414630d0b43@arm.com>
Date:   Tue, 1 Oct 2019 18:19:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1569338454-26202-3-git-send-email-guoheyi@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Heyi,

On 24/09/2019 16:20, Heyi Guo wrote:
> Add new KVM capability "KVM_CAP_FORWARD_HYPERCALL" for user space to
> probe whether KVM supports forwarding hypercall.
> 
> The capability should be enabled by user space explicitly, for we
> don't want user space application to deal with unexpected hypercall
> exits. We also use an additional argument to pass exception bit mask,
> to request KVM to forward all hypercalls except the classes specified
> in the bit mask.
> 
> Currently only PSCI can be set as exception, so that we can still keep
> consistent with the old PSCI processing flow.

I agree this needs to be default-on, but I don't think this exclusion mechanism is extensible.


> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index f4a8ae9..2201b62 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -102,6 +105,28 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	return r;
>  }
>  
> +int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> +			    struct kvm_enable_cap *cap)
> +{
> +	if (cap->flags)
> +		return -EINVAL;
> +
> +	switch (cap->cap) {
> +	case KVM_CAP_FORWARD_HYPERCALL: {
> +		__u64 exclude_flags = cap->args[0];

and if there are more than 64 things to exclude?


> +		/* Only support excluding PSCI right now */
> +		if (exclude_flags & ~KVM_CAP_FORWARD_HYPERCALL_EXCL_PSCI)
> +			return -EINVAL;

Once we have a 65th bit, older kernels will let user-space set it, but nothing happens.


> +		kvm->arch.hypercall_forward = true;
> +		if (exclude_flags & KVM_CAP_FORWARD_HYPERCALL_EXCL_PSCI)
> +			kvm->arch.hypercall_excl_psci = true;
> +		return 0;
> +	}
> +	}
> +
> +	return -EINVAL;
> +}

While 4*64 'named bits' for SMC/HVC ranges might be enough, it is tricky to work with.
Both the kernel and user-space have to maintain a list of bit->name and
name->call-number-range, which may change over time.

A case in point: According to PSCI's History (Section 7 of DEN022D), PSCIv1.1 added
SYSTEM_RESET2, MEM_PROTECT and MEM_PROTECT_CHECK_RANGE.

I think its simpler for the HYPERCALL thing to act as a catch-all, and we provide
something to enumerate the list of function id's the kernel implements.

We can then add controls to disable the PSCI (which I think is the only one we have a case
for disabling). I think the PSCI disable should wait until it has a user.


Thanks,

James
