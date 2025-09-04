Return-Path: <kvm+bounces-56804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E5FCB4356E
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:19:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AD49188334B
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A5892C11CF;
	Thu,  4 Sep 2025 08:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U+AuvpzN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4C02C11F6
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973925; cv=none; b=seKEiRGM1ctL9JIqV5OYWQ4wjsBTHJxhh4RuDg5rD2uLcX3oK3rhUEkgSbX4GndyH9OF/Cbp7J6aG0hgXo0nfAd0ILqpLrkS5Y0hbnBCUzbVgfq0PVvWnzL4Uw2ZKClqvu8PY92r1pbMfICTN8xJvHMJkZlYERO7Szq/MHMc/ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973925; c=relaxed/simple;
	bh=Ce7Nj9k0E9dcQQLbID9KlUYhNtKU/RoRR6PHZXUoaiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqapbK/PczyIG51WbndAwPfLN07BCTboqb1losMAS8zX2pzMR/nuLeUUDjZYW2IP/WHomNIPcc2wkKXVcxmqUNeMbBd1WRZ6+O+7iIdgw1QoXa8M6Um/0xAZE0PtO5Vg0JrmpoqrpOsvfcDzPGCRYtDKmIGICERWOI8E4jbo9L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U+AuvpzN; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b03fa5c5a89so108098166b.2
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973922; x=1757578722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Qo9EKDwE3/n/WLrIsObXlhp0emB+zNEnQk4ZCSW4aE=;
        b=U+AuvpzNTzdrSCuCeIA3R5/BibBQiJjNUoX0odndDIoq6f+AtgBUHHb0+PNso/6ckQ
         bv06UTS9SMbw+LWQFnyjtCiHTL5W/oi72K06c/4ss3/xG9tLzJvJ8QvIjoZkz+syLRjp
         Cua3LA3Q2JxoTJIBa+jcOlVU3l3jU50T8c35c3R7X3hk+Olin7NidRtnAm/4eykl6LBg
         QgHt/bYV8RnFzMfVqzliP6c3jZrCVbV+JNVJ1fbYtk6R0lzLgpADSrUzf96+0ghJ1QMq
         NmNPCwQ2TL8gW6nIkbsP34VjPe8wpEwl0B9wrII4GHxli4UlmntQpiwGL1vml0We3Q4k
         Hm0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973922; x=1757578722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Qo9EKDwE3/n/WLrIsObXlhp0emB+zNEnQk4ZCSW4aE=;
        b=CGgxZHvsAbUMjBfJVubR3P5SceYg7JDByRGonOx1tx0VX1Xq3GRmqgVMJLg2kpXxy4
         RNwlayntYg7jPOvCdsuoThkfDk7phGHl1iPFq7Fog/SF/LpwLk1Za54c0tZZ0a1+z+cz
         HvZZyYRAZp/LPLZnsYHlQ7ubyDI8RAzCPpwuMkEvLTtC5WVYFWFyNpcNi+pcT0moXFe2
         N9o87WbIeFHF3U5TQU218bUNHCPouCPOCLByL+Lr/UkaOiB/pPqYRzL32pX64MJp41fY
         lxXze+u1785vUD15/OR22cZ7ypHuni9HHyik0/CASLWEYUDvcZsuwT4MJjUuQj/nLxE5
         8Yog==
X-Forwarded-Encrypted: i=1; AJvYcCU3JLp0aXrQC5BiL/fueVH1LmJSx4ERkViWoHUlPyYKJpKWPua9EutIxKG4xY/cxcIiTRI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9ZU9U6+GRaj/hnlAylB2SRChbpNzRviCCSCXQZxwJcF33KQtz
	qiPkKUTfjsd6CN3IPiDWnbhmUIAuDR/Mn78wvrc9dJ3hPFl0qzp4ZU8wljvEm72duRc=
X-Gm-Gg: ASbGncui84+rIzMOZ3DnGgF4JvYPqrAZ7iGLEvH+ZSt3K532IMSSvnRItvBTHZ+btxR
	4L6ySqDmNC/8qdmyGwKL1EqFBB7OTb4qduC1UGqcKb5nlxw2ac41U1eKj1tAUo3fvX0+i+iU51O
	HbEvAIsdk8J1vLWH8Iza1QjkhaoVnme8ZLx53mx8j4qbQW4ycs8hcTKW1/mFcBlvyW2GGQbZFnG
	pv402JHWKFpY2cu0ndnfWgr9ct6a6snrXFzbMQTtfhi8QwyIVyLeZAPqX4jWk8YMaKU9I9yM1Hm
	XWM5HeQw8TXMhLIf84Hqs1Qma3GKebmoey2no/Bx0FLXNp2Tfv7eJUKch/tqU4XvwpzVZR9RX31
	8PlBuCY6FQ4btkepoo3mrQmmf1CbnxubRww==
X-Google-Smtp-Source: AGHT+IH72PsAQjSge09/VEswdIRor8b+s0ivH0yVqM4TiBV9FovWzP9bspcPBbf4+HVqFBF5NwAp4Q==
X-Received: by 2002:a17:907:7245:b0:b04:76ed:3ff5 with SMTP id a640c23a62f3a-b0476ed442bmr339748766b.40.1756973921478;
        Thu, 04 Sep 2025 01:18:41 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b04634dbd5csm417619266b.19.2025.09.04.01.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:18:37 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 2C5BA60A38;
	Thu, 04 Sep 2025 09:11:37 +0100 (BST)
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
Subject: [PATCH v2 069/281] linux-user: Remove ELF_PLATFORM
Date: Thu,  4 Sep 2025 09:07:43 +0100
Message-ID: <20250904081128.1942269-70-alex.bennee@linaro.org>
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

All real definitions of ELF_PLATFORM are now identical, and the stub
definitions are NULL.  Use HAVE_ELF_PLATFORM and provide a stub as a
fallback definition of get_elf_platform.

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
---
 linux-user/elfload.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 83cb6731ec8..d2d73b06fc0 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -149,8 +149,6 @@ typedef abi_int         target_pid_t;
 
 #ifdef TARGET_I386
 
-#define ELF_PLATFORM get_elf_platform(thread_cpu)
-
 #ifdef TARGET_X86_64
 #define ELF_CLASS      ELFCLASS64
 #define ELF_ARCH       EM_X86_64
@@ -309,8 +307,6 @@ static void elf_core_copy_regs(target_elf_gregset_t *regs, const CPUX86State *en
 
 #ifdef TARGET_ARM
 
-#define ELF_PLATFORM get_elf_platform(thread_cpu)
-
 #ifndef TARGET_AARCH64
 /* 32 bit ARM definitions */
 
@@ -665,8 +661,6 @@ static void elf_core_copy_regs(target_elf_gregset_t *regs,
 #define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE        4096
 
-#define ELF_PLATFORM get_elf_platform(thread_cpu)
-
 #endif /* TARGET_LOONGARCH64 */
 
 #ifdef TARGET_MIPS
@@ -846,8 +840,6 @@ static void elf_core_copy_regs(target_elf_gregset_t *regs,
     (*regs)[33] = tswapreg(cpu_get_sr(env));
 }
 
-#define ELF_PLATFORM NULL
-
 #endif /* TARGET_OPENRISC */
 
 #ifdef TARGET_SH4
@@ -1046,7 +1038,6 @@ static inline void init_thread(struct target_pt_regs *regs,
 
 #define ELF_CLASS       ELFCLASS32
 #define ELF_ARCH        EM_PARISC
-#define ELF_PLATFORM    get_elf_platform(thread_cpu)
 #define STACK_GROWS_DOWN 0
 #define STACK_ALIGNMENT  64
 
@@ -1182,10 +1173,6 @@ static inline void init_thread(struct target_pt_regs *regs,
 #define ELF_BASE_PLATFORM (NULL)
 #endif
 
-#ifndef ELF_PLATFORM
-#define ELF_PLATFORM (NULL)
-#endif
-
 #ifndef ELF_MACHINE
 #define ELF_MACHINE ELF_ARCH
 #endif
@@ -1229,6 +1216,9 @@ abi_ulong get_elf_hwcap(CPUState *cs) { return 0; }
 abi_ulong get_elf_hwcap2(CPUState *cs) { g_assert_not_reached(); }
 #define HAVE_ELF_HWCAP2 0
 #endif
+#ifndef HAVE_ELF_PLATFORM
+const char *get_elf_platform(CPUState *cs) { return NULL; }
+#endif
 
 #include "elf.h"
 
@@ -1699,7 +1689,7 @@ static abi_ulong create_elf_tables(abi_ulong p, int argc, int envc,
     }
 
     u_platform = 0;
-    k_platform = ELF_PLATFORM;
+    k_platform = get_elf_platform(thread_cpu);
     if (k_platform) {
         size_t len = strlen(k_platform) + 1;
         if (STACK_GROWS_DOWN) {
-- 
2.47.2


