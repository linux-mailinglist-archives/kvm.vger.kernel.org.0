Return-Path: <kvm+bounces-33952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E15739F4D93
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 349DC168BA8
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826FE1F7094;
	Tue, 17 Dec 2024 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nkMX7o6a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761EB1E47BA;
	Tue, 17 Dec 2024 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734445408; cv=none; b=WQtVn+wpZzeKEgjIpuoLZKqp93m5KJ7sts/XlbzrS2GN+gB2yP9r3ePmLPVLwuX+hEtdc7rZeAWIgxF85VFfWjhMm3XLhDd3BUbAvs3RcWGritYo79SuCOEPgx3dXQbtgVF/OlJiBA8orOyr8Q3Fn0eK6eFWKIU+nYXCjuwn7Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734445408; c=relaxed/simple;
	bh=lF2ax88UUsP94gAzYVqXkXrfXc+/lzun8rESgff8Kw8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b3RwlRrLaYo8QVSLW92Tx4PYi9x/cjmvFh90RmVhvAxRfhThms90pBbKBPp9UyeGVi1205kp9h78vE7zbywIcMPL2iO3x1nLrYBf4RNGqSsyDwvZkNfo7ntt+puKwWwpRPD3uCdoDQ7cHwKMI7tjKExQUExICHxaePBCJy98gSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nkMX7o6a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559B0C4CED3;
	Tue, 17 Dec 2024 14:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734445408;
	bh=lF2ax88UUsP94gAzYVqXkXrfXc+/lzun8rESgff8Kw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkMX7o6aZMQc+YTR90omdLeqJQCyfPFiBboJmkdiDnnC/ilocBahACOwO+fC4JQdV
	 NE6aOtD30XLpOdPnJJ+7ETQYG1jLI8vkFp6aNq0PbO/I17BkLX2azdP3YEIKZO9n/A
	 1jmMXNUH+Osu8FvJgCcZRWYGVzwCUzBX9DgFGXaywFPyH3QAlLRQbSx0CHceCdiJbe
	 xOM4OXeLix/51wylaTOZSBfYNJkwymn6osQ5FT37p3PMdAfsyyCIV7vy/bow9353Ga
	 5PLMB5cjEHaRUCq357KJRqhD5O1WEn5yBAP/Hc3WiGU3HpKF5SCqYzlXOg6xk+Kgh3
	 29pthKxKfujew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNYTu-004aJx-CF;
	Tue, 17 Dec 2024 14:23:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: [PATCH v2 09/12] KVM: arm64: nv: Propagate CNTHCTL_EL2.EL1NV{P,V}CT bits
Date: Tue, 17 Dec 2024 14:23:17 +0000
Message-Id: <20241217142321.763801-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217142321.763801-1-maz@kernel.org>
References: <20241217142321.763801-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, eauger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Allow a guest hypervisor to trap accesses to CNT{P,V}CT_EL02 by
propagating these trap bits to the host trap configuration.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6f04f31c0a7f2..e5951e6eaf236 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -824,6 +824,10 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 	 * Apply the enable bits that the guest hypervisor has requested for
 	 * its own guest. We can only add traps that wouldn't have been set
 	 * above.
+	 * Implementation choices: we do not support NV when E2H=0 in the
+	 * guest, and we don't support configuration where E2H is writable
+	 * by the guest (either FEAT_VHE or FEAT_E2H0 is implemented, but
+	 * not both). This simplifies the handling of the EL1NV* bits.
 	 */
 	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
 		u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
@@ -834,6 +838,9 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 
 		tpt |= !(val & (CNTHCTL_EL1PCEN << 10));
 		tpc |= !(val & (CNTHCTL_EL1PCTEN << 10));
+
+		tpt02 |= (val & CNTHCTL_EL1NVPCT);
+		tvt02 |= (val & CNTHCTL_EL1NVVCT);
 	}
 
 	/*
-- 
2.39.2


