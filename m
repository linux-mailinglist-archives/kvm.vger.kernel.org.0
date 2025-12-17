Return-Path: <kvm+bounces-66179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 13198CC84ED
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 15:56:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B3E9304ED91
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 14:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C29F346AF1;
	Wed, 17 Dec 2025 14:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oyb3R/ij"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E82834B198
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 14:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765982470; cv=none; b=dznTj+7b8Fe7o+f8+8TpTisBaqhEB46K1oCtxqPX9jLv7H5jjF5La+YLJIBtTT7kcURCqkIoKIVfLV4soSGmpikkws7/JgU9m50frC7rXzCJQTmiYa0C0tM+lXoMrx8YYxstJHBvXHG9imCngZby3/27cd2SX68c2POn/00xFHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765982470; c=relaxed/simple;
	bh=JoyvrPitA52QjiAPwDLXwrvrVkcazE8gldGvMteUArw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s6gdIZuSBNYLhBSoAL4KP1YSikfgBDW1YziVU+dbKApStDqk24oXMrAXuQHOE5lgnonIgPRSJjwuyG7BrggPmAmjUyE6Fwu7j8kwMKIPvx3sdiT3z6q+zi89ovDAh3grySPCHKarC10M1SobVkrWDFdtGbhKVFaRFrnM5uoA8Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oyb3R/ij; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c904a1168so6747914a91.1
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 06:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765982463; x=1766587263; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sD4gtZYJjmXhHVmeohFr4+ySjk22q/qhYtG7atMeswo=;
        b=oyb3R/ijQv2F4z8PhUyOxlF5IzrtY8FcaPjmkMoup6WCvrhoyOvRgOR7VADALNxuce
         i8AWE+tb9McqS2+C1Y0nshzKjVKUF8PpdoHz8hjlXZ5SdiFmorgSWIOjtir3yM6Wswxy
         GM9CT6+9uoAJ910DG1LJEyG3TsnMVMrYb4XvDBkAaTX+2/LnRqelK2okkWSi6LvLRb9T
         7lN+WofAbtY7Z0WARJjhM+nYlbwhFQYA0VJMGgsZ1hnO/EeVynEdmBOaIYrqPjtkbbGF
         56XqFGT7H5hI27MKnucciXFcI2jyTewdZo0+a4SJ8fTbuNYwjQqPp/XKas8x7TsFVTQa
         3DSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765982463; x=1766587263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sD4gtZYJjmXhHVmeohFr4+ySjk22q/qhYtG7atMeswo=;
        b=d+okNBmdOp6m+EYpVZk0JJPPcMCSlmKtzDLiLexCwng9PpgRo2oLpW0aMRKvTMKycH
         AC/SxffOrLAhauP/LfL2Ou3rNClTnzF5dHXohpRocCCu7itkQTzKbItj7ZR69bbTFfOr
         8EQVZgugfTMLqXi27ki4Ox+QoRA5cTMB9QRWR2LiuKrcHDIW3VTu9AxLpiWkSZ9F4Oej
         PrLDgrcYm993OFxWryN7br+RznbAxFbUFlvD9OK+4LLkHg5ttoD9JEv9JThENk3wB1Wd
         oinoazKhO3Ok7eK7BXcXC/pIagOn8z1dXD9IhTI/jlpD+baH2Ul5VO4tC7dh03E5dIO4
         dI6A==
X-Forwarded-Encrypted: i=1; AJvYcCUyqNwcR6nyGsIVF1cjZTxEsPfJ5t1I22edDaFwOOQBB9Mx9Qofcd8UM0+iUkJlhKxB0VY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzvtayspwgiaf4d9hxIxf6PK+0HCNd8Nn9oEZrU0mBzc0S7WLG7
	csfnVpVMVjPMWdq7Hfl+QEVlC5mhujMR4usdnrxwaG2asALUpauB59aKisj3qK99s21HkZpnvYP
	ctW1NNw==
X-Google-Smtp-Source: AGHT+IHa5GABwEH2tlBdSM74mYDSBbfkFweBmt+8WvoWz8syzYPBNcgs9/zm7V7+ssuMso/wSieQoqXZVOg=
X-Received: from pjnu19.prod.google.com ([2002:a17:90a:8913:b0:34c:4048:b62b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35c8:b0:340:e521:bc73
 with SMTP id 98e67ed59e1d1-34abd6cc48fmr12942643a91.5.1765982463248; Wed, 17
 Dec 2025 06:41:03 -0800 (PST)
Date: Wed, 17 Dec 2025 06:41:01 -0800
In-Reply-To: <70FDA8A5-9B92-459B-A661-159365AE6385@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251216012918.1707681-1-seanjc@google.com> <70FDA8A5-9B92-459B-A661-159365AE6385@zytor.com>
Message-ID: <aULA_VdN0gjjGJuF@google.com>
Subject: Re: [PATCH] KVM: nVMX: Disallow access to vmcs12 fields that aren't
 supported by "hardware"
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 16, 2025, Xin Li wrote:
> > diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
> > index 4233b5ca9461..78eca9399975 100644
> > --- a/arch/x86/kvm/vmx/vmcs12.c
> > +++ b/arch/x86/kvm/vmx/vmcs12.c
> > @@ -9,7 +9,7 @@
> > FIELD(number, name), \
> > [ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
> > 
> > -const unsigned short vmcs12_field_offsets[] = {
> > +const __initconst u16 supported_vmcs12_field_offsets[] = {
> 
> I initially misunderstood "supported" to mean the VMCS fields available at
> runtime.  I'm unsure if it's necessary to make its meaning more explicit.
> E.g., prefix with kvm_?

Oh, good point.  Ya, will do.

> > FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
> > FIELD(POSTED_INTR_NV, posted_intr_nv),
> > FIELD(GUEST_ES_SELECTOR, guest_es_selector),
> > @@ -158,4 +158,55 @@ const unsigned short vmcs12_field_offsets[] = {
> > FIELD(HOST_SSP, host_ssp),
> > FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
> > };
> > -const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
> > +
> > +u16 vmcs12_field_offsets[ARRAY_SIZE(supported_vmcs12_field_offsets)] __ro_after_init;
> > +unsigned int nr_vmcs12_fields __ro_after_init;
> > +
> > +#define VMCS12_CASE64(enc) case enc##_HIGH: case enc
> > +
> > +static __init bool cpu_has_vmcs12_field(unsigned int idx)
> > +{
> > + switch (VMCS12_IDX_TO_ENC(idx)) {
> > + case VIRTUAL_PROCESSOR_ID: return cpu_has_vmx_vpid();
> > + case POSTED_INTR_NV: return cpu_has_vmx_posted_intr();
> > + VMCS12_CASE64(TSC_MULTIPLIER): return cpu_has_vmx_tsc_scaling();
> > + VMCS12_CASE64(VIRTUAL_APIC_PAGE_ADDR): return cpu_has_vmx_tpr_shadow();
> > + VMCS12_CASE64(APIC_ACCESS_ADDR): return cpu_has_vmx_virtualize_apic_accesses();
> > + VMCS12_CASE64(POSTED_INTR_DESC_ADDR): return cpu_has_vmx_posted_intr();
> > + VMCS12_CASE64(VM_FUNCTION_CONTROL): return cpu_has_vmx_vmfunc();
> > + VMCS12_CASE64(EPT_POINTER): return cpu_has_vmx_ept();
> > + VMCS12_CASE64(EPTP_LIST_ADDRESS): return cpu_has_vmx_vmfunc();
> > + VMCS12_CASE64(XSS_EXIT_BITMAP): return cpu_has_vmx_xsaves();
> > + VMCS12_CASE64(ENCLS_EXITING_BITMAP): return cpu_has_vmx_encls_vmexit();
> > + VMCS12_CASE64(GUEST_IA32_PERF_GLOBAL_CTRL): return cpu_has_load_perf_global_ctrl();
> > + VMCS12_CASE64(HOST_IA32_PERF_GLOBAL_CTRL): return cpu_has_load_perf_global_ctrl();
> 
> Combine the above 2 cases?
> 
> > + case TPR_THRESHOLD: return cpu_has_vmx_tpr_shadow();
> > + case SECONDARY_VM_EXEC_CONTROL: return cpu_has_secondary_exec_ctrls();
> > + case GUEST_S_CET: return cpu_has_load_cet_ctrl();
> > + case GUEST_SSP: return cpu_has_load_cet_ctrl();
> > + case GUEST_INTR_SSP_TABLE: return cpu_has_load_cet_ctrl();
> > + case HOST_S_CET: return cpu_has_load_cet_ctrl();
> > + case HOST_SSP: return cpu_has_load_cet_ctrl();
> > + case HOST_INTR_SSP_TABLE: return cpu_has_load_cet_ctrl();
> 
> Combine all CET cases?

Yeah, will do.  I was on the fence as to whether it would be a net positive to
combine them.

Thanks!

