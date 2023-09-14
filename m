Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A81079FDC3
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 10:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbjINICg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 04:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjINICg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 04:02:36 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6181BFA
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 01:02:31 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-401c90ed2ecso7336525e9.0
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 01:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1694678550; x=1695283350; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Yy7C3eh8AGJ5bOR1d/ShKLFT+panz2pLVtrtSqm2ZHg=;
        b=XD76436IqKjCqyjfCqfMZRTQBNlgBe65EWcim9kOBLUT48ZwCcklXXHkGTmAMPbpqc
         jksJbKz3t+2dZZjifjWIBcM4bwjhOi5Btdf3uCyLW9L0fYQXlvLAUBTm7rYHs6iEYOoW
         71nJ7E1Go4X5VWgwy0b3Ni7h1WIkiVyhDubUnH8NCGOJD4UiqJp2JF2PXdKoesLlVEAU
         0UWyFagIjEj/7idmggSoqlQUYHcy4fnajX709YcLmwEty0uYA9eDUTa2ExxcfDiwnofO
         S5nmV1xcepEP77Imkro17DjGG9tClb4L9gxQh8gQusxEPsLy1cZ6DfG8YaUNdwjEmEOZ
         SiAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694678550; x=1695283350;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yy7C3eh8AGJ5bOR1d/ShKLFT+panz2pLVtrtSqm2ZHg=;
        b=pqGPynaaZdCMfcOJapu8zxIovmZhDrqebID3KSl6sYaXpc+G68vOgwApKA1GE5PmJo
         rt/FUOk0zJ82TwN7XqrvtAQ9X1VQIbnW7aPBx3Ra6OwvlRIoJWlN7bfYkBdtd2KLHZLn
         lbG0fTZyG4rlCQUj9VQcrf0/2tHQl2ZcqLAF8y27UnXF9xDHjV8ViF1eLo5t4LPBAEYi
         nc3WSnfZ48pe0kR3H3dD7c/hCEf1OzsHuuD05iSi38IdNlrRLPxw5/nOq4/6TlxrmBwT
         S/fTRQnqik+47U3THNF8qImKRmlQbdt2+MSeUr/st6gYVYgHMYgfcMF1q9BNTHxvatSL
         Up1g==
X-Gm-Message-State: AOJu0YwNr2SRHsY2Q59XDFalPeZinsb2Fb/qL4EM0E2dfauQePEE5vL+
        ZHdQJloIHWO6GNUmUNi1Lj6rzAh2rswDn3DvvqI=
X-Google-Smtp-Source: AGHT+IG3SmBgVgZZJ5iJ7L/Ga7w0g/7ztmL7VNHiAqZIQ8zO3HOGSRNBtLv27Eam03BPW7kg9b1sOA==
X-Received: by 2002:a7b:c414:0:b0:402:fe6d:6296 with SMTP id k20-20020a7bc414000000b00402fe6d6296mr4102677wmi.9.1694678550109;
        Thu, 14 Sep 2023 01:02:30 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id t7-20020a1c7707000000b003fedcd02e2asm1233317wmi.35.2023.09.14.01.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:02:29 -0700 (PDT)
Date:   Thu, 14 Sep 2023 10:02:28 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Haibo Xu <haibo1.xu@intel.com>,
        Anup Patel <anup@brainfault.org>
Subject: Re: [PATCH] KVM: selftests: Assert that vasprintf() is successful
Message-ID: <20230914-d8d1bb0c3d71454c0a55f721@orel>
References: <20230914010636.1391735-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230914010636.1391735-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023 at 06:06:36PM -0700, Sean Christopherson wrote:
> Assert that vasprintf() succeeds as the "returned" string is undefined
> on failure.  Checking the result also eliminates the only warning with
> default options in KVM selftests, i.e. is the only thing getting in the
> way of compile with -Werror.
> 
>   lib/test_util.c: In function ‘strdup_printf’:
>   lib/test_util.c:390:9: error: ignoring return value of ‘vasprintf’
>   declared with attribute ‘warn_unused_result’ [-Werror=unused-result]
>   390 |         vasprintf(&str, fmt, ap);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~
> 

Oh, darn. My compilers didn't report that or I would have fixed it.

> Don't bother capturing the return value, allegedly vasprintf() can only
> fail due to a memory allocation failure.
> 
> Fixes: dfaf20af7649 ("KVM: arm64: selftests: Replace str_with_index with strdup_printf")
> Cc: Andrew Jones <ajones@ventanamicro.com>
> Cc: Haibo Xu <haibo1.xu@intel.com>
> Cc: Anup Patel <anup@brainfault.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> I haven't actually run the relevant tests, someone should probably do so on
> ARM and/or RISC-V to make sure I didn't do something stupid.

Done for both.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Tested-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew

> 
>  tools/testing/selftests/kvm/lib/test_util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 3e36019eeb4a..5d7f28b02d73 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -387,7 +387,7 @@ char *strdup_printf(const char *fmt, ...)
>  	char *str;
>  
>  	va_start(ap, fmt);
> -	vasprintf(&str, fmt, ap);
> +	TEST_ASSERT(vasprintf(&str, fmt, ap) >= 0, "vasprintf() failed");
>  	va_end(ap);
>  
>  	return str;
> 
> base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
> -- 
> 2.42.0.283.g2d96d420d3-goog
> 
