Return-Path: <kvm+bounces-15233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D4F08AACD5
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DE1E1F21EB2
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E258003F;
	Fri, 19 Apr 2024 10:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UfVa3ZqF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B704E78276;
	Fri, 19 Apr 2024 10:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522592; cv=none; b=KjSHXCaUV3tYWD/45PQGXoEq5PctkG8JieJ4yFmBUDbgjQ5vopz4S/fJgcTEQnydOeEFpgA50tYytDzx2zOCJ9etuLyanJrC9wIz274kBNjBP8HCUHGkj367GPkxnB9QG39YDCovVRqNCkN4/mzx81rYS9kfCCm8CT+uWHBZ8zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522592; c=relaxed/simple;
	bh=PcLim/KmKXgvfK0zZahv5eoT9zsPnsz7Cs5wQESJbb0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iyqjq/64mfvlV1YVeBjPsJw4uFMjIPYn8j5CyRxRzs0ZGbqtloaI/L01d2zOI01q5/2s0y7RtUo9zu1tcdgBSAsmkP7rPrqux4ffutnVkTCVT+xvm14X82IlXRnksWla3l487qY2KxjGbb8+kO214iNjzp/hgVRfnfCiEhTXuRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UfVa3ZqF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9448DC3277B;
	Fri, 19 Apr 2024 10:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522592;
	bh=PcLim/KmKXgvfK0zZahv5eoT9zsPnsz7Cs5wQESJbb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfVa3ZqFVVai07mBnhGDCE0D8AzVON7uUb5tZ5fBY5Lz1wn7am8guF2RxitqfucQu
	 QCROhze7GpJTSc3Y1q5HbqEoeb/wmfBitkTSN3+yBERMOHZHnWH5ZB4Q4fhKVY5qKl
	 TL/N5Xqgg+H9b8cPspSvynuj3tcIbafsqO1ndyUz8RWvG2g+ZH+0wkBT/3k2FvxDe4
	 Xqr3jAGGjhHJCHXz5RfR8HQ7XKo9SF7EfArUpeaNIgYOebsj7IUDolx8U6k7pH3D6u
	 pXk5ZhQ0903Af+/rWFH9MhmdMDmDFaExhFFzn8DSR2QQNOIT6BDpeOFGxlxpmvow/P
	 L/v2/QaA7QdPw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlV8-00636W-O0;
	Fri, 19 Apr 2024 11:29:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 08/15] KVM: arm64: nv: Honor HFGITR_EL2.ERET being set
Date: Fri, 19 Apr 2024 11:29:28 +0100
Message-Id: <20240419102935.1935571-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If the L1 hypervisor decides to trap ERETs while running L2,
make sure we don't try to emulate it, just like we wouldn't
if it had its NV bit set.

The exception will be reinjected from the core handler.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 390c7d99f617..26395171621b 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -220,7 +220,8 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * Unless the trap has to be forwarded further down the line,
 	 * of course...
 	 */
-	if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV)
+	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV) ||
+	    (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET))
 		return false;
 
 	spsr = read_sysreg_el1(SYS_SPSR);
-- 
2.39.2


