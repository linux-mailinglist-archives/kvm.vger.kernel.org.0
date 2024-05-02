Return-Path: <kvm+bounces-16429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6528A8B9FF1
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 20:00:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F173282708
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 18:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505AF17164D;
	Thu,  2 May 2024 18:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eq1s56iN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC931553BB;
	Thu,  2 May 2024 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714672825; cv=none; b=CHIb1PRaWIstlNtiKt6Z+0jrofURf6AKkoDpb9VIjc2Sayb0oC2k/RVlUpvb8mTLu0SOAkL4XtKP4H4Ng8NI+APHMNckUQ74jo434wCwWekDEInMZywywMJNkh2shgeqbIRi1cKfhfUpvxEQ2WQWII9g0SwVSuCwr+dKKSNyb6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714672825; c=relaxed/simple;
	bh=2ElUwF2ICPzqg1r6ina1TYny/zo1oJOeLgbtQE/BZ90=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DkGzfs0Leb14CX9Q0euK8SbmvYwAwmcILhXf5HaPX11ikxuyQMM++u5jcbu6rBEoZGerd4J1a3W5o1zGipvmEQYu6Bdhws2LWlpS5gjAQ0tkx+YsgwroHyDv+0bRYnq8QmrdzzgeleR3wYoPAFePw2wMwq8eYrTnSC3hCVFa+1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eq1s56iN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF9FC116B1;
	Thu,  2 May 2024 18:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714672825;
	bh=2ElUwF2ICPzqg1r6ina1TYny/zo1oJOeLgbtQE/BZ90=;
	h=From:To:Cc:Subject:Date:From;
	b=Eq1s56iN93KlGgj7TsME+Dhgna/x6TQYGutHM2Bnu6yGiqTdS9k9YOcEIha9PMxMc
	 cBnQPXEWuH+/B6VEcGU4YfTcbr0fin1ycnI6rBUXo6K7Jt45N88YZz3C8WtR5YO5uN
	 IsO+J6O0dCQNVNkxP9MvY647auZ0sv48r6e30cyaylZpVAu42vH6cOYT0EtsXbbeTe
	 toCht87/iIZOV5x4jdNLRFyJ0cuSQP18Gm050d4l78vpwwdz/JpVSXdgyuZDayN2XI
	 wvsE7aX7AX6d5fy51AZcWb3ECEy6jp+9qwSvAdenO5yv9KX485/KQihBOJQLwErOLG
	 ZU+WPeecAvdQA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s2ajH-00A53o-HM;
	Thu, 02 May 2024 19:00:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Correct BTYPE/SS in host SMC emulation
Date: Thu,  2 May 2024 19:00:20 +0100
Message-Id: <20240502180020.3215547-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When taking a trap for an SMC instruction on the host, we must
stau true to the letter of the architecture and perform all the
actions that the CPU would otherwise do. Among those are clearing
the BTYPE and SS bits.

Just do that.

Fixes: a805e1fb3099 ("KVM: arm64: Add SMC handler in nVHE EL2")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
index 4fdfeabefeb4..b1afb7b59a31 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -47,7 +47,13 @@ static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
  */
 static inline void kvm_skip_host_instr(void)
 {
+	u64 spsr = read_sysreg_el2(SYS_SPSR);
+
 	write_sysreg_el2(read_sysreg_el2(SYS_ELR) + 4, SYS_ELR);
+
+	spsr &= ~(PSR_BTYPE_MASK | DBG_SPSR_SS);
+
+	write_sysreg_el2(spsr, SYS_SPSR);
 }
 
 #endif
-- 
2.39.2


