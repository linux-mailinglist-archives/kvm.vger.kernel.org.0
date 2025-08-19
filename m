Return-Path: <kvm+bounces-54955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E904FB2B9CB
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 08:45:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 970867AE7CF
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 06:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624A92773D0;
	Tue, 19 Aug 2025 06:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pF7BZ0Lh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5A726E6EB;
	Tue, 19 Aug 2025 06:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755585912; cv=none; b=ldv3seipU+JPH84A61NqJKHqogtkhG6oDwghtivLmrpLLOpCfy0ChVIcbs1AfLLETTQoPUWPaFyEZPjZ4qm1PxfERbS90Q3+oz6EEevzSusXm1+PoQ+6HXNyixrG9wE9JvZNnvrZeRsxGQqmdJqZHYcoYEq29nD9rZ+cFh2fnQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755585912; c=relaxed/simple;
	bh=UP9QrxfK6QYEHcUJrlYlyfxkQRb2pZ0b31ddHRriPIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VeXWJv6sXh7nhOUIIbE8RQt5A8j8DUjQThJ42F+4aXCCDU8eFyk3akqcLnQMFygRUHDGjkFqPctCBYpnBxQL6MxzUEHjnnOHXXnE3pCIuq/e2/Xgggkt7LrdlPOI9NwSXpPj9NUXAg72Pe+H1jzc92eeM9oUOnmFXfw1dwVDYd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pF7BZ0Lh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25906C4CEF4;
	Tue, 19 Aug 2025 06:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755585912;
	bh=UP9QrxfK6QYEHcUJrlYlyfxkQRb2pZ0b31ddHRriPIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pF7BZ0Lh144HFRdf5oCuVGgwhS7bRIQEywwzSk6HQeJ/ALSsZDqbmX1Mk168Z/kKe
	 jx8wzNKp4rnFXGafekaeWb0JvrWmtmuqGF0cdq2pPSKfH47PD7fUhvSYR+5FQdb0Jb
	 yjuLh6wYWTqAGcx8RghQz0VbMo2YtdGRGhH8cuz7qXaZre0aivb9DwwW4pdxQRKgRZ
	 N6sZgsVkPlM20oc+MnJq7W9u2yH30quU+dSMjTfmiHxsq2QiksdauUpz2oXQrrx9Op
	 JdtbmLse2hd8SIF+h0v2IZq9ZdQq8vrM6R+ibymfYLih6iS4zxZVWvDNUyqe1zhhrv
	 LcUn7JuQFMOrQ==
From: guoren@kernel.org
To: guoren@kernel.org
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
	paul.walmsley@sifive.com
Subject: [PATCH] RISC-V KVM: Remove unnecessary HGATP csr_read
Date: Tue, 19 Aug 2025 02:44:29 -0400
Message-Id: <20250819064429.1947476-1-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <CAJF2gTQFWJzHhRoQ-oASO9nn1kC0dv+NuK-DD=JgfeHE90RWqw@mail.gmail.com>
References: <CAJF2gTQFWJzHhRoQ-oASO9nn1kC0dv+NuK-DD=JgfeHE90RWqw@mail.gmail.com>
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
---
This cleanup is based on yufang.yu's vmid fixup patch.
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
2.40.1


