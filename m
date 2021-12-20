Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DF847A6F9
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 10:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhLTJ1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 04:27:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41075 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229926AbhLTJ1N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 04:27:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639992432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9IkdL23yNRLEYMxVab7u73BGV3lZNI1vsDJ3NZLqO74=;
        b=hyRff8e97TOjmonXskjZktRnBbJr3LR4coTfk9qpXQKdAX0MpqKC0u7b7FgmB+DfCu03nZ
        d0l6jN9iOtd5wwhXChAG6rkrfrc3cSxopDT18dn4LEXvuFvF51ApTT8kzvNMZgruKDzza6
        5ru7QEcQG9ABYdMPdJNeSZ2BAO2qnMM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-ebXaDYAFOfypAoubw9ZdyA-1; Mon, 20 Dec 2021 04:27:11 -0500
X-MC-Unique: ebXaDYAFOfypAoubw9ZdyA-1
Received: by mail-ed1-f70.google.com with SMTP id h22-20020a056402281600b003f839627a38so3192968ede.23
        for <kvm@vger.kernel.org>; Mon, 20 Dec 2021 01:27:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9IkdL23yNRLEYMxVab7u73BGV3lZNI1vsDJ3NZLqO74=;
        b=LQISjWKTkCCLiiuXeaw6rX1XJzfwf89pURRxMUe/LYDijBCBWJkyAIsqrHj/brZ08O
         yeDJUSqtpTWdtIyLOv7LjBaD6TVN2AtMiCL+13dtEpT2+aSb1/nztX04zuPXut/dTtwA
         m6dJjT+HScv9ysftix67QoGqENEQGTNbW6VblF+C6osdrxx9+bMCt4eYc63Eph8Y/pni
         wP0UEWTBmSa6/P68Sifp5T+67GdVD7FipaHOkWj8XD7aLN8iJcWEtuIQEnJ+xTmQqKF1
         WJqUJXEGOWDZthqJ6iBUyoTRvhb7mtwm983n88QExpt1HQHzBV4t3PCd3gfWnLsvibG2
         RBtA==
X-Gm-Message-State: AOAM532etEAFkQcCvqY4um+DBIMG6aoNpnzxbdRCfsH16BDZ2k36lvaL
        fLiuYH9UuEuqW5fmXzKJddpsbLyWiPK/8yHycjjWWa24iQMfqzrHizqJUjIuJjVKK72+qkY9nR8
        5Oa5X9GPPAa/c
X-Received: by 2002:a05:6402:34ca:: with SMTP id w10mr4770306edc.106.1639992430481;
        Mon, 20 Dec 2021 01:27:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwM8KhSmPNIRgPd6dTe2R2O5YzHMVaTkyQKkGLcmqKwqeprqs3Exvl3OO6bz9RJhSGEWxataQ==
X-Received: by 2002:a05:6402:34ca:: with SMTP id w10mr4770296edc.106.1639992430294;
        Mon, 20 Dec 2021 01:27:10 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f8sm559744edd.73.2021.12.20.01.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 01:27:09 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Quanfa Fu <quanfafu@gmail.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Quanfa Fu <quanfafu@gmail.com>, pbonzini@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com
Subject: Re: [PATCH] KVM/X86: Remove unneeded variable
In-Reply-To: <20211219150307.179306-1-quanfafu@gmail.com>
References: <20211219150307.179306-1-quanfafu@gmail.com>
Date:   Mon, 20 Dec 2021 10:27:08 +0100
Message-ID: <87lf0ftymr.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quanfa Fu <quanfafu@gmail.com> writes:

> Remove unneeded variable used to store return value.
>
> No functional change intended.
>
> Signed-off-by: Quanfa Fu <quanfafu@gmail.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e2e1d012df22..7603db81b902 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2553,16 +2553,13 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
>  static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
>  {
>  	gpa_t gpa;
> -	int r;
>  
>  	if (vcpu->arch.mmu->direct_map)
>  		return 0;
>  
>  	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
>  
> -	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
> -
> -	return r;
> +	return kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);

While on it, you could've switched to using gpa_to_gfn() here.

>  }
>  
>  static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

