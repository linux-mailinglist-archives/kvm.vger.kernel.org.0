Return-Path: <kvm+bounces-62801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03CEDC4F4F4
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 18:49:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5A15189E115
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 17:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA96393DF6;
	Tue, 11 Nov 2025 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Aeu0tref";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mAWjL/J2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDF722157B
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762883344; cv=none; b=E4XjCp/z3dOpQYW0dNY0tZgmrLm92zdFLc5gkILNR8Seop2oHGN2HaTC66t/bGsOWtl+wixH1Prfu24kxH/rGCwkOk5jvI5aGQPVKK95DFW53rgNi3h0vPhwDv8c5F9cVHjRw6cYV3tPFHgVGDPK3pMTU6EG4O9mZlNbu5lJ4ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762883344; c=relaxed/simple;
	bh=LgfSEHm5E8c0ifvyByIniNQ1/eAtlEy8YYfec15ztiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gsf1Vo55zQPWhua91JUNFbmeszNMjuKSFFMB5MnH5CQNhx1nz08JE0pa6Up9C46fIsQ/TR+/2jTTlVREVonIXVFGzBFoJHmA+vNAwT5ol3Xzj3DQ9XLxZoHCg2rlMBgJC8yvax6ua3E0j0lvhH0DGrK5UhZrKmoQRyU5Q6bs+mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Aeu0tref; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mAWjL/J2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762883341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Ir3GNyu8K7+Ql/2pFj7EGPETpq94G110GW5lctbTuc=;
	b=Aeu0treffxzxqSwxxpJfqSxuSnAy9bMkdBW3PrTB9P/cRnl6ii/Su1TTq7b1foiV3wWSwk
	PdxAT5IdKvYaJW+jd5CBDgH9rfjfccGA7It0Pju/31k5uYKvVBQFT3IP37yisqT5l6JTny
	JplQrh0EwzMyH/SbDUaEaw3vlC/9jkY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-1sCgbiALO_OVfzd-dIunkg-1; Tue, 11 Nov 2025 12:49:00 -0500
X-MC-Unique: 1sCgbiALO_OVfzd-dIunkg-1
X-Mimecast-MFC-AGG-ID: 1sCgbiALO_OVfzd-dIunkg_1762883339
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b2ad2a58cso1833468f8f.0
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 09:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762883338; x=1763488138; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0Ir3GNyu8K7+Ql/2pFj7EGPETpq94G110GW5lctbTuc=;
        b=mAWjL/J2LtwppM4QiVON2K4nmdtQzx+VTRA0Faig5fG/mwshCzr4khlQqTSGtPc+Ie
         Qy3WWYnYK1U1BfoHb/e0iN6c1S0o7MChc+CaClWECzUckg5XVXOH9KkDLK/S6I2VfdTR
         Gzw5j/rv9LhN6EO2Z3LTEy3P6/2ck82TA08crFZ3DY/c8BbTqpnQvKs+YidkUe0pmogd
         +JUVHiG0w+bj0tyq6c+lx8oMuryRUwvTpZWRSHOPPt1PNvrt/1jsMEkcUD+2eMW7KoxP
         iU9TAMeGgyB2biFcvWIzQGk2dw6QB+UApj31iNv8Tjg9wBOxwCCl/Nbc2QZWqLEpm57O
         VSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762883338; x=1763488138;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Ir3GNyu8K7+Ql/2pFj7EGPETpq94G110GW5lctbTuc=;
        b=SIyctP2Yh+5RsJi13d2NsrF5LXafP7fFsXg5PI2aJFlfgoZT1X3L4GYEgL5+Mbv9qJ
         cIUPKshNbtsBzb/COZb/AFqc7TYknXSRZ1Nao38+lJxxkd6ALzuAowUCwF/l/ZuWdFqW
         D/p2B4pspp0VW4Ay4PFDvzqwTAFDCDQBO89DKLk2oLHd9u9d91v7kH2H6hOEtgLwgRxv
         OOU5LVvSCHObZmtWsIqKGeqp3MQhhagmtmTVzqUgnOQ1uQbbe/uKKVz5KanqezqMzxzf
         1x7SvKM6r6m9/saIKi9tWZCfKnf60/XNFVOOKajK48uBa499l92cjH640ig6rGc7/QSx
         QvgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsWzDBwU7wNCy57RDLE1N4k3H5UN/4onW0V6exg7JTUNdP+3CsY64V0L3Ybj6URxtSjnw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDY/SJOO/WkSfhuBlZFdC8zlDsoBWMh3eymaewMQ9mJhU3//U+
	7D+CWYq4o3OGESwRBM/q/9qhVHe49nNlfUoEteydM3jsneWJZo4iOfxgaAqGYh7ZI9IPcrq5tpj
	mnCN6t7S8+ktcktgmGv6wJLF/ycj5RsdEksu3NEP3Rp8n5aAR3tXe22RMfAKvAw==
X-Gm-Gg: ASbGncvgeoIHt0WlNy8RGuEFm0FoukY9fjHoHypuuhkmLAFsGOEKZBSSZq4XjPu5Tgr
	e4A49sMj7/d91pb/pM7nlORbX6+ySv5/yv5SBXN1zrRfqx1MH30TGF9iT79Vame5OcRYrFA6lxI
	epzHC61XtlU8XtEZuyfz84vrfG36qlrdr3yFvwo3y33VtRb2YKaZiMHgmPJrArvrRklxds6aiHm
	R5JiGJPotcDiVBUrym0cEPBE2JzmQrlDeIK7nhFJGel/H/8W40Om+UXMfFXfJ4uVuqEM5rt9VfK
	iCpQvV+9rmA7Vsk/dKKdKjuQY+ryO0HB8B3Gdseqm12yP0fvR6yKFEjPLdoeNtt8JAIwkQNpneG
	R0NqCE9SzW/WUg4aiKEd4XLoRn03ujY14cm9fd4+Hldg4Lzi5Ypd95GU60aIQkhTxnZiRheGd3x
	zRJ3dRpA==
X-Received: by 2002:a05:6000:24c2:b0:429:c450:8fad with SMTP id ffacd0b85a97d-42b4bdb8c17mr44709f8f.53.1762883337893;
        Tue, 11 Nov 2025 09:48:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGpJqHhquYMTbCx1S1xFecjmlzL5ZP61ooK/fmIld3/vUnPpo6ngWbwqeyiPh5gU0D+c1VmlQ==
X-Received: by 2002:a05:6000:24c2:b0:429:c450:8fad with SMTP id ffacd0b85a97d-42b4bdb8c17mr44688f8f.53.1762883337515;
        Tue, 11 Nov 2025 09:48:57 -0800 (PST)
Received: from [192.168.10.81] ([176.206.111.214])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-42ac677ab75sm28258289f8f.35.2025.11.11.09.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 09:48:54 -0800 (PST)
Message-ID: <ebda0c03-b21e-48df-a885-8543882a3f3b@redhat.com>
Date: Tue, 11 Nov 2025 18:48:53 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 07/20] KVM: nVMX: Support the extended instruction
 info field
To: "Chang S. Bae" <chang.seok.bae@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: seanjc@google.com, chao.gao@intel.com, zhao1.liu@intel.com
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-8-chang.seok.bae@intel.com>
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
In-Reply-To: <20251110180131.28264-8-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/10/25 19:01, Chang S. Bae wrote:
> Define the VMCS field offset for the extended instruction information and
> handle it for nested VMX.
> 
> When EGPRs are available, VMX provides a new 64-bit field to extend the
> legacy instruction information, allowing access to the higher register
> indices. Then, nested VMX needs to propagate this field between L1 and
> L2.
> 
> The EGPR checker will be implemented later.
> 
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> ---
> RFC note:
> During the draft, I brought up the offset definition initially for
> non-nested VMX primarily. Then, I realized the switching helper affects
> nVMX code anyway. Due to this dependency, this change is placed first
> together with the offset definition.
> ---
>   arch/x86/include/asm/vmx.h | 2 ++
>   arch/x86/kvm/vmx/nested.c  | 2 ++
>   arch/x86/kvm/vmx/vmcs12.c  | 1 +
>   arch/x86/kvm/vmx/vmcs12.h  | 3 ++-
>   arch/x86/kvm/vmx/vmx.h     | 2 ++
>   5 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index c85c50019523..ab0684948c56 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -264,6 +264,8 @@ enum vmcs_field {
>   	PID_POINTER_TABLE_HIGH		= 0x00002043,
>   	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
>   	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
> +	EXTENDED_INSTRUCTION_INFO	= 0x00002406,
> +	EXTENDED_INSTRUCTION_INFO_HIGH	= 0x00002407,
>   	VMCS_LINK_POINTER               = 0x00002800,
>   	VMCS_LINK_POINTER_HIGH          = 0x00002801,
>   	GUEST_IA32_DEBUGCTL             = 0x00002802,
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 97ec8e594155..3442610a6b70 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4798,6 +4798,8 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>   		vmcs12->vm_exit_intr_info = exit_intr_info;
>   		vmcs12->vm_exit_instruction_len = exit_insn_len;
>   		vmcs12->vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
> +		if (vmx_egpr_enabled(vcpu))
> +			vmcs12->extended_instruction_info = vmcs_read64(EXTENDED_INSTRUCTION_INFO);

 From patch 17:

+static inline bool vmx_egpr_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.xcr0 & XFEATURE_MASK_APX && is_64_bit_mode(vcpu);
+}

but here you must not check XCR0, the extended instruction information 
field is always available.  The spec says "A non-Intel® APX enabled VMM 
is free to continue using the legacy definition of the field, since lack 
of Intel® APX enabling will guarantee that regIDs are only 4-bits, 
maximum" but you can also use the extended instruction information field 
if you want.  So, I'd make this also static_cpu_has(X86_FEATURE_APX).

Paolo

>   
>   		/*
>   		 * According to spec, there's no need to store the guest's
> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
> index 4233b5ca9461..ea2b690a419e 100644
> --- a/arch/x86/kvm/vmx/vmcs12.c
> +++ b/arch/x86/kvm/vmx/vmcs12.c
> @@ -53,6 +53,7 @@ const unsigned short vmcs12_field_offsets[] = {
>   	FIELD64(XSS_EXIT_BITMAP, xss_exit_bitmap),
>   	FIELD64(ENCLS_EXITING_BITMAP, encls_exiting_bitmap),
>   	FIELD64(GUEST_PHYSICAL_ADDRESS, guest_physical_address),
> +	FIELD64(EXTENDED_INSTRUCTION_INFO, extended_instruction_info),
>   	FIELD64(VMCS_LINK_POINTER, vmcs_link_pointer),
>   	FIELD64(GUEST_IA32_DEBUGCTL, guest_ia32_debugctl),
>   	FIELD64(GUEST_IA32_PAT, guest_ia32_pat),
> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
> index 4ad6b16525b9..2146e45aaade 100644
> --- a/arch/x86/kvm/vmx/vmcs12.h
> +++ b/arch/x86/kvm/vmx/vmcs12.h
> @@ -71,7 +71,7 @@ struct __packed vmcs12 {
>   	u64 pml_address;
>   	u64 encls_exiting_bitmap;
>   	u64 tsc_multiplier;
> -	u64 padding64[1]; /* room for future expansion */
> +	u64 extended_instruction_info;
>   	/*
>   	 * To allow migration of L1 (complete with its L2 guests) between
>   	 * machines of different natural widths (32 or 64 bit), we cannot have
> @@ -261,6 +261,7 @@ static inline void vmx_check_vmcs12_offsets(void)
>   	CHECK_OFFSET(pml_address, 312);
>   	CHECK_OFFSET(encls_exiting_bitmap, 320);
>   	CHECK_OFFSET(tsc_multiplier, 328);
> +	CHECK_OFFSET(extended_instruction_info, 336);
>   	CHECK_OFFSET(cr0_guest_host_mask, 344);
>   	CHECK_OFFSET(cr4_guest_host_mask, 352);
>   	CHECK_OFFSET(cr0_read_shadow, 360);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 64a0772c883c..b8da6ebc35dc 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -372,6 +372,8 @@ struct vmx_insn_info {
>   	union insn_info info;
>   };
>   
> +static inline bool vmx_egpr_enabled(struct kvm_vcpu *vcpu __maybe_unused) { return false; }
> +
>   static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu *vcpu __maybe_unused)
>   {
>   	struct vmx_insn_info insn;


