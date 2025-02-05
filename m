Return-Path: <kvm+bounces-37312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00EEDA28674
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:25:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 842231638AC
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 09:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EDEB22A7E1;
	Wed,  5 Feb 2025 09:25:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CAF322A4DA;
	Wed,  5 Feb 2025 09:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738747544; cv=none; b=nosjc7Rp49To51Ud53FSf3pQmh2GYPBoNpuAKKMUnQcrBOkL+roV/6t7ya5GHUvXFtKw/sMcQMhL386n9SNQsWS5svGKQzjSbJVmacHLR8ra4Z/OpH2JGw0sqrzxEtI0/eHa3G0cmCxaBZtDUehGVLxGacPOjVLdigqldAKkxcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738747544; c=relaxed/simple;
	bh=LJcFnN9gJwfUfOG3O6tba5PYyMbo02O+qICApByuuMM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QsXxta2I64ilVei4vILjE7GbAoK1wfxaa3aaUNtTcUq4FeHwz/96MJ4hHLMMddye1U0YUIf0n4fx9goT0sbbekvcZhBdMzWLX9+YxRZadM5J0kksDZfAm5PFWzvTrtJR1o9WkjrovvA5o2/BWQgDpjGu8n9dj2YQ7Yq7e4hA3TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxaeGLLqNnQR1sAA--.14187S3;
	Wed, 05 Feb 2025 17:25:31 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxXsWKLqNnvh0AAA--.262S2;
	Wed, 05 Feb 2025 17:25:31 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Remove PGD table saving during VM context switch
Date: Wed,  5 Feb 2025 17:25:30 +0800
Message-Id: <20250205092530.1625606-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxXsWKLqNnvh0AAA--.262S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

PGD table for primary mmu keeps unchanged once VM is created, it
is not necessary to save PGD table pointer during VM context switch.
And it can be acquired when VCPU is created.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  2 ++
 arch/loongarch/kernel/asm-offsets.c   |  4 +---
 arch/loongarch/kvm/switch.S           | 10 +---------
 arch/loongarch/kvm/vcpu.c             | 10 ++++++++++
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 590982cd986e..0d7a83407d84 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -180,6 +180,8 @@ struct kvm_vcpu_arch {
 	unsigned long host_sp;
 	unsigned long host_tp;
 	unsigned long host_pgd;
+	/* pgd table pointer for secondary mmu */
+	unsigned long host_second_pgd;
 
 	/* Host CSRs are used when handling exits from guest */
 	unsigned long badi;
diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/asm-offsets.c
index 8be1c38ad8eb..8c33b9b2ee40 100644
--- a/arch/loongarch/kernel/asm-offsets.c
+++ b/arch/loongarch/kernel/asm-offsets.c
@@ -289,13 +289,13 @@ static void __used output_kvm_defines(void)
 	BLANK();
 
 	OFFSET(KVM_VCPU_ARCH, kvm_vcpu, arch);
-	OFFSET(KVM_VCPU_KVM, kvm_vcpu, kvm);
 	OFFSET(KVM_VCPU_RUN, kvm_vcpu, run);
 	BLANK();
 
 	OFFSET(KVM_ARCH_HSP, kvm_vcpu_arch, host_sp);
 	OFFSET(KVM_ARCH_HTP, kvm_vcpu_arch, host_tp);
 	OFFSET(KVM_ARCH_HPGD, kvm_vcpu_arch, host_pgd);
+	OFFSET(KVM_ARCH_HSECPGD, kvm_vcpu_arch, host_second_pgd);
 	OFFSET(KVM_ARCH_HANDLE_EXIT, kvm_vcpu_arch, handle_exit);
 	OFFSET(KVM_ARCH_HEENTRY, kvm_vcpu_arch, host_eentry);
 	OFFSET(KVM_ARCH_GEENTRY, kvm_vcpu_arch, guest_eentry);
@@ -306,8 +306,6 @@ static void __used output_kvm_defines(void)
 	OFFSET(KVM_ARCH_HECFG, kvm_vcpu_arch, host_ecfg);
 	OFFSET(KVM_ARCH_HESTAT, kvm_vcpu_arch, host_estat);
 	OFFSET(KVM_ARCH_HPERCPU, kvm_vcpu_arch, host_percpu);
-
-	OFFSET(KVM_GPGD, kvm, arch.pgd);
 	BLANK();
 }
 
diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 0c292f818492..1598d1f53334 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -60,16 +60,8 @@
 	ld.d	t0, a2, KVM_ARCH_GPC
 	csrwr	t0, LOONGARCH_CSR_ERA
 
-	/* Save host PGDL */
-	csrrd	t0, LOONGARCH_CSR_PGDL
-	st.d	t0, a2, KVM_ARCH_HPGD
-
-	/* Switch to kvm */
-	ld.d	t1, a2, KVM_VCPU_KVM - KVM_VCPU_ARCH
-
 	/* Load guest PGDL */
-	li.w    t0, KVM_GPGD
-	ldx.d   t0, t1, t0
+	ld.d	t0, a2, KVM_ARCH_HSECPGD
 	csrwr	t0, LOONGARCH_CSR_PGDL
 
 	/* Mix GID and RID */
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index fb72095c8077..8e822b1233ff 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1462,6 +1462,16 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED_HARD);
 	vcpu->arch.swtimer.function = kvm_swtimer_wakeup;
 
+	/* Get pgd for secondary mmu */
+	vcpu->arch.host_second_pgd = (unsigned long)vcpu->kvm->arch.pgd;
+
+	/*
+	 * Get pgd for primary mmu
+	 *
+	 * Supposing current->mm == vcpu->kvm->mm and pgd table keeps unchanged
+	 * since vmm threads are created
+	 */
+	vcpu->arch.host_pgd = (unsigned long)vcpu->kvm->mm->pgd;
 	vcpu->arch.handle_exit = kvm_handle_exit;
 	vcpu->arch.guest_eentry = (unsigned long)kvm_loongarch_ops->exc_entry;
 	vcpu->arch.csr = kzalloc(sizeof(struct loongarch_csrs), GFP_KERNEL);

base-commit: 5c8c229261f14159b54b9a32f12e5fa89d88b905
-- 
2.39.3


