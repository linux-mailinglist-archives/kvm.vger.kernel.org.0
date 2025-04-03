Return-Path: <kvm+bounces-42613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1930A7B02D
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:10:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BE7E17C074
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D029325E457;
	Thu,  3 Apr 2025 20:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A8rQS6v1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1533825DD08
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743711049; cv=none; b=YgF6e1V46JCMJeX3OKE8d3iGvf5oE7tU6EGODwJU5D9GBavoCPe//iPsGb651gDfON979htBJ1DQhvLPwbNox04I6thMcsaRsU4aN4d5U53aC+xEMioqIEks2sYrFeauBOWnMKFf2AWNWmnO9q9Gc39hJDfQFmqUzELobFZS+SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743711049; c=relaxed/simple;
	bh=IAbb+57bvxBTSqct+jicwJiBlS6fZhLGUsf4hfx/jXM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FJK5Ue1XKHsCHtzg6v5CDWoT+/+GtXbaNEt7VEih+ISbI379IpYvNqI/S+KKpHc6sNBzdATiSEABCFoBGsLBtR/kJF3blbmdr85SarBlIfxVzKEg68Fj6lrtFXqhotL2xV5DJGomrChzglxoz1B689zbO7Al/dv37Cg9hLbUL3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A8rQS6v1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743711046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RGv3I+Uf1BgmOqSQxj8McIcEQIndE7P+WntswOEF8vk=;
	b=A8rQS6v1GMYdNUTMI5Vod/NKHks0vCI2DYjzIkZfxyhip2EAaESVabAVdfrcYCDrNmrqKC
	SPfyAT3PwvSVLdIyD9FE142yZEy1GBP8QhCdlShPZtUX4PqHYF2NY4KvoKH6XPJO1DOB2f
	upUPOuCxSjVB0mNTNgAxl75QBrqZM24=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-JJpMRyPpNx-BSD0lcO_8Fg-1; Thu, 03 Apr 2025 16:10:09 -0400
X-MC-Unique: JJpMRyPpNx-BSD0lcO_8Fg-1
X-Mimecast-MFC-AGG-ID: JJpMRyPpNx-BSD0lcO_8Fg_1743711008
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4769a1db721so33082651cf.3
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743711008; x=1744315808;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RGv3I+Uf1BgmOqSQxj8McIcEQIndE7P+WntswOEF8vk=;
        b=cLVtV7bdvAIWELDqYDf3ThA5o2D5mbhJonY4zASleGCw9pAYajXcsVm2I9SODk9lU0
         Go2h42McGWunyhkkjiwUotfHnwiLkXIfjm1HVcEKl3q4omuDX0lUSlJmCcqKB/adJ3PG
         lQ87QKf7+zYxwIcGFdXv2qkZrUrGIdPFJYqLND1Y2Jrs3G9TvjF9sMhzjw3JUo880yIs
         irPmaYQC+XxXVNcr54MweVrql7IY/IhpKkmUPfBMMv4XktsOTEQbB101NpRfLOHlXfi0
         yXNYUO8oVDgD6N6eHZdo4tKUXSkpkJKvrdbF00EOf4kSet7bXQURoGKsJteF8s7z/HoM
         aiqw==
X-Forwarded-Encrypted: i=1; AJvYcCVLX+JZO2XXwnHGYSMeCa2KEfgWW3t3yPuhT9kP5mK+pjBMTRRZbi+ZuA6mNTc36nO/+3o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDeQZSDvq3BO5Mrgu+vmLnHZvlQMSL9m4TBdPZKftVuuOFvQfs
	XsR069Sfqiu9fiwJH2saC57jdzbyr7+OAlMXI7DL/iW5W7wLje3EwRxZ+DoQ6rtYv5y4rsuv54x
	NhUdMk6hUoGpw3whYgSoC+/ZNREa4Twpfn1d/B0d1judPLK8TBg==
X-Gm-Gg: ASbGncsvrIsCnyDM3mOHVcw30uhTJ7hkfvg3ZudxIMezqSN4UgmFMjA5sPRHs9DUYJQ
	7/BaeZ4l1uxJsdWWywrQMspzJnsZsByeraoPtTofDgr02LfJkYkB2sxInrQParVkcvc7/KdI+Zx
	Fgp8er+405hvUuagSE6Jh8dwAjNV8JN5jcZDvfOnVTFUoScGNV8iQtSQxm4bNMQAY3V23h5nevy
	cZ+SZ4hoAYJhsx/SfZsyMvJlSxIiu3bmMF5L77WNNRUlBx/nut/wa5xcWLGeGhPMPjs1/tZ3dmL
	oCXjhp3yAQWQsYw=
X-Received: by 2002:a05:622a:1920:b0:477:6f28:8c16 with SMTP id d75a77b69052e-4792490da45mr12914381cf.6.1743711008623;
        Thu, 03 Apr 2025 13:10:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxK4rvzFyEl6eiIaIgKnQSl586hDylja1va27HaDiyQgv7ChcS37qrANaiPXgjgwx3huqPGg==
X-Received: by 2002:a05:622a:1920:b0:477:6f28:8c16 with SMTP id d75a77b69052e-4792490da45mr12913871cf.6.1743711008200;
        Thu, 03 Apr 2025 13:10:08 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76e7355f9sm116588585a.24.2025.04.03.13.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:10:07 -0700 (PDT)
Message-ID: <a910ebd37e05091ec59ba7e731f10f6f7b9b97bc.camel@redhat.com>
Subject: Re: [RFC PATCH 13/24] KVM: nSVM: Parameterize svm_flush_tlb_asid()
 by is_guest_mode
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:10:06 -0400
In-Reply-To: <20250326193619.3714986-14-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-14-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-26 at 19:36 +0000, Yosry Ahmed wrote:
> svm_flush_tlb_asid() currently operates on the current VMCB. In
> preparation for properly tracking TLB flushes for L1 and L2 ASIDs,
> refactor it to take is_guest_mode and find the proper VMCB. All existing
> callers pass is_guest_mode(vcpu) to maintain existing behavior for now.
> 
> Move the comment about only flushing the current ASID to
> svm_flush_tlb_all(), where it probably should have been anyway, because
> svm_flush_tlb_asid() now flushes a given ASID, not the current ASID.
> 
> Create a svm_flush_tlb_guest() wrapper to use as the flush_tlb_guest()
> callback.
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/svm.c | 39 +++++++++++++++++++++++++--------------
>  1 file changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 865c5ce4fa473..fb6b9f88a1504 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4016,25 +4016,24 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
>  }
>  
> -static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
> +static struct vmcb *svm_get_vmcb(struct vcpu_svm *svm, bool is_guest_mode)
> +{
> +	return is_guest_mode ? svm->nested.vmcb02.ptr : svm->vmcb01.ptr;
> +}

Not sure 100% about this helper, it name might be a bit confusing because
we already have a current vmcb. Maybe add a comment above stating this
this is to get vmcb which might not be currently active?

> +
> +static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu, bool is_guest_mode)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb *vmcb = svm_get_vmcb(svm, is_guest_mode);
>  
>  	/*
>  	 * Unlike VMX, SVM doesn't provide a way to flush only NPT TLB entries.
>  	 * A TLB flush for the current ASID flushes both "host" and "guest" TLB
>  	 * entries, and thus is a superset of Hyper-V's fine grained flushing.
>  	 */
> -	kvm_hv_vcpu_purge_flush_tlb(vcpu, is_guest_mode(vcpu));
> -
> -	/*
> -	 * Flush only the current ASID even if the TLB flush was invoked via
> -	 * kvm_flush_remote_tlbs().  Although flushing remote TLBs requires all
> -	 * ASIDs to be flushed, KVM uses a single ASID for L1 and L2, and
> -	 * unconditionally does a TLB flush on both nested VM-Enter and nested
> -	 * VM-Exit (via kvm_mmu_reset_context()).
> -	 */
> -	vmcb_set_flush_asid(svm->vmcb);
> +	kvm_hv_vcpu_purge_flush_tlb(vcpu, is_guest_mode);
> +	if (vmcb)
> +		vmcb_set_flush_asid(vmcb);
>  }
>  
>  static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> @@ -4050,7 +4049,7 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
>  	if (svm_hv_is_enlightened_tlb_enabled(vcpu) && VALID_PAGE(root_tdp))
>  		hyperv_flush_guest_mapping(root_tdp);
>  
> -	svm_flush_tlb_asid(vcpu);
> +	svm_flush_tlb_asid(vcpu, is_guest_mode(vcpu));
>  }
>  
>  static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
> @@ -4065,7 +4064,14 @@ static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
>  	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
>  		hv_flush_remote_tlbs(vcpu->kvm);
>  
> -	svm_flush_tlb_asid(vcpu);
> +	/*
> +	 * Flush only the current ASID even if the TLB flush was invoked via
> +	 * kvm_flush_remote_tlbs().  Although flushing remote TLBs requires all
> +	 * ASIDs to be flushed, KVM uses a single ASID for L1 and L2, and
> +	 * unconditionally does a TLB flush on both nested VM-Enter and nested
> +	 * VM-Exit (via kvm_mmu_reset_context()).
> +	 */
> +	svm_flush_tlb_asid(vcpu, is_guest_mode(vcpu));
>  }
>  
>  static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
> @@ -4075,6 +4081,11 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>  	invlpga(gva, svm_get_current_asid(svm));
>  }
>  
> +static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
> +{
> +	svm_flush_tlb_asid(vcpu, is_guest_mode(vcpu));
> +}
> +
>  static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -5187,7 +5198,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.flush_tlb_all = svm_flush_tlb_all,
>  	.flush_tlb_current = svm_flush_tlb_current,
>  	.flush_tlb_gva = svm_flush_tlb_gva,
> -	.flush_tlb_guest = svm_flush_tlb_asid,
> +	.flush_tlb_guest = svm_flush_tlb_guest,
>  
>  	.vcpu_pre_run = svm_vcpu_pre_run,
>  	.vcpu_run = svm_vcpu_run,


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky






