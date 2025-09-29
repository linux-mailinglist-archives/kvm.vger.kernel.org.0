Return-Path: <kvm+bounces-59003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC8CBA9F0D
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6819E7A24DA
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83DE930DD26;
	Mon, 29 Sep 2025 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mguS8PJ5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9960D30CB55;
	Mon, 29 Sep 2025 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161906; cv=none; b=U36fZH+KmoBPdbgX2DeuVO7n/WEUUXc1JdiuHKL0z9pTikz+rPP6yQBN3kLO57FVRgiNZeX62X/TtnH9jt8c+WROzpILxq6yXeSX2TkwD4/qo1EnExZUIS+fJPrC1MowRE2t1vLgMs+ONEDhdKxprKNYa3BlPeno1iD3sam5tUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161906; c=relaxed/simple;
	bh=5tQEXQDyC9vxxdE7mqQF1/f3C1/wRXDxUYy358duArk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGL2P85PbC+LaYfn4aa7QCMppohJrq7OFwtSVMBiQ9DmPmYJzaY4KFTR57NEE0V++rwGWajlUVrj7x4rS0XJ0w3Qz9/xX7njo9MHumvtItxFCiF3qe7qOVCvT4hYeUyor2xI4MV9jyIVkYs5CiLXUdZgm4c1HlgxxI1fH66zkBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mguS8PJ5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BADC116B1;
	Mon, 29 Sep 2025 16:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161906;
	bh=5tQEXQDyC9vxxdE7mqQF1/f3C1/wRXDxUYy358duArk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mguS8PJ5es/pXZHYSoUzE5f0pJHxXShYNFeHBATXJCfJPpnIjqDmin7B9UFwA6NS8
	 D2Mce+VHPJlEfE7aGWv7wzg8kL3xtBu0XlUfStAQDF9zCglTqyxOAyBRuQiMwwfuwh
	 fhQzeSFOU6UfqBKmZTd/lScxHViysNxPdFUH26C3m+B+exPp2PeqxDsWoKyhJGjpUS
	 bqehRPK182VHHyk5A1OcrIUKsKshfjXqy2UdW9eETGhplzKIi91DZplPslPpEan2Lp
	 lipbvtqUZt6FlYeczaSzyHcXbfEpaK1a0si9a/Uie9Y0Zrcr8sw13M08xKORfv4tVB
	 3lMOf8klTDaQA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN6-0000000AHqo-2L5H;
	Mon, 29 Sep 2025 16:05:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 05/13] KVM: arm64: Add timer UAPI workaround to sysreg infrastructure
Date: Mon, 29 Sep 2025 17:04:49 +0100
Message-ID: <20250929160458.3351788-6-maz@kernel.org>
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

Amongst the numerous bugs that plague the KVM/arm64 UAPI, one of
the most annoying thing is that the userspace view of the virtual
timer has its CVAL and CNT encodings swapped.

In order to reduce the amount of code that has to know about this,
start by adding handling for this bug in the sys_reg code.

Nothing is making use of it yet, as the code responsible for userspace
interaction is catching the accesses early.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 33 ++++++++++++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.h |  6 ++++++
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9f2f4e0b042e8..8e6f50f54b4bf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5231,15 +5231,28 @@ static int demux_c15_set(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 	}
 }
 
+static u64 kvm_one_reg_to_id(const struct kvm_one_reg *reg)
+{
+	switch(reg->id) {
+	case KVM_REG_ARM_TIMER_CVAL:
+		return TO_ARM64_SYS_REG(CNTV_CVAL_EL0);
+	case KVM_REG_ARM_TIMER_CNT:
+		return TO_ARM64_SYS_REG(CNTVCT_EL0);
+	default:
+		return reg->id;
+	}
+}
+
 int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 			 const struct sys_reg_desc table[], unsigned int num)
 {
 	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
 	const struct sys_reg_desc *r;
+	u64 id = kvm_one_reg_to_id(reg);
 	u64 val;
 	int ret;
 
-	r = id_to_sys_reg_desc(vcpu, reg->id, table, num);
+	r = id_to_sys_reg_desc(vcpu, id, table, num);
 	if (!r || sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
@@ -5272,13 +5285,14 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 {
 	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
 	const struct sys_reg_desc *r;
+	u64 id = kvm_one_reg_to_id(reg);
 	u64 val;
 	int ret;
 
 	if (get_user(val, uaddr))
 		return -EFAULT;
 
-	r = id_to_sys_reg_desc(vcpu, reg->id, table, num);
+	r = id_to_sys_reg_desc(vcpu, id, table, num);
 	if (!r || sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
@@ -5338,10 +5352,23 @@ static u64 sys_reg_to_index(const struct sys_reg_desc *reg)
 
 static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
 {
+	u64 idx;
+
 	if (!*uind)
 		return true;
 
-	if (put_user(sys_reg_to_index(reg), *uind))
+	switch (reg_to_encoding(reg)) {
+	case SYS_CNTV_CVAL_EL0:
+		idx = KVM_REG_ARM_TIMER_CVAL;
+		break;
+	case SYS_CNTVCT_EL0:
+		idx = KVM_REG_ARM_TIMER_CNT;
+		break;
+	default:
+		idx = sys_reg_to_index(reg);
+	}
+
+	if (put_user(idx, *uind))
 		return false;
 
 	(*uind)++;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 317abc490368d..b3f904472fac5 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -257,4 +257,10 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu);
 	(val);								       \
 })
 
+#define TO_ARM64_SYS_REG(r)	ARM64_SYS_REG(sys_reg_Op0(SYS_ ## r),	\
+					      sys_reg_Op1(SYS_ ## r),	\
+					      sys_reg_CRn(SYS_ ## r),	\
+					      sys_reg_CRm(SYS_ ## r),	\
+					      sys_reg_Op2(SYS_ ## r))
+
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
-- 
2.47.3


