Return-Path: <kvm+bounces-42607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2275EA7B01F
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48874175183
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34FD25D21F;
	Thu,  3 Apr 2025 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RypxOL5+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0D6253B59
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710977; cv=none; b=q4pTPH67Reg1RE7mzufOnDQe0SKgtzAkYTR4Fa3sCkI2mBuYeZj3F4H/xWXMrZnXZ8edwvNcaKIvlcQ8KlaSqKkcCYCrtMUo2WefXTK2XJup88uuqbdjVmlAnQbHuGVK2KlIo/7KChNXvXK6Q6SsKIxiUexLSzeoA8D2DOIitIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710977; c=relaxed/simple;
	bh=VM/LZ2Hify8LhO6mOdJAAEZTRv8bASm7Uv+aSgyzxNc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a1xIVhxanJK+lytToGX8QTcjjN98XgX4YlUm4jYUqi6AiSSf886ZH/Omam2pxO9SR9gn8ZN0XDNXJ5Cta8QiR3C/0BffyZCf1yp58gouDsu06TPW0Ny25bp6T8EL92Akr2aVEErrNzp+4ahLz4f1VDH3lY28iMLdEht4V/d82W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RypxOL5+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743710974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hHkPg4f2KhDyPjkAa0vYH0z+cU0CoktXMmBUTSvvlNg=;
	b=RypxOL5+pztQpibLof6SFAPxXRol/nifkItcdMw+HJuQY7+P0xwl0KIxR+xSFr37aQbkW9
	lng99/lCtc+xd1klVk/1wSRkJIkwYd/rKD7JMj/SkQDEUa3uyT0CTwHJiI7+Qhe2ie1Psu
	S/ODbPr/leIiYsjmoARod+Hyj5L+tTA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-IYNKEV-1OoaYdOKE_Er-5Q-1; Thu, 03 Apr 2025 16:09:33 -0400
X-MC-Unique: IYNKEV-1OoaYdOKE_Er-5Q-1
X-Mimecast-MFC-AGG-ID: IYNKEV-1OoaYdOKE_Er-5Q_1743710972
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4767e6b4596so21432791cf.2
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743710972; x=1744315772;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hHkPg4f2KhDyPjkAa0vYH0z+cU0CoktXMmBUTSvvlNg=;
        b=MtfwTn/IzsL1DYMsFeu9A6AiU/9IGpBfEb99t4NNPA+Kt25XX5hqg7sDQhEGOQVQf8
         pibqUQy5PPDabqXTJFPOabwKWoXYpHWRzCtk5IrqO5osI4ZJpgD5+W7joW3szAVikI0P
         FkOabZn/biV49P6RM7hiQGTwrPZxJiTCt2EXVTHWpcmgTZhVmWZCzEJVJO/ZgH5Xtv8L
         k/asKMS+zzeFBbOduHo6RLupXRzzTQbwP1YyWMfP1E7z4R7Zq9MskPM5Sg6YKP6AJdbE
         VRHKUhglBjSkFu24iJfAeqKB4F03llf3MZDNyD6eulB+cWAAONRo4zlw8YdLL0ETw2a6
         Yc6w==
X-Forwarded-Encrypted: i=1; AJvYcCVlmA0QLUO0fG+baOEEVs0KrJP8p470d832sMUXY2NYoQZ/azRTfPekp2miuyFJ3iUdWCY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjYADStx0mIClA6g/u61VDlklKdxbxpPu1cTiwKYKibqGgdwCj
	8m9cyPkbeRj24tGmkpsg0Wgjq8HMCYQYPX+2W7aaXRgtcD2eLFe5/czc3i8mQNS/WFATfwlep6Q
	j3rv1hW/XH9L6VDF7S3cMRXb0zcwG4kHPOA7uvKydS97RrLu0pFiGDPQQJA==
X-Gm-Gg: ASbGncuOeouCrXQQW+pkxNx7keXBl4wIC5qkqrIGpHFCVt8t5YvCJEzFlgNEceTewAi
	O2KDahnMaZF0IB1ghBtMnqIXn8zTZOKBGyfiPvWPs3e2h9nUufZ0uy+N6Hy6DEZsInAFAblmfql
	KIZyxKEYqY9aEVPV+dbE9q7k454dCBsfX20DzW2qGYOOKxdDKEB/99o6yO+WAB3KwS3XPWg4/Vn
	fxM0rVaGaT6C5+myBLac0IRXSGKAqPE/fyqH6rc61+DzEqF6KIPAlCECfE3digYe/xhv5wCcUcB
	llS0DkshFVyAam4=
X-Received: by 2002:a05:622a:20f:b0:478:f03c:b3dc with SMTP id d75a77b69052e-47925a35858mr4930151cf.41.1743710972365;
        Thu, 03 Apr 2025 13:09:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbU+UU1cCtLalnRfA0DF1A/kmiMX8QNwvpWlUJwraHCy8fxemUuozaBN5IUqdCFtsVCeFXkg==
X-Received: by 2002:a05:622a:20f:b0:478:f03c:b3dc with SMTP id d75a77b69052e-47925a35858mr4929931cf.41.1743710972094;
        Thu, 03 Apr 2025 13:09:32 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4791b1440d0sm11537231cf.68.2025.04.03.13.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:09:31 -0700 (PDT)
Message-ID: <45e6e250e5bc51d2b0a8490f31e2144054990b82.camel@redhat.com>
Subject: Re: [RFC PATCH 11/24] KVM: nSVM: Use a separate ASID for nested
 guests
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:09:30 -0400
In-Reply-To: <20250326193619.3714986-12-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-12-yosry.ahmed@linux.dev>
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
> The per-VM ASID is currently shared by both L1 and L2 guests. That ASID
> is currently flushed on every transition between L1 and L2.
> 
> Allocate and track a separate ASID per-VM for nested guests. This is in
> preparation for doing fine-grained TLB flushes on nested transitions
> instead of unconditional full flushes.
> 
> Nested ASIDs are still not fully maintained (e.g. a remote flush will
> only flush the current ASID), so keep the TLB flush on every transition
> until this is sorted out in following changes.
> 
> Add a helper to get the ASID associated with a specific VMCB and use it
> instead of directly reading the VM's ASID. This transparently uses L2's
> ASID when an L2 guest is being run.
> 
> L1's ASID is flushed on KVM_REQ_TLB_FLUSH_GUEST if it is the active
> context, so remove the TODO in nested_svm_transition_tlb_flush() about
> it.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c |  8 ++++++--
>  arch/x86/kvm/svm/svm.c    | 13 +++++++++++--
>  arch/x86/kvm/svm/svm.h    |  3 ++-
>  3 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 81184b2fb27fd..75223869aa8c6 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -495,7 +495,6 @@ static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
>  	 *  - Honor L1's request to flush an ASID on nested VMRUN
>  	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
>  	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
> -	 *  - Flush L1's ASID on KVM_REQ_TLB_FLUSH_GUEST
>  	 *
>  	 * [*] Unlike nested EPT, SVM's ASID management can invalidate nested
>  	 *     NPT guest-physical mappings on VMRUN.
> @@ -677,7 +676,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
>  	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
>  	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
> -	vmcb02->control.asid = svm_asid(vcpu->kvm);
> +	vmcb02->control.asid = svm_nested_asid(vcpu->kvm);
>  
>  	/* Also overwritten later if necessary.  */
>  	vmcb_clr_flush_asid(vmcb02);
> @@ -1179,6 +1178,7 @@ static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
>  
>  int svm_allocate_nested(struct vcpu_svm *svm)
>  {
> +	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
>  	struct page *vmcb02_page;
>  
>  	if (svm->nested.initialized)
> @@ -1196,6 +1196,10 @@ int svm_allocate_nested(struct vcpu_svm *svm)
>  	svm_vcpu_init_msrpm(&svm->vcpu, svm->nested.msrpm);
>  
>  	svm->nested.initialized = true;
> +
> +	if (!kvm_svm->nested_asid)
> +		kvm_svm->nested_asid = kvm_svm->asid;

Nitpick: maybe put nested_asid into .nested struct as well?
I don't have a strong option on this, feel free to leave it where it is now.


> +
>  	return 0;
>  
>  err_free_vmcb02:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f028d006f69dc..e664d8428c792 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1225,17 +1225,26 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -unsigned int svm_asid(struct kvm *kvm)
> +unsigned int svm_nested_asid(struct kvm *kvm)
> +{
> +	return to_kvm_svm(kvm)->nested_asid;
> +}

It might also make sense to add WARN_ON_ONCE(!svm->nested.initialized) here, just in case.

> +
> +static unsigned int svm_asid(struct kvm *kvm)
>  {
>  	return to_kvm_svm(kvm)->asid;
>  }
>  
>  static unsigned int svm_get_current_asid(struct vcpu_svm *svm)
>  {
> -	struct kvm *kvm = svm->vcpu.kvm;
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm *kvm = vcpu->kvm;
>  
>  	if (sev_guest(kvm))
>  		return sev_get_asid(kvm);
> +	if (is_guest_mode(vcpu))
> +		return svm_nested_asid(kvm);
> +	WARN_ON_ONCE(svm->current_vmcb != &svm->vmcb01);
>  	return svm_asid(kvm);
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 436b7e83141b9..e67e3a64e92f7 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -118,6 +118,7 @@ struct kvm_svm {
>  	struct kvm kvm;
>  
>  	unsigned int asid;
> +	unsigned int nested_asid;
>  
>  	/* Struct members for AVIC */
>  	u32 avic_vm_id;
> @@ -651,7 +652,7 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
>  				     int trig_mode, int vec);
>  bool svm_register_asid(unsigned int asid);
>  void svm_unregister_asid(unsigned int asid);
> -unsigned int svm_asid(struct kvm *kvm);
> +unsigned int svm_nested_asid(struct kvm *kvm);
>  
>  /* nested.c */
>  


Overall looks good,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




