Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3453C336A6C
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 04:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhCKDJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 22:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhCKDJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 22:09:04 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99ACDC061574;
        Wed, 10 Mar 2021 19:09:04 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id v192so14041540oia.5;
        Wed, 10 Mar 2021 19:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CpYr2shWjkG+N+QLxthfTv5bG8FNrC8Nvj/Q2Hx+eMM=;
        b=dDjxs9wbKFOJyi78KHhb2oeVtgz0s9r1NkojdbvqhCyt50j2A78iFYw/+s+yOqy+zB
         Kik7iOaeNMCMAYIveTgNYFp52A6zJ4doRTXIj+lgi80hb84fmBnhPTlwxhNL0d2NhWeG
         nR7OqVufvZ2UbGl6+D0fGfgFmvwmrqEq6t8i90/WegEAQoyhBTLhaA6VRpFdFrQAfSFg
         e1H20V/3cLQPkgLDkUXgWBHyUA9tv3MUhBn2Cc8OJ/nZTx+FR+ypWOJD63aVcHbmnC4s
         8R8dC3pp7E+uu2tlOsh6Fv5aSv6GBl4MM01VPrpbxC05eJqfVt5HKBHXXGZfQhW0j5Ew
         Zesg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CpYr2shWjkG+N+QLxthfTv5bG8FNrC8Nvj/Q2Hx+eMM=;
        b=FmZtJqy4BzzmIyv1bNX+UXtutFslm9vrAFeo2X5txfWJJyWgs377qbzgZGPiLwYUFF
         S/g0ymqvL2/VZucLfltkTI/7JS+ul2pLWrxJ2ZMOjTePCVnzMpEZ1rXj3rYGs7/vU59H
         s8T87EBr+PKFRH/G5xTALijpTK6423Kz13xRxQheOOw/YcfYbAgNCN4soHPbG9IiC7Np
         XWVsDTX6/HQt1TMgeJ5gMYmZk77WXVwGKR/expBEqH3WzxGnX6pZVFUatbJZUOg00Kun
         /Zw526tmZLXTq93eHSYBjrvA/hzg3GHyl5I22+ZAdlzRS9HmzkbCg6P6X+AcnfNgZJDy
         /F0Q==
X-Gm-Message-State: AOAM533s3DKdOwxp4SHa6b/3d4O+yvuzst9VR4ILvzHFMbD1zwYePGNs
        nRjv72tqx2jHXuWTvadYiSBjUjPsv6FP5W/iXVbr+wnd
X-Google-Smtp-Source: ABdhPJx0GTwhLGYhOlbN3VZXfZS4v+ACCXf9GxRQ5GcUH8VIJj9GWv6pUY7EAR+eCtgG+yaiuJ4enwhfQkS4d8EjMa4=
X-Received: by 2002:a54:408a:: with SMTP id i10mr4875452oii.141.1615432143818;
 Wed, 10 Mar 2021 19:09:03 -0800 (PST)
MIME-Version: 1.0
References: <1614130683-24137-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1614130683-24137-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 11 Mar 2021 11:08:53 +0800
Message-ID: <CANRm+CwLmHVuG36MCwU2kMQHfGODNismJEy2QDwH_AbN1OMPRQ@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping, :)
On Wed, 24 Feb 2021 at 09:38, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> # lscpu
> Architecture:          x86_64
> CPU op-mode(s):        32-bit, 64-bit
> Byte Order:            Little Endian
> CPU(s):                88
> On-line CPU(s) list:   0-63
> Off-line CPU(s) list:  64-87
>
> # cat /proc/cmdline
> BOOT_IMAGE=/vmlinuz-5.10.0-rc3-tlinux2-0050+ root=/dev/mapper/cl-root ro
> rd.lvm.lv=cl/root rhgb quiet console=ttyS0 LANG=en_US .UTF-8 no-kvmclock-vsyscall
>
> # echo 1 > /sys/devices/system/cpu/cpu76/online
> -bash: echo: write error: Cannot allocate memory
>
> The per-cpu vsyscall pvclock data pointer assigns either an element of the
> static array hv_clock_boot (#vCPU <= 64) or dynamically allocated memory
> hvclock_mem (vCPU > 64), the dynamically memory will not be allocated if
> kvmclock vsyscall is disabled, this can result in cpu hotpluged fails in
> kvmclock_setup_percpu() which returns -ENOMEM. It's broken for no-vsyscall
> and sometimes you end up with vsyscall disabled if the host does something
> strange. This patch fixes it by allocating this dynamically memory
> unconditionally even if vsyscall is disabled.
>
> Fixes: 6a1cac56f4 ("x86/kvm: Use __bss_decrypted attribute in shared variables")
> Reported-by: Zelin Deng <zelin.deng@linux.alibaba.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: stable@vger.kernel.org#v4.19-rc5+
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v3 -> v4:
>  * fix kernel test robot report WARNING
> v2 -> v3:
>  * allocate dynamically memory unconditionally
> v1 -> v2:
>  * add code comments
>
>  arch/x86/kernel/kvmclock.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index aa59374..1fc0962 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -268,21 +268,20 @@ static void __init kvmclock_init_mem(void)
>
>  static int __init kvm_setup_vsyscall_timeinfo(void)
>  {
> -#ifdef CONFIG_X86_64
> -       u8 flags;
> +       kvmclock_init_mem();
>
> -       if (!per_cpu(hv_clock_per_cpu, 0) || !kvmclock_vsyscall)
> -               return 0;
> +#ifdef CONFIG_X86_64
> +       if (per_cpu(hv_clock_per_cpu, 0) && kvmclock_vsyscall) {
> +               u8 flags;
>
> -       flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
> -       if (!(flags & PVCLOCK_TSC_STABLE_BIT))
> -               return 0;
> +               flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
> +               if (!(flags & PVCLOCK_TSC_STABLE_BIT))
> +                       return 0;
>
> -       kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
> +               kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
> +       }
>  #endif
>
> -       kvmclock_init_mem();
> -
>         return 0;
>  }
>  early_initcall(kvm_setup_vsyscall_timeinfo);
> --
> 2.7.4
>
