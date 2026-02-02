Return-Path: <kvm+bounces-69796-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0GSYLZshgGnw3AIAu9opvQ
	(envelope-from <kvm+bounces-69796-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 05:01:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 59E3BC81A4
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 05:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D99013001A64
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 04:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3036027B340;
	Mon,  2 Feb 2026 04:01:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D003FC9;
	Mon,  2 Feb 2026 04:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770004885; cv=none; b=Hg8DjAVWEXmouKykat+iTpGb84StpK/AUTF4P8B8WpWK+X7ZBafcigxf73uGxV/gCLwCiT2DT8HuyDTb/+sZVULrh823dlrofRW4qedm9eWVLCmkOO7yjdiT6x/F4t94MxOe4xodqQ7mXjzAmGIVLT89aNMlOSYUQQTgwUSgYXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770004885; c=relaxed/simple;
	bh=Zg/r068zEFYzvwHs29BQBUHJfUAoW/lDKEqKlai3FXo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ms9BMwnuADQff6X+LLJXDp/d+xTdEGx3kRYRsloPOjXt+oSvb7CW0vWcqsKO6noFvL49muG1rzqMXBMWnMuwe9hQS/ImYG/p0OcJdxEcfV8p6hIVgbqRQlegwL8/lQngqM3LZPtrGGpzuykO765IX9MuZZNIUiDt+PoUEw0xBic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowAAnDON8IYBpot59Bw--.49852S2;
	Mon, 02 Feb 2026 12:01:01 +0800 (CST)
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
Subject: [PATCH v2] RISC-V: KVM: Fix use-after-free in kvm_riscv_gstage_get_leaf()
Date: Mon,  2 Feb 2026 04:00:59 +0000
Message-Id: <20260202040059.1801167-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAnDON8IYBpot59Bw--.49852S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw4UtrW7XF4Utw45tF13Jwb_yoW5JFykpF
	Z8Gry3CryrJr4kCry7tryDZrWDWw4UWrWkCFy5CF9rGrsIqa97Zrna9as2qry5ArykXFy3
	ZrWDKa4rCr4Fya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU6c_3UUUUU=
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiDAUGCWl-a8ajEgABsN
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69796-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[ghiti.fr,eecs.berkeley.edu,dabbelt.com,sifive.com,linux.dev,brainfault.org,iscas.ac.cn,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iscas.ac.cn:mid,iscas.ac.cn:email]
X-Rspamd-Queue-Id: 59E3BC81A4
X-Rspamd-Action: no action

While fuzzing KVM on RISC-V, a use-after-free was observed in
kvm_riscv_gstage_get_leaf(),  where ptep_get() dereferences a
freed gstage page table page during gfn unmap.

The crash manifests as:
  use-after-free in ptep_get include/linux/pgtable.h:340 [inline]
  use-after-free in kvm_riscv_gstage_get_leaf arch/riscv/kvm/gstage.c:89
  Call Trace:
    ptep_get include/linux/pgtable.h:340 [inline]
    kvm_riscv_gstage_get_leaf+0x2ea/0x358 arch/riscv/kvm/gstage.c:89
    kvm_riscv_gstage_unmap_range+0xf0/0x308 arch/riscv/kvm/gstage.c:265
    kvm_unmap_gfn_range+0x168/0x1fc arch/riscv/kvm/mmu.c:256
    kvm_mmu_unmap_gfn_range virt/kvm/kvm_main.c:724 [inline]
  page last free pid 808 tgid 808 stack trace:
    kvm_riscv_mmu_free_pgd+0x1b6/0x26a arch/riscv/kvm/mmu.c:457
    kvm_arch_flush_shadow_all+0x1a/0x24 arch/riscv/kvm/mmu.c:134
    kvm_flush_shadow_all virt/kvm/kvm_main.c:344 [inline]

The UAF is caused by gstage page table walks running concurrently with
gstage pgd teardown. In particular, kvm_unmap_gfn_range() can traverse
gstage page tables while kvm_arch_flush_shadow_all() frees the pgd,
leading to use-after-free of page table pages.

Fix the issue by serializing gstage unmap and pgd teardown with
kvm->mmu_lock. Holding mmu_lock ensures that gstage page tables
remain valid for the duration of unmap operations and prevents
concurrent frees.

This matches existing RISC-V KVM usage of mmu_lock to protect gstage
map/unmap operations, e.g. kvm_riscv_mmu_iounmap.

Fixes: dd82e35638d67f ("RISC-V: KVM: Factor-out g-stage page table management")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
---
V1 -> V2: Removed kvm->mmu_lock in kvm_arch_flush_shadow_all().

 arch/riscv/kvm/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index a1c3b2ec1dde5..1d71c1cb429ca 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -268,9 +268,11 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	gstage.flags = 0;
 	gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
 	gstage.pgd = kvm->arch.pgd;
+	spin_lock(&kvm->mmu_lock);
 	kvm_riscv_gstage_unmap_range(&gstage, range->start << PAGE_SHIFT,
 				     (range->end - range->start) << PAGE_SHIFT,
 				     range->may_block);
+	spin_unlock(&kvm->mmu_lock);
 	return false;
 }
 
-- 
2.34.1


