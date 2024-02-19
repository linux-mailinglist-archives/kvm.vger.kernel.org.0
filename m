Return-Path: <kvm+bounces-9059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2DF6859F86
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:21:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59E282840E5
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DFB428DA0;
	Mon, 19 Feb 2024 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q89F6BMS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C58724B39;
	Mon, 19 Feb 2024 09:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334425; cv=none; b=iuVfcsjnmoBPaEZXCPnXF1x4AGWiEG4RYoPgxtJk+nBzVl6IxPmzy8bqRM8ogsi5BqfUhoatgwhoNq3d4lA1w2n2r9aNj2ZaKrIjtKyi1Gqb9yiEzjCZfsMPp4RPraRMVMt4QvRx9c58E6JXeEDk/Mg+FQbxhK81id//hiFIn2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334425; c=relaxed/simple;
	bh=BXb8tAm/95vFkuq3D2jCOy3oGWf70BBXrMbsz1oxJZA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OpIUEdNvr8RmwvzjV1VjNXcYSFg5y64lZ42/ZzT+SFAeQf1XytJeDrq2L/MrwrdZgOpiGud6M8D6PB51I4UvYYqzgR6ieWLAO6p499TIGKLff7D/EtF2C2UWcD8Njmwuwnk5DsKZeyT3HCgEmVtp+OGBZSY3B/oUVfuB3BQQPFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q89F6BMS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64B8C433C7;
	Mon, 19 Feb 2024 09:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708334425;
	bh=BXb8tAm/95vFkuq3D2jCOy3oGWf70BBXrMbsz1oxJZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q89F6BMSPF9NqMX3WsGiaqpVAB7KuAYncda0xr3oHsn202hR2L14VOCLek7xUEJXE
	 jOIvqFsgUWFGNTM7nVWRai+EWBEcPy5vL00ptNeFFmnoMu273eMSD/i1GGJaTRkYZB
	 hD32hpeGpX6RbRCkL1fpqD6Xa1LXvHNduHKMdSYJaJXyDaLsZNO+IEiVCg67dVvZRu
	 sBhlSWXdZeKdtNn0VsrO2bpO7OXgwyJRxYx9nUa51Q+SxlLDVLPCQ4V1r5bNDjyZmd
	 GFN4sanp2XNEdS8TxEsU7eVCgYhl+oiQOdQO8mk6dhuXr5ybpxZzoS9uDrrCdKjH37
	 35N5dhn7zp+qg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rbzp1-004WBZ-5B;
	Mon, 19 Feb 2024 09:20:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 09/13] KVM: arm64: nv: Reinject PAC exceptions caused by HCR_EL2.API==0
Date: Mon, 19 Feb 2024 09:20:10 +0000
Message-Id: <20240219092014.783809-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219092014.783809-1-maz@kernel.org>
References: <20240219092014.783809-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order for a L1 hypervisor to correctly handle PAuth instructions,
it must observe traps caused by a L1 PAuth instruction when
HCR_EL2.API==0. Since we already handle the case for API==1 as
a fixup, only the exception injection case needs to be handled.

Rework the kvm_handle_ptrauth() callback to reinject the trap
in this case. Note that APK==0 is already handled by the exising
triage_sysreg_trap() helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 1ccdfe40c691..556af771a9e9 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -214,12 +214,34 @@ static int handle_sve(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
- * a NOP). If we get here, it is that we didn't fixup ptrauth on exit, and all
- * that we can do is give the guest an UNDEF.
+ * Two possibilities to handle a trapping ptrauth instruction:
+ *
+ * - Guest usage of a ptrauth instruction (which the guest EL1 did not
+ *   turn into a NOP). If we get here, it is that we didn't fixup
+ *   ptrauth on exit, and all that we can do is give the guest an
+ *   UNDEF (as the guest isn't supposed to use ptrauth without being
+ *   told it could).
+ *
+ * - Running an L2 NV guest while L1 has left HCR_EL2.API==0, and for
+ *   which we reinject the exception into L1. API==1 is handled as a
+ *   fixup so the only way to get here is when API==0.
+ *
+ * Anything else is an emulation bug (hence the WARN_ON + UNDEF).
  */
 static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 {
+	if (!vcpu_has_ptrauth(vcpu)) {
+		kvm_inject_undefined(vcpu);
+		return 1;
+	}
+
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+		return 1;
+	}
+
+	/* Really shouldn't be here! */
+	WARN_ON_ONCE(1);
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
-- 
2.39.2


