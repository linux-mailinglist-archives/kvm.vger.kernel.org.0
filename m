Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9072B5A67
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 08:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgKQHkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 02:40:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725771AbgKQHkM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 02:40:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605598810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4XVB2HLVPXWZSYAGy1w+L0QjlzQTnzB+6hDaTM7i40Y=;
        b=SNqY+oT77+ZO9U9ZaxrsFuh5yBlIr7hJB94WyRkrnkeltxjTO1u9TjsFhSYN5uFBMa+oem
        CePOc6Mic+kPRaVvsOECsFTaM9TCjTk8cmcOCVqGn4+wwfPvERXZ4YaSBAbCdtpkeqjrAz
        9H5A3jlI7MXdNv+jSBS5fsn09cMPZr8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-yY3dBygsOLeiWGtt8z-8-Q-1; Tue, 17 Nov 2020 02:40:09 -0500
X-MC-Unique: yY3dBygsOLeiWGtt8z-8-Q-1
Received: by mail-ej1-f72.google.com with SMTP id yc22so8830648ejb.20
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 23:40:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4XVB2HLVPXWZSYAGy1w+L0QjlzQTnzB+6hDaTM7i40Y=;
        b=rxs9TMry2tshEtLgtkAHvRJw4Sw579dpOXAN5ay55+gPmpw4cx+aoaHi+elyA5hmct
         GTksBg/xday8/GFvtTZbLptM4NwFBq9cAcG4Hr+SkzRjF8nc7fbz8+joIXsbOsTZQkRd
         pdUuefFnuqp+6ezC77hn9g3nzsY9LAapLc0FRNorcr5Fj/nIU+CKlhr325Is4CGTnN4y
         v94Tf/kE8MSmi37VVkx3mzBgmWrtj4RfaONLHqOea9FIpYUx4MUQaSd6+gmNfLEkGkvD
         RePyaE9kHCJ6L/vH6+EXDDHQ7tbRVP2oa5G287UsnUZGJMWl1FoniF+0kc96g+gxT4t4
         5/Dg==
X-Gm-Message-State: AOAM53277qu1S79PwbZe3Mvw/CxqO9aAEtNj3aP7RzuvG65CBoHxJmoY
        QexI7jBCQY0iN9Qf97Sni9ud1SJ3Xs1BaCHohfTEcuHOkksnuHoJ6oEOfyU8dkQyZwsyWUCp7Bn
        czXPwbL989Zyt
X-Received: by 2002:aa7:cc8f:: with SMTP id p15mr20781352edt.240.1605598807950;
        Mon, 16 Nov 2020 23:40:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyrEkHOlHKCbof8IeyU5M5pVclQNmoojK/SG37Qm5GctY0ngu506HbkBX3BPY9sTkZNAjQL1w==
X-Received: by 2002:aa7:cc8f:: with SMTP id p15mr20781340edt.240.1605598807737;
        Mon, 16 Nov 2020 23:40:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w3sm11726222edt.84.2020.11.16.23.40.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 23:40:07 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: fix error return code in svm_create_vcpu()
To:     Chen Zhou <chenzhou10@huawei.com>, rkrcmar@redhat.com,
        tglx@linutronix.de, mingo@redhat.com
Cc:     hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201117025426.167824-1-chenzhou10@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3ffc3a59-fdc1-3cb4-46e8-0369084bcc06@redhat.com>
Date:   Tue, 17 Nov 2020 08:40:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201117025426.167824-1-chenzhou10@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/11/20 03:54, Chen Zhou wrote:
> Fix to return a negative error code from the error handling case
> instead of 0 in function svm_create_vcpu(), as done elsewhere in this
> function.
> 
> Fixes: f4c847a95654 ("KVM: SVM: refactor msr permission bitmap allocation")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> ---
>   arch/x86/kvm/svm/svm.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1e81cfebd491..79b3a564f1c9 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1309,8 +1309,10 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>   		svm->avic_is_running = true;
>   
>   	svm->msrpm = svm_vcpu_alloc_msrpm();
> -	if (!svm->msrpm)
> +	if (!svm->msrpm) {
> +		err = -ENOMEM;
>   		goto error_free_vmcb_page;
> +	}
>   
>   	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
>   
> 

Queued, thanks.

Paolo

