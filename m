Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE66C4CD8F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 14:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731837AbfFTMSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 08:18:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38453 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730886AbfFTMSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 08:18:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so2812379wrs.5
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 05:18:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YOyay7L+Ug00icQt9/AuolC+PTU/k20bZjxiFL/LzXw=;
        b=OnJPUV3iENe2WpAi2z4/mp4yRLDB0ke+uIs15hrBvyZp/496ADE1NB4n/K9VbvEvrc
         c9pxCnb9OiBwmQ4qSkaiKl2k0XgFQBQ8qcQVbvnClZAJLrPkJI8Y6sDspxzBePjdsUOF
         DJx0F6JVN7NMWVXL/FGenJGB6FkFeuwIJTbCOBAJzYDBbd3L8IhgrRQvtTXkD7eparCo
         h6ux5LI+7xpqLkXMSFNsBLHCL0d1otEeTGPdR4lVk5qhRD5moMSojyL+4Q6S7eUKDmTG
         bLRTk6F+fRp9N8mnSJm3RYLQkJ3egvJnDcFlHLDIyRxAn4WqAqCxSE21EOfX0gM8oPgw
         wZQw==
X-Gm-Message-State: APjAAAXCGeSaORSRjiTJCl5WkwK3PUZ19UB2RO2BbC+pqBjjpWvI5xvf
        AvGp8dY2iYyyNlSM5Q1M56bZTw==
X-Google-Smtp-Source: APXvYqynay/wtRGlHY6FX1KkqdtL1giCC9W9+5OV9fapZCTz3X+ZA5NlxK69UqxLBRK68aPNscyTPg==
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr4144690wrx.39.1561033126353;
        Thu, 20 Jun 2019 05:18:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7822:aa18:a9d8:39ab? ([2001:b07:6468:f312:7822:aa18:a9d8:39ab])
        by smtp.gmail.com with ESMTPSA id r4sm45526075wra.96.2019.06.20.05.18.45
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 05:18:45 -0700 (PDT)
Subject: Re: [PATCH RFC 4/5] x86: KVM: add xsetbv to the emulator
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
References: <20190620110240.25799-1-vkuznets@redhat.com>
 <20190620110240.25799-5-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a86ca8b7-0333-398b-7bf6-90cb79366226@redhat.com>
Date:   Thu, 20 Jun 2019 14:18:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190620110240.25799-5-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/06/19 13:02, Vitaly Kuznetsov wrote:
> To avoid hardcoding xsetbv length to '3' we need to support decoding it in
> the emulator.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Can you also emulate it properly?  The code from QEMU's
target/i386/fpu_helper.c can help. :)

Paolo

> ---
>  arch/x86/include/asm/kvm_emulate.h | 1 +
>  arch/x86/kvm/emulate.c             | 9 ++++++++-
>  arch/x86/kvm/svm.c                 | 1 +
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
> index feab24cac610..478f76b0122d 100644
> --- a/arch/x86/include/asm/kvm_emulate.h
> +++ b/arch/x86/include/asm/kvm_emulate.h
> @@ -429,6 +429,7 @@ enum x86_intercept {
>  	x86_intercept_ins,
>  	x86_intercept_out,
>  	x86_intercept_outs,
> +	x86_intercept_xsetbv,
>  
>  	nr_x86_intercepts
>  };
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index d0d5dd44b4f4..ff25d94df684 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4393,6 +4393,12 @@ static const struct opcode group7_rm1[] = {
>  	N, N, N, N, N, N,
>  };
>  
> +static const struct opcode group7_rm2[] = {
> +	N,
> +	DI(SrcNone | Priv, xsetbv),
> +	N, N, N, N, N, N,
> +};
> +
>  static const struct opcode group7_rm3[] = {
>  	DIP(SrcNone | Prot | Priv,		vmrun,		check_svme_pa),
>  	II(SrcNone  | Prot | EmulateOnUD,	em_hypercall,	vmmcall),
> @@ -4482,7 +4488,8 @@ static const struct group_dual group7 = { {
>  }, {
>  	EXT(0, group7_rm0),
>  	EXT(0, group7_rm1),
> -	N, EXT(0, group7_rm3),
> +	EXT(0, group7_rm2),
> +	EXT(0, group7_rm3),
>  	II(SrcNone | DstMem | Mov,		em_smsw, smsw), N,
>  	II(SrcMem16 | Mov | Priv,		em_lmsw, lmsw),
>  	EXT(0, group7_rm7),
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index f980fc43372d..39e61029f401 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6041,6 +6041,7 @@ static const struct __x86_intercept {
>  	[x86_intercept_ins]		= POST_EX(SVM_EXIT_IOIO),
>  	[x86_intercept_out]		= POST_EX(SVM_EXIT_IOIO),
>  	[x86_intercept_outs]		= POST_EX(SVM_EXIT_IOIO),
> +	[x86_intercept_xsetbv]		= PRE_EX(SVM_EXIT_XSETBV),
>  };
>  
>  #undef PRE_EX
> 

