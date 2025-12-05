Return-Path: <kvm+bounces-65347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 15FB4CA82F4
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 16:28:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EFCE83045244
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 15:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95F833BBAC;
	Fri,  5 Dec 2025 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FoolOGVf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0957C32D43F
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 15:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946985; cv=none; b=W0tY+9OdfrcVpzmD8I0AmYeDgGkCO1AyBhbnfvT1ga2EPCboSXwdhmAPOga2o7H4A45sgbtTOYDPTGj5qFvvRmt5pOX+8/cas7LxeAn6k9ri3vPoq6xpk9ENdl/SP3LH69nz0ziOELdReqwtVySrhnZMUZ85UJmAkGHI6VY6DQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946985; c=relaxed/simple;
	bh=3xapohOrSIZRT+JHshHypgVtGlI3T/Janydy7Vpdfko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JNXrbRFpHwWNdvo1UFuuWRsfL1SMyXSv17yAlSQYTVENvAU+j38u9e1hWXZmA9pfbhZNcSKoJ1DBza2Q82DUFNzvDYfzvT5HOMADp1aBy3yGzOZ4bP7ExHdFKlctJNsMXre8Z4odvWIAzSFLkgEWGX0Ebe5MMP8DhYVy5iDUkiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FoolOGVf; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34385d7c4a7so1495051a91.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 07:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764946980; x=1765551780; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mlronA36IJ2M3yhWzdAx4gw45wCVc8Nt8asq71S1AXs=;
        b=FoolOGVfuA+8+awk3YfH5MMSec4hD6Ib1/yIFtnhcCRkQN6JjQ+3Oi/4AC7OnpQXPx
         FY1/aADHA/Opkcb/a25+jDvdPAkrppvpXZ5rBZBFtAoiEMChB6fNxoNshhxkNder9TB1
         z/s1jjPgIVbBQ8CVLFGHsGaTVU/Sy5RoNM2joroHlb/HLQgIftwnUew5xt+kMvQ5tjyO
         EOxiPkPOmxppE/W0Z7vuGM2xX9fJB4Lbi8+1A7Yjd+2d2WTooxXP66L+6nON23yga8wr
         Pa5MwHny4kYifRe22b7i/7g6z6YS6wHPWuiOKWYr51qUSL/q2FcpzGfQfSK7sbChOu9l
         /dFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946980; x=1765551780;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mlronA36IJ2M3yhWzdAx4gw45wCVc8Nt8asq71S1AXs=;
        b=sam/VsUcc8Amqud3mBFNwcCoc2Mvlea+n5YzKlEuClVMlG56XIMLJlmB1kSPpLClrr
         lhUGk3+7awjsHyaz+PgXtZwSGruEO754o+V1WntoH0eAjjSzPTgvdOpZw/4DQY4pU3GK
         r8aTxQlUaAj35t/OFSSOTTlFuuFU6XJpOoyZ18X2PwV3YvF0+pZ5I29ME0nw8DCVSyG9
         Iz5U3zKeAHUbkt2L8jw2fqNGrl0xqGRRGPNxcSOJ13NVJimbOtFYGLaxonQ17nRwVTI/
         BH143UfD042q99cOUDwtkmNP9jqNIZflLiDYEHuQpc01naRKiaEmp4J1YuvHPjcLFTm4
         f4IQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+WqBw40oSw7P8KmT6JM8RJAFZ/5A30xZXq3GnNpKpPFnOeFxVrtjSlSW25PNNEBuQhJU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwiPKRNwFj5DI38ayHQQwVT8MoOgMRUplDqIsJa844YR4qYiMX
	+zqqr6AlWXG4gBrJ+XMe1Cw7zxl3hYZVHActEmSgFmAp3tmgMjHd7rTm8ediHKKCSJiFlpVSEeY
	L2BSTlA==
X-Google-Smtp-Source: AGHT+IGWZqc+hRFYndTXiDGdpm3mc7j4kqnqgVs0UPiQPMHG/fJyWFnmnQsZfQPLkenHK5IuVNLxnQTDzWI=
X-Received: from pjdw15.prod.google.com ([2002:a17:90a:15cf:b0:340:ac4b:f19a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d00e:b0:340:8d99:49d4
 with SMTP id 98e67ed59e1d1-34943853806mr7358844a91.1.1764946980039; Fri, 05
 Dec 2025 07:03:00 -0800 (PST)
Date: Fri, 5 Dec 2025 07:02:58 -0800
In-Reply-To: <34048508-8ddd-4183-9d0d-f495af1984ab@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205074537.17072-1-jgross@suse.com> <20251205074537.17072-6-jgross@suse.com>
 <877bv1kz1a.fsf@redhat.com> <34048508-8ddd-4183-9d0d-f495af1984ab@suse.com>
Message-ID: <aTL0ItlXp5gRi6Q8@google.com>
Subject: Re: [PATCH 05/10] KVM/x86: Add KVM_MSR_RET_* defines for values 0 and 1
From: Sean Christopherson <seanjc@google.com>
To: "=?utf-8?B?SsO8cmdlbiBHcm/Dnw==?=" <jgross@suse.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 05, 2025, J=C3=BCrgen Gro=C3=9F wrote:
> On 05.12.25 11:23, Vitaly Kuznetsov wrote:
> > Juergen Gross <jgross@suse.com> writes:
> >=20
> > > For MSR emulation return values only 2 special cases have defines,
> > > while the most used values 0 and 1 don't.
> > >=20
> > > Reason seems to be the maze of function calls of MSR emulation
> > > intertwined with the KVM guest exit handlers, which are using the
> > > values 0 and 1 for other purposes. This even led to the comment above
> > > the already existing defines, warning to use the values 0 and 1 (and
> > > negative errno values) in the MSR emulation at all.
> > >=20
> > > Fact is that MSR emulation and exit handlers are in fact rather well
> > > distinct, with only very few exceptions which are handled in a sane
> > > way.
> > >=20
> > > So add defines for 0 and 1 values of MSR emulation and at the same
> > > time comments where exit handlers are calling into MSR emulation.
> > >=20
> > > The new defines will be used later.
> > >=20
> > > No change of functionality intended.
> > >=20
> > > Signed-off-by: Juergen Gross <jgross@suse.com>
> > > ---
> > >   arch/x86/kvm/x86.c |  2 ++
> > >   arch/x86/kvm/x86.h | 10 ++++++++--
> > >   2 files changed, 10 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index e733cb923312..e87963a47aa5 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -2130,6 +2130,7 @@ static int __kvm_emulate_rdmsr(struct kvm_vcpu =
*vcpu, u32 msr, int reg,
> > >   	u64 data;
> > >   	int r;
> > > +	/* Call MSR emulation. */

Why?  The function name makes it pretty clear its doing MSR emulation.

> > >   	r =3D kvm_emulate_msr_read(vcpu, msr, &data);
> > >   	if (!r) {
> > > @@ -2171,6 +2172,7 @@ static int __kvm_emulate_wrmsr(struct kvm_vcpu =
*vcpu, u32 msr, u64 data)
> > >   {
> > >   	int r;
> > > +	/* Call MSR emulation. */
> > >   	r =3D kvm_emulate_msr_write(vcpu, msr, data);
> > >   	if (!r) {
> > >   		trace_kvm_msr_write(msr, data);
> > > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > > index f3dc77f006f9..e44b6373b106 100644
> > > --- a/arch/x86/kvm/x86.h
> > > +++ b/arch/x86/kvm/x86.h
> > > @@ -639,15 +639,21 @@ enum kvm_msr_access {
> > >   /*
> > >    * Internal error codes that are used to indicate that MSR emulatio=
n encountered
> > >    * an error that should result in #GP in the guest, unless userspac=
e handles it.
> > > - * Note, '1', '0', and negative numbers are off limits, as they are =
used by KVM
> > > - * as part of KVM's lightly documented internal KVM_RUN return codes=
.
> > > + * Note, negative errno values are possible for return values, too.
> > > + * In case MSR emulation is called from an exit handler, any return =
value other
> > > + * than KVM_MSR_RET_OK will normally result in a GP in the guest.
> > >    *
> > > + * OK		- Emulation succeeded. Must be 0, as in some cases return val=
ues
> > > + *		  of functions returning 0 or -errno will just be passed on.

This is (dangerously) misleading due to KVM's use of -errno/0/1 to communic=
ate
whether to exit to userspace or return to the guest.  E.g. my first read of=
 it
is that you meant "will just be passed on up the stack to vcpu_enter_guest(=
)",
but that's flat out wrong because returning KVM_MSR_RET_OK would generate a=
n
unexpected userspace exit.

IMO, the real reason '0' is special is because of the myriad code that trea=
ts
'0' as success and everything else as failure.  E.g. making KVM_MSR_RET_OK =
a
non-zero value would break code like this:

	r =3D kvm_emulate_msr_read(vcpu, msr, &data);
	if (!r) {
		<happy path>
	} else {
		<sad path>
	}

> > > + * ERR		- Some error occurred.

And this is partly why the conversion stalled out.  *All* of the non-zero v=
alues
report an error of some kind.  This really should be something like KVM_MSR=
_RET_INVALID
or KVM_MSR_RET_FAULTED, but using such precise names would result in "bad" =
code,
e.g. due to many flows returning '1' when they really mean KVM_MSR_RET_UNSU=
PPORTED.

> > >    * UNSUPPORTED	- The MSR isn't supported, either because it is comp=
letely
> > >    *		  unknown to KVM, or because the MSR should not exist according
> > >    *		  to the vCPU model.
> > >    *
> > >    * FILTERED	- Access to the MSR is denied by a userspace MSR filter=
.
> > >    */
> > > +#define  KVM_MSR_RET_OK			0
> > > +#define  KVM_MSR_RET_ERR		1
> > >   #define  KVM_MSR_RET_UNSUPPORTED	2
> > >   #define  KVM_MSR_RET_FILTERED		3
> >=20
> > I like the general idea of the series as 1/0 can indeed be
> > confusing. What I'm wondering is if we can do better by changing 'int'
> > return type to something else. I.e. if the result of the function can b=
e
> > 'passed on' and KVM_MSR_RET_OK/KVM_MSR_RET_ERR have one meaning while
> > KVM_MSR_RET_UNSUPPORTED/KVM_MSR_RET_FILTERED have another, maybe we can
> > do better by changing the return type to something and then, when the
> > value needs to be passed on, do proper explicit vetting of the result
> > (e.g. to make sure only 1/0 pass through)? Just a thought, I think the
> > series as-is makes things better and we can go with it for now.
>=20
> The pass through case is always 0 or -errno, never the "1" (and of course
> KVM_MSR_RET_*/-errno).
>=20
> Changing from int to something else would probably require some helpers
> for e.g. stuffing something like -EINVAL into it. An enum alone wouldn't
> work for this, so it would need to be a specific new type, like a union
> of an int (for the -errno) and an enum, but I believe this would make the
> code harder to read instead of improving it.

Hmm, for this specify case I probably agree it's not worth hardening.

But for the the broader -errno/0/1 pattern, I think enforcing the return ty=
pe
would would be a huge net positive.  AFAICT, by far the biggest problem is =
the
sheer amount of code that needs to be updated, because truly hardening the =
returns
will disallow implicit casts and comparisons.  Which is a good thing (and k=
inda
the whole point), it just makes it hard to do incremental conversions.

We might still be able to do a somewhat incremental conversion by working "=
ground
up", i.e. by starting from the lowest helpers and "pausing" the conversion =
at
convienent choke points.  But that may or may not be better than going stra=
ight
to a full conversion.

And to help guard against goof during the transition, we could add e.g.
CONFIG_KVM_PROVE_RUN to generate off-by-default WARNs on bad return values.

E.g. drawing nomenclature from fastpath_t, with a deliberately terse typede=
f name
(to keep function prototypes short) and a bit of macro magic:

---
 arch/x86/include/asm/kvm_host.h | 17 +++++++++
 arch/x86/kvm/vmx/vmx.c          | 65 +++++++++++++++------------------
 2 files changed, 47 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 5a3bfa293e8b..0b9f47669db3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -222,6 +222,23 @@ enum exit_fastpath_completion {
 };
 typedef enum exit_fastpath_completion fastpath_t;
=20
+typedef struct { int r; } run_t;
+#define KVM_RUN_ERR(err) ({ static_assert(err < 0); (run_t) { .r =3D err }=
; })
+#define KVM_RUN_EXIT_USERSPACE ({ (run_t) { .r =3D 0 }; })
+#define KVM_RUN_REENTER_GUEST ({ (run_t) { .r =3D 1 }; })
+
+#ifdef CONFIG_KVM_PROVE_RUN
+#define KVM_RUN_WARN_ON(x) WARN_ON_ONCE(x)
+#else
+#define KVM_RUN_WARN_ON(x) BUILD_BUG_ON_INVALID(x)
+#endif
+
+static __always_inline bool KVM_REENTER_GUEST(run_t ret)
+{
+	KVM_RUN_WARN_ON(ret.r && ret.r > 1);
+	return ret.r > 0;
+}
+
 struct x86_emulate_ctxt;
 struct x86_exception;
 union kvm_smram;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ef8d29c677b9..fdee70f6a0a8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5958,16 +5958,16 @@ static int handle_ept_misconfig(struct kvm_vcpu *vc=
pu)
 	return kvm_mmu_page_fault(vcpu, gpa, PFERR_RSVD_MASK, NULL, 0);
 }
=20
-static int handle_nmi_window(struct kvm_vcpu *vcpu)
+static run_t handle_nmi_window(struct kvm_vcpu *vcpu)
 {
 	if (KVM_BUG_ON(!enable_vnmi, vcpu->kvm))
-		return -EIO;
+		return KVM_RUN_ERR(-EIO);
=20
 	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
 	++vcpu->stat.nmi_window_exits;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
=20
-	return 1;
+	return KVM_RUN_REENTER_GUEST;
 }
=20
 /*
@@ -6187,20 +6187,20 @@ static int handle_preemption_timer(struct kvm_vcpu =
*vcpu)
  * When nested=3D0, all VMX instruction VM Exits filter here.  The handler=
s
  * are overwritten by nested_vmx_hardware_setup() when nested=3D1.
  */
-static int handle_vmx_instruction(struct kvm_vcpu *vcpu)
+static run_t handle_vmx_instruction(struct kvm_vcpu *vcpu)
 {
 	kvm_queue_exception(vcpu, UD_VECTOR);
-	return 1;
+	return KVM_RUN_REENTER_GUEST;
 }
=20
-static int handle_tdx_instruction(struct kvm_vcpu *vcpu)
+static run_t handle_tdx_instruction(struct kvm_vcpu *vcpu)
 {
 	kvm_queue_exception(vcpu, UD_VECTOR);
-	return 1;
+	return KVM_RUN_REENTER_GUEST;
 }
=20
 #ifndef CONFIG_X86_SGX_KVM
-static int handle_encls(struct kvm_vcpu *vcpu)
+static run_t handle_encls(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * SGX virtualization is disabled.  There is no software enable bit for
@@ -6208,11 +6208,11 @@ static int handle_encls(struct kvm_vcpu *vcpu)
 	 * the guest from executing ENCLS (when SGX is supported by hardware).
 	 */
 	kvm_queue_exception(vcpu, UD_VECTOR);
-	return 1;
+	return KVM_RUN_REENTER_GUEST;
 }
 #endif /* CONFIG_X86_SGX_KVM */
=20
-static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
+static run_t handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * Hardware may or may not set the BUS_LOCK_DETECTED flag on BUS_LOCK
@@ -6220,10 +6220,10 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *=
vcpu)
 	 * vmx_handle_exit().
 	 */
 	to_vt(vcpu)->exit_reason.bus_lock_detected =3D true;
-	return 1;
+	return KVM_RUN_REENTER_GUEST;
 }
=20
-static int handle_notify(struct kvm_vcpu *vcpu)
+static run_t handle_notify(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qual =3D vmx_get_exit_qual(vcpu);
 	bool context_invalid =3D exit_qual & NOTIFY_VM_CONTEXT_INVALID;
@@ -6243,10 +6243,10 @@ static int handle_notify(struct kvm_vcpu *vcpu)
 		vcpu->run->exit_reason =3D KVM_EXIT_NOTIFY;
 		vcpu->run->notify.flags =3D context_invalid ?
 					  KVM_NOTIFY_CONTEXT_INVALID : 0;
-		return 0;
+		return KVM_RUN_EXIT_USERSPACE;
 	}
=20
-	return 1;
+	return KVM_RUN_REENTER_GUEST;
 }
=20
 static int vmx_get_msr_imm_reg(struct kvm_vcpu *vcpu)
@@ -6254,24 +6254,19 @@ static int vmx_get_msr_imm_reg(struct kvm_vcpu *vcp=
u)
 	return vmx_get_instr_info_reg(vmcs_read32(VMX_INSTRUCTION_INFO));
 }
=20
-static int handle_rdmsr_imm(struct kvm_vcpu *vcpu)
+static run_t handle_rdmsr_imm(struct kvm_vcpu *vcpu)
 {
 	return kvm_emulate_rdmsr_imm(vcpu, vmx_get_exit_qual(vcpu),
 				     vmx_get_msr_imm_reg(vcpu));
 }
=20
-static int handle_wrmsr_imm(struct kvm_vcpu *vcpu)
+static run_t handle_wrmsr_imm(struct kvm_vcpu *vcpu)
 {
 	return kvm_emulate_wrmsr_imm(vcpu, vmx_get_exit_qual(vcpu),
 				     vmx_get_msr_imm_reg(vcpu));
 }
=20
-/*
- * The exit handlers return 1 if the exit was handled fully and guest exec=
ution
- * may resume.  Otherwise they set the kvm_run parameter to indicate what =
needs
- * to be done to userspace and return 0.
- */
-static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) =3D {
+static run_t (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) =3D {
 	[EXIT_REASON_EXCEPTION_NMI]           =3D handle_exception_nmi,
 	[EXIT_REASON_EXTERNAL_INTERRUPT]      =3D handle_external_interrupt,
 	[EXIT_REASON_TRIPLE_FAULT]            =3D handle_triple_fault,
@@ -6641,7 +6636,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
  * The guest has exited.  See if we can fix it or if we need userspace
  * assistance.
  */
-static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpa=
th)
+static run_t __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fast=
path)
 {
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
 	union vmx_exit_reason exit_reason =3D vmx_get_exit_reason(vcpu);
@@ -6666,7 +6661,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, f=
astpath_t exit_fastpath)
 	 * allowed a nested VM-Enter with an invalid vmcs12.  More below.
 	 */
 	if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
-		return -EIO;
+		return KVM_RUN_ERR(-EIO);
=20
 	if (is_guest_mode(vcpu)) {
 		/*
@@ -6702,11 +6697,11 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu,=
 fastpath_t exit_fastpath)
 		 */
 		if (vmx->vt.emulation_required) {
 			nested_vmx_vmexit(vcpu, EXIT_REASON_TRIPLE_FAULT, 0, 0);
-			return 1;
+			return KVM_RUN_REENTER_GUEST;
 		}
=20
 		if (nested_vmx_reflect_vmexit(vcpu))
-			return 1;
+			return KVM_RUN_REENTER_GUEST;
 	}
=20
 	/* If guest state is invalid, start emulating.  L2 is handled above. */
@@ -6719,7 +6714,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, f=
astpath_t exit_fastpath)
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			=3D exit_reason.full;
 		vcpu->run->fail_entry.cpu =3D vcpu->arch.last_vmentry_cpu;
-		return 0;
+		return KVM_RUN_EXIT_USERSPACE;
 	}
=20
 	if (unlikely(vmx->fail)) {
@@ -6728,7 +6723,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, f=
astpath_t exit_fastpath)
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			=3D vmcs_read32(VM_INSTRUCTION_ERROR);
 		vcpu->run->fail_entry.cpu =3D vcpu->arch.last_vmentry_cpu;
-		return 0;
+		return KVM_RUN_EXIT_USERSPACE;
 	}
=20
 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
@@ -6740,7 +6735,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, f=
astpath_t exit_fastpath)
 	     exit_reason.basic !=3D EXIT_REASON_NOTIFY &&
 	     exit_reason.basic !=3D EXIT_REASON_EPT_MISCONFIG)) {
 		kvm_prepare_event_vectoring_exit(vcpu, INVALID_GPA);
-		return 0;
+		return KVM_RUN_EXIT_USERSPACE;
 	}
=20
 	if (unlikely(!enable_vnmi &&
@@ -6763,7 +6758,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, f=
astpath_t exit_fastpath)
 	}
=20
 	if (exit_fastpath !=3D EXIT_FASTPATH_NONE)
-		return 1;
+		return KVM_RUN_REENTER_GUEST;
=20
 	if (exit_reason.basic >=3D kvm_vmx_max_exit_handlers)
 		goto unexpected_vmexit;
@@ -6794,25 +6789,25 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu,=
 fastpath_t exit_fastpath)
 unexpected_vmexit:
 	dump_vmcs(vcpu);
 	kvm_prepare_unexpected_reason_exit(vcpu, exit_reason.full);
-	return 0;
+	return KVM_RUN_EXIT_USERSPACE;
 }
=20
 int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
-	int ret =3D __vmx_handle_exit(vcpu, exit_fastpath);
+	run_t ret =3D __vmx_handle_exit(vcpu, exit_fastpath);
=20
 	/*
 	 * Exit to user space when bus lock detected to inform that there is
 	 * a bus lock in guest.
 	 */
 	if (vmx_get_exit_reason(vcpu).bus_lock_detected) {
-		if (ret > 0)
+		if (KVM_REENTER_GUEST(ret))
 			vcpu->run->exit_reason =3D KVM_EXIT_X86_BUS_LOCK;
=20
 		vcpu->run->flags |=3D KVM_RUN_X86_BUS_LOCK;
-		return 0;
+		return KVM_RUN_EXIT_USERSPACE.r;
 	}
-	return ret;
+	return ret.r;
 }
=20
 void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)

base-commit: 99e111dd57b5e5d4c673164f9026ea96eedc9adf
--=20

