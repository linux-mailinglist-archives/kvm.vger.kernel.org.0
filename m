Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7A562FAE7
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 17:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242261AbiKRQ7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 11:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbiKRQ7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 11:59:16 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D71384322
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 08:59:15 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-3691e040abaso55009437b3.9
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 08:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2MTsNotZvEhDe9MvvmrIxNp7OMwAIiXD6u7MQo/OIhU=;
        b=kf01PKNxdhaB6e4/CUiwb0RKSy9a/b/ZVkeWFy2SAeXx4YwqmHviZ0hReHMULTdJ4S
         6xHSTUAAxhCzPN3RQxufeh4If63vSa0+Gk7SMhFNSbhaz+WBeZF3Sj+W3wuAELinpKM1
         hurklQ/KFESAhIzYANRys2RRdy1jNytTjvFobGqcyux3YzZFAeWiiNGcJcruTkyMDc9S
         dGl2eaiVzcHgmGgzVIyQp5DsHvqOOyN7GaFIRBbUchybaomWe+l/7vTom5IC6ABDCT2j
         Ntw5rzLyZsmTXPhEKA2hi8MJS4VZE/Q2qn3ede/BTSGL7E9aV61dmcIDS59RVMFJcAAW
         gEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2MTsNotZvEhDe9MvvmrIxNp7OMwAIiXD6u7MQo/OIhU=;
        b=ewT3CblIZ4RT/7MlzmtOFKUwtwzerE6E+ydbnc9jlxupdkc2hXZQJvMt5PaaC8VPFA
         LsLD67gyj1E/jVEMyXzUefMzW1auexkeCjZBV3pka29lwBsyO0l0PnBpc45lr+euQC42
         xXd90vpuSrC8AvXSvaxaOxMfLk5JMPPdi96I0bTvhTWKTl9V3FMxh9FiAS8M2j07Qfo+
         DuFwjtZrMAa+RznY3MLCAQ3DKM6nkHwjp5H20fURQig6uVmxc+6N1MNWvreIiY+SJGc0
         D8LMG4GS4WA+nU8KxIoxEztZ8Gri/HuHeRx7kiQT81iR8B28nxxoCvBHoQagwNtx5fDa
         J1cw==
X-Gm-Message-State: ANoB5pnV51xJxYMAjezzNZ+8nXCfU6ml4D/ii1GM3S4F5dSSPLXL3hmx
        FeEVqWdpW1UXotdLSzVFVGGV3kGZqZ3KQqb4E/Etog==
X-Google-Smtp-Source: AA0mqf7GIwnb6+ie5wmPqnAw2FQ4dpbX9IJrQX6aY1nhYJ2SsAbmOBfDF1HDRPBTIiMUY9ZYZt14m0GOek0tY1LOXlI=
X-Received: by 2002:a81:ac47:0:b0:393:504b:c358 with SMTP id
 z7-20020a81ac47000000b00393504bc358mr5534650ywj.111.1668790754204; Fri, 18
 Nov 2022 08:59:14 -0800 (PST)
MIME-Version: 1.0
References: <20221117001657.1067231-1-dmatlack@google.com> <20221117001657.1067231-4-dmatlack@google.com>
 <97ccc949-254e-879d-9206-613b328c271d@huawei.com>
In-Reply-To: <97ccc949-254e-879d-9206-613b328c271d@huawei.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 18 Nov 2022 08:58:47 -0800
Message-ID: <CALzav=fY6-C_Y1+8B0_hQM9X8L-SA2cEULgcp24-6f_xVLgkqw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] KVM: Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL
To:     "wangyanan (Y)" <wangyanan55@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        wangyuan38@huawei.com
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

On Fri, Nov 18, 2022 at 12:28 AM wangyanan (Y) <wangyanan55@huawei.com> wrote:
>
> Hi David,
>
> On 2022/11/17 8:16, David Matlack wrote:
> > Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL on every halt,
> > rather than just sampling the module parameter when the VM is first
> s/first/firstly
> > created. This restore the original behavior of kvm.halt_poll_ns for VMs
> s/restore/restores
> > that have not opted into KVM_CAP_HALT_POLL.
> >
> > Notably, this change restores the ability for admins to disable or
> > change the maximum halt-polling time system wide for VMs not using
> > KVM_CAP_HALT_POLL.
> Should we add more detailed comments about relationship
> between KVM_CAP_HALT_POLL and kvm.halt_poll_ns in
> Documentation/virt/kvm/api.rst? Something like:
> "once KVM_CAP_HALT_POLL is used for a target VM, it will
> completely ignores any future changes to kvm.halt_poll_ns..."

Yes we should.

I will do some testing on this series today and then resend the series
as a non-RFC with the Documentation changes.

Thanks for the reviews.

> > Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > Fixes: acd05785e48c ("kvm: add capability for halt polling")
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >   include/linux/kvm_host.h |  1 +
> >   virt/kvm/kvm_main.c      | 27 ++++++++++++++++++++++++---
> >   2 files changed, 25 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index e6e66c5e56f2..253ad055b6ad 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -788,6 +788,7 @@ struct kvm {
> >       struct srcu_struct srcu;
> >       struct srcu_struct irq_srcu;
> >       pid_t userspace_pid;
> > +     bool override_halt_poll_ns;
> >       unsigned int max_halt_poll_ns;
> >       u32 dirty_ring_size;
> >       bool vm_bugged;
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 78caf19608eb..7f73ce99bd0e 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1198,8 +1198,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
> >                       goto out_err_no_arch_destroy_vm;
> >       }
> >
> > -     kvm->max_halt_poll_ns = halt_poll_ns;
> > -
> >       r = kvm_arch_init_vm(kvm, type);
> >       if (r)
> >               goto out_err_no_arch_destroy_vm;
> > @@ -3490,7 +3488,20 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
> >
> >   static unsigned int kvm_vcpu_max_halt_poll_ns(struct kvm_vcpu *vcpu)
> >   {
> > -     return READ_ONCE(vcpu->kvm->max_halt_poll_ns);
> > +     struct kvm *kvm = vcpu->kvm;
> > +
> > +     if (kvm->override_halt_poll_ns) {
> > +             /*
> > +              * Ensure kvm->max_halt_poll_ns is not read before
> > +              * kvm->override_halt_poll_ns.
> > +              *
> > +              * Pairs with the smp_wmb() when enabling KVM_CAP_HALT_POLL.
> > +              */
> > +             smp_rmb();
> > +             return READ_ONCE(kvm->max_halt_poll_ns);
> > +     }
> > +
> > +     return READ_ONCE(halt_poll_ns);
> >   }
> >
> >   /*
> > @@ -4600,6 +4611,16 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
> >                       return -EINVAL;
> >
> >               kvm->max_halt_poll_ns = cap->args[0];
> > +
> > +             /*
> > +              * Ensure kvm->override_halt_poll_ns does not become visible
> > +              * before kvm->max_halt_poll_ns.
> > +              *
> > +              * Pairs with the smp_rmb() in kvm_vcpu_max_halt_poll_ns().
> > +              */
> > +             smp_wmb();
> > +             kvm->override_halt_poll_ns = true;
> > +
> >               return 0;
> >       }
> >       case KVM_CAP_DIRTY_LOG_RING:
> Looks good to me:
> Reviewed-by: Yanan Wang <wangyanan55@huawei.com>
>
> Thanks,
> Yanan
