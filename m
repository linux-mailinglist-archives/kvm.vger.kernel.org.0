Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF353E0C15
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 03:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237413AbhHEBcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 21:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbhHEBcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 21:32:24 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF0AC0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 18:32:10 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id n19so4826497ioz.0
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 18:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8t/9JoKQ84VqwJveoASuBq/SiF9ShqKfSF5avleoS2Y=;
        b=C3RFGN7uI0MtXGUlkyPzFRzTC7Jzkn64LIwBYM7TWUhOmBbdsUpjtSCMzkohdYtoVT
         iN0+5LFxboXB/T7fqk5b8IgBrBYIVEZXMGY2Ad4Q4kaZdI+ZGQ2QxkI+rkwGnEQ6s7K5
         /L3qGhmGAxscO5B/+LDX9PbWsXhF9XaRPttrghAWkUq8Q6ZyAss+q8Eu/ASKSokft8M2
         oMxe4CGA+y76Az387YSOjUjZQHFJQwE0sPC4XyrzkG+vBmg0/178+fuEBJUkdlxQwJC9
         c+9xby+JIzF1vDElt1CCimQyz/jC9TcSV5iGPeoYe+eVsc7dMoOTOWdAHO5j/riHwxbl
         ty/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8t/9JoKQ84VqwJveoASuBq/SiF9ShqKfSF5avleoS2Y=;
        b=Mes1FsSwBiNaBFlr9UQ5WISoDV1/pQZVy9zNVtI83BCQxY5TD7BtHBU+1VMm2nJrME
         Ov647z4dtQAbEg0h1LjhqCj1wC9QXu+F/Z02pT8XLw26dmZFQDWyx3N4GdDS+dPu+3/g
         f+x6n7Hg/i406loogOG7yCjRkflp1c1ddqL0zTgj5r5oIGZXEunG/xAG1Wb+XVljfFl9
         wydFgoS+19S2cw7JjtvW7iPYjn785hzVLhXT0x2aEQvVieC58IfBZc8OvOxY7DRhfj7W
         b4DlhJaDRGpSJH9JWTlCbMC//VGgrlgejE91D6BcGp+E1oXuO4cjVfIXJq58rrckln1D
         tUpw==
X-Gm-Message-State: AOAM531ZCJ7RwqkgMq41AZrUr5AnRV0Pqp60uB1vmV6DUl94Zx4wKzvj
        m3KW9Zgf0ZkBk0Hhxz4reLWwZeJ5/1Ll9Zs1J8H2Uw==
X-Google-Smtp-Source: ABdhPJzNeGoDTJThBCcssnSIlKytrqrh3D64Eh70SDGoDko9ZUB1isVRapNEbTGJvaYTkuJ7lq07oarOMyLEXuSukyQ=
X-Received: by 2002:a02:5d0a:: with SMTP id w10mr2158883jaa.47.1628127129927;
 Wed, 04 Aug 2021 18:32:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1624978790.git.ashish.kalra@amd.com> <8fce27b8477073b9c7750f7cfc0c68f7ebd3a97d.1624978790.git.ashish.kalra@amd.com>
In-Reply-To: <8fce27b8477073b9c7750f7cfc0c68f7ebd3a97d.1624978790.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 4 Aug 2021 18:31:34 -0700
Message-ID: <CABayD+eiT0VW3=psF0Wrai9WfqkXkLr-GoxSNWvkSCXu1dH8VQ@mail.gmail.com>
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

Re-reading things, I've convinced myself that kexec is fine. I was
previously concerned with KEXEC_PRESERVE_CONTEXT. In particular, since
the guest does not re-call the encryption status hypercalls after it
jumps back, the host will be out of the loop, and continue believing
the guest is in the same state as it was while running the
intermediate kernel. As a result, it would have an inaccurate list of
which pages are shared/private after a kexecing and jumping back.

The bit that I neglected is that the new kernel (just like the
original kernel) will disable live migration before jumping back (if
it enabled live migration at all). And the original kernel will never
re-enable. This is sub-optimal, since a VM that previously supported
migration can reach a state where it will stop supporting live
migration. But that's unavoidable. Kexecing a kernel that does not
support live migration does the same thing.

This looks good to me.

Reviewed-by: Steve Rutherford<srutherford@google.com>
