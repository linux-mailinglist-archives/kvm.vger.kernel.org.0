Return-Path: <kvm+bounces-69314-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6ByXNqR8eWldxQEAu9opvQ
	(envelope-from <kvm+bounces-69314-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:04:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 679379C77A
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:04:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8A5A8300A8F9
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 03:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFE932D7DF2;
	Wed, 28 Jan 2026 03:03:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F09C31AF0AF;
	Wed, 28 Jan 2026 03:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769569424; cv=none; b=nb7601UgQKQvghmvUod/lOu/+y0k/2fKkqWWNoH5QWFQ32vHdJ28Zgi/5KATgz4+ZT8/9ribFapEGsnhP0/WspqSmkrhB9PQoVg1kutrMQ98fpybewjVJpDwXeTcitsfVH1PIsuTijmq2QqHJXNANbcjuMZfen6IVyf4LXNFUzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769569424; c=relaxed/simple;
	bh=5IF9vTs1CTliJUkSEFAaRm/bX3qtI0wgMi0WxYzm8I4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N6vR8CFCWqt/CoazgsU8FoukKGgXl5nsZtVr3fZaJJnFb00rGIl1kY+PiTSUg0NXU2CKGgX6YFX3KerUXxsezkO5yQpPZ+/UwlIdgNMCyvZxpiyqV1Gu4DnT8gMImjebDXZ9efwAz+ENFj6/mRzmM0zd849Clqzb3q754gBT9TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxfcOGfHlpCWMNAA--.43959S3;
	Wed, 28 Jan 2026 11:03:34 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxSeCGfHlpj0g2AA--.40015S2;
	Wed, 28 Jan 2026 11:03:34 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 4/4] LoongArch: KVM: Add register LOONGARCH_CSR_IPR during vCPU context switch
Date: Wed, 28 Jan 2026 11:03:26 +0800
Message-Id: <20260128030326.3377462-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260128030326.3377462-1-maobibo@loongson.cn>
References: <20260128030326.3377462-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxSeCGfHlpj0g2AA--.40015S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
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
	NEURAL_HAM(-0.00)[-0.995];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	TAGGED_FROM(0.00)[bounces-69314-lists,kvm=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,loongson.cn:mid,loongson.cn:email]
X-Rspamd-Queue-Id: 679379C77A
X-Rspamd-Action: no action

Register LOONGARCH_CSR_IPR is interrupt priority setting for nested
interrupt handling. Though LoongArch Linux avec driver does not use
this register, however KVM hypervisor needs need save or restore this
register during vCPU context switch, Linux avec driver may use this
register in future or other OS may use it.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 6d9953d0b7be..b224df0f6d0a 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1666,6 +1666,7 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR1);
 		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR2);
 		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR3);
+		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_IPR);
 	}
 
 	/* Restore Root.GINTC from unused Guest.GINTC register */
@@ -1761,6 +1762,7 @@ static int _kvm_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
 		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR1);
 		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR2);
 		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR3);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_IPR);
 	}
 
 	vcpu->arch.aux_inuse |= KVM_LARCH_SWCSR_LATEST;
-- 
2.39.3


