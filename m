Return-Path: <kvm+bounces-29335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 456C19A98A5
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 07:36:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7FEEAB239FF
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 05:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EFFF13CFA5;
	Tue, 22 Oct 2024 05:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wik+Y5JZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92048136664;
	Tue, 22 Oct 2024 05:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729575393; cv=none; b=WRoFY1PRGjIKQiDpprDXuskJUEFDsruvJDvFRzRw6WjWfqEdGbgXCiqBrDny08+KDKuE8ad2cl7csZ4JqlnaegG/1a6fZk+EkgNgf5YrwBkNSTZbmT6FhQSkEBROESC6e0uHe2oRSW19jvYoLL1stbKovHbRczkgJmkfSmh+FYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729575393; c=relaxed/simple;
	bh=wAQmJk9sBaDF/4frCO1dXVeeLAsFYnKWPlj3F8H/kGI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PKjrn9ZVitGT+unbmk0lFmtd795xZL2hn2YYDh2SJsHm2vvfppL0TE2GTG7BHykni2ZynjaF9qwgBmnCDxfw5Ja+FXNjmu1me/g2rsKdO2tpTTw832PwGCARMwUCbqIRV6oq2f6i7HePTbHhqswn3JYp5iq/eNirU6mQFkD0l0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wik+Y5JZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47947C4CEC3;
	Tue, 22 Oct 2024 05:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729575393;
	bh=wAQmJk9sBaDF/4frCO1dXVeeLAsFYnKWPlj3F8H/kGI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Wik+Y5JZKk4RYdo+5dTY2Sie/7AE3Z7z5mLERcY+v1MbvBoY8jhxYXo/q/t/NVDt0
	 pdZiy1wHdZLSgbg2cOsKWRkPYvpBvXkeEsiVZHLpJMZ3jzHSdz7nXix1otQC7Onoz3
	 6GWMxtXl4AV43+NE5ASm51YojalbuHX0/OicwA6A3Q1T4JbnxmapYXfJDNrsuKwdy5
	 tom+fdCIEduju3mm6RpHgpn0CQOJPGc/lh3750wBNRH/S7S3u5Q/QM+1qTqAauQbTP
	 etB+nlKuTErT9/BjQ3BL6ZyU05lNccjQ7nPE/QJSNrAIoe/v0NpnTpNBxfpjbP382d
	 4+Mlb3JKv6L4w==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 21/43] arm64: RME: Runtime faulting of memory
In-Reply-To: <20241004152804.72508-22-steven.price@arm.com>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-22-steven.price@arm.com>
Date: Tue, 22 Oct 2024 11:06:15 +0530
Message-ID: <yq5a5xpkg0mo.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


....

> +static int private_memslot_fault(struct kvm_vcpu *vcpu,
> +				 phys_addr_t fault_ipa,
> +				 struct kvm_memory_slot *memslot)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	gpa_t gpa = kvm_gpa_from_fault(kvm, fault_ipa);
> +	gfn_t gfn = gpa >> PAGE_SHIFT;
> +	bool priv_exists = kvm_mem_is_private(kvm, gfn);
> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> +	kvm_pfn_t pfn;
> +	int ret;
> +	/*
> +	 * For Realms, the shared address is an alias of the private GPA with
> +	 * the top bit set. Thus is the fault address matches the GPA then it
> +	 * is the private alias.
> +	 */
> +	bool is_priv_gfn = (gpa == fault_ipa);
> +
> +	if (priv_exists != is_priv_gfn) {
> +		kvm_prepare_memory_fault_exit(vcpu,
> +					      gpa,
> +					      PAGE_SIZE,
> +					      kvm_is_write_fault(vcpu),
> +					      false, is_priv_gfn);
> +
> +		return -EFAULT;
> +	}
>

If we want an exit to VMM and handle the fault, should we have the return value 0? For
kvmtool we do have the KVM_RUN ioctl doing the below

	err = ioctl(vcpu->vcpu_fd, KVM_RUN, 0);
	if (err < 0 && (errno != EINTR && errno != EAGAIN))
		die_perror("KVM_RUN failed");


Qemu did end up adding the below condition. 

            if (!(run_ret == -EFAULT && run->exit_reason == KVM_EXIT_MEMORY_FAULT)) {
                fprintf(stderr, "error: kvm run failed %s\n",
                        strerror(-run_ret));


so should we fix kvmtool. We may possibly want to add other exit_reason
and it would be useful to not require similar VMM changes for these exit_reason.

> +
> +	if (!is_priv_gfn) {
> +		/* Not a private mapping, handling normally */
> +		return -EINVAL;
> +	}
> +

-aneesh

