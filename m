Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A4A35D46B
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 02:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242950AbhDMA0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 20:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239944AbhDMA0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 20:26:12 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1701EC061574
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:25:52 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id p15so1734904iln.3
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Fk0Ydc4INU9kA/4N18lz0yrA/BY4ISNVvPkHSciPKc=;
        b=olZJ1pv0QdJv+590BuKk/LL2viXHzEJcqg5fJUNbV9QyUTmni43OzvrXi0sXUMYoZv
         8/ysODqpF3HNrgjq9PNn3LFJ6VTlUBYPjK58veMURgP7aJObMSU99TNncLEk9DGKoM0h
         +X1JlRH3auare3DJ3yn5W6+P8fY0pAgoAlCrKc49rDEzt9+BFRKaXnHBN0/TIAOQO4p9
         +i7mfxpzNpwKPgszhEb4lAV2HzyVbyHL2pbuZxbOv1RHA7iJDmTT9KpoVVJMXYjWY3b6
         1oC3sMmrlZRNrypEl54hcCh8bKNip37iG9PGKmf2+/2mhzPbL8Rqi2Ck+bGeAAlzWOSE
         /VyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Fk0Ydc4INU9kA/4N18lz0yrA/BY4ISNVvPkHSciPKc=;
        b=XbZxCNDRtXCG08XvfARR5kEERW9LBYOcOZdECoJ1zelBDOKMezbZRcddC8W3qYsaHt
         WbBr/DM5oijcmlRqh8y5xXx4JyYDDfrPiWRCoSEbDg2M+q/9Pd3IBrKFqQgaUI2kiZiB
         vyNvehEt5hTng/4eJJuQdJsPVvfl1bbc7LNqmd4qlw1Obw56IDMZSqVkEgUT+6Ma4Fgw
         bH3OrhwK2+8FlgZiNqzyuU3EGPyrAPJ1M3+WyeUS3J5+BwU4irA92x/gKdd6U95MPjds
         qR01wDw4yIL+fXj78dFpfbQTTbEmH2Usl+nJvlZx5TyLu2F6sUVm5T0pHB3mxZX9RZVV
         Wu4Q==
X-Gm-Message-State: AOAM5316x9ZGs1WY7qhq1mCRc/SAdp1LxHkj3T3mx86pxizKCwuIf7iI
        nVFDsKw4JeX9yeH1ungqTY09+7P3tPdfv70iS5cafQ==
X-Google-Smtp-Source: ABdhPJz69Zh7XeVOdZmmHQQy8riunODUN3VYpHjd7Jh5QEjTfvHyAlWI/Bfp9TvwNN+nJ4Z0AagXRafCrgIctlV2440=
X-Received: by 2002:a05:6e02:1e08:: with SMTP id g8mr25483937ila.176.1618273551211;
 Mon, 12 Apr 2021 17:25:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618254007.git.ashish.kalra@amd.com> <4ca573363fb8fcd970add90fad4b51d43f1c5d84.1618254007.git.ashish.kalra@amd.com>
In-Reply-To: <4ca573363fb8fcd970add90fad4b51d43f1c5d84.1618254007.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 12 Apr 2021 17:25:15 -0700
Message-ID: <CABayD+duig2-H+K4PgoNtvy42PDgZTSDN84nAkF8hA-dUs=awQ@mail.gmail.com>
Subject: Re: [PATCH v12 12/13] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
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
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 12:46 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> The guest support for detecting and enabling SEV Live migration
> feature uses the following logic :
>
>  - kvm_init_plaform() invokes check_kvm_sev_migration() which
>    checks if its booted under the EFI
>
>    - If not EFI,
>
>      i) check for the KVM_FEATURE_CPUID
>
>      ii) if CPUID reports that migration is supported, issue a wrmsrl()
>          to enable the SEV live migration support
>
>    - If EFI,
>
>      i) check for the KVM_FEATURE_CPUID
>
>      ii) If CPUID reports that migration is supported, read the UEFI variable which
>          indicates OVMF support for live migration
>
>      iii) the variable indicates live migration is supported, issue a wrmsrl() to
>           enable the SEV live migration support
>
> The EFI live migration check is done using a late_initcall() callback.
>
> Also, ensure that _bss_decrypted section is marked as decrypted in the
> shared pages list.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/mem_encrypt.h |  8 +++++
>  arch/x86/kernel/kvm.c              | 52 ++++++++++++++++++++++++++++++
>  arch/x86/mm/mem_encrypt.c          | 41 +++++++++++++++++++++++
>  3 files changed, 101 insertions(+)
>
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 31c4df123aa0..19b77f3a62dc 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -21,6 +21,7 @@
>  extern u64 sme_me_mask;
>  extern u64 sev_status;
>  extern bool sev_enabled;
> +extern bool sev_live_migration_enabled;
>
>  void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
>                          unsigned long decrypted_kernel_vaddr,
> @@ -44,8 +45,11 @@ void __init sme_enable(struct boot_params *bp);
>
>  int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
>  int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
> +                                           bool enc);
>
>  void __init mem_encrypt_free_decrypted_mem(void);
> +void __init check_kvm_sev_migration(void);
>
>  /* Architecture __weak replacement functions */
>  void __init mem_encrypt_init(void);
> @@ -60,6 +64,7 @@ bool sev_es_active(void);
>  #else  /* !CONFIG_AMD_MEM_ENCRYPT */
>
>  #define sme_me_mask    0ULL
> +#define sev_live_migration_enabled     false
>
>  static inline void __init sme_early_encrypt(resource_size_t paddr,
>                                             unsigned long size) { }
> @@ -84,8 +89,11 @@ static inline int __init
>  early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
>  static inline int __init
>  early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
> +static inline void __init
> +early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
>
>  static inline void mem_encrypt_free_decrypted_mem(void) { }
> +static inline void check_kvm_sev_migration(void) { }
>
>  #define __bss_decrypted
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 78bb0fae3982..bcc82e0c9779 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -26,6 +26,7 @@
>  #include <linux/kprobes.h>
>  #include <linux/nmi.h>
>  #include <linux/swait.h>
> +#include <linux/efi.h>
>  #include <asm/timer.h>
>  #include <asm/cpu.h>
>  #include <asm/traps.h>
> @@ -429,6 +430,56 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
>         early_set_memory_decrypted((unsigned long) ptr, size);
>  }
>
> +static int __init setup_kvm_sev_migration(void)
> +{
> +       efi_char16_t efi_sev_live_migration_enabled[] = L"SevLiveMigrationEnabled";
> +       efi_guid_t efi_variable_guid = MEM_ENCRYPT_GUID;
> +       efi_status_t status;
> +       unsigned long size;
> +       bool enabled;
> +
> +       /*
> +        * check_kvm_sev_migration() invoked via kvm_init_platform() before
> +        * this callback would have setup the indicator that live migration
> +        * feature is supported/enabled.
> +        */
> +       if (!sev_live_migration_enabled)
> +               return 0;
> +
> +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> +               pr_info("%s : EFI runtime services are not enabled\n", __func__);
> +               return 0;
> +       }
> +
> +       size = sizeof(enabled);
> +
> +       /* Get variable contents into buffer */
> +       status = efi.get_variable(efi_sev_live_migration_enabled,
> +                                 &efi_variable_guid, NULL, &size, &enabled);
> +
> +       if (status == EFI_NOT_FOUND) {
> +               pr_info("%s : EFI live migration variable not found\n", __func__);
> +               return 0;
> +       }
> +
> +       if (status != EFI_SUCCESS) {
> +               pr_info("%s : EFI variable retrieval failed\n", __func__);
> +               return 0;
> +       }
> +
> +       if (enabled == 0) {
> +               pr_info("%s: live migration disabled in EFI\n", __func__);
> +               return 0;
> +       }
> +
> +       pr_info("%s : live migration enabled in EFI\n", __func__);
> +       wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION, KVM_SEV_LIVE_MIGRATION_ENABLED);
> +
> +       return true;
> +}
> +
> +late_initcall(setup_kvm_sev_migration);
> +
>  /*
>   * Iterate through all possible CPUs and map the memory region pointed
>   * by apf_reason, steal_time and kvm_apic_eoi as decrypted at once.
> @@ -747,6 +798,7 @@ static bool __init kvm_msi_ext_dest_id(void)
>
>  static void __init kvm_init_platform(void)
>  {
> +       check_kvm_sev_migration();
>         kvmclock_init();
>         x86_platform.apic_post_init = kvm_apic_init;
>  }
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index fae9ccbd0da7..4de417333c09 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -20,6 +20,7 @@
>  #include <linux/bitops.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/kvm_para.h>
> +#include <linux/efi.h>
>
>  #include <asm/tlbflush.h>
>  #include <asm/fixmap.h>
> @@ -48,6 +49,8 @@ EXPORT_SYMBOL_GPL(sev_enable_key);
>
>  bool sev_enabled __section(".data");
>
> +bool sev_live_migration_enabled __section(".data");
> +
>  /* Buffer used for early in-place encryption by BSP, no locking needed */
>  static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
>
> @@ -237,6 +240,9 @@ static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
>         unsigned long sz = npages << PAGE_SHIFT;
>         unsigned long vaddr_end, vaddr_next;
>
> +       if (!sev_live_migration_enabled)
> +               return;
> +
>         vaddr_end = vaddr + sz;
>
>         for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> @@ -407,6 +413,12 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
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
> @@ -462,6 +474,35 @@ bool force_dma_unencrypted(struct device *dev)
>         return false;
>  }
>
> +void __init check_kvm_sev_migration(void)
> +{
> +       if (sev_active() &&
> +           kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
> +               unsigned long nr_pages;
> +
> +               pr_info("KVM enable live migration\n");
> +               sev_live_migration_enabled = true;
> +
> +               /*
> +                * Ensure that _bss_decrypted section is marked as decrypted in the
> +                * shared pages list.
> +                */
> +               nr_pages = DIV_ROUND_UP(__end_bss_decrypted - __start_bss_decrypted,
> +                                       PAGE_SIZE);
> +               early_set_mem_enc_dec_hypercall((unsigned long)__start_bss_decrypted,
> +                                               nr_pages, 0);
> +
> +               /*
> +                * If not booted using EFI, enable Live migration support.
> +                */
> +               if (!efi_enabled(EFI_BOOT))
> +                       wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION,
> +                              KVM_SEV_LIVE_MIGRATION_ENABLED);
> +               } else {
> +                       pr_info("KVM enable live migration feature unsupported\n");
I might be misunderstanding this, but I'm not sure this log message is
correct: isn't the intention that the late initcall will be the one to
check if this should be enabled later in this case?

I have a similar question above about the log message after
"!efi_enabled(EFI_RUNTIME_SERVICES)": shouldn't that avoid logging if
!efi_enabled(EFI_BOOT) (since the wrmsl call already had been made
here?)
> +               }
> +}
> +
>  void __init mem_encrypt_free_decrypted_mem(void)
>  {
>         unsigned long vaddr, vaddr_end, npages;
> --
> 2.17.1
>

Other than these:
Reviewed-by: Steve Rutherford <srutherford@google.com>
