Return-Path: <kvm+bounces-36461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72CA9A1AE24
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 02:19:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D49607A1DF6
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 01:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 177C11D517E;
	Fri, 24 Jan 2025 01:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T0P01pB2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2953FD1
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 01:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737681533; cv=none; b=TCTbOl5As1tJ4mtMaknCbadDholy45phnMTo/CX0TKKUkqseNljePKYVpCQtP6zGqFJYYV5oEwKgUeSMX10sSpAkt4ftvaXmRwNQBWUwyWLRz79j2TsfAYlXGmB+IFZki7FhQddgkcESblfygU0Mumd/xusDJjZhPDXV6Kdc0Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737681533; c=relaxed/simple;
	bh=Kwe8mEuy0tJoIZlJh7U/FTlhIvHqM+4bw/YC7zleOvM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m56BXPNmR09TCjlPNlUQO3WDU4vgStAdWkQ7HGRcPC/Mz2Hr/Aid03LpkHAM9XoxZfVACWet3TiJVWqrb2XdykrcKssJ2LCJlw7bRfgQQKx65ek3DUywYZiKd784Le6CAOsGYFmNlDi4eY/lIGadAzjE91wwQPx731Ndr4Mwh8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T0P01pB2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e4c5343so4559241a91.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 17:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737681530; x=1738286330; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ur2PbnNKxFkaTdxwZWyIq/IA0X7RdIwqwKCVenYA4c=;
        b=T0P01pB2Gkqo7ZPKqwUZb4PudOhXfWm4B6/YmBbh4JXB7Ptw2cwu9N0srl+Jd2F4V0
         lBoAPGA0wR9HpXnIClDflR4NepkqeG8OvZRoelzWjSEqPu/gDyDDP7sayeO2Wrzm3IOL
         ZchTJKr12NDvj+PzAE9DUB7DPLd6LKfOLMoTRDi7pg9UZomMZyz23BY+EuREmZVFfhRq
         /2APGv0fiwfAJ8R2elNxuNymMWrYARPsGrqaT1gvQroReY91ePn9CO8JW0tEP04lDbp5
         48rIMqG7WfPjTPWprfNTdaZMfoN1akXJaREEHS3UKwYKBNvqdbfS8ezxHneGrefUssRk
         oDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737681530; x=1738286330;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3ur2PbnNKxFkaTdxwZWyIq/IA0X7RdIwqwKCVenYA4c=;
        b=CnOG254xt7PkViR4v1Kag/CSGRDVP+1Q0wyCn3ngm9esCp92NhyYHsba84wlVlzjub
         MGZGYbA7pMLUZgSaKEDmwwSQbExW3PHSbzA0y/e+EG85PDwfiLxftTRf9y9xtHPoRjOy
         GiQ2uv/kKA7fZbuiizXn9zm8CmGAAosfPBxeySG43jV79TgJU2YxDBKoSv0OC8xsDlbn
         SbLNXAFpSAYdrRh9E6/XaIn+lfFiXZoueRnQhqJTd5dOjwcZAMceIwAxofnYvSQ74iYY
         vg0WxXGZ9+tECHOVYYNuD3nTtbXQhqP/W6qGWUNT4DJCR94Vcfu4yrko227uKQzJU7yH
         zLPg==
X-Forwarded-Encrypted: i=1; AJvYcCXHl9lSR+oCLZz63V+B8zgdiUZMHZaplsUa0XzskoXTMkIwOUvZX4S1zUXWNUUDf4AjIPU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw32pUJ8iY7C+ny1DJX5+9wZhgtb57LXB6HGmbDWQOBn6+I1Qmx
	/ACJ8Jk7dzPliqkTpwxuihtg46PFs1hz1qoRBNeLi+KLR6kxOC88/afz7iaKw2FCh6P6Y/UnA3y
	5rg==
X-Google-Smtp-Source: AGHT+IF7+RIG2h90IjL10wDrEATogrj6yYNIvhio0s1/V+zrfNZ0ZTIXXYSGMVXge60xKL+iE+0t3TwHcW4=
X-Received: from pfat15.prod.google.com ([2002:a05:6a00:aa0f:b0:727:3c81:f42a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:330b:b0:724:59e0:5d22
 with SMTP id d2e1a72fcca58-72dafba2625mr40907641b3a.20.1737681529722; Thu, 23
 Jan 2025 17:18:49 -0800 (PST)
Date: Thu, 23 Jan 2025 17:18:48 -0800
In-Reply-To: <c7b494d34d3e14531337311c286a9c06a99c9295.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250123190253.25891-1-fgriffo@amazon.co.uk> <c7b494d34d3e14531337311c286a9c06a99c9295.camel@infradead.org>
Message-ID: <Z5LqeGa_G_NZ_boC@google.com>
Subject: Re: [PATCH] KVM: x86: Update Xen TSC leaves during CPUID emulation
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Fred Griffoul <fgriffo@amazon.co.uk>, kvm@vger.kernel.org, griffoul@gmail.com, 
	vkuznets@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 23, 2025, David Woodhouse wrote:
> On Thu, 2025-01-23 at 19:02 +0000, Fred Griffoul wrote:
>=20
> > +static inline void kvm_xen_may_update_tsc_info(struct kvm_vcpu *vcpu,
> > +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 function, u32 index,
> > +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 *eax, u32 *ecx, u32 *edx=
)
>=20
> Should this be called kvm_xen_maybe_update_tsc_info() ?=20
>=20
> Is it worth adding if (static_branch_unlikely(&kvm_xen_enabled.key))?=20

Or add a helper?  Especially if we end up processing KVM_REQ_CLOCK_UPDATE.

static inline bool kvm_xen_is_tsc_leaf(struct kvm_vcpu *vcpu, u32 function)
{
	return static_branch_unlikely(&kvm_xen_enabled.key) &&
	       vcpu->arch.xen.cpuid.base &&
	       function < vcpu->arch.xen.cpuid.limit;
	       function =3D=3D (vcpu->arch.xen.cpuid.base | XEN_CPUID_LEAF(3));
}

>=20
> > +{
> > +	u32 base =3D vcpu->arch.xen.cpuid.base;
> > +
> > +	if (base && (function =3D=3D (base | XEN_CPUID_LEAF(3)))) {

Pretty sure cpuid.limit needs to be checked, e.g. to avoid a false positive=
 in
the unlikely scenario that userspace advertised a lower limit but still fil=
led
the CPUID entry.

> > +		if (index =3D=3D 1) {
> > +			*ecx =3D vcpu->arch.hv_clock.tsc_to_system_mul;
> > +			*edx =3D vcpu->arch.hv_clock.tsc_shift;
>=20
> Are these fields in vcpu->arch.hv_clock definitely going to be set?

Set, yes.  Up-to-date, no.  If there is a pending KVM_REQ_CLOCK_UPDATE, e.g=
. due
to frequency change, KVM could emulate CPUID before processing the request =
if
the CPUID VM-Exit occurred before the request was made.

> If so, can we have a comment to that effect? And perhaps a warning to
> assert the truth of that claim?
>=20
> Before this patch, if the hv_clock isn't yet set then the guest would
> see the original content of the leaves as set by userspace?

In theory, yes, but in practice that can't happen because KVM always pends =
a
KVM_REQ_CLOCK_UPDATE before entering the guest (it's stupidly hard to see).

On the first kvm_arch_vcpu_load(), vcpu->cpu will be -1, which results in
KVM_REQ_GLOBAL_CLOCK_UPDATE being pending.

  	if (unlikely(vcpu->cpu !=3D cpu) || kvm_check_tsc_unstable()) {
		...

		if (!vcpu->kvm->arch.use_master_clock || vcpu->cpu =3D=3D -1)
			kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);

	}

That in turn triggers a KVM_REQ_CLOCK_UPDATE.

		if (kvm_check_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu))
			kvm_gen_kvmclock_update(vcpu);

  static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
  {
	struct kvm *kvm =3D v->kvm;

	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
	schedule_delayed_work(&kvm->arch.kvmclock_update_work,
					KVMCLOCK_UPDATE_DELAY);
  }

And in the extremely unlikely failure path, which I assume handles the case=
 where
TSC calibration hasn't completed, KVM requests another KVM_REQ_CLOCK_UPDATE=
 and
aborts VM-Enter.  So AFAICT, it's impossible to trigger CPUID emulation wit=
hout
first stuffing Xen CPUID.

	/* Keep irq disabled to prevent changes to the clock */
	local_irq_save(flags);
	tgt_tsc_khz =3D get_cpu_tsc_khz();
	if (unlikely(tgt_tsc_khz =3D=3D 0)) {
		local_irq_restore(flags);
		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
		return 1;
	}

> Now it gets zeroes if that happens?

Somewhat of a tangent, if userspace is providing non-zero values, commit f4=
22f853af03
("KVM: x86/xen: update Xen CPUID Leaf 4 (tsc info) sub-leaves, if present")=
 would
have broken userspace.  QEMU doesn't appear to stuff non-zero values and no=
 one
has complained, so I think we escaped this time.

Jumping back to the code, if we add kvm_xen_is_tsc_leaf(), I would be a-ok =
with
handling the CPUID manipulations in kvm_cpuid().  I'd probably even prefer =
it,
because overall I think bleeding a few Xen details into common code is wort=
h
making the flow easier to follow.

Putting it all together, something like this?  Compile tested only.

---
 arch/x86/kvm/cpuid.c | 16 ++++++++++++++++
 arch/x86/kvm/x86.c   |  3 +--
 arch/x86/kvm/x86.h   |  1 +
 arch/x86/kvm/xen.c   | 23 -----------------------
 arch/x86/kvm/xen.h   | 13 +++++++++++--
 5 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index edef30359c19..689882326618 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -2005,6 +2005,22 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 =
*ebx,
 		} else if (function =3D=3D 0x80000007) {
 			if (kvm_hv_invtsc_suppressed(vcpu))
 				*edx &=3D ~feature_bit(CONSTANT_TSC);
+		} else if (IS_ENABLED(CONFIG_KVM_XEN) &&
+			   kvm_xen_is_tsc_leaf(vcpu, function)) {
+			/*
+			 * Update guest TSC frequency information is necessary.
+			 * Ignore failures, there is no sane value that can be
+			 * provided if KVM can't get the TSC frequency.
+			 */
+			if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu))
+				kvm_guest_time_update(vcpu);
+
+			if (index =3D=3D 1) {
+				*ecx =3D vcpu->arch.hv_clock.tsc_to_system_mul;
+				*edx =3D vcpu->arch.hv_clock.tsc_shift;
+			} else if (index =3D=3D 2) {
+				*eax =3D vcpu->arch.hw_tsc_khz;
+			}
 		}
 	} else {
 		*eax =3D *ebx =3D *ecx =3D *edx =3D 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f61d71783d07..817a7e522935 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3173,7 +3173,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *=
v,
 	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
 }
=20
-static int kvm_guest_time_update(struct kvm_vcpu *v)
+int kvm_guest_time_update(struct kvm_vcpu *v)
 {
 	unsigned long flags, tgt_tsc_khz;
 	unsigned seq;
@@ -3256,7 +3256,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 				   &vcpu->hv_clock.tsc_shift,
 				   &vcpu->hv_clock.tsc_to_system_mul);
 		vcpu->hw_tsc_khz =3D tgt_tsc_khz;
-		kvm_xen_update_tsc_info(v);
 	}
=20
 	vcpu->hv_clock.tsc_timestamp =3D tsc_timestamp;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7a87c5fc57f1..5fdf32ba9406 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -362,6 +362,7 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcp=
u, int irq, int inc_eip);
 u64 get_kvmclock_ns(struct kvm *kvm);
 uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm);
 bool kvm_get_monotonic_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp);
+int kvm_guest_time_update(struct kvm_vcpu *v);
=20
 int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
 	gva_t addr, void *val, unsigned int bytes,
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a909b817b9c0..ed5c2f088361 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -2247,29 +2247,6 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 	del_timer_sync(&vcpu->arch.xen.poll_timer);
 }
=20
-void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpuid_entry2 *entry;
-	u32 function;
-
-	if (!vcpu->arch.xen.cpuid.base)
-		return;
-
-	function =3D vcpu->arch.xen.cpuid.base | XEN_CPUID_LEAF(3);
-	if (function > vcpu->arch.xen.cpuid.limit)
-		return;
-
-	entry =3D kvm_find_cpuid_entry_index(vcpu, function, 1);
-	if (entry) {
-		entry->ecx =3D vcpu->arch.hv_clock.tsc_to_system_mul;
-		entry->edx =3D vcpu->arch.hv_clock.tsc_shift;
-	}
-
-	entry =3D kvm_find_cpuid_entry_index(vcpu, function, 2);
-	if (entry)
-		entry->eax =3D vcpu->arch.hw_tsc_khz;
-}
-
 void kvm_xen_init_vm(struct kvm *kvm)
 {
 	mutex_init(&kvm->arch.xen.xen_lock);
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index f5841d9000ae..5ee7f3f1b45f 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,6 +9,7 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__
=20
+#include <asm/xen/cpuid.h>
 #include <asm/xen/hypervisor.h>
=20
 #ifdef CONFIG_KVM_XEN
@@ -35,7 +36,6 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe,
 int kvm_xen_setup_evtchn(struct kvm *kvm,
 			 struct kvm_kernel_irq_routing_entry *e,
 			 const struct kvm_irq_routing_entry *ue);
-void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu);
=20
 static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
 {
@@ -50,6 +50,14 @@ static inline void kvm_xen_sw_enable_lapic(struct kvm_vc=
pu *vcpu)
 		kvm_xen_inject_vcpu_vector(vcpu);
 }
=20
+static inline bool kvm_xen_is_tsc_leaf(struct kvm_vcpu *vcpu, u32 function=
)
+{
+	return static_branch_unlikely(&kvm_xen_enabled.key) &&
+	       vcpu->arch.xen.cpuid.base &&
+	       function < vcpu->arch.xen.cpuid.limit &&
+	       function =3D=3D (vcpu->arch.xen.cpuid.base | XEN_CPUID_LEAF(3));
+}
+
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
 	return static_branch_unlikely(&kvm_xen_enabled.key) &&
@@ -157,8 +165,9 @@ static inline bool kvm_xen_timer_enabled(struct kvm_vcp=
u *vcpu)
 	return false;
 }
=20
-static inline void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
+static inline bool kvm_xen_is_tsc_leaf(struct kvm_vcpu *vcpu, u32 function=
)
 {
+	return false;
 }
 #endif
=20

base-commit: 84be94b5b6490e29a6f386cec90f8d5c6d14f0df
--=20

