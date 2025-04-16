Return-Path: <kvm+bounces-43486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6715DA90B3D
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 20:25:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F25FB190400B
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 18:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8027621B8FE;
	Wed, 16 Apr 2025 18:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mnh2R253"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577BA20E6EC
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744827886; cv=none; b=Z/bkQjrnqjGgKeX9pv2pu2+2/t/9vdl5oM1bY/7SGregIjuVjykrNTOSMKkNAboPVPEMZXa6H5Er8oVcITnYbHFzPA7E7ymUQCZ1tPcCgmqHkI0HF37QzfLAfZbEAtdic69XOYHRkRUDUKMCc43iGyxHy96htokz56duaoukjWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744827886; c=relaxed/simple;
	bh=oWT/F7XNGMua84md0xB7i6qKpkZiaDT6KbfyOZrXN4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJ8BC9YKRcNpSoY808dJSvs+AdLqSLEj4303biDZ4G/p1B2fTD4grxp7R+jmC5gum8A19yfEJVg6cIs3IG6DSyjNZU2w91woMlOOidV1VCw0JjZzUoN7uDvVhpaNVvLE0Q8tR80+YaNcf0THyvzwRCQY6E75uTwc4icwhIKuDy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mnh2R253; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2263428c8baso30875ad.1
        for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 11:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744827883; x=1745432683; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wOK0Vf+KbobwJmYW/gQ4vGafXzu+jG9W32EG6FGCWPQ=;
        b=Mnh2R253H9M9WGf3/4vXTN4xAYUfoLXSKuZ43/2JPlLo686tKR0ovZCYp3wEbEiyW/
         Wy6/YovEwRXvIb5hGDKNlmwhWsb3b0VkZbx41tDYAM6/hmsCrAIS0t2FT6IAExcXZZyq
         x7zGYJPzfB001XD2ZDXOH+Rg79sSqk1yyDCm4fRfWPV8RBk9zDNaVSX8UQQ3KS8IfVJg
         TUKj9q272r2VWZEjlMgdF6RC55ir+MnQscZ8FRpT20rpgSZJSxW3v6xrIZdU04E1zTTS
         gPV/PgtVsk6A328UEwx/0VY6G5mD8e72d9FhWyRMYwsSX7e2f5UCpbNkTIagCz5L1oGl
         zfng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744827883; x=1745432683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wOK0Vf+KbobwJmYW/gQ4vGafXzu+jG9W32EG6FGCWPQ=;
        b=YpbUC0L7Wg1lAu+VK+fqjVB6d79WZDEymJg0kG4ioD7gfdA+BXhc1+6Vq0Le1UVpnc
         XEweY84ky8Mk73jtTCSXAj2QoS0LHkzH83clEarWIksvlgq3rvhW+y9jDMk0hatVzBqV
         jpsbfpfRIkujC1KTDR/UQrY4myK6CWEdj5j457xBesN0z96tMJxClA9xN1bVDmWIf1La
         +3j3NM9aQVHfeQOgEzOEMnAP4uxd2KuD3lQJduqjexSfV9G7prV4PF6VjuOsYkJ9DrRE
         aklH/dzo522nQX0CcSiCvQavOqb9Uj9P80tlVpEROVvGZtB/s3reHaJwPf04Jm945rjp
         aW+Q==
X-Forwarded-Encrypted: i=1; AJvYcCURX6VUI84yxZLRPpp/AipSpdiLJU81wiMFrR7I8rreJFICwSugOJcAsJSp7wBoU86CFQc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoHBnT09lEJwVgZWRgBwYhCsnlHU+H/IYT9vNC4mPFogk93sBc
	p8wkPwb4ZuNuZanLySdUeZAUFU30oGm2+UXzgjtR5bVPtYWPGC7DZFHplZ4ZsaorJkaNhE/wg7W
	KFw==
X-Gm-Gg: ASbGnctOivX9lw0G/+97gH+zGPdSaFwhkRNqsZp33N0D+CIe/c+hfQD4PA2SrANT8dY
	apep3ixLSGsd9dsa1BrjpOAUyHEC1gbBFmgoES0HVQd75DFeaH4agAnT7LXPGl58zZoiAXdJPtT
	RS4IJxCt1ObWV4MKhhrIxUfo+e7J0kGdAlCHFIelf6Q3v9ztvulbMi3ALjrUkOjkzZqge7OEcKv
	DEXxVnxtEG2VscNcUwy3EiQ3KB9iP9/wGmzs1Ha4A1eg2T6Odtncg3c2aUkNExznBEgbKW1UXiD
	a6XgzDwGGtL16OK4MJigqTxyIrmY6DOol+tt8RCnZoooClhssMxwqGOCU3y05BAnuXK1vRJFagB
	RFA==
X-Google-Smtp-Source: AGHT+IEpHyqavKPJ4ronBax5JpMqCt2LPq1gE7nGAr42leNu8PkO8Q/dBpQStv9Xhaw0weJzShRUgQ==
X-Received: by 2002:a17:902:ef11:b0:215:aca2:dc04 with SMTP id d9443c01a7336-22c412344e8mr232485ad.26.1744827883313;
        Wed, 16 Apr 2025 11:24:43 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-308612299basm1963232a91.33.2025.04.16.11.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 11:24:42 -0700 (PDT)
Date: Wed, 16 Apr 2025 11:24:37 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: x86: Allocate kvm_vmx/kvm_svm structures
 using kzalloc()
Message-ID: <20250416182437.GA963080.vipinsh@google.com>
References: <20250401155714.838398-1-seanjc@google.com>
 <20250401155714.838398-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250401155714.838398-3-seanjc@google.com>

On 2025-04-01 08:57:13, Sean Christopherson wrote:
> Now that the size of "struct kvm" is less than 2KiB, switch back to using
> kzalloc() to allocate the VM structures.  Add compile-time assertions in
> vendor code to ensure the size is an order-0 allocation, i.e. to prevent
> unknowingly letting the size balloon in the future.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/svm/svm.c          | 1 +
>  arch/x86/kvm/vmx/vmx.c          | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e523d7d8a107..6c7fd7db6f11 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1940,7 +1940,7 @@ void kvm_x86_vendor_exit(void);
>  #define __KVM_HAVE_ARCH_VM_ALLOC
>  static inline struct kvm *kvm_arch_alloc_vm(void)
>  {
> -	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	return kzalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT);
>  }
>  
>  #define __KVM_HAVE_ARCH_VM_FREE
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8abeab91d329..589adc5f92e0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5536,6 +5536,7 @@ static int __init svm_init(void)
>  	if (r)
>  		goto err_kvm_init;
>  
> +	BUILD_BUG_ON(get_order(sizeof(struct kvm_svm) != 0));

There is a typo here. It is checking sizeof(struct kvm_svm) != 0, instead
of checking get_order(...) != 0.

>  	return 0;
>  
>  err_kvm_init:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b70ed72c1783..01264842bf45 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8755,6 +8755,7 @@ static int __init vmx_init(void)
>  	if (r)
>  		goto err_kvm_init;
>  
> +	BUILD_BUG_ON(get_order(sizeof(struct kvm_vmx) != 0));

Same as above.

>  	return 0;
>  
>  err_kvm_init:
> -- 
> 2.49.0.472.ge94155a9ec-goog
> 

