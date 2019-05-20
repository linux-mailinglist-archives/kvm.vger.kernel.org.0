Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1E6237B0
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 15:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732968AbfETM4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 08:56:04 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34835 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732316AbfETM4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 08:56:04 -0400
Received: by mail-wm1-f65.google.com with SMTP id q15so12934446wmj.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 05:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=POdzCkn+BD1xo1P2qkRXdnWiMHzE1h+gIx0vGRX+ho8=;
        b=Z7z9AGBaEAqcSibBI0Ckil97/iQBMyKMzR+dUPQbwgNarE5m0rfSLK73554yM27dpI
         RY25e1PSTf6A8MGuUfEB2BIF2W+7krKFvnU3CpyE5K1yXDtCZOs5U12YcACWdySt2v0R
         /HzPKn02EP10pKMJoZvO0ZANEMT/P2NZCm7oRY7aF1qSEK6m8PyrxmA4FestTdISkx6Y
         4UU+WaRAJ9JcuKbn85yTNVygNpeQLyc6DGaw/8cMmaNNteLFj+Fc9owWcW0h5DV4+dUa
         KrTLLwqsUYx9+7MGV+iVI6LlU4Fw0efTcqmGKzPqTNb6kcAZDW07kDAsxxc4kIt/fDbI
         jLzA==
X-Gm-Message-State: APjAAAUeiRE4Ph67wDNy895EQd9xrAo1Rkk/qtsOhc+yq+bussXia7jl
        rDCL0C3+k1qtdCmzQso6qChxag==
X-Google-Smtp-Source: APXvYqx5pXXCwxwx4x3VvqGSmM62foFIjaxcXPie2D4bBE9OAyupnN+bbaEloCiMX9qJ4TNU8ne+BQ==
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr7138843wmk.67.1558356962715;
        Mon, 20 May 2019 05:56:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id a10sm20115664wrm.94.2019.05.20.05.56.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 05:56:02 -0700 (PDT)
Subject: Re: [PATCH] svm/avic: Do not send AVIC doorbell to self
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
References: <1556890721-9613-1-git-send-email-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4275b74a-a228-d2a3-cb7d-5abce0a86f59@redhat.com>
Date:   Mon, 20 May 2019 14:56:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556890721-9613-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/19 15:38, Suthikulpanit, Suravee wrote:
> AVIC doorbell is used to notify a running vCPU that interrupts
> has been injected into the vCPU AVIC backing page. Current logic
> checks only if a VCPU is running before sending a doorbell.
> However, the doorbell is not necessary if the destination
> CPU is itself.
> 
> Add logic to check currently running CPU before sending doorbell.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 122788f..4bbf6fc 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5283,10 +5283,13 @@ static void svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
>  	kvm_lapic_set_irr(vec, vcpu->arch.apic);
>  	smp_mb__after_atomic();
>  
> -	if (avic_vcpu_is_running(vcpu))
> -		wrmsrl(SVM_AVIC_DOORBELL,
> -		       kvm_cpu_get_apicid(vcpu->cpu));
> -	else
> +	if (avic_vcpu_is_running(vcpu)) {
> +		int cpuid = vcpu->cpu;
> +
> +		if (cpuid != get_cpu())
> +			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpuid));
> +		put_cpu();
> +	} else
>  		kvm_vcpu_wake_up(vcpu);
>  }
>  
> 

Queued, thanks.

Paolo
