Return-Path: <kvm+bounces-15581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C83E08ADB03
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 02:25:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FAEB2872FF
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 00:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409F3FC18;
	Tue, 23 Apr 2024 00:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VbRsqxR7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10362D26A
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 00:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713830893; cv=none; b=hgFMHgFhxowDoZOAxlGYSkwwXTW4XA/yNlDODJJgrMSQpdIopcMkCgvg05vDHn0x4mh8nBLROa9Q9jQVcrXs8DUj67w+CzClgJX3nrEKIx5aKFbiYPDYbvv8htxMzqdWdtW1p78BDFLrjknnqggkklHvQeaORsxmP1PXq62BGek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713830893; c=relaxed/simple;
	bh=Cf1ORiW1uFS2EWdaAE3TYopQhrdHIIQ+l0qKHQ1/nQE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iyQO3jAkvQ6fXgh0ehLpU8Mx5s5kBf0dEgBQB7nVT1fSB2fg7VzDDVCwHnsnB278q9xlT1aoPxOHfvdNRb6WkeUYhkIt/0xxiVxL4jvqv8JvUDOW7QoKTb8uhNkTdmncL0/2gwqPeJE55eaJYFsaXP/fzUOsgr9mbj2TOIkRkB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VbRsqxR7; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de51daf900cso3388165276.1
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 17:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713830890; x=1714435690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fSiP+YvaDs3jh62Pfat9l6z4oUHjC0nvbsdrQqrK9Ho=;
        b=VbRsqxR7F2F+2lt1Nxqpfo9yU7Gs46Yp4WWu7v3Wqvg894D9BCteKAIas8Mp2YCwgU
         cfQRiHn+KMG6Myj3/SE79zPrrDSKKQDWi2GdzXX3881Gn9xSYbNHYQdGS4cFV6m40S1a
         ZZyuVp0SnfRBofrYE7Ao36Vpibv6VkhtA6eRCrlCjLZoaxyAyoWS0M07g47pradf7VE3
         q/bCupe+NTXsZDxsDL3HNEmVyW0VuxCs9AsAq1fF8MNpeE+kTcFt7UGwHhb86lY/PEU8
         ZcpJnLsWtVm8hTmWP6oReHKxySMoI8eeXLMLoHhGGaT38RRu4xgY2k9xjpD1XFeW+2GU
         7aIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713830890; x=1714435690;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fSiP+YvaDs3jh62Pfat9l6z4oUHjC0nvbsdrQqrK9Ho=;
        b=vic+SIxpo3E10soXxvsMQ//S+iOEh0bY/enDBjImZ90asx4CPf06NVXGRu95bID4bF
         SY4HifQGbG0OsYgO/RYlfHKVFcglL7T7sptY7E2/HFXhbmi7fRhxy4UPuB7CJcwECKce
         J5lJ78S68KWI4XObmdq1wM2FVPTCs/pkTmrR2whR4F6Xp/8570/ZevoefXJxByIErhec
         s14pblS8rBX+IEdWSYBj1QHNPwtN3pu8XWXQIFjFI1x5XP57JW/BvNbi+qpe5OvL6cX6
         P9oT+Tg9YG28apR9JyJjJMz9ZHjlt9XHXxCPAvc7W5bCdE64pGsjZRltH+JpJGxgPSG3
         jitw==
X-Forwarded-Encrypted: i=1; AJvYcCUKgJm96RF8Jp1OnGYMhIJF/Mr8K5JpytyzLyuvs1EK5LJQuFsytKqIdELf6wi7mITBTZc/oeVGcaTZ2BoqrUxbSUa6
X-Gm-Message-State: AOJu0YzHYUp/Pq7GlI0pa9RswX+4sDM90JzaFqaug1fPU5jmdYO/3LMq
	aVNPBpTMaw5UEWKyBAzAF/MQk/KMSWV9JOVxIwVF34dHXzx9T+SC1CvicyQqZ7ETExh/b3rDdBX
	L6g==
X-Google-Smtp-Source: AGHT+IHU4mCSqnUYaY/a2VAkVJDSAay6oHgaBExG+JDzouNQhDUIgkM4e0T1nws9M+PKKyMHvjkmvaM6Kds=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:fc04:0:b0:dc6:cafd:dce5 with SMTP id
 v4-20020a25fc04000000b00dc6cafddce5mr3192351ybd.12.1713830890077; Mon, 22 Apr
 2024 17:08:10 -0700 (PDT)
Date: Mon, 22 Apr 2024 17:08:08 -0700
In-Reply-To: <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Zh_exbWc90khzmYm@google.com> <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
 <ZiBc13qU6P3OBn7w@google.com> <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
 <ZiEulnEr4TiYQxsB@google.com> <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
 <ZiKoqMk-wZKdiar9@google.com> <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
 <ZiaWMpNm30DD1A-0@google.com> <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
Message-ID: <Zib76LqLfWg3QkwB@google.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	Bo2 Chen <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024, Kai Huang wrote:
> On Mon, 2024-04-22 at 09:54 -0700, Sean Christopherson wrote:
> > On Mon, Apr 22, 2024, Kai Huang wrote:
> > > On Fri, 2024-04-19 at 10:23 -0700, Sean Christopherson wrote:
> > > > On Fri, Apr 19, 2024, Kai Huang wrote:
> > > > And tdx_enable() should also do its best to verify that the caller =
is post-VMXON:
> > > >=20
> > > > 	if (WARN_ON_ONCE(!(__read_cr4() & X86_CR4_VMXE)))
> > > > 		return -EINVAL;
> > >=20
> > > This won't be helpful, or at least isn't sufficient.
> > >=20
> > > tdx_enable() can SEAMCALLs on all online CPUs, so checking "the calle=
r is
> > > post-VMXON" isn't enough.  It needs "checking all online CPUs are in =
post-
> > > VMXON with tdx_cpu_enable() having been done".
> >=20
> > I'm suggesting adding it in the responding code that does that actual S=
EAMCALL.
>=20
> The thing is to check you will need to do additional things like making
> sure no scheduling would happen during "check + make SEAMCALL".  Doesn't
> seem worth to do for me.
>=20
> The intent of tdx_enable() was the caller should make sure no new CPU
> should come online (well this can be relaxed if we move
> cpuhp_setup_state() to hardware_enable_all()), and all existing online
> CPUs are in post-VMXON with tdx_cpu_enable() been done.
>=20
> I think, if we ever need any check, the latter seems to be more
> reasonable.
>=20
> But if we allow new CPU to become online during tdx_enable() (with your
> enhancement to the hardware enabling), then I don't know how to make such
> check at the beginning of tdx_enable(), because do=C2=A0
>=20
> 	on_each_cpu(check_seamcall_precondition, NULL, 1);
>=20
> cannot catch any new CPU during tdx_enable().

Doh, we're talking past each other, because my initial suggestion was half-=
baked.

When I initially said "tdx_enable()", I didn't intend to literally mean jus=
t the
CPU that calls tdx_enable().  What I was trying to say was, when doing per-=
CPU
things when enabling TDX, sanity check that the current CPU has CR4.VMXE=3D=
1 before
doing a SEAMCALL.

Ah, and now I see where the disconnect is.  I was assuming tdx_enable() als=
o did
TDH_SYS_LP_INIT, but that's in a separate chunk of code that's manually inv=
oked
by KVM.  More below.

> > And the intent isn't to catch every possible problem.  As with many san=
ity checks,
> > the intent is to detect the most likely failure mode to make triaging a=
nd debugging
> > issues a bit easier.
>=20
> The SEAMCALL will literally return a unique error code to indicate CPU
> isn't in post-VMXON, or tdx_cpu_enable() hasn't been done.  I think the
> error code is already clear to pinpoint the problem (due to these pre-
> SEAMCALL-condition not being met).

No, SEAMCALL #UDs if the CPU isn't post-VMXON.  I.e. the CPU doesn't make i=
t to
the TDX Module to provide a unique error code, all KVM will see is a #UD.

> > > Btw, I noticed there's another problem, that is currently tdx_cpu_ena=
ble()
> > > actually requires IRQ being disabled.  Again it was implemented based=
 on
> > > it would be invoked via both on_each_cpu() and kvm_online_cpu().
> > >=20
> > > It also also implemented with consideration that it could be called b=
y
> > > multiple in-kernel TDX users in parallel via both SMP call and in nor=
mal
> > > context, so it was implemented to simply request the caller to make s=
ure
> > > it is called with IRQ disabled so it can be IRQ safe  (it uses a perc=
pu
> > > variable to track whether TDH.SYS.LP.INIT has been done for local cpu
> > > similar to the hardware_enabled percpu variable).
> >=20
> > Is this is an actual problem, or is it just something that would need t=
o be
> > updated in the TDX code to handle the change in direction?
>=20
> For now this isn't, because KVM is the solo user, and in KVM
> hardware_enable_all() and kvm_online_cpu() uses kvm_lock mutex to make
> hardware_enable_nolock() IPI safe.
>=20
> I am not sure how TDX/SEAMCALL will be used in TDX Connect.
>=20
> However I needed to consider KVM as a user, so I decided to just make it
> must be called with IRQ disabled so I could know it is IRQ safe.
>=20
> Back to the current tdx_enable() and tdx_cpu_enable(), my personal
> preference is, of course, to keep the existing way, that is:
>=20
> During module load:
>=20
> 	cpus_read_lock();
> 	tdx_enable();
> 	cpus_read_unlock();
>=20
> and in kvm_online_cpu():
>=20
> 	local_irq_save();
> 	tdx_cpu_enable();
> 	local_irq_restore();
>=20
> But given KVM is the solo user now, I am also fine to change if you
> believe this is not acceptable.

Looking more closely at the code, tdx_enable() needs to be called under
cpu_hotplug_lock to prevent *unplug*, i.e. to prevent the last CPU on a pac=
kage
from being offlined.  I.e. that part's not option.

And the root of the problem/confusion is that the APIs provided by the core=
 kernel
are weird, which is really just a polite way of saying they are awful :-)

There is no reason to rely on the caller to take cpu_hotplug_lock, and defi=
nitely
no reason to rely on the caller to invoke tdx_cpu_enable() separately from =
invoking
tdx_enable().  I suspect they got that way because of KVM's unnecessarily c=
omplex
code, e.g. if KVM is already doing on_each_cpu() to do VMXON, then it's eas=
y enough
to also do TDH_SYS_LP_INIT, so why do two IPIs?

But just because KVM "owns" VMXON doesn't mean the core kernel code should =
punt
TDX to KVM too.  If KVM relies on the cpuhp code to ensure all online CPUs =
are
post-VMXON, then the TDX shapes up nicely and provides a single API to enab=
le
TDX.  And then my CR4.VMXE=3D1 sanity check makes a _lot_ more sense.

Relative to some random version of the TDX patches, this is what I'm thinki=
ng:

---
 arch/x86/kvm/vmx/tdx.c      | 46 +++----------------
 arch/x86/virt/vmx/tdx/tdx.c | 89 ++++++++++++++++++-------------------
 2 files changed, 49 insertions(+), 86 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a1d3ae09091c..137d08da43c3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3322,38 +3322,8 @@ bool tdx_is_vm_type_supported(unsigned long type)
 	return type =3D=3D KVM_X86_TDX_VM;
 }
=20
-struct tdx_enabled {
-	cpumask_var_t enabled;
-	atomic_t err;
-};
-
-static void __init tdx_on(void *_enable)
-{
-	struct tdx_enabled *enable =3D _enable;
-	int r;
-
-	r =3D vmx_hardware_enable();
-	if (!r) {
-		cpumask_set_cpu(smp_processor_id(), enable->enabled);
-		r =3D tdx_cpu_enable();
-	}
-	if (r)
-		atomic_set(&enable->err, r);
-}
-
-static void __init vmx_off(void *_enabled)
-{
-	cpumask_var_t *enabled =3D (cpumask_var_t *)_enabled;
-
-	if (cpumask_test_cpu(smp_processor_id(), *enabled))
-		vmx_hardware_disable();
-}
-
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 {
-	struct tdx_enabled enable =3D {
-		.err =3D ATOMIC_INIT(0),
-	};
 	int max_pkgs;
 	int r =3D 0;
 	int i;
@@ -3409,17 +3379,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x=
86_ops)
 		goto out;
 	}
=20
-	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
-	cpus_read_lock();
-	on_each_cpu(tdx_on, &enable, true); /* TDX requires vmxon. */
-	r =3D atomic_read(&enable.err);
-	if (!r)
-		r =3D tdx_module_setup();
-	else
-		r =3D -EIO;
-	on_each_cpu(vmx_off, &enable.enabled, true);
-	cpus_read_unlock();
-	free_cpumask_var(enable.enabled);
+	r =3D tdx_enable();
+	if (r)
+		goto out;
+
+	r =3D tdx_module_setup();
 	if (r)
 		goto out;
=20
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index d2b8f079a637..19897f736c47 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -139,49 +139,6 @@ static int try_init_module_global(void)
 	return sysinit_ret;
 }
=20
-/**
- * tdx_cpu_enable - Enable TDX on local cpu
- *
- * Do one-time TDX module per-cpu initialization SEAMCALL (and TDX module
- * global initialization SEAMCALL if not done) on local cpu to make this
- * cpu be ready to run any other SEAMCALLs.
- *
- * Always call this function via IPI function calls.
- *
- * Return 0 on success, otherwise errors.
- */
-int tdx_cpu_enable(void)
-{
-	struct tdx_module_args args =3D {};
-	int ret;
-
-	if (!boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
-		return -ENODEV;
-
-	lockdep_assert_irqs_disabled();
-
-	if (__this_cpu_read(tdx_lp_initialized))
-		return 0;
-
-	/*
-	 * The TDX module global initialization is the very first step
-	 * to enable TDX.  Need to do it first (if hasn't been done)
-	 * before the per-cpu initialization.
-	 */
-	ret =3D try_init_module_global();
-	if (ret)
-		return ret;
-
-	ret =3D seamcall_prerr(TDH_SYS_LP_INIT, &args);
-	if (ret)
-		return ret;
-
-	__this_cpu_write(tdx_lp_initialized, true);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(tdx_cpu_enable);
-
 /*
  * Add a memory region as a TDX memory block.  The caller must make sure
  * all memory regions are added in address ascending order and don't
@@ -1201,6 +1158,43 @@ static int init_tdx_module(void)
 	goto out_put_tdxmem;
 }
=20
+/**
+ * Do one-time TDX module per-cpu initialization SEAMCALL (and TDX module
+ * global initialization SEAMCALL if not done) on local cpu to make this
+ * cpu be ready to run any other SEAMCALLs.
+ */
+static void tdx_cpu_enable(void *__err)
+{
+	struct tdx_module_args args =3D {};
+	atomic_t err =3D __err;
+	int ret;
+
+	if (__this_cpu_read(tdx_lp_initialized))
+		return;
+
+	if (WARN_ON_ONCE(!(__read_cr4() & X86_CR4_VMXE)))
+		goto failed;
+
+	/*
+	 * The TDX module global initialization is the very first step
+	 * to enable TDX.  Need to do it first (if hasn't been done)
+	 * before the per-cpu initialization.
+	 */
+	ret =3D try_init_module_global();
+	if (ret)
+		goto failed;
+
+	ret =3D seamcall_prerr(TDH_SYS_LP_INIT, &args);
+	if (ret)
+		goto failed;
+
+	__this_cpu_write(tdx_lp_initialized, true);
+	return;
+
+failed:
+	atomic_inc(err);
+}
+
 static int __tdx_enable(void)
 {
 	int ret;
@@ -1234,15 +1228,19 @@ static int __tdx_enable(void)
  */
 int tdx_enable(void)
 {
+	atomic_t err =3D ATOMIC_INIT(0);
 	int ret;
=20
 	if (!boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
 		return -ENODEV;
=20
-	lockdep_assert_cpus_held();
-
+	cpus_read_lock();
 	mutex_lock(&tdx_module_lock);
=20
+	on_each_cpu(tdx_cpu_enable, &err, true);
+	if (atomic_read(&err))
+		tdx_module_status =3D TDX_MODULE_ERROR;
+
 	switch (tdx_module_status) {
 	case TDX_MODULE_UNINITIALIZED:
 		ret =3D __tdx_enable();
@@ -1258,6 +1256,7 @@ int tdx_enable(void)
 	}
=20
 	mutex_unlock(&tdx_module_lock);
+	cpus_read_unlock();
=20
 	return ret;
 }

base-commit: fde917bc1af3e1a440ab0cb0d9364f8da25b9e17
--=20


