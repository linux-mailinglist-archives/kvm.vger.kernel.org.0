Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800D8EFAE8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 11:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388475AbfKEKW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 05:22:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388465AbfKEKW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 05:22:57 -0500
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9606683F40
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 10:22:56 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id c2so5455637wrt.1
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 02:22:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w1BCAZKLINDOJhskICvqC++S8PHHqkR0cjyYqMXwaWg=;
        b=cdYI9uLcDjdjVj30duu3jOm2XcD3w4+5dtOWciibrJJ9vssj77RzJgJzOU5vsrOzha
         un+H+r+i015po/kWPDRks7xeEyvJvNaoRmAeisWm2wer95liyNqlepjiqxj2gPqAoiq2
         DAmTt0YnJB+apJv98FwpqWDPFM86zMh6uEqpjVJm1wyANtkgt0iVywgGjwhM91Cj8PTm
         dJX2p9EutxhFNfK5CGDKJZ0l4EdZ3MyqfpBI3UOzk8MpIfPgczThO+qlagwIV6cTm+3w
         ByGnoIo3qFH309SMCA/vgXPDsGg7gaJzxIpQ4AsIRQ1sWsOV6h4K3OxIEPPalCIgqWOr
         m7iQ==
X-Gm-Message-State: APjAAAWp/aMgOBoJQclaq5w8YoevjhfB3A9G9nhGydl9GlbNw3LRf5nl
        SSNCEw2u2D/r5oKqhm/iUuaeJoyhNmgKXqorJjJKDyERvbQJh3PsRMkozKzajLJpTi6JJJm5mRv
        D5XQPmTMGINQ5
X-Received: by 2002:a1c:f011:: with SMTP id a17mr3382571wmb.18.1572949375130;
        Tue, 05 Nov 2019 02:22:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqxoX5cZMXM5LMq0fy/rBwYBB0kKzDPvOVjvARwxEJRYK7Zjuvt1eg9SucU5CToGpBrEvSRuHA==
X-Received: by 2002:a1c:f011:: with SMTP id a17mr3382549wmb.18.1572949374830;
        Tue, 05 Nov 2019 02:22:54 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id s21sm29125029wrb.31.2019.11.05.02.22.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 02:22:54 -0800 (PST)
Subject: Re: [PATCH 11/13] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
To:     Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-12-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9a7d3134-b8eb-dfae-9c26-c21d3c1a1ea8@redhat.com>
Date:   Tue, 5 Nov 2019 11:20:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104230001.27774-12-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/19 23:59, Andrea Arcangeli wrote:
> It's enough to check the exit value and issue a direct call to avoid
> the retpoline for all the common vmexit reasons.
> 
> Of course CONFIG_RETPOLINE already forbids gcc to use indirect jumps
> while compiling all switch() statements, however switch() would still
> allow the compiler to bisect the case value. It's more efficient to
> prioritize the most frequent vmexits instead.
> 
> The halt may be slow paths from the point of the guest, but not
> necessarily so from the point of the host if the host runs at full CPU
> capacity and no host CPU is ever left idle.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a6afa5f4a01c..582f837dc8c2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5905,9 +5905,23 @@ int kvm_x86_handle_exit(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (exit_reason < kvm_vmx_max_exit_handlers
> -	    && kvm_vmx_exit_handlers[exit_reason])
> +	    && kvm_vmx_exit_handlers[exit_reason]) {
> +#ifdef CONFIG_RETPOLINE
> +		if (exit_reason == EXIT_REASON_MSR_WRITE)
> +			return kvm_emulate_wrmsr(vcpu);
> +		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
> +			return handle_preemption_timer(vcpu);
> +		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
> +			return handle_interrupt_window(vcpu);
> +		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> +			return handle_external_interrupt(vcpu);
> +		else if (exit_reason == EXIT_REASON_HLT)
> +			return kvm_emulate_halt(vcpu);
> +		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
> +			return handle_ept_misconfig(vcpu);
> +#endif
>  		return kvm_vmx_exit_handlers[exit_reason](vcpu);
> -	else {
> +	} else {
>  		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
>  				exit_reason);
>  		dump_vmcs();
> 

Queued, thanks.

Paolo
