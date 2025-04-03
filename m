Return-Path: <kvm+bounces-42602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E1F7A7B006
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B98E18882BA
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EEAA254AF5;
	Thu,  3 Apr 2025 20:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T0+ymd61"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BE7253B4E
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710652; cv=none; b=HYngnBZWYVkitLPJUhs6R2u6twfFeWJEoJtAIzuIxi/U/r2g9iTYpc4CjvNtAATgysz+IUTFx5UyBJc38g9kU/NWWZmUfeV486iACQqiLV2PSJ/I4zgc+LFYCDtzl81v2FJc+d+oHAsYR+Qa3efQdhNxIJvNFzBO8FTCvwzeJ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710652; c=relaxed/simple;
	bh=zGLq1pKU3vT6MPN6WYVbl9v9VWrgWfS+KwbxVLesfb0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W5ZwtgLKIREHHmUxGyjzME78bJo/Z8GMxfOPDT9QCcBpVY8l8WICb8BBM65v4vR12D03krr13yoG0vhpfbG94IEa80cZ/iumtcjyNLOZYap7Xk7uiMqTepZo6wwYgbRiwaKuCOBWXnj3sNv4b9g9zl9U1Jhb6/+XgRH53D6F/BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T0+ymd61; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743710648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ySMLQ7nl0QHO1+0KOlz9UGIbL4OhdDWaV8q7u33fOMc=;
	b=T0+ymd61XOg3WdAmbH/Ea+fLarr6VWXn2Zw0GumxbC5/wKj3a2i0I8L0Vzq3asTi48/+Pu
	Bi0lKm8lZCmA8gdEAtditr3ho3mSYp85oPzYly4VollyrnW+tpAuR+ZbgQnXaqNL+CgJbA
	4BH59QPs267SqsBWLpT0/w0qH43nK7g=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-UlN76wKINdCb_S-7FOwmaQ-1; Thu, 03 Apr 2025 16:04:07 -0400
X-MC-Unique: UlN76wKINdCb_S-7FOwmaQ-1
X-Mimecast-MFC-AGG-ID: UlN76wKINdCb_S-7FOwmaQ_1743710647
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5d608e703so216766285a.3
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:04:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743710647; x=1744315447;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ySMLQ7nl0QHO1+0KOlz9UGIbL4OhdDWaV8q7u33fOMc=;
        b=w2k0UBhPpcB+jlpR2Ge/frFJd+H5daLBg6riqv1BXO3USGeko9EHaof1aQS1J7RFsp
         OtD2kb5rsyX3sEgHVE8cIfjrogynyp/0nN9he+p9apdvIwEbtHRCah03dLnLOAOMf31k
         mZoL955SOSR6zVzI7YQH8sHW4iDRw2OEnb6OyTyVfCB4l+HuVU32FQGQVNrq0gtwCfnU
         DoYFazYc9umeSUZ6r2NAkQRvJQkioch0PcbOwsl5c5saYYfAZH62lCN/GrYDajrG+Rq+
         MNzIH0Fy3lp9M7HSiNZJ46L2fA/YKLy0tqj/4163gbO6AnKwdHBesIql4cjTUjZf0w27
         kNzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSikOsr6FvVXyZKiphoPZxLuqgp2OOmaXf6rZtyNKmh5xiujxDXCoKA/3VlG9sd/L6l4Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzILvX4ysWmOzp4SgkiXniQZDa1XWPdgjfradMUBO62lQ/lzIUw
	Z2BbLtvpWeMlKGqI5LPg/J1neIvoM7U8SGLTnZJH/hTfJ7JDthETI/B3j877sFng2IKrIgr8Uye
	2eY8orf1gkbc7+VCWycyzjSOVOVOi8zgfcqXDzy9c7IsCkahzIg==
X-Gm-Gg: ASbGnctHNC6hEVe3aRpxbUIGEp3ElQtlYPLAPDUC+mlvwWigJuxN3lqt4PhPzeT3Aq1
	7nhXlHK4ZjE4JOnStl8qwYLI9ghQD1MVXR8C1F43R4meP7QJRqh8NWMjL8MtRSb/9iv+/7CtiJO
	s3plcjwgTUHKiJ96aVQPATqmSuWf1RCud155XS6IDHQiGzAuqMOFz27835yZT5YgRoehzKzxhXT
	lfSQIzaC8CCR+n8r4biaWJ1OQOuXRRgEAshZ131TFuoRO+4lRt5N1gWb60WyOkLVB1N1W+lVSi0
	UX148ZVrx/enKZQ=
X-Received: by 2002:a05:620a:17ab:b0:7c5:54d7:d744 with SMTP id af79cd13be357-7c774d32d2amr77208085a.23.1743710647060;
        Thu, 03 Apr 2025 13:04:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXnXuXsXM2t4zH972gygBZXfgtU6llV4Ahgf7pAsBs8JBeLaCvDrRZ35sE7DKtZ77Uckzx2g==
X-Received: by 2002:a05:620a:17ab:b0:7c5:54d7:d744 with SMTP id af79cd13be357-7c774d32d2amr77204185a.23.1743710646623;
        Thu, 03 Apr 2025 13:04:06 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ef0f14d250sm11316526d6.103.2025.04.03.13.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:04:06 -0700 (PDT)
Message-ID: <03be59f070a02555596550d5764aa8b416e43b58.camel@redhat.com>
Subject: Re: [RFC PATCH 06/24] KVM: SEV: Track ASID->vCPU instead of
 ASID->VMCB
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:04:05 -0400
In-Reply-To: <20250326193619.3714986-7-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-7-yosry.ahmed@linux.dev>
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
> SEV currently tracks the ASID to VMCB mapping for each physical CPU.
> This is required to flush the ASID when a new VMCB using the same ASID
> is run on the same CPU. 


> Practically, there is a single VMCB for each
> vCPU using SEV. 

Can you elaborate on this a bit? AFAIK you can't run nested with SEV,
even plain SEV because guest state is encrypted, so for SEV we have
indeed one VMCB per vCPU.

> Furthermore, TLB flushes on nested transitions between
> VMCB01 and VMCB02 are handled separately (see
> nested_svm_transition_tlb_flush()).

Yes, or we can say that for now both VMCBs share the same ASID,
up until later in this patch series.

> 
> In preparation for generalizing the tracking and making the tracking
> more expensive, start tracking the ASID to vCPU mapping instead. This
> will allow for the tracking to be moved to a cheaper code path when
> vCPUs are switched.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/sev.c | 12 ++++++------
>  arch/x86/kvm/svm/svm.c |  2 +-
>  arch/x86/kvm/svm/svm.h |  4 ++--
>  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d613f81addf1c..ddb4d5b211ed7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -240,7 +240,7 @@ static void sev_asid_free(struct kvm_sev_info *sev)
>  
>  	for_each_possible_cpu(cpu) {
>  		sd = per_cpu_ptr(&svm_data, cpu);
> -		sd->sev_vmcbs[sev->asid] = NULL;
> +		sd->sev_vcpus[sev->asid] = NULL;
>  	}
>  
>  	mutex_unlock(&sev_bitmap_lock);
> @@ -3081,8 +3081,8 @@ int sev_cpu_init(struct svm_cpu_data *sd)
>  	if (!sev_enabled)
>  		return 0;
>  
> -	sd->sev_vmcbs = kcalloc(nr_asids, sizeof(void *), GFP_KERNEL);
> -	if (!sd->sev_vmcbs)
> +	sd->sev_vcpus = kcalloc(nr_asids, sizeof(void *), GFP_KERNEL);
> +	if (!sd->sev_vcpus)
>  		return -ENOMEM;
>  
>  	return 0;
> @@ -3471,14 +3471,14 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
>  	/*
>  	 * Flush guest TLB:
>  	 *
> -	 * 1) when different VMCB for the same ASID is to be run on the same host CPU.
> +	 * 1) when different vCPU for the same ASID is to be run on the same host CPU.
>  	 * 2) or this VMCB was executed on different host CPU in previous VMRUNs.
>  	 */
> -	if (sd->sev_vmcbs[asid] == svm->vmcb &&
> +	if (sd->sev_vcpus[asid] == &svm->vcpu &&
>  	    svm->vcpu.arch.last_vmentry_cpu == cpu)
>  		return 0;
>  
> -	sd->sev_vmcbs[asid] = svm->vmcb;
> +	sd->sev_vcpus[asid] = &svm->vcpu;
>  	vmcb_set_flush_asid(svm->vmcb);
>  	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
>  	return 0;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 18bfc3d3f9ba1..1156ca97fd798 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -694,7 +694,7 @@ static void svm_cpu_uninit(int cpu)
>  	if (!sd->save_area)
>  		return;
>  
> -	kfree(sd->sev_vmcbs);
> +	kfree(sd->sev_vcpus);
>  	__free_page(__sme_pa_to_page(sd->save_area_pa));
>  	sd->save_area_pa = 0;
>  	sd->save_area = NULL;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 843a29a6d150e..4ea6c61c3b048 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -340,8 +340,8 @@ struct svm_cpu_data {
>  
>  	struct vmcb *current_vmcb;
>  
> -	/* index = sev_asid, value = vmcb pointer */
> -	struct vmcb **sev_vmcbs;
> +	/* index = sev_asid, value = vcpu pointer */
> +	struct kvm_vcpu **sev_vcpus;
>  };
>  
>  DECLARE_PER_CPU(struct svm_cpu_data, svm_data);


Code itself looks OK, so 

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky





