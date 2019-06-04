Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339D734E99
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfFDRUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:20:10 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46150 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFDRUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:20:10 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so11423741wrw.13
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:20:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EWKVf946mEo/oyXIfSAbG9mTl6hfbEVRS3WPIZRQKV8=;
        b=bWlN8A+atFHy16Lgsi8E18GJ9WF0kWvtdtDr24n/d29LH68LWJhXefeF0oQt7n6x+m
         ZgBxImolmfP8a9qDY8oUZ8CEItidKnQkQKSsf+yoU8BnShwD9vMSeW4KjjPyw6hXgnbn
         2BoTuWS/6VnHTePoyAwHYgkQQvs1XoIiqpc1fKCmeYYSd+FRaLreryhde0k7c1XnyuXg
         wtCw26fT6C2nfIuYGqPV3hVgGzQ7ocal6ycwqW4/NTIo5TixklimbGa59KI91Hbgs0h1
         Ws6ZJEXMJiAcoSA3H8FOoWbnadLfG/ljrEssKxOVmmRiUjgCdF4GXrIXAh4+9N5hRk2h
         Ev0Q==
X-Gm-Message-State: APjAAAUY8rpy/vkbfxFh93zoyTz46lcDjkpLTrLNqpW5cbuudUdRwQjo
        K4cxzGcYpU1mjbjOpVC1cfsw3CNAEUZAYQ==
X-Google-Smtp-Source: APXvYqwhzqIp4GOnRWlSAKtSmB9j+eyMBSR5idH/RxAK+mF47fCdpKb6CpoC9tiz/7jwmRyCBkRWzw==
X-Received: by 2002:adf:f312:: with SMTP id i18mr7109864wro.300.1559668808820;
        Tue, 04 Jun 2019 10:20:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id y5sm2500083wrs.63.2019.06.04.10.20.07
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:20:08 -0700 (PDT)
Subject: Re: [PATCH] x86/kvm/VMX: drop bad asm() clobber from
 nested_vmx_check_vmentry_hw()
To:     Jan Beulich <JBeulich@suse.com>, Radim Krm <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>
References: <5CEBA3B80200007800232856@prv1-mh.provo.novell.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c53e4040-91b6-c4c8-133a-cba5d3cf242f@redhat.com>
Date:   Tue, 4 Jun 2019 19:20:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5CEBA3B80200007800232856@prv1-mh.provo.novell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/19 10:45, Jan Beulich wrote:
> While upstream gcc doesn't detect conflicts on cc (yet), it really
> should, and hence "cc" should not be specified for asm()-s also having
> "=@cc<cond>" outputs. (It is quite pointless anyway to specify a "cc"
> clobber in x86 inline assembly, since the compiler assumes it to be
> always clobbered, and has no means [yet] to suppress this behavior.)
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2781,7 +2781,7 @@ static int nested_vmx_check_vmentry_hw(s
>  		[launched]"i"(offsetof(struct loaded_vmcs, launched)),
>  		[host_state_rsp]"i"(offsetof(struct loaded_vmcs, host_state.rsp)),
>  		[wordsize]"i"(sizeof(ulong))
> -	      : "cc", "memory"
> +	      : "memory"
>  	);
>  
>  	if (vmx->msr_autoload.host.nr)
> 
> 

Queued, thanks.

Paolo
