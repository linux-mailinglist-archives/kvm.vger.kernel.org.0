Return-Path: <kvm+bounces-72531-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +BOPDy7upmlKaQAAu9opvQ
	(envelope-from <kvm+bounces-72531-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:20:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 21CA61F1545
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 28F8F303A3FC
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 14:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810A44279EC;
	Tue,  3 Mar 2026 14:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b="BaKNGRcY"
X-Original-To: kvm@vger.kernel.org
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972B6390CA3;
	Tue,  3 Mar 2026 14:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547597; cv=none; b=D1sjwUJM2CPZnx1Y3k6V9SDo+E29OucpB5yjq+KJFtUgelMGx1YoAm4iQwcYUOomFgV21qAyq3HZHPXl2C0nQIpeioGtdJLsxy+DBVSHKZXGgaO6BWQZsbzmnyd99mh0eFQ/FxImpx+W7yPajgmdS/az5SBhEYFO1YK5Y5N7lk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547597; c=relaxed/simple;
	bh=BlH7+hXy1ms4n8/da7TKhRnIXRsOiXYku1MgTJCyimE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=HgvX1lhaWcHG7rq0xjgOGyGBygmvsvOy9QLwBwIPXMF+U2vSa/J00TtjqionN52adAWaz+vo7hbb5StYObgnIeQJQhdqzcg1pKIMagqpZpanmEmUd3Wf+yv49DSVQARsq5cL2Dc/Be3bPMUd3/G3m5J7UxsDl+Z/+njMgfXVpbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de; spf=pass smtp.mailfrom=cispa.de; dkim=pass (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b=BaKNGRcY; arc=none smtp.client-ip=134.76.10.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=CC:To:In-Reply-To:References:Message-ID:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=yVoHntqSoUsA+2/rgo1maXXswKzLzoa8w8hdNMp26VE=; b=BaKNGRcYaT/fUwvHRRF/o511AP
	CXi6cuSX62g5rl5agqvxu7/lqIETCxr71zT6Se1G9X3VPG/yQYvPyDxCZxhS6O/hr1osYZUR2FmyG
	RY+UMsvrNUZr3paUuP0eJlMTWrJwg0Y8e8cR/mocK7zhY4pZ/fFr2mHM4creha1cndcIIO1hr9sdt
	0p0mG2zCRqhm5HTf20vcvCrWsahNSPrsKBfacNDoV641YG2kusQ285HyHxu/XSRxnKGErU9ejHpJE
	qGR+FrvC22o8X0VYsKPcGvNGQc5/Ah6V03eWm+js9xl8uOBxqT3cR7lPcHrzamDWabxU7cVFZ29YQ
	ShBOErRw==;
Received: from mailer.gwdg.de ([134.76.10.26]:56797)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vxQb8-00850R-2P;
	Tue, 03 Mar 2026 15:19:43 +0100
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vxQb9-0006kV-1Z;
	Tue, 03 Mar 2026 15:19:43 +0100
Received: from lukass-mbp-7.lan (10.250.9.200) by MBX19-SUB-05.um.gwdg.de
 (10.108.142.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Tue, 3 Mar
 2026 15:19:42 +0100
From: Lukas Gerlach <lukas.gerlach@cispa.de>
Date: Tue, 3 Mar 2026 15:19:42 +0100
Subject: [PATCH v2 2/4] KVM: riscv: Fix Spectre-v1 in AIA CSR access
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20260303-kvm-riscv-spectre-v1-v2-2-192caab8e0dc@cispa.de>
References: <20260303-kvm-riscv-spectre-v1-v2-0-192caab8e0dc@cispa.de>
In-Reply-To: <20260303-kvm-riscv-spectre-v1-v2-0-192caab8e0dc@cispa.de>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert
 Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones
	<ajones@ventanamicro.com>
CC: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <radim.krcmar@oss.qualcomm.com>,
	<kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, Daniel
 Weber <daniel.weber@cispa.de>, Michael Schwarz <michael.schwarz@cispa.de>,
	Marton Bognar <marton.bognar@kuleuven.be>, Jo Van Bulck
	<jo.vanbulck@kuleuven.be>, Lukas Gerlach <lukas.gerlach@cispa.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2077;
 i=lukas.gerlach@cispa.de; h=from:subject:message-id;
 bh=BlH7+hXy1ms4n8/da7TKhRnIXRsOiXYku1MgTJCyimE=;
 b=owGbwMvMwCGWoTIjqP/42kTG02pJDJnL3v69fFpB2FgmvejjhFmfOq/tboxouxV1K7+VO+ET8
 1bug1ePdZSyMIhxMMiKKbJMFXzN2LfHgScp8/A5mDmsTCBDGLg4BWAiv2UY/plJBJ5lrlRUyncQ
 ThJybn0+2dA4MTbASW666s52j+iJvYwM73aKfH4/+VHQxQc6B02SxRweznnXE2knFn6vM4e1ofA
 6PwA=
X-Developer-Key: i=lukas.gerlach@cispa.de; a=openpgp;
 fpr=9511EB018EBC400C6269C3CE682498528FC7AD61
X-ClientProxiedBy: MBX19-SUB-05.um.gwdg.de (10.108.142.70) To
 MBX19-SUB-05.um.gwdg.de (10.108.142.70)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -
X-Rspamd-Queue-Id: 21CA61F1545
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[cispa.de:s=2023-rsa];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[cispa.de : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lukas.gerlach@cispa.de,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.974];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72531-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[cispa.de:-]
X-Rspamd-Action: no action

User-controlled indices are used to access AIA CSR registers.
Sanitize them with array_index_nospec() to prevent speculative
out-of-bounds access.

Similar to x86 commit 8c86405f606c ("KVM: x86: Protect
ioapic_read_indirect() from Spectre-v1/L1TF attacks") and arm64
commit 41b87599c743 ("KVM: arm/arm64: vgic: fix possible spectre-v1
in vgic_get_irq()").

Reviewed-by: Radim Krčmář <radim.krcmar@oss.qualcomm.com>
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


