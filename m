Return-Path: <kvm+bounces-65553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B4665CB083B
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:12:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0C423012253
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C20933009C1;
	Tue,  9 Dec 2025 16:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vi+SHUqk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655542C21F6
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 16:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765296705; cv=none; b=beNPCDQUfjknRQfLdBUS8ZuodQr7lk/Bl3iDDNl5Vu1ExpsoWEYGlp2BCtRrqZsESYbiaEuFOy6doXkPon0m8bmSEFmisTen1XCWEUa4xQhY5dKKUpIoTgNTMbKhEluffm4XHkCOuscf+CJS/5ERo80jcA11JR8u8vJ1hPq7rXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765296705; c=relaxed/simple;
	bh=Kh7KUxmjE8+scuOUQpnbxS6QQSnQbsbiA9/9F2qRFkY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J3XyX/JSmPhWlrac+iIrAQo338Udz+TIfiyxsaqAjjWbFm6MjxJnYtCCsAjvPkx3Hkfu+d3UMQA38Ko3yVaRIj1ybd9bMGb+TRfGB/O/ewhe+IzM8smvoeCx5sJpJUzeYLWJQH4juz5oKX9C0J/TDQ+yeKxvaBum1fRhRUiiYAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vi+SHUqk; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29806c42760so170127705ad.2
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 08:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765296703; x=1765901503; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=60BxFZFYKgM6eA3TWfbXyscIJHIh4xISbBeoYNqExFw=;
        b=Vi+SHUqkLBYvs5tZ7HQymJyHN0RvIKcZO/07Xgwxp+sjW+gopxDb1d3LgYdIgS27jo
         7tT7L0PBxZXo3MiWqDyvXqn3ec27EsRoWUc/70cV6NDL1CWuKf+4LeTACtwwAf6ZkH0t
         y7Ot1LJ6tsNsyANoGIyZugm8hDvRtUE3/cxg7j+pX4Nn876gybEULWxE1LTUPT7NK26S
         Jss9tYgC4lQR21IupjVBuhAQeXqCe7M1IzSdeK6qVGKnrVs2H9C+28auu/ZQqJ6ME4tm
         dofGeWAR2rLd5vFZ82Lkt4bTVxltiPkQBEIl4yzQl72J+/9Q9mx47cFeBeJUwT1hF3+P
         raLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765296703; x=1765901503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=60BxFZFYKgM6eA3TWfbXyscIJHIh4xISbBeoYNqExFw=;
        b=duH+TofCnMDYW2abFWkN/3rSDIjYcyvqrwJVPhEOsgimXktxzMS7RNHwQHa509fOz/
         +2f4/6adoVMSp/PLM/XESJXjLlJ30+VmrV8lIEl7umWAObgXNcKyB+4/0ltP9KLKqtLz
         TKY5tOJSACN9aJFwMhgS8aG7TFBnfLpzuA4xolwfxgMdY7i1204qS9S6OPcH6aelFsYB
         IXGcqW1etfbDBRaOrw+Hbpdg3q92OBvQ6lP+5EUQmzmT3O9nbfn4XkyGvYvz49bH35q+
         9S03wSCD/KkiIg67qbakxhDRBRnGWncAuxjAHBP29HvpderjBMK8XG/DzAAWJdssYpJX
         kxJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQsqYVUJ6YVQSDceE82RAJHf0oXskSA3lAuEbdGlwWtrmOL38ZaPkCJfjNTBtPKyu1Buk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyod0Ir1vI4t09ld6e9l+HvvntvfjI1lyEzcmQxA8pn9YGqJObz
	Tqg5i8+humgb+fZUB1Efst+4nC16p33LENudHUUzVNBmlCes5A5GxCAtZO941TG13Dgmk8xms0v
	eRYEB9g==
X-Google-Smtp-Source: AGHT+IFgcJ96AP2T+meCJP95P0+gLiXgIEk1wgAmlcWk6nXqvmdJXt7SKpxT1iA2W2b0JnhtfNLC54/YqZI=
X-Received: from plar11.prod.google.com ([2002:a17:902:c7cb:b0:269:7867:579f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf50:b0:299:e031:16d
 with SMTP id d9443c01a7336-29df5dc1902mr66055815ad.33.1765296702709; Tue, 09
 Dec 2025 08:11:42 -0800 (PST)
Date: Tue, 9 Dec 2025 08:11:41 -0800
In-Reply-To: <20251110222922.613224-12-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110222922.613224-1-yosry.ahmed@linux.dev> <20251110222922.613224-12-yosry.ahmed@linux.dev>
Message-ID: <aThKPT9ItrrDZdSd@google.com>
Subject: Re: [PATCH v2 11/13] KVM: nSVM: Simplify nested_svm_vmrun()
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> Call nested_svm_merge_msrpm() from enter_svm_guest_mode() if called from
> the VMRUN path, instead of making the call in nested_svm_vmrun(). This
> simplifies the flow of nested_svm_vmrun() and removes all jumps to
> cleanup labels.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index a48668c36a191..89830380cebc5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1020,6 +1020,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
>  
>  	nested_svm_hv_update_vm_vp_ids(vcpu);
>  
> +	if (from_vmrun && !nested_svm_merge_msrpm(vcpu))

This is silly, just do:

	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true) ||
	    nested_svm_merge_msrpm(vcpu)) {
		svm->nested.nested_run_pending = 0;
		svm->nmi_l1_to_l2 = false;
		svm->soft_int_injected = false;

		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
		svm->vmcb->control.exit_code_hi = -1u;
		svm->vmcb->control.exit_info_1  = 0;
		svm->vmcb->control.exit_info_2  = 0;

		nested_svm_vmexit(svm);
	}

> +		return -1;

Please stop returning -1, use a proper -errno.

> +
>  	return 0;
>  }
>  
> @@ -1105,23 +1108,18 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  
>  	svm->nested.nested_run_pending = 1;
>  
> -	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true))
> -		goto out_exit_err;
> -
> -	if (nested_svm_merge_msrpm(vcpu))
> -		return ret;
> -
> -out_exit_err:
> -	svm->nested.nested_run_pending = 0;
> -	svm->nmi_l1_to_l2 = false;
> -	svm->soft_int_injected = false;
> +	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true)) {
> +		svm->nested.nested_run_pending = 0;
> +		svm->nmi_l1_to_l2 = false;
> +		svm->soft_int_injected = false;
>  
> -	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> -	svm->vmcb->control.exit_code_hi = 0;
> -	svm->vmcb->control.exit_info_1  = 0;
> -	svm->vmcb->control.exit_info_2  = 0;
> +		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> +		svm->vmcb->control.exit_code_hi = 0;
> +		svm->vmcb->control.exit_info_1  = 0;
> +		svm->vmcb->control.exit_info_2  = 0;
>  
> -	nested_svm_vmexit(svm);
> +		nested_svm_vmexit(svm);

Note, there's a pre-existing bug in nested_svm_vmexit().  Lovely, and it's a
user-triggerable WARN_ON() (and not even a WARN_ON_ONCE() at that).

If nested_svm_vmexit() fails to map vmcb12, it (unbelievably stupidly) injects a
#GP and hopes for the best.  Oh FFS, it also has the asinine -EINVAL "logic".
Anyways, it injects #GP (maybe), and bails early, which leaves
KVM_REQ_GET_NESTED_STATE_PAGES set.  KVM will then process that on the next
vcpu_enter_guest() and trip the WARN_ON() in svm_get_nested_state_pages().

Something like this to clean up the mess:

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d4c872843a9d..96f8009a0d45 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1018,9 +1018,6 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
 
        nested_svm_hv_update_vm_vp_ids(vcpu);
 
-       if (from_vmrun && !nested_svm_merge_msrpm(vcpu))
-               return -1;
-
        return 0;
 }
 
@@ -1094,7 +1091,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
        svm->nested.nested_run_pending = 1;
 
-       if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true)) {
+       if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true) ||
+           nested_svm_merge_msrpm(vcpu)) {
                svm->nested.nested_run_pending = 0;
                svm->nmi_l1_to_l2 = false;
                svm->soft_int_injected = false;
@@ -1158,24 +1156,16 @@ void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 int nested_svm_vmexit(struct vcpu_svm *svm)
 {
        struct kvm_vcpu *vcpu = &svm->vcpu;
+       gpa_t vmcb12_gpa = svm->nested.vmcb12_gpa;
        struct vmcb *vmcb01 = svm->vmcb01.ptr;
        struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
        struct vmcb *vmcb12;
        struct kvm_host_map map;
-       int rc;
-
-       rc = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
-       if (rc) {
-               if (rc == -EINVAL)
-                       kvm_inject_gp(vcpu, 0);
-               return 1;
-       }
 
        vmcb12 = map.hva;
 
        /* Exit Guest-Mode */
        leave_guest_mode(vcpu);
-       svm->nested.vmcb12_gpa = 0;
        WARN_ON_ONCE(svm->nested.nested_run_pending);
 
        kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
@@ -1183,6 +1173,13 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
        /* in case we halted in L2 */
        kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
+       svm->nested.vmcb12_gpa = 0;
+
+       if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
+               kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+               return 1;
+       }
+
        /* Give the current vmcb to the guest */
 
        vmcb12->save.es     = vmcb02->save.es;
@@ -1973,7 +1970,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
-       if (WARN_ON(!is_guest_mode(vcpu)))
+       if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
                return true;
 
        if (!vcpu->arch.pdptrs_from_userspace &&


