Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8493A445A3E
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 20:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbhKDTH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 15:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbhKDTHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 15:07:24 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC78C061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 12:04:45 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id d10so16874767ybe.3
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 12:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a8bYlLhvyabe/zdfFGm59a9QoggEe1fy64RUEfMkLIw=;
        b=e4zsu8VcJphDG3YFoAXcx2rexEUfhM1w71L7h2hNTthkrFDBtZUZeQKIfr18OSTdpz
         wpOxX0D8RDOJ64cW2VUslpepyAR0vwqMb+tVoFvUPoETOMicRnV3KJKnbF2QShUj7KXy
         ndFOQ1ZURzLaQC1e5nTsqfDO/FHoSv5F7Q8t43UxxCS50JMfPQReIcb6Ldfnw/ApAGSo
         8Gdzp9IEm0k65QHHBsdbptXBD/13Yq6a9yUVR8pP7kKkZ4FE1Sphwaxpk7rMpdVI6q2U
         3n68uhJtvSwk+PbmAUNYOfCLwgte7wh7FVmq6yyoxrThOHG/y1nlCftm2Okz/Wv3+g0i
         tS5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a8bYlLhvyabe/zdfFGm59a9QoggEe1fy64RUEfMkLIw=;
        b=4dISd5swDy+GWsd45EUXJpBW4sbjqaQasDgSH+OjY7DknXJRfz2WuBO9kvoJGVi7rQ
         ACV3bJavMX0VE9twBWBVpPl/qdgyZ47BLQt0GxZvCZ4yYk/3RfisqckAVV1In2087Ryi
         QcRzWjp3X3WksUsdpkeql1hfUxI/JvYn7KvKgoDUC+yiJ670Ks3ctr6PNlO2kKVsffFb
         p2Kp9EQaOmp2MxGTpuqQbQPpRJKYsA7FDNOqiDo1J+SwPHHNQYmiZhzJxhSxHu96Vxup
         6LrBAeHmV3XC25LGYb+y+p2vOUVaRXbu8juzL6D1VEoBzJMS2RlqnA8rA4ZrS20Obefj
         CoVw==
X-Gm-Message-State: AOAM531U1HdR+d0Tmq/GwzUtEn+TlstB3xE/EITAfySNo90hnx1MOdKF
        aUZQnJYjW5PtqBnQEpyYsAeKujMm1qncHH92rIIP7A==
X-Google-Smtp-Source: ABdhPJw7Bbo4UEiQVtBphw9F/uSKQaSVqBKxcL0Q9JnJqUvuNJ+9wPat2wk8utDuzYoSqM5XyYV9w2O/cB9hgzXC9qI=
X-Received: by 2002:a25:db0f:: with SMTP id g15mr49843133ybf.414.1636052684836;
 Thu, 04 Nov 2021 12:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <20211102002203.1046069-1-rananta@google.com> <20211102002203.1046069-3-rananta@google.com>
 <YYMKphExkqttn2w0@google.com>
In-Reply-To: <YYMKphExkqttn2w0@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 4 Nov 2021 12:04:33 -0700
Message-ID: <CAJHc60zC0HSVRfU0wN6OW6dkZm8m9AxmsTkZsRRiLFyq8kdmfg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/8] KVM: arm64: Setup base for hypercall firmware registers
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 3, 2021 at 3:18 PM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Nov 02, 2021 at 12:21:57AM +0000, Raghavendra Rao Ananta wrote:
> > The hypercall firmware registers may hold versioning information
> > for a particular hypercall service. Before a VM starts, these
> > registers are read/write to the user-space. That is, it can freely
> > modify the fields as it sees fit for the guest. However, this
> > shouldn't be allowed once the VM is started since it may confuse
> > the guest as it may have read an older value. As a result, introduce
> > a helper interface to convert the registers to read-only once any
> > vCPU starts running.
> >
> > Extend this interface to also clear off all the feature bitmaps of
> > the firmware registers upon first write. Since KVM exposes an upper
> > limit of the feature-set to user-space via these registers, this
> > action will ensure that no new features get enabled by accident if
> > the user-space isn't aware of a newly added register.
> >
> > Since the upcoming changes introduces more firmware registers,
> > rename the documentation to PSCI (psci.rst) to a more generic
> > hypercall.rst.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../virt/kvm/arm/{psci.rst => hypercalls.rst} | 24 +++----
> >  Documentation/virt/kvm/arm/index.rst          |  2 +-
> >  arch/arm64/include/asm/kvm_host.h             |  8 +++
> >  arch/arm64/kvm/arm.c                          |  7 +++
> >  arch/arm64/kvm/hypercalls.c                   | 62 +++++++++++++++++++
> >  5 files changed, 90 insertions(+), 13 deletions(-)
> >  rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (81%)
>
> nit: consider doing the rename in a separate patch.
>
> > diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> > similarity index 81%
> > rename from Documentation/virt/kvm/arm/psci.rst
> > rename to Documentation/virt/kvm/arm/hypercalls.rst
> > index d52c2e83b5b8..85dfd682d811 100644
> > --- a/Documentation/virt/kvm/arm/psci.rst
> > +++ b/Documentation/virt/kvm/arm/hypercalls.rst
> > @@ -1,22 +1,19 @@
> >  .. SPDX-License-Identifier: GPL-2.0
> >
> > -=========================================
> > -Power State Coordination Interface (PSCI)
> > -=========================================
> > +=======================
> > +ARM Hypercall Interface
> > +=======================
> >
> > -KVM implements the PSCI (Power State Coordination Interface)
> > -specification in order to provide services such as CPU on/off, reset
> > -and power-off to the guest.
> > -
> > -The PSCI specification is regularly updated to provide new features,
> > -and KVM implements these updates if they make sense from a virtualization
> > +New hypercalls are regularly added by ARM specifications (or KVM), and
>
> nit: maybe we should use the abstraction of "hypercall service" to refer
> to the functional groups of hypercalls. i.e. PSCI or TRNG are hypercall
> services.
>
> > +are made available to the guests if they make sense from a virtualization
> >  point of view.
> >
> >  This means that a guest booted on two different versions of KVM can
> >  observe two different "firmware" revisions. This could cause issues if
> > -a given guest is tied to a particular PSCI revision (unlikely), or if
> > -a migration causes a different PSCI version to be exposed out of the
> > -blue to an unsuspecting guest.
> > +a given guest is tied to a particular version of a specific hypercall
> > +(PSCI revision for instance (unlikely)), or if a migration causes a
>
> a particular version of a hypercall service
>
Sure, I can address your comments on this file. Thanks!
> > +different (PSCI) version to be exposed out of the blue to an unsuspecting
> > +guest.
> >
> >  In order to remedy this situation, KVM exposes a set of "firmware
> >  pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
> > @@ -26,6 +23,9 @@ to a convenient value if required.
> >  The following register is defined:
> >
> >  * KVM_REG_ARM_PSCI_VERSION:
> > +    KVM implements the PSCI (Power State Coordination Interface)
> > +    specification in order to provide services such as CPU on/off, reset
> > +    and power-off to the guest.
> >
> >    - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
> >      (and thus has already been initialized)
> > diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
> > index 78a9b670aafe..e84848432158 100644
> > --- a/Documentation/virt/kvm/arm/index.rst
> > +++ b/Documentation/virt/kvm/arm/index.rst
> > @@ -8,6 +8,6 @@ ARM
> >     :maxdepth: 2
> >
> >     hyp-abi
> > -   psci
> > +   hypercalls
> >     pvtime
> >     ptp_kvm
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index d0221fb69a60..0b2502494a17 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -102,6 +102,11 @@ struct kvm_s2_mmu {
> >  struct kvm_arch_memory_slot {
> >  };
> >
> > +struct hvc_reg_desc {
> > +     bool write_disabled;
> > +     bool write_attempted;
> > +};
> > +
> >  struct kvm_arch {
> >       struct kvm_s2_mmu mmu;
> >
> > @@ -137,6 +142,9 @@ struct kvm_arch {
> >
> >       /* Memory Tagging Extension enabled for the guest */
> >       bool mte_enabled;
> > +
> > +     /* Hypercall firmware registers' information */
> > +     struct hvc_reg_desc hvc_desc;
> >  };
> >
> >  struct kvm_vcpu_fault_info {
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 24a1e86d7128..f9a25e439e99 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -630,6 +630,13 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> >       if (kvm_vm_is_protected(kvm))
> >               kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
> >
> > +     /* Mark the hypercall firmware registers as read-only since
> > +      * at least once vCPU is about to start running.
> > +      */
> > +     mutex_lock(&kvm->lock);
> > +     kvm->arch.hvc_desc.write_disabled = true;
> > +     mutex_unlock(&kvm->lock);
> > +
>
> This really is just an alias for if any vCPU in the VM has started yet.
> While the ARM KVM code does some bookkeeping around which vCPUs have
> been started, it is in no way specific to ARM.
>
> It might be nice to hoist vcpu->arch.has_run_once into the generic KVM
> code, then build some nice abstractions there to easily determine if any
> vCPU in the VM has been started yet.
>
Sure, let me look into it..
> >       return ret;
> >  }
> >
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index d030939c5929..7e873206a05b 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -58,6 +58,12 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
> >       val[3] = lower_32_bits(cycles);
> >  }
> >
> > +static u64 *kvm_fw_reg_to_bmap(struct kvm *kvm, u64 fw_reg)
> > +{
> > +     /* No firmware registers supporting hvc bitmaps exits yet */
> > +     return NULL;
> > +}
> > +
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >  {
> >       u32 func_id = smccc_get_function(vcpu);
> > @@ -234,15 +240,71 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >       return 0;
> >  }
> >
> > +static void kvm_fw_regs_sanitize(struct kvm *kvm, struct hvc_reg_desc *hvc_desc)
> > +{
> > +     unsigned int i;
> > +     u64 *hc_bmap = NULL;
> > +
> > +     mutex_lock(&kvm->lock);
> > +
> > +     if (hvc_desc->write_attempted)
> > +             goto out;
> > +
> > +     hvc_desc->write_attempted = true;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(fw_reg_ids); i++) {
> > +             hc_bmap = kvm_fw_reg_to_bmap(kvm, fw_reg_ids[i]);
> > +             if (hc_bmap)
> > +                     *hc_bmap = 0;
> > +     }
>
> Maybe instead of checking for feature bitmap registers in the full range
> of FW registers, you could separately track a list of feature bitmap
> regs and just iterate over that.
>
> You could then just stash an array/substructure of feature bitmap reg
> values in struct kvm_arch, along with a bitmap of which regs were
> touched by the VMM.
>
> For the first vCPU in KVM_RUN, zero out the FW feature regs that were
> never written to. You could then punt the clobber operation and do it
> exactly once for a VM.
>
Sure, I guess there are some cases that I missed checking. Will try to
address them in the next patchset.

Regards,
Raghavendra
> > +out:
> > +     mutex_unlock(&kvm->lock);
> > +}
> > +
> > +static bool
> > +kvm_fw_regs_block_write(struct kvm *kvm, struct hvc_reg_desc *hvc_desc, u64 val)
> > +{
> > +     bool ret = false;
> > +     unsigned int i;
> > +     u64 *hc_bmap = NULL;
> > +
> > +     mutex_lock(&kvm->lock);
> > +
> > +     for (i = 0; i < ARRAY_SIZE(fw_reg_ids); i++) {
> > +             hc_bmap = kvm_fw_reg_to_bmap(kvm, fw_reg_ids[i]);
> > +             if (hc_bmap)
> > +                     break;
> > +     }
> > +
> > +     if (!hc_bmap)
> > +             goto out;
> > +
> > +     /* Do not allow any updates if the VM has already started */
> > +     if (hvc_desc->write_disabled && val != *hc_bmap)
> > +             ret = true;
> > +
> > +out:
> > +     mutex_unlock(&kvm->lock);
> > +     return ret;
> > +}
> > +
> >  int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >  {
> >       void __user *uaddr = (void __user *)(long)reg->addr;
> > +     struct kvm *kvm = vcpu->kvm;
> > +     struct hvc_reg_desc *hvc_desc = &kvm->arch.hvc_desc;
> >       u64 val;
> >       int wa_level;
> >
> >       if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
> >               return -EFAULT;
> >
> > +     if (kvm_fw_regs_block_write(kvm, hvc_desc, val))
> > +             return -EBUSY;
> > +
> > +     kvm_fw_regs_sanitize(kvm, hvc_desc);
> > +
> >       switch (reg->id) {
> >       case KVM_REG_ARM_PSCI_VERSION:
> >               return kvm_arm_set_psci_fw_reg(vcpu, val);
> > --
> > 2.33.1.1089.g2158813163f-goog
> >
