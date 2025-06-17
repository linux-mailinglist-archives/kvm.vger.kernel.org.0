Return-Path: <kvm+bounces-49716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55BB6ADD0AE
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:57:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C812188857F
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 14:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6E1227E8A;
	Tue, 17 Jun 2025 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0+YY0EV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CBB18DB35;
	Tue, 17 Jun 2025 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171821; cv=none; b=lracx+VKubQyh4P+F36eoezzwzoBFB5fdqpHls6MtnaexLF+ZCxpdnpnrxV2TcHT4FGxFmhzFV+uFEzz4diTf3EL8sqjwRq3C3aURB/h+uxEl5id+thk7GZHFXwdK6wPNcLkpyDJcEed428rbBk2pHLeXY/MdgFPfFbWAlVaOQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171821; c=relaxed/simple;
	bh=vcZN/uU0Z+D8+9jFTvc1z2F6ONl+fjkhBpzf5Kdq9CU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G7HBF/JBbayHSucvbKjWsVxZyaLa+h6cSYSyfbeki/HHHYe1+Py/2uuCRLaVNwIc2mqjRrv2IBSaZj/jGGmxLRomXH5U1WYZNAd47yB2vs8xZaGg+CAjT+4IM9aQdcNkpzTcERuX+0vYoIF1HKjhk7zUrw63CaZHgDv2uVlqdi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0+YY0EV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55311C4CEE3;
	Tue, 17 Jun 2025 14:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750171820;
	bh=vcZN/uU0Z+D8+9jFTvc1z2F6ONl+fjkhBpzf5Kdq9CU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A0+YY0EVIITtA40tAwzQzDmH/iGvRkWodYkM2BCdZc1UB2XNmBqOxD/1GWCYFwdjZ
	 f83THZKNo3sMSBPUtmNm2BIgcsk+Yysf/zFnJ2anqIxIeIjFrDZpCS5oaLfKu07v71
	 BHKqvPyjGlD/cUOttYS6tEdIS3gzTsfP6rjS6lQgjEXQYe7KwqCuHAWr+m+8Q1i7DL
	 32yRoA3HxlAoPkZ48bhAlXHf/kinoOQmlUcaC+rhhnbSBRMS9de8WTz94GF9EaR3oT
	 IdR56IFaIRJT+mCKsvqqQDINhRs0UDN7UncakMdcUV/d8nnPCWs5GWFUfUiXiZm2EB
	 jSu365NQOVUug==
Date: Tue, 17 Jun 2025 20:19:00 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 13/62] KVM: SVM: Drop redundant check in AVIC code on
 ID during vCPU creation
Message-ID: <qusmkqqsvc7hyuemddv66mooach7mdq66mxbk7qbr6if6spguj@k57k5lqmvt5u>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-15-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-15-seanjc@google.com>

On Wed, Jun 11, 2025 at 03:45:16PM -0700, Sean Christopherson wrote:
>  static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  {
> -	u64 *entry, new_entry;
> -	int id = vcpu->vcpu_id;
> +	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	u32 id = vcpu->vcpu_id;
> +	u64 *table, new_entry;
>  
>  	/*
>  	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
> @@ -291,6 +277,9 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  		return 0;
>  	}
>  
> +	BUILD_BUG_ON((AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE ||
> +		     (X2AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE);
						    ^^^^^^^^^^^^^^
Renaming new_entry to just 'entry' and using sizeof(entry) makes this 
more readable for me. Otherwise, for this patch:
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>


As an aside, there are a few static asserts to validate some of the 
related macros. Can this also be a static_assert(), or is there is 
reason to prefer BUILD_BUG_ON()?


- Naveen


