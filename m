Return-Path: <kvm+bounces-55124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36D9AB2DD43
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0708176F2E
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 13:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A26C31DDB5;
	Wed, 20 Aug 2025 13:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Ut/70OCZ"
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B14C31DD84;
	Wed, 20 Aug 2025 12:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755694803; cv=none; b=ofSPQxld26WzMcvFIXUrjDyiVmesWmdDbUMmYgpubrso0NLKYyU1yyMoMXx8ZBxM1I1G/d4rNuWANoNzE20qsGidN89JRvS6kyC4aeAkQoHfkJ4W6G+hznNixUovAzOAxKKslFOXKdcTC5lArPHSq5sdNzlUkJxpJ0V9lI99EiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755694803; c=relaxed/simple;
	bh=c4d8lao18sblo5EKTHFtqf2ou3wuf2cEnlrvot6mnTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cv6z1TI5lUxhEzXEfuAmov7GsGgrWSiXHgtyUohv2o4icpULaS0qytHjQ0+vavZOD/yit5uET3ROeRPVB9oToWskDsFVO0OhCib+jCSa8gGk7zKFltD1E96KKIzbEBRZClY7029dKqw8gTv4r/1dkOZYsQCq2VU0f6qmhWZOZo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Ut/70OCZ; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755694797; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=U4wVJ4Rm1M27YjAVFx51yXXj7bzUgmhjmUV0DS4wCbY=;
	b=Ut/70OCZgXxYTICGYkKHnh3dRDc0JqlPTS4IUx3kruzrw2c2sL8n3tpwjdrWVq1GMC3wFjRmF8Vq4mkkbQZSTb6Lcc4WdOETjH0E3f+qc5ub7Fm3ukUxwl9V5mLpqPx1cbj6gD89ArQhkRinyqwuM3Utlhun25xP0PnqjzSrDsI=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WmCQaZj_1755694796 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 20:59:57 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	atish.patra@linux.dev,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH v3 2/2] RISC-V KVM: Remove unnecessary HGATP csr_read
Date: Wed, 20 Aug 2025 20:59:52 +0800
Message-Id: <20250820125952.71689-3-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250820125952.71689-1-fangyu.yu@linux.alibaba.com>
References: <20250820125952.71689-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>

The HGATP has been set to zero in gstage_mode_detect(), so there
is no need to save the old context. Unify the code convention
with gstage_mode_detect().

Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 arch/riscv/kvm/vmid.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 5f33625f4070..abb1c2bf2542 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -25,15 +25,12 @@ static DEFINE_SPINLOCK(vmid_lock);
 
 void __init kvm_riscv_gstage_vmid_detect(void)
 {
-	unsigned long old;
-
 	/* Figure-out number of VMID bits in HW */
-	old = csr_read(CSR_HGATP);
 	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
 	vmid_bits = csr_read(CSR_HGATP);
 	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
 	vmid_bits = fls_long(vmid_bits);
-	csr_write(CSR_HGATP, old);
+	csr_write(CSR_HGATP, 0);
 
 	/* We polluted local TLB so flush all guest TLB */
 	kvm_riscv_local_hfence_gvma_all();
-- 
2.49.0


