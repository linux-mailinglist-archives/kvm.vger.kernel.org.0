Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5228C613C62
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 18:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiJaRnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 13:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiJaRnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 13:43:01 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF42013CF9
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 10:43:00 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id g24so11394247plq.3
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 10:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZcNKklRqNOZIzzN6/3ZLoVJI0v8lu05LuofxUAi4FAA=;
        b=n/9114iiJT3Pb6g1KtiouPIirIqiDc/eV5IIPiIcTg8fl0V6CgUavesyYzghkf5lJg
         XRTzRh2OORGLhn98zDg8DaP7P3AWwWPKDU6Xm7YdBURTEY4C+AVNRNbSTxtJy2kD7CsG
         SSSZwqzqGiJc45v7gN8pGDB9bsqM93vai29dolS+crS4a3COZlqo/8Yy4/CkUFdcH+QS
         2KDWviWZtNk3pKVthPEURNZDTttgUqWq55/E1Z2FhLgNIUEVu/pXPqpFr8FBExnoQKG7
         DmeynWvrJLJ8mzZHN8AMX+ylVP1/QxymldPAuGimj146L996gP+lVqOSzYcDoXBT9N4w
         x4zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZcNKklRqNOZIzzN6/3ZLoVJI0v8lu05LuofxUAi4FAA=;
        b=YosAUou6PwFJt73uKUMcnhGHiY5KnXuhhxhTb22OKICD/X8WFO8QGK6E8gZZg7snWy
         KsoDzkOEEUd15bgv00Qf7wUIvvMbsZQZDSQSuR6jGZiszYO2uHtGC8lCTWTRY8t3Zrg9
         ClRHh5F/1rTsRzQk2X788y7p/cH72oyl7gvg/KqVU7/NYlPw38YPvf7rvhOuEA4G1JIs
         kK1P/9Zo9g959HrIFRL41YIVDrlRLdsOdyNPKG2UBNfPaWpQQ1pDkGwsPYeWfA3AeyXO
         oowVrmjwAplEHLA7LEF/udq53esxXZmIcl2Y1tDK7Mq+5X2m8tdtiy+7aBbcqku8F8dZ
         yrng==
X-Gm-Message-State: ACrzQf3YfrOLL0LHE/ooXV5cQpiVn95qwX0UJzwBoriBsxVi+H+bz/n8
        OD/rX08sTbtMGJZdRSAJfmZN5Q==
X-Google-Smtp-Source: AMsMyM6XPFkXrXlfhshI1TQUoZ5vICWxCazRkuzHGlkQo7L8wq34j2LDDHmzG62n4sTJwVOcVlOL5g==
X-Received: by 2002:a17:90b:38cf:b0:212:d06c:9489 with SMTP id nn15-20020a17090b38cf00b00212d06c9489mr32354595pjb.220.1667238180313;
        Mon, 31 Oct 2022 10:43:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902c60a00b0017f48a9e2d6sm4700484plr.292.2022.10.31.10.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 10:42:59 -0700 (PDT)
Date:   Mon, 31 Oct 2022 17:42:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix undefined behavior in bit shift for
 __feature_bit
Message-ID: <Y2AJIFQlF5C0ozoU@google.com>
References: <20221031113638.4182263-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031113638.4182263-1-cuigaosheng1@huawei.com>
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

On Mon, Oct 31, 2022, Gaosheng Cui wrote:
> Shifting signed 32-bit value by 31 bits is undefined, so changing
> significant bit to unsigned. The UBSAN warning calltrace like below:
> 
> UBSAN: shift-out-of-bounds in arch/x86/kvm/reverse_cpuid.h:101:11
> left shift of 1 by 31 places cannot be represented in type 'int'

PeterZ is contending that this isn't actually undefined behavior given how the
kernel is compiled[*].  That said, I would be in favor of replacing the open-coded
shift with BIT() to make the code a bit more self-documenting, and that would
naturally fix this maybe-undefined-behavior issue. 

[*] https://lore.kernel.org/all/Y1%2FAaJOcgIc%2FINtv@hirez.programming.kicks-ass.net

> ---
>  arch/x86/kvm/reverse_cpuid.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index a19d473d0184..ebd6b621d3b8 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -98,7 +98,7 @@ static __always_inline u32 __feature_bit(int x86_feature)
>  	x86_feature = __feature_translate(x86_feature);
>  
>  	reverse_cpuid_check(x86_feature / 32);
> -	return 1 << (x86_feature & 31);
> +	return 1U << (x86_feature & 31);
>  }
>  
>  #define feature_bit(name)  __feature_bit(X86_FEATURE_##name)
> -- 
> 2.25.1
> 
