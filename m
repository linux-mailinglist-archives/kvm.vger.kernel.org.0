Return-Path: <kvm+bounces-60985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B0474C04B21
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 09:23:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2D3B1B822B5
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 07:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951822DCF55;
	Fri, 24 Oct 2025 07:20:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94DBE2D8393;
	Fri, 24 Oct 2025 07:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761290418; cv=none; b=M8vjp/hFoCBw2cQeUGjVWBs2nAtmWlubNOZ/tn0z9lwiyGjHXyil9+oAnmWjiJinP/SnfQXO84WNNxvP1ZTIFrjdws8rFPSnIcZYclcVoGzuFdfJTKdl1iWAo27p8JU8lGvHzQlP2C4DhZrtC4N+ZP9m6cDcKIZAKuCBnHy4Evc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761290418; c=relaxed/simple;
	bh=FHPCUkF47wmXOUMYG5D5p7ycxQXyM3ejbPFjYjrSGIg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g3U4vBKCQ60auo853dU6wYMPw7RZ4Outgu5+nQ3X8AVe4H7y0QG45znIrIgmZGOcu+jQQRmI3XYXErcBMiJX/qlDuke0Ewd4g8h9eHrk7yN+hWWA4WfRQkCc4c9tgMzmfPpFv6In3+AERc9kqGvQxL75WbYwYo7o9X9jebCnATI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Axz7+oKPto0hUaAA--.54356S3;
	Fri, 24 Oct 2025 15:20:08 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxocKiKPtojj4GAQ--.47710S4;
	Fri, 24 Oct 2025 15:20:08 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>,
	Song Gao <gaosong@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] LoongArch: KVM: Skip PMU checking on vCPU context switch
Date: Fri, 24 Oct 2025 15:20:01 +0800
Message-Id: <20251024072001.3164600-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251024072001.3164600-1-maobibo@loongson.cn>
References: <20251024072001.3164600-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxocKiKPtojj4GAQ--.47710S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

PMU hardware about VM is switched on VM exit to host rather than
vCPU context sched off, PMU is checked and restored on return to
VM. It is not necessary to check PMU on vCPU context sched on
callback, since the request is made on VM exit entry or VM PMU CSR
access abort routine already.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index bf56ad29ac15..dc35bf526fe9 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -148,12 +148,6 @@ static void kvm_lose_pmu(struct kvm_vcpu *vcpu)
 	kvm_restore_host_pmu(vcpu);
 }
 
-static void kvm_restore_pmu(struct kvm_vcpu *vcpu)
-{
-	if ((vcpu->arch.aux_inuse & KVM_LARCH_PMU))
-		kvm_make_request(KVM_REQ_PMU, vcpu);
-}
-
 static void kvm_check_pmu(struct kvm_vcpu *vcpu)
 {
 	if (kvm_check_request(KVM_REQ_PMU, vcpu)) {
@@ -304,7 +298,10 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.aux_inuse &= ~KVM_LARCH_SWCSR_LATEST;
 
 		if (kvm_request_pending(vcpu) || xfer_to_guest_mode_work_pending()) {
-			kvm_lose_pmu(vcpu);
+			if (vcpu->arch.aux_inuse & KVM_LARCH_PMU) {
+				kvm_lose_pmu(vcpu);
+				kvm_make_request(KVM_REQ_PMU, vcpu);
+			}
 			/* make sure the vcpu mode has been written */
 			smp_store_mb(vcpu->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
@@ -1609,9 +1606,6 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_restore_timer(vcpu);
 	kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 
-	/* Restore hardware PMU CSRs */
-	kvm_restore_pmu(vcpu);
-
 	/* Don't bother restoring registers multiple times unless necessary */
 	if (vcpu->arch.aux_inuse & KVM_LARCH_HWCSR_USABLE)
 		return 0;
-- 
2.39.3


