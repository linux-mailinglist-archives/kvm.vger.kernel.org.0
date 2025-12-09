Return-Path: <kvm+bounces-65552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E4338CB07EA
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:03:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 14D673016B89
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 372442FFF89;
	Tue,  9 Dec 2025 16:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vx87W573"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D0121CC58
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 16:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765296199; cv=none; b=B0svlyq6V5N/bFx8G9vYhKLkDZkHPennRRnuVOCzmB8T30cQNJ+6vjxZTgWhjJDDV3dN+ZKe9npyUNh0y94cpEH7JyKHmUP3lk7cVf4ArrjXBkC148L9wtmlrlJyqCtWV/+gx0BxvLQ6Q593qyCbQAbNOdGG/D/9HWxFTYOYz0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765296199; c=relaxed/simple;
	bh=CQNMzGWKNG8yGe7obh87TRcznlg7PKmrFPNXMzAxoUA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P24F/EbNe6TZHkoENhnG5SWoUybGkbhWJs6WNb7nNCK1x76CjN0misrSCEu55aH5ILDvgOrOQSkS9bJqoDMDvZHOHP6W2kr4bPdY/jmqwBr+3ZrLPHMommOe4tHDEp/qZ+pVWg35YRztfOjvk7DhijlemjMc/nDZQU0BFq4f8aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vx87W573; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34a1bca4c23so4105650a91.1
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 08:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765296197; x=1765900997; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6E7UtjiHBzKMQ+diuhzveVTThdgH8taH9j8g+Q5cMAo=;
        b=Vx87W573S2hkcTD6O16IiYRFNrze6IC7K3V4qwZTM8MGN9uZcJCCGL1sgg/oYDDF0P
         ixrfQo/dIZrXA1ySvZmy4OclmrFTcdlcjKs2zxDFtxQ7lzLp5mIj+3KvehRiEBcG2FVu
         uzFe/USJyJjzS1ds/G/JJR0lMGHZ9ftg2flM5bIReeuxK5ARG0vnRaVKr83eYgXecv5N
         vy3y9LgZI2NHuEnE/SnXG8RdK2hGGymQ1Ir+yt7UKbGqh+MgjuQsOooMofWKHz8BZKuW
         a8DVNSAQs1q8nSYej40ebFUGXwn85AlQed4PTw6aCUQInLiRBxg4GZzucGzUsUOv92fI
         ZgSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765296197; x=1765900997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6E7UtjiHBzKMQ+diuhzveVTThdgH8taH9j8g+Q5cMAo=;
        b=ci9U0EIkUOzOKvhLnSMwFMQfIofo+px5uLmTWUyJAcWcRkG/D6MyFLXy+zTK1zXzjD
         72pcgvLoPBOWojvkTPdR73D0XNB4M6DJNmA/pGxzG9e3cvwr8klsmleAiPPFboiB4ikB
         zRM9HAE1gcfHpKyMtxqfYX0HeqNei0kqtPG7tCpkup/LhH/tPgtv+HG+6EOlY70fJ+9x
         nSDaVYmKfW8R9JAGC8Vre/ZEgY4Nq7VF3EXImesznOZRTtiipckWF5b2+TSS51qI/yoS
         I0mTla+RHHDSs5TNYLxPGMTYiGS31zje01k/NdX6NRDNihEPUMN59S0ZpySNFE1i2DOA
         oraA==
X-Forwarded-Encrypted: i=1; AJvYcCXaHpli1IwXdmh+jIlATL6Ejpre2lIQF/De9wWd66NYdjhjxnC7anxhHO1xES9BxIiZa2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQj6zFJvJ4LSPv05EsLA2ej3ZDNVqPFKRSdVJ5iHDUuLgXCWLL
	jro6dPxsESYNaQjc7lXZ2TeilE1TRU+eDm8Gust+chf4uZrBqQ7QdR1VFcEfiiKq6W7qXM+4AV/
	ulf7RPQ==
X-Google-Smtp-Source: AGHT+IEWTBlGcfg7DxjxR0GF7osNfR9d8IDS+CQFSZyrfCNFdQbSgp1tdOxpx8gG1tM9gJV0Jm40uZKyQsI=
X-Received: from pjzb11.prod.google.com ([2002:a17:90a:e38b:b0:339:ae3b:2bc7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1642:b0:349:19a8:e00e
 with SMTP id 98e67ed59e1d1-349a25e645amr9161849a91.31.1765296196868; Tue, 09
 Dec 2025 08:03:16 -0800 (PST)
Date: Tue, 9 Dec 2025 08:03:15 -0800
In-Reply-To: <20251110222922.613224-11-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110222922.613224-1-yosry.ahmed@linux.dev> <20251110222922.613224-11-yosry.ahmed@linux.dev>
Message-ID: <aThIQzni6fC1qdgj@google.com>
Subject: Re: [PATCH v2 10/13] KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> All accesses to the VMCB12 in the guest memory are limited to
> nested_svm_vmrun(). However, the VMCB12 remains mapped until the end of
> the function execution. Unmapping right after the consistency checks is
> possible, but it becomes easy-ish to introduce bugs where 'vmcb12' is
> used after being unmapped.
> 
> Move all accesses to the VMCB12 into a new helper,
> nested_svm_vmrun_read_vmcb12(),  that maps the VMCB12,
> caches the needed fields, performs consistency checks, and unmaps it.
> This limits the scope of the VMCB12 mapping appropriately. It also
> slightly simplifies the cleanup path of nested_svm_vmrun().
> 
> nested_svm_vmrun_read_vmcb12() returns -1 if the consistency checks
> fail, maintaining the current behavior of skipping the instructions and
> unmapping the VMCB12 (although in the opposite order).
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 59 ++++++++++++++++++++++-----------------
>  1 file changed, 34 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index ddcd545ec1c3c..a48668c36a191 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1023,12 +1023,39 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
>  	return 0;
>  }
>  
> +static int nested_svm_vmrun_read_vmcb12(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)

"read_vmcb12"() sounds like a generic helper to read a specific field.  And if
the name is more specific, then I think we can drop the "vmrun" scoping.  To
aligh with similar functions in VMX and __nested_copy_vmcb_save_to_cache(), how
about nested_svm_copy_vmcb12_to_cache()?

> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct kvm_host_map map;
> +	struct vmcb *vmcb12;
> +	int ret;
> +
> +	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
> +	if (ret)
> +		return ret;
> +
> +	vmcb12 = map.hva;
> +
> +	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
> +	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> +
> +	if (!nested_vmcb_check_save(vcpu) ||
> +	    !nested_vmcb_check_controls(vcpu)) {
> +		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> +		vmcb12->control.exit_code_hi = 0;
> +		vmcb12->control.exit_info_1  = 0;
> +		vmcb12->control.exit_info_2  = 0;
> +		ret = -1;

I don't love shoving the consistency checks in here.  I get why you did it, but
it's very surprising to see (and/or easy to miss) these consistency checks.  The
caller also ends up quite wonky:

	if (ret == -EINVAL) {
		kvm_inject_gp(vcpu, 0);
		return 1;
	} else if (ret) {
		return kvm_skip_emulated_instruction(vcpu);
	}

	ret = kvm_skip_emulated_instruction(vcpu);

Ha!  And it's buggy.  __kvm_vcpu_map() can return -EFAULT if creating a host
mapping fails.  Eww, and blindly using '-1' as the "failed a consistency check"
is equally cross, as it relies on kvm_vcpu_map() not returning -EPERM in a very
weird way.

Ugh, and there's also this nastiness in nested_vmcb_check_controls():

	 * Make sure we did not enter guest mode yet, in which case
	 * kvm_read_cr0() could return L2's CR0.
	 */
	WARN_ON_ONCE(is_guest_mode(vcpu));
	return __nested_vmcb_check_controls(vcpu, ctl, kvm_read_cr0(vcpu));

nested_vmcb_check_save() and nested_vmcb_check_controls() really shouldn't exist.
They just make it harder to see what KVM is checking in the "normal" flow.

Aha!  And I'm fairly certain there are at least two pre-existing bugs due to KVM
doing "early" consistency checks in nested_svm_vmrun().

  1. KVM doesn't clear GIF on the early #VMEXIT.  In classic APM fashion, nothing
     _requires_ GIF=0 before VMRUN:

        It is assumed that VMM software cleared GIF some time before executing
        the VMRUN instruction, to ensure an atomic state switch.

     And so VMRUN with GIF=1 that hits an "early" consistency check #VMEXIT would
     incorrectly leave GIF=1.


  2. svm_leave_smm() is missing consistency checks on the newly loaded guest state,
     because the checks aren't performed by enter_svm_guest_mode().  I don't see
     anything that would prevent vmcb12 from being modified by the guest bewteen
     SMI and RSM.

Moving the consistency checks into enter_svm_guest_mode() would solve all three
(four?) problems.  And as a bonus, nested_svm_copy_vmcb12_to_cache() can use
kvm_vcpu_map_readonly().

Compile tested only, but I think we can end up with delta like so:

---
 arch/x86/kvm/svm/nested.c | 67 ++++++++++++---------------------------
 1 file changed, 20 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7c86987fdaca..8a0df6c535b5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -372,9 +372,9 @@ static bool nested_svm_check_event_inj(struct kvm_vcpu *vcpu, u32 event_inj)
 	return true;
 }
 
-static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
-					 struct vmcb_ctrl_area_cached *control,
-					 unsigned long l1_cr0)
+static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
+				       struct vmcb_ctrl_area_cached *control,
+				       unsigned long l1_cr0)
 {
 	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
 		return false;
@@ -408,8 +408,8 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 }
 
 /* Common checks that apply to both L1 and L2 state.  */
-static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
-				     struct vmcb_save_area_cached *save)
+static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
+				   struct vmcb_save_area_cached *save)
 {
 	if (CC(!(save->efer & EFER_SVME)))
 		return false;
@@ -448,27 +448,6 @@ static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb_save_area_cached *save = &svm->nested.save;
-
-	return __nested_vmcb_check_save(vcpu, save);
-}
-
-static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb_ctrl_area_cached *ctl = &svm->nested.ctl;
-
-	/*
-	 * Make sure we did not enter guest mode yet, in which case
-	 * kvm_read_cr0() could return L2's CR0.
-	 */
-	WARN_ON_ONCE(is_guest_mode(vcpu));
-	return __nested_vmcb_check_controls(vcpu, ctl, kvm_read_cr0(vcpu));
-}
-
 static
 void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 					 struct vmcb_ctrl_area_cached *to,
@@ -1004,6 +983,12 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
+
+	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
+	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl,
+					svm->vmcb01.ptr->save.cr0))
+		return -EINVAL;
+
 	nested_vmcb02_prepare_control(svm, save->rip, save->cs.base);
 	nested_vmcb02_prepare_save(svm);
 
@@ -1025,33 +1010,24 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
 	return 0;
 }
 
-static int nested_svm_vmrun_read_vmcb12(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
+static int nested_svm_copy_vmcb12_to_cache(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_host_map map;
 	struct vmcb *vmcb12;
-	int ret;
+	int r;
 
-	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
-	if (ret)
-		return ret;
+	r = kvm_vcpu_map_readonly(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
+	if (r)
+		return r;
 
 	vmcb12 = map.hva;
 
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
-	if (!nested_vmcb_check_save(vcpu) ||
-	    !nested_vmcb_check_controls(vcpu)) {
-		vmcb12->control.exit_code    = SVM_EXIT_ERR;
-		vmcb12->control.exit_code_hi = -1u;
-		vmcb12->control.exit_info_1  = 0;
-		vmcb12->control.exit_info_2  = 0;
-		ret = -1;
-	}
-
 	kvm_vcpu_unmap(vcpu, &map);
-	return ret;
+	return 0;
 }
 
 int nested_svm_vmrun(struct kvm_vcpu *vcpu)
@@ -1082,12 +1058,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	vmcb12_gpa = svm->vmcb->save.rax;
-	ret = nested_svm_vmrun_read_vmcb12(vcpu, vmcb12_gpa);
-	if (ret == -EINVAL) {
+	if (nested_svm_copy_vmcb12_to_cache(vcpu, vmcb12_gpa)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
-	} else if (ret) {
-		return kvm_skip_emulated_instruction(vcpu);
 	}
 
 	ret = kvm_skip_emulated_instruction(vcpu);
@@ -1919,7 +1892,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	ret = -EINVAL;
 	__nested_copy_vmcb_control_to_cache(vcpu, &ctl_cached, ctl);
 	/* 'save' contains L1 state saved from before VMRUN */
-	if (!__nested_vmcb_check_controls(vcpu, &ctl_cached, save->cr0))
+	if (!nested_vmcb_check_controls(vcpu, &ctl_cached, save->cr0))
 		goto out_free;
 
 	/*
@@ -1938,7 +1911,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
-	    !__nested_vmcb_check_save(vcpu, &save_cached))
+	    !nested_vmcb_check_save(vcpu, &save_cached))
 		goto out_free;
 
 

base-commit: 01597a665f5dcf8d7cfbedf36f4e6d46d045eb4f
--


