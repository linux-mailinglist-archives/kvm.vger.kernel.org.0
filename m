Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278415AF0A8
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 18:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiIFQh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 12:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238265AbiIFQhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 12:37:09 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672E9D128
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 09:14:29 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id fs14so7022591pjb.5
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 09:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=7CXDoix81nCcuywXft6Y3RRt0+1RNNcCmY7zulk0U7c=;
        b=OFjpfysVV1/z6c6F7Tl1V0DukI72KYzDhLdtoOZgHLzGCHihgIKAFQlVhWam6SBvJu
         P4gYQceuv8uTFhEriQ7a805oEkTCwl0CPwvPS4JQwwLLJlpkE/PhT3bGFarXT71ZV/zC
         /L8MQaIBhK/L/Po1d7BYMfDSuuRR6Z0DhvvBCC7yYh0gFL0q/I/ftbzNgIeFeZlzx+8p
         NmFZ+3aoiy/3LAUn12pFdTBuXQeiLIugcKhnbIBCsvAekEexbA37sYwcgyOTd5kJHssD
         zpYogs2kEJ7sq2XIPm4cDWVV5N5waUI10efONdoWWFJehxlK8XTO2y7LZlTji0FpOh7c
         6yVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=7CXDoix81nCcuywXft6Y3RRt0+1RNNcCmY7zulk0U7c=;
        b=KY04opwN9MFJGZ7A+eEcfHFznZJ7MmQ5DI/rGy5nook/xkxZYceSc0E6FpQ9RSUNFj
         GWNrCGIl9oJ7wwB+edHoho7SoQIF9vuxmx7i2yEmO2C85OarRIwy980snna880+YGHel
         ndCYo5I+59ZXOQ4OujZ8ZFRqaMYHYWIyj9VlQ6AzpxJJdMBAuApmJ9N19G+1S0xKVpab
         YCJPRyLvRhGUwgAOEWd2sT6oU1j6J1xzpBp4vq3YzozYViBVv9p8TX3nOQ8UXET8kc+E
         UrfgZxYEvhQKLFWhgZ9DI/sLY+FXtjH8KmfXNIn2+1FmKdg6a+irNkWboHTqG8cNjal7
         7ltA==
X-Gm-Message-State: ACgBeo2sGmIVFME+LArXovSrs5i22v8hKfmGIzIVH59UN2tkEtuCxLam
        x0f8HasvMRHEZanP4Uycy+DlKQ==
X-Google-Smtp-Source: AA6agR5flBH1H6qZt6yqi1YACzYjOurpqqJC2Z48B/RK4btE8X1zqj9xN+EaD6QhovkgkPr16hq/9g==
X-Received: by 2002:a17:90b:1e0c:b0:1f5:4e52:4866 with SMTP id pg12-20020a17090b1e0c00b001f54e524866mr26225036pjb.230.1662480868029;
        Tue, 06 Sep 2022 09:14:28 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id bi10-20020a170902bf0a00b00174e5fe9ce1sm1858226plb.159.2022.09.06.09.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 09:14:27 -0700 (PDT)
Date:   Tue, 6 Sep 2022 16:14:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Liam Ni <zhiguangni01@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH] KVM: Reduce the execution of one instruction
Message-ID: <Yxdx36BHlClCq52J@google.com>
References: <20220906153357.1362555-1-zhiguangni01@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906153357.1362555-1-zhiguangni01@zhaoxin.com>
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

"KVM: x86:" for the shortlog.

On Tue, Sep 06, 2022, Liam Ni wrote:
> From: Liam Ni <zhiguangni01@gmail.com>
> 
> If the condition is met,

Please describe this specific code change, "If the condition is met" is extremely
generic and doesn't help the reader understand what change is being made.

> reduce the execution of one instruction.

This is highly speculative, e.g. clang will generate identical output since it's
trivial for the compiler to observe that ctxt->modrm_reg doesn't need to be read.

And similar to the above "If the condition is met", the shortlog is too generic
even if it were 100% accurate.

I do think this change is a net positive, but it's beneficial only in making the
code easier to read.  Shaving a single cheap instruction in a relatively slow path
isn't sufficient justification even if the compiler isn't clever enough to optimize
away the load in the first place.

E.g. something like:

  KVM: x86: Clean up ModR/M "reg" initialization in reg op decoding

  Refactor decode_register_operand() to get the ModR/M register if and
  only if the instruction uses a ModR/M encoding to make it more obvious
  how the register operand is retrieved.

> Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
> ---
>  arch/x86/kvm/emulate.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index f8382abe22ff..ebb95f3f9862 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1139,10 +1139,12 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
>  static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
>  				    struct operand *op)
>  {
> -	unsigned reg = ctxt->modrm_reg;
> +	unsigned int reg;
>  
>  	if (!(ctxt->d & ModRM))
>  		reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
> +	else
> +		reg = ctxt->modrm_reg;

I'd prefer to write this as:

	unsigned int reg;

	if (ctxt->d & ModRM)
		reg = ctxt->modrm_reg;
	else
		reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);

so that "is ModRM" check is immediately followed by "get ModRM".

>  
>  	if (ctxt->d & Sse) {
>  		op->type = OP_XMM;
> -- 
> 2.25.1

> 
