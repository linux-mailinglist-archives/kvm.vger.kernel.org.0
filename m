Return-Path: <kvm+bounces-71553-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uA7wDHPynGkvMQQAu9opvQ
	(envelope-from <kvm+bounces-71553-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:36:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A038D18042B
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DF5EB30517DF
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02DD4233721;
	Tue, 24 Feb 2026 00:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YHN9pEt+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9CB22A1E1
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771893358; cv=none; b=EwLMuacc79zuxckQ6V7hLdon4bwtfRmkFkJfXjTmDSB7BAjAXlW5aAz3NfZemxxrvsIa7/ufRXrQ7fYpjhpdlPy2m7OvfkxLrevTHQQm+ltFnuZjsZrvLc6nucJiXwEg4+AHasHQOWYGEYNBIHWdXDwBHsA2dntNGrZknEApnvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771893358; c=relaxed/simple;
	bh=M6g0YDap4C1uqReTa7EwkgNp6R9HB4m80rv/FdOmZPc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bMCCp+N7/w+nmdCsay1cSLzF/bCrMbWqKNRPPCUaVj9VUT9WfXDatP5uPAZbbnKivSKCQMgtYPc/8sZ4q2bLTojQcn28wcIH6M6NgBmOxkpZV367K4EZuanJi0kwWfVpoosDQoaWRTer2NF2naTHU7XV0UW9qTfcjo6rZI6gjPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YHN9pEt+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aad60525deso351922785ad.1
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771893356; x=1772498156; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MNsgvRbBMfW3rMafejRvmewmBE10GfmJzRXEziHw284=;
        b=YHN9pEt+lVRth3TxKir0a5Y7O8S45IwZnDPNfWKg7ALp7+xqMaEI3WfwkScNelqsAb
         ud74FcCgo9j05DqDEHSNPMqCIZdcjpGSYp1xoRJfYXWm8FdzxNJLfRBKd+89NeMxm+1y
         olbXKuCYpkHiBKMmUAozJSLZdT9/g7EBfBNHcECoLz83rVGkoZvf889O+955tjp3hUoS
         BVg8wThkbXBrqHxW0QFDTymnWzEoqZlJkyY/TFWrWydCyY/yzBPbJSwiIm+jmZeVGWWH
         GVl5vC8ZlrZAFCxwifzepycZ6tpyuy2lzJ0N8ElmUfzt/RBtVvyLwPShWFzlFcTKoLn7
         AeEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771893356; x=1772498156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MNsgvRbBMfW3rMafejRvmewmBE10GfmJzRXEziHw284=;
        b=Cvj+zyRP8EkMnQ8jMEMdqch7EMutGRIo8hEUquu3iAGk9lYlYAgoT8+7OUxD3DbHO0
         VLOMixqSqsXKtjzjuChfw2U8DsnDXghGIBPnmGHJLH6U/ucBcroQ0nrJ4y++Rr+n+Jez
         vXq0rOhjVULmrmViEqjnPvGsytyi8I2dbbwzt+1c0mABSKDlzrbrRkoHS/i0q1HobkaP
         lRzwmzaUaWv3jNZ2T+aZR1PG8vu6plHDo74P+UlVzEvTFv+b4IhwvsoBNvApXoNiEgsH
         hH+GXH+wo5FDpESGFKRik7GE9J0Xp8hIH0RJKsGLf6nQzdr3qogjV2WcGrbNJqfzWMny
         1x+Q==
X-Forwarded-Encrypted: i=1; AJvYcCV0vE/BHWl1DpEOnmyGzDeHOXcnEybsDarRDucX2C+VvtVJOUYBdtXUGiiNKenAmPFD3aU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8DODSC7kujz0BEHfgH+vTmBWpGRMAyrZclUfwynCM51C4298R
	ijdkuBrxTpozQRDcSPrYpPnUp8YTDd6W67706pRqhDouwTEiPplabTXqyneehEBs/wE+DDXSRkb
	DTxSD5w==
X-Received: from plsd5.prod.google.com ([2002:a17:902:b705:b0:2ab:3156:fa7b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:37cc:b0:2a9:5db8:d651
 with SMTP id d9443c01a7336-2ad744683e8mr95147495ad.25.1771893356036; Mon, 23
 Feb 2026 16:35:56 -0800 (PST)
Date: Mon, 23 Feb 2026 16:35:54 -0800
In-Reply-To: <20260206190851.860662-7-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260206190851.860662-1-yosry.ahmed@linux.dev> <20260206190851.860662-7-yosry.ahmed@linux.dev>
Message-ID: <aZzyanOAcoAnh01A@google.com>
Subject: Re: [PATCH v5 06/26] KVM: nSVM: Triple fault if mapping VMCB12 fails
 on nested #VMEXIT
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71553-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: A038D18042B
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Yosry Ahmed wrote:
> KVM currently injects a #GP and hopes for the best if mapping VMCB12
> fails on nested #VMEXIT, and only if the failure mode is -EINVAL.
> Mapping the VMCB12 could also fail if creating host mappings fails.
> 
> After the #GP is injected, nested_svm_vmexit() bails early, without
> cleaning up (e.g. KVM_REQ_GET_NESTED_STATE_PAGES is set, is_guest_mode()
> is true, etc). Move mapping VMCB12 a bit later, after leaving guest mode
> and clearing KVM_REQ_GET_NESTED_STATE_PAGES, right before the VMCB12 is
> actually used.
> 
> Instead of optionally injecting a #GP, triple fault the guest if mapping
> VMCB12 fails since KVM cannot make a sane recovery. The APM states that
> a #VMEXIT will triple fault if host state is illegal or an exception
> occurs while loading host state, so the behavior is not entirely made
> up.
> 
> Also update the WARN_ON() in svm_get_nested_state_pages() to
> WARN_ON_ONCE() to avoid future user-triggeable bugs spamming kernel logs
> and potentially causing issues.
> 
> Fixes: cf74a78b229d ("KVM: SVM: Add VMEXIT handler and intercepts")
> CC: stable@vger.kernel.org
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index fab0d3d5baa2..830341b0e1f8 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1121,24 +1121,14 @@ void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
>  int nested_svm_vmexit(struct vcpu_svm *svm)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	gpa_t vmcb12_gpa = svm->nested.vmcb12_gpa;
>  	struct vmcb *vmcb01 = svm->vmcb01.ptr;
>  	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
>  	struct vmcb *vmcb12;
>  	struct kvm_host_map map;
> -	int rc;
> -
> -	rc = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
> -	if (rc) {
> -		if (rc == -EINVAL)
> -			kvm_inject_gp(vcpu, 0);
> -		return 1;
> -	}
> -
> -	vmcb12 = map.hva;
>  
>  	/* Exit Guest-Mode */
>  	leave_guest_mode(vcpu);
> -	svm->nested.vmcb12_gpa = 0;
>  	WARN_ON_ONCE(svm->nested.nested_run_pending);
>  
>  	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> @@ -1146,8 +1136,16 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	/* in case we halted in L2 */
>  	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
>  
> +	svm->nested.vmcb12_gpa = 0;
> +
> +	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
> +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> +		return 1;

Returning early isn't entirely correct.  In fact, I think it's worse than the
current behavior in many aspects.

By doing leave_guest_mode() and not switching back to vmcb01 and not putting
vcpu->arch.mmu back to root_mmu, the vCPU will be in L1 but with vmcb02 and L2's
MMU active.

The idea I can come up with is to isolate the vmcb12 writes (which is suprisingly
straightforward), and then simply skip the vmcb12 updates.  E.g.

---
 arch/x86/kvm/svm/nested.c | 95 ++++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fab0d3d5baa2..e8c163d95364 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -639,6 +639,12 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
 }
 
+static bool nested_vmcb12_has_lbrv(struct kvm_vcpu *vcpu)
+{
+	return guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
+	       to_svm(vcpu)->nested.ctl.virt_ext;
+}
+
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	bool new_vmcb12 = false;
@@ -703,8 +709,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		vmcb_mark_dirty(vmcb02, VMCB_DR);
 	}
 
-	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+	if (nested_vmcb12_has_lbrv(vcpu)) {
 		/*
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
 		 * svm_set_msr's definition of reserved bits.
@@ -1118,35 +1123,14 @@ void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 	to_vmcb->save.sysenter_eip = from_vmcb->save.sysenter_eip;
 }
 
-int nested_svm_vmexit(struct vcpu_svm *svm)
+static void nested_svm_vmexit_update_vmcb12(struct kvm_vcpu *vcpu,
+					    struct vmcb *vmcb12,
+					    struct vmcb *vmcb02)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct vmcb *vmcb01 = svm->vmcb01.ptr;
-	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
-	struct vmcb *vmcb12;
-	struct kvm_host_map map;
-	int rc;
+	struct vcpu_svm *svm = to_svm(vcpu);
 
-	rc = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
-	if (rc) {
-		if (rc == -EINVAL)
-			kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
-	vmcb12 = map.hva;
-
-	/* Exit Guest-Mode */
-	leave_guest_mode(vcpu);
-	svm->nested.vmcb12_gpa = 0;
-	WARN_ON_ONCE(svm->nested.nested_run_pending);
-
-	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
-
-	/* in case we halted in L2 */
-	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
-
-	/* Give the current vmcb to the guest */
+	if (!vmcb12)
+		return;
 
 	vmcb12->save.es     = vmcb02->save.es;
 	vmcb12->save.cs     = vmcb02->save.cs;
@@ -1184,14 +1168,53 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
 		vmcb12->control.next_rip  = vmcb02->control.next_rip;
 
+	if (nested_vmcb12_has_lbrv(vcpu))
+		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
+
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
 	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
 	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
+	trace_kvm_nested_vmexit_inject(vmcb12->control.exit_code,
+				       vmcb12->control.exit_info_1,
+				       vmcb12->control.exit_info_2,
+				       vmcb12->control.exit_int_info,
+				       vmcb12->control.exit_int_info_err,
+				       KVM_ISA_SVM);
+}
+
+int nested_svm_vmexit(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
+	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
+	struct vmcb *vmcb12;
+	struct kvm_host_map map;
+	int rc;
+
+	if (!kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map)) {
+		vmcb12 = map.hva;
+	} else {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		vmcb12 = NULL;
+	}
+
+	/* Exit Guest-Mode */
+	leave_guest_mode(vcpu);
+	svm->nested.vmcb12_gpa = 0;
+	WARN_ON_ONCE(svm->nested.nested_run_pending);
+
+	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+
+	/* in case we halted in L2 */
+	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
+
+	/* Give the current vmcb to the guest */
+	nested_svm_vmexit_update_vmcb12(vcpu, vmcb12, vmcb02);
+
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
 		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
-
 	}
 
 	/*
@@ -1232,10 +1255,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (!nested_exit_on_intr(svm))
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
-	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
-		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
-	} else {
+	if (!nested_vmcb12_has_lbrv(vcpu)) {
 		svm_copy_lbrs(&vmcb01->save, &vmcb02->save);
 		vmcb_mark_dirty(vmcb01, VMCB_LBR);
 	}
@@ -1291,13 +1311,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->vcpu.arch.dr7 = DR7_FIXED_1;
 	kvm_update_dr7(&svm->vcpu);
 
-	trace_kvm_nested_vmexit_inject(vmcb12->control.exit_code,
-				       vmcb12->control.exit_info_1,
-				       vmcb12->control.exit_info_2,
-				       vmcb12->control.exit_int_info,
-				       vmcb12->control.exit_int_info_err,
-				       KVM_ISA_SVM);
-
 	kvm_vcpu_unmap(vcpu, &map);
 
 	nested_svm_transition_tlb_flush(vcpu);

base-commit: 2125912d022f4740238a950469da505783945be6
--

