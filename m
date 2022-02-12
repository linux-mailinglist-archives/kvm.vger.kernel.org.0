Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4754C4B36A9
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 18:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbiBLRAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 12:00:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236998AbiBLRAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 12:00:06 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EBF2409F
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 09:00:02 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id r15-20020a4ae5cf000000b002edba1d3349so14206645oov.3
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 09:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NN1zn+ohf44hkJhJ0JsLISv0R/JfpRzNUJNI3cR4508=;
        b=Q8oYCgYyTjm/gE+jSLZMvhfrhjoMfH59eWIAarRWkVGMHK8xcg6eZE/3/SMYpN6a0z
         klgv5YAe5AA5ylNcZelm2tbo89MC9FtNRr3wzDqeiUts6gdtF2OG5xqGbHP/wWMN1Het
         lmZMGMpDm1YmAJBkLhHEGpQIQ3jyZeGiIz8TuVOLADdss226zkjGT9V0qAcudKbUlMl5
         ifGeGubjQRFnZB4lhHMovbv3EQrwo89jQL0JtIzKcHAZGimnHo69gRPgjeNDBReBVIB3
         GrsUoIBxwN+LnOCbmQ7ogoiMKdoVsj2P12axo0Do9aWofJ8U37LqxoxDbJLbuhyB/GCQ
         v1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NN1zn+ohf44hkJhJ0JsLISv0R/JfpRzNUJNI3cR4508=;
        b=oRk6Ew0mayUs9mUZXK9sl/X6dAlK4+s/y5rTryXi2YS64vc3pQlUNoTDlZ4XQC6f4d
         Y+oNDYRCvhgH5RxzOKN5Y+jkjhfi/M0+0vdzc5rZFj4r1V1oKFvU7qFbPCFdOtNXBxTO
         eXHuyXPY52WBFrWGRhRh53iomuF1zroZyVcwfrcePKzb4oDI2Tacp6VczKJ/HqB8K2mN
         I2/kItYxYP6t016CTXNbbQBgIP+Si287ODi12cmIyyaLZ7DilOYhssjYYRPRTR8HCqec
         eSd+ekmC9AitRSMmd7CH2HODvjnOBTvWvB5asxKdw0dGv17k48FLL4k7ps4cJQNfu1fs
         Y7hQ==
X-Gm-Message-State: AOAM533uxQ7oF3uj6i9SqAIEKseavj6tohzSsVO5WBn6BGwfOQJYQBtn
        zgCr+tvtwPSR2iMZQwyHxDemopD0WH1imYv1BTcEeQ==
X-Google-Smtp-Source: ABdhPJyAmWUhTvyjbui4vEFZeyNC1gQszPqa/085+tM9jaJYLnoxDUKYmz2PhMesXoZY+opdOcZ2/FWlJZi/KCAsUgE=
X-Received: by 2002:a05:6870:12d0:: with SMTP id 16mr1698180oam.304.1644685201297;
 Sat, 12 Feb 2022 09:00:01 -0800 (PST)
MIME-Version: 1.0
References: <20220209164420.8894-1-varad.gautam@suse.com> <20220209164420.8894-2-varad.gautam@suse.com>
In-Reply-To: <20220209164420.8894-2-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sat, 12 Feb 2022 08:59:50 -0800
Message-ID: <CAA03e5Ersr5bmOGaKvuE5OATyP=e9kx31LAS1nmtB_03PBr1gA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 01/10] x86: AMD SEV-ES: Setup #VC
 exception handler for AMD SEV-ES
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 9, 2022 at 8:44 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> AMD SEV-ES defines a new guest exception that gets triggered on
> some vmexits to allow the guest to control what state gets shared
> with the host. kvm-unit-tests currently relies on UEFI to provide
> this #VC exception handler. This leads to the following problems:
>
> 1) The test's page table needs to map the firmware and the shared
>    GHCB used by the firmware.
> 2) The firmware needs to keep its #VC handler in the current IDT
>    so that kvm-unit-tests can copy the #VC entry into its own IDT.
> 3) The firmware #VC handler might use state which is not available
>    anymore after ExitBootServices.
> 4) After ExitBootServices, the firmware needs to get the GHCB address
>    from the GHCB MSR if it needs to use the kvm-unit-test GHCB. This
>    requires keeping an identity mapping, and the GHCB address must be
>    in the MSR at all times where a #VC could happen.
>
> Problems 1) and 2) were temporarily mitigated via commits b114aa57ab
> ("x86 AMD SEV-ES: Set up GHCB page") and 706ede1833 ("x86 AMD SEV-ES:
> Copy UEFI #VC IDT entry") respectively.
>
> However, to make kvm-unit-tests reliable against 3) and 4), the tests
> must supply their own #VC handler [1][2].
>
> Switch the tests to install a #VC handler on early bootup, just after
> GHCB has been mapped. The tests will use this handler by default.
> If --amdsev-efi-vc is passed during ./configure, the tests will
> continue using the UEFI #VC handler.
>
> [1] https://lore.kernel.org/all/Yf0GO8EydyQSdZvu@suse.de/
> [2] https://lore.kernel.org/all/YSA%2FsYhGgMU72tn+@google.com/
>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  Makefile             |  3 +++
>  configure            | 21 +++++++++++++++++++++
>  lib/x86/amd_sev.c    | 13 +++++--------
>  lib/x86/amd_sev.h    |  1 +
>  lib/x86/amd_sev_vc.c | 14 ++++++++++++++
>  lib/x86/desc.c       | 15 +++++++++++++++
>  lib/x86/desc.h       |  1 +
>  lib/x86/setup.c      |  8 ++++++++
>  x86/Makefile.common  |  1 +
>  9 files changed, 69 insertions(+), 8 deletions(-)
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
> index 2d9c3e0..148d051 100755
> --- a/configure
> +++ b/configure
> @@ -30,6 +30,12 @@ gen_se_header=
>  page_size=
>  earlycon=
>  target_efi=
> +# For AMD SEV-ES, the tests build to use their own #VC exception handler
> +# by default, instead of using the one installed by UEFI. This ensures
> +# that the tests do not depend on UEFI state after ExitBootServices.
> +# To continue using the UEFI #VC handler, ./configure can be run with
> +# --amdsev-efi-vc.
> +amdsev_efi_vc=
>
>  usage() {
>      cat <<-EOF
> @@ -75,6 +81,8 @@ usage() {
>                                    Specify a PL011 compatible UART at address ADDR. Supported
>                                    register stride is 32 bit only.
>             --target-efi           Boot and run from UEFI
> +           --amdsev-efi-vc        Use UEFI-provided #VC handlers on AMD SEV/ES. Requires
> +                                  --target-efi.
>  EOF
>      exit 1
>  }
> @@ -145,6 +153,9 @@ while [[ "$1" = -* ]]; do
>         --target-efi)
>             target_efi=y
>             ;;
> +       --amdsev-efi-vc)
> +           amdsev_efi_vc=y
> +           ;;
>         --help)
>             usage
>             ;;
> @@ -204,8 +215,17 @@ elif [ "$processor" = "arm" ]; then
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
> @@ -363,6 +383,7 @@ WA_DIVIDE=$wa_divide
>  GENPROTIMG=${GENPROTIMG-genprotimg}
>  HOST_KEY_DOCUMENT=$host_key_document
>  TARGET_EFI=$target_efi
> +AMDSEV_EFI_VC=$amdsev_efi_vc
>  GEN_SE_HEADER=$gen_se_header
>  EOF
>  if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
> diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
> index 6672214..987b59f 100644
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
> @@ -100,14 +101,10 @@ efi_status_t setup_amd_sev_es(void)
>
>         /*
>          * Copy UEFI's #VC IDT entry, so KVM-Unit-Tests can reuse it and does
> -        * not have to re-implement a #VC handler. Also update the #VC IDT code
> -        * segment to use KVM-Unit-Tests segments, KERNEL_CS, so that we do not
> +        * not have to re-implement a #VC handler for #VC exceptions before
> +        * GHCB is mapped. Also update the #VC IDT code segment to use
> +        * KVM-Unit-Tests segments, KERNEL_CS, so that we do not
>          * have to copy the UEFI GDT entries into KVM-Unit-Tests GDT.
> -        *
> -        * TODO: Reusing UEFI #VC handler is a temporary workaround to simplify
> -        * the boot up process, the long-term solution is to implement a #VC
> -        * handler in kvm-unit-tests and load it, so that kvm-unit-tests does
> -        * not depend on specific UEFI #VC handler implementation.
>          */
>         sidt(&idtr);
>         idt = (idt_entry_t *)idtr.base;
> @@ -126,7 +123,7 @@ void setup_ghcb_pte(pgd_t *page_table)
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
> index 9b81da0..6d95ab3 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -224,6 +224,7 @@ void set_intr_alt_stack(int e, void *fn);
>  void print_current_tss_info(void);
>  handler handle_exception(u8 v, handler fn);
>  void unhandled_exception(struct ex_regs *regs, bool cpu);
> +void setup_amd_sev_es_vc(void);
>
>  bool test_for_exception(unsigned int ex, void (*trigger_func)(void *data),
>                         void *data);
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index bbd3468..9de946b 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -327,6 +327,14 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>         smp_init();
>         setup_page_table();
>
> +#ifndef AMDSEV_EFI_VC
> +       /*
> +        * Switch away from the UEFI-installed #VC handler.
> +        * GHCB has already been mapped at this point.
> +        */
> +       setup_amd_sev_es_vc();
> +#endif /* AMDSEV_EFI_VC */
> +
>         return EFI_SUCCESS;
>  }
>
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index ff02d98..ae426aa 100644
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

Reviewed-by: Marc Orr <marcorr@google.com>
