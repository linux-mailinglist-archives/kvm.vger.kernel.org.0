Return-Path: <kvm+bounces-54367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1CC1B1FF0E
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 08:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 173583B6351
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 06:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D792D8DCA;
	Mon, 11 Aug 2025 06:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="eap5vj5x"
X-Original-To: kvm@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F592D8381;
	Mon, 11 Aug 2025 06:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754892686; cv=none; b=V40OL4PBNH9vxpyj2lCV6MahFNWzc5xXu1lC4cUXhcvlYcIMZyi32jY8/HgE7YloZQzPJWzasSDUoCYah0VtqR3XVVLxlZ5sKNGtJmPpRec2Gy98gWwcnj5VA5HN7v6g+hVCUKZ/Of5YuAlyYfz4uKkP/oGuEkDdMsBpPLwr90M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754892686; c=relaxed/simple;
	bh=TykNv5gkgpZAOZDIW+MRRdfsxuTLkyNVFKonDaW4f/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iOCf4EAQhmKlNDcZEZ68v8/EgbV/hJBXVLH+LJZ+BpgN1nPTJrbkS3vgBLRtQq7vD/YbHaTeihOvJSERw52JlvAfn/t2vbKcNbmBoTOEt3gD0hR5sNh82lg3RwJowOLOfceWIkRPzUdF3vuAnyRgIO8phRidFX9YzuKz+Xhy/Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=eap5vj5x; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754892677; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=whyJDouuAuGf1j7b/5M2xWcx/VsvP58NxkP1IN3I0Kg=;
	b=eap5vj5xSFdMsiuuuxLcPgRxyY801HFUQUIvCCqkpAcHYj//JV5cuXJwf5j1YJm0/ee6jEICMpLSj9vYtmzqNDC0P4AsCA++zgDJ/6Xz3bzu8Mt2eGKZZZUxVQMxln1Cgp17Oapr64gInk8k46GeW/MWwpX4zMTNL+eZiutt98A=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WlP-v9-_1754892672 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 Aug 2025 14:11:13 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	atishp@atishpatra.org,
	tjeznach@rivosinc.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	sunilvl@ventanamicro.com,
	rafael.j.wysocki@intel.com,
	tglx@linutronix.de,
	ajones@ventanamicro.com
Cc: guoren@linux.alibaba.com,
	guoren@kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [RFC PATCH 2/6] RISC-V: KVM: Transfer the physical address of MRIF to iommu-ir
Date: Mon, 11 Aug 2025 14:11:00 +0800
Message-Id: <20250811061104.10326-3-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250811061104.10326-1-fangyu.yu@linux.alibaba.com>
References: <20250811061104.10326-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

According to the RISC-V IOMMU Spec, an IOMMU may optionally
support memory-resident interrupt files (MRIFs).

When the guest interrupt files are used up, we transfer the
physical address of MRIF to iommu-ir, and enable MRIF  mode
if the iommu-ir supports.

Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 arch/riscv/kvm/aia_imsic.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 8f5703d9112a..e91164742fd0 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -21,6 +21,8 @@
 
 #define IMSIC_MAX_EIX	(IMSIC_MAX_ID / BITS_PER_TYPE(u64))
 
+static int kvm_riscv_vcpu_irq_update(struct kvm_vcpu *vcpu);
+
 struct imsic_mrif_eix {
 	unsigned long eip[BITS_PER_TYPE(u64) / BITS_PER_LONG];
 	unsigned long eie[BITS_PER_TYPE(u64) / BITS_PER_LONG];
@@ -717,7 +719,8 @@ void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
 				 vcpu->arch.aia_context.imsic_addr,
 				 IMSIC_MMIO_PAGE_SZ);
 
-	/* TODO: Purge the IOMMU mapping ??? */
+	/* Update the IOMMU mapping */
+	kvm_riscv_vcpu_irq_update(vcpu);
 
 	/*
 	 * At this point, all interrupt producers have been re-directed
@@ -795,13 +798,14 @@ int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
 
 			read_lock_irqsave(&imsic->vsfile_lock, flags);
 
-			if (WARN_ON_ONCE(imsic->vsfile_cpu < 0)) {
-				read_unlock_irqrestore(&imsic->vsfile_lock, flags);
-				goto out;
+			if (imsic->vsfile_cpu < 0) {
+				vcpu_info.hpa = imsic->swfile_pa;
+				vcpu_info.mrif = true;
+			} else {
+				vcpu_info.hpa = imsic->vsfile_pa;
+				vcpu_info.mrif = false;
 			}
 
-			vcpu_info.hpa = imsic->vsfile_pa;
-
 			ret = irq_set_vcpu_affinity(host_irq, &vcpu_info);
 			if (ret) {
 				read_unlock_irqrestore(&imsic->vsfile_lock, flags);
@@ -844,6 +848,13 @@ static int kvm_riscv_vcpu_irq_update(struct kvm_vcpu *vcpu)
 		if (!irqfd->producer)
 			continue;
 		host_irq = irqfd->producer->irq;
+
+		if (imsic->vsfile_cpu < 0) {
+			vcpu_info.hpa = imsic->swfile_pa;
+			vcpu_info.mrif = true;
+		} else {
+			vcpu_info.mrif = false;
+		}
 		ret = irq_set_vcpu_affinity(host_irq, &vcpu_info);
 		if (ret) {
 			spin_unlock_irq(&kvm->irqfds.lock);
-- 
2.49.0


