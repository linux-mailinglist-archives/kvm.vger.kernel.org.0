Return-Path: <kvm+bounces-65306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A38CA5E45
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 03:16:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 784E830B0426
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 02:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D622A2DF3EA;
	Fri,  5 Dec 2025 02:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rfOBJvv9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759602DCBF2
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 02:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764900955; cv=none; b=XODL3h57c1hxfougeWtfFtQNGETtZvCoO66gSTb1jnbhRuI/t5Hhj0R3X11ipRwqw4/fP3yclZOYuXtgs4kcGp84g9A5mXttmsZr+zBDQ1XwlVEgARqTxdj5cMomFSj68tLo4qh3dGrgrE6+YJm3I4SICvLAnzc2d5Nw0lDHaLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764900955; c=relaxed/simple;
	bh=x0QnqqfKKo90zFO6KyqzY+TRKQEjdQUyHLMrvT+9Tnc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Px4NF5aPT4PxzzwNX7I0CVFkP87TjaXz2ee7tbdd9+bWHEcZMDUrqnUm7acoacR5LXK77a7EnaxG6MXW/Mo3MgoNwMLdqxH2KxQ/rILdTzGntPcblIOc3qHcO9+2HHAPY+Iuuvey2AUIO1O96GptGCRCXHK8P6YCufoqxcyb5Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rfOBJvv9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343725e6243so2133942a91.1
        for <kvm@vger.kernel.org>; Thu, 04 Dec 2025 18:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764900953; x=1765505753; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1meOpPbnt6lgwkT8TjcOzWeU5C4K9QiAwf9UPoQwrdI=;
        b=rfOBJvv9VfA9ORPztjA0Y4XhZ30yarfVeQiwPXuchqOIPaOMxtNb0mp4onLnbedI54
         r3hBvFL2Wpxwyh0h6EjWFgfyVd4uOG/fk2LpuIvKE6Zt2eKVDIncmQo6+sQQS7/kYULh
         l/pp3PsB66Ttp81fLaCMpGLI1VSOWOcSzKmDachD/J0JgRWQgzsqwsdbEF8vVRJ2YSfv
         lf0DbK2x/NCITuxVtcrLO3FyV4ILYKHM2rClt2MiRZL9PT2Qkml2Xqn2bMFSdbjqbfqW
         XH6f03Lu1e/zulqqavr8izXrSW3jGVjWThKojYRsvHNZSd9PpN/MldOVrr9viItL6wCY
         q04A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764900953; x=1765505753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1meOpPbnt6lgwkT8TjcOzWeU5C4K9QiAwf9UPoQwrdI=;
        b=r/f5rdDzD/UpYT3givyHFs8lsNKocE+DuqcyZwFbyKIQ3aobTiQ1vcD0CJTGXoruas
         yps3YqALnsobHDzeH4C2pkSs+Nn7wGRSagbBQvCljH9ooE5ptygSlo76HUR9l5tl5C4F
         fx21u2+skA6OBz7GzcrHuh+coLPLj21Vl+EdzLV21pSdPzbpK0MxnyqSI//m+vqKGH1D
         Pcybdzc9aDnvTRs9tKPevhyNh4IjUa1toalUxTBoqUnimlKbPWrggAlmQW81yvbHi5Z9
         YNU+SJqOr6nCQG9eIVZaU5twoAs99Y3aVDuVM9CeF1wTgSlFvlfcHQzBETsx//US7tPw
         NGew==
X-Gm-Message-State: AOJu0YzV/zv+7P4wEC/h6tGltiXRACD0hOLVlTRvT8rhX/+f+aavZnsa
	ZDAmgf47mYuObeVcYd4XxLjU1X32NuGxDF8+Usw0TeoBzogvOSX3WSdvIWXZeIaCmXOQDVoyUKE
	wfR7oPg==
X-Google-Smtp-Source: AGHT+IEmQJcJjoUzQ7VCgXotmZg9hQevwRFmOgZhoo+SyyXgPzhN1odg6nF2OOcplUstSccwMABfCqD5mYA=
X-Received: from plka14.prod.google.com ([2002:a17:903:f8e:b0:297:fd8b:fe1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f709:b0:299:dc97:a694
 with SMTP id d9443c01a7336-29d9ed6e60cmr56567935ad.24.1764900952742; Thu, 04
 Dec 2025 18:15:52 -0800 (PST)
Date: Thu, 4 Dec 2025 18:15:51 -0800
In-Reply-To: <a3d1407c-86d6-46d4-ae96-b40d7b26eb34@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110063212.34902-1-dongli.zhang@oracle.com>
 <aRScMffMkpsdi5vs@google.com> <72da0532-908b-40c2-a4e4-7ef1895547c7@oracle.com>
 <aRZKEC4n9hpLVCRp@google.com> <a3d1407c-86d6-46d4-ae96-b40d7b26eb34@oracle.com>
Message-ID: <aTJAVx7C3vuPDgkm@google.com>
Subject: Re: [PATCH v2 1/1] KVM: VMX: configure SVI during runtime APICv activation
From: Sean Christopherson <seanjc@google.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	chao.gao@intel.com, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, joe.jin@oracle.com, 
	alejandro.j.jimenez@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 17, 2025, Dongli Zhang wrote:
> > Hmm, what if we go the opposite direction and bundle the vISR update into
> > KVM_REQ_APICV_UPDATE?  Then we can drop nested.update_vmcs01_hwapic_isr, and
> > hopefully avoid similar ordering issues in the future.

...

> Thank you very much for suggestion.

If only it was a good suggestion :-)

> There are still a few issues to fix.
> 
> 1. We still need to remove WARN_ON_ONCE() from vmx_hwapic_isr_update().

..

> 2. As you mentioned in prior email, while this is not a functional issue,
> apic_find_highest_isr() is still invoked unconditionally, as
> kvm_apic_update_hwapic_isr() is always called during KVM_REQ_APICV_UPDATE.
> 
> 
> 3. The issue that Chao reminded is still present.
> 
> (1) Suppose APICv is activated during L2.
> 
> kvm_vcpu_update_apicv()
> -> __kvm_vcpu_update_apicv()
>    -> apic->apicv_active = true
>    -> vmx_refresh_apicv_exec_ctrl()
>       -> vmx->nested.update_vmcs01_apicv_status = true
>       -> return
> 
> Then L2 exits to L1:
> 
> __nested_vmx_vmexit()
> -> kvm_make_request(KVM_REQ_APICV_UPDATE)
> 
> vcpu_enter_guest: KVM_REQ_APICV_UPDATE
> -> kvm_vcpu_update_apicv()
>    -> __kvm_vcpu_update_apicv()
>       -> return because of
>          if (apic->apicv_active == activate)
> 
> refresh_apicv_exec_ctrl() is skipped.
> 
> 4. It looks more complicated if we update "update_vmcs01_apicv_status = true" at
> both vmx_hwapic_isr_update() and vmx_refresh_apicv_exec_ctrl().
> 
> 
> Therefore, how about we continue to handle 'update_vmcs01_apicv_status' and
> 'update_vmcs01_hwapic_isr' as independent operations.
> 
> 1. Take the approach reviewed by Chao, and ...

Ya.  I spent a lot of time today wrapping my head around what all is going on,
and my lightbulb moment came when reading this from the changelog:

  The issue is not applicable to AMD SVM which employs a different LAPIC
  virtualization mechanism. 

That's not entirely true.  It's definitely true for SVI, but not for the bug that
Chao pointed out.  SVM is "immune" from these bugs because KVM simply updates
vmcb01 directly.  And looking at everything, there's zero reason we can't do the
same for VMX.  Yeah, KVM needs to do a couple VMPTRLDs to swap between vmcs01 and
vmcs02, but those aren't _that_ expensive, and these are slow paths.

And with a guard(), it's pretty trivial to run a section of code with vmcs01
active.

static void vmx_load_vmcs01(struct kvm_vcpu *vcpu)
{
	struct vcpu_vmx *vmx = to_vmx(vcpu);

	if (!is_guest_mode(vcpu)) {
		WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->vmcs01);
		return;
	}

	WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->nested.vmcs02);
	vmx_switch_loaded_vmcs(vcpu, &vmx->vmcs01);
}

static void vmx_put_vmcs01(struct kvm_vcpu *vcpu)
{
	if (!is_guest_mode(vcpu))
		return;

	vmx_switch_loaded_vmcs(vcpu, &to_vmx(vcpu)->nested.vmcs02);
}
DEFINE_GUARD(vmx_vmcs01, struct kvm_vcpu *,
	     vmx_load_vmcs01(_T), vmx_put_vmcs01(_T))

I've got changes to convert everything to guard(vmx_vmcs01); except for
vmx_set_virtual_apic_mode(), they're all quite trivial.  I also have a selftest
that hits both this bug and the one Chao pointed out, so I'm reasonably confident
the changes do indeed work.

But they're most definitely NOT stable material.  So my plan is to grab this
and the below for 6.19, and then do the cleanup for 6.20 or later.

Oh, almost forgot.  We can also sink the hwapic_isr_update() call into
kvm_apic_update_apicv() and drop kvm_apic_update_hwapic_isr() entirely, which is
another argument for your approach.  That's actually a really good fit, because
that's where KVM parses the vISR when APICv is being _disabled_.

I'll post a v3 with everything tomorrow (hopefully) after running the changes
through more normal test flow.

> 2. Fix the vmx_refresh_apicv_exec_ctrl() issue with an additional patch:
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bcea087b642f..7d98c11a8920 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -19,6 +19,7 @@
>  #include "trace.h"
>  #include "vmx.h"
>  #include "smm.h"
> +#include "x86_ops.h"
> 
>  static bool __read_mostly enable_shadow_vmcs = 1;
>  module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
> @@ -5214,9 +5215,9 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32
> vm_exit_reason,
>                 kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>         }
> 
> -       if (vmx->nested.update_vmcs01_apicv_status) {
> -               vmx->nested.update_vmcs01_apicv_status = false;
> -               kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> +       if (vmx->nested.update_vmcs01_apicv_exec_ctrl) {
> +               vmx->nested.update_vmcs01_apicv_exec_ctrl = false;
> +               vmx_refresh_apicv_exec_ctrl(vcpu);

+1 to the fix, but I'll omit the update_vmcs01_apicv_exec_ctrl rename because I'm
99% certain we can get rid of it entirely.

Oh, and can you give your SoB for this?  I'll write the changelog, just need the
SoB for the commit.  Thanks!

>         }
> 
>         if (vmx->nested.update_vmcs01_hwapic_isr) {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c3b9eb72b6f3..83705a6d5a8a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4415,7 +4415,7 @@ void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
> 
>         if (is_guest_mode(vcpu)) {
> -               vmx->nested.update_vmcs01_apicv_status = true;
> +               vmx->nested.update_vmcs01_apicv_exec_ctrl = true;
>                 return;
>         }
> 
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index ea93121029f9..f6bee0e132a8 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -134,7 +134,7 @@ struct nested_vmx {
>         bool change_vmcs01_virtual_apic_mode;
>         bool reload_vmcs01_apic_access_page;
>         bool update_vmcs01_cpu_dirty_logging;
> -       bool update_vmcs01_apicv_status;
> +       bool update_vmcs01_apicv_exec_ctrl;
>         bool update_vmcs01_hwapic_isr;
> 
>         /*
> 
> 
> 
> By the way, while reviewing source code, I noticed that certain read accesses to
> 'apicv_inhibit_reasons' are not protected by 'apicv_update_lock'.

Those are fine (hopefully; we spent a stupid amount of time sorting out the ordering).
In all cases, a false positive/negative will be remedied before KVM really truly
consumes the result.

