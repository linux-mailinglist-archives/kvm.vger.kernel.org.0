Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1F077D68B
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 01:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240553AbjHOXMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 19:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240571AbjHOXL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 19:11:58 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3752110
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 16:11:38 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5646868b9e7so6299534a12.3
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 16:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692141098; x=1692745898;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=68208DkSFFRb+ZYItS1VBeVEWHiZTcmMjcr2WX+BbKM=;
        b=kRr4cmYElFOMe6ZJs6P79p3yFII+ItOSsoAatXN9c5Qb7Kqz5+qAKCsz0oxhkbUAnv
         /4Gx6xzip9c+a2zumCv3uHLIMpqGb57iewmqxOCsFSNaP5L7lefgQ/gK9rCEAyqe6+EU
         mRGE5It5aWrsDFTUM9rqJ2+TCTOyxp+uJ0IsRJXkEXQRhsmfzjYPyfw7YUJsdxmYfdW9
         lGDHB4qOpSbfoNwEsRQ67QzUlz3q6P1CFluY3U0Hz+k+bCKZcwlhcCUFrJJAAiYYGUlI
         NPYBJ5LtDxRvA2Nq29mNI0hLk7v+ZMm122dKHa1Vuo+Mc1xKu6KDbqN4zEpS80qQk53b
         35ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692141098; x=1692745898;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=68208DkSFFRb+ZYItS1VBeVEWHiZTcmMjcr2WX+BbKM=;
        b=VD6iV1y/FbVwMDHSUma/MH7H+7N4GddwDS1jr82P2ovoW0S5BFoB7UEDkZfj+67iTy
         VzxZ3kjHBvsMHaXs101nlCKOtgddjsqoTW9b6uQs5PtKKTUnnWv+kN3QKVkwPCkhuXNw
         woW+wWVt59VjEgxzSEY1gLFwOHwlDR+dHA76sNbm8lmIDK+e4SOAPzonUnjz5zXYQZXp
         zinRbTsKORqq38j+UGSN5yuA1eD3Hx3043zSTsbccjwAvPkZpTaZ28rsYq9Q9Hq4mN7V
         q39XFZUtdg7ddFQ1N5pSpi93jnC3tFY4tBZiBNsV647ZKOZ02X+Gk0T0hUqR6OgnJSmj
         B7Cg==
X-Gm-Message-State: AOJu0YzUsOHngbZz86Mcy0pvmNJxy7ujnb5aIJTsyO6bzVstZsRvPWNF
        te3P6lVeRH2H2UPqMkbsiNTI0YyZ4OE=
X-Google-Smtp-Source: AGHT+IEri9SE2UEHAt47BWDJSmpUO893HSTjSAclfz+daIAC0CEnk93OT8h4T1TLYtgD7Zj5kds8h0KGn9c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:a312:0:b0:565:eb51:3866 with SMTP id
 s18-20020a63a312000000b00565eb513866mr51228pge.11.1692141098258; Tue, 15 Aug
 2023 16:11:38 -0700 (PDT)
Date:   Tue, 15 Aug 2023 16:11:36 -0700
In-Reply-To: <20230719024558.8539-5-guang.zeng@intel.com>
Mime-Version: 1.0
References: <20230719024558.8539-1-guang.zeng@intel.com> <20230719024558.8539-5-guang.zeng@intel.com>
Message-ID: <ZNwGKPnTY7hRRy+S@google.com>
Subject: Re: [PATCH v2 4/8] KVM: x86: Add X86EMUL_F_INVTLB and pass it in em_invlpg()
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023, Zeng Guang wrote:
> From: Binbin Wu <binbin.wu@linux.intel.com>
> 
> Add an emulation flag X86EMUL_F_INVTLB, which is used to identify an
> instruction that does TLB invalidation without true memory access.
> 
> Only invlpg & invlpga implemented in emulator belong to this kind.
> invlpga doesn't need additional information for emulation. Just pass
> the flag to em_invlpg().

Please add a paragraph explaining *why* this flag is being added.  Ideally, the
previous patch would also explain the need for an IMPLICIT flag, but that one
doesn't bug me all that much because implicit accesses are known to be special
snowflakes, i.e. it's easy to imagine that KVM would need to identify such
accesses.  But for INVLPG, without already knowing the details of LASS (or LAM),
it's harder to think of why it needs to exist.

> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/x86/kvm/emulate.c     | 4 +++-
>  arch/x86/kvm/kvm_emulate.h | 1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 8e706d19ae45..9b4b3ce6d52a 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3443,8 +3443,10 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
>  {
>  	int rc;
>  	ulong linear;
> +	unsigned max_size;

	unsigned int

> -	rc = linearize(ctxt, ctxt->src.addr.mem, 1, false, &linear);
> +	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1, ctxt->mode,
> +		&linear, X86EMUL_F_INVTLB);

Align indentation:

	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1, ctxt->mode,
			 &linear, X86EMUL_F_INVTLB);

>  	if (rc == X86EMUL_CONTINUE)
>  		ctxt->ops->invlpg(ctxt, linear);
>  	/* Disable writeback. */
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index c0e48f4fa7c4..c944055091e1 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -93,6 +93,7 @@ struct x86_instruction_info {
>  #define X86EMUL_F_FETCH			BIT(1)
>  #define X86EMUL_F_BRANCH		BIT(2)
>  #define X86EMUL_F_IMPLICIT		BIT(3)
> +#define X86EMUL_F_INVTLB		BIT(4)

Why F_INVTLB instead of X86EMUL_F_INVLPG?  Ah, because LAM is ignored for the
linear address in the INVPCID and INVVPID descriptors.  Hrm.

I think my vote is to call this X86EMUL_F_INVLPG even though *in theory* it's not
strictly limited to INVLPG.  Odds are good KVM's emulator will never support
INVPCID or INVVPID, and IMO even though F_INVLPG would be somewhat of a misnomer,
it's much more intuitive even for INVPCID and INVVPID descriptors.  F_INVTLB makes
me think more of the actual act of invalidating the TLB.

I'm not dead set against INVTLB if someone really likes it, but I did scratch my
head for a second when I saw it.
