Return-Path: <kvm+bounces-56791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0CDB4353D
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C25241C83780
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10CA62D3756;
	Thu,  4 Sep 2025 08:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jM0aEvcU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB362C0F95
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973532; cv=none; b=ldaNJQ13aTK3+0TzSY/YW4ysyykXakTbiRLzwCZih2cUyVQcO4xNNNjL35bq/qFBg6S1o/8ydggyUg8YBXAXGVlWfs+nA7v6UUg0pj9pu3cqhHcolfiUYsiN3QvH7hn4n6meti4ipl3SJ9ZzXx2Ji6oOvRyADfm+yL2rueC0yuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973532; c=relaxed/simple;
	bh=86qax4iskeRy1MsvuxSDiAUgfweBfKrMbbGNI40Er+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4Z6qObrgnEiUEzEZ19UhtipVEFeAISGu4P5sGqgxu4r7FZEzr0JDsd5424jvzFkXw0hFW6oR3bOqbuC+SMmGl9bTXY6q1oaSyh5Gvf3F+iwozyKv9yeoiMScATK6qPCKQwG3sPc5tHcEGyAXN4wIaUCuew+iV9OAZnR2wYyWH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jM0aEvcU; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-61cd6089262so1203900a12.3
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973529; x=1757578329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nJY1IlIgq7GGkBP3hhYu6s36xjwpVbPeSOjHkNAYnEM=;
        b=jM0aEvcUfO5KjRHBJbYIni3OMKxhgXgpXBthQF2JVp/qqLdsAC87e0dI12AMv7bF/a
         vy6gXScVTUKi/yZ+66wQBU8M0qnZdROulHFfZdl0IKlahd7+CnhvfTB0Sxrc7ICsBooL
         hfG5vkP+sNpaozww26NUHgiRwaiVcMZNlsJKcF4itQ/TX6O+Bz9VxcWFYDIRdUGumlZk
         8CHiVvZQIVPxHABA0IKYVj8jK/9hl/UYLtLSbZLo8R265qBus/H0ViecrJIpeU27CAxw
         4IVEUobgYwEVrrgY+dcbKWn7Cobjoz81R5oIcZ/ylnXa+U6MhA/oja49S45m8SOnKVvC
         SpSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973529; x=1757578329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nJY1IlIgq7GGkBP3hhYu6s36xjwpVbPeSOjHkNAYnEM=;
        b=s5EsXmCLWR2cQSpSs9ACTVAea11mVGx3nzP4Lbtkj0Gx8YYjYzyvyhmznLd3baKcTe
         RxR5/B6x8fbu0Iooc3Klphdi/Ybq5FxHuo/soGUPkOpite8dK8KMaUE9Wr9nUEYQ4hro
         CbvPifDUCkI+zSJMG9395jUvwXoTk1lzfyHOs/GTWdCouGiQhgf/bdSRLDbHCNqEmBz1
         dwbri1X7bxMVyAM0jCHyRhT16m7xC34fTMHjDXJPpXu3a9513zKlwLwf+pJ/bSXN+2SJ
         Kn2ZrqkJMhXVbcYTvzeiQ8ewlbynAfMRUuobdGCaCODVP/rF5vo9TOscJWFW3EstnkU8
         6X+g==
X-Forwarded-Encrypted: i=1; AJvYcCUcDxWInzNA7Z2phSXxN7nyTyRvKw2EgG00IBn2YUUVUBT2EmrWwaSvwh4xJe52ezKeeGU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn/5FkuuIxL7NgsXg6PlwReWq7hbMfSQzTBrnH1L6CDW9mJPL4
	fedetYwH3ix42EiA24oQboiJpU0LiN45tXGQk910N/1/1aQlRN1bZT3+M+8v4XVLSqM=
X-Gm-Gg: ASbGncs8naSa1DnguJJ46dYTqjDWz3oHi5PwBfQNuowXEKjXvyaO4t/yuccodDqY9s1
	EiC1Ft1DOXL1GkCk9qQkyjdteixyyWV/YYix+HdZJy6tCaaVPglb9ANNNszS9IM9p/USLfVJQK9
	eIusmq0ccA0nOPMpvRwQ1qO18djECfZBKAfVpzvvBtffnEoG5738WOMbqDZzRLSrBMtGYulgDlD
	QbCtkfyYu/m4acyUgl4U8VRpnLugIfeUp1PBp5fI+/dpsnthlmXfoV8IO2jxPQIPI4spx1j4xjV
	4PtJRs5diRQCZ+frJd+lSvzH2F+0KVOPgbB7SxjoKer4PlVM9KTP6j5yZ9ZcQRotyXjbuzZhKxS
	aU58Spf2NQ49y1+z+/ffG7Q0=
X-Google-Smtp-Source: AGHT+IEi9pe0oeBOE15/8xuZT4mmtCw/EODsHqznTJDr3Z4WP9YjhwiV366LnSMgu6QLvZ6qkctWyg==
X-Received: by 2002:a17:907:86a6:b0:afe:bdcb:9e62 with SMTP id a640c23a62f3a-b01d973074dmr1930653766b.33.1756973527252;
        Thu, 04 Sep 2025 01:12:07 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0424cc1698sm987487966b.21.2025.09.04.01.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:12:04 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 093DB60ABF;
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
Subject: [PATCH v2 076/281] linux-user/aarch64: Create init_main_thread
Date: Thu,  4 Sep 2025 09:07:50 +0100
Message-ID: <20250904081128.1942269-77-alex.bennee@linaro.org>
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
 linux-user/aarch64/cpu_loop.c | 14 ++++++--------
 linux-user/elfload.c          | 10 +---------
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/linux-user/aarch64/cpu_loop.c b/linux-user/aarch64/cpu_loop.c
index 030a630c936..4c4921152e8 100644
--- a/linux-user/aarch64/cpu_loop.c
+++ b/linux-user/aarch64/cpu_loop.c
@@ -137,10 +137,10 @@ void cpu_loop(CPUARMState *env)
     }
 }
 
-void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
+void init_main_thread(CPUState *cs, struct image_info *info)
 {
+    CPUARMState *env = cpu_env(cs);
     ARMCPU *cpu = env_archcpu(env);
-    int i;
 
     if (!(arm_feature(env, ARM_FEATURE_AARCH64))) {
         fprintf(stderr,
@@ -148,14 +148,12 @@ void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
         exit(EXIT_FAILURE);
     }
 
-    for (i = 0; i < 31; i++) {
-        env->xregs[i] = regs->regs[i];
-    }
-    env->pc = regs->pc;
-    env->xregs[31] = regs->sp;
+    env->pc = info->entry & ~0x3ULL;
+    env->xregs[31] = info->start_stack;
+
 #if TARGET_BIG_ENDIAN
     env->cp15.sctlr_el[1] |= SCTLR_E0E;
-    for (i = 1; i < 4; ++i) {
+    for (int i = 1; i < 4; ++i) {
         env->cp15.sctlr_el[i] |= SCTLR_EE;
     }
     arm_rebuild_hflags(env);
diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 95868739546..f93afbdcea3 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -395,15 +395,7 @@ static const VdsoImageInfo *vdso_image_info(uint32_t elf_flags)
 #define ELF_ARCH        EM_AARCH64
 #define ELF_CLASS       ELFCLASS64
 
-static inline void init_thread(struct target_pt_regs *regs,
-                               struct image_info *infop)
-{
-    abi_long stack = infop->start_stack;
-    memset(regs, 0, sizeof(*regs));
-
-    regs->pc = infop->entry & ~0x3ULL;
-    regs->sp = stack;
-}
+#define HAVE_INIT_MAIN_THREAD
 
 #define ELF_NREG    34
 typedef target_elf_greg_t  target_elf_gregset_t[ELF_NREG];
-- 
2.47.2


