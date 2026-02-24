Return-Path: <kvm+bounces-71611-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mNpoBtyBnWlsQQQAu9opvQ
	(envelope-from <kvm+bounces-71611-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:47:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F66185A01
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:47:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 75A273062419
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E73C36921C;
	Tue, 24 Feb 2026 10:45:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FEA3793C1;
	Tue, 24 Feb 2026 10:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771929905; cv=none; b=IxDF2/mWssxETPtjT6DH/PJsE+WUta1wE+cc3LnT67afprkN5Qxui2A4v7dmOXl2V3USw7GFJj7ueF0nD9IyH8Nv5F/RH5BAr/xYwfgPqkxZUtBikg50UerTP46D3AP+AjZjVvPQCx+nVZJNK8GbQVVU2IQmanKz6qm8K8bqDJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771929905; c=relaxed/simple;
	bh=3bdAopc9FEVX41KwJBnanSobIsK2xquFnhmTqrrAGrk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TiuDEQ6DnO28MZ3Hg0FOtref+QZJUZqbus297ggVUoQ9+jFAoQ5VGyZIxm8iQh8dRdR3emtioLjxw14wNoZzoHUiZDVYVC7dJCu2cgUF09dQlzu2TSfPcazjxUvmTMryOku22o82+/tm8EeTd79ctjLBUlhzKku2PEK4nSyl8SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowAAXrA8XgZ1pbTsKCQ--.27963S2;
	Tue, 24 Feb 2026 18:44:40 +0800 (CST)
From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: [PATCH] RISC-V: KVM: Fix use-after-free in kvm_riscv_aia_aplic_has_attr()
Date: Tue, 24 Feb 2026 10:44:38 +0000
Message-Id: <20260224104438.57727-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAXrA8XgZ1pbTsKCQ--.27963S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWF4fGF45WF4DGrWrGF1rJFb_yoWruFyfpr
	WUGryDAr45trn7Gr4a9wn7Ww4a9r4q9F15KrWUWrWI9r43trWft3s29w1jqF15AFyrZasI
	vr4UK3s3Wa15AF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
	YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjEoGDUUUUU==
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiBgwICWmdZOtWnQAAs7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71611-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[brainfault.org,linux.dev,sifive.com,dabbelt.com,eecs.berkeley.edu,ghiti.fr,iscas.ac.cn,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iscas.ac.cn:mid,iscas.ac.cn:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 83F66185A01
X-Rspamd-Action: no action

Fuzzer reports a KASAN use-after-free bug triggered by a race
between KVM_HAS_DEVICE_ATTR and KVM_SET_DEVICE_ATTR ioctls on the AIA
device. The root cause is that aia_has_attr() invokes
kvm_riscv_aia_aplic_has_attr() without holding dev->kvm->lock, while
a concurrent aia_set_attr() may call aia_init() under that lock. When
aia_init() fails after kvm_riscv_aia_aplic_init() has succeeded, it
calls kvm_riscv_aia_aplic_cleanup() in its fail_cleanup_imsics path,
which frees both aplic_state and aplic_state->irqs. The concurrent
has_attr path can then dereference the freed aplic->irqs in
aplic_read_pending():
	irqd = &aplic->irqs[irq];   /* UAF here */

KASAN report:
 BUG: KASAN: slab-use-after-free in aplic_read_pending
             arch/riscv/kvm/aia_aplic.c:119 [inline]
 BUG: KASAN: slab-use-after-free in aplic_read_pending_word
             arch/riscv/kvm/aia_aplic.c:351 [inline]
 BUG: KASAN: slab-use-after-free in aplic_mmio_read_offset
             arch/riscv/kvm/aia_aplic.c:406
 Read of size 8 at addr ff600000ba965d58 by task 9498
 Call Trace:
  aplic_read_pending arch/riscv/kvm/aia_aplic.c:119 [inline]
  aplic_read_pending_word arch/riscv/kvm/aia_aplic.c:351 [inline]
  aplic_mmio_read_offset arch/riscv/kvm/aia_aplic.c:406
  kvm_riscv_aia_aplic_has_attr arch/riscv/kvm/aia_aplic.c:566
  aia_has_attr arch/riscv/kvm/aia_device.c:469
 allocated by task 9473:
  kvm_riscv_aia_aplic_init arch/riscv/kvm/aia_aplic.c:583
  aia_init arch/riscv/kvm/aia_device.c:248 [inline]
  aia_set_attr arch/riscv/kvm/aia_device.c:334
 freed by task 9473:
  kvm_riscv_aia_aplic_cleanup arch/riscv/kvm/aia_aplic.c:644
  aia_init arch/riscv/kvm/aia_device.c:292 [inline]
  aia_set_attr arch/riscv/kvm/aia_device.c:334

The patch replaces the actual MMIO read in kvm_riscv_aia_aplic_has_attr()
with a new aplic_mmio_has_offset() that only validates whether the given
offset falls within a known APLIC region, without touching any
dynamically allocated state. This is consistent with the KVM API
documentation for KVM_HAS_DEVICE_ATTR:
  "Tests whether a device supports a particular attribute. A successful
   return indicates the attribute is implemented. It does not necessarily
   indicate that the attribute can be read or written in the device's
   current state."
The upper bounds of each region are taken directly from the
RISC-V AIA specification, so the check is independent of the runtime
values of nr_irqs and nr_words.

This patch both fixes the use-after-free and makes the has_attr
implementation semantically correct.

Fixes: 289a007b98b06d ("RISC-V: KVM: Expose APLIC registers as attributes of AIA irqchip")
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
---
 arch/riscv/kvm/aia_aplic.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
index f59d1c0c8c43a..5e7a1055b2de6 100644
--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -527,6 +527,31 @@ static struct kvm_io_device_ops aplic_iodoev_ops = {
 	.write = aplic_mmio_write,
 };
 
+static int aplic_mmio_has_offset(struct kvm *kvm, gpa_t off)
+{
+	if ((off & 0x3) != 0)
+		return -EOPNOTSUPP;
+
+	if ((off == APLIC_DOMAINCFG) ||
+		(off >= APLIC_SOURCECFG_BASE && off < (APLIC_SOURCECFG_BASE + 1023 * 4)) ||
+		(off >= APLIC_SETIP_BASE && off < (APLIC_SETIP_BASE + 32 * 4)) ||
+		(off == APLIC_SETIPNUM) ||
+		(off >= APLIC_CLRIP_BASE && off < (APLIC_CLRIP_BASE + 32 * 4)) ||
+		(off == APLIC_CLRIPNUM) ||
+		(off >= APLIC_SETIE_BASE && off < (APLIC_SETIE_BASE + 32 * 4)) ||
+		(off == APLIC_SETIENUM) ||
+		(off >= APLIC_CLRIE_BASE && off < (APLIC_CLRIE_BASE + 32 * 4)) ||
+		(off == APLIC_CLRIENUM) ||
+		(off == APLIC_SETIPNUM_LE) ||
+		(off == APLIC_SETIPNUM_BE) ||
+		(off == APLIC_GENMSI) ||
+		(off >= APLIC_TARGET_BASE && off < (APLIC_TARGET_BASE + 1203 * 4))
+	)
+		return 0;
+	else
+		return -ENODEV;
+}
+
 int kvm_riscv_aia_aplic_set_attr(struct kvm *kvm, unsigned long type, u32 v)
 {
 	int rc;
@@ -558,12 +583,11 @@ int kvm_riscv_aia_aplic_get_attr(struct kvm *kvm, unsigned long type, u32 *v)
 int kvm_riscv_aia_aplic_has_attr(struct kvm *kvm, unsigned long type)
 {
 	int rc;
-	u32 val;
 
 	if (!kvm->arch.aia.aplic_state)
 		return -ENODEV;
 
-	rc = aplic_mmio_read_offset(kvm, type, &val);
+	rc = aplic_mmio_has_offset(kvm, type);
 	if (rc)
 		return rc;
 
-- 
2.34.1


