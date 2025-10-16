Return-Path: <kvm+bounces-60117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A0A6BE1299
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 03:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 07BB24E9DD5
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 01:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6966E200113;
	Thu, 16 Oct 2025 01:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="s8Tca036"
X-Original-To: kvm@vger.kernel.org
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B369442C;
	Thu, 16 Oct 2025 01:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760578037; cv=none; b=WCzFqjNFaRPDoITFZayFbPa1oCztVGXqrAEvesRMB30kyZHoUrG62tM1ekfGqan2rikn0YT0jbblV7E0kKO/QsDgZs8Yjl2AmIu8Td6CdrymZ0YWnKlCugXRNZLCUuN6lMQ4UON03GLzZlgF0cWusjJbteiY80jbZl5ulHk3JUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760578037; c=relaxed/simple;
	bh=gOUgDUYZVm+im++xEkphoCbEb/h269Q16wFF6gakZDQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nJLgXgDq7xekLGUHz/zPV06l0VBZAVlTDutHEpsi6rggt0TKgb8+W+8aq1LSS3SpCa/9TacHR8P/Ei+K2MUGPTU0e3WVcgtCG3ygwPt/roLkPChUaSJdMDCWNDKoZsrbJ92SBebJMgPwIp+XQrSv+egIOGq4WDrQ7+NL3Wi++74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=s8Tca036; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760578025; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=mWoWxsGAtDp0EV2ifeUAQMZcSWDLqLKjj7ZtzpCtdDQ=;
	b=s8Tca036nAYGLhwD/eHRemHu1aYPLz8nNT0PfNxS3NQ+q7ePV+qFrww/jeHZhVSKJ9Lc104DmROM/Pnv6QrHAA0GFrORj4JFgKoms90ipLDclwYsNdctp/mu5pLeQnerPKoU/Q4KDX1G0eIO3xURZy+zjpkmOfJLIIJMqewvjkg=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WqIKtva_1760578023 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Oct 2025 09:27:04 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	liujingqi@lanxincomputing.com
Cc: guoren@kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH] RISC-V: KVM: Read HGEIP CSR on the correct cpu
Date: Thu, 16 Oct 2025 09:26:59 +0800
Message-Id: <20251016012659.82998-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

When executing kvm_riscv_vcpu_aia_has_interrupts, the vCPU may have
migrated and the IMSIC VS-file have not been updated yet, currently
the HGEIP CSR should be read from the imsic->vsfile_cpu ( the pCPU
before migration ) via on_each_cpu_mask, but this will trigger an
IPI call and repeated IPI within a period of time is expensive in
a many-core systems.

Just let the vCPU execute and update the correct IMSIC VS-file via
kvm_riscv_vcpu_aia_imsic_update may be a simple solution.

Fixes: 4cec89db80ba ("RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization")
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 arch/riscv/kvm/aia_imsic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index fda0346f0ea1..168c02ad0a78 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -689,8 +689,12 @@ bool kvm_riscv_vcpu_aia_imsic_has_interrupt(struct kvm_vcpu *vcpu)
 	 */
 
 	read_lock_irqsave(&imsic->vsfile_lock, flags);
-	if (imsic->vsfile_cpu > -1)
-		ret = !!(csr_read(CSR_HGEIP) & BIT(imsic->vsfile_hgei));
+	if (imsic->vsfile_cpu > -1) {
+		if (imsic->vsfile_cpu != smp_processor_id())
+			ret = true;
+		else
+			ret = !!(csr_read(CSR_HGEIP) & BIT(imsic->vsfile_hgei));
+	}
 	read_unlock_irqrestore(&imsic->vsfile_lock, flags);
 
 	return ret;
-- 
2.50.1


