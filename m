Return-Path: <kvm+bounces-36961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F52A238B0
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 02:48:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EC9518899FC
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 01:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E0E61FF2;
	Fri, 31 Jan 2025 01:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yau81Eqe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4776B22318
	for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 01:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738288107; cv=none; b=TSHNYWMmCTccyDYE2ZVPywcz4q2Bkq6mKD9DHkj81fQ8xJRcRJw6aY4aWuZ+KXF9c8FOC4JC3Z93doAiuWaPTseiNeztNRiXIuxsbySfMEf0LasUEEMV/qrNo+d0SbK0cgm1bNzRJ+xz+Zb/0SiTl1ayTaGsZ+eJA71G9y/JfMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738288107; c=relaxed/simple;
	bh=PCcWp1tjtTTwT+4T+gwNe8f1pHXDJ+jDQQs7L3JrJJQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iRNx/XsTVAJRxFhRB6ts3WeBmxmHnYLDuJYTy0EOjr7VHeK2+niSh5DnIwPpchAeOdRW8bESSoxWxhNqCACa6ZkzVJiyTTC+DwepFxmCMTnlBjzN+pUN5RBXUbVBfIV2+wz9CAt42Qkux7PX1PWxDPwzIba12+zDdEns5Alhfio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yau81Eqe; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-218cf85639eso43696155ad.3
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 17:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738288103; x=1738892903; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yk4T/kfqEFgVa3SrODaXARdMdIV0x31oxIDNkWjd6DU=;
        b=yau81EqeHBHxeO9mmWpCTLmIVFhj5Qq0mJ3WUQlXJD7hOWXgO02KeZ8neZzxV+zOjv
         RTYb5hUQRn6LKR2IDRXYAusLzkP9f0U0nDOeLmWkRZf57srGIO/QhHz8v9h/g4NUPCad
         NTfBa7v+u88W6u3LGc5umo/8AK+qiZhnEEt4Z74njP151I3uFgXYia4OLp1N/Hjl6P8m
         ysmpxc8DUAtfoWicnK2BmDriCC6RkOH0RG0u3wMTvYblrKRnmPB/klkEKvYTL7fcJ2T3
         wHKkGGooLrRH+xe5mf2VZ4s96IFSmC96fLqE3iOF/vYP6EfAxgM5lZILgvgNSqPATBsn
         GNOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738288103; x=1738892903;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yk4T/kfqEFgVa3SrODaXARdMdIV0x31oxIDNkWjd6DU=;
        b=CtGJ/NZu7gRh7d4q9jW4bG2oOEm3kwYBqIjkIeFtzmNBpcbemUw4E8Qcmp4CBbDQhQ
         lcmU1DGYajsuR32OC+JCW05sHd0EuFqavax0v8m/PA7m98GS6o5XutQ4YMJWmgBasiVr
         tfbqkfvQtZ+qZzLmrGpXmBHpuBzw1m+Q/xzYrf8vJaiXrtAZ1N6NimHixls0tdAA9FEr
         2djPuEVQh5zXxN9YcdUVonF1XkTQA2nJxPJl8mrfQHxbRN0riGG53l8jTTe3853tNpZL
         fqpHE8bayoHtftUMfYiEHFSEHd1/DcXmo3mMOYbqjiVJVzQAW6evJiklDuGw86IvqZDj
         HynQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjNZpMePhdDiy99mQrnVEqVq1eOVxIwskyo45Z8KQnD5UNTbLHzEaIxzQ1ORmIQqi7RYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YybvizW7W7Fk73pdVmkLNKOjgwrTVcl+dSLeTkRgERxl7PYH0Le
	YjPTnkvI0nmHOK8QkGQpiFNbblaDl1vsUIa2FA61YlvTr0DTibsvdlCafAkoT8FP1b1T8nSGcVQ
	phw==
X-Google-Smtp-Source: AGHT+IG0aBeCk8/iEUAOZ9Ro4ZQRn21EJE6cjItE25bpHK7iUdp9q2QgGNTaw88LaidLTqtzkYVxy3WfYW8=
X-Received: from pjbso10.prod.google.com ([2002:a17:90b:1f8a:b0:2ef:82c0:cb8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f70c:b0:21d:3bee:990c
 with SMTP id d9443c01a7336-21dd7de15b4mr143430755ad.42.1738288103586; Thu, 30
 Jan 2025 17:48:23 -0800 (PST)
Date: Thu, 30 Jan 2025 17:48:22 -0800
In-Reply-To: <afc1fb55dfcb1bccd8ee6730282b78a7e2f77a46.1738274758.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1738274758.git.ashish.kalra@amd.com> <afc1fb55dfcb1bccd8ee6730282b78a7e2f77a46.1738274758.git.ashish.kalra@amd.com>
Message-ID: <Z5wr5h03oLEA5WBn@google.com>
Subject: Re: [PATCH v2 4/4] iommu/amd: Enable Host SNP support after enabling
 IOMMU SNP support
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com, 
	will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com, 
	dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-coco@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 31, 2025, Ashish Kalra wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> This patch fixes the current SNP host enabling code and effectively SNP
  ^^^^^^^^^^
> ---
>  drivers/iommu/amd/init.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index c5cd92edada0..ee887aa4442f 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -3194,7 +3194,7 @@ static bool __init detect_ivrs(void)
>  	return true;
>  }
>  
> -static void iommu_snp_enable(void)
> +static __init void iommu_snp_enable(void)

If you're feeling nitpicky, adding "__init" could be done in a separate patch.

>  {
>  #ifdef CONFIG_KVM_AMD_SEV
>  	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> @@ -3219,6 +3219,11 @@ static void iommu_snp_enable(void)
>  		goto disable_snp;
>  	}
>  
> +	if (snp_rmptable_init()) {
> +		pr_warn("SNP: RMP initialization failed, SNP cannot be supported.\n");
> +		goto disable_snp;
> +	}
> +
>  	pr_info("IOMMU SNP support enabled.\n");
>  	return;
>  
> @@ -3426,18 +3431,23 @@ void __init amd_iommu_detect(void)
>  	int ret;
>  
>  	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
> -		return;
> +		goto disable_snp;
>  
>  	if (!amd_iommu_sme_check())
> -		return;
> +		goto disable_snp;
>  
>  	ret = iommu_go_to_state(IOMMU_IVRS_DETECTED);
>  	if (ret)
> -		return;
> +		goto disable_snp;

This handles initial failure, but it won't handle the case where amd_iommu_prepare()
fails, as the iommu_go_to_state() call from amd_iommu_enable() will get
short-circuited.  I don't see any pleasant options.  Maybe this?

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index c5cd92edada0..436e47f13f8f 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3318,6 +3318,8 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
                ret = state_next();
        }
 
+       if (ret && !amd_iommu_snp_en && cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+               cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
        return ret;
 }
 

Somewhat of a side topic, what happens if the RMP is fully configured and _then_
IOMMU initialization fails?  I.e. if amd_iommu_init_pci() or amd_iommu_enable_interrupts()
fails?  Is that even survivable?

>  
>  	amd_iommu_detected = true;
>  	iommu_detected = 1;
>  	x86_init.iommu.iommu_init = amd_iommu_init;
> +	return;
> +
> +disable_snp:
> +	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> +		cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
>  }
>  
>  /****************************************************************************
> -- 
> 2.34.1
> 

