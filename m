Return-Path: <kvm+bounces-59008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 561D0BA9F31
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:07:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31D1A16BF78
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D285C30E83D;
	Mon, 29 Sep 2025 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJWMTT15"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958E130DD33;
	Mon, 29 Sep 2025 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161907; cv=none; b=JBQIlHcSen85fCKRiCE6dTrx3JI4iYGSgL6dhsCz5PLHT8ihRxeFt87mCBkF6DMXXidZ1TkIBiIo0qrzec31Aor9kyUQFX8QL0+HDfkid0sL1EcFh1kbPx6B9um15+Mhx1uJmT1PPGS+w3NSBSrXHkbpxyGFluoTCR2N2U0E69w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161907; c=relaxed/simple;
	bh=FKuPiW6IwnxqxPKqIfxCB1Qt99lPKm+h9WG+rzcIo24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmYg5ScLvBecXQXhR3WAn3oco5PXdGod4SQhego58ksrmLG/wPVZetTPhpR0JZwDuT+jIcPr/yeyT15Bss24URl86sAVSIGOr//4pdx4Uu8gJpMOJbEw21OcUTUsnCVYs5HZV9h8Eat4/vrEcEwwbT1gBDe3I4KDyGaBD2O7Rqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJWMTT15; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F654C116C6;
	Mon, 29 Sep 2025 16:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161906;
	bh=FKuPiW6IwnxqxPKqIfxCB1Qt99lPKm+h9WG+rzcIo24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJWMTT15dVS+Z3DZKn5HMUzuY8o73xiarWH6QUyCjklPais1zMtBq3Xn/+SqDTCpz
	 J8rv/qscZH//bLNHviA+6Dd4Od0siwg19qmZjF92fhljFyrPCoQcLI5dGCsVT4dRZP
	 pPwsxPkEFghc3YQ7sCpA6FO6KITDHjg+0SANlDzk6qZKFIvX2ic2pKkEEXCBJMjbLp
	 eUzEs+7BQXt/+Z8/TPuS0R06N6fvJq392ZsZA9XYByX+vdL+CEZ8hV5YyHinTFS6hS
	 LS06luUN6Q6kj5QbpR3kmn23uM0sZZvqSJQPm6grWVzyCPSB+SNYRSGYhIpErlqwNm
	 PHmANDXr7LIvA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN5-0000000AHqo-3caT;
	Mon, 29 Sep 2025 16:05:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 03/13] KVM: arm64: Replace timer context vcpu pointer with timer_id
Date: Mon, 29 Sep 2025 17:04:47 +0100
Message-ID: <20250929160458.3351788-4-maz@kernel.org>
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

Having to follow a pointer to a vcpu is pretty dumb, when the timers
are are a fixed offset in the vcpu structure itself.

Trade the vcpu pointer for a timer_id, which can then be used to
compute the vcpu address as needed.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  |  4 ++--
 include/kvm/arm_arch_timer.h | 11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index e5a25e743f5be..c832c293676a3 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -149,7 +149,7 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
 static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 {
 	if (!ctxt->offset.vm_offset) {
-		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
+		WARN(offset, "timer %d\n", arch_timer_ctx_index(ctxt));
 		return;
 	}
 
@@ -1064,7 +1064,7 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 	struct arch_timer_context *ctxt = vcpu_get_timer(vcpu, timerid);
 	struct kvm *kvm = vcpu->kvm;
 
-	ctxt->vcpu = vcpu;
+	ctxt->timer_id = timerid;
 
 	if (timerid == TIMER_VTIMER)
 		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index d188c716d03cb..d8e400cb2bfff 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -51,8 +51,6 @@ struct arch_timer_vm_data {
 };
 
 struct arch_timer_context {
-	struct kvm_vcpu			*vcpu;
-
 	/* Emulated Timer (may be unused) */
 	struct hrtimer			hrtimer;
 	u64				ns_frac;
@@ -71,6 +69,9 @@ struct arch_timer_context {
 		bool			level;
 	} irq;
 
+	/* Who am I? */
+	enum kvm_arch_timers		timer_id;
+
 	/* Duplicated state from arch_timer.c for convenience */
 	u32				host_timer_irq;
 };
@@ -127,9 +128,9 @@ void kvm_timer_init_vhe(void);
 #define vcpu_hvtimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_HVTIMER])
 #define vcpu_hptimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_HPTIMER])
 
-#define arch_timer_ctx_index(ctx)	((ctx) - vcpu_timer((ctx)->vcpu)->timers)
-#define timer_context_to_vcpu(ctx)	((ctx)->vcpu)
-#define timer_vm_data(ctx)		(&(ctx)->vcpu->kvm->arch.timer_data)
+#define arch_timer_ctx_index(ctx)	((ctx)->timer_id)
+#define timer_context_to_vcpu(ctx)	container_of((ctx), struct kvm_vcpu, arch.timer_cpu.timers[(ctx)->timer_id])
+#define timer_vm_data(ctx)		(&(timer_context_to_vcpu(ctx)->kvm->arch.timer_data))
 #define timer_irq(ctx)			(timer_vm_data(ctx)->ppi[arch_timer_ctx_index(ctx)])
 
 u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
-- 
2.47.3


