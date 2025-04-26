Return-Path: <kvm+bounces-44409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD13EA9DA4F
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 13:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 090011B66460
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 11:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB7122423E;
	Sat, 26 Apr 2025 11:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="oUMmaDaI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D2621CC59
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 11:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745665483; cv=none; b=GI4eF9xcqrgvube3rkuwz6Txow3zRsfvn6C4yzbIzJw/gsJuE0rtAV2LOAuDU9IMugJ4LYYD4JK9R0isl+TLkLyeZ9MmnPeNDcOePUvLhB2Awb4csrQFE68q06zjLTFYGEI7SXsSRi6TFkF1IN5Mf3WtG3a/orGlY+19NPbx84k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745665483; c=relaxed/simple;
	bh=631W5o3g3CZxKv8D3kmPZsR7ENQvUL/ve/2ajbQSxPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkh0gmbviVa6Y8Zf1WlDsbwZqAtmTt3yZWOnqeSuaOeEgyIfAYGGTRmZz9/I9zpl2ySBYpeosf8Tt5gp0Tdc5uRTWbOQfpHV1vaKHNbKa7edpdDhFwW63P9Q4r+5P5HUj3NucufRY16X6FyjoP/V55ZtQtVtLzjEO1xH9ASN/XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=oUMmaDaI; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-af50f56b862so2210826a12.1
        for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 04:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745665480; x=1746270280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xo4Fl+pVAb32qLSshYkAcx18QLYg4yrAcKR/5H6gjL0=;
        b=oUMmaDaIwssu30p7RP0wusHujP6mFNEynHDrip4VwNKqLdP7ZMz3uE5MwcOcKI7p11
         CiL66W89R3iiSDFgrobp8NFiBqQM+7DG+VbqL4cGyqNtA5s/9jsPgcRj7ooV/m0mASXR
         cCjGkySl3BKZ/9JJUONrpZnzf0W5FRj+1bp30rutm27q6e4h0tXiuP2fXf5/8i8oxjUi
         ZrczaiYA27MCGSKnJxqDAp6fDIx9vC3VGEFL8khH6ZjevGN+cZvM1XeczxXNF4JuCuyq
         M3jdCh1m9L8gOS2S13SDPwrOIH9GeQ7q6hPu5NW3GMCv5gqdjfEwSGu+/vax33SoTaY8
         WvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745665480; x=1746270280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xo4Fl+pVAb32qLSshYkAcx18QLYg4yrAcKR/5H6gjL0=;
        b=fSJd4No+bKKp2FrLpNxEgB+1QdmHaAQn+6kHMt51v/jeQr4QoMYAg7LY3YAESTI2yO
         vW6dIhthlv0HhkOWohQHRJrjrl1RzmLt5Y9iqfsvlwUyNvbWsbj/mY0taOKtOom4XtlV
         PFBORqanKIJQgE7kyiKd8+YmoWIYgxVq20JFBZxk21Q2UUyeM2w87K1oXNwj6/GlOpye
         YG4+z4RL/76S7CER/WN/+we50CX1++AsmBO6YgMmeVkLTZ4Az0E+TYN3+kUYuzEvXoDn
         GDJKbOatZkRH01zm1tOgFbgwUjMXrr4P4Lm/T/r3hwSsWXEP5GO3hR4LNuckTMt/WTP8
         h02w==
X-Forwarded-Encrypted: i=1; AJvYcCXYDIaKUl9YYpltIQX3DlDnyTZWQWmYmHtw/K2sC5KNkvnYpOfnKqBSlKNC5B1IMRDAxts=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBmDBgTkLA03cGSyf3Vael8mbCG7H2BdOH4JgEm5jXYiM1LshJ
	K4pYx9NJNN01Oxi9zrjL6xG39h+aw4BDbbGlZcVQKQB1Nz9ASKLg9CVtlQHhTRw=
X-Gm-Gg: ASbGncuxkwwrS8bpS6G2uHBCepOb8vWgqsSi2PejSMlT1Uf04uB4/eLPT9HDjaW4NLd
	BILzCQFe76HSusV570FnDbRIU0F8an5OizTgH59C7+bbCyfuzWmLQlfkjNqjbjGzg8Hjw2RAcJ/
	0Qr6rGHJOHbg7O8a/awOmDrb6Ut8sodipReP4Fdg0E62p/0R/ygCAKtd77yVDvNjGwl7XRi1JYm
	EBnrGG1VScrwohp8phzLongGkk9VKkEl6oUpTYvHxYIAuYY7Z2HTLa4Ug8X8HicTu5sfc6iRvBs
	9VPrUZmf042Pa8bDa+1xikXxDEYVu8pr17ruejnNw1xNd+jzYFsOiaht13kKVnkGFv3JhyAhaKm
	C5pOs
X-Google-Smtp-Source: AGHT+IGFdwG5nx4focrSUQIHOY7lZnK0HJsTw7gvZeD5G+O0EY/0nVr5PBoeJS7FVvcFvd3EbxH7VA==
X-Received: by 2002:a17:902:ef47:b0:21f:4b01:b978 with SMTP id d9443c01a7336-22dc6a54a44mr47953985ad.36.1745665480347;
        Sat, 26 Apr 2025 04:04:40 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22dc8e24231sm10956725ad.125.2025.04.26.04.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 04:04:39 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 09/10] riscv: Add cpu-type command-line option
Date: Sat, 26 Apr 2025 16:33:46 +0530
Message-ID: <20250426110348.338114-10-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250426110348.338114-1-apatel@ventanamicro.com>
References: <20250426110348.338114-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the KVMTOOL always creates a VM with all available
ISA extensions virtualized by the in-kernel KVM module.

For better flexibility, add cpu-type command-line option using
which users can select one of the available CPU types for VM.

There are two CPU types supported at the moment namely "min"
and "max". The "min" CPU type implies VCPU with rv[64|32]imafdc
ISA whereas the "max" CPU type implies VCPU with all available
ISA extensions.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/aia.c                         |  2 +-
 riscv/fdt.c                         | 68 +++++++++++++++++++++++++----
 riscv/include/kvm/kvm-arch.h        |  2 +
 riscv/include/kvm/kvm-config-arch.h | 10 +++++
 4 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/riscv/aia.c b/riscv/aia.c
index 21d9704..cad53d4 100644
--- a/riscv/aia.c
+++ b/riscv/aia.c
@@ -209,7 +209,7 @@ void aia__create(struct kvm *kvm)
 		.flags = 0,
 	};
 
-	if (kvm->cfg.arch.ext_disabled[KVM_RISCV_ISA_EXT_SSAIA])
+	if (riscv__isa_extension_disabled(kvm, KVM_RISCV_ISA_EXT_SSAIA))
 		return;
 
 	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &aia_device);
diff --git a/riscv/fdt.c b/riscv/fdt.c
index c741fd8..abb6557 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -13,16 +13,17 @@ struct isa_ext_info {
 	const char *name;
 	unsigned long ext_id;
 	bool single_letter;
+	bool min_enabled;
 };
 
 struct isa_ext_info isa_info_arr[] = {
 	/* single-letter ordered canonically as "IEMAFDQCLBJTPVNSUHKORWXYZG" */
-	{"i",		KVM_RISCV_ISA_EXT_I,	.single_letter = true},
-	{"m",		KVM_RISCV_ISA_EXT_M,	.single_letter = true},
-	{"a",		KVM_RISCV_ISA_EXT_A,	.single_letter = true},
-	{"f",		KVM_RISCV_ISA_EXT_F,	.single_letter = true},
-	{"d",		KVM_RISCV_ISA_EXT_D,	.single_letter = true},
-	{"c",		KVM_RISCV_ISA_EXT_C,	.single_letter = true},
+	{"i",		KVM_RISCV_ISA_EXT_I,	.single_letter = true, .min_enabled = true},
+	{"m",		KVM_RISCV_ISA_EXT_M,	.single_letter = true, .min_enabled = true},
+	{"a",		KVM_RISCV_ISA_EXT_A,	.single_letter = true, .min_enabled = true},
+	{"f",		KVM_RISCV_ISA_EXT_F,	.single_letter = true, .min_enabled = true},
+	{"d",		KVM_RISCV_ISA_EXT_D,	.single_letter = true, .min_enabled = true},
+	{"c",		KVM_RISCV_ISA_EXT_C,	.single_letter = true, .min_enabled = true},
 	{"v",		KVM_RISCV_ISA_EXT_V,	.single_letter = true},
 	{"h",		KVM_RISCV_ISA_EXT_H,	.single_letter = true},
 	/* multi-letter sorted alphabetically */
@@ -89,6 +90,56 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zvkt",	KVM_RISCV_ISA_EXT_ZVKT},
 };
 
+static bool __isa_ext_disabled(struct kvm *kvm, struct isa_ext_info *info)
+{
+	if (kvm->cfg.arch.cpu_type == RISCV__CPU_TYPE_MIN &&
+	    !info->min_enabled)
+		return true;
+
+	return kvm->cfg.arch.ext_disabled[info->ext_id];
+}
+
+static bool __isa_ext_warn_disable_failure(struct kvm *kvm, struct isa_ext_info *info)
+{
+	if (kvm->cfg.arch.cpu_type == RISCV__CPU_TYPE_MIN &&
+	    !info->min_enabled)
+		return false;
+
+	return true;
+}
+
+bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
+{
+	struct isa_ext_info *info = NULL;
+	unsigned long i;
+
+	for (i = 0; i < ARRAY_SIZE(isa_info_arr); i++) {
+		if (isa_info_arr[i].ext_id == isa_ext_id) {
+			info = &isa_info_arr[i];
+			break;
+		}
+	}
+	if (!info)
+		return true;
+
+	return __isa_ext_disabled(kvm, info);
+}
+
+int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset)
+{
+	struct kvm *kvm = opt->ptr;
+
+	if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || strlen(arg) != 3)
+		die("Invalid CPU type %s\n", arg);
+
+	if (!strcmp(arg, "max"))
+		kvm->cfg.arch.cpu_type = RISCV__CPU_TYPE_MAX;
+	else
+		kvm->cfg.arch.cpu_type = RISCV__CPU_TYPE_MIN;
+
+	return 0;
+}
+
 static void dump_fdt(const char *dtb_file, void *fdt)
 {
 	int count, fd;
@@ -139,9 +190,10 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 				/* This extension is not available in hardware */
 				continue;
 
-			if (kvm->cfg.arch.ext_disabled[isa_info_arr[i].ext_id]) {
+			if (__isa_ext_disabled(kvm, &isa_info_arr[i])) {
 				isa_ext_out = 0;
-				if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+				if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0 &&
+				    __isa_ext_warn_disable_failure(kvm, &isa_info_arr[i]))
 					pr_warning("Failed to disable %s ISA exension\n",
 						   isa_info_arr[i].name);
 				continue;
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index f0f469f..1bb2d32 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -90,6 +90,8 @@ enum irqchip_type {
 	IRQCHIP_AIA
 };
 
+bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long ext_id);
+
 extern enum irqchip_type riscv_irqchip;
 extern bool riscv_irqchip_inkernel;
 extern void (*riscv_irqchip_trigger)(struct kvm *kvm, int irq,
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 7e54d8a..6d9a29a 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -3,7 +3,13 @@
 
 #include "kvm/parse-options.h"
 
+enum riscv__cpu_type {
+	RISCV__CPU_TYPE_MAX = 0,
+	RISCV__CPU_TYPE_MIN
+};
+
 struct kvm_config_arch {
+	enum riscv__cpu_type cpu_type;
 	const char	*dump_dtb_filename;
 	u64		suspend_seconds;
 	u64		custom_mvendorid;
@@ -13,8 +19,12 @@ struct kvm_config_arch {
 	bool		sbi_ext_disabled[KVM_RISCV_SBI_EXT_MAX];
 };
 
+int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset);
+
 #define OPT_ARCH_RUN(pfx, cfg)						\
 	pfx,								\
+	OPT_CALLBACK('\0', "cpu-type", NULL, "min or max",		\
+		     "Choose the cpu type (default is max).", riscv__cpu_type_parser, kvm),\
 	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,		\
 		   ".dtb file", "Dump generated .dtb to specified file"),\
 	OPT_U64('\0', "suspend-seconds",				\
-- 
2.43.0


