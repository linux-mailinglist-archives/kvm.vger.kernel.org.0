Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5886D30EE3E
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 09:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbhBDIV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 03:21:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234881AbhBDIV5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 03:21:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612426831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nMux9xeg2o0Nzq5bnmpVyZk80lGMRhzWrGwfdgzhu+M=;
        b=W3LRcfPVpimeHx+CUWTaSgMIk1CmKRrKjASO6zBIVeZS7QXilIDWLrWmMKxCBpAuPwD+M/
        CWoIIspuLWlljQC/gAH5aIkuvaz7bx582a3ldkG9Z1pjkL0S5K3TJ9qrUaDQ2V6UKzvCJr
        gvX7/CuhYqvEKSVhsZYT6VkRImypeIk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-av0CDugUNKaE5bZmuOaeCg-1; Thu, 04 Feb 2021 03:20:27 -0500
X-MC-Unique: av0CDugUNKaE5bZmuOaeCg-1
Received: by mail-wr1-f71.google.com with SMTP id h18so2235131wrr.5
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 00:20:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nMux9xeg2o0Nzq5bnmpVyZk80lGMRhzWrGwfdgzhu+M=;
        b=ofiutz/6u6yzDWzECrzzFbxj4JdrNU8nkpap4o2XmE39k+N3aIoZiY2yc3zbu5I3kE
         3ji9rozJs6KX44wzoXyroM1UTH9IhrCh2E88wrLmM36w9AsJHRZFA7yEkJstDvPEl4XY
         DOA5F9QtrBQ00rzQRyTJgxGPSirn25wF3YZUBQP1bO0t6oQrjEZRUQDzrNEvjCsHu0YZ
         OUTPC++C2F74MdrPQOaqLgO4WIQQg7QJIwfxA8sCwFxOzcxjO9Sj4V5YOkhi8OwKf2BA
         uu8riwQiQoBwqb1a7OkLi6TvaMEBQ5lWUgZadk9Zv+xHcGNt+5EmU3X6n4HVzxFJZbng
         d91Q==
X-Gm-Message-State: AOAM531STr50zptUppZO6Ymv+ivHLHijrkiE7iPd7T4lpYYjtOQl+Z3O
        F/kxPnNfsWhAtoXPgupcVmdobyhCIo3XCNb3wNgxgg8udjUIl5qveVRjJzkYXe+Vsv0p4JY2nO6
        9p6wenySy2eyC
X-Received: by 2002:a05:6000:48:: with SMTP id k8mr8056025wrx.340.1612426826842;
        Thu, 04 Feb 2021 00:20:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxCv+uSSCqNqJhvOGDIOprVqWzgGeSsvHNPHsJBguW10RgCtSVMlhGlz9OjHYpIL+UQJmeGFA==
X-Received: by 2002:a05:6000:48:: with SMTP id k8mr8056011wrx.340.1612426826663;
        Thu, 04 Feb 2021 00:20:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u10sm5071763wmj.40.2021.02.04.00.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 00:20:25 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: Remove bogus WARN and emulation if guest #GPs
 with EFER.SVME=1
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bandan Das <bsd@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210204023536.3397005-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dde46009-10b6-9274-fb36-a57c04bf1df5@redhat.com>
Date:   Thu, 4 Feb 2021 09:20:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210204023536.3397005-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/21 03:35, Sean Christopherson wrote:
> Immediately reinject #GP (if intercepted) if the VMware backdoor is
> disabled and the instruction is not affected by the erratum that causes
> bogus #GPs on SVM instructions.  It is completely reasonable for the
> guest to take a #GP(0) with EFER.SVME=1, e.g. when probing an MSR, and
> attempting emulation on an unknown instruction is obviously not good.
> 
> Fixes: b3f4e11adc7d ("KVM: SVM: Add emulation support for #GP triggered by SVM instructions")
> Cc: Bandan Das <bsd@redhat.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f53e6377a933..707a2f85bcc6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2263,7 +2263,8 @@ static int gp_interception(struct vcpu_svm *svm)
>   	opcode = svm_instr_opcode(vcpu);
>   
>   	if (opcode == NONE_SVM_INSTR) {
> -		WARN_ON_ONCE(!enable_vmware_backdoor);
> +		if (!enable_vmware_backdoor)
> +			goto reinject;
>   
>   		/*
>   		 * VMware backdoor emulation on #GP interception only handles
> 

Squashed, thanks.

Paolo

