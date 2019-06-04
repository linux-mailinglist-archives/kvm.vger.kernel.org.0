Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCF134EA7
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfFDRWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:22:17 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42481 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfFDRWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:22:16 -0400
Received: by mail-wr1-f67.google.com with SMTP id o12so9567410wrj.9
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+KH/ekFO6lMki0C/5utaD2khaP3c08rUkCg6NOoTPRA=;
        b=jSPqYIkM456c1fSZk0gR8mShOlCLU670u/X14RyH8uOzYACWDfAcYDh9h5tgfYbhNA
         M0+YMHDuMsNDnUajqxkQxvGJIm2ehIqWV1mxKrcU/7kmyJ42aJJMtD4gJmTMCtFC8fXL
         kQwRI2nCPiRGmDxIZ9xQzQcUICLJvSKWVM8XiqGN1K/K7BMope1sC4vdrf7XcxJRLVHt
         IY8wn+3ovly7xL9ZoVmVmlLhRUCjuE0/kQf1r545b3JG62Dw6k6XtpSrxtnlx9uPuU+h
         XAuoU9X5AYWE32Qn16gIlPLpqVklXTEMSHbPd8u7JEktEzZwZwOB7dIYYS9EZ+RCwYL1
         06bw==
X-Gm-Message-State: APjAAAW1WJg8KazADk0ni4FppWLem9vLMStldOkMgG11S62Wx+NEp3+i
        KB3VT9PS62yWn+W1maZy71tjXuK7E4G5Tg==
X-Google-Smtp-Source: APXvYqzSrOfwtYcDUlgfDPuhUIMQCCYSSA0yqDnIxz7VWMjHRgisWBJ06fJbkhfNlbhzW/DGmnbeQw==
X-Received: by 2002:a5d:5189:: with SMTP id k9mr7149379wrv.329.1559668934999;
        Tue, 04 Jun 2019 10:22:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id 135sm7537958wmb.28.2019.06.04.10.22.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:22:14 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: remove unneeded 'asm volatile ("")' from
 vmcs_write64
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
References: <20190602191156.1101-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <12b39f5c-d02f-1abc-1820-5595a8548ca5@redhat.com>
Date:   Tue, 4 Jun 2019 19:22:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190602191156.1101-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/06/19 21:11, Uros Bizjak wrote:
> __vmcs_writel uses volatile asm, so there is no need to insert another
> one between the first and the second call to __vmcs_writel in order
> to prevent unwanted code moves for 32bit targets.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/vmx/ops.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
> index b8e50f76fefc..2200fb698dd0 100644
> --- a/arch/x86/kvm/vmx/ops.h
> +++ b/arch/x86/kvm/vmx/ops.h
> @@ -146,7 +146,6 @@ static __always_inline void vmcs_write64(unsigned long field, u64 value)
>  
>  	__vmcs_writel(field, value);
>  #ifndef CONFIG_X86_64
> -	asm volatile ("");
>  	__vmcs_writel(field+1, value >> 32);
>  #endif
>  }
> 

Queued, thanks.

Paolo
