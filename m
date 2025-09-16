Return-Path: <kvm+bounces-57794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF852B5A415
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 23:39:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A645D7ABB37
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 21:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E382DE707;
	Tue, 16 Sep 2025 21:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wpjpdlV2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3E931BCBB
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 21:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758058736; cv=none; b=XeUzE3F1QSyR5W/EEyJVTRmMLuBBfFNbA3HITX3tdUbNUNI75Acemv2LTko1g/3rN8U9oXCfma94VarAmJdXHeh5QNVZvnwsYKxTkr+D0zOFRruKc4KxRptDIxjNModxX7ajYAB7QlX7zr6xvA0llxLLl0eI37tuPReUvoY4kF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758058736; c=relaxed/simple;
	bh=ry7qkTB0pJG0crn45IaGPPnZtArUza62ClgAt7diaKQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=an73S5ygLC1ibUf3ckve98FF/XyJppS8lxd+RdoOxK77LqlhgvxtNVYkDffIozeMDjADQhyF3fznknKTD0QnX4Hljm6RM0CUgQ4+cEPZsWbhw9/VJtjfRjfprc5rw0AlQboN3Xqsh5o7Ynk7dafjTsFOiXzTEav0b03vE0xNW3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wpjpdlV2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec2211659so678378a91.0
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 14:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758058734; x=1758663534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N3b3Tk/l8MqsriYm3Qf+JFhCnUPMjiU2DQ5fPBKzlm4=;
        b=wpjpdlV2GhQTD91Ta5eX5siWUFbN7US6sLSpp8857mx0hm+AGZEskIQEoWrtzSaHsj
         3YS4Rt3/1BSguL9dIPA6PEZ0FhiCeTVHX28kqcaBH6Z8s84FZKVVrNiMRbWGrjZDMCj6
         uc9LfK09Ff0968zxpYpp22Fg3aohyMIaRM8zbeEIW+OXFy/Z8zWNfvbVYnlTzkixWY7b
         HdTMnuPplklppuPadcOZJ0Mtk0O+uwTeLJZbOkZbQ67DGEQ3Sm04KDTdUTkXByDIE8P4
         CGFBdt1ZTeDJezKTygsKU3sIBkytXfPTSNR6jPbsgjcfoXR3soBRKdkf2x+h7HI71zna
         UnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758058734; x=1758663534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N3b3Tk/l8MqsriYm3Qf+JFhCnUPMjiU2DQ5fPBKzlm4=;
        b=iiwQX9f+3ElaOacSmwpbKdU0WJeskhfz8MJUfk9HkR/06/OD3Mg5vQX9iiRni8Nkkz
         J9UZSe8fmHEgcqeYjMAbJ634EYA7ulpNIHRSnn/E5cuW8SedbX5Z0vlVxWjP0RiPqbu8
         v4CQGa5+hViWkpKDfqxU2WbNcluPHwXlTrf4Tdl3pSzKS+a0S5HavqRG7cvGR4nRRQNP
         WKQntKXFovmtWffIkIqF725ixWUUg1Z81MkjS33hCx1YFziQLYllTpcjDF3mvT7o9WqM
         qAnsXVG0EZo7lo0NIGU6hX93vgjJQkjtG5QeumGKlud59O6nMZ4oelSHV74ynEyPPqWS
         91Eg==
X-Forwarded-Encrypted: i=1; AJvYcCVPenYQFUu0uIw7DaaRtfbXQ20JUytZ2iRe6c/b3EZpYs7dXGFZ6FjjLvwRxLbvDjFuWBo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVTdzVoqXMzfKm0EOJPkd/FK7pF9USHdFawC9ZIjWGAEDLHZE9
	irmQ4C7+wVa0kaqmZUSRu/RTqC3KTEvVRbamnHbtqliJgETsmyLnT2qZ5u43lFgj0cSkcdZB7pc
	/gakYjQ==
X-Google-Smtp-Source: AGHT+IFpPyFP3pZHDiGP08zKKpUK8E7Uz0NLVkZDtHl1SG5g6WnVLCUlyN3v3omtp5YZLceLqn/eINYnI94=
X-Received: from pjbsq6.prod.google.com ([2002:a17:90b:5306:b0:32e:834b:ea49])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c43:b0:32b:6cf2:a2cf
 with SMTP id 98e67ed59e1d1-32de4ecfef6mr20983631a91.14.1758058733733; Tue, 16
 Sep 2025 14:38:53 -0700 (PDT)
Date: Tue, 16 Sep 2025 14:38:52 -0700
In-Reply-To: <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-30-seanjc@google.com>
 <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com> <aMnAVtWhxQipw9Er@google.com> <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com>
Message-ID: <aMnY7NqhhnMYqu7m@google.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 16, 2025, John Allen wrote:
> On Tue, Sep 16, 2025 at 12:53:58PM -0700, Sean Christopherson wrote:
> > On Tue, Sep 16, 2025, John Allen wrote:
> > > On Fri, Sep 12, 2025 at 04:23:07PM -0700, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > index 0cd77a87dd84..0cd32df7b9b6 100644
> > > > --- a/arch/x86/kvm/svm/sev.c
> > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > @@ -3306,6 +3306,9 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
> > > >  	if (kvm_ghcb_xcr0_is_valid(svm))
> > > >  		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(ghcb));
> > > >  
> > > > +	if (kvm_ghcb_xss_is_valid(svm))
> > > > +		__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(ghcb));
> > > > +
> > > 
> > > It looks like this is the change that caused the selftest regression
> > > with sev-es. It's not yet clear to me what the problem is though.
> > 
> > Do you see any WARNs in the guest kernel log?
> > 
> > The most obvious potential bug is that KVM is missing a CPUID update, e.g. due
> > to dropping an XSS write, consuming stale data, not setting cpuid_dynamic_bits_dirty,
> > etc.  But AFAICT, CPUID.0xD.1.EBX (only thing that consumes the current XSS) is
> > only used by init_xstate_size(), and I would expect the guest kernel's sanity
> > checks in paranoid_xstate_size_valid() to yell if KVM botches CPUID emulation.
> 
> Yes, actually that looks to be the case:
> 
> [    0.463504] ------------[ cut here ]------------
> [    0.464443] XSAVE consistency problem: size 880 != kernel_size 840
> [    0.465445] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/fpu/xstate.c:638 paranoid_xstate_size_valid+0x101/0x140

Can you run with the below printk tracing in the host (and optionally tracing in
the guest for its updates)?  Compile tested only.

There should be very few XSS updates, so this _shouldn't_ spam/crash your host :-)

---
 arch/x86/kvm/svm/sev.c |  6 ++++--
 arch/x86/kvm/x86.c     | 15 ++++++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0cd32df7b9b6..8ac87d623767 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3306,8 +3306,10 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	if (kvm_ghcb_xcr0_is_valid(svm))
 		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(ghcb));
 
-	if (kvm_ghcb_xss_is_valid(svm))
-		__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(ghcb));
+	if (kvm_ghcb_xss_is_valid(svm)) {
+		if (__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(ghcb));
+			pr_warn("Dropped XSS update, val = %llx\n", data);
+	}
 
 	/* Copy the GHCB exit information into the VMCB fields */
 	exit_code = kvm_ghcb_get_sw_exit_code(ghcb);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c78acab2ff3f..a846ed69ce2c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4118,13 +4118,22 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_XSS:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES)) {
+			pr_warn("Guest CPUID doesn't have XSAVES\n");
 			return KVM_MSR_RET_UNSUPPORTED;
+		}
 
-		if (data & ~vcpu->arch.guest_supported_xss)
+		if (data & ~vcpu->arch.guest_supported_xss) {
+			pr_warn("Invalid XSS: supported = %llx, val = %llx\n",
+				vcpu->arch.guest_supported_xss, data);
 			return 1;
-		if (vcpu->arch.ia32_xss == data)
+		}
+		if (vcpu->arch.ia32_xss == data) {
+			pr_warn("XSS already set to val = %llx, eliding updates\n", data);
 			break;
+		}
+
+		pr_warn("XSS updated to val = %llx, marking CPUID dirty\n", data);
 		vcpu->arch.ia32_xss = data;
 		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 		break;

base-commit: 14298d819d5a6b7180a4089e7d2121ca3551dc6c
--

