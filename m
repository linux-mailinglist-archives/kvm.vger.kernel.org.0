Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438B53B8FFA
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 11:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235890AbhGAJtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 05:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbhGAJtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 05:49:32 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6EDC061756
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 02:47:02 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id o6so6589911oic.9
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 02:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CzA0jCepO54uwES15x6DkUyCTw6qvrEVHWRi3DUevtg=;
        b=hb7Pi70sYKHDLlWSjMIT/b4qJZ4aoqdthmN1Npw6Z6jTYOcvRlg1xYefHz5+gNexYM
         Wjo9xxvk/HcGIGI+nhlCMSsdRCwzhEANhHo4lmY/bItZti1yjccrItuRgbZKamCed1EQ
         7k8+YCFIS8lnHiDAuCeC7J/1Emtw03g7LEol8uZ+Ne359NCyssINd0u6pevm04senxJN
         iDYv/mkXXuhfJlFxUHTa2mvm2Nr7YPnMxAOLTwDF09MAWJkOa+KVcN415sXWvH9SmvYl
         dFydYqTyOYcy+4xXISqTTpXYHZADhMvH/VdTtTEPDkyZN4Eq2tMAhAXROGNaLP1AS8OH
         DyBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CzA0jCepO54uwES15x6DkUyCTw6qvrEVHWRi3DUevtg=;
        b=WF6QVwNFYGo0+f85stascphDxuXfvKNFlpIXQYztn4LPAzjm3cIxfLCWXcXY6P8V8v
         TsUBDSCipU8BuoQmngEqvv4RX81k5MRlA+NA8BtGLpaY1zcW7nM2Gf60URgIr8zP0ROQ
         LmeGJ+GMPXuVdOBsILq4az50vCx1+EPJPkdFweZzJFlBi8cTjTVz8Flt1iHe1jOlyk1X
         dxPpWrE5P/CB7M9Y/9WdQBknpCQD/PUVsrrGXS/5oc3Hd0/9+Yl/JiRlBUZJnowxrh76
         KNvvPvvwnmJ0jtUhmLm4Hs64LHdPeAGpWIl3FJHZsv+LJLWiMO8/eXR7gouVclxrjKuP
         meQg==
X-Gm-Message-State: AOAM531EYcL7jBvvHKC8/C6NiFlsXC79gJzsZ9RpqcLDVQCNWqOeYDj9
        90PVaecVTggGZyCr2kaxsLXr9ZGOckGF7u9BKW7ISw==
X-Google-Smtp-Source: ABdhPJxEuiySzfwt1ZUEiyiI0LrUpKHPQgujuf7t3DIRA3CqgwzGKwm8+vLecpKuc10szVB0w6eMLkvYCVo8fS42YMk=
X-Received: by 2002:a05:6808:158b:: with SMTP id t11mr132724oiw.8.1625132821520;
 Thu, 01 Jul 2021 02:47:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210608154805.216869-1-jean-philippe@linaro.org> <20210608154805.216869-5-jean-philippe@linaro.org>
In-Reply-To: <20210608154805.216869-5-jean-philippe@linaro.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 1 Jul 2021 10:46:25 +0100
Message-ID: <CA+EHjTygpsnA89itDxNi015W=uv2NjtzDfApOzU1eMHvhpvdrw@mail.gmail.com>
Subject: Re: [RFC PATCH 4/5] KVM: arm64: Pass hypercalls to userspace
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     maz@kernel.org, salil.mehta@huawei.com, lorenzo.pieralisi@arm.com,
        kvm@vger.kernel.org, corbet@lwn.net, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, will@kernel.org,
        jonathan.cameron@huawei.com, pbonzini@redhat.com,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean-Philippe,

On Tue, Jun 8, 2021 at 4:54 PM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> Let userspace request to handle all hypercalls that aren't handled by
> KVM, by setting the KVM_CAP_ARM_HVC_TO_USER capability.
>
> With the help of another capability, this will allow userspace to handle
> PSCI calls.
>
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
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

Another reason, which supports the last item on this list, to consider
removing the copying to kvm_run.hypercall.args is PSCA*, which I think
does use registers beyond x5 for some calls.

* https://developer.arm.com/-/media/Files/pdf/PlatformSecurityArchitecture/Architect/DEN0063-PSA_Firmware_Framework-1.0.0-2.pdf?revision=2d1429fa-4b5b-461a-a60e-4ef3d8f7f4b4

>   x0 does contain the SMCCC function ID and may be useful for fast
>   dispatch, we could keep that plus the immediate number.
>
> * Should we add a flag in the kvm_run.hypercall telling whether this is
>   HVC or SMC?  Can be added later in those bottom longmode and pad
>   fields.

Would it make sense to make this even more fine-grained, where there
would be two capabilities, e.g., one KVM_CAP_ARM_HVC_TO_USER and
another KVM_CAP_ARM_SMC_TO_USER, to select whether to handle the one
or the other (or maybe a parameter of KVM_CAP_ARM_HVC_TO_USER that
selects what subset to handle, e.g., psci). I cannot think of a
use-case to be honest, but considering whether such fine-grained
control is helpful or just unnecessary overkill.

But as you suggest, I think that having a flag to indicate whether
this is an hvc or an smc would be good.

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
>                         __u32 pad;
>                 } hypercall;
>
> -Unused.  This was once used for 'hypercall to userspace'.  To implement
> -such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
> +On x86 this was once used for 'hypercall to userspace'.  To implement such
> +functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).

Should the "all except s390" become "all except s390 and arm64"? The
following paragraph clarifies this, but thinking about the person who
might be just skimming through the documentation.

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
>          * supported.
>          */
>         bool return_nisv_io_abort_to_user;
> +       bool hvc_to_user;

Maybe some documentation for this field, similar to
return_nisv_io_abort_to_user above?

>
>         /*
>          * VM-wide PMU filter, implemented as a bitmap and big enough for
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index 5b58bd2fe088..d6b71a48fbb1 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -16,6 +16,10 @@
>
>  #define KVM_ARM_PSCI_LATEST    KVM_ARM_PSCI_1_0
>
> +#define KVM_PSCI_FN_LAST       KVM_PSCI_FN(3)
> +#define PSCI_0_2_FN_LAST       PSCI_0_2_FN(0x3f)
> +#define PSCI_0_2_FN64_LAST     PSCI_0_2_FN64(0x3f)

I think it might be clearer to define these where their _BASE
counterparts are, i.e., uapi/asm/kvm.h and uapi/linux/psci.h.

Also, should _LAST be 0x1f rather than 0x3f, or do you want to include SDEI?
https://developer.arm.com/documentation/den0028/latest

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
>                 r = 0;
>                 kvm->arch.return_nisv_io_abort_to_user = true;
>                 break;
> +       case KVM_CAP_ARM_HVC_TO_USER:
> +               r = 0;
> +               kvm->arch.hvc_to_user = true;
> +               break;
>         default:
>                 r = -EINVAL;
>                 break;
> @@ -208,6 +212,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_VCPU_ATTRIBUTES:
>         case KVM_CAP_PTP_KVM:
>         case KVM_CAP_ARM_MP_HALTED:
> +       case KVM_CAP_ARM_HVC_TO_USER:
>                 r = 1;
>                 break;
>         case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 30da78f72b3b..ccc2015eddf9 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -58,6 +58,28 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
>         val[3] = lower_32_bits(cycles);
>  }
>
> +static int kvm_hvc_user(struct kvm_vcpu *vcpu)
> +{
> +       int i;
> +       struct kvm_run *run = vcpu->run;
> +
> +       if (!vcpu->kvm->arch.hvc_to_user) {
> +               smccc_set_retval(vcpu, SMCCC_RET_NOT_SUPPORTED, 0, 0, 0);
> +               return 1;
> +       }
> +
> +       run->exit_reason = KVM_EXIT_HYPERCALL;
> +       run->hypercall.nr = kvm_vcpu_hvc_get_imm(vcpu);
> +       /* Copy the first parameters for fast access */
> +       for (i = 0; i < 6; i++)

nit: ARRAY_SIZE(run->hypercall.args) instead of 6?

> +               run->hypercall.args[i] = vcpu_get_reg(vcpu, i);
> +       run->hypercall.ret = 0;
> +       run->hypercall.longmode = 0;
> +       run->hypercall.pad = 0;
> +
> +       return 0;
> +}
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  {
>         u32 func_id = smccc_get_function(vcpu);
> @@ -139,8 +161,12 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>         case ARM_SMCCC_TRNG_RND32:
>         case ARM_SMCCC_TRNG_RND64:
>                 return kvm_trng_call(vcpu);
> -       default:
> +       case KVM_PSCI_FN_BASE...KVM_PSCI_FN_LAST:
> +       case PSCI_0_2_FN_BASE...PSCI_0_2_FN_LAST:
> +       case PSCI_0_2_FN64_BASE...PSCI_0_2_FN64_LAST:
>                 return kvm_psci_call(vcpu);
> +       default:
> +               return kvm_hvc_user(vcpu);
>         }

I know that SMCCC is a convention, but would it make sense to exclude
other ranges, e.g., not allocated, trusted os-related, or reserved for
future use?

Thanks,
/fuad



>
>         smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> --
> 2.31.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
