Return-Path: <kvm+bounces-41311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F285BA66042
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 22:12:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54E2F16DF37
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 21:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 257CB1F6664;
	Mon, 17 Mar 2025 21:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ee7LXzJ+"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06FB7E9
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742245917; cv=none; b=vFzHtaFttY/yCmX673gK2ntGvKc+ulTbRlvDuMl/885X7qdgCsGvsJGhEoJFNsLc1wOx5ySQMPzA0YUVQhOD1Z2ZkPAp0/ISvqggSLorSwQxWOjZUJrWbEN7kcALJX2U3rscskdCKVFPkWlRsO4fOoXZpXDS0GWlBRs5QWawi6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742245917; c=relaxed/simple;
	bh=Q44OiKPmtCXgGHbf4MCJCUBX1K59+ZC7S1QYVgcaWBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lh0VwnF/HViNmD81PGHtRxWhdYIrw7KuELD4Q6OPTk3yA0EBSt+u5uIU+60PtZ/POWRhN+u8z/kwiGWOkHZdorapf2Dg8OuHRubxnmr9K6xMyQh7rioIefyXYa5QfsR7xrTWfGEiMg3k0ioeePSYi3WPXrzavzg9BbIzu8OnmY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ee7LXzJ+; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 17 Mar 2025 21:11:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742245910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0U39mg1m03nP3wbLf9xV2iS796N9j66PGE+5QWYWutw=;
	b=ee7LXzJ+86r2fS7arMi0dkwCzskYbLNWx6Vuokox7Bzu1tNcGNEOnZGvrAicSA+wv6v554
	8c9+aZSlwYKkP00O1OFArFG2Ns8Zjm/FXbZu3XxhwIGlcXFy7LPJGX35GM0a57TivXKOoW
	U1niGqWu+JR24ufZk++UxpWL6OjC8B0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] KVM: SVM: Use a single ASID per VM
Message-ID: <Z9iQEV9SQYjtLT8V@google.com>
References: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
 <20250313215540.4171762-7-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313215540.4171762-7-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 13, 2025 at 09:55:39PM +0000, Yosry Ahmed wrote:
> The ASID generation and dynamic ASID allocation logic is now only used
> by initialization the generation to 0 to trigger a new ASID allocation
> per-vCPU on the first VMRUN, so the ASID is more-or-less static
> per-vCPU.
> 
> Moreover, having a unique ASID per-vCPU is not required. ASIDs are local
> to each physical CPU, and the ASID is flushed when a vCPU is migrated to
> a new physical CPU anyway. SEV VMs have been using a single ASID per VM
> already for other reasons.
> 
> Use a static ASID per VM and drop the dynamic ASID allocation logic. The
> ASID is allocated during vCPU reset (SEV allocates its own ASID), and
> the ASID is always flushed on first use in case it was used by another
> VM previously.
> 
> On VMRUN, WARN if the ASID in the VMCB does not match the VM's ASID, and
> update it accordingly. Also, flush the ASID on every VMRUN if the VM
> failed to allocate a unique ASID. This would probably wreck performance
> if it happens, but it should be an edge case as most AMD CPUs have over
> 32k ASIDs.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
[..]
> @@ -3622,7 +3613,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  
>  static int pre_svm_run(struct kvm_vcpu *vcpu)
>  {
> -	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
> +	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
>  	/*
> @@ -3639,9 +3630,15 @@ static int pre_svm_run(struct kvm_vcpu *vcpu)
>  	if (sev_guest(vcpu->kvm))
>  		return pre_sev_run(svm, vcpu->cpu);
>  
> -	/* FIXME: handle wraparound of asid_generation */
> -	if (svm->current_vmcb->asid_generation != sd->asid_generation)
> -		new_asid(svm, sd);
> +	/* Flush the ASID on every VMRUN if kvm_svm->asid allocation failed */
> +	if (unlikely(!kvm_svm->asid))
> +		svm_vmcb_set_flush_asid(svm->vmcb);

This is wrong. I thought we can handle ASID allocation failures by just
reusing ASID=0 and flushing it on every VMRUN, but using ASID=0 is
illegal according to the APM. Also, in this case we also need to flush
the ASID on every VM-exit, which I failed to do here.

There are two ways to handle running out of ASIDs:

(a) Failing to create the VM. This will impose a virtual limit on the
number of VMs that can be run concurrently. The number of ASIDs was
quite high on the CPUs I checked (2^15 IIRC), so it's probably not
an issue, but I am not sure if this is considered breaking userspace.

(b) Designating a specific ASID value as the "fallback ASID". This value
would be used by any VMs created after running out of ASIDs, and we
flush it on every VMRUN, similar to what I am trying to do here for
ASID=0.

Any thoughts on which way we should take? (a) is simpler if we can get
away with it and all AMD CPUs have a sufficiently large number of ASIDs.

