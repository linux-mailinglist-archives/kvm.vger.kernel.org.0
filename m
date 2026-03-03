Return-Path: <kvm+bounces-72476-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YMH9EnwupmkrLwAAu9opvQ
	(envelope-from <kvm+bounces-72476-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:42:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A58D41E74CF
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:42:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 361C0316707C
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EEBF36BCC4;
	Tue,  3 Mar 2026 00:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WiveKnAA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F594367F3C;
	Tue,  3 Mar 2026 00:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498080; cv=none; b=uEuarOU7VOPsc45h7D4lcUdSvl8lhaYoqPXul0pXcurd8zaNaAOn6i0yfTDT9EuPe6IIcJqXCy0rGz5uO1zmLKg7tjrVqK/qrJIMOCIlflzicloYkeALBZHGblvrHgh8BzwSdvUGGPUjV/3gs/V2rKdJeAgIVdp/Ssnv4w6JSdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498080; c=relaxed/simple;
	bh=t6T5p2jEtoStZk2ZCNurG/WhOCqTBgnABKrBRmfK3Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3G2Zbpttr934YBHrPMFstOJfWaUEAdZ8OasyNiVmsYcREFSJ7oXBZB05PJRHF3EWEjJZMgv5Cz1eatgx5oiGD+/vGtEIiZJZiXi44iq4oTzYCS3HR3oTRTzddm7E4d4tGSFZh2y4H2A5KG0Pe2CiuF59a0+6RN8SrCNQ+7TKSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WiveKnAA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C8EC19423;
	Tue,  3 Mar 2026 00:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498080;
	bh=t6T5p2jEtoStZk2ZCNurG/WhOCqTBgnABKrBRmfK3Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiveKnAAkAzfOFda66zzm2IoS1jhljqRP0atuS/SODnFiCj/IQBiNaftOtNrV5ocH
	 Cx0T7IkDz+KcUSGib0XvdATUQd5A8a3uGtsGBgEVvONp69AVEMf8i7GQ6y5oZ13Vyo
	 JpF+eN+FMKYJTZJiRiaAJq4qOzIp8FsmEcppn1S3NqUlX2d8nhIgPgAGCQT/qClBwW
	 KHIuE/JQMweotwcF/wrrM6scu5IOAOxCkUsKU/aGBD8rLPLpflSPlyvQfhDs3QM0Zk
	 NIAN2R1BYkmxLhvdDPnY+C5hdzV4VtGMTTOJ4lINxJdk5QIfwRugnUyFe9nz9LyYH6
	 uG9gDLLeEH7PQ==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v7 21/26] KVM: nSVM: Restrict mapping vmcb12 on nested VMRUN
Date: Tue,  3 Mar 2026 00:34:15 +0000
Message-ID: <20260303003421.2185681-22-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260303003421.2185681-1-yosry@kernel.org>
References: <20260303003421.2185681-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A58D41E74CF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72476-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

All accesses to the vmcb12 in the guest memory on nested VMRUN are
limited to nested_svm_vmrun() copying vmcb12 fields and writing them on
failed consistency checks. However, vmcb12 remains mapped throughout
nested_svm_vmrun().  Mapping and unmapping around usages is possible,
but it becomes easy-ish to introduce bugs where 'vmcb12' is used after
being unmapped.

Move reading the vmcb12, copying to cache, and consistency checks from
nested_svm_vmrun() into a new helper, nested_svm_copy_vmcb12_to_cache()
to limit the scope of the mapping.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 89 ++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f89040a467d4a..0151354b2ef01 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1054,12 +1054,39 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
 	return 0;
 }
 
-int nested_svm_vmrun(struct kvm_vcpu *vcpu)
+static int nested_svm_copy_vmcb12_to_cache(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	int ret;
-	struct vmcb *vmcb12;
 	struct kvm_host_map map;
+	struct vmcb *vmcb12;
+	int r = 0;
+
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map))
+		return -EFAULT;
+
+	vmcb12 = map.hva;
+	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
+	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
+
+	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
+	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
+		vmcb12->control.exit_code = SVM_EXIT_ERR;
+		vmcb12->control.exit_info_1 = 0;
+		vmcb12->control.exit_info_2 = 0;
+		vmcb12->control.event_inj = 0;
+		vmcb12->control.event_inj_err = 0;
+		svm_set_gif(svm, false);
+		r = -EINVAL;
+	}
+
+	kvm_vcpu_unmap(vcpu, &map);
+	return r;
+}
+
+int nested_svm_vmrun(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int ret, err;
 	u64 vmcb12_gpa;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 
@@ -1080,32 +1107,23 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return ret;
 	}
 
+	if (WARN_ON_ONCE(!svm->nested.initialized))
+		return -EINVAL;
+
 	vmcb12_gpa = svm->vmcb->save.rax;
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
+	err = nested_svm_copy_vmcb12_to_cache(vcpu, vmcb12_gpa);
+	if (err == -EFAULT) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
+	/*
+	 * Advance RIP if #GP or #UD are not injected, but otherwise stop if
+	 * copying and checking vmcb12 failed.
+	 */
 	ret = kvm_skip_emulated_instruction(vcpu);
-
-	vmcb12 = map.hva;
-
-	if (WARN_ON_ONCE(!svm->nested.initialized))
-		return -EINVAL;
-
-	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
-	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
-
-	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
-	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
-		vmcb12->control.exit_code    = SVM_EXIT_ERR;
-		vmcb12->control.exit_info_1  = 0;
-		vmcb12->control.exit_info_2  = 0;
-		vmcb12->control.event_inj = 0;
-		vmcb12->control.event_inj_err = 0;
-		svm_set_gif(svm, false);
-		goto out;
-	}
+	if (err)
+		return ret;
 
 	/*
 	 * Since vmcb01 is not in use, we can use it to store some of the L1
@@ -1122,23 +1140,18 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	svm->nested.nested_run_pending = 1;
 
-	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true))
-		goto out_exit_err;
-
-	if (nested_svm_merge_msrpm(vcpu))
-		goto out;
-
-out_exit_err:
-	svm->nested.nested_run_pending = 0;
-
-	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
-	svm->vmcb->control.exit_info_1  = 0;
-	svm->vmcb->control.exit_info_2  = 0;
+	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true) ||
+	    !nested_svm_merge_msrpm(vcpu)) {
+		svm->nested.nested_run_pending = 0;
+		svm->nmi_l1_to_l2 = false;
+		svm->soft_int_injected = false;
 
-	nested_svm_vmexit(svm);
+		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
+		svm->vmcb->control.exit_info_1  = 0;
+		svm->vmcb->control.exit_info_2  = 0;
 
-out:
-	kvm_vcpu_unmap(vcpu, &map);
+		nested_svm_vmexit(svm);
+	}
 
 	return ret;
 }
-- 
2.53.0.473.g4a7958ca14-goog


