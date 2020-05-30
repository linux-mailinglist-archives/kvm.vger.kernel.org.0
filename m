Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53CA1E8D16
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 04:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgE3CIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 22:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728835AbgE3CIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 22:08:41 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4B8C03E969
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:08:40 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id 17so4393289ilj.3
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ftdjrlHvaYC20sQ3K9w73i/hjP0UjC8uFxImsgB2/2M=;
        b=MbSXwiYo4Mwlrx0tkQitGLm050rTRjsN7DTIYMfj0/MboEVg2Hpeiz6tdVH+YbY4Y2
         lfG80Fx1hqDOv4LnXw0mnb3TZ5yXeKtH+T2+OF6GbJcR2BJp92tloXOaet3WJoSnf73o
         xUftZ2YFAYJmcjCmkX4Id1Q4jeYOpXbrPhJfSpqpbF/sbSn8EQrNGOQ8oawT1kGE5rsM
         e0n4AZg+jAIQbGaOEfNIrSTOXwLqYphLn6wE6I/JDErJ3RIkO0mvQx0pZUA87LgZy5CQ
         eQ9TmYwgtSW9KgYVgMVhbF/RmYf1xPeyqDf5B1hz3VV34iia6o8YOjLfOl1EHQTRnTha
         Gl8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ftdjrlHvaYC20sQ3K9w73i/hjP0UjC8uFxImsgB2/2M=;
        b=VdH9kK83pLkbBH7iEYNFhCwTtl4T6pPIPbTMmLQKKWN1qDafSdyJaiEdT8AQ49ny9d
         gpYUTdEwTSN2Wan/POhaIWkVSJ6sOdq7N1hc1VgKb5sXWZyOUIRAvT64b8IJLa7z4MOp
         YzQP4TomL3+l9ZmRxg0aRh+9g9Q0mK8jnmLQ2vWvJ69+h89qa1L61B1A/B8P2orTDkzX
         6GczpOHsFV98BkmwSIo7ATBPKOTaym2QBCF7z8ncBd83SyWe9s+TF3ta6SdahhVBykn0
         3kuLJLOvBd25w7U2NOJ2O2LxpSUB29EX5iCvTnHWwYkn4icYHAUCn/V+J+hffkEfxxSz
         rrpQ==
X-Gm-Message-State: AOAM532H/sSy8iSblU91+9rk0Hk1z+IOGPk6RjTsIwDNbmfsz23caSko
        5P0TWwP5a//E+1FxOx29DzkdT/hqdvM9AtzYO6qJDA==
X-Google-Smtp-Source: ABdhPJwrAt4xJo3hDT+wuwe/3per5bNi4NM8c3HEFlDQO4AWFvMckdoJpIdbYR0fozlWHL+KfP7cEbdOvDUOcMwCE/Y=
X-Received: by 2002:a92:914d:: with SMTP id t74mr9813539ild.182.1590804519646;
 Fri, 29 May 2020 19:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <939af9274e47bb106f49b0154fd4222dd23e7f6d.1588711355.git.ashish.kalra@amd.com>
In-Reply-To: <939af9274e47bb106f49b0154fd4222dd23e7f6d.1588711355.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 29 May 2020 19:08:03 -0700
Message-ID: <CABayD+eSCAAfrcgod3OpEJ9puOdcUPDCCwsk=xmoxpk0yXTDxQ@mail.gmail.com>
Subject: Re: [PATCH v8 15/18] KVM: x86: Add guest support for detecting and
 enabling SEV Live Migration feature.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 5, 2020 at 2:20 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> The guest support for detecting and enabling SEV Live migration
> feature uses the following logic :
>
>  - kvm_init_plaform() checks if its booted under the EFI
>
>    - If not EFI,
>
>      i) check for the KVM_FEATURE_CPUID
>
>      ii) if CPUID reports that migration is support then issue wrmsrl
>          to enable the SEV migration support
>
>    - If EFI,
>
>      i) Check the KVM_FEATURE_CPUID.
>
>      ii) If CPUID reports that migration is supported, then reads the UEFI enviroment variable which
>          indicates OVMF support for live migration.
>
>      iii) If variable is set then wrmsr to enable the SEV migration support.
>
> The EFI live migration check is done using a late_initcall() callback.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/mem_encrypt.h | 11 ++++++
>  arch/x86/kernel/kvm.c              | 62 ++++++++++++++++++++++++++++++
>  arch/x86/mm/mem_encrypt.c          | 11 ++++++
>  3 files changed, 84 insertions(+)
>
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 848ce43b9040..d10e92ae5ca1 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -20,6 +20,7 @@
>
>  extern u64 sme_me_mask;
>  extern bool sev_enabled;
> +extern bool sev_live_mig_enabled;
>
>  void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
>                          unsigned long decrypted_kernel_vaddr,
> @@ -42,6 +43,8 @@ void __init sme_enable(struct boot_params *bp);
>
>  int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
>  int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
> +                                           bool enc);
>
>  /* Architecture __weak replacement functions */
>  void __init mem_encrypt_init(void);
> @@ -55,6 +58,7 @@ bool sev_active(void);
>  #else  /* !CONFIG_AMD_MEM_ENCRYPT */
>
>  #define sme_me_mask    0ULL
> +#define sev_live_mig_enabled   false
>
>  static inline void __init sme_early_encrypt(resource_size_t paddr,
>                                             unsigned long size) { }
> @@ -76,6 +80,8 @@ static inline int __init
>  early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
>  static inline int __init
>  early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
> +static inline void __init
> +early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
>
>  #define __bss_decrypted
>
> @@ -102,6 +108,11 @@ static inline u64 sme_get_me_mask(void)
>         return sme_me_mask;
>  }
>
> +static inline bool sev_live_migration_enabled(void)
> +{
> +       return sev_live_mig_enabled;
> +}
> +
>  #endif /* __ASSEMBLY__ */
>
>  #endif /* __X86_MEM_ENCRYPT_H__ */
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6efe0410fb72..4b29815de873 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -24,6 +24,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/nmi.h>
>  #include <linux/swait.h>
> +#include <linux/efi.h>
>  #include <asm/timer.h>
>  #include <asm/cpu.h>
>  #include <asm/traps.h>
> @@ -403,6 +404,53 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
>         early_set_memory_decrypted((unsigned long) ptr, size);
>  }
>
> +#ifdef CONFIG_EFI
> +static bool setup_kvm_sev_migration(void)
> +{
> +       efi_char16_t efi_Sev_Live_Mig_support_name[] = L"SevLiveMigrationEnabled";
> +       efi_guid_t efi_variable_guid = MEM_ENCRYPT_GUID;
> +       efi_status_t status;
> +       unsigned long size;
> +       bool enabled;
> +
> +       if (!sev_live_migration_enabled())
> +               return false;
> +
> +       size = sizeof(enabled);
> +
> +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> +               pr_info("setup_kvm_sev_migration: no efi\n");
> +               return false;
> +       }
> +
> +       /* Get variable contents into buffer */
> +       status = efi.get_variable(efi_Sev_Live_Mig_support_name,
> +                                 &efi_variable_guid, NULL, &size, &enabled);
> +
> +       if (status == EFI_NOT_FOUND) {
> +               pr_info("setup_kvm_sev_migration: variable not found\n");
> +               return false;
> +       }
> +
> +       if (status != EFI_SUCCESS) {
> +               pr_info("setup_kvm_sev_migration: get_variable fail\n");
> +               return false;
> +       }
> +
> +       if (enabled == 0) {
> +               pr_info("setup_kvm_sev_migration: live migration disabled in OVMF\n");
> +               return false;
> +       }
> +
> +       pr_info("setup_kvm_sev_migration: live migration enabled in OVMF\n");
> +       wrmsrl(MSR_KVM_SEV_LIVE_MIG_EN, KVM_SEV_LIVE_MIGRATION_ENABLED);
> +
> +       return true;
> +}
> +
> +late_initcall(setup_kvm_sev_migration);
> +#endif
> +
>  /*
>   * Iterate through all possible CPUs and map the memory region pointed
>   * by apf_reason, steal_time and kvm_apic_eoi as decrypted at once.
> @@ -725,6 +773,20 @@ static void __init kvm_apic_init(void)
>
>  static void __init kvm_init_platform(void)
>  {
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +       if (sev_active() &&
> +           kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
> +               printk(KERN_INFO "KVM enable live migration\n");
> +               sev_live_mig_enabled = true;
> +               /*
> +                * If not booted using EFI, enable Live migration support.
> +                */
> +               if (!efi_enabled(EFI_BOOT))
> +                       wrmsrl(MSR_KVM_SEV_LIVE_MIG_EN,
> +                              KVM_SEV_LIVE_MIGRATION_ENABLED);
> +       } else
> +               printk(KERN_INFO "KVM enable live migration feature unsupported\n");
> +#endif
>         kvmclock_init();
>         x86_platform.apic_post_init = kvm_apic_init;
>  }
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index c9800fa811f6..f54be71bc75f 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -46,6 +46,8 @@ EXPORT_SYMBOL_GPL(sev_enable_key);
>
>  bool sev_enabled __section(.data);
>
> +bool sev_live_mig_enabled __section(.data);
> +
>  /* Buffer used for early in-place encryption by BSP, no locking needed */
>  static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
>
> @@ -204,6 +206,9 @@ static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
>         unsigned long sz = npages << PAGE_SHIFT;
>         unsigned long vaddr_end, vaddr_next;
>
> +       if (!sev_live_migration_enabled())
> +               return;
> +
>         vaddr_end = vaddr + sz;
>
>         for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> @@ -374,6 +379,12 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
>         return early_set_memory_enc_dec(vaddr, size, true);
>  }
>
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
> +                                       bool enc)
> +{
> +       set_memory_enc_dec_hypercall(vaddr, npages, enc);
> +}
> +
>  /*
>   * SME and SEV are very similar but they are not the same, so there are
>   * times that the kernel will need to distinguish between SME and SEV. The
> --
> 2.17.1
>


Reviewed-by: Steve Rutherford <srutherford@google.com>
