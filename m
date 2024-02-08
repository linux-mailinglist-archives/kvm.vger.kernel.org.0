Return-Path: <kvm+bounces-8348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D81E84E37A
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 15:51:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D04A21C230B0
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 14:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1847AE79;
	Thu,  8 Feb 2024 14:51:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD696149DFF;
	Thu,  8 Feb 2024 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707403900; cv=none; b=HBDH1OB17GGCRlFfHXifwdiUGFSVINOQoGxoBv2/IR7UJV5hmmGCFA63Zb97UR17iDqyBWHmqYwqf8B5fLbCn9X3LScwJ2/XU99rdxKxptQkHQOIsVkgCS+FCEV9C4UncY+9IoVwTzohw3IlZEkaZl1UiaeCCFVdYlOozZ052gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707403900; c=relaxed/simple;
	bh=H3JliNSIVGW2a5U9VupsVIrX9pf2EG9gcj0iEeG/xlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SMTo+QLVZfaIMLzppQPhZSq4gFnxffY93siaRQ3LIuQHodQWIcV9LdqahrMB9unE7VeXohLKuKOkBL4gdUZuVwu5Gn4zoyWqCzzi7zlUyj/pFcB7/1oqqpZeWNmhrOawQbTnhRPzl2U4hdztRtMVLy54NEOj32wT+VHm3ZCwq8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3BEC433F1;
	Thu,  8 Feb 2024 14:51:32 +0000 (UTC)
Date: Thu, 8 Feb 2024 14:51:30 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, will@kernel.org, mark.rutland@arm.com,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	andreyknvl@gmail.com, wangjinchao@xfusion.com, gshan@redhat.com,
	ricarkol@google.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, kvmarm@lists.linux.dev,
	mochs@nvidia.com, zhiw@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 3/4] kvm: arm64: set io memory s2 pte as normalnc for
 vfio pci device
Message-ID: <ZcTqcqE69zkLZgQx@arm.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-4-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207204652.22954-4-ankita@nvidia.com>

On Thu, Feb 08, 2024 at 02:16:51AM +0530, ankita@nvidia.com wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d14504821b79..e1e6847a793b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1381,7 +1381,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	int ret = 0;
>  	bool write_fault, writable, force_pte = false;
>  	bool exec_fault, mte_allowed;
> -	bool device = false;
> +	bool device = false, vfio_allow_wc = false;
>  	unsigned long mmu_seq;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> @@ -1472,6 +1472,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	gfn = fault_ipa >> PAGE_SHIFT;
>  	mte_allowed = kvm_vma_mte_allowed(vma);
>  
> +	vfio_allow_wc = (vma->vm_flags & VM_VFIO_ALLOW_WC);

Nitpick: no need for brackets, '=' has a pretty low precedence.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

