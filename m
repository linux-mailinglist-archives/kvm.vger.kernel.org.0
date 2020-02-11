Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC156159C78
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgBKWq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:46:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbgBKWqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:46:25 -0500
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C9F424672
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 22:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581461184;
        bh=9zLCa0HTXZYtXrs14B/zXbcAM+4CsAnHeAwUWEaDQbU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tEpjSeql3DYLAsrYSUbprtMEMw4C1h4U9B78zjw3Qwnq3PhruIVJrZW8I5dlgSnI6
         RCIp+Vz9WgnqGblWwxpp3lhHSfdMKx+4t6P4j+em9epOg+/6e+14nf9fPQcXYTnq6P
         +BDN9l79+1oay7W+lPw8cHQ29YuY1J1E6/p9/UXQ=
Received: by mail-wr1-f54.google.com with SMTP id u6so14650279wrt.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 14:46:24 -0800 (PST)
X-Gm-Message-State: APjAAAVYH9+Vc4JGTxf8Yfz6LbroYA+LGMaDQnU6ZdYQGSa0iu+YfeBO
        hbuWP0TpVypEkooF4UP4C34UeaIAIetR5R80jtMjng==
X-Google-Smtp-Source: APXvYqzDG+yy1Y1bMAL59wrUEfua8nCDrkCgCp14PmWU1Fe0rMfRwXKkAP8PvX1rVCDgCCV2/NPugHE40sdjEg/9qFs=
X-Received: by 2002:adf:a354:: with SMTP id d20mr10846226wrb.257.1581461182628;
 Tue, 11 Feb 2020 14:46:22 -0800 (PST)
MIME-Version: 1.0
References: <20200211135256.24617-1-joro@8bytes.org> <20200211135256.24617-36-joro@8bytes.org>
In-Reply-To: <20200211135256.24617-36-joro@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 11 Feb 2020 14:46:11 -0800
X-Gmail-Original-Message-ID: <CALCETrWVYM_EQJYznNzPT0q2yYjUojCHYpHmdYoSCdqApitTrA@mail.gmail.com>
Message-ID: <CALCETrWVYM_EQJYznNzPT0q2yYjUojCHYpHmdYoSCdqApitTrA@mail.gmail.com>
Subject: Re: [PATCH 35/62] x86/sev-es: Setup per-cpu GHCBs for the runtime handler
To:     Joerg Roedel <joro@8bytes.org>
Cc:     X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> From: Tom Lendacky <thomas.lendacky@amd.com>
>
> The runtime handler needs a GHCB per CPU. Set them up and map them
> unencrypted.
>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/mem_encrypt.h |  2 ++
>  arch/x86/kernel/sev-es.c           | 25 ++++++++++++++++++++++++-
>  arch/x86/kernel/traps.c            |  3 +++
>  3 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 6f61bb93366a..d48e7be9bb49 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -48,6 +48,7 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
>  void __init mem_encrypt_init(void);
>  void __init mem_encrypt_free_decrypted_mem(void);
>
> +void __init encrypted_state_init_ghcbs(void);
>  bool sme_active(void);
>  bool sev_active(void);
>  bool sev_es_active(void);
> @@ -71,6 +72,7 @@ static inline void __init sme_early_init(void) { }
>  static inline void __init sme_encrypt_kernel(struct boot_params *bp) { }
>  static inline void __init sme_enable(struct boot_params *bp) { }
>
> +static inline void encrypted_state_init_ghcbs(void) { }
>  static inline bool sme_active(void) { return false; }
>  static inline bool sev_active(void) { return false; }
>  static inline bool sev_es_active(void) { return false; }
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 0e0b28477627..9a5530857db7 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -8,8 +8,11 @@
>   */
>
>  #include <linux/sched/debug.h> /* For show_regs() */
> -#include <linux/kernel.h>
> +#include <linux/percpu-defs.h>
> +#include <linux/mem_encrypt.h>
>  #include <linux/printk.h>
> +#include <linux/set_memory.h>
> +#include <linux/kernel.h>
>  #include <linux/mm.h>
>
>  #include <asm/trap_defs.h>
> @@ -28,6 +31,9 @@ struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
>   */
>  struct ghcb __initdata *boot_ghcb;
>
> +/* Runtime GHCBs */
> +static DEFINE_PER_CPU_DECRYPTED(struct ghcb, ghcb_page) __aligned(PAGE_SIZE);

Hmm.  This is a largeish amount of memory on large non-SEV-ES systems.
Maybe store a pointer instead?  It would be even better if it could be
DEFINE_PER_CPU like this but be discarded if we don't need it, but I
don't think we have the infrastructure for that.

--Andy
