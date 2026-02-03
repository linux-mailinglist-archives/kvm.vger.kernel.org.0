Return-Path: <kvm+bounces-69962-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QKMdNs9LgWkPFgMAu9opvQ
	(envelope-from <kvm+bounces-69962-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 02:13:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6163BD3442
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 02:13:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C50A33015449
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 01:13:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2013E20F08C;
	Tue,  3 Feb 2026 01:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dXJI/0i6"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47351D88B4
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 01:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770081223; cv=none; b=U50PGf84Rm1q0EOGp+Y0LUru+joMku3J6NIOU+fqHwB5hnwzi/yO5U0N8rnZT862YIpyEj1BDAX+EtraNL1z/bh2eMdn50DUMUntIJwUNAdLxgiYBf1gqVLKOtNcJzgpjXKjmkSM4P9+5RbbGoDp+WRWCLJjj5W6aERrKS+MXCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770081223; c=relaxed/simple;
	bh=ta6pw6wNOqCrWjP2bbYcl+cXXp5tkfdAkUDp94AcNpA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A+Qb8Xbwu9mGPdZgbe6r5Qj6t8ZILbbYvj4aDdAbz2d5eznW620Sxb6B3ZcNm04rX+2mbdB/l+wIdZZebqZIdxSmOZj25/evgO/0IjT+ATmXySo9OT+ilvKaYs403/i4VsBm/LQSfCLwnlwMoG5uP9visBZsBT4s5uFdXg/UUPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dXJI/0i6; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770081218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6k4x4TotG0h5oWjhK5Jc0cfmAdQ/uj+dUUOSUP2fT3U=;
	b=dXJI/0i6iwlptH9AGGZH+hu8uNYb5bglAi9ckm3DhF7wFAfqhHucw6hz58TbvnblFw80ti
	vYUr1NB0W/tnjKi3bP3px0LVdB/yl51ZYpAfYhjvusAW2Qp4XGczd1vRxhpFchxlj5Qaw4
	ZY+erBRpIAy/jUjl01w1ARgMJTijvJw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH] KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on nested #VMEXIT
Date: Tue,  3 Feb 2026 01:13:20 +0000
Message-ID: <20260203011320.1314791-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69962-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6163BD3442
X-Rspamd-Action: no action

KVM currently uses the value of CR2 from vmcb02 to update vmcb12 on
nested #VMEXIT. Use the value from vcpu->arch.cr2 instead.

The value in vcpu->arch.cr2 is sync'd to vmcb02 shortly before a VMRUN
of L2, and sync'd back to vcpu->arch.cr2 shortly after. The value are
only out-of-sync in two cases: after migration, and after a #PF is
injected into L2.

After migration, the value of CR2 in vmcb02 is uninitialized (i.e.
zero), as KVM_SET_SREGS restores CR2 value to vcpu->arch.cr2. Using
vcpu->arch.cr2 to update vmcb12 is the right thing to do.

The #PF injection case is more nuanced. It occurs if KVM injects a #PF
into L2, then exits to L1 before it actually runs L2. Although the APM
is a bit unclear about when CR2 is written during a #PF, the SDM is more
clear:

	Processors update CR2 whenever a page fault is detected. If a
	second page fault occurs while an earlier page fault is being
	delivered, the faulting linear address of the second fault will
	overwrite the contents of CR2 (replacing the previous address).
	These updates to CR2 occur even if the page fault results in a
	double fault or occurs during the delivery of a double fault.

KVM injecting the exception surely counts as the #PF being "detected".
More importantly, when an exception is injected into L2 at the time of a
synthesized #VMEXIT, KVM updates exit_int_info in vmcb12 accordingly,
such that an L1 hypervisor can re-inject the exception. If CR2 is not
written at that point, the L1 hypervisor have no way of correctly
re-injecting the #PF. Hence, using vcpu->arch.cr2 is also the right
thing to write in vmcb12 in this case.

Note that KVM does _not_ update vcpu->arch.cr2 when a #PF is pending for
L2, only when it is injected. The distinction is important, because only
injected exceptions are propagated to L1 through exit_int_info. It would
be incorrect to update CR2 in vmcb12 for a pending #PF, as L1 would
perceive an updated CR2 value with no #PF. Update the comment in
kvm_deliver_exception_payload() to clarify this.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 arch/x86/kvm/x86.c        | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd5..9031746ce2db1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1156,7 +1156,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->save.efer   = svm->vcpu.arch.efer;
 	vmcb12->save.cr0    = kvm_read_cr0(vcpu);
 	vmcb12->save.cr3    = kvm_read_cr3(vcpu);
-	vmcb12->save.cr2    = vmcb02->save.cr2;
+	vmcb12->save.cr2    = vcpu->arch.cr2;
 	vmcb12->save.cr4    = svm->vcpu.arch.cr4;
 	vmcb12->save.rflags = kvm_get_rflags(vcpu);
 	vmcb12->save.rip    = kvm_rip_read(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d94..1015522d0fbd7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -864,6 +864,13 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 		vcpu->arch.exception.error_code = error_code;
 		vcpu->arch.exception.has_payload = has_payload;
 		vcpu->arch.exception.payload = payload;
+		/*
+		 * Only injected exceptions are propagated to L1 in
+		 * vmcb12/vmcs12 on nested #VMEXIT. Hence, do not deliver the
+		 * exception payload for L2 until the exception is injected.
+		 * Otherwise, L1 would perceive the updated payload without a
+		 * corresponding exception.
+		 */
 		if (!is_guest_mode(vcpu))
 			kvm_deliver_exception_payload(vcpu,
 						      &vcpu->arch.exception);
-- 
2.53.0.rc2.204.g2597b5adb4-goog


