Return-Path: <kvm+bounces-9917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B4AD867932
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:57:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E8E7292F98
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2AE12EBDE;
	Mon, 26 Feb 2024 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gv8zeCts"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA351474AE;
	Mon, 26 Feb 2024 14:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958275; cv=none; b=H59LIbYReXOOxZa6CFfa06vs1eTCeykqPBnGjd3MqVJIxxtnzkY96gUuDAukmAQE44EKlIPTnM/np5zthZrD3CFObrSjrMPWEuZ8uqfEizI5yiggziB64iTuDcwbU4Qltn8KVfxy5jVTDKqQVHIHZhOVZqWeKXITqn3eYokwKVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958275; c=relaxed/simple;
	bh=iF+u/pfN6Z+LC5rl3PmX0bCf9rpWWKCNx9V96EJqjYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RQ39hGtv5Zmz+kpM3jUuwRGUFmRnbyPNBMr/kc2DVcobHFIwnamzWfaArshQkWzMqsmOB788WVa2Z6KrBHNJuhOCXuN//gdgYtZbJmXHMaKSwWXP96aSsOzeT7YdWd308B58ef8i19kfQpfppBSjqokgYq9oXmc3Fq4PU100VJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gv8zeCts; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5a04fb5e689so1598809eaf.1;
        Mon, 26 Feb 2024 06:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958273; x=1709563073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3F50O3ylG3ZskDRT0xmw8UdB0U5PMTg1O+LfmHJzgw=;
        b=gv8zeCtsq2M6LddJ3hVu/JOGKJ76Kd5zhChWtb4fjuvoBJhaCx1wk4RBLhnrA4oTQE
         ub1DP4v3QfGcDpBRxkLjCalAsEqB+mKaKKHCfvCZVdgnSH4oPkdB46LwKM9gHFBgblqL
         CO5xQ0BlyRyqyYR5jKnU8a9ZsahFPUMASPgt6Rx9KkK2jJTOTJ5TXkWyzVwCKoOP8172
         ocxbVBPn6YqboT0femcO67wZw8m9szL8ppw9oq7Sf4NH8pMk2LAXKL4yE//nS95Dvxsp
         j4MqOO62Rw+wNNRm6Ksr1a/ZF9xBpf3AZhUtrGeDO8f3eWCFNZs1TjUjj281ubX0RkY/
         Yu2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958273; x=1709563073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j3F50O3ylG3ZskDRT0xmw8UdB0U5PMTg1O+LfmHJzgw=;
        b=KNn7mBOGnn5nFQ7smH1HBQqotAJy1b4kxLrwPzlA/WhEmpWqJM1hr88cFgEs97xaCY
         YHxBxSMppMjuRdDwOcGk8uMumKdEeB4oJD0Zi7W21xiUifZ5o++u4Ztni35sFg3zw4lm
         jJCc3YIuiN5f9WQSE0NCKximHNereuGvGPmHUmg/V4ZvA76tyeEBC/ApcSAyNMchV4Cw
         c4i/fdIwZbTcFtCEANkSW58a5/lfg14itKJa+qgbogzlYvpysjKodGHtzD1R7uMQFzyC
         Qu/71ymSqBQ18y/TViJXivnufOitfmxwPxdrjEJSRA+LUc06km+wCFJ+hntD61Gm7Vme
         gKag==
X-Forwarded-Encrypted: i=1; AJvYcCWAx0aVb+lDrGMiWVV0SkjGrDzHBxXpXtxMwrgBOrjmpPgCTTaPbemBe+xD4ha5RI+aBEPGMcP9+O6sMZRR8NtXyWG2
X-Gm-Message-State: AOJu0YxdSR73sgIU2uKzi72ZoEbnyFpwLXEXujMkmoimUh2rBkGMbLFj
	BZ5QX43iXMxHBj05hWERQi9RmJTYpCKEFEEqrNeM2JDZG6XgUje12AO9VgQC
X-Google-Smtp-Source: AGHT+IFPVhu8MaUL4U9TiSoKfpjFwi5MzWPuMosqmec6SO4g8BFH6Kp+bCxObLQ7ckCBnTySm25wpA==
X-Received: by 2002:a05:6358:286:b0:17a:f91c:825b with SMTP id w6-20020a056358028600b0017af91c825bmr8812523rwj.5.1708958273041;
        Mon, 26 Feb 2024 06:37:53 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id v4-20020aa78504000000b006e4e557346esm4114190pfn.28.2024.02.26.06.37.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:37:52 -0800 (PST)
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
	"H. Peter Anvin" <hpa@zytor.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Pengfei Xu <pengfei.xu@intel.com>,
	Ze Gao <zegao2021@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [RFC PATCH 54/73] x86/pvm: Detect PVM hypervisor support
Date: Mon, 26 Feb 2024 22:36:11 +0800
Message-Id: <20240226143630.33643-55-jiangshanlai@gmail.com>
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

Detect PVM hypervisor support through the use of the PVM synthetic
instruction 'PVM_SYNTHETIC_CPUID'. This is a necessary step in preparing
to initialize the PVM guest during booting.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/include/asm/pvm_para.h | 69 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/Makefile        |  1 +
 arch/x86/kernel/pvm.c           | 22 +++++++++++
 3 files changed, 92 insertions(+)
 create mode 100644 arch/x86/include/asm/pvm_para.h
 create mode 100644 arch/x86/kernel/pvm.c

diff --git a/arch/x86/include/asm/pvm_para.h b/arch/x86/include/asm/pvm_para.h
new file mode 100644
index 000000000000..efd7afdf9be9
--- /dev/null
+++ b/arch/x86/include/asm/pvm_para.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_PVM_PARA_H
+#define _ASM_X86_PVM_PARA_H
+
+#include <linux/init.h>
+#include <uapi/asm/pvm_para.h>
+
+#ifdef CONFIG_PVM_GUEST
+#include <asm/irqflags.h>
+#include <uapi/asm/kvm_para.h>
+
+void __init pvm_early_setup(void);
+
+static inline void pvm_cpuid(unsigned int *eax, unsigned int *ebx,
+			     unsigned int *ecx, unsigned int *edx)
+{
+	asm(__ASM_FORM(.byte PVM_SYNTHETIC_CPUID ;)
+		: "=a" (*eax),
+		  "=b" (*ebx),
+		  "=c" (*ecx),
+		  "=d" (*edx)
+		: "0" (*eax), "2" (*ecx));
+}
+
+/*
+ * pvm_detect() is called before event handling is set up and it might be
+ * possibly called under any hypervisor other than PVM, so it should not
+ * trigger any trap in all possible scenarios. PVM_SYNTHETIC_CPUID is supposed
+ * to not trigger any trap in the real or virtual x86 kernel mode and is also
+ * guaranteed to trigger a trap in the underlying hardware user mode for the
+ * hypervisor emulating it.
+ */
+static inline bool pvm_detect(void)
+{
+	unsigned long cs;
+	uint32_t eax, signature[3];
+
+	/* check underlying interrupt flags */
+	if (arch_irqs_disabled_flags(native_save_fl()))
+		return false;
+
+	/* check underlying CS */
+	asm volatile("mov %%cs,%0\n\t" : "=r" (cs) : );
+	if ((cs & 3) != 3)
+		return false;
+
+	/* check KVM_SIGNATURE and KVM_CPUID_VENDOR_FEATURES */
+	eax = KVM_CPUID_SIGNATURE;
+	pvm_cpuid(&eax, &signature[0], &signature[1], &signature[2]);
+	if (memcmp(KVM_SIGNATURE, signature, 12))
+		return false;
+	if (eax < KVM_CPUID_VENDOR_FEATURES)
+		return false;
+
+	/* check PVM_CPUID_SIGNATURE */
+	eax = KVM_CPUID_VENDOR_FEATURES;
+	pvm_cpuid(&eax, &signature[0], &signature[1], &signature[2]);
+	if (signature[0] != PVM_CPUID_SIGNATURE)
+		return false;
+
+	return true;
+}
+#else
+static inline void pvm_early_setup(void)
+{
+}
+#endif /* CONFIG_PVM_GUEST */
+
+#endif /* _ASM_X86_PVM_PARA_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index dc1f5a303e9b..67f11f7d5c88 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -129,6 +129,7 @@ obj-$(CONFIG_AMD_NB)		+= amd_nb.o
 obj-$(CONFIG_DEBUG_NMI_SELFTEST) += nmi_selftest.o
 
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvmclock.o
+obj-$(CONFIG_PVM_GUEST)		+= pvm.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
new file mode 100644
index 000000000000..2d27044eaf25
--- /dev/null
+++ b/arch/x86/kernel/pvm.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KVM PVM paravirt_ops implementation
+ *
+ * Copyright (C) 2020 Ant Group
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+#define pr_fmt(fmt) "pvm-guest: " fmt
+
+#include <asm/cpufeature.h>
+#include <asm/pvm_para.h>
+
+void __init pvm_early_setup(void)
+{
+	if (!pvm_detect())
+		return;
+
+	setup_force_cpu_cap(X86_FEATURE_KVM_PVM_GUEST);
+}
-- 
2.19.1.6.gb485710b


