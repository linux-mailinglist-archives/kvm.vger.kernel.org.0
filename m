Return-Path: <kvm+bounces-64279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7922CC7CA49
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 08:52:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A3B13A89BF
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 07:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BD752BEC52;
	Sat, 22 Nov 2025 07:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="K5OjLYeD"
X-Original-To: kvm@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45F81CEACB;
	Sat, 22 Nov 2025 07:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763797839; cv=none; b=GyLB4f1btvfR53cDTnpDMURhKi32+HZGSEnhlb362C51g0q4oWn3SiHzar/GT5p2PWT3BpoY2dMuuVE24pTrYb6H8iznOm1c5MGQchp56Ym6uPvOiaUsnm5aWG6TlkcsZ1h/9+6B097z9L/jmLoaaVIcSBC7z6CkdYivwlraEEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763797839; c=relaxed/simple;
	bh=NlMNDqM/zhbO5Zx0zbB8P2NEoDgtv71aGtiPas/lsGw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oyjDuiPrzk2Nquea04F7rKO3n8OM5GY5IwKW68XYoM3gdjOuiBU7UaGjMo9NMGbKUJfmhX5bJSzcSAUhbr5+S2ktzYvNSIYJwxij2PA+fpZkHvkp79YCsLQ0SGGmZipoZ2ipb4srR1Vhhzp4GuMwYuI/Ybn0D43WCSvKifYWWSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=K5OjLYeD; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763797827; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=2EzqfeFOaSlEXbtIbD6DtqooVMJceZ4coYRaIINcRzU=;
	b=K5OjLYeD9/C4G6Y5zqdG3iT38bBxZ8AJ+UxLrsIcZLGctPKZqN88q+iCobzTk0cMeP/xu4wrAy0bfo16wxd6xr52oKOQsLuqm54eintWT5FM/SP6TOvYE18fCFYFC5kB8+XSaix40dIr4M39E2TDSGYoy1dFTLUJVB36u43tRSs=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0Wt3WcpV_1763797825 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 22 Nov 2025 15:50:26 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@kernel.org,
	ajones@ventanamicro.com,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH] RISC-V: KVM: Allow to downgrade HGATP mode via SATP mode
Date: Sat, 22 Nov 2025 15:50:23 +0800
Message-Id: <20251122075023.27589-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

Currently, HGATP mode uses the maximum value detected by the hardware
but often such a wide GPA is unnecessary, just as a host sometimes
doesn't need sv57.
It's likely that no additional parameters (like no5lvl and no4lvl) are
needed, aligning HGATP mode to SATP mode should meet the requirements
of most scenarios.

Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 arch/riscv/kvm/gstage.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index b67d60d722c2..bff80c80ead3 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -320,7 +320,6 @@ void __init kvm_riscv_gstage_mode_detect(void)
 	csr_write(CSR_HGATP, HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
 	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV57X4) {
 		kvm_riscv_gstage_mode = HGATP_MODE_SV57X4;
-		kvm_riscv_gstage_pgd_levels = 5;
 		goto done;
 	}
 
@@ -328,7 +327,6 @@ void __init kvm_riscv_gstage_mode_detect(void)
 	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
 	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
 		kvm_riscv_gstage_mode = HGATP_MODE_SV48X4;
-		kvm_riscv_gstage_pgd_levels = 4;
 		goto done;
 	}
 
@@ -336,7 +334,6 @@ void __init kvm_riscv_gstage_mode_detect(void)
 	csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
 	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV39X4) {
 		kvm_riscv_gstage_mode = HGATP_MODE_SV39X4;
-		kvm_riscv_gstage_pgd_levels = 3;
 		goto done;
 	}
 #else /* CONFIG_32BIT */
@@ -354,6 +351,10 @@ void __init kvm_riscv_gstage_mode_detect(void)
 	kvm_riscv_gstage_pgd_levels = 0;
 
 done:
+#ifdef CONFIG_64BIT
+	kvm_riscv_gstage_mode = min(satp_mode >> SATP_MODE_SHIFT, kvm_riscv_gstage_mode);
+	kvm_riscv_gstage_pgd_levels = kvm_riscv_gstage_mode - HGATP_MODE_SV39X4 + 3;
+#endif
 	csr_write(CSR_HGATP, 0);
 	kvm_riscv_local_hfence_gvma_all();
 }
-- 
2.50.1


