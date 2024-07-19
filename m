Return-Path: <kvm+bounces-21941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 376CB937A6A
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E05332829EA
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BD8146A8D;
	Fri, 19 Jul 2024 16:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LK6tZVK4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D641465B7
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721405374; cv=none; b=l24EZk9zbjPK3Wo+HTzQyMsvOCnTPZ7MLO2o+qD7rotFeSWNOPiL5/l9JarC/xraRkBjZLrcXK+wMXgowoCqUrz4wEqV+x8oR26ybISVNR+wtVU0JBguRTxCFp3sCpbFYAq7WnRFk6VmRObETmcJsuOCqt7zSwkXxZ8hfh8mwIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721405374; c=relaxed/simple;
	bh=N9pX7Hk8PqZtQMvnahaNMPemieT0f6nEInc/thREa5M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LDCjPtn4CgSXRB4wRnmch8jAGt2zkG8/BHL0qcMWK3OZ3Y167W3QIcRDJmQkeINx3XCJlT7ncw515FbPcQd/c3Ny8/BjVbfgTXHv4EFHqTqs1bBpx+jSZ2WVH66AySB2kxQbRJITgx7T0JYV5Bg8a6eRcBrNHI3yML11xXFqeWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LK6tZVK4; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fc6a017abdso12508775ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 09:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721405372; x=1722010172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGcYsUF3DJYRqNt/bHhanbow+t8gedh1ONp0/95fX0k=;
        b=LK6tZVK4HER7S6rfYrHJ5PIDuMTpqDA0GkGWW4QMn2HLafpRuCgFmJnD1EAU72MwBL
         g+JhS3e7naJxDlufXJV/yrM5Rxa7YeddZJPYpLVpvMEivUkI/+Zae9F7o46NrlOaZ5Jw
         V5jfrV8s/1vKSq4HCzooWQnBtOlNbt7nFm2YZJKOPMVt2HofTKWpDs5C0xw+4gXnU8gD
         iqq5xGc0+RxvNRe4VFcppVDESdIfHuD7+k6/apOguC14sHxRR7sWgi1VlDnSt4Fe52F/
         IjBx5DQyb3Wcw/1HikEGDmsGCg89On3HHNKo3kGJuYbnEM08t0qukMl2tIVx/jAKnCNf
         BaOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721405372; x=1722010172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OGcYsUF3DJYRqNt/bHhanbow+t8gedh1ONp0/95fX0k=;
        b=GtpXsdQQ7UB78nkyPtJseayvylzNUwbzqkLZY6LkLV3L1irr4RFK1U0OMydEhn9FfF
         R123JQWpFhd7cxfnrJm98HZ2iktwvuFU5l4xj8gCB134xdSx8bk+JdXHmJfI/baBxARU
         LsvWA9GEXElrBa0HU/e1b1Rwdj9ai+XqFrkIn4iPtMFtVMlVE8zOyq20g2jPtAw0vUFR
         AOkzYTGbWpktQ0vdlsNOtwXSJ5jvTfZgAPRHC3b4JRfvc2uClyqBygQmbAptzOJQDk9j
         Vu9EGx54cABHR2mTYO0Gb0IPL91GoMlrWbu3FmMI3K12A+n5Soecfmq2/eUYjrFK88C3
         XaAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqbEgEGoDfn+QzIsWpsS6zRuMwxx8MWpjrlymZNa+rs5caJJO/rEyKe5UIEN+yqxa//MSsLCyzmZE2YIXasZl3QX5v
X-Gm-Message-State: AOJu0YyVZ0yFUJO2NZ19duWf9FJH4tUlNq9cDtdsobzABueGiVgCDZ9y
	uHdGTUHgZyUgVuFSwhSw3u9afeKiReuB2WywLS00J8iZjtzyH3f+mns2wlXT4JY=
X-Google-Smtp-Source: AGHT+IGPjT8nh2ANsFn3KOth35OvyCH2HUqbnWMJwIQKneQhkQKr1OrfOoTIE7geur0pJijTHCcRbQ==
X-Received: by 2002:a17:903:234a:b0:1f9:f3c6:ed37 with SMTP id d9443c01a7336-1fd74597a55mr4348925ad.14.1721405371674;
        Fri, 19 Jul 2024 09:09:31 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f28f518sm6632615ad.69.2024.07.19.09.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 09:09:31 -0700 (PDT)
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
Subject: [PATCH 02/13] RISC-V: KVM: Save/restore HSTATUS in C source
Date: Fri, 19 Jul 2024 21:39:02 +0530
Message-Id: <20240719160913.342027-3-apatel@ventanamicro.com>
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

We will be optimizing HSTATUS CSR access via shared memory setup
using the SBI nested acceleration extension. To facilitate this,
we first move HSTATUS save/restore in kvm_riscv_vcpu_enter_exit().

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu.c        |  9 +++++++++
 arch/riscv/kvm/vcpu_switch.S | 36 +++++++++++++-----------------------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 449e5bb948c2..93b1ce043482 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -720,9 +720,18 @@ static __always_inline void kvm_riscv_vcpu_swap_in_host_state(struct kvm_vcpu *v
  */
 static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *gcntx = &vcpu->arch.guest_context;
+	struct kvm_cpu_context *hcntx = &vcpu->arch.host_context;
+
 	kvm_riscv_vcpu_swap_in_guest_state(vcpu);
 	guest_state_enter_irqoff();
+
+	hcntx->hstatus = csr_swap(CSR_HSTATUS, gcntx->hstatus);
+
 	__kvm_riscv_switch_to(&vcpu->arch);
+
+	gcntx->hstatus = csr_swap(CSR_HSTATUS, hcntx->hstatus);
+
 	vcpu->arch.last_exit_cpu = vcpu->cpu;
 	guest_state_exit_irqoff();
 	kvm_riscv_vcpu_swap_in_host_state(vcpu);
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
index 0c26189aa01c..f83643c4fdb9 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -43,35 +43,30 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 
 	/* Load Guest CSR values */
 	REG_L	t0, (KVM_ARCH_GUEST_SSTATUS)(a0)
-	REG_L	t1, (KVM_ARCH_GUEST_HSTATUS)(a0)
-	REG_L	t2, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
-	la	t4, .Lkvm_switch_return
-	REG_L	t5, (KVM_ARCH_GUEST_SEPC)(a0)
+	REG_L	t1, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
+	la	t3, .Lkvm_switch_return
+	REG_L	t4, (KVM_ARCH_GUEST_SEPC)(a0)
 
 	/* Save Host and Restore Guest SSTATUS */
 	csrrw	t0, CSR_SSTATUS, t0
 
-	/* Save Host and Restore Guest HSTATUS */
-	csrrw	t1, CSR_HSTATUS, t1
-
 	/* Save Host and Restore Guest SCOUNTEREN */
-	csrrw	t2, CSR_SCOUNTEREN, t2
+	csrrw	t1, CSR_SCOUNTEREN, t1
 
 	/* Save Host STVEC and change it to return path */
-	csrrw	t4, CSR_STVEC, t4
+	csrrw	t3, CSR_STVEC, t3
 
 	/* Save Host SSCRATCH and change it to struct kvm_vcpu_arch pointer */
-	csrrw	t3, CSR_SSCRATCH, a0
+	csrrw	t2, CSR_SSCRATCH, a0
 
 	/* Restore Guest SEPC */
-	csrw	CSR_SEPC, t5
+	csrw	CSR_SEPC, t4
 
 	/* Store Host CSR values */
 	REG_S	t0, (KVM_ARCH_HOST_SSTATUS)(a0)
-	REG_S	t1, (KVM_ARCH_HOST_HSTATUS)(a0)
-	REG_S	t2, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
-	REG_S	t3, (KVM_ARCH_HOST_SSCRATCH)(a0)
-	REG_S	t4, (KVM_ARCH_HOST_STVEC)(a0)
+	REG_S	t1, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
+	REG_S	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
+	REG_S	t3, (KVM_ARCH_HOST_STVEC)(a0)
 
 	/* Restore Guest GPRs (except A0) */
 	REG_L	ra, (KVM_ARCH_GUEST_RA)(a0)
@@ -153,8 +148,7 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	REG_L	t1, (KVM_ARCH_HOST_STVEC)(a0)
 	REG_L	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
 	REG_L	t3, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
-	REG_L	t4, (KVM_ARCH_HOST_HSTATUS)(a0)
-	REG_L	t5, (KVM_ARCH_HOST_SSTATUS)(a0)
+	REG_L	t4, (KVM_ARCH_HOST_SSTATUS)(a0)
 
 	/* Save Guest SEPC */
 	csrr	t0, CSR_SEPC
@@ -168,18 +162,14 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	/* Save Guest and Restore Host SCOUNTEREN */
 	csrrw	t3, CSR_SCOUNTEREN, t3
 
-	/* Save Guest and Restore Host HSTATUS */
-	csrrw	t4, CSR_HSTATUS, t4
-
 	/* Save Guest and Restore Host SSTATUS */
-	csrrw	t5, CSR_SSTATUS, t5
+	csrrw	t4, CSR_SSTATUS, t4
 
 	/* Store Guest CSR values */
 	REG_S	t0, (KVM_ARCH_GUEST_SEPC)(a0)
 	REG_S	t2, (KVM_ARCH_GUEST_A0)(a0)
 	REG_S	t3, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
-	REG_S	t4, (KVM_ARCH_GUEST_HSTATUS)(a0)
-	REG_S	t5, (KVM_ARCH_GUEST_SSTATUS)(a0)
+	REG_S	t4, (KVM_ARCH_GUEST_SSTATUS)(a0)
 
 	/* Restore Host GPRs (except A0 and T0-T6) */
 	REG_L	ra, (KVM_ARCH_HOST_RA)(a0)
-- 
2.34.1


