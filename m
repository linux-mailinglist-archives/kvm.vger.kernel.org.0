Return-Path: <kvm+bounces-30108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3623B9B6E7E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 22:12:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD0741F22E55
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 21:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0FE42170CB;
	Wed, 30 Oct 2024 21:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hOdj19Vi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25F1215024
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 21:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730322719; cv=none; b=gfWahCIm9oW5bTtA/W0Jf0rQX7AiJohFzhJmG3mT5SVOTsUpNftA+JTArnYhYhIzEknvA+KDKhR2cRR+pCnD707kRm796W15i50rNLlxRMIJHRJLzN7bTXm1nVFRUUKgGDpXsR34K7iU5cwa0O3fy130+Ueref8cjBGBWvuCNJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730322719; c=relaxed/simple;
	bh=dK8zblxdg7VQz/w2whC3EVz1aUFGq+CflEQqeOv8y6Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LDlZhZtESdEkFrWZ4pgFhLaWaFw7bMw0WZFAZz7eJpxb46drAb7KNQRz7CsAruEhr0dJmcdwkX7yM3StgXHJ9aCrEHguqQedubGVrRVY079jIelo53zIN6eHqMKXQV0Zd50cI+9WYOXxNJrVuPyf2cHzRFhqx5FDXuNzEn1iSiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hOdj19Vi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730322715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rRHcL+YDIMgSKFkvGIrjcEfwCn7euHJZZibYKEHMXN4=;
	b=hOdj19Viu2PYe5CXoO1cmRRtE6VfBWJBBj6qkZwLSA5Bv8ee5GnZfWx+iO4HXpSCFv5ziQ
	FvxNYkS7DbSG/UnfsusTLl3kQp2/TXCU95rxrUKMBVu9IaD4iQIesga4CSzN21vJUf+W+q
	M/3xkpgP5YUy5LbM3Hx2gF3I/aWifZc=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-3qMO_U9qP-qUarWUSzmMsw-1; Wed, 30 Oct 2024 17:11:54 -0400
X-MC-Unique: 3qMO_U9qP-qUarWUSzmMsw-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-718074f58fcso483597a34.1
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 14:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730322713; x=1730927513;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rRHcL+YDIMgSKFkvGIrjcEfwCn7euHJZZibYKEHMXN4=;
        b=iDH/lFQoRtrNtPpaDmIglcBxixCfivvWLR4YM220YyVrgZ0BuF+bLMjQ5NplPB+ZqP
         3PiA1d91v6tT8WI0wgvTvNMkAtc03jdmlo9zNhZxOm/Xit+L+7H9PKY9YkfxgxfYcBuc
         KrMUyksX0KvNC3J8CljhsBDjpZIvEIDr26Lk1rQ8hQ4hJAh0kQDDWz9YU9EIm5AuoG2W
         1akTtDsOETF4Tl2Oy/+CV5Htp94MpIzIj1YSmanGY44C+SR9dlimewCmz3E9NfXNjzZX
         uPZqlN7pEkBnoUPs2mEZw7w4gzI/yXZoGil6nWptOB/HPSGbHQ3bExhwvCZ8DWD2H2C2
         w8FA==
X-Gm-Message-State: AOJu0YxnAa/alYfxf6McXwVVY91lUPuAWg9hNV2FEAHLCpLc3RIip1Tb
	YT1zoc3KgdGKzDplJY/hx1DzOt2964R7zKqtZAmADpRLL08ZjbibnWTm3/i9CucEhXci3bC0lbO
	y4LBQaJxyehZ1iqOmpKDpnSnuvYpa32/Rzlo8JX38T4FIVfB4FJYXphoCcA==
X-Received: by 2002:a05:6358:312a:b0:1bc:8d9c:e55a with SMTP id e5c5f4694b2df-1c3f9da1a7fmr885077955d.1.1730322713543;
        Wed, 30 Oct 2024 14:11:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGhqgf5KC2VCX90+BzDsMx6sEYU7BuWip331+ObesFyjp0SCvHBlJ980/j+JIH8IgxqqeKC1w==
X-Received: by 2002:a05:6358:312a:b0:1bc:8d9c:e55a with SMTP id e5c5f4694b2df-1c3f9da1a7fmr885076055d.1.1730322713180;
        Wed, 30 Oct 2024 14:11:53 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-462ad086df0sm481011cf.5.2024.10.30.14.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 14:11:52 -0700 (PDT)
Message-ID: <d871e7e8d0c874bb59fd3d43eb0afdffb87d9eed.camel@redhat.com>
Subject: Re: [PATCH v4 1/4] KVM: x86: Bypass register cache when querying
 CPL from kvm_sched_out()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 30 Oct 2024 17:11:52 -0400
In-Reply-To: <20241009175002.1118178-2-seanjc@google.com>
References: <20241009175002.1118178-1-seanjc@google.com>
	 <20241009175002.1118178-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-10-09 at 10:49 -0700, Sean Christopherson wrote:
> When querying guest CPL to determine if a vCPU was preempted while in
> kernel mode, bypass the register cache, i.e. always read SS.AR_BYTES from
> the VMCS on Intel CPUs.  If the kernel is running with full preemption
> enabled, using the register cache in the preemption path can result in
> stale and/or uninitialized data being cached in the segment cache.
> 
> In particular the following scenario is currently possible:
> 
>  - vCPU is just created, and the vCPU thread is preempted before
>    SS.AR_BYTES is written in vmx_vcpu_reset().
> 
>  - When scheduling out the vCPU task, kvm_arch_vcpu_in_kernel() =>
>    vmx_get_cpl() reads and caches '0' for SS.AR_BYTES.
> 
>  - vmx_vcpu_reset() => seg_setup() configures SS.AR_BYTES, but doesn't
>    invoke vmx_segment_cache_clear() to invalidate the cache.
> 
> As a result, KVM retains a stale value in the cache, which can be read,
> e.g. via KVM_GET_SREGS.  Usually this is not a problem because the VMX
> segment cache is reset on each VM-Exit, but if the userspace VMM (e.g KVM
> selftests) reads and writes system registers just after the vCPU was
> created, _without_ modifying SS.AR_BYTES, userspace will write back the
> stale '0' value and ultimately will trigger a VM-Entry failure due to
> incorrect SS segment type.
> 
> Note, the VM-Enter failure can also be avoided by moving the call to
> vmx_segment_cache_clear() until after the vmx_vcpu_reset() initializes all
> segments.  However, while that change is correct and desirable (and will
> come along shortly), it does not address the underlying problem that
> accessing KVM's register caches from !task context is generally unsafe.
> 
> In addition to fixing the immediate bug, bypassing the cache for this
> particular case will allow hardening KVM register caching log to assert
> that the caches are accessed only when KVM _knows_ it is safe to do so.
> 
> Fixes: de63ad4cf497 ("KVM: X86: implement the logic for spinlock optimization")
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Closes: https://lore.kernel.org/all/20240716022014.240960-3-mlevitsk@redhat.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/svm/svm.c             |  1 +
>  arch/x86/kvm/vmx/main.c            |  1 +
>  arch/x86/kvm/vmx/vmx.c             | 23 ++++++++++++++++++-----
>  arch/x86/kvm/vmx/vmx.h             |  1 +
>  arch/x86/kvm/x86.c                 |  8 +++++++-
>  7 files changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 861d080ed4c6..5aff7222e40f 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -34,6 +34,7 @@ KVM_X86_OP(set_msr)
>  KVM_X86_OP(get_segment_base)
>  KVM_X86_OP(get_segment)
>  KVM_X86_OP(get_cpl)
> +KVM_X86_OP(get_cpl_no_cache)
>  KVM_X86_OP(set_segment)
>  KVM_X86_OP(get_cs_db_l_bits)
>  KVM_X86_OP(is_valid_cr0)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6d9f763a7bb9..3ae90df0a177 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1656,6 +1656,7 @@ struct kvm_x86_ops {
>  	void (*get_segment)(struct kvm_vcpu *vcpu,
>  			    struct kvm_segment *var, int seg);
>  	int (*get_cpl)(struct kvm_vcpu *vcpu);
> +	int (*get_cpl_no_cache)(struct kvm_vcpu *vcpu);
>  	void (*set_segment)(struct kvm_vcpu *vcpu,
>  			    struct kvm_segment *var, int seg);
>  	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9df3e1e5ae81..50f6b0e03d04 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5031,6 +5031,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.get_segment = svm_get_segment,
>  	.set_segment = svm_set_segment,
>  	.get_cpl = svm_get_cpl,
> +	.get_cpl_no_cache = svm_get_cpl,
>  	.get_cs_db_l_bits = svm_get_cs_db_l_bits,
>  	.is_valid_cr0 = svm_is_valid_cr0,
>  	.set_cr0 = svm_set_cr0,
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 7668e2fb8043..92d35cc6cd15 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -50,6 +50,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.get_segment = vmx_get_segment,
>  	.set_segment = vmx_set_segment,
>  	.get_cpl = vmx_get_cpl,
> +	.get_cpl_no_cache = vmx_get_cpl_no_cache,
>  	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
>  	.is_valid_cr0 = vmx_is_valid_cr0,
>  	.set_cr0 = vmx_set_cr0,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1a4438358c5e..12dd7009efbe 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3568,16 +3568,29 @@ u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
>  	return vmx_read_guest_seg_base(to_vmx(vcpu), seg);
>  }
>  
> -int vmx_get_cpl(struct kvm_vcpu *vcpu)
> +static int __vmx_get_cpl(struct kvm_vcpu *vcpu, bool no_cache)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	int ar;
>  
>  	if (unlikely(vmx->rmode.vm86_active))
>  		return 0;
> -	else {
> -		int ar = vmx_read_guest_seg_ar(vmx, VCPU_SREG_SS);
> -		return VMX_AR_DPL(ar);
> -	}
> +
> +	if (no_cache)
> +		ar = vmcs_read32(GUEST_SS_AR_BYTES);
> +	else
> +		ar = vmx_read_guest_seg_ar(vmx, VCPU_SREG_SS);
> +	return VMX_AR_DPL(ar);
> +}
> +
> +int vmx_get_cpl(struct kvm_vcpu *vcpu)
> +{
> +	return __vmx_get_cpl(vcpu, false);
> +}
> +
> +int vmx_get_cpl_no_cache(struct kvm_vcpu *vcpu)
> +{
> +	return __vmx_get_cpl(vcpu, true);
>  }
>  
>  static u32 vmx_segment_access_rights(struct kvm_segment *var)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 2325f773a20b..bcf40c7f3a38 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -385,6 +385,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>  void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
>  			unsigned long fs_base, unsigned long gs_base);
>  int vmx_get_cpl(struct kvm_vcpu *vcpu);
> +int vmx_get_cpl_no_cache(struct kvm_vcpu *vcpu);
>  bool vmx_emulation_required(struct kvm_vcpu *vcpu);
>  unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
>  void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83fe0a78146f..830073294640 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5094,7 +5094,13 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	int idx;
>  
>  	if (vcpu->preempted) {
> -		vcpu->arch.preempted_in_kernel = kvm_arch_vcpu_in_kernel(vcpu);
> +		/*
> +		 * Assume protected guests are in-kernel.  Inefficient yielding
> +		 * due to false positives is preferable to never yielding due
> +		 * to false negatives.
> +		 */
> +		vcpu->arch.preempted_in_kernel = vcpu->arch.guest_state_protected ||
> +						 !kvm_x86_call(get_cpl_no_cache)(vcpu);
>  
>  		/*
>  		 * Take the srcu lock as memslots will be accessed to check the gfn


Initially I thought that we need to do this for the CPL, and the RIP at least, but
if this is done only for the CPL, it is reasonable IMHO.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky





