Return-Path: <kvm+bounces-49966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83A06AE0438
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 13:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41DF21897C9C
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 11:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D4922DFA5;
	Thu, 19 Jun 2025 11:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sAQ/3Twk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4864921FF31;
	Thu, 19 Jun 2025 11:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750333548; cv=none; b=LugsCo/TaVVqrPCS8kIAtJM2oD4vQpxwkonrZd4MXxGxGHoPK5ENYE/cAjWLd6aJ3D3cvElht2LopNfF80/X+5UpZwDrFNLBdmaPOXthuAf+CTApOZg7MdAMUdzXPVK0NU7ouogzuKgVVNWbMvTPqZhFFjVDiAOMJqB2s7FhgEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750333548; c=relaxed/simple;
	bh=vHD3lkaGKBaHMp6CdM1wZKNCsSPyM5DrFzrbeCyGBAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b3iZUGqImRA0KJyG2SPO7VB8uEahqGHe+ABRKjzyCMpr1lcyT/Sbh52gSvrS1VmGuErtcc8nUkvgdjjqrL0xgIDIr8OVjEj6LsVAACR9zXDzSuc8vqZgKfS+VngqZH8L4m8E6n2gsmg8exQvT+k4+ebGFroKhY7KiMqB1zjdmpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sAQ/3Twk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D00C4CEEA;
	Thu, 19 Jun 2025 11:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750333547;
	bh=vHD3lkaGKBaHMp6CdM1wZKNCsSPyM5DrFzrbeCyGBAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sAQ/3TwkHh4tQny7cI0HaO5x3reXpZGwght1TNFGLHkVqT2VcLfQwYoafTXZdKJ8E
	 pkEwQMfdQXLe9JopRJuwqPlDxDGVzpMStLRBs+PzCYRKs2iR7Tg48zGsuYtVaR1XMK
	 P/U2Rohl3rmIQPiwEa70bQ3kqvJIz9Xbg8QHgFWkwfXfP1N8Cutc0AHM/HrVFk2qYD
	 LQ5UZeix+K8IGaOplmtbU8EyaB2TDRexl+WovO2T/vvpbwxuxsvsESbp5bDJSesFrT
	 9RgAJDhuRJxatju67tTg932hwF/eHBvcS+QL/D3qKE0lA7w1iyk458gB3R9tpDEqNn
	 HwWiUp9bNwWyg==
Date: Thu, 19 Jun 2025 17:01:30 +0530
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
Subject: Re: [PATCH v3 17/62] KVM: SVM: Add enable_ipiv param, never set
 IsRunning if disabled
Message-ID: <2eqjnjnszlmhlnvw6kcve4exjnpy7skguypwtmxutb2gecs3an@gcou53thsqww>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-19-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611224604.313496-19-seanjc@google.com>

On Wed, Jun 11, 2025 at 03:45:20PM -0700, Sean Christopherson wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Let userspace "disable" IPI virtualization for AVIC via the enable_ipiv
> module param, by never setting IsRunning.  SVM doesn't provide a way to
> disable IPI virtualization in hardware, but by ensuring CPUs never see
> IsRunning=1, every IPI in the guest (except for self-IPIs) will generate a
> VM-Exit.

I think this is good to have regardless of the erratum. Not sure about VMX,
but does it make sense to intercept writes to the self-ipi MSR as well?

> 
> To avoid setting the real IsRunning bit, while still allowing KVM to use
> each vCPU's entry to update GA log entries, simply maintain a shadow of
> the entry, without propagating IsRunning updates to the real table when
> IPI virtualization is disabled.
> 
> Providing a way to effectively disable IPI virtualization will allow KVM
> to safely enable AVIC on hardware that is susceptible to erratum #1235,
> which causes hardware to sometimes fail to detect that the IsRunning bit
> has been cleared by software.
> 
> Note, the table _must_ be fully populated, as broadcast IPIs skip invalid
> entries, i.e. won't generate VM-Exit if every entry is invalid, and so
> simply pointing the VMCB at a common dummy table won't work.
> 
> Alternatively, KVM could allocate a shadow of the entire table, but that'd
> be a waste of 4KiB since the per-vCPU entry doesn't actually consume an
> additional 8 bytes of memory (vCPU structures are large enough that they
> are backed by order-N pages).
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> [sean: keep "entry" variables, reuse enable_ipiv, split from erratum]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 32 ++++++++++++++++++++++++++------
>  arch/x86/kvm/svm/svm.c  |  2 ++
>  arch/x86/kvm/svm/svm.h  |  8 ++++++++
>  3 files changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 0c0be274d29e..48c737e1200a 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -292,6 +292,13 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	/* Setting AVIC backing page address in the phy APIC ID table */
>  	new_entry = avic_get_backing_page_address(svm) |
>  		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
> +	svm->avic_physical_id_entry = new_entry;
> +
> +	/*
> +	 * Initialize the real table, as vCPUs must have a valid entry in order
> +	 * for broadcast IPIs to function correctly (broadcast IPIs ignore
> +	 * invalid entries, i.e. aren't guaranteed to generate a VM-Exit).
> +	 */
>  	WRITE_ONCE(kvm_svm->avic_physical_id_table[id], new_entry);
>  
>  	return 0;
> @@ -769,8 +776,6 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
>  			   struct amd_iommu_pi_data *pi)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
> -	struct kvm *kvm = vcpu->kvm;
> -	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
>  	unsigned long flags;
>  	u64 entry;
>  
> @@ -788,7 +793,7 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
>  	 * will update the pCPU info when the vCPU awkened and/or scheduled in.
>  	 * See also avic_vcpu_load().
>  	 */
> -	entry = READ_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id]);
> +	entry = svm->avic_physical_id_entry;
>  	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
>  		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
>  				    true, pi->ir_data);
> @@ -998,14 +1003,26 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	 */
>  	spin_lock_irqsave(&svm->ir_list_lock, flags);
>  
> -	entry = READ_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id]);
> +	entry = svm->avic_physical_id_entry;
>  	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
>  
>  	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
>  	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
>  	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
>  
> +	svm->avic_physical_id_entry = entry;
> +
> +	/*
> +	 * If IPI virtualization is disabled, clear IsRunning when updating the
> +	 * actual Physical ID table, so that the CPU never sees IsRunning=1.
> +	 * Keep the APIC ID up-to-date in the entry to minimize the chances of
> +	 * things going sideways if hardware peeks at the ID.
> +	 */
> +	if (!enable_ipiv)
> +		entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
> +
>  	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
> +
>  	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
>  
>  	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
> @@ -1030,7 +1047,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>  	 * can't be scheduled out and thus avic_vcpu_{put,load}() can't run
>  	 * recursively.
>  	 */
> -	entry = READ_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id]);
> +	entry = svm->avic_physical_id_entry;
>  
>  	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
>  	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
> @@ -1049,7 +1066,10 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>  	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
>  
>  	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
> -	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
> +	svm->avic_physical_id_entry = entry;
> +
> +	if (enable_ipiv)
> +		WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);

If enable_ipiv is false, then isRunning bit will never be set and we 
would have bailed out earlier. So, the check for enable_ipiv can be 
dropped here (or converted into an assert).

- Naveen


