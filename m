Return-Path: <kvm+bounces-54218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5779BB1D2FF
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:08:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DC9F166B70
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 07:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267C7230BCC;
	Thu,  7 Aug 2025 07:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="q8h3SWMD"
X-Original-To: kvm@vger.kernel.org
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E76F1F0E34;
	Thu,  7 Aug 2025 07:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754550486; cv=none; b=UltA3gAawvcJ1k+u7FYm1FafB+PwrfKkg3eO9zkVUR1pDnlxduZk8kypnUw6855q0k/YhXNxBEyD9aCFs3W7gPRsqQEqNvcNVxZT0Ehdoq2Fn5chl5fW+Jkoj/BEtF4j6+8hX0j+C5xX2VVPSjdgzJKbczv4KWpM51stAAOhdrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754550486; c=relaxed/simple;
	bh=hAERWUPiLhlozUtBoCJrHGmE5+TJ8nS2/la8R6RnQFg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lVx+HFB/wC5A8MgrRGNnuZG7Ow8kJetySd/w6ium14OaKibANLtJeSK0P8exkrvUQUXmoi6cJhUdpYdJ7cfb8gBu6kdtjXAYgVlfadejsYREKKdDZcsCnRA4EtJqSR36JlqwjXVw8nqIa6EXxeszlHJ4fbL690VGjVCYZOq/FWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=q8h3SWMD; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754550473; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=x1j0D5e4G22FkHtFUQZnx1eku8o9hze9aSs0LkJshCo=;
	b=q8h3SWMDgZC7umFXgFPPwtFS9b4AHT8JyRzC1ZZG+Z+dF9GSKzSuaoiThpPjYXnxyhAP1vEYqorFKPqsWMJTdFiDqpAeTn9Mmvbot4/nsiy90Je0Jq9pDAUOAKU/UzIxE85vR4e9uilBeGv815IxZlfxLDPGc8EJGZlVNNexnuk=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WlDLLJk_1754550471 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 07 Aug 2025 15:07:53 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	atish.patra@linux.dev,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@linux.alibaba.com,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH] RISC-V: KVM: Using user-mode pte within kvm_riscv_gstage_ioremap
Date: Thu,  7 Aug 2025 15:07:29 +0800
Message-Id: <20250807070729.89701-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

Currently we use kvm_riscv_gstage_ioremap to map IMSIC gpa to the spa of
guest interrupt file within IMSIC.

The PAGE_KERNEL_IO property does not include user mode settings, so when
accessing the IMSIC address in the virtual machine,  a  guest page fault
will occur, this is not expected.

According to the RISC-V Privileged Architecture Spec, for G-stage address
translation, all memory accesses are considered to be user-level accesses
as though executed in Umode.

Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 arch/riscv/kvm/mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 1087ea74567b..800064e96ef6 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -351,6 +351,7 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 	int ret = 0;
 	unsigned long pfn;
 	phys_addr_t addr, end;
+	pgprot_t prot;
 	struct kvm_mmu_memory_cache pcache = {
 		.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0,
 		.gfp_zero = __GFP_ZERO,
@@ -359,8 +360,11 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
 	pfn = __phys_to_pfn(hpa);
 
+	prot = pgprot_noncached(PAGE_WRITE);
+
 	for (addr = gpa; addr < end; addr += PAGE_SIZE) {
-		pte = pfn_pte(pfn, PAGE_KERNEL_IO);
+		pte = pfn_pte(pfn, prot);
+		pte = pte_mkdirty(pte);
 
 		if (!writable)
 			pte = pte_wrprotect(pte);
-- 
2.39.3 (Apple Git-146)


