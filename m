Return-Path: <kvm+bounces-56789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D683AB4353B
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:14:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A06B188F1A7
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0DF62C0F84;
	Thu,  4 Sep 2025 08:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jpgXpgec"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9202D2496
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973527; cv=none; b=TVF25TuDhrCh/VYzRN3/k+uin+mym+zyUW9zNPTp9CAkTFY5oN9KZmflxT0NmlxSJ84TbfGE1x75Lq2OIbrbcN6ItyytJnjYSnP5kfylp5ij15fXlxmXTBfoCxKoFH7ryB/7p/rb+bAve7cUG+wUakJwQjmR0JnGP15ZqIS9tjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973527; c=relaxed/simple;
	bh=BEw1FuhWBeVCXqnjsjp8lj10DaNP4Bc5Yc1ZZdmfN7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6/KCWShPP4WH3Tygt3TB1HHzgfJwN6fyry13bbjSI07hmMMeUFGUN/OKZR6DVt50/4CLXjG4gka07WSfP3JaFJaAkYlHe1d56QTdAPuSBiIfeKm+mM2ccsPbbhCrjZYV1tzz19qLai4O+1ME4QiJLHu1hGbFnvpW4O8YzfSAhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jpgXpgec; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61e8fdfd9b4so1639203a12.1
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973524; x=1757578324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JLxFb3NYbTS9f/pm1eUqTOiDM/5DBuFeeS5GZ+vjJzw=;
        b=jpgXpgecnxq+pzwy6kwvMP+XI8IsBNS3t+OFGmDFQ7AVY9D3vmbUd+3rllLh6SZN/I
         NckjZn+vNS/iAxhdL28bkptv9Yb+kAr5yZdks6D8037B9b6m7o2oBXBS/8Ypcf0xms90
         Tlghm+Hn4LbKUQn18MoCVRRJFka9acoqhWYeCnj5Oouu20dgriW3+/eup24PgAEGLDGh
         mE79KvY3vgSyCJam6WRTL7synSJPdTaRLPHR8rAhXo4rhAVLt19Te4tRC2f0dYrppWUY
         z98HaYaH0arAjwc9ioCZJSngzmmnbp2nnvoCgmJ2QsyG0F9Op6rsbRd68yRNNuLfZSce
         ptlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973524; x=1757578324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JLxFb3NYbTS9f/pm1eUqTOiDM/5DBuFeeS5GZ+vjJzw=;
        b=OkfMONqyunfCYk8PPjdU7QWHO7Fn2Mr1OtQ9c+AokLn3fhTxzmv1QYpXQ/s1KOpAve
         z0dJGE3I07zagKKZAa8273bQsS3tI6lUPjtn7PetAURJQLrdXmPyC4QNSEdrYXrFAmQG
         NKgB0DWo1C04YL3pOmGfn/jx73JuMqXQ7ykLc7I8AIMoaFQ7TQyjWYwBA3JGlI5EOg35
         fsOSQWNP85Ks6+JZwTIk8LZaNiIHAicAfhBLZlYQaG/TTiReYemYspzNoIbrX0DT1AIn
         5iNBoM1R19s+Orbz87QSm1HDlOkOA/p/buAGae1T98pdTEpCJvROYRT4HkHlPECMr+9/
         Xzpw==
X-Forwarded-Encrypted: i=1; AJvYcCU9xVXt/stF4px45oYTEfBzjzJ3gJL2xOpjvEdcEUwEFS3I8yBFGW2dky4wsAAX4wPF884=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ9Mj34S4cHygUyV5hgi9T5htaqfJ52loHxlADPc7Ai7ow6rvn
	epw3FRwFYrbCN4RrfLnstbDXzXopE22s51a93/weKZeLOAJIwFIhUU2arUwvzco4UJA=
X-Gm-Gg: ASbGncuRUUjhq7tcFlqUW+PXD7ISOttGVKoCkmIEwCU0Vhcm+HKqH7NRTrZqDW1XZbs
	qtxGLEQpOzWt2nBdMbZ7p827VrGE/U0yI9YJqIFI/fvwkBi9JoeLlZ4rEO9UfJf/rhrImRM6o8p
	CV+a2PRmb+buQBlx0/9iqZWS4ZYiwDrmQxTHP4sB7qAzX8hsC1Byf/ALSdEbBx+7yboyt4Ov1yi
	KmNK/EoE3S1bsYSv9kRJYHix9UNjaz44bTgVVIIQyHKPwQYG+6hSlfBfYvsfTpz4fLpboy+jpPF
	u+JWxxzWliPLABHRg17hLg4GVhPGi6Qeo/5gOBzByCI12lVWFMHa+3d755Hx5jh7KJCzwFgiQ7/
	bw6PFmBzlAJvLreLrkldJb7A=
X-Google-Smtp-Source: AGHT+IGCIzSs++vG4Q/r44POEQofytYBuUaIuGpsL8NKxkWgprP60aqkJ1SOMVPil+NtFGgd+q+1ug==
X-Received: by 2002:a05:6402:2356:b0:61c:e287:7ad3 with SMTP id 4fb4d7f45d1cf-61d22dfbd0emr19350555a12.6.1756973524107;
        Thu, 04 Sep 2025 01:12:04 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc216304sm12809226a12.19.2025.09.04.01.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:58 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id BE271603EE;
	Thu, 04 Sep 2025 09:11:35 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-arm@nongnu.org,
	Fam Zheng <fam@euphon.net>,
	Helge Deller <deller@gmx.de>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-rust@nongnu.org,
	Bibo Mao <maobibo@loongson.cn>,
	qemu-riscv@nongnu.org,
	Thanos Makatos <thanos.makatos@nutanix.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Cameron Esfahani <dirty@apple.com>,
	Alexander Graf <agraf@csgraf.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-ppc@nongnu.org,
	Stafford Horne <shorne@gmail.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	devel@lists.libvirt.org,
	Mads Ynddal <mads@ynddal.dk>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Peter Xu <peterx@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	qemu-block@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Kostiantyn Kostiuk <kkostiuk@redhat.com>,
	Kyle Evans <kevans@freebsd.org>,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Warner Losh <imp@bsdimp.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	John Snow <jsnow@redhat.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Alistair Francis <alistair@alistair23.me>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Yonggang Luo <luoyonggang@gmail.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-s390x@nongnu.org,
	Alex Williamson <alex.williamson@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Michael Roth <michael.roth@amd.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	John Levon <john.levon@nutanix.com>
Subject: [PATCH v2 058/281] linux-user: Move get_elf_hwcap to mips/elfload.c
Date: Thu,  4 Sep 2025 09:07:32 +0100
Message-ID: <20250904081128.1942269-59-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250904081128.1942269-1-alex.bennee@linaro.org>
References: <20250904081128.1942269-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Richard Henderson <richard.henderson@linaro.org>

Change the return type to abi_ulong, and pass in the cpu.

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
---
 linux-user/loader.h            |  2 +-
 linux-user/mips/target_elf.h   |  2 ++
 linux-user/mips64/target_elf.h |  2 ++
 linux-user/elfload.c           | 52 +---------------------------------
 linux-user/mips/elfload.c      | 50 ++++++++++++++++++++++++++++++++
 5 files changed, 56 insertions(+), 52 deletions(-)

diff --git a/linux-user/loader.h b/linux-user/loader.h
index 92b6d41145e..04457737dd4 100644
--- a/linux-user/loader.h
+++ b/linux-user/loader.h
@@ -103,7 +103,7 @@ const char *get_elf_cpu_model(uint32_t eflags);
 
 #if defined(TARGET_I386) || defined(TARGET_X86_64) || defined(TARGET_ARM) \
     || defined(TARGET_SPARC) || defined(TARGET_PPC) \
-    || defined(TARGET_LOONGARCH64)
+    || defined(TARGET_LOONGARCH64) || defined(TARGET_MIPS)
 abi_ulong get_elf_hwcap(CPUState *cs);
 abi_ulong get_elf_hwcap2(CPUState *cs);
 #endif
diff --git a/linux-user/mips/target_elf.h b/linux-user/mips/target_elf.h
index febf710c7ae..877f8347d70 100644
--- a/linux-user/mips/target_elf.h
+++ b/linux-user/mips/target_elf.h
@@ -8,4 +8,6 @@
 #ifndef MIPS_TARGET_ELF_H
 #define MIPS_TARGET_ELF_H
 
+#define HAVE_ELF_HWCAP          1
+
 #endif
diff --git a/linux-user/mips64/target_elf.h b/linux-user/mips64/target_elf.h
index 02e6d14840a..c0347e5cb6e 100644
--- a/linux-user/mips64/target_elf.h
+++ b/linux-user/mips64/target_elf.h
@@ -8,4 +8,6 @@
 #ifndef MIPS64_TARGET_ELF_H
 #define MIPS64_TARGET_ELF_H
 
+#define HAVE_ELF_HWCAP          1
+
 #endif
diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 574b37a22c1..dc3f502277a 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -834,57 +834,7 @@ static void elf_core_copy_regs(target_elf_gregset_t *regs, const CPUMIPSState *e
 #define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE        4096
 
-/* See arch/mips/include/uapi/asm/hwcap.h.  */
-enum {
-    HWCAP_MIPS_R6           = (1 << 0),
-    HWCAP_MIPS_MSA          = (1 << 1),
-    HWCAP_MIPS_CRC32        = (1 << 2),
-    HWCAP_MIPS_MIPS16       = (1 << 3),
-    HWCAP_MIPS_MDMX         = (1 << 4),
-    HWCAP_MIPS_MIPS3D       = (1 << 5),
-    HWCAP_MIPS_SMARTMIPS    = (1 << 6),
-    HWCAP_MIPS_DSP          = (1 << 7),
-    HWCAP_MIPS_DSP2         = (1 << 8),
-    HWCAP_MIPS_DSP3         = (1 << 9),
-    HWCAP_MIPS_MIPS16E2     = (1 << 10),
-    HWCAP_LOONGSON_MMI      = (1 << 11),
-    HWCAP_LOONGSON_EXT      = (1 << 12),
-    HWCAP_LOONGSON_EXT2     = (1 << 13),
-    HWCAP_LOONGSON_CPUCFG   = (1 << 14),
-};
-
-#define ELF_HWCAP get_elf_hwcap()
-
-#define GET_FEATURE_INSN(_flag, _hwcap) \
-    do { if (cpu->env.insn_flags & (_flag)) { hwcaps |= _hwcap; } } while (0)
-
-#define GET_FEATURE_REG_SET(_reg, _mask, _hwcap) \
-    do { if (cpu->env._reg & (_mask)) { hwcaps |= _hwcap; } } while (0)
-
-#define GET_FEATURE_REG_EQU(_reg, _start, _length, _val, _hwcap) \
-    do { \
-        if (extract32(cpu->env._reg, (_start), (_length)) == (_val)) { \
-            hwcaps |= _hwcap; \
-        } \
-    } while (0)
-
-static uint32_t get_elf_hwcap(void)
-{
-    MIPSCPU *cpu = MIPS_CPU(thread_cpu);
-    uint32_t hwcaps = 0;
-
-    GET_FEATURE_REG_EQU(CP0_Config0, CP0C0_AR, CP0C0_AR_LENGTH,
-                        2, HWCAP_MIPS_R6);
-    GET_FEATURE_REG_SET(CP0_Config3, 1 << CP0C3_MSAP, HWCAP_MIPS_MSA);
-    GET_FEATURE_INSN(ASE_LMMI, HWCAP_LOONGSON_MMI);
-    GET_FEATURE_INSN(ASE_LEXT, HWCAP_LOONGSON_EXT);
-
-    return hwcaps;
-}
-
-#undef GET_FEATURE_REG_EQU
-#undef GET_FEATURE_REG_SET
-#undef GET_FEATURE_INSN
+#define ELF_HWCAP get_elf_hwcap(thread_cpu)
 
 #endif /* TARGET_MIPS */
 
diff --git a/linux-user/mips/elfload.c b/linux-user/mips/elfload.c
index 04e3b767401..739f71c21b1 100644
--- a/linux-user/mips/elfload.c
+++ b/linux-user/mips/elfload.c
@@ -42,3 +42,53 @@ const char *get_elf_cpu_model(uint32_t eflags)
     return "24Kf";
 #endif
 }
+
+/* See arch/mips/include/uapi/asm/hwcap.h.  */
+enum {
+    HWCAP_MIPS_R6           = (1 << 0),
+    HWCAP_MIPS_MSA          = (1 << 1),
+    HWCAP_MIPS_CRC32        = (1 << 2),
+    HWCAP_MIPS_MIPS16       = (1 << 3),
+    HWCAP_MIPS_MDMX         = (1 << 4),
+    HWCAP_MIPS_MIPS3D       = (1 << 5),
+    HWCAP_MIPS_SMARTMIPS    = (1 << 6),
+    HWCAP_MIPS_DSP          = (1 << 7),
+    HWCAP_MIPS_DSP2         = (1 << 8),
+    HWCAP_MIPS_DSP3         = (1 << 9),
+    HWCAP_MIPS_MIPS16E2     = (1 << 10),
+    HWCAP_LOONGSON_MMI      = (1 << 11),
+    HWCAP_LOONGSON_EXT      = (1 << 12),
+    HWCAP_LOONGSON_EXT2     = (1 << 13),
+    HWCAP_LOONGSON_CPUCFG   = (1 << 14),
+};
+
+#define GET_FEATURE_INSN(_flag, _hwcap) \
+    do { if (cpu->env.insn_flags & (_flag)) { hwcaps |= _hwcap; } } while (0)
+
+#define GET_FEATURE_REG_SET(_reg, _mask, _hwcap) \
+    do { if (cpu->env._reg & (_mask)) { hwcaps |= _hwcap; } } while (0)
+
+#define GET_FEATURE_REG_EQU(_reg, _start, _length, _val, _hwcap) \
+    do { \
+        if (extract32(cpu->env._reg, (_start), (_length)) == (_val)) { \
+            hwcaps |= _hwcap; \
+        } \
+    } while (0)
+
+abi_ulong get_elf_hwcap(CPUState *cs)
+{
+    MIPSCPU *cpu = MIPS_CPU(cs);
+    abi_ulong hwcaps = 0;
+
+    GET_FEATURE_REG_EQU(CP0_Config0, CP0C0_AR, CP0C0_AR_LENGTH,
+                        2, HWCAP_MIPS_R6);
+    GET_FEATURE_REG_SET(CP0_Config3, 1 << CP0C3_MSAP, HWCAP_MIPS_MSA);
+    GET_FEATURE_INSN(ASE_LMMI, HWCAP_LOONGSON_MMI);
+    GET_FEATURE_INSN(ASE_LEXT, HWCAP_LOONGSON_EXT);
+
+    return hwcaps;
+}
+
+#undef GET_FEATURE_REG_EQU
+#undef GET_FEATURE_REG_SET
+#undef GET_FEATURE_INSN
-- 
2.47.2


