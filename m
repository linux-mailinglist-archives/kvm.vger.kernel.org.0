Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CEE3A300A
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 18:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhFJQEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 12:04:38 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3203 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJQEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 12:04:37 -0400
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4G17hY43GQz6M4gy;
        Thu, 10 Jun 2021 23:49:49 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 18:02:39 +0200
Received: from localhost (10.52.126.112) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 17:02:38 +0100
Date:   Thu, 10 Jun 2021 17:02:35 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     <maz@kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <corbet@lwn.net>, <james.morse@arm.com>,
        <alexandru.elisei@arm.com>, <suzuki.poulose@arm.com>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <lorenzo.pieralisi@arm.com>, <salil.mehta@huawei.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [RFC PATCH 4/5] KVM: arm64: Pass hypercalls to userspace
Message-ID: <20210610170235.00003494@Huawei.com>
In-Reply-To: <20210608154805.216869-5-jean-philippe@linaro.org>
References: <20210608154805.216869-1-jean-philippe@linaro.org>
        <20210608154805.216869-5-jean-philippe@linaro.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.126.112]
X-ClientProxiedBy: lhreml728-chm.china.huawei.com (10.201.108.79) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  8 Jun 2021 17:48:05 +0200
Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:

> Let userspace request to handle all hypercalls that aren't handled by
> KVM, by setting the KVM_CAP_ARM_HVC_TO_USER capability.
> 
> With the help of another capability, this will allow userspace to handle
> PSCI calls.
> 
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

Trivial question inline.


> ---
> 
> Notes on this implementation:
> 
> * A similar mechanism was proposed for SDEI some time ago [1]. This RFC
>   generalizes the idea to all hypercalls, since that was suggested on
>   the list [2, 3].
> 
> * We're reusing kvm_run.hypercall. I copied x0-x5 into
>   kvm_run.hypercall.args[] to help userspace but I'm tempted to remove
>   this, because:
>   - Most user handlers will need to write results back into the
>     registers (x0-x3 for SMCCC), so if we keep this shortcut we should
>     go all the way and synchronize them on return to kernel.
>   - QEMU doesn't care about this shortcut, it pulls all vcpu regs before
>     handling the call.
>   - SMCCC uses x0-x16 for parameters.
>   x0 does contain the SMCCC function ID and may be useful for fast
>   dispatch, we could keep that plus the immediate number.
> 
> * Should we add a flag in the kvm_run.hypercall telling whether this is
>   HVC or SMC?  Can be added later in those bottom longmode and pad
>   fields.
> 
> * On top of this we could share with userspace which HVC ranges are
>   available and which ones are handled by KVM. That can actually be
>   added independently, through a vCPU/VM device attribute (which doesn't
>   consume a new ioctl):
>   - userspace issues HAS_ATTR ioctl on the VM fd to query whether this
>     feature is available.
>   - userspace queries the number N of HVC ranges using one GET_ATTR.
>   - userspace passes an array of N ranges using another GET_ATTR.
>     The array is filled and returned by KVM.
> 
> * Untested for AArch32 guests.
> 
> [1] https://lore.kernel.org/linux-arm-kernel/20170808164616.25949-12-james.morse@arm.com/
> [2] https://lore.kernel.org/linux-arm-kernel/bf7e83f1-c58e-8d65-edd0-d08f27b8b766@arm.com/
> [3] https://lore.kernel.org/linux-arm-kernel/f56cf420-affc-35f0-2355-801a924b8a35@arm.com/
> ---
>  Documentation/virt/kvm/api.rst    | 17 +++++++++++++++--
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  include/kvm/arm_psci.h            |  4 ++++
>  include/uapi/linux/kvm.h          |  1 +
>  arch/arm64/kvm/arm.c              |  5 +++++
>  arch/arm64/kvm/hypercalls.c       | 28 +++++++++++++++++++++++++++-
>  6 files changed, 53 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index e4fe7fb60d5d..3d8c1661e7b2 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5228,8 +5228,12 @@ to the byte array.
>  			__u32 pad;
>  		} hypercall;
>  
> -Unused.  This was once used for 'hypercall to userspace'.  To implement
> -such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
> +On x86 this was once used for 'hypercall to userspace'.  To implement such
> +functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
> +
> +On arm64 it is used for hypercalls, when the KVM_CAP_ARM_HVC_TO_USER capability
> +is enabled. 'nr' contains the HVC or SMC immediate. 'args' contains registers
> +x0 - x5. The other parameters are unused.
>  
>  .. note:: KVM_EXIT_IO is significantly faster than KVM_EXIT_MMIO.
>  
> @@ -6894,3 +6898,12 @@ This capability is always enabled.
>  This capability indicates that the KVM virtual PTP service is
>  supported in the host. A VMM can check whether the service is
>  available to the guest on migration.
> +
> +8.33 KVM_CAP_ARM_HVC_TO_USER
> +----------------------------
> +
> +:Architecture: arm64
> +
> +This capability indicates that KVM can pass unhandled hypercalls to userspace,
> +if the VMM enables it. Hypercalls are passed with KVM_EXIT_HYPERCALL in
> +kvm_run::hypercall.
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3ca732feb9a5..25554ce97045 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -123,6 +123,7 @@ struct kvm_arch {
>  	 * supported.
>  	 */
>  	bool return_nisv_io_abort_to_user;
> +	bool hvc_to_user;
>  
>  	/*
>  	 * VM-wide PMU filter, implemented as a bitmap and big enough for
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index 5b58bd2fe088..d6b71a48fbb1 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -16,6 +16,10 @@
>  
>  #define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
>  
> +#define KVM_PSCI_FN_LAST	KVM_PSCI_FN(3)
> +#define PSCI_0_2_FN_LAST	PSCI_0_2_FN(0x3f)
> +#define PSCI_0_2_FN64_LAST	PSCI_0_2_FN64(0x3f)

Why 3f?  Perhaps a spec reference if appropriate.

> +
>  /*
>   * We need the KVM pointer independently from the vcpu as we can call
>   * this from HYP, and need to apply kern_hyp_va on it...
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 06ba64c49737..aa831986a399 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1084,6 +1084,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
>  #define KVM_CAP_PTP_KVM 198
>  #define KVM_CAP_ARM_MP_HALTED 199
> +#define KVM_CAP_ARM_HVC_TO_USER 200
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index d6ad977fea5f..074197721e97 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -93,6 +93,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r = 0;
>  		kvm->arch.return_nisv_io_abort_to_user = true;
>  		break;
> +	case KVM_CAP_ARM_HVC_TO_USER:
> +		r = 0;
> +		kvm->arch.hvc_to_user = true;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -208,6 +212,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_VCPU_ATTRIBUTES:
>  	case KVM_CAP_PTP_KVM:
>  	case KVM_CAP_ARM_MP_HALTED:
> +	case KVM_CAP_ARM_HVC_TO_USER:
>  		r = 1;
>  		break;
>  	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 30da78f72b3b..ccc2015eddf9 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -58,6 +58,28 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
>  	val[3] = lower_32_bits(cycles);
>  }
>  
> +static int kvm_hvc_user(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	struct kvm_run *run = vcpu->run;
> +
> +	if (!vcpu->kvm->arch.hvc_to_user) {
> +		smccc_set_retval(vcpu, SMCCC_RET_NOT_SUPPORTED, 0, 0, 0);
> +		return 1;
> +	}
> +
> +	run->exit_reason = KVM_EXIT_HYPERCALL;
> +	run->hypercall.nr = kvm_vcpu_hvc_get_imm(vcpu);
> +	/* Copy the first parameters for fast access */
> +	for (i = 0; i < 6; i++)
> +		run->hypercall.args[i] = vcpu_get_reg(vcpu, i);
> +	run->hypercall.ret = 0;
> +	run->hypercall.longmode = 0;
> +	run->hypercall.pad = 0;
> +
> +	return 0;
> +}
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  {
>  	u32 func_id = smccc_get_function(vcpu);
> @@ -139,8 +161,12 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	case ARM_SMCCC_TRNG_RND32:
>  	case ARM_SMCCC_TRNG_RND64:
>  		return kvm_trng_call(vcpu);
> -	default:
> +	case KVM_PSCI_FN_BASE...KVM_PSCI_FN_LAST:
> +	case PSCI_0_2_FN_BASE...PSCI_0_2_FN_LAST:
> +	case PSCI_0_2_FN64_BASE...PSCI_0_2_FN64_LAST:
>  		return kvm_psci_call(vcpu);
> +	default:
> +		return kvm_hvc_user(vcpu);
>  	}
>  
>  	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);

