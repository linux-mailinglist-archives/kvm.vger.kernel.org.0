Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE22A24C69A
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 22:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgHTUIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 16:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbgHTUIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 16:08:35 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F32C061386
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 13:08:35 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id b22so2971739oic.8
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 13:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GpwFgamWVqMs1v/sOEpIYQQxMEuzWGAMmLZ6OgISKjw=;
        b=hR8BP/i1JBmlB1LmQQlCWmfRR0GJ9aYCx7yH/mjonES133wZQVlrqzfUFWRknPJ3VO
         /lbl4Pz1/2091MNHFqE9FWJhAH/NIZsnd5rHDBlS2hxr30JymZmf2d65AlVyME8mvWII
         C2zPQSZWBYNaE+V063+hhHkSXf16+iXEn3CmAYQOxxNBXJa3tJ8GfiTdfyGqcsBSKJaA
         O5nkoC+SSbwKi9wqnedJKOR6OPjfwqDWWLK8YEolJWZVEXjCvFEjPQUVTs29/xgdpUTF
         r6k0DgH96GCug2xxFeSAHNCoGTRVJAxCZN9scJqPepL3mhCjhAA49jn0RhPFh0lgJEVr
         fmgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GpwFgamWVqMs1v/sOEpIYQQxMEuzWGAMmLZ6OgISKjw=;
        b=oFNbzjXXTRmOvwFFsRXundftpRH4cMAAR9WCD1uCAQipb2YB+GlHfpKu98xWGWBxAL
         Wyz8wEE1jn0UQ/zVNZ1tV4mo88BO4GhOpZKHYG17+hO3CZzY7FrUuEPsYYhUSpGRQw+B
         /hGPlQBvRjBzwVPbw+DfmDUpmg7ezO50n2yID6z1TI3QCpNpM9we+4wHeHTMxmeV4JaL
         FMpRgInoUGkrAphaUnwaKjkyM64nUoJcGN1B1RxwhPgO8Pb7wUiPWIlnZRsN6tADbbL4
         aQjVx9CRnOQExicdz1EUxgrRHoyOBEdHKQDIj4aGM3r6InxODG7f0/kt0Xm7anIf0Xqo
         UoRQ==
X-Gm-Message-State: AOAM533Nn9+McMrq0Ab5LQc/UxEjbCjvLjiylffUjks+nlu8KEFK5lZM
        Xg9B6uymObm0hYayhLpmrvNj/dsQGLN1P5t/q2E8jw==
X-Google-Smtp-Source: ABdhPJxLujXsofK2hMWnUp1gfJMtqP5I7r3Zv2lLxYgVvsnyUj3yNq2asg7InuIn65oLgHoB6hORdloRnSe+gpmBZrQ=
X-Received: by 2002:aca:670b:: with SMTP id z11mr60431oix.6.1597954113907;
 Thu, 20 Aug 2020 13:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200401081348.1345307-1-vkuznets@redhat.com>
In-Reply-To: <20200401081348.1345307-1-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Aug 2020 13:08:22 -0700
Message-ID: <CALMp9eROXAOg_g=R8JRVfywY7uQXzBtVxKJYXq0dUcob-BfR-g@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: fix crash cleanup when KVM wasn't used
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 1, 2020 at 1:13 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> If KVM wasn't used at all before we crash the cleanup procedure fails with
>  BUG: unable to handle page fault for address: ffffffffffffffc8
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 23215067 P4D 23215067 PUD 23217067 PMD 0
>  Oops: 0000 [#8] SMP PTI
>  CPU: 0 PID: 3542 Comm: bash Kdump: loaded Tainted: G      D           5.6.0-rc2+ #823
>  RIP: 0010:crash_vmclear_local_loaded_vmcss.cold+0x19/0x51 [kvm_intel]
>
> The root cause is that loaded_vmcss_on_cpu list is not yet initialized,
> we initialize it in hardware_enable() but this only happens when we start
> a VM.
>
> Previously, we used to have a bitmap with enabled CPUs and that was
> preventing [masking] the issue.
>
> Initialized loaded_vmcss_on_cpu list earlier, right before we assign
> crash_vmclear_loaded_vmcss pointer. blocked_vcpu_on_cpu list and
> blocked_vcpu_on_cpu_lock are moved altogether for consistency.
>
> Fixes: 31603d4fc2bb ("KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3aba51d782e2..39a5dde12b79 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2257,10 +2257,6 @@ static int hardware_enable(void)
>             !hv_get_vp_assist_page(cpu))
>                 return -EFAULT;
>
> -       INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> -       INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
> -       spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
> -
>         r = kvm_cpu_vmxon(phys_addr);
>         if (r)
>                 return r;
> @@ -8006,7 +8002,7 @@ module_exit(vmx_exit);
>
>  static int __init vmx_init(void)
>  {
> -       int r;
> +       int r, cpu;
>
>  #if IS_ENABLED(CONFIG_HYPERV)
>         /*
> @@ -8060,6 +8056,12 @@ static int __init vmx_init(void)
>                 return r;
>         }
>
> +       for_each_possible_cpu(cpu) {
> +               INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> +               INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
> +               spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
> +       }

Just above this chunk, we have:

r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
if (r) {
        vmx_exit();
...

If we take that early exit, because vmx_setup_l1d_flush() fails, we
won't initialize loaded_vmcss_on_cpu. However, vmx_exit() calls
kvm_exit(), which calls on_each_cpu(hardware_disable_nolock, NULL, 1).
Hardware_disable_nolock() then calls kvm_arch_hardware_disable(),
which calls kvm_x86_ops.hardware_disable() [the vmx.c
hardware_disable()], which calls vmclear_local_loaded_vmcss().

I believe that vmclear_local_loaded_vmcss() will then try to
dereference a NULL pointer, since per_cpu(loaded_vmcss_on_cpu, cpu) is
uninitialzed.

>  #ifdef CONFIG_KEXEC_CORE
>         rcu_assign_pointer(crash_vmclear_loaded_vmcss,
>                            crash_vmclear_local_loaded_vmcss);
> --
> 2.25.1
>
