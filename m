Return-Path: <kvm+bounces-24182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18918952184
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:50:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 849141F226AD
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6587C1BD002;
	Wed, 14 Aug 2024 17:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dAIo8Sn3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B351BA870
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723657811; cv=none; b=EkqLD9XPRaMoykW2Lo5VyVOSlMwQbROU8+2LRxeLYGQNVR2DtPldxxQwc6kA4yBjv6j0qR/v50G8qJ2KNkCI1lbtrA41JweVTOupDdbM3XPM2imLf0g61vqGZrB8FQXlo/hToE6pY+sq20E3f9aVFC7iLC2Vt888Lspkvux18WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723657811; c=relaxed/simple;
	bh=o7UnWKGC5ImuqDKd0A+y4X+zbi4zjYGIUvZ598GJQx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p7zqN7xtF0UkF7ga9dWe74iviv5NO5T8B6pmjSFdEJAYaC0Ga8jzx7makNXcLkr4WxZAkftT66aHgSU+6XX1CGqy2JaG2+/aEO/9ZPzt1QzsrxuyHKSiBvhbi0+pVp5FTc8svJACYoWtQbuNCnAe/WlR0qRnCLhcDy30KJ3m3fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dAIo8Sn3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723657808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=D60tbrlKP7Gw+YlhJwC85uUtehBLMwc9/zsHx1WY5pU=;
	b=dAIo8Sn3CVi5A4ym+bn/EVp/UXpNFTXRDyRjgRkMb0/QcJni0oCoZyn09y+K1sNMGDp/Fz
	FLISHw/T9hg1W4FgYoHKtM/MZlAoTTrr1MfC1NfIm7W0yVZuOmnY61mLRxfg0Kpj7LrvA0
	hO4FN8ZULksOVl3F3QJrxKen8oaGJwg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-DTAdoPp5NjaZbyEdMxBGKA-1; Wed, 14 Aug 2024 13:50:07 -0400
X-MC-Unique: DTAdoPp5NjaZbyEdMxBGKA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-36bbcecebb4so124846f8f.0
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 10:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723657806; x=1724262606;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D60tbrlKP7Gw+YlhJwC85uUtehBLMwc9/zsHx1WY5pU=;
        b=qyW+Q09lFHqyaof45dDMTt87PLqPB6y+au8Nr8+mw+OochPcY4I42Zx8h00R49fBlw
         P6tVFFfApE79EyAXHFttKZ973wioDxQYFJn/nO2NDjbW7111Gs8x7t7HGo0lsnmyg7z/
         O/rpAMAtooDRJqpFLfnG5AL94icjiJWTMhd2ABxGNzNyHYMyBi73jXLq0cXBUC12KSuq
         JGHf+ufmEMMsskUOar+EocIoydIglmW4NEQXBzZrJxDj658FIjTnvL6Qs17FN6GOq2gI
         NwUAe8u1VjrkQYrn1/1LMSbC7dSxBxiqzeaKefIHmXc1YkZ7vlMvOxtlLewmvgSt3+ns
         ryvQ==
X-Gm-Message-State: AOJu0YxR5B3hoifJAMRZLw0KssIh4Vr68VqLQveiwKBD8XSAVV0orBYT
	NKshsz/vrZBnMrgOvfeMJKsyEQvx6xpxQsjG6ce8dr5VD8DEJNmuS0mRTC4T+OwkzXVhW2+/uXj
	PIRgbfR1Y/jfBYA8vUfw3sjZo+Xx3Uu11xz5nj/zEAaZ2cuVXtg==
X-Received: by 2002:adf:fb4d:0:b0:368:78d0:c240 with SMTP id ffacd0b85a97d-37177785ebemr2965849f8f.35.1723657805847;
        Wed, 14 Aug 2024 10:50:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5RNDAtSjrNSf17qwEzrd6g2TkSGUK2wx5/qSGkwfZKkZy0bGLK/2llpLIbYk1QHtZWfCfOg==
X-Received: by 2002:adf:fb4d:0:b0:368:78d0:c240 with SMTP id ffacd0b85a97d-37177785ebemr2965825f8f.35.1723657805330;
        Wed, 14 Aug 2024 10:50:05 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-371874c7e1asm151669f8f.9.2024.08.14.10.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 10:50:04 -0700 (PDT)
Message-ID: <6530eb94-b937-415c-8457-f5c598d94e7b@redhat.com>
Date: Wed, 14 Aug 2024 19:50:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/22] KVM: x86: Remove manual pfn lookup when retrying
 #PF after failed emulation
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerly Tng <ackerleytng@google.com>
References: <20240809190319.1710470-1-seanjc@google.com>
 <20240809190319.1710470-17-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240809190319.1710470-17-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/24 21:03, Sean Christopherson wrote:
> Drop the manual pfn look when retrying an instruction that KVM failed to
> emulation in response to a #PF due to a write-protected gfn.  Now that KVM
> sets EMULTYPE_PF if and only if the page fault it a write-protected gfn,

Pointing out where this happened will likely help a few years from now:

With the introduction of RET_PF_WRITE_PROTECTED, KVM sets EMULTYPE_PF if 
and only if the page fault it a write-protected gfn, i.e. if and only if 
there's a writable memslot.  KVM will never try to redo an instruction 
that failed on emulated MMIO (no slot, or a write to a read-only slot), 
so therefore there's no redo the lookup in reexecute_instruction().

Paolo

> i.e. if and only if there's a writable memslot, there's no need to redo
> the lookup to avoid retrying an instruction that failed on emulated MMIO
> (no slot, or a write to a read-only slot).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 18 ------------------
>   1 file changed, 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 771e67381fce..67f9871990fb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8867,7 +8867,6 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   				  int emulation_type)
>   {
>   	gpa_t gpa = cr2_or_gpa;
> -	kvm_pfn_t pfn;
>   
>   	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
>   		return false;
> @@ -8887,23 +8886,6 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   			return true;
>   	}
>   
> -	/*
> -	 * Do not retry the unhandleable instruction if it faults on the
> -	 * readonly host memory, otherwise it will goto a infinite loop:
> -	 * retry instruction -> write #PF -> emulation fail -> retry
> -	 * instruction -> ...
> -	 */
> -	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
> -
> -	/*
> -	 * If the instruction failed on the error pfn, it can not be fixed,
> -	 * report the error to userspace.
> -	 */
> -	if (is_error_noslot_pfn(pfn))
> -		return false;
> -
> -	kvm_release_pfn_clean(pfn);
> -
>   	/*
>   	 * If emulation may have been triggered by a write to a shadowed page
>   	 * table, unprotect the gfn (zap any relevant SPTEs) and re-enter the


