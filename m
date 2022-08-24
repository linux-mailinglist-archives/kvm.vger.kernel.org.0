Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272CB5A0380
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 23:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240261AbiHXV5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 17:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239989AbiHXV5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 17:57:15 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB09475FFE
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 14:57:13 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x19so15020306pfq.1
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 14:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=GzeQ8UfnZgFzVsS9nYnsVjGN8/XJ7d4LfMKvcO3JEq8=;
        b=fJiqL8P2aKKxhbMkesL39klbja+GBE8/578Sh/oxZl+m0V6Zb0QrWGQZMtA0YjQyQ8
         ptKPk0bn7TO/Ee00EZblLeT2kzuYax7CRD8KE2w5a8O1XDoHo8ntpzVe06zTQmOE4f3f
         hvVqGNqLeLyg49aKRTu2N4ygCzvXTepUO0qsqg56meDNO3lmV84tdedCGZRvDFY4odb9
         fGajR1I4gm+j6X1EOxJOEHrtq93+J0O5iWbaLkl2cwf9df+nOxni6TCB7Gqd549TmhNH
         WAg1Fc9NyOCx870DM6iTg9+cdq7HEXEL2hNIqPSi3Jua/NO4YRD6UZqohW9ScXG1BQod
         ACUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=GzeQ8UfnZgFzVsS9nYnsVjGN8/XJ7d4LfMKvcO3JEq8=;
        b=yT87UGLW86aFhyaM7w9RI8MChbCd6FHsyAtie86lbRw3aCqZ+xCg+1Xi1/tBysvwD0
         cTiXr4fLEDFbtxhUb0ZTUtC+HlVE96K2aT1PnKBiThRuGxdiMI3+MSr+MYt1HeanrXVj
         vsdMv7Zq9T6sBGmxGpOHRhytmFdcUzh4dqyINP+gUMTBe8yR5JyNN7rTVEzvhpJs3JW9
         WHjPJr302nzPqcgQISPDo4NhDO6ta3GspJTPEJoPkws3j2qt8F3MZt/tCqgYUIZXzBlW
         QbGtYZtsz+uJDnCCjPPFOm5S4Ae37caFo9t7RlFbJ1SNziVK3YtwSEq9cqYl/Cchwagx
         gp1g==
X-Gm-Message-State: ACgBeo31PVC4OkpqphBDQb94SttMO5rLuNtz3inJSmh8UvjrBpCVAeI8
        wqFRdZBphdsjlgB/2D22riZHyQ==
X-Google-Smtp-Source: AA6agR6E2CfaEKt+0LcgrA7rYehmiX3jf4R/fOcaxvVZV6ibR+u2YkiFO9rOuy5PqoH/tME4tQlQmg==
X-Received: by 2002:a62:1795:0:b0:536:4e84:5ee9 with SMTP id 143-20020a621795000000b005364e845ee9mr1031193pfx.52.1661378233171;
        Wed, 24 Aug 2022 14:57:13 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z38-20020a630a66000000b0041a67913d5bsm11498087pgk.71.2022.08.24.14.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 14:57:12 -0700 (PDT)
Date:   Wed, 24 Aug 2022 21:57:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 05/13] KVM: x86: emulator: update the emulation mode
 after CR0 write
Message-ID: <YwaetYqmL4Wfr21I@google.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
 <20220803155011.43721-6-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803155011.43721-6-mlevitsk@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022, Maxim Levitsky wrote:
> CR0.PE toggles real/protected mode, thus its update

Uber nit, I like using title case for Real Mode, Protected Mode, etc... so that
it's more obvious that a changelog/comment is referring to the architectural modes.

> should update the emulation mode.
> 
> This is likely a benign bug because there is no writeback
> of state, other than the RIP increment, and when toggling
> CR0.PE, the CPU has to execute code from a very low memory address.
> 
> Also CR0.PG toggle when EFER.LMA is set, toggles the long mode.

This last sentence is jumbled, and it probably fits better with the opening
sentence.  And it's technically EFER.LME; EFER.LMA=1 indicates the Long Mode is
fully active.  E.g. something like

  Update the emulation mode when handling writes to CR0, toggling CR0.PE switches
  between Real and Protected Mode, and toggling CR0.PG when EFER.LME=1 switches
  between Long and Protected Mode.

> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/emulate.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 5e91b26cc1d8aa..765ec65b2861ba 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3658,11 +3658,23 @@ static int em_movbe(struct x86_emulate_ctxt *ctxt)
>  
>  static int em_cr_write(struct x86_emulate_ctxt *ctxt)
>  {
> -	if (ctxt->ops->set_cr(ctxt, ctxt->modrm_reg, ctxt->src.val))
> +	int cr_num = ctxt->modrm_reg;
> +	int r;
> +
> +	if (ctxt->ops->set_cr(ctxt, cr_num, ctxt->src.val))
>  		return emulate_gp(ctxt, 0);
>  
>  	/* Disable writeback. */
>  	ctxt->dst.type = OP_NONE;
> +
> +	if (cr_num == 0) {
> +		/* CR0 write might have updated CR0.PE and/or CR0.PG
> +		 * which can affect the cpu execution mode */

		/*
		 * Multi-line comment format should look like this.  I need more
		 * words to make this multiple lines.
		 */

> +		r = emulator_recalc_and_set_mode(ctxt);
> +		if (r != X86EMUL_CONTINUE)
> +			return r;
> +	}
> +
>  	return X86EMUL_CONTINUE;
>  }
>  
> -- 
> 2.26.3
> 
