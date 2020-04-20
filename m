Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81E51B151C
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 20:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725613AbgDTSrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 14:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgDTSry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 14:47:54 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3002C061A0C
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 11:47:54 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 18so1738049pfx.6
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 11:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YX8bi5fDaDstDbsAIYV5L0+yRn3gHRYis1uiUL+frHw=;
        b=qG0RbCXjb4O1PX0PClINkjVTasq0J6pnbmoYg/9p8Kveq+2ocVi5h5ui32CfTc2VUo
         SJeBZUaIFTxm1A/iNOXmVWHoMmdQWPh1EShmHkLkLEWJ0vZ5tonKLLE8ohN5VGRzkK1V
         3Gm4muoqdpmZ+FXawn/3LiGoGkmsz4ANVjIrN7nPgrVtqzJpKLjGE5QLXqDuyp2uwHij
         ++stzadYm+tW3VhstqC3zCBmJ0HKrVcsXeqgLIkzYyFO6ut74mLEBBBSdYq4B+zSWXS4
         ZVCcDE4kFUPPZezIAlWPjcA6sxydX4swpZj00wmnFNBBwIaANtWZ4pYOEf73gEliMbMM
         JoMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YX8bi5fDaDstDbsAIYV5L0+yRn3gHRYis1uiUL+frHw=;
        b=giy+NrEvIpp0EQytmp8cXW8QBTRShLDk9CgHMKiz6aYAoYTpA7FDQkd/LBUMM/37qc
         e3NeU0Uuavy7rY6LwNE0nDVGWhmyJyGDqyT/a0U9gSr5zfr+y+T0FtDLkgcPSO/3jFiI
         V1JU1BH5u813TTIM5GFV8Ag6SNDIkNA5Q8q88qPze8ZN3sdVgxYHf0EAeQ/zvlOEcuXY
         oNZfhb8yWYCZcq8IppbDr2pPmeFknV0p2qsgM0JidCCIw5V5BMDEkBZeNKwfsnNPwlDq
         aCsbXTRZuHil4sMtQ2DF9udcowYzsIi3PWACccApTA6XSGSh04VmzWs8S1sV5jHf4wha
         7/rw==
X-Gm-Message-State: AGi0PuZDQQNI5ZKZaSnL+nX2esiXYtwdkeK2R0ZHEheocv0yZUMte5MZ
        7FABVBQOQNaV4jLbMKXJFshaEQhFjiU8qd0NMdvPwNKx
X-Google-Smtp-Source: APiQypJcs1Q7PvvAodn1vm2JVKjaQzu3sBVnVYABVZQO/avRKuN4+hsPmVWRexHiz/Nfq8eSgHxBWBgzLCh3w0Q0ahY=
X-Received: by 2002:a92:aac7:: with SMTP id p68mr15904865ill.62.1587408464090;
 Mon, 20 Apr 2020 11:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200417221446.108733-1-jcargill@google.com> <87d083td9f.fsf@vitty.brq.redhat.com>
In-Reply-To: <87d083td9f.fsf@vitty.brq.redhat.com>
From:   Jon Cargille <jcargill@google.com>
Date:   Mon, 20 Apr 2020 11:47:31 -0700
Message-ID: <CANxmayg3ML5_w=pY3=x7_TLOqawojxYGbqMLrXJn+r0b_gvWgA@mail.gmail.com>
Subject: Re: [PATCH] kvm: add capability for halt polling
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 19, 2020 at 1:46 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Jon Cargille <jcargill@google.com> writes:
>
> > From: David Matlack <dmatlack@google.com>
> >
> > KVM_CAP_HALT_POLL is a per-VM capability that lets userspace
> > control the halt-polling time, allowing halt-polling to be tuned or
> > disabled on particular VMs.
> >
> > With dynamic halt-polling, a VM's VCPUs can poll from anywhere from
> > [0, halt_poll_ns] on each halt. KVM_CAP_HALT_POLL sets the
> > upper limit on the poll time.
>
> Out of pure curiosity, why is this a per-VM and not a per-VCPU property?

Great question, Vitaly.  We actually implemented this as a per-VCPU property
initially; however, our user-space implementation was only using it to apply
the same value to all VCPUs, so we later simplified it on the advice of
Jim Mattson. If there is a consensus for this to go in as per-VCPU rather
than per-VM, I'm happy to submit that way instead. The per-VM version did
end up looking simpler, IMO.

>
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Jon Cargille <jcargill@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
> >  include/linux/kvm_host.h       |  1 +
> >  include/uapi/linux/kvm.h       |  1 +
> >  virt/kvm/kvm_main.c            | 19 +++++++++++++++----
> >  4 files changed, 34 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index efbbe570aa9b7b..d871dacb984e98 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -5802,6 +5802,23 @@ If present, this capability can be enabled for a VM, meaning that KVM
> >  will allow the transition to secure guest mode.  Otherwise KVM will
> >  veto the transition.
> >
> > +7.20 KVM_CAP_HALT_POLL
> > +----------------------
> > +
> > +:Architectures: all
> > +:Target: VM
> > +:Parameters: args[0] is the maximum poll time in nanoseconds
> > +:Returns: 0 on success; -1 on error
> > +
> > +This capability overrides the kvm module parameter halt_poll_ns for the
> > +target VM.
> > +
> > +VCPU polling allows a VCPU to poll for wakeup events instead of immediately
> > +scheduling during guest halts. The maximum time a VCPU can spend polling is
> > +controlled by the kvm module parameter halt_poll_ns. This capability allows
> > +the maximum halt time to specified on a per-VM basis, effectively overriding
> > +the module parameter for the target VM.
> > +
> >  8. Other capabilities.
> >  ======================
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 6d58beb65454f7..922b24ce5e7297 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -503,6 +503,7 @@ struct kvm {
> >       struct srcu_struct srcu;
> >       struct srcu_struct irq_srcu;
> >       pid_t userspace_pid;
> > +     unsigned int max_halt_poll_ns;
> >  };
> >
> >  #define kvm_err(fmt, ...) \
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 428c7dde6b4b37..ac9eba0289d1b6 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_S390_VCPU_RESETS 179
> >  #define KVM_CAP_S390_PROTECTED 180
> >  #define KVM_CAP_PPC_SECURE_GUEST 181
> > +#define KVM_CAP_HALT_POLL 182
> >
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 74bdb7bf32952e..ec038a9e60a275 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -710,6 +710,8 @@ static struct kvm *kvm_create_vm(unsigned long type)
> >                       goto out_err_no_arch_destroy_vm;
> >       }
> >
> > +     kvm->max_halt_poll_ns = halt_poll_ns;
> > +
> >       r = kvm_arch_init_vm(kvm, type);
> >       if (r)
> >               goto out_err_no_arch_destroy_vm;
> > @@ -2716,15 +2718,16 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >       if (!kvm_arch_no_poll(vcpu)) {
> >               if (!vcpu_valid_wakeup(vcpu)) {
> >                       shrink_halt_poll_ns(vcpu);
> > -             } else if (halt_poll_ns) {
> > +             } else if (vcpu->kvm->max_halt_poll_ns) {
> >                       if (block_ns <= vcpu->halt_poll_ns)
> >                               ;
> >                       /* we had a long block, shrink polling */
> > -                     else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
> > +                     else if (vcpu->halt_poll_ns &&
> > +                                     block_ns > vcpu->kvm->max_halt_poll_ns)
> >                               shrink_halt_poll_ns(vcpu);
> >                       /* we had a short halt and our poll time is too small */
> > -                     else if (vcpu->halt_poll_ns < halt_poll_ns &&
> > -                             block_ns < halt_poll_ns)
> > +                     else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
> > +                                     block_ns < vcpu->kvm->max_halt_poll_ns)
> >                               grow_halt_poll_ns(vcpu);
> >               } else {
> >                       vcpu->halt_poll_ns = 0;
> > @@ -3516,6 +3519,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> >       case KVM_CAP_IOEVENTFD_ANY_LENGTH:
> >       case KVM_CAP_CHECK_EXTENSION_VM:
> >       case KVM_CAP_ENABLE_CAP_VM:
> > +     case KVM_CAP_HALT_POLL:
> >               return 1;
> >  #ifdef CONFIG_KVM_MMIO
> >       case KVM_CAP_COALESCED_MMIO:
> > @@ -3566,6 +3570,13 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
> >               return 0;
> >       }
> >  #endif
> > +     case KVM_CAP_HALT_POLL: {
> > +             if (cap->flags || cap->args[0] != (unsigned int)cap->args[0])
> > +                     return -EINVAL;
> > +
> > +             kvm->max_halt_poll_ns = cap->args[0];
>
> Is it safe to allow any value from userspace here or would it maybe make
> sense to only allow [0, global halt_poll_ns]?

I believe that any value is safe; a very large value effectively disables
halt-polling, which is equivalent to setting a value of zero to explicitly
disable it, which is legal.


>
>
> > +             return 0;
> > +     }
> >       default:
> >               return kvm_vm_ioctl_enable_cap(kvm, cap);
> >       }
>
> --
> Vitaly
>
