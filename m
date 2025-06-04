Return-Path: <kvm+bounces-48408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44560ACDFA3
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 15:56:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DA4C167271
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 13:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 622DA2900BD;
	Wed,  4 Jun 2025 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KPd/cZ7n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F086328F935
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 13:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749045366; cv=none; b=L+u26G57gaJKPmLSOT0lXwem/wOR+/E8Fae+yvOy7ZdZQoin9ioVO5Lh2pyEQ63FU25djsO29+DfdwcoPZz8ru9huS9PGGETb5qfc089IdxFRJoiGM+KzUTM/tAHsIybOc8AvJnyL0Hv9XLFPvKNfKWQo+dGa2L+4bgchEhnX/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749045366; c=relaxed/simple;
	bh=Jd4bOTdufN+SkQt/Ld5ULZ9ZL5hW/b1y0IEOOcTR0w4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nih6bClLXNaeOX7Was+0ZAc0mXfKXT+OZ4MUzSmnwYViH0lwXyJE+1CfGL69D6nDlBZFYuhCXeSr+iCfaGXIw8bAkhO6ODA8UzZ6SeZPJsBOxaGmujlNv6QiJ03ksT33lu68WqKbeqvLASS8U8tMtmAhYyRRwtqIr9V/TosZmSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KPd/cZ7n; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-312eaf676b3so2710907a91.3
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 06:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749045364; x=1749650164; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9BF4BQWYCffwCvEcJneONMaK8DNln+FUa3w2saRVlU0=;
        b=KPd/cZ7nryauGsNL/ig4YIq3aAnStFT+gMXWWmH8GF/RAliGoOHzMd6Jve/8+BDor2
         +P3L/1kzMIMvG1XOQKMBcK2WdSPl+op5Osq5ZEaOJ0C3NqzoETvW8qsaoNIdUnY60BLU
         tof2I5/iOMc+q0tNVcx6Db9T1PhG6QD+sJT0zNM7bU4jwtsxNraGBD+KxEuwR+AD/LX6
         cqz1ZI9Ge242Eu7AJgRJhmGjJ4ft4W9RUzi6SqPIF+AkCJZQUCdF2dONA0HhGOg+2wb7
         wSTjMjKw81Jxwz1mBfzjF6qH/+FmTW375DEEAQcK2zfRn6GxUdcznBj7W6KSLqLAAFmq
         W3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749045364; x=1749650164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9BF4BQWYCffwCvEcJneONMaK8DNln+FUa3w2saRVlU0=;
        b=f/UxOMQ9LMqL9HCC0gIWN6pUKEmxSpeXdx19yLRsuClRZlk7UKM4RIMR9/67pT3YQI
         bYYi3zfz+n2qbLlW6bRKfmLD5ZtK7ZqxplfSCbv9o84956Dx4xTvrqOGgWfN0jb/yPUj
         pZqIdwdbT76IfMEaOrSkdnHe9ler3OsqJkGyA6sKmNeLB8BJ2leD9Lz7urm+aREr6yaS
         L2Gil3a7bEE0Igkb2JBZIXBGAgMzFMJOhjElC32j+VdYwJq+beXX95M+l1+AWOPMIjSy
         mSDK5+UNsqjcqMuMDMr/26iDAtc+ibUXfrexXge54rlfYWIMRZfZz07BHTA2emTOEvDZ
         s8zw==
X-Forwarded-Encrypted: i=1; AJvYcCU+oV3XBPq3+sT8lGZ3bekHwWDI2WWUdzI0T84m44TLm3qBjjFFrEwDnmlngWPvdH4zUUU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDlWBlu/I+/2OPSCEjyz/+WtNplswXCJ7NJZ42iacMc2Eq7gMD
	NoZ/YvZKmcMhw1kwpI0TeS4NIQwe+MvTP9q1xxxHv9frPpaiVwE9FqYYtOotp2U7YKLl6uUqCHx
	75aK3cQ==
X-Google-Smtp-Source: AGHT+IHnjDcLBr5/b5vVMhOX9FYYeTjBdgbqUz02Tjf48qTrSCQ4pB6Rh8rX4c6lQeoe9Fsflp0vIM3e6wo=
X-Received: from pjbsb6.prod.google.com ([2002:a17:90b:50c6:b0:312:1dae:6bf0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ace:b0:312:f88d:260b
 with SMTP id 98e67ed59e1d1-3130ccd51d5mr4706762a91.14.1749045364124; Wed, 04
 Jun 2025 06:56:04 -0700 (PDT)
Date: Wed, 4 Jun 2025 06:56:02 -0700
In-Reply-To: <aD/c6RZvE7a1KSqk@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com> <20250529234013.3826933-9-seanjc@google.com>
 <aD/c6RZvE7a1KSqk@intel.com>
Message-ID: <aEBQchT0cpCKkmQ6@google.com>
Subject: Re: [PATCH 08/28] KVM: nSVM: Use dedicated array of MSRPM offsets to
 merge L0 and L1 bitmaps
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 04, 2025, Chao Gao wrote:
> >diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> >index 89a77f0f1cc8..e53020939e60 100644
> >--- a/arch/x86/kvm/svm/nested.c
> >+++ b/arch/x86/kvm/svm/nested.c
> >@@ -184,6 +184,64 @@ void recalc_intercepts(struct vcpu_svm *svm)
> > 	}
> > }
> > 
> >+static int nested_svm_msrpm_merge_offsets[9] __ro_after_init;
> 
> I understand how the array size (i.e., 9) was determined :). But, adding a
> comment explaining this would be quite helpful 

Yeah, I'll write a comment explaining what all is going on.

> >+static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
> >+
> >+int __init nested_svm_init_msrpm_merge_offsets(void)
> >+{
> >+	const u32 merge_msrs[] = {
> >+		MSR_STAR,
> >+		MSR_IA32_SYSENTER_CS,
> >+		MSR_IA32_SYSENTER_EIP,
> >+		MSR_IA32_SYSENTER_ESP,
> >+	#ifdef CONFIG_X86_64
> >+		MSR_GS_BASE,
> >+		MSR_FS_BASE,
> >+		MSR_KERNEL_GS_BASE,
> >+		MSR_LSTAR,
> >+		MSR_CSTAR,
> >+		MSR_SYSCALL_MASK,
> >+	#endif
> >+		MSR_IA32_SPEC_CTRL,
> >+		MSR_IA32_PRED_CMD,
> >+		MSR_IA32_FLUSH_CMD,
> 
> MSR_IA32_DEBUGCTLMSR is missing, but it's benign since it shares the same
> offset as MSR_IA32_LAST* below.

Gah.  Once all is said and done, it's not supposed to be in this list because its
only passed through for SEV-ES guests, but my intent was to keep it in this patch,
and then removeit along with XSS, EFER, PAT, GHCB, and TSC_AUX in the next.

This made me realize that merging in chunks has a novel flaw: if there is an MSR
that KVM *doesn't* want to give L2 access to, then KVM needs to ensure its offset
isn't processed, i.e. that there isn't a "collision" with another MSR.  I don't
think it's a major concern, because the x2APIC MSRs are nicely isolated, and off
the top of my head I can't think of any MSRs that fall into that bucket.  But it's
something worth calling out in a comment, at least.

> I'm a bit concerned that we might overlook adding new MSRs to this array in the
> future, which could lead to tricky bugs. But I have no idea how to avoid this.

Me either.  One option would be to use wrapper macros for the interception helpers
to fill an array at compile time (similar to how kernel exception fixup works),
but (a) it requires modifications to the linker scripts to generate the arrays,
(b) is quite confusing/complex, and (c) it doesn't actually solve the problem,
it just inverts the problem.  Because as above, there are MSRs we *don't* want
to expose to L2, and so we'd need to add yet more code to filter those out.

And the failure mode for the inverted case would be worse, because if we missed
an MSR, KVM would incorrectly give L2 access to an MSR.  Whereas with the current
approach, a missed MSR simply means L2 gets a slower path; but functionally, it's
fine (and it has to be fine, because KVM can't force L1 to disable interception).

> Removing this array and iterating over direct_access_msrs[] directly is an
> option but it contradicts this series as one of its purposes is to remove
> direct_access_msrs[].

Using direct_access_msrs[] wouldn't solve the problem either, because nothing
ensures _that_ array is up-to-date either.

The best idea I have is to add a test that verifies the MSRs that are supposed
to be passed through actually are passed through.  It's still effectively manual
checking, but it would require us to screw up twice, i.e. forget to update both
the array and the test.  The problem is that there's no easy and foolproof way to
verify that an MSR is passed through in a selftest.

E.g. it would be possible to precisely detect L2 => L0 MSR exits via a BPF program,
but incorporating a BPF program into a KVM selftest just to detect exits isn't
something I'm keen on doing (or maintaining).

Using the "exits" stat isn't foolproof due to NMIs (IRQs can be accounted for via
"irq_exits", and to a lesser extent page faults (especially if shadow paging is
in use).

If KVM provided an "msr_exits" stats, it would be trivial to verify interception
via a selftest, but I can't quite convince myself that MSR exits are interesting
enough to warrant their own stat.

> >+		MSR_IA32_LASTBRANCHFROMIP,
> >+		MSR_IA32_LASTBRANCHTOIP,
> >+		MSR_IA32_LASTINTFROMIP,
> >+		MSR_IA32_LASTINTTOIP,
> >+
> >+		MSR_IA32_XSS,
> >+		MSR_EFER,
> >+		MSR_IA32_CR_PAT,
> >+		MSR_AMD64_SEV_ES_GHCB,
> >+		MSR_TSC_AUX,
> >+	};
> 
> 
> > 
> > 		if (kvm_vcpu_read_guest(vcpu, offset, &value, 4))
> >diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >index 1c70293400bc..84dd1f220986 100644
> >--- a/arch/x86/kvm/svm/svm.c
> >+++ b/arch/x86/kvm/svm/svm.c
> >@@ -5689,6 +5689,10 @@ static int __init svm_init(void)
> > 	if (!kvm_is_svm_supported())
> > 		return -EOPNOTSUPP;
> > 
> >+	r = nested_svm_init_msrpm_merge_offsets();
> >+	if (r)
> >+		return r;
> >+
> 
> If the offset array is used for nested virtualization only, how about guarding
> this with nested virtualization? For example, in svm_hardware_setup():

Good idea, I'll do that in the next version.

> 	if (nested) {
> 		r = nested_svm_init_msrpm_merge_offsets();
> 		if (r)
> 			goto err;
> 
> 		pr_info("Nested Virtualization enabled\n");
> 		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
> 	}
> 
> 
> > 	r = kvm_x86_vendor_init(&svm_init_ops);
> > 	if (r)
> > 		return r;
> >diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> >index 909b9af6b3c1..0a8041d70994 100644
> >--- a/arch/x86/kvm/svm/svm.h
> >+++ b/arch/x86/kvm/svm/svm.h
> >@@ -686,6 +686,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
> > 	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
> > }
> > 
> >+int __init nested_svm_init_msrpm_merge_offsets(void);
> >+
> > int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
> > 			 u64 vmcb_gpa, struct vmcb *vmcb12, bool from_vmrun);
> > void svm_leave_nested(struct kvm_vcpu *vcpu);
> >-- 
> >2.49.0.1204.g71687c7c1d-goog
> >

