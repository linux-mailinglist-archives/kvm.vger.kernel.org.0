Return-Path: <kvm+bounces-24168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB8795205D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 18:48:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71A52B242ED
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7E291BA86E;
	Wed, 14 Aug 2024 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kzpm//R0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8708F1B9B26
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 16:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723654084; cv=none; b=m1YMLrOVHg4NyVMkmlxTZesmo9CeLdTx22z+D/LLnE4olJQ3776x4i8WA1Z1G0ehwquw1wGakQwZZ8chqeNlOzEHULFl+h6emPgNulXomvbQT4ly1Tz8D8yEozPGwUoeOE2PQifP7CsFQvcTUilVV6qTtQbq/0DofC/4wHTsNHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723654084; c=relaxed/simple;
	bh=vTfAPEk2c1Ct83IEMiOqxGera7uARBbWF1WLwgPNSIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jPJX+cxVuXBZszIaBCjmHKxaSLYOuyGqUKIRdvutdML5Bk8c3VRXvjhXIF0p9hDe1xCnJ9GeF3b3vCdLfc/yNEuhsqvMKL2rqCbaaRxU9iiGrjxlFip4AcPa4220TUOTJ9t+d03KI1nc5b2yV56Ds5i2eBAGFUKLh5yxwu39mw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kzpm//R0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723654081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QYxda2UDwR4Xmvyg0lcuf9BUoRVgq+CvoIu/NKSta7Q=;
	b=Kzpm//R0KArimu3RMB3Sx2Ealmq0vZsbcF6zVy48lZXF6QE7rt+HnoA4EfGhAYaKA6fiDm
	H46U//Wg5VNOKm7cJbiwacbdBmiA0qH5MSF0KUBuGDorovJsottQlxXZljnox3J9SW41Jf
	m/7CFY3gJqAqZANl8cDsZfYDtw2/CHE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-jJbuy6VmP4S8iXXUH7ZFuQ-1; Wed, 14 Aug 2024 12:48:00 -0400
X-MC-Unique: jJbuy6VmP4S8iXXUH7ZFuQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-36835daf8b7so60319f8f.2
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 09:47:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723654079; x=1724258879;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QYxda2UDwR4Xmvyg0lcuf9BUoRVgq+CvoIu/NKSta7Q=;
        b=ScH5LUVOPBMkOg4EQv8zC0mqSLKoYAc4K26/vKTFom3lM/o20aReHU9dXq3FxAQN2r
         IACqqQmDGYEXjFAJOfZuZCdVuXUa52v5Es/WoLpeS4map5JpEG49Yx9ySK1tcyfvHrF/
         nrmP6JIFKcrq4a3w0ymz2t2U3gdM7euBAAM9WzbsLwvEv0/01+1zi8HRPUdOkCp9OoWz
         9AOmKZYWfPzRlLrEstbGe9iCT0wA3oMH4dsclS2yWG7g38B2lTW+15ffUWzU5KRedRao
         VEsK249/meiKpox5fhZs7gnE++l7fiDxBH7m04aKVR2MyTeZKpUnqW9J3KH1+f2uD94w
         8BwQ==
X-Gm-Message-State: AOJu0YxOJPD0ByrYNIkBMWAkcjIcOQh8D1Puts+TT8yvcHY9g9zjC2RX
	o6YKBAcYfslt14d+KN7erOIIZ6NvCM3i0Rz0PqCCID0AsegjAOQ7cXLR3CxGpKG6OxkV43EGYwy
	RquZN9LwmkjcQImUYC7mJmlQt+ldsSepv0irj5F0v3wUYpDYBfQ==
X-Received: by 2002:a5d:63d2:0:b0:368:4e35:76f9 with SMTP id ffacd0b85a97d-37177792c5cmr3202376f8f.37.1723654078839;
        Wed, 14 Aug 2024 09:47:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlHisBwwOgDSWWZAt8jetKNRxWN9mxvxPG18APJHAdr+BzMtyO7krVv2Z7CFUDIx3n93TEAQ==
X-Received: by 2002:a5d:63d2:0:b0:368:4e35:76f9 with SMTP id ffacd0b85a97d-37177792c5cmr3202351f8f.37.1723654078206;
        Wed, 14 Aug 2024 09:47:58 -0700 (PDT)
Received: from [192.168.10.3] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-36e4e51eaa9sm13321050f8f.68.2024.08.14.09.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 09:47:57 -0700 (PDT)
Message-ID: <2bec792d-22aa-4c79-8324-2f801407a4eb@redhat.com>
Date: Wed, 14 Aug 2024 18:47:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/22] KVM: x86/mmu: Skip emulation on page fault iff 1+
 SPs were unprotected
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerly Tng <ackerleytng@google.com>
References: <20240809190319.1710470-1-seanjc@google.com>
 <20240809190319.1710470-5-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240809190319.1710470-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/24 21:03, Sean Christopherson wrote:
> When doing "fast unprotection" of nested TDP page tables, skip emulation
> if and only if at least one gfn was unprotected, i.e. continue with
> emulation if simply resuming is likely to hit the same fault and risk
> putting the vCPU into an infinite loop.
> 
> Note, it's entirely possible to get a false negative, e.g. if a different
> vCPU faults on the same gfn and unprotects the gfn first, but that's a
> relatively rare edge case, and emulating is still functionally ok, i.e.
> the risk of putting the vCPU isn't an infinite loop isn't justified.

English snafu - "the risk of causing a livelock for the vCPU is 
negligible", perhaps?

Paolo

> Fixes: 147277540bbc ("kvm: svm: Add support for additional SVM NPF error codes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 28 ++++++++++++++++++++--------
>   1 file changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e3aa04c498ea..95058ac4b78c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5967,17 +5967,29 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   	bool direct = vcpu->arch.mmu->root_role.direct;
>   
>   	/*
> -	 * Before emulating the instruction, check if the error code
> -	 * was due to a RO violation while translating the guest page.
> -	 * This can occur when using nested virtualization with nested
> -	 * paging in both guests. If true, we simply unprotect the page
> -	 * and resume the guest.
> +	 * Before emulating the instruction, check to see if the access may be
> +	 * due to L1 accessing nested NPT/EPT entries used for L2, i.e. if the
> +	 * gfn being written is for gPTEs that KVM is shadowing and has write-
> +	 * protected.  Because AMD CPUs walk nested page table using a write
> +	 * operation, walking NPT entries in L1 can trigger write faults even
> +	 * when L1 isn't modifying PTEs, and thus result in KVM emulating an
> +	 * excessive number of L1 instructions without triggering KVM's write-
> +	 * flooding detection, i.e. without unprotecting the gfn.
> +	 *
> +	 * If the error code was due to a RO violation while translating the
> +	 * guest page, the current MMU is direct (L1 is active), and KVM has
> +	 * shadow pages, then the above scenario is likely being hit.  Try to
> +	 * unprotect the gfn, i.e. zap any shadow pages, so that L1 can walk
> +	 * its NPT entries without triggering emulation.  If one or more shadow
> +	 * pages was zapped, skip emulation and resume L1 to let it natively
> +	 * execute the instruction.  If no shadow pages were zapped, then the
> +	 * write-fault is due to something else entirely, i.e. KVM needs to
> +	 * emulate, as resuming the guest will put it into an infinite loop.
>   	 */
>   	if (direct &&
> -	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
> -		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
> +	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE &&
> +	    kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
>   		return RET_PF_FIXED;
> -	}
>   
>   	/*
>   	 * The gfn is write-protected, but if emulation fails we can still


