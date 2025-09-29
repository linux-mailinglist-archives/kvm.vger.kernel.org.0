Return-Path: <kvm+bounces-59007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE64BBA9F3A
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E92DF3C2B5F
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7534A30E0E1;
	Mon, 29 Sep 2025 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BK2ikC9N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6162530DD16;
	Mon, 29 Sep 2025 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161907; cv=none; b=SkqJycjgD/7WhS9CKMXKmard/GrkQSNjFj4iyNYBfjfDTrNUgJHxnB8BLc7eW8j5C2fvi+6mzwkm9cQZMyKq7ulhcR/XQBSIn2myMpCgbwm6NQeGVDEBJpQm3t2JHEehIlAhGWNt5tML4xb7xMsY6UuGXQZICHobzQdffWnl998=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161907; c=relaxed/simple;
	bh=sxh21aUMK0goU7+ee1G2UCf1HO4Rfb84evxHrAlsjD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdEUn/lGt3yU+b63aXjCXwiBzfKLfVPniNfu51/ziQpMiimIJorw7/j2h0wkmUNvi1s024Wl7TJP3gEUEnoplyBXPpmTwCuouPNN/GO/L4KtugDLrB9KsnoHqwtofadMakX84LbAhNrvH5kykUBC7dmzhr3kZpOcD/LxRtxAL10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BK2ikC9N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4383CC4CEF7;
	Mon, 29 Sep 2025 16:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161907;
	bh=sxh21aUMK0goU7+ee1G2UCf1HO4Rfb84evxHrAlsjD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BK2ikC9NkCAgqKRbqpMLgH7fXcG3NXQ7TbMMs8Ja9lwk0tDI277lW7yasOWyl80c6
	 B0r3Gb+HxTj7tigapfVLGaisgJTg59FNtdiavwowynAY7YOPi4tnUaOegFzG9Ucyk8
	 EETCPgirsp2mGPgQqultjo0twyTJbDdLalCiFxJLYVptOPPuMzn1l5BcZO+r51Ajo3
	 XcUfKHSDyq/lCA4sneNvVbaXpRoqrEteGWl11Y6R1EuUjU4558QkgTiUuMtF7vXyG9
	 GsUqWkeUmXmiLySRH9NXoSOV94NJhwZFqCgEyZkLcuGj5altqQCL7s+XpItW+T6csT
	 vCK0HqwbwLgpg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN7-0000000AHqo-1oaN;
	Mon, 29 Sep 2025 16:05:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 09/13] KVM: arm64: Fix WFxT handling of nested virt
Date: Mon, 29 Sep 2025 17:04:53 +0100
Message-ID: <20250929160458.3351788-10-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929160458.3351788-1-maz@kernel.org>
References: <20250929160458.3351788-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The spec for WFxT indicates that the parameter to the WFxT instruction
is relative to the reading of CNTVCT_EL0. This means that the implementation
needs to take the execution context into account, as CNTVOFF_EL2
does not always affect readings of CNTVCT_EL0 (such as when HCR_EL2.E2H
is 1 and that we're in host context).

This also rids us of the last instance of KVM_REG_ARM_TIMER_CNT
outside of the userspace interaction code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d449e15680e46..415f91ee8bcbf 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -147,7 +147,12 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 		if (esr & ESR_ELx_WFx_ISS_RV) {
 			u64 val, now;
 
-			now = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_TIMER_CNT);
+			now = kvm_phys_timer_read();
+			if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
+				now -= timer_get_offset(vcpu_hvtimer(vcpu));
+			else
+				now -= timer_get_offset(vcpu_vtimer(vcpu));
+
 			val = vcpu_get_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu));
 
 			if (now >= val)
-- 
2.47.3


