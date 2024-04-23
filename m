Return-Path: <kvm+bounces-15586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D65498ADB24
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 02:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89DBC286928
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 00:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66B6E28E8;
	Tue, 23 Apr 2024 00:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZiVeDMv0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35417A21
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 00:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713832163; cv=none; b=t84uT4KQC9FxsiqyA0nZtnyM5l03iteukip58UfofroPllmLP3+OMzuQAB1PnpaoLmuY5T0WIyTlfuUgrqm8WGy2uIxxSCgdSvHbCJRFolSV3Nf6csoen6dz0z+32EbJzSJKu1s8fu5OKDRb2RKq0noDnuvGkjVkPOkYHaZyfWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713832163; c=relaxed/simple;
	bh=O0KZs07EFjpjx6LbcojmZ6OYdZDyT8p2fmytJk8+59M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l3uSV7rou3mk6nIWp9R88yypKXLB7glU4eoT+wofUTqMygrFON4Mqzu6QkOt2Lh4c70qZwBf77wwyXhsQfPw9timKH2IuYx2qgSPQtW2gutD/ehhZXsqHNRQFNz+DL5ohiQm9CIB+MX9d/3V+Izin7auvGejgDOWvCTm5xuRhfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZiVeDMv0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61b3518eb6bso78744787b3.2
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 17:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713832161; x=1714436961; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qCOvCCGD9VvcxRxOAyyAmzQ2MA+ylwIKSa/A9Dwg5AA=;
        b=ZiVeDMv03SpolK0honAKz8mIdKonOXOTyEga5cPFuZkULS9PeuysDf5o48Da7g/pb2
         /0ZLPNh3QxO5BL969psXTvQ/IJWkZCEiahTmGe6o35IBba0kEC34VhQ1LAS1jYJ4mHc5
         vsF0iaA38QYXyGzBSczOmqVSUqkfzlf+x6qmZ8+zXuSLqCJnBbvt2WpGxuEVM58ALOo1
         wpRr95MLuSIJXG8ozZIbsa2pIw+GFh7KOIEaqa2w1bZXErxqyG4SF381PUMr/JkUPg82
         q6N9vJidofr8Ppw6MkvyFWsLsTdR7nPofRo7Y02S04e9CM03cKx8KNgqLBv29TnvaHEo
         qpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713832161; x=1714436961;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qCOvCCGD9VvcxRxOAyyAmzQ2MA+ylwIKSa/A9Dwg5AA=;
        b=kGaK8QE3I2EC+oEXcsSYYKxn5qTO52cj2tT0a0qAIIRf6za7Dl9uA7yAQ5rXHpq7Au
         tsrpy4ia1tzgQEdy3AsxmS6kK+F0myji2Pk0BlQdn4O6JOv2PFtcMBQhcdQcfAheiUFr
         eaN/Pvi08Cmgqy0ZhLJQ9m/jOVgRiNi2XEcALbHm7UWdUSMj1EpyoZ7mdDNvP1hheOYI
         oepQ7eyY2bpxiZ4pa889GNx2GL6Ege2CoaZwGGLj0fYaGkIgjEFFuAfnVPMZYdjVf8SG
         AnOoxXNoJ+ALHQkq5PeAwrd3Y8edHxpvI2W1l8nfZFBTTdFbRMMGmPi6+f0TQaF6PGcF
         aAmg==
X-Forwarded-Encrypted: i=1; AJvYcCUemCFygGdTr9WcuMiR1qh7clLoFi7hAurZ/FelMUktocyNzbmOVAlau3Tb3vI7cRFjW3TgHzO8NKbicUsmaY8c2arf
X-Gm-Message-State: AOJu0Yz7MFnKJbon1yJBev9h4YpTQN3Bq3legV8X4lQxi4IhFxIQBSI2
	YCerQuv6/TcYVd0/0rHmOE3Z7SYSRQjOBORl8i2mbJ8c6GWi0iFG4KLScggkDXRoZzn3Rx1FmuY
	ZFg==
X-Google-Smtp-Source: AGHT+IFRX/TvKdAfQ6kCHw2myn6PqhPUBzzulp9T2w2y50IpNdRGGiBfguSrXxTL5ma9i/vz6BfE0NaRInA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a0c4:0:b0:61a:e319:b0 with SMTP id
 x187-20020a81a0c4000000b0061ae31900b0mr2873834ywg.1.1713832161140; Mon, 22
 Apr 2024 17:29:21 -0700 (PDT)
Date: Mon, 22 Apr 2024 17:29:19 -0700
In-Reply-To: <20240418030703.38628-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240418030703.38628-1-lirongqing@baidu.com>
Message-ID: <ZicA3732THkl-B1u@google.com>
Subject: Re: [PATCH] KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area
From: Sean Christopherson <seanjc@google.com>
To: Li RongQing <lirongqing@baidu.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="us-ascii"

+Tom, Mike, and Peter

On Thu, Apr 18, 2024, Li RongQing wrote:
> save_area of per-CPU svm_data are dominantly accessed from their
> own local CPUs, so allocate them node-local for performance reason
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kvm/svm/sev.c | 6 +++---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  arch/x86/kvm/svm/svm.h | 6 +++++-
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 61a7531..cce8ec7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3179,13 +3179,13 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
>  }
>  
> -struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> +struct page *snp_safe_alloc_page_node(struct kvm_vcpu *vcpu, int node)
>  {
>  	unsigned long pfn;
>  	struct page *p;
>  
>  	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> -		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +		return alloc_pages_node(node, GFP_KERNEL_ACCOUNT | __GFP_ZERO, 0);
>  
>  	/*
>  	 * Allocate an SNP-safe page to workaround the SNP erratum where
> @@ -3196,7 +3196,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
>  	 * Allocate one extra page, choose a page which is not
>  	 * 2MB-aligned, and free the other.
>  	 */
> -	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
> +	p = alloc_pages_node(node, GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);

This made me realize the existing code is buggy.  The allocation for the per-CPU
save area shouldn't be accounted.

Also, what's the point of taking @vcpu?  It's a nice enough flag to say "this
should be accounted", but it's decidely odd.

How about we fix both in a single series, and end up with this over 3-4 patches?
I.e. pass -1 where vcpu is non-NULL, and the current CPU for the save area.

struct page *snp_safe_alloc_page(int cpu)
{
	unsigned long pfn;
	struct page *p;
	gfp_t gpf;
	int node;

	if (cpu >= 0) {
		node = cpu_to_node(cpu);
		gfp = GFP_KERNEL;
	} else {
		node = NUMA_NO_NODE;
		gfp = GFP_KERNEL_ACCOUNT
	}
	gfp |= __GFP_ZERO;

	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
		return alloc_pages_node(node, gfp, 0);

	/*
	 * Allocate an SNP-safe page to workaround the SNP erratum where
	 * the CPU will incorrectly signal an RMP violation #PF if a
	 * hugepage (2MB or 1GB) collides with the RMP entry of a
	 * 2MB-aligned VMCB, VMSA, or AVIC backing page.
	 *
	 * Allocate one extra page, choose a page which is not
	 * 2MB-aligned, and free the other.
	 */
	p = alloc_pages_node(node, gfp, 1);
	if (!p)
		return NULL;

	split_page(p, 1);

	pfn = page_to_pfn(p);
	if (IS_ALIGNED(pfn, PTRS_PER_PMD))
		__free_page(p++);
	else
		__free_page(p + 1);

	return p;
}


