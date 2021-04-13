Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4418D35D467
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 02:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbhDMAXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 20:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239133AbhDMAXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 20:23:52 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37579C061756
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:23:34 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id 6so12637988ilt.9
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kRssdtFHKi97tNyc5D+V2cDQ5RHWUMi++g4fZzFZXRg=;
        b=vAcFAzMKpNpNOdQbVBxXaL8NIRssz2A0T70BqLEbbCva8esUHoy1CiUge40ajK6OFY
         MxSGvp0eOi0oX68c0nc3F3rye/jLuYftu6Fn8piIHgcMPRgCTsjOWVjcyb9Wpl2vZe0O
         aDelcZ8mtHb+MHsJ3E20k3G4WKhp1g9fQYoKSZckDZp3l7paguUMwrv265NHxnW32SwA
         Y535vKY8yE+qx5b+IUZId5WK/lYcefqdvXMg5wlSvQCsV+NPbEL0xRqDbU3HazeMbyos
         wmsS91C1fkryNiabTWPK7eqVxkOLTzLVa8ZmotDbz24wQKLFX4//qSpcFFTEY7ox7As/
         5/ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kRssdtFHKi97tNyc5D+V2cDQ5RHWUMi++g4fZzFZXRg=;
        b=AKciYA/1k/gzSy4WpHpdfqpTU0uozkZaVw+uEM/mYLfuMo+owo5X/FEknbrvVVbsfY
         +Ekt3/kRwD30p7Izdqf0QGM3yi4TR6k3PJxAbP4SmP+7VbfKu/TYKZjIh2bnCRs80n+W
         18hqf32Yt2Kdm0cow6Wlhqca4zZRdMrEUWPf5z7wdF+Zw8poMYZyasbVWS7+QQyMmQNM
         jTP9ASpMXwY67z9tu1sp9dT+15AyBOU0NtK1H9/jX3unMUMLQggseRcy+EyI54fqA/N+
         BDqUmoT4q9YhYxbIGRNO4IYHETODDaDZVwiqtnSIRUTtRGcqPG6ieN62m3siYqJiXYOx
         pf+g==
X-Gm-Message-State: AOAM530OHa8CQy2a8hbArnIQqFfp9uTGmg6Y2mgxuaHk6SogMntdUEZB
        1c3EE4HrIujc9XLl54vQ5bGSLC51cKC6fZUJyOGRAQ==
X-Google-Smtp-Source: ABdhPJx3hMAvxNQzOgqi/dUzz8vLdAc4w72/15OSKJjaCygiC+JLISAmTZF5EmhAdBLIe5z7+HR8HsUadOoa7aZLbdc=
X-Received: by 2002:a05:6e02:1e08:: with SMTP id g8mr25478517ila.176.1618273413327;
 Mon, 12 Apr 2021 17:23:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618254007.git.ashish.kalra@amd.com> <c349516d85d9e3fc7404d564ff81d7ebecc1162c.1618254007.git.ashish.kalra@amd.com>
In-Reply-To: <c349516d85d9e3fc7404d564ff81d7ebecc1162c.1618254007.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 12 Apr 2021 17:22:57 -0700
Message-ID: <CABayD+cNLdoPHYvw0ZAXZS2wRg4cCFGTMvON0Ja2cWJ4juHNbA@mail.gmail.com>
Subject: Re: [PATCH v12 13/13] x86/kvm: Add kexec support for SEV Live Migration.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 12:48 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Reset the host's shared pages list related to kernel
> specific page encryption status settings before we load a
> new kernel by kexec. We cannot reset the complete
> shared pages list here as we need to retain the
> UEFI/OVMF firmware specific settings.
>
> The host's shared pages list is maintained for the
> guest to keep track of all unencrypted guest memory regions,
> therefore we need to explicitly mark all shared pages as
> encrypted again before rebooting into the new guest kernel.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kernel/kvm.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index bcc82e0c9779..4ad3ed547ff1 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -39,6 +39,7 @@
>  #include <asm/cpuidle_haltpoll.h>
>  #include <asm/ptrace.h>
>  #include <asm/svm.h>
> +#include <asm/e820/api.h>
>
>  DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
>
> @@ -384,6 +385,29 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
>          */
>         if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>                 wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> +       /*
> +        * Reset the host's shared pages list related to kernel
> +        * specific page encryption status settings before we load a
> +        * new kernel by kexec. NOTE: We cannot reset the complete
> +        * shared pages list here as we need to retain the
> +        * UEFI/OVMF firmware specific settings.
> +        */
> +       if (sev_live_migration_enabled & (smp_processor_id() == 0)) {
What happens if the reboot of CPU0 races with another CPU servicing a
device request (while the reboot is pending for that CPU)?
Seems like you could run into a scenario where you have hypercalls racing.

Calling this on every core isn't free, but it is an easy way to avoid this race.
You could also count cores, and have only last core do the job, but
that seems more complicated.

Steve
> +               int i;
> +               unsigned long nr_pages;
> +
> +               for (i = 0; i < e820_table->nr_entries; i++) {
> +                       struct e820_entry *entry = &e820_table->entries[i];
> +
> +                       if (entry->type != E820_TYPE_RAM)
> +                               continue;
> +
> +                       nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
> +
> +                       kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> +                                          entry->addr, nr_pages, 1);
> +               }
> +       }
>         kvm_pv_disable_apf();
>         kvm_disable_steal_time();
>  }
> --
> 2.17.1
>
