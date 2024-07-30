Return-Path: <kvm+bounces-22654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA1D0940D36
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 11:17:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28EFC1F24648
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:17:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A775194ACD;
	Tue, 30 Jul 2024 09:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FsaST5ui"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47FC194AC7
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 09:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722331013; cv=none; b=favfQj8PoED79gFV109iHsc+s6CdVZnvRWya5t+k3qcEax9u4t2LdaTNtLfIxmN47HEGGfgl9+Y4N7Uw1Fe/2BcPGS2Y36o0kAUT0eCHQA/FQzkcYStFdtjYRNEo+Kqnz9eXtlm1vJ2PmuGlpb3pDW+qayuE8E9Jdov0VDqvxpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722331013; c=relaxed/simple;
	bh=RujWWFICNS+D3KtquiXXKYFpSP4yMEPxvb8x0tkvbGg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wy+wy3CPTUGJSIoUvP0d51V+zP5YTIVIKcCuEpFfsL75FWjDM38FgLNI/3+Pi2DRj//avF5g6ZbTYpFMT8Se/irm8SqKmXJ3I76l+56eNWRIY4+pMTos0U0rTM3ScuqWy70IXZM9avPKwWYZgwuNQUhZEiPkMmql3pgSTrcuu3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FsaST5ui; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722331010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wSoM14Hbf8JWs7i+OFUf4B4qSfihpmSQKAXrIRgdk1Q=;
	b=FsaST5uiIFtUY5E1HpK4WVMWvX5nucACBCNyS8O8Cku73AOY/cmZDFG6D5her0WGSG6BAn
	/p60Rf3KByGRpTQ/EiBm+/bDEbOveynz84Pclsvp+I4w3i10/0UqPtkVSMKT97MpD7mGnR
	vqYVFQr7rEU8pxQT5ygPlYhE7buwv9M=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-aSOqD3fKOPK_T7V8XBcMnw-1; Tue, 30 Jul 2024 05:16:48 -0400
X-MC-Unique: aSOqD3fKOPK_T7V8XBcMnw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-52fcb0f226bso5440971e87.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 02:16:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722331007; x=1722935807;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wSoM14Hbf8JWs7i+OFUf4B4qSfihpmSQKAXrIRgdk1Q=;
        b=SXi4MgSQSAbBMiL1N4LcqQaD1jtTzm0jqoJMqJbU7S6FmH44uwyN54YTXLqi+Gj0ZV
         T4mglan+Dr0miqqT5nzLBGYuAm4vujH9EiWye8tJgdmXzyRwN80TwrXLaCLcXoY3JVLH
         OQBj3kjF9BSUoV0SaOAYdFk7Gyrm9P4BWed6gkwmRO7PkurGi4rTAjYCY6YhPUTC51kD
         gzplkPOpFhDuvGBt8zs2IGmToP/pUhfF20z9SoQSis+7t9afMG68i+uuV5DecEq/CH4a
         Hn97nDCPuDSqaOXzTqZctgiahrDX7mD6IDQuD9QQYkzGU+QCL3g1PAjVT2pDfApH/dEw
         +wxw==
X-Gm-Message-State: AOJu0YwY99YWij211/qQ/BNE1LelMNh7TvhH8L8+hWZHLN1yjpTrdC+x
	dIch8wTto/QV0oY7WKMJPYKn4LuYyTvelmrZtGlh7wj6ciff9UJI07HJ2y3VxnW0Ao5tmGg54vO
	i8VTgy6CFMhv2UEMGNS5IytLQNcTLe/kesXxTAslVckJm7BDJMQ==
X-Received: by 2002:ac2:4f12:0:b0:530:aa4b:81c7 with SMTP id 2adb3069b0e04-530aa4b8305mr2006857e87.59.1722331006985;
        Tue, 30 Jul 2024 02:16:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUF9I37oQHPenEa9PRrwCd26iqWipagbaN7wiWJUc1E4LVMqyaRp/Za4G9rA85eSycTZnByA==
X-Received: by 2002:ac2:4f12:0:b0:530:aa4b:81c7 with SMTP id 2adb3069b0e04-530aa4b8305mr2006827e87.59.1722331006424;
        Tue, 30 Jul 2024 02:16:46 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a7acab4ded1sm618552566b.56.2024.07.30.02.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 02:16:45 -0700 (PDT)
Message-ID: <db00e68b-2b34-49e1-aa72-425a35534762@redhat.com>
Date: Tue, 30 Jul 2024 11:16:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/mmu: Conditionally call kvm_zap_obsolete_pages
To: flyingpenghao@gmail.com, seanjc@google.com
Cc: kvm@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>
References: <20240730053215.33768-1-flyingpeng@tencent.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240730053215.33768-1-flyingpeng@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 07:32, flyingpenghao@gmail.com wrote:
> 
> When tdp_mmu is enabled, invalid root calls kvm_tdp_mmu_zap_invalidated_roots
> to implement it, and kvm_zap_obsolete_pages is not used.
> 
> Signed-off-by: Peng Hao<flyingpeng@tencent.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 901be9e420a4..e91586c2ef87 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6447,7 +6447,8 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>   	 */
>   	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
>   
> -	kvm_zap_obsolete_pages(kvm);
> +	if (!tdp_mmu_enabled)
> +		kvm_zap_obsolete_pages(kvm);
>   

Can't you have obsolete pages from the shadow MMU that's used for 
nested (nGPA->HPA) virtualization?

Paolo


