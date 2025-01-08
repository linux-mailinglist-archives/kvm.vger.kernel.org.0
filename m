Return-Path: <kvm+bounces-34779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE98A05F27
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9D9E3A2C7B
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 14:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815401FDE2D;
	Wed,  8 Jan 2025 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MMTWIsUj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2705D1FCFF2
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 14:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736347236; cv=none; b=inU5J1w+SF6FqzoTpQdonzZbtrbTI4Rahox5Fk9Sa+xe3BjFVYr9NaD0WLrIE2qh5Yptm69CfQe7vWtkRBYczeUymavFb6UUW5OjpYiAJsR97MbCoMHhTwoSwsdr3ypED6Wk0TnzgwT+R6eUBu/YXDrrsCqKmAvy8TLHrPdm0G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736347236; c=relaxed/simple;
	bh=RGAhfR20O+YnJKIelvg6zwiP/ClBrgVRV5L2EzB7kR8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cuBV12W6tuMT6t/i5wSQhBgqi80HRaH/52ARY8ctrC+H00kdx6gnMwf9/r3gK34S7LU6T/qsn+xhOuSoTA2WrEs/EW+u+gc4YDwh+0lUDrDn7B2SqtuvVYuBK1bgf284bIcPd2WSkUVaT9lNozjzazcJu/U7xzSD61mKbkq+73k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MMTWIsUj; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21638389f63so206815025ad.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 06:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736347234; x=1736952034; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zsahhm75wId/fXEPEblBOXmCeV+GcIu0DpTtAFj++F8=;
        b=MMTWIsUj3aMzLrMhQkdtNPtTNv2OmlMo25Sg0zioytOFU4GNh3CwDBPaAnjYp7FZfZ
         3Adi4QIWo6uW00xvKib6Agy73eOyeiuxdztWW9S5gssOYzdFuQi6F7/+/GuYKqf/FAE8
         T9kJIXngNSsIz/ZS4D3JjExBXrtS49EJ/wWkfgaQyFl2HQU5GNZ2qljEu3v9TBRCoa/5
         CTJUKQof6oFoMTTqVVwkkx+9Hyukqyp80L6QskaqtnRY3/aRyWCgTRl1UN2a+LPaby7u
         0i+DEeVMTz8DoYGt+im3rEHjyx55ASGB4sLJBmBf3Z2FFIYcnKjs71YW+wyZc+lvuyZC
         1Y3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736347234; x=1736952034;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zsahhm75wId/fXEPEblBOXmCeV+GcIu0DpTtAFj++F8=;
        b=sugv4kOPSCrS906HwWFJl6PlzoQt1wJ+QUqdLX4OVGAbq4B39XpVhh5kD49vwv97xO
         RhJZsjJPe/YSBeU2mXGSy0hbNlpTKHn38x11/vPv16ptn6e5oBJMeqQ/xevlSjweoiFk
         Nj6bzxnNNDmcU7GNaNUpxBUMaa2w8tBkRG5/BDXu/rTZb325iVbtdXFUW7JAp736vcOf
         oVtz8Gd2KRrYbdDGgmNwLJ7oYfb1dn9dH2lvyLJIJ6FtgB8uXUltiA53z6oKcVfYHhVl
         kRjPG34t3xlths4AGrvwSCQhvLZlNQ8OIg6QKiq+iN3Uls43CUHkvPNV6ibVZdeS1vTb
         p2Fw==
X-Forwarded-Encrypted: i=1; AJvYcCWpa9Lo4yIuVlwzmEZrOqGhspQB2WWCTSmrL+sQ/qqUEW8J8UkE2YZBJTRifndpjNVAKQA=@vger.kernel.org
X-Gm-Message-State: AOJu0YydwnmJgjUOkLGwOdauUx4k+I7j7oHzY+f4GDBcmJH/aL8Nm2fn
	7SboBf1ChTD22XOcB0qp8+ldcz802sEd/Dp7ExMY1FY3Wbt+FcrJllQUXo6rnDUrmBWeKARD/AD
	bdQ==
X-Google-Smtp-Source: AGHT+IEDsr5EIFKHo0SXbbakT2oiUmkEin/P2VEh2NqZchthSzg4oPAuZrCNOtTR8siJiPFwiB+HBhGUh18=
X-Received: from pfbjc32.prod.google.com ([2002:a05:6a00:6ca0:b0:728:f1bf:72ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c799:b0:1e1:72ce:fefc
 with SMTP id adf61e73a8af0-1e88d11cb13mr6225413637.22.1736347234472; Wed, 08
 Jan 2025 06:40:34 -0800 (PST)
Date: Wed, 8 Jan 2025 06:40:33 -0800
In-Reply-To: <904c0aa7-8aa6-4ac2-b2d3-9bac89355af1@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-12-binbin.wu@linux.intel.com> <473c1a20-11c8-4e4e-8ff1-e2e5c5d68332@intel.com>
 <904c0aa7-8aa6-4ac2-b2d3-9bac89355af1@linux.intel.com>
Message-ID: <Z36OYfRW9oPjW8be@google.com>
Subject: Re: [PATCH 11/16] KVM: TDX: Always block INIT/SIPI
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, tony.lindgren@linux.intel.com, 
	isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2025, Binbin Wu wrote:
> On 1/8/2025 3:21 PM, Xiaoyao Li wrote:
> > On 12/9/2024 9:07 AM, Binbin Wu wrote:

...

> > > ---
> > > =C2=A0 arch/x86/kvm/lapic.c=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> > > =C2=A0 arch/x86/kvm/vmx/main.c | 19 ++++++++++++++++++-
> > > =C2=A0 2 files changed, 19 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 474e0a7c1069..f93c382344ee 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -3365,7 +3365,7 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcp=
u)
> > > =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_and_clear_bit(KVM_APIC=
_INIT, &apic->pending_events)) {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_vcpu_reset=
(vcpu, true);
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (kvm_vcpu_is_bsp(apic-=
>vcpu))
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (kvm_vcpu_is_bsp(vcpu)=
)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 vcpu->arch.mp_state =3D KVM_MP_STATE_RUNNABLE;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 vcpu->arch.mp_state =3D KVM_MP_STATE_INIT_RECEIVED;
> > > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > > index 8ec96646faec..7f933f821188 100644
> > > --- a/arch/x86/kvm/vmx/main.c
> > > +++ b/arch/x86/kvm/vmx/main.c
> > > @@ -115,6 +115,11 @@ static void vt_vcpu_free(struct kvm_vcpu *vcpu)
> > > =C2=A0 =C2=A0 static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool i=
nit_event)
> > > =C2=A0 {
> > > +=C2=A0=C2=A0=C2=A0 /*
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 * TDX has its own sequence to do init durin=
g TD build time (by
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 * KVM_TDX_INIT_VCPU) and it doesn't support=
 INIT event during TD
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 * runtime.
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 */
> >=20
> > The first half is confusing. It seems to mix up init(ialization) with I=
NIT
> > event.
> >=20
> > And this callback is about *reset*, which can be due to INIT event or n=
ot.
> > That's why it has a second parameter of init_event. The comment needs t=
o
> > clarify why reset is not needed for both cases.
> >=20
> > I think we can just say TDX doesn't support vcpu reset no matter due to
> > INIT event or not.

That's not entirely accurate either though.  TDX does support KVM's version=
 of
RESET, because KVM's RESET is "power-on", i.e. vCPU creation.  Emulation of
runtime RESET is userspace's responsibility.

The real reason why KVM doesn't do anything during KVM's RESET is that what
little setup KVM does/can do needs to be defered until after guest CPUID is
configured.

KVM should also WARN if a TDX vCPU gets INIT, no?

Side topic, the comment about x2APIC in tdx_vcpu_init() is too specific, e.=
g.
calling out that x2APIC support is enumerated in CPUID.0x1.ECX isn't necess=
ary,
and stating that userspace must use KVM_SET_CPUID2 is flat out wrong.  Very
technically, KVM_SET_CPUID is also a valid option, it's just not used in pr=
actice
because it doesn't support setting non-zero indices (but in theory it could=
 be
used to enable x2APIC).

E.g. something like this?

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d2e78e6675b9..e36fba94fa14 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -115,13 +115,10 @@ static void vt_vcpu_free(struct kvm_vcpu *vcpu)
=20
 static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
-       /*
-        * TDX has its own sequence to do init during TD build time (by
-        * KVM_TDX_INIT_VCPU) and it doesn't support INIT event during TD
-        * runtime.
-        */
-       if (is_td_vcpu(vcpu))
+       if (is_td_vcpu(vcpu)) {
+               tdx_vcpu_reset(vcpu, init_event);
                return;
+       }
=20
        vmx_vcpu_reset(vcpu, init_event);
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 9e490fccf073..a587f59167a7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2806,9 +2806,8 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struc=
t kvm_tdx_cmd *cmd)
                return -EINVAL;
=20
        /*
-        * As TDX requires X2APIC, set local apic mode to X2APIC.  User spa=
ce
-        * VMM, e.g. qemu, is required to set CPUID[0x1].ecx.X2APIC=3D1 by
-        * KVM_SET_CPUID2.  Otherwise kvm_apic_set_base() will fail.
+        * TDX requires x2APIC, userspace is responsible for configuring gu=
est
+        * CPUID accordingly.
         */
        apic_base =3D APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC |
                (kvm_vcpu_is_reset_bsp(vcpu) ? MSR_IA32_APICBASE_BSP : 0);
@@ -2827,6 +2826,19 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, stru=
ct kvm_tdx_cmd *cmd)
        return 0;
 }
=20
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+       /*
+        * Yell on INIT, as TDX doesn't support INIT, i.e. KVM should drop =
all
+        * INIT events.
+        *
+        * Defer initializing vCPU for RESET state until KVM_TDX_INIT_VCPU,=
 as
+        * userspace needs to define the vCPU model before KVM can initiali=
ze
+        * vCPU state, e.g. to enable x2APIC.
+        */
+       WARN_ON_ONCE(init_event);
+}
+
 struct tdx_gmem_post_populate_arg {
        struct kvm_vcpu *vcpu;
        __u32 flags;


