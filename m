Return-Path: <kvm+bounces-2786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 375FF7FDF49
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 19:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 687251C20B6F
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 18:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520625D4AB;
	Wed, 29 Nov 2023 18:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gAgzZ6gR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0244910F
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 10:25:32 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cff359d156so816565ad.2
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 10:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701282331; x=1701887131; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u4fWnS8KCc7MNvbU8xpMSjs/sidzZbsAjD36ZdMftP0=;
        b=gAgzZ6gRAXEtCjf3h8++bsepTJSayLwbPIITAx4f9U+360/8obVhpxnVDSe2LnRPWG
         XgsK87v1UeCrv+FKHYeKQDRL6mM1hidpCfOmoCD3Qqf1W7OrQA4coFN5NfM3ti2ydTiq
         Oa6M34bU9L0co198PlU7HA4Q4yH+ft+dhh9yW1ma+0VnyUuDWwas4myAWYiAN0jJ2d7h
         cgZc+QjDFeeRP0DXvN1kHFjqNN7yux09HDIohtYRr4/Q5AabWgwoiCJZkZFhOC34DIEz
         jQeN0j31qiQb9vysP/fVi5dbJetOL/Vnubj7c5+Hw/reIoWyp/jnC2PvOyJ2/kRM9qKy
         IxYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701282331; x=1701887131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u4fWnS8KCc7MNvbU8xpMSjs/sidzZbsAjD36ZdMftP0=;
        b=GQUvqo3YYiXxp5rwB4sp9CvnM6y4uZTxMRxv22xNvPx2TSjgqOP491bUB/krnCPRRu
         i8W9OREBSO6t1dmrRjefJIK8oMIjnf6DinC1uX0LuMYVPH4matBDvqT6mpWsA9qkqKwy
         v1PEbvSewR+nK971627+S5Kur7+sKeetBw022kOYFCzugOiNDEkbMCT8SkLVAuKuhihz
         u13te2al/WgVj+M6L8PX9AXhnjaRuOPyHJBFE819DJ8qMOE4DXoZM5BojxQqbWIR8ySd
         q3x3D20fbVH/4tJQ0zzPa8HKFOjSSDoSxitP8LMgnR7QrnzGNaMLjEuOVRADLaw0m2sE
         sh1Q==
X-Gm-Message-State: AOJu0YzFmAHZZPQxHqHo5JxEtSErS5T+V2/0b6OEFZjeQRvDf/68QqCv
	0RCc1qg0nvJ76bCdJM5qS6BK9nt1X6I=
X-Google-Smtp-Source: AGHT+IGrxf40BQP7nniTAO79iKHLuD08KvDSxknYYYp6NltQ6nf9nJ8IH7FCZ/mjwcc3S3BbIHJ2rpL9t5Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:11d1:b0:1cf:5d59:8ecc with SMTP id
 q17-20020a17090311d100b001cf5d598eccmr4755463plh.5.1701282331465; Wed, 29 Nov
 2023 10:25:31 -0800 (PST)
Date: Wed, 29 Nov 2023 10:25:29 -0800
In-Reply-To: <bcbc9d0f-8b52-468b-8c69-0e09ec168a39@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231123075818.12521-1-likexu@tencent.com> <ZWVCwvoETD_NVOFG@google.com>
 <bcbc9d0f-8b52-468b-8c69-0e09ec168a39@gmail.com>
Message-ID: <ZWeB_nfLPmyRnbAs@google.com>
Subject: Re: [PATCH] KVM: x86: Use get_cpl directly in case of vcpu_load to
 improve accuracy
From: Sean Christopherson <seanjc@google.com>
To: Like Xu <like.xu.linux@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 29, 2023, Like Xu wrote:
> > Rather than fudge around that ugliness with a kvm_get_running_vcpu() check, what
> > if we instead repurpose kvm_arch_dy_has_pending_interrupt(), which is effectively
> > x86 specific, to deal with not being able to read the current CPL for a vCPU that
> > is (possibly) not "loaded", which AFAICT is also x86 specific (or rather, Intel/VMX
> > specific).
> 
> I'd break it into two parts, the first step applying this simpler, more
> straightforward fix (which is backport friendly compared to the diff below),
> and the second step applying your insight for more decoupling and cleanup.
> 
> You'd prefer one move to fix it, right ?

Yeah, I'll apply your patch first, though if you don't object I'd like to reword
the shortlog+changelog to make it explicitly clear that this is a correctness fix,
that the preemption case really needs to have a separate API, and that checking
for vcpu->preempted isn't safe.

I've applied it to kvm-x86/fixes with the below changelog, holler if you want to
change anything.

[1/1] KVM: x86: Get CPL directly when checking if loaded vCPU is in kernel mode
      https://github.com/kvm-x86/linux/commit/8eedf4177184

    KVM: x86: Get CPL directly when checking if loaded vCPU is in kernel mode
    
    When querying whether or not a vCPU "is" running in kernel mode, directly
    get the CPL if the vCPU is the currently loaded vCPU.  In scenarios where
    a guest is profiled via perf-kvm, querying vcpu->arch.preempted_in_kernel
    from kvm_guest_state() is wrong the vCPU is actively running, i.e. hasn't
    been preempted and so preempted_in_kernel is stale.
    
    This affects perf/core's ability to accurately tag guest RIP with
    PERF_RECORD_MISC_GUEST_{KERNEL|USER} and record it in the sample.  This
    causes perf/tool to fail to connect the vCPU RIPs to the guest kernel
    space symbols when parsing these samples due to incorrect PERF_RECORD_MISC
    flags:
    
       Before (perf-report of a cpu-cycles sample):
          1.23%  :58945   [unknown]         [u] 0xffffffff818012e0
    
       After:
          1.35%  :60703   [kernel.vmlinux]  [g] asm_exc_page_fault
    
    Note, checking preempted_in_kernel in kvm_arch_vcpu_in_kernel() is awful
    as nothing in the API's suggests that it's safe to use if and only if the
    vCPU was preempted.  That can be cleaned up in the future, for now just
    fix the glaring correctness bug.
    
    Note #2, checking vcpu->preempted is NOT safe, as getting the CPL on VMX
    requires VMREAD, i.e. is correct if and only if the vCPU is loaded.  If
    the target vCPU *was* preempted, then it can be scheduled back in after
    the check on vcpu->preempted in kvm_vcpu_on_spin(), i.e. KVM could end up
    trying to do VMREAD on a VMCS that isn't loaded on the current pCPU.
    
    Signed-off-by: Like Xu <likexu@tencent.com>
    Fixes: e1bfc24577cc ("KVM: Move x86's perf guest info callbacks to generic KVM")
    Link: https://lore.kernel.org/r/20231123075818.12521-1-likexu@tencent.com
    [sean: massage changelong, add Fixes]
    Signed-off-by: Sean Christopherson <seanjc@google.com>

> > And if getting the CPL for a vCPU that may not be loaded is problematic for other
> > architectures, then I think the correct fix is to move preempted_in_kernel into
> > common code and check it directly in kvm_vcpu_on_spin().
> 
> Not sure which tests would cover this part of the change.

It'd likely require a human to look at results, i.e. as you did.

> > +bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
> > +{
> > +	/*
> > +	 * Treat the vCPU as being in-kernel if it has a pending interrupt, as
> > +	 * the vCPU trying to yield may be spinning on IPI delivery, i.e. the
> > +	 * the target vCPU is in-kernel for the purposes of directed yield.
> 
> How about the case "vcpu->arch.guest_state_protected == true" ?

Ah, right, the existing code considers vCPUs to always be in-kernel for preemption
checks.

> > +	return vcpu->arch.preempted_in_kernel ||
> > +	       kvm_dy_has_pending_interrupt(vcpu);
> >   }
> >   bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
> > @@ -13043,7 +13051,7 @@ bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
> >   		 kvm_test_request(KVM_REQ_EVENT, vcpu))
> >   		return true;
> > -	return kvm_arch_dy_has_pending_interrupt(vcpu);
> > +	return kvm_dy_has_pending_interrupt(vcpu);
> >   }
> >   bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> > @@ -13051,7 +13059,7 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> >   	if (vcpu->arch.guest_state_protected)
> >   		return true;
> > -	return vcpu->arch.preempted_in_kernel;
> > +	return static_call(kvm_x86_get_cpl)(vcpu);
> 
> We need "return static_call(kvm_x86_get_cpl)(vcpu) == 0;" here.

Doh, I had fixed this locally but forgot to refresh the copy+paste with the updated
diff.

> > -bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
> > +bool __weak kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
> >   {
> > -	return false;
> > +	return kvm_arch_vcpu_in_kernel(vcpu);
> >   }
> >   void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
> > @@ -4086,8 +4086,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
> >   			if (kvm_vcpu_is_blocking(vcpu) && !vcpu_dy_runnable(vcpu))
> >   				continue;
> >   			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
> > -			    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
> > -			    !kvm_arch_vcpu_in_kernel(vcpu))
> > +			    kvm_arch_vcpu_preempted_in_kernel(vcpu))
> 
> Use !kvm_arch_vcpu_preempted_in_kernel(vcpu) ?

Double doh.  Yeah, this is inverted.

