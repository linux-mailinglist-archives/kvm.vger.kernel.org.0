Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957254A3906
	for <lists+kvm@lfdr.de>; Sun, 30 Jan 2022 21:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356151AbiA3UhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jan 2022 15:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356140AbiA3UhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jan 2022 15:37:00 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DEFC061714
        for <kvm@vger.kernel.org>; Sun, 30 Jan 2022 12:37:00 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id o188-20020a4a44c5000000b002e6c0c05892so1045562ooa.13
        for <kvm@vger.kernel.org>; Sun, 30 Jan 2022 12:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QhjxwC6MSB9HNT8l4bVgs3KJKpgJgBLFSPUFaV078lo=;
        b=UZQwRP/eCMIqhwjMELB1DKoqP+dLDA9VsNvaCDRRlszbnx79ejHnrnmPKlygwBQi35
         aJkhZdKi0yiPS9UEcWhsnfUHbU7m0ogl52uRHf9DHQuWN8T+x1MApXfci5u5Eg24Y6xj
         a8eRaMWEzM9EEWqn8QKWMjfoOsrW/Fda7tV8DJvCIC4FP6ocdQlZqrZtfchkNnNlE6g8
         5H97YlRQIguWpXIqlXrtzWNcHIo2e9n9gVJEy0T0xJlwlXsUhf5b6nLidURmYVvj7zAz
         Dl/KcmyuLIogobdnEfxsYjB1meyzFhU8xKL2Ib+sVdK1LbxCz2THmUYSWKc9EbCuzJjO
         EpFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QhjxwC6MSB9HNT8l4bVgs3KJKpgJgBLFSPUFaV078lo=;
        b=mrEROJ27NU2+pDVfyxnwS9tgwG80GIEFPlAoImjHgFMtT1ATZajTCWbLquoy6q33nS
         egj1Bz1HvitCIdG62nKMPmKSGVBCnXl8fEY4UoanXbG2hsti0bKU8Q/OcaxO7j49z5fG
         YyaNLU0T5CYGi6FJ6CjkYLBsYvU1JYNebJFxl31FUU6mhHHQfsdM11CKvqxCiRsLiBBr
         +dHWlIVOlt4XMpTpi1aEX3s4ba4TPDJWbdHv5UVNIgh9igEZMmpFZjEc/jNyfpPv86DY
         qTdxk1zY9korLbE4YreMue/yT7wYqnNBO3m6htj0wBXA/9t2nZcgmkvrDzVFef/wnm4Q
         Zn2g==
X-Gm-Message-State: AOAM531PB8PIJ4nPi5YckfzzpfuPV4y4H8sMjrP6qbeCE+hx61IeJfsM
        Ju4ZGCTcNYREUkMOCCL3svhbn2QJaYDNVWg/2YuwMQ==
X-Google-Smtp-Source: ABdhPJytIY1RiV8a1higxZdGeMG0F+3qxftdXFsuS7MzDiu93hO7mqLTD96yBLOZ26jI+UWJQTD41g/VHJHfpc0vKAg=
X-Received: by 2002:a4a:1782:: with SMTP id 124mr8760134ooe.20.1643575019757;
 Sun, 30 Jan 2022 12:36:59 -0800 (PST)
MIME-Version: 1.0
References: <20220120125122.4633-1-varad.gautam@suse.com> <20220120125122.4633-3-varad.gautam@suse.com>
In-Reply-To: <20220120125122.4633-3-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sun, 30 Jan 2022 12:36:48 -0800
Message-ID: <CAA03e5FbSoRo9tXwJocBtZHEc7xisJ3gEFuOW0FPvchbL9X8PQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests 02/13] x86: AMD SEV-ES: Setup #VC exception
 handler for AMD SEV-ES
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 20, 2022 at 4:52 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> AMD SEV-ES defines a new guest exception that gets triggered on
> some vmexits to allow the guest to control what state gets shared
> with the host. kvm-unit-tests currently relies on UEFI to provide
> this #VC exception handler.
>
> Switch the tests to install their own #VC handler on early bootup
> to process these exits, just after GHCB has been mapped.
>
> If --amdsev-efi-vc is passed during ./configure, the tests will
> continue using the UEFI #VC handler.
>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  Makefile             |  3 +++
>  configure            | 16 ++++++++++++++++
>  lib/x86/amd_sev.c    |  3 ++-
>  lib/x86/amd_sev.h    |  1 +
>  lib/x86/amd_sev_vc.c | 14 ++++++++++++++
>  lib/x86/desc.c       | 15 +++++++++++++++
>  lib/x86/desc.h       |  1 +
>  lib/x86/setup.c      | 10 ++++++++++
>  x86/Makefile.common  |  1 +
>  9 files changed, 63 insertions(+), 1 deletion(-)
>  create mode 100644 lib/x86/amd_sev_vc.c
>
> diff --git a/Makefile b/Makefile
> index 4f4ad23..94a0162 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -46,6 +46,9 @@ else
>  $(error Cannot build $(ARCH_NAME) tests as EFI apps)
>  endif
>  EFI_CFLAGS := -DTARGET_EFI
> +ifeq ($(AMDSEV_EFI_VC),y)
> +EFI_CFLAGS += -DAMDSEV_EFI_VC
> +endif
>  # The following CFLAGS and LDFLAGS come from:
>  #   - GNU-EFI/Makefile.defaults
>  #   - GNU-EFI/apps/Makefile
> diff --git a/configure b/configure
> index 41372ef..c687d9f 100755
> --- a/configure
> +++ b/configure
> @@ -29,6 +29,7 @@ host_key_document=
>  page_size=
>  earlycon=
>  target_efi=
> +amdsev_efi_vc=
>
>  usage() {
>      cat <<-EOF
> @@ -71,6 +72,8 @@ usage() {
>                                    Specify a PL011 compatible UART at address ADDR. Supported
>                                    register stride is 32 bit only.
>             --target-efi           Boot and run from UEFI
> +           --amdsev-efi-vc        Use UEFI-provided #VC handlers on AMD SEV/ES. Requires
> +                                  --target-efi.

What's the rationale to make the built-in #VC handler default? Note:
I'm not actually saying I have an opinion, one way or the other. But I
think the commit description (and cover letter) should explain why we
prefer what we're doing.

>  EOF
>      exit 1
>  }
> @@ -138,6 +141,9 @@ while [[ "$1" = -* ]]; do
>         --target-efi)
>             target_efi=y
>             ;;
> +       --amdsev-efi-vc)
> +           amdsev_efi_vc=y
> +           ;;
>         --help)
>             usage
>             ;;
> @@ -197,8 +203,17 @@ elif [ "$processor" = "arm" ]; then
>      processor="cortex-a15"
>  fi
>
> +if [ "$amdsev_efi_vc" ] && [ "$arch" != "x86_64" ]; then
> +    echo "--amdsev-efi-vc requires arch x86_64."
> +    usage
> +fi
> +
>  if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
>      testdir=x86
> +    if [ "$amdsev_efi_vc" ] && [ -z "$target_efi" ]; then
> +        echo "--amdsev-efi-vc requires --target-efi."
> +        usage
> +    fi
>  elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>      testdir=arm
>      if [ "$target" = "qemu" ]; then
> @@ -356,6 +371,7 @@ WA_DIVIDE=$wa_divide
>  GENPROTIMG=${GENPROTIMG-genprotimg}
>  HOST_KEY_DOCUMENT=$host_key_document
>  TARGET_EFI=$target_efi
> +AMDSEV_EFI_VC=$amdsev_efi_vc
>  EOF
>  if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>      echo "TARGET=$target" >> config.mak
> diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
> index 6672214..bde126b 100644
> --- a/lib/x86/amd_sev.c
> +++ b/lib/x86/amd_sev.c
> @@ -14,6 +14,7 @@
>  #include "x86/vm.h"
>
>  static unsigned short amd_sev_c_bit_pos;
> +phys_addr_t ghcb_addr;
>
>  bool amd_sev_enabled(void)
>  {
> @@ -126,7 +127,7 @@ void setup_ghcb_pte(pgd_t *page_table)
>          * function searches GHCB's L1 pte, creates corresponding L1 ptes if not
>          * found, and unsets the c-bit of GHCB's L1 pte.
>          */
> -       phys_addr_t ghcb_addr, ghcb_base_addr;
> +       phys_addr_t ghcb_base_addr;
>         pteval_t *pte;
>
>         /* Read the current GHCB page addr */
> diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
> index 6a10f84..afbacf3 100644
> --- a/lib/x86/amd_sev.h
> +++ b/lib/x86/amd_sev.h
> @@ -54,6 +54,7 @@ efi_status_t setup_amd_sev(void);
>  bool amd_sev_es_enabled(void);
>  efi_status_t setup_amd_sev_es(void);
>  void setup_ghcb_pte(pgd_t *page_table);
> +void handle_sev_es_vc(struct ex_regs *regs);
>
>  unsigned long long get_amd_sev_c_bit_mask(void);
>  unsigned long long get_amd_sev_addr_upperbound(void);
> diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
> new file mode 100644
> index 0000000..8226121
> --- /dev/null
> +++ b/lib/x86/amd_sev_vc.c
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include "amd_sev.h"
> +
> +extern phys_addr_t ghcb_addr;
> +
> +void handle_sev_es_vc(struct ex_regs *regs)
> +{
> +       struct ghcb *ghcb = (struct ghcb *) ghcb_addr;
> +       if (!ghcb) {
> +               /* TODO: kill guest */
> +               return;
> +       }
> +}
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index 16b7256..73aa866 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -3,6 +3,9 @@
>  #include "processor.h"
>  #include <setjmp.h>
>  #include "apic-defs.h"
> +#ifdef TARGET_EFI
> +#include "amd_sev.h"
> +#endif
>
>  /* Boot-related data structures */
>
> @@ -228,6 +231,9 @@ EX_E(ac, 17);
>  EX(mc, 18);
>  EX(xm, 19);
>  EX_E(cp, 21);
> +#ifdef TARGET_EFI
> +EX_E(vc, 29);
> +#endif
>
>  asm (".pushsection .text \n\t"
>       "__handle_exception: \n\t"
> @@ -293,6 +299,15 @@ void setup_idt(void)
>      handle_exception(13, check_exception_table);
>  }
>
> +void setup_amd_sev_es_vc(void)
> +{
> +       if (!amd_sev_es_enabled())
> +               return;
> +
> +       set_idt_entry(29, &vc_fault, 0);
> +       handle_exception(29, handle_sev_es_vc);
> +}
> +
>  unsigned exception_vector(void)
>  {
>      unsigned char vector;
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index b65539e..4fcbf9f 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -220,6 +220,7 @@ void set_intr_alt_stack(int e, void *fn);
>  void print_current_tss_info(void);
>  handler handle_exception(u8 v, handler fn);
>  void unhandled_exception(struct ex_regs *regs, bool cpu);
> +void setup_amd_sev_es_vc(void);
>
>  bool test_for_exception(unsigned int ex, void (*trigger_func)(void *data),
>                         void *data);
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index bbd3468..6013602 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -327,6 +327,16 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>         smp_init();
>         setup_page_table();
>
> +#ifndef AMDSEV_EFI_VC
> +       if (amd_sev_es_enabled()) {

This is a tautology. `setup_amd_sev_es_vc()` returns immediately upon
`!amd_sev_es_enabled()`. Therefore, I think we should remove the check
here.

> +               /*
> +                * Switch away from the UEFI-installed #VC handler.
> +                * GHCB has already been mapped at this point.
> +                */
> +               setup_amd_sev_es_vc();
> +       }
> +#endif /* AMDSEV_EFI_VC */
> +
>         return EFI_SUCCESS;
>  }
>
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 984444e..65d16e7 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -24,6 +24,7 @@ cflatobjs += lib/x86/fault_test.o
>  cflatobjs += lib/x86/delay.o
>  ifeq ($(TARGET_EFI),y)
>  cflatobjs += lib/x86/amd_sev.o
> +cflatobjs += lib/x86/amd_sev_vc.o
>  cflatobjs += lib/efi.o
>  cflatobjs += x86/efi/reloc_x86_64.o
>  endif
> --
> 2.32.0
>

Thank you for adding this patch to the series!

I left a comment above asking about the default #VC handler, above.
And I'd like to expand on that question with my thoughts here.

As far as I understand, mostly from offline conversations with Sean, a
big motivation for the built-in #VC handler is that in the (very) long
term, people will build a guest firmware without a #VC handler. In
other words, eventually (I assume this is many years down the road),
the guest firmware will be enlightened enough to avoid NAEs
altogether, and instead explicitly call VMGEXIT explicitly, rather
than implicitly after triggering a #VC exception. To me, this all
sounds very far (e.g., 5-10 years) out. And thus, I still question the
value in adding the built-in #VC handler with this as the
justification now. However, it's clear from prior discussions that
this is the direction preferred by the community. So I'm not pushing
back. I'm just making sure we're all on the same page here. Please let
me know if I'm mis-understanding this rationale or missing any reasons
for why folks want a built-in #VC handler. And again, I think the
cover letter should be updated with all the reasons why we're doing
what we're doing.

Where I think this work could be useful in the shorter term is
testing. We have three pieces of code to test:
1. Host-side VMGEXIT handler.
2. Guest-side firmware #VC handler.
3. Guest-side kernel #VC handler.

Technically, I guess there are multiple #VC handlers within each
guest-side component, depending on the boot stage. But let's consider
the steady state handlers that operate after initial guest-side boot
stages for now.

Using the UEFI's builtin #VC handler tests:
- Guest-side firmware #VC handler + host-side VMGEXIT handler.

Notably, it does _not_ test the guest-side kernel #VC handler. Looking
ahead in the series, I can see that the code for the new builtin
kvm-unit-tests #VC handler is basically copied from the Linux kernel
#VC handler. Therefore, we could use this work to test:
- Guest-side kernel #VC handler + host-side VMGEXIT handler.

The difficulty with using this approach to test the guest-side #VC
handler is that we now have two copies of the code that can get out of
sync: one in the kernel and a 2nd in kvm-unit-tests. However, maybe
this is OK. And maybe we can even try to ameliorate this issue with
some scripts to compare the two codes or some policy that when we
update the Linux kernel proper we send a follow-up patch to
kvm-unit-tests.

Another approach to test the guest-side kernel #VC handler would be to
add tests to run from within a Linux guest. E.g., maybe Linux
selftests could work here. We actually have something like this
internally, But the way it was written would make it non-trivial to
upstream.

Thoughts?

Tested-by: Marc Orr <marcorr@google.com>
