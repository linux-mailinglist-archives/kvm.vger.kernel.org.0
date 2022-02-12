Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7AA4B3838
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 22:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbiBLVcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 16:32:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiBLVcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 16:32:23 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606C6606F7
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 13:32:19 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id u47-20020a4a9732000000b00316d0257de0so14705960ooi.7
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 13:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Q/KMq402huvrEYfhR71AiwsVypURG5gY6d6ygJ4e8k=;
        b=hJx9hyM5l+Hg9dDNu6DYJdunNwtHoCusL4kvnWEp42ZY/EGCNTC/yNDRMRO41JIVLb
         8e6Gzr0/+WvTxhlxSO36qOg3KUBUxL5fXSvsIIfAgUn9F5L2nH5W043o35hmUkVyHOZM
         NyS30fQpwEid6R2GeQnR+z0Gk8x/5Ak+cQvvGdz2mzzDoUuG+xlvrJdguplTQQbcq+xp
         8g/qPAcJTUUGzw5mDSG4k9wv92rNpbHMY4iwcZCb/feqUCT6xKcSvLYcYXnjorc9BY5x
         6v4V6XokeQeRiro6UGT+C7D17JPeTUfIrmWI6W+z1N9gOCoZQpId9MBBw/1yqJWKepax
         93Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Q/KMq402huvrEYfhR71AiwsVypURG5gY6d6ygJ4e8k=;
        b=pwj0+JL/g+DQt1W8rUhXxIYTJIOy7fKpKpArdWrqAW0TleJUo+oWyED298e3JFYogV
         5WcA3LmIg96aW+H6W723ozDgKoM8ptdCwUpl9onvOoAHXO9SIA/Y+qJ6+cesHNhi8inq
         /XFWlN31M0ChtM1PdXsxUTjcgKOk7G/lK9J5VDRMCM8d4w0C8jPS3nlEbBrqAWqL6hDj
         bqBLEBH1aUMWvqQ5MqD7nEPDTBvrazmCdCA+h9t7Q/O05xAThUQO24N3jBtas9sGqu9C
         yqvrfzhVPkrTrOxKqtYVkKFiy5Xm3ClmdlEuohJnMK8saifHuyICCfP4qlhwHoRhy/w6
         5T+Q==
X-Gm-Message-State: AOAM533QQYpzI4ATBZ+Gvfjou6th1R1CQVX4LgTxrpkPvaeEFLcHsRQr
        3bunDMNFZQ0rs4VcoyvBMAB+eUH0NfDzw+khUGGy1g==
X-Google-Smtp-Source: ABdhPJyw7bMT7Tb8ayHg9Aj/jwerd88ARLx7xbQrXq4bwDRCOOUJxjDnOFfi8XXdGQIE1OzmHRZY2tpvtg4d8e3hySo=
X-Received: by 2002:a05:6870:6186:: with SMTP id a6mr2073532oah.153.1644701538422;
 Sat, 12 Feb 2022 13:32:18 -0800 (PST)
MIME-Version: 1.0
References: <20220209164420.8894-1-varad.gautam@suse.com> <20220209164420.8894-8-varad.gautam@suse.com>
In-Reply-To: <20220209164420.8894-8-varad.gautam@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Sat, 12 Feb 2022 13:32:07 -0800
Message-ID: <CAA03e5Eu1SmGgV4ne22ox1qU2wGZ_ce-iFTiCNqzKeD7qeiUiw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 07/10] x86: AMD SEV-ES: Handle CPUID #VC
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
> Using Linux's CPUID #VC processing logic.
>
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/amd_sev_vc.c | 98 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 98 insertions(+)
>
> diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
> index 142f2cd..9ee67c0 100644
> --- a/lib/x86/amd_sev_vc.c
> +++ b/lib/x86/amd_sev_vc.c
> @@ -2,6 +2,7 @@
>
>  #include "amd_sev.h"
>  #include "svm.h"
> +#include "x86/xsave.h"
>
>  extern phys_addr_t ghcb_addr;
>
> @@ -52,6 +53,100 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
>         ctxt->regs->rip += ctxt->insn.length;
>  }
>
> +static inline u64 lower_bits(u64 val, unsigned int bits)
> +{
> +       u64 mask = (1ULL << bits) - 1;
> +
> +       return (val & mask);
> +}

This isn't used in this patch. I guess it ends up being used later, in
path 9: "x86: AMD SEV-ES: Handle IOIO #VC". Let's introduce it there
if we're going to put it in this file. Though, again, maybe it's worth
creating a platform agnostic bit library, and put this and
`_test_bit()` (introduced in a previous patch) there.

> +
> +static inline void sev_es_wr_ghcb_msr(u64 val)
> +{
> +       wrmsr(MSR_AMD64_SEV_ES_GHCB, val);
> +}
> +
> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +                                         struct es_em_ctxt *ctxt,
> +                                         u64 exit_code, u64 exit_info_1,
> +                                         u64 exit_info_2)
> +{
> +       enum es_result ret;
> +
> +       /* Fill in protocol and format specifiers */
> +       ghcb->protocol_version = GHCB_PROTOCOL_MAX;
> +       ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
> +
> +       ghcb_set_sw_exit_code(ghcb, exit_code);
> +       ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
> +       ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
> +
> +       sev_es_wr_ghcb_msr(__pa(ghcb));
> +       VMGEXIT();
> +
> +       if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
> +               u64 info = ghcb->save.sw_exit_info_2;
> +               unsigned long v;
> +
> +               info = ghcb->save.sw_exit_info_2;

This line seems redundant, since `info` is already initialized to this
value when it's declared, two lines above. That being said, I see this
is how the code is in Linux as well. I wonder if it was done like this
on accident.

> +               v = info & SVM_EVTINJ_VEC_MASK;
> +
> +               /* Check if exception information from hypervisor is sane. */
> +               if ((info & SVM_EVTINJ_VALID) &&
> +                   ((v == GP_VECTOR) || (v == UD_VECTOR)) &&
> +                   ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
> +                       ctxt->fi.vector = v;
> +                       if (info & SVM_EVTINJ_VALID_ERR)
> +                               ctxt->fi.error_code = info >> 32;
> +                       ret = ES_EXCEPTION;
> +               } else {
> +                       ret = ES_VMM_ERROR;
> +               }
> +       } else if (ghcb->save.sw_exit_info_1 & 0xffffffff) {
> +               ret = ES_VMM_ERROR;
> +       } else {
> +               ret = ES_OK;
> +       }
> +
> +       return ret;
> +}
> +
> +static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
> +                                     struct es_em_ctxt *ctxt)
> +{
> +       struct ex_regs *regs = ctxt->regs;
> +       u32 cr4 = read_cr4();
> +       enum es_result ret;
> +
> +       ghcb_set_rax(ghcb, regs->rax);
> +       ghcb_set_rcx(ghcb, regs->rcx);
> +
> +       if (cr4 & X86_CR4_OSXSAVE) {
> +               /* Safe to read xcr0 */
> +               u64 xcr0;
> +               xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0);
> +               ghcb_set_xcr0(ghcb, xcr0);
> +       } else
> +               /* xgetbv will cause #GP - use reset value for xcr0 */
> +               ghcb_set_xcr0(ghcb, 1);

nit: Consider adding curly braces to the else branch, so that it
matches the if branch.

> +
> +       ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
> +       if (ret != ES_OK)
> +               return ret;
> +
> +       if (!(ghcb_rax_is_valid(ghcb) &&
> +             ghcb_rbx_is_valid(ghcb) &&
> +             ghcb_rcx_is_valid(ghcb) &&
> +             ghcb_rdx_is_valid(ghcb)))
> +               return ES_VMM_ERROR;
> +
> +       regs->rax = ghcb->save.rax;
> +       regs->rbx = ghcb->save.rbx;
> +       regs->rcx = ghcb->save.rcx;
> +       regs->rdx = ghcb->save.rdx;
> +
> +       return ES_OK;
> +}
> +
>  static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>                                          struct ghcb *ghcb,
>                                          unsigned long exit_code)
> @@ -59,6 +154,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
>         enum es_result result;
>
>         switch (exit_code) {
> +       case SVM_EXIT_CPUID:
> +               result = vc_handle_cpuid(ghcb, ctxt);
> +               break;
>         default:
>                 /*
>                  * Unexpected #VC exception
> --
> 2.32.0
>
