Return-Path: <kvm+bounces-60984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CE20C04B12
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 09:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6151A501D95
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 07:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 749F22D7DCC;
	Fri, 24 Oct 2025 07:20:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85C22D7392;
	Fri, 24 Oct 2025 07:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761290416; cv=none; b=Rl5PA0A2f/jmU+JHJ19omZWxU278FYoji49ZO4mqU9dDlZZvYp7sAxv+lWbabkH2N2YJMhoJMjT+uQfdFAyeo+k/7uz+TE2nudcLwJDvVtCn3gZY098M3SbIG0wg442A2r7hxiUrooFXEli9OLDOG59qCgmQWwj109T5O4CmosQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761290416; c=relaxed/simple;
	bh=+a5Q+LkF/T/35mNgCl0Aao91nQhP7XnVyxfARfJcCNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XWeGcHwapDtL8lzcOcZnRTd4Mmtruh+FBXjyyooxdybsuSeikx3QoC/VIljr4wdlJE9DnB3c5C1m1j2eG9DD2bon64V5J5VtmgJMGWIlCsdSd+ib7NdMzCZ3nD3pyP9ILclTJmAilfFUJMjxdzioS7oqb8NyfkbCROZaIHP2csU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxVNCoKPtozxUaAA--.56292S3;
	Fri, 24 Oct 2025 15:20:08 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxocKiKPtojj4GAQ--.47710S3;
	Fri, 24 Oct 2025 15:20:07 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>,
	Song Gao <gaosong@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] LoongArch: KVM: Restore guest PMU if it is enabled
Date: Fri, 24 Oct 2025 15:20:00 +0800
Message-Id: <20251024072001.3164600-2-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJCxocKiKPtojj4GAQ--.47710S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

On LoongArch system, guest PMU hardware is shared by guest and host
and PMU interrupt is separated. PMU is pass-through to VM, and there is
PMU context switch when exit to host and return to guest.

There is optimiation to check whether PMU is enabled by guest. If not,
it is not necessary to return to guest. However it is enabled, PMU
context for guest need switch on. Now KVM_REQ_PMU notification is set
on vcpu context switch, however it is missing if there is no vcpu context
switch and PMU is used by guest VM.

Fixes: f4e40ea9f78f ("LoongArch: KVM: Add PMU support for guest")
Cc: <stable@vger.kernel.org>

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 30e3b089a596..bf56ad29ac15 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -132,6 +132,9 @@ static void kvm_lose_pmu(struct kvm_vcpu *vcpu)
 	 * Clear KVM_LARCH_PMU if the guest is not using PMU CSRs when
 	 * exiting the guest, so that the next time trap into the guest.
 	 * We don't need to deal with PMU CSRs contexts.
+	 *
+	 * Otherwise set request bit KVM_REQ_PMU to restore guest PMU
+	 * before entering guest VM
 	 */
 	val = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_PERFCTRL0);
 	val |= kvm_read_sw_gcsr(csr, LOONGARCH_CSR_PERFCTRL1);
@@ -139,6 +142,8 @@ static void kvm_lose_pmu(struct kvm_vcpu *vcpu)
 	val |= kvm_read_sw_gcsr(csr, LOONGARCH_CSR_PERFCTRL3);
 	if (!(val & KVM_PMU_EVENT_ENABLED))
 		vcpu->arch.aux_inuse &= ~KVM_LARCH_PMU;
+	else
+		kvm_make_request(KVM_REQ_PMU, vcpu);
 
 	kvm_restore_host_pmu(vcpu);
 }
-- 
2.39.3


