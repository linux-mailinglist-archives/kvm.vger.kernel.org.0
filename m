Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B40001019F5
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 08:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfKSHBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 02:01:55 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43680 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfKSHBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 02:01:54 -0500
Received: by mail-oi1-f195.google.com with SMTP id l20so17900402oie.10;
        Mon, 18 Nov 2019 23:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qz77BFNx7Mzy/MD1o3YVo9rJMBCL9I3q5BZGdkzee6E=;
        b=ft+p6PvxpkSpqyVCfKBkwoJ9cWG+lIgZDlW4rBbYsNdr/my6ZIlaxRNhEawqAOx24E
         JU2bg5u8gnVxdGZmJlE0h2iYcEccL1YM5MAdvz1/30irCnM5CnWS/XvMC+igIQPIf9zD
         3IG4Wy6Wrss1w+MARmW437uRb8gDXPKxtO9NQvDpEeuy1AGu/MhZvtrWq1tGb6d51+Ts
         KWOzkPl3VYVC7GPcfnYbxEP6036+OIugWfRvP1AmqUvppEGo20h+7rwiTCPgLC2jJ77I
         D0EmrbS9yKHXawP+2gtee8WPxFYiRZpDaIWu2E+EXu1Kjgahx/euS/f1iXMxf89iHBZE
         1qmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qz77BFNx7Mzy/MD1o3YVo9rJMBCL9I3q5BZGdkzee6E=;
        b=SlAAS7N1bzc9Gb/7ewXsSk3Xmn0FVy5piY82nbsIY6yjZ/+c0VDFu5S1bhFvXaY37h
         v7L3SnscZUumlxAYJ845S/DoeauwkGVACTbNm6o8azCwES4UNSEPZYsGe306TUQdsrlJ
         BSp4BNPjB2iFpFYlDpeF+HNVVGbEXsJQ7Q4avEcNwwj+yYGu+JIu/c5L/E4tTOSZQUtO
         qG83KlLkfDvx96N73afELmUfaudxTlPmDLYBeqTxnrmU6I5tWZTkFUFZzyolFZhvj2/V
         +QzSegIDsq2M9AVZLKHWO4vtRs94fDXOIpEHu7uETTlvxPwFpRnwcCk+D2MBJxAyMxqj
         BvRA==
X-Gm-Message-State: APjAAAUPn3hgtkP/GB0FlPWKdTLI6SHe10xNgNOqDxXKd8+arqugNEna
        gNFzKL9pPiQgB+avdn5zJspzrdfTtXRDMdMOkCo=
X-Google-Smtp-Source: APXvYqwmGoKh3uUy1mY1+Rk/+b0NiC55jQDs6tDgUT9OAyqEAabRDmNRZTUwg+81GMFFRf9NBZUqS3aOPzRCkh04aqQ=
X-Received: by 2002:aca:5015:: with SMTP id e21mr2814500oib.174.1574146913825;
 Mon, 18 Nov 2019 23:01:53 -0800 (PST)
MIME-Version: 1.0
References: <1571829384-5309-1-git-send-email-zhenzhong.duan@oracle.com> <1571829384-5309-4-git-send-email-zhenzhong.duan@oracle.com>
In-Reply-To: <1571829384-5309-4-git-send-email-zhenzhong.duan@oracle.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 19 Nov 2019 15:01:45 +0800
Message-ID: <CANRm+CzW=M37QwkVPhkhJHimUG6MtCMZnhcLL+24ujtpv9cPyA@mail.gmail.com>
Subject: Re: [PATCH v8 3/5] x86/kvm: Add "nopvspin" parameter to disable PV spinlocks
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>, will@kernel.org,
        linux-hyperv@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        mikelley@microsoft.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Oct 2019 at 19:21, Zhenzhong Duan <zhenzhong.duan@oracle.com> wrote:
>
> There are cases where a guest tries to switch spinlocks to bare metal
> behavior (e.g. by setting "xen_nopvspin" on XEN platform and
> "hv_nopvspin" on HYPER_V).
>
> That feature is missed on KVM, add a new parameter "nopvspin" to disable
> PV spinlocks for KVM guest.
>
> The new 'nopvspin' parameter will also replace Xen and Hyper-V specific
> parameters in future patches.
>
> Define variable nopvsin as global because it will be used in future
> patches as above.
>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krcmar <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Will Deacon <will@kernel.org>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

> ---
>  Documentation/admin-guide/kernel-parameters.txt |  5 ++++
>  arch/x86/include/asm/qspinlock.h                |  1 +
>  arch/x86/kernel/kvm.c                           | 39 ++++++++++++++++++++-----
>  kernel/locking/qspinlock.c                      |  7 +++++
>  4 files changed, 45 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index a84a83f..bd49ed2 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5334,6 +5334,11 @@
>                         as generic guest with no PV drivers. Currently support
>                         XEN HVM, KVM, HYPER_V and VMWARE guest.
>
> +       nopvspin        [X86,KVM]
> +                       Disables the qspinlock slow path using PV optimizations
> +                       which allow the hypervisor to 'idle' the guest on lock
> +                       contention.
> +
>         xirc2ps_cs=     [NET,PCMCIA]
>                         Format:
>                         <irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
> diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
> index 444d6fd..d86ab94 100644
> --- a/arch/x86/include/asm/qspinlock.h
> +++ b/arch/x86/include/asm/qspinlock.h
> @@ -32,6 +32,7 @@ static __always_inline u32 queued_fetch_set_pending_acquire(struct qspinlock *lo
>  extern void __pv_init_lock_hash(void);
>  extern void __pv_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
>  extern void __raw_callee_save___pv_queued_spin_unlock(struct qspinlock *lock);
> +extern bool nopvspin;
>
>  #define        queued_spin_unlock queued_spin_unlock
>  /**
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6562886..9834737 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -825,18 +825,36 @@ __visible bool __kvm_vcpu_is_preempted(long cpu)
>   */
>  void __init kvm_spinlock_init(void)
>  {
> -       /* Does host kernel support KVM_FEATURE_PV_UNHALT? */
> -       if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
> +       /*
> +        * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
> +        * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
> +        * preferred over native qspinlock when vCPU is preempted.
> +        */
> +       if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
> +               pr_info("PV spinlocks disabled, no host support\n");
>                 return;
> +       }
>
> +       /*
> +        * Disable PV spinlocks and use native qspinlock when dedicated pCPUs
> +        * are available.
> +        */
>         if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
> -               static_branch_disable(&virt_spin_lock_key);
> -               return;
> +               pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints\n");
> +               goto out;
>         }
>
> -       /* Don't use the pvqspinlock code if there is only 1 vCPU. */
> -       if (num_possible_cpus() == 1)
> -               return;
> +       if (num_possible_cpus() == 1) {
> +               pr_info("PV spinlocks disabled, single CPU\n");
> +               goto out;
> +       }
> +
> +       if (nopvspin) {
> +               pr_info("PV spinlocks disabled, forced by \"nopvspin\" parameter\n");
> +               goto out;
> +       }
> +
> +       pr_info("PV spinlocks enabled\n");
>
>         __pv_init_lock_hash();
>         pv_ops.lock.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
> @@ -849,6 +867,13 @@ void __init kvm_spinlock_init(void)
>                 pv_ops.lock.vcpu_is_preempted =
>                         PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
>         }
> +       /*
> +        * When PV spinlock is enabled which is preferred over
> +        * virt_spin_lock(), virt_spin_lock_key's value is meaningless.
> +        * Just disable it anyway.
> +        */
> +out:
> +       static_branch_disable(&virt_spin_lock_key);
>  }
>
>  #endif /* CONFIG_PARAVIRT_SPINLOCKS */
> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> index 2473f10..75193d6 100644
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -580,4 +580,11 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>  #include "qspinlock_paravirt.h"
>  #include "qspinlock.c"
>
> +bool nopvspin __initdata;
> +static __init int parse_nopvspin(char *arg)
> +{
> +       nopvspin = true;
> +       return 0;
> +}
> +early_param("nopvspin", parse_nopvspin);
>  #endif
> --
> 1.8.3.1
>
