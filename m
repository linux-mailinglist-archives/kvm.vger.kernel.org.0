Return-Path: <kvm+bounces-55317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 870B8B2FC96
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 16:30:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B151B6211E
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 14:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8DD2D6614;
	Thu, 21 Aug 2025 14:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eO4X4D+e"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4972D6405;
	Thu, 21 Aug 2025 14:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786368; cv=none; b=k/qBwhoI4mKueNrXp6f1AFfNmRuTnuYCy0BTcpNS9ta8jKdo2s2HkTN6e5lwGAUmaNRbiAxqJG1A/qWqYAu986kGbZ2u4IKYJ5We5l2pSMfjx3xrUo6L18nY08aoamoqYgvVroHlnpICjCyGl4wpW0p7YmooFkxwIEjEpFs4E2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786368; c=relaxed/simple;
	bh=SjKIvgxvILxvhlxc+qvjcKbL1gYIOzuL2gDprUk8RXw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n0T4tDSmESOD4hMI7QYg97g9isX7ozyeg4ram6qb5H2PYS9/O41SrHiu57yN7ntoLAkqdkSS0ioqRlSKQ2Z6ulqlR1b1dwaP7cWMYVK9Xx1wphmcSgpFXF74lIGHbyt5qYpRze92uJGUmG1vGZcupB1VOhbBwWxTtFhrbxTjwpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eO4X4D+e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A355C4CEF4;
	Thu, 21 Aug 2025 14:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755786368;
	bh=SjKIvgxvILxvhlxc+qvjcKbL1gYIOzuL2gDprUk8RXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eO4X4D+eJ5MIGDyLmCAoKu949pGua8tVh4BV2PyxZC+P8SacIeWNDxI2Vr5SCyFoX
	 zy+x6Ka7BoBc1yA8X5kn0LPDzC2S8wadzowzTntqQ+vJw0yQWs6GkhJAkGJzNJ1VW0
	 Ly65kHNc/RhvM8K23X9Q68UCIAK51yI3QD7fzcUpECZsu8rs1r7feFufMgOkatcSqm
	 yPcdTNvNRTTqb/NericCHeFH+vunh86qRgfYL+zkX0yJrD4MMwnHSNRWdqbYMHSurf
	 7PDsLy/iu64gaLE2x1ZMpRpnnS/b2U4/JtVCFfDf4t7jX1jwW8+pJqnVb92Iv21x+w
	 zAlnWQKzeILTA==
From: guoren@kernel.org
To: guoren@kernel.org,
	troy.mitchell@linux.dev
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
	guoren@linux.alibaba.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	Nutty Liu <nutty.liu@hotmail.com>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>
Subject: [PATCH V4 RESEND 1/3] RISC-V: KVM: Write hgatp register with valid mode bits
Date: Thu, 21 Aug 2025 10:25:40 -0400
Message-Id: <20250821142542.2472079-2-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250821142542.2472079-1-guoren@kernel.org>
References: <20250821142542.2472079-1-guoren@kernel.org>
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

Fixes: fd7bb4a251df ("RISC-V: KVM: Implement VMID allocator")
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
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
2.40.1


