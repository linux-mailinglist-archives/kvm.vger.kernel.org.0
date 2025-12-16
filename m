Return-Path: <kvm+bounces-66081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8947FCC4591
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 17:40:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 27190304C9D7
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 16:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51262C21F4;
	Tue, 16 Dec 2025 16:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ea1RCxiE"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048A056B81
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 16:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765902910; cv=none; b=Rn2aOrstvCizXyxNTZWTaKIB+BbAeXhqz3TaHbGe+QzcHALVhYXsWUZGNWK7qXggurtS3v+lyD8GjfrrNmhFNRVJTbLt1I3cQF8WPfgxSHLVwHh8p2i3DpizcqRNboWNlsExtzyRf0IVDjJYRoPNqkvxUGrLgwgTlxY0ZNIZMHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765902910; c=relaxed/simple;
	bh=qvpdEjcUDM3+eRHVDJiUyeVx/AqZ2iES3mpoHTy/kQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=psfi9LCljGdt5fr++FjqaH0FFWt5BrrDU9WONSWH3K9xufKk4h2msxk2X9/F+G/iPitiIC+SbZ5RYXy9oY2CNDnjy6n2huKKuOHFvC1x/0sCui8kbKHiomq1TOOSKdayi2DoaNrN/7Lnex1RGC2oOFO0CMv4ECJauuKGYnH3SFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ea1RCxiE; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 16 Dec 2025 16:34:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765902900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yml9Gx96F7Zb2nN7cdhrf3qN/V9uqlpQQsF7Q/RPzIE=;
	b=Ea1RCxiEgIQ+Yl3Yu7UiOj0doe8xtOxqYNfw2wPefiCzc4P/2WXkTtlmC1hyOGecurQ8li
	w6To3p6CmB2UmtUJ+K2s1jugevH/VM8tNhKQORkjrgLiUbkYgylGtyn+BS0i1xC/dg21Zp
	mFwBoNkMFgxHI4YA9nr/ovWpwg9k74A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 24/26] KVM: nSVM: Restrict mapping VMCB12 on nested
 VMRUN
Message-ID: <oims37p6hfw4d2ufyinvi44scy3rhmbvibsmi66cde4e4pnidb@ugwhcwtalghf>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
 <20251215192722.3654335-26-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215192722.3654335-26-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 15, 2025 at 07:27:19PM +0000, Yosry Ahmed wrote:
> All accesses to the VMCB12 in the guest memory on nested VMRUN are
> limited to nested_svm_vmrun() and nested_svm_failed_vmrun(). However,
> the VMCB12 remains mapped throughout nested_svm_vmrun().  Mapping and
> unmapping around usages is possible, but it becomes easy-ish to
> introduce bugs where 'vmcb12' is used after being unmapped.
> 
> Move reading the VMCB12 and copying to cache from nested_svm_vmrun()
> into a new helper, nested_svm_copy_vmcb12_to_cache(),  that maps the
> VMCB12, caches the needed fields, and unmaps it. Use
> kvm_vcpu_map_readonly() as only reading the VMCB12 is needed.
> 
> Similarly, move mapping the VMCB12 on VMRUN failure into
> nested_svm_failed_vmrun(). Inject a triple fault if the mapping fails,
> similar to nested_svm_vmexit().
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 55 ++++++++++++++++++++++++++++-----------
>  1 file changed, 40 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 48ba34d8b713..d33a2a27efe5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1055,23 +1055,55 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm, struct vmcb *vmcb12)
>  		kvm_queue_exception(vcpu, DB_VECTOR);
>  }
>  
> -static void nested_svm_failed_vmrun(struct vcpu_svm *svm, struct vmcb *vmcb12)
> +static void nested_svm_failed_vmrun(struct vcpu_svm *svm, u64 vmcb12_gpa)
>  {
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm_host_map map;
> +	struct vmcb *vmcb12;
> +	int r;
> +
>  	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
>  

Ugh I missed leave_guest_mode() here, which means guest state won't be
cleaned up properly and the triple fault won't be inject correctly if
unmap fails. I re-introduced the bug I fixed earlier in the series :')

Should probably add WARN_ON_ONCE(is_guest_mode()) in
__nested_svm_vmexit() since the caller is expected to
leave_guest_mode().

> +	r = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
> +	if (r) {
> +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> +		return;
> +	}
> +
> +	vmcb12 = map.hva;
>  	vmcb12->control.exit_code = SVM_EXIT_ERR;
>  	vmcb12->control.exit_code_hi = -1u;
>  	vmcb12->control.exit_info_1 = 0;
>  	vmcb12->control.exit_info_2 = 0;
>  	__nested_svm_vmexit(svm, vmcb12);
> +
> +	kvm_vcpu_unmap(vcpu, &map);
> +}
> +
> +static int nested_svm_copy_vmcb12_to_cache(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct kvm_host_map map;
> +	struct vmcb *vmcb12;
> +	int r;
> +
> +	r = kvm_vcpu_map_readonly(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
> +	if (r)
> +		return r;
> +
> +	vmcb12 = map.hva;
> +
> +	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
> +	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> +
> +	kvm_vcpu_unmap(vcpu, &map);
> +	return 0;
>  }
>  
>  int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	int ret;
> -	struct vmcb *vmcb12;
> -	struct kvm_host_map map;
>  	u64 vmcb12_gpa;
>  	struct vmcb *vmcb01 = svm->vmcb01.ptr;
>  
> @@ -1092,22 +1124,17 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  		return ret;
>  	}
>  
> +	if (WARN_ON_ONCE(!svm->nested.initialized))
> +		return -EINVAL;
> +
>  	vmcb12_gpa = svm->vmcb->save.rax;
> -	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
> +	if (nested_svm_copy_vmcb12_to_cache(vcpu, vmcb12_gpa)) {
>  		kvm_inject_gp(vcpu, 0);
>  		return 1;
>  	}
>  
>  	ret = kvm_skip_emulated_instruction(vcpu);
>  
> -	vmcb12 = map.hva;
> -
> -	if (WARN_ON_ONCE(!svm->nested.initialized))
> -		return -EINVAL;
> -
> -	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
> -	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> -
>  	/*
>  	 * Since vmcb01 is not in use, we can use it to store some of the L1
>  	 * state.
> @@ -1128,11 +1155,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  		svm->nmi_l1_to_l2 = false;
>  		svm->soft_int_injected = false;
>  
> -		nested_svm_failed_vmrun(svm, vmcb12);
> +		nested_svm_failed_vmrun(svm, vmcb12_gpa);
>  	}
>  
> -	kvm_vcpu_unmap(vcpu, &map);
> -
>  	return ret;
>  }
>  
> -- 
> 2.52.0.239.gd5f0c6e74e-goog
> 

