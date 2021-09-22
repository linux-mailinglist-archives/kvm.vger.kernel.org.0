Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8175414E3C
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 18:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhIVQl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 12:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236586AbhIVQl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 12:41:26 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334BFC061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 09:39:56 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id f3-20020a17090a638300b00199097ddf1aso4945568pjj.0
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 09:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PW23i0GIZpYOKEzTqk+0cWYUuyP87m/dxg4zLRnBdeE=;
        b=OHK/38foGKQMIzX+tMw54pe3+we6z+GqAb7EYV48FrolmOZA5ZXs75Vz7ptO5O5QCc
         3ObsP0ezCd98tkelKfylwWr94LLC7Lp5ZoJ8vsQOzxaiw14PVfhxIPD6gSETeTcVr8WC
         RwMAUHFBjrWwdaHOUOLvz2oc8qgwfCSadjUSe6iSExZvCsUwbrX3gaBxA51eCqTFM8cc
         HFO0j3TDOH2XPK5GYrGt1Arj75+JoD3Ucgop5nTuYgoZK136P1tdtFT4e84393IFiBtq
         6Qjwf5UaaLoP7YQWfaDisTvjiWRmaVF85t3igVA4eoy/KYk6zwPrYlIqBrtwL1UlL8J7
         GAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PW23i0GIZpYOKEzTqk+0cWYUuyP87m/dxg4zLRnBdeE=;
        b=qGYLu+gHO1PXwH7YutwdCI7bvcivMi209nTCUc9SxEZylmhUBQq2/G6xfMPCUz9O8a
         3zC+OiQUOG+2WdG/pFx7ErXM6mHlVOdCO45LZlmMFzCHmD1ZwO5lCgMdcQW7DysvRWHd
         Gv2BkOIyIq3KukcFt2kHDgFvdgZFodxe5XohJL1ts4SdY8/f06W8bvbhXQq9QRFM38hH
         VZfg6gEhtrPE4YvtKXgc5j1faYWJrO3xjUqXsXm9xS8sQawaLqkW5CSwSIYq/tDO3YAN
         LIeWnNqx9zsb01eHXwTSdG9Ui+gixdiR5WENHZma0LHw3d9ih4KXR101gQCn1bD58bj5
         aUAA==
X-Gm-Message-State: AOAM532QETMgBK+0vo5VCZvIYm9XibJMZjg8Adlh31shQm/RIHniP08W
        7eOKQ6DMCanZXCmA61Z/B5TfmOCfSq9RHjilO9DSQw==
X-Google-Smtp-Source: ABdhPJz8H/RAL1dI93d737TYTOWsckzgACsNdTYWFWDVvnwdX9XiTvZdEh3MxX8nyFxDYqhzGhMLSHvHBonLNgpfCKs=
X-Received: by 2002:a17:90b:3702:: with SMTP id mg2mr52409pjb.110.1632328795320;
 Wed, 22 Sep 2021 09:39:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com> <20210916181510.963449-7-oupton@google.com>
In-Reply-To: <20210916181510.963449-7-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 22 Sep 2021 09:39:39 -0700
Message-ID: <CAAeT=Fwrh5L8FNKVJipOH6a8MohRsPOgmJDhojRw8DkAS4Kk2Q@mail.gmail.com>
Subject: Re: [PATCH v8 6/8] KVM: arm64: Allow userspace to configure a guest's
 counter-timer offset
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Thu, Sep 16, 2021 at 11:15 AM Oliver Upton <oupton@google.com> wrote:
>
> Presently, KVM provides no facilities for correctly migrating a guest
> that depends on the physical counter-timer. While most guests (barring
> NV, of course) should not depend on the physical counter-timer, an
> operator may wish to provide a consistent view of the physical
> counter-timer across migrations.
>
> Provide userspace with a new vCPU attribute to modify the guest
> counter-timer offset. Unlike KVM_REG_ARM_TIMER_OFFSET, this attribute is
> hidden from the guest's architectural state. The value offsets *both*
> the virtual and physical counter-timer views for the guest. Only support
> this attribute on ECV systems as ECV is required for hardware offsetting
> of the physical counter-timer.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>  Documentation/arm64/booting.rst         |  7 ++
>  Documentation/virt/kvm/devices/vcpu.rst | 28 ++++++++
>  arch/arm64/include/asm/sysreg.h         |  2 +
>  arch/arm64/include/uapi/asm/kvm.h       |  1 +
>  arch/arm64/kvm/arch_timer.c             | 96 ++++++++++++++++++++++++-
>  include/clocksource/arm_arch_timer.h    |  1 +
>  include/kvm/arm_arch_timer.h            |  5 ++
>  7 files changed, 138 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/arm64/booting.rst b/Documentation/arm64/booting.rst
> index 3f9d86557c5e..b0e012da9b3b 100644
> --- a/Documentation/arm64/booting.rst
> +++ b/Documentation/arm64/booting.rst
> @@ -340,6 +340,13 @@ Before jumping into the kernel, the following conditions must be met:
>      - SMCR_EL2.LEN must be initialised to the same value for all CPUs the
>        kernel will execute on.
>
> +  For CPUs with the Enhanced Counter Virtualization (FEAT_ECV) extension
> +  present with ID_AA64MMFR0_EL1.ECV >= 0x2:
> +
> +  - if EL3 is present and the kernel is entered at EL2:
> +
> +    - SCR_EL3.ECVEn (bit 28) must be initialized to 0b1.
> +
>  The requirements described above for CPU mode, caches, MMUs, architected
>  timers, coherency and system registers apply to all CPUs.  All CPUs must
>  enter the kernel in the same exception level.  Where the values documented
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index 2acec3b9ef65..f240ecc174ef 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -139,6 +139,34 @@ configured values on other VCPUs.  Userspace should configure the interrupt
>  numbers on at least one VCPU after creating all VCPUs and before running any
>  VCPUs.
>
> +2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_PHYS_OFFSET
> +-----------------------------------------
> +
> +:Parameters: in kvm_device_attr.addr the address for the timer offset is a
> +             pointer to a __u64
> +
> +Returns:
> +
> +        ======= ==================================
> +        -EFAULT Error reading/writing the provided
> +                parameter address
> +        -ENXIO  Timer offsetting not implemented
> +        ======= ==================================
> +
> +Specifies the guest's counter-timer offset from the host's virtual counter.
> +The guest's physical counter value is then derived by the following
> +equation:
> +
> +  guest_cntpct = host_cntvct - KVM_ARM_VCPU_TIMER_PHYS_OFFSET
> +
> +The guest's virtual counter value is derived by the following equation:
> +
> +  guest_cntvct = host_cntvct - KVM_REG_ARM_TIMER_OFFSET
> +                       - KVM_ARM_VCPU_TIMER_PHYS_OFFSET
> +
> +KVM does not allow the use of varying offset values for different vCPUs;
> +the last written offset value will be broadcasted to all vCPUs in a VM.
> +
>  3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
>  ==================================
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 3fa6b091384d..d5a686dff57e 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -587,6 +587,8 @@
>  #define SYS_ICH_LR14_EL2               __SYS__LR8_EL2(6)
>  #define SYS_ICH_LR15_EL2               __SYS__LR8_EL2(7)
>
> +#define SYS_CNTPOFF_EL2                        sys_reg(3, 4, 14, 0, 6)
> +
>  /* VHE encodings for architectural EL0/1 system registers */
>  #define SYS_SCTLR_EL12                 sys_reg(3, 5, 1, 0, 0)
>  #define SYS_CPACR_EL12                 sys_reg(3, 5, 1, 0, 2)
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 949a31bc10f0..70e2893c1749 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -366,6 +366,7 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_ARM_VCPU_TIMER_CTRL                1
>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER                0
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER                1
> +#define   KVM_ARM_VCPU_TIMER_PHYS_OFFSET       2
>  #define KVM_ARM_VCPU_PVTIME_CTRL       2
>  #define   KVM_ARM_VCPU_PVTIME_IPA      0
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 9d9bac3ec40e..4bba149d140c 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -86,8 +86,11 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
>  {
>         switch(arch_timer_ctx_index(ctxt)) {
>         case TIMER_VTIMER:
> +       case TIMER_PTIMER:
>                 return ctxt->host_offset;
>         default:
> +               WARN_ONCE(1, "unrecognized timer %ld\n",
> +                         arch_timer_ctx_index(ctxt));
>                 return 0;
>         }
>  }
> @@ -140,6 +143,7 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>  {
>         switch(arch_timer_ctx_index(ctxt)) {
>         case TIMER_VTIMER:
> +       case TIMER_PTIMER:
>                 ctxt->host_offset = offset;
>                 break;
>         default:
> @@ -568,6 +572,11 @@ static void set_cntvoff(u64 cntvoff)
>         kvm_call_hyp(__kvm_timer_set_cntvoff, cntvoff);
>  }
>
> +static void set_cntpoff(u64 cntpoff)
> +{
> +       write_sysreg_s(cntpoff, SYS_CNTPOFF_EL2);
> +}
> +
>  static inline void set_timer_irq_phys_active(struct arch_timer_context *ctx, bool active)
>  {
>         int r;
> @@ -643,6 +652,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>         }
>
>         set_cntvoff(timer_get_offset(map.direct_vtimer));
> +       if (kvm_timer_physical_offset_allowed())
> +               set_cntpoff(timer_get_offset(map.direct_ptimer));
>
>         kvm_timer_unblocking(vcpu);
>
> @@ -810,6 +821,22 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
>         mutex_unlock(&kvm->lock);
>  }
>
> +static void update_ptimer_cntpoff(struct kvm_vcpu *vcpu, u64 cntpoff)
> +{
> +       struct kvm *kvm = vcpu->kvm;
> +       u64 cntvoff;
> +
> +       mutex_lock(&kvm->lock);
> +
> +       /* adjustments to the physical offset also affect vtimer */
> +       cntvoff = timer_get_offset(vcpu_vtimer(vcpu));
> +       cntvoff += cntpoff - timer_get_offset(vcpu_ptimer(vcpu));
> +
> +       update_timer_offset(vcpu, TIMER_PTIMER, cntpoff, false);
> +       update_timer_offset(vcpu, TIMER_VTIMER, cntvoff, false);
> +       mutex_unlock(&kvm->lock);
> +}
> +
>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  {
>         struct arch_timer_cpu *timer = vcpu_timer(vcpu);
> @@ -1346,6 +1373,9 @@ void kvm_timer_init_vhe(void)
>         val = read_sysreg(cnthctl_el2);
>         val |= (CNTHCTL_EL1PCEN << cnthctl_shift);
>         val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
> +
> +       if (cpus_have_final_cap(ARM64_HAS_ECV2))
> +               val |= CNTHCTL_ECV;
>         write_sysreg(val, cnthctl_el2);
>  }
>
> @@ -1360,7 +1390,8 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
>         }
>  }
>
> -int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +static int kvm_arm_timer_set_attr_irq(struct kvm_vcpu *vcpu,
> +                                     struct kvm_device_attr *attr)
>  {
>         int __user *uaddr = (int __user *)(long)attr->addr;
>         struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> @@ -1393,7 +1424,37 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>         return 0;
>  }
>
> -int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +static int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu,
> +                                        struct kvm_device_attr *attr)
> +{
> +       u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +       u64 offset;
> +
> +       if (!kvm_timer_physical_offset_allowed())
> +               return -ENXIO;
> +
> +       if (get_user(offset, uaddr))
> +               return -EFAULT;
> +
> +       update_ptimer_cntpoff(vcpu, offset);
> +       return 0;
> +}
> +
> +int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +       switch (attr->attr) {
> +       case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> +       case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> +               return kvm_arm_timer_set_attr_irq(vcpu, attr);
> +       case KVM_ARM_VCPU_TIMER_PHYS_OFFSET:
> +               return kvm_arm_timer_set_attr_offset(vcpu, attr);
> +       default:
> +               return -ENXIO;
> +       }
> +}
> +
> +static int kvm_arm_timer_get_attr_irq(struct kvm_vcpu *vcpu,
> +                                     struct kvm_device_attr *attr)
>  {
>         int __user *uaddr = (int __user *)(long)attr->addr;
>         struct arch_timer_context *timer;
> @@ -1414,12 +1475,43 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>         return put_user(irq, uaddr);
>  }
>
> +static int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu,
> +                                        struct kvm_device_attr *attr)
> +{
> +       u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +       u64 offset;
> +
> +       if (!kvm_timer_physical_offset_allowed())
> +               return -ENXIO;
> +
> +       offset = timer_get_offset(vcpu_ptimer(vcpu));
> +       return put_user(offset, uaddr);
> +}
> +
> +int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu,
> +                          struct kvm_device_attr *attr)
> +{
> +       switch (attr->attr) {
> +       case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> +       case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> +               return kvm_arm_timer_get_attr_irq(vcpu, attr);
> +       case KVM_ARM_VCPU_TIMER_PHYS_OFFSET:
> +               return kvm_arm_timer_get_attr_offset(vcpu, attr);
> +       default:
> +               return -ENXIO;
> +       }
> +}
> +
>  int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>         switch (attr->attr) {
>         case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
>         case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
>                 return 0;
> +       case KVM_ARM_VCPU_TIMER_PHYS_OFFSET:
> +               if (kvm_timer_physical_offset_allowed())
> +                       return 0;
> +               break;
>         }
>
>         return -ENXIO;
> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
> index 73c7139c866f..7252ffa3d675 100644
> --- a/include/clocksource/arm_arch_timer.h
> +++ b/include/clocksource/arm_arch_timer.h
> @@ -21,6 +21,7 @@
>  #define CNTHCTL_EVNTEN                 (1 << 2)
>  #define CNTHCTL_EVNTDIR                        (1 << 3)
>  #define CNTHCTL_EVNTI                  (0xF << 4)
> +#define CNTHCTL_ECV                    (1 << 12)
>
>  enum arch_timer_reg {
>         ARCH_TIMER_REG_CTRL,
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 615f9314f6a5..aa666373f603 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -110,4 +110,9 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
>  u32 timer_get_ctl(struct arch_timer_context *ctxt);
>  u64 timer_get_cval(struct arch_timer_context *ctxt);
>
> +static inline bool kvm_timer_physical_offset_allowed(void)
> +{
> +       return cpus_have_final_cap(ARM64_HAS_ECV2) && has_vhe();
> +}
> +
>  #endif


In my understanding, the offset that the code below specifies
to call update_vtimer_cntvoff() is (guest's virtual counter) offset
from the host's counter, which is always same as guest's virtual
counter offset from the guest's physical counter-timer before this patch.

int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
{
        struct arch_timer_context *timer;

        switch (regid) {
        <...>
        case KVM_REG_ARM_TIMER_CNT:
                timer = vcpu_vtimer(vcpu);
                update_vtimer_cntvoff(vcpu, kvm_phys_timer_read() - value);
                break;
        <...>

With this patch, since the guest's counter-timer offset from the host's
counter can be set by userspace, doesn't the code need to specify
guest's virtual counter offset (from guest's physical counter-timer) ?

Thanks,
Reiji
