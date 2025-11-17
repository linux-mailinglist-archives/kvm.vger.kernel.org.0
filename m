Return-Path: <kvm+bounces-63389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 786D9C64F71
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 16:50:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 11ABE3538DC
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 15:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E65C296BCB;
	Mon, 17 Nov 2025 15:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R1XdJy27"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1427B27F016
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763394474; cv=none; b=j7dpUV8tSQyh3vyV9u9u/mjdEN80Enqzly81PI6oWFzgRFNg+LVARz/bmOG4kVQnneTNKP/me4XuA2wHO8qD13Ib2+4S8MkZUcyZWmiGtNllKDy/+WYnzajBxGsAatbI0UoTRRvd8kuazRmv4kn+Rlh/eRvOYn2ECe02s1rtuRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763394474; c=relaxed/simple;
	bh=S3VS2vlTquoz0Ey+ul06GiZbnYLVMgC2APREHcx/Xog=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pjy7N8CoF27Tb+HDtZ0Jy/zF/aln5xyIWZafgnRYkA4oi60lWlZPsSRu2j086XeAGAYXVSz2eDJQ8KQQTS6Y+VoM795fx4tAxvZeqm/NYrwxDUoWRDICYM6Y4Laihe31gZIH9pHF6xgDATH7frH6luVgRVt4ug/fVXNKj47yG9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R1XdJy27; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b6b194cf71so5696846b3a.3
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 07:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763394471; x=1763999271; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wdsS2EyVSMNBbGPJvYoyehbAtWAmx3Bt9tblbDN3w7s=;
        b=R1XdJy27JkZcBuVy5ISvRr68V6E6ovQ1x7nLo3DOGKsnAz0pCW3mNamnMQOmXklH9D
         YtCNAp0JDgsge7ly85dkCF3UKxHfjOA1d574JhGFOk0deEaNgJM9T/DUcpb3g9nSVQTv
         NI5eafHB9TpNXnc8oOqeV0k5P/hKChNP7cs6RS3j9s/FRtA/IhO0feFMnyyTL+yCHCHN
         9cRCGD47sQid/tZ+3qvyRs95LUEMGkmBQInt9851ozj9vtbIJXdJURZPBFLGX2hqjOjy
         QMZNpggNGT/Uwwiemq9OtaMGE2EqTPaO9mHHO4IPQsMuvTSC/LdbbaCBf8diynsckUvu
         j9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763394471; x=1763999271;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wdsS2EyVSMNBbGPJvYoyehbAtWAmx3Bt9tblbDN3w7s=;
        b=I1s00oFwBg9gsE/X9YkgBDwduR5Qa5sDRW0GF4sRKPUdjcL97QaUChpneL3oFKeRDA
         BQ6mf3FggLcDhrJyQjphw9YBKnvvPe07u2ePjovs8wF5jSMlfPdJV5hMrSz6kMws0OQP
         n7/1JfE4IBiBB04J5G6HHMXKH3l8nNfnjHDi+1WjcozwaWSIMNzqMXh/0xozpGJXyP8a
         qUepv+AJZ+yQ+9jN8BCeNYvs417I4X7yYppOuZcvpESnkcXCXhiuNjwoFGF7LFANdzNr
         cEU2/x6JzHrYxivaa4Un8PEh7RKVBJ1bKoibdpcVaLNjtiQP178q6VvrhFYYdpSk0pXm
         NqhA==
X-Forwarded-Encrypted: i=1; AJvYcCWb/G9b7lfqQ9ARZ4oPviGjGSXk27k6yAneqjMz3eDPAC7c0lAtlYmgaCprzBsHE6a6v2E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnEwrB+j6taczK/FW1tAdXpNDhJhMkk3dGH1V2m5eWau2Cvmmj
	F/PDEG4AGrrvqgxPDm8PRuUkozR7aVeBqZxZRG5a++wyp/3zC1uXTiaRlctQOABR92OP1dJc+XH
	cVSzjCg==
X-Google-Smtp-Source: AGHT+IGuz5sFBTWGUG0HC+frxB6UxyEssga+2yAcLsRRtLljmZ5LW6SqXSoQEtV1ACaAj1R7XFvuwQiZVV0=
X-Received: from pfbhm2.prod.google.com ([2002:a05:6a00:6702:b0:77c:6e29:42af])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2449:b0:35f:e2c8:247
 with SMTP id adf61e73a8af0-35fe2c80442mr3496015637.32.1763394471289; Mon, 17
 Nov 2025 07:47:51 -0800 (PST)
Date: Mon, 17 Nov 2025 07:47:49 -0800
In-Reply-To: <aRsXVvDHsdCjEgPM@tlindgre-MOBL1>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030224246.3456492-1-seanjc@google.com> <20251030224246.3456492-3-seanjc@google.com>
 <aRsXVvDHsdCjEgPM@tlindgre-MOBL1>
Message-ID: <aRtDpQ9DTonYw9Bi@google.com>
Subject: Re: [PATCH 2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside of
 the fastpath
From: Sean Christopherson <seanjc@google.com>
To: Tony Lindgren <tony.lindgren@linux.intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jon Kohler <jon@nutanix.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 17, 2025, Tony Lindgren wrote:
> Hi,
> 
> On Thu, Oct 30, 2025 at 03:42:44PM -0700, Sean Christopherson wrote:
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -608,6 +608,17 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> >  	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
> >  }
> >  
> > +static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> > +{
> > +	if (unlikely((u16)vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
> > +		kvm_machine_check();
> > +
> > +	if (is_td_vcpu(vcpu))
> > +		return;
> > +
> > +	return vmx_handle_exit_irqoff(vcpu);
> > +}
> 
> I bisected kvm-x86/next down to this change for a TDX guest not booting
> and host producing errors like:
> 
> watchdog: CPU118: Watchdog detected hard LOCKUP on cpu 118
> 
> Dropping the is_td_vcpu(vcpu) check above fixes the issue. Earlier the
> call for vmx_handle_exit_irqoff() was unconditional.

Ugh, once you see it, it's obvious.  Sorry :-(

I'll drop the entire series and send a v2.  There's only one other patch that I
already sent the "thank you" for, so I think it's worth unwinding to avoid
breaking bisection for TDX (and because the diff can be very different).

Lightly tested, but I think this patch can instead be:

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 163f854a39f2..6d41d2fc8043 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1063,9 +1063,6 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
        if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
                return EXIT_FASTPATH_NONE;
 
-       if (unlikely(vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
-               kvm_machine_check();
-
        trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
        if (unlikely(tdx_failed_vmentry(vcpu)))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d98107a7bdaa..d1117da5463f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7035,10 +7035,19 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
        if (to_vt(vcpu)->emulation_required)
                return;
 
-       if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXTERNAL_INTERRUPT)
+       switch (vmx_get_exit_reason(vcpu).basic) {
+       case EXIT_REASON_EXTERNAL_INTERRUPT:
                handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
-       else if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXCEPTION_NMI)
+               break;
+       case EXIT_REASON_EXCEPTION_NMI:
                handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
+               break;
+       case EXIT_REASON_MCE_DURING_VMENTRY:
+               kvm_machine_check();
+               break;
+       default:
+               break;
+       }
 }
 
 /*
@@ -7501,9 +7510,6 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
        if (unlikely(vmx->fail))
                return EXIT_FASTPATH_NONE;
 
-       if (unlikely((u16)vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
-               kvm_machine_check();
-
        trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
        if (unlikely(vmx_get_exit_reason(vcpu).failed_vmentry))

