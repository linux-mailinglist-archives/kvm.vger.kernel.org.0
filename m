Return-Path: <kvm+bounces-9879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF418678D3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:41:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9D671F2C095
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97B312BEBF;
	Mon, 26 Feb 2024 14:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UjjzPkEZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CE812B159;
	Mon, 26 Feb 2024 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958135; cv=none; b=PZ2FnLFzRAyGEvlNY7qrxpEBF+RBMJlyxKkjZxSG25syI2gDzakoJrvoK4ROVmd5sCYclDUIQqouELZB7IXyLoscSWZxdfblzKYdQPfuTF1rUTGJNT88RrcTh7BwcNjE/ow7UYP2TtQwyMRmb3DXaJhN9/jMn8TgU2Kyqy45OQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958135; c=relaxed/simple;
	bh=xauN1X+DnKCvc9vbegp66abdsujgHus+chSqx8LSMo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cU+yo7csTPoIREC1np41RTCOTZR+Fv1k/XyjvfRvxysaW0L7oK0C87yUhdk6xx4yyrJIdbyMoMHT8UAuICb3+8eSS581bmQixMZpY4a8gz4qITz+NDcX2jstWNsRGKpMBJ/MpgLpIdgZyrq+JZkImHyXYiPvErh3ffbzluWL5VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UjjzPkEZ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e4f45d4369so744848b3a.0;
        Mon, 26 Feb 2024 06:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958132; x=1709562932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yD1HeaqObCXgnz+2gI2K/L5qfqtKYhGCecQdpxW3XxA=;
        b=UjjzPkEZq9hMSxPU1ddaV6LPXmnsD/2oza3L93R38tcG5l5ZCmEqlvmg2lmw4FZlab
         6hR4McxIk9YVMn3QlXzgA6sDcImysA/J1NLBc38GqFoXncvFUdeW7BqIjUoqhBOgN9Gs
         YhlHGg84/uJugoFui63Wd7emeInHMw3ZyWEF5CiCosG3S0Rlo+GhqQAwfHSbVpxmu6Jl
         i0cnno9OmcIqjMJpr9Nb71/EAFjt4LAZCXboVdUQ1rboxSSNgQuY7ufLzF8bUKF50pd7
         M4S9rHYP2fitES7qyxByR2ZGmm02nPEAFt+FPefDjtw4i2KV1aeRhK4K8aQ7rWulwN/f
         F+FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958132; x=1709562932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yD1HeaqObCXgnz+2gI2K/L5qfqtKYhGCecQdpxW3XxA=;
        b=PKW1Ic7ZwP1GRgYAWXWTxbcKaC0vFPBT3TE7n+fK9V/IycSuEWz/4sNssg/5HBcrnc
         pnSG9dJI7/fXBDMfzFnR7fKdh3yixB7WkUcVK9L9cIZ53QYjIFo38nc+IXiIczkA6Evw
         MOCjSZ7pENIUNFPNvtLIiLAK/a9XivFXWHUhseYhUhzzViZBigJBaE+W+zlKLeG+e661
         i7QF2sbKfLt/EkPJVv7DWQgXgc0OqgUGPUeZr5fyrHBnNbAsoqDuxhMqAQ43y3Lu4ODV
         rgmBp6bOVRTGK6TyMj+KO8bRcdII9fdpFr0kRbB/nHyzlzvCWJx2ABPHDrNwQFfLrR1v
         luuA==
X-Forwarded-Encrypted: i=1; AJvYcCWuzPk/ImF+zkITTrSFyyLTC03Y6ttkLARUh6zb8Z3dbi0S3pjLzQTaZuYhLSZmFE1+kjgzOiKvJ5j0KulIaKmZQJ85
X-Gm-Message-State: AOJu0Yx9sEtfuTyuNqEGkUAScjVzs/gRwy0oVr5yVHLMpOH1/9i20Xma
	HQsmfgBw4O5rUHEGinRUVyDR1Qayrp/GfnxU0mnQCNMuor94LDeanQLki4iJ
X-Google-Smtp-Source: AGHT+IH8QenAPT1BN1EhFBpA+vGG63V6RRQrHdNvIxBeli/0imj6TysqynunDG5ZYc7ZTHjKGHqkmg==
X-Received: by 2002:a05:6a00:3c86:b0:6e1:3cdb:76f1 with SMTP id lm6-20020a056a003c8600b006e13cdb76f1mr9954405pfb.20.1708958130791;
        Mon, 26 Feb 2024 06:35:30 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id bn20-20020a056a00325400b006e2301e702fsm4138353pfb.125.2024.02.26.06.35.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:30 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 16/73] KVM: x86/PVM: Implement host mmu initialization
Date: Mon, 26 Feb 2024 22:35:33 +0800
Message-Id: <20240226143630.33643-17-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

For PVM, it utilizes shadow paging as MMU virtualization for the guest.
As the switcher supports guest/host world switches, the host kernel
mapping should be cloned into the guest shadow paging table, similar to
PTI. For simplicity, only the PGD level is cloned. Additionally, the
guest Linux kernel runs in high address space, so PVM will reserve a
kernel virtual area in the host vmalloc area for the guest, also at the
PGD level.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/Makefile       |   2 +-
 arch/x86/kvm/pvm/host_mmu.c | 119 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h      |  23 +++++++
 3 files changed, 143 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/pvm/host_mmu.c
 create mode 100644 arch/x86/kvm/pvm/pvm.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 036458a27d5e..706ccf3eca45 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -33,7 +33,7 @@ ifdef CONFIG_HYPERV
 kvm-amd-y		+= svm/svm_onhyperv.o
 endif
 
-kvm-pvm-y 		+= pvm/pvm.o
+kvm-pvm-y 		+= pvm/pvm.o pvm/host_mmu.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
 obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
diff --git a/arch/x86/kvm/pvm/host_mmu.c b/arch/x86/kvm/pvm/host_mmu.c
new file mode 100644
index 000000000000..35e97f4f7055
--- /dev/null
+++ b/arch/x86/kvm/pvm/host_mmu.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * PVM host mmu implementation
+ *
+ * Copyright (C) 2020 Ant Group
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/vmalloc.h>
+
+#include <asm/cpufeature.h>
+#include <asm/vsyscall.h>
+#include <asm/pgtable.h>
+
+#include "mmu.h"
+#include "mmu/spte.h"
+#include "pvm.h"
+
+static struct vm_struct *pvm_va_range_l4;
+
+u32 pml4_index_start;
+u32 pml4_index_end;
+u32 pml5_index_start;
+u32 pml5_index_end;
+
+static int __init guest_address_space_init(void)
+{
+	if (IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
+		pr_warn("CONFIG_KASAN_VMALLOC is not compatible with PVM");
+		return -1;
+	}
+
+	pvm_va_range_l4 = get_vm_area_align(DEFAULT_RANGE_L4_SIZE, PT_L4_SIZE,
+			  VM_ALLOC|VM_NO_GUARD);
+	if (!pvm_va_range_l4)
+		return -1;
+
+	pml4_index_start = __PT_INDEX((u64)pvm_va_range_l4->addr, 4, 9);
+	pml4_index_end = __PT_INDEX((u64)pvm_va_range_l4->addr + (u64)pvm_va_range_l4->size, 4, 9);
+	pml5_index_start = 0x1ff;
+	pml5_index_end = 0x1ff;
+	return 0;
+}
+
+static __init void clone_host_mmu(u64 *spt, u64 *host, int index_start, int index_end)
+{
+	int i;
+
+	for (i = PTRS_PER_PGD/2; i < PTRS_PER_PGD; i++) {
+		/* clone only the range that doesn't belong to guest */
+		if (i >= index_start && i < index_end)
+			continue;
+
+		/* remove userbit from host mmu, which also disable VSYSCALL page */
+		spt[i] = host[i] & ~(_PAGE_USER | SPTE_MMU_PRESENT_MASK);
+	}
+}
+
+u64 *host_mmu_root_pgd;
+u64 *host_mmu_la57_top_p4d;
+
+int __init host_mmu_init(void)
+{
+	u64 *host_pgd;
+
+	if (guest_address_space_init() < 0)
+		return -ENOMEM;
+
+	if (!boot_cpu_has(X86_FEATURE_PTI))
+		host_pgd = (void *)current->mm->pgd;
+	else
+		host_pgd = (void *)kernel_to_user_pgdp(current->mm->pgd);
+
+	host_mmu_root_pgd = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+
+	if (!host_mmu_root_pgd) {
+		host_mmu_destroy();
+		return -ENOMEM;
+	}
+	if (pgtable_l5_enabled()) {
+		host_mmu_la57_top_p4d = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		if (!host_mmu_la57_top_p4d) {
+			host_mmu_destroy();
+			return -ENOMEM;
+		}
+
+		clone_host_mmu(host_mmu_root_pgd, host_pgd, pml5_index_start, pml5_index_end);
+		clone_host_mmu(host_mmu_la57_top_p4d, __va(host_pgd[511] & SPTE_BASE_ADDR_MASK),
+				pml4_index_start, pml4_index_end);
+	} else {
+		clone_host_mmu(host_mmu_root_pgd, host_pgd, pml4_index_start, pml4_index_end);
+	}
+
+	if (pgtable_l5_enabled()) {
+		pr_warn("Supporting for LA57 host is not fully implemented yet.\n");
+		host_mmu_destroy();
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+void host_mmu_destroy(void)
+{
+	if (pvm_va_range_l4)
+		free_vm_area(pvm_va_range_l4);
+	if (host_mmu_root_pgd)
+		free_page((unsigned long)(void *)host_mmu_root_pgd);
+	if (host_mmu_la57_top_p4d)
+		free_page((unsigned long)(void *)host_mmu_la57_top_p4d);
+	pvm_va_range_l4 = NULL;
+	host_mmu_root_pgd = NULL;
+	host_mmu_la57_top_p4d = NULL;
+}
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
new file mode 100644
index 000000000000..7a3732986a6d
--- /dev/null
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_PVM_H
+#define __KVM_X86_PVM_H
+
+#define PT_L4_SHIFT		39
+#define PT_L4_SIZE		(1UL << PT_L4_SHIFT)
+#define DEFAULT_RANGE_L4_SIZE	(32 * PT_L4_SIZE)
+
+#define PT_L5_SHIFT		48
+#define PT_L5_SIZE		(1UL << PT_L5_SHIFT)
+#define DEFAULT_RANGE_L5_SIZE	(32 * PT_L5_SIZE)
+
+extern u32 pml4_index_start;
+extern u32 pml4_index_end;
+extern u32 pml5_index_start;
+extern u32 pml5_index_end;
+
+extern u64 *host_mmu_root_pgd;
+
+void host_mmu_destroy(void);
+int host_mmu_init(void);
+
+#endif /* __KVM_X86_PVM_H */
-- 
2.19.1.6.gb485710b


