Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C74A377E9D
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhEJIwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhEJIwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 04:52:35 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8C7C061573;
        Mon, 10 May 2021 01:51:30 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso13734052otb.13;
        Mon, 10 May 2021 01:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+r8BVxHk1L3blGKpgXCIc2S1WgCsup6Bh4KC+edeS3k=;
        b=lOzjSy0Ncj10m2t9syUMAtwu2shOjfAIyyTVlt9DK4D4QIBi/X1gLtnIru/pUwaAQQ
         l13Jsl4sdulSWQw9dJpq1uVFC6f54kOT6hqHwxZiyvPBNu0GRzKXQpdP40vAleigw09g
         XMARzKwa1jWyOxUWFnEI24JPaMXosvtDFV+h+TUZtTJZPOBvhCccOYOhKytIoxSPYTKK
         fnkqZIXqam0P8tyUXxHmwZeJ2IVVAswxA7DgDUYSKsxFRMLJFpe8NMhaADrfhmjKbQ4j
         kSKXmFNysKxMLuk1dNti7aCKHqCC1pNiPAKFyQn86x3mQNQE+oRiP0FcPxUJdEPFB2If
         f96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+r8BVxHk1L3blGKpgXCIc2S1WgCsup6Bh4KC+edeS3k=;
        b=iki8R6MbALN8vti2pIIPTI3J27Ni5Y1ckbSs+QmmfilQJOEAD7acNgVeQBFY9IBeMu
         tUxiFAjWe4ppRB+GAker8y2ScCcXv1+tGPUmbH+5639cnQPLyLDTQTU+ZJLU15TuOsAZ
         B7lgWDJF5Fm0QI3SOj9rgiLQXcPLSI6D2wRo9EkY5dsLK3Utlu5F9GEEcTw2Lv4aW2T6
         nEarISwt4MOLfY7vjfiyE+5/PXYurcBKamFsa4fES24PkToB2jJTguROUDacklNyL142
         /TB8IawYVKmB6UXhtSlrwL8aC9l0/pFisfEfgsFrwg2OeMqFh028u8rln7E4eGqNAfVy
         adkg==
X-Gm-Message-State: AOAM531bQcmo2BF1Jc4GB/H1AkOyihX5QfPItst1GwNXdvciXxy1nPKg
        rIqx6kULstr/TNfSSPnhdw+WywkcZzNFV4XvwZA=
X-Google-Smtp-Source: ABdhPJzpeAnTZoQL+kI8F0FuoxC2H61x7yppqevqk2UpMiyc23SeJw5jVmwJ8Y3NPiRgyhhTimsHxcDfT1FLq9gknD4=
X-Received: by 2002:a05:6830:16c8:: with SMTP id l8mr20327751otr.56.1620636690072;
 Mon, 10 May 2021 01:51:30 -0700 (PDT)
MIME-Version: 1.0
References: <1620634919-4563-1-git-send-email-wanpengli@tencent.com> <87mtt3vus5.fsf@vitty.brq.redhat.com>
In-Reply-To: <87mtt3vus5.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 10 May 2021 16:51:19 +0800
Message-ID: <CANRm+Cw-MdiZKt7rPKGM=7ZudW3c_H5--CGg82t7eChSBkn-FQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: hyper-v: Task srcu lock when accessing kvm_memslots()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 at 16:48, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> >  WARNING: suspicious RCU usage
> >  5.13.0-rc1 #4 Not tainted
> >  -----------------------------
> >  ./include/linux/kvm_host.h:710 suspicious rcu_dereference_check() usage!
> >
> > other info that might help us debug this:
> >
> > rcu_scheduler_active = 2, debug_locks = 1
> >  1 lock held by hyperv_clock/8318:
> >   #0: ffffb6b8cb05a7d8 (&hv->hv_lock){+.+.}-{3:3}, at: kvm_hv_invalidate_tsc_page+0x3e/0xa0 [kvm]
> >
> > stack backtrace:
> > CPU: 3 PID: 8318 Comm: hyperv_clock Not tainted 5.13.0-rc1 #4
> > Call Trace:
> >  dump_stack+0x87/0xb7
> >  lockdep_rcu_suspicious+0xce/0xf0
> >  kvm_write_guest_page+0x1c1/0x1d0 [kvm]
> >  kvm_write_guest+0x50/0x90 [kvm]
> >  kvm_hv_invalidate_tsc_page+0x79/0xa0 [kvm]
> >  kvm_gen_update_masterclock+0x1d/0x110 [kvm]
> >  kvm_arch_vm_ioctl+0x2a7/0xc50 [kvm]
> >  kvm_vm_ioctl+0x123/0x11d0 [kvm]
> >  __x64_sys_ioctl+0x3ed/0x9d0
> >  do_syscall_64+0x3d/0x80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > kvm_memslots() will be called by kvm_write_guest(), so we should take the srcu lock.
> >
> > Fixes: e880c6ea5 (KVM: x86: hyper-v: Prevent using not-yet-updated TSC page by secondary CPUs)
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/hyperv.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index f98370a3..f00830e 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -1172,6 +1172,7 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
> >  {
> >       struct kvm_hv *hv = to_kvm_hv(kvm);
> >       u64 gfn;
> > +     int idx;
> >
> >       if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
> >           hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET ||
> > @@ -1190,9 +1191,16 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
> >       gfn = hv->hv_tsc_page >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
> >
> >       hv->tsc_ref.tsc_sequence = 0;
> > +
> > +     /*
> > +      * Take the srcu lock as memslots will be accessed to check the gfn
> > +      * cache generation against the memslots generation.
> > +      */
> > +     idx = srcu_read_lock(&kvm->srcu);
> >       if (kvm_write_guest(kvm, gfn_to_gpa(gfn),
> >                           &hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence)))
> >               hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
> > +     srcu_read_unlock(&kvm->srcu, idx);
> >
> >  out_unlock:
> >       mutex_unlock(&hv->hv_lock);
>
> Thanks!
>
> Do we need to do the same in kvm_hv_setup_tsc_page()?

kvm_hv_setup_tsc_page() is called in vcpu_enter_guest() path which has
already held kvm->srcu lock.

    Wanpeng
