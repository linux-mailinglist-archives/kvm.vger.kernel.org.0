Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FA24B38CF
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 02:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiBMBb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 20:31:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiBMBbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 20:31:25 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890F360056
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 17:31:20 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id w27-20020a9d5a9b000000b005a17d68ae89so9032357oth.12
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 17:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IqVw1dNWLGaNjOjsb9lpDO0X9Y4fNFUj1aDh1p2RCJc=;
        b=X4ia5K0IC5p7WddVkQx3awbSFxdPflbeO9qpFk8b7bXLyHrLJCoYNfXpDoUBleT4Wt
         6inOoC0kLmdFrxaGS9HKjwqp3hXn0CREeJu4ij5M3vLFeY87U8CcEnE6QcfeTaUt4725
         AYqcIG8X2EAjSxugzC8DbeknW/8THTRf+9fp+qJAqrn3AM7EwYCAp+OC+Ba3HSjkXZ+P
         R5W5gZrrw5kKcW2UmIn2XZUoW38q4ckwbTiDOIjG9u+wqMXORr6B9QZbT1dNyGtHKmKQ
         jGUhFuhbXN23VbCA5MF8Jly71wtl0udbnYtFLquCgElOZwPk+ub0ntaXvGROeZnVeBEi
         ysgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IqVw1dNWLGaNjOjsb9lpDO0X9Y4fNFUj1aDh1p2RCJc=;
        b=CC8+afX2fOMrRKdOA0Fj0PN5wKYJqxbj5fOYiJp4GIay1xzirnXBVYGFA4xEbaVuyR
         MBD+K2bXVv9yb/sBIHWGrDDutac+Z9CsoTB2BjNXZ+eOsiMu8Sv7BKQJD7zJUqQQVQqM
         0FrDP3VTu6cKUL2jN9XVMNw6g+tnAEllBoSzmu7YCVvMuQt+A+OQNPdvthT6UaVlvwYN
         uvA3dI8gqn5aiy8Pe20hoBa27ylHl2Y80Uht5kRKS62t8Bpw9KRASxDDzW02KnFUI0YH
         aZwRTrD8Qmu/tJdt7iEXBi9BlT08jdu4PlOGLkfO0eOh3XaN+n+y1uMamQgLYQfGDgK5
         wLlw==
X-Gm-Message-State: AOAM532JCepdGVSnc++4XAtGZ61wI9Nwcycr/G6nrb0lOm3QIlaC5nSv
        i/4+P+rVTXNusk6RSOJT0UH3epUmCpqSpqI63XwM8Q==
X-Google-Smtp-Source: ABdhPJy+9EnaWqi9ZImaW8Q//Pes0d11LRByzNQfIfblpodSrxJBf/dCjuGovHfaRcnfzlXwytwHD96plZaD6vOAS9w=
X-Received: by 2002:a9d:6041:: with SMTP id v1mr2962025otj.35.1644715879358;
 Sat, 12 Feb 2022 17:31:19 -0800 (PST)
MIME-Version: 1.0
References: <20220209164420.8894-1-varad.gautam@suse.com> <20220209164420.8894-11-varad.gautam@suse.com>
In-Reply-To: <20220209164420.8894-11-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sat, 12 Feb 2022 17:31:08 -0800
Message-ID: <CAA03e5FR9mV1XtR9958rRh0ZPbZtcAftOvS6DxxD2zaVtKHX4g@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 10/10] x86: AMD SEV-ES: Handle string IO
 for IOIO #VC
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
> Using Linux's IOIO #VC processing logic.
>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/amd_sev_vc.c | 108 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 106 insertions(+), 2 deletions(-)
>
> diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
> index 88c95e1..c79d9be 100644
> --- a/lib/x86/amd_sev_vc.c
> +++ b/lib/x86/amd_sev_vc.c
> @@ -278,10 +278,46 @@ static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
>         return ES_OK;
>  }
>
> +static enum es_result vc_insn_string_read(struct es_em_ctxt *ctxt,
> +                                         void *src, unsigned char *buf,
> +                                         unsigned int data_size,
> +                                         unsigned int count,
> +                                         bool backwards)
> +{
> +       int i, b = backwards ? -1 : 1;
> +
> +       for (i = 0; i < count; i++) {
> +               void *s = src + (i * data_size * b);
> +               unsigned char *d = buf + (i * data_size);
> +
> +               memcpy(d, s, data_size);
> +       }
> +
> +       return ES_OK;
> +}
> +
> +static enum es_result vc_insn_string_write(struct es_em_ctxt *ctxt,
> +                                          void *dst, unsigned char *buf,
> +                                          unsigned int data_size,
> +                                          unsigned int count,
> +                                          bool backwards)
> +{
> +       int i, s = backwards ? -1 : 1;
> +
> +       for (i = 0; i < count; i++) {
> +               void *d = dst + (i * data_size * s);
> +               unsigned char *b = buf + (i * data_size);
> +
> +               memcpy(d, b, data_size);
> +       }
> +
> +       return ES_OK;
> +}
> +
>  static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>  {
>         struct ex_regs *regs = ctxt->regs;
> -       u64 exit_info_1;
> +       u64 exit_info_1, exit_info_2;
>         enum es_result ret;
>
>         ret = vc_ioio_exitinfo(ctxt, &exit_info_1);
> @@ -289,7 +325,75 @@ static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>                 return ret;
>
>         if (exit_info_1 & IOIO_TYPE_STR) {
> -               ret = ES_VMM_ERROR;
> +               /* (REP) INS/OUTS */
> +
> +               bool df = ((regs->rflags & X86_EFLAGS_DF) == X86_EFLAGS_DF);
> +               unsigned int io_bytes, exit_bytes;
> +               unsigned int ghcb_count, op_count;
> +               unsigned long es_base;
> +               u64 sw_scratch;
> +
> +               /*
> +                * For the string variants with rep prefix the amount of in/out
> +                * operations per #VC exception is limited so that the kernel
> +                * has a chance to take interrupts and re-schedule while the
> +                * instruction is emulated.
> +                */
> +               io_bytes   = (exit_info_1 >> 4) & 0x7;
> +               ghcb_count = sizeof(ghcb->shared_buffer) / io_bytes;
> +
> +               op_count    = (exit_info_1 & IOIO_REP) ? regs->rcx : 1;
> +               exit_info_2 = op_count < ghcb_count ? op_count : ghcb_count;
> +               exit_bytes  = exit_info_2 * io_bytes;
> +
> +               es_base = 0;
> +
> +               /* Read bytes of OUTS into the shared buffer */
> +               if (!(exit_info_1 & IOIO_TYPE_IN)) {
> +                       ret = vc_insn_string_read(ctxt,
> +                                              (void *)(es_base + regs->rsi),
> +                                              ghcb->shared_buffer, io_bytes,
> +                                              exit_info_2, df);
> +                       if (ret)
> +                               return ret;
> +               }
> +
> +               /*
> +                * Issue an VMGEXIT to the HV to consume the bytes from the
> +                * shared buffer or to have it write them into the shared buffer
> +                * depending on the instruction: OUTS or INS.
> +                */
> +               sw_scratch = __pa(ghcb) + offsetof(struct ghcb, shared_buffer);
> +               ghcb_set_sw_scratch(ghcb, sw_scratch);
> +               ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO,
> +                                         exit_info_1, exit_info_2);
> +               if (ret != ES_OK)
> +                       return ret;
> +
> +               /* Read bytes from shared buffer into the guest's destination. */
> +               if (exit_info_1 & IOIO_TYPE_IN) {
> +                       ret = vc_insn_string_write(ctxt,
> +                                                  (void *)(es_base + regs->rdi),
> +                                                  ghcb->shared_buffer, io_bytes,
> +                                                  exit_info_2, df);
> +                       if (ret)
> +                               return ret;
> +
> +                       if (df)
> +                               regs->rdi -= exit_bytes;
> +                       else
> +                               regs->rdi += exit_bytes;
> +               } else {
> +                       if (df)
> +                               regs->rsi -= exit_bytes;
> +                       else
> +                               regs->rsi += exit_bytes;
> +               }
> +
> +               if (exit_info_1 & IOIO_REP)
> +                       regs->rcx -= exit_info_2;
> +
> +               ret = regs->rcx ? ES_RETRY : ES_OK;
>         } else {
>                 /* IN/OUT into/from rAX */
>
> --
> 2.32.0
>

I was able to run both the amd_sev and msr tests under SEV-ES using
this built-in #VC handler on my setup. Obviously, that doesn't
exercise all of this #VC handler code. But I also compared it against
what's in LInux and read through all of it as well. Great job, Varad!

Reviewed-by: Marc Orr <marcorr@google.com>
Tested-by: Marc Orr <marcorr@google.com>
