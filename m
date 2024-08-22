Return-Path: <kvm+bounces-24842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BED6495BD13
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 19:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E05E61C220ED
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 17:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7C21CEACB;
	Thu, 22 Aug 2024 17:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UqpQhBq+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E1D1CEAC6
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 17:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724347474; cv=none; b=jF76cRAzuer87MX501zgDohzC0TVkMWCpQkr7Ax20M8X5s5NIR+8AIvqjro51HrL3TlN1qkliz3FYyvjKx2TfNr9zESz5pzt+QTQcVP8SQ8HkNnYnuO/XW7I50DA+U+2TTaPe7CjMcjNapZphF12RmcXsZ7zfMWWv95ZwkBq2G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724347474; c=relaxed/simple;
	bh=FNnRXc/XyYm2YcL44hGop5y6Z9wNRycvY1nLGUoPqJk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GmOmcInBsmQ3QmOD6KCBFYFOdH1pJ5nPfoUcSEEwR++lTHUEByw+DnZwAyKHppPCjUuDYo1zhwoZQ9X5J3db5IfRrDkk/fF88WFZwkpphlBpoMnkR7Rm2Z7itjhjAzmaE7AD4QUygkFaSYX9j1YA305rVQ9Df1XY4g2VlfnNUpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UqpQhBq+; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0b3742b309so1831262276.1
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 10:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724347472; x=1724952272; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p9LDICzt8/AlrjXhgJo1A5epNuZdtFyz7+SWPHqTnTM=;
        b=UqpQhBq+mw1nYYwHgqiIeCoByY0DvlUaOowjrF8KJClhdzeLN3s5D2doSbBefO6Gch
         cSU9NNoy4JFlG2OBw9+SvNWQuRLYEUZFyCzetW/IwL/PgFVTUpuk61zRI21nh7JNYTIb
         minW91xIxRc7qDCu6q8/DuaiFoRIN2xnvQGTOyKiFfInfu72v2/ZNWnPqfArWjcsCiWe
         Zb0tLLPnQV6or6YrFWbQUjW+k2Ck8/WsZOLdPOJNZ+/2HlZcANbMxOPjC6FOt21VTPrw
         sq9DHZcIqr134swDfT7iYE6VXJcaWOCeBl4d+WN6QvmYtLI7LDFJ/F7w2UpOhVJRM6EQ
         N8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724347472; x=1724952272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p9LDICzt8/AlrjXhgJo1A5epNuZdtFyz7+SWPHqTnTM=;
        b=ADw4p2aZNE+duz0dVNM2hBZkt8DDpK+yfIlvgNHvw30cx3TfjeAiiODRtnw/7tehlz
         z/9dKi3sS2+puWkQSgd9b7crEBi+itpQYuttvpN88RC8mh48zqjV1Cuvpv1Tsuqn1PIv
         Tmth9ojNzSsu/6n1sj7FS3hpv3vCAYfzATZtuxMgL0VTxqK5Ixqk1d0u471StIUonw5E
         uEomcp6nK4oSGiaY65DSOIKmLW1LtPcr8iv5tYlhClHThCfFRiH0j+M2I4jXEHk1jEw1
         5FNzFvdngikC9R5uxU/BtplToZU5sMz3MJf/zAU+UyR7Bab0izTWLPPlsAA+x8KuFsdz
         kPTQ==
X-Gm-Message-State: AOJu0YzIlvC5KZXCIqfcnO8XCOkfg05Y9bFs/9D7IiF4fcB77q2yATIM
	cQYXYr6Rv9P28KQnKmwx0wxEocCk1Tw9g6JhnsObUlA7L1fBsczokX05Oku6dzvPJ24yFkQfmIT
	nTQ==
X-Google-Smtp-Source: AGHT+IFpRmyAKzAAwXvy/NbLsL5lVy1d1AR/RBoeGiL9rcELXtRpcBlMCxK5Cc303D478Hkk9FtYHcjHTPI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ace3:0:b0:e11:5f87:1e3c with SMTP id
 3f1490d57ef6-e17a451c2e8mr3839276.11.1724347471987; Thu, 22 Aug 2024 10:24:31
 -0700 (PDT)
Date: Thu, 22 Aug 2024 10:24:30 -0700
In-Reply-To: <20240703175618.2304869-2-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240703175618.2304869-2-aaronlewis@google.com>
Message-ID: <Zsd0TqCeY3B5Sb5b@google.com>
Subject: Re: [PATCH] KVM: x86: Free the MSR filter after destorying VCPUs
From: Sean Christopherson <seanjc@google.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 03, 2024, Aaron Lewis wrote:
> Delay freeing the MSR filter until after the VCPUs are destroyed to
> avoid a possible use-after-free when freeing a nested guest.
> 
> This callstack is from a 5.15 kernel, but the issue still appears to be
> possible upstream.
> 
> kvm_msr_allowed+0x4c/0xd0
> __kvm_set_msr+0x12d/0x1e0
> kvm_set_msr+0x19/0x40
> load_vmcs12_host_state+0x2d8/0x6e0 [kvm_intel]
> nested_vmx_vmexit+0x715/0xbd0 [kvm_intel]
> nested_vmx_free_vcpu+0x33/0x50 [kvm_intel]
> vmx_free_vcpu+0x54/0xc0 [kvm_intel]
> kvm_arch_vcpu_destroy+0x28/0xf0
> kvm_vcpu_destroy+0x12/0x50
> kvm_arch_destroy_vm+0x12c/0x1c0
> kvm_put_kvm+0x263/0x3c0
> kvm_vm_release+0x21/0x30
> __fput+0xb9/0x240
> ____fput+0xe/0x20
> task_work_run+0x6f/0xd0
> syscall_exit_to_user_mode+0x123/0x300
> do_syscall_64+0x72/0xb0
> entry_SYSCALL_64_after_hwframe+0x61/0xc6
> 
> Fixes: b318e8decf6b ("KVM: x86: Protect userspace MSR filter with SRCU, and set atomically-ish")
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Suggested-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 66c4381460dc..638696efa17e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12711,12 +12711,12 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	}
>  	kvm_unload_vcpu_mmus(kvm);
>  	static_call_cond(kvm_x86_vm_destroy)(kvm);
> -	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
>  	kvm_pic_destroy(kvm);
>  	kvm_ioapic_destroy(kvm);
>  	kvm_destroy_vcpus(kvm);
>  	kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
>  	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
> +	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));

This makes the KFENCE/KASAN issues go away, but I'm not so sure it actually fixes
the main problem, which is that doing nested_vmx_vmexit() when freeing a vCPU is
insane.  E.g. it can do VMWRITEs, VMPTRLD, read and write guest memory, write
guest MSRs (which could theoretically write _host_ MSRs), and so on and so fort.

And free_nested() really should free _everything_, i.e. it shouldn't rely on
nested_vmx_vmexit() to do things like cancel hrtimers.

Completely untested, but at a glance I think we can/should do this.  If we need
a fix for stable, then we can move the MSR filter freeing, but going forward, I
think we need to fix the underlying mess.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2392a7ef254d..f5210834a246 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -359,6 +359,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
        kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
        vmx->nested.pi_desc = NULL;
 
+       hrtimer_cancel(&to_vmx(vcpu)->nested.preemption_timer);
+
        kvm_mmu_free_roots(vcpu->kvm, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
 
        nested_release_evmcs(vcpu);
@@ -372,9 +374,10 @@ static void free_nested(struct kvm_vcpu *vcpu)
  */
 void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
-       vcpu_load(vcpu);
-       vmx_leave_nested(vcpu);
-       vcpu_put(vcpu);
+       struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+       vmx->loaded_vmcs = &vmx->vmcs01;
+       free_nested(vcpu);
 }
 
 #define EPTP_PA_MASK   GENMASK_ULL(51, 12)


