Return-Path: <kvm+bounces-8664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC11A854923
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:22:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62A9128F950
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32C721363;
	Wed, 14 Feb 2024 12:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="msjzoidu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C141CD0F
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913326; cv=none; b=jVL0zw0cF+gHtfPIIfa4zdEmqtXBDJ0vJJ1ke57ShPemdWvKnhsch6jzWuyA5h9xfp2WL6iQkhojZGKi3923wI9yGRj54AfyhWZ8fIn8wgMF1C0FIQuiYaKViiB/iLpQ5E77H9TUOCTe59HP57cWikbzz5X/dKrpnFkLvA2iSbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913326; c=relaxed/simple;
	bh=OVvM3FMv8/NR21J+dE6C56B0IghZOQkZqVDKL8wGZwM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s6jFtOEET5YzVY8aEZ1ckyPlY9KgUXwwbWDTK5iDcTQxfmRCCzc5iKJ87Cu+TIvXn0qwvUmqPgrsykt4SDUw6YPY7+5lror7aUPDQCKUzgeh73hUI1+5M660HcJbSLB3eJhRwgqGyBtQoGzxfgyrXt/bCqJA0znP9BVxE0th4Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=msjzoidu; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5dc816e4affso1579539a12.2
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707913325; x=1708518125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJHsdkwY98XNAe7FkD7zjxblmst8KoO5VlTSmaDE1gU=;
        b=msjzoiduq8Pr6Hpit5AcqVJkAz7sYDXwBjmroZPllYzTPYmDLlmEZFz6tPziu/Bdw3
         /MKDjIJzTLej0shR98TMTLGrnTha24sbGbdw0NAgl0VfmfjqKksO64+Ot4rQxX142jmh
         n4sWTl42Q9UtjDXXWTx49040Kz2j2Ex6gG+yoUWHCLpNMMuzkyuLzEmriMDzgIxillek
         JFabLw7e5YyBysvPsH9wvS9495wbd7IDkjeg6fM7lqvRrzu4E8WMrf2F+R4oiC2on9ls
         Vx1qZRxht/9ZpeGxSfGFWWjzRFy9O7Rsu4SFZVtSb6OimnGgX+2zVJXap/I1GE60Ovsw
         rcZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707913325; x=1708518125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EJHsdkwY98XNAe7FkD7zjxblmst8KoO5VlTSmaDE1gU=;
        b=HZitlQDknkP+B97iJHj0wAaSgXSNHPk8Qc+vzelyeEtPBSNOHa3RhiPai/WvoFR7Dg
         fWc4OgMLxTwV1IThb/nbXGY2dmnz4wD9160anS9yujBkz+AkXe0PrNJ4S0Y8DqKHQpRK
         55ebKzo1tigUILMzjxYwcO4/Op7a1WFStWdge7iWqvrJLomxxmB1Gi4xfbzUv0hlUjfp
         qjjNNiCsc1YpLs+ACkmUdwvfkjwjr9IwTRr7dkiu/R2u5AKL5NOAMbCEUpkRtOs5eOeO
         yzOTMJzVUN9RoiZvzB8NRCltK3R3355SuiO34yRpSiDZIjyGTXyQ6s+zD102BBi9r8QO
         fumw==
X-Forwarded-Encrypted: i=1; AJvYcCUJVzq87jQcEH9aiuk+1qT9kr9v1lWI0IBe/S1K7pTHlgm8bWt80s01czqMCa/uH1Ac2BYOlKzL2gjzX9R2R4d7mvf0
X-Gm-Message-State: AOJu0Yw+XbGNn/FDAPs98pt5KnBXxrAT6U02LPTl9r8C94RiNDCKId5U
	reBpZSgVfaHjkkUQsDC57fuaaokeATV9NUOv2bUOrtLfujiYFihVbUricHz4MF8=
X-Google-Smtp-Source: AGHT+IGp4YwbcwK+b1C4aq3yR7OclF7DR3MNrVHVpS7sfr51IswGxSrVvBIsYCSQNVCPhQbvUbffSA==
X-Received: by 2002:a05:6a20:9597:b0:19e:a25e:a7f5 with SMTP id iu23-20020a056a20959700b0019ea25ea7f5mr3019724pzb.46.1707913324651;
        Wed, 14 Feb 2024 04:22:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVGs0dh5rH2LYPpbdVIJ4u49Ly9YNrZHkdy1J3ir8Jw1I1/gPgTiMabQlgrwfOwFUOKXDt81221legsQiG4RuJFshhigmbdRTNsSsJ+NgD5YrQSXsah6KuPXgXpsfRiE+Dsj2t+4F0yZdCxQBavp905JL9DzZ9suTSsfofIYoPd3chterKvn2FbfQFWqIJdj1s1Rz9PTLrOCu7TXu0vDVOGEEASnQNsLc3KpR3GhBv/fcJr3i8F36ZjM06EGpsSYT7KX3lnt3p7er6RHZFrmFYtCJ4pdBDtLIvoNonSlA9qBT0ko05EfaW1XlaL0ZuPhw==
Received: from anup-ubuntu-vm.localdomain ([171.76.87.178])
        by smtp.gmail.com with ESMTPSA id hq26-20020a056a00681a00b006dbdac1595esm9496060pfb.141.2024.02.14.04.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 04:22:04 -0800 (PST)
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
Subject: [kvmtool PATCH 04/10] riscv: Add scalar crypto extensions support
Date: Wed, 14 Feb 2024 17:51:35 +0530
Message-Id: <20240214122141.305126-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240214122141.305126-1-apatel@ventanamicro.com>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
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
 riscv/fdt.c                         | 10 ++++++++++
 riscv/include/kvm/csr.h             | 15 ++++++++++++++
 riscv/include/kvm/kvm-config-arch.h | 30 ++++++++++++++++++++++++++++
 riscv/kvm-cpu.c                     | 31 +++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+)
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
index 0000000..2d27f74
--- /dev/null
+++ b/riscv/include/kvm/csr.h
@@ -0,0 +1,15 @@
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
index c4e83c4..3e17c12 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -1,3 +1,4 @@
+#include "kvm/csr.h"
 #include "kvm/kvm-cpu.h"
 #include "kvm/kvm.h"
 #include "kvm/virtio.h"
@@ -222,11 +223,41 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
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
+		vcpu->kvm_run->riscv_csr.ret_value = rand() & SEED_ENTROPY_MASK;
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
+	};
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


