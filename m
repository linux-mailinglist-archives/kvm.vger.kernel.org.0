Return-Path: <kvm+bounces-26126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 993F7971C00
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 16:01:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A794282D1C
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 14:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C251BB6A9;
	Mon,  9 Sep 2024 13:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PzYdYnQw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83281BA27F
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725890381; cv=none; b=GXR84siPFDDC2iY9JfUumSren4giUODzDG7YpWZ7vQNa71l0IZIGs76RSFtzx0w1RJdK7x0UvEwvNRsKOLjlXOwdvSdtuHZXy5iMTpNEX9AqMTCCw+ebe3I3be2U7rdHZ9umn3sEGRgccbQlUraz++Ef7PgsN5nCxIxwAJdSfWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725890381; c=relaxed/simple;
	bh=uadjIBFc2LCTF1emgtPRKwskaecxd7XchkYDvOQzgdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nIE6JLdB/D635QBzxGG5sU1MqWFiAToO6nHLdYxP2cAtY8vFGX5X/p9MVSPPoNVcw8NVVGbS76WZOQA+BOKhjONWsjgfI1xDUG/4iNfhxb8CXR+dQfKdkwi+UAHy+1SQpvNtsJ+qMoXA1Fo1jbzYk/8rEsrqezooArWPZZYhSp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PzYdYnQw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725890378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BD2LjVHgvEl5ckWt6TDWb206CCNpiCl3W2+fY4tPKko=;
	b=PzYdYnQwIue6vVpB8VSRlUwVDuauBHp8GEhE53JtpBpZauzD8oC9m4kHUcdiWqtNilk1+S
	hYnwPNiCia+7TmfAJaMwE+hzEkOf/eXVnk8/ILsrOU6tbWk4QoyQ1sMdDz78LqnbhhKxsg
	DwRPp8x1FhhI0xeMKKV7YdI0S25qHTg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-dC3gDduoO9-a5no0TJDpjw-1; Mon, 09 Sep 2024 09:59:37 -0400
X-MC-Unique: dC3gDduoO9-a5no0TJDpjw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-374b9617ab0so1850363f8f.3
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 06:59:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725890376; x=1726495176;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BD2LjVHgvEl5ckWt6TDWb206CCNpiCl3W2+fY4tPKko=;
        b=kfNWppie/XeVOttJJ5oyHP4CMBQXp2sML/kGYsb7uxqLKDSyHfQTF0hQDb66M4b1Go
         3GuXUVT84s8XkXpYyDpgQgDtLImOfIpPBVn4mhxWxaMHroc8W1DDp5iWstA609oEsXWe
         APiLQWm+mM7+o3qr1GljTwlewoliFjGAjHNYU1HXjHGCPLukO8pj2r0TbA5JaOUtN14q
         QuAwOIOAsMxjgMdR3W+Pe+kVPT2sNPVzg/D3UHBPe2aFKaES5iuzE5tuwOIjwhTHL+7H
         +N+DgcxNL1DvM3BrOXNNChuUrK1eTtI6nfqzaBp94bqLtn1ZuMTx1XOTxX7zxYO069qf
         iISQ==
X-Forwarded-Encrypted: i=1; AJvYcCUymtpeDfPCkc6Z0uWE8Qa35/G7wATgbOzskeNgSUkVqpmD5XWAfI7CUqoC8xXVWMLkfHM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoQiYFPOVo0QNvtII4fp7q73lDhkqf0VCG+lRzIuG+SWc0TZD9
	RRURAT1EY4aKRXY/rBGtdxG0Dt1o4AZ/SGjM4VFHa3ABClp/9JhTsbuxJ7A59g4lglioS/chqLW
	/MhsQTCmtnxGrvDFCw9iUvZgjCyC6bjnncIjRTZ7+7zdpMGHflg==
X-Received: by 2002:adf:f489:0:b0:374:baf1:41bb with SMTP id ffacd0b85a97d-37892685979mr3763845f8f.3.1725890376212;
        Mon, 09 Sep 2024 06:59:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNaWA+QcPPrm8bvTDzmFg3kG3BrB9jWkRT4CRrCmQChDuuMC4Rev7/APmGPLXzL0N7t7K/Ww==
X-Received: by 2002:adf:f489:0:b0:374:baf1:41bb with SMTP id ffacd0b85a97d-37892685979mr3763824f8f.3.1725890375638;
        Mon, 09 Sep 2024 06:59:35 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42caeb449aesm77452765e9.25.2024.09.09.06.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 06:59:35 -0700 (PDT)
Message-ID: <c4e8842e-4d1b-419f-974c-edaa20ff84d4@redhat.com>
Date: Mon, 9 Sep 2024 15:59:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/21] KVM: VMX: Teach EPT violation helper about private
 mem
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-6-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-6-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> Teach EPT violation helper to check shared mask of a GPA to find out
> whether the GPA is for private memory.
> 
> When EPT violation is triggered after TD accessing a private GPA, KVM will
> exit to user space if the corresponding GFN's attribute is not private.
> User space will then update GFN's attribute during its memory conversion
> process. After that, TD will re-access the private GPA and trigger EPT
> violation again. Only with GFN's attribute matches to private, KVM will
> fault in private page, map it in mirrored TDP root, and propagate changes
> to private EPT to resolve the EPT violation.
> 
> Relying on GFN's attribute tracking xarray to determine if a GFN is
> private, as for KVM_X86_SW_PROTECTED_VM, may lead to endless EPT
> violations.
> 
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU part 2 v1:
>   - Split from "KVM: TDX: handle ept violation/misconfig exit"
> ---
>   arch/x86/kvm/vmx/common.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 78ae39b6cdcd..10aa12d45097 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -6,6 +6,12 @@
>   
>   #include "mmu.h"
>   
> +static inline bool kvm_is_private_gpa(struct kvm *kvm, gpa_t gpa)
> +{
> +	/* For TDX the direct mask is the shared mask. */
> +	return !kvm_is_addr_direct(kvm, gpa);
> +}
> +
>   static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
>   					     unsigned long exit_qualification)
>   {
> @@ -28,6 +34,13 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
>   		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
>   			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
>   
> +	/*
> +	 * Don't rely on GFN's attribute tracking xarray to prevent EPT violation
> +	 * loops.
> +	 */
> +	if (kvm_is_private_gpa(vcpu->kvm, gpa))
> +		error_code |= PFERR_PRIVATE_ACCESS;
> +
>   	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>   }
>   

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>


