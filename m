Return-Path: <kvm+bounces-69073-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KEG9Mx/WdmlRXgEAu9opvQ
	(envelope-from <kvm+bounces-69073-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 03:49:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D1F83956
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 03:49:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BFF1D3008D09
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 02:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8FB296BD0;
	Mon, 26 Jan 2026 02:48:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF4501BD9CE;
	Mon, 26 Jan 2026 02:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769395727; cv=none; b=eIbXowh7Oo3juZlqyRLOansMAo0uIdZjIzlKXgnsYd8NNRu4J6c0CHjqcZmSZFHJNauPv6iHb3Ej5oV4S8MWnfVn0uUKUfkUEpBtzTlD90BOAtpjXmd3RTcSETm6nt+I11Zmu8spqKGzmKEGqLtQrLLSH6hew6WKRdvhxnEomHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769395727; c=relaxed/simple;
	bh=PjZ8K0McQdNe8F8SMKmXiuTZmYmqd+zIPV/1WD6KVY0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZkQeCUvcxQ0+ugkSK92Prr7IKUPaJz7i0+9FtByYxsVbR4oTy/ruovnQVGy8sCcffodWe7hNblfFUXfwW142Ai8n21eXwse7jYHoJJWkozdQr6PfPyUkji/FqRUKcuut13CJA5w828ZfTQxja8hPDTsb3D1lcdr8IZs1prMBjP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxPMMK1nZpPJcMAA--.41044S3;
	Mon, 26 Jan 2026 10:48:42 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCx98AJ1nZp+0AxAA--.18313S2;
	Mon, 26 Jan 2026 10:48:42 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v2] LoongArch: KVM: Add more CPUCFG mask bit
Date: Mon, 26 Jan 2026 10:48:40 +0800
Message-Id: <20260126024840.2308379-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx98AJ1nZp+0AxAA--.18313S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	TAGGED_FROM(0.00)[bounces-69073-lists,kvm=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,loongson.cn:mid,loongson.cn:email]
X-Rspamd-Queue-Id: 24D1F83956
X-Rspamd-Action: no action

With LA664 CPU there are more features supported which are indicated
in CPUCFG2 bit24:30 and CPUCFG3 bit17 and bit 23. KVM hypervisor can
not enable or disable these features and there is no KVM exception
when instructions of these features are used in guest mode.

Here add more CPUCFG mask support with LA664 CPU type.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
  1. Rebase on the latest version since some common CPUCFG bit macro
     definitions are merged.
  2. Modifiy the comments explaining why it comes from feature detect
     of host CPU.
---
 arch/loongarch/kvm/vcpu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 656b954c1134..a9608469fa7a 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -652,6 +652,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
 
 static int _kvm_get_cpucfg_mask(int id, u64 *v)
 {
+	unsigned int config;
+
 	if (id < 0 || id >= KVM_MAX_CPUCFG_REGS)
 		return -EINVAL;
 
@@ -684,9 +686,22 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 		if (cpu_has_ptw)
 			*v |= CPUCFG2_PTW;
 
+		/*
+		 * The capability indication of some features are the same
+		 * between host CPU and guest vCPU, and there is no special
+		 * feature detect method with vCPU. Also KVM hypervisor can
+		 * not enable or disable these features.
+		 *
+		 * Here use host CPU detected features for vCPU
+		 */
+		config = read_cpucfg(LOONGARCH_CPUCFG2);
+		*v |= config & (CPUCFG2_FRECIPE | CPUCFG2_DIV32 | CPUCFG2_LAM_BH);
+		*v |= config & (CPUCFG2_LAMCAS | CPUCFG2_LLACQ_SCREL | CPUCFG2_SCQ);
 		return 0;
 	case LOONGARCH_CPUCFG3:
 		*v = GENMASK(16, 0);
+		config = read_cpucfg(LOONGARCH_CPUCFG3);
+		*v |= config & (CPUCFG3_DBAR_HINTS | CPUCFG3_SLDORDER_STA);
 		return 0;
 	case LOONGARCH_CPUCFG4:
 	case LOONGARCH_CPUCFG5:

base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
-- 
2.39.3


