Return-Path: <kvm+bounces-56802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9B55B4356C
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:19:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD8D81883594
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D912C1585;
	Thu,  4 Sep 2025 08:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ruv6EZOH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623D22C0F81
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973923; cv=none; b=QoY1+//GJMJ4LEMb7SjwLaDH7++AROlwMUHwDupg/hmFNa6NRIMXJvr4cwXGJ34shhr1rZdiPwDF5tAzQtOx+OBxokghOXSOEzMlUr8StfDeSYJiJP6UHS7nVi//s+sS5q5g1Pgw/ZMoropA2kxKwDbcMdOzwFlq2NNYK18qOCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973923; c=relaxed/simple;
	bh=6A08BUh3fCUxF9R841eS/4IGV0EM/Q1EsI9U9KOjmBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cv6Udy0IECA5HX5hwC9IlsBRcyS5BFHKjWor+m2EN2gZ1gBXdPmEco4nkcxUPz7Evotvy6S+1O9Gu0LF8fd/Y4yFDfXQWYD/ojt/z9sG+kylvriUEZIMntNR1MGK/E5wraGO6M35MXrR66P+CAjdhOjI3AX8eqn+mk9m7MUxO9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ruv6EZOH; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb7ace3baso138909966b.3
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973920; x=1757578720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+88w9AQZ9cLJwlirAZW/BDB9U/6ab+UNG3qEc9GZaw4=;
        b=ruv6EZOHaeOk9Psq9DBH/WqgDKgmqOgq7IfpQUqbxEXraDsE+vtSNW7X3UK2rgi6AZ
         6jNDOi6DinwAQvhSmj7+FYJG/61yvw6DrlYALEfWJR1FxOVLFygNrKrUw3i5ghJaDYp+
         C8EwYm8E1YLDGDc5i+jgTQExrnQnoxoT90iYQIz8Z9dfLESiO/3XB+/UOpvZBriPb0Im
         qC517weeDXLlHOUuIZEuVsEAAcW3sNT8nKG/35N9QAvL2vsd/US4pt6LlleQjcN8F2Gx
         CAEC7mHDvSGbmJODhDBGiWb+lnAMwrVCW6l79BPB4CWln/ZGnR6LsEhsWwK8qGdNUkRG
         Kyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973920; x=1757578720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+88w9AQZ9cLJwlirAZW/BDB9U/6ab+UNG3qEc9GZaw4=;
        b=CYgAowNgcb7Bji4au7cUapKD5lBAGzgINomwWeA9pst7jCuhw28+BLBfKbpFsT9Cj+
         /F7+ue9HSToeH3MaDGDt4s4rptucKoL2MwwmrQDorBwum7PXkY6oVX5eNiSIi9OvJ/JE
         hZOEAfy63pjPYgZV2DuFl1A6FCCl75bbewV16clgN1uRWpcPfAyFbaPzqjth1fL844Yt
         DNZIX1cY/JioRrcnjSoBANPRbs3HeeXh4Fe/Uftw7IxCw1p3322oYxuAvZrC1LCh/KAu
         FMmAW0/ku0o8GjUR68VtKhq1rfEDDHSQ1BvVervpLjWRLQYvj+QvROcA6WG1AZRmM5/l
         SozA==
X-Forwarded-Encrypted: i=1; AJvYcCUVsyzQGeFToS0nLVCiUeYI3TTfM+17MeNUNwtSqBO+3+/RuR/yyJmb/IjLYxndXqq2jfo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv2SEy0nvbkgtrbRNcB01/6Z1pGP9fCEXMVNa+NLNhgxs+tEGv
	MunhKfXkP3kTlmQjDzZ5ERBsZ2+hwdp80vpaqoy+hu1xEqpBwLZ2iMD8aM0vmfLhj+0=
X-Gm-Gg: ASbGncvH25g6JIGTNkvrWSmnipx5XywMBOheLiTutrv14eLzZM4eQ0Ys/yzG/3x1pZU
	3V7ut9Wr5oft0qo9MXrMwlBTz7FOyjVeLYC0mBSBojwwFUUhoIX0m2TrgIrgHXQvC/Vc6gVOQ0B
	GhZ4dCVEe9Cdj+Hg66qTjtqyH22WfTNppNeZJzUp6dx6m9JOdR9Fl1TNWxoEqlscVq4cvHnbOOV
	5FO7Y9Fg5dvilL8Ns9NxAG/LcoapUPlH5dEZ8EJWPd4MKiFem1PXU7Tcp/p4nHqsl4UPb+C1GUg
	xVAx2JUREJpsGY9o01MNat+uZR0/rHAP/ms2CRHgzpgsBd7AsOkOndkndGSlsWQicZeZA6z9W0o
	kGMDzxg3X2CUl78Ruep1feqc=
X-Google-Smtp-Source: AGHT+IGxjVBN0FQryOFHW7NPMAzsYYrdCtTTvqWBsGarhpRXGfdwEbKrpxErVnpLvup6bLCipLULiA==
X-Received: by 2002:a17:906:4fca:b0:b04:6546:347e with SMTP id a640c23a62f3a-b0465463a5bmr592167766b.51.1756973919569;
        Thu, 04 Sep 2025 01:18:39 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0425ce98f1sm977746666b.67.2025.09.04.01.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:18:37 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 5504A60AF7;
	Thu, 04 Sep 2025 09:11:39 +0100 (BST)
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
Subject: [PATCH v2 087/281] linux-user/riscv: Create init_main_thread
Date: Thu,  4 Sep 2025 09:08:01 +0100
Message-ID: <20250904081128.1942269-88-alex.bennee@linaro.org>
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
 linux-user/elfload.c        |  7 +------
 linux-user/riscv/cpu_loop.c | 10 ++++------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 16aa09214e8..556f11d720d 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -849,12 +849,7 @@ static void elf_core_copy_regs(target_elf_gregset_t *regs,
 #define VDSO_HEADER "vdso-64.c.inc"
 #endif
 
-static inline void init_thread(struct target_pt_regs *regs,
-                               struct image_info *infop)
-{
-    regs->sepc = infop->entry;
-    regs->sp = infop->start_stack;
-}
+#define HAVE_INIT_MAIN_THREAD
 
 #define ELF_EXEC_PAGESIZE 4096
 
diff --git a/linux-user/riscv/cpu_loop.c b/linux-user/riscv/cpu_loop.c
index 2dd30c7b288..b3162815320 100644
--- a/linux-user/riscv/cpu_loop.c
+++ b/linux-user/riscv/cpu_loop.c
@@ -94,14 +94,12 @@ void cpu_loop(CPURISCVState *env)
     }
 }
 
-void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
+void init_main_thread(CPUState *cs, struct image_info *info)
 {
-    CPUState *cpu = env_cpu(env);
-    TaskState *ts = get_task_state(cpu);
-    struct image_info *info = ts->info;
+    CPUArchState *env = cpu_env(cs);
 
-    env->pc = regs->sepc;
-    env->gpr[xSP] = regs->sp;
+    env->pc = info->entry;
+    env->gpr[xSP] = info->start_stack;
     env->elf_flags = info->elf_flags;
 
     if ((env->misa_ext & RVE) && !(env->elf_flags & EF_RISCV_RVE)) {
-- 
2.47.2


