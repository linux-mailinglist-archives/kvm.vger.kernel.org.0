Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC2F48A4B4
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 02:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346086AbiAKBFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 20:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243310AbiAKBFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 20:05:37 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDA1C061748
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 17:05:37 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso1865328pjo.5
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 17:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q1R1PzpvGV/VojxQSiAa0bdqqqYycDMe3kAEirZNPdY=;
        b=ZESbEMzMJBAVvuSkQjGbPSGJsUnccftXUOXcM0pM9sSRfKNKisoQEd8ypg8qvpwAVx
         udQJ6ElRq7XD+djyuignDXBDWDBfpw5JxgNqVMSGwTzN4SOmjsxgs8wmqqZdeec+Zw5Y
         RznC+ZJjeAkY5ovug5GZHwlHimGkOmqWIyQ5nTlIaijy/UgsfsjaZ85gaFR57xpwmSG0
         0p7/wzE825snC5KenjZgDBdeCbcqYvSpWnBGX+JKXySINWmmChhu4jCARXHgOu+ZESBp
         +2VNgIyBbWorDPRuSGXyDSMvvDOU8K8JPhfZJ+VXxtP8rj2n+pY23qcy56Ef1pI5a8ZY
         V2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q1R1PzpvGV/VojxQSiAa0bdqqqYycDMe3kAEirZNPdY=;
        b=6GzHxffCaWNcxLlV2vyLG9CkGhUKq4sm1mgUeIasHUcn7EyfV1mwDu+Q9sqHzEdOjk
         jfXTQ4mEzwO+GO/kxfN2AkLCwNyl6IhTGIHDzsqKHUyNlSkcIsU9i3VAw0j0k+lvKb4u
         B3Ji5lVds3mI8QAwHZ5rmkD5Eb7iZHtgEuelwoHCsB6ER7JPQiSpAJr7nW9o2ZtlL0NQ
         g417D73g0Zi0s2rYxTfE2JtzYQFrLPrflvTvrlXyOaPTzM4azARu374uusXFKCo81gbK
         +vtu7aBYd/A+SVSgwddB6PmUZRIs0AWzEybABNoLmupFPGd1iNqD6Y+5KwUFCv0QlHrY
         BdnA==
X-Gm-Message-State: AOAM531OyjskEuo5MoU5lobDXGKOZUfG+Juy76cYhCQUy9OygCdmfZSY
        2gZJGHIhtH2M9aHMMIMLDRTnNg==
X-Google-Smtp-Source: ABdhPJzY/pkjKcqkaTs3n6wVHySOuAdgQewvLGOp/V9vsTfqwjdPrPNXXaklaP1HFYEan64rPHMzvw==
X-Received: by 2002:a17:902:b414:b0:149:61c7:d550 with SMTP id x20-20020a170902b41400b0014961c7d550mr2078379plr.129.1641863136914;
        Mon, 10 Jan 2022 17:05:36 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z15sm8400964pfh.201.2022.01.10.17.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:05:36 -0800 (PST)
Date:   Tue, 11 Jan 2022 01:05:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shirong Hao <shirong@linux.alibaba.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.co, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        srutherford@google.com, ashish.kalra@amd.com, natet@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, zhang.jia@linux.alibaba.com
Subject: Re: [PATCH 1/3] KVM: X86: Introduce KVM_HC_VM_HANDLE hypercall
Message-ID: <YdzX3AXqqbwYBRej@google.com>
References: <20220110060445.549800-1-shirong@linux.alibaba.com>
 <20220110060445.549800-2-shirong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110060445.549800-2-shirong@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022, Shirong Hao wrote:
> This hypercall is used by the SEV guest to get the firmware handle.

This is completely insufficient to justify why KVM is providing host information
to the guest, let alone why KVM is providing that information to guest _userspace_.

> +static int sev_vm_handle(struct kvm *kvm)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	return sev->handle;
> +}
> +
>  static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.name = "kvm_amd",
>  

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0cf1082455df..24acf0f2a539 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8906,7 +8906,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		a3 &= 0xFFFFFFFF;
>  	}
>  
> -	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
> +	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 && nr != KVM_HC_VM_HANDLE) {
>  		ret = -KVM_EPERM;
>  		goto out;
>  	}
