Return-Path: <kvm+bounces-71702-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qAQiMaMpnmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71702-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:43:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A03718D960
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:43:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C7390319162E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA273AE713;
	Tue, 24 Feb 2026 22:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzFTn4Kg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7BC3563E9;
	Tue, 24 Feb 2026 22:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972472; cv=none; b=fddsm6BihHMbtEGxARVXy+1JAVd6mZkPdWaIfQd8oMV0d7XA6uvlH9AiGVqm5ZW77FZOMtz5deV+Si6WOcod46hsY/hB/asH8oqqyT93vKOH5MmuMxkb+9NQYtnX+1+lUOxJmwsAHgVP9c2rNw6tmdmbMjFF0wI8UT5rRvE/MyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972472; c=relaxed/simple;
	bh=FPAWkNTV8oYTTiMhCjkNFMa3V2d8Jopr+IUsm+6qo+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLmeNokA4pCftxYCj45foIHSLf8ucIIcTqzfGxYVLblN8yP/hg/8xP4oz4DbRYSWV9Aa7fXZcwKt38jv2lo7R3nOVFiP0HTfc4UHuTy/bHzf8WC+69qKWji6QQuM177I22oFihehDiZnu+8cT7cm3e9456jbwrapl0aTbw2LZQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzFTn4Kg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E263C2BC87;
	Tue, 24 Feb 2026 22:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972471;
	bh=FPAWkNTV8oYTTiMhCjkNFMa3V2d8Jopr+IUsm+6qo+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzFTn4KgmgfdfsfZb5K8iq28A0LQkl7c1ptre6wb+rMtIdVia7pvbcnJrR3Y+9AqP
	 IcbKzv5uU18XERZQ6+jTUBNeIIKP/F6QyZ2Tw3HG1cdV669DHE11HkUpXHZ+a2ZKOq
	 jzbzxVjyqgk3jqsv9BjoFc4r7Zrgk7BuCKH+Ak9QoXSwb73XxraaE+q72LPCOZwj2+
	 B5GJ3h7nUufZKmgN14Bvvvx/Z06Q0GNGf1M24uIHGyV3j3Z/2OEsu5N8exXMAjMMiv
	 uTaKaH9HGN/sceoPlkQV7N1ZqkfgCTvy8pscLZ5XAZVGKE6IPJGw2M+isvDxBRCHTu
	 2l7jKDIHxhJNg==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v6 26/31] KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
Date: Tue, 24 Feb 2026 22:34:00 +0000
Message-ID: <20260224223405.3270433-27-yosry@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-71702-lists,kvm=lfdr.de];
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
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8A03718D960
X-Rspamd-Action: no action

All accesses to the VMCB12 in the guest memory on nested VMRUN are
limited to nested_svm_vmrun() and nested_svm_vmrun_error_vmexit().
However, the VMCB12 remains mapped throughout nested_svm_vmrun().
Mapping and unmapping around usages is possible, but it becomes easy-ish
to introduce bugs where 'vmcb12' is used after being unmapped.

Move reading the VMCB12 and copying to cache from nested_svm_vmrun()
into a new helper, nested_svm_copy_vmcb12_to_cache(),  that maps the
VMCB12, caches the needed fields, and unmaps it. Use
kvm_vcpu_map_readonly() as only reading the VMCB12 is needed.

Similarly, move mapping the VMCB12 on VMRUN failure into
nested_svm_vmrun_error_vmexit(). Inject a triple fault if the mapping
fails, similar to nested_svm_vmexit().

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 49 +++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2159f5fbfc314..5c8449bc6fa0c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1102,28 +1102,54 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm)
 		kvm_queue_exception(vcpu, DB_VECTOR);
 }
 
-static void nested_svm_vmrun_error_vmexit(struct kvm_vcpu *vcpu, struct vmcb *vmcb12)
+static void nested_svm_vmrun_error_vmexit(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_host_map map;
+	struct vmcb *vmcb12;
 
 	WARN_ON_ONCE(svm->vmcb == svm->nested.vmcb02.ptr);
 
 	leave_guest_mode(vcpu);
 
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		goto out;
+	}
+
+	vmcb12 = map.hva;
 	vmcb12->control.exit_code = SVM_EXIT_ERR;
 	vmcb12->control.exit_info_1 = 0;
 	vmcb12->control.exit_info_2 = 0;
 	vmcb12->control.event_inj = 0;
 	vmcb12->control.event_inj_err = 0;
+	kvm_vcpu_unmap(vcpu, &map);
+out:
 	__nested_svm_vmexit(svm);
 }
 
+static int nested_svm_copy_vmcb12_to_cache(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_host_map map;
+	struct vmcb *vmcb12;
+	int r;
+
+	r = kvm_vcpu_map_readonly(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
+	if (r)
+		return r;
+
+	vmcb12 = map.hva;
+	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
+	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
+	kvm_vcpu_unmap(vcpu, &map);
+	return 0;
+}
+
 int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
-	struct vmcb *vmcb12;
-	struct kvm_host_map map;
 	u64 vmcb12_gpa;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 
@@ -1144,22 +1170,17 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return ret;
 	}
 
+	if (WARN_ON_ONCE(!svm->nested.initialized))
+		return -EINVAL;
+
 	vmcb12_gpa = svm->vmcb->save.rax;
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
+	if (nested_svm_copy_vmcb12_to_cache(vcpu, vmcb12_gpa)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
 	ret = kvm_skip_emulated_instruction(vcpu);
 
-	vmcb12 = map.hva;
-
-	if (WARN_ON_ONCE(!svm->nested.initialized))
-		return -EINVAL;
-
-	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
-	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
-
 	/*
 	 * Since vmcb01 is not in use, we can use it to store some of the L1
 	 * state.
@@ -1180,11 +1201,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		svm->nmi_l1_to_l2 = false;
 		svm->soft_int_injected = false;
 
-		nested_svm_vmrun_error_vmexit(vcpu, vmcb12);
+		nested_svm_vmrun_error_vmexit(vcpu, vmcb12_gpa);
 	}
 
-	kvm_vcpu_unmap(vcpu, &map);
-
 	return ret;
 }
 
-- 
2.53.0.414.gf7e9f6c205-goog


