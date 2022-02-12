Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3522E4B3813
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 21:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiBLUyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 15:54:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiBLUyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 15:54:50 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DFE606ED
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 12:54:46 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id i5so13472251oih.1
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 12:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v7uqubuoxrJOyAsfITRitpJH9TVLjLPiNqSisXW5UIo=;
        b=dtMfcCx+DLajyI/IsigwCjIzYK9YfwTmvaiV5zUGgGW/WXExdcF4JbB8ngKfDA/8At
         aXa9n/ScSjtrwGHxmrmmaWocOvJscOu+BnILVOGmEzGt86vR6o9uMmEm/oTKpiQXcMAm
         fMUcL4Or60OCrBsVCFk3roH+xc/7RL5a8Dt+55+TGpRMHw20hgCM0PIdkLLf/fiQGr3l
         1vkD9JcAwqVfXBmwzoDqJqGQ0Db49h+sy72c4KlfSqkRa5zE5WntIUL3D1FcT5PukxvT
         cGFou7wv29dtiBfo9P43cN4mbdVEIWg4Z20zGbN14pzTcR0QWn6ASSYkOvuZ/Qh9Imdo
         Kisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v7uqubuoxrJOyAsfITRitpJH9TVLjLPiNqSisXW5UIo=;
        b=Kb2rEN4SzZw3Swn1Iv2PPoRGVDHrrcaAQAu6Ff1ZuPcqlKeHtC2759+PuxgdegXwSD
         R/dYxdF36pCU4Y45XqSAorgEsSZu0xkR5rPrBHGqgiFBBp21ElOqmSaZidKtYK4oyLiL
         3PVnPIoABNI2s5kqlItLeth5tz1lVKBP0Ki/i/TROHJJkxzJZnP29P2ful1LkHGzNGYj
         LO45GFdkL4DiB01CxL6HdT9bFbqYYc0iXU8QbwrkamBNpRD/ojF3XH9KyDzKMNupkQLv
         18M4+DYCgsYwGxWEWtAgmntmTFBNqtu2qdvOtR8TgjE6EPqJgCAYUNAK/YUTCwZeAEoS
         kJ+A==
X-Gm-Message-State: AOAM532Bbp6p8ntrtXdAteJGfdI9rb28x45PiQHece5uHfpdKucyac8Y
        AEDLYG1urbCORtoXBcLxAl50w41GrqPgWK3wx561rg==
X-Google-Smtp-Source: ABdhPJxlUY+r73p7kpP/NwDBa4bbXpwPK0yWKuda3RuQtg3wQu8ma56GyOGAf9c7j3tV+RJhrXYuQ07B45kSrpEbIF8=
X-Received: by 2002:a05:6808:1391:: with SMTP id c17mr2774151oiw.333.1644699285609;
 Sat, 12 Feb 2022 12:54:45 -0800 (PST)
MIME-Version: 1.0
References: <20220209164420.8894-1-varad.gautam@suse.com> <20220209164420.8894-6-varad.gautam@suse.com>
In-Reply-To: <20220209164420.8894-6-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sat, 12 Feb 2022 12:54:34 -0800
Message-ID: <CAA03e5G9Ler28JsLWU914Hg5w8cNEaQxoF_=K185vvTKo0MLcg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 05/10] x86: AMD SEV-ES: Prepare for #VC processing
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
> Lay the groundwork for processing #VC exceptions in the handler.
> This includes clearing the GHCB, decoding the insn that triggered
> this #VC, and continuing execution after the exception has been
> processed.

This description does not mention that this code is copied from Linux.
Should we have a comment in this patch description, similar to the
other patches?

Also, in general, I wonder if we need to mention where this code came
from in a comment header at the top of the file.

>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/amd_sev_vc.c | 78 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
>
> diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
> index 8226121..142f2cd 100644
> --- a/lib/x86/amd_sev_vc.c
> +++ b/lib/x86/amd_sev_vc.c
> @@ -1,14 +1,92 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>
>  #include "amd_sev.h"
> +#include "svm.h"
>
>  extern phys_addr_t ghcb_addr;
>
> +static void vc_ghcb_invalidate(struct ghcb *ghcb)
> +{
> +       ghcb->save.sw_exit_code = 0;
> +       memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
> +}
> +
> +static bool vc_decoding_needed(unsigned long exit_code)
> +{
> +       /* Exceptions don't require to decode the instruction */
> +       return !(exit_code >= SVM_EXIT_EXCP_BASE &&
> +                exit_code <= SVM_EXIT_LAST_EXCP);
> +}
> +
> +static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
> +{
> +       unsigned char buffer[MAX_INSN_SIZE];
> +       int ret;
> +
> +       memcpy(buffer, (unsigned char *)ctxt->regs->rip, MAX_INSN_SIZE);
> +
> +       ret = insn_decode(&ctxt->insn, buffer, MAX_INSN_SIZE, INSN_MODE_64);
> +       if (ret < 0)
> +               return ES_DECODE_FAILED;
> +       else
> +               return ES_OK;
> +}
> +
> +static enum es_result vc_init_em_ctxt(struct es_em_ctxt *ctxt,
> +                                     struct ex_regs *regs,
> +                                     unsigned long exit_code)
> +{
> +       enum es_result ret = ES_OK;
> +
> +       memset(ctxt, 0, sizeof(*ctxt));
> +       ctxt->regs = regs;
> +
> +       if (vc_decoding_needed(exit_code))
> +               ret = vc_decode_insn(ctxt);
> +
> +       return ret;
> +}
> +
> +static void vc_finish_insn(struct es_em_ctxt *ctxt)
> +{
> +       ctxt->regs->rip += ctxt->insn.length;
> +}
> +
> +static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
> +                                        struct ghcb *ghcb,
> +                                        unsigned long exit_code)
> +{
> +       enum es_result result;
> +
> +       switch (exit_code) {
> +       default:
> +               /*
> +                * Unexpected #VC exception
> +                */
> +               result = ES_UNSUPPORTED;
> +       }
> +
> +       return result;
> +}
> +
>  void handle_sev_es_vc(struct ex_regs *regs)
>  {
>         struct ghcb *ghcb = (struct ghcb *) ghcb_addr;
> +       unsigned long exit_code = regs->error_code;
> +       struct es_em_ctxt ctxt;
> +       enum es_result result;
> +
>         if (!ghcb) {
>                 /* TODO: kill guest */
>                 return;
>         }
> +
> +       vc_ghcb_invalidate(ghcb);
> +       result = vc_init_em_ctxt(&ctxt, regs, exit_code);
> +       if (result == ES_OK)
> +               result = vc_handle_exitcode(&ctxt, ghcb, exit_code);
> +       if (result == ES_OK)
> +               vc_finish_insn(&ctxt);

Should we print an error if the result is not `ES_OK`, like the
function `vc_raw_handle_exception()` does in Linux? Otherwise, this
silent failure is going to be very confusing to whoever runs into it.

> +
> +       return;
>  }
> --
> 2.32.0
>
