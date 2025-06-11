Return-Path: <kvm+bounces-48989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F3FAAD515A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F0693A6534
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 10:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA24E263F41;
	Wed, 11 Jun 2025 10:08:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6E4263C68;
	Wed, 11 Jun 2025 10:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749636499; cv=none; b=bAbQh9NCK8CsBHLx05+B+oyde/aRuUP6YXxZzbv/8tY97vuHwL8obSo7QTCQ0LUbzoQzuCy85r/xyEWmEScojLmOb57VT9uwNbtMt20+yF/3A0ZC3/y5Xbua4w6yZ3WBnBXAYXSA31HgtBKHTLTxcV9L6AUNxHfy2zsbzqnCIKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749636499; c=relaxed/simple;
	bh=RLqB1iQ7SrII3N8HkkeOdj1kfx6TbSgG6AN9Zp7FTB4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qIuS5vi8DwjwcdMBJslzKcXIOoZbtKpmZCmrvMRLgtttUdfmYl4GP41XldEGmjd1G4Bmp0+VL3cXNl9kHrReRrQVNpVVucIyJxIczWJV/yDF/C4hcLKxMToclsMG92Tt1t9GyHBvGn1LziXRXmKREQ4kfYno3Rns3QFSMQaKX+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.smartont.net (unknown [180.110.114.155])
	by APP-01 (Coremail) with SMTP id qwCowADHPdy2U0lo4lS+BQ--.28065S2;
	Wed, 11 Jun 2025 18:00:22 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH] RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()
Date: Wed, 11 Jun 2025 17:51:40 +0800
Message-Id: <50989f0a02790f9d7dc804c2ade6387c4e7fbdbc.1749634392.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADHPdy2U0lo4lS+BQ--.28065S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WrW3trWfAFyrArWUXrW3GFg_yoW8JF43pF
	4xCF1DCr4Fg3ZI9ry2k3Wv9a9xCa95W3Z7Cr4UGrWYqrsxtrySqws5W397ZF13Jr48XFWx
	ZFn8XFWUZr4rGw7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9C14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUBSoAUUUUU=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBgwKBmhJLhCtlQAAsh

From: Quan Zhou <zhouquan@iscas.ac.cn>

The caller has already passed in the memslot, and there are
two instances `{kvm_faultin_pfn/mark_page_dirty}` of retrieving
the memslot again in `kvm_riscv_gstage_map`, we can replace them
with `{__kvm_faultin_pfn/mark_page_dirty_in_slot}`.

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 arch/riscv/kvm/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 1087ea74567b..f9059dac3ba3 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -648,7 +648,8 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	}
 
-	hfn = kvm_faultin_pfn(vcpu, gfn, is_write, &writable, &page);
+	hfn = __kvm_faultin_pfn(memslot, gfn, is_write ? FOLL_WRITE : 0,
+				&writable, &page);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
 		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
 				vma_pageshift, current);
@@ -670,7 +671,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		goto out_unlock;
 
 	if (writable) {
-		mark_page_dirty(kvm, gfn);
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
 		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
 				      vma_pagesize, false, true);
 	} else {
-- 
2.34.1


