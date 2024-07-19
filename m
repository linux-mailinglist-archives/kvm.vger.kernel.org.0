Return-Path: <kvm+bounces-21950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BEFC937A7D
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 125AD1F21765
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4A3149C6F;
	Fri, 19 Jul 2024 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="CLuMdLT6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CCB149C4B
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721405405; cv=none; b=VeIlZC805aRPmAcy32+QvMdmIPP5c3D6kf5d1Y9yer6+O8rDGpD+hQbbws2BFmKe97tZyMxRdzLNCDTnd5/UEvEJTsAvWnIjywYskpo8xeK9y7mAoWgviP5HwmpbnfWnVU75z6NLHn23O0vTrO/OWSCHI4iIYvgAs7FZfJELV6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721405405; c=relaxed/simple;
	bh=0l8IyTL3ESKkiXlSGe/bagpKKMdDRBeDey0wpgpZSqA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IswEyjOavlqNzB/H4AYVGgMTRbrT8tKfXE03LDEOQX/B7BdZqw9xesTvK/lrNFQj0pi/cqGnp18GRJcT2xGtXTq17Hh7TFsEYjX7bbfj7i10fk6cdWdBIXMAv6ZXQh1gRTGsQGw6Px524YJXcJ+kUl+VOMJvagJOy9ZDEh6CoL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=CLuMdLT6; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1fbc3a9d23bso15788605ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 09:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721405403; x=1722010203; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zbBUe2dWVBXnAYtzUPKnZBxBsVbv9ClXZgKI121YyMI=;
        b=CLuMdLT6uGJGQp7GjsccUeJXdVwarQ2gjxDRv61t5AhVtHSUYMbxXejQr+9iJiFnaj
         IXnL0Z+azZ5nuJ269sN4i50Pc5TEFA+LxSFvX+V3B5HE12tmk3lJV8hBldSGOv4iAE9G
         hUGMP2x1jMfcdYCEwMysxLKnbczLCY4Gt2q1ymSWakVKvWoKNdT1KFieMJN8+MPmwNZL
         BF6kGqqqb+Vd4+VEpFHe5GZdKbiSE7gLJnlNRUGw6jV6PROJUtdaCJXspRCB/ohRSIRd
         pEWBrr6s8D/HTClG88DAo8PzSNKuETl8KUNRKjVyvEiifDGDizwjKWwtLwvDuzaksea7
         ohPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721405403; x=1722010203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zbBUe2dWVBXnAYtzUPKnZBxBsVbv9ClXZgKI121YyMI=;
        b=oMzyXNt+7Tw4ChTN48QNwx/I8EIv6gVnSv8qZcmAG32lxKRRT+UqodKOBeTHGvusVA
         Fmol+tdeU1NElJw6j6qfrd/AHb65/F7xyRHQXkfO81/N3hxbyphS1HVdWkU+VORkc2qV
         WP1z3FL2jymjHrPJm7Vc3K2yQNzd9YDmOQFzVybz/i6pnBcmYoFwWO1I0ws3KT5mIXRj
         IubQv9FoQJbsTODpVDkZjI8oxSIFumxxSIkyuZfPu2wrTK3Ylo9VVdrowkf9L+YM0rqi
         9kMleEfDpZF1fg+VyGpLNGWGTNERdsy+N2VT5NJkIyCNpvbGp0gF/cxCq/lbRMfmcxGF
         dK2w==
X-Forwarded-Encrypted: i=1; AJvYcCUy+IiAAiHCNq1En1pu7kwcAEqywH3aXoVKBxvtMLD4pqC3qL8ZIb+5m5cp1P9EPnC3Ghw5YPao83IWLYOoHh+/WjQ4
X-Gm-Message-State: AOJu0YyyDmTWUJ0ynPxmtl/53PCAafsYFfhsE36iggbJY10fFJfgtsfp
	jLZZPT6r7rOqevpJghyHI5GrWZ6T1Qyi5QG4Z9IYISWYa5MbW9gY8z1j/PY/wUo=
X-Google-Smtp-Source: AGHT+IHnsrDgJZ0Xs5ITUii+G2fuHbMcUuyE62ZDbeRXtLEqFfI/Ns6FYVTGusklNoZKrSdaOfNp8w==
X-Received: by 2002:a17:902:f947:b0:1fb:81ec:26da with SMTP id d9443c01a7336-1fd7462c073mr2523815ad.58.1721405403214;
        Fri, 19 Jul 2024 09:10:03 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f28f518sm6632615ad.69.2024.07.19.09.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 09:10:02 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 11/13] RISC-V: KVM: Use SBI sync SRET call when available
Date: Fri, 19 Jul 2024 21:39:11 +0530
Message-Id: <20240719160913.342027-12-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240719160913.342027-1-apatel@ventanamicro.com>
References: <20240719160913.342027-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement an optimized KVM world-switch using SBI sync SRET call
when SBI nested acceleration extension is available. This improves
KVM world-switch when KVM RISC-V is running as a Guest under some
other hypervisor.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_nacl.h | 32 +++++++++++++++++++++
 arch/riscv/kvm/vcpu.c             | 48 ++++++++++++++++++++++++++++---
 arch/riscv/kvm/vcpu_switch.S      | 29 +++++++++++++++++++
 3 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_nacl.h b/arch/riscv/include/asm/kvm_nacl.h
index a704e8000a58..5e74238ea525 100644
--- a/arch/riscv/include/asm/kvm_nacl.h
+++ b/arch/riscv/include/asm/kvm_nacl.h
@@ -12,6 +12,8 @@
 #include <asm/csr.h>
 #include <asm/sbi.h>
 
+struct kvm_vcpu_arch;
+
 DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_available);
 #define kvm_riscv_nacl_available() \
 	static_branch_unlikely(&kvm_riscv_nacl_available)
@@ -43,6 +45,10 @@ void __kvm_riscv_nacl_hfence(void *shmem,
 			     unsigned long page_num,
 			     unsigned long page_count);
 
+void __kvm_riscv_nacl_switch_to(struct kvm_vcpu_arch *vcpu_arch,
+				unsigned long sbi_ext_id,
+				unsigned long sbi_func_id);
+
 int kvm_riscv_nacl_enable(void);
 
 void kvm_riscv_nacl_disable(void);
@@ -64,6 +70,32 @@ int kvm_riscv_nacl_init(void);
 #define nacl_shmem_fast()						\
 	(kvm_riscv_nacl_available() ? nacl_shmem() : NULL)
 
+#define nacl_scratch_read_long(__shmem, __offset)			\
+({									\
+	unsigned long *__p = (__shmem) +				\
+			     SBI_NACL_SHMEM_SCRATCH_OFFSET +		\
+			     (__offset);				\
+	lelong_to_cpu(*__p);						\
+})
+
+#define nacl_scratch_write_long(__shmem, __offset, __val)		\
+do {									\
+	unsigned long *__p = (__shmem) +				\
+			     SBI_NACL_SHMEM_SCRATCH_OFFSET +		\
+			     (__offset);				\
+	*__p = cpu_to_lelong(__val);					\
+} while (0)
+
+#define nacl_scratch_write_longs(__shmem, __offset, __array, __count)	\
+do {									\
+	unsigned int __i;						\
+	unsigned long *__p = (__shmem) +				\
+			     SBI_NACL_SHMEM_SCRATCH_OFFSET +		\
+			     (__offset);				\
+	for (__i = 0; __i < (__count); __i++)				\
+		__p[__i] = cpu_to_lelong((__array)[__i]);		\
+} while (0)
+
 #define nacl_sync_hfence(__e)						\
 	sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_SYNC_HFENCE,		\
 		  (__e), 0, 0, 0, 0, 0)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 00baaf1b0136..fe849fb1aaab 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -759,19 +759,59 @@ static __always_inline void kvm_riscv_vcpu_swap_in_host_state(struct kvm_vcpu *v
  */
 static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
+	void *nsh;
 	struct kvm_cpu_context *gcntx = &vcpu->arch.guest_context;
 	struct kvm_cpu_context *hcntx = &vcpu->arch.host_context;
 
 	kvm_riscv_vcpu_swap_in_guest_state(vcpu);
 	guest_state_enter_irqoff();
 
-	hcntx->hstatus = ncsr_swap(CSR_HSTATUS, gcntx->hstatus);
+	if (kvm_riscv_nacl_sync_sret_available()) {
+		nsh = nacl_shmem();
 
-	nsync_csr(-1UL);
+		if (kvm_riscv_nacl_autoswap_csr_available()) {
+			hcntx->hstatus =
+				nacl_csr_read(nsh, CSR_HSTATUS);
+			nacl_scratch_write_long(nsh,
+						SBI_NACL_SHMEM_AUTOSWAP_OFFSET +
+						SBI_NACL_SHMEM_AUTOSWAP_HSTATUS,
+						gcntx->hstatus);
+			nacl_scratch_write_long(nsh,
+						SBI_NACL_SHMEM_AUTOSWAP_OFFSET,
+						SBI_NACL_SHMEM_AUTOSWAP_FLAG_HSTATUS);
+		} else if (kvm_riscv_nacl_sync_csr_available()) {
+			hcntx->hstatus = nacl_csr_swap(nsh,
+						       CSR_HSTATUS, gcntx->hstatus);
+		} else {
+			hcntx->hstatus = csr_swap(CSR_HSTATUS, gcntx->hstatus);
+		}
 
-	__kvm_riscv_switch_to(&vcpu->arch);
+		nacl_scratch_write_longs(nsh,
+					 SBI_NACL_SHMEM_SRET_OFFSET +
+					 SBI_NACL_SHMEM_SRET_X(1),
+					 &gcntx->ra,
+					 SBI_NACL_SHMEM_SRET_X_LAST);
+
+		__kvm_riscv_nacl_switch_to(&vcpu->arch, SBI_EXT_NACL,
+					   SBI_EXT_NACL_SYNC_SRET);
+
+		if (kvm_riscv_nacl_autoswap_csr_available()) {
+			nacl_scratch_write_long(nsh,
+						SBI_NACL_SHMEM_AUTOSWAP_OFFSET,
+						0);
+			gcntx->hstatus = nacl_scratch_read_long(nsh,
+								SBI_NACL_SHMEM_AUTOSWAP_OFFSET +
+								SBI_NACL_SHMEM_AUTOSWAP_HSTATUS);
+		} else {
+			gcntx->hstatus = csr_swap(CSR_HSTATUS, hcntx->hstatus);
+		}
+	} else {
+		hcntx->hstatus = csr_swap(CSR_HSTATUS, gcntx->hstatus);
 
-	gcntx->hstatus = csr_swap(CSR_HSTATUS, hcntx->hstatus);
+		__kvm_riscv_switch_to(&vcpu->arch);
+
+		gcntx->hstatus = csr_swap(CSR_HSTATUS, hcntx->hstatus);
+	}
 
 	vcpu->arch.last_exit_cpu = vcpu->cpu;
 	guest_state_exit_irqoff();
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
index 9f13e5ce6a18..47686bcb21e0 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -218,6 +218,35 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	ret
 SYM_FUNC_END(__kvm_riscv_switch_to)
 
+	/*
+	 * Parameters:
+	 * A0 <= Pointer to struct kvm_vcpu_arch
+	 * A1 <= SBI extension ID
+	 * A2 <= SBI function ID
+	 */
+SYM_FUNC_START(__kvm_riscv_nacl_switch_to)
+	SAVE_HOST_GPRS
+
+	SAVE_HOST_AND_RESTORE_GUEST_CSRS .Lkvm_nacl_switch_return
+
+	/* Resume Guest using SBI nested acceleration */
+	add	a6, a2, zero
+	add	a7, a1, zero
+	ecall
+
+	/* Back to Host */
+	.align 2
+.Lkvm_nacl_switch_return:
+	SAVE_GUEST_GPRS
+
+	SAVE_GUEST_AND_RESTORE_HOST_CSRS
+
+	RESTORE_HOST_GPRS
+
+	/* Return to C code */
+	ret
+SYM_FUNC_END(__kvm_riscv_nacl_switch_to)
+
 SYM_CODE_START(__kvm_riscv_unpriv_trap)
 	/*
 	 * We assume that faulting unpriv load/store instruction is
-- 
2.34.1


