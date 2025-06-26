Return-Path: <kvm+bounces-50854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 165AFAEA353
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 18:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0C111C21F96
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 16:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD25720AF9A;
	Thu, 26 Jun 2025 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="25kOulNA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45FB19ABC6
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 16:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750954658; cv=none; b=pdehA7RIURMRNcBkPvJGz9BBFkFJmpmoprR+ektKpK//mT+/+YVhD3PrVlDraZr/n9fCeXRYahyj2GytnHmZpJXK9i7GUfMx/Q9wl1/fXWp1yXkiJthxPeFdfYi7pe0fxk2BgxUY01c/+a+zXNSV1FSMcxBHrbXTRWex3BSkh/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750954658; c=relaxed/simple;
	bh=H49TY38qk7RAZjC4aU5etaH/Yaa+mCiifkqAhIxkVnI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ADiU0ucVttTqJ7DwQ5j8kvGODrj01KZN/rMK7Ff6xnFDk3wnEpt/pvLlVz+Y0kvSRQoBEyp+ZK9Wknb5UlzReFIpqXJXaILAE1AU0olHsk/Qeff/HD32+49ns5wYMl2IrFdU/cN9TAArlxP/Ybletml63UZqDbExsP2TMzBSiNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=25kOulNA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313f702d37fso981884a91.3
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 09:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750954656; x=1751559456; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OUSYF6uddg/J1Cph/NK/Hlbf5Ti8UhmhK3Dy5+MrM/c=;
        b=25kOulNA3deSEVqD6F+y0T/+2utypCCnW17h6hK54xQO+c1UWTSPWIOwOtNvyfYHCp
         tBDSmBGr0OWkdej5r/b6uT1OHtvdGWEKOSjJZebMYsk89+itYIrfsDbugujVaUz6NXM4
         dQKqsOOam7ihSEeGxVxIZ/oM6W4ZzzE3/sjEuTCA4UMVAeL3pJo2oCC+2a/p3/WyMGPx
         o5AZX6nJY1crvmvoiRtPsf8tg0945KRQ/IF9qHfKQC3kQyE2BZGhokP9LO8dLHNnUxRg
         t6ddU2lypt1aMJRpqGi5bjNzeW410K3CsJPE/Lq4aWmNH/mBlg0bXu6oS5tWJqe+ufBU
         fs6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750954656; x=1751559456;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OUSYF6uddg/J1Cph/NK/Hlbf5Ti8UhmhK3Dy5+MrM/c=;
        b=IAiFsa3vu2W3amW89Z5mSyK4oF64Pj8f28Yb4s5SYJ4nbOsXoEXvUK/J286RxIfje/
         2AnX2TtfsmxcVs+AxkM80nNdl/jBM7jqKmnMoa/JZh4DNJHrjR+ye0rJqM3UKKhZ6O+d
         YkNm1dTSwQwBFHop3n883WMmjXOq+YdC0TggwJ6KVbJ4GFGFKrvMDZv3CJo95txB7MnO
         OCmjlcZDECJiIXdNHD2nWqu07bAvy/27acF3mYVMWUVd9rzrbv/57njvdpNo/p9QOirP
         9zrDRTDzk+MJO8pi96cRa2NZXBgEDrcJRo3q/BBrC7GaHH+I/A/hmsUSdhtrdF744i2F
         gZUA==
X-Forwarded-Encrypted: i=1; AJvYcCWlZXYEkjF7v0pk0sXB5aCxUL7lhXDdhlxUUcPh3N2JS74l03BVonXw11gX+LFU1HCUfVA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGwsHsUUareaED7druxsk5DaDolUxTcLaGghxAYepqE5s7RbYS
	kwbWbZ9eYB0bxpUw491jJuk13g7tNoHJb9ApIJnPGmT0McS+pTMla5E4XQ4ImRTmRlZQnVl9Ou+
	mHQTX0w==
X-Google-Smtp-Source: AGHT+IEL84+fyvijfqFOjED5E3i8DGwaB2WKlidAkoQbRibNM2YrvFmpQ+5rdiMhDDBywhNyf/wsjOgGjp4=
X-Received: from pjbsw14.prod.google.com ([2002:a17:90b:2c8e:b0:312:4b0b:a94])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2790:b0:312:1c83:58e7
 with SMTP id 98e67ed59e1d1-315f25e3043mr10261950a91.1.1750954655843; Thu, 26
 Jun 2025 09:17:35 -0700 (PDT)
Date: Thu, 26 Jun 2025 09:17:34 -0700
In-Reply-To: <17b45add9debcc226f515e5d8bb31c508576fa1e.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610232010.162191-1-seanjc@google.com> <20250610232010.162191-9-seanjc@google.com>
 <17b45add9debcc226f515e5d8bb31c508576fa1e.camel@redhat.com>
Message-ID: <aF1yni8U6XNkyfRf@google.com>
Subject: Re: [PATCH v6 8/8] KVM: VMX: Preserve host's DEBUGCTLMSR_FREEZE_IN_SMM
 while running the guest
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2025, mlevitsk@redhat.com wrote:
> On Tue, 2025-06-10 at 16:20 -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index c20a4185d10a..076af78af151 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -419,12 +419,25 @@ bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu,=
 u64 data, bool host_initiated)
> > =C2=A0
> > =C2=A0static inline void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu=
, u64 val)
> > =C2=A0{
> > +	WARN_ON_ONCE(val & DEBUGCTLMSR_FREEZE_IN_SMM);
> > +
> > +	val |=3D vcpu->arch.host_debugctl & DEBUGCTLMSR_FREEZE_IN_SMM;
> > =C2=A0	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
> > =C2=A0}
> > =C2=A0
> > =C2=A0static inline u64 vmx_guest_debugctl_read(void)
> > =C2=A0{
> > -	return vmcs_read64(GUEST_IA32_DEBUGCTL);
> > +	return vmcs_read64(GUEST_IA32_DEBUGCTL) & ~DEBUGCTLMSR_FREEZE_IN_SMM;
> > +}
> > +
> > +static inline void vmx_reload_guest_debugctl(struct kvm_vcpu *vcpu)
> > +{
> > +	u64 val =3D vmcs_read64(GUEST_IA32_DEBUGCTL);
> > +
> > +	if (!((val ^ vcpu->arch.host_debugctl) & DEBUGCTLMSR_FREEZE_IN_SMM))
> > +		return;
> > +
> > +	vmx_guest_debugctl_write(vcpu, val & ~DEBUGCTLMSR_FREEZE_IN_SMM);
> > =C2=A0}
>=20
>=20
> Wouldn't it be better to use kvm_x86_ops.HOST_OWNED_DEBUGCTL here as well
> to avoid logic duplication?

Hmm, yeah.  I used DEBUGCTLMSR_FREEZE_IN_SMM directly to avoid a memory loa=
d
just to get at a constant literal.

What about this?  It doesn't completely dedup the logic, but I think it get=
s us
close enough to a single source of truth.

--
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 26 Jun 2025 09:14:20 -0700
Subject: [PATCH] KVM: VMX: Add a macro to track which DEBUGCTL bits are
 host-owned

Add VMX_HOST_OWNED_DEBUGCTL_BITS to track which bits are host-owned, i.e.
need to be preserved when running the guest, to dedup the logic without
having to incur a memory load to get at kvm_x86_ops.HOST_OWNED_DEBUGCTL.

No functional change intended.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/main.c |  2 +-
 arch/x86/kvm/vmx/vmx.h  | 12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 8c6435fdda18..dbab1c15b0cd 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -883,7 +883,7 @@ struct kvm_x86_ops vt_x86_ops __initdata =3D {
 	.vcpu_load =3D vt_op(vcpu_load),
 	.vcpu_put =3D vt_op(vcpu_put),
=20
-	.HOST_OWNED_DEBUGCTL =3D DEBUGCTLMSR_FREEZE_IN_SMM,
+	.HOST_OWNED_DEBUGCTL =3D VMX_HOST_OWNED_DEBUGCTL_BITS,
=20
 	.update_exception_bitmap =3D vt_op(update_exception_bitmap),
 	.get_feature_msr =3D vmx_get_feature_msr,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 87174d961c85..d3389baf3ab3 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -410,27 +410,29 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vc=
pu);
 u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)=
;
 bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_init=
iated);
=20
+#define VMX_HOST_OWNED_DEBUGCTL_BITS	(DEBUGCTLMSR_FREEZE_IN_SMM)
+
 static inline void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, u64 val=
)
 {
-	WARN_ON_ONCE(val & DEBUGCTLMSR_FREEZE_IN_SMM);
+	WARN_ON_ONCE(val & VMX_HOST_OWNED_DEBUGCTL_BITS);
=20
-	val |=3D vcpu->arch.host_debugctl & DEBUGCTLMSR_FREEZE_IN_SMM;
+	val |=3D vcpu->arch.host_debugctl & VMX_HOST_OWNED_DEBUGCTL_BITS;
 	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
 }
=20
 static inline u64 vmx_guest_debugctl_read(void)
 {
-	return vmcs_read64(GUEST_IA32_DEBUGCTL) & ~DEBUGCTLMSR_FREEZE_IN_SMM;
+	return vmcs_read64(GUEST_IA32_DEBUGCTL) & ~VMX_HOST_OWNED_DEBUGCTL_BITS;
 }
=20
 static inline void vmx_reload_guest_debugctl(struct kvm_vcpu *vcpu)
 {
 	u64 val =3D vmcs_read64(GUEST_IA32_DEBUGCTL);
=20
-	if (!((val ^ vcpu->arch.host_debugctl) & DEBUGCTLMSR_FREEZE_IN_SMM))
+	if (!((val ^ vcpu->arch.host_debugctl) & VMX_HOST_OWNED_DEBUGCTL_BITS))
 		return;
=20
-	vmx_guest_debugctl_write(vcpu, val & ~DEBUGCTLMSR_FREEZE_IN_SMM);
+	vmx_guest_debugctl_write(vcpu, val & ~VMX_HOST_OWNED_DEBUGCTL_BITS);
 }
=20
 /*

base-commit: 6c7ecd725e503bf2ca69ff52c6cc48bb650b1f11
--

