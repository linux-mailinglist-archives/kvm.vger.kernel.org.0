Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC117C98DF
	for <lists+kvm@lfdr.de>; Sun, 15 Oct 2023 14:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjJOMAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Oct 2023 08:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjJOMAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Oct 2023 08:00:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0CCA3
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 04:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697371161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7odMBbvZWVsldhQpSxACtvJJIZbtETAe+tcSmUnuJjg=;
        b=KceyIFoiWoiNrl2fzVPzFLKkgeZ3tCQrozeh/pVETfY4poj0AJbwHR3GXhRCGgIPyf59Kz
        a0Fn0SmsmPpMEYHPDMoH4xaiKynwCCM6Oxyv3PJNwGlyxgYyn33TnyZwutqdaLCso0mTwZ
        RW4A3mcYlaDrBaZXVTxL/f8Gx7HOv9o=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-E9MqRsmbNcCLWcGbGDapDw-1; Sun, 15 Oct 2023 07:59:19 -0400
X-MC-Unique: E9MqRsmbNcCLWcGbGDapDw-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-457c02bfb64so805073137.0
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 04:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697371159; x=1697975959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7odMBbvZWVsldhQpSxACtvJJIZbtETAe+tcSmUnuJjg=;
        b=d1arNhC50FlahsLvz+4NrjvSWaSj9YIcXIRyW1SmmCHA/NQhnfMPmebIy944nC+poM
         6j6tuvWjou7LXi/6iMNhiBSQ1BGXjXBd1NTPV8wFJR7zBfA1ErHNI2jPhYPWBrQNMXPz
         W7V2xEd1s0w11u1QpaadX8Gi0e0UVvtzBKsRlosWk19lGpPfLpTy6veS47JPBdQ1+5UB
         9zhvlJzqdYw340/GcYnkGBtFc1gAyDpPDjFljwpzXXWYdeILudmj+l+BbozZw4Z3/XU6
         oyF4aHR+K8uVfz3ww8fuwegq/hIzWvG/NNFNGxF/Ut0Hzce6HlCkYcIEB4fVxg8vFyYG
         Yinw==
X-Gm-Message-State: AOJu0Yx+kTtSC7+cxXHp3dzmyEFNdiKnb1LbGeX3iNwFRurKNvsr1uP5
        83AxVkrMg1b+TuYw7UUPKbgGuebhQ2u8+X6IkMfU+slXjl1yCO1V2rKZmtJR8RUhkA0j3L6TVO4
        tZL5Md9+sE1oNdcKcDNOhhWfq6mPL
X-Received: by 2002:a67:f918:0:b0:452:8e07:db61 with SMTP id t24-20020a67f918000000b004528e07db61mr28478012vsq.6.1697371158534;
        Sun, 15 Oct 2023 04:59:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELKarAPYFoutdt+n5qD/eLZFSa9kKfU3ZxWAZUeTN1sG50XRhX1O35PZcGF5uWUC5f/xEbG8Q271emAppLWM4=
X-Received: by 2002:a67:f918:0:b0:452:8e07:db61 with SMTP id
 t24-20020a67f918000000b004528e07db61mr28478004vsq.6.1697371158260; Sun, 15
 Oct 2023 04:59:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230914015459.51740-1-sashal@kernel.org>
In-Reply-To: <20230914015459.51740-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sun, 15 Oct 2023 13:59:06 +0200
Message-ID: <CABgObfbKV3TvVeixtVvp6f9Qtr47aiStUBsDH2_c6jrDGiWR_A@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.5 1/7] x86/reboot: VMCLEAR active VMCSes before
 emergency reboot
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, akpm@linux-foundation.org, bhe@redhat.com,
        eric.devolder@oracle.com, hbathini@linux.ibm.com,
        sourabhjain@linux.ibm.com, bhelgaas@google.com,
        kai.huang@intel.com, peterz@infradead.org, jpoimboe@kernel.org,
        tiwai@suse.de, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 3:55=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> From: Sean Christopherson <seanjc@google.com>
>
> [ Upstream commit b23c83ad2c638420ec0608a9de354507c41bec29 ]
>
> VMCLEAR active VMCSes before any emergency reboot, not just if the kernel
> may kexec into a new kernel after a crash.  Per Intel's SDM, the VMX
> architecture doesn't require the CPU to flush the VMCS cache on INIT.  If
> an emergency reboot doesn't RESET CPUs, cached VMCSes could theoretically
> be kept and only be written back to memory after the new kernel is booted=
,
> i.e. could effectively corrupt memory after reboot.
>
> Opportunistically remove the setting of the global pointer to NULL to mak=
e
> checkpatch happy.

Intended as a cleanup but I guess it does not hurt, since it was the first =
patch
in the large series that included it.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo


> Cc: Andrew Cooper <Andrew.Cooper3@citrix.com>
> Link: https://lore.kernel.org/r/20230721201859.2307736-2-seanjc@google.co=
m
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/x86/include/asm/kexec.h  |  2 --
>  arch/x86/include/asm/reboot.h |  2 ++
>  arch/x86/kernel/crash.c       | 31 -------------------------------
>  arch/x86/kernel/reboot.c      | 22 ++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c        | 10 +++-------
>  5 files changed, 27 insertions(+), 40 deletions(-)
>
> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> index 5b77bbc28f969..819046974b997 100644
> --- a/arch/x86/include/asm/kexec.h
> +++ b/arch/x86/include/asm/kexec.h
> @@ -205,8 +205,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage =
*image);
>  #endif
>  #endif
>
> -typedef void crash_vmclear_fn(void);
> -extern crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
>  extern void kdump_nmi_shootdown_cpus(void);
>
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.=
h
> index 9177b4354c3f5..dc201724a6433 100644
> --- a/arch/x86/include/asm/reboot.h
> +++ b/arch/x86/include/asm/reboot.h
> @@ -25,6 +25,8 @@ void __noreturn machine_real_restart(unsigned int type)=
;
>  #define MRR_BIOS       0
>  #define MRR_APM                1
>
> +typedef void crash_vmclear_fn(void);
> +extern crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
>  void cpu_emergency_disable_virtualization(void);
>
>  typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index cdd92ab43cda4..54cd959cb3160 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -48,38 +48,12 @@ struct crash_memmap_data {
>         unsigned int type;
>  };
>
> -/*
> - * This is used to VMCLEAR all VMCSs loaded on the
> - * processor. And when loading kvm_intel module, the
> - * callback function pointer will be assigned.
> - *
> - * protected by rcu.
> - */
> -crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss =3D NULL;
> -EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
> -
> -static inline void cpu_crash_vmclear_loaded_vmcss(void)
> -{
> -       crash_vmclear_fn *do_vmclear_operation =3D NULL;
> -
> -       rcu_read_lock();
> -       do_vmclear_operation =3D rcu_dereference(crash_vmclear_loaded_vmc=
ss);
> -       if (do_vmclear_operation)
> -               do_vmclear_operation();
> -       rcu_read_unlock();
> -}
> -
>  #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
>
>  static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
>  {
>         crash_save_cpu(regs, cpu);
>
> -       /*
> -        * VMCLEAR VMCSs loaded on all cpus if needed.
> -        */
> -       cpu_crash_vmclear_loaded_vmcss();
> -
>         /*
>          * Disable Intel PT to stop its logging
>          */
> @@ -133,11 +107,6 @@ void native_machine_crash_shutdown(struct pt_regs *r=
egs)
>
>         crash_smp_send_stop();
>
> -       /*
> -        * VMCLEAR VMCSs loaded on this cpu if needed.
> -        */
> -       cpu_crash_vmclear_loaded_vmcss();
> -
>         cpu_emergency_disable_virtualization();
>
>         /*
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 3adbe97015c13..3fa4c6717a1db 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -787,6 +787,26 @@ void machine_crash_shutdown(struct pt_regs *regs)
>  }
>  #endif
>
> +/*
> + * This is used to VMCLEAR all VMCSs loaded on the
> + * processor. And when loading kvm_intel module, the
> + * callback function pointer will be assigned.
> + *
> + * protected by rcu.
> + */
> +crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
> +EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
> +
> +static inline void cpu_crash_vmclear_loaded_vmcss(void)
> +{
> +       crash_vmclear_fn *do_vmclear_operation =3D NULL;
> +
> +       rcu_read_lock();
> +       do_vmclear_operation =3D rcu_dereference(crash_vmclear_loaded_vmc=
ss);
> +       if (do_vmclear_operation)
> +               do_vmclear_operation();
> +       rcu_read_unlock();
> +}
>
>  /* This is the CPU performing the emergency shutdown work. */
>  int crashing_cpu =3D -1;
> @@ -798,6 +818,8 @@ int crashing_cpu =3D -1;
>   */
>  void cpu_emergency_disable_virtualization(void)
>  {
> +       cpu_crash_vmclear_loaded_vmcss();
> +
>         cpu_emergency_vmxoff();
>         cpu_emergency_svm_disable();
>  }
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index df461f387e20d..f60fb79fea881 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -41,7 +41,7 @@
>  #include <asm/idtentry.h>
>  #include <asm/io.h>
>  #include <asm/irq_remapping.h>
> -#include <asm/kexec.h>
> +#include <asm/reboot.h>
>  #include <asm/perf_event.h>
>  #include <asm/mmu_context.h>
>  #include <asm/mshyperv.h>
> @@ -754,7 +754,6 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vm=
x,
>         return ret;
>  }
>
> -#ifdef CONFIG_KEXEC_CORE
>  static void crash_vmclear_local_loaded_vmcss(void)
>  {
>         int cpu =3D raw_smp_processor_id();
> @@ -764,7 +763,6 @@ static void crash_vmclear_local_loaded_vmcss(void)
>                             loaded_vmcss_on_cpu_link)
>                 vmcs_clear(v->vmcs);
>  }
> -#endif /* CONFIG_KEXEC_CORE */
>
>  static void __loaded_vmcs_clear(void *arg)
>  {
> @@ -8622,10 +8620,9 @@ static void __vmx_exit(void)
>  {
>         allow_smaller_maxphyaddr =3D false;
>
> -#ifdef CONFIG_KEXEC_CORE
>         RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
>         synchronize_rcu();
> -#endif
> +
>         vmx_cleanup_l1d_flush();
>  }
>
> @@ -8674,10 +8671,9 @@ static int __init vmx_init(void)
>                 pi_init_cpu(cpu);
>         }
>
> -#ifdef CONFIG_KEXEC_CORE
>         rcu_assign_pointer(crash_vmclear_loaded_vmcss,
>                            crash_vmclear_local_loaded_vmcss);
> -#endif
> +
>         vmx_check_vmcs12_offsets();
>
>         /*
> --
> 2.40.1
>

