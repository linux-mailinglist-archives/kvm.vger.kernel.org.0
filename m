Return-Path: <kvm+bounces-52037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A3BDB0032D
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 15:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 572533B6EB1
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 13:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA2D2253F2;
	Thu, 10 Jul 2025 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NGlRy8Dv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0651117741
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 13:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752153618; cv=none; b=OH4ldSLA1wHGvSttDG/Nap/bbcCl1W5P+ekWDOyl0vnScxcVWK/4gn7o93UIR6+g76x1knNr9gxGavPMED8Koph9aoCdBuZTzUUkoL27nRjjiF3NrMvw8jJ6fMV2v5IZxlknlsgUVgt0fpbuFuWuckvD6NK+6Po7uijQUYiKYKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752153618; c=relaxed/simple;
	bh=uehGeOxIsYu/H+UPVbsxf29t7tS792bMgEiqy2Fx3LM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bRUFaoL0ayFX4BeJJh7nxhRPVXjc297zzC0bxo2bNH77Atp2tFRvexQbyouNtvrEkNM8nRu1bIzti2n/RGEhWrm7zVIDEw2x4f95fjM4WU428CfYpKkK8tmAAD2RlFOMvB70qdHeNavQOc4AeAwf8mrIsbTxVJYNPmmzWVjRQSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NGlRy8Dv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138e64b3f1so1356135a91.3
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 06:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752153616; x=1752758416; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xIdcYlEoAcORDptPg4wk7ZcTs4eHO9pee3oXMmDSMPU=;
        b=NGlRy8DveukGODmUToJVl0nyEwznEcUzvvFWSBpMMzBYVmmOEA9Uqsik1/7W3DJBck
         0AY1xxNXpIY3VOimDi1yILiQdK80We0mbvzc61adysJtlc2wdDIIQk0UD5fx/FqiFaYq
         mHVrlAGuhTCfEopCw0wCua9bssRUXK0M+uo1TQ0zen7yi8vZm/31MakrA24eKp6gPuzL
         2fpZXuDZw/mhSCjxD4DSsMog5wjz99BEaVkm+A3TkXc5p7c/SyUpuJdpw9K4wRqo11mt
         vtNDb5MB/mWRrF5Y7alLl/6/nKdM8M0Xa5Cia8t5vgXGLJ21I3bcLcCuoKh1iWKkJfUv
         Rnyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752153616; x=1752758416;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xIdcYlEoAcORDptPg4wk7ZcTs4eHO9pee3oXMmDSMPU=;
        b=m3amLdzGr3UILoq5DyfEyu2QVq1YQq6Kn+ljnfFmch69b3zPiK0ROfIXm0hMH15w2K
         5U2VhiRLaC4jharnUNvv0+R1I4+7PdVkcn9nhK942ig1A8d89WzOl74S6wVEWeV6QOsS
         RQwKLrjwnNvZfgwVMXzfEV3+LBIIgLiy/ivq6vhtu0yBMTwJS5KjbHcvQMAUqcbsKteR
         g6XHZW+V/dysuxXdYtEkp2Ct5hnPMnWtpuzLvLcM10qEabb7vKUmpPpg5q7/SKD9jd0v
         TQSNIHq35Prjy/3rcOj+ESFo/9kV/7qJbx9jlRJgcYd2nhyS8Y8PyRsbh3zd9Ka9NLba
         YLKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCe7diQM4dHCPn3R+ECYaBiNkM+nBHhJNdO5e/ddUArUeGCn/bbOXDzovCN4bDMCUdyVM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwH/3UIGevgX7/vUToeA+zVbjywto+NsbPXqOsvje7MMX0Q/kcT
	u2kkWCbFujBlxFUAZ7AenoBfUyETw9NRM2Rnza2mc6FvuchFcpUi0Vvsh6fQC9wBJAfV8EjvbP3
	faJstWw==
X-Google-Smtp-Source: AGHT+IEzq6sTKc1fZp5QRbRsM7aFBvr84H6fw/kfn/awB0ppWQTWv6ubPYOCQ+69MHzEJ32Bt7+xrhN8FTg=
X-Received: from pjqq12.prod.google.com ([2002:a17:90b:584c:b0:314:3438:8e79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f41:b0:315:cbe0:13b3
 with SMTP id 98e67ed59e1d1-31c3eeeb2f9mr4156406a91.7.1752153616317; Thu, 10
 Jul 2025 06:20:16 -0700 (PDT)
Date: Thu, 10 Jul 2025 06:20:14 -0700
In-Reply-To: <85h5zkuxa2.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707101029.927906-1-nikunj@amd.com> <20250707101029.927906-3-nikunj@amd.com>
 <aG0tFvoEXzUqRjnC@google.com> <63f08c9e-b228-4282-bd08-454ccdf53ecf@amd.com>
 <aG5oTKtWWqhwoFlI@google.com> <85h5zkuxa2.fsf@amd.com>
Message-ID: <aG--DjX1r4RK3lFC@google.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: bp@alien8.de, pbonzini@redhat.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, santosh.shukla@amd.com, isaku.yamahata@intel.com, 
	vaishali.thakkar@suse.com, kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 10, 2025, Nikunj A Dadhania wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > Because there's zero point in not intercepting writes, and KVM shouldn't do
> > things for no reason as doing so tends to confuse readers.  E.g. I reacted to
> > this because I didn't read the changelog first, and was surprised that the guest
> > could adjust its TSC frequency (which it obviously can't, but that's what the
> > code implies to me).
> >
> 
> Agree to your point that MSR read-only and having a MSR_TYPE_RW
> creates a special case. I can change this to MSR_TYPE_R. The only thing
> which looks inefficient to me is the path to generate the #GP when the
> MSR interception is enabled.
> 
> AFAIU, the GUEST_TSC_FREQ write handling for SEV-SNP guest:
> 
> sev_handle_vmgexit()
> -> msr_interception()
>   -> kvm_set_msr_common()
>      -> kvm_emulate_wrmsr()
>         -> kvm_set_msr_with_filter()
>         -> svm_complete_emulated_msr() will inject the #GP
> 
> With MSR interception disabled: vCPU will directly generate #GP

Yes, but no well-behaved guest will ever write the MSR, and if a guest does
manage to generate a WRMSR, the guest is beyond hosed if it affects performance.

> >>    The guest vCPU handles it appropriately when interception is disabled.
> >>
> >> 2) Guest does not expect GUEST_TSC_FREQ MSR to be intercepted(read or write), guest 
> >>    will terminate if GUEST_TSC_FREQ MSR is intercepted by the hypervisor:
> >
> > But it's read-only, the guest shouldn't be writing.  If the vCPU handles #GPs
> > appropriately, then it should have no problem handling #VCs on bad writes.
> >
> >> 38cc6495cdec x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC enabled guests
> >
> > That's a guest bug, it shouldn't be complaining about the host
> > intercepting writes.
> 
> The code was written with a perspective that host should not be
> intercepting GUEST_TSC_FREQ, as it is a guest-only MSR.

It's fine to panic on a _read_, I'm saying the guest shouldn't panic on a write,
because the guest shouldn't be writing in the first place.

diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index 0989d98da130..353647339a79 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -369,24 +369,21 @@ static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool wri
        u64 tsc;
 
        /*
-        * GUEST_TSC_FREQ should not be intercepted when Secure TSC is enabled.
-        * Terminate the SNP guest when the interception is enabled.
+        * Writing to MSR_IA32_TSC can cause subsequent reads of the TSC to
+        * return undefined values, and GUEST_TSC_FREQ is read-only.  Ignore
+        * all writes, but WARN to log the kernel bug.
+        */
+       if (WARN_ON_ONCE(write))
+               return ES_OK;
+
+       /*
+        * GUEST_TSC_FREQ should be not be intercepted when Secure TSC is
+        * enabled. Terminate the SNP guest when the interception is enabled.
         */
        if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ)
                return ES_VMM_ERROR;
 
-       /*
-        * Writes: Writing to MSR_IA32_TSC can cause subsequent reads of the TSC
-        *         to return undefined values, so ignore all writes.
-        *
-        * Reads: Reads of MSR_IA32_TSC should return the current TSC value, use
-        *        the value returned by rdtsc_ordered().
-        */
-       if (write) {
-               WARN_ONCE(1, "TSC MSR writes are verboten!\n");
-               return ES_OK;
-       }
-
+       /* Reads of MSR_IA32_TSC should return the current TSC value. */
        tsc = rdtsc_ordered();
        regs->ax = lower_32_bits(tsc);
        regs->dx = upper_32_bits(tsc);

