Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED72267490
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 19:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfGLRqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 13:46:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43115 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbfGLRp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 13:45:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so10770858wru.10
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2019 10:45:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5AAY/XLB5sNM5xu1cxB6MBuk0Q+am8e86PPXt5EsGZI=;
        b=PXh/7B7OFm4Vs7npD7cPcryfOTaRhVc07U5vTQ5yDlYo+r5FIES14RcFfCjO4B4e9z
         OYnzXyz/LJ3vNRRrXedlQjb736P6HQ73DShVSgmvspihDPH1c1IKimtZ1vJRPssZtEqr
         3xkDnTGbA6TRToqKg3N0SzY1x1Ejlf+L0BgQ/eUX6l4CodzmBPh4iEXYGNQ0PbixHIjb
         bzbP/T3N69CNgmO3eS/tEOnOrf4AyUc7C8vYvyaoaTqbPvytv6QVl0KIfT8Wtp+IEClD
         6NLPNQ10FQy0Ji/qSJxFz2Wg7jRPB3pP/m9rYzDisLyWe8sSw/nYVfprAqRBH3AS467y
         F2Dg==
X-Gm-Message-State: APjAAAXstrcHICOjXVbTro6msILde1KlcsncwzH2WHTPnyntXOhtp63o
        5QcVO3/AuVUMCM+LfBdBPphKhQ==
X-Google-Smtp-Source: APXvYqztfm0GMtUN0DWOYu24qfN1n1ZjFz8nEz/A1BvDT3bf6OdkVwRupsDeRYQC+wLyk5PLJd+Npg==
X-Received: by 2002:adf:a299:: with SMTP id s25mr5567669wra.74.1562953557279;
        Fri, 12 Jul 2019 10:45:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id y1sm7470474wma.32.2019.07.12.10.45.56
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 10:45:56 -0700 (PDT)
Subject: Re: [PATCH] [v3] x86: kvm: avoid -Wsometimes-uninitized warning
To:     Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Liran Alon <liran.alon@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20190712141322.1073650-1-arnd@arndb.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e85f877e-7c1c-7c9d-40c0-b41ac0fc68d6@redhat.com>
Date:   Fri, 12 Jul 2019 19:45:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712141322.1073650-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/07/19 16:13, Arnd Bergmann wrote:
> Clang notices a code path in which some variables are never
> initialized, but fails to figure out that this can never happen
> on i386 because is_64_bit_mode() always returns false.
> 
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'ingpa' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>         if (!longmode) {
>             ^~~~~~~~~
> arch/x86/kvm/hyperv.c:1632:55: note: uninitialized use occurs here
>         trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgpa);
>                                                              ^~~~~
> arch/x86/kvm/hyperv.c:1610:2: note: remove the 'if' if its condition is always true
>         if (!longmode) {
>         ^~~~~~~~~~~~~~~
> arch/x86/kvm/hyperv.c:1595:18: note: initialize the variable 'ingpa' to silence this warning
>         u64 param, ingpa, outgpa, ret = HV_STATUS_SUCCESS;
>                         ^
>                          = 0
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'outgpa' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> arch/x86/kvm/hyperv.c:1610:6: error: variable 'param' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> 
> Flip the condition around to avoid the conditional execution on i386.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v3: reword commit log, simplify patch again
> v2: make the change inside of is_64_bit_mode().
> ---
>  arch/x86/kvm/hyperv.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index a39e38f13029..c10a8b10b203 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1594,7 +1594,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	u64 param, ingpa, outgpa, ret = HV_STATUS_SUCCESS;
>  	uint16_t code, rep_idx, rep_cnt;
> -	bool fast, longmode, rep;
> +	bool fast, rep;
>  
>  	/*
>  	 * hypercall generates UD from non zero cpl and real mode
> @@ -1605,9 +1605,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  		return 1;
>  	}
>  
> -	longmode = is_64_bit_mode(vcpu);
> -
> -	if (!longmode) {
> +#ifdef CONFIG_X86_64
> +	if (is_64_bit_mode(vcpu)) {
> +		param = kvm_rcx_read(vcpu);
> +		ingpa = kvm_rdx_read(vcpu);
> +		outgpa = kvm_r8_read(vcpu);
> +	} else
> +#endif
> +	{
>  		param = ((u64)kvm_rdx_read(vcpu) << 32) |
>  			(kvm_rax_read(vcpu) & 0xffffffff);
>  		ingpa = ((u64)kvm_rbx_read(vcpu) << 32) |
> @@ -1615,13 +1620,6 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  		outgpa = ((u64)kvm_rdi_read(vcpu) << 32) |
>  			(kvm_rsi_read(vcpu) & 0xffffffff);
>  	}
> -#ifdef CONFIG_X86_64
> -	else {
> -		param = kvm_rcx_read(vcpu);
> -		ingpa = kvm_rdx_read(vcpu);
> -		outgpa = kvm_r8_read(vcpu);
> -	}
> -#endif
>  
>  	code = param & 0xffff;
>  	fast = !!(param & HV_HYPERCALL_FAST_BIT);
> 

Queued, thanks.

Paolo
