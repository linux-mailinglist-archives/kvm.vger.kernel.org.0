Return-Path: <kvm+bounces-24184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B77449521AB
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:58:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E5B12848D1
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3A41BD4F7;
	Wed, 14 Aug 2024 17:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IN7nOMvW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18DE1BCA19
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723658286; cv=none; b=rxnpgCliv1UX9iBK76rIt1dQ+5J81J1y22h/gl7Kq6/9FVkHsxvZMrV1ST8wOkWPzefIgEPS4+vTF7DNRQ2TOHnm+q3/Q0kMyTMa0JBynT+IjpkQMDiO/zPo4qYmrw6oawIuzeTTXfWn91F98RokylSZuluxteLdPlKJHvjpG2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723658286; c=relaxed/simple;
	bh=rUZCZSuAi1h96XDH07V4ivoXQ31utrr9lhxuwp8RHgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D5+gvWbW500K/Gja8uHqUNJ+F0jhd+V1bsna4KRsYraGaSoa831G7EuStIxnxIGdBtU7Mc/ZcaBf/VuvOgEiCmoUkrXtKecFkKKjZp/2YJzcj4CQJU7siZKV3w2s/W3ytQXvOTXtVPcxyaOP0880ilUxc/x7eqX8v2pcFe1lHqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IN7nOMvW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723658283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=89Qpoy/8XSxEnmGVZvkO72frQAWI1Kmg3p1IknMu/FI=;
	b=IN7nOMvWsnURcn/u7U5cheX/1hmLaef8SqJx5OAaxQ4NuLD3Mo6HEVRWaSQTAskhFoT3/J
	y2sXQFuG6HRZcQ4kikYdoiKFbLs6PHRas0jkASxaUByughZoDC1dOq/jxYVXtIAf1IKnWU
	iJ14qKSjk2ka9oBMjK9UPoVx+lG/ol4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-gpsEPS0jMYSvJggmR6NmIg-1; Wed, 14 Aug 2024 13:58:02 -0400
X-MC-Unique: gpsEPS0jMYSvJggmR6NmIg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42816aacabcso297355e9.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 10:58:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723658280; x=1724263080;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=89Qpoy/8XSxEnmGVZvkO72frQAWI1Kmg3p1IknMu/FI=;
        b=E2rMqF8qFYWVKg9DcHHFd2gG6rnhk9wk6ZW1PJJWvAWFeNOnKhbhrXMQupZR0WP54+
         02zFRjAHnlTxIWP0nKXvwKOryZOYuG5eTSZnFmxuQ0RIYqqpC21f7VnEvVN+AB6s/UED
         LcW6yy5z0LMuCUodx4U7HYqulaiVRdhqRK8w82ld7L5vB6jSBKjJy1dMb1ejGAhwlNzA
         DY4Y0/sOSclJAW7PAG7WfY4A00vrCRCVLjblVky90A8CJIj92Z+YW0YMEd2M7ZV3A9W5
         Klxz7HBwGvDWmsPWoBU7y4cXd21gEPsbnw5J8ABA79j9AlREzyNPbCKEgPgCZOhynjj3
         1J4g==
X-Gm-Message-State: AOJu0YyowLzehMxKtn/gJRrm+aCamq61KjxC6AnMbSQdZSe7PCFJcQpT
	VR+Z2m1IngJQ9Wq8aOp9XmOvhL6y+AyFkq9aMtrOSIGm9uKXX00CgOhY4P3f/Kzr/T7IsE86LOa
	xH+AY1ufvqjt0HonoRGCeyJ/VJoBcJ1vMwOXohnFwHch173YTgA==
X-Received: by 2002:a05:600c:1da6:b0:426:5471:156a with SMTP id 5b1f17b1804b1-429dd23b7b8mr28648715e9.13.1723658279776;
        Wed, 14 Aug 2024 10:57:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSCwDwNXwiqgNc8qTmHDkSdNy4unKmAQEh5uyse96W8/CeXQ9UmxrPFPRv7DJnqCF/7Y7tMQ==
X-Received: by 2002:a05:600c:1da6:b0:426:5471:156a with SMTP id 5b1f17b1804b1-429dd23b7b8mr28648565e9.13.1723658279229;
        Wed, 14 Aug 2024 10:57:59 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-429ded71ee3sm26570925e9.29.2024.08.14.10.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 10:57:58 -0700 (PDT)
Message-ID: <5f8c0ca4-ae99-4d1c-8525-51c6f1096eaa@redhat.com>
Date: Wed, 14 Aug 2024 19:57:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/22] KVM: x86/mmu: Detect if unprotect will do anything
 based on invalid_list
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerly Tng <ackerleytng@google.com>
References: <20240809190319.1710470-1-seanjc@google.com>
 <20240809190319.1710470-23-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240809190319.1710470-23-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/24 21:03, Sean Christopherson wrote:
> Explicitly query the list of to-be-zapped shadow pages when checking to
> see if unprotecting a gfn for retry has succeeded, i.e. if KVM should
> retry the faulting instruction.
> 
> Add a comment to explain why the list needs to be checked before zapping,
> which is the primary motivation for this change.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 300a47801685..50695eb2ee22 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2731,12 +2731,15 @@ bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   			goto out;
>   	}
>   
> -	r = false;
>   	write_lock(&kvm->mmu_lock);
> -	for_each_gfn_valid_sp_with_gptes(kvm, sp, gpa_to_gfn(gpa)) {
> -		r = true;
> +	for_each_gfn_valid_sp_with_gptes(kvm, sp, gpa_to_gfn(gpa))
>   		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> -	}
> +
> +	/*
> +	 * Snapshot the result before zapping, as zapping will remove all list
> +	 * entries, i.e. checking the list later would yield a false negative.
> +	 */

Hmm, the comment is kinda overkill?  Maybe just

	/* Return whether there were sptes to zap.  */
	r = !list_empty(&invalid_test);

I'm not sure about patch 21 - I like the simple kvm_mmu_unprotect_page() 
function.  Maybe rename it to kvm_mmu_zap_gfn() and make it static in 
the same patch?

Either way, this small cleanup applies even if the function is not inlined.

Thanks,

Paolo
> +	r = !list_empty(&invalid_list);
>   	kvm_mmu_commit_zap_page(kvm, &invalid_list);
>   	write_unlock(&kvm->mmu_lock);
>   


