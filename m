Return-Path: <kvm+bounces-72534-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GEtVAf3vpmlKaQAAu9opvQ
	(envelope-from <kvm+bounces-72534-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:28:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 753C11F1731
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 15:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 797163067B1A
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 14:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67E542F54E;
	Tue,  3 Mar 2026 14:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b="bx+XtFRc"
X-Original-To: kvm@vger.kernel.org
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973723E51D7;
	Tue,  3 Mar 2026 14:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547598; cv=none; b=rIQFIkDq535aNaxaNn/05tAlI3zOT6eFCMH0nNOVwBe98CptbrJN2z7JPdzaDGk3DEYKYZAMEPZk44KXUndsAiO9DOKF3ypqeMFIFRcRIVfYklD2o5nk9mOSi6cJDd10a8ZjJGSMSZ+kdk49StgS35kUghU8r1ANXptd9u24wUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547598; c=relaxed/simple;
	bh=j5JRn8BDxWYEk9Bob09tmUeE0dFdl/ufaymZCcn8CKk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=t6Plk9Ptb3IT7B29ZicnjVBGJZ/o1dJPjwaXohoncSefUM79PqjMA39WXDDWAIt+3EBXxNmJshV7h4o11pcSb/p2K8lzHXpGGthduTbmQ3iMPywc4xZxbxRD/73hgxL7OGEn1OfDhyPiYIOrmwUHoGk1XsVEu2UJFXM08t5PVaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de; spf=pass smtp.mailfrom=cispa.de; dkim=pass (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b=bx+XtFRc; arc=none smtp.client-ip=134.76.10.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=CC:To:In-Reply-To:References:Message-ID:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2BcOjrNpCibrOdJLkBqx5P6cXuCy4qWNPIEqtnNoka0=; b=bx+XtFRck2NQYURZKzj0Pu2TPi
	ZJde3H6huowlW8yvSMUd+iaAII9CdNbcoafI4Qo2vxxXsbbc/8YBXARPdRypNtboYEx5fCGOkQCpA
	eB79fToU8cjQzHGxqzhX5BshdYf6S3V8kdpRrvnGGLrbNaATe7XPRBMPcpt2Ugp+MbJB23WwaCNNg
	Mq2RmEje/nu2X/6jZ0D8is7iwq6vzAlgdsPDu5fS2haIyUgaDcEA2cRelW8ASqOtRVpsvLTCprNoc
	LYuw6SBSB331PqMNqsjYUUMo+6V5+Xzg3g7qD73Mt9XKNqla7JxL9xmRUcIS51d/p2Uy/4yUnSoi8
	7+nxWVkQ==;
Received: from mailer.gwdg.de ([134.76.10.26]:44405)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vxQb8-00850J-11;
	Tue, 03 Mar 2026 15:19:43 +0100
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vxQb9-0006kE-0D;
	Tue, 03 Mar 2026 15:19:43 +0100
Received: from lukass-mbp-7.lan (10.250.9.200) by MBX19-SUB-05.um.gwdg.de
 (10.108.142.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Tue, 3 Mar
 2026 15:19:42 +0100
From: Lukas Gerlach <lukas.gerlach@cispa.de>
Date: Tue, 3 Mar 2026 15:19:41 +0100
Subject: [PATCH v2 1/4] KVM: riscv: Fix Spectre-v1 in ONE_REG register
 access
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20260303-kvm-riscv-spectre-v1-v2-1-192caab8e0dc@cispa.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4830;
 i=lukas.gerlach@cispa.de; h=from:subject:message-id;
 bh=j5JRn8BDxWYEk9Bob09tmUeE0dFdl/ufaymZCcn8CKk=;
 b=owGbwMvMwCGWoTIjqP/42kTG02pJDJnL3v5dkqdzp0c7IKDp3yTmhGlzJ53VWHqdd8/mA3Ibc
 oSPZ67+1FHKwiDGwSArpsgyVfA1Y98eB56kzMPnYOawMoEMYeDiFICJnGZjZDgldNGT/dFhs6gj
 7Du3/XynX7Hn9R9lrt5uSe5Hy6o+309kZPi3SNwklPu9y+6G4mX1Ux+4fi68LBQ5/a54+y3vIN6
 GXAYA
X-Developer-Key: i=lukas.gerlach@cispa.de; a=openpgp;
 fpr=9511EB018EBC400C6269C3CE682498528FC7AD61
X-ClientProxiedBy: MBX19-SUB-05.um.gwdg.de (10.108.142.70) To
 MBX19-SUB-05.um.gwdg.de (10.108.142.70)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -
X-Rspamd-Queue-Id: 753C11F1731
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[cispa.de:s=2023-rsa];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[cispa.de : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
	TAGGED_FROM(0.00)[bounces-72534-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[cispa.de:-]
X-Rspamd-Action: no action

User-controlled register indices from the ONE_REG ioctl are used to
index into arrays of register values. Sanitize them with
array_index_nospec() to prevent speculative out-of-bounds access.

Reviewed-by: Radim Krčmář <radim.krcmar@oss.qualcomm.com>
Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
---
 arch/riscv/kvm/vcpu_onereg.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index e7ab6cb00646..a4c8703a96a9 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -10,6 +10,7 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/err.h>
+#include <linux/nospec.h>
 #include <linux/uaccess.h>
 #include <linux/kvm_host.h>
 #include <asm/cacheflush.h>
@@ -127,6 +128,7 @@ static int kvm_riscv_vcpu_isa_check_host(unsigned long kvm_ext, unsigned long *g
 	    kvm_ext >= ARRAY_SIZE(kvm_isa_ext_arr))
 		return -ENOENT;
 
+	kvm_ext = array_index_nospec(kvm_ext, ARRAY_SIZE(kvm_isa_ext_arr));
 	*guest_ext = kvm_isa_ext_arr[kvm_ext];
 	switch (*guest_ext) {
 	case RISCV_ISA_EXT_SMNPM:
@@ -443,13 +445,16 @@ static int kvm_riscv_vcpu_get_reg_core(struct kvm_vcpu *vcpu,
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
 					    KVM_REG_SIZE_MASK |
 					    KVM_REG_RISCV_CORE);
+	unsigned long regs_max = sizeof(struct kvm_riscv_core) / sizeof(unsigned long);
 	unsigned long reg_val;
 
 	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
 		return -EINVAL;
-	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -ENOENT;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
 		reg_val = cntx->sepc;
 	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
@@ -476,13 +481,16 @@ static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
 					    KVM_REG_SIZE_MASK |
 					    KVM_REG_RISCV_CORE);
+	unsigned long regs_max = sizeof(struct kvm_riscv_core) / sizeof(unsigned long);
 	unsigned long reg_val;
 
 	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
 		return -EINVAL;
-	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -ENOENT;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
@@ -507,10 +515,13 @@ static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
 					  unsigned long *out_val)
 {
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	unsigned long regs_max = sizeof(struct kvm_riscv_csr) / sizeof(unsigned long);
 
-	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -ENOENT;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
 		kvm_riscv_vcpu_flush_interrupts(vcpu);
 		*out_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
@@ -526,10 +537,13 @@ static int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
 					  unsigned long reg_val)
 {
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	unsigned long regs_max = sizeof(struct kvm_riscv_csr) / sizeof(unsigned long);
 
-	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -ENOENT;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
 		reg_val &= VSIP_VALID_MASK;
 		reg_val <<= VSIP_TO_HVIP_SHIFT;
@@ -548,11 +562,14 @@ static inline int kvm_riscv_vcpu_smstateen_set_csr(struct kvm_vcpu *vcpu,
 						   unsigned long reg_val)
 {
 	struct kvm_vcpu_smstateen_csr *csr = &vcpu->arch.smstateen_csr;
+	unsigned long regs_max = sizeof(struct kvm_riscv_smstateen_csr) /
+		sizeof(unsigned long);
 
-	if (reg_num >= sizeof(struct kvm_riscv_smstateen_csr) /
-		sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -EINVAL;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	((unsigned long *)csr)[reg_num] = reg_val;
 	return 0;
 }
@@ -562,11 +579,14 @@ static int kvm_riscv_vcpu_smstateen_get_csr(struct kvm_vcpu *vcpu,
 					    unsigned long *out_val)
 {
 	struct kvm_vcpu_smstateen_csr *csr = &vcpu->arch.smstateen_csr;
+	unsigned long regs_max = sizeof(struct kvm_riscv_smstateen_csr) /
+		sizeof(unsigned long);
 
-	if (reg_num >= sizeof(struct kvm_riscv_smstateen_csr) /
-		sizeof(unsigned long))
+	if (reg_num >= regs_max)
 		return -EINVAL;
 
+	reg_num = array_index_nospec(reg_num, regs_max);
+
 	*out_val = ((unsigned long *)csr)[reg_num];
 	return 0;
 }

-- 
2.51.0


