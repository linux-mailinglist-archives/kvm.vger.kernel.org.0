Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03DE32255D
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 06:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhBWF3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 00:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhBWF3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 00:29:12 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DB6C061574;
        Mon, 22 Feb 2021 21:28:31 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id f3so16503657oiw.13;
        Mon, 22 Feb 2021 21:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lwj5MobrJnNqjEfnyDCKLy+EwAn09sOy0OKym1ak5/U=;
        b=mwN8jiaUTi634arC+a8gFSiO0axpO2LOG2l/oEedksOViVsBbYkB4rNchP5FMxJ6bU
         EWiz3QsVzu+5wyccPloIt7bwheEFT4bgbuyMzF7CIJGE+2Qp2R2aUKGqYgYZnXU/H0q+
         uns3J7goprXWurkldJqLd3I43QqWB9ASjhL8JpdfdzX6wI2eU7+fGr7XxH7Qopf4o02P
         xsyRn5j5c/yXgUJqrawHacS8l8WuH/OxnbHkri3CFvqfiYm5HBK4O6/5pcvvFks9ZJpi
         VWDd0Uie/TjdvmGuam2daFvRfgfKle5WG3oOJreq/WNir4CFKRoX60ZYey2qRNU/d9v2
         UyMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lwj5MobrJnNqjEfnyDCKLy+EwAn09sOy0OKym1ak5/U=;
        b=KbU9kxZBukfYI3wlRAyDVpDz+lTgQ0gTv5Mn8VLwov5BOqx4CYNqymUXFPiTQJMx2S
         6U7rB/YCMvQF0unrh+HDBAOWpLBeC6OKVtzFiGrzQf0jCqaO9rEmx7hvqPWmBkdNMzq7
         Tb5Nqev8RWd8kAF8a6BYu94IT17w0KYpCyoxsHjwm9nUd6/X3EIM7z1vcS2hKmOWxPdI
         7LU3P1iQAxvofmDEMoLB+2SL03Llrck5mbdCcpabKaJZQTTuW8hBo8ty/HhOEo4NJ6mt
         Nh+vpOAvbB/fCbKifWNzN7GT71dk5cGZkP0lG6A37u5yH7PX8wELV058yDBNGb/cPm3x
         tyow==
X-Gm-Message-State: AOAM532nwqul+Nh/v40O9jQf4ZiUriVn5Wy7Wew6fQsFAtF5bvVSyRl5
        5GG728bfqSxN5RpRtC7KUTmEE7ID6A7QIPWWUXmz6mVuIyU=
X-Google-Smtp-Source: ABdhPJykN5Bi5N4WPXpFZGHeFc7dsRHkkUyc7QyH+biEyWI1M6bLOwto6RHwjHeIb2PpzXp+z4PQG8QkdMM3ajtVGJY=
X-Received: by 2002:a05:6808:10ca:: with SMTP id s10mr15557313ois.33.1614058111252;
 Mon, 22 Feb 2021 21:28:31 -0800 (PST)
MIME-Version: 1.0
References: <1614057902-23774-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1614057902-23774-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 23 Feb 2021 13:28:19 +0800
Message-ID: <CANRm+CwX189YE_oi5x-b6Xx4=hpcGCqzLaHjmW6bz_=Fj2N7Mw@mail.gmail.com>
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

An alternative fix:

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5e78e01..7127aef 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -836,12 +836,13 @@ static void kvm_kick_cpu(int cpu)

 static void kvm_wait(u8 *ptr, u8 val)
 {
-    unsigned long flags;
+    bool disabled = irqs_disabled();

     if (in_nmi())
         return;

-    local_irq_save(flags);
+    if (!disabled)
+        local_irq_disable();

     if (READ_ONCE(*ptr) != val)
         goto out;
@@ -851,13 +852,14 @@ static void kvm_wait(u8 *ptr, u8 val)
      * for irq enabled case to avoid hang when lock info is overwritten
      * in irq spinlock slowpath and no spurious interrupt occur to save us.
      */
-    if (arch_irqs_disabled_flags(flags))
+    if (disabled)
         halt();
     else
         safe_halt();

 out:
-    local_irq_restore(flags);
+    if (!disabled)
+        local_irq_enable();
 }

 #ifdef CONFIG_X86_32
