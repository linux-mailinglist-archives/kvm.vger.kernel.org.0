Return-Path: <kvm+bounces-72006-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0DJOGFpboGm3igQAu9opvQ
	(envelope-from <kvm+bounces-72006-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:40:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 013DB1A7BE4
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:40:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 32AE7300C33C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51F93D2FE5;
	Thu, 26 Feb 2026 14:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b="U/Xd5ZKk"
X-Original-To: kvm@vger.kernel.org
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051DC389E06;
	Thu, 26 Feb 2026 14:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772116819; cv=none; b=nyitJQZ+FCtolvdsPaId4ABjV1skxl90UUsJvWndPFTdArDjSP5RcH5hsfLHgHXJeGk0hI4oxDBjme5DLEbfw8TPRhN0qoofFR/xOxdy8xlkNVObLETqHfju5wxl+ePikoAsfyqTTH7A+j+4F/kH6sJEPx1LHCFS12wpFD6Gj80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772116819; c=relaxed/simple;
	bh=GFfVWFqoNPRvvXxOXJ4Garf8GrDfVffFbdN0xbFwWQM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=d6F09Ltw4jBz61w2EPBkcGZH7TyNABUXFgkBzpJT3f4DztQ7w8llUCq2t+/yMugfjVQDmRiVI8PTwZCZRixNbZg98FE04UcVMNYHs5tMHkSgvaPw6P85u9tHD9R5i+xgR0BayGUiwV7n8XuA770LuXHGN+tgxOVVbqzmOfCKw14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de; spf=pass smtp.mailfrom=cispa.de; dkim=pass (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b=U/Xd5ZKk; arc=none smtp.client-ip=134.76.10.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=CC:To:In-Reply-To:References:Message-ID:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jAeCECNlZO1euMlCtdN550hykLYZFsNroN+0wfjKXiE=; b=U/Xd5ZKkugLw4jKH46vDneAvZt
	thgWfeRlQiGg57cm5hQq1sFPZpOyeZpwDSvQHndFDsW8VhO1wCSNRxq2NKDBKTqGC2UR87ky/toI0
	sv2v3QzTEeCIMwbHaRQO4JcyJXh7V2nYbFX9JGgHtgzOGaKu2KjHwz7Sy3S9L4ztcv40rHoeOm7g9
	rhfAuT1aaHG78sjRl9Ji6OcEQSjjVO11rd4K6ltPFL5CssSp7DWii4qjvtthmWh4dWhOUY/C/igou
	IHrMhsZ22Zw+SjzyLhpU3dNjMnuZlzvKgkoByFEBkytskW1PWxV0G5zZcT6eI8WbVhJ9BXrA25EI3
	7pEMUIyQ==;
Received: from mailer.gwdg.de ([134.76.10.26]:60674)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vvcDC-006EG9-09;
	Thu, 26 Feb 2026 15:19:30 +0100
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vvcDC-0009wl-1u;
	Thu, 26 Feb 2026 15:19:30 +0100
Received: from
 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa
 (10.250.9.200) by MBX19-SUB-05.um.gwdg.de (10.108.142.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.37; Thu, 26 Feb 2026 15:19:24 +0100
From: Lukas Gerlach <lukas.gerlach@cispa.de>
Date: Thu, 26 Feb 2026 15:18:59 +0100
Subject: [PATCH 2/4] KVM: riscv: Fix Spectre-v1 in AIA CSR access
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260226-kvm-riscv-spectre-v1-v1-2-5f930ea16691@cispa.de>
References: <20260226-kvm-riscv-spectre-v1-v1-0-5f930ea16691@cispa.de>
In-Reply-To: <20260226-kvm-riscv-spectre-v1-v1-0-5f930ea16691@cispa.de>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert
 Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones
	<ajones@ventanamicro.com>
CC: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, Daniel
 Weber <daniel.weber@cispa.de>, Michael Schwarz <michael.schwarz@cispa.de>,
	Marton Bognar <marton.bognar@kuleuven.be>, Jo Van Bulck
	<jo.vanbulck@kuleuven.be>, Lukas Gerlach <lukas.gerlach@cispa.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2015;
 i=lukas.gerlach@cispa.de; h=from:subject:message-id;
 bh=GFfVWFqoNPRvvXxOXJ4Garf8GrDfVffFbdN0xbFwWQM=;
 b=owGbwMvMwCGWoTIjqP/42kTG02pJDJkLwuIfLzVcePOR7OkbR7qXJLL5P7wzzfT4Pc9ZSyb8Z
 g1+mqH3rqOUhUGMg0FWTJFlquBrxr49DjxJmYfPwcxhZQIZwsDFKQATyXrHyHC74nK1qUAi67n9
 K6pE1sinnhXMZouL+RNyir+l+IfpV12G/xEpN+e9u7Pni+8smeeh8m0Ppr0MzihVuLpZoM64eGd
 GEzcA
X-Developer-Key: i=lukas.gerlach@cispa.de; a=openpgp;
 fpr=9511EB018EBC400C6269C3CE682498528FC7AD61
X-ClientProxiedBy: mbx19-sub-02.um.gwdg.de (10.108.142.55) To
 MBX19-SUB-05.um.gwdg.de (10.108.142.70)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[cispa.de:s=2023-rsa];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[cispa.de : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72006-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[cispa.de:-];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lukas.gerlach@cispa.de,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[cispa.de:mid,cispa.de:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 013DB1A7BE4
X-Rspamd-Action: no action

User-controlled indices are used to access AIA CSR registers.
Sanitize them with array_index_nospec() to prevent speculative
out-of-bounds access.

Similar to x86 commit 8c86405f606c ("KVM: x86: Protect
ioapic_read_indirect() from Spectre-v1/L1TF attacks") and arm64
commit 41b87599c743 ("KVM: arm/arm64: vgic: fix possible spectre-v1
in vgic_get_irq()").

Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
---
 arch/riscv/kvm/aia.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index cac3c2b51d72..38de97d2f5b8 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -13,6 +13,7 @@
 #include <linux/irqchip/riscv-imsic.h>
 #include <linux/irqdomain.h>
 #include <linux/kvm_host.h>
+#include <linux/nospec.h>
 #include <linux/percpu.h>
 #include <linux/spinlock.h>
 #include <asm/cpufeature.h>
@@ -182,10 +183,13 @@ int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
 			       unsigned long *out_val)
 {
 	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
+	unsigned long regs_max = sizeof(struct kvm_riscv_aia_csr) / sizeof(unsigned long);
 
-	if (reg_num >= sizeof(struct kvm_riscv_aia_csr) / sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -ENOENT;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	*out_val = 0;
 	if (kvm_riscv_aia_available())
 		*out_val = ((unsigned long *)csr)[reg_num];
@@ -198,10 +202,13 @@ int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
 			       unsigned long val)
 {
 	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
+	unsigned long regs_max = sizeof(struct kvm_riscv_aia_csr) / sizeof(unsigned long);
 
-	if (reg_num >= sizeof(struct kvm_riscv_aia_csr) / sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -ENOENT;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	if (kvm_riscv_aia_available()) {
 		((unsigned long *)csr)[reg_num] = val;
 

-- 
2.51.0


