Return-Path: <kvm+bounces-12597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3560688AA8E
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:02:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58DDF1C3AF78
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845445BACF;
	Mon, 25 Mar 2024 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LlbFlHTZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2389C4DA11
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711380730; cv=none; b=GXXxlokHxlUed5YMkrINteKQD8jl8S9tztfSszTcyZ5LGgyBQZm4qM5BN2E0EGFEtw/8heYIiTF7S0lvYCJE0SOX0t01mAcWJ9fbvIepCikwpkfddccRk1F/WGr9NSjSOPSt5R0bGs8lfUB8Q7iElxaek/Tn/YeaMkZOdQuSkUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711380730; c=relaxed/simple;
	bh=Toen6tS0ClDye5WWdGidypJLDNjVy0u+fHU/JZlMUXw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g4Mxbxe0jxcEFEvzfJejcnwWlM0cSSspPMdgVFqVx77nnvVKunl/JFQFaTj2gEXpZNNvF8sTvwOtZ+vDpbJuazPFr2UtzAsBNsBclb7isFUoIltz+CvgWahQTrZn02ihC2ZiBcDQc5BV2QSa5UCMBdxSxz8S1jRemuqfH5WRlW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LlbFlHTZ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1e0b889901bso8545995ad.1
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711380728; x=1711985528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ew95XvvTol4/ofCLLLZzdrFLR5bnldw50BI/kwmiGo0=;
        b=LlbFlHTZK87tSiCtO3RVA/k0LYSCtU5sRQWzyUWhC/+m39kUvuomCGMYd4XQm4U9l3
         f+I1X1CcolMtOYnA8AoAUEXR2wWrcTwsTa4wcO3RMiSwM4bf/+FuqH+grXeuZ8G7xe1J
         tf/kKopWKUuoPkqzAw+ZLlUoTQwbAjQStd3DF/JdEHUQrxWOTJPBcdYtjHCOrSZ6LdYH
         Xx/C69sM5D3cxje8+gFuQ48uXP6kVRliZ2FWymq0oCiJCZRXoFUCAhpvWJO92qGOZHFg
         W9ExfGf3OgYzGQfErgd5wUEmsct63iUwdLX/79uLxeaR7R0YhSPdqIJ0CROS93QSCG3N
         saOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711380728; x=1711985528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ew95XvvTol4/ofCLLLZzdrFLR5bnldw50BI/kwmiGo0=;
        b=cBLFn8WBRidP+sue4qUzmOEur4nM+jReBfIWwDD+CC7noAlQ0pcBelRyxeKvvCnm97
         AXnIN+L9vqs7uC3UYejiuVUFbWxY/DT5BMaFcuV6j+3gtKmQBJoTmIo6S6m/y/+x3SKF
         25MtoCx9MdPz43NuRCwDQ0AaFqCJwc/rOthGUj3CDOTenKY+z24swYvb4V9duzRRO6bK
         V0nQOII8aOC9ww0zDYZGsm5ub6LlSY715FbnFSK6l3S/m03fSkZxSRvCci3GotN2ZQbW
         xiGZlFJCb/MdFwtD8Jn8PzKmBYY84SlAlCVWBDntl802x7Z3SMEfOZTrSetir2o4m6sU
         +aDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWm584rTIoHba3HjXbJbUo4tFwm0s4V9AKEZCnr3Gx6oH2nSyXzN7LlYtCqUGV89uVimT7qej/BvxmbQ6PnzMCQtkbi
X-Gm-Message-State: AOJu0Yy7+59qGc7wOpUILQvZZZpHfBUU3hfYk5zulQxpTbzaCzSzyPTd
	X4I0Y+rwywgTwVVCVRhu0IzDBNbmAWxV3qfUYg4oXCNz6irwWTwbAyIQ5j6bx0s=
X-Google-Smtp-Source: AGHT+IHd01HEQle7MFWsl8lSOS4t1U0+IipUIywyfXGAs11x9EEwtIIw3BQVwHEoK4SHC9n9Bm3zww==
X-Received: by 2002:a17:902:d306:b0:1df:fd30:8b2d with SMTP id b6-20020a170902d30600b001dffd308b2dmr6112710plc.50.1711380728296;
        Mon, 25 Mar 2024 08:32:08 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.87.36])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001dd0d090954sm4789044plg.269.2024.03.25.08.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 08:32:07 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 04/10] riscv: Add scalar crypto extensions support
Date: Mon, 25 Mar 2024 21:01:35 +0530
Message-Id: <20240325153141.6816-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240325153141.6816-1-apatel@ventanamicro.com>
References: <20240325153141.6816-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the scalar extensions are available expose them to the guest
via device tree so that guest can use it. This includes extensions
Zbkb, Zbkc, Zbkx, Zknd, Zkne, Zknh, Zkr, Zksed, Zksh, and Zkt.

The Zkr extension requires SEED CSR emulation in user space so
we also add related KVM_EXIT_RISCV_CSR handling.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 10 +++++++++
 riscv/include/kvm/csr.h             | 16 +++++++++++++++
 riscv/include/kvm/kvm-config-arch.h | 30 +++++++++++++++++++++++++++
 riscv/kvm-cpu.c                     | 32 +++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+)
 create mode 100644 riscv/include/kvm/csr.h

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 84b6087..be87e9a 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -25,6 +25,9 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zba", KVM_RISCV_ISA_EXT_ZBA},
 	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
 	{"zbc", KVM_RISCV_ISA_EXT_ZBC},
+	{"zbkb", KVM_RISCV_ISA_EXT_ZBKB},
+	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
+	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
@@ -34,6 +37,13 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM},
+	{"zknd", KVM_RISCV_ISA_EXT_ZKND},
+	{"zkne", KVM_RISCV_ISA_EXT_ZKNE},
+	{"zknh", KVM_RISCV_ISA_EXT_ZKNH},
+	{"zkr", KVM_RISCV_ISA_EXT_ZKR},
+	{"zksed", KVM_RISCV_ISA_EXT_ZKSED},
+	{"zksh", KVM_RISCV_ISA_EXT_ZKSH},
+	{"zkt", KVM_RISCV_ISA_EXT_ZKT},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
diff --git a/riscv/include/kvm/csr.h b/riscv/include/kvm/csr.h
new file mode 100644
index 0000000..bcbf61d
--- /dev/null
+++ b/riscv/include/kvm/csr.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef KVM__KVM_CSR_H
+#define KVM__KVM_CSR_H
+
+#include <linux/const.h>
+
+/* Scalar Crypto Extension - Entropy */
+#define CSR_SEED		0x015
+#define SEED_OPST_MASK		_AC(0xC0000000, UL)
+#define SEED_OPST_BIST		_AC(0x00000000, UL)
+#define SEED_OPST_WAIT		_AC(0x40000000, UL)
+#define SEED_OPST_ES16		_AC(0x80000000, UL)
+#define SEED_OPST_DEAD		_AC(0xC0000000, UL)
+#define SEED_ENTROPY_MASK	_AC(0xFFFF, UL)
+
+#endif /* KVM__KVM_CSR_H */
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 6d09eee..3764d7c 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -52,6 +52,15 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zbc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBC],	\
 		    "Disable Zbc Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zbkb",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBKB],	\
+		    "Disable Zbkb Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zbkc",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBKC],	\
+		    "Disable Zbkc Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zbkx",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBKX],	\
+		    "Disable Zbkx Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zbs",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
 		    "Disable Zbs Extension"),				\
@@ -79,6 +88,27 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zihpm",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHPM],	\
 		    "Disable Zihpm Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zknd",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKND],	\
+		    "Disable Zknd Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zkne",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKNE],	\
+		    "Disable Zkne Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zknh",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKNH],	\
+		    "Disable Zknh Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zkr",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKR],	\
+		    "Disable Zkr Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zksed",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKSED],	\
+		    "Disable Zksed Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zksh",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKSH],	\
+		    "Disable Zksh Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zkt",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKT],	\
+		    "Disable Zkt Extension"),				\
 	OPT_BOOLEAN('\0', "disable-sbi-legacy",				\
 		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_V01],	\
 		    "Disable SBI Legacy Extensions"),			\
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index c4e83c4..ae87848 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -1,3 +1,4 @@
+#include "kvm/csr.h"
 #include "kvm/kvm-cpu.h"
 #include "kvm/kvm.h"
 #include "kvm/virtio.h"
@@ -222,11 +223,42 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
 	return ret;
 }
 
+static bool kvm_cpu_riscv_csr(struct kvm_cpu *vcpu)
+{
+	int dfd = kvm_cpu__get_debug_fd();
+	bool ret = true;
+
+	switch (vcpu->kvm_run->riscv_csr.csr_num) {
+	case CSR_SEED:
+		/*
+		 * We ignore the new_value and write_mask and simply
+		 * return a random value as SEED.
+		 */
+		vcpu->kvm_run->riscv_csr.ret_value = SEED_OPST_ES16;
+		vcpu->kvm_run->riscv_csr.ret_value |= rand() & SEED_ENTROPY_MASK;
+		break;
+	default:
+		dprintf(dfd, "Unhandled CSR access\n");
+		dprintf(dfd, "csr_num=0x%lx new_value=0x%lx\n",
+			vcpu->kvm_run->riscv_csr.csr_num,
+			vcpu->kvm_run->riscv_csr.new_value);
+		dprintf(dfd, "write_mask=0x%lx ret_value=0x%lx\n",
+			vcpu->kvm_run->riscv_csr.write_mask,
+			vcpu->kvm_run->riscv_csr.ret_value);
+		ret = false;
+		break;
+	}
+
+	return ret;
+}
+
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 {
 	switch (vcpu->kvm_run->exit_reason) {
 	case KVM_EXIT_RISCV_SBI:
 		return kvm_cpu_riscv_sbi(vcpu);
+	case KVM_EXIT_RISCV_CSR:
+		return kvm_cpu_riscv_csr(vcpu);
 	default:
 		break;
 	};
-- 
2.34.1


