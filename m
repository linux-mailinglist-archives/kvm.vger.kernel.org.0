Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2D5447B50
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 08:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbhKHHsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 02:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbhKHHsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 02:48:45 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFBCC061570
        for <kvm@vger.kernel.org>; Sun,  7 Nov 2021 23:46:01 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id s136so14420272pgs.4
        for <kvm@vger.kernel.org>; Sun, 07 Nov 2021 23:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MZURfzT5WqgPzciBayl8Gbd6sno0JzLLiamB607T0vk=;
        b=ZnIUt1JelCsTRR6fIzHidHe9/7Y978GVEDrK4rCMnCd37KYtexjWuBJyJIJuoJ1YeX
         gzom3TeGtLqJcUGnvikaRIeXPjkg22zZ/+dE2a3/2nPtK+6kQzsEqcEkHSlXav4n/0K8
         If3SqjQU+Aj5R4JTA00GrXupya0xWHIimf5z75WSAlaWkBCpaASVIL6YxQDxaJFf2Wje
         QibRNnuZfhxddqdtqDg8azZburkkhB5y+ubuho9D33nshXwB/49ClTnUOMnXI/Kcp/ti
         3JmMtI37F7Cmho4jaSuQhc7jolji8loTld6rvBp2Kv5/Tk1ytCpZcDLIWYIB6VaXhbvl
         49zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MZURfzT5WqgPzciBayl8Gbd6sno0JzLLiamB607T0vk=;
        b=g2Oxw1W2dfh3IIXJa2PD5iUs7XzmMs7xgBpKoIENRfXTA7kMI7lc2AcevGJMJNDzZb
         0Nb7chgoPqiuLFq6n85OAKHUQMnDApMiVaVArs/uOfplavnTmjOr7/Q6ukOh00tON9dI
         t/1CHjsHH73Ugaee6MtJI9npbIaK2YcpP/ahVd6E/EijYR+Ipj5RdmKVvSmobC4VMpSG
         b+x6IzzFTfwRFs43nTWSzo5ib5MePsCDcnBfAIEqKlR6PEdUxotBL8Xd2fN2FMX43esD
         D1N9h9o2I1zc9Mrj0rDWzjnJdKhkC8PyK/kCLsBS1K+QoMFXAftWysXYBAR8gklNO/wt
         vaLQ==
X-Gm-Message-State: AOAM533aNEoneJlaLooK1fi7+49Y++6YpSF/p3N5TNZL92KLMEeFnNJN
        Pq55P1TF8y4qdR18wv3GHtelT6fYWJJzVVKjkXotwg==
X-Google-Smtp-Source: ABdhPJx7WXF80L+8m+mkuvMLgSvWfhN3xBVAqB7AEFTyz0qB+7z/x/1Trxos8znWh3vl0Z8zHcVz8O9fi87762zc1Ek=
X-Received: by 2002:aa7:8246:0:b0:44b:4870:1b09 with SMTP id
 e6-20020aa78246000000b0044b48701b09mr81055621pfn.82.1636357560558; Sun, 07
 Nov 2021 23:46:00 -0800 (PST)
MIME-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com> <20211103062520.1445832-5-reijiw@google.com>
 <YYQLdtcjiTESMFES@google.com>
In-Reply-To: <YYQLdtcjiTESMFES@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 7 Nov 2021 23:45:44 -0800
Message-ID: <CAAeT=Fw61dX4fZQf04OTi8TammDZq8N=5jufMe76FVdWAjPYJA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/28] KVM: arm64: Keep consistency of ID registers
 between vCPUs
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Thu, Nov 4, 2021 at 9:34 AM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Nov 02, 2021 at 11:24:56PM -0700, Reiji Watanabe wrote:
> > All vCPUs that are owned by a VM must have the same values of ID
> > registers.
> >
> > Return an error at the very first KVM_RUN for a vCPU if the vCPU has
> > different values in any ID registers from any other vCPUs that have
> > already started KVM_RUN once.  Also, return an error if userspace
> > tries to change a value of ID register for a vCPU that already
> > started KVM_RUN once.
> >
> > Changing ID register is still not allowed at present though.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  arch/arm64/kvm/arm.c              |  4 ++++
> >  arch/arm64/kvm/sys_regs.c         | 31 +++++++++++++++++++++++++++++++
> >  3 files changed, 37 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 0cd351099adf..69af669308b0 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -745,6 +745,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
> >  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >                               struct kvm_arm_copy_mte_tags *copy_tags);
> >
> > +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
> > +
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index fe102cd2e518..83cedd74de73 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -595,6 +595,10 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> >               return -EPERM;
> >
> >       vcpu->arch.has_run_once = true;
> > +     if (kvm_id_regs_consistency_check(vcpu)) {
> > +             vcpu->arch.has_run_once = false;
> > +             return -EPERM;
> > +     }
>
> It might be nice to return an error to userspace synchronously (i.e. on
> the register write). Of course, there is still the issue where userspace
> writes to some (but not all) of the vCPU feature ID registers, which
> can't be known until the first KVM_RUN.

Yes, I agree that it would be better.  As I mentioned for patch-02,
I will remove the consistency checking amongst vCPUs anyway though.


> >       kvm_arm_vcpu_init_debug(vcpu);
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 64d51aa3aee3..e34351fdc66c 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1436,6 +1436,10 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
> >       if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
> >               return -EINVAL;
> >
> > +     /* Don't allow to change the reg after the first KVM_RUN. */
> > +     if (vcpu->arch.has_run_once)
> > +             return -EINVAL;
> > +
> >       if (raz)
> >               return 0;
> >
> > @@ -3004,6 +3008,33 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> >       return write_demux_regids(uindices);
> >  }
> >
> > +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
> > +{
> > +     int i;
> > +     const struct kvm_vcpu *t_vcpu;
> > +
> > +     /*
> > +      * Make sure vcpu->arch.has_run_once is visible for others so that
> > +      * ID regs' consistency between two vCPUs is checked by either one
> > +      * at least.
> > +      */
> > +     smp_mb();
> > +     WARN_ON(!vcpu->arch.has_run_once);
> > +
> > +     kvm_for_each_vcpu(i, t_vcpu, vcpu->kvm) {
> > +             if (!t_vcpu->arch.has_run_once)
> > +                     /* ID regs still could be updated. */
> > +                     continue;
> > +
> > +             if (memcmp(&__vcpu_sys_reg(vcpu, ID_REG_BASE),
> > +                        &__vcpu_sys_reg(t_vcpu, ID_REG_BASE),
> > +                        sizeof(__vcpu_sys_reg(vcpu, ID_REG_BASE)) *
> > +                                     KVM_ARM_ID_REG_MAX_NUM))
> > +                     return -EINVAL;
> > +     }
> > +     return 0;
> > +}
> > +
>
> Couldn't we do the consistency check exactly once per VM? I had alluded
> to this when reviewing Raghu's patches, but I think the same applies
> here too: an abstraction for detecting the first vCPU to run in a VM.
>
> https://lore.kernel.org/all/YYMKphExkqttn2w0@google.com/

Yes, the same applies to this, as well.

Thank you so much for your review !

Regards,
Reiji
