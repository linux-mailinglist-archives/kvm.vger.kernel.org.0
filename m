Return-Path: <kvm+bounces-7521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C653843297
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 02:13:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEAFE1C24ADA
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B2174C97;
	Wed, 31 Jan 2024 01:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w9IQLSNZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203D64C87
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706663584; cv=none; b=c0NvG+ZqvCFP0piWYpANH0MaBNOOzmnNd7baWb3PhU29bV+dKXwwXEh2GncR7Enqmtd0sChjwj8L60uqPjhkS1K8U+tT3GbzXFnDf7d+5n7S9CFEGyx3OuXr/tJeJHVr3KB6ZCFQxrjLizHOiTVZjQ3W9ESs0GgFdOhQ/12LHI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706663584; c=relaxed/simple;
	bh=WnaiMYjG3HYrBPVosKeochjRi58QHb85b9Uafy87v5A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XwQGKRk8sjpE1P6np5WqkLqmgf5IxU4kIUkQ1m/erTPQrd0/EWB9SPYhH6KYidX2KihHyPlrmK8F8hj+z9mKnZzAsHG94IQtezegteoeDPLArv3weDAUAaUjw9YMEHC1A2Xv4JKlbXStwRHb07UUFvdeKYeBbX1ZIgi5eUslv2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w9IQLSNZ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5ca5b61c841so3236392a12.3
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 17:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706663582; x=1707268382; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/GoosJvXV4tQVgQnoX094ue9LgaeDV/puMZ+zgV5v8A=;
        b=w9IQLSNZ4uiLohicHi+6G4ZMJRs0oUrtBRqKLSOvirKyQrWa1O/qJwki5kVmpdZUx3
         IpKJ4/Q6lzxOqvq+nzIOc64XbTDVm5OnVcguzGFi4NlitC2y4KwWXcGKJZHfHjeWTbpc
         Nqc5QsHw1b4PeF0Jqt2N5f0pgo9UHiHsbXI6wiwqGaevp5KffFT1lNyFTEchXuLFnmwy
         8aeYQITF4QJdmpaKl8yABpwEesen6QirhP2R5sWTUkaY7VuuYZpwS4VR8k2F/w6BascW
         TIj9TXanfw+TjmKBdug0CmE/Jm2wfYbveeQ59wYGdBLLdJZWqwhMyrLj+atS2x+AgBwu
         5s7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706663582; x=1707268382;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/GoosJvXV4tQVgQnoX094ue9LgaeDV/puMZ+zgV5v8A=;
        b=n312WsIMhTaOFqUp7ElJsrgb7Cj9hsHUZ1aCsHY7TuEetFhaV92SiIGCpUN/xdNGPW
         cRoFjB2voORbLZY5itE32AqwrbqWrYRAwPP1vOAojwhbYUGltq5k3ft7lmvgjjEBa9uQ
         VtqFXn1FwK80JYUOHoif0OKV94AFEwb3VgI+1kNpiaZnK5/jnv6Djl3X6nEAogRk57k+
         lI0yRQ898mDCZoOQdfEVBSI5GmhaWd449TzPdCAPKPRyS0joAjbFFLHhZ0oi+hPpnd38
         1qqrwpUGTIFwfbqtp0M56uePy/56DWrw94BQQRMd+p7V40b/XDu6l0dBvpyF6UXIsH64
         yCiw==
X-Gm-Message-State: AOJu0Yz5MIT6/CeF618yRTMnk1VNIVyhsS/4c3WDPSj3/G5OIlEHDU2+
	JqXciuIw09sqKY1XHW9GIVuBdR4WTomYvbV/kAlLaEaY4RX9FX28zOmBlDIwPQ31umiySyTFcG/
	kaA==
X-Google-Smtp-Source: AGHT+IHXA4t0uhZ7tzthJIqQkUlU7edO5hP5ya6T+NaNmVk8RFxp+26SnKPKNqGEdvTVdg4s3sxwKV4qvvQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d212:b0:1d9:1e1:76ca with SMTP id
 t18-20020a170902d21200b001d901e176camr715ply.10.1706663582547; Tue, 30 Jan
 2024 17:13:02 -0800 (PST)
Date: Tue, 30 Jan 2024 17:13:00 -0800
In-Reply-To: <20231016115028.996656-9-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231016115028.996656-1-michael.roth@amd.com> <20231016115028.996656-9-michael.roth@amd.com>
Message-ID: <ZbmenP05fo8hZU8N@google.com>
Subject: Re: [PATCH RFC gmem v1 8/8] KVM: x86: Determine shared/private faults
 based on vm_type
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, pbonzini@redhat.com, isaku.yamahata@intel.com, 
	ackerleytng@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	nikunj.dadhania@amd.com, jroedel@suse.de, pankaj.gupta@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 16, 2023, Michael Roth wrote:
> For KVM_X86_SNP_VM, only the PFERR_GUEST_ENC_MASK flag is needed to
> determine with an #NPF is due to a private/shared access by the guest.
> Implement that handling here. Also add handling needed to deal with
> SNP guests which in some cases will make MMIO accesses with the
> encryption bit.

...

> @@ -4356,12 +4357,19 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  			return RET_PF_EMULATE;
>  	}
>  
> -	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> +	/*
> +	 * In some cases SNP guests will make MMIO accesses with the encryption
> +	 * bit set. Handle these via the normal MMIO fault path.
> +	 */
> +	if (!slot && private_fault && kvm_is_vm_type(vcpu->kvm, KVM_X86_SNP_VM))
> +		private_fault = false;

Why?  This is inarguably a guest bug.

> +	if (private_fault != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
>  		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
>  		return -EFAULT;
>  	}
>  
> -	if (fault->is_private)
> +	if (private_fault)
>  		return kvm_faultin_pfn_private(vcpu, fault);
>  
>  	async = false;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 759c8b718201..e5b973051ad9 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -251,6 +251,24 @@ struct kvm_page_fault {
>  
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  
> +static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err)
> +{
> +	bool private_fault = false;
> +
> +	if (kvm_is_vm_type(kvm, KVM_X86_SNP_VM)) {
> +		private_fault = !!(err & PFERR_GUEST_ENC_MASK);
> +	} else if (kvm_is_vm_type(kvm, KVM_X86_SW_PROTECTED_VM)) {
> +		/*
> +		 * This handling is for gmem self-tests and guests that treat
> +		 * userspace as the authority on whether a fault should be
> +		 * private or not.
> +		 */
> +		private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
> +	}

This can be more simply:

	if (kvm_is_vm_type(kvm, KVM_X86_SNP_VM))
		return !!(err & PFERR_GUEST_ENC_MASK);

	if (kvm_is_vm_type(kvm, KVM_X86_SW_PROTECTED_VM))
		return kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);

