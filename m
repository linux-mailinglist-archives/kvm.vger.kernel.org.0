Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD05740723
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjF1ATS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjF1ATN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:19:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A077926B1
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:19:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bfae0f532e4so6627025276.2
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687911552; x=1690503552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JxI6sBdKFLWo5Ay5v2GBSHIoKPiwpGbdFIVlVPe/v4M=;
        b=o7IzfuzhBh4HIx1i1BzhePb11oSoCkZdF5cXU1rZUb1WQ93wB5m8uCCACBFIHP34Nr
         knyUQJ06dz8rz3+5HG6XTAtPLzdJLqONWk0jZ+gsWGHvqb0ZhqqnpemzA1Z0KfJSUIrA
         ksnTQsJumX9JbFmfFR+VCu5jr7NfLGkMWfYqUKo7CcbIHbKsCghJ/eD4z2oauLow/LF5
         kYA3mpHM1XCXMTVouhCUKDJMZ3Guf3f3D5dbWaoaa/kAXGeARWW1TNQwxcz6lChPMCkI
         9xR1pFECo23PbVvl4RHotEqeXhMwD8qzZwU8o7lIxgjdfdZeC9jNYvmsRlFSNt1/1BW9
         SDuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911552; x=1690503552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JxI6sBdKFLWo5Ay5v2GBSHIoKPiwpGbdFIVlVPe/v4M=;
        b=I+gEEjgkNGY+0+/IBHFP8jlgigQdZ5d26eR9r+l7cu9RT6WR6AZiG/pCsDJ66xbcsd
         hlEuppsGXZzKmMOme/7bIJKzOujQsngX/pSLgv/qpPODVVenmEuMKKlPTG3uYRXgk+1r
         9bchvVsKYWzmL0xJWASU3XhYd/D/sAtDbVj6R1/Su9dzR8hVvBKc3XpnnDPKONg+ZdEz
         P50wWHniUyxB7YDN8g1rTN4qISLSyaVgpIdJz853njtjT9xSdY7kYSR5FT+MmhiKREJm
         b733sgSsvI3eFEacArt0XQecrQpDjG3GyA6veg2MbclQ55HiElKLuG40rVKx88ToMUy3
         TCog==
X-Gm-Message-State: AC+VfDzbyUEq+d49ejfWJwwNBb39WroM7eDC3d6fzCyEn8SutsLgdz1s
        TII8JhhQD3ZAJxUIswFw54a5TILU7S8=
X-Google-Smtp-Source: ACHHUZ7dTSjYNqSQljkBCaYubh27DakmyAQK55bDz+5RD15ftXpG6YHCof66yu7RUAC6POkSnUOpLyFBemc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:248d:0:b0:c1a:b0e2:e933 with SMTP id
 k135-20020a25248d000000b00c1ab0e2e933mr3579839ybk.1.1687911551936; Tue, 27
 Jun 2023 17:19:11 -0700 (PDT)
Date:   Tue, 27 Jun 2023 17:19:10 -0700
In-Reply-To: <20230606091842.13123-6-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230606091842.13123-1-binbin.wu@linux.intel.com> <20230606091842.13123-6-binbin.wu@linux.intel.com>
Message-ID: <ZJt8fjfNQYIV9wVk@google.com>
Subject: Re: [PATCH v9 5/6] KVM: x86: Untag address when LAM applicable
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023, Binbin Wu wrote:
> Untag address for 64-bit memory/MMIO operand in instruction emulations
> and VMExit handlers when LAM is applicable.
> 
> For instruction emulation, untag address in __linearize() before
> canonical check. LAM doesn't apply to addresses used for instruction
> fetches or to those that specify the targets of jump and call instructions,
> use X86EMUL_F_SKIPLAM to skip LAM untag.
> 
> For VMExit handlers related to 64-bit linear address:
> - Cases need to untag address
>   Operand(s) of VMX instructions and INVPCID.
>   Operand(s) of SGX ENCLS.
> - Cases LAM doesn't apply to
>   Operand of INVLPG.
>   Linear address in INVPCID descriptor (no change needed).
>   Linear address in INVVPID descriptor (it has been confirmed, although it is
>   not called out in LAM spec, no change needed).
>   BASEADDR specified in SESC of ECREATE (no change needed).
> 
> Note:
> LAM doesn't apply to the writes to control registers or MSRs.
> LAM masking applies before paging, so the faulting linear address in CR2
> doesn't contain the metadata.
> The guest linear address saved in VMCS doesn't contain metadata.
> 
> Co-developed-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> ---
>  arch/x86/kvm/emulate.c     | 16 +++++++++++++---
>  arch/x86/kvm/kvm_emulate.h |  2 ++
>  arch/x86/kvm/vmx/nested.c  |  2 ++
>  arch/x86/kvm/vmx/sgx.c     |  1 +
>  arch/x86/kvm/x86.c         |  7 +++++++
>  5 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index e89afc39e56f..c135adb26f1e 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -701,6 +701,7 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>  	*max_size = 0;
>  	switch (mode) {
>  	case X86EMUL_MODE_PROT64:
> +		ctxt->ops->untag_addr(ctxt, &la, flags);
>  		*linear = la;

Ha!  Returning the untagged address does help:

		*linear = ctx->ops->get_untagged_address(ctxt, la, flags);

>  		va_bits = ctxt_virt_addr_bits(ctxt);
>  		if (!__is_canonical_address(la, va_bits))
> @@ -771,8 +772,12 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
>  
>  	if (ctxt->op_bytes != sizeof(unsigned long))
>  		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
> +	/*
> +	 * LAM doesn't apply to addresses that specify the targets of jump and
> +	 * call instructions.
> +	 */
>  	rc = __linearize(ctxt, addr, &max_size, 1, ctxt->mode, &linear,
> -			 X86EMUL_F_FETCH);
> +			 X86EMUL_F_FETCH | X86EMUL_F_SKIPLAM);

No need for anything LAM specific here, just skip all FETCH access (unlike LASS
which skips checks only for branch targets).

> -	rc = linearize(ctxt, ctxt->src.addr.mem, 1, false, &linear);
> +	/* LAM doesn't apply to invlpg */

Comment unneeded if X86EMUL_F_INVLPG is added.
