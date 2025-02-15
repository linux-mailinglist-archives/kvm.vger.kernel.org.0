Return-Path: <kvm+bounces-38301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9C0A36FD7
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 18:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B351A3B198F
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 17:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15EC31FCCED;
	Sat, 15 Feb 2025 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/6E8OUN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723571EA7E6;
	Sat, 15 Feb 2025 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739641103; cv=none; b=FI7Hz7tGOswS/lKJMuNyYdLM00OqJMw4qU+onAU0aaIlRbJCXKIcKQ55apwkcKoM9PKlXQVU02xQ8fa2L1sgEDIhfPyLDHliNNxxfLJyb10b9FB5WOHwEFxjK699YxG2qJKNA0tHz3W10QC6+p3JITw/2xroQHg+Z/98mENi6yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739641103; c=relaxed/simple;
	bh=mjigrhJTQih8m7VA5C/kcuPrCUbXNvrUzYxrPtFBC4A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ozGn5DnFRLAYzkt2XQcejf3NmsJ1cBWScld1ItlCroA6NbfRa7kU8SFE2Qz/nhOo+EH9nP/tTvmAorRBZtpaGLH0vROYXfXAW6/qLdHuPKverGt4kODHQHdwnn0sRgvNcFzipuWE7KQMzQnAOMP8CYu+T2yUkbN+9fiNJwOeC8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/6E8OUN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3240C4CEEA;
	Sat, 15 Feb 2025 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739641103;
	bh=mjigrhJTQih8m7VA5C/kcuPrCUbXNvrUzYxrPtFBC4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/6E8OUNIPEtJkg80JA8nnXIIHGr6d6atrpEjjOTef4WaC+QHyx2aKjRojhapG74s
	 ppfVO6J2t8H8QBRH+80lrLvZZn3+JGKpet6dEqlB7WO3fpezLhkrk+wwg5FiGoDf4x
	 aXgLB0NnA7mmcFXg7fbCp8U5/W1Nt4gJJ/gk/M2su0qhDJtweErUIUdwLw15KEgAwP
	 b8GA5Wh529IpK/1KDq1BiVq32PsTGgFJuljQlniF1c/w89SFt6lpbYciCsTzc4nk2R
	 i6Pd8LVzCEC5UE4IqG2nrN17oS/YFBw6/mhCQT8Eb6hXRi64ADQkfJ6VN0ZYzV73Cl
	 /JKvt3eChuaqA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjM7R-004Pqp-8D;
	Sat, 15 Feb 2025 17:38:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 05/14] KVM: arm64: Advertise NV2 in the boot messages
Date: Sat, 15 Feb 2025 17:38:07 +0000
Message-Id: <20250215173816.3767330-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215173816.3767330-1-maz@kernel.org>
References: <20250215173816.3767330-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make it a bit easier to understand what people are running by
adding a +NV2 string to the successful KVM initialisation.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 071a7d75be689..4746c6cace2a8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2814,11 +2814,12 @@ static __init int kvm_arm_init(void)
 	if (err)
 		goto out_hyp;
 
-	kvm_info("%s%sVHE mode initialized successfully\n",
+	kvm_info("%s%sVHE%s mode initialized successfully\n",
 		 in_hyp_mode ? "" : (is_protected_kvm_enabled() ?
 				     "Protected " : "Hyp "),
 		 in_hyp_mode ? "" : (cpus_have_final_cap(ARM64_KVM_HVHE) ?
-				     "h" : "n"));
+				     "h" : "n"),
+		 cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) ? "+NV2": "");
 
 	/*
 	 * FIXME: Do something reasonable if kvm_init() fails after pKVM
-- 
2.39.2


