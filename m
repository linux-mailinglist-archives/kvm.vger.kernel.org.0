Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE2D4B3878
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 00:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiBLXDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 18:03:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiBLXDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 18:03:16 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DEA5F8CA
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 15:03:12 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id i5so13658773oih.1
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 15:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XnHCuAZT9IuQAR1S+WE0f0q7JyEoS/WTPeScnfuUCPw=;
        b=sZvLtQgoAtugSeclQAoTOLIMWb0Cca+JuhbpYqS5m+TCzPf1Eehf7P1T8dsTIuIhh2
         QNr1bYzE89pt0eCtqIZaDuUHiOnGu1DMnuZL1XraKP+2kGacZLEqEwhFQ1z/1hBm2Cun
         mVHzGg+KJjKpztWGpWx/NB5YJhdTjii/Uh8RBywNk35qBjwSQgrP/a8JV6Ms8lWB1kfN
         LIYkbnrvgNvfSff84Q6BVsdb8zp5vezenrYqwUNNnSxGU+8cZpmHtcurAyrRAZ2l+SMd
         ixhVtpsiBWo68UzVdH7ZUx+td0Hawyd2sunO2Ws/pkOvUKjbel4nXQMzyAVpUu9p5UM6
         PRjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XnHCuAZT9IuQAR1S+WE0f0q7JyEoS/WTPeScnfuUCPw=;
        b=FRkQ4g1XKep/XaV4m6Qe2AeVt5g38FchcUchi7VbLHrNWZy2BWysjDM3Zzr12OxLy0
         HtqVD6xn1Yz6DjgH3t/ZCHKVPOrCm/qYga4OOmI6tDU4LlKKNnJZeWkBPaTbWFgjyLyv
         KwzLn07jfj1LZzyNg3JG7JQ8SVX2kh7cA5ipsG/1zt/2rOU30bDgex6falmMCApGJX8D
         UYMf+FmnSvqcmf4LDkGHeVMwIV7swu+NosZ4gu+INXSwiyb4RmhL0r+lZPyennRlA6U0
         MABG1fa7e6ttH+MPcPlT8FwlnDCUAUZlTvJowecYXypZA2JlhL1fYMQEcMnpAvcS8rcP
         NtIA==
X-Gm-Message-State: AOAM5318SWmMC4TaL+ny2AIrkULeBEDVPeteZ+jhJoG32+XSVNcOQxwR
        tjBHZaDLg5QNTKGL0cyeWCjGVeml0HQOXFbB87Wnzw==
X-Google-Smtp-Source: ABdhPJyAN8uJ7v/Yx2P/1viLF0mH/GyUBV9Vr/j2DWPJXWn+azjMMGhFXsldGGW6gyGb9cEHv88vZtNgNgP0Yg8l2Zs=
X-Received: by 2002:a05:6808:1a0b:: with SMTP id bk11mr2893601oib.49.1644706991731;
 Sat, 12 Feb 2022 15:03:11 -0800 (PST)
MIME-Version: 1.0
References: <20220209164420.8894-1-varad.gautam@suse.com> <20220209164420.8894-10-varad.gautam@suse.com>
In-Reply-To: <20220209164420.8894-10-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sat, 12 Feb 2022 15:03:00 -0800
Message-ID: <CAA03e5E+ohvN87AFQc8=gL=BVQnJqdLD5HrBWOtQnG9brioPww@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 09/10] x86: AMD SEV-ES: Handle IOIO #VC
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
>  lib/x86/amd_sev_vc.c | 146 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 146 insertions(+)
>
> diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
> index 401cb29..88c95e1 100644
> --- a/lib/x86/amd_sev_vc.c
> +++ b/lib/x86/amd_sev_vc.c
> @@ -172,6 +172,149 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>         return ret;
>  }
>
> +#define IOIO_TYPE_STR  BIT(2)
> +#define IOIO_TYPE_IN   1
> +#define IOIO_TYPE_INS  (IOIO_TYPE_IN | IOIO_TYPE_STR)
> +#define IOIO_TYPE_OUT  0
> +#define IOIO_TYPE_OUTS (IOIO_TYPE_OUT | IOIO_TYPE_STR)
> +
> +#define IOIO_REP       BIT(3)
> +
> +#define IOIO_ADDR_64   BIT(9)
> +#define IOIO_ADDR_32   BIT(8)
> +#define IOIO_ADDR_16   BIT(7)
> +
> +#define IOIO_DATA_32   BIT(6)
> +#define IOIO_DATA_16   BIT(5)
> +#define IOIO_DATA_8    BIT(4)
> +
> +#define IOIO_SEG_ES    (0 << 10)
> +#define IOIO_SEG_DS    (3 << 10)
> +
> +static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
> +{
> +       struct insn *insn = &ctxt->insn;
> +       *exitinfo = 0;
> +
> +       switch (insn->opcode.bytes[0]) {
> +       /* INS opcodes */
> +       case 0x6c:
> +       case 0x6d:
> +               *exitinfo |= IOIO_TYPE_INS;
> +               *exitinfo |= IOIO_SEG_ES;
> +               *exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
> +               break;
> +
> +       /* OUTS opcodes */
> +       case 0x6e:
> +       case 0x6f:
> +               *exitinfo |= IOIO_TYPE_OUTS;
> +               *exitinfo |= IOIO_SEG_DS;
> +               *exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
> +               break;
> +
> +       /* IN immediate opcodes */
> +       case 0xe4:
> +       case 0xe5:
> +               *exitinfo |= IOIO_TYPE_IN;
> +               *exitinfo |= (u8)insn->immediate.value << 16;
> +               break;
> +
> +       /* OUT immediate opcodes */
> +       case 0xe6:
> +       case 0xe7:
> +               *exitinfo |= IOIO_TYPE_OUT;
> +               *exitinfo |= (u8)insn->immediate.value << 16;
> +               break;
> +
> +       /* IN register opcodes */
> +       case 0xec:
> +       case 0xed:
> +               *exitinfo |= IOIO_TYPE_IN;
> +               *exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
> +               break;
> +
> +       /* OUT register opcodes */
> +       case 0xee:
> +       case 0xef:
> +               *exitinfo |= IOIO_TYPE_OUT;
> +               *exitinfo |= (ctxt->regs->rdx & 0xffff) << 16;
> +               break;
> +
> +       default:
> +               return ES_DECODE_FAILED;
> +       }
> +
> +       switch (insn->opcode.bytes[0]) {
> +       case 0x6c:
> +       case 0x6e:
> +       case 0xe4:
> +       case 0xe6:
> +       case 0xec:
> +       case 0xee:
> +               /* Single byte opcodes */
> +               *exitinfo |= IOIO_DATA_8;
> +               break;
> +       default:
> +               /* Length determined by instruction parsing */
> +               *exitinfo |= (insn->opnd_bytes == 2) ? IOIO_DATA_16
> +                                                    : IOIO_DATA_32;
> +       }
> +       switch (insn->addr_bytes) {
> +       case 2:
> +               *exitinfo |= IOIO_ADDR_16;
> +               break;
> +       case 4:
> +               *exitinfo |= IOIO_ADDR_32;
> +               break;
> +       case 8:
> +               *exitinfo |= IOIO_ADDR_64;
> +               break;
> +       }
> +
> +       if (insn_has_rep_prefix(insn))
> +               *exitinfo |= IOIO_REP;
> +
> +       return ES_OK;
> +}
> +
> +static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
> +{
> +       struct ex_regs *regs = ctxt->regs;
> +       u64 exit_info_1;
> +       enum es_result ret;
> +
> +       ret = vc_ioio_exitinfo(ctxt, &exit_info_1);
> +       if (ret != ES_OK)
> +               return ret;
> +
> +       if (exit_info_1 & IOIO_TYPE_STR) {
> +               ret = ES_VMM_ERROR;
> +       } else {
> +               /* IN/OUT into/from rAX */
> +
> +               int bits = (exit_info_1 & 0x70) >> 1;
> +               u64 rax = 0;
> +
> +               if (!(exit_info_1 & IOIO_TYPE_IN))
> +                       rax = lower_bits(regs->rax, bits);
> +
> +               ghcb_set_rax(ghcb, rax);
> +
> +               ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_IOIO, exit_info_1, 0);
> +               if (ret != ES_OK)
> +                       return ret;
> +
> +               if (exit_info_1 & IOIO_TYPE_IN) {
> +                       if (!ghcb_rax_is_valid(ghcb))
> +                               return ES_VMM_ERROR;
> +                       regs->rax = lower_bits(ghcb->save.rax, bits);
> +               }
> +       }
> +
> +       return ret;
> +}
> +
>  static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>                                          struct ghcb *ghcb,
>                                          unsigned long exit_code)
> @@ -185,6 +328,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>         case SVM_EXIT_MSR:
>                 result = vc_handle_msr(ghcb, ctxt);
>                 break;
> +       case SVM_EXIT_IOIO:
> +               result = vc_handle_ioio(ghcb, ctxt);
> +               break;
>         default:
>                 /*
>                  * Unexpected #VC exception
> --
> 2.32.0
>

Reviewed-by: Marc Orr <marcorr@google.com>
