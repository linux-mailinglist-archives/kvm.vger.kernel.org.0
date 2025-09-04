Return-Path: <kvm+bounces-56801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6BDB4356B
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:18:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81ACF171A93
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F5A2C11E7;
	Thu,  4 Sep 2025 08:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="orTnXy9i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE042BDC13
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973922; cv=none; b=iBiKnKi6htV+q47udmb6SAu9nv+ilUXPRiUJSYkQcutMb3Is1FSpo15gt3fCck2NUFCOwVhD4tQYT4FeplPANCbjsFOr66SSSJ3pjP6dJ+iROE4v7sOuOdFlZLRGrhcc2IMmF8OWauAy1+D+v0giIYpqygarIz89jrz0mnNPZxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973922; c=relaxed/simple;
	bh=hxeIfx20g7cYcGNYqYWaBdGJWYym53wbjhT65dexDS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frxGzFOjlRPjZUFl86hoLsFJg3vhzbJah0DaC/1OyU/E+8UfWQwSer2Jnds0LiGRe7e6B0clCh+VsWN0zwioyQmbWdcTpJmyKWJsyoV2ZMPk4Z8ENpgcaZWnrNHqYjaHtR8VFrXmfU3cbrLz491akrtYVhjU3MK321ilZMa9zoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=orTnXy9i; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b047f28a83dso81487566b.2
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973918; x=1757578718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTwVN2pdB6APtd4vJTidA71Ye17u96MfvC5vKsLhS50=;
        b=orTnXy9il2OgQup3RyFDjJoK2F462TVKe9ja4nrmquRhl39xhywVzVngOtbWcxtV9e
         9qnT4Br/yiRJNAIb0JUk9z6qoA8eiMQYUol249AYBJ9xN3tmyp7nA6CiBfxcIzBFhiG9
         marAzrLbIalTnfyQkmd7wzWNZ8A0fVn/r2CcDdquTUTsHvwn2kf53+gcMM4lyE+C136F
         ILvdd4zaykSe3YM/cvXUJ0uehFss+tog+GkqX6qVC0O13vMjS/DOjUJd6PPGJICs7cag
         Xzas/zuBS+CRRUTYC5Fa8xCL5mZGoaAkSVxo8hSn2QXkj4h8WI06dbuA15AN1ip2BKfT
         DOwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973918; x=1757578718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fTwVN2pdB6APtd4vJTidA71Ye17u96MfvC5vKsLhS50=;
        b=K0mWOh0HWAcvEU4j2boE58CuM1BI4xWdZGcWYweogHjG/wR3ZzQqPSYfsB8kvt+Eeo
         TmIZKd0euxzhWRcNca3V7GztvAJsiwWrgsLtYmJ7z8sb6X//bqnoED6s0kfINCvz1g6O
         XAD+DpcFmAmm/V5GAczHcRUChF4Tc3yYGA0DcUStOpL6rp6RZ+9Pw3XJb/n4DeOoe6HW
         s4gBY3YjdOtRfxdB10ghAm6uSDParejc41rj+yc/i8L8bLCOlw0P07CokxFWHfMKI5Bj
         81q4GCgE5BU5JlnYn9NG3vKezQy5fD4NeeQEsSGx9UB0epKKoq9R4g+bvjCtEyOwLCrN
         dmXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbI/rm6mv/l452vDXwFFta0jR6FLWaiBW8GA+puvNMC9e1UOR4wFc+lN5Rf4MY2TC2bGA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxD6LtdyG4VNcGhb68Ed2WGeu0XRUNrxojshn9XWAHT+lDEX9Te
	o3GwZmfqi81QdM68SP27iUrWwthwbWZ7wbtMWNYdSJFdpDuv6lZil0fo+r9r02vxnsw=
X-Gm-Gg: ASbGncvmNimXqlrCmN9kvcEdTLA4dfT/GSCbA4h/mxiYXCZxgF/55kV930sIQ7/WrvL
	udnPsWAqZ8Or4RqkMCO5w8/Oso3DZWDNjS9g67XCyFvuNwMVykvnZX6s2mvY3rnGW7OtpuFdCZx
	JiM6XQ4VZqLeScyUirGx1QbUZeTq4H8b7WPJ5Z/6Id8w3v5XrbkAOLnEX7okM9Ou6U9bsbQI5u/
	sZs926EyuUtK9erS0GhOhbzebQUfUQdoZpp5qWcbKh+/gL7OUwyC/uz9spEkak06jPR4esrvm8X
	VdhXWZJger7mBBJY9AeIsBXXfb4Tokaz1AiUsIILvSF1kOYXG7q2sRJTzetIXtTkfQBuE8+aNDE
	d0Qe9NdAUts1U3w5MnG3OCJeFJD5M0z2H2Q==
X-Google-Smtp-Source: AGHT+IF1g0xPlQZwXvixbktzxWp7pylp9yJpF3ozVocEpxZl4vhVy/vLrP8CDNUZO12I//3cD7pawA==
X-Received: by 2002:a17:907:7e86:b0:afe:ad18:8662 with SMTP id a640c23a62f3a-b01d8c74c8emr1897318666b.23.1756973918422;
        Thu, 04 Sep 2025 01:18:38 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aff12a6b404sm1396323866b.88.2025.09.04.01.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:18:37 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 5CC61601C5;
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
Subject: [PATCH v2 055/281] linux-user: Move get_elf_hwcap to sparc/elfload.c
Date: Thu,  4 Sep 2025 09:07:29 +0100
Message-ID: <20250904081128.1942269-56-alex.bennee@linaro.org>
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
 linux-user/loader.h           |  3 ++-
 linux-user/sparc/target_elf.h |  2 ++
 linux-user/elfload.c          | 30 +-----------------------------
 linux-user/sparc/elfload.c    | 27 +++++++++++++++++++++++++++
 4 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/linux-user/loader.h b/linux-user/loader.h
index 151a06f5db5..2c8414e0e53 100644
--- a/linux-user/loader.h
+++ b/linux-user/loader.h
@@ -101,7 +101,8 @@ extern unsigned long guest_stack_size;
 /* Note that Elf32 and Elf64 use uint32_t for e_flags. */
 const char *get_elf_cpu_model(uint32_t eflags);
 
-#if defined(TARGET_I386) || defined(TARGET_X86_64) || defined(TARGET_ARM)
+#if defined(TARGET_I386) || defined(TARGET_X86_64) || defined(TARGET_ARM) \
+    || defined(TARGET_SPARC)
 abi_ulong get_elf_hwcap(CPUState *cs);
 abi_ulong get_elf_hwcap2(CPUState *cs);
 #endif
diff --git a/linux-user/sparc/target_elf.h b/linux-user/sparc/target_elf.h
index 7e46748d261..b7544db0a1c 100644
--- a/linux-user/sparc/target_elf.h
+++ b/linux-user/sparc/target_elf.h
@@ -8,4 +8,6 @@
 #ifndef SPARC_TARGET_ELF_H
 #define SPARC_TARGET_ELF_H
 
+#define HAVE_ELF_HWCAP          1
+
 #endif
diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 149d1313c0a..16709865f78 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -565,35 +565,7 @@ static void elf_core_copy_regs(target_elf_gregset_t *regs,
 # define ELF_ARCH   EM_SPARCV9
 #endif
 
-#include "elf.h"
-
-#define ELF_HWCAP get_elf_hwcap()
-
-static uint32_t get_elf_hwcap(void)
-{
-    /* There are not many sparc32 hwcap bits -- we have all of them. */
-    uint32_t r = HWCAP_SPARC_FLUSH | HWCAP_SPARC_STBAR |
-                 HWCAP_SPARC_SWAP | HWCAP_SPARC_MULDIV;
-
-#ifdef TARGET_SPARC64
-    CPUSPARCState *env = cpu_env(thread_cpu);
-    uint32_t features = env->def.features;
-
-    r |= HWCAP_SPARC_V9 | HWCAP_SPARC_V8PLUS;
-    /* 32x32 multiply and divide are efficient. */
-    r |= HWCAP_SPARC_MUL32 | HWCAP_SPARC_DIV32;
-    /* We don't have an internal feature bit for this. */
-    r |= HWCAP_SPARC_POPC;
-    r |= features & CPU_FEATURE_FSMULD ? HWCAP_SPARC_FSMULD : 0;
-    r |= features & CPU_FEATURE_VIS1 ? HWCAP_SPARC_VIS : 0;
-    r |= features & CPU_FEATURE_VIS2 ? HWCAP_SPARC_VIS2 : 0;
-    r |= features & CPU_FEATURE_FMAF ? HWCAP_SPARC_FMAF : 0;
-    r |= features & CPU_FEATURE_VIS3 ? HWCAP_SPARC_VIS3 : 0;
-    r |= features & CPU_FEATURE_IMA ? HWCAP_SPARC_IMA : 0;
-#endif
-
-    return r;
-}
+#define ELF_HWCAP get_elf_hwcap(thread_cpu)
 
 static inline void init_thread(struct target_pt_regs *regs,
                                struct image_info *infop)
diff --git a/linux-user/sparc/elfload.c b/linux-user/sparc/elfload.c
index 243e6f9b66a..32ca1b05b1a 100644
--- a/linux-user/sparc/elfload.c
+++ b/linux-user/sparc/elfload.c
@@ -3,6 +3,7 @@
 #include "qemu/osdep.h"
 #include "qemu.h"
 #include "loader.h"
+#include "elf.h"
 
 
 const char *get_elf_cpu_model(uint32_t eflags)
@@ -13,3 +14,29 @@ const char *get_elf_cpu_model(uint32_t eflags)
     return "Fujitsu MB86904";
 #endif
 }
+
+abi_ulong get_elf_hwcap(CPUState *cs)
+{
+    /* There are not many sparc32 hwcap bits -- we have all of them. */
+    uint32_t r = HWCAP_SPARC_FLUSH | HWCAP_SPARC_STBAR |
+                 HWCAP_SPARC_SWAP | HWCAP_SPARC_MULDIV;
+
+#ifdef TARGET_SPARC64
+    CPUSPARCState *env = cpu_env(cs);
+    uint32_t features = env->def.features;
+
+    r |= HWCAP_SPARC_V9 | HWCAP_SPARC_V8PLUS;
+    /* 32x32 multiply and divide are efficient. */
+    r |= HWCAP_SPARC_MUL32 | HWCAP_SPARC_DIV32;
+    /* We don't have an internal feature bit for this. */
+    r |= HWCAP_SPARC_POPC;
+    r |= features & CPU_FEATURE_FSMULD ? HWCAP_SPARC_FSMULD : 0;
+    r |= features & CPU_FEATURE_VIS1 ? HWCAP_SPARC_VIS : 0;
+    r |= features & CPU_FEATURE_VIS2 ? HWCAP_SPARC_VIS2 : 0;
+    r |= features & CPU_FEATURE_FMAF ? HWCAP_SPARC_FMAF : 0;
+    r |= features & CPU_FEATURE_VIS3 ? HWCAP_SPARC_VIS3 : 0;
+    r |= features & CPU_FEATURE_IMA ? HWCAP_SPARC_IMA : 0;
+#endif
+
+    return r;
+}
-- 
2.47.2


