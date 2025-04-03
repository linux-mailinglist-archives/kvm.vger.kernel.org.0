Return-Path: <kvm+bounces-42599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB06A7AFFC
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:05:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EB9C17EFE8
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848A71C84AB;
	Thu,  3 Apr 2025 20:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BFTpMUnR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DB91D7E26
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710442; cv=none; b=kC3BjA57PKw6QlVwh0xGSH2wJwO8Gth7UDTfBbJnEuH68safgFxJXJoV3ylsHenwNiWxP8jYRQPDYZGLzKVCx8Kho3LcBFyVcThMOMrL78/skui8IU4HA6msyC1etG7xeBYriGpWXYIh9HAY+jKmEcIYCaFeVUYGTfEORRu0Mj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710442; c=relaxed/simple;
	bh=/myFRG/nsVfvxlwyn4haCTUVlcewocEJodVCFIfmHas=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nVu1ibYW28m0i6rVwlk4iAIpbAXhoGOGxaGPAbgjT038wGdXAMu9SGAkTgY/Ek9qC01V4JcgzBro/TD0MtNUL3xjEE/MNJX1oZuLpzIgc5L9TBi0oq15RGGb6VmJyzrJ+z0uR+b3bVMxYdHvGQQSZKAMNpg/OPNpRC6IGC0SR/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BFTpMUnR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743710439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D3jepgq6mpSu+t7xHDXlZ7+DEihAAmM7cFMk5sO7ptU=;
	b=BFTpMUnRg4J8mXgrIFojwbz3Yy5stjgMIZRmXn2oIqKqRAUOxvUfF63oJe6wDEeJNFX5Jd
	77V7fWeZZXIuT8LKAfs1d3sBN2ufbP4Fv0qljkhyjY7lfipTQMrcANwPm4AVTx5hCVXmXj
	Az62YxD+OKnNQZvrSb3jFUa+mON+PWo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-PqzxomUsPHuBwWXP9B8bKw-1; Thu, 03 Apr 2025 16:00:37 -0400
X-MC-Unique: PqzxomUsPHuBwWXP9B8bKw-1
X-Mimecast-MFC-AGG-ID: PqzxomUsPHuBwWXP9B8bKw_1743710437
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6e8feea216aso45920026d6.0
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743710437; x=1744315237;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D3jepgq6mpSu+t7xHDXlZ7+DEihAAmM7cFMk5sO7ptU=;
        b=AsaBHk4uyLTUstuNaEqRFsvpBUzUcSpI+sKRfOO6wX8JadQZLwpDPbN/HizHkKgqa8
         TnjlD9QKsd+WBmh4BlptVufRSuElTz6biNqxmoYBpEJOwZ62NXhuSFPDlbnc23XOjM9f
         VOTdA9qaI+CP+mBDRScvDNbsR/DAjAGUsgYO65ArEwgU84Qexi0RBJDChdYPcD9rjJii
         cMwmzhRy6lCzEi/uG1epjG+lx9BYinaJMuNnPM3HjAWFdoU4LaREixaNCH+1jpvwS1zX
         sVtk1OSMkV5urThlH8p+Md9uIHInWR6cD0R4t8XtPaxArXhveKp9jdKlxRgXnNpPjVII
         h+AA==
X-Forwarded-Encrypted: i=1; AJvYcCXMJ9ZaKY+ZpUAAIVLFSy57bf++/PFmhrvSkdiWJeHi68HU84XdMSZ3026ymlHd+XU8u+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj/AQYw1NfmWtwjVGJBm4Yy0/gVxzlwVoSam6FHO74coaz0Sue
	IkDf7WGGHSmzlGIqxu9HF/M2hzjV8GBcFgGB3nCxB3UP62Esemuxouq9jyORS2clFJGDOMKf+Dg
	nEUv7lYjBeE4v5+TFT4peSJz8l7kMijzXTFRSCJPC6iNKObZoCLMDVvRT4A==
X-Gm-Gg: ASbGncs5rIrKEKNX1RWMHFpBxeuaT6GVUUMPlPLy50rsQTIwISwqkHJD9FRMScx9b/J
	O66201JFL+KCCJfqSFKLOxwbF6H14Ym5chjmMdqnecj+kd2W15SaKyO5Rn2RY2DT4P+W1FhDRZ7
	OqRksR64rRihHq9/NXv66EqrPGL2rhbSMEB4cofo3yLvCs3d+58wsqKh4/mer3RcrsUOMa4L4AN
	7HXcUrmSt04HT4OrKuIiY0tMvtgA4EFMfXWrQizt0vjD+uDNSe1QAquTD7+K78FEUN/Nz0wZKAv
	DOssCiPw2nYSnxA=
X-Received: by 2002:ad4:5946:0:b0:6e4:3478:8ea7 with SMTP id 6a1803df08f44-6efec7c5883mr9360986d6.4.1743710436955;
        Thu, 03 Apr 2025 13:00:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHhxVlTI5ZtwILKtPmNpkeVHykTY5ZSMDq9uRW77B59bcLV+ibcnF+bnMcoEIze83EEiT0Hmg==
X-Received: by 2002:ad4:5946:0:b0:6e4:3478:8ea7 with SMTP id 6a1803df08f44-6efec7c5883mr9360516d6.4.1743710436562;
        Thu, 03 Apr 2025 13:00:36 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ef0f150213sm11211296d6.116.2025.04.03.13.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:00:36 -0700 (PDT)
Message-ID: <2b040c2922dae99b42db7cc0bf5cc070607c3464.camel@redhat.com>
Subject: Re: [RFC PATCH 03/24] KVM: SVM: Add helpers to set/clear ASID flush
 in VMCB
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:00:35 -0400
In-Reply-To: <20250326193619.3714986-4-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-4-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-26 at 19:35 +0000, Yosry Ahmed wrote:
> Incoming changes will add more code paths that set tlb_ctl to
> TLB_CONTROL_FLUSH_ASID, and will eliminate the use of
> TLB_CONTROL_FLUSH_ALL_ASID except as fallback when FLUSHBYASID is not
> available. Introduce set/clear helpers to set tlb_ctl to
> TLB_CONTROL_FLUSH_ASID or TLB_CONTROL_DO_NOTHING.
> 
> Opportunistically move the TLB_CONTROL_* definitions to
> arch/x86/kvm/svm/svm.h as they are not used outside of arch/x86/kvm/svm/.

Same microscopic nitpick as in previous patch :) 
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/include/asm/svm.h |  5 -----
>  arch/x86/kvm/svm/nested.c  |  2 +-
>  arch/x86/kvm/svm/sev.c     |  2 +-
>  arch/x86/kvm/svm/svm.c     |  4 ++--
>  arch/x86/kvm/svm/svm.h     | 15 +++++++++++++++
>  5 files changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 9b7fa99ae9513..a97da63562eb3 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -171,11 +171,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  };
>  
>  
> -#define TLB_CONTROL_DO_NOTHING 0
> -#define TLB_CONTROL_FLUSH_ALL_ASID 1
> -#define TLB_CONTROL_FLUSH_ASID 3
> -#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
> -
>  #define V_TPR_MASK 0x0f
>  
>  #define V_IRQ_SHIFT 8
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 834b67672d50f..11b02a0340d9e 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -681,7 +681,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	/* Done at vmrun: asid.  */
>  
>  	/* Also overwritten later if necessary.  */
> -	vmcb02->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
> +	vmcb_clr_flush_asid(vmcb02);
>  
>  	/* nested_cr3.  */
>  	if (nested_npt_enabled(svm))
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0bc708ee27887..d613f81addf1c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3479,7 +3479,7 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
>  		return 0;
>  
>  	sd->sev_vmcbs[asid] = svm->vmcb;
> -	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
> +	vmcb_set_flush_asid(svm->vmcb);
>  	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 28a6d2c0f250f..0e302ae9a8435 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4006,7 +4006,7 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
>  	 * VM-Exit (via kvm_mmu_reset_context()).
>  	 */
>  	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
> -		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
> +		vmcb_set_flush_asid(svm->vmcb);
>  	else
>  		svm->current_vmcb->asid_generation--;
>  }
> @@ -4373,7 +4373,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>  		svm->nested.nested_run_pending = 0;
>  	}
>  
> -	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
> +	vmcb_clr_flush_asid(svm->vmcb);
>  	vmcb_mark_all_clean(svm->vmcb);
>  
>  	/* if exit due to PF check for async PF */
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d4490eaed55dd..d2c49cbfbf1ca 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -409,6 +409,21 @@ static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
>          return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
>  }
>  
> +#define TLB_CONTROL_DO_NOTHING 0
> +#define TLB_CONTROL_FLUSH_ALL_ASID 1
> +#define TLB_CONTROL_FLUSH_ASID 3
> +#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
> +
> +static inline void vmcb_set_flush_asid(struct vmcb *vmcb)
> +{
> +	vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
> +}
> +
> +static inline void vmcb_clr_flush_asid(struct vmcb *vmcb)
> +{
> +	vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
> +}
> +
>  static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
>  {
>  	return container_of(vcpu, struct vcpu_svm, vcpu);


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




