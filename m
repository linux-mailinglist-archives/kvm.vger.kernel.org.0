Return-Path: <kvm+bounces-54864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C476B298FE
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 07:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46DFC201302
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 05:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 367B92701C7;
	Mon, 18 Aug 2025 05:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hPIwl/x4"
X-Original-To: kvm@vger.kernel.org
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1FF26FA5E;
	Mon, 18 Aug 2025 05:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755495746; cv=none; b=fhcJUVPbsPg738GAuF2bgq4m6iGnVVYONJFOCrIXYtRXLqSEPp0L3LxYGrvv/5P0oVQ+X/T+d8qIjWteiSvDlj2jaM4yHUlmKKGoENFoHwmLWcP9weNPnB/0t9nDG43yA3twiGSDKSIb+H0v1ZJ/Nn+2haQ+HIGAzhfv10PprZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755495746; c=relaxed/simple;
	bh=XExVPFjM+tFXne7pcUVaqjrlJWN5Mo3/9a3ND1Rmit8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eGge0zMPA5lHMAcA2+RIG3Rua6NImghvT5mjQ+vVYSXFwSpPsLUofmoiXufQs9ikBAuLfG5z8ApsfF1wKtmdCOx2sxirIlAeuR0K6kiQ1Mo8GjKZT1vGPbAmNovECwei1kkoFt17/2zjlJh/L5hnsJNU6lbpXNMu70tHghoJpIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hPIwl/x4; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755495734; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=W4lHP3UjuHeCBUcDEIF9ZeVamIkRm6NrjeDmREzHBUM=;
	b=hPIwl/x466LMKdD2zsBK0SqUCtPuPve8LARSTo62NI9PQqaVxjM8k5nih0mUEbv/1RcV2gs18W9L+S0P8GQi7JFfDwCgyaraHjPkBm93TefAKdtiD4j1WV/whZ3GDR8O9tuK0/GL8rHfKMYSG5k17coXXv52LIoCHCfXk/67ArQ=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0Wlvjb0u_1755495732 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 Aug 2025 13:42:14 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	atish.patra@linux.dev,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@linux.alibaba.com,
	guoren@kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH V2] RISC-V: KVM: Write hgatp register with valid mode bits
Date: Mon, 18 Aug 2025 13:42:07 +0800
Message-Id: <20250818054207.21532-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

According to the RISC-V Privileged Architecture Spec, when MODE=Bare
is selected,software must write zero to the remaining fields of hgatp.

We have detected the valid mode supported by the HW before, So using a
valid mode to detect how many vmid bits are supported.

Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>

---
Changes in v2:
- Fixed build error since kvm_riscv_gstage_mode() has been modified.
---
 arch/riscv/kvm/vmid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 3b426c800480..5f33625f4070 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -14,6 +14,7 @@
 #include <linux/smp.h>
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
+#include <asm/kvm_mmu.h>
 #include <asm/kvm_tlb.h>
 #include <asm/kvm_vmid.h>
 
@@ -28,7 +29,7 @@ void __init kvm_riscv_gstage_vmid_detect(void)
 
 	/* Figure-out number of VMID bits in HW */
 	old = csr_read(CSR_HGATP);
-	csr_write(CSR_HGATP, old | HGATP_VMID);
+	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
 	vmid_bits = csr_read(CSR_HGATP);
 	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
 	vmid_bits = fls_long(vmid_bits);
-- 
2.49.0


