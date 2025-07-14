Return-Path: <kvm+bounces-52336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E55B0421C
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 16:47:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 676C13A8F77
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D426253F11;
	Mon, 14 Jul 2025 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Svq06I1L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE5F198E91;
	Mon, 14 Jul 2025 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752504402; cv=none; b=PhyPz5BkZ1T1qoJmZSxr2r2awfNtO2t3cugAfbXccxNT/2tDRWPFE5JI/IfkLfO8GCVMtkDvDeIdtRbPjXZHO5du38+paa/9azWd9X0RFhf+HY4gLHyhBegWBuwXGlBbWv4y6ILuR57AIcNThH8CcuVKH1bA3pOrRs245RIw8xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752504402; c=relaxed/simple;
	bh=46x8HtFBUnGgwM/Z0aa5GTGEbN7erQRVBDxKEEPldCA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gcuKeLrlIhmtB+TeyDFuA1ZDK7vtfBhhNG/1JOPtavJ+2hli/uh/bETakPOBzitKvfBo5NrjRgi849zOGIM4Vk23DFiqd5vFvMAx2bkJSfU9TydCeFbxupJiTk/dHdhv8eFyKupisLTCcj+enPaVED/mZcNP8WNxNSvwe5ASKw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Svq06I1L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2895EC4CEED;
	Mon, 14 Jul 2025 14:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752504402;
	bh=46x8HtFBUnGgwM/Z0aa5GTGEbN7erQRVBDxKEEPldCA=;
	h=From:To:Cc:Subject:Date:From;
	b=Svq06I1LRxtov0m0O9l5uudGQQs1fchCE9hDZXIvsqIhBpM94YPNTeplYJvFJ5jw6
	 plh//FX/P7g+ue6U0yXupde0hnxHl9jOquJqhUGKkjy7jez7eynrVq60bNE2wlJLEj
	 /GY4y8f3jKgqsQ/GuONpeRM9tgGzF1sEYY7qyeUfl+IcZjvWbEMyY+z5GXP8HXFAGu
	 K7Zrjki8Ox+ieXkvfT7F32qqaMqYjt4Q0fKiqloW86UMdLJLiPUsUNQDBrzdRAarKx
	 LtJxrOvq5lpRZ1GbYbfabZB++pg5TlFKVq+1KgXVNqwu6i626ZpF5PjO5ILEyu0CFT
	 Bth9arRE6b2ag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubKRz-00FYqi-Sk;
	Mon, 14 Jul 2025 15:46:39 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	syzbot+4e09b1432de3774b86ae@syzkaller.appspotmail.com
Subject: [PATCH] KVM: arm64: Clear pending exception state before injecting a new one
Date: Mon, 14 Jul 2025 15:46:36 +0100
Message-Id: <20250714144636.3569479-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, syzbot+4e09b1432de3774b86ae@syzkaller.appspotmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Repeatedly injecting an exception from userspace without running
the vcpu between calls results in a nasty warning, as we're not
really keen on losing already pending exceptions.

But this precaution doesn't really apply to userspace, who can
do whatever it wants (within reason). So let's simply clear any
previous exception state before injecting a new one.

Note that this is done unconditionally, even if the injection
ultimately fails.

Reported-by: syzbot+4e09b1432de3774b86ae@syzkaller.appspotmail.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/guest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index e2702718d56d2..ac6b26e25e191 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -843,6 +843,8 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	u64 esr = events->exception.serror_esr;
 	int ret = 0;
 
+	vcpu_clear_flag(vcpu, EXCEPT_MASK);
+
 	if (ext_dabt_pending)
 		ret = kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 
-- 
2.39.2


