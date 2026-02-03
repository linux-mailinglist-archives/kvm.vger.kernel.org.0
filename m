Return-Path: <kvm+bounces-69966-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0N17KyBsgWmwGAMAu9opvQ
	(envelope-from <kvm+bounces-69966-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 04:31:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 188D6D4254
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 04:31:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 54577300D4CA
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 03:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4017324B0C;
	Tue,  3 Feb 2026 03:31:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1A2E31D387;
	Tue,  3 Feb 2026 03:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770089501; cv=none; b=Q2S/GNltmvZCssMCsXfbAHzhDSkpFCDDRPmJ44HYaQOi9AvMGZps1e5LI4kKnu0i5AWkQgrXhGwI0l2izh1B1C33CHpwcVBXrV+crULjSli7Ek8Y610hT2Fd+Mvl+TfT7NnoEKN4aoVy3nSc2gI6r8w1M+J9AOuyTCoBTVSw5nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770089501; c=relaxed/simple;
	bh=/52FdCO+2MJf5DIczIzycLBU53I2LCS2snJAb73d9h4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QuMo5AODH0TDzJUczVufSP/nXdtirjS08j0LRTu2so0XJU/cPvGETbD6O23Gcbp70aA+a5SctGf3lf8YGeNx7LbX1hOsoUNIDHHfyMbyNA/XIniZswVVv41/ebbi18UYGJWxU6PCzLV314g4fGBzQIBvuWMpFsJaXe27+TSBHL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Axy8IXbIFp5zwPAA--.49026S3;
	Tue, 03 Feb 2026 11:31:35 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxGMEVbIFpbtk+AA--.37628S5;
	Tue, 03 Feb 2026 11:31:35 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v3 3/4] LoongArch: KVM: Move LBT capability checking in LBT exception handler
Date: Tue,  3 Feb 2026 11:31:30 +0800
Message-Id: <20260203033131.3372834-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260203033131.3372834-1-maobibo@loongson.cn>
References: <20260203033131.3372834-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxGMEVbIFpbtk+AA--.37628S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	DMARC_NA(0.00)[loongson.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69966-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,loongson.cn:mid,loongson.cn:email]
X-Rspamd-Queue-Id: 188D6D4254
X-Rspamd-Action: no action

Like FPU exception handler, check LBT capability in LBT exception
handler rather than function kvm_own_lbt().

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 4 +++-
 arch/loongarch/kvm/vcpu.c | 3 ---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 74b427287e96..65ec10a7245a 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -820,8 +820,10 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu, int ecode)
 
 static int kvm_handle_lbt_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
-	if (kvm_own_lbt(vcpu))
+	if (!kvm_guest_has_lbt(&vcpu->arch))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
+	else
+		kvm_own_lbt(vcpu);
 
 	return RESUME_GUEST;
 }
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index d91a1160a309..995461d724b5 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1286,9 +1286,6 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 #ifdef CONFIG_CPU_HAS_LBT
 int kvm_own_lbt(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_guest_has_lbt(&vcpu->arch))
-		return -EINVAL;
-
 	preempt_disable();
 	if (!(vcpu->arch.aux_inuse & KVM_LARCH_LBT)) {
 		set_csr_euen(CSR_EUEN_LBTEN);
-- 
2.39.3


