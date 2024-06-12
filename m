Return-Path: <kvm+bounces-19520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA4A905E4A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 00:14:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0745283EB5
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 22:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4743D12B163;
	Wed, 12 Jun 2024 22:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s//GaH7E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138F143144
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 22:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718230436; cv=none; b=DY4OcXwcKSqJqL2G4I1b+ofP0OYBzfztIMPiIzm+c5imeMF15vNdf7PKOkW7wUxX7RjO/9by3BZMeABwcShwX6n20qYoFSc0Sa60t/DwjIhuhGn9p3niM7kijf1vBJRsuY51FYgInKEFJMSVy0wR4m9Bi8Xhms3MP5JMb36qDFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718230436; c=relaxed/simple;
	bh=GwfBCcHjkevNkWnlhNs7s7LtsNgX3NNWwh13LjsHl2k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dL7aRRthk7D6i1gruc+pRf4C9I0u5hoIfeP6/eNtB2x7juRbDSle7AHwMp561RmRvfzjwIlukh5seDuLnsVyyZy28iwiVyukDqyzgmpZ42AdG/pyKqHePFA1DJHDf1vygNnol9oLSCdCnxBOHiolYqEw8aDp1gGKkDWTSu7FiS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s//GaH7E; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfe148f1549so427762276.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 15:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718230434; x=1718835234; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bPX3/Z0GWf3goqQnQ+80IAoevnNEBGSkkJOiBvmG4jY=;
        b=s//GaH7EOLTmaXUl1rmYJN1rO/2MMS3WFL/FmLQy72muCUwpBXJdkimk4Zp+zGmG56
         Gad94F4y7yknfrh9EMlah0PXnZfI0yM4yiuEWqCOkvDQkuQsqz7YmRxMB7kG2hpSiTW5
         k/5rQYS36eV21ARWug4Xl8y5srpiuW9U3KmaFWunNhB6PQwPswRGB11cwmucIx9Czx4+
         +mNaGCiLxeqkHE6yqosioiE0B9T6M4WWaubTjRMNbuymK5tR2G0BE+x/4DDcjGMgwDJT
         8P23GTan20gqVn7DbXDn4b2mJGh//PkuDWLHI164cWS5qr+fsYCs+hcAi62efO4tWfMK
         FfWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718230434; x=1718835234;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bPX3/Z0GWf3goqQnQ+80IAoevnNEBGSkkJOiBvmG4jY=;
        b=lTEVMGWwm4vGqApzv8xw1s19XAxqpjxr7CNZfaFCx1d190cZ2Rxx49NoXI3+qdJQ/5
         sO3sWdhI38L0BfmGQKgGWIQWAOuwlrsWWKM7hbFQmdtPI82sYH0B/GQY5AlRYpbrUvJJ
         k/BQ2aMrM2DY+W6V+k8dYEjTjzPT95zryI+Jb2X8Af6YbOdE7hT6zh8n9K9B33YvqWUT
         OC3GrvIF9PVxCUGxXYRoTHCwqud/A6gMPRUu3jphuejSaVE0lOBzAZT1yEWMiaiMd1Fw
         7u7NKhXdUmyS4lvpu+np3gwyB6xipuKnqQoJckRxmOuYgIXPFHurrDQFvHKiel/Fy82F
         jU/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXMsIxwoh08osmWizPKtIYSMDEtxCBteOB1ORylEXEv29/H6ZMF1cyuogdTCa4ldMRpgpLI4P1A3uYnvfCosHsk55II
X-Gm-Message-State: AOJu0YzKbKjLMgijgzO4WBPuQnROK31IFLHqj/2ThICalZjoBI+1a2Cq
	QSnfyF/K7rJphD35zjWiMaIxQJdhdHPB908gQhx55rMc4lQC75BayGkjIAMQu0A2ku9v87urkF6
	0mQ==
X-Google-Smtp-Source: AGHT+IHQk/QK4uDOLMVdbV04IdfTlJ2Btibfi42Ivx9v36nGEO3157fO4+iqYDDxzqE9oJh20Eg6PCiUsJk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:150f:b0:de5:2694:45ba with SMTP id
 3f1490d57ef6-dfe62d1ee23mr813079276.0.1718230434092; Wed, 12 Jun 2024
 15:13:54 -0700 (PDT)
Date: Wed, 12 Jun 2024 15:13:52 -0700
In-Reply-To: <20240207172646.3981-12-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240207172646.3981-1-xin3.li@intel.com> <20240207172646.3981-12-xin3.li@intel.com>
Message-ID: <ZmodoHj_ebGza4Sj@google.com>
Subject: Re: [PATCH v2 11/25] KVM: x86: Add kvm_is_fred_enabled()
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin3.li@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	shuah@kernel.org, vkuznets@redhat.com, peterz@infradead.org, 
	ravi.v.shankar@intel.com, xin@zytor.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 07, 2024, Xin Li wrote:
> Add kvm_is_fred_enabled() to get if FRED is enabled on a vCPU.
> 
> Signed-off-by: Xin Li <xin3.li@intel.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> ---
> 
> Change since v1:
> * Explain why it is ok to only check CR4.FRED (Chao Gao).
> ---
>  arch/x86/kvm/kvm_cache_regs.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 75eae9c4998a..1d431c703fdf 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -187,6 +187,23 @@ static __always_inline bool kvm_is_cr4_bit_set(struct kvm_vcpu *vcpu,
>  	return !!kvm_read_cr4_bits(vcpu, cr4_bit);
>  }
>  
> +/*
> + * It's enough to check just CR4.FRED (X86_CR4_FRED) to tell if
> + * a vCPU is running with FRED enabled, because:
> + * 1) CR4.FRED can be set to 1 only _after_ IA32_EFER.LMA = 1.
> + * 2) To leave IA-32e mode, CR4.FRED must be cleared first.
> + *
> + * More details at FRED Spec 6.0 Section 4.2 Enabling in CR4.
> + */
> +static __always_inline bool kvm_is_fred_enabled(struct kvm_vcpu *vcpu)

Maybe just is_fred_enabled(), or even just is_fred()?  Most helpers in x86.h that
wrap CR4/CR0 in similar ways omit the "kvm_", partly for brevity, but also because
the check is architectural, not KVM-defined (though the state obviously comes
from KVM).

> +{
> +#ifdef CONFIG_X86_64
> +	return kvm_is_cr4_bit_set(vcpu, X86_CR4_FRED);
> +#else
> +	return false;
> +#endif
> +}
> +
>  static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
>  {
>  	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
> -- 
> 2.43.0
> 

