Return-Path: <kvm+bounces-39790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2B1A4A7B8
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 02:55:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 178DD3BA60B
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 01:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80E7A15574E;
	Sat,  1 Mar 2025 01:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MfvG3vv/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9F585C5E
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 01:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740794125; cv=none; b=WDemtN7lvgIFPiUFkBTp4ebE+hDigCYlGFYPmGZas3zoBnMbdVrmm4to+7ZF5QtpYQs+AugdGmdvRi9QdSbbBSWzCuNuPfiQJHVnPet1rGMqdxZhLq9salXrbCp8J6ItaXvOXiHTC7FF2bDhAU6JxUdemBbJe/AcM7jaT2sOpKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740794125; c=relaxed/simple;
	bh=agbLwShmsiCBGOcOkro8XyIDN5wz8KMLHL45E7XFHzU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JqEId0U3zaJ4cE6mMUuuMOncqorCYNvsGxaBITsHAX+k3/VmMHSkB/27qPM5cHmoyykbTxmaX8nEZKDkNByg7nnJ/k6BOd8ESOvb07/Yv6MfpRUWQQOnjPGxH2w/txYFCB0h90M53+0kKcQ7WaTSMIJqHnyl5xR6bErR1k35TSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MfvG3vv/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740794122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aAsYMdRkvhEpcyr8RgVQ95Zwb4P2n4C/moQ8o10rw0g=;
	b=MfvG3vv/X6ufIAi3v/PmON/FXVavvKn63aOdN3libX9HAEnDPdC079Db+bA2dRJNtFOblG
	JEczWFgWqLZ8ozWtuaDBc4wgvKVcUyl9ci9kDh58Zh0X0TtGHhtLE48BqipRbXO3nmFGzb
	fKjJRi7eGyjDHY46G2jbqM3U5nI1Sys=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-ekZ0X1wbNKCVimAx4g0Ocg-1; Fri, 28 Feb 2025 20:55:20 -0500
X-MC-Unique: ekZ0X1wbNKCVimAx4g0Ocg-1
X-Mimecast-MFC-AGG-ID: ekZ0X1wbNKCVimAx4g0Ocg_1740794120
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-471f1b00de4so56571771cf.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 17:55:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740794120; x=1741398920;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aAsYMdRkvhEpcyr8RgVQ95Zwb4P2n4C/moQ8o10rw0g=;
        b=InOoVL7eXMZ2Q/6CrWQC9a+d2MQU+YeTPSyfeRfeR7Glh0hXKhm9wuc7wAA0hywKqh
         mpNBZeeoCfTjOngJFKVEf6TBtG4X+EQPNtB0AYsCccV9uKxgO3+Ni+DCyI0rdZh24H75
         5MnaUAEahIbHGRfU8qWnI0eOLpUga7KCyStbTsQ4sPfiHEjbgU9OfDgVtwGXalTnh18W
         svqQ2N4DE2Qax/ViGlHxgRw8FOIgZ9DyFzEDs69mK7JOEMrLO2Gv6/zSclshjbU46u/I
         ujtMqXwi7SiZuEq2g19M2Mv+i8++cHn2FHLhulJig5SF+IxGXrdxyXlz7ERDRebBRodi
         KMLg==
X-Gm-Message-State: AOJu0YzZ0I9dRONMvyLG3Tgn0uJMVUjGb7/SGq5u6bgbkMVZuTiB/RB/
	KHiwNM9BonH8Kc0DOlvZEHgPyziVXQq0ZI+Rel3CTbMOmQBgRF47fgiZr74f+nwQ8YhqzC7QCyV
	AABl0kiYEKJCoXV3IZWxXy0JfbXin6Xea7+ly8KUVpfZCl69Tag==
X-Gm-Gg: ASbGncuga0LmajF4jV8RV8u1vpZiCkk4Htg/UVAE1fXLalE0i3kiRluWSipVpTA2aqv
	vcAhqHvnFha+I2qjdNmCbBWH4PcZ5VFbOm/hJ92sK4DIYUS4wuoD2W7CJB38rAGPBRtuLiHOEYO
	aJgJOcO02nbMMPsaLlCUYjcjZtnsRYkgvkdVhraE5CvEnIvQ4fxrRVmPug9bBn8TtB2OiQ4OFZN
	VQsH9Ezm30u5PR2D/DsYuOzBBNJjampMAqeWRkMLkqPwRpY82wZanl6iHR1qxMg423Y4/GmMMJr
	poWqufQZAUiPgEQ=
X-Received: by 2002:a05:622a:293:b0:472:3f6:92a2 with SMTP id d75a77b69052e-474bc0ee7d8mr88422611cf.38.1740794120279;
        Fri, 28 Feb 2025 17:55:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEaRnryBkVHtHBl06y+ys7QNbTBv5IvHFdAP/T3CqaSIQR1aN3JKp+CLO1jtag75OmShRsKSg==
X-Received: by 2002:a05:622a:293:b0:472:3f6:92a2 with SMTP id d75a77b69052e-474bc0ee7d8mr88422351cf.38.1740794119953;
        Fri, 28 Feb 2025 17:55:19 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47472431449sm31402011cf.77.2025.02.28.17.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 17:55:19 -0800 (PST)
Message-ID: <330b0214680efacf15cf18d70788b9feab2b68b0.camel@redhat.com>
Subject: Re: [RFC PATCH 07/13] KVM: nSVM: Handle INVLPGA interception
 correctly
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2025 20:55:18 -0500
In-Reply-To: <20250205182402.2147495-8-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-8-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> Currently, INVPLGA interception handles it like INVLPG, which flushes
> L1's TLB translations for the address. It was implemented in this way
> because L1 and L2 shared an ASID. Now, L1 and L2 have separate ASIDs. It
> is still harmless to flush L1's translations, but it's only correct
> because all translations are flushed on nested transitions anyway.
> 
> In preparation for stopping unconditional flushes on nested transitions,
> handle INVPLGA interception properly. If L1 specified zero as the ASID,
> this is equivalent to INVLPG, so handle it as such. Otherwise, use
> INVPLGA to flush the translations of the appropriate ASID tracked by
> KVM, if any. Sync the shadow MMU as well, as L1 invalidated L2's
> mappings.
> 
> Opportunistically update svm_flush_tlb_gva() to use
> svm->current_vmcb->asid instead of svm->vmcb->control.asid for
> consistency. The two should always be in sync except when KVM allocates
> a new ASID in pre_svm_run(), and they are shortly brought back in sync
> in svm_vcpu_run(). However, if future changes add more code paths where
> KVM allocates a new ASID, flushing the potentially old ASID in
> svm->vmcb->control.asid would be unnecessary overhead (although probably
> not much different from flushing the newly allocated ASID).
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu/mmu.c          |  5 +++--
>  arch/x86/kvm/svm/svm.c          | 40 ++++++++++++++++++++++++++++++---
>  3 files changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5193c3dfbce15..1e147bb2e560f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2213,6 +2213,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  		       void *insn, int insn_len);
>  void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
>  void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
> +void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +			       u64 addr, unsigned long roots, bool gva_flush);
>  void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  			     u64 addr, unsigned long roots);
>  void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ac133abc9c173..f5e0d2c8f4bbe 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6158,8 +6158,8 @@ static void kvm_mmu_invalidate_addr_in_root(struct kvm_vcpu *vcpu,
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  }
>  
> -static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> -				      u64 addr, unsigned long roots, bool gva_flush)
> +void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +			       u64 addr, unsigned long roots, bool gva_flush)
>  {
>  	int i;
>  
> @@ -6185,6 +6185,7 @@ static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu
>  			kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(__kvm_mmu_invalidate_addr);
>  
>  void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  			     u64 addr, unsigned long roots)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a2d601cd4c283..9e29f87d3bd93 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2483,6 +2483,7 @@ static int clgi_interception(struct kvm_vcpu *vcpu)
>  
>  static int invlpga_interception(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
>  	gva_t gva = kvm_rax_read(vcpu);
>  	u32 asid = kvm_rcx_read(vcpu);
>  
> @@ -2492,8 +2493,41 @@ static int invlpga_interception(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_invlpga(to_svm(vcpu)->vmcb->save.rip, asid, gva);
>  
> -	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
> -	kvm_mmu_invlpg(vcpu, gva);
> +	/*
> +	 * APM is silent about using INVLPGA to flush the host ASID (i.e. 0).
> +	 * Do the logical thing and handle it like INVLPG.
> +	 */
> +	if (asid == 0) {
> +		kvm_mmu_invlpg(vcpu, gva);
> +		return kvm_skip_emulated_instruction(vcpu);
> +	}
> +
> +	/*
> +	 * Check if L1 specified the L2 ASID we are currently tracking. If it
> +	 * isn't, do nothing as we have to handle the TLB flush when switching
> +	 * to the new ASID anyway. APM mentions that INVLPGA is typically only
> +	 * meaningful with shadow paging, so also do nothing if L1 is using
> +	 * nested NPT.
> +	 */
> +	if (!nested_npt_enabled(svm) && asid == svm->nested.last_asid)
> +		invlpga(gva, svm->nested.vmcb02.asid);


Hi, 

IMHO we can't just NOP the INVLPGA because it is not useful in nested NPT case.

If I understand the APM correctly, the CPU will honor the INVLPGA
request, even when NPT is enabled, and so KVM must do this as well.

It is not useful for the hypervisor because it needs GVA, which in case of NPT,
the hypervisor won't usually track, but we can't completely rule out that some
hypervisor uses this in some cases.


Also, there is out of order patch here: last_asid isn't yet declared.
It is added in patch 10.

Best regards,
	Maxim Levitsky


> +
> +	/*
> +	 * If NPT is disabled, sync the shadow page tables as L1 is invalidating
> +	 * mappings for L2. Sync all roots as ASIDs are not tracked in the MMU
> +	 * role.
> +	 *
> +	 * As we are not flushing the current context, skip the gva flush from
> +	 * __kvm_mmu_invalidate_addr(), it would flush the wrong ASID anyway.
> +	 * The correct TLB flush was done above (if needed).
> +	 *
> +	 * This always operates on root_mmu because L1 and L2 share an MMU when
> +	 * NPT is disabled. This can be optimized by invalidating guest roots
> +	 * only.
> +	 */
> +	if (!npt_enabled)
> +		__kvm_mmu_invalidate_addr(vcpu, &vcpu->arch.root_mmu, gva,
> +					  KVM_MMU_ROOTS_ALL, false);
>  
>  	return kvm_skip_emulated_instruction(vcpu);
>  }
> @@ -4017,7 +4051,7 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	invlpga(gva, svm->vmcb->control.asid);
> +	invlpga(gva, svm->current_vmcb->asid);
>  }
>  
>  static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)



