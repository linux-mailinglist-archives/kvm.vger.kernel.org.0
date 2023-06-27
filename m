Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA1B740260
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 19:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjF0Rky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 13:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjF0Rkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 13:40:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA05270C
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 10:40:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bc9483b506fso6308510276.0
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 10:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687887651; x=1690479651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=11Uk86ZiG1l2t7RwyJFa1Yxm6VpbSLgLXUmBFPvvECA=;
        b=Tbl8Q2EMHSj8qNK++25yc467ygYFwxXCtu6J3DDF6fIaZyTMczmS1nE7iIf2QqCRxn
         8GmQWSYxJ01AQH13w2cagG1MnvhGyPGCur9J1DMjZKttuK1mF1CBc9Wu9f5FvD3gH1N+
         rArUn6KlKqSEgD176PZc4Uw8Vfn5amVF9A7aZvLvh0znAJCJFq0+4c2tCKeFyMcs9Pck
         hch2uqqqhHdNJnYsoK4OV6JxThG0GkmIO0u5hzRd5dbRJ+XH0z/Shn82J+dgLSa52bsd
         Tt+Itf7DZLzBr3pp7lPb6812MrKm9SHrLN9wMPuOa7gxt1vuaVa02Hu6TJUpuOycKwP3
         UkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687887651; x=1690479651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=11Uk86ZiG1l2t7RwyJFa1Yxm6VpbSLgLXUmBFPvvECA=;
        b=lqr1Zghe1NUcOnzZwljjArCXMacKCG073PKfsfziBa6P5TNALKiaNNPW7xSn6+UQl5
         MbXDqM1OLtFlWH+0wvWw/csr+NgTWy/QbsV7aFDNI2iND4CqCPhHHv8qfwRXoynwLX14
         TZ29AjrXH+a/wwOhZxmcrw+iKBAr1GMOn69Lot9FjTEPtExO8/x+tRsAdM+r4C+/BYUM
         aCxMCIhr0WVFkcaX4PZHqvZpWgVoQoQawaL6fPkbVyJXPQmucs1TjBjeZBXImsiRxBlg
         BOyZGroIu9Hcvyb8Rr5p+dEP9hBKXjT9NCi9kguUppuSdGavKhuTBPxBjypupLG34JLB
         HHRw==
X-Gm-Message-State: AC+VfDzuo8utj9A+jwkQNSCt/8PxKLC/Pu4cJNTHsU5uJbTW7/lxV66z
        Yz3trnSUXGEeLi+m1HSqWkTxEojGPYA=
X-Google-Smtp-Source: ACHHUZ4BRjuUrPhEpTRnMzYsdxJbdPhxA56gCmuzjdiAqaUv2m2Dh//xRc9KiTYHoGQSwPnQBUePnaKGz4c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5091:0:b0:c1a:dc07:1d74 with SMTP id
 e139-20020a255091000000b00c1adc071d74mr3324078ybb.0.1687887650871; Tue, 27
 Jun 2023 10:40:50 -0700 (PDT)
Date:   Tue, 27 Jun 2023 10:40:49 -0700
In-Reply-To: <20230601142309.6307-2-guang.zeng@intel.com>
Mime-Version: 1.0
References: <20230601142309.6307-1-guang.zeng@intel.com> <20230601142309.6307-2-guang.zeng@intel.com>
Message-ID: <ZJsfIQqPQgRILn7o@google.com>
Subject: Re: [PATCH v1 1/6] KVM: x86: Consolidate flags for __linearize()
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023, Zeng Guang wrote:
> From: Binbin Wu <binbin.wu@linux.intel.com>
> 
> Define a 32-bit parameter and consolidate the two bools into it.

Please write changelogs so that they make sense without the context of the shortlog.
In isolation, the above provides zero context.  And there's no need to provide a
play-by-play description of the change, e.g. this can be:

  Consolidate __linearize()'s @write and @fetch into a set of flags so that
  additional flags can be added without needing more/new boolean parameters,
  e.g. to precisely identify the access type for LASS.

> __linearize() has two bool parameters write and fetch. And new flag
> will be needed to support new feature (e.g. LAM needs a flag to skip

s/LAM/LASS

> address untag under some conditions).

Looks like this was copy+pasted LAM.  AIUI, there is no untagging in LASS.  Please,
please take the time to proofread what you're posting.  To you it's a minor typo,
to others, incorrect statements like this can create a lot of confusion.

> No functional change intended.
> 
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/x86/kvm/emulate.c     | 19 +++++++++++++------
>  arch/x86/kvm/kvm_emulate.h |  4 ++++
>  2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 936a397a08cd..9508836e8a35 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -687,8 +687,8 @@ static unsigned insn_alignment(struct x86_emulate_ctxt *ctxt, unsigned size)
>  static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>  				       struct segmented_address addr,
>  				       unsigned *max_size, unsigned size,
> -				       bool write, bool fetch,
> -				       enum x86emul_mode mode, ulong *linear)
> +				       u32 flags, enum x86emul_mode mode,

"unsigned int", not "u32".  They're obviously the same effective thing, but using
"unsigned int" captures that the number of bits doesn't truly matter, e.g. isn't
reflected in hardware or anything.  This could just as easily be a u16, but there's
obviously no reason to squeeze this into a u16.

> +				       ulong *linear)
>  {
>  	struct desc_struct desc;
>  	bool usable;
> @@ -696,6 +696,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>  	u32 lim;
>  	u16 sel;
>  	u8  va_bits;
> +	bool fetch = !!(flags & X86EMUL_F_FETCH);
> +	bool write = !!(flags & X86EMUL_F_WRITE);
>  
>  	la = seg_base(ctxt, addr.seg) + addr.ea;
>  	*max_size = 0;
> @@ -757,7 +759,11 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
>  		     ulong *linear)
>  {
>  	unsigned max_size;
> -	return __linearize(ctxt, addr, &max_size, size, write, false,
> +	u32 flags = 0;
> +
> +	if (write)
> +		flags |= X86EMUL_F_WRITE;
> +	return __linearize(ctxt, addr, &max_size, size, flags,
>  			   ctxt->mode, linear);

I'm tempted to have this be:

	return __linearize(ctxt, addr, &max_size, size,
			   write ? X86EMUL_F_WRITE : 0, ctxt->mode, linear);

Mostly so that it's obvious "flags" is constant.  The alterntive would e

	const unsigned int flags = write ? X86EMUL_F_WRITE : 0;

But my preference is probably to omit "flags" entirely.

>  }
>  
> @@ -768,10 +774,11 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
>  	unsigned max_size;
>  	struct segmented_address addr = { .seg = VCPU_SREG_CS,
>  					   .ea = dst };
> +	u32 flags = X86EMUL_F_FETCH;
>  
>  	if (ctxt->op_bytes != sizeof(unsigned long))
>  		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
> -	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
> +	rc = __linearize(ctxt, addr, &max_size, 1, flags, ctxt->mode, &linear);

Meh, just pass X86EMUL_F_FETCH directly, i.e. drop the local "flags".

>  	if (rc == X86EMUL_CONTINUE)
>  		ctxt->_eip = addr.ea;
>  	return rc;
> @@ -896,6 +903,7 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
>  	int cur_size = ctxt->fetch.end - ctxt->fetch.data;
>  	struct segmented_address addr = { .seg = VCPU_SREG_CS,
>  					   .ea = ctxt->eip + cur_size };
> +	u32 flags = X86EMUL_F_FETCH;
>  
>  	/*
>  	 * We do not know exactly how many bytes will be needed, and
> @@ -907,8 +915,7 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
>  	 * boundary check itself.  Instead, we use max_size to check
>  	 * against op_size.
>  	 */
> -	rc = __linearize(ctxt, addr, &max_size, 0, false, true, ctxt->mode,
> -			 &linear);
> +	rc = __linearize(ctxt, addr, &max_size, 0, flags, ctxt->mode, &linear);

And here.

>  	if (unlikely(rc != X86EMUL_CONTINUE))
>  		return rc;
>  
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index ab65f3a47dfd..5b9ec610b2cb 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -88,6 +88,10 @@ struct x86_instruction_info {
>  #define X86EMUL_IO_NEEDED       5 /* IO is needed to complete emulation */
>  #define X86EMUL_INTERCEPTED     6 /* Intercepted by nested VMCB/VMCS */
>  
> +/* x86-specific emulation flags */
> +#define X86EMUL_F_FETCH			BIT(0)
> +#define X86EMUL_F_WRITE			BIT(1)
> +
>  struct x86_emulate_ops {
>  	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
>  	/*
> -- 
> 2.27.0
> 
