Return-Path: <kvm+bounces-72349-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IE8sCidQpWms8gUAu9opvQ
	(envelope-from <kvm+bounces-72349-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 09:53:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C20E31D4FA2
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 09:53:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31B6C301FFA8
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 08:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F2E38A737;
	Mon,  2 Mar 2026 08:53:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A07379EF2;
	Mon,  2 Mar 2026 08:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772441612; cv=none; b=r9G5HNFS7mz+qCWSxrHThDyzhXet7IC3rE1VIfaHGlz2dDlmln778DPnAG6wIPVkr1/2OaoK1B23MHB1vG2nq3ecS0c8ZFl3EzsyZTDsixyciJIfBBwm61b8BhFrcvK35xS5xKm1lSAb8GEagzeb7UncjHFyeOuT9OIpM3kxeCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772441612; c=relaxed/simple;
	bh=hLrEGYCjrXxtdkrxjLHrijTiQu7D53a/IAQk4YLfN6w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QQKt146O15+S1v1W/Sut8bWVVv6TZY+68y9suQng3u+LsP0ckJqypIVhO/Lk37vkVIogUa9xalneduMMhBJAzw8oO5yjMNzvIe2zKd7Wmojgli1L5h1U7BkZl62emcsABIkjUj+wtt9etEGtK42543w/3BWexPb32ZGamf4Qh/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowAB34276T6Vpe_AXCQ--.522S2;
	Mon, 02 Mar 2026 16:53:14 +0800 (CST)
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
Subject: [PATCH v2] RISC-V: KVM: Fix use-after-free in kvm_riscv_aia_aplic_has_attr()
Date: Mon,  2 Mar 2026 08:53:12 +0000
Message-Id: <20260302085312.1649738-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAB34276T6Vpe_AXCQ--.522S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWF4fGF45WF4DGrWrGF1rJFb_yoW5Cry7pF
	WrGFyDA3y5Gwn7GrZIkw1kXr4I9r4YkF1rKr47urWI9rsxtrWIyr9a9ry2qr45AFW8J3sI
	qF4Yk3s5ur15JF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCY02Avz4vE14
	v_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUnJPEDUUU
	U
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiDAUOCWmlOvpQgAAAsS
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72349-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.561];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,iscas.ac.cn:mid,iscas.ac.cn:email]
X-Rspamd-Queue-Id: C20E31D4FA2
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

Fix this race by acquiring dev->kvm->lock in aia_has_attr() before
calling kvm_riscv_aia_aplic_has_attr(), consistent with the locking
pattern used in aia_get_attr() and aia_set_attr().

Fixes: 289a007b98b06d ("RISC-V: KVM: Expose APLIC registers as attributes of AIA irqchip")
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
---
V1 -> V2:
- Fixed the race by adding locking in aia_has_attr() instead of
  introducing a new validation function, as suggested by Anup Patel.
---
 arch/riscv/kvm/aia_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index b195a93add1ce..ef944d7097d29 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -466,7 +466,9 @@ static int aia_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 		}
 		break;
 	case KVM_DEV_RISCV_AIA_GRP_APLIC:
+		mutex_lock(&dev->kvm->lock);
 		return kvm_riscv_aia_aplic_has_attr(dev->kvm, attr->attr);
+		mutex_unlock(&dev->kvm->lock);
 	case KVM_DEV_RISCV_AIA_GRP_IMSIC:
 		return kvm_riscv_aia_imsic_has_attr(dev->kvm, attr->attr);
 	}
-- 
2.34.1


