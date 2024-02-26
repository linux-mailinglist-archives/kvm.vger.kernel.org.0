Return-Path: <kvm+bounces-9877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9FE886790F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B5C6B2A3C8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49533130E24;
	Mon, 26 Feb 2024 14:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G1oT6GPZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF48130ADA;
	Mon, 26 Feb 2024 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958125; cv=none; b=JeLh5HVJyKICf5Pr5BjbxD1OVGDXl4ZSA5/hmS7uFX+4OV/zT5SdRC1GftLB5C/IT86urun7by4ToApdgcFM/lYm/9lvP6VQ+UzwwR/swPiCVxc3TZ/uNvAD30gMhqK+RA/0HE+3gOOmqY/zNQRNh/jKCG3MEfnudfdt1tjjKvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958125; c=relaxed/simple;
	bh=Fc9fjKhu9+1SCbCYIk+yYMNj9ArhrQq5vfxkzOjYC2k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F5hKWLnj87I1wysMzfF/D2IdYEg6AbdASUq8wNUCYSjZHEd+k7Khm00EW7Hga4/Ql21cTJ/nJae0Z0Cx0yJrfd0eMTCT310ra+vGNeVXb8xsXx7EjqQoIYdGD7g2TepaaIEypAMRkaF3B6+4Cfkb2zScOUVnG5F8lW/9snpTBXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G1oT6GPZ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e459b39e2cso1729865b3a.1;
        Mon, 26 Feb 2024 06:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958123; x=1709562923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=koLrT/8ZaHBP75M3jJkVq1itGq5s215EKD4aR1Xrs9Q=;
        b=G1oT6GPZ/aVd87JtJucn5V/abf3QP6KbbG83vB+1Ir1FY2c1zQaraSW0UoKfNT4Giz
         1SCGPQgBSPAHDG32EMebHr2KBiED+M+M8GUbbkVn4wO3U4iQC1RjoAEeQdnIQgeb967d
         RCaSDKL9I32YpML20S2q150E1VU8/GzrTXCnpNwHnhVprdUf3h/8G44TJwcVdvkxGchm
         hpqNRYvqecK63zbAgS1tw51N+F1wpY9oHnxmMeLizm2Sp1e6HzK65+AP5rWuEppOAsJW
         YuYAvW2swzm5xx5lpYLbHK5+Ov2SEpASHevdKidPgiasEkavmbIMK7C+KWAYlUewE9bE
         epTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958123; x=1709562923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=koLrT/8ZaHBP75M3jJkVq1itGq5s215EKD4aR1Xrs9Q=;
        b=NSvc+KnhB6BvVY+P5c+qPWaqGNmynB5UBBwfaEZU5BIyVDa5qJMzvAIGX1kCisqrvL
         iBRsbbKHcXJTJZAJvwJgtTA2TwTVMXJhmrErEcvkj2knoqXve448S4MtRED1YazIQQpo
         Vii5UO723DRpgRwu7PPI1kuXQUgV3MWeI3FvDCsJfxNoG0CydyqHH7lUjU2tnj9WMIhh
         Z+DWuPTYs/NbpvLv2+2ZZU6oblgb970s6vWpve/rwj0D+8WSX1PQEyqQ06VdAL66Pj/t
         pQWcsFmCSfHR6mC+0CHDw9oxPbW2GoZf0xgyITUXRJwTiuqXTjP1JLbP+3phe07WNnBo
         9tzw==
X-Forwarded-Encrypted: i=1; AJvYcCW8CxC/SIGjchO7vetrHeM1/2SPhGjvbjipgFn251hVZum/PUAtlDgzzcxPX7/97KuJZ9Al6dLgRt8dQpX/hb/5H1wL
X-Gm-Message-State: AOJu0YzdRTXZcWXtbCGf6FDA6iUj6qOTn34yWpk8sqR64vGtT5Rp5YoB
	FpcN2WQrVG5lH6SgfitapNCVBPNQ5gCTeB1M0NXei9970zmNUFmMEdEXoxyM
X-Google-Smtp-Source: AGHT+IGkIaU97O2tmt7HU52M8oE3r8e7BYbysBBvgkybW7v+NpBM415W6UhaXfuBCJz7jrhFnep1IA==
X-Received: by 2002:a05:6a20:9593:b0:1a0:ecf0:640a with SMTP id iu19-20020a056a20959300b001a0ecf0640amr10170340pzb.9.1708958123223;
        Mon, 26 Feb 2024 06:35:23 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id w13-20020aa79a0d000000b006e02f4bb4e4sm4216825pfj.18.2024.02.26.06.35.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:22 -0800 (PST)
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
Subject: [RFC PATCH 14/73] KVM: x86: Create stubs for PVM module as a new vendor
Date: Mon, 26 Feb 2024 22:35:31 +0800
Message-Id: <20240226143630.33643-15-jiangshanlai@gmail.com>
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

Add a new Kconfig option and create stub files for what will eventually
be a new module named PVM (Pagetable-based PV Virtual Machine). PVM will
function as a vendor module, similar to VMX/SVM for KVM, but it doesn't
require hardware virtualization assistance.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/Kconfig   |  9 +++++++++
 arch/x86/kvm/Makefile  |  3 +++
 arch/x86/kvm/pvm/pvm.c | 26 ++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)
 create mode 100644 arch/x86/kvm/pvm/pvm.c

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 950c12868d30..49a8b3489a0a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -118,6 +118,15 @@ config KVM_AMD_SEV
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
 
+config KVM_PVM
+	tristate "Pagetable-based PV Virtual Machine"
+	depends on KVM && X86_64
+	help
+	  Provides Pagetable-based PV Virtual Machine for KVM.
+
+	  To compile this as a module, choose M here: the module
+	  will be called kvm-pvm.
+
 config KVM_SMM
 	bool "System Management Mode emulation"
 	default y
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 97bad203b1b1..036458a27d5e 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -33,9 +33,12 @@ ifdef CONFIG_HYPERV
 kvm-amd-y		+= svm/svm_onhyperv.o
 endif
 
+kvm-pvm-y 		+= pvm/pvm.o
+
 obj-$(CONFIG_KVM)	+= kvm.o
 obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
 obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
+obj-$(CONFIG_KVM_PVM) 	+= kvm-pvm.o
 
 AFLAGS_svm/vmenter.o    := -iquote $(obj)
 $(obj)/svm/vmenter.o: $(obj)/kvm-asm-offsets.h
diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
new file mode 100644
index 000000000000..1dfa1ae57c8c
--- /dev/null
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Pagetable-based Virtual Machine driver for Linux
+ *
+ * Copyright (C) 2020 Ant Group
+ * Copyright (C) 2020 Alibaba Group
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+#include <linux/module.h>
+
+MODULE_AUTHOR("AntGroup");
+MODULE_LICENSE("GPL");
+
+static void pvm_exit(void)
+{
+}
+module_exit(pvm_exit);
+
+static int __init pvm_init(void)
+{
+	return 0;
+}
+module_init(pvm_init);
-- 
2.19.1.6.gb485710b


