Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916E6262A41
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 10:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgIII2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 04:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgIII2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 04:28:07 -0400
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19D2221D92;
        Wed,  9 Sep 2020 08:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599640086;
        bh=oSkqx7fBtktZCSjvlDsbeuVWELoU2VwL0f24i8mxIJ4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TaYXqS7yjX1QZf+Jjwi2LNDwgsgsAbbs5GZYGxrqbMpiTFL7pucnnEHNf4T0QfhiC
         twq861jBz+X1OiMeOSg5DY8ZLRYclPN0z76igP4Ng5NNKhrk78sR68+x6CNdWddV/a
         QqBwXofMe6sOgkJIVB/Eli6qmKvcSOQfdDnP1lMs=
Received: by mail-ot1-f46.google.com with SMTP id y5so1605889otg.5;
        Wed, 09 Sep 2020 01:28:06 -0700 (PDT)
X-Gm-Message-State: AOAM531wlP66cGCA99kwHsMerhArs54do9zkGuSdGbB1/SSHHhlyk7pj
        8hSt90uS83P0gR2LSckg+2znlXM0Jz5mOXnmq9s=
X-Google-Smtp-Source: ABdhPJzuRvkfw2UsrXnDtOomSzQk4+ouGefn8y3WUKW/5qfhfluPTn6CzSpJ7LO1VqxCc/nePgDDCAfAxZzTI7YLOX8=
X-Received: by 2002:a9d:69c9:: with SMTP id v9mr2077418oto.90.1599640085272;
 Wed, 09 Sep 2020 01:28:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200907131613.12703-1-joro@8bytes.org> <20200907131613.12703-72-joro@8bytes.org>
 <20200908174616.GJ25236@zn.tnic>
In-Reply-To: <20200908174616.GJ25236@zn.tnic>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 9 Sep 2020 11:27:54 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHbePrDYXGbVG0fHfH5=M19ZpCLm9YVTs-yKTuR_jFLDg@mail.gmail.com>
Message-ID: <CAMj1kXHbePrDYXGbVG0fHfH5=M19ZpCLm9YVTs-yKTuR_jFLDg@mail.gmail.com>
Subject: Re: [PATCH v7 71/72] x86/efi: Add GHCB mappings when SEV-ES is active
To:     Borislav Petkov <bp@alien8.de>, Laszlo Ersek <lersek@redhat.com>,
        brijesh.singh@amd.com
Cc:     Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(adding Laszlo and Brijesh)

On Tue, 8 Sep 2020 at 20:46, Borislav Petkov <bp@alien8.de> wrote:
>
> + Ard so that he can ack the efi bits.
>
> On Mon, Sep 07, 2020 at 03:16:12PM +0200, Joerg Roedel wrote:
> > From: Tom Lendacky <thomas.lendacky@amd.com>
> >
> > Calling down to EFI runtime services can result in the firmware performing
> > VMGEXIT calls. The firmware is likely to use the GHCB of the OS (e.g., for
> > setting EFI variables), so each GHCB in the system needs to be identity
> > mapped in the EFI page tables, as unencrypted, to avoid page faults.
> >
> > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> > [ jroedel@suse.de: Moved GHCB mapping loop to sev-es.c ]
> > Signed-off-by: Joerg Roedel <jroedel@suse.de>


This looks like it is papering over a more fundamental issue: any
memory region that the firmware itself needs to access during the
execution of runtime services needs to be described in the UEFI memory
map, with the appropriate annotations so that the OS knows it should
include these in the EFI runtime page tables. So why has this been
omitted in this case?



> > ---
> >  arch/x86/boot/compressed/sev-es.c |  1 +
> >  arch/x86/include/asm/sev-es.h     |  2 ++
> >  arch/x86/kernel/sev-es.c          | 30 ++++++++++++++++++++++++++++++
> >  arch/x86/platform/efi/efi_64.c    | 10 ++++++++++
> >  4 files changed, 43 insertions(+)
> >
> > diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
> > index 45702b866c33..0a9a248ca33d 100644
> > --- a/arch/x86/boot/compressed/sev-es.c
> > +++ b/arch/x86/boot/compressed/sev-es.c
> > @@ -12,6 +12,7 @@
> >   */
> >  #include "misc.h"
> >
> > +#include <asm/pgtable_types.h>
> >  #include <asm/sev-es.h>
> >  #include <asm/trapnr.h>
> >  #include <asm/trap_pf.h>
> > diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
> > index e919f09ae33c..cf1d957c7091 100644
> > --- a/arch/x86/include/asm/sev-es.h
> > +++ b/arch/x86/include/asm/sev-es.h
> > @@ -102,11 +102,13 @@ static __always_inline void sev_es_nmi_complete(void)
> >       if (static_branch_unlikely(&sev_es_enable_key))
> >               __sev_es_nmi_complete();
> >  }
> > +extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
> >  #else
> >  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
> >  static inline void sev_es_ist_exit(void) { }
> >  static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
> >  static inline void sev_es_nmi_complete(void) { }
> > +static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
> >  #endif
> >
> >  #endif
> > diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> > index 9ab3a4dfecd8..4e2b7e4d9b87 100644
> > --- a/arch/x86/kernel/sev-es.c
> > +++ b/arch/x86/kernel/sev-es.c
> > @@ -491,6 +491,36 @@ int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
> >       return 0;
> >  }
> >
> > +/*
> > + * This is needed by the OVMF UEFI firmware which will use whatever it finds in
> > + * the GHCB MSR as its GHCB to talk to the hypervisor. So make sure the per-cpu
> > + * runtime GHCBs used by the kernel are also mapped in the EFI page-table.
> > + */
> > +int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
> > +{
> > +     struct sev_es_runtime_data *data;
> > +     unsigned long address, pflags;
> > +     int cpu;
> > +     u64 pfn;
> > +
> > +     if (!sev_es_active())
> > +             return 0;
> > +
> > +     pflags = _PAGE_NX | _PAGE_RW;
> > +
> > +     for_each_possible_cpu(cpu) {
> > +             data = per_cpu(runtime_data, cpu);
> > +
> > +             address = __pa(&data->ghcb_page);
> > +             pfn = address >> PAGE_SHIFT;
> > +
> > +             if (kernel_map_pages_in_pgd(pgd, pfn, address, 1, pflags))
> > +                     return 1;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
> >  {
> >       struct pt_regs *regs = ctxt->regs;
> > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > index 6af4da1149ba..8f5759df7776 100644
> > --- a/arch/x86/platform/efi/efi_64.c
> > +++ b/arch/x86/platform/efi/efi_64.c
> > @@ -47,6 +47,7 @@
> >  #include <asm/realmode.h>
> >  #include <asm/time.h>
> >  #include <asm/pgalloc.h>
> > +#include <asm/sev-es.h>
> >
> >  /*
> >   * We allocate runtime services regions top-down, starting from -4G, i.e.
> > @@ -229,6 +230,15 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
> >               return 1;
> >       }
> >
> > +     /*
> > +      * When SEV-ES is active, the GHCB as set by the kernel will be used
> > +      * by firmware. Create a 1:1 unencrypted mapping for each GHCB.
> > +      */
> > +     if (sev_es_efi_map_ghcbs(pgd)) {
> > +             pr_err("Failed to create 1:1 mapping for the GHCBs!\n");
> > +             return 1;
> > +     }
> > +
> >       /*
> >        * When making calls to the firmware everything needs to be 1:1
> >        * mapped and addressable with 32-bit pointers. Map the kernel
> > --
> > 2.28.0
> >
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
