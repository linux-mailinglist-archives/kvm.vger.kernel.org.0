Return-Path: <kvm+bounces-49717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E39ADD110
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 17:10:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AF8C165024
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8902E92BC;
	Tue, 17 Jun 2025 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1V8IgRl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E708D2E889A;
	Tue, 17 Jun 2025 15:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750173019; cv=none; b=uusAlsXv7o5kGjlmAy/aYeWxh51aOhZB3g6LnDFupEC7ZKgerjTjnM7wAPLpeRyZVLNbFIaIHH86Pb/nAAfvFBDs6Un01EpRJVacj8FKEeNC4UdI94HEOg3nw8p0Xn7GJq+JCuQxK74dbGVTuzgVylTYllY2LuaeNy8RUe+DHps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750173019; c=relaxed/simple;
	bh=TZcOBjPsqZfGB1DMcUTuXivLLt+YrMUoZ3nRg9JcutA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qs+b4vVpu/W53/PM0eF8RBOs228FmQ3E+JAFQSqQvyLa8pAwgxdA6SYmYhjz3rd5YlNUSm/pnOd/zmiIfEjHhrlDLcNMRtjiROfTJvmaUoEVMFQ0YSYFMv0EFfZ7AtoaX1fUYKFXmzXcLJPVRL1PnqcnBah9FgWr5/B5NBMwru0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1V8IgRl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB254C4CEE3;
	Tue, 17 Jun 2025 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750173018;
	bh=TZcOBjPsqZfGB1DMcUTuXivLLt+YrMUoZ3nRg9JcutA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l1V8IgRlHTwSpqeHPfwcab6KJbWP4sgrPRjDiY5mVBfW1R1Ysf8BUTKEIPao3PYyQ
	 lI3B1+Mj6q5O5kBypRlQzoI0+zeVg+I1fwkDRbujK5PcEnZUMljlB8yEQocCjbqlXl
	 vSAD4DY6nXirSVMcaqOWWV5d61j6LRHxZvTg8UArFI6hBYa6KarYXR+JTOG3pMWy0Q
	 ltpk+JEFpn0LUZuzNOniyP0LlW9VNrfuBZo8dxB8XEJHh8d8DFdgtkHUqCD/RXZq2Z
	 BcjKScmmFE7bQHLs4S3AgeqqmssrlnkLDTG7lQ7nEMwFC1/4FwVhOyJn3+Gi8b0qI6
	 q+AdRLx1gSiEA==
Date: Tue, 17 Jun 2025 20:31:36 +0530
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
Subject: Re: [PATCH v3 14/62] KVM: SVM: Track AVIC tables as natively sized
 pointers, not "struct pages"
Message-ID: <a7j5yllrxxzaqzjcmpfu3oxh775xgzx7h7nrkw53rmucnrbspy@zlwzwgfd7uke>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-16-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-16-seanjc@google.com>

On Wed, Jun 11, 2025 at 03:45:17PM -0700, Sean Christopherson wrote:
> @@ -277,8 +265,8 @@ static int avic_init_backing_page(struct kvm_vcpu 
> *vcpu)
>  		return 0;
>  	}
>  
> -	BUILD_BUG_ON((AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE ||
> -		     (X2AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE);
> +	BUILD_BUG_ON((AVIC_MAX_PHYSICAL_ID + 1) * sizeof(new_entry) > PAGE_SIZE ||
> +		     (X2AVIC_MAX_PHYSICAL_ID + 1) * sizeof(new_entry) > PAGE_SIZE);

Ah, you change to 'new_entry' here. Would be good to rename it to just 
'entry', but that's a minor nit. Ignore my comment on the previous 
patch.

For this patch:
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>


- Naveen

