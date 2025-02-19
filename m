Return-Path: <kvm+bounces-38547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C0EAA3B017
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 04:39:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB0613B3774
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 03:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F0B1AC892;
	Wed, 19 Feb 2025 03:38:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1E119D8A9;
	Wed, 19 Feb 2025 03:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739936309; cv=none; b=ACy3j4bfikLt8iCB+m8Pet2K8oCES7rKqbHz1zhhhJHEU35UZQTfbdyJnLuuisKEvXonkHiU6hhMHGQINHGQMJsVoUNm8M/15tXd90R8b5O1yJLwjHIolN37DS8J16awvVLsUSWlT6b5QdKFtl3iIjYoJyle++s3dHlpot4hYZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739936309; c=relaxed/simple;
	bh=B5D0QBR6hqfloL2g//LnwTjoR4Jenu08YmsMwiP98uc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=myb6c2qU3fRMgQ4UXLWSXO3GUV1GL8TIGiEq3qCXYiq8+GHOiF5rwETTUZs+OqSdO227Ra+jQrYD9/lnnFCvxR9Aur0YjdqRYQYuT8t9LboMDuz1flbGFhkcjLHycIrMby5RM/Yql175k7KkDmKZdoY6SEaWfBz3QqwpwlU/WwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxG6wxUrVn7Ip6AA--.48243S3;
	Wed, 19 Feb 2025 11:38:25 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxj8UwUrVnRnAbAA--.39192S3;
	Wed, 19 Feb 2025 11:38:24 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] LoongArch: KVM: Remove PGD saving during VM context switch
Date: Wed, 19 Feb 2025 11:38:22 +0800
Message-Id: <20250219033823.215630-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250219033823.215630-1-maobibo@loongson.cn>
References: <20250219033823.215630-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxj8UwUrVnRnAbAA--.39192S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

PGD table for primary mmu keeps unchanged once VM is created, it
is not necessary to save PGD table pointer during VM context switch.
And it can be acquired when VM is created.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  2 ++
 arch/loongarch/kernel/asm-offsets.c   |  4 +---
 arch/loongarch/kvm/switch.S           | 12 ++----------
 arch/loongarch/kvm/vcpu.c             |  8 ++++++++
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 590982cd986e..7a96c6300b0b 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -180,6 +180,8 @@ struct kvm_vcpu_arch {
 	unsigned long host_sp;
 	unsigned long host_tp;
 	unsigned long host_pgd;
+	/* physical address about pgd for secondary mmu */
+	unsigned long kvm_pgd;
 
 	/* Host CSRs are used when handling exits from guest */
 	unsigned long badi;
diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/asm-offsets.c
index 8be1c38ad8eb..13b158081145 100644
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
+	OFFSET(KVM_ARCH_KVMPGD, kvm_vcpu_arch, kvm_pgd);
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
index 1be185e94807..f1768b7a6194 100644
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
-	/* Load guest PGDL */
-	li.w    t0, KVM_GPGD
-	ldx.d   t0, t1, t0
+	/* Load PGD for KVM hypervisor */
+	ld.d	t0, a2, KVM_ARCH_KVMPGD
 	csrwr	t0, LOONGARCH_CSR_PGDL
 
 	/* Mix GID and RID */
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 20f941af3e9e..1edce1192577 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1462,6 +1462,14 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED_HARD);
 	vcpu->arch.swtimer.function = kvm_swtimer_wakeup;
 
+	/* Get physical address about pgd for kvm hypervisor */
+	vcpu->arch.kvm_pgd = __pa(vcpu->kvm->arch.pgd);
+
+	/*
+	 * Get pgd for primary mmu, virtual address is used since there is
+	 * memory access after loading from CSR_PGD in tlb exception fast path.
+	 */
+	vcpu->arch.host_pgd = (unsigned long)vcpu->kvm->mm->pgd;
 	vcpu->arch.handle_exit = kvm_handle_exit;
 	vcpu->arch.guest_eentry = (unsigned long)kvm_loongarch_ops->exc_entry;
 	vcpu->arch.csr = kzalloc(sizeof(struct loongarch_csrs), GFP_KERNEL);
-- 
2.39.3


