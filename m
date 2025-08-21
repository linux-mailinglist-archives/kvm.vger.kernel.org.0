Return-Path: <kvm+bounces-55231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7CEEB2EBD5
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 05:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 798705E2372
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 03:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FF32E4242;
	Thu, 21 Aug 2025 03:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOooZLj+";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=lists.infradead.org header.i=@lists.infradead.org header.b="2ZxzVYUV";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="koOuzd7g";
	dkim=neutral (0-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Bw06UKcc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D666E2E0927;
	Thu, 21 Aug 2025 03:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755746279; cv=none; b=ECKf6mneXKgXFwQI9Mme941Fp1gRskmd86NNO7r74h9OXuEeIWKal5QVA3b0j3ZVBXbjoPxspk8MjDlnlLbUA4skB5CaCTezc1J5P4a/njoWsnSKXfK5A6tAJ+cs8tHw4MX18At70Wg9iBN6go2bDsaYQztMsOhKKDVjvHK3mzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755746279; c=relaxed/simple;
	bh=pIZZGYlHJcwUGIEu2mrA8wTduJ6lRtlRg1MiSy3SH4k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sfYWa6EQnfoqGbzQ7UjiwiIHEr3/trWB8x3gYonbFFgQpK4iJZQaDgLhE/qDiZCdQY1lYNV+WgEVKhbMUCwgQj+QzOpTEYVXSFaNBOqrtpvAnsYER1CDlp575IHGC+5VEfc2zHV0PizY6PnRtwKvkRm5Sa8QFTyKQXLDnXvwnms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOooZLj+; dkim=fail (2048-bit key) header.d=lists.infradead.org header.i=@lists.infradead.org header.b=2ZxzVYUV reason="signature verification failed"; dkim=fail (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=koOuzd7g reason="signature verification failed"; dkim=neutral (0-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Bw06UKcc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B005CC113D0;
	Thu, 21 Aug 2025 03:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755746278;
	bh=pIZZGYlHJcwUGIEu2mrA8wTduJ6lRtlRg1MiSy3SH4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-Id:
	 List-Unsubscribe:List-Archive:List-Post:List-Help:List-Subscribe:
	 From;
	b=jOooZLj+YY+aMj55dFok5m9llv1ugcrpy1AnF3OnHvsDm2gTVE352eR81/Z+EGf9q
	 Cf2KY06W8UScjXMHJjJnNHU9TVGBFVI6AGPxfpeV6aeY+97FBlKcP+gxupn+L7PuQa
	 r7gmWcgUNxb9JEtxRKEhnQwI/IglV/Nus7Q0208bSS+ArdxHHFxwMxoOG1VKjHstlI
	 0y28zXaPFNSQYyRf8HoncVQj+stLzg3iryXzJ4hRDZdJxXubJs9dPgUlJMJR7yhw60
	 Oe4SOqsA0CauzfF+3rp2Aae75vydTlh2G8BanL6PzBVH87nf9qE+jOalab4bSJRYBY
	 Vif1tHQMLP+MQ==
From: guoren@kernel.org
To: guoren@kernel.org,
	troy.mitchell@linux.dev,
	anup@brainfault.org,
	atish.patra@linux.dev,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: fangyu.yu@linux.alibaba.com,
	guoren@linux.alibaba.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH V2] RISC-V: KVM: Write hgatp register with valid mode bits
Date: Wed, 20 Aug 2025 23:17:19 -0400
Message-Id: <20250818054207.21532-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250821031719.2366017-1-guoren@kernel.org>
References: <CAJF2gTQFWJzHhRoQ-oASO9nn1kC0dv+NuK-DD=JgfeHE90RWqw@mail.gmail.com>
 <20250821031719.2366017-1-guoren@kernel.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133]) (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits)) (No client certificate requested) by smtp.lore.kernel.org (Postfix) with ESMTPS id 99F14CA0EE4 for <linux-riscv@archiver.kernel.org>; Mon, 18 Aug 2025 05:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lists.infradead.org; s=bombadil.20210309; h=Sender: Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post: List-Archive:List-Unsubscribe:List-Id:MIME-Version:Message-Id:Date:Subject:Cc :To:From:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From: Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References: List-Owner; bh=V/Xvw3Ej+7ZPNCPsGP++tgMpKMekL0hhuM8UIwiPd5Y=; b=2ZxzVYUVFi37Yt jF7MIm78837f27APbAPlvfpkdaMJWzjexabx9AD8ZAonS3zJuWlOE1V1KdFXv3NzCW/4OxKLK28My iBQo2YXcFrVn6B/W32Cx4kULqj/3bJln7lIkBy6xx8a9cBT1CHrkRRDltDg4mkITpUX3M+GvdY4OT NXjbntvEwuq7DQ2RABwvL6nSsyhqxNI3pOsLK4Cm8a/bLWkv+BJzhoLHexWlkmaW+GG66u4AAQnYu E5QoEymQ1zI/yNPiGl3c2X1zlMfvfaUG+FqQDR8ZjghL9oKWgSYZoFIWHcuxd68JDhj+DKZsVdAtf dpa7pkCixetHi2UQ91xw==;
Received: from localhost ([::1] helo=bombadil.infradead.org) by bombadil.infradead.org with esmtp (Exim 4.98.2 #2 (Red Hat Linux)) id 1unsdj-00000006ZQx-2OO3; Mon, 18 Aug 2025 05:42:39 +0000
Received: from desiato.infradead.org ([2001:8b0:10b:1:d65d:64ff:fe57:4e05]) by bombadil.infradead.org with esmtps (Exim 4.98.2 #2 (Red Hat Linux)) id 1unsdh-00000006ZQR-2Mit; Mon, 18 Aug 2025 05:42:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:MIME-Version :Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID: Content-Description:In-Reply-To:References; bh=W4lHP3UjuHeCBUcDEIF9ZeVamIkRm6NrjeDmREzHBUM=; b=koOuzd7gtEiuvbX6QWUdEEfxep wAoSpz+VU+Pvg8z5YcgXjpCuSUBt9vOfCZYlk2EHiOJdkxBoA0L97jRRXlMA08bhZvQREefopKM45 7fUXMPpddLtAY3wEzin8HeCmpDUj80aphi2Cq7MjsUt7sNP+ouV2apWc+n6iQPf+1Zr/njiwynjsA 9XaYUFDot8JKd7WB3rjbi0qN8uYGTArj+/9GuOkTUvtEvRFOmEgpo6PNgVMZmMXSuv6PWx/ptlUt0 9gJ+ZmGYWq7GiufiH/bvt9BgskruRB3jP+/R+3wcjclP+NpdaEVNvDxLSq+y0KUgNpXOEwzAQCi9W UE/CQv4A==;
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]) by desiato.infradead.org with esmtps (Exim 4.98.2 #2 (Red Hat Linux)) id 1unsdd-0000000HGDo-03SR; Mon, 18 Aug 2025 05:42:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.alibaba.com; s=default; t=1755495738; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=W4lHP3UjuHeCBUcDEIF9ZeVamIkRm6NrjeDmREzHBUM=; b=Bw06UKccpjeqr3QGXKendqsuoZ4upfWC07EDlSUZNyTv+ry0pLXfAM2oL4nyomAVBWM74WLkZRF0F0c5dctIJ454Neh1G659OADELFbLykfqQXtkwgyK9Dq3g76FZ1LI+amflRyfHSNziddWLTU/Qqp8JmdV1lxO4C99atObuJw=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0Wlvjb0u_1755495732 cluster:ay36) by smtp.aliyun-inc.com; Mon, 18 Aug 2025 13:42:14 +0800
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-BeenThere: linux-riscv@lists.infradead.org
X-Mailman-Version: 2.1.34
Precedence: list
List-Archive: <http://lists.infradead.org/pipermail/linux-riscv/>
List-Post: <mailto:linux-riscv@lists.infradead.org>
List-Help: <mailto:linux-riscv-request@lists.infradead.org?subject=help>
Content-Type: text/plain; charset="us-ascii"
Sender: "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
Errors-To: linux-riscv-bounces+linux-riscv=archiver.kernel.org@lists.infradead.org
Content-Transfer-Encoding: 8bit

From: fangyu.yu@linux.alibaba.com

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


_______________________________________________
linux-riscv mailing list
linux-riscv@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-riscv


