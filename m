Return-Path: <kvm+bounces-42604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E221A7B01E
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:09:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06EDE173618
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97C625BACE;
	Thu,  3 Apr 2025 20:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YYxHoMER"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD7F25BAC5
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710683; cv=none; b=kGdNgVqpFcfXHcYnIOBDX2RKUPoJbwHbUBxsdouo+X+oEIjQ1VPltlW4RA3TySGxfpE1oAdpXF4VFUy9Oe/MIFdry9EPAFCdr4dIDGY/8SEZeDtKw6vTLgtK/uCx77M6IwBe3W3YC4c5XvIqh+ruKExhgiRBYQwFK65dN2ydB4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710683; c=relaxed/simple;
	bh=NkB3n0ul+MfMxizFwXwyx3phcNv722wiU11cVISsZts=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ejt9jc0L2yc+7Mik+CBE3ATak1UO8YdlJ0EGgONYdR/7XBqrvVZ2M3I7QujmB9AXA2MiotNY6IAQ64oOD5aM+EJR79bDic6XPYtKAzD1oa++Nn3QHDYlYhoYBoYTeFJuK8pNGY/JD9BtqfpqgNps8N9HykIqIdOQzYH6WUBDet8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YYxHoMER; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743710679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kga9aNRHkzQOD82yZTsoFxnFwsipXqt6fxru+FOVT4s=;
	b=YYxHoMERdvnL35XXOmeuw1MJNgyUgjHiqd2qgavfRJCzKf6BflGBMn7TNUT1d70lImF+hg
	Mh7bFqqXHrHTpGUOdqQSyEXwcRFgCUm8zT6EwLUcyj9zEPP8ix0ugTb7OulmUucWXKxHlJ
	BIfd1oyu4KyCIHPTGRNBZ4utbVpp3aI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-Zi2Q83sqMo20TxK4TTaQXw-1; Thu, 03 Apr 2025 16:04:37 -0400
X-MC-Unique: Zi2Q83sqMo20TxK4TTaQXw-1
X-Mimecast-MFC-AGG-ID: Zi2Q83sqMo20TxK4TTaQXw_1743710677
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c5f3b94827so240249185a.0
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:04:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743710677; x=1744315477;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kga9aNRHkzQOD82yZTsoFxnFwsipXqt6fxru+FOVT4s=;
        b=FVEKlh2vcSv7MTLjI31XklUhno4J445rTLX5998ualng0bJ4dV4qSxZL9Y1AKq8q0u
         PRLdP4i/JeLXwlDZ23L4nsyYTqRRJf+x6zQRsc0TJtLgizhsPmey+TmU8vwjhC1eidVD
         xZC2FZ8Am4SZze6Z7NiEOYgmzIuHn9KINiOjJX3J+50ZKiyj0hiV4FY0LUaoTmXX3S98
         j4cS6BRCbh6G8wOkSO4TI/42srwPxIa9YNBS8wlE/RPwjEEKKp8T+gtRLjAZMHSpw/yo
         R/DuKcTHZd0xpyjrzRs46pXJFr0bv4/vKFe5u0fsRzpFrO/Pq8ldvMwsIdlrT8ISrvHl
         XC4g==
X-Forwarded-Encrypted: i=1; AJvYcCVhqxfyBxvD2KC+HgvHjww5fK4gXNs0O5oK5077F/uBL5pGNIOyMHgaE72FCKDB8BXv1IY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8JaANFJocgCM0dwWn86A7sblhdjc7t/PcbeWDrg27MCABbRAR
	PiT6Ji3CB5juDCXreXH0pddEfcKr6Hcn4QQfgVjRzGbbxVYbdRvm1nK31cfP065xttwigKnUAVA
	DAeoWLoPG9UOIRTMjFyhWgdHut7UaCqj6p90nNRhnOTbjVnmQbA==
X-Gm-Gg: ASbGncuexjOTkHTp8BwCZ/wxmomOYW5ABgqwlm4nH0LwTWY5eFBuFGQnczhffSjsDY6
	svtHKxWd1u1HnQ0k7sv+PhgI/4Lk53VnwbC9ASGhqx3pHqYXbP6aKe/Lsd4DTf74GlUjtd+prNy
	Mzo6VqzX78mo7vu0pdHW457eSIbJYlG0hzDCszLav+VINvZdzJCrIhtyIhSkamV/ZDao9+4HIOl
	p6SKxqZi8feEXK2O5Zhv/DFCfcjWWydETv0ElObrjnrLtQPhFU/JJToWNrg40A2MDk2fZh+U1nA
	Bl2xV0wCoNBc1UE=
X-Received: by 2002:a05:620a:25c8:b0:7c7:5c0b:fdc8 with SMTP id af79cd13be357-7c774d5128cmr87078885a.17.1743710677406;
        Thu, 03 Apr 2025 13:04:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZCLnm4HCvgrp1JG+ONjQils839nHMO7PI4qjxrAX6OLhscKo4reCAsfz0+t2ZEZw/qV/d3A==
X-Received: by 2002:a05:620a:25c8:b0:7c7:5c0b:fdc8 with SMTP id af79cd13be357-7c774d5128cmr87074385a.17.1743710677052;
        Thu, 03 Apr 2025 13:04:37 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76e75b5dfsm115867385a.35.2025.04.03.13.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:04:36 -0700 (PDT)
Message-ID: <83942b9b464c9ab69ca9059f879eb0539380e2a3.camel@redhat.com>
Subject: Re: [RFC PATCH 08/24] KVM: SEV: Drop pre_sev_run()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:04:35 -0400
In-Reply-To: <20250326193619.3714986-9-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-9-yosry.ahmed@linux.dev>
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
> Now that the ASID to vCPU/VMCB tracking was moved out of pre_sev_run(),
> the only remaining pieces are:
> (a) Checking for valid VMSA.
> (b) Assigning svm->asid.
> (c) Flush the ASID if the VMCB is run on a different physical CPU.
> 
> The check in (c) is already being done in pre_svm_run(), and so is
> redundant. (a) and (b) are small enough and probably do not warrant a
> separate helper (and (b) will be going way soon), so open-code the
> function into pre_svm_run() and remove it.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/sev.c | 28 ----------------------------
>  arch/x86/kvm/svm/svm.c | 16 ++++++++++++++--
>  arch/x86/kvm/svm/svm.h |  1 -
>  3 files changed, 14 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3ef0dfdbb34d2..1742f51d4c194 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3451,34 +3451,6 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
>  	svm->sev_es.ghcb = NULL;
>  }
>  
> -int pre_sev_run(struct vcpu_svm *svm, int cpu)
> -{
> -	struct kvm *kvm = svm->vcpu.kvm;
> -	unsigned int asid = sev_get_asid(kvm);
> -
> -	/*
> -	 * Reject KVM_RUN if userspace attempts to run the vCPU with an invalid
> -	 * VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after an SNP
> -	 * AP Destroy event.
> -	 */
> -	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa))
> -		return -EINVAL;
> -
> -	/* Assign the asid allocated with this SEV guest */
> -	svm->asid = asid;
> -
> -	/*
> -	 * Flush guest TLB if the VMCB was executed on a differet host CPU in
> -	 * previous VMRUNs.
> -	 */
> -	if (svm->vcpu.arch.last_vmentry_cpu == cpu)
> -		return 0;
> -
> -	vmcb_set_flush_asid(svm->vmcb);
> -	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
> -	return 0;
> -}
> -
>  #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
>  static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>  {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e6e380411fbec..ce67112732e8c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3649,8 +3649,20 @@ static int pre_svm_run(struct kvm_vcpu *vcpu)
>  		svm->current_vmcb->cpu = vcpu->cpu;
>          }
>  
> -	if (sev_guest(vcpu->kvm))
> -		return pre_sev_run(svm, vcpu->cpu);
> +	if (sev_guest(vcpu->kvm)) {
> +		/* Assign the asid allocated with this SEV guest */
> +		svm->asid = sev_get_asid(vcpu->kvm);
> +
> +		/*
> +		 * Reject KVM_RUN if userspace attempts to run the vCPU with an invalid
> +		 * VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after an SNP
> +		 * AP Destroy event.
> +		 */
> +		if (sev_es_guest(vcpu->kvm) &&
> +		    !VALID_PAGE(svm->vmcb->control.vmsa_pa))
> +			return -EINVAL;
> +		return 0;
> +	}
>  
>  	/* FIXME: handle wraparound of asid_generation */
>  	if (svm->current_vmcb->asid_generation != sd->asid_generation)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index ca38a233fa24c..3ab2a424992c1 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -760,7 +760,6 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  
>  /* sev.c */
>  
> -int pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void sev_init_vmcb(struct vcpu_svm *svm);
>  void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
>  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




