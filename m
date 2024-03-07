Return-Path: <kvm+bounces-11225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 546D9874528
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A8791F25819
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6AE21879;
	Thu,  7 Mar 2024 00:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lm8uwmt7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30B34C6C
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 00:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709771465; cv=none; b=G+jjV3iAzKozMfhv6dI3vrTJoFZ0XeyZ/7nubkhtOf543T1FiOQgqqRPEXBPrCeeAJNYcklCVBNUOsfPKwpfMYps5g2K5Hgts0n0h6jtXfRgGOovocPAYWUtn94FvEb3iZRPkcRWPDtEvFnSSP+1XkMc8Lpnk94MNicwbr7t/Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709771465; c=relaxed/simple;
	bh=pd9U5XZMi1oPg8Lscf6Mt9lBs/qEgPyJWmDOSKdvgcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iYhsl70y6ONGAYWxPGPyaTYWpCewGOdQH24JPSWCFah3gw3g7lYmC3UaOtpuCWkGQKL6A1qicZML+YNFo6xdKcQDtKeFITVaBZTmWtpPGAI9Jm7n3FDxwopVYG75w6JB4uhvgqe/siDDYZRnBvErefskmg2fAWAEFgr34m3wJVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lm8uwmt7; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dc0d11d1b7so3128595ad.2
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 16:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709771463; x=1710376263; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qVq7pyXwgwgu4A+bvfIL5VWqGeKZIwSqAv8m6DJwZHQ=;
        b=lm8uwmt7eoc8A4LKD6EaWx9KCE7Xw1lR4cDJiXXlJtETfd+oVzpMpikqcG9msR8pIe
         22Lh7SKypeUsxBm8jE7ZCTIM8wSYNacH9WET2AjoMFNrMdkyk69plkt8/GenVS2dG5hj
         t+xVWbR0yjbqeiLRQ24QiX+6bBgmukMAQdi7jqVTiM8yAwVMod0cvv49grEOW656AUR5
         tYY1tp5QHBj62L69+URMc1kBChVtjByYy10Xv4qa9HGScC3hiPzu6UMSxwj0glVlACP7
         XGacRrd3Ji5icS4v4sCyh/k3JPnR2Y6y3sn5t3EnPb+tqUFeSHdZms4ghurLxCusbsl5
         i4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709771463; x=1710376263;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qVq7pyXwgwgu4A+bvfIL5VWqGeKZIwSqAv8m6DJwZHQ=;
        b=pn/iWheyxto9AzMWSTtycVkNU+mdPGHQUIiFo0eeW4SaWE+uJA/KVjbhNbSt5UPIOS
         /1SuUEOu//AEJC6OnoEbz7uygPR2NHtrZdhYqyyP96r0JWK70eSJpfPjSUvNhVKP0+Js
         dIY5QlUQ9vuepNKZpAMZe5LjLuvEMGfoirJUIT5g0yLVqnvKe7O7sFJkH78U98WAAzjI
         gjIdJUgz8G/Z1u9INZ749S8LAQgECl3Oyaddo3SGRD7msPAgSRt59Q142Ffk60enarWY
         ddouSX+H0P5dhbRx3i1pcmiDpb20Rmk/9GuvmIgUQwyVmu4kI6Wqp/y2Jb+afJ9jz54z
         8Idw==
X-Gm-Message-State: AOJu0Yyz5ligOql/4KwYz37zIEwmGOhm7zW2/WW6iZ8G6G5BdnauMlsZ
	zLGGIqxYSo+ZzLIujSgiqOCoyM2zjX6tfcWk2T7szKrdpPFD8/63rAOsB0iQsg==
X-Google-Smtp-Source: AGHT+IF62LqATgEJWKwVf8OT6RXbxw/mOea+GfHlm4GB1D4za7a/1j70tlLpnxsqJ/S5CNU+KUfHnQ==
X-Received: by 2002:a17:902:650f:b0:1dd:3929:3029 with SMTP id b15-20020a170902650f00b001dd39293029mr3704049plk.64.1709771462899;
        Wed, 06 Mar 2024 16:31:02 -0800 (PST)
Received: from google.com (61.139.125.34.bc.googleusercontent.com. [34.125.139.61])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b001dcdf2576c6sm12757924pln.3.2024.03.06.16.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 16:31:02 -0800 (PST)
Date: Wed, 6 Mar 2024 16:30:58 -0800
From: David Matlack <dmatlack@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>
Subject: Re: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{,
 pre_}vcpu_map_memory()
Message-ID: <ZekKwlLdf6vm5e5u@google.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>

On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Wire KVM_MAP_MEMORY ioctl to kvm_mmu_map_tdp_page() to populate guest
> memory.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/x86.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3b8cb69b04fa..6025c0e12d89 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4660,6 +4660,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
>  	case KVM_CAP_IRQFD_RESAMPLE:
>  	case KVM_CAP_MEMORY_FAULT_INFO:
> +	case KVM_CAP_MAP_MEMORY:
>  		r = 1;
>  		break;
>  	case KVM_CAP_EXIT_HYPERCALL:
> @@ -5805,6 +5806,54 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +int kvm_arch_vcpu_pre_map_memory(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_mmu_reload(vcpu);
> +}

Why is the here and not kvm_arch_vcpu_map_memory()?

> +
> +int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
> +			     struct kvm_memory_mapping *mapping)
> +{
> +	u8 max_level, goal_level = PG_LEVEL_4K;
> +	u32 error_code;
> +	int r;
> +
> +	error_code = 0;
> +	if (mapping->flags & KVM_MEMORY_MAPPING_FLAG_WRITE)
> +		error_code |= PFERR_WRITE_MASK;
> +	if (mapping->flags & KVM_MEMORY_MAPPING_FLAG_EXEC)
> +		error_code |= PFERR_FETCH_MASK;
> +	if (mapping->flags & KVM_MEMORY_MAPPING_FLAG_USER)
> +		error_code |= PFERR_USER_MASK;
> +	if (mapping->flags & KVM_MEMORY_MAPPING_FLAG_PRIVATE) {
> +#ifdef PFERR_PRIVATE_ACCESS
> +		error_code |= PFERR_PRIVATE_ACCESS;
> +#else
> +		return -OPNOTSUPP;

-EOPNOTSUPP

> +#endif
> +	}
> +
> +	if (IS_ALIGNED(mapping->base_gfn, KVM_PAGES_PER_HPAGE(PG_LEVEL_1G)) &&
> +	    mapping->nr_pages >= KVM_PAGES_PER_HPAGE(PG_LEVEL_1G))
> +		max_level = PG_LEVEL_1G;
> +	else if (IS_ALIGNED(mapping->base_gfn, KVM_PAGES_PER_HPAGE(PG_LEVEL_2M)) &&
> +		 mapping->nr_pages >= KVM_PAGES_PER_HPAGE(PG_LEVEL_2M))
> +		max_level = PG_LEVEL_2M;
> +	else
> +		max_level = PG_LEVEL_4K;

Is there a requirement that KVM must not map memory outside of the
requested region?

> +
> +	r = kvm_mmu_map_page(vcpu, gfn_to_gpa(mapping->base_gfn), error_code,
> +			     max_level, &goal_level);
> +	if (r)
> +		return r;
> +
> +	if (mapping->source)
> +		mapping->source += KVM_HPAGE_SIZE(goal_level);
> +	mapping->base_gfn += KVM_PAGES_PER_HPAGE(goal_level);
> +	mapping->nr_pages -= KVM_PAGES_PER_HPAGE(goal_level);
> +	return r;
> +}
> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>  			 unsigned int ioctl, unsigned long arg)
>  {
> -- 
> 2.25.1
> 

