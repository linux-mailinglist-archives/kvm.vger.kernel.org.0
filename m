Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91AD7180D53
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 02:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgCKBMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 21:12:16 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38807 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbgCKBMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 21:12:15 -0400
Received: by mail-oi1-f193.google.com with SMTP id k21so235897oij.5;
        Tue, 10 Mar 2020 18:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7e9kdJF3mluOhD1f6/Nwb28lEg4dYM2hjsaSfswwkMc=;
        b=NiQEiqxOO8bCCcjt2dn/i+Qn6TwC8hrPuXzL48/sfX1J5PAT0Bd5JTi4w/pz+vjMC3
         rUhxUiloArwMIKuntpFtdZjbTTakVANaquCU02lPV+gn8lMO8BSbZvpQ3SZuLWFFVv0B
         AEv1cSoafHTaceX505JZVMvQRLMkhcxYobRttgnYEBHZJdlWnd5c34y/Hg108JcaFY9Y
         DN0u+T3gmrvijuVODZSke1apmMbuXafdR2pxh6KDh/CUoH84e7Yon6ijTcYKbU7ycSR2
         ZRoWrenj/urlzpsXPql0pouwZzFmLvDbPyeWgZBWPVvXSg2aAcmYNv5SWxOSaY2OBtbQ
         UJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7e9kdJF3mluOhD1f6/Nwb28lEg4dYM2hjsaSfswwkMc=;
        b=BQqnhQjclQ0nTGRgcZgBjco38ZgGKtOF818rF67ioN9d3NAlOPDOOfijmWST/gfkwX
         YgXe+NWqKp4XYEHOxCISRXlyovO71oHBvTJFSYNStvDMrn3zm7/yICzm+7V1NIajWLt5
         KiHLLp2XfyB8rSaINxU98j//j0aFeeWYuL0seFrR4vfgIzxlZQXAdwvLkzbim3dfuS9J
         6zzCrVx54ef31UVyWeI/K4UVzMJWfejx/5UqxPVpy+54ryDdQnt720QfSXpxC0TFGrxh
         45Dj1teGvvgHGRVslu8acLOFBhgZYCr2RQ7RDrtfpBMwkU9/d1l+BBWk0ZRvZZxfiwyv
         X2Vw==
X-Gm-Message-State: ANhLgQ1SGRuZxqp1YXlFknWbmeadXKy1OvmyK2tAnl55p993fyQOsUv5
        nrDNk4TWeaNB0UDLBRKLXWc81GC6cMqXMFdCvNY=
X-Google-Smtp-Source: ADFU+vsZ+NXvpZuO6uraRuKkYFspwGjGqaznVWT289WY9llq5Vwwotot8JNDzFXSvIGNknEPl0kDhOAoqCIPNxnB5i0=
X-Received: by 2002:aca:5f09:: with SMTP id t9mr327851oib.5.1583889133582;
 Tue, 10 Mar 2020 18:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <1583823679-17648-1-git-send-email-wanpengli@tencent.com> <20200310160129.GA9305@linux.intel.com>
In-Reply-To: <20200310160129.GA9305@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 11 Mar 2020 09:12:02 +0800
Message-ID: <CANRm+CxFUiv=ss51Yg73L+HTWe4-Zrixk4mM6=XAaVwKRqeUYA@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Don't load/put guest FPU context for sleeping AP
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Mar 2020 at 00:01, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Mar 10, 2020 at 03:01:19PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > kvm_load_guest_fpu() and kvm_put_guest_fpu() each consume more than 14us
> > observed by ftrace, the qemu userspace FPU is swapped out for the guest
> > FPU context for the duration of the KVM_RUN ioctl even if sleeping AP,
> > we shouldn't load/put guest FPU context for this case especially for
> > serverless scenario which sensitives to boot time.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/x86.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5de2006..080ffa4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8680,7 +8680,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >
> >       vcpu_load(vcpu);
> >       kvm_sigset_activate(vcpu);
> > -     kvm_load_guest_fpu(vcpu);
> >
> >       if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
> >               if (kvm_run->immediate_exit) {
> > @@ -8718,12 +8717,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >               }
> >       }
> >
> > +     kvm_load_guest_fpu(vcpu);
>
> Ugh, so this isn't safe on MPX capable CPUs, kvm_apic_accept_events() can
> trigger kvm_vcpu_reset() with @init_event=true and try to unload guest_fpu.

Right.

>
> We could hack around that issue, but it'd be ugly, and I'm also concerned
> that calling vmx_vcpu_reset() without guest_fpu loaded will be problematic
> in the future with all the things that are getting managed by XSAVE.
>
> > +
> >       if (unlikely(vcpu->arch.complete_userspace_io)) {
> >               int (*cui)(struct kvm_vcpu *) = vcpu->arch.complete_userspace_io;
> >               vcpu->arch.complete_userspace_io = NULL;
> >               r = cui(vcpu);
> >               if (r <= 0)
> > -                     goto out;
> > +                     goto out_fpu;
> >       } else
> >               WARN_ON(vcpu->arch.pio.count || vcpu->mmio_needed);
> >
> > @@ -8732,8 +8733,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >       else
> >               r = vcpu_run(vcpu);
> >
> > -out:
> > +out_fpu:
> >       kvm_put_guest_fpu(vcpu);
> > +out:
> >       if (vcpu->run->kvm_valid_regs)
> >               store_regs(vcpu);
> >       post_kvm_run_save(vcpu);
> > --
> > 2.7.4
> >
