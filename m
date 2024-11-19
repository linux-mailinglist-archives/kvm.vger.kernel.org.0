Return-Path: <kvm+bounces-32050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 691F89D2731
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 14:44:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDDF1284599
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 13:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D831CC8A7;
	Tue, 19 Nov 2024 13:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mmiKvVhn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1DC1C57B2
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 13:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732023853; cv=none; b=PGPJ0zqj75X/PsTCP8ffBBMD5kWorB8Mr9nSnWi28V2G3HjKUwS9mmTrEBfkl5Xj+Qb+lkG8HZDzIynPovD/nc0l0O4Lx847qrXQVRnKy/w6giIIRevbMV/dapxFFCJMdco/L5XN5woSADDJj+DBO6hfJYNWKnvdgoGpl1hzXO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732023853; c=relaxed/simple;
	bh=u06XGTZbxb3oXJKlyll3G+tbzotpOuuYrSpxrl9DZQw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gX64tr/4yC4Yg/Kpy0GpnrqbxbOVbY4Wn0XgU1JahiLyha6uN/9AA2O+YqvBISuZrd/E1BP+amxNYucXM2si94aKXFDSEAgRPttyINhathspf7uIu+E5QdD5D/tDugsm0VDj4BNfduhzQVAoeV71rPJWjFCZtDej6wEZCbImkXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mmiKvVhn; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e388c4bd92bso4236915276.1
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 05:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732023851; x=1732628651; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5CkBUuaeP2+eh+1nuZsk4/gpv7iDku/8q2+t4vG3IRg=;
        b=mmiKvVhnRI4CxfmNEtrqVRcBSBgcVXP76T4PDrwP5YQfhBkhsCdKtLcd+zjsr/NWVj
         Vx93AJQ9SQldUOHGh0EQzYcIX3e7pade7FRZYktTXz6lFTaE9Dg4qGh+u9YyWnEtT/0C
         i6oQQOV/kolR016B9Q/ilPqFARLr7P105LPgl5l4+aj76hLVAMPQ1CDrjIBNu/z4ZlE+
         UFtKsyzTYFKmwjcwNo0+IvDmuHmv/5kZ4/S0jhQ9Z6Af4Ie2/ZwVDfVVhJ2A3OYqbFM+
         8jpsYJLEhd3ytZtIPQe0A27Pw7T7wUMQKNMOwv6WRhbRyp46SzQzxgb/tDbtkZgZIuPN
         9i5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732023851; x=1732628651;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5CkBUuaeP2+eh+1nuZsk4/gpv7iDku/8q2+t4vG3IRg=;
        b=LwSo3xqSBixsNM5RHcLG3urhL0DiEUAhob7GUSz8g8MkHtfZxnCBXnmpZh3kH9EboG
         nEomMaJHhtAkpHxRngq4umoJ79gCJXjb/l0S97dP3ru8EqEhftoKNthXSOWC6/9dTdjQ
         f9GCuD47rDauZNtS+Bsz3+oF/1BPA96sDJeZ5IwoelTyx2k8WEXm4+9VdgjRneBojF1U
         jCODMyTrjup/V4GTkA0Gn3yZTZOXs9oDS3w5Ft6URgcsfC1DbxfC+SFyMDNlbYQbA8Fz
         BN5fXC2Efy62q+T3RscWk7U4BNAvQqzfIubKqoRWu5a9sAdREJWolqAiv2RZIgJWk2lO
         6moA==
X-Forwarded-Encrypted: i=1; AJvYcCVa5ld6T8RnrgapORZKSp4aUCUL2a0zYk1Xkg+WlGZ0zx67QAv9J9aHvrfNRNPPU6H2gSA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzkq6wJH7FzLG8gM42673y4oEEYd8QQlDliTvwkc9yhmNM+Wp/H
	w9nkxTE7HU+wtMGgwhtpnEPptW10cHTAjIBy8zLYNaVRcuqO9u0jmBjcisvt/ZOCfhkWXPT7xHr
	JOg==
X-Google-Smtp-Source: AGHT+IHpDGRiUSA5RDravQEdPZmbfx93BH1B54BaMEZPvlDiKyKrhIp1+KFD17MAnezPh1tiOHFxtBw3iEM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:c5c3:0:b0:e25:5cb1:77cd with SMTP id
 3f1490d57ef6-e3826612092mr243804276.10.1732023850425; Tue, 19 Nov 2024
 05:44:10 -0800 (PST)
Date: Tue, 19 Nov 2024 05:44:09 -0800
In-Reply-To: <67013550-9739-4943-812f-4ba6f01e4fb4@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-38-mizhang@google.com>
 <5309ec1b-edc6-4e59-af88-b223dbf2a455@intel.com> <c21d02a3-4315-41f4-b873-bf28041a0d82@linux.intel.com>
 <Zzvt_fNw0U34I9bJ@google.com> <67013550-9739-4943-812f-4ba6f01e4fb4@linux.intel.com>
Message-ID: <ZzyWKTMdNi5YjvEM@google.com>
Subject: Re: [RFC PATCH v3 37/58] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL
 at VM boundary
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Zide Chen <zide.chen@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>, 
	Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>, 
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024, Dapeng Mi wrote:
>=20
> On 11/19/2024 9:46 AM, Sean Christopherson wrote:
> > On Fri, Oct 25, 2024, Dapeng Mi wrote:
> >> On 10/25/2024 4:26 AM, Chen, Zide wrote:
> >>> On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
> >>>
> >>>> @@ -7295,6 +7299,46 @@ static void atomic_switch_perf_msrs(struct vc=
pu_vmx *vmx)
> >>>>  					msrs[i].host, false);
> >>>>  }
> >>>> =20
> >>>> +static void save_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vm=
x *vmx)
> >>>> +{
> >>>> +	struct kvm_pmu *pmu =3D vcpu_to_pmu(&vmx->vcpu);
> >>>> +	int i;
> >>>> +
> >>>> +	if (vm_exit_controls_get(vmx) & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL=
) {
> >>>> +		pmu->global_ctrl =3D vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
> >>> As commented in patch 26, compared with MSR auto save/store area
> >>> approach, the exec control way needs one relatively expensive VMCS re=
ad
> >>> on every VM exit.
> >> Anyway, let us have a evaluation and data speaks.
> > No, drop the unconditional VMREAD and VMWRITE, one way or another.  No =
benchmark
> > will notice ~50 extra cycles, but if we write poor code for every featu=
re, those
> > 50 cycles per feature add up.
> >
> > Furthermore, checking to see if the CPU supports the load/save VMCS con=
trols at
> > runtime beyond ridiculous.  The mediated PMU requires ***VERSION 4***; =
if a CPU
> > supports PMU version 4 and doesn't support the VMCS controls, KVM shoul=
d yell and
> > disable the passthrough PMU.  The amount of complexity added here to su=
pport a
> > CPU that should never exist is silly.
> >
> >>>> +static void load_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vm=
x *vmx)
> >>>> +{
> >>>> +	struct kvm_pmu *pmu =3D vcpu_to_pmu(&vmx->vcpu);
> >>>> +	u64 global_ctrl =3D pmu->global_ctrl;
> >>>> +	int i;
> >>>> +
> >>>> +	if (vm_entry_controls_get(vmx) & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CT=
RL) {
> >>>> +		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, global_ctrl);
> >>> ditto.
> >>>
> >>> We may optimize it by introducing a new flag pmu->global_ctrl_dirty a=
nd
> >>> update GUEST_IA32_PERF_GLOBAL_CTRL only when it's needed.  But this
> >>> makes the code even more complicated.
> > I haven't looked at surrounding code too much, but I guarantee there's =
_zero_
> > reason to eat a VMWRITE+VMREAD on every transition.  If, emphasis on *i=
f*, KVM
> > accesses PERF_GLOBAL_CTRL frequently, e.g. on most exits, then add a VC=
PU_EXREG_XXX
> > and let KVM's caching infrastructure do the heavy lifting.  Don't reinv=
ent the
> > wheel.  But first, convince the world that KVM actually accesses the MS=
R somewhat
> > frequently.
>=20
> Sean, let me give more background here.
>=20
> VMX supports two ways to save/restore PERF_GLOBAL_CTRL MSR, one is to
> leverage VMCS_EXIT_CTRL/VMCS_ENTRY_CTRL to save/restore guest
> PERF_GLOBAL_CTRL value to/from VMCS guest state. The other is to use the
> VMCS MSR auto-load/restore bitmap to save/restore guest PERF_GLOBAL_CTRL.=
=C2=A0

I know.

> Currently we prefer to use the former way to save/restore guest
> PERF_GLOBAL_CTRL as long as HW supports it. There is a limitation on the
> MSR auto-load/restore feature. When there are multiple MSRs, the MSRs are
> saved/restored in the order of MSR index. As the suggestion of SDM,
> PERF_GLOBAL_CTRL should always be written at last after all other PMU MSR=
s
> are manipulated. So if there are some PMU MSRs whose index is larger than
> PERF_GLOBAL_CTRL (It would be true in archPerfmon v6+, all PMU MSRs in th=
e
> new MSR range have larger index than PERF_GLOBAL_CTRL),

No, the entries in the load/store lists are processed in sequential order a=
s they
appear in the lists.  Ordering them based on their MSR index would be insan=
e and
would make the lists useless.

  VM entries may load MSRs from the VM-entry MSR-load area (see Section 25.=
8.2).
  Specifically each entry in that area (up to the number specified in the V=
M-entry
  MSR-load count) is processed in order by loading the MSR indexed by bits =
31:0
  with the contents of bits 127:64 as they would be written by WRMSR.1

> these PMU MSRs would be restored after PERF_GLOBAL_CTRL. That would break=
 the
> rule. Of course, it's good to save/restore PERF_GLOBAL_CTRL right now wit=
h
> the VMCS VMCS MSR auto-load/restore bitmap feature since only one PMU MSR
> PERF_GLOBAL_CTRL is saved/restored in current implementation.

No, it's never good to use the load/store lists.  They're slow as mud, beca=
use
they're essentially just wrappers to the standard WRMSR/RDMSR ucode.  Where=
as
dedicated VMCS fields have dedicated, streamlined ucode to make loads and s=
tores
as fast as possible.

I haven't measured PERF_GLOBAL_CTRL specifically, at least not in recent me=
mory,
but generally speaking using a load/store entry is 100+ cycles, whereas usi=
ng a
dedicated VMCS field is <20 cyles (often far less).

So what I am saying is that the mediated PMU should _require_ support for l=
oading
and saving PERF_GLOBAL_CTRL via dedicated fields, and WARN if a CPU with a =
v4+
PMU doesn't support said fields.  E.g.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a4b2b0b69a68..cab8305e7bf0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8620,6 +8620,15 @@ __init int vmx_hardware_setup(void)
                enable_sgx =3D false;
 #endif
=20
+       /*
+        * All CPUs that support a mediated PMU are expected to support loa=
ding
+        * and saving PERF_GLOBAL_CTRL via dedicated VMCS fields.
+        */
+       if (enable_passthrough_pmu &&
+           (WARN_ON_ONCE(!cpu_has_load_perf_global_ctrl() ||
+                         !cpu_has_save_perf_global_ctrl())))
+               enable_passthrough_pmu =3D false;
+
        /*
         * set_apic_access_page_addr() is used to reload apic access
         * page upon invalidation.  No need to do anything if not

That will provide better, more consistent performance, and will eliminate a=
 big
pile of non-trivial code.

> PERF_GLOBAL_CTRL MSR could be frequently accessed by perf/pmu driver, e.g=
.
> on each task switch, so PERF_GLOBAL_CTRL MSR is configured to passthrough
> to reduce the performance impact in mediated vPMU proposal if guest own a=
ll
> PMU HW resource. But if guest only owns part of PMU HW resource,
> PERF_GLOBAL_CTRL would be set to interception mode.

Again, I know.  What I am saying is that propagating PERF_GLOBAL_CTRL to/fr=
om the
VMCS on every entry and exit is extremely wasteful and completely unnecessa=
ry.

> I suppose KVM doesn't need access PERF_GLOBAL_CTRL in passthrough mode.
> This piece of code is intently just for PERF_GLOBAL_CTRL interception mod=
e,

No, it's even more useless if PERF_GLOBAL_CTRL is intercepted, because in t=
hat
case the _only_ time KVM needs move the guest's value to/from the VMCS is w=
hen
the guest (or host userspace) is explicitly accessing the field.

> but think twice it looks unnecessary to save/restore PERF_GLOBAL_CTRL via
> VMCS as KVM would always maintain the guest=C2=A0PERF_GLOBAL_CTRL value? =
Anyway,
> this part of code can be optimized.

