Return-Path: <kvm+bounces-67275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 96104D000ED
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 21:50:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 83416302628E
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 20:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDED3314C5;
	Wed,  7 Jan 2026 20:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lyELzdEi"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04ECA23C8A0
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 20:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767818965; cv=none; b=VBFhs3kEl0uDfgp/y294CeV1/HuCUYsCmlvlnme5IuWWl6/PJlzzqMR4zZxNg10syAbYN9rWRrZGJOlQ2eGTPdVhswxkHBL30QMfR/ASpBoEGgb0/CYpIXgnVf9uetdJFHa+txiBFAptMGuUh5JyTmdPUIHtewKuU6avrn5WAy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767818965; c=relaxed/simple;
	bh=GXjVef8iYj8SPU1MD7qDLXDRuZIS8BdiIZxLYn52WFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRIBdd2F5RxLaAfG9LE3YP+r3Cl7f0Kx+VAMoQpOZ9V+iiGN1trOhIMjlOWaHZtcuUP3z8fF/b1fxaFFsLIth5RQq0YYuCIypHsqmNBf+1Us+PNUCQDJM4EWnxg1Vto16E1zNsxZaInN6rFOwqg9xfbcgoYTc5RYoHrv4k/AroA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lyELzdEi; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 Jan 2026 20:49:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767818962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dKk/h08jQcgbAcD4A8zVbjejzNtuw5vq6KVHl9BuMH4=;
	b=lyELzdEiX6fDGWmGp7BchWynACgO4uA4+u6u8Q8nrVEcblt0p7VJqkby20ZwGYNNRFVj0Z
	3qQoVCuut7lmLgfAJGaI3JFrF4ovcJGYD6tpj+CmYSY1Nv68NMljlbBghLbmc+TzCF8fXr
	6skggFzM+rVhxrhjoRHcrUP+liUYnn0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kevin Cheng <chengkev@google.com>
Subject: Re: [PATCH] KVM: x86: Disallow setting CPUID and/or feature MSRs if
 L2 is active
Message-ID: <ttwq52yzpaymiygr3qgq3cmpghsakb4zdm6yf7qmp5dvvmylar@6ymzjweesi2x>
References: <20251230205641.4092235-1-seanjc@google.com>
 <iwe37tgg2nc2vc5shdlh3zhs4t3mxmuknf4uo3n3p7mz3o5qdn@sxjo33ussf2s>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <iwe37tgg2nc2vc5shdlh3zhs4t3mxmuknf4uo3n3p7mz3o5qdn@sxjo33ussf2s>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 07, 2026 at 08:47:02PM +0000, Yosry Ahmed wrote:
> On Tue, Dec 30, 2025 at 12:56:41PM -0800, Sean Christopherson wrote:
> > Extend KVM's restriction on CPUID and feature MSR changes to disallow
> > updates while L2 is active in addition to rejecting updates after the vCPU
> > has run at least once.  Like post-run vCPU model updates, attempting to
> > react to model changes while L2 is active is practically infeasible, e.g.
> > KVM would need to do _something_ in response to impossible situations where
> > userspace has a removed a feature that was consumed as parted of nested
> > VM-Enter.
> 
> Another reason why I think this may be needed, but I am not sure:
> 
> If kvm_vcpu_after_set_cpuid() is executed while L2 is active,
> KVM_REQ_RECALC_INTERCEPTS will cause
> svm_recalc_intercepts()->svm_recalc_instruction_intercepts() in the
> context of L2. While the svm_clr_intercept() and svm_set_intercept()
> calls explicitly modify vmcb01, we set and clear
> VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK in svm->vmcb->control.virt_ext. So
> this will set/clear the bit in vmcb02.
> 
> I think this is a bug, because we could end up setting
> VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK when we shouldn't (e.g. L1 doesn't set
> in vmcb12, or the X86_FEATURE_V_VMSAVE_VMLOAD is not exposed to L1).
> 
> Actually as I am typing this, I believe a separate fix for this is
> needed. We should be probably setting/clearing
> VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK on svm->vmcb01.control.
> 
> Did I miss something?

If the analysis above is correct, then a separate fix is indeed required
because we can end up in the same situation from
kvm_vm_ioctl_set_msr_filter() -> KVM_REQ_RECALC_INTERCEPTS.

