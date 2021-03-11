Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732A9337886
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 16:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbhCKPyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 10:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbhCKPyK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 10:54:10 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706F1C061574
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 07:54:10 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id x7so11306061pfi.7
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 07:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z5PoswBrR9D4NEhdwlwnZjVgcw3Poesjip25bNbsvU8=;
        b=t5yefpVgg8U6RDXhYTFKKGbUXlerm6bj/1pyeMAxmsC20sRKST3anGVeBDmIDI89BR
         SFufWVJtRj8yekWN8So9DUlCaOPhKjWVm6x7iF3Jq8LhLXliKi+FYBS0UROVrld/MBVv
         w94wv05EyFDVIoKyLCltc1foTrI4HC4CLCNZ9k1VF8/aiVx8xfce/VS3L7bMYpoKucVR
         LLxU9Q8g4ZrPQxihftdFRmIDv3qgCfbFDvIox5nVgUkHRG01t8L1/mNf3YFs2WN2EcXC
         SwCaE3tBu0Yzl9raS7hV+RU46+Q+wMHX/lHCgqPyrgVliqCNtPDHgAvGg4WjL08ZY0Zj
         XF9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z5PoswBrR9D4NEhdwlwnZjVgcw3Poesjip25bNbsvU8=;
        b=S4EsMktyl7q+Ub4+4w3zB120k0NJzwP2W/I9h0iaZHUuw1YT3gs5F06TU32P/j+Bq1
         p9rm8vdt+RbEQfTGt6oOB+xYfrFT92TdZCmMGd/BuQbwPHL3rhdB6I38+oOMoP3q92do
         qbPGfrHKn4Jy0iO+/8t9h0ceqo8If83bfwAEm+SUkf/kk+EVZNmizjJudhmahQEgGj0s
         vlu7KmuRIeHFwhTlpAEOnq4pLRl7dzaEaOsrKtJoqIbqhpgrgDyAv+BccxW7tCAILm7C
         SwBy5Wz+qI+td9bjsyQ0sFWb6ZwkB5sY2wBesedlavk/3VRqQ+qt47SNH/z6sxJsF9sW
         53yg==
X-Gm-Message-State: AOAM530ZT2kSQJc4aNn2H5vHFhBwOj8PpAOCvQn3lVt8V8hmUh1JGS8w
        b3bnG+bbkA8zGk0hNwIhsVNEEQ==
X-Google-Smtp-Source: ABdhPJymE1QgFXx8Se7176Cso2qqQ7PucvJBOYCjymexgDruIIGWmoykHSbe4insIabqBTG9pHuppg==
X-Received: by 2002:a05:6a00:80e:b029:1db:589f:332e with SMTP id m14-20020a056a00080eb02901db589f332emr8021448pfk.24.1615478049703;
        Thu, 11 Mar 2021 07:54:09 -0800 (PST)
Received: from google.com ([2620:15c:f:10:c4e3:28f1:33df:26ba])
        by smtp.gmail.com with ESMTPSA id c128sm2023765pfc.76.2021.03.11.07.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 07:54:09 -0800 (PST)
Date:   Thu, 11 Mar 2021 07:54:02 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/kvm: Fix broken irq restoration in kvm_wait
Message-ID: <YEo9GsUTKQRbd3HF@google.com>
References: <1614057902-23774-1-git-send-email-wanpengli@tencent.com>
 <CANRm+CwX189YE_oi5x-b6Xx4=hpcGCqzLaHjmW6bz_=Fj2N7Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CwX189YE_oi5x-b6Xx4=hpcGCqzLaHjmW6bz_=Fj2N7Mw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 23, 2021, Wanpeng Li wrote:
> On Tue, 23 Feb 2021 at 13:25, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > After commit 997acaf6b4b59c (lockdep: report broken irq restoration), the guest
> > splatting below during boot:
> >
> >  raw_local_irq_restore() called with IRQs enabled
> >  WARNING: CPU: 1 PID: 169 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x26/0x30
> >  Modules linked in: hid_generic usbhid hid
> >  CPU: 1 PID: 169 Comm: systemd-udevd Not tainted 5.11.0+ #25
> >  RIP: 0010:warn_bogus_irq_restore+0x26/0x30
> >  Call Trace:
> >   kvm_wait+0x76/0x90
> >   __pv_queued_spin_lock_slowpath+0x285/0x2e0
> >   do_raw_spin_lock+0xc9/0xd0
> >   _raw_spin_lock+0x59/0x70
> >   lockref_get_not_dead+0xf/0x50
> >   __legitimize_path+0x31/0x60
> >   legitimize_root+0x37/0x50
> >   try_to_unlazy_next+0x7f/0x1d0
> >   lookup_fast+0xb0/0x170
> >   path_openat+0x165/0x9b0
> >   do_filp_open+0x99/0x110
> >   do_sys_openat2+0x1f1/0x2e0
> >   do_sys_open+0x5c/0x80
> >   __x64_sys_open+0x21/0x30
> >   do_syscall_64+0x32/0x50
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > The irqflags handling in kvm_wait() which ends up doing:
> >
> >         local_irq_save(flags);
> >         safe_halt();
> >         local_irq_restore(flags);
> >
> > which triggered a new consistency checking, we generally expect
> > local_irq_save() and local_irq_restore() to be pared and sanely
> > nested, and so local_irq_restore() expects to be called with
> > irqs disabled.
> >
> > This patch fixes it by adding a local_irq_disable() after safe_halt()
> > to avoid this warning.
> >
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kernel/kvm.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 5e78e01..688c84a 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -853,8 +853,10 @@ static void kvm_wait(u8 *ptr, u8 val)
> >          */
> >         if (arch_irqs_disabled_flags(flags))
> >                 halt();
> > -       else
> > +       else {
> >                 safe_halt();
> > +               local_irq_disable();
> > +       }
> 
> An alternative fix:
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 5e78e01..7127aef 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -836,12 +836,13 @@ static void kvm_kick_cpu(int cpu)
> 
>  static void kvm_wait(u8 *ptr, u8 val)
>  {
> -    unsigned long flags;
> +    bool disabled = irqs_disabled();
> 
>      if (in_nmi())
>          return;
> 
> -    local_irq_save(flags);
> +    if (!disabled)
> +        local_irq_disable();
> 
>      if (READ_ONCE(*ptr) != val)
>          goto out;
> @@ -851,13 +852,14 @@ static void kvm_wait(u8 *ptr, u8 val)
>       * for irq enabled case to avoid hang when lock info is overwritten
>       * in irq spinlock slowpath and no spurious interrupt occur to save us.
>       */
> -    if (arch_irqs_disabled_flags(flags))
> +    if (disabled)
>          halt();
>      else
>          safe_halt();
> 
>  out:
> -    local_irq_restore(flags);
> +    if (!disabled)
> +        local_irq_enable();
>  }
> 
>  #ifdef CONFIG_X86_32

A third option would be to split the paths.  In the end, it's only the ptr/val
line that's shared.

---
 arch/x86/kernel/kvm.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5e78e01ca3b4..78bb0fae3982 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -836,28 +836,25 @@ static void kvm_kick_cpu(int cpu)

 static void kvm_wait(u8 *ptr, u8 val)
 {
-	unsigned long flags;
-
 	if (in_nmi())
 		return;

-	local_irq_save(flags);
-
-	if (READ_ONCE(*ptr) != val)
-		goto out;
-
 	/*
 	 * halt until it's our turn and kicked. Note that we do safe halt
 	 * for irq enabled case to avoid hang when lock info is overwritten
 	 * in irq spinlock slowpath and no spurious interrupt occur to save us.
 	 */
-	if (arch_irqs_disabled_flags(flags))
-		halt();
-	else
-		safe_halt();
+	if (irqs_disabled()) {
+		if (READ_ONCE(*ptr) == val)
+			halt();
+	} else {
+		local_irq_disable();

-out:
-	local_irq_restore(flags);
+		if (READ_ONCE(*ptr) == val)
+			safe_halt();
+
+		local_irq_enable();
+	}
 }

 #ifdef CONFIG_X86_32
--
