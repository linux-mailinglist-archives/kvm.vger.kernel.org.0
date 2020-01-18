Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179D11419D9
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 22:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgARV1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 16:27:01 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46638 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726957AbgARV1B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 18 Jan 2020 16:27:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579382819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8SoUZ6kA7er6ACVnsGobCaUYtb3x9ncX9KA1N8TyDd4=;
        b=F1PUYjgDbsTuSVUar5XGz/CPISjqgacywQygboKIbVAVjXT/WlXuqbwAMhSnaW9RRgclSf
        BlLsAUq2MG09CN87+TkbPSV1hImTSr2gibzZ++bKHChf61Hgs6EmmNzdw+Sx1GQXOT9PP9
        7dNVpkcmyr4ulVremv6CCAQ4DPqqblw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-9Qap42a7O5GwRGoHQZeqQw-1; Sat, 18 Jan 2020 16:26:58 -0500
X-MC-Unique: 9Qap42a7O5GwRGoHQZeqQw-1
Received: by mail-wr1-f71.google.com with SMTP id z10so12044747wrt.21
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 13:26:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8SoUZ6kA7er6ACVnsGobCaUYtb3x9ncX9KA1N8TyDd4=;
        b=HixgWspzr2k3g7sN3Pt+wgI2s/tfPnenwiPw6S/wmJqumat8jTdE7HdLPMUkpPbe/5
         CldCleZN6TRD7bG2NK90S5dx8+sgLevIMwVXi9oC0v1Ic1/Y6pyPWONhdgt3uKXmQhuO
         iA0JyTfZtzj+geADpkL8e/p+sO5rNI4Q38RdaylUmJilKWY5oco9BWyzIo2HQTGfHQ9V
         RumVfUNZ7hcJm8e4xDCl1ZP63BOe2yXjQ+F0W7DANwGUTLl9fr7brOotOOXREMI8dmsx
         9X+xV2LGm/mDdBZDWz7KRSW2vIlvWnuopk6rYDi5xEkjszZnW9ZnrBCWzfYE63q4WVE2
         5zvw==
X-Gm-Message-State: APjAAAWXrgW03iRR4alfWKG30AMmDlY9N73CCh4huA6xkUnfE4Bp4ILS
        a9K2EAIwe3Q6xfELx7RqE1Q+i1x+VcO8b/AbHrb7RZyI2JciEKBowGoPjfDu+GoWkwGHnwFNuEF
        suRvGMV5DMM4K
X-Received: by 2002:adf:f1cb:: with SMTP id z11mr9782330wro.375.1579382816991;
        Sat, 18 Jan 2020 13:26:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqzKbULLGgSbmncb6Oa5ppPsxM+7ljn9oiaQFYP3SIq9dnDvmwsvpMGT53d5nrj7vu0BV4hrNw==
X-Received: by 2002:adf:f1cb:: with SMTP id z11mr9782315wro.375.1579382816773;
        Sat, 18 Jan 2020 13:26:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id i8sm41644376wro.47.2020.01.18.13.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 13:26:55 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: avoid clearing pending exception event twice
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1579315315-6444-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <58e9932a-99e7-33c3-d615-ee5f2ad766e8@redhat.com>
Date:   Sat, 18 Jan 2020 22:26:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1579315315-6444-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/20 03:41, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> The exception pending event is cleared by kvm_clear_exception_queue(). We
> shouldn't clear it again.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/x86.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 93bbbce67a03..10fa42f627d9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9180,7 +9180,6 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	vcpu->arch.nmi_injected = false;
>  	kvm_clear_interrupt_queue(vcpu);
>  	kvm_clear_exception_queue(vcpu);
> -	vcpu->arch.exception.pending = false;
>  
>  	memset(vcpu->arch.db, 0, sizeof(vcpu->arch.db));
>  	kvm_update_dr0123(vcpu);
> 

Queued, thanks.

Paolo

