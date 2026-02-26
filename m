Return-Path: <kvm+bounces-71944-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yDVPEm8KoGnbfQQAu9opvQ
	(envelope-from <kvm+bounces-71944-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:55:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC311A2F97
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:55:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0059F301DAD2
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A6839526A;
	Thu, 26 Feb 2026 08:51:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD8D311955;
	Thu, 26 Feb 2026 08:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772095896; cv=none; b=f99fh3KtEC3CiwusEhORs8nXN7K5cdKPRIqMa1G7PvdW1m5ACBkhTn0kmeJjBQW+BMHexaE4zgx50JwXhuW1P0dN/pb+4MKjN77EgnRcVP1l8rN5dfC9mXiM5gxfqYIzxSYruPnfqsQx8lD3+CNvOaS76EIu7UughNBz1STaJSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772095896; c=relaxed/simple;
	bh=704/CSEq1m4Y2rP6RAsg3HnDt40VW3AMizWZPmg0E+I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VqeaDs/SvVmSOaeAdY724WlCKQkN/P0tPFhEJxvTZmRSBA/VlIByS1FXGnsF47w40+r7aCOf8KU7sHhmjHhSAkpktFX4Db/7LQL5PxkYPM0Y+tKTpzgWkDbyxHnhkbEbFj0UF+8BsYuoqInebw54NCHqA3b8uRd6DxWmhw5rOME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowADnkGyJCaBpC0_FCA--.1935S2;
	Thu, 26 Feb 2026 16:51:22 +0800 (CST)
From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Atish Patra <atish.patra@linux.dev>,
	Anup Patel <anup@brainfault.org>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: [PATCH v2] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_vcpu_aia_rmw_topei()
Date: Thu, 26 Feb 2026 08:51:19 +0000
Message-Id: <20260226085119.643295-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADnkGyJCaBpC0_FCA--.1935S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WFyUuryxKr4Dtr47Cry5twb_yoW8tw1Dpr
	ZxCrnYkryxXF4xC39rAwn7Xr4vgr4jkF15Wr98W3y5Wr4UtFWFvr1vg348XFWUJFy8Zas2
	yF1UCF4F9F1UXw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8JVWxJw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
	YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxkIecxEwVAFwV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUx5rcUUUUU
	=
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiBwkKCWmf1qe6iQAAs5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71944-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[ghiti.fr,eecs.berkeley.edu,dabbelt.com,sifive.com,linux.dev,brainfault.org,iscas.ac.cn,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iscas.ac.cn:mid,iscas.ac.cn:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BBC311A2F97
X-Rspamd-Action: no action

kvm_riscv_vcpu_aia_rmw_topei() assumes that the per-vCPU IMSIC state has
been initialized once AIA is reported as available and initialized at
the VM level. This assumption does not always hold.

Under fuzzed ioctl sequences, a guest may access the IMSIC TOPEI CSR
before the vCPU IMSIC state is set up. In this case,
vcpu->arch.aia_context.imsic_state is still NULL, and the TOPEI RMW path
dereferences it unconditionally, leading to a host kernel crash.

The crash manifests as:
  Unable to handle kernel paging request at virtual address
  dfffffff0000000e
  ...
  kvm_riscv_vcpu_aia_imsic_rmw arch/riscv/kvm/aia_imsic.c:909
  kvm_riscv_vcpu_aia_rmw_topei arch/riscv/kvm/aia.c:231
  csr_insn arch/riscv/kvm/vcpu_insn.c:208
  system_opcode_insn arch/riscv/kvm/vcpu_insn.c:281
  kvm_riscv_vcpu_virtual_insn arch/riscv/kvm/vcpu_insn.c:355
  kvm_riscv_vcpu_exit arch/riscv/kvm/vcpu_exit.c:230
  kvm_arch_vcpu_ioctl_run arch/riscv/kvm/vcpu.c:1008
  ...

Fix this by explicitly checking whether the vCPU IMSIC state has been
initialized before handling TOPEI CSR accesses. If not, forward the CSR
emulation to user space.

Fixes: db8b7e97d6137 ("RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
---
V1 -> V2: Moved imsic_state NULL check into kvm_riscv_vcpu_aia_imsic_rmw().
          Updated Fixes tag to db8b7e97d6137.
---
 arch/riscv/kvm/aia_imsic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index fda0346f0ea1f..60917f4789d84 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -892,6 +892,10 @@ int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu, unsigned long isel,
 	int r, rc = KVM_INSN_CONTINUE_NEXT_SEPC;
 	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
 
+	/* If IMSIC vCPU state not initialized then forward to user space */
+	if (!imsic)
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+
 	if (isel == KVM_RISCV_AIA_IMSIC_TOPEI) {
 		/* Read pending and enabled interrupt with highest priority */
 		topei = imsic_mrif_topei(imsic->swfile, imsic->nr_eix,
-- 
2.34.1


