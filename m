Return-Path: <kvm+bounces-54826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A444B28B77
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 09:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08325AA31C2
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 07:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2162264DB;
	Sat, 16 Aug 2025 07:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="UluxB1cQ"
X-Original-To: kvm@vger.kernel.org
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17ADB10E3;
	Sat, 16 Aug 2025 07:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755329572; cv=none; b=iNIYFGO871ZIgoyVMAciaEXQP/90nQgFgRRgItNC0mbQCCNga5uusc031Uv0rHwYSN9coKMORiEv4wm+5zjOIiJ2As/b1OZa+j2Au4673fORTMHkFeQtz+FbUGTiEnOSss7rRjOauFK6ffyD47v7qJuW2SKKEAnBqKJ8ksdyd3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755329572; c=relaxed/simple;
	bh=q+dgUCPe7PptlK/VNa6BpDuPqjJRDtx/mKOxTEyOEdI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b8fRmzP9QIHdcPdr6kqRsOB2UNIk0AR1aBinOSAaUBdIHnGr0UkidIs1uD4KewEW/W6+zEmACAqtgX0l0qpb24PwBp8k4LAW4Ks6TjUfZH6nqTQtl7owtFfKmQ0AqfuEjOpjHNxMDdovCCV6lFBFYE91b58Xlly/cr5ZS8its0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=UluxB1cQ; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755329558; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Zi3mt6f9DghYW3n1681Tp/+SCUmn8lZ88byVYz6vHiE=;
	b=UluxB1cQrymYLvK+3ZAwrCIev8HS87uApWtGZS5RlQeX+uwrjobqZwe+crSsmpGRFFnvGLTo9HegkVsBplo0cxeDZ/wndqgjdF06CPrFnovzd2gW1O8tisZ91SRox798RnhHPcZDUe6NZnmuzuaHHBg2/jk5mHdhUwdxSsYTthM=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0Wlqzknt_1755329556 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 16 Aug 2025 15:32:38 +0800
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
Subject: [PATCH] RISC-V: KVM: Write hgatp register with valid mode bits
Date: Sat, 16 Aug 2025 15:32:34 +0800
Message-Id: <20250816073234.77646-1-fangyu.yu@linux.alibaba.com>
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
 arch/riscv/kvm/vmid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 3b426c800480..d176a5c2f9a4 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -28,7 +28,7 @@ void __init kvm_riscv_gstage_vmid_detect(void)
 
 	/* Figure-out number of VMID bits in HW */
 	old = csr_read(CSR_HGATP);
-	csr_write(CSR_HGATP, old | HGATP_VMID);
+	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode() << HGATP_MODE_SHIFT) | HGATP_VMID);
 	vmid_bits = csr_read(CSR_HGATP);
 	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
 	vmid_bits = fls_long(vmid_bits);
-- 
2.49.0


