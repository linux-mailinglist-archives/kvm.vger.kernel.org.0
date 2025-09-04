Return-Path: <kvm+bounces-56794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26DB2B4353E
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:15:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 090056870D4
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C312D3745;
	Thu,  4 Sep 2025 08:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ua6ydgAF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E852D3ECA
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973536; cv=none; b=Lf87+VDwBbak2IOFofw4V4jeiTkq6P+mnfqk7uE2a+7sqYljNkI4IX/wOYauAbnznGzg9zT077NHeG/6TptsmJ/JNunIRtHsNYigpEOlw9Ia6PSg0JwcxU86goaeo0ZGMvU7eWYgpkalA97HGFVcolW+fJCLDL5/wvL4Yza2J4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973536; c=relaxed/simple;
	bh=gqXWKVZSt23LEnWU5zf0VH6+BsFAzsBScxDHndqeKjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5BXV1WGvnr9hBH45LBlAWiA11EGN+JS6vyRaoTOZYfA1+HJYdfNdtMw5DnwD1StmmE8EA36nbqSXW2Dht80tpK1EVGjlarEbyQmhULbrANMk1Og34UyKp+9GvkjQZA3AUZaL3bNu+h2N6nwxbrcYQl23d3TKsdkJYN4ctLw+O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ua6ydgAF; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b042eb09948so122999966b.3
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973533; x=1757578333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EbVn5eJ4TWHIldxY30gfc+9eY3s2xC+za4HvKYilBo=;
        b=ua6ydgAFYD5WARlC0we5olBwOqYmVdKH6DNtsJ8tYj8OFgHJsurW8nPLWROHPuu9HD
         hP50W2t4NqQnNkCN+FuNyT9Gnx1QU33/M5bwrhXH0YbQBkdoxyFCozt24Elv+EJFh30i
         0N7LCIEpTXwz6MqHGIRlBtTYvJ2NTB9gh0U+RQRWFHaokoseH/GXd3amad9rZqTXFY6x
         kZv7dQVdRmBk/hvoACdVxow8vu9ylteQOOMwoP3+ZmhuY3tXJ7TNXnSDdrEsltSRrZjF
         H0cPWNKSnsVw4PlxjgNRrL30JYdL4lWV1TFvJu/oLC8tfXDnGl3LPo7leWHPMH+piYE5
         +W1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973533; x=1757578333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6EbVn5eJ4TWHIldxY30gfc+9eY3s2xC+za4HvKYilBo=;
        b=mzHKm2O/ZjBNOfzuKH7Z7jgszkexmagrwkW7VX8LGPsgX3QancABLMcxJKnhyHpZIc
         vHOp6EB2eBsTG/lhFzAxJnutibEkQ2iLfu8OVBOyniOrOH4Krzwe2WKzZDAXP8Yhh2D7
         ZFfqVfU28C7Vb36iUZzJbIGwDZDWRqGh92y5iAtGPWK7NTyGq82s9QVcpKBgpjVeni1A
         mE4M1DoWjIUJp3mbD65WgDNRz5brAsIF+A7oZnKfJqffp+yU7KAJY8zuJCXc7lzQejJb
         N9xHAAhvQiHKZMZ6ONztCXHKeLuVqh7Qk7jUNEquOChAj1pSGdjc89DgVyOFN++Rh5ce
         AI/g==
X-Forwarded-Encrypted: i=1; AJvYcCVPzyFVUHCWbtKjiUwEuXG/rxhuJ1w65Rlfs5AXB7SPFsChiNrdgy3jUJbo81z9WdiOQ+8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwG6Dvy/PpudcewYxQYXR7ZGN9Y9n6XCXxDPGH+zKX1kXmofRbf
	i5aJ29zPjeq5hs1s7M6Lje/HdTUoYzCEh1CdmVf2Q5CNiBL9bDHzEFroY8UBGlDpvVc=
X-Gm-Gg: ASbGncto6tFD+6EO1MHaiB14CkaUFtCTuLltBv926LDfAtMhqWc4Q5V5cBB9NgCQ5ra
	788gaCw1NVgaPlzJtxDNJNk1snqRnWRfe0YLd/BB+I32XYAb5/9mW08pfVsnotZQcn9l7UZ54wk
	sSs2PQf9lcxAuvZm8wSKBsMcTO68L5um3fw9tERWomNvUGhezLVs2x9WLkWoSpXiTl3aXzRYpal
	SdC7/OwbT0jklU7npuxhyEdtd7Pvc67BzuUqc/mz2xEETRyKqZtmHMZ5eCOaOcL4QuGMglZcByt
	gfmAvkZyW1/CT8qLMD4d0W3X9nt9maO02B+V8fgEdGY9ufJmX6OU9wxAF+QHVr9B3m8bcLUc08Y
	SaNG7g+CxYBIuU6TwVpZcIhs=
X-Google-Smtp-Source: AGHT+IGE72xujCzrpuvniQ2ueJZ4x/ss9sVMxOq4r/64b7nh3Vp6WuzYsL8MWp7c3HyS0dLplsfeZA==
X-Received: by 2002:a17:907:7253:b0:af9:8438:de48 with SMTP id a640c23a62f3a-b01d978f785mr1865512266b.48.1756973533095;
        Thu, 04 Sep 2025 01:12:13 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b04190700a4sm1095117366b.63.2025.09.04.01.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:12:10 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id F184860AED;
	Thu, 04 Sep 2025 09:11:38 +0100 (BST)
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
Subject: [PATCH v2 084/281] linux-user/m68k: Create init_main_thread
Date: Thu,  4 Sep 2025 09:07:58 +0100
Message-ID: <20250904081128.1942269-85-alex.bennee@linaro.org>
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

Merge init_thread and target_cpu_copy_regs.
There's no point going through a target_pt_regs intermediate.

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
---
 linux-user/elfload.c       | 11 +----------
 linux-user/m68k/cpu_loop.c | 25 ++++++-------------------
 2 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 8604308a310..46150586aff 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -746,16 +746,7 @@ static inline void elf_core_copy_regs(target_elf_gregset_t *regs,
 #define ELF_CLASS       ELFCLASS32
 #define ELF_ARCH        EM_68K
 
-/* ??? Does this need to do anything?
-   #define ELF_PLAT_INIT(_r) */
-
-static inline void init_thread(struct target_pt_regs *regs,
-                               struct image_info *infop)
-{
-    regs->usp = infop->start_stack;
-    regs->sr = 0;
-    regs->pc = infop->entry;
-}
+#define HAVE_INIT_MAIN_THREAD
 
 /* See linux kernel: arch/m68k/include/asm/elf.h.  */
 #define ELF_NREG 20
diff --git a/linux-user/m68k/cpu_loop.c b/linux-user/m68k/cpu_loop.c
index 23693f33582..aca0bf23dc6 100644
--- a/linux-user/m68k/cpu_loop.c
+++ b/linux-user/m68k/cpu_loop.c
@@ -92,24 +92,11 @@ void cpu_loop(CPUM68KState *env)
     }
 }
 
-void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
+void init_main_thread(CPUState *cs, struct image_info *info)
 {
-    env->pc = regs->pc;
-    env->dregs[0] = regs->d0;
-    env->dregs[1] = regs->d1;
-    env->dregs[2] = regs->d2;
-    env->dregs[3] = regs->d3;
-    env->dregs[4] = regs->d4;
-    env->dregs[5] = regs->d5;
-    env->dregs[6] = regs->d6;
-    env->dregs[7] = regs->d7;
-    env->aregs[0] = regs->a0;
-    env->aregs[1] = regs->a1;
-    env->aregs[2] = regs->a2;
-    env->aregs[3] = regs->a3;
-    env->aregs[4] = regs->a4;
-    env->aregs[5] = regs->a5;
-    env->aregs[6] = regs->a6;
-    env->aregs[7] = regs->usp;
-    env->sr = regs->sr;
+    CPUArchState *env = cpu_env(cs);
+
+    env->pc = info->entry;
+    env->aregs[7] = info->start_stack;
+    env->sr = 0;
 }
-- 
2.47.2


