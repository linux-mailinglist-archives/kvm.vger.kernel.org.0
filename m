Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6436D257E
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 18:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjCaQ3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 12:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjCaQ3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 12:29:20 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB09E053
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:25:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5416d3a321eso225514377b3.12
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680279848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VGbystLMcrIZks9JQKgPUKUM6IG2Jn6AM0cO7Dt+QKY=;
        b=HxIpKRg/wPS2vuyroohj0mMisr+wK6l/g4Z2xDUG/6FwNvS1HLXOj/nS428GEpg0P0
         gdKLmg1qmQ64QwPvlMe5FnYAn02Fc8R0VSvTRJsQytakyyxgvXcZi3tDi+0Gfkd5Vyx7
         iCNJbzJn2CW29g879x4Z/i8kL3DkkyTqTU4o9xD8kF6mFLPrKjj9XaJMCULRGWTjlFC9
         fJ7r0LK/NOmvzf9W1z2dGuQNdYpoLpHLQzUawl+MmmmVMcjFO75ONQ8jZUqIA37noa/i
         INUdFQt/u5+LnT2btmLddCkcxG+TpZNDF5U7B9UJrFibYPFGPWyZJ7dsik1RvioOeMrz
         yUpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680279848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGbystLMcrIZks9JQKgPUKUM6IG2Jn6AM0cO7Dt+QKY=;
        b=GDjNCzpv8o3U+dZVN5+ulzcrZQLcDu/KVBZX5lGVCckb4XdZIaJj9RkghgTrjpx+2m
         DO9beelQamyE6fd1WBK5hrGF+2s2JTQqxeYnyMT5AG0Xgv7Z7upE83Si/OSRmqs1hqAQ
         1CvuZS87/iLepBqsrUDGf6/FGMfVcZClREplmduE3etMNBadCUPSLnhwV6e4e/hoeBwu
         luOTxF01VoNa5OtBXXx6usA59ynmUwHObWMrMiTr7v+7tKwkw8V18/jvZqQaxVbLuP5h
         K+TkgxRwT3pgk/Qbs8WvP7j/SBu86JtwESWDO73hFpA9hwEju3Hc/smB4m/7It0ZNV4U
         x+bg==
X-Gm-Message-State: AAQBX9epvb/Df7MdDHP6qo7TeX2Ecbh7ZiaPFPk7KLG8MnWtjb71plED
        LAoB56vVCCCtGKnhw+JZ/CEfzUfELug=
X-Google-Smtp-Source: AKy350ab2Lg7egx2duZTEm2B0pCz2u08hYS4RxgMvMYL2mMWHfJO4L1nrUgQACNpj4M/C96iiMpUK3Wh+qc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bb85:0:b0:b7c:1144:a708 with SMTP id
 y5-20020a25bb85000000b00b7c1144a708mr11615178ybg.12.1680279848281; Fri, 31
 Mar 2023 09:24:08 -0700 (PDT)
Date:   Fri, 31 Mar 2023 09:24:06 -0700
In-Reply-To: <20230331135709.132713-4-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230331135709.132713-1-minipli@grsecurity.net> <20230331135709.132713-4-minipli@grsecurity.net>
Message-ID: <ZCcJJoe2OhReyV7X@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/4] x86/access: Forced emulation support
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 31, 2023, Mathias Krause wrote:
> Add support to enforce access tests to be handled by the emulator, if
> supported by KVM. Exclude it from the ac_test_exec() test, though, to
> not slow it down too much.

/enthusiastic high five

I was going to ask if you could extend the test to utilize FEP, and woke up this
morning to see it already done.  Thanks!!!!!

> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---

...

> @@ -152,6 +161,7 @@ const char *ac_names[] = {
>  	[AC_CPU_CR0_WP_BIT] = "cr0.wp",
>  	[AC_CPU_CR4_SMEP_BIT] = "cr4.smep",
>  	[AC_CPU_CR4_PKE_BIT] = "cr4.pke",
> +	[AC_FEP_BIT] = "fep",
>  };
>  
>  static inline void *va(pt_element_t phys)
> @@ -190,6 +200,7 @@ typedef struct {
>  
>  static void ac_test_show(ac_test_t *at);
>  
> +static bool fep_available;

I don't think fep_available needs to be captured in a global bool, the usage in
the CR0_WP test can do

	if (invalid_mask & AC_FEP_MASK)
		<skip>
