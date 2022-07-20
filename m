Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4628457C11A
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 01:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiGTXuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 19:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiGTXuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 19:50:09 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF603D59
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 16:50:07 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id bh13so100593pgb.4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 16:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SDnyggnh9pThzoDcJ3VXXCME6j9cwwo6N50/QOAGYi4=;
        b=PlQVOfMoLRbWIbLQUit4qc8Cr9e1p1I+DEw8K9HdObjZpV1NVWuTIWGnOwAR/eu+CT
         tJbWMjF81xfy2Ihd+23mqaALZYKa97ZBOR7gwq0Ifvw2/gKM30EM5Puj0/PgTvU3Z0UN
         LbKQbr6ZIuain8733He3iMd1TMnz2fJ1/V9vuz9d86IyXDQwswapDVpGLz2YzVdaL6rz
         Eylh7axUrLtGiPSwVtUO4JcvhaJQDKMM5J4eEcUb8FbW2jG40PJTjZfSCn+QXuotErLM
         1HuH8/fM948Pttrj8jzfmYtASASRdosYB2NTqPzzP3h0sXT10GkU3C6bgtsQJWLZclbt
         sYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SDnyggnh9pThzoDcJ3VXXCME6j9cwwo6N50/QOAGYi4=;
        b=NNnLhJm03QWL5o4S0Dh6SCIibf4g2ZOdJ2ccVMLFI7S1OlY0+FnC+wVs/MCtCJTUYL
         idT0AAUJeW6xIlAzKe/b2WCIROXdJGVDHHf7pENFtP3GWmgPZA1uL6JkfKKA7W/mcS+D
         X25RWTUBjuoUgZcxJ4z0UsdMZ2/Oq1p2UmdGVhbEZ3YTijecOgMTI4g2PSguBe6OW+eZ
         hz8PghY7lMmLn9nxVmnQ0K8h9fW3NBJ4+vtK4vvqW8Vqj0mLRIaJeLiY4FIpj0pYp5jb
         yJdUyyhd4qhZC4Ppt5uPH/YCNzRsNwBYHZvOk9gdkVAekfcRu3WEp1ZAaQ1k6cwTN+/w
         1aPg==
X-Gm-Message-State: AJIora9W5Q6LQlmGVCDha4a+HmGsBvbgHM7yT5uERDqr/CSq6sUl1lab
        TJs4T6RyRFWhbZpXxCPko9xKFw==
X-Google-Smtp-Source: AGRyM1uIj7US8Y7oIaCy/d4XVt8BGXMupWNBQUm7cMoPwn35cUNrKPQn/t+NucZZwTv0f2vXj6iJpg==
X-Received: by 2002:a63:4f52:0:b0:41a:3744:d952 with SMTP id p18-20020a634f52000000b0041a3744d952mr12528022pgl.186.1658361007090;
        Wed, 20 Jul 2022 16:50:07 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z15-20020a17090abd8f00b001f21f7821e0sm68648pjr.2.2022.07.20.16.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 16:50:06 -0700 (PDT)
Date:   Wed, 20 Jul 2022 23:50:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 05/11] KVM: x86: emulator: update the emulation mode
 after CR0 write
Message-ID: <YtiUq7jm2Z1NTRv3@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
 <20220621150902.46126-6-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621150902.46126-6-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> CR0.PE toggles real/protected mode, thus its update
> should update the emulation mode.
> 
> This is likely a benign bug because there is no writeback
> of state, other than the RIP increment, and when toggling
> CR0.PE, the CPU has to execute code from a very low memory address.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/emulate.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 6f4632babc4cd8..002687d17f9364 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3659,11 +3659,22 @@ static int em_movbe(struct x86_emulate_ctxt *ctxt)
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
> +		/* CR0 write might have updated CR0.PE */

Or toggled CR0.PG.  It's probably also worth noting that ->set_cr() handles side
effects to other registers, e.g. the lack of an EFER.LMA update makes this look
suspicious at first glance.

> +		r = update_emulation_mode(ctxt);
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
