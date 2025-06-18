Return-Path: <kvm+bounces-49856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D40AFADEA6E
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EDC3401972
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A085D2E8DF6;
	Wed, 18 Jun 2025 11:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="a5SNmXew"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073132E719A
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246587; cv=none; b=oH8ubpYi5AOdqxoToniIIRykBjGUwuPbYEDiV9OgVpvPoYfzdSCDWB9qzIstgzAB0FsW+O0J5TzUjkNmj9t5JPcJVjBYaDRY3oqgpGJjdLZuYmhAC/e8ehvW51/RBLBcnu0ly+FBJcAVUxxLMuCVvXgxtV+Db/2BcRsfsPniD9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246587; c=relaxed/simple;
	bh=2d2hcsyTQ0lvEdoc6WWyvYcrM8xIbbbNagydej5vg1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGaMpZ4CZNGx1bJkpEVvGFOCOtOQxYbrgB5UpSaCWIy7kaAUxk3JkXtn2wEBORrK7v0KN2ZP79GAa/e884bTIz/kxEC4KGMGH/3TKhIS0oH6XjfyFFjC5E4ftivF90+Wcj2Nvl2MdSucUOkPoyLdhZGAaWxaRzKRF6Vorsf0vmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=a5SNmXew; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2350b1b9129so48521435ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750246585; x=1750851385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XG7/Ztl2DSM9ZPCCvmv6w8e8h4Eb1mPFR7YIhnXta3M=;
        b=a5SNmXewmuqRe4Ro0/JLEWOq8DlFikbtaMIs8v5IkyHb+n2yX5GPCVFjlXJ+YPzZje
         WqEfkESFEMfIyxplhMAUhV24cFvtEnxwqbpd0gUy4Pw2xAROgm/xHHnr24HpIx9oTR8F
         loR5r1XVU4jGChT50BZAhOstjrf622weIi9Xx82SG8AxDSa2de8LOGolhL/74II6OWsK
         XjUp25m/41n4623XKcWbk9uY8jIzXLR/1giMrjih7QIq6Kmv/wQfLCP3RjzJ/2Z7o0NH
         sLUFQDejrTTLPUoD6hdxouKKvLF1oVGaYcCPr1aC8TybbCQu56p4Mh8/wOBZCP+ijEVd
         wtJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246585; x=1750851385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XG7/Ztl2DSM9ZPCCvmv6w8e8h4Eb1mPFR7YIhnXta3M=;
        b=QFVp8O7MAasCs/oS+JqI3RYba/ttp0hX4DrSxcWaylmqdYX0SFpRNl0Pm5TEAclglB
         nVYHBWwVGY/OIt9x19iCzGH3j/4ovkKDEhCKdVGLBiLAdxFZdX6wuUTEHolsMWGCs00+
         blW05iP70JKQVJg5yYunxslXTIqYRUQnSl888ejZUa6an/ZvLh6J0czhwYRarYl6CDdb
         sNK2m5EpK3pIdpRhEpgFsOWcg+7r4YDz6H01FRV98r1LT3dtIndKqiFEe1o1n09xe6dV
         Dg05URGmtDXSGHxdnVyhcBZbuIQHlO5wrexwnv8YcF1rlI13vx/xlm3JizhQu3fwcp9w
         jIIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWftbl6NPIMO4lLWIKHrVxW3xOj8sSElokZ2/gMGTkFJQvJ2wN18lcSMxqyEPUlT6QuNZI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6LVoxeL0lt3B2Wi0lJKE7Lnt8SC8pg4hhYdM8tcPDAb65djxc
	mTSProqZ/6ps7JECR0Ked6VDE7Uu5aB04nDqkZqc8lx6T/u5w9A5/ltR/rq36M3EKKI=
X-Gm-Gg: ASbGnctFYGRsfpvVMRylCITG/J8GmcPc7R85IeTKEcDoKmvgUbxDNhQ5u7Q5XgMvKSh
	633V/An2IFto42Htxd9pnVlyI98Lhdw/SdkT0mvbb25mgWoZHo/sYtvTmSXtpLGsGT7FIAkkcUs
	yxBXCgZS2hNcLGf6tZ+kAOTNaNAf6Gl02KCgQNXudIGySHMsbiNeV8FM6aIl+UWguvXDela9JFG
	gcvfCQ/vgopdaqWLDLbUQ5ccwHOSkVupPai2tI3IIJ2pKu85rJbA7XtivQOgIbv2ONTnYXx5pJf
	JKPATKQ1rS8kaNWEGMW7oBOQmV3Hkr9pi13VHOdUkRarsfIUzt76csVhIle0KgeuqN0HjOaRarb
	4BlgKBSx4tcDiX/Mo4g==
X-Google-Smtp-Source: AGHT+IEN9kYbtX3MN80cXl6plnuIGLwCBL6Acv0xEEsexI78AVAHqncJpWj7BsS4zuj7DZwkxDeSFQ==
X-Received: by 2002:a17:903:32c9:b0:234:986c:66e0 with SMTP id d9443c01a7336-2366b32e4e0mr257201345ad.4.1750246585084;
        Wed, 18 Jun 2025 04:36:25 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237c57c63efsm9112475ad.172.2025.06.18.04.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:36:24 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v3 08/12] RISC-V: KVM: Factor-out MMU related declarations into separate headers
Date: Wed, 18 Jun 2025 17:05:28 +0530
Message-ID: <20250618113532.471448-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250618113532.471448-1-apatel@ventanamicro.com>
References: <20250618113532.471448-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MMU, TLB, and VMID management for KVM RISC-V already exists as
seprate sources so create separate headers along these lines. This
further simplifies asm/kvm_host.h header.

Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h | 100 +-----------------------------
 arch/riscv/include/asm/kvm_mmu.h  |  26 ++++++++
 arch/riscv/include/asm/kvm_tlb.h  |  78 +++++++++++++++++++++++
 arch/riscv/include/asm/kvm_vmid.h |  27 ++++++++
 arch/riscv/kvm/aia_imsic.c        |   1 +
 arch/riscv/kvm/main.c             |   1 +
 arch/riscv/kvm/mmu.c              |   1 +
 arch/riscv/kvm/tlb.c              |   2 +
 arch/riscv/kvm/vcpu.c             |   1 +
 arch/riscv/kvm/vcpu_exit.c        |   1 +
 arch/riscv/kvm/vm.c               |   1 +
 arch/riscv/kvm/vmid.c             |   2 +
 12 files changed, 143 insertions(+), 98 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_mmu.h
 create mode 100644 arch/riscv/include/asm/kvm_tlb.h
 create mode 100644 arch/riscv/include/asm/kvm_vmid.h

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 6162575e2177..bd5341efa127 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -16,6 +16,8 @@
 #include <asm/hwcap.h>
 #include <asm/kvm_aia.h>
 #include <asm/ptrace.h>
+#include <asm/kvm_tlb.h>
+#include <asm/kvm_vmid.h>
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_insn.h>
 #include <asm/kvm_vcpu_sbi.h>
@@ -56,24 +58,6 @@
 					 BIT(IRQ_VS_TIMER) | \
 					 BIT(IRQ_VS_EXT))
 
-enum kvm_riscv_hfence_type {
-	KVM_RISCV_HFENCE_UNKNOWN = 0,
-	KVM_RISCV_HFENCE_GVMA_VMID_GPA,
-	KVM_RISCV_HFENCE_VVMA_ASID_GVA,
-	KVM_RISCV_HFENCE_VVMA_ASID_ALL,
-	KVM_RISCV_HFENCE_VVMA_GVA,
-};
-
-struct kvm_riscv_hfence {
-	enum kvm_riscv_hfence_type type;
-	unsigned long asid;
-	unsigned long order;
-	gpa_t addr;
-	gpa_t size;
-};
-
-#define KVM_RISCV_VCPU_MAX_HFENCE	64
-
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 };
@@ -99,15 +83,6 @@ struct kvm_vcpu_stat {
 struct kvm_arch_memory_slot {
 };
 
-struct kvm_vmid {
-	/*
-	 * Writes to vmid_version and vmid happen with vmid_lock held
-	 * whereas reads happen without any lock held.
-	 */
-	unsigned long vmid_version;
-	unsigned long vmid;
-};
-
 struct kvm_arch {
 	/* G-stage vmid */
 	struct kvm_vmid vmid;
@@ -311,77 +286,6 @@ static inline bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
 	return IS_ENABLED(CONFIG_GUEST_PERF_EVENTS) && !!vcpu;
 }
 
-#define KVM_RISCV_GSTAGE_TLB_MIN_ORDER		12
-
-void kvm_riscv_local_hfence_gvma_vmid_gpa(unsigned long vmid,
-					  gpa_t gpa, gpa_t gpsz,
-					  unsigned long order);
-void kvm_riscv_local_hfence_gvma_vmid_all(unsigned long vmid);
-void kvm_riscv_local_hfence_gvma_gpa(gpa_t gpa, gpa_t gpsz,
-				     unsigned long order);
-void kvm_riscv_local_hfence_gvma_all(void);
-void kvm_riscv_local_hfence_vvma_asid_gva(unsigned long vmid,
-					  unsigned long asid,
-					  unsigned long gva,
-					  unsigned long gvsz,
-					  unsigned long order);
-void kvm_riscv_local_hfence_vvma_asid_all(unsigned long vmid,
-					  unsigned long asid);
-void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
-				     unsigned long gva, unsigned long gvsz,
-				     unsigned long order);
-void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
-
-void kvm_riscv_tlb_flush_process(struct kvm_vcpu *vcpu);
-
-void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
-void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
-void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu);
-
-void kvm_riscv_fence_i(struct kvm *kvm,
-		       unsigned long hbase, unsigned long hmask);
-void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
-				    unsigned long hbase, unsigned long hmask,
-				    gpa_t gpa, gpa_t gpsz,
-				    unsigned long order);
-void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
-				    unsigned long hbase, unsigned long hmask);
-void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
-				    unsigned long hbase, unsigned long hmask,
-				    unsigned long gva, unsigned long gvsz,
-				    unsigned long order, unsigned long asid);
-void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
-				    unsigned long hbase, unsigned long hmask,
-				    unsigned long asid);
-void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
-			       unsigned long hbase, unsigned long hmask,
-			       unsigned long gva, unsigned long gvsz,
-			       unsigned long order);
-void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
-			       unsigned long hbase, unsigned long hmask);
-
-int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
-			     phys_addr_t hpa, unsigned long size,
-			     bool writable, bool in_atomic);
-void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa,
-			      unsigned long size);
-int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
-			 struct kvm_memory_slot *memslot,
-			 gpa_t gpa, unsigned long hva, bool is_write);
-int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm);
-void kvm_riscv_gstage_free_pgd(struct kvm *kvm);
-void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu);
-void __init kvm_riscv_gstage_mode_detect(void);
-unsigned long __init kvm_riscv_gstage_mode(void);
-int kvm_riscv_gstage_gpa_bits(void);
-
-void __init kvm_riscv_gstage_vmid_detect(void);
-unsigned long kvm_riscv_gstage_vmid_bits(void);
-int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
-bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
-void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
-void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu);
-
 int kvm_riscv_setup_default_irq_routing(struct kvm *kvm, u32 lines);
 
 void __kvm_riscv_unpriv_trap(void);
diff --git a/arch/riscv/include/asm/kvm_mmu.h b/arch/riscv/include/asm/kvm_mmu.h
new file mode 100644
index 000000000000..4e1654282ee4
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_mmu.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025 Ventana Micro Systems Inc.
+ */
+
+#ifndef __RISCV_KVM_MMU_H_
+#define __RISCV_KVM_MMU_H_
+
+#include <linux/kvm_types.h>
+
+int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
+			     phys_addr_t hpa, unsigned long size,
+			     bool writable, bool in_atomic);
+void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa,
+			      unsigned long size);
+int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
+			 struct kvm_memory_slot *memslot,
+			 gpa_t gpa, unsigned long hva, bool is_write);
+int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm);
+void kvm_riscv_gstage_free_pgd(struct kvm *kvm);
+void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu);
+void kvm_riscv_gstage_mode_detect(void);
+unsigned long kvm_riscv_gstage_mode(void);
+int kvm_riscv_gstage_gpa_bits(void);
+
+#endif
diff --git a/arch/riscv/include/asm/kvm_tlb.h b/arch/riscv/include/asm/kvm_tlb.h
new file mode 100644
index 000000000000..cd00c9a46cb1
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_tlb.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025 Ventana Micro Systems Inc.
+ */
+
+#ifndef __RISCV_KVM_TLB_H_
+#define __RISCV_KVM_TLB_H_
+
+#include <linux/kvm_types.h>
+
+enum kvm_riscv_hfence_type {
+	KVM_RISCV_HFENCE_UNKNOWN = 0,
+	KVM_RISCV_HFENCE_GVMA_VMID_GPA,
+	KVM_RISCV_HFENCE_VVMA_ASID_GVA,
+	KVM_RISCV_HFENCE_VVMA_ASID_ALL,
+	KVM_RISCV_HFENCE_VVMA_GVA,
+};
+
+struct kvm_riscv_hfence {
+	enum kvm_riscv_hfence_type type;
+	unsigned long asid;
+	unsigned long order;
+	gpa_t addr;
+	gpa_t size;
+};
+
+#define KVM_RISCV_VCPU_MAX_HFENCE	64
+
+#define KVM_RISCV_GSTAGE_TLB_MIN_ORDER		12
+
+void kvm_riscv_local_hfence_gvma_vmid_gpa(unsigned long vmid,
+					  gpa_t gpa, gpa_t gpsz,
+					  unsigned long order);
+void kvm_riscv_local_hfence_gvma_vmid_all(unsigned long vmid);
+void kvm_riscv_local_hfence_gvma_gpa(gpa_t gpa, gpa_t gpsz,
+				     unsigned long order);
+void kvm_riscv_local_hfence_gvma_all(void);
+void kvm_riscv_local_hfence_vvma_asid_gva(unsigned long vmid,
+					  unsigned long asid,
+					  unsigned long gva,
+					  unsigned long gvsz,
+					  unsigned long order);
+void kvm_riscv_local_hfence_vvma_asid_all(unsigned long vmid,
+					  unsigned long asid);
+void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
+				     unsigned long gva, unsigned long gvsz,
+				     unsigned long order);
+void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
+
+void kvm_riscv_tlb_flush_process(struct kvm_vcpu *vcpu);
+
+void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
+void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
+void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu);
+
+void kvm_riscv_fence_i(struct kvm *kvm,
+		       unsigned long hbase, unsigned long hmask);
+void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
+				    unsigned long hbase, unsigned long hmask,
+				    gpa_t gpa, gpa_t gpsz,
+				    unsigned long order);
+void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
+				    unsigned long hbase, unsigned long hmask);
+void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
+				    unsigned long hbase, unsigned long hmask,
+				    unsigned long gva, unsigned long gvsz,
+				    unsigned long order, unsigned long asid);
+void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
+				    unsigned long hbase, unsigned long hmask,
+				    unsigned long asid);
+void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
+			       unsigned long hbase, unsigned long hmask,
+			       unsigned long gva, unsigned long gvsz,
+			       unsigned long order);
+void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
+			       unsigned long hbase, unsigned long hmask);
+
+#endif
diff --git a/arch/riscv/include/asm/kvm_vmid.h b/arch/riscv/include/asm/kvm_vmid.h
new file mode 100644
index 000000000000..ab98e1434fb7
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vmid.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025 Ventana Micro Systems Inc.
+ */
+
+#ifndef __RISCV_KVM_VMID_H_
+#define __RISCV_KVM_VMID_H_
+
+#include <linux/kvm_types.h>
+
+struct kvm_vmid {
+	/*
+	 * Writes to vmid_version and vmid happen with vmid_lock held
+	 * whereas reads happen without any lock held.
+	 */
+	unsigned long vmid_version;
+	unsigned long vmid;
+};
+
+void __init kvm_riscv_gstage_vmid_detect(void);
+unsigned long kvm_riscv_gstage_vmid_bits(void);
+int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
+bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
+void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
+void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu);
+
+#endif
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 29ef9c2133a9..40b469c0a01f 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -16,6 +16,7 @@
 #include <linux/swab.h>
 #include <kvm/iodev.h>
 #include <asm/csr.h>
+#include <asm/kvm_mmu.h>
 
 #define IMSIC_MAX_EIX	(IMSIC_MAX_ID / BITS_PER_TYPE(u64))
 
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 4b24705dc63a..b861a5dd7bd9 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/kvm_host.h>
 #include <asm/cpufeature.h>
+#include <asm/kvm_mmu.h>
 #include <asm/kvm_nacl.h>
 #include <asm/sbi.h>
 
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index a5387927a1c1..c1a3eb076df3 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -15,6 +15,7 @@
 #include <linux/vmalloc.h>
 #include <linux/kvm_host.h>
 #include <linux/sched/signal.h>
+#include <asm/kvm_mmu.h>
 #include <asm/kvm_nacl.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index f46a27658c2e..6fc4361c3d75 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -15,6 +15,8 @@
 #include <asm/cpufeature.h>
 #include <asm/insn-def.h>
 #include <asm/kvm_nacl.h>
+#include <asm/kvm_tlb.h>
+#include <asm/kvm_vmid.h>
 
 #define has_svinval()	riscv_has_extension_unlikely(RISCV_ISA_EXT_SVINVAL)
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 6eb11c913b13..8ad7b31f5939 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -18,6 +18,7 @@
 #include <linux/fs.h>
 #include <linux/kvm_host.h>
 #include <asm/cacheflush.h>
+#include <asm/kvm_mmu.h>
 #include <asm/kvm_nacl.h>
 #include <asm/kvm_vcpu_vector.h>
 
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 85c43c83e3b9..965df528de90 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -9,6 +9,7 @@
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
 #include <asm/insn-def.h>
+#include <asm/kvm_mmu.h>
 #include <asm/kvm_nacl.h>
 
 static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index b27ec8f96697..8601cf29e5f8 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <linux/kvm_host.h>
+#include <asm/kvm_mmu.h>
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS()
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 92c01255f86f..3b426c800480 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -14,6 +14,8 @@
 #include <linux/smp.h>
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
+#include <asm/kvm_tlb.h>
+#include <asm/kvm_vmid.h>
 
 static unsigned long vmid_version = 1;
 static unsigned long vmid_next;
-- 
2.43.0


