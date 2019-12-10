Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46144118F07
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 18:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfLJRbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 12:31:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20492 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727516AbfLJRbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 12:31:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575999062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KPiYgRrVUK4mpgLmiCk8waG0ovOsvvI/iTIjqjQJdOU=;
        b=VHrYKIa/jWPKQCyZ7e3VHxWO9B4JhhKT4I+EM+Pf0glFalchuK5ue76OLw47bbU14ontkK
        TBzj6BitSweR9iBwqWnc/GEsyJf+Whi4fFophFE5OoVgR8s3VvpQmE2C1MraXD0Bc8RLF9
        RnjJGSX8sEErS/DISNTPkHKlZ6M1t9c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-1ecC8R_APM2w1ypE8Ot75A-1; Tue, 10 Dec 2019 12:31:00 -0500
Received: by mail-wm1-f69.google.com with SMTP id 7so835954wmf.9
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 09:31:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KPiYgRrVUK4mpgLmiCk8waG0ovOsvvI/iTIjqjQJdOU=;
        b=gd0HBQ8Sipv+lFLgy9O/Jk3ro78i2pJ0n3MujbImFE1DaQFL3/VqrXzBXRaDtUfXdp
         gf25l6NnoR7SsxafYd6i9DggjCA8+InegzJiBSRU7uVJryBK44mELXfc/m9cpRiMQpYh
         TgQtJxLTnPbTHfrzHBeSp1RklDYwJvWVplZI5wS9fBbYokkgooX2dyF9/TGnqTL5qeTh
         5oR/x+cmIxu7DB1iqTbWa1ENOJi/jTnyQepma2kIiZExMt2Z0+h7vCYOzowBjn1SxUCa
         /vTxz+LU9HUvLhcajhkbo2QshabZf3b8hWRmV8QoH3OPP9KmYkjAWxhuT+7ADPq+Mjlz
         oGiA==
X-Gm-Message-State: APjAAAUtq2fEiMpE4ru9CBOQfEu+P0+3avH0doNuYe51YRLkwBzT6oxT
        5hgFx/ssKbLlWEHy/IT34IRnkwOtcSaGpRzUJwDUX/D3L+gYvmI164WO2loyYJgcq7METY5wFbp
        GIne8Z5ORRQLU
X-Received: by 2002:a05:600c:21c5:: with SMTP id x5mr6275738wmj.72.1575999059591;
        Tue, 10 Dec 2019 09:30:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqxbsrSfssSog453UJKeQJi6kdTcX3K/jvZ1cpYRR+ptHDYaNf3jkpN5Y5MNq9hBr1oaoBmnNw==
X-Received: by 2002:a05:600c:21c5:: with SMTP id x5mr6275701wmj.72.1575999059322;
        Tue, 10 Dec 2019 09:30:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id y139sm4133182wmd.24.2019.12.10.09.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 09:30:58 -0800 (PST)
Subject: Re: [PATCH 1/4] KVM: nVMX: Check GUEST_SYSENTER_ESP and
 GUEST_SYSENTER_EIP on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com
References: <20191206231302.3466-1-krish.sadhukhan@oracle.com>
 <20191206231302.3466-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8755e710-20d1-da11-0df6-2f0d94f0c0b3@redhat.com>
Date:   Tue, 10 Dec 2019 18:30:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191206231302.3466-2-krish.sadhukhan@oracle.com>
Content-Language: en-US
X-MC-Unique: 1ecC8R_APM2w1ypE8Ot75A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/19 00:12, Krish Sadhukhan wrote:
> According to section "Checks on Guest Control Registers, Debug Registers, and
> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
> of nested guests:
> 
>     "The IA32_SYSENTER_ESP field and the IA32_SYSENTER_EIP field must each
>      contain a canonical address."
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0e7c9301fe86..a2d1c305a7d8 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2770,6 +2770,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  	    CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
>  		return -EINVAL;
>  
> +	if (CC(!is_noncanonical_address(vmcs12->guest_sysenter_esp)) ||
> +	    CC(!is_noncanonical_address(vmcs12->guest_sysenter_eip)))
> +		return -EINVAL;

This should not be negated.

That said, the new tests pass even without this check, and that's not
surprising since the MSRs are passed through to the vmcs02 directly.

Paolo

>  	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
>  	    CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))
>  		return -EINVAL;
> 

