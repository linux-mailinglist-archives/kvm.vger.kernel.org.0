Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DE46D1941
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 10:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjCaIDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 04:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjCaIDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 04:03:38 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8D21024E;
        Fri, 31 Mar 2023 01:03:37 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso22559306pjb.3;
        Fri, 31 Mar 2023 01:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680249816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2YYDqaXEe+OlABx7nR00XL22NbKcMoWA4HV8o8wFw4=;
        b=jd4QUO4qQCCNMeP1y1kdFNasUVZNXLbfLZh3Ef7q2XkFJDggudlgm1SvUp3KwtL6mg
         rff482SM+B2v52u0U0heU18u3X2B+YPqj15IG4EgxmfC0rdEt8z37NxWic2kbBzYkS+7
         qBin4exH+KLnro6Fxt+orrT1TNi4uWcn7QtMOS4wI5qdAg5hn6WkaRlW62Vf1mKcWAB2
         1YI5ZDox5dvQ+EmxzNNcc6WCw3CqirZd8IrgdMTkvmLFzvPSgQoJbEm/HhExrJxGHw20
         PwuZvTtwERtCFkdYWE3ZhRlgnihB7JVCZjx/PJYavY0KBMekYHqcLORWIl6oISQGw3wm
         z2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680249816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X2YYDqaXEe+OlABx7nR00XL22NbKcMoWA4HV8o8wFw4=;
        b=atEw4uip5yjeh8D3AFyWV7c03eWU0D0fjwfrnxJW8+NYnp4yxrVVYT1k0D4JAlVaQ6
         0z9tpv4vVcEmbSCXI4qO87DKJ+FGl7/zofjkFC0st5hYgsqLDtZgNnKrjam9BMu/vIgX
         gZaHJszoDTQa0nKYGuA0PYJcXbY6oUuuKCYEqEsv3/AaKye8skYLXlUmFcnkks29BSzc
         jaT/5XZAv2NYwpGDZPRMHOlHnteimNIvAEZfmnGUcrS6YiqQ0gtonSJBD3q3NaMStC7Y
         k+5ke3LesIhWlAQXaDlNJU2LA3FaDDF+bEyiNMnkfq32rY+q0Yn/LPAb5A50PI4VTVDR
         SnoQ==
X-Gm-Message-State: AAQBX9cs2mltxJo6qMdfawh/8/ugE2Gct6qvsFDjojAsubGFPwdRtUIk
        1ZSubcXfqmOwcHm0D6z9XQJmmUEHvtdJfk0COcg=
X-Google-Smtp-Source: AKy350bagh6xUTSk+gvpPAa/yBG4/ITbe87XXMZ7yUIaLH9rNwAaG8B08G54xTGRY+lSZg9nJWrLengD7VdxDHcqS+U=
X-Received: by 2002:a17:902:8bc4:b0:19f:1d62:4393 with SMTP id
 r4-20020a1709028bc400b0019f1d624393mr8775321plo.7.1680249816556; Fri, 31 Mar
 2023 01:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230327075838.5403-1-xin3.li@intel.com> <20230327075838.5403-28-xin3.li@intel.com>
In-Reply-To: <20230327075838.5403-28-xin3.li@intel.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 31 Mar 2023 16:03:24 +0800
Message-ID: <CAJhGHyDQSHkfxVS1o+rqA4JaaOpvyVH0C5JNLKdDuzNtncQiTw@mail.gmail.com>
Subject: Re: [PATCH v6 27/33] x86/fred: fixup fault on ERETU by jumping to fred_entrypoint_user
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, shan.kang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 4:24=E2=80=AFPM Xin Li <xin3.li@intel.com> wrote:
>
> If the stack frame contains an invalid user context (e.g. due to invalid =
SS,
> a non-canonical RIP, etc.) the ERETU instruction will trap (#SS or #GP).
>
> From a Linux point of view, this really should be considered a user space
> failure, so use the standard fault fixup mechanism to intercept the fault=
,
> fix up the exception frame, and redirect execution to fred_entrypoint_use=
r.
> The end result is that it appears just as if the hardware had taken the
> exception immediately after completing the transition to user space.
>
> Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>
> Changes since v5:
> * Move the NMI bit from an invalid stack frame, which caused ERETU to fau=
lt,
>   to the fault handler's stack frame, thus to unblock NMI ASAP if NMI is =
blocked
>   (Lai Jiangshan).
> ---
>  arch/x86/entry/entry_64_fred.S             |  8 +++--
>  arch/x86/include/asm/extable_fixup_types.h |  4 ++-
>  arch/x86/mm/extable.c                      | 36 ++++++++++++++++++++++
>  3 files changed, 45 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fre=
d.S
> index d975cacd060f..efe2bcd11273 100644
> --- a/arch/x86/entry/entry_64_fred.S
> +++ b/arch/x86/entry/entry_64_fred.S
> @@ -5,8 +5,10 @@
>   * The actual FRED entry points.
>   */
>  #include <linux/linkage.h>
> -#include <asm/errno.h>
> +#include <asm/asm.h>
>  #include <asm/asm-offsets.h>
> +#include <asm/errno.h>
> +#include <asm/export.h>
>  #include <asm/fred.h>
>
>  #include "calling.h"
> @@ -38,7 +40,9 @@ SYM_CODE_START_NOALIGN(fred_entrypoint_user)
>         call    fred_entry_from_user
>  SYM_INNER_LABEL(fred_exit_user, SYM_L_GLOBAL)
>         FRED_EXIT
> -       ERETU
> +1:     ERETU
> +
> +       _ASM_EXTABLE_TYPE(1b, fred_entrypoint_user, EX_TYPE_ERETU)
>  SYM_CODE_END(fred_entrypoint_user)
>
>  .fill fred_entrypoint_kernel - ., 1, 0xcc
> diff --git a/arch/x86/include/asm/extable_fixup_types.h b/arch/x86/includ=
e/asm/extable_fixup_types.h
> index 991e31cfde94..1585c798a02f 100644
> --- a/arch/x86/include/asm/extable_fixup_types.h
> +++ b/arch/x86/include/asm/extable_fixup_types.h
> @@ -64,6 +64,8 @@
>  #define        EX_TYPE_UCOPY_LEN4              (EX_TYPE_UCOPY_LEN | EX_D=
ATA_IMM(4))
>  #define        EX_TYPE_UCOPY_LEN8              (EX_TYPE_UCOPY_LEN | EX_D=
ATA_IMM(8))
>
> -#define EX_TYPE_ZEROPAD                        20 /* longword load with =
zeropad on fault */
> +#define        EX_TYPE_ZEROPAD                 20 /* longword load with =
zeropad on fault */
> +
> +#define        EX_TYPE_ERETU                   21
>
>  #endif
> diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
> index 60814e110a54..a5d75b27a993 100644
> --- a/arch/x86/mm/extable.c
> +++ b/arch/x86/mm/extable.c
> @@ -6,6 +6,7 @@
>  #include <xen/xen.h>
>
>  #include <asm/fpu/api.h>
> +#include <asm/fred.h>
>  #include <asm/sev.h>
>  #include <asm/traps.h>
>  #include <asm/kdebug.h>
> @@ -195,6 +196,37 @@ static bool ex_handler_ucopy_len(const struct except=
ion_table_entry *fixup,
>         return ex_handler_uaccess(fixup, regs, trapnr);
>  }
>
> +#ifdef CONFIG_X86_FRED
> +static bool ex_handler_eretu(const struct exception_table_entry *fixup,
> +                            struct pt_regs *regs, unsigned long error_co=
de)
> +{
> +       struct pt_regs *uregs =3D (struct pt_regs *)(regs->sp - offsetof(=
struct pt_regs, ip));
> +       unsigned short ss =3D uregs->ss;
> +       unsigned short cs =3D uregs->cs;
> +
> +       /*
> +        * Move the NMI bit from the invalid stack frame, which caused ER=
ETU
> +        * to fault, to the fault handler's stack frame, thus to unblock =
NMI
> +        * with the fault handler's ERETS instruction ASAP if NMI is bloc=
ked.
> +        */
> +       regs->nmi =3D uregs->nmi;
> +
> +       fred_info(uregs)->edata =3D fred_event_data(regs);
> +       uregs->ssx =3D regs->ssx;
> +       uregs->ss =3D ss;
> +       uregs->csx =3D regs->csx;
> +       uregs->nmi =3D 0; /* The NMI bit was moved away above */
> +       uregs->current_stack_level =3D 0;
> +       uregs->cs =3D cs;
> +
> +       /* Copy error code to uregs and adjust stack pointer accordingly =
*/
> +       uregs->orig_ax =3D error_code;

The address of uregs->orig_ax is below regs->sp, so I think
some comments are needed here to state why it is safe to
write to uregs->orig_ax (a.k.a it is not verlapped with regs).



Thanks
Lai

> +       regs->sp -=3D 8;
> +
> +       return ex_handler_default(fixup, regs);
> +}
> +#endif
> +
>  int ex_get_fixup_type(unsigned long ip)
>  {
>         const struct exception_table_entry *e =3D search_exception_tables=
(ip);
> @@ -272,6 +304,10 @@ int fixup_exception(struct pt_regs *regs, int trapnr=
, unsigned long error_code,
>                 return ex_handler_ucopy_len(e, regs, trapnr, reg, imm);
>         case EX_TYPE_ZEROPAD:
>                 return ex_handler_zeropad(e, regs, fault_addr);
> +#ifdef CONFIG_X86_FRED
> +       case EX_TYPE_ERETU:
> +               return ex_handler_eretu(e, regs, error_code);
> +#endif
>         }
>         BUG();
>  }
> --
> 2.34.1
>
