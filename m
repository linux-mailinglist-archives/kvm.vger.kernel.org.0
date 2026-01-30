Return-Path: <kvm+bounces-69694-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YLERHtSEfGmINgIAu9opvQ
	(envelope-from <kvm+bounces-69694-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 11:15:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F6AB9421
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 11:15:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9C37F30292DA
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 10:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13CE5313276;
	Fri, 30 Jan 2026 10:15:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97E11F09A8;
	Fri, 30 Jan 2026 10:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769768142; cv=none; b=Pe3d6ZWROLyW0DqAk4fSsc8De5PHnPpQvMepramcaYra27SvyqI3UJNuEQphSAUknkZ9ME/aBSONaN97OFXUZB9KpMug/LnQ1D6jT51wi+ptA2Oio3KQshmQs12+GapY74YMfku6CmyR3U2fiEho9mtLJEkzY2EwlL9EnxaSwm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769768142; c=relaxed/simple;
	bh=PZuljLuawC6Q0ycJomnrZQnxgiXcT31C1kuc0BfSIXA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pl8ONq8C1s7/7GhMkdDlk7K07S7BNTXvxgWcL9vVRbmgN2wnBtKH/NMZw8RxxolnGVIcf2wvB0SgnHgMvWqNhmpkoZib2bYNX+QV5hoXhjSloQM9rFfqK/cAKirL0tfyv1vvKKnArRA5k3QA2GlHkeP0O4IOG4zBYYxrEqEVG7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowADXaw+8hHxpTvkMBw--.50196S2;
	Fri, 30 Jan 2026 18:15:24 +0800 (CST)
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
Subject: [PATCH] RISC-V: KVM: Fix use-after-free in kvm_riscv_gstage_get_leaf()
Date: Fri, 30 Jan 2026 10:15:23 +0000
Message-Id: <20260130101523.1314053-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADXaw+8hHxpTvkMBw--.50196S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCF43XF47Gw4rCF13uF4kZwb_yoW5XF4kpF
	W5GrZxCryrJrs7CFy7tr1kZrsruw48Wr97Ca45CF98GFnIqrs7Zrn29as2qr15Ar18Zry3
	ZFyDKa4rCr4Fya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCY02Avz4vE14
	v_Gw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU5o7KDUUU
	U
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiDAYBCWl6JcUB-gABsP
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69694-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[ghiti.fr,eecs.berkeley.edu,dabbelt.com,sifive.com,linux.dev,brainfault.org,iscas.ac.cn,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,iscas.ac.cn:mid,iscas.ac.cn:email]
X-Rspamd-Queue-Id: E6F6AB9421
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
 arch/riscv/kvm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index a1c3b2ec1dde5..08316e433d729 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -128,7 +128,9 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
+	spin_lock(&kvm->mmu_lock);
 	kvm_riscv_mmu_free_pgd(kvm);
+	spin_unlock(&kvm->mmu_lock);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
@@ -268,9 +270,11 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
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


