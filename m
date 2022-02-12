Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2B74B3841
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 22:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiBLVuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 16:50:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbiBLVuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 16:50:15 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79351606FA
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 13:50:11 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id u47-20020a4a9732000000b00316d0257de0so14744751ooi.7
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 13:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SVKrc5Tfh9jWH+GGzVHsyB4pyVUbqfoaq3i7KUvmLKs=;
        b=DZ6JPorGRzHXg4MqQX4918pgFR8v2Flnvatdm050gBJzCGGHjbe7EM4qL8w4cEJwAZ
         L5QuCD7X/IpjPt36jR9mDXjNg6fcM7QhM7EI1yhUOIZGtBpybP3AowJUbHiNH5RLp7JZ
         aMZ5zuw/3znOwkv4onKflD193WVm8jU/ovKIdD918Jwtt853c1Zl0hwp7ex6Y5Z4sHmZ
         PdWF1NJLcZxJlWVGdF4iykHM7oMpwHq0kfPd4T2WieX1P9GttkznEYXfeDbvDnTOiZyx
         RO7t82mAqxJ23ucGPC2NeWA3/oy97XJUsqwW8rwqkW6D4J3o17YLi7Nxy20P1HSYjP29
         iZnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SVKrc5Tfh9jWH+GGzVHsyB4pyVUbqfoaq3i7KUvmLKs=;
        b=Tckl6aowaT8sBaZ8GhQ1KSCEYp9QRXxk0hAyRtW46rI34Jvkpti6iXQiKzeVpwJoJk
         PQxnSAJ1+AvQjZYlm26F5Finl0f6pFlbaHAqWeDf4Q4emmbreSZq47udYi8MEAqEbdmi
         NgINIoW8VoFp2zo8spKo2pxe6P5mrZ/Tj9IjBHXIaT/KpSdBRHvd05vcVWEYOt3Nwkch
         mKGkB5J2exCsKipSkUnZ5frH55ywgcfvulo4g6l4Kx8w04mBJpKZfrmcSqUsju7Na+0Z
         xLYFTMVHvd2d+E4MYFtSfkUAEncxl+ZErm2rs6sjIXPS29gcyKNrFu4vH+AU2bcjdJEX
         lsdA==
X-Gm-Message-State: AOAM5329prt1FXbRdA36bzNWgD6WhoOX+iFUCBW7L7XIZfXCrOteGRLB
        /eODqnRh9btQNFcInXullBchgy7JOED8eVQvNjxGWw==
X-Google-Smtp-Source: ABdhPJyeS9ujHhAbVlMBTxqcY+3Pt8N0xaoSBMdHMfjzj7OKd4hW8/ryUfZMwX2gOSmKwR3TNaph36e1JQTrlyro968=
X-Received: by 2002:a05:6870:6186:: with SMTP id a6mr2088982oah.153.1644702610590;
 Sat, 12 Feb 2022 13:50:10 -0800 (PST)
MIME-Version: 1.0
References: <20220209164420.8894-1-varad.gautam@suse.com> <20220209164420.8894-9-varad.gautam@suse.com>
In-Reply-To: <20220209164420.8894-9-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sat, 12 Feb 2022 13:49:59 -0800
Message-ID: <CAA03e5E8BpA-g_1MDNUxjf096a4OCaGS_rGzkha=RCAN6QLXfw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 08/10] x86: AMD SEV-ES: Handle MSR #VC
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
> Using Linux's MSR #VC processing logic.
>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/amd_sev_vc.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
> index 9ee67c0..401cb29 100644
> --- a/lib/x86/amd_sev_vc.c
> +++ b/lib/x86/amd_sev_vc.c
> @@ -147,6 +147,31 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
>         return ES_OK;
>  }
>
> +static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
> +{
> +       struct ex_regs *regs = ctxt->regs;
> +       enum es_result ret;
> +       u64 exit_info_1;
> +
> +       /* Is it a WRMSR? */
> +       exit_info_1 = (ctxt->insn.opcode.bytes[1] == 0x30) ? 1 : 0;
> +
> +       ghcb_set_rcx(ghcb, regs->rcx);
> +       if (exit_info_1) {
> +               ghcb_set_rax(ghcb, regs->rax);
> +               ghcb_set_rdx(ghcb, regs->rdx);
> +       }
> +
> +       ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_MSR, exit_info_1, 0);
> +
> +       if ((ret == ES_OK) && (!exit_info_1)) {
> +               regs->rax = ghcb->save.rax;
> +               regs->rdx = ghcb->save.rdx;
> +       }
> +
> +       return ret;
> +}
> +
>  static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>                                          struct ghcb *ghcb,
>                                          unsigned long exit_code)
> @@ -157,6 +182,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>         case SVM_EXIT_CPUID:
>                 result = vc_handle_cpuid(ghcb, ctxt);
>                 break;
> +       case SVM_EXIT_MSR:
> +               result = vc_handle_msr(ghcb, ctxt);
> +               break;
>         default:
>                 /*
>                  * Unexpected #VC exception
> --
> 2.32.0
>

Reviewed-by: Marc Orr <marcorr@google.com>
