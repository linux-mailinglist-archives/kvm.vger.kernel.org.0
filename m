Return-Path: <kvm+bounces-13469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CE1897309
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 16:49:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D74821C271CC
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 14:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E83658AA1;
	Wed,  3 Apr 2024 14:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DwDT8NYj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655202F28
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 14:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712155771; cv=none; b=m7vQSKHI6uCqlBn+v8E0SjARWhBZyjzNm9DsfbbNkf+Yh1BpTI6nqJk7qoo+nNWk1A7Uxe7qDQ1uCBGY44pbcqpYXdm8Ho9hHY4DA7LCJES6QXb3vLjQBcaOrD9ByN1GOtK0KzbqWkxaQYvIuU4gKQcEeo1ScEa9Tx0BbEF5tvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712155771; c=relaxed/simple;
	bh=x+/Whws7IOZZfnW79uF6wUm5Ocmsx9bOqXCA8yKOKTM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i9EMrhznHheXZzZl3Mu9yeTObHuum0ZxdgbVXsCQi6Zqe+ot+b5eRXavJ5xZ1wZ+KmifCII0hEqMwv/YuICYDMFY9PFiL1gnhFlpvFI3mWuKFqdmgbAArO+3r+ptL49VjXZSXOl/97cT6aDsQQVyRRj4LmR4k5WZOt7P8iOuFKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DwDT8NYj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2a262ec9911so1477757a91.0
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 07:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712155770; x=1712760570; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dy+Nk5dzJaNhxp6iwoL8oKHLG7ul37PUDWHPTXb13jY=;
        b=DwDT8NYjPYAzWTXcPz0Pdc3FDInk0uoRkbCZ7rzSxdDGQ7Ys3uqzEOGfXcLu6BhJsk
         vl8dRGhK0+Oi38DaHatdzbBM4zFH6gWqsvBS3pPZMcjqueT38z/XF5Y+fRoleM8hdsxI
         VIVDL1e4IuvUdlIX7ltVVcN3/GIum62Z/zrPfxrGF/EgozBdDJmvQCm+9wr6FAdcle8u
         womSjSkqYgtct5TICAmvbi26aKM0LpT0q+ZTL0ELfgbfkMGKt9exKCmcNqWWNgBMyNVG
         MTCicMPMgEkw5oVIRL1B5/b50mdUXnjqUGfrGBzKzKy7/bJguq+gjmCcBCwA110jvqqi
         dPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712155770; x=1712760570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dy+Nk5dzJaNhxp6iwoL8oKHLG7ul37PUDWHPTXb13jY=;
        b=rONbOt0RolLkrkneFxjaKxLj5IChzsMczij3vxAiN0P0p6JSngP+ymB4jiQlniwBHl
         /9kPlLOD3lYiQL0V8Qfs5GV9dfOcpzXTEwrV38bTX7/HHhRAdqxMsUrDCt4H67OC4VDl
         F/vBAvFKMMAheMSbWRjdYGWvS+mh2EFK7rbokJoOtZpXp8d2UmT+wtZUlEd77XsKb/EZ
         /6RSe4p2a3izObtwG7KH2MxK3OQ7RdP+gIrNhpELFfT8cPGGAeA+Szs1wVYgkATW7g3F
         liQ9XsbOIrZmwNrW1qu4+S2E/2hxSr3rUxRm2P+N3Slsu0p4ImyX4kxd1L0uI+rrP8WV
         wwvw==
X-Forwarded-Encrypted: i=1; AJvYcCVzARMZbgAy5RcdAREEeb82c2eszx/RPJFxOlaxdE1MxMEBTmPsMc16eXLgBqjxVq2mibyRIaEbDIMZ8M5swlKMOFC3
X-Gm-Message-State: AOJu0Yw6dc/9i9Mz9hhEkOyf42nNrWrRE4+Pu7E6fPhMZm9yIahy2Xdw
	Cy/97wKcWW833LF1a4QiJbe/jsALuq+oIKmw0KXRThGoNNkwe5jnXOTkIX9v0rdFfh2q6caTRKm
	mcg==
X-Google-Smtp-Source: AGHT+IEuC8rrpEQtV1b/Z1iw1PNLmfo+7pgvTb3ZaGiDaEj9q7X59dJc9XHsl8uxojAhpUO2cciXz6fp9Oc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1998:b0:2a2:64a2:436f with SMTP id
 mv24-20020a17090b199800b002a264a2436fmr11557pjb.6.1712155769720; Wed, 03 Apr
 2024 07:49:29 -0700 (PDT)
Date: Wed, 3 Apr 2024 07:49:28 -0700
In-Reply-To: <ZgzMH3944ZaBx8B3@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c083430632ba9e80abd09bccd5609fb3cd9d9c63.1708933498.git.isaku.yamahata@intel.com>
 <ZgzMH3944ZaBx8B3@chao-email>
Message-ID: <Zg1seIaTmM94IyR8@google.com>
Subject: Re: [PATCH v19 108/130] KVM: TDX: Handle TDX PV HLT hypercall
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, Sagi Shahar <sagis@google.com>, 
	Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com, 
	tina.zhang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 03, 2024, Chao Gao wrote:
> On Mon, Feb 26, 2024 at 12:26:50AM -0800, isaku.yamahata@intel.com wrote:
> >From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> >Wire up TDX PV HLT hypercall to the KVM backend function.
> >
> >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >---
> >v19:
> >- move tdvps_state_non_arch_check() to this patch
> >
> >v18:
> >- drop buggy_hlt_workaround and use TDH.VP.RD(TD_VCPU_STATE_DETAILS)
> >
> >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >---
> > arch/x86/kvm/vmx/tdx.c | 26 +++++++++++++++++++++++++-
> > arch/x86/kvm/vmx/tdx.h |  4 ++++
> > 2 files changed, 29 insertions(+), 1 deletion(-)
> >
> >diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> >index eb68d6c148b6..a2caf2ae838c 100644
> >--- a/arch/x86/kvm/vmx/tdx.c
> >+++ b/arch/x86/kvm/vmx/tdx.c
> >@@ -688,7 +688,18 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > 
> > bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
> > {
> >-	return pi_has_pending_interrupt(vcpu);
> >+	bool ret = pi_has_pending_interrupt(vcpu);
> 
> Maybe
> 	bool has_pending_interrupt = pi_has_pending_interrupt(vcpu);
> 
> "ret" isn't a good name. or even call pi_has_pending_interrupt() directly in
> the if statement below.

Ya, or split the if-statement into multiple chucks, with comments explaining
what each non-intuitive chunk is doing.  The pi_has_pending_interrupt(vcpu) check
is self-explanatory, the halted thing, not so much.  They are terminal statements,
there's zero reason to pre-check the PID.

E.g.

	/*
	 * Comment explaining why KVM needs to assume a non-halted vCPU has a
	 * pending interrupt (KVM can't see RFLAGS.IF).
	 */
	if (vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
		return true;

	if (pi_has_pending_interrupt(vcpu))
		return;

> >+	union tdx_vcpu_state_details details;
> >+	struct vcpu_tdx *tdx = to_tdx(vcpu);
> >+
> >+	if (ret || vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
> >+		return true;
> 
> Question: why mp_state matters here?
> >+
> >+	if (tdx->interrupt_disabled_hlt)
> >+		return false;
> 
> Shouldn't we move this into vt_interrupt_allowed()? VMX calls the function to
> check if interrupt is disabled. KVM can clear tdx->interrupt_disabled_hlt on
> every TD-enter and set it only on TD-exit due to the guest making a
> TDVMCALL(hlt) w/ interrupt disabled.

I'm pretty sure interrupt_disabled_hlt shouldn't exist, should "a0", a.k.a. r12,
be preserved at this point?

	/* Another comment explaning magic code. */
	if (to_vmx(vcpu)->exit_reason.basic == EXIT_REASON_HLT &&
	    tdvmcall_a0_read(vcpu))
		return false;


Actually, can't this all be:

	if (to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_HLT)
		return true;

	if (!tdvmcall_a0_read(vcpu))
		return false;

	if (pi_has_pending_interrupt(vcpu))
		return true;

	return tdx_has_pending_virtual_interrupt(vcpu);

