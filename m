Return-Path: <kvm+bounces-44194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AA59A9B26A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B7AD920E2E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C747C223DF9;
	Thu, 24 Apr 2025 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="n+7gIdb0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0F91A8F97
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508772; cv=none; b=poh02B/rEDq2lGOtCBU0EYfh0+xKhWqTEDrTmnwsV/zhfqr+BfNaHDm/OghZvKrdecBxtNLFC9aWLM85R1KVnqtyVFSKE/+DekUmlv+Ma0fTPHPblKc+yICK7FXAZoOd9RzJUdr3onbwlVmUpRcRC1zDqEzpSvY7tkloeyCQui0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508772; c=relaxed/simple;
	bh=7jdSy1q/dGX/KosB4oP8/r4XIDRS8m3u3Fw/YMFatqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdvsPjx7zDJ6WkRrXI6lGZUuoEmRwBBlpmrqQYm/uPmxIjUutTs3QXVnBrBJJbnQvkLcpGaCcyPMVZVwax1B2Z1uDX4I31kdnn2dUpvE7RFlM665TUpYv3tbMnTgEsKgkIG8rgxCAUaCtCIZXFBCmQ2jjPXIN/q8dQM1Q8tB1DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=n+7gIdb0; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b07d607dc83so985380a12.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745508769; x=1746113569; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2D6nlmo1xCA/mCgv9pPk+Ys6Km6cHx2FzcMKI2G3UM=;
        b=n+7gIdb06Ujl6Rq+AK1h8T6GAgtN2xzooKNB1k4dZkxilf3fnerp4c2pNMdThvSNWQ
         Xv1vp2OGptJ1KicuwM2hhE7gPTpeWv2qMj1lZPlB4h3X3UX4cWTp6U9ujLCN14arVeWP
         pY/IdhdSlLJmhRKobeo8Oj3QAGSHb5YOIo5oCux2JvclN9+vwfgKLKMTt1pLwY23lKfs
         FXdwn2n11d4o9Bcl8BBo1m+32pT5jYSb3qQEXsgAcrh+22M0bLAPq752iNVPSHpvmOp2
         eOmFqJImlXqved6w+Zm8zvXSncJrbB44NqoPJSSLE7UHwnaxz+xunWTB+0aOSV/g7N9V
         tisw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745508770; x=1746113570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P2D6nlmo1xCA/mCgv9pPk+Ys6Km6cHx2FzcMKI2G3UM=;
        b=u1l7QhbedMZDeOxq1O317O1bAmP6Hhi895i6wRLARtf/Lnfe6+orDN6rxTloSOcJOj
         JAD3TqvqM0GKHQcEpeLETsifSzvcvsYwPVy7LOJ6JGnRypSdbTAEVlDj2mKLQbcZOKgO
         krj26dh974WZ1VjPViYAVNU/mp06bPvkseT9gZxDQlDQdVRCF7ZOM9RyI/Jtgzp+0Yvh
         c6UAxqCJse6STVsIZHsOd7owJijqbbORIscGJ+81+08p42K1LZ2LdZev7G9U7iAYquKJ
         s1/zBPq5NNzhpZ7t6iwyoaR04PZc5hUvD35xzxjxQX8fBiHrMdOv5ZfJuGB1w5Pex2Pc
         D5eA==
X-Forwarded-Encrypted: i=1; AJvYcCVBtRRTDhA8F989zt9lecOSw0IIGdfYy0nmKF7dzZissHRApUbL1fiOHOzoSRv6FhddmD8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkBnub/2R+F7EOINj5b9Glx4Y/WWv0nrewyss/uVCq6I5TUQHc
	+vW2jdmzpXtjPHu1+ydXeQ8T0APUXS7fIduGl5aPtTKu21VfZXXjiwSNoIZewlQ=
X-Gm-Gg: ASbGncsAu8XejSmWu5t8Eznlp8xVdx49bJaZ1YRayd6RozrOk+A2uS2ozYsMqFZ6qHZ
	BdIOE3bhpKe13Ix3xrVi1bZmqH6NZdCuHW4HYMNYZeIqyfYPjqv5LxvIW41cijB7hECrxASVno3
	PI52cMbNGiHMMrVdu5FudSDKvvOYX+bUf91UIvBuFHNL28Mt45oq6l1xkX5VMahnCpC02x7Ly5f
	wEEALFURUg9SBk05TfthVTbsVY4bV1YdI7jF4dbUagAyXTfuocPpTd4QRwNyQrMTnkPBPzpYD+u
	nWrqcrJdsctvwhbHt+zuNfnUgLx1gJr6IYGrdYHK3pdCTuKSkIptplF7FYT0/11U6OVvIXehzS7
	bM+0X
X-Google-Smtp-Source: AGHT+IEKYppXAd5zqADsBjhthJktNqLWdYfwg51TFJZpqKaoJ9QHpJBSE0Aotf6FvdZ4KpFp4+imYw==
X-Received: by 2002:a05:6a20:438d:b0:1f5:60fb:8d9 with SMTP id adf61e73a8af0-20444fbb9c6mr4405396637.33.1745508769500;
        Thu, 24 Apr 2025 08:32:49 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f8597f5csm1360610a12.43.2025.04.24.08.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 08:32:48 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 09/10] riscv: Add cpu-type command-line option
Date: Thu, 24 Apr 2025 21:01:58 +0530
Message-ID: <20250424153159.289441-10-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250424153159.289441-1-apatel@ventanamicro.com>
References: <20250424153159.289441-1-apatel@ventanamicro.com>
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
index c741fd8..5d9b9bf 100644
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
+		break;
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


