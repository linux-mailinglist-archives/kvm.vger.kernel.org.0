Return-Path: <kvm+bounces-48615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92C03ACF9CF
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 00:45:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE4613AD851
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 22:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86C427FB3F;
	Thu,  5 Jun 2025 22:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HPfmmRSr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F07027CCF3
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 22:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749163529; cv=none; b=elpES4Rrs7fqhBs4L6DS/mnd6NhlNy2In+2EyRHe9rNmR89TBR+GlY7LTOsTd9QE4+CwVBygr0nV3XsHSdknZ43YYyXi2I4JHTV8Jlv5QaJbVqx4zItlG96BzoFTkqgEwmmGPxi+5Q3H/27Er0QDbDpTi5CCwWEavy7yBfKddRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749163529; c=relaxed/simple;
	bh=6YuAfwZQJjuClEHEe0uU4Jv+uNSJ56oYiKv6H3ihh0M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BXcjiosEYc7iyS7yfeP4JOui3Wi7TkUcMakbP5w6LEg73T/4wkr6UdjGcsx5dOE59DDlX4Vt4yLVCTjJFh+8VVPXzl1WwB9zBNHx27CM1YyNHaqJprQENHjndWNa6HaNBu5mHon42PlJ8wzhjeWKBLdfhqA/DWD+QMRgMkBZEmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HPfmmRSr; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234aceaf591so9779365ad.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 15:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749163527; x=1749768327; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ugvQvrQ0LdnzKH+hQvM3dsEHBtBiigm9XRnIEkv/Xbo=;
        b=HPfmmRSrBV9p4Y+tg9QVvq2mOBBeEpgkErqlYEGQh6hBQouAjtmTRXbhPgUZNLDoPz
         dI9Oc7AzSxVBHljlSfQL+XobIt7bPhp1/KMJFuhESEKYu2brIKAX7Iv+u3ouLNoKkPSd
         CI0L/I7Cl24y/Obhi6XcN4DFwQ7yGuSCgoq9B+MZgCwmXosWi/MQS+3dNxij1PHd51HU
         49+Q94dv8Lx0ewVzXipQbiIq2H3j5zBomWju6z0k2xkaLqQ22670T1NNQwb56DbcqNeM
         VsucFXDNztFJ0ECbYyUFa6WA5wHnXMFqmmruO4FvGH/2PiSi9v3LXr2K4afRDHNv2v57
         yygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749163527; x=1749768327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ugvQvrQ0LdnzKH+hQvM3dsEHBtBiigm9XRnIEkv/Xbo=;
        b=OV1q86iv1EWFpwF2Of5BpMJM27fFWxn9dQn9CIQKF/ribO3QDSRCSTpdy1rx3Ig8cG
         CJ1ydRopjnUR774Ir8U7q2e47bWTZulT+Sub2G+ILSXj8CWcO5x8rWjo7VfkSVt3VjuV
         OOF89tzQm7BLJq9a6Of8kloI8rWxS+kQG0CNwGqZpq5f9e9e4UkoEBlZ338rqQEjFGyW
         9IPCRNQ2eB0ojWCLPt/OmBo1WA9c5+yNYd+pOX/1ctU8YnooAFncXWPp3GZJMj+XyvTV
         LnSF5Q7sV4rCBls1pBRvYUrxTk8QiyDPzpGakAieaGX1aapmc9Ob6xTBHr2K5DaKjtP+
         yLfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMzn1k5S57d13lS8kY7+FZLorrVAZp4jBJTKDGH/vBtcc0H8DAgOcR+4H+KdsxtGdhmtg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjhhBs73QM4LW1yv893GEXI927Ay3ImKYPJ04gNxKEsHMtGNXk
	Oy3kXOaRxEqzDZPAe0ejLfX5/2Qnc+s3oCTy2hlvP1w1GHOWRZ7SlO3oxTQ/3rDpJFqUmOO5qCD
	tD6xCGA==
X-Google-Smtp-Source: AGHT+IF4XA/cekiM7zz30QoLBWk54GmCCOInuS1IOF6zdOMi/h4d856on0mJoA5XVDm65MtEqJtNKw45MiM=
X-Received: from pjbqo14.prod.google.com ([2002:a17:90b:3dce:b0:2ff:84e6:b2bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce82:b0:234:bc4e:4eb4
 with SMTP id d9443c01a7336-23601dec370mr11746275ad.51.1749163526816; Thu, 05
 Jun 2025 15:45:26 -0700 (PDT)
Date: Thu, 5 Jun 2025 15:45:25 -0700
In-Reply-To: <20250401161106.790710-8-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401161106.790710-1-pbonzini@redhat.com> <20250401161106.790710-8-pbonzini@redhat.com>
Message-ID: <aEIeBU72WBWnlZdZ@google.com>
Subject: Re: [PATCH 07/29] KVM: do not use online_vcpus to test vCPU validity
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, roy.hopkins@suse.com, 
	thomas.lendacky@amd.com, ashish.kalra@amd.com, michael.roth@amd.com, 
	jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de, 
	James.Bottomley@hansenpartnership.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 01, 2025, Paolo Bonzini wrote:
> Different planes can initialize their vCPUs separately, therefore there is
> no single online_vcpus value that can be used to test that a vCPU has
> indeed been fully initialized.
> 
> Use the shiny new plane field instead, initializing it to an invalid value
> (-1) while the vCPU is visible in the xarray but may still disappear if
> the creation fails.

Checking vcpu->plane _in addition_ to online_cpus seems way safer than checking
vcpu->plane _instead_ of online_cpus.  Even if we end up checking only vcpu->plane,
I think that should be a separate patch.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/i8254.c     |  3 ++-
>  include/linux/kvm_host.h | 23 ++++++-----------------
>  virt/kvm/kvm_main.c      | 20 +++++++++++++-------
>  3 files changed, 21 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index d7ab8780ab9e..e3a3e7b90c26 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -260,9 +260,10 @@ static void pit_do_work(struct kthread_work *work)
>  	 * VCPUs and only when LVT0 is in NMI mode.  The interrupt can
>  	 * also be simultaneously delivered through PIC and IOAPIC.
>  	 */
> -	if (atomic_read(&kvm->arch.vapics_in_nmi_mode) > 0)
> +	if (atomic_read(&kvm->arch.vapics_in_nmi_mode) > 0) {

Spurious change (a good change, but noisy for this patch).

>  		kvm_for_each_vcpu(i, vcpu, kvm)
>  			kvm_apic_nmi_wd_deliver(vcpu);
> +	}
>  }
>  
>  static enum hrtimer_restart pit_timer_fn(struct hrtimer *data)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4d408d1d5ccc..0db27814294f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -992,27 +992,16 @@ static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
>  
>  static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
>  {
> -	int num_vcpus = atomic_read(&kvm->online_vcpus);
> -
> -	/*
> -	 * Explicitly verify the target vCPU is online, as the anti-speculation
> -	 * logic only limits the CPU's ability to speculate, e.g. given a "bad"
> -	 * index, clamping the index to 0 would return vCPU0, not NULL.
> -	 */
> -	if (i >= num_vcpus)
> +	struct kvm_vcpu *vcpu = xa_load(&kvm->vcpu_array, i);

newline

> +	if (vcpu && unlikely(vcpu->plane == -1))
>  		return NULL;
>  
> -	i = array_index_nospec(i, num_vcpus);

Don't we still need to prevent speculating into the xarray ?

> -
> -	/* Pairs with smp_wmb() in kvm_vm_ioctl_create_vcpu.  */
> -	smp_rmb();
> -	return xa_load(&kvm->vcpu_array, i);
> +	return vcpu;
>  }
>  
> -#define kvm_for_each_vcpu(idx, vcpup, kvm)				\
> -	if (atomic_read(&kvm->online_vcpus))				\
> -		xa_for_each_range(&kvm->vcpu_array, idx, vcpup, 0,	\
> -				  (atomic_read(&kvm->online_vcpus) - 1))
> +#define kvm_for_each_vcpu(idx, vcpup, kvm)			\
> +	xa_for_each(&kvm->vcpu_array, idx, vcpup)		\
> +		if ((vcpup)->plane == -1) ; else		\
>  
>  static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
>  {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e343905e46d8..eba02cb7cc57 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4186,6 +4186,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>  		goto unlock_vcpu_destroy;
>  	}
>  
> +	/*
> +	 * Store an invalid plane number until fully initialized.  xa_insert() has
> +	 * release semantics, which ensures the write is visible to kvm_get_vcpu().
> +	 */
> +	vcpu->plane = -1;
>  	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
>  	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
>  	WARN_ON_ONCE(r == -EBUSY);
> @@ -4195,7 +4200,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>  	/*
>  	 * Now it's all set up, let userspace reach it.  Grab the vCPU's mutex
>  	 * so that userspace can't invoke vCPU ioctl()s until the vCPU is fully
> -	 * visible (per online_vcpus), e.g. so that KVM doesn't get tricked
> +	 * visible (valid vcpu->plane), e.g. so that KVM doesn't get tricked
>  	 * into a NULL-pointer dereference because KVM thinks the _current_
>  	 * vCPU doesn't exist.  As a bonus, taking vcpu->mutex ensures lockdep
>  	 * knows it's taken *inside* kvm->lock.
> @@ -4206,12 +4211,13 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>  	if (r < 0)
>  		goto kvm_put_xa_erase;
>  
> -	/*
> -	 * Pairs with smp_rmb() in kvm_get_vcpu.  Store the vcpu
> -	 * pointer before kvm->online_vcpu's incremented value.

Bad me for not updating this comment, but kvm_vcpu_on_spin() also pairs with this
barrier, and needs to be updated to be planes-aware, e.g. this looks like a NULL
pointer deref waiting to happen:

		vcpu = xa_load(&plane->vcpu_array, idx);
		if (!READ_ONCE(vcpu->ready))
			continue;

