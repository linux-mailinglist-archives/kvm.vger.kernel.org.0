Return-Path: <kvm+bounces-63984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 07B81C76246
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 21:11:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B910B4E100A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 20:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27FAD306B17;
	Thu, 20 Nov 2025 20:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zf/i2IMf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDD32FD66E
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 20:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763669474; cv=none; b=bDB/D4/IBUYK7fcq/CN2iKgFQXAfgXjdMJURe4tVIDLM+aMw4XRomxtyXkna4djtVXTtghMMG9k8CoqGqsXIslbazxHVSznqMO8h/ucu9K1uPls54FdYi2adS4dK++xw3V61/MeIXw4Mn126RzaM8Xfvtm7YArR1Zu8Ab8TruYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763669474; c=relaxed/simple;
	bh=/N91MQkT4hirPp48GVavg7Gl10a/lhArrXXn8s2xfy8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gQ1ot4f8xZtOcpvIqUv6cj2sgPy88dgZhECkJZuJz799kIVoESjQ5qSyQQDa8GZOnqMNatsB3qaoGfvMtaUD/7dxdXPf3I+C9yvlCHbyT94xzvm/jrpxcmwJaIbKaQ5XYr9igK7RV4gKH5sJ8NRdqCPg/xVd6QyYjae++oYnB38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zf/i2IMf; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b969f3f5c13so1237900a12.0
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 12:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763669471; x=1764274271; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0kd5gopvx3Cs928Gispk22ZOd+uJO9mD6SmSdOIrX3k=;
        b=zf/i2IMftEtkjxBqb3yqc7VJn5cV0AW+PVNGaEMlsOPUc8fsKaYxBbjyxTSMl7xTYa
         oSpaoI4rIBGr9O3H2bZeyZea0eoHakLnpj30WBaEzqB4r4lkFG0BLCZcD1+wBTJmALj1
         nlMhZFXqtMOtTOOs0U9OzgCton222tTvsLpSMaejRzrR0tTvkqAn9QHcFyd9znS23lH8
         qSU2nQ5TXiUr3EBX3BHfMJTY4XoZE492Wy1LLtLQK+Kp6DCxc2MyHykM9opSBiLPIhPS
         8G52MQxayEBCDBtNcM4+or/0kHnftI+3IPU4N3w6BqXr3mLgweFPqttJLimBdAz1NRx7
         q2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763669471; x=1764274271;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0kd5gopvx3Cs928Gispk22ZOd+uJO9mD6SmSdOIrX3k=;
        b=E0/7U0S+rhOM+rLO+ygmRE4m+Eif1bGrgjoV+2y2SWZkWv0hXWYpSQPVVs96tBT3RX
         UI7X0mvtogbXKzUGmWTE6WfSvpM37q6FFf+7KfHU96SbO8tSJsTRjPUP1oDJf2y3xZXo
         w5CbY4LgCMQAfodhiN4pADrPJ3O5HuoEAPu0he7R+IJlyD7Nl9N+CNU1CKLKFhr/8baz
         VT1qf4Sm12RpHWgoYDo1mIzYlYBM+6FWylL2TwVZLTrnzJ5kc1QsfNZbEE/sDJwmJQJd
         P5MPX4T5G3GP9ySb/I5PXE9ZQlF5sFOMS2Exs9ZQ0sgfz3YBpJ3xzIOReEA34UhBb3MB
         vtJA==
X-Forwarded-Encrypted: i=1; AJvYcCUrKiQsh+bT/s+ClsroVWbQt/EYf8sqRHAPlazyW6mXjGhvjplEHn3wpvPAAmYjZyt6w5s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGSAK7o4LDMg+MeSBKC3Uy8Fo8jxuoOdX9YV04SOqHUnY+vHlF
	EP1jd7XbfRtyUQ/BKvcG1zld/tkTL/VjenrzJEe06jir3mPreDveG4RhVvgM7/J8XV6tafaR0A4
	hk9JzLA==
X-Google-Smtp-Source: AGHT+IFq0zl+KKWiwS6oGlFzB8Gt6K80lJBaxXVbTTl9srEVwchDqj3bDxEfDvavtm6P1Jmvy2zmXIvE+Ig=
X-Received: from pfbho11.prod.google.com ([2002:a05:6a00:880b:b0:76b:651e:a69c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:939e:b0:343:5d53:c0ab
 with SMTP id adf61e73a8af0-3613b519f50mr5937926637.20.1763669470559; Thu, 20
 Nov 2025 12:11:10 -0800 (PST)
Date: Thu, 20 Nov 2025 12:11:09 -0800
In-Reply-To: <20251107093239.67012-2-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251107093239.67012-1-amit@kernel.org> <20251107093239.67012-2-amit@kernel.org>
Message-ID: <aR913X8EqO6meCqa@google.com>
Subject: Re: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
From: Sean Christopherson <seanjc@google.com>
To: Amit Shah <amit@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	linux-doc@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com, 
	bp@alien8.de, tglx@linutronix.de, peterz@infradead.org, jpoimboe@kernel.org, 
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com, 
	dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com, 
	daniel.sneddon@linux.intel.com, kai.huang@intel.com, sandipan.das@amd.com, 
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com, david.kaplan@amd.com, 
	dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

KVM: SVM:

On Fri, Nov 07, 2025, Amit Shah wrote:
> From: Amit Shah <amit.shah@amd.com>
>=20
> AMD CPUs with the Enhanced Return Address Predictor (ERAPS) feature

Enhanced Return Address Predictor Security.  The 'S' matters.

> Zen5+) obviate the need for FILL_RETURN_BUFFER sequences right after
> VMEXITs.  The feature adds guest/host tags to entries in the RSB (a.k.a.
> RAP).  This helps with speculation protection across the VM boundary,
> and it also preserves host and guest entries in the RSB that can improve
> software performance (which would otherwise be flushed due to the
> FILL_RETURN_BUFFER sequences).  This feature also extends the size of
> the RSB from the older standard (of 32 entries) to a new default
> enumerated in CPUID leaf 0x80000021:EBX bits 23:16 -- which is 64
> entries in Zen5 CPUs.
>=20
> The hardware feature is always-on, and the host context uses the full
> default RSB size without any software changes necessary.  The presence
> of this feature allows software (both in host and guest contexts) to
> drop all RSB filling routines in favour of the hardware doing it.
>=20
> There are two guest/host configurations that need to be addressed before
> allowing a guest to use this feature: nested guests, and hosts using
> shadow paging (or when NPT is disabled):
>=20
> 1. Nested guests: the ERAPS feature adds host/guest tagging to entries
>    in the RSB, but does not distinguish between the guest ASIDs.  To
>    prevent the case of an L2 guest poisoning the RSB to attack the L1
>    guest, the CPU exposes a new VMCB bit (CLEAR_RAP).  The next
>    VMRUN with a VMCB that has this bit set causes the CPU to flush the
>    RSB before entering the guest context.  Set the bit in VMCB01 after a
>    nested #VMEXIT to ensure the next time the L1 guest runs, its RSB
>    contents aren't polluted by the L2's contents.  Similarly, before
>    entry into a nested guest, set the bit for VMCB02, so that the L1
>    guest's RSB contents are not leaked/used in the L2 context.
>=20
> 2. Hosts that disable NPT: the ERAPS feature flushes the RSB entries on
>    several conditions, including CR3 updates.  Emulating hardware
>    behaviour on RSB flushes is not worth the effort for NPT=3Doff case,
>    nor is it worthwhile to enumerate and emulate every trigger the
>    hardware uses to flush RSB entries.  Instead of identifying and
>    replicating RSB flushes that hardware would have performed had NPT
>    been ON, do not let NPT=3Doff VMs use the ERAPS features.

The emulation requirements are not limited to shadow paging.  From the APM:

  The ERAPS feature eliminates the need to execute CALL instructions to cle=
ar
  the return address predictor in most cases. On processors that support ER=
APS,
  return addresses from CALL instructions executed in host mode are not use=
d in
  guest mode, and vice versa. Additionally, the return address predictor is
  cleared in all cases when the TLB is implicitly invalidated (see Section =
5.5.3 =E2=80=9CTLB
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  Management,=E2=80=9D on page 159) and in the following cases:

  =E2=80=A2 MOV CR3 instruction
  =E2=80=A2 INVPCID other than single address invalidation (operation type =
0)

Yes, KVM only intercepts MOV CR3 and INVPCID when NPT is disabled (or INVPC=
ID is
unsupported per guest CPUID), but that is an implementation detail, the ins=
tructions
are still reachable via emulator, and KVM needs to emulate implicit TLB flu=
sh
behavior.

So punting on emulating RAP clearing because it's too hard is not an option=
.  And
AFAICT, it's not even that hard.

The changelog also needs to include the architectural behavior, otherwise "=
is not
worth the effort" is even more subjective since there's no documentation of=
 what
the effort would actually be.

As for emulating the RAP clears, a clever idea is to piggyback and alias di=
rty
tracking for VCPU_EXREG_CR3, as VCPU_EXREG_ERAPS.  I.e. mark the vCPU as ne=
eding
a RAP clear if CR3 is written to, and then let common x86 also set VCPU_EXR=
EG_ERAPS
as needed, e.g. when handling INVPCID.

> This patch to KVM ensures both those caveats are addressed, and sets the

No "This patch".

> new ALLOW_LARGER_RAP VMCB bit that allows the CPU to operate with ERAPS
> enabled in guest contexts.
>=20
> This feature is documented in AMD APM Vol 2 (Pub 24593), in revisions
> 3.43 and later.
>=20
> Signed-off-by: Amit Shah <amit.shah@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h |  1 +
>  arch/x86/include/asm/svm.h         |  6 +++++-
>  arch/x86/kvm/cpuid.c               |  8 +++++++-
>  arch/x86/kvm/svm/nested.c          |  6 ++++++
>  arch/x86/kvm/svm/svm.c             | 11 +++++++++++
>  5 files changed, 30 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cp=
ufeatures.h
> index 4091a776e37a..edc76a489aae 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -467,6 +467,7 @@
>  #define X86_FEATURE_GP_ON_USER_CPUID	(20*32+17) /* User CPUID faulting *=
/
> =20
>  #define X86_FEATURE_PREFETCHI		(20*32+20) /* Prefetch Data/Instruction t=
o Cache Level */
> +#define X86_FEATURE_ERAPS		(20*32+24) /* Enhanced Return Address Predict=
or Security */
>  #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barr=
ier */
>  #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushe=
s all branch type predictions */
>  #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO *=
/
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 17f6c3fedeee..d4602ee4cf1f 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -131,7 +131,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area=
 {
>  	u64 tsc_offset;
>  	u32 asid;
>  	u8 tlb_ctl;
> -	u8 reserved_2[3];
> +	u8 erap_ctl;
> +	u8 reserved_2[2];
>  	u32 int_ctl;
>  	u32 int_vector;
>  	u32 int_state;
> @@ -182,6 +183,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area=
 {
>  #define TLB_CONTROL_FLUSH_ASID 3
>  #define TLB_CONTROL_FLUSH_ASID_LOCAL 7
> =20
> +#define ERAP_CONTROL_ALLOW_LARGER_RAP BIT(0)
> +#define ERAP_CONTROL_CLEAR_RAP BIT(1)
> +
>  #define V_TPR_MASK 0x0f
> =20
>  #define V_IRQ_SHIFT 8
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 52524e0ca97f..93934d4f8f11 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1795,8 +1795,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid=
_array *array, u32 function)
>  		entry->eax =3D entry->ebx =3D entry->ecx =3D entry->edx =3D 0;
>  		break;
>  	case 0x80000021:
> -		entry->ebx =3D entry->edx =3D 0;
> +		entry->edx =3D 0;
>  		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
> +
> +		if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
> +			entry->ebx &=3D GENMASK(23, 16);
> +		else
> +			entry->ebx =3D 0;
> +
>  		cpuid_entry_override(entry, CPUID_8000_0021_ECX);
>  		break;
>  	/* AMD Extended Performance Monitoring and Debug */
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index a6443feab252..de51595e875c 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -869,6 +869,9 @@ static void nested_vmcb02_prepare_control(struct vcpu=
_svm *svm,
>  		}
>  	}
> =20
> +	if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))

My bad, this should be=20

	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))

because KVM doesn't need to flush the RAP if the virtual isn't ERAPS-capabl=
e
(L1 is responsible for manually clearing the RAP).

Ditto for setting ERAP_CONTROL_ALLOW_LARGER_RAP in init_vmcb() and below.  =
If
userspace decides not to expose ERAPS to L1 for whatever reason, then KVM s=
hould
honor that.

> +		vmcb02->control.erap_ctl |=3D ERAP_CONTROL_CLEAR_RAP;

Suspiciously absent is support for running L2 with ERAP_CONTROL_ALLOW_LARGE=
R_RAP.
init_vmcb() always operates on vmcb01.  In theory, we could set ALLOW_LARGE=
R_RAP
in vmcb02 if it's supported in the virtual CPU, regardless of what vmcb12 s=
ays.
But given that this is security related, I think it makes sense to honor L1=
's
wishes, even though that means L1 also needs to be updated to fully benefit=
 from
ERAPS.

Compile tested only at this point, but this?

--
From: Amit Shah <amit.shah@amd.com>
Date: Fri, 7 Nov 2025 10:32:39 +0100
Subject: [PATCH] KVM: SVM: Virtualize and advertise support for ERAPS
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

AMD CPUs with the Enhanced Return Address Predictor Security (ERAPS)
feature (available on Zen5+) obviate the need for FILL_RETURN_BUFFER
sequences right after VMEXITs.  ERAPS adds guest/host tags to entries in
the RSB (a.k.a. RAP).  This helps with speculation protection across the
VM boundary, and it also preserves host and guest entries in the RSB that
can improve software performance (which would otherwise be flushed due to
the FILL_RETURN_BUFFER sequences).

Importantly, ERAPS also improves cross-domain security by clearing the RAP
in certain situations.  Specifically, the RAP is cleared in response to
actions that are typically tied to software context switching between
tasks.  Per the APM:

  The ERAPS feature eliminates the need to execute CALL instructions to
  clear the return address predictor in most cases. On processors that
  support ERAPS, return addresses from CALL instructions executed in host
  mode are not used in guest mode, and vice versa. Additionally, the
  return address predictor is cleared in all cases when the TLB is
  implicitly invalidated and in the following cases:

  =E2=80=A2 MOV CR3 instruction
  =E2=80=A2 INVPCID other than single address invalidation (operation type =
0)

ERAPS also allows CPUs to extends the size of the RSB/RAP from the older
standard (of 32 entries) to a new size, enumerated in CPUID leaf
0x80000021:EBX bits 23:16 (64 entries in Zen5 CPUs).

In hardware, ERAPS is always-on, when running in host context, the CPU
uses the full RSB/RAP size without any software changes necessary.
However, when running in guest context, the CPU utilizes the full size of
the RSB/RAP if and only if the new ALLOW_LARGER_RAP flag is set in the
VMCB; if the flag is not set, the CPU limits itself to the historical size
of 32 entires.

Requiring software to opt-in for guest usage of RAPs larger than 32 entries
allows hypervisors, i.e. KVM, to emulate the aforementioned conditions in
which the RAP is cleared as well as the guest/host split.  E.g. if the CPU
unconditionally used the full RAP for guests, failure to clear the RAP on
transitions between L1 or L2, or on emulated guest TLB flushes, would
expose the guest to RAP-based attacks as a guest without support for ERAPS
wouldn't know that its FILL_RETURN_BUFFER sequence is insufficient.

Address the ~two broad categories of ERAPS emulation, and advertise
ERAPS support to userspace, along with the RAP size enumerated in CPUID.

1. Architectural RAP clearing: as above, CPUs with ERAPS clear RAP entries
   on several conditions, including CR3 updates.  To handle scenarios
   where a relevant operation is handled in common code (emulation of
   INVPCID and to a lesser extent MOV CR3), piggyback VCPU_EXREG_CR3 and
   create an alias, VCPU_EXREG_ERAPS.  SVM doesn't utilize CR3 dirty
   tracking, and so for all intents and purposes VCPU_EXREG_CR3 is unused.
   Aliasing VCPU_EXREG_ERAPS ensures that any flow that writes CR3 will
   also clear the guest's RAP, and allows common x86 to mark ERAPS vCPUs
   as needing a RAP clear without having to add a new request (or other
   mechanism).

2. Nested guests: the ERAPS feature adds host/guest tagging to entries
   in the RSB, but does not distinguish between the guest ASIDs.  To
   prevent the case of an L2 guest poisoning the RSB to attack the L1
   guest, the CPU exposes a new VMCB bit (CLEAR_RAP).  The next
   VMRUN with a VMCB that has this bit set causes the CPU to flush the
   RSB before entering the guest context.  Set the bit in VMCB01 after a
   nested #VMEXIT to ensure the next time the L1 guest runs, its RSB
   contents aren't polluted by the L2's contents.  Similarly, before
   entry into a nested guest, set the bit for VMCB02, so that the L1
   guest's RSB contents are not leaked/used in the L2 context.

Enable ALLOW_LARGER_RAP (and emulate RAP clears) if and only if ERAPS is
exposed to the guest.  Enabling ALLOW_LARGER_RAP unconditionally wouldn't
cause any functional issues, but ignoring userspace's (and L1's) desires
would put KVM into a grey area, which is especially undesirable due to the
potential security implications.  E.g. if a use case wants to have L1 do
manual RAP clearing even when ERAPS is present in hardware, enabling
ALLOW_LARGER_RAP could result in L1 leaving stale entries in the RAP.

ERAPS is documented in AMD APM Vol 2 (Pub 24593), in revisions 3.43 and
later.

Signed-off-by: Amit Shah <amit.shah@amd.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  8 ++++++++
 arch/x86/include/asm/svm.h         |  6 +++++-
 arch/x86/kvm/cpuid.c               |  9 ++++++++-
 arch/x86/kvm/svm/nested.c          | 18 ++++++++++++++++++
 arch/x86/kvm/svm/svm.c             | 25 ++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h             |  1 +
 arch/x86/kvm/x86.c                 | 12 ++++++++++++
 8 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpuf=
eatures.h
index 646d2a77a2e2..31ab1e4e70f3 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -468,6 +468,7 @@
 #define X86_FEATURE_GP_ON_USER_CPUID	(20*32+17) /* User CPUID faulting */
=20
 #define X86_FEATURE_PREFETCHI		(20*32+20) /* Prefetch Data/Instruction to =
Cache Level */
+#define X86_FEATURE_ERAPS		(20*32+24) /* Enhanced Return Address Predictor=
 Security */
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrie=
r */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes =
all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 5a3bfa293e8b..0353d8b6988c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -195,7 +195,15 @@ enum kvm_reg {
=20
 	VCPU_EXREG_PDPTR =3D NR_VCPU_REGS,
 	VCPU_EXREG_CR0,
+	/*
+	 * Alias AMD's ERAPS (not a real register) to CR3 so that common code
+	 * can trigger emulation of the RAP (Return Address Predictor) with
+	 * minimal support required in common code.  Piggyback CR3 as the RAP
+	 * is cleared on writes to CR3, i.e. marking CR3 dirty will naturally
+	 * mark ERAPS dirty as well.
+	 */
 	VCPU_EXREG_CR3,
+	VCPU_EXREG_ERAPS =3D VCPU_EXREG_CR3,
 	VCPU_EXREG_CR4,
 	VCPU_EXREG_RFLAGS,
 	VCPU_EXREG_SEGMENTS,
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e69b6d0dedcf..348957bda488 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -131,7 +131,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 tsc_offset;
 	u32 asid;
 	u8 tlb_ctl;
-	u8 reserved_2[3];
+	u8 erap_ctl;
+	u8 reserved_2[2];
 	u32 int_ctl;
 	u32 int_vector;
 	u32 int_state;
@@ -182,6 +183,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define TLB_CONTROL_FLUSH_ASID 3
 #define TLB_CONTROL_FLUSH_ASID_LOCAL 7
=20
+#define ERAP_CONTROL_ALLOW_LARGER_RAP BIT(0)
+#define ERAP_CONTROL_CLEAR_RAP BIT(1)
+
 #define V_TPR_MASK 0x0f
=20
 #define V_IRQ_SHIFT 8
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d563a948318b..8bed1224635d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1216,6 +1216,7 @@ void kvm_set_cpu_caps(void)
 		/* PrefetchCtlMsr */
 		/* GpOnUserCpuid */
 		/* EPSF */
+		F(ERAPS),
 		SYNTHESIZED_F(SBPB),
 		SYNTHESIZED_F(IBPB_BRTYPE),
 		SYNTHESIZED_F(SRSO_NO),
@@ -1796,8 +1797,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_a=
rray *array, u32 function)
 		entry->eax =3D entry->ebx =3D entry->ecx =3D entry->edx =3D 0;
 		break;
 	case 0x80000021:
-		entry->ebx =3D entry->edx =3D 0;
+		entry->edx =3D 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
+
+		if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
+			entry->ebx &=3D GENMASK(23, 16);
+		else
+			entry->ebx =3D 0;
+
 		cpuid_entry_override(entry, CPUID_8000_0021_ECX);
 		break;
 	/* AMD Extended Performance Monitoring and Debug */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c81005b24522..5dc6b8915809 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -417,6 +417,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcp=
u *vcpu,
 	to->msrpm_base_pa       =3D from->msrpm_base_pa;
 	to->tsc_offset          =3D from->tsc_offset;
 	to->tlb_ctl             =3D from->tlb_ctl;
+	to->erap_ctl            =3D from->erap_ctl;
 	to->int_ctl             =3D from->int_ctl;
 	to->int_vector          =3D from->int_vector;
 	to->int_state           =3D from->int_state;
@@ -866,6 +867,19 @@ static void nested_vmcb02_prepare_control(struct vcpu_=
svm *svm,
 		}
 	}
=20
+	/*
+	 * Take ALLOW_LARGER_RAP from vmcb12 even though it should be safe to
+	 * let L2 use a larger RAP since KVM will emulate the necessary clears,
+	 * as it's possible L1 deliberately wants to restrict L2 to the legacy
+	 * RAP size.  Unconditionally clear the RAP on nested VMRUN, as KVM is
+	 * responsible for emulating the host vs. guest tags (L1 is the "host",
+	 * L2 is the "guest").
+	 */
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
+		vmcb02->control.erap_ctl =3D (svm->nested.ctl.erap_ctl &
+					    ERAP_CONTROL_ALLOW_LARGER_RAP) |
+					   ERAP_CONTROL_CLEAR_RAP;
+
 	/*
 	 * Merge guest and host intercepts - must be called with vcpu in
 	 * guest-mode to take effect.
@@ -1161,6 +1175,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
=20
 	kvm_nested_vmexit_handle_ibrs(vcpu);
=20
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
+		vmcb01->control.erap_ctl |=3D ERAP_CONTROL_CLEAR_RAP;
+
 	svm_switch_vmcb(svm, &svm->vmcb01);
=20
 	/*
@@ -1667,6 +1684,7 @@ static void nested_copy_vmcb_cache_to_control(struct =
vmcb_control_area *dst,
 	dst->tsc_offset           =3D from->tsc_offset;
 	dst->asid                 =3D from->asid;
 	dst->tlb_ctl              =3D from->tlb_ctl;
+	dst->erap_ctl             =3D from->erap_ctl;
 	dst->int_ctl              =3D from->int_ctl;
 	dst->int_vector           =3D from->int_vector;
 	dst->int_state            =3D from->int_state;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f56c2d895011..4f1407b9d0a2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1141,6 +1141,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool ini=
t_event)
 		svm_clr_intercept(svm, INTERCEPT_PAUSE);
 	}
=20
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
+		svm->vmcb->control.erap_ctl |=3D ERAP_CONTROL_ALLOW_LARGER_RAP;
+
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
=20
@@ -3271,6 +3274,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "tsc_offset:", control->tsc_offset);
 	pr_err("%-20s%d\n", "asid:", control->asid);
 	pr_err("%-20s%d\n", "tlb_ctl:", control->tlb_ctl);
+	pr_err("%-20s%d\n", "erap_ctl:", control->erap_ctl);
 	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
 	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
 	pr_err("%-20s%08x\n", "int_state:", control->int_state);
@@ -3982,6 +3986,13 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu,=
 gva_t gva)
 	invlpga(gva, svm->vmcb->control.asid);
 }
=20
+static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
+{
+	kvm_register_mark_dirty(vcpu, VCPU_EXREG_ERAPS);
+
+	svm_flush_tlb_asid(vcpu);
+}
+
 static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
@@ -4240,6 +4251,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm=
_vcpu *vcpu, u64 run_flags)
 	}
 	svm->vmcb->save.cr2 =3D vcpu->arch.cr2;
=20
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS) &&
+	    kvm_register_is_dirty(vcpu, VCPU_EXREG_ERAPS))
+		svm->vmcb->control.erap_ctl |=3D ERAP_CONTROL_CLEAR_RAP;
+
 	svm_hv_update_vp_id(svm->vmcb, vcpu);
=20
 	/*
@@ -4317,6 +4332,14 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm=
_vcpu *vcpu, u64 run_flags)
 	}
=20
 	svm->vmcb->control.tlb_ctl =3D TLB_CONTROL_DO_NOTHING;
+
+	/*
+	 * Unconditionally mask off the CLEAR_RAP bit, the AND is just as cheap
+	 * as the TEST+Jcc to avoid it.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_ERAPS))
+		svm->vmcb->control.erap_ctl &=3D ~ERAP_CONTROL_CLEAR_RAP;
+
 	vmcb_mark_all_clean(svm->vmcb);
=20
 	/* if exit due to PF check for async PF */
@@ -5071,7 +5094,7 @@ struct kvm_x86_ops svm_x86_ops __initdata =3D {
 	.flush_tlb_all =3D svm_flush_tlb_all,
 	.flush_tlb_current =3D svm_flush_tlb_current,
 	.flush_tlb_gva =3D svm_flush_tlb_gva,
-	.flush_tlb_guest =3D svm_flush_tlb_asid,
+	.flush_tlb_guest =3D svm_flush_tlb_guest,
=20
 	.vcpu_pre_run =3D svm_vcpu_pre_run,
 	.vcpu_run =3D svm_vcpu_run,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9e151dbdef25..96eab58830ce 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -156,6 +156,7 @@ struct vmcb_ctrl_area_cached {
 	u64 tsc_offset;
 	u32 asid;
 	u8 tlb_ctl;
+	u8 erap_ctl;
 	u32 int_ctl;
 	u32 int_vector;
 	u32 int_state;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c6d899d53dd..98c177ebf2a2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14123,6 +14123,13 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsi=
gned long type, gva_t gva)
 			return 1;
 		}
=20
+		/*
+		 * When ERAPS is supported, invalidating a specific PCID clears
+		 * the RAP (Return Address Predicator).
+		 */
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
+			kvm_register_is_dirty(vcpu, VCPU_EXREG_ERAPS);
+
 		kvm_invalidate_pcid(vcpu, operand.pcid);
 		return kvm_skip_emulated_instruction(vcpu);
=20
@@ -14136,6 +14143,11 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsi=
gned long type, gva_t gva)
=20
 		fallthrough;
 	case INVPCID_TYPE_ALL_INCL_GLOBAL:
+		/*
+		 * Don't bother marking VCPU_EXREG_ERAPS dirty, SVM will take
+		 * care of doing so when emulating the full guest TLB flush
+		 * (the RAP is cleared on all implicit TLB flushes).
+		 */
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 		return kvm_skip_emulated_instruction(vcpu);
=20

base-commit: 0c3b67dddd1051015f5504389a551ecd260488a5
--

