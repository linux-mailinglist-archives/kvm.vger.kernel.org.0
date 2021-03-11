Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C6E336A6E
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 04:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhCKDJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 22:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhCKDJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 22:09:32 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E96C061574;
        Wed, 10 Mar 2021 19:09:22 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id z47-20020a4a98720000b02901b5f20aed58so337728ooi.0;
        Wed, 10 Mar 2021 19:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f8s2BYFkRAlrcL5fH4h6mp5Vr1uQC0s8KYZq39wp270=;
        b=aQU8tLc0883Itw1FbO1/2m9S7YUANZmRBo/KdnN5kaNalSBwBmh7U2O4KfBLT99aZ+
         ay2K7+dGAdS6nCSUGhGtZVfRjuW5fcLpOTgfShjrfFhmgbOebgDo760+jHuwUk2uWC7w
         Uyc+BfQiOUkDZ57OLFX7tjzNizxszN8IZtpC8lb0yeS+tvsbQ53Mnj+AtAA9mfmLdZ9e
         jVRyFxtmmUVrSrHui18zmjEPxDmA9Xq3um4poHqVaKjPREWrCfamQxGXGSwKkyyl4pSg
         y+uqu6kk+N4c+9PtQPB5wFEmaLuXIEyvDcdTmpZVPBwEL2PgNQpBZetxdUHnnjU3zLwU
         uvGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f8s2BYFkRAlrcL5fH4h6mp5Vr1uQC0s8KYZq39wp270=;
        b=X0wCo5PfGZmpxVsb5YcfDaq+8TNk2/h8cTu4Pl8o6ErjkTgpjOvXMIvCjN5pQM9iEK
         BltFC+FbWpsFlZMQ5S9YP9idxW+y02uzsEobQVJk6My0FlpdSaMH8gI5EP8/CriJsY1C
         1OEYAZUNEtkzOVZvRIrtvHmJaTU60/8FLS6vfOHf6l8QCsG+TeIoLm2rbDv4vAVEisbU
         JYrx6hVBwmmWmM2447r3OXXeJMTw3NxLuCtapPNsHw7kLHtDMwTJLkY908kewBtPhxvf
         AYT0GbVpzhlMpZmD6XptTHdCbEa+ZTZBLgNt0Ir0oqiUtiUq4xfCIiPxRtMC8MdlrAgn
         EvTA==
X-Gm-Message-State: AOAM533JRTEZifDmADVRDaXkPmatD8UR5eA/j9eHPoySGX8H9s4S+Te7
        JKDt5hs9N2n8e8IyyJhDk4pQexP4SGLeMaEg40K6womf
X-Google-Smtp-Source: ABdhPJzuRfyNSDS/ECwr6eYkC+3MLV78crdkV4sjdfCvG9ZtfIUTxJE9knMhMkVFLV1NoJhpuYWci4ebpKPdQMt7pGU=
X-Received: by 2002:a4a:a223:: with SMTP id m35mr4927781ool.39.1615432160511;
 Wed, 10 Mar 2021 19:09:20 -0800 (PST)
MIME-Version: 1.0
References: <1614057902-23774-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1614057902-23774-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 11 Mar 2021 11:09:09 +0800
Message-ID: <CANRm+CyDPTio2DArTn0tiNs5kCRvKeT7YHUySvUnqkdQLC1+6Q@mail.gmail.com>
Subject: Re: [PATCH] x86/kvm: Fix broken irq restoration in kvm_wait
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping,
On Tue, 23 Feb 2021 at 13:25, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> After commit 997acaf6b4b59c (lockdep: report broken irq restoration), the guest
> splatting below during boot:
>
>  raw_local_irq_restore() called with IRQs enabled
>  WARNING: CPU: 1 PID: 169 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x26/0x30
>  Modules linked in: hid_generic usbhid hid
>  CPU: 1 PID: 169 Comm: systemd-udevd Not tainted 5.11.0+ #25
>  RIP: 0010:warn_bogus_irq_restore+0x26/0x30
>  Call Trace:
>   kvm_wait+0x76/0x90
>   __pv_queued_spin_lock_slowpath+0x285/0x2e0
>   do_raw_spin_lock+0xc9/0xd0
>   _raw_spin_lock+0x59/0x70
>   lockref_get_not_dead+0xf/0x50
>   __legitimize_path+0x31/0x60
>   legitimize_root+0x37/0x50
>   try_to_unlazy_next+0x7f/0x1d0
>   lookup_fast+0xb0/0x170
>   path_openat+0x165/0x9b0
>   do_filp_open+0x99/0x110
>   do_sys_openat2+0x1f1/0x2e0
>   do_sys_open+0x5c/0x80
>   __x64_sys_open+0x21/0x30
>   do_syscall_64+0x32/0x50
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The irqflags handling in kvm_wait() which ends up doing:
>
>         local_irq_save(flags);
>         safe_halt();
>         local_irq_restore(flags);
>
> which triggered a new consistency checking, we generally expect
> local_irq_save() and local_irq_restore() to be pared and sanely
> nested, and so local_irq_restore() expects to be called with
> irqs disabled.
>
> This patch fixes it by adding a local_irq_disable() after safe_halt()
> to avoid this warning.
>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kernel/kvm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 5e78e01..688c84a 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -853,8 +853,10 @@ static void kvm_wait(u8 *ptr, u8 val)
>          */
>         if (arch_irqs_disabled_flags(flags))
>                 halt();
> -       else
> +       else {
>                 safe_halt();
> +               local_irq_disable();
> +       }
>
>  out:
>         local_irq_restore(flags);
> --
> 2.7.4
>
