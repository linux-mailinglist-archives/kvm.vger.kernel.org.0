Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C6A5016A3
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 17:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244871AbiDNPI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 11:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354784AbiDNOmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 10:42:37 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F3FBF75
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 07:39:36 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id h15-20020a17090a054f00b001cb7cd2b11dso5840528pjf.5
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 07:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gJ8pcz3Yaw1gKMnr6f7nkiOA+qMs14RS4sjJplU0gjM=;
        b=R4JJPAxBiFl6PYRwZGRkCFzqF4VwdjE3sCH/tcEdYlbUlKE40ftv4JdLWisRcFdYD+
         ZLPXO8yK68lWcdip9fPvd539XPVr0LDMwcHJYld7xq+NTMqK4zO/fBnRDPY4ReezcpiT
         JdwrQMgNMvGbpSuS30JR74qg3aQuKtF2S2RQYN1PhbM0k3BNLsaBiv45OV5UWZagEa4u
         Jr/VESJVUOAcZAQr/ZCswkJRgxe1UdqlQiNNfmilwIZIwDOp5tfmoIHRHxAvjoNxXnN+
         EQ1InC2XexhkzFjVnN9GiHdeciEeyR+KRFdB1lWMlL1esYJgtlNQfvZN9wS2wH7Tk5On
         Io6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gJ8pcz3Yaw1gKMnr6f7nkiOA+qMs14RS4sjJplU0gjM=;
        b=olGC5ombSv2X+Jh+3+1EhV+x7nlguuMox652s8FOsuDiU9K3LeUqvd/62k50JGxU5u
         NhSON3ldclosoW5qu6x2pbJ3rUPGINKmT0UL4rzmEpRLUa+iCzZXPsVl9ByO8yAOFHAE
         edYFHUOeTXqKeLGJb6/ZZ3Yf26ECWtaRiVBPf6xgj7oESFpWyfz9dPI7U7bmrtgs1Quk
         CHybMJIbecHPzrD4dBK3hd2KG0OIi2sX7oiSjtyF+DHF9ExIZaco9Tgu6CYGMpYnI7Uw
         AyMTNQTeXnys2gNojo0a3gPmy5JWtvICZlhe+F117/22b5XhMEkeTCx+VzMDLM9zG+li
         ZW/w==
X-Gm-Message-State: AOAM532UQOpyHoIAj5dnWPMr7Gd7wtcGmqhPtyXWXWRtx8K7orZy+4MB
        TR7r1wtWxrJaIT91foeOa3vUienGn8R77w==
X-Google-Smtp-Source: ABdhPJyQhgIYo4iouGyYUQ+Q7Nt/zlHN4/wmdz2jjSvmkYXLB9lHmvXGarXlMm7Az348QWDplNeaIw==
X-Received: by 2002:a17:903:110c:b0:14d:8859:5c8 with SMTP id n12-20020a170903110c00b0014d885905c8mr47115691plh.156.1649947176324;
        Thu, 14 Apr 2022 07:39:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a0026ca00b004fb44e0cb17sm178299pfw.116.2022.04.14.07.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 07:39:35 -0700 (PDT)
Date:   Thu, 14 Apr 2022 14:39:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: make read-only const array vmx_uret_msrs_list
 static
Message-ID: <YlgyJPRVNCe4w8q3@google.com>
References: <20220414100720.295502-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414100720.295502-1-colin.i.king@gmail.com>
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

On Thu, Apr 14, 2022, Colin Ian King wrote:
> Don't populate the read-only array vmx_uret_msrs_list on the stack
> but instead make it static. Also makes the object code a little smaller.

Why not put it on the stack?  It's an __init function, i.e. called once in the
lifetime of kvm-intel.ko, isn't all that big, and is certainly not performance
critical.  And making it static begs the question of whether or not the data gets
thrown away after init, i.e. this might consume _more_ memory once KVM has reached
steady state.

> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c654c9d76e09..36429e2bb918 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7871,7 +7871,7 @@ static __init void vmx_setup_user_return_msrs(void)
>  	 * but is never loaded into hardware.  MSR_CSTAR is also never loaded
>  	 * into hardware and is here purely for emulation purposes.
>  	 */
> -	const u32 vmx_uret_msrs_list[] = {
> +	static const u32 vmx_uret_msrs_list[] = {
>  	#ifdef CONFIG_X86_64
>  		MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
>  	#endif
> -- 
> 2.35.1
> 
