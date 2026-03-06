Return-Path: <kvm+bounces-73166-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gGeJKuNCq2nJbgEAu9opvQ
	(envelope-from <kvm+bounces-73166-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:10:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AED1227BD5
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2BD9230F4DF9
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 21:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B59F48B37E;
	Fri,  6 Mar 2026 21:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQt1nSsX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDC248A2AE;
	Fri,  6 Mar 2026 21:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772831352; cv=none; b=lS17pmHvjcE0uBOgAL3V+m+IYfT0a6xtSRBo5AnLcJWAGvhOTONWjckmoNuRRckIATf8bbNguyPKHZ5+//A8NTvYX+BE/uR/ZNFQBTvsTPi4/eXMOFYTSLrb6129NVIsgJQ0/Oj6tVw0wspPU+amxjvRdkC77sRiJmnIe/azQmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772831352; c=relaxed/simple;
	bh=W1GDvhBjURiDIQSdO6sAf7i/CnmSx/BtLxKrERUXc7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZv/bKwqbrx7gVAb7qBYKSa4h/48YPf9u43IPoVFF6VqT0OZO0ZMsS72HBp+jyeg7R2bRlDe8XuWbnavgbgdbvaVihpMZuDMxOuLDdBp3TJ6UWU7YKJpSZiGheJvW659K8y9Gcvg63OqvwHFdXw1NObyww6Qn781b+FKyTbVKUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQt1nSsX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D10DC2BC9E;
	Fri,  6 Mar 2026 21:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772831352;
	bh=W1GDvhBjURiDIQSdO6sAf7i/CnmSx/BtLxKrERUXc7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQt1nSsXr0JyiwaryAGSWx9p2npmCf/1gWOYpifa/dfwWIi8HaEQytM6FPnbbYGyq
	 sQ52Y4PTgCAyaLWnkR2lu9ubVvsk5MspUqz+2BKvvov8/GgI+zq4OUS8axNds1iD5P
	 0gQVKmFSFtj/3s44rHf8i8J2HChVP3TMCcuR8LClDsTaAQ6wMgi4jJoniUEkMfgCq4
	 1VL9H/Ok0lfv9dJOU0+WGMIPFFOi7/4VjvhO/q8aWPJQW7FD4pIkFGejforGK1DZlI
	 PTFBuAwPGqreOSd7qiZC8/7B2PWemxJVo8x4Tn8ii40B3BEJ2bumBMD1IfU67nS4Wh
	 PKW7lXRZL6BsA==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v2 4/6] KVM: nSVM: Fail emulation of VMRUN/VMLOAD/VMSAVE if mapping vmcb12 fails
Date: Fri,  6 Mar 2026 21:08:58 +0000
Message-ID: <20260306210900.1933788-5-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260306210900.1933788-1-yosry@kernel.org>
References: <20260306210900.1933788-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2AED1227BD5
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
	TAGGED_FROM(0.00)[bounces-73166-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.982];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

KVM currently injects a #GP if mapping vmcb12 fails when emulating
VMRUN/VMLOAD/VMSAVE. This is not architectural behavior, as #GP should
only be injected if the physical address is not supported or not aligned
(which hardware will do before the VMRUN intercept is checked).

Instead, handle it as an emulation failure, similar to how nVMX handles
failures to read/write guest memory in several emulation paths.

When virtual VMLOAD/VMSAVE is enabled, if vmcb12's GPA is not mapped in
the NPTs a VMEXIT(#NPF) will be generated, and KVM will install an MMIO
SPTE and emulate the instruction if there is no corresponding memslot.
x86_emulate_insn() will return EMULATION_FAILED as VMLOAD/VMSAVE are not
handled as part of the twobyte_insn cases.

Even though this will also result in an emulation failure, it will only
result in a straight return to userspace if
KVM_CAP_EXIT_ON_EMULATION_FAILURE is set. Otherwise, it would inject #UD
and only exit to userspace if not in guest mode. So the behavior is
slightly different if virtual VMLOAD/VMSAVE is enabled.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 13 ++++++-------
 arch/x86/kvm/svm/svm.c    |  6 ++----
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6d4c053778b21..089cdcfd60340 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1107,15 +1107,14 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	ret = nested_svm_copy_vmcb12_to_cache(vcpu, vmcb12_gpa);
 
 	/*
-	 * Advance RIP if #GP or #UD are not injected, but otherwise
-	 * stop if copying and checking vmcb12 failed.
+	 * Advance RIP if instruction emulation completes, whether it's a
+	 * successful VMRUN or a failed one with #VMEXIT(INVALID), but not if
+	 * #GP/#UD is injected, or if reading vmcb12 fails.
 	 */
-	if (ret == -EFAULT) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	} else if (ret) {
+	if (ret == -EFAULT)
+		return kvm_handle_memory_failure(vcpu, X86EMUL_IO_NEEDED, NULL);
+	else if (ret)
 		return kvm_skip_emulated_instruction(vcpu);
-	}
 
 	ret = kvm_skip_emulated_instruction(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7ec0b0e8945fe..35433bd345eff 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2190,10 +2190,8 @@ static int vmload_vmsave_interception(struct kvm_vcpu *vcpu, bool vmload)
 	if (nested_svm_check_permissions(vcpu))
 		return 1;
 
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map)) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map))
+		return kvm_handle_memory_failure(vcpu, X86EMUL_IO_NEEDED, NULL);
 
 	vmcb12 = map.hva;
 
-- 
2.53.0.473.g4a7958ca14-goog


