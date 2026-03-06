Return-Path: <kvm+bounces-73165-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJvgAdNCq2nJbgEAu9opvQ
	(envelope-from <kvm+bounces-73165-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:10:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 86C5B227BCE
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:10:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A529C30DF415
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 21:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF2D481AAB;
	Fri,  6 Mar 2026 21:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u51syaj+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75090481FCC;
	Fri,  6 Mar 2026 21:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772831352; cv=none; b=fZDh7FXGvIIvtfohjhdmSy2klFI8LgeDuO0A51CQ+tOTtPjGD16v8EphvbxJgAMb1ktApwUDQf0KB20NR9fpgU69RJynG5POWfVlA14qxdT6VQI9hQ0kQCIH9t2H39xLRysJYUJK1TtBSyrGoWWCaLJ+Yt7URHztzf3qwUngqKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772831352; c=relaxed/simple;
	bh=CzgGTWWUcPgcLTG0JmCUypOX1KdDxGsKqlELDtaWJZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlPFVPdvFFB+rXwMvJ1PQoKDjjo5ok7bUIdLpTjoJNZTQkcivgHUoW8iHhoYujuVbQHdZKycDQ7fmaPRCnhVXEyuaKztp8x2iP2NcnOi7+MSFOoKi1Fh/Jme8zofJFegjG1f+AczDr/HJw3qelAq82gJjShwJvNQiKP3gMmptc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u51syaj+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA92C2BCB2;
	Fri,  6 Mar 2026 21:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772831352;
	bh=CzgGTWWUcPgcLTG0JmCUypOX1KdDxGsKqlELDtaWJZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u51syaj+rCMA2ab2LQvD0LoLleEA7d+uWhQm8lWFWiuT4c+KvEbHszr7wJ87l3tri
	 mnjZ6IXMe4D2BbbBkEU47qCQwg7RJTp+nrBqZGLkRTtcs/+GAOEVU+lqFbFiHjZ/L/
	 43YPr7c8GN2kzla8SgLfUa6f9Dipwffisc9PTXt+6gETaIapfW6Z9eDP/qTqdlKBjH
	 qSi7vLaZCCl71kWAi6c5aHD3KoXOH40qDmKDQF4DsPsr/iYiW6BCyB9LFnyabt3nRP
	 q4jPsBVaaowuiX32Rowwb5hzDtkwCuVZNS66rArDAvpei/p8cq37Kn57h2Hovmm+eN
	 +ZYfrXj47jhwQ==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v2 3/6] KVM: SVM: Treat mapping failures equally in VMLOAD/VMSAVE emulation
Date: Fri,  6 Mar 2026 21:08:57 +0000
Message-ID: <20260306210900.1933788-4-yosry@kernel.org>
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
X-Rspamd-Queue-Id: 86C5B227BCE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73165-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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

Currently, a #GP is only injected if kvm_vcpu_map() fails with -EINVAL.
But it could also fail with -EFAULT if creating a host mapping failed.
Inject a #GP in all cases, no reason to treat failure modes differently.

Similar to commit 01ddcdc55e09 ("KVM: nSVM: Always inject a #GP if
mapping VMCB12 fails on nested VMRUN"), treat all failures equally.

Fixes: 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest memory")
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3407deac90bd6..7ec0b0e8945fe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2190,10 +2190,8 @@ static int vmload_vmsave_interception(struct kvm_vcpu *vcpu, bool vmload)
 	if (nested_svm_check_permissions(vcpu))
 		return 1;
 
-	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
-	if (ret) {
-		if (ret == -EINVAL)
-			kvm_inject_gp(vcpu, 0);
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map)) {
+		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
-- 
2.53.0.473.g4a7958ca14-goog


