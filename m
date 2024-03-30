Return-Path: <kvm+bounces-13160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46943892D85
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 22:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3A53283A3D
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 21:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3505051C44;
	Sat, 30 Mar 2024 21:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AaC50WIk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D084A99C
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 21:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711834544; cv=none; b=llVqaoaCimh+5hmI9zmsnC/iwyzb2E5Hu7QNGoMonpzPGejc///CLaxbkq8Cweg+S1JiGYBT3GW4IXKhqhtyeU45YUqJD3NDZBzyxFgxcr6x2bJ/zqwbjYWUDHB6m51Ve9hV/UuT0jat8CyrbAV3/nk8SjFStB8Gtdb3yUASx7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711834544; c=relaxed/simple;
	bh=A/4nTvH3zcKKDjwq9z7ISuECCM1K8A3A6bBgBipegtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eFNgdjaR4J4Uoz+I3mgxLCqDUhmelqAAHz0lyzdxYao424xVWR2Nhu0tjv7RzRU8+BurJQYRKYCRtuYssoMOcH5fLyOkLqidZ7AIYF220I4hAc3/JVLff8IYWvxugAc9q4yrqtBIOvmWRLQaDqhCFqYWv+xjN9Pyjs5/yvVQ9xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AaC50WIk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711834542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k6nhJ/n2fVMLTJ5orSzZrSN05UZkFdn1WgbErq3l2Pk=;
	b=AaC50WIksL9NXcrY24Vf8866p2pD2dqoSt2KH3Q9m5G0W+ckANKXwFV174bh285mSHdYYp
	Am7Pp2OVACSpmiGTiarIdJ3LjY7U4pMD4dIoEJj3ZGOB4HEAf14Rvx311TLCJXwVJkY5J+
	xI1Knv3RO0diA68TV+qXMsxlED6tSMU=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-DH0MhiZ-NpO52d4IzgoGyw-1; Sat, 30 Mar 2024 17:35:39 -0400
X-MC-Unique: DH0MhiZ-NpO52d4IzgoGyw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-50e91f9d422so2894479e87.2
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 14:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711834538; x=1712439338;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6nhJ/n2fVMLTJ5orSzZrSN05UZkFdn1WgbErq3l2Pk=;
        b=RCf5TMeMQhuiEsqquu6GXQ6GB3m+0/iFcCRbdF6FHT1Iubn/tjzv9lJOylHmfYv5Rd
         0IDLo6EJAZe/Wj/3XMS1gcLnaViQijGQJp80IzzKosq6bJfMwoJ05jO2hHjP2LesRkCL
         ls6tLS8SmE7uOn5J/O8eraI2NB5d2E7aFk5FjrSgdc4szOq6yKDiEsUZh7LD8AZt3x3V
         FjPHhGFDXaTfQRvJNBteXbSAO2dwmd9M+EVjU5OP479DDtLt7PAvHOQhrnFbM2mI+xQ1
         GpaNnNlrtdfoevCxQxcG3X81fpRXiK2IjIEOGdqn+4ljVqkGltjlAiV1zSYWssY4ZXsf
         Yajg==
X-Forwarded-Encrypted: i=1; AJvYcCVsvUr1yfJMqn5TiPVxUHnKx54OrM1lq42sSt5QV6/IUdSjUCRDAopDDLunjYXvT4rMttWkkf9EOqxfV0NgTL6zg5Gv
X-Gm-Message-State: AOJu0Yw78dI/Q4jTJmUdgdVwmJo61d5Dc0X6+N42kKg2Ei0tQZSPKJKn
	85HBFAanKtI/SqjFIhGrwICQQxDWmQLuhNwCXKkLmnck6SXZv02QHXiI7Juury1kcXbmHeR23iX
	H7r5aoSL0elu+EUpX1DdU0z9z4Uju3Ci5pQXkOOY1Vc6cKsnqGw==
X-Received: by 2002:a19:2d18:0:b0:513:b062:98c4 with SMTP id k24-20020a192d18000000b00513b06298c4mr3643259lfj.11.1711834538175;
        Sat, 30 Mar 2024 14:35:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5PGmEGHf24nUfF7B7vuwJRBVN0rKW1MZiU9RQdC6MVZb3TnEUgyIIaZghldmm9GaQfOSwZw==
X-Received: by 2002:a19:2d18:0:b0:513:b062:98c4 with SMTP id k24-20020a192d18000000b00513b06298c4mr3643226lfj.11.1711834537752;
        Sat, 30 Mar 2024 14:35:37 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id w4-20020a1709062f8400b00a4e07f8b6bfsm3445434eji.59.2024.03.30.14.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 14:35:37 -0700 (PDT)
Message-ID: <00800f4b-5403-4416-b984-12b207362a19@redhat.com>
Date: Sat, 30 Mar 2024 22:35:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 24/29] KVM: SEV: Avoid WBINVD for HVA-based MMU
 notifications for SNP
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-25-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-25-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> With SNP/guest_memfd, private/encrypted memory should not be mappable,
> and MMU notifications for HVA-mapped memory will only be relevant to
> unencrypted guest memory. Therefore, the rationale behind issuing a
> wbinvd_on_all_cpus() in sev_guest_memory_reclaimed() should not apply
> for SNP guests and can be ignored.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: Add some clarifications in commit]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/svm/sev.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 31f6f4786503..3e8de7cb3c89 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2975,7 +2975,14 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>   
>   void sev_guest_memory_reclaimed(struct kvm *kvm)
>   {
> -	if (!sev_guest(kvm))
> +	/*
> +	 * With SNP+gmem, private/encrypted memory should be
> +	 * unreachable via the hva-based mmu notifiers. Additionally,
> +	 * for shared->private translations, H/W coherency will ensure
> +	 * first guest access to the page would clear out any existing
> +	 * dirty copies of that cacheline.
> +	 */
> +	if (!sev_guest(kvm) || sev_snp_guest(kvm))
>   		return;
>   
>   	wbinvd_on_all_cpus();


