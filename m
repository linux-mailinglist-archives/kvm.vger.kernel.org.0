Return-Path: <kvm+bounces-58282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59FA4B8B98A
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D5C87E73AE
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B2C2D24BA;
	Fri, 19 Sep 2025 22:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HqSQJ9VC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C948E27B359
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758322673; cv=none; b=CM+VRbRYte77bzZUZBvvfCiDsNQwZyiLRHvvI7HG2mnsT4uywG4L9TDMpXcXU3WiBhCGgy5sDtVXLSDVj4IdKqRk26TjPZKo7AO8IWtsakhurYSfeVmXOtekFlFeXZ92IxzYcOpV9it8DOOEOELqEjW27wmhO0rAqeXDvF1IwEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758322673; c=relaxed/simple;
	bh=w0n0oT4AEY8eEke71r8eB5cNddQs2dgmAUHaPww1Rw4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ouHXqrTvkZBsRTwRSy3ppnLAm+o/zLcei86XhcAFVL8Pfg95Ih4NR3uIxnOESjyADeG8sJvi9F9kJlUZqI1BLNVX7r/RNeagJo1+9b6y1DBFGsyBwFaniEDsiqU0IK0BjlX2Yok8tGhJxj9dDcg/KoogbHwJkX6gFsRCZO4Oty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HqSQJ9VC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-244581ce13aso49132645ad.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758322671; x=1758927471; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k1nL2sHZaVwxxO8gmb5F84AIaQWW4Mnos7VRIHq3uu8=;
        b=HqSQJ9VCcS6h1Iyb4PEARseHyJ9In8kdbhvPM3lx6qV/PGltmu5giY8fCwhA3ObgSy
         e9pcoR85X146M/tSyk87AFIacSy6RDy55F6g7lk0rPlV4Hm0OFpDENHWohdfL/ousbc+
         WtbGhppSBLcgFRS4kWDYV/x95YDasGeKytmus9ZVCg5cNJyFZAH5a81zp4HoPTsy2Quv
         opbmc+4TenVZ4I30rztSPR9KOvg08wTunycYNRKRvnj3PUzRLUrZEWnMERx/I+E1N7F7
         6TotlF3bhiRFPpOXwOaJ+nC0a7b7FVSiNJ8JXzMBWaBfEUW/b7mqHr3CxTZ/XROj1rBD
         z0Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758322671; x=1758927471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k1nL2sHZaVwxxO8gmb5F84AIaQWW4Mnos7VRIHq3uu8=;
        b=TK8d/4OhKJr9t3ywPslvP30j2EFE3mi4N7VMOfgRfnSAEtVgqj3+Tmn8swoNIR0nKO
         ygangu8yIsrskDt0mUv1B1yEk1c+yG9b3+ir7s5BdVhUZylCuRswwAf+8Fzb++prSaNl
         c2Ioxt0yZp3wrFPwmy2iz1AOIBnai8DCY2knr7M3hC38YIICaVZs+Xf+56+nbgdgejln
         3Jv4iVEuohoGcLM9pjKFh4l9FgWEq9VW3NcJRlPsPsAsqkKnh5E5wWm3XeK8zVDdNxLe
         Y6s1MbUcQNc6bGO3ayRAKUPRM7OOXwfWcElc7oBF0YgC+EwaNKoV3DAAddYioGz5C92h
         feVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeLQxXqTeGa0x1J+d6FyMHnBtlaw1+9QtL66Ud49tFCPtgTUPUfrEBzq+/Atk4lpiIZOM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzh00Y6YudtMdl3Wa/ET+Ink3h1l14U79Ei7ilm859o4Rpz9WV
	j48+25UGI1+yf5TiYUHnGA/u732fN6G4d+ST1mZhMY9UdWn7Z5Jun9P0g76PCgZZTfp/A7y9klk
	I7fk0Ng==
X-Google-Smtp-Source: AGHT+IFqogJhM5Mui7Rp4qxU0fl/m/BHClbKB37c6LI0q4FxFPT8FIRihkRWutMLOjMrfLVHId/GfrdfgSc=
X-Received: from pjuw15.prod.google.com ([2002:a17:90a:d60f:b0:330:8c66:4984])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecd1:b0:269:6052:3536
 with SMTP id d9443c01a7336-269ba5347camr65655375ad.45.1758322671102; Fri, 19
 Sep 2025 15:57:51 -0700 (PDT)
Date: Fri, 19 Sep 2025 15:57:49 -0700
In-Reply-To: <d3459026-c935-4738-8b28-49492e88e113@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-20-seanjc@google.com>
 <d3459026-c935-4738-8b28-49492e88e113@linux.intel.com>
Message-ID: <aM3f7cwjmSYMYq-K@google.com>
Subject: Re: [PATCH v15 19/41] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 18, 2025, Binbin Wu wrote:
> 
> 
> On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> > From: Yang Weijiang <weijiang.yang@intel.com>
> > 
> > Expose CET features to guest if KVM/host can support them, clear CPUID
> > feature bits if KVM/host cannot support.
> > 
> > Set CPUID feature bits so that CET features are available in guest CPUID.
> > Add CR4.CET bit support in order to allow guest set CET master control
> > bit.
> > 
> > Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
> > KVM does not support emulating CET.
> > 
> > The CET load-bits in VM_ENTRY/VM_EXIT control fields should be set to make
> > guest CET xstates isolated from host's.
> > 
> > On platforms with VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error
> > code will fail, and if VMX_BASIC[bit56] == 1, #CP injection with or without
> > error code is allowed. Disable CET feature bits if the MSR bit is cleared
> > so that nested VMM can inject #CP if and only if VMX_BASIC[bit56] == 1.
> > 
> > Don't expose CET feature if either of {U,S}_CET xstate bits is cleared
> > in host XSS or if XSAVES isn't supported.
> > 
> > CET MSRs are reset to 0s after RESET, power-up and INIT, clear guest CET
> > xsave-area fields so that guest CET MSRs are reset to 0s after the events.
> > 
> > Meanwhile explicitly disable SHSTK and IBT for SVM because CET KVM enabling
> > for SVM is not ready.
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> > Tested-by: Mathias Krause <minipli@grsecurity.net>
> > Tested-by: John Allen <john.allen@amd.com>
> > Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> 
> One nit below.
> 
> [...]
> > 			\
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 15f208c44cbd..c78acab2ff3f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -226,7 +226,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
> >    * PT via guest XSTATE would clobber perf state), i.e. KVM doesn't support
> >    * IA32_XSS[bit 8] (guests can/must use RDMSR/WRMSR to save/restore PT MSRs).
> >    */
> > -#define KVM_SUPPORTED_XSS     0
> > +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
> > +				 XFEATURE_MASK_CET_KERNEL)
> 
> Since XFEATURE_MASK_CET_USER and XFEATURE_MASK_CET_KERNEL are always checked or
> set together, does it make sense to use a macro for the two bits?

Good call.  I was going to say "eh, we can do that later", but it's a massive
improvement for readability.

