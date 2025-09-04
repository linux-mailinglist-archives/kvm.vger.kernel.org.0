Return-Path: <kvm+bounces-56787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C859B43537
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8F201C26CE0
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DAFC2D3204;
	Thu,  4 Sep 2025 08:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GMH79qoP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A8F2D239F
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973523; cv=none; b=cj4GC6Zk/0aiUhoMP/2uWwlB8rQ3n3yQ2eCQPX61Pn5jdlFx7shUSUSuHpRPn5gaZO9qE1UiAQiOsisr586jKIS/luL+mqjNT2CeuAq5L9dgX9yyiRx2yTm+YDEyNIccYrpWpeq8g8FJ1zaDmnoF5FM+CY7XgMMHEab7gu7SnSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973523; c=relaxed/simple;
	bh=ds+tcWZhl3qNw2U3ZWzgwTiRQDc02aoniF0oXcthNyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWc4REVoOlGI5/3IKAdyXshodSIXKCt5DngLHvj79IhUsZ0Pn7GR8a50erveTvk9wAsLKFGsO2W1amwoesgkuXwiKVJiTlisc90nPW1STb+hrwFScgAvbajwG0hoblzz5d15bE/WkiH9NnmSuA+CuVqzZw0iI8IS45gfxuYh/bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GMH79qoP; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b0418f6fc27so103936066b.3
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973519; x=1757578319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TRlsHGqvmjF2Vf3U8TOAt/9n2Jks0amzBlUrbfofXWc=;
        b=GMH79qoPghTsIvily5FlREOh4n48D/t0m9iS+NXqW34aMiP3IlNkR8q9Qr9hjeIowI
         NuZKsvPhJRObp9UW47GOXYP7z6/lSTrv0ORtlNAxzpc9WjWB2G+0hyUYnDtSUTdpp8lj
         qhlbq68vwLbRc8oW1FwotzG+5JQJdrc7reOIAsN13h08D65ddJPRQiJp0h54zWSsPeY/
         QrXNLsqd2VK4uXTwTgxSZhWqQ9sjvStIzV1sRnNWwS0m2b4QHeJU9mSH+Tvy0hkdXO8J
         K9oGC/vT1vtVdWM4TIDIYo/ScJmQGkN2jehgG6nJON/xjNgAUWF7JITPRg4309pIB0e/
         sbSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973519; x=1757578319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TRlsHGqvmjF2Vf3U8TOAt/9n2Jks0amzBlUrbfofXWc=;
        b=SijqyT0I/v2pJdeYvAjRVdJXSrfzF91ZOPdIf2iYxuMl8biPJPt0dXtGurDow7gd5N
         buVVz66m4P3RinXeHYyHXAiDpOF8uoLC+8x33ZzSUvzgmGbcpmtlFUwAj1wd7OqM0aCQ
         QianVN/jxRiQX6haNOhvshfCs8qjIAfehcli9ZbrvDoAulZqMxwwxVcaq40pcIGkqc55
         lMwjDmcLSo5BgzdwLXjfbI6hixMwH+a3FWboxofr1WSp2ytQqRTJ4FQtrxP4W4u5U4ID
         7k671SR1qBKhya+oqFgc5V0y2mymQAVd7Xodmc7vOxNkYpgMT2JZkKTWfq7GVIBrhZCb
         HjTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDVoIZOVRoBCOAaoYgAg5GXzGWAp8Q6aEAEuEG+VnE6UFVoWtg9uiTtqLrin3aPCR2KHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIsQYKy2MOH+te5u+LS3I35WQpj+2fOeLzm+dAZMGnTyCMyRXe
	CxVT1e6t1qZuYjQvcsBJUckOj3kc3EY1uqpC5CR1FOPfAUA2QTejk4JIAxOPtz6mDEA=
X-Gm-Gg: ASbGncsl+wVu3Y7SQS+Q58yZVquMLsEhe6foO93EPc75v3bWly4+TZq+qLY9VziYUOD
	at1G+tKmx9NRFbRYiDnw+BrhhJA2MJvLxrXmzDH49dVR4tqiazE4JP9IKAL7w0qj+F9xtbPHaaC
	DmQVccEajda52CCHP7OWzBQIQ8EiyLI7jYKQXG/j9207QUJJ9CjO9r5CzqL8Rh8eNHhjWvz2O1P
	GQrbkU59ZiuD+DuPbaq0ERehxeVuoPek6SmUCWtuGuUiRLjCAytcOMLyfLFHwntj1MBZ3oUOv1b
	9ny0CZeJJP3z6Pzmi5EK5NQzaUgvlPqGye0DAOnPWJRK/rORhlIuV3R5vnu4crvAq4gHw7tdyA9
	8GpEcr2nIiIo2LRn+57aAYik=
X-Google-Smtp-Source: AGHT+IHiB61XSQJ8aB9kXr4pJ7kTktTaOCm5+fM0Vksx2NmfVFmOxv3vcmFjV8pk0rEQY7r1+KjTyw==
X-Received: by 2002:a17:907:3cca:b0:b04:354e:47a5 with SMTP id a640c23a62f3a-b04354e4b78mr1354661066b.17.1756973519415;
        Thu, 04 Sep 2025 01:11:59 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0432937d7esm869790666b.17.2025.09.04.01.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:55 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 9C0DE60363;
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
Subject: [PATCH v2 057/281] linux-user: Move get_elf_hwcap to loongarch64/elfload.c
Date: Thu,  4 Sep 2025 09:07:31 +0100
Message-ID: <20250904081128.1942269-58-alex.bennee@linaro.org>
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
 linux-user/loader.h                 |  3 +-
 linux-user/loongarch64/target_elf.h |  2 ++
 linux-user/elfload.c                | 49 +----------------------------
 linux-user/loongarch64/elfload.c    | 47 +++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 49 deletions(-)

diff --git a/linux-user/loader.h b/linux-user/loader.h
index 818c5e6d7d7..92b6d41145e 100644
--- a/linux-user/loader.h
+++ b/linux-user/loader.h
@@ -102,7 +102,8 @@ extern unsigned long guest_stack_size;
 const char *get_elf_cpu_model(uint32_t eflags);
 
 #if defined(TARGET_I386) || defined(TARGET_X86_64) || defined(TARGET_ARM) \
-    || defined(TARGET_SPARC) || defined(TARGET_PPC)
+    || defined(TARGET_SPARC) || defined(TARGET_PPC) \
+    || defined(TARGET_LOONGARCH64)
 abi_ulong get_elf_hwcap(CPUState *cs);
 abi_ulong get_elf_hwcap2(CPUState *cs);
 #endif
diff --git a/linux-user/loongarch64/target_elf.h b/linux-user/loongarch64/target_elf.h
index 39a08d35d9b..037740d36f2 100644
--- a/linux-user/loongarch64/target_elf.h
+++ b/linux-user/loongarch64/target_elf.h
@@ -6,4 +6,6 @@
 #ifndef LOONGARCH_TARGET_ELF_H
 #define LOONGARCH_TARGET_ELF_H
 
+#define HAVE_ELF_HWCAP          1
+
 #endif
diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 843b1f7b6cc..574b37a22c1 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -725,54 +725,7 @@ static void elf_core_copy_regs(target_elf_gregset_t *regs,
 #define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE        4096
 
-#define ELF_HWCAP get_elf_hwcap()
-
-/* See arch/loongarch/include/uapi/asm/hwcap.h */
-enum {
-    HWCAP_LOONGARCH_CPUCFG   = (1 << 0),
-    HWCAP_LOONGARCH_LAM      = (1 << 1),
-    HWCAP_LOONGARCH_UAL      = (1 << 2),
-    HWCAP_LOONGARCH_FPU      = (1 << 3),
-    HWCAP_LOONGARCH_LSX      = (1 << 4),
-    HWCAP_LOONGARCH_LASX     = (1 << 5),
-    HWCAP_LOONGARCH_CRC32    = (1 << 6),
-    HWCAP_LOONGARCH_COMPLEX  = (1 << 7),
-    HWCAP_LOONGARCH_CRYPTO   = (1 << 8),
-    HWCAP_LOONGARCH_LVZ      = (1 << 9),
-    HWCAP_LOONGARCH_LBT_X86  = (1 << 10),
-    HWCAP_LOONGARCH_LBT_ARM  = (1 << 11),
-    HWCAP_LOONGARCH_LBT_MIPS = (1 << 12),
-};
-
-static uint32_t get_elf_hwcap(void)
-{
-    LoongArchCPU *cpu = LOONGARCH_CPU(thread_cpu);
-    uint32_t hwcaps = 0;
-
-    hwcaps |= HWCAP_LOONGARCH_CRC32;
-
-    if (FIELD_EX32(cpu->env.cpucfg[1], CPUCFG1, UAL)) {
-        hwcaps |= HWCAP_LOONGARCH_UAL;
-    }
-
-    if (FIELD_EX32(cpu->env.cpucfg[2], CPUCFG2, FP)) {
-        hwcaps |= HWCAP_LOONGARCH_FPU;
-    }
-
-    if (FIELD_EX32(cpu->env.cpucfg[2], CPUCFG2, LAM)) {
-        hwcaps |= HWCAP_LOONGARCH_LAM;
-    }
-
-    if (FIELD_EX32(cpu->env.cpucfg[2], CPUCFG2, LSX)) {
-        hwcaps |= HWCAP_LOONGARCH_LSX;
-    }
-
-    if (FIELD_EX32(cpu->env.cpucfg[2], CPUCFG2, LASX)) {
-        hwcaps |= HWCAP_LOONGARCH_LASX;
-    }
-
-    return hwcaps;
-}
+#define ELF_HWCAP get_elf_hwcap(thread_cpu)
 
 #define ELF_PLATFORM "loongarch"
 
diff --git a/linux-user/loongarch64/elfload.c b/linux-user/loongarch64/elfload.c
index 874dc4c2304..ee4a85b8d6c 100644
--- a/linux-user/loongarch64/elfload.c
+++ b/linux-user/loongarch64/elfload.c
@@ -9,3 +9,50 @@ const char *get_elf_cpu_model(uint32_t eflags)
 {
     return "la464";
 }
+
+/* See arch/loongarch/include/uapi/asm/hwcap.h */
+enum {
+    HWCAP_LOONGARCH_CPUCFG   = (1 << 0),
+    HWCAP_LOONGARCH_LAM      = (1 << 1),
+    HWCAP_LOONGARCH_UAL      = (1 << 2),
+    HWCAP_LOONGARCH_FPU      = (1 << 3),
+    HWCAP_LOONGARCH_LSX      = (1 << 4),
+    HWCAP_LOONGARCH_LASX     = (1 << 5),
+    HWCAP_LOONGARCH_CRC32    = (1 << 6),
+    HWCAP_LOONGARCH_COMPLEX  = (1 << 7),
+    HWCAP_LOONGARCH_CRYPTO   = (1 << 8),
+    HWCAP_LOONGARCH_LVZ      = (1 << 9),
+    HWCAP_LOONGARCH_LBT_X86  = (1 << 10),
+    HWCAP_LOONGARCH_LBT_ARM  = (1 << 11),
+    HWCAP_LOONGARCH_LBT_MIPS = (1 << 12),
+};
+
+abi_ulong get_elf_hwcap(CPUState *cs)
+{
+    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
+    abi_ulong hwcaps = 0;
+
+    hwcaps |= HWCAP_LOONGARCH_CRC32;
+
+    if (FIELD_EX32(cpu->env.cpucfg[1], CPUCFG1, UAL)) {
+        hwcaps |= HWCAP_LOONGARCH_UAL;
+    }
+
+    if (FIELD_EX32(cpu->env.cpucfg[2], CPUCFG2, FP)) {
+        hwcaps |= HWCAP_LOONGARCH_FPU;
+    }
+
+    if (FIELD_EX32(cpu->env.cpucfg[2], CPUCFG2, LAM)) {
+        hwcaps |= HWCAP_LOONGARCH_LAM;
+    }
+
+    if (FIELD_EX32(cpu->env.cpucfg[2], CPUCFG2, LSX)) {
+        hwcaps |= HWCAP_LOONGARCH_LSX;
+    }
+
+    if (FIELD_EX32(cpu->env.cpucfg[2], CPUCFG2, LASX)) {
+        hwcaps |= HWCAP_LOONGARCH_LASX;
+    }
+
+    return hwcaps;
+}
-- 
2.47.2


