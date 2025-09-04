Return-Path: <kvm+bounces-56796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3420CB4353F
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:15:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8A9A7C3E6D
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B19A2C11CE;
	Thu,  4 Sep 2025 08:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zsNpVATL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B992C0F73
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973537; cv=none; b=diC9qenkqpxuz3yH+fo2UFQGCRhUS/8TKK3OxDSgtB2/Lle+V9w4hB4wuwKqoJ/Ice/cbl43IEgmNbIZjYlJY86CkUwSxgg3tMi6aPYopeMOB2KK2T1X6qCz5muun53srqBR9OWlxYWRlH4k9FyBB7f78db8Qb+gO4fZTSknwIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973537; c=relaxed/simple;
	bh=MK7uE6FYw195OkpC9ESOb0dNhAnkls99T1qThZMfVR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2SrP59WWI+CX7ar37fzd5AZWFeNxXPJ3ky8TvyHSCj+HiVymoo2eMwfAVFc4FWy0/nzXqLoMpRJZehZTbpIJHBRofDJQ2VE4s5Erqp49uLPzDeNY0WT5MXK2Av4P7L5fDHZjmEx/sBvd5bQF/1ReCn7uftYKRC3LL760nL8xzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zsNpVATL; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-619487c8865so3299511a12.1
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973534; x=1757578334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2o641iW9Eoei/+yvUIKi4qJ7pGzfbvmdWyUoyzoyuTo=;
        b=zsNpVATLoEyPiOUdFbeAKG0Aky/cemCLLDmk2wZvIk5Z5rhgUkZq5Er7tjuVPBiHxW
         aahWvb5j75F7eUlpZ9Mde7YbdqjB5uHrt1RfCDtPymClNmB301Sel9XfMunE4p+rknVY
         I5TXysZT3nvPXCxytDyQgrEoBrSPrmqwq2HcvTI1ugB4Vz3i6XZeltSOmo6PD1Jus6yI
         EthczKC2QRxZ+zszzkw1NJVI3xO+ST9HYkSK3lB+PxOPcQYG9aRen1asdoGC/hE2ZD2T
         Fa7Uug4VK21k5uQP9gHqx3neP2DXlBw9hpDyRiW31AcfsJ3cl2ebJbAtdplVjndbNzGf
         7N9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973534; x=1757578334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2o641iW9Eoei/+yvUIKi4qJ7pGzfbvmdWyUoyzoyuTo=;
        b=IKnwseF4yuhcUS4q06xhzKvC9E3QmElQpKcXxWAq4mSUuUFNrW5Lsu/blDDTjxm0OR
         nPIOmyaitOvZVvPVj4w/5gh22PspBSVQSDeQxK/lZ4xyxE0lEtLlo/koLlvu7k3CT1rN
         P8aU9PwNt8UGaspjDBAqdABqCJtCIzdy88K00lFKswzCzuklOCwspp/Btpk2A8viRl8E
         310F/VKg3nq9248U90jScOiga8sXV4j+zMMvwCMfEfWu7PjXX6yDhWOI0im1ry+6v3J8
         Pj23MHeDBW4JrKh5A8MAWyMCZ/P+OOPVoXIaTwIxetE6dmWD5V8QFnD3C34Ba3pfCkuw
         3ggw==
X-Forwarded-Encrypted: i=1; AJvYcCUBcNIeVtdVKdkQaDbJ8KZAEfyFM9oDkiyHQFZTifXva4S057PngaUb3flKy2aDY0W0KaI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyBb30DlUdU24R4mJzQfyGnOcdJ7833Z9LDjw9hkQBsTgogwy2
	Cxv4Hwr2oc9N+JoD9yxVEyoNZxGnnI71Y8kBcuck1cqAayzrxtrXysielSWjJzR13pU=
X-Gm-Gg: ASbGncsTqw1l6rhYgA7kqqO9qbqD2lRWq9JntdIetSzmgyL4wrXNDQHF3L1ghImkc9M
	CuTyxzqVJj6Td0G8iAPBsnWCPtnItbAh5zaZvHSqvlB1fmZIuQAKJrLSH6RiY6n/k2Ncy2wYtrV
	4liftClBIlY7OlCMI7oWCZn7+hkKNmnOv14jsBEt2OhK5p0YyPNa++R99K6a9uxf02GEm9Fw+ND
	l3ot6Z4UG7l8I5OMUv5JQkbmxgUaclAYqsPQtV0iPHEMxAoiWai91D6G/KsvOmaTCk6DmBMZvyY
	XiZBAySauAexxJCoST29rc56d2ci2zqVAZcHMH3circa+cGrlFC/jjIO3ofGHpQo1rEmJGC9SoN
	t88eG8HAGzO392PkR1d2PF1U=
X-Google-Smtp-Source: AGHT+IGLKV6kj/wdkKv1zH+QlHElinS7UZypfjzlhnOqgFK2g8smAfI2YLmWX9/F3AuN9VCXaBC4yQ==
X-Received: by 2002:a05:6402:35d3:b0:61c:7ee2:f41a with SMTP id 4fb4d7f45d1cf-61d26d93883mr16733782a12.15.1756973534355;
        Thu, 04 Sep 2025 01:12:14 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc1c7a10sm14089854a12.5.2025.09.04.01.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:12:10 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id D4EB660AE4;
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
Subject: [PATCH v2 083/281] linux-user/sh4: Create init_main_thread
Date: Thu,  4 Sep 2025 09:07:57 +0100
Message-ID: <20250904081128.1942269-84-alex.bennee@linaro.org>
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
 linux-user/elfload.c      |  8 +-------
 linux-user/sh4/cpu_loop.c | 10 ++++------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 03c95397744..8604308a310 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -701,13 +701,7 @@ static void elf_core_copy_regs(target_elf_gregset_t *regs,
 #define ELF_CLASS ELFCLASS32
 #define ELF_ARCH  EM_SH
 
-static inline void init_thread(struct target_pt_regs *regs,
-                               struct image_info *infop)
-{
-    /* Check other registers XXXXX */
-    regs->pc = infop->entry;
-    regs->regs[15] = infop->start_stack;
-}
+#define HAVE_INIT_MAIN_THREAD
 
 /* See linux kernel: arch/sh/include/asm/elf.h.  */
 #define ELF_NREG 23
diff --git a/linux-user/sh4/cpu_loop.c b/linux-user/sh4/cpu_loop.c
index ee9eff3428a..259ea1cc8bb 100644
--- a/linux-user/sh4/cpu_loop.c
+++ b/linux-user/sh4/cpu_loop.c
@@ -81,12 +81,10 @@ void cpu_loop(CPUSH4State *env)
     }
 }
 
-void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
+void init_main_thread(CPUState *cs, struct image_info *info)
 {
-    int i;
+    CPUArchState *env = cpu_env(cs);
 
-    for(i = 0; i < 16; i++) {
-        env->gregs[i] = regs->regs[i];
-    }
-    env->pc = regs->pc;
+    env->pc = info->entry;
+    env->gregs[15] = info->start_stack;
 }
-- 
2.47.2


