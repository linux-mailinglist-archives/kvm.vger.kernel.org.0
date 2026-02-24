Return-Path: <kvm+bounces-71686-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aDayNjYonmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71686-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:37:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 572DE18D711
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 94A2530D67E9
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA79D3624DD;
	Tue, 24 Feb 2026 22:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZ1zeMy1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7FA362132;
	Tue, 24 Feb 2026 22:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972465; cv=none; b=AQjT0tbIesCjlquZiPOGFwT4rjMres7U8+rWIR0ixGL+d3bz9F5YkT5D4gHvmrN1z7v2GCwH9V/yscnhxfr2i3bqg0aFCSNgq3m39NZriSaegV0P7ZOhctAPurvXLXELOHnQpbZae8SrK0CstpJSO/VpP/BTa46DnbEvnVgRj5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972465; c=relaxed/simple;
	bh=drX3y5hy6AEbca6xRJ5i+n/gyJBJwMNXexAazCTSk+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3rNvHaDswCI057x/YrF6twhmNsgv6uUfQqnf+gsDcGQ2VVbSFQqlS/fiVB2AxLphXxq6zGkxGHy/ajCQr5j3amrm3ecHIxPWJ8Tc+qOkJzxgHuaEfqQZUGaO8Cun5G5SVStMFxLwSGk1e3yKaB5NVSrlAvv+1fn4xYg9NZhSP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZ1zeMy1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D869C2BC86;
	Tue, 24 Feb 2026 22:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972465;
	bh=drX3y5hy6AEbca6xRJ5i+n/gyJBJwMNXexAazCTSk+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZ1zeMy1LcZoBbafHoY8s6tvitjkiTbEXOYyEDoyXg4/u1bO8QKrTa/l0kL9ZNSkL
	 Q6jW6U4r/F+aUNbbJX9GZdMHJS6Hj//Og7mZHYva/HxNk/OIBBI1Exq16ZZWDEIm+K
	 qERSa6NFe5eIvz4pAZx8l9IM811Bml0/C31Cd0AX6x/q7cE8Cbx0m81ekbDj/0PlWX
	 dbo6h1x00RF01EQqEwFvR/cYTlz1p+EeXA/pc2+ZEb5UiZdTcoXGGKhOgVE54W4jJL
	 jH8/wsKh7NbJK6fILQqmtLqj+MxlV4QFZvmq5/l0/nb6Fbn72hXUOSt3KIlxewgVsf
	 kAfZ+8+n6bZdA==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 10/31] KVM: nSVM: Drop nested_vmcb_check_{save/control}() wrappers
Date: Tue, 24 Feb 2026 22:33:44 +0000
Message-ID: <20260224223405.3270433-11-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260224223405.3270433-1-yosry@kernel.org>
References: <20260224223405.3270433-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71686-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 572DE18D711
X-Rspamd-Action: no action

The wrappers provide little value and make it harder to see what KVM is
checking in the normal flow. Drop them.

Opportunistically fixup comments referring to the functions, adding '()'
to make it clear it's a reference to a function.

No functional change intended.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d734cd5eef5e7..0592690e75164 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -339,8 +339,8 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
 
-static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
-					 struct vmcb_ctrl_area_cached *control)
+static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
+				       struct vmcb_ctrl_area_cached *control)
 {
 	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
 		return false;
@@ -367,8 +367,8 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 }
 
 /* Common checks that apply to both L1 and L2 state.  */
-static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
-				     struct vmcb_save_area_cached *save)
+static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
+				   struct vmcb_save_area_cached *save)
 {
 	if (CC(!(save->efer & EFER_SVME)))
 		return false;
@@ -402,22 +402,6 @@ static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
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
-	return __nested_vmcb_check_controls(vcpu, ctl);
-}
-
 /*
  * If a feature is not advertised to L1, clear the corresponding vmcb12
  * intercept.
@@ -469,7 +453,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->pause_filter_count  = from->pause_filter_count;
 	to->pause_filter_thresh = from->pause_filter_thresh;
 
-	/* Copy asid here because nested_vmcb_check_controls will check it.  */
+	/* Copy asid here because nested_vmcb_check_controls() will check it */
 	to->asid           = from->asid;
 	to->msrpm_base_pa &= ~0x0fffULL;
 	to->iopm_base_pa  &= ~0x0fffULL;
@@ -1031,8 +1015,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
-	if (!nested_vmcb_check_save(vcpu) ||
-	    !nested_vmcb_check_controls(vcpu)) {
+	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
+	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
@@ -1871,12 +1855,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	ret = -EINVAL;
 	__nested_copy_vmcb_control_to_cache(vcpu, &ctl_cached, ctl);
-	if (!__nested_vmcb_check_controls(vcpu, &ctl_cached))
+	if (!nested_vmcb_check_controls(vcpu, &ctl_cached))
 		goto out_free;
 
 	/*
 	 * Processor state contains L2 state.  Check that it is
-	 * valid for guest mode (see nested_vmcb_check_save).
+	 * valid for guest mode (see nested_vmcb_check_save()).
 	 */
 	cr0 = kvm_read_cr0(vcpu);
         if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
@@ -1890,7 +1874,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
-	    !__nested_vmcb_check_save(vcpu, &save_cached))
+	    !nested_vmcb_check_save(vcpu, &save_cached))
 		goto out_free;
 
 
-- 
2.53.0.414.gf7e9f6c205-goog


