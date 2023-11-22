Return-Path: <kvm+bounces-2318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D85AA7F4E9E
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 18:44:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60851B20EBB
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 17:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 129EE58AA6;
	Wed, 22 Nov 2023 17:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IwOjoiZJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2231AB
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 09:44:01 -0800 (PST)
Date: Wed, 22 Nov 2023 17:43:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700675039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yif9/R0seijjZkswLQjC123TRryhMDeXRV3W6l704w8=;
	b=IwOjoiZJ6TZRDftP7Jo9gW0ZJ9MwzjqkHORLvzXmRcPo1qmdtm33R9vb2jhi0y9al0MF36
	i+EBAFS31KNsBUdQmnHqPb93ME3fa92OJXrjnAm8Og1Z2G3o3EhJDUrTj9QxrQq6QynVtg
	t3+V/1Vbx7/n4Lo5kaLDfcqOW+ABwOM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 1/3] KVM: arm64: selftests: Standardize GIC base
 addresses
Message-ID: <ZV4924juGGCk2cjf@linux.dev>
References: <20231103192915.2209393-1-coltonlewis@google.com>
 <20231103192915.2209393-2-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103192915.2209393-2-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 03, 2023 at 07:29:13PM +0000, Colton Lewis wrote:
> Use default values during GIC initialization and setup to avoid
> multiple tests needing to decide and declare base addresses for GICD
> and GICR. Remove the repeated definitions of these addresses across
> tests.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

<snip>

> -void gic_init(enum gic_type type, unsigned int nr_cpus,
> +void _gic_init(enum gic_type type, unsigned int nr_cpus,
>  		void *dist_base, void *redist_base)
>  {
>  	uint32_t cpu = guest_get_vcpuid();
> @@ -63,6 +63,11 @@ void gic_init(enum gic_type type, unsigned int nr_cpus,
>  	gic_cpu_init(cpu, redist_base);
>  }
>  
> +void gic_init(enum gic_type type, unsigned int nr_cpus)
> +{
> +	_gic_init(type, nr_cpus, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
> +}
> +

</snip>

> -int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
> +int _vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t nr_irqs,
>  		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
>  {
>  	int gic_fd;
> @@ -79,6 +79,11 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
>  	return gic_fd;
>  }
>  
> +int vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t nr_irqs)
> +{
> +	return _vgic_v3_setup(vm, nr_vcpus, nr_irqs, GICD_BASE_GPA, GICR_BASE_GPA);
> +}
> +

What's the point of having the internal implementations of these
functions that still take addresses? If we're standardizing GIC
placement then there's no need for allowing the caller to provide
different addresses.

-- 
Thanks,
Oliver

