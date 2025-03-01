Return-Path: <kvm+bounces-39788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25D6FA4A78A
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 02:38:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5A867AB79D
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 01:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DCED156C69;
	Sat,  1 Mar 2025 01:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ct7rcUPZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE7C22EE4
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 01:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740793064; cv=none; b=rue0nUS7uS5Rc/ZDg68bByRA66T1lhmSJzbT9e1ABAzKExmBxpwfBpau1tEtRcTRxr5m8nuc/pkR/i6qZQvWrqDhNUUhp62G6lZPNlOygpQj0P2VDsXSOQ/nmQQ/CBq3vnTI5paZIxRKoQ5te+cdS6zvXs0oTpyYJugeai/pNCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740793064; c=relaxed/simple;
	bh=qESiWLtNg8pNT3kw9CM9EvlGat+N9UabGQzZ8rlbcZ0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QpyV29pG8zude9KBn/KaSQfCXVjaEzq3fAwqiz+GFkvkjeldaoKwbsvMUZU+FEinLm1d5XwRb6gLSGXydtruIUYJJYllwG1/xSMNiIoWBV3gCkjm2bNN21qQcHhPApNJM2iZwDgst1vP7UY5iS8Fqu4EiWVD2PNBkIbl5ohm5cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ct7rcUPZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740793061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wbjFTBlv9o3OEhDfHME1jza4oVL1Cr86+PPTD5t1xQQ=;
	b=ct7rcUPZm23OmChXYdR0iY6Ii/4u4RHSt2zkRmPVei7nuKiVQEkm3eOeWd7kCXrG8YosZ4
	VwFyZhBRCHjtQDROt3SNk5pEg9HtAwwQ6vzot7wS4RqBz//aS5cv52YlgDUMfATPkVURQR
	otg2hssn1NWJJSr31xSlDis0MY56KSA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-OOCxzdRsOsqxcU9naVvEQw-1; Fri, 28 Feb 2025 20:37:40 -0500
X-MC-Unique: OOCxzdRsOsqxcU9naVvEQw-1
X-Mimecast-MFC-AGG-ID: OOCxzdRsOsqxcU9naVvEQw_1740793059
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e8a0f19ae1so36241716d6.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 17:37:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740793059; x=1741397859;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wbjFTBlv9o3OEhDfHME1jza4oVL1Cr86+PPTD5t1xQQ=;
        b=rSS2CqI623YdVAw2J6Oo5Z0XDkT/K7vqggPuD0KClA3XGbH0u0mB+a4jQ1tiVPbfNg
         DI0c1uVzH0uDPc8tik+lyT+L9yPVVmDFDcBWLvLMT4+dZLRDLajoZkqN85XYW2jStbBN
         4ACH6d9efmr7w1cc3Jys+BK135s9a4nlt7t+YfE8s9/7f+Hxn8g3G7D2lgmMUNwRZb5K
         2CWvzcdAcG2XwK/T8acrOBY4lE4LHNlCOx9ojr05gUed4HIfl2uCgOFvk3Hlu45Y7KRm
         EX7hUW1lgg+vmd/7ts4dO/vuY6eirhucejgGOqeXBmsjoTPHvA7ykRKffVu7oPIBiSax
         GiSA==
X-Gm-Message-State: AOJu0Ywc97np+/NbqspHYqp0dkIhuQHMwuCR1rTF1TKzn73jPfJYQPka
	e/O+t5NQ0cLcpvDRujNfbDuY810Db5ffemBP522+dleOPRfq2C2pxMfORRH/gzoW+E0JBJxrtoG
	wWgBWA6hHIC6XndI3vQOp1Dvf7yUZP8g8Eiu+hVHjn/XvDSuMdB+1hrTuug==
X-Gm-Gg: ASbGncunJejcJMEyxqrE3w1kTKQvXL4iGla7hWcVXIue6jCi5wxAyruiOcj04pQFXUC
	d7TG6EJJR/pAuwdAl8vmGN45PqNjDheyi3aoQ1Rvg4HQh2QcB7OMZSKqxX/Ev20+0CHy/hLHXv6
	B5dgb8DHW7WaaR1TKlSW/jk7MsMJCDJ+YvalVBFHsbxBAcqFjIrqq6ByFPJU/RT9Iq08SkIC6Hx
	Vb7TAkl0h1kwqZFFOf5hVK1jSvFMt4/dRsYwW9pYTNPnCt+dcrjKgR9XqSdf0jqpKYoczrPF1PD
	UUzXQ3QHAIga5q4=
X-Received: by 2002:a05:6214:2aad:b0:6e1:715f:cdf5 with SMTP id 6a1803df08f44-6e8a0d77582mr80862726d6.15.1740793059326;
        Fri, 28 Feb 2025 17:37:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/lGF35E66itIC4CFSpT1I377Q3SynkjXqLrgBB1/PVXtshkzQ3dnZsGHaeAFgJuaumO6MxQ==
X-Received: by 2002:a05:6214:2aad:b0:6e1:715f:cdf5 with SMTP id 6a1803df08f44-6e8a0d77582mr80862566d6.15.1740793058991;
        Fri, 28 Feb 2025 17:37:38 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8976347acsm28205876d6.4.2025.02.28.17.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 17:37:38 -0800 (PST)
Message-ID: <974185d11c41c8019036e153e95a96e0c2712d6c.camel@redhat.com>
Subject: Re: [RFC PATCH 04/13] KVM: SVM: Introduce helpers for updating
 TLB_CONTROL
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2025 20:37:37 -0500
In-Reply-To: <20250205182402.2147495-5-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-5-yosry.ahmed@linux.dev>
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
> Introduce helpers for updating TLB_CONTROL in the VMCB instead of
> directly setting it. Two helpers are introduced:
> 
> - svm_add_tlb_ctl_flush(): Combines a new TLB_CONTROL value with the
>   existing one.
> 
> - svm_clear_tlb_ctl_flush(): Clears the TLB_CONTROL field.
> 
> The goal is to prevent overwriting a TLB_CONTROL value with something
> that results in less TLB entries being flushed. This does not currently
> happen as KVM only sets TLB_CONTROL_FLUSH_ASID when servicing a flush
> request, and TLB_CONTROL_FLUSH_ALL_ASID when allocating a new ASID. The
> latter always happens after the former so no unsafe overwrite happens.
> 
> However, future changes may result in subtle bugs where the TLB_CONTROL
> field is incorrectly overwritten. The new helpers prevent that.
> 
> A separate helper is used for clearing the TLB flush because it is
> semantically different. In this case, KVM knowingly ignores the existing
> value of TLB_CONTROL. Also, although svm_add_tlb_ctl_flush() would just
> work for TLB_CONTROL_DO_NOTHING, the logic becomes inconsistent (use the
> biggest hammer unless no hammer at all is requested).
> 
> Opportunistically move the TLB_CONTROL_* definitions to
> arch/x86/kvm/svm/svm.h as they are not used outside of
> arch/x86/kvm/svm/.
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/include/asm/svm.h |  6 ------
>  arch/x86/kvm/svm/nested.c  |  2 +-
>  arch/x86/kvm/svm/sev.c     |  2 +-
>  arch/x86/kvm/svm/svm.c     |  6 +++---
>  arch/x86/kvm/svm/svm.h     | 29 +++++++++++++++++++++++++++++
>  5 files changed, 34 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 2b59b9951c90e..e6bccf8f90982 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -169,12 +169,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  	};
>  };
>  
> -
> -#define TLB_CONTROL_DO_NOTHING 0
> -#define TLB_CONTROL_FLUSH_ALL_ASID 1
> -#define TLB_CONTROL_FLUSH_ASID 3
> -#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
> -
>  #define V_TPR_MASK 0x0f
>  
>  #define V_IRQ_SHIFT 8
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 2eba36af44f22..0e9b0592c1f83 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -690,7 +690,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	/* Done at vmrun: asid.  */
>  
>  	/* Also overwritten later if necessary.  */
> -	vmcb02->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
> +	svm_clear_tlb_ctl_flush(vmcb02);
>  
>  	/* nested_cr3.  */
>  	if (nested_npt_enabled(svm))
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b0adfd0537d00..3af296d6c04f6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3481,7 +3481,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>  		return;
>  
>  	sd->sev_vmcbs[asid] = svm->vmcb;
> -	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
> +	svm_add_tlb_ctl_flush(svm->vmcb, TLB_CONTROL_FLUSH_ASID);
>  	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2108b48ba4959..a2d601cd4c283 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1985,7 +1985,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
>  	if (sd->next_asid > sd->max_asid) {
>  		++sd->asid_generation;
>  		sd->next_asid = sd->min_asid;
> -		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
> +		svm_add_tlb_ctl_flush(svm->vmcb, TLB_CONTROL_FLUSH_ALL_ASID);
>  		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
>  	}
>  
> @@ -3974,7 +3974,7 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu, struct kvm_vmcb_info *vmcb
>  	 * VM-Exit (via kvm_mmu_reset_context()).
>  	 */
>  	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
> -		vmcb->ptr->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
> +		svm_add_tlb_ctl_flush(vmcb->ptr, TLB_CONTROL_FLUSH_ASID);
>  	else
>  		vmcb->asid_generation--;
>  }
> @@ -4317,7 +4317,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>  		svm->nested.nested_run_pending = 0;
>  	}
>  
> -	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
> +	svm_clear_tlb_ctl_flush(svm->vmcb);
>  	vmcb_mark_all_clean(svm->vmcb);
>  
>  	/* if exit due to PF check for async PF */
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index ebbb0b1a64676..6a73d6ed1e428 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -611,6 +611,35 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
>  void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
>  				     int trig_mode, int vec);
>  
> +#define TLB_CONTROL_DO_NOTHING 0
> +#define TLB_CONTROL_FLUSH_ALL_ASID 1
> +#define TLB_CONTROL_FLUSH_ASID 3
> +#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
> +
> +/*
> + * Clearing TLB flushes is done separately because combining
> + * TLB_CONTROL_DO_NOTHING with others is counter-intuitive.
> + */
> +static inline void svm_add_tlb_ctl_flush(struct vmcb *vmcb, u8 tlb_ctl)
> +{
> +	if (WARN_ON_ONCE(tlb_ctl == TLB_CONTROL_DO_NOTHING))
> +		return;
> +
> +	/*
> +	 * Apply the least targeted (most inclusive) TLB flush. Apart from
> +	 * TLB_CONTROL_DO_NOTHING, lower values of tlb_ctl are less targeted.
> +	 */
> +	if (vmcb->control.tlb_ctl == TLB_CONTROL_DO_NOTHING)
> +		vmcb->control.tlb_ctl = tlb_ctl;
> +	else
> +		vmcb->control.tlb_ctl = min(vmcb->control.tlb_ctl, tlb_ctl);
> +}
> +
> +static inline void svm_clear_tlb_ctl_flush(struct vmcb *vmcb)
> +{
> +	vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
> +}
> +
>  /* nested.c */
>  
>  #define NESTED_EXIT_HOST	0	/* Exit handled on host level */


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



