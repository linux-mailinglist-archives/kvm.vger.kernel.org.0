Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1325B22CB
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 17:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiIHPum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 11:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiIHPul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 11:50:41 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A01CEB841
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 08:50:40 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id pj10so7776280pjb.2
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 08:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=yhkKsuJjCkH5vvaGM2iHjCoLwIu5zJgsDHBQXx6FXt0=;
        b=Pyk6o4ghYxcqlBGmRohX+ieQOgTmJcNA8CcaDxXlkVxb97sWZelsSKCR3YlgrRmQLQ
         KXX2MOTT+0R4V4P0lPbj/NdxAlonQqoLOae9CCqUkgE9lPKaEW4Bew5xo4djzKJt0e3u
         zGRli44wSACwjVIiFnyxFWknF2cfJfObrjU4QlY4/umwFFxg+EBgr8M9js75hr1qBbwj
         lj1T3AbVdAXQJ3O4rgCqsOJdFd6Rf+z+UhxcSEhUEjq36m2IBNpDZ0MTIHxnmPVvjydv
         5k3hfxHYYvuLcwxms3/D4jxJGNIoQWJhoUTyYmB8Xu5E+ZvKFFEvXK8cEwxkiXEWYqXN
         ZW1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=yhkKsuJjCkH5vvaGM2iHjCoLwIu5zJgsDHBQXx6FXt0=;
        b=ANbFYBxiCaCbslIY1ZqW1fSME5QUtgAlERNeNtJW6jZwewL/z9qmh2AtTxG/SB69f3
         6VmrvReiVJo6zofWvAvsIcOlrgjQh+UC5WKPRDsQuwkNNnwOyrABnUXASh0VC3SuszVo
         L/jTlVwjUkYhQTrhOIAf3GE8WVY9QzfJVRbJENjXUuSwA6al7qMUTQqilrsI3/KUe09E
         HzaeoRzLzl9av5RuWQJc7TO/33771tOZF9RYbRA7u3SYKKEY09timvGwjeqmmoVikCKW
         KU4O80wNWdjS8k0svpmfjTx6DK15h0QgNjSvlGepY6Pca8UjuEH6vpjZCvQczF059wYW
         99IA==
X-Gm-Message-State: ACgBeo2oHGmFsOHOXkXHADCZaMZofMe2TdqLjUkNlPuO+zISCeZXH0s5
        RmwzOfFm25kfyM035/GeIPOCzQ==
X-Google-Smtp-Source: AA6agR4Ecbhy1CSe7fhCFYobvIDT8BJv3rXrEEP0R+F5e+Gc49DQ8JnrdCsBqI1eJGG+/g2sLfmzig==
X-Received: by 2002:a17:90a:fc98:b0:202:52cf:c117 with SMTP id ci24-20020a17090afc9800b0020252cfc117mr4731880pjb.26.1662652239831;
        Thu, 08 Sep 2022 08:50:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c8-20020a621c08000000b0053e4296e1d3sm6235817pfc.198.2022.09.08.08.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:50:39 -0700 (PDT)
Date:   Thu, 8 Sep 2022 15:50:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Liam Ni <zhiguangni01@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH v2] KVM:x86: Clean up ModR/M "reg" initialization in reg
 op decoding
Message-ID: <YxoPS5OCup1h8QD4@google.com>
References: <20220908141210.1375828-1-zhiguangni01@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908141210.1375828-1-zhiguangni01@zhaoxin.com>
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

On Thu, Sep 08, 2022, Liam Ni wrote:
> From: Liam Ni <zhiguangni01@gmail.com>
> 
> Refactor decode_register_operand() to get the ModR/M register if and
> only if the instruction uses a ModR/M encoding to make it more obvious
> how the register operand is retrieved.
> 
> Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
> ---

Pushed to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

with the below nit sqaushed.  Unless you hear otherwise, it will make its way to
kvm/queue "soon".

Note, the commit IDs are not guaranteed to be stable.

>  arch/x86/kvm/emulate.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index f092c54d1a2f..879b52af763a 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1137,9 +1137,11 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
>  static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
>  				    struct operand *op)
>  {
> -	unsigned reg = ctxt->modrm_reg;
> +	unsigned int reg;
>  
> -	if (!(ctxt->d & ModRM))
> +	if ((ctxt->d & ModRM))

Only need one set of parentheses.  

> +		reg = ctxt->modrm_reg;
> +	else
>  		reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
>  
>  	if (ctxt->d & Sse) {
> -- 
> 2.34.1
> 
