Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1CA58832D
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 22:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbiHBUlz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 16:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbiHBUlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 16:41:53 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BF3419B8
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 13:41:52 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id m2so7744900pls.4
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 13:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=7xjDDxxQfmpPBRCybHCm4DRLSoGvc3iJ8H4E+bKdArs=;
        b=S5F3BoeiU3pIgieJm7tPYwmfI2c3ectAi8d42PqNel0HnNhYhErUwT5BAmb/fzEKEi
         FvFZWHs36QcJZslB9nqGhYh/agHCeuzBL4n1ZxZYN161kRJIfPMd+m9h37HIsEl7DK1b
         g1HpD03yDCm63xdDUeLIce0iP528JROijLMhW+elmXScE/8ITw/SdW9Motm5keeSsczR
         lXPMo80XBAm2wCdaL5QBO/g3hekqgcwbPaGSgpjdmzj4+PaBr8w8DlFYVIbM4mz/qGl8
         ZnIgOshFpTLEg7qhMorTG7g8veGHLEDt9Jvj+aJOWLYcX0BKLOTsZQEl9NTyo2bGiv59
         OyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=7xjDDxxQfmpPBRCybHCm4DRLSoGvc3iJ8H4E+bKdArs=;
        b=i1H4jRYcGvgCMug2hF9LnYl1vWZtuGGto25/YpozecxHRdbSic3kir2vYsRy5G/X7P
         YacUeHuV+ZR4NCOshRq+ygD9Xhqj460id05kEUFZ+uy9S7+i4lKZECaiKe4ksW9/OXna
         J7vGpIR3tYO74hfzCSfg966TjHCjA9iw+8e8fb8f9Ih8EaOItfQ9Dx73fBS203rCb6ha
         9vgdTeERL8i0jcsU7BS8QcwSGFyDFF0vJPjDpplit7lCzRk3VZUyNCPBEXxJvFDzf+Sd
         PNpmPQIZ8XF4aQSkOypFcwR+UDqT9TfvFQloC5pLsuX8qflmy0AiYpXjD2LrhD8k3hDc
         SuVQ==
X-Gm-Message-State: ACgBeo2dbx64Q9Ey28n0axZyC9UM+JDRPbj0Pko4LysQ8lSkVgxNPAnw
        9Tv55+LyZmQ3xnS3qGy/TyNqig==
X-Google-Smtp-Source: AA6agR7Esp9V/xSixJU0GIppBkpwBozYA62W2tbkie+LTzK5g/cnP+vn6prpyO1dfif5XbSGomujjg==
X-Received: by 2002:a17:903:328e:b0:16e:fa5f:37ae with SMTP id jh14-20020a170903328e00b0016efa5f37aemr7981059plb.148.1659472911326;
        Tue, 02 Aug 2022 13:41:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b9-20020a63cf49000000b0040cb1f55391sm7349850pgj.2.2022.08.02.13.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 13:41:50 -0700 (PDT)
Date:   Tue, 2 Aug 2022 20:41:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] X86: Set up EPT before running
 vmx_pf_exception_test
Message-ID: <YumMC1hAVpTWLmap@google.com>
References: <20220715113334.52491-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715113334.52491-1-yu.c.zhang@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 15, 2022, Yu Zhang wrote:
> Although currently vmx_pf_exception_test can succeed, its
> success is actually because we are using identical mappings
> in the page tables and EB.PF is not set by L1. In practice,
> the #PFs shall be expected by L1, if it is using shadowing
> for L2.

I'm a bit lost.  Is there an actual failure somewhere?  AFAICT, this passes when
run as L1 or L2, with or without EPT enabled.

> So just set up the EPT, and clear the EB.PT, then L1 has the
> right to claim a failure if a #PF is encountered.
> 
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>  x86/vmx_tests.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 4d581e7..cc90611 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -10639,6 +10639,17 @@ static void __vmx_pf_exception_test(invalidate_tlb_t inv_fn, void *data)
>  
>  static void vmx_pf_exception_test(void)
>  {
> +	u32 eb;
> +
> +	if (setup_ept(false)) {
> +		printf("EPT not supported.\n");
> +		return;
> +	}
> +
> +	eb = vmcs_read(EXC_BITMAP);
> +	eb &= ~(1 << PF_VECTOR);
> +	vmcs_write(EXC_BITMAP, eb);
> +
>  	__vmx_pf_exception_test(NULL, NULL);
>  }
>  
> -- 
> 2.25.1
> 
