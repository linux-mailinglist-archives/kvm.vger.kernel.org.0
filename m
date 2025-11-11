Return-Path: <kvm+bounces-62800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B6D8C4F4CA
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 18:45:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F71E1898B9C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 17:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3752848A2;
	Tue, 11 Nov 2025 17:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h64brTMj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SQDWRIMJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4193AA1A9
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 17:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762883133; cv=none; b=YfI077fVPWkTAvO1IPnP+OSk5+ko/tdnf0G0Y54MyYbHDW1tUjBmaAWQEsGr00npGSdYomw1LlSPIY1GLu5e21z/y8BDQ5PL6JRY12Z7cknQsyK6O2FK1AhaGdU1q8zRIxHR3yfZf8ZBtMkgPgRrjUbAEIpZ7dsm0e8y58kF7cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762883133; c=relaxed/simple;
	bh=qFqfVNv8CY7kl1TbSgBJCASJkrGC7v0dIcn8lg+2R1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ob/TTrVdE7PLtFggHvvzw0R/nAO3pTeNKLu1Ubr8eBCtUwpT6JgSU5SD7s3f5/QSCNmkDmbTBy5IeRYhqnIWkbmiailoTdO9M27ZwmBUz15X6TrHUZXnuzCiS/SMvrZnrvlzpCExwspxBgvwYkTtAQcLzjFY0GoTNAsfd6078f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h64brTMj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SQDWRIMJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762883130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aRxMT/jej8MFjJFwaDpo3RirJca38pxpSFHOzHKFSiY=;
	b=h64brTMjuOhDmESZT2vrI44+XMYqaO29x1ODz0PBDLdu/aFwzUm7jmuNkjgW+SPoeBIHHq
	FMlPOwUAQwcYCVfYOZiicXnGigyVqnFCPn/SA1QZ14Hls0IR8EIWTxGILC+Ogff28r1AeJ
	dyTqz42c75pjN1wPF/XvIuhcGPCssHo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-0PvcmE01M8iX-MGZoeBYzg-1; Tue, 11 Nov 2025 12:45:28 -0500
X-MC-Unique: 0PvcmE01M8iX-MGZoeBYzg-1
X-Mimecast-MFC-AGG-ID: 0PvcmE01M8iX-MGZoeBYzg_1762883128
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-429c95fdba8so1853698f8f.0
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 09:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762883127; x=1763487927; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aRxMT/jej8MFjJFwaDpo3RirJca38pxpSFHOzHKFSiY=;
        b=SQDWRIMJB7vmhVpBpkXW0Ecc+3bKUkEV6/QjtPUpsonCmyO1HFSYQKnwqLBluO9tby
         tiQ4UEOjd7nCZ03/5s6ChMTnyZxkDCeE352oX1uZvD1bLqf/N8TVOcU1f29Yo4PWRu/e
         EXux/VQaGX7GAAyYSoh7lwWPZ+wS6JqAU3LgMx91BKidMx95GACsaU6v0kjOEPMOwjKC
         m0hcDmfqZ/cs03I9BQvyS72lQX3oftn9pWzXof6bLlONMazGQwLvqt3LF3tTbOexl86O
         WsMrch8+V3Zc2NwOpVeHQQ1FkSYKWgzVRY/kHmgO849zzrKuonnEax+c4J++XTjuNNXq
         ugrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762883127; x=1763487927;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aRxMT/jej8MFjJFwaDpo3RirJca38pxpSFHOzHKFSiY=;
        b=dpnrvwr8d8/0pXuT5slvCcXTaY9hjYplR95YSDBxG9i8sOVEN+yc0fmKTsDZ+2uTdV
         tjzuprX7eM2sl6IkXE5XOFuQjkzU9GTLcKQyOmffD/APTGpVM2oRdKO0/VedFokInqCw
         rN/UUSKBJbC2ujnWjnsmk7IeBFaPEJXoM62+V95OpE8ps64jqLShj7ZyN+BURu9AhwZd
         RIwRpaOqRSse/0Pc5+7m6Z1tdoU7DwybWv7u9HPK5aySSf2kOamClD3z4YVYPcaF+SCp
         njJQcPGXESIWVlopd8FjPz7RyBsiV8abQ2AXkDCMrqUgNRhi5VKLFBaD/BWPgcqoxsM+
         voBw==
X-Forwarded-Encrypted: i=1; AJvYcCVzEJSRANzdDDJFawDcipHDxKyZwS7JtzEptjdAyH56HoPtbDZvfLGWHxoAJtELt4mwlCM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXRjT8aHFJ//ip9nRyXMSNSkdpbdJTBOElg08azLj2P5cDIBRh
	zhdxv2ffQtdgTMJ1jrQDfa6FjOZoEWmxM66fR3krSLZ+qUx98FGxi6FKZjtDc79JI8qkNllUup5
	2r9g+AIDT8YT3u1XQywIoNKGKevr0SwyLsDDPO4Ggjpi6zmXRZu+Hfg==
X-Gm-Gg: ASbGncv61QcxqzJSYwcZH4U8ujhvPtx5UxVnaKXkKmDJEzB4GCL0dcuJQ9IScy8j9Dt
	t1HbJ7rtUJVd++NxtB63xfiBdOPAKzMSxepljOwiiI0XZsRalAQueag3vSMNSkMqw1Qk0Ca38Of
	Jo67TmqtA6EHgXXHxJ/pMGC1QwcTZChVKxkbRNT6nSKsV1xItzX2HbBz2IZIxoRn+9zR2iG/fmC
	XLV2LQyHS43yN4P8n+kvwrYx/OSXve/dSjBHBOpa2BKpL0YcZcpbkz2qxxQkTvW7zITT8z5ai27
	SlnEq7/RZgZT+DRb9vJ7r0PIO1J1zH/FE4Ti5awpQOtSJA7X0g3rUyLj/VqYEZxVOWZIm2lUEm4
	4ZgyQaxe19ZEoykPJe4oJwF93Xw1a4ffxU6u3DwLb+O+UrkYeGBKfG78a9/G+vp1Q1iHq5E1fT/
	gJyq/Gnw==
X-Received: by 2002:a05:6000:2dc1:b0:42b:30d4:e3f0 with SMTP id ffacd0b85a97d-42b4bb93645mr58480f8f.22.1762883127647;
        Tue, 11 Nov 2025 09:45:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4iotn4s//bsY/hXaMRsE/Z1iP1fzTtupCR3bGIiAkiu5lxA8fj5eP9KfVURpbWXHL/LzIIw==
X-Received: by 2002:a05:6000:2dc1:b0:42b:30d4:e3f0 with SMTP id ffacd0b85a97d-42b4bb93645mr58456f8f.22.1762883127259;
        Tue, 11 Nov 2025 09:45:27 -0800 (PST)
Received: from [192.168.10.81] ([176.206.111.214])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-42ac677abeasm29848626f8f.33.2025.11.11.09.45.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 09:45:26 -0800 (PST)
Message-ID: <7bb14722-c036-4835-8ed9-046b4e67909e@redhat.com>
Date: Tue, 11 Nov 2025 18:45:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 08/20] KVM: VMX: Support extended register index in
 exit handling
To: "Chang S. Bae" <chang.seok.bae@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: seanjc@google.com, chao.gao@intel.com, zhao1.liu@intel.com
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-9-chang.seok.bae@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 xsEhBFRCcBIBDqDGsz4K0zZun3jh+U6Z9wNGLKQ0kSFyjN38gMqU1SfP+TUNQepFHb/Gc0E2
 CxXPkIBTvYY+ZPkoTh5xF9oS1jqI8iRLzouzF8yXs3QjQIZ2SfuCxSVwlV65jotcjD2FTN04
 hVopm9llFijNZpVIOGUTqzM4U55sdsCcZUluWM6x4HSOdw5F5Utxfp1wOjD/v92Lrax0hjiX
 DResHSt48q+8FrZzY+AUbkUS+Jm34qjswdrgsC5uxeVcLkBgWLmov2kMaMROT0YmFY6A3m1S
 P/kXmHDXxhe23gKb3dgwxUTpENDBGcfEzrzilWueOeUWiOcWuFOed/C3SyijBx3Av/lbCsHU
 Vx6pMycNTdzU1BuAroB+Y3mNEuW56Yd44jlInzG2UOwt9XjjdKkJZ1g0P9dwptwLEgTEd3Fo
 UdhAQyRXGYO8oROiuh+RZ1lXp6AQ4ZjoyH8WLfTLf5g1EKCTc4C1sy1vQSdzIRu3rBIjAvnC
 tGZADei1IExLqB3uzXKzZ1BZ+Z8hnt2og9hb7H0y8diYfEk2w3R7wEr+Ehk5NQsT2MPI2QBd
 wEv1/Aj1DgUHZAHzG1QN9S8wNWQ6K9DqHZTBnI1hUlkp22zCSHK/6FwUCuYp1zcAEQEAAc0j
 UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT7CwU0EEwECACMFAlRCcBICGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRB+FRAMzTZpsbceDp9IIN6BIA0Ol7MoB15E
 11kRz/ewzryFY54tQlMnd4xxfH8MTQ/mm9I482YoSwPMdcWFAKnUX6Yo30tbLiNB8hzaHeRj
 jx12K+ptqYbg+cevgOtbLAlL9kNgLLcsGqC2829jBCUTVeMSZDrzS97ole/YEez2qFpPnTV0
 VrRWClWVfYh+JfzpXmgyhbkuwUxNFk421s4Ajp3d8nPPFUGgBG5HOxzkAm7xb1cjAuJ+oi/K
 CHfkuN+fLZl/u3E/fw7vvOESApLU5o0icVXeakfSz0LsygEnekDbxPnE5af/9FEkXJD5EoYG
 SEahaEtgNrR4qsyxyAGYgZlS70vkSSYJ+iT2rrwEiDlo31MzRo6Ba2FfHBSJ7lcYdPT7bbk9
 AO3hlNMhNdUhoQv7M5HsnqZ6unvSHOKmReNaS9egAGdRN0/GPDWr9wroyJ65ZNQsHl9nXBqE
 AukZNr5oJO5vxrYiAuuTSd6UI/xFkjtkzltG3mw5ao2bBpk/V/YuePrJsnPFHG7NhizrxttB
 nTuOSCMo45pfHQ+XYd5K1+Cv/NzZFNWscm5htJ0HznY+oOsZvHTyGz3v91pn51dkRYN0otqr
 bQ4tlFFuVjArBZcapSIe6NV8C4cEiSTOwE0EVEJx7gEIAMeHcVzuv2bp9HlWDp6+RkZe+vtl
 KwAHplb/WH59j2wyG8V6i33+6MlSSJMOFnYUCCL77bucx9uImI5nX24PIlqT+zasVEEVGSRF
 m8dgkcJDB7Tps0IkNrUi4yof3B3shR+vMY3i3Ip0e41zKx0CvlAhMOo6otaHmcxr35sWq1Jk
 tLkbn3wG+fPQCVudJJECvVQ//UAthSSEklA50QtD2sBkmQ14ZryEyTHQ+E42K3j2IUmOLriF
 dNr9NvE1QGmGyIcbw2NIVEBOK/GWxkS5+dmxM2iD4Jdaf2nSn3jlHjEXoPwpMs0KZsgdU0pP
 JQzMUMwmB1wM8JxovFlPYrhNT9MAEQEAAcLBMwQYAQIACQUCVEJx7gIbDAAKCRB+FRAMzTZp
 sadRDqCctLmYICZu4GSnie4lKXl+HqlLanpVMOoFNnWs9oRP47MbE2wv8OaYh5pNR9VVgyhD
 OG0AU7oidG36OeUlrFDTfnPYYSF/mPCxHttosyt8O5kabxnIPv2URuAxDByz+iVbL+RjKaGM
 GDph56ZTswlx75nZVtIukqzLAQ5fa8OALSGum0cFi4ptZUOhDNz1onz61klD6z3MODi0sBZN
 Aj6guB2L/+2ZwElZEeRBERRd/uommlYuToAXfNRdUwrwl9gRMiA0WSyTb190zneRRDfpSK5d
 usXnM/O+kr3Dm+Ui+UioPf6wgbn3T0o6I5BhVhs4h4hWmIW7iNhPjX1iybXfmb1gAFfjtHfL
 xRUr64svXpyfJMScIQtBAm0ihWPltXkyITA92ngCmPdHa6M1hMh4RDX+Jf1fiWubzp1voAg0
 JBrdmNZSQDz0iKmSrx8xkoXYfA3bgtFN8WJH2xgFL28XnqY4M6dLhJwV3z08tPSRqYFm4NMP
 dRsn0/7oymhneL8RthIvjDDQ5ktUjMe8LtHr70OZE/TT88qvEdhiIVUogHdo4qBrk41+gGQh
 b906Dudw5YhTJFU3nC6bbF2nrLlB4C/XSiH76ZvqzV0Z/cAMBo5NF/w=
In-Reply-To: <20251110180131.28264-9-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/25 19:01, Chang S. Bae wrote:
> Support to 5-bit register indices in VMCS fields when EGPRs are enabled.
> 
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> ---
> RFC note:
> The "chicken bit" (XCR0.APX) checker is intentionally deferred, as the
> emulator in the next series will do a similar check. Consolidating the
> XCR0 handling at the end keeps the logic clearer during the feature
> exposition.
> ---
>   arch/x86/kvm/vmx/vmx.h | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index b8da6ebc35dc..6cf1eb739caf 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -374,12 +374,17 @@ struct vmx_insn_info {
>   
>   static inline bool vmx_egpr_enabled(struct kvm_vcpu *vcpu __maybe_unused) { return false; }
>   
> -static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu *vcpu __maybe_unused)
> +static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu *vcpu)
>   {
>   	struct vmx_insn_info insn;
>   
> -	insn.extended  = false;
> -	insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
> +	if (vmx_egpr_enabled(vcpu)) {
> +		insn.extended   = true;
> +		insn.info.dword = vmcs_read64(EXTENDED_INSTRUCTION_INFO);
> +	} else {
> +		insn.extended  = false;
> +		insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
> +	}

Could this use static_cpu_has(X86_FEATURE_APX) instead, which is more 
efficient (avoids a runtime test)?

>   	return insn;
>   }
> @@ -415,7 +420,10 @@ static __always_inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
>   
>   static inline int vmx_get_exit_qual_gpr(struct kvm_vcpu *vcpu)
>   {
> -	return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
> +	if (vmx_egpr_enabled(vcpu))
> +		return (vmx_get_exit_qual(vcpu) >> 8) & 0x1f;
> +	else
> +		return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;

Can this likewise mask against 0x1f, unconditionally?

Paolo

>   }
>   
>   static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)


