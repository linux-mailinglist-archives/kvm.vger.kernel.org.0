Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4AA509558
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 05:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383939AbiDUD04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 23:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244213AbiDUD0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 23:26:55 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30C62BE0
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 20:24:06 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id y11so4190981ljh.5
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 20:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n1YYn9MwGcVRzWNm1bh3AOfLSEyB+Oxqkz107Lry6Go=;
        b=egiTfzD6akLZHcZR24/rkj3bKerb2ZepmPQ0NQgA4c0nSZAOiBWuS7Vq/iSKUN2Wyo
         yW6bFIZJa5HG1OcD89Xepjh3jThFTr6ETH9dhZOpxcpRsZgt9YSJReNE/w38GyhB+0Zf
         6tsHeie7wv0jwNEzIVO3jyt/NHhbgKF2N4NRueCpkNtyDisY9NRVOSn7fBtRcKMIkIBf
         VJWcSP1KR4+WXgdc8nC5QUvyhqEVCmNIm5SN6gAGgZ0XoFjQp9cyVVCYUQy0mvYC1R8I
         qwfoBQgK6wrdEWo+DRRmzCi7fU62UDYat7aYCpl5LY5/sk7oEXiKEx4J7LEGOVB8dSZy
         65VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n1YYn9MwGcVRzWNm1bh3AOfLSEyB+Oxqkz107Lry6Go=;
        b=a7CeZV6T4+vMHz/eqOlOPojioZWAvmznwnPjzLUek/AQLqlVIKFwxLN/bchVZZNFAb
         MikwcPxXarfSeAmmrDdpctoWebc7/DSNLaEgdxfR14z5RyDXuui1SvxK9cfk3iXK3fbg
         TBSXQsg9VtpfSPIA5W1eDYjxsEux5jLEC4YgrL9aTkz7I1ku+UPskZl2bYKnjxBsWLDm
         i76fI9Gfc37zqhCx1WbfKCuXkz0z7NJ/DLDj9yeDnVXaGDGe+3DjSWU/bweHE4kY2VIe
         2npmRDMryYBcqoJfQr0D3Ur1aBNhoxn1HSE/DVqHdrXskinAqkGElFknym/JJ+2y/mxg
         v/PA==
X-Gm-Message-State: AOAM531fhg/5zOl+1cpkFSI0mh0xR0OIwCCyZwEdcaTinpon10OMNOj5
        WnMbakBcDZVZatx4KO7n7brh+Q2RllVaEjIote06pw==
X-Google-Smtp-Source: ABdhPJy4F3mVF4kLJgR3+L7/eOVY/Wf8n6Q2/ivcnbNaRLjiYnygxZ1G5DKIlNk2ah4WQEwa0SniOuU+aFhWqfMQ85M=
X-Received: by 2002:a2e:998b:0:b0:24d:a08d:8933 with SMTP id
 w11-20020a2e998b000000b0024da08d8933mr14731795lji.170.1650511444716; Wed, 20
 Apr 2022 20:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com> <20220409184549.1681189-8-oupton@google.com>
 <CAAeT=FzURZmYfsLJnWMXufBiaZ6Wypan+xK4WxOSM=p=kEnYxA@mail.gmail.com>
In-Reply-To: <CAAeT=FzURZmYfsLJnWMXufBiaZ6Wypan+xK4WxOSM=p=kEnYxA@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 20 Apr 2022 20:23:53 -0700
Message-ID: <CAOQ_Qsg2oNx8Ke7wGy1sU-5Ruq8uCWMKU5VkvTn=co6oRhhXww@mail.gmail.com>
Subject: Re: [PATCH v5 07/13] KVM: arm64: Add support for userspace to suspend
 a vCPU
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        James Morse <james.morse@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Wed, Apr 20, 2022 at 8:13 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Oliver,
>
> On Sat, Apr 9, 2022 at 11:46 AM Oliver Upton <oupton@google.com> wrote:
> >
> > Introduce a new MP state, KVM_MP_STATE_SUSPENDED, which indicates a vCPU
> > is in a suspended state. In the suspended state the vCPU will block
> > until a wakeup event (pending interrupt) is recognized.
> >
> > Add a new system event type, KVM_SYSTEM_EVENT_WAKEUP, to indicate to
> > userspace that KVM has recognized one such wakeup event. It is the
> > responsibility of userspace to then make the vCPU runnable, or leave it
> > suspended until the next wakeup event.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst    | 37 +++++++++++++++++++++--
> >  arch/arm64/include/asm/kvm_host.h |  1 +
> >  arch/arm64/kvm/arm.c              | 49 +++++++++++++++++++++++++++++++
> >  include/uapi/linux/kvm.h          |  2 ++
> >  4 files changed, 87 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index d13fa6600467..d104e34ad703 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -1476,14 +1476,43 @@ Possible values are:
> >                                   [s390]
> >     KVM_MP_STATE_LOAD             the vcpu is in a special load/startup state
> >                                   [s390]
> > +   KVM_MP_STATE_SUSPENDED        the vcpu is in a suspend state and is waiting
> > +                                 for a wakeup event [arm64]
> >     ==========================    ===============================================
> >
> >  On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
> >  in-kernel irqchip, the multiprocessing state must be maintained by userspace on
> >  these architectures.
> >
> > -For arm64/riscv:
> > -^^^^^^^^^^^^^^^^
> > +For arm64:
> > +^^^^^^^^^^
> > +
> > +If a vCPU is in the KVM_MP_STATE_SUSPENDED state, KVM will emulate the
> > +architectural execution of a WFI instruction.
> > +
> > +If a wakeup event is recognized, KVM will exit to userspace with a
> > +KVM_SYSTEM_EVENT exit, where the event type is KVM_SYSTEM_EVENT_WAKEUP. If
> > +userspace wants to honor the wakeup, it must set the vCPU's MP state to
> > +KVM_MP_STATE_RUNNABLE. If it does not, KVM will continue to await a wakeup
> > +event in subsequent calls to KVM_RUN.
> > +
> > +.. warning::
> > +
> > +     If userspace intends to keep the vCPU in a SUSPENDED state, it is
> > +     strongly recommended that userspace take action to suppress the
> > +     wakeup event (such as masking an interrupt). Otherwise, subsequent
> > +     calls to KVM_RUN will immediately exit with a KVM_SYSTEM_EVENT_WAKEUP
> > +     event and inadvertently waste CPU cycles.
> > +
> > +     Additionally, if userspace takes action to suppress a wakeup event,
> > +     it is strongly recommended that it also restores the vCPU to its
> > +     original state when the vCPU is made RUNNABLE again. For example,
> > +     if userspace masked a pending interrupt to suppress the wakeup,
> > +     the interrupt should be unmasked before returning control to the
> > +     guest.
> > +
> > +For riscv:
> > +^^^^^^^^^^
> >
> >  The only states that are valid are KVM_MP_STATE_STOPPED and
> >  KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
> > @@ -5985,6 +6014,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
> >    #define KVM_SYSTEM_EVENT_SHUTDOWN       1
> >    #define KVM_SYSTEM_EVENT_RESET          2
> >    #define KVM_SYSTEM_EVENT_CRASH          3
> > +  #define KVM_SYSTEM_EVENT_WAKEUP         4
> >                         __u32 type;
> >                         __u64 flags;
> >                 } system_event;
> > @@ -6009,6 +6039,9 @@ Valid values for 'type' are:
> >     has requested a crash condition maintenance. Userspace can choose
> >     to ignore the request, or to gather VM memory core dump and/or
> >     reset/shutdown of the VM.
> > + - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
> > +   KVM has recognized a wakeup event. Userspace may honor this event by
> > +   marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
> >
> >  Valid flags are:
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f3f93d48e21a..46027b9b80ca 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -46,6 +46,7 @@
> >  #define KVM_REQ_RECORD_STEAL   KVM_ARCH_REQ(3)
> >  #define KVM_REQ_RELOAD_GICv4   KVM_ARCH_REQ(4)
> >  #define KVM_REQ_RELOAD_PMU     KVM_ARCH_REQ(5)
> > +#define KVM_REQ_SUSPEND                KVM_ARCH_REQ(6)
> >
> >  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
> >                                      KVM_DIRTY_LOG_INITIALLY_SET)
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index efe54aba5cce..e9641b86d375 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -444,6 +444,18 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
> >         return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
> >  }
> >
> > +static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
> > +{
> > +       vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
> > +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> > +       kvm_vcpu_kick(vcpu);
>
> > +static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
> > +{
> > +       vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
> > +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> > +       kvm_vcpu_kick(vcpu);
>
> Considering the patch 8 will remove the call to kvm_vcpu_kick()
> (BTW, I wonder why you wanted to make that change in the patch-8
> instead of the patch-7),

Squashed the diff into the wrong patch! Marc pointed out this is of
course cargo-culted as I was following the pattern laid down by
KVM_REQ_SLEEP :)

> it looks like we could use the mp_state
> KVM_MP_STATE_SUSPENDED instead of using KVM_REQ_SUSPEND.
> What is the reason why you prefer to introduce KVM_REQ_SUSPEND
> rather than simply using KVM_MP_STATE_SUSPENDED ?

I was trying to avoid any heavy refactoring in adding new
functionality here, as we handle KVM_MP_STATE_STOPPED similarly (make
a request). ARM is definitely a bit different than x86 in the way that
we handle the MP states, as x86 doesn't bounce through vCPU requests
to do it and instead directly checks the mp_state value.

Do you think it's fair to defer on repainting to a later series? We
probably will need to touch up the main run loop quite a lot along the
way.

--
Thanks,
Oliver
