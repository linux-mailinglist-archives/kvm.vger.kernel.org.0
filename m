Return-Path: <kvm+bounces-52692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97375B0845A
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 07:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF5C7567F92
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 05:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29F992040AB;
	Thu, 17 Jul 2025 05:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VdUE6A0L"
X-Original-To: kvm@vger.kernel.org
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206BE18A6AB;
	Thu, 17 Jul 2025 05:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752731095; cv=none; b=hI93FigNNRiuigMuTaB6QSMnByfdORiLA3mivePYdKBqcWOlHFdx9+5Xn5NOB7OJmM18Ywplizr1YxRc9F8rFQDvRhgmH0ohGtNeQJhmXapbkrgXCWVdhdDY8wzl1Ll/abTfLpTPP9ZWah+ApuTH4HfLM8Y8HEMLy6AuKcE3j3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752731095; c=relaxed/simple;
	bh=w491fvpswdgO9wRATDhvQPUCge5G7qz5bcA5tAA2vyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tyqBpzalbnNa7oAk0uzVDTeJJBj7ItoMh+E3/JHtMQjKLZ9TnxqlHUekY/aEgz2eJQ9S2jEK8UJCs4Bajahlh9VDNv+WjMmQDxMSRIBcbwfyWF9Wfh492a5syoa0WJTiIxMTsYWpOvwnDFqbKu4JIIFrTBrbjD/unaWuscziCjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VdUE6A0L; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1752731089; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=kBJJqTsK6OR0NVSYEEqLg25vZSFAVXL/THfeZ/uRZK8=;
	b=VdUE6A0Lcl0Qhzs3kbycYeYfSvW3vpLa8XHDs7NX28dV5Y43Xqy/2gApcRiZDhr2L16L5CaRS0QqjvF1+WgCuVGcLhEO3xzZFqStQtlMyQoMfBp+RwcQUr/oBm7F4VctPEtkP5dqJWyZ8u4vgxv0vZeW0ZmtHg81TzN77R+wtvc=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0Wj6rlc._1752731088 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 17 Jul 2025 13:44:49 +0800
Date: Thu, 17 Jul 2025 13:44:48 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Keir Fraser <keirf@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Explicitly implement
 vgic_dist::ready ordering
Message-ID: <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34>
References: <20250716110737.2513665-1-keirf@google.com>
 <20250716110737.2513665-3-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716110737.2513665-3-keirf@google.com>

On Wed, Jul 16, 2025 at 11:07:35AM +0800, Keir Fraser wrote:
> In preparation to remove synchronize_srcu() from MMIO registration,
> remove the distributor's dependency on this implicit barrier by
> direct acquire-release synchronization on the flag write and its
> lock-free check.
>
> Signed-off-by: Keir Fraser <keirf@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 502b65049703..bc83672e461b 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -567,7 +567,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
>  	gpa_t dist_base;
>  	int ret = 0;
>
> -	if (likely(dist->ready))
> +	if (likely(smp_load_acquire(&dist->ready)))
>  		return 0;
>
>  	mutex_lock(&kvm->slots_lock);
> @@ -598,14 +598,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
>  		goto out_slots;
>  	}
>
> -	/*
> -	 * kvm_io_bus_register_dev() guarantees all readers see the new MMIO
> -	 * registration before returning through synchronize_srcu(), which also
> -	 * implies a full memory barrier. As such, marking the distributor as
> -	 * 'ready' here is guaranteed to be ordered after all vCPUs having seen
> -	 * a completely configured distributor.
> -	 */
> -	dist->ready = true;
> +	smp_store_release(&dist->ready, true);

No need the store-release and load-acquire for replacing
synchronize_srcu_expedited() w/ call_srcu() IIUC:

Tree SRCU on SMP:
call_srcu()
 __call_srcu()
  srcu_gp_start_if_needed()
    __srcu_read_unlock_nmisafe()
	 #ifdef	CONFIG_NEED_SRCU_NMI_SAFE
	   	  smp_mb__before_atomic() // __smp_mb() on ARM64, do nothing on x86.
	 #else
          __srcu_read_unlock()
		   smp_mb()
	 #endif

TINY SRCY on UP:
Should have no memory ordering issue on UP.

>  	goto out_slots;
>  out:
>  	mutex_unlock(&kvm->arch.config_lock);
> --
> 2.50.0.727.gbf7dc18ff4-goog
>

