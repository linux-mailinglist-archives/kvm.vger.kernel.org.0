Return-Path: <kvm+bounces-57442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B93BB559C8
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 00:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F5CAA06E24
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 22:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8271286D7F;
	Fri, 12 Sep 2025 22:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UjoqhsHB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB442848B4
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 22:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757717731; cv=none; b=MsXHl7YToLQJWPDrGGPWRojJ1eQlktA7rJTiKE+SqbKKb99HABkKIBgIbavVftIRcqjP2fRULwrcMLdqgNB71GCY6qJpopUr/TSI0T8TW96qtk6sQL28V3XjtNHHLIBbA9aJtI+X2A56zF6AN5c7FsIx+kKUAa2wQZJm6u2t4bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757717731; c=relaxed/simple;
	bh=s81gDgnQeGccrS8LsVmeNH8hG65sh8m34+oHvpgsrrI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n55/iroFDJep1QcdrfCEtyperljJhblCviFSGBcNwK+YXmGmghUE4tu+cbxyQp9Vc/XyHhaCU/t2b2gflcryevkwap1KbfWQdtFzCkdFdjYQwmkfCUs9ijq/wrBn/POC8XXIveL9WdLLBvoKtCS+GfoxtTitnawcr5J9aUDywvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UjoqhsHB; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47174bdce2so1722023a12.2
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 15:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757717727; x=1758322527; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M5UxjIlsEgvTF8daNW02GCq6jap774PItnDVhlq0f8c=;
        b=UjoqhsHBA61DXGARwcZ/ROhWFgX4maQIWYOp5mN9IV3MW0X5MWk7xdLBpAeRRCMmUK
         pdtcq2WVt3/qkLjJy9J4cbCRWaBCMWFzWpzRdYMot1MRQiRG3sb8w3/27juv7qVbFYHD
         p4R5d/5O4cL34/hsCTStpRuAb41nW1UjuS5qxnKIlCnCRbMd9WWGP7T9wExKM+SvAby2
         IokeMJjXzdMt8PFiw7++y+hFWdQSmw1pY2ovq8Es0v565lb0OVyNLKcAipNole5ZySiw
         eH236h9HrPy7L/UA9CV+ZpzJ77BMC+Cow0MV1BopuB/yQaptc+ynze6vcxiSUpFUfOps
         j8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757717727; x=1758322527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M5UxjIlsEgvTF8daNW02GCq6jap774PItnDVhlq0f8c=;
        b=geyYDRUKuFFl5L5j2UIYxc7mEdOPDiuVvqkxdkcrXtl8j5BEd8+TLWMkIEepkj4i/j
         3aAeIOWkBKJIBUwZ70UL0XTTyddtFW1uPbLQuNWgtRgAGhgP5paZx8LtIaFETGvd4T8R
         dwpj2s55v+FkXNzfak8CwW6dt7zQj1XYEc8SWM5x7fECm3ECgzp6KtJ4ICnTuw+yTFbk
         1/++W7rN7kuAi1zSkLKI+SqQqCngryeggH4dd9IPxJxhfJZM9SvPuEz30ON53YK1OrIb
         +vk/EUxpWQC0LEj+rCCQrVC+6ZmbKKhXioD9NVO3QMB5G83YTXhffog5ORIOFFTpuiwJ
         QGiQ==
X-Gm-Message-State: AOJu0YyMO0ZBHJiExO5CiG9y2fxEfR8NenoS1pRGBhLOsYvUMzinur85
	tMjIPGpDP2M8TRqrBiGu2IKAfgY4FPl5qazhejD1Bg27zA+leGTVeudC6CNdpiJiFYu8cNhpfzv
	dwAn6OQ==
X-Google-Smtp-Source: AGHT+IEBFW2+no450hTjR9z5hEWHspR3hha0vnhjysBUIwJUVLZG1hVKgUXc1l4Dd+5wBSZ/IjDFCVmvLWg=
X-Received: from plbja20.prod.google.com ([2002:a17:902:efd4:b0:25c:a8a8:add6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f60d:b0:25d:df7a:b1a2
 with SMTP id d9443c01a7336-25ddf7ab591mr33868625ad.5.1757717727608; Fri, 12
 Sep 2025 15:55:27 -0700 (PDT)
Date: Fri, 12 Sep 2025 15:55:25 -0700
In-Reply-To: <20250908201750.98824-2-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250908201750.98824-1-john.allen@amd.com> <20250908201750.98824-2-john.allen@amd.com>
Message-ID: <aMSk3fY7XzScBuOx@google.com>
Subject: Re: [PATCH v4 1/5] KVM: x86: SVM: Emulate reads and writes to shadow
 stack MSRs
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	pbonzini@redhat.com, dave.hansen@intel.com, rick.p.edgecombe@intel.com, 
	mlevitsk@redhat.com, weijiang.yang@intel.com, chao.gao@intel.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 08, 2025, John Allen wrote:
> Emulate shadow stack MSR access by reading and writing to the
> corresponding fields in the VMCB.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e4af4907c7d8..fee60f3378e1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2767,6 +2767,15 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (guest_cpuid_is_intel_compatible(vcpu))
>  			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
>  		break;
> +	case MSR_IA32_S_CET:
> +		msr_info->data = svm->vmcb->save.s_cet;
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		msr_info->data = svm->vmcb->save.isst_addr;
> +		break;
> +	case MSR_KVM_INTERNAL_GUEST_SSP:
> +		msr_info->data = svm->vmcb->save.ssp;
> +		break;
>  	case MSR_TSC_AUX:
>  		msr_info->data = svm->tsc_aux;
>  		break;
> @@ -2999,6 +3008,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
>  		svm->sysenter_esp_hi = guest_cpuid_is_intel_compatible(vcpu) ? (data >> 32) : 0;
>  		break;
> +	case MSR_IA32_S_CET:
> +		svm->vmcb->save.s_cet = data;

These writes should mark VMCB_CET (the dirty/clean flag) dirty, and obviously
KVM should mark VMCB_CET clean along with everything else on #VMEXIT.

> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		svm->vmcb->save.isst_addr = data;
> +		break;
> +	case MSR_KVM_INTERNAL_GUEST_SSP:
> +		svm->vmcb->save.ssp = data;
> +		break;
>  	case MSR_TSC_AUX:
>  		/*
>  		 * TSC_AUX is always virtualized for SEV-ES guests when the
> -- 
> 2.47.3
> 

