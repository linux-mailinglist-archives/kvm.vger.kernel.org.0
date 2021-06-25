Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE69B3B49E8
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 23:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhFYVFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 17:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbhFYVFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 17:05:31 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A59AC061574
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 14:03:09 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id s19so14090051ioc.3
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 14:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8qszR2cYGCkZ6vw7M2TMt0JVjgMI76NNQQAhFnIUvIE=;
        b=qzQRXnjEMEcmhJOPqTWMBN31iX/XIw1BM8Ks02JFR4RaMTqXvPZ4wnPk6flOI7XtSI
         vWqpVUaQqg0CfvzZdh8dj271RDnycthvc3fHhGHw8HKpAIQiW0aaAnAMHQJOyB9mE+kH
         Ia3cUkgmDfDKn0JenVZta8WDUAJhxiu2VFvM/9HVB3N0azJqf2pJTuT2WIW+vEaXS4QC
         sX3Lzw2uwfMO8NluWq2ibEyjqrAnY2lBkYNIleHEdQvCplIp3UKOjkzO5gdoYaIp18YA
         UYgYdnumHE9oZB/eWpUMXx4oslu075QADhzHmjo7rOHLD0ZkQeaGtRkQtGMjcQkh8bvD
         8RAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8qszR2cYGCkZ6vw7M2TMt0JVjgMI76NNQQAhFnIUvIE=;
        b=CYbhHPb1k7mX6FCKogjGG2rmoGrvDn0rMeYYTscfm5lAqhdld7HMgXeI7hDcwNw7zH
         7NfD+pu6Ong+oOdA2JrPvBtxn5qyBrRZ1j4ZGyzs7bR04rkhWOrFsI51lOxW1QUIPOaN
         yFdarSUJBKPZmqm4uviaAgxq17BhvRZ2AU7EXoVP6SgliUINc95NLe3HJzgLY+aC6bWd
         oN8MKiDbGU7uwO1zoINm7KQfwYAAURimK2OmJhPq/MNgkuIJBNUZ5npebIpiXuE6E5vP
         aH89BClZJqJssvu/ewadNLphjPejoeiDcm2VEb3Yxn9OO0nXUZ4WIGASG/5nCoEE1twv
         P/NA==
X-Gm-Message-State: AOAM532nUHOAqE6BvpiZPvGaxStmOkEG7eO6kJ+ZtbUGUE0SEqv21D51
        KyGL44DeaeuDQ+3vIyfSdgai+MQFV7fJhCnHunegnw==
X-Google-Smtp-Source: ABdhPJzIHok8bMC/9ZDbdeG4Kfiq1t+9f+kpvazkqvIIdBDTu52DD4iUUo7XXQALKqLgkTLMnoV78tqZu97DgUkGEXU=
X-Received: by 2002:a05:6638:3789:: with SMTP id w9mr10927931jal.77.1624654988068;
 Fri, 25 Jun 2021 14:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1623421410.git.ashish.kalra@amd.com> <8c581834c77284d5b9465b3388f07fa100f9fc4e.1623421410.git.ashish.kalra@amd.com>
In-Reply-To: <8c581834c77284d5b9465b3388f07fa100f9fc4e.1623421410.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 25 Jun 2021 14:02:32 -0700
Message-ID: <CABayD+ckOsM4+sab00SggrH3_iFaiV-7h9tHHuL1J-o6_YQVKA@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brijesh.singh@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 7:30 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
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
>      i) if kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL), issue a wrmsrl()
>          to enable the SEV live migration support
>
>    - If EFI,
>
>      i) If kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL), read
>         the UEFI variable which indicates OVMF support for live migration
>
>      ii) the variable indicates live migration is supported, issue a wrmsrl() to
>           enable the SEV live migration support
>
> The EFI live migration check is done using a late_initcall() callback.
>
> Also, ensure that _bss_decrypted section is marked as decrypted in the
> shared pages list.
>
> Also adds kexec support for SEV Live Migration.
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
>  arch/x86/include/asm/mem_encrypt.h |   4 ++
>  arch/x86/kernel/kvm.c              | 107 +++++++++++++++++++++++++++++
>  arch/x86/mm/mem_encrypt.c          |   5 ++
>  3 files changed, 116 insertions(+)
>
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 9c80c68d75b5..8dd373cc8b66 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -43,6 +43,8 @@ void __init sme_enable(struct boot_params *bp);
>
>  int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
>  int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
> +                                           bool enc);
>
>  void __init mem_encrypt_free_decrypted_mem(void);
>
> @@ -83,6 +85,8 @@ static inline int __init
>  early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
>  static inline int __init
>  early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
> +static inline void __init
> +early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
>
>  static inline void mem_encrypt_free_decrypted_mem(void) { }
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a26643dc6bd6..80a81de4c470 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -27,6 +27,7 @@
>  #include <linux/nmi.h>
>  #include <linux/swait.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/efi.h>
>  #include <asm/timer.h>
>  #include <asm/cpu.h>
>  #include <asm/traps.h>
> @@ -40,6 +41,7 @@
>  #include <asm/ptrace.h>
>  #include <asm/reboot.h>
>  #include <asm/svm.h>
> +#include <asm/e820/api.h>
>
>  DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
>
> @@ -433,6 +435,8 @@ static void kvm_guest_cpu_offline(bool shutdown)
>         kvm_disable_steal_time();
>         if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>                 wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> +       if (kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL))
> +               wrmsrl(MSR_KVM_MIGRATION_CONTROL, 0);
>         kvm_pv_disable_apf();
>         if (!shutdown)
>                 apf_task_wake_all();
> @@ -547,6 +551,55 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
>         __send_ipi_mask(local_mask, vector);
>  }
>
> +static int __init setup_efi_kvm_sev_migration(void)
> +{
> +       efi_char16_t efi_sev_live_migration_enabled[] = L"SevLiveMigrationEnabled";
> +       efi_guid_t efi_variable_guid = AMD_SEV_MEM_ENCRYPT_GUID;
> +       efi_status_t status;
> +       unsigned long size;
> +       bool enabled;
> +
> +       if (!sev_active() ||
> +           !kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL))
> +               return 0;
> +
> +       if (!efi_enabled(EFI_BOOT))
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
> +       wrmsrl(MSR_KVM_MIGRATION_CONTROL, KVM_MIGRATION_READY);
> +
> +       return true;
> +}
> +
> +late_initcall(setup_efi_kvm_sev_migration);
> +
>  /*
>   * Set the IPI entry points
>   */
> @@ -805,8 +858,62 @@ static bool __init kvm_msi_ext_dest_id(void)
>         return kvm_para_has_feature(KVM_FEATURE_MSI_EXT_DEST_ID);
>  }
>
> +static void kvm_sev_hc_page_enc_status(unsigned long pfn, int npages, bool enc)
> +{
> +       kvm_hypercall3(KVM_HC_MAP_GPA_RANGE, pfn << PAGE_SHIFT, npages,
> +                      KVM_MAP_GPA_RANGE_ENC_STAT(enc) | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
> +}
> +
>  static void __init kvm_init_platform(void)
>  {
> +       if (sev_active() &&
> +           kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL)) {
> +               unsigned long nr_pages;
> +               int i;
> +
> +               pv_ops.mmu.notify_page_enc_status_changed =
> +                       kvm_sev_hc_page_enc_status;
> +
> +               /*
> +                * Reset the host's shared pages list related to kernel
> +                * specific page encryption status settings before we load a
> +                * new kernel by kexec. Reset the page encryption status
> +                * during early boot intead of just before kexec to avoid SMP
> +                * races during kvm_pv_guest_cpu_reboot().
> +                * NOTE: We cannot reset the complete shared pages list
> +                * here as we need to retain the UEFI/OVMF firmware
> +                * specific settings.
> +                */
> +
> +               for (i = 0; i < e820_table->nr_entries; i++) {
> +                       struct e820_entry *entry = &e820_table->entries[i];
> +
> +                       if (entry->type != E820_TYPE_RAM)
> +                               continue;
> +
> +                       nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
> +
> +                       kvm_hypercall3(KVM_HC_MAP_GPA_RANGE, entry->addr,
> +                                      nr_pages,
> +                                      KVM_MAP_GPA_RANGE_ENCRYPTED | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
> +               }
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
> +                       wrmsrl(MSR_KVM_MIGRATION_CONTROL,
> +                              KVM_MIGRATION_READY);
> +       }
>         kvmclock_init();
>         x86_platform.apic_post_init = kvm_apic_init;
>  }
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 455ac487cb9d..2673a89d17d9 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -409,6 +409,11 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
>         return early_set_memory_enc_dec(vaddr, size, true);
>  }
>
> +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
> +{
> +       notify_range_enc_status_changed(vaddr, npages, enc);
> +}
> +
>  /*
>   * SME and SEV are very similar but they are not the same, so there are
>   * times that the kernel will need to distinguish between SME and SEV. The
> --
> 2.17.1
>

Most of this looks good to me.

The one thing I find hard to understand is the kexec state machine.
Based on my naive reading, this should work fine for "normal" kexecs,
since it should disable migration on shutdown (with one call per
vCPU), and reenable on reboot (with a single call). That said, I don't
really understand how this interacts with the
hibernate-old-kernel/preserve-context mode of kexec (which allows
jumping back into the original kernel). That may "just work" if
reloading memory would also trigger all of the necessary c-bit
hypercalls. If there are concerns that this would not "just work", the
kernel could choose not to reenable migration on return to the
original kernel until someone implements support for this.

Boris, do you have any thoughts on the kexec aspect of this change?

Steve
