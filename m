Return-Path: <kvm+bounces-9060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84C9B859F8C
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:21:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F88428409F
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D9EA28DA7;
	Mon, 19 Feb 2024 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tL0BZ/Fn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E173D241E4;
	Mon, 19 Feb 2024 09:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334425; cv=none; b=vCmY7tn3uIPxBLlvpZcHup/ACBUJhUupKWhgq+uHbkKAzJVcdjFk5OiNgSM5ZrVuLcqJ9i2FCGM2qNa3jzNXItCOZHVR5vG9N1RotEUFY9Xq0K3NCuJdbTRyinnW5x4f7WOpJAuulfvAo0lRsm4Hasa9p3nZuYpBLdTrYQd8+Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334425; c=relaxed/simple;
	bh=4kAZSZwBw7KrpIGu7/Ra/W9TXJ5J7n34iChEeNy2XZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jB6JIJDnUSW5LHYT3IZbGfSjbTz30SNpZO/W1LAcnt2nf/bt/q0VM5U1snCRPFxWXUwc7lGwKg7dpQgtQfGcSNwysqIt1yNmUyQ4XWBAlZ2LoYy/HmMWDkBPglpoT7PsJYp8QefVXOta0AI7NuPjtu6Mr3kxXNS/so3a06RuGEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tL0BZ/Fn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF517C433F1;
	Mon, 19 Feb 2024 09:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708334424;
	bh=4kAZSZwBw7KrpIGu7/Ra/W9TXJ5J7n34iChEeNy2XZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tL0BZ/FnfSxi9h9WPq2TR8n8MgilFmZVyGO/koI7YmnjPTAWdN9sBim2tF4cZ/Iq0
	 WACkUXskbbAS5TSP1NEnMfZA3JhUhMEw3RZjyUbXEDQOT7FWtmgeMYAXOwhkGwIlAL
	 Tag+CRt2pbMJowxSAO7+5by7b/EbOL0OmVv8m4IpRAHoraOF9K0ToP3v9e0diGeMKO
	 s9XaxTZUlqQ6o/JwgBZz0nvs5YCbemUeorVfmjt8lIR/26961Xe09AzSbTV8B85YC5
	 VZcaHUuqmMSMKwqye3yNQwKWBx5f3RliBs/yvq/Gwy2iI4RSf09MAwH3LOCalLOBCT
	 t7E5dfaUydzjw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rbzp0-004WBZ-Ot;
	Mon, 19 Feb 2024 09:20:22 +0000
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
Subject: [PATCH 07/13] KVM: arm64: nv: Honor HFGITR_EL2.ERET being set
Date: Mon, 19 Feb 2024 09:20:08 +0000
Message-Id: <20240219092014.783809-8-maz@kernel.org>
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

If the L1 hypervisor decides to trap ERETs while running L2,
make sure we don't try to emulate it, just like we wouldn't
if it had its NV bit set.

The exception will be reinjected from the core handler.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 0c175516d114..a6c61d2ffc35 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -219,7 +219,8 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
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


