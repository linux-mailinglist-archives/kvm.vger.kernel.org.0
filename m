Return-Path: <kvm+bounces-35327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B677EA0C3F7
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 22:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C312A168126
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 21:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C05E1D516B;
	Mon, 13 Jan 2025 21:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xQryF1Tf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008203232
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 21:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736804778; cv=none; b=BiyQd0odAk8cnWlP1WmsfLY6yuhCDszJcLBFSvBZ4H1uar/TcBSM36Suo3qE+x/SHnTe+7VS77+PhMkQkXupo5ow4ak0dLbRVc/ysHUk21nKhFQpnSa3ZMUBS6ZymCoZaoB+UUzhDzM5E41IDneCpQGcFjt6RquMSg5R6othasc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736804778; c=relaxed/simple;
	bh=1J3JeXkI+YbVdKmOfVEndH44r8Uwoadx5LQYivTUbj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YfHKm2mhlbIW8JjsU18lkPAlfWOJpF5bS9qijGxmz/+6yVZtDYHOQf9dDv0TQv3eykfAUzkzadS8ZSjGmeKXDaUz/4owj0eonMAeRGHLVXfvbNuTHsJXt2St6oHIdJn/sFMYAY/TDV4sVciTsXnwDc9qqJN7GImJYV1AuZ9qS1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xQryF1Tf; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2156e078563so71374725ad.2
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 13:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736804776; x=1737409576; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oe+xMQhT1hq8w/y5GjvgXMHT+eGurbbeYjjutUFK+h4=;
        b=xQryF1Tfg/6LqJp+H+PfBrvwAhmfXJB9zfOjs+y+CqIabRfOB3cWtm2N9Ub+HXYrqf
         aJIhvNQhoi/ac+P1vhGsibB7cmAZRvTWbrlJuR9BAj/jsoMFDKE4YZxQHGZnvApvuURO
         UfadFsFrjMPBstbJLZpkepXXsm6WrUAq+bXE+chaCXCS9s3XGoY9kELY7iJnJmcgjQ3Q
         4EokHmDnn48IAtdVVUBPLHydzWDdy4jP4kVt/t9+into2rzs6Y9hyacaB/dJAYMinXmJ
         HRl2y0cZanOqjbyWBz+etVjJ+Pac0QkiqyriUn8VTOeCuaZyIzUHph17EMYN7qlorAyG
         fJ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736804776; x=1737409576;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oe+xMQhT1hq8w/y5GjvgXMHT+eGurbbeYjjutUFK+h4=;
        b=Sb63t0ahFIdlBXGAL/aF6e4KbOO4kPkrvBPpVJEIf1iqrga2knntW8Y9voBLlJ29zW
         plc3auNLpRjU8xmR8NupYPZzBqJyjPH+dwPCyUSTbqfv/E2LAg6OhG5/iuPpe9ScDTLZ
         6jcU5ueJ8khDUzyfsUr4GmwBkqEqaCE+AFRXOYQZUtSLkKJ5L7RZhRy47iX/yqjAI0Wc
         LXbcVqmOJFVP3670B720SJZbqyLI+twIj3NpzkifNO4mut/AQYxdF0NhoYBfELk54u/A
         w6cpeiyLo9dqKVMnYY3Vnzy0LRsE8XGrUg7ASQ0PH0nzlEVoEyWboh+h+8mqwX7HFkLN
         XNuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvWrB1gIWXfLFP/3rNbE1jyU6+Cyjh6sAWdUoIMlwkKxGk73y/jVbbWn8SQyhUc0sfDHI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdYmOHcOrfuvixha0UgEm+DfIkcyzn8OcIg1YJj50ovZAFcKxY
	EWPHQETlrE6Fv7O4ouwxVT4jQFISwFJ2W5GcYE5N2KL9e5r4WCVyUtlEdJmq5w==
X-Gm-Gg: ASbGncsNaeNMxeOcCLAEC41OM57mQbIQ770m4zf15cePK1RTZc0syKx1QBLpYf6SBt0
	RPzz8+8UXRDiTqRTx/62m+OsPhBPJcG4qGhvEecC0FJyOa0DtmyQu7UsoMevnCNdnDFGk6V6NVs
	Hc+vZef9L9ZkcEu0WsXpat7akdEekUwds20Llff02jdpvSN2uknjU/HhOHMhWAQ4FH2VTzxHtuy
	FLxBjjpM1kmqGRLUfkwIfZNsKtO29rTdgnlT8m34v2IgdrVeZE5lk8OmmDdBqNAL9ykUUMA52wB
	zvFvuYemy3wLNzw=
X-Google-Smtp-Source: AGHT+IERov760jvH7yH0to2wZedY8jZkl0VGbMlVyFSK/WYyq7qWHul1SI6gNIGj86eIZ2zGLetekA==
X-Received: by 2002:a05:6a20:3d8b:b0:1d9:18af:d150 with SMTP id adf61e73a8af0-1e88d114f9bmr35256310637.21.1736804776004;
        Mon, 13 Jan 2025 13:46:16 -0800 (PST)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d4067e31asm6255766b3a.123.2025.01.13.13.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 13:46:15 -0800 (PST)
Date: Mon, 13 Jan 2025 21:46:12 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
	kirill.shutemov@linux.intel.com, kai.huang@intel.com,
	ubizjak@gmail.com, dave.jiang@intel.com, jgross@suse.com,
	kvm@vger.kernel.org, thomas.lendacky@amd.com, pgonda@google.com,
	sidtelang@google.com, rientjes@google.com, szy0127@sjtu.edu.cn
Subject: Re: [PATCH v2 2/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
Message-ID: <Z4WJpGiw-UBskxfM@google.com>
References: <20250109225533.1841097-1-kevinloughlin@google.com>
 <20250109225533.1841097-3-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109225533.1841097-3-kevinloughlin@google.com>

On Thu, Jan 09, 2025, Kevin Loughlin wrote:
> AMD CPUs currently execute WBINVD in the host when unregistering SEV
> guest memory or when deactivating SEV guests. Such cache maintenance is
> performed to prevent data corruption, wherein the encrypted (C=1)
> version of a dirty cache line might otherwise only be written back
> after the memory is written in a different context (ex: C=0), yielding
> corruption. However, WBINVD is performance-costly, especially because
> it invalidates processor caches.
> 
> Strictly-speaking, unless the SEV ASID is being recycled (meaning all
> existing cache lines with the recycled ASID must be flushed), the
> cache invalidation triggered by WBINVD is unnecessary; only the
> writeback is needed to prevent data corruption in remaining scenarios.
> 
> To improve performance in these scenarios, use WBNOINVD when available
> instead of WBINVD. WBNOINVD still writes back all dirty lines
> (preventing host data corruption by SEV guests) but does *not*
> invalidate processor caches.

This looks reasonable to me. I assume when WBNOINVD writes back the
content, those cache lines are no longer "dirty" and any subsequent
WBINVD invoked in other locations (for other reasons) won't write back
these cache lines again. Thus it avoids corruption.

> 
> Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 35 ++++++++++++++++++++++-------------
>  1 file changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index fe6cc763fd51..a413b2299d30 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -116,6 +116,7 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
>  	 */
>  	down_write(&sev_deactivate_lock);
>  
> +	/* Use WBINVD for ASID recycling. */
>  	wbinvd_on_all_cpus();

IIUC, using WBINVD is essentially needed by architecture if software
want to successfully recycle ASIDs. This is not related with flushing
pages, but updating the "state" in the Data Fabric.


>  
>  	if (sev_snp_enabled)
> @@ -710,6 +711,14 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>  	}
>  }
>  
> +static void sev_wb_on_all_cpus(void)
> +{
> +	if (boot_cpu_has(X86_FEATURE_WBNOINVD))
> +		wbnoinvd_on_all_cpus();
> +	else
> +		wbinvd_on_all_cpus();
> +}
> +
>  static unsigned long get_num_contig_pages(unsigned long idx,
>  				struct page **inpages, unsigned long npages)
>  {
> @@ -2774,11 +2783,11 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
>  	}
>  
>  	/*
> -	 * Ensure that all guest tagged cache entries are flushed before
> -	 * releasing the pages back to the system for use. CLFLUSH will
> -	 * not do this, so issue a WBINVD.
> +	 * Ensure that all dirty guest tagged cache entries are written back
> +	 * before releasing the pages back to the system for use. CLFLUSH will
> +	 * not do this without SME_COHERENT, so issue a WB[NO]INVD.
>  	 */
> -	wbinvd_on_all_cpus();
> +	sev_wb_on_all_cpus();
>  
>  	__unregister_enc_region_locked(kvm, region);
>  
> @@ -2900,11 +2909,11 @@ void sev_vm_destroy(struct kvm *kvm)
>  	}
>  
>  	/*
> -	 * Ensure that all guest tagged cache entries are flushed before
> -	 * releasing the pages back to the system for use. CLFLUSH will
> -	 * not do this, so issue a WBINVD.
> +	 * Ensure that all dirty guest tagged cache entries are written back
> +	 * before releasing the pages back to the system for use. CLFLUSH will
> +	 * not do this without SME_COHERENT, so issue a WB[NO]INVD.
>  	 */
> -	wbinvd_on_all_cpus();
> +	sev_wb_on_all_cpus();
>  
>  	/*
>  	 * if userspace was terminated before unregistering the memory regions
> @@ -3130,12 +3139,12 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>  	 * by leaving stale encrypted data in the cache.
>  	 */
>  	if (WARN_ON_ONCE(wrmsrl_safe(MSR_AMD64_VM_PAGE_FLUSH, addr | asid)))
> -		goto do_wbinvd;
> +		goto do_wb_on_all_cpus;
>  
>  	return;
>  
> -do_wbinvd:
> -	wbinvd_on_all_cpus();
> +do_wb_on_all_cpus:
> +	sev_wb_on_all_cpus();
>  }
>  
>  void sev_guest_memory_reclaimed(struct kvm *kvm)
> @@ -3149,7 +3158,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
>  	if (!sev_guest(kvm) || sev_snp_guest(kvm))
>  		return;
>  
> -	wbinvd_on_all_cpus();
> +	sev_wb_on_all_cpus();
>  }
>  
>  void sev_free_vcpu(struct kvm_vcpu *vcpu)
> @@ -3858,7 +3867,7 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
>  		 * guest-mapped page rather than the initial one allocated
>  		 * by KVM in svm->sev_es.vmsa. In theory, svm->sev_es.vmsa
>  		 * could be free'd and cleaned up here, but that involves
> -		 * cleanups like wbinvd_on_all_cpus() which would ideally
> +		 * cleanups like sev_wb_on_all_cpus() which would ideally
>  		 * be handled during teardown rather than guest boot.
>  		 * Deferring that also allows the existing logic for SEV-ES
>  		 * VMSAs to be re-used with minimal SNP-specific changes.
> -- 
> 2.47.1.688.g23fc6f90ad-goog
> 

