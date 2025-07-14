Return-Path: <kvm+bounces-52322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79AF5B03E96
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB2047A8586
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 566D521B91F;
	Mon, 14 Jul 2025 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SkjN7X8l"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0722475E3;
	Mon, 14 Jul 2025 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496004; cv=none; b=rA4typlThfkEyW/ucs0qOYOkRs6oCBR26uk7jCr0AOELtdvy4qP7NpEdJfgmUkRLYqJ7GLPAwKH08LiQZpa4+5i3d1NyXJajdddbztf24yO6QgNk6tpy8AerYrXfRk/UrSRJtUCx5IndrGybRWN8WGYjD/OipuzNg93M5xzVXeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496004; c=relaxed/simple;
	bh=ncwASAA1qi99xaHllmrz6NR9vRZXa0OXO/G8CF9AaoA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XjcWPTn9rdhTnmpJ2iyAlsKWUC9Q7fBTxmhVaTYPwPDT5VyIZGhjKN9SefUHI8/IyKh/Cui7w10rOuTuoYdMqBXxTmU9DzzBNITgrVXjwpAHG/tUJV+sTECTg58szN/EsfEWxUKhgYccBFUWbbShbEEROk9l4sz9EdH760dVl50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SkjN7X8l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3A2C4CEED;
	Mon, 14 Jul 2025 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752496004;
	bh=ncwASAA1qi99xaHllmrz6NR9vRZXa0OXO/G8CF9AaoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkjN7X8lo/gUYjopp59OGVBV5OTYpP6g/nojuQ/EmEgJOt5mwhl+qccDIrpWMqo4L
	 bobBG+h4fu7rVhecD+De3hwcF31M2VRVGoAlNNOwtiR3V/vGmXm/WjQ1IPpxyilevm
	 y5Z4dInppH7HI8yR/2nCMlv7+GzrC06E7+ufXeaHo52yNrzLPXAsKy+Mr1HIQ1sZB+
	 0kQkVtGVBzrPIuolUax1AlVbr5V4/uVRzMsqK+x7oxyxj+l+E5mYXuyh1dUwyFW4rx
	 R/GHkKM5ACGJ93H18ZP/lMHAv4jU/vJlPIeR7zlKyrILcp4ZFWrX0hLq7HMQMZ0BLb
	 JxO8kCVm8pJDg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubIGY-00FW7V-JG;
	Mon, 14 Jul 2025 13:26:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 05/11] KVM: arm64: Let GICv3 save/restore honor visibility attribute
Date: Mon, 14 Jul 2025 13:26:28 +0100
Message-Id: <20250714122634.3334816-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250714122634.3334816-1-maz@kernel.org>
References: <20250714122634.3334816-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The GICv3 save/restore code never needed any visibility attribute,
but that's about to change. Make vgic_v3_has_cpu_sysregs_attr()
check the visibility in case a register is hidden.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 5eacb4b3250a1..6f40225c4a3ff 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -341,8 +341,12 @@ static u64 attr_to_id(u64 attr)
 
 int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
-	if (get_reg_by_id(attr_to_id(attr->attr), gic_v3_icc_reg_descs,
-			  ARRAY_SIZE(gic_v3_icc_reg_descs)))
+	const struct sys_reg_desc *r;
+
+	r = get_reg_by_id(attr_to_id(attr->attr), gic_v3_icc_reg_descs,
+			  ARRAY_SIZE(gic_v3_icc_reg_descs));
+
+	if (r && !sysreg_hidden(vcpu, r))
 		return 0;
 
 	return -ENXIO;
-- 
2.39.2


