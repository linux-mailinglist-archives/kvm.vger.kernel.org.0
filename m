Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93BA3EF5E9
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 00:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbhHQWvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 18:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhHQWvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 18:51:33 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FBFC061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 15:50:59 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id h18so199083ilc.5
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 15:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kJF4ZjAfLVqVGakZdtq7slT5DgNeQPyF9be1SJwj1Hw=;
        b=WO9c2QU3Rm2pxOkmPo3AjUE8xD5dFp5H0PSGK5grzjQmciMODNSL22Zp4RSjoEY94H
         YfcPOe6WNeAWprC+6IYhHnqWMMYcefPncqKab6WFpoYh6SgO5pPaRz24RgIFR0BB7hZd
         hZwXrGGKflEsK54TiEY7x007y5705IjpZ3dVDtKptBdiZDJdqVlj7kl8BdNcEFZXj64a
         ggLzVwkDsJDp83zyN4n2mhpq99SvPffSjD3srWPL57EQRM0eKQIOLZwUhcUudv+BJ4k/
         FyV3hprr5oHGe+X6b7/tWiRrsPSm1hLfRILzP/t1I3+7zx24CaU0IuE7aLyT/7sYMKVZ
         +LGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kJF4ZjAfLVqVGakZdtq7slT5DgNeQPyF9be1SJwj1Hw=;
        b=GAGZKBrZoQQGLwYoddya5p6WKk/knH6N6P+2yZQV3otRi+pzc5qiSvtFWyH8Vyxnda
         OzHTcoESbE89eQzyvvWq2N6FFj3a7gWv8ISx6/qcKKzUim7sqcbCyVzDBZhN0ZJT4op6
         +zT1A1+lUaa/9EqQhoN6dSPDykvlkhU5XrvalC/vhI0gJ0QkrbzwVTNie6Yu+xndLexn
         ZzL0IyLhd2hBSp1l123XdaBur4yUkmOHorl/EjapwPVJEFaXR7HhJ8ZXIXdt0zEK9Aqy
         9wiZBaBdCNzdYu0XMZdrOn6qDWRqevDSPAEoptIZdT+Trw3IK5/YnFPnOh0O7A3bQ8B5
         9SVQ==
X-Gm-Message-State: AOAM531+2Lx0BkoDr9Xxeu2HftP6b6ORES1LJMzQYk7WskSvM47ihBU9
        dx2fs0JaZ8C4D8VxX7wRXoEkbo4b+3s82LgyVgM5Ew==
X-Google-Smtp-Source: ABdhPJyuXoUtjClO2XGjUvJ2jPKvvD6Oev6zK+cSmuR2nXNTv2OiJ8PR9E4e1vYMb2o+/X6JTTnGUfU3qmZ1b3XMejw=
X-Received: by 2002:a92:c808:: with SMTP id v8mr3929501iln.110.1629240658875;
 Tue, 17 Aug 2021 15:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1624978790.git.ashish.kalra@amd.com> <8fce27b8477073b9c7750f7cfc0c68f7ebd3a97d.1624978790.git.ashish.kalra@amd.com>
In-Reply-To: <8fce27b8477073b9c7750f7cfc0c68f7ebd3a97d.1624978790.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Tue, 17 Aug 2021 15:50:22 -0700
Message-ID: <CABayD+fWA2bVe_MhR4SnOo7VH7Qs5kR5n9Jb6s7byqaP+UhXQA@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] x86/kvm: Add kexec support for SEV Live Migration.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org, bp@alien8.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brijesh.singh@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 29, 2021 at 8:14 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
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
>  arch/x86/kernel/kvm.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a014c9bb5066..a55712ee58a1 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -869,10 +869,35 @@ static void __init kvm_init_platform(void)
>         if (sev_active() &&
>             kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL)) {
>                 unsigned long nr_pages;
> +               int i;
>
>                 pv_ops.mmu.notify_page_enc_status_changed =
>                         kvm_sev_hc_page_enc_status;
>
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
>                 /*
>                  * Ensure that _bss_decrypted section is marked as decrypted in the
>                  * shared pages list.
> --
> 2.17.1
>
I believe this entire series has been reviewed. Is there any appetite
to queue these for 915?
They may need to be resent, since I'm not sure there is a single patch
series that contains all the patches.

--Steve
