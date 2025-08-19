Return-Path: <kvm+bounces-55070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C12EDB2D00E
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E69EC586520
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34159271462;
	Tue, 19 Aug 2025 23:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4F9h0DFa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0146D22D9E9
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646553; cv=none; b=GpGYsaU1ayPWOJhTX6/26NEXuu09y3QHxfbZdX0jrjxWXZ+eibr045WRudsCpIEug9RzzQGBJm6lWtWBbKWKBx3Cmtrfg3SbhaARrRL7U1myKtNWr6Z9gLsde5bENPBIWTES6gLE0F37d4smWe3iCdcrMO6+mmi0hX6ZHbPJ0W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646553; c=relaxed/simple;
	bh=pGNoCw5RliMR1hc2G8FGCbiY6EkVS7thZ2xnU1DivA8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p4hOgp84dh6COTrnRgXpsWGc6XSIe75qb9nfr6bLGA2TNw80N98Q2fwFzjU0854KxqRJ/9JXETlxIVxRT0TWUaQHDETSWZjcnEI3njjO82u6qkDAAr5Ed/vqhWZ96gw1KXWpSvhd7M0Xy7JauU9CRRbOOqmaZ2td0hN+SNRSdRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4F9h0DFa; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e1fc66de5so324838b3a.0
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755646551; x=1756251351; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fFgj43Bl6pF7x625ndmXUSvzXKMpEIMY0lc+Fsn4QXM=;
        b=4F9h0DFaky5l+auWDdXEreHCSJ+YEaiL06P9Kyn0FQkktiWWg2gY7YIkN7rAXrsxlJ
         /c0OiZ8+SkpCLMOS7xHvC7lutC5/Zwe8JmzP4bI073rKplFHV+N1yFHHdwjCSFTId1Z4
         sKgraamAhR8u5/M9aZlZu1ZcsJDWPth/H0gmxYTrbuKWs3qZs+h/4PgGpZ9toBCssyyi
         TRWNtDshe2JLQQj4plg7YAE0OnEymrVdh+TtOb42yrYzcUIjEnFULQeP0x1IykpMBO+l
         ygUUGgWxFF/JUjLr66GCrAkdWXz9MttZEQ7555R0TgyqT6wst1+aA/TPnyphVhR8KWT5
         JEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755646551; x=1756251351;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fFgj43Bl6pF7x625ndmXUSvzXKMpEIMY0lc+Fsn4QXM=;
        b=oXzbLO0kUh6oVWtb95w9YdijDOphunNiHCJf37HmsTsWGb79c8hRE4INYzFEHO3Iu0
         p4CGINHuBnJ0G4KonDagnvuMlpFDAsd5DB9qi2AeeAXGSE2LBNMqNODutfriKrrwHGk6
         OkjLQHftM8b7KWGJNB/NqJvuy0yXZDmR6/PUWNHgjpDAvE5jXLaXNwQ61/AaYBeglnzU
         1kB5JFLU4YrWQQgwsh7ylFqNoFjLLVTUxYU9Z818DF2p0BcELWCswKnLRZbwWFg0jjYs
         P0ONPF4HsBtNdmQh5T7ANU4jnmELBN2xRK+71AuXMKRGHHIcl2A6/B2PmGOBW7K5sLcH
         mxpg==
X-Forwarded-Encrypted: i=1; AJvYcCW7f/zdAdNBMdS+e5TfnJSMzk2m66BuHARIjLI+sLIByVIUYoe/JrRc6cB8T0mh69LyF3I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ5l+o3sVCfkzlOwLfcuaqyaZ8taH1H1P/9EICZmGV7KtSu0gA
	XO+fo7VeWRgKpPyd4hSmQsFwWa4dj+lXXuECfz4OprVzpMYBhhe/eFT45mddEDAn3CZeUqVSjov
	eJPXfzg==
X-Google-Smtp-Source: AGHT+IH3D25e+3vUdFm0XxyCHr/yIlxg3402tHO1ZlCDyh7A1HQY9j4X69+ePOM9vGTg1vVEx2W74S7b0J8=
X-Received: from pjg11.prod.google.com ([2002:a17:90b:3f4b:b0:31f:f3:f8c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4322:b0:220:898b:2ca1
 with SMTP id adf61e73a8af0-2431b961256mr1437836637.21.1755646551214; Tue, 19
 Aug 2025 16:35:51 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:35:49 -0700
In-Reply-To: <fb858e9d16762fbc9c44ef357c670c475f559709.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250816144436.83718-1-adrian.hunter@intel.com>
 <20250816144436.83718-2-adrian.hunter@intel.com> <aKMzEYR4t4Btd7kC@google.com>
 <136ab62e9f403ad50a7c2cb4f9196153a0a2ef7c.camel@intel.com>
 <968d2750-cbd6-47cb-b2fc-d0894662dafc@intel.com> <fb858e9d16762fbc9c44ef357c670c475f559709.camel@intel.com>
Message-ID: <aKUKVdonFGwUZI_k@google.com>
Subject: Re: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in guest
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Len Brown <len.brown@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-08-19 at 10:38 +0300, Adrian Hunter wrote:
> > On 18/08/2025 21:49, Edgecombe, Rick P wrote:
> > > Attn: Binbin, Xiaoyao
> > >=20
> > > On Mon, 2025-08-18 at 07:05 -0700, Sean Christopherson wrote:
> > > > NAK.
> > > >=20
> > > > Fix the guest, or wherever else in the pile there are issues.=C2=A0=
 KVM is NOT carrying
> > > > hack-a-fixes to workaround buggy software/firmware.=C2=A0 Been ther=
e, done that.
> > >=20
> > > Yes, I would have thought we should have at least had a TDX module ch=
ange option
> > > for this.
> >=20
> > That would not help with existing TDX Modules, and would possibly requi=
re
> > a guest opt-in, which would not help with existing guests.  Hence, to s=
tart
> > with disabling the feature first, and look for another solution second.
>=20
> I think you have the priorities wrong. There are only so many kludges we =
can ask
> KVM to take. Across all the changes people want for TDX, do you think not=
 having
> to update the TDX module, backport a guest fix or even just adjust qemu a=
rgs is
> more important the other stuff?

I'm especially sensitive to fudging around _bugs_ in other pieces of the st=
ack.
KVM has been burned badly, multiple times, by hacking around issues elsewhe=
re.
There are inevitably cases where throwing something into KVM is the least a=
wful
choice (usually because it's the only feasible choise), but this ain't one =
of
those cases.

> TDX support is still very early. We need to think about long term sustain=
able
> solutions. So a fix that doesn't support existing TDX modules or guests (=
the
> intel_idle fix is also in this category anyway) should absolutely be on t=
he
> table.
>=20
> >=20
> > In the MWAIT case, Sean has rejected supporting MSR_PKG_CST_CONFIG_CONT=
ROL
> > even for VMX, because it is an optional MSR, so altering intel_idle is
> > being proposed.

No, I rejected support MSR_PKG_CST_CONFIG_CONTROL _in KVM_ because I don't =
see
any reason to shove information into KVM.  AFAICT, it's not an "architectur=
al"
MSR, and all of KVM's existing handling of truly uarch/model-specific MSRs =
is
painful and ugly.

And userspace (e.g. QEMU) could support emulate MSR_PKG_CST_CONFIG_CONTROL =
(and
any other MSRs of that nature) via MSR filters.  I doubt the MSR is accesse=
d
outside of boot paths, so the cost of a userspace exit should be a non-issu=
e.
Of course, QEMU probably can't provide useful/accurate information.

One option if there is a super strong need to do so would be to add a "disa=
ble
exits" capability to let the guest read package c-state MSRs, but that has
obvious downsides and would still just be fudging around a flawed driver.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8dbf19aa66ef..c254aa26ff22 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4120,6 +4120,15 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu=
)
                vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, =
MSR_TYPE_R);
                vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, =
MSR_TYPE_R);
        }
+       if (kvm_package_cstate_in_guest(vcpu->kvm)) {
+               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_CST_CONFIG_CONT=
ROL, MSR_TYPE_R);
+               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_C2_RESIDENCY, M=
SR_TYPE_R);
+               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_C3_RESIDENCY, M=
SR_TYPE_R);
+               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_C6_RESIDENCY, M=
SR_TYPE_R);
+               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_C8_RESIDENCY, M=
SR_TYPE_R);
+               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_C9_RESIDENCY, M=
SR_TYPE_R);
+               vmx_disable_intercept_for_msr(vcpu, MSR_PKG_C10_RESIDENCY, =
MSR_TYPE_R);
+       }
        if (kvm_aperfmperf_in_guest(vcpu->kvm)) {
                vmx_disable_intercept_for_msr(vcpu, MSR_IA32_APERF, MSR_TYP=
E_R);
                vmx_disable_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYP=
E_R);

