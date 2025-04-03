Return-Path: <kvm+bounces-42603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8B7DA7B014
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53BB33AE527
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C85824EAA0;
	Thu,  3 Apr 2025 20:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VdA2cbGo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7641E257423
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710672; cv=none; b=DrWvUHwPSovx2mQO0lMN9dMCpJbGqnEDt6nmJ36yv1p70RGUqMdAPHcEVAL3qB5FH12q0WKWQ61QeoSBlIyxs41BMTGubCXKqUMh0aWck2GVqEui5M3JJAnwZDdJI374hmh6w/efwUJGw2f0edEjzG6MFKTQ0kXfw8+/NeJvZbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710672; c=relaxed/simple;
	bh=AH4J3DuNwTnChu/7r8I6VQ6X1tqQrfaGgbCXpv52MsY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RrUWqK7BYOHpbIkj/uEcUTDNsNj0qiVAOyQ1PXjAAzs5eem/Byh5w8WjRIQxndqRT2LFwH/ZjvIKK4N0iKx3J0KTmejaygT5xQrjDUkjLbKR5mrGbt9nnMMphsoAXiSk9DymCKSet5Jf/H0Yrk83b1dtKMz6XbfJomaEsM63UTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VdA2cbGo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743710669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y4rtz3oVK3jnDeigZKXEGQ7kxzJIURgIIDBtTHH9UTU=;
	b=VdA2cbGow99gPp4ngscbYTORoLh55/QiZS3Q6OfNCxgiNEaF3nlfVM6tuI5FAhuTWV4SmI
	0iouTpALwAXxzU5gJgTZr45l+d7eK0FWob9LKeG58T7lZ9hpZhrIrkwtGsh8luvX455XYs
	+aAhR6Llway9hasLagUw0JSjQiAVDVw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-UZIicV0ePvaZDrRJzz_8lg-1; Thu, 03 Apr 2025 16:04:27 -0400
X-MC-Unique: UZIicV0ePvaZDrRJzz_8lg-1
X-Mimecast-MFC-AGG-ID: UZIicV0ePvaZDrRJzz_8lg_1743710667
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-476870bad3bso23037461cf.3
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743710667; x=1744315467;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y4rtz3oVK3jnDeigZKXEGQ7kxzJIURgIIDBtTHH9UTU=;
        b=EcVgvCVMGfUpPztXQjsItb8me8GrulXFRLbbdBd77KXubj7yO5ROW/vUKP43qZUM8O
         kswkwAMbk+5FgmleHlEQn4EqS879zDN/6PDYVPV33M8T91crDP5TsTPlikGdyDj4FtQe
         MFnWzBOh+O9mhcEhLVANOEzsyOR9B2w+1Uz+RrsMzKTm6yQn6IM0kPgKgWBmCM0Nn+S4
         INnoQllfLGzx6aHIEdqDJCq053+4dWJag34aLPvSLzOsC1303U9flE/jXR9VcL79sPcF
         /KAdZoxX0M0VL5GYoUJKnbGsJKs+kyhi1wykMDhbQyXbyS5tT2VG4yXw9te9oJN+Jo4b
         q2Hg==
X-Forwarded-Encrypted: i=1; AJvYcCXhHSvmA/YKGE8rZFMflZQk+sdpe5qGorpGhLGoKDMb8CIYnmQA9MscjSw1BNojZlvm1FU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJjtLHn0+6TiqBNUI1oURB02rl15S70uzFIIaIJ8zmGYIKl0YS
	2+xNqE1QJTzsH01avh7PR7BvGeU+bs+08b2mcMXwtaCeCk4JB2IOuBA5ERxvNi4LPItCLBjf37p
	TCTyYEz0wfY8Q7ne8SZ0lhbV/UwlpYe85dOuaA3Oo8DiknM/9hg==
X-Gm-Gg: ASbGnct+a8XZw8BQ1KuGppwoOb6qsVpwZmXkPO2+e+yI1YQfmgoFvX+HSW8j5monqsN
	NF2e4t5TkE1qn6RwUGWTWYdb9Kzf1Zvbz9KQIe25/uo9hTE6lWFEuQzakjzQSCjyKu5kzx3Rx1E
	lj5zKRs0JyZJUZIkxFBMvzNb3qCsqAbhki9oXIf6bukc9KiLtHs+MFagx7IBaitdAwynwNUMm6C
	GIdxKQqg1QmyaXVUbPd52JsMxMACQzjSfsKVv4lC6vbHtDiQqyJ/pZDEbVP8DuUezwq+EimnKfI
	9487nUkv8WiAmCA=
X-Received: by 2002:a05:622a:448:b0:476:8288:955f with SMTP id d75a77b69052e-4792490fb2emr11018921cf.8.1743710667013;
        Thu, 03 Apr 2025 13:04:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEo9LOR/QTdiYbvtlfOeC04oRbI9fAMuBy7hvGsx2K2DNOTFI5IS0fHaCtTn4DM15/wrGnywQ==
X-Received: by 2002:a05:622a:448:b0:476:8288:955f with SMTP id d75a77b69052e-4792490fb2emr11018581cf.8.1743710666704;
        Thu, 03 Apr 2025 13:04:26 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4791b0719b8sm11733041cf.24.2025.04.03.13.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:04:26 -0700 (PDT)
Message-ID: <26cedde1e10a210556aabf7510b1d08ee73dca0a.camel@redhat.com>
Subject: Re: [RFC PATCH 07/24] KVM: SEV: Track ASID->vCPU on vCPU load
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:04:25 -0400
In-Reply-To: <20250326193619.3714986-8-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-8-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-26 at 19:36 +0000, Yosry Ahmed wrote:
> Check for changes in the ASID to vCPU mapping on vCPU load instead of
> doing it on vCPU run. This should be sufficient and more efficient, and
> is needed to allow generalizing the tracking and making it more
> expensive.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/sev.c | 13 ++++---------
>  arch/x86/kvm/svm/svm.c | 13 +++++++++++++
>  arch/x86/kvm/svm/svm.h |  1 +
>  3 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index ddb4d5b211ed7..3ef0dfdbb34d2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -224,7 +224,7 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>  	return ret;
>  }
>  
> -static unsigned int sev_get_asid(struct kvm *kvm)
> +unsigned int sev_get_asid(struct kvm *kvm)
>  {
>  	return to_kvm_sev_info(kvm)->asid;
>  }
> @@ -3453,7 +3453,6 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
>  
>  int pre_sev_run(struct vcpu_svm *svm, int cpu)
>  {
> -	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
>  	struct kvm *kvm = svm->vcpu.kvm;
>  	unsigned int asid = sev_get_asid(kvm);
>  
> @@ -3469,16 +3468,12 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
>  	svm->asid = asid;
>  
>  	/*
> -	 * Flush guest TLB:
> -	 *
> -	 * 1) when different vCPU for the same ASID is to be run on the same host CPU.
> -	 * 2) or this VMCB was executed on different host CPU in previous VMRUNs.
> +	 * Flush guest TLB if the VMCB was executed on a differet host CPU in
> +	 * previous VMRUNs.
>  	 */
> -	if (sd->sev_vcpus[asid] == &svm->vcpu &&
> -	    svm->vcpu.arch.last_vmentry_cpu == cpu)
> +	if (svm->vcpu.arch.last_vmentry_cpu == cpu)
>  		return 0;
>  
> -	sd->sev_vcpus[asid] = &svm->vcpu;
>  	vmcb_set_flush_asid(svm->vmcb);
>  	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
>  	return 0;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1156ca97fd798..e6e380411fbec 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1554,6 +1554,7 @@ static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
>  
>  static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
> +	unsigned int asid;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
>  
> @@ -1568,6 +1569,18 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	}
>  	if (kvm_vcpu_apicv_active(vcpu))
>  		avic_vcpu_load(vcpu, cpu);
> +
> +	if (sev_guest(vcpu->kvm)) {
> +		/*
> +		 * Flush the TLB when a different vCPU using the same ASID is
> +		 * run on the same CPU.
> +		 */
> +		asid = sev_get_asid(vcpu->kvm);
> +		if (sd->sev_vcpus[asid] != vcpu) {
> +			sd->sev_vcpus[asid] = vcpu;
> +			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> +		}
> +	}
>  }
>  
>  static void svm_vcpu_put(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 4ea6c61c3b048..ca38a233fa24c 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -768,6 +768,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>  void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> +unsigned int sev_get_asid(struct kvm *kvm);
>  
>  #ifdef CONFIG_KVM_AMD_SEV
>  int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);

Makes sense, but I might have missed something.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




