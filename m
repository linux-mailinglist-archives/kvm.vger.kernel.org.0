Return-Path: <kvm+bounces-56795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6474EB43536
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:14:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07BF7177036
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420832D3A85;
	Thu,  4 Sep 2025 08:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hWM0MaAy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B0C2D29D8
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973537; cv=none; b=ML7X3K/w12eGWa636LgowZfjLumWK7lKBUaTxcyM0An6P7cBVHON8eIGwF946fQqyRP5uppLn0eA8e1eXQgI8m13msHVLXKq4d8ArMRZw2mvYexLgQD0qsxc7wC/DFG1Ji7n1XnSr0tJB9sh8XsCIWFJJs/U3B8mETuzvPkezEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973537; c=relaxed/simple;
	bh=UF9QbSGC74iDz55xEPag2iWKJqR5ZEPcErqgu9gQ3Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SD8XzhAgpEiel+/85ct6G1UHqc/WVIllBDe/fneX7qpe2umv7OrQuX1DIa0yRmP+ZkDWYgp4IXSyR2O0VVHK86yvSzcmfOZDrBO+IG+WFQUZh2jl+nhf4MzP31JGOdVOoH5aYAHnUTo1YlbYN+xA995qjiLN/zNiCjQs8RyG2Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hWM0MaAy; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61e4254271dso1273471a12.2
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973534; x=1757578334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5Zye4y6NxJaSczxcVcmt24avvGWMTOUTr/+SGRum6M=;
        b=hWM0MaAyCA7Syohv+9syTJMpUW0fM94kj13gR6I25MdpvR80jlRLRbYBhXhc1xXni5
         ltJUAEzUtxrZSyx+g2dwn/ztwB1uxbC2Cq6KIwXS77XShCzxScCwTwBZ33wrrDK3O72J
         Hr30YiUrFep9e51NvC5bpJw6Nt1uRabzX5wGouZDgUt0V5DTEX/HzTwwYq2rbqJIKUm4
         tY2kc4JqgqOLd5EkYDOvv3uuTyhhjxg/mTKDW4vrNK6aH/uCErxiv9mqGKr76UgtQQ6q
         Z4/mSMWhXWzZor9mMPz8R785xwdqyGiJApWZ/vSXaHs60FG/WnbdxFZ1MI/6ze0K4Nyn
         dP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973534; x=1757578334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V5Zye4y6NxJaSczxcVcmt24avvGWMTOUTr/+SGRum6M=;
        b=htlpR31jgKUj7CwaEidQHlEfSbCApc6M0P05NcM8sYxf1RqHGBTUqTULtfKcmg1h5g
         D00c+rwjeJWzQ+FE72pWfdmv8WS5OP+/YrvH07taxsmNZLT2gPz0AD4OunHEXVjM+WTb
         gcQ5P/MC39yDxrcz6p+XZUuXr5DKzFk5B+FxQUOYjh5AJgJjFd8n/rLJcQMSDkbtWeag
         NkmiY17FA/33ErOHjfTStHK/1MAtf6wTCrBY5CfaIxB5JtvHTnRKp/lenDYjpvhl8YM9
         0E5i4Yn/xs5Zqu5DUASIMMM90DAr78piBjMqWir5GFSDPA69clBtinwcBqENrFJa9BI5
         yftA==
X-Forwarded-Encrypted: i=1; AJvYcCXuybrPwGLLYo36waRmijsYk1fXce0xuams3V6KHATwTTTz+cnMHgMt9yh1ms3KVVuha1g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvcLun8CHzKw64V7dBJLOCCocv5l3fOZPF0xmvIsYd6KA2g2zg
	TkAB551I7EQkMwPM2v9Rf2iMAPfIpfVrqTYW9XNGh65lcdEJLFbORQmraTOZQCyf/+E=
X-Gm-Gg: ASbGnctbGX/nA5wj3r6vmSQuhL4pxAfyK4CNM0dz9an4DaGssFQ9Biegp4LGPY/sWxv
	mLnhSiaf6UmaO1upZOMfxCsTCF9CQxt31zicKxsXbkSqm0n/zZlSmi/Xux6uBlp5VRXc5GnKE9R
	01xmVcovwpYbCQ5RjfDANrUkz5+S05mxmJhPcNK9ikwHwv1ZOIkb1Z080jIY6dW5sQI+zJD6Oj5
	VLWVO+HTFNZbKjFBTDaMidqAD8y1x66OJ0RTk5p28qIpG6HTlwlIqsLScz2GwjxR2kLMrYTMwPY
	Ys+7EQ6PQRGsb/V/CeIZ7Ql/4gRINcxD/cBgedL/bNbSiv8cuXgBF0PH0X10SvpviMb1yU78PCF
	RoaJYFloSv5KIYE0aC2KhYw8jEU5LYTqVIg==
X-Google-Smtp-Source: AGHT+IGvhyi3Ob8FQTO0E+SlWXz70PknUDYB759PnOR+EDDgh33qtQBCOSrVgpXzaEOgq2NGLcCnnA==
X-Received: by 2002:a05:6402:2549:b0:618:afa:70b1 with SMTP id 4fb4d7f45d1cf-61d26c32e70mr15695243a12.20.1756973533908;
        Thu, 04 Sep 2025 01:12:13 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc4bbc6bsm13985707a12.29.2025.09.04.01.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:12:10 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id BA7BD5F93B;
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
Subject: [PATCH v2 082/281] linux-user/openrisc: Create init_main_thread
Date: Thu,  4 Sep 2025 09:07:56 +0100
Message-ID: <20250904081128.1942269-83-alex.bennee@linaro.org>
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
 linux-user/elfload.c           |  7 +------
 linux-user/openrisc/cpu_loop.c | 11 ++++-------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 3f9ec493595..03c95397744 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -673,12 +673,7 @@ static void elf_core_copy_regs(target_elf_gregset_t *regs, const CPUMBState *env
 #define ELF_CLASS ELFCLASS32
 #define ELF_DATA  ELFDATA2MSB
 
-static inline void init_thread(struct target_pt_regs *regs,
-                               struct image_info *infop)
-{
-    regs->pc = infop->entry;
-    regs->gpr[1] = infop->start_stack;
-}
+#define HAVE_INIT_MAIN_THREAD
 
 #define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE 8192
diff --git a/linux-user/openrisc/cpu_loop.c b/linux-user/openrisc/cpu_loop.c
index 306b4f8eb43..8c72347a99a 100644
--- a/linux-user/openrisc/cpu_loop.c
+++ b/linux-user/openrisc/cpu_loop.c
@@ -83,13 +83,10 @@ void cpu_loop(CPUOpenRISCState *env)
     }
 }
 
-void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
+void init_main_thread(CPUState *cs, struct image_info *info)
 {
-    int i;
+    CPUArchState *env = cpu_env(cs);
 
-    for (i = 0; i < 32; i++) {
-        cpu_set_gpr(env, i, regs->gpr[i]);
-    }
-    env->pc = regs->pc;
-    cpu_set_sr(env, regs->sr);
+    env->pc = info->entry;
+    cpu_set_gpr(env, 1, info->start_stack);
 }
-- 
2.47.2


