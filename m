Return-Path: <kvm+bounces-56792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC2B8B43532
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:14:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D15216DB62
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3C12D3A6D;
	Thu,  4 Sep 2025 08:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kJaRlG32"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19922C0F97
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973532; cv=none; b=tZKg++uNe44mmQNn2kIhaOnO3LtveWL3G9mWN/dd2XqUtbQeUrwZPU+e2YCaHrHlesvKShqkFvePqqm5Uut9kMs+vZsCqJ6hKSzJK/DgOSOA0HbeRXpU6OiBmkAgoDogUm/CCqf2zwP5Mkg6+6oq0TSPFdlHq6Srqb1uFGiZaPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973532; c=relaxed/simple;
	bh=yA8j+MoZAD6VN3pYFZl4y9pYrJJfBXOa3vg2ZiqVELo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0/Lovgml5AcJTCOxt5jVZ8wFib4EokV7qAsuH/fJT1C5UsFFJ/dtyy9wfcL4NO8kqejt4w8ZocKpuq8VUmDlfrPSSDvpuUofYCiHdtwbuOMDYX7mxNpZsLQYqhrap8VEcfK5bF/VxA2mqx0zfPAjpCCHnBtxUuuIQQbkMEZ4VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kJaRlG32; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-619487c8865so3299339a12.1
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973529; x=1757578329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yLl9oYpNkKlC5u6Dy+xpIH1LWB2sTjU8xRvbErhSckk=;
        b=kJaRlG32ZFJz/EkMYsGlYAFPpZ1u+Bcbd6QKpYXT9rjJPKz+oweEKdLmgqUFD5w8o1
         k77VLzyq3XVSBqGg/pTuY7ZaKmBuIP9eKaYPd8RZi/lmE/6it/fDMc8hrdckfces9V6b
         sSYv4Upv/5+1wrx0Evppgpif0guyC6PiPx2tib/h9vlAuCifx8L09fzRSUgcRFcdcVao
         wPYTGVpCWJ6UyZZCrEowLbfCgwtDOm3CVYbEsL6s+erdsj1MYM/jYDcKi7k4NPD7Hhqm
         kp2c6inUvbZ3QAO3T5+AdiDLPnnLPV7C3FAAyHTSH2WSio17CxndxgLU+G3tQAqmn8mC
         cUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973529; x=1757578329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yLl9oYpNkKlC5u6Dy+xpIH1LWB2sTjU8xRvbErhSckk=;
        b=bBlLED+uzHJDNmoRez4b7C6W6gPEiAmwQhqt0znkRXDo7KvrX8gUH61Uxx+I85nyqI
         HFN3V66ZZmpoWs0U5wYTmPw4rUmDm2CwbV5WFjETVFg0UVRlUvO4v+aer2YREG8JO9eQ
         5ak3MmrFqxUDlTHtdDPL39EY/KOd3q36eaIISdOkyQdMUFQLemRV7X+6usNQ05+00jdW
         G+Ik6fQNNNwNKjNUlvqHAJtidLtHYNHtAPhVzzbrPs97VM5+xcaDqWO+3RgNNT+auaYp
         TgQhBRs69ic5Wunrvtbs7sHomrKecYYwmoGM8aLmERCvrAPIFmlAcA3EHNCzi7qic+nR
         d2oA==
X-Forwarded-Encrypted: i=1; AJvYcCU4OH0Gl7TYSnJvxTIxQ+Bio+Av940x1iOzi7vRJfF54BTGYDU7iKkdYZKPxxQJuKO56SE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi7XICA8SjtETFbGawPQ3o34ugUSWOptVL3yHt6yw3Ym8RJ4Sh
	/j3QlLICO18DCJEYTzQnqJzwAUF8EGLkx9Hs3MEFjEiZJpV0SA1fJS+etvBh+vuRy3U=
X-Gm-Gg: ASbGncuyU5E7AWGK+6yhIyyhtXSERRsgLV+uUKFA/QXeMrMio4h2b9Bc0GtLqH2Y435
	j0ByBxihe21X1f+raOhLUwoVD9A1F2nG0e/nd55GaHLcknyKj+znHq8NwtRNN7EJNaDBzy3zYf4
	CJTSIDXnS/deJHaZi66WdCFDCqA8Z18/5e5X8zODvn2/dEa3j20w5DkAKeUphtrOTyog6cKMTkW
	qFmIzHf6MvlBeQ6HpXY/V0EpjREhjPCTeSTt46AP0JBYu4/vNjZjEAztNRk9t+OHVOwjalCt6Ut
	0OVS1kRFEyHnzZoWWZrPnuryTRsJgTmybAwAWP1cyvSRbjvzeavNMd0JwWn80ObJ8r8hlfLMdFw
	PcNcx7Lv3JVPPNQY2fs1iu7f1hNLDWq4ANL8QIrJUINOD
X-Google-Smtp-Source: AGHT+IHg43VIz5IWaoCglFsXYUVyXtk+RFiP5eDwfdW8F/G9pRndbxerLOqZv98JEUjySgovhYynfw==
X-Received: by 2002:a17:907:3fa2:b0:b04:3623:aa10 with SMTP id a640c23a62f3a-b043623b1c6mr1473568066b.2.1756973529066;
        Thu, 04 Sep 2025 01:12:09 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b018fe7c638sm1311287266b.6.2025.09.04.01.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:12:04 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 7EACA60AD9;
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
Subject: [PATCH v2 080/281] linux-user/mips: Create init_main_thread
Date: Thu,  4 Sep 2025 09:07:54 +0100
Message-ID: <20250904081128.1942269-81-alex.bennee@linaro.org>
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

Note that init_thread had set cp0_status in target_pt_regs, but
target_cpu_copy_regs did not copy to env.  This turns out to be
ok because mips_cpu_reset_hold initializes CP0_Status properly.

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
---
 linux-user/elfload.c       |  8 +-------
 linux-user/mips/cpu_loop.c | 16 ++++++----------
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 0feccfbe916..ac96755b06c 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -581,13 +581,7 @@ static void elf_core_copy_regs(target_elf_gregset_t *regs,
 #define elf_check_abi(x) (!((x) & EF_MIPS_ABI2))
 #endif
 
-static inline void init_thread(struct target_pt_regs *regs,
-                               struct image_info *infop)
-{
-    regs->cp0_status = 2 << CP0St_KSU;
-    regs->cp0_epc = infop->entry;
-    regs->regs[29] = infop->start_stack;
-}
+#define HAVE_INIT_MAIN_THREAD
 
 /* See linux kernel: arch/mips/include/asm/elf.h.  */
 #define ELF_NREG 45
diff --git a/linux-user/mips/cpu_loop.c b/linux-user/mips/cpu_loop.c
index 6405806eb02..e67b8a2e463 100644
--- a/linux-user/mips/cpu_loop.c
+++ b/linux-user/mips/cpu_loop.c
@@ -211,12 +211,9 @@ done_syscall:
     }
 }
 
-void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
+void init_main_thread(CPUState *cs, struct image_info *info)
 {
-    CPUState *cpu = env_cpu(env);
-    TaskState *ts = get_task_state(cpu);
-    struct image_info *info = ts->info;
-    int i;
+    CPUArchState *env = cpu_env(cs);
 
     struct mode_req {
         bool single;
@@ -245,12 +242,11 @@ void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
 
     struct mode_req prog_req;
     struct mode_req interp_req;
+    target_ulong entry = info->entry;
 
-    for(i = 0; i < 32; i++) {
-        env->active_tc.gpr[i] = regs->regs[i];
-    }
-    env->active_tc.PC = regs->cp0_epc & ~(target_ulong)1;
-    if (regs->cp0_epc & 1) {
+    env->active_tc.gpr[29] = info->start_stack;
+    env->active_tc.PC = entry & ~(target_ulong)1;
+    if (entry & 1) {
         env->hflags |= MIPS_HFLAG_M16;
     }
 
-- 
2.47.2


