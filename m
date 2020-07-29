Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6A92327E3
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 01:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgG2XJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 19:09:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33286 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727982AbgG2XJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 19:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596064173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MOzWsoV4V1UYpUe37YHfLbYZNy/u93r4LzdthqJ6/oA=;
        b=PYcrp0Uyl9y/FbwJ11K8ey7+Kito7FRBAYzDFgclXeqeieeGvaYoujH5JkJGpxfc4G6b6M
        dFNjR0XwK3Tdx/qmh++b3EEukRRIS2UCJvuAqMIyXdy0Cc7FoScuijIfbntXoLM6mUMc5z
        L78BHc7q163ESaKlGu1afvxMs3jRa9A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-EroWjDThP9GNmgEQ3e8SOQ-1; Wed, 29 Jul 2020 19:09:31 -0400
X-MC-Unique: EroWjDThP9GNmgEQ3e8SOQ-1
Received: by mail-wr1-f71.google.com with SMTP id d6so5596318wrv.23
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 16:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MOzWsoV4V1UYpUe37YHfLbYZNy/u93r4LzdthqJ6/oA=;
        b=b6j3sZRmG2vILm/pFWvVx9cDIt/jXduz55vJVI/4y22spxekgCGnITJtZuO4DbUxSY
         oXbR01KjDJ1AwC98lef2N7m2tEQQkMvnyeYoLOdjYEQE0eZB6m/f1mIPCwEayWmnkunt
         3X3oP5SKfl01moSG+e3YHzxpQhxk6WA4TP+Ef7pjUtJL6Aq6sgs8AjvZrRZqomMwMw2p
         hdVFudmznUchzYelwH+bSCi1dHpu7jLHLT5k82uQ3p3VvfErgYeqEC5wjz+xCQs35tu5
         9uIHAKDCdSReohR52SH9XHAWc8fm5Yp7YDJzfvYHnHeyoDxjyybKOez6Yu5kM/priahR
         +L2w==
X-Gm-Message-State: AOAM5301Y09133AjP5r5y6q1r4DwbN6fkAgDr9OkOodbIpufQGznnp1A
        bB0WgClZLkjWNweLvq9zXYNXg/i5hK3B49taPxkBj0eJ1RwgSvNs1e/0ekIvX2GLYQftLRSNUwX
        ++CTogXeZrYMM
X-Received: by 2002:a5d:618e:: with SMTP id j14mr22472wru.374.1596064170198;
        Wed, 29 Jul 2020 16:09:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6A8g5r+z6yS7wZ5SDypfCJ/7uTsFty4Vrb8Ti/KJDrWVOKGqmBLEWrbhtsfBg4vBNjr4YvA==
X-Received: by 2002:a5d:618e:: with SMTP id j14mr22406wru.374.1596064169050;
        Wed, 29 Jul 2020 16:09:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:101f:6e7:e073:454c? ([2001:b07:6468:f312:101f:6e7:e073:454c])
        by smtp.gmail.com with ESMTPSA id s20sm6324317wmh.21.2020.07.29.16.09.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 16:09:28 -0700 (PDT)
Subject: Re: [PATCH v3 01/11] KVM: SVM: Introduce __set_intercept,
 __clr_intercept and __is_intercept
To:     Babu Moger <babu.moger@amd.com>, vkuznets@redhat.com,
        wanpengli@tencent.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
 <159597947370.12744.8741858978174141331.stgit@bmoger-ubuntu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7c6c66d0-85cd-e558-f43e-a2d5d57e8913@redhat.com>
Date:   Thu, 30 Jul 2020 01:09:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <159597947370.12744.8741858978174141331.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/20 01:37, Babu Moger wrote:
> This is in preparation for the future intercept vector additions.
> 
> Add new functions __set_intercept, __clr_intercept and __is_intercept
> using kernel APIs __set_bit, __clear_bit and test_bit espectively.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/kvm/svm/svm.h |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 6ac4c00a5d82..3b669718190a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -217,6 +217,21 @@ static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
>  		return svm->vmcb;
>  }
>  
> +static inline void __set_intercept(void *addr, int bit)
> +{
> +	__set_bit(bit, (unsigned long *)addr);
> +}
> +
> +static inline void __clr_intercept(void *addr, int bit)
> +{
> +	__clear_bit(bit, (unsigned long *)addr);
> +}
> +
> +static inline bool __is_intercept(void *addr, int bit)
> +{
> +	return test_bit(bit, (unsigned long *)addr);
> +}
> +

Probably worth adding a range check?

Paolo

>  static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
>  {
>  	struct vmcb *vmcb = get_host_vmcb(svm);
> 

