Return-Path: <kvm+bounces-55318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC30B2FCEA
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 16:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EBDD1D21025
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 14:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEEAA2D6E6B;
	Thu, 21 Aug 2025 14:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIUwo+87"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA032D6E5D;
	Thu, 21 Aug 2025 14:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786373; cv=none; b=rDzjlfZgtSt/fl+d9Tr+QeLG7dbFd7orWv2QGCMyqU5pO7wjA11P0OHQ+8IGFdW5RvMo1mcyw4rNSI2ro3z3svNmJPiHOMf/oHaQDhG2i/WrsWjoYv/hewBSmTzWlvgwC+JufmjNMPiUm1OLqvi2Re/wNoUf2Ro8FfsOWE83hyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786373; c=relaxed/simple;
	bh=G0YrLOlqNEkhmNDKqjNXIej+ao+iP0qZxWm/nWbxgcU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QF5PaYhXVtL8/Odfjm0qcLN8OxSBCghdhdxyxrou0zI8F7q5WHAsA6R2u+863xkFURlR1Y+lyiuEd0qGPCKV+iimosQxKNVGIA4tQv26yEgiMxalxUIJzp+cbV55Xhj8PdGKi9o/zXR5KqegWvMgmcP9672D/wCrXWCU4IazRwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIUwo+87; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E13C4CEEB;
	Thu, 21 Aug 2025 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755786372;
	bh=G0YrLOlqNEkhmNDKqjNXIej+ao+iP0qZxWm/nWbxgcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nIUwo+87Ry/oXZ6mg9Fw4HZ0MMFxJkXAarXgjf1itGfDNVkddF4Mp9uqfxoFzfwwq
	 dKkxZPxRYY1b8fD4Gzfy77M8ZwRGzu1RRdhCgLkhFVCyRl9G71eTogt/T+i5tI71u+
	 BllOOUXWaAO6HLOOnHNhwvJlDGq/Rmr3zM/Qy4lQu2tGIUSeYmZSvD2I3ubrSiHccA
	 h5aSW27p/WEpPX2u1iVBmgKU7a0nHp6CD+jOJXNj/XTA4RLvZAdRNMlxXbmUNEvnWf
	 gI32iy8/42hgb5rRDxJhwI6k52FpdkimxQJmeV9X99ERICX2upoWuiSF28m4VDYneg
	 VKarGoW2PNQRA==
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
	paul.walmsley@sifive.com
Subject: [PATCH V4 RESEND 2/3] RISC-V: KVM: Remove unnecessary HGATP csr_read
Date: Thu, 21 Aug 2025 10:25:41 -0400
Message-Id: <20250821142542.2472079-3-guoren@kernel.org>
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

From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>

The HGATP has been set to zero in gstage_mode_detect(), so there
is no need to save the old context. Unify the code convention
with gstage_mode_detect().

Reviewed-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
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


