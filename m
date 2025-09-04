Return-Path: <kvm+bounces-56785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E9E3B4352B
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4C74580AA7
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0432D2395;
	Thu,  4 Sep 2025 08:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RZI0VbZ/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266072C08D9
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973520; cv=none; b=WCK9PBudlW4mWn8HvCdqh1P9Vkuu6zHc7WZ/FoCgO35+n4UBIu/fhpANt98+OMvQ352RU7QjkjFG+Jjt40NhnV3GsLxFTl702m5Y3lUsjwXSEnW264BIUd8oprsa+IAUwfztkCHUlWLx4d64KhRaMJ0ZxrC/D5BoEpSxCbwqaDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973520; c=relaxed/simple;
	bh=5xDSBXc9nXN4ta/QPhfxKSQn6ju6Su21gkFlP+oTifg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFGrz92zpS0weKNPgPBH38QqLLUg8kKafSkz2fku3BhLcamunOWBhM2OokabsuKEzGhdxMmJRgHnmfQENLKDQIkiTyTUns1YsT/5RgEv3p4VXB3tEHdMpv5eZe3pgXBoolyeypnSQHxwpVSV6UKQurSjlpwi59pbCatLc4EJjVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RZI0VbZ/; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b042eb09948so122951666b.3
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973516; x=1757578316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihVvxQgeNn/GjHbnY+gzjmvaE+8lZrZaLCxntP4XREM=;
        b=RZI0VbZ/SMv1xZHWVP+eXfOODXN7T/TZWKCVFR1RIbgM/uXabtmSan+dqomU3290vc
         IlfCJaqmOt1ULDFpjWwqT78Ia99Yi8Y/LA8fFuVU8u2unchGrvvYSImKIG1W0E6Pc/I7
         yJe7eCpySveyGyZE1oicycZOPVDxsAfA+mlBDYBcaWWT9of4Uzy2bb/EE0Z8MkDimzDY
         wx8emBvo1ns2lJeJGwVFhLp52scduQnPdWWhQNVs62ICybb3soOATmW+qIVu+zJuz1Jx
         8VBkMtPC3Fx+2CuO6LWtnrPsmsB7kJomktDodejH/1LSruXdTEG/GiJG7DLwd9s4DZtq
         gZrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973516; x=1757578316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ihVvxQgeNn/GjHbnY+gzjmvaE+8lZrZaLCxntP4XREM=;
        b=HA2B9tadOkZAHldD+7v/XgIjN9DTRKeHOsNTlMe9EEOzdJhaSEXlMUZJmdYdv9vYeJ
         e0npfk0lNk09pfdHKg5fuEZnOBM1zMq2EqxCY5scjsWTbp0mAIopAOATgJBIPDMJJd5Z
         iBnIjjMuM+FOCYd6Ix3aS+tkZp+UwKyaeadyjQh/aLCVL46YY0+JQkKf97YSpt1rwi5M
         kS2d/LhLbXKY3A+qSFPqQG5AsKEJ/K+HZTV82X0RBtkE+KCXK4G2eqUFrF15IPG5/eq6
         bCntTO6dJTmJBOESKPXNNfumcJy1KqqzPKOJYv5o41dXslbFIaM0NYC5vNGngJfkpmEu
         dXLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3V6hhW2uu2yvEMmM7vd+9R+Ib4pASLIVkdK2q8LnKu4+yYKGllwkXSgHPlcmDwynHVk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjpFCSXz11+Mzybf6TFa4Pe1fb3NXBeRGIocJ92/NsP5YthXkF
	uAa6VzymN0KC2ZMK8oRaVztL9rMks3MduU4TWtRF0Dbk8Eq7OOiRkkA4vl3syeCfkp0=
X-Gm-Gg: ASbGncvumESMSGlOd+Uj6EmteXmNj9JhCvjmQmNOsgbL3kTx4/oXDNr5VSKvzSSMtM0
	Ys8m5DnS+o2JsaUM/kbn2lpvRasJoCCvquiZ7d2lU+wsTwuIH6wkDNMhQs4QNjKqVYlQm77mZs4
	XEOv/SjVEA11gxtGGByeyQasrlpVnehO2DEOKvWdzPzVaT8RZ2BCmi49/SrKkjp5aVHjY3qZVY7
	ZBcLGF3epaDVmuM9C29yduiD5bj2XErulFL8HEopK7KoZRrDv4TAz7r06/vXrSprnaXipOVXWaJ
	xTKPOUqKa8C+EgAotE5yudXUJlA5opI9VJoSkjnTomM8Werbr034G4CH3P7LmkMCTJFL3M9yPPy
	kTomWqfwymfulQWu1G/3j8Aw=
X-Google-Smtp-Source: AGHT+IE6icEl4XuEBWlH8j8BpgjiN6xgfsXzhcsYUMtNnFW6HtKULX+/oPffLgfaZHVhKWGCJwwp1Q==
X-Received: by 2002:a17:907:2682:b0:afd:d9e4:51e7 with SMTP id a640c23a62f3a-b01f20bde05mr360782366b.63.1756973516361;
        Thu, 04 Sep 2025 01:11:56 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b04709b3effsm279304666b.5.2025.09.04.01.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:55 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 0EB89601A4;
	Thu, 04 Sep 2025 09:11:34 +0100 (BST)
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
Subject: [PATCH v2 048/281] semihosting: Retrieve stack top from image_info
Date: Thu,  4 Sep 2025 09:07:22 +0100
Message-ID: <20250904081128.1942269-49-alex.bennee@linaro.org>
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

Remove the write-once field TaskState.stack_base, and use the
same value from struct image_info.

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
---
 linux-user/qemu.h             | 1 -
 linux-user/aarch64/cpu_loop.c | 1 -
 linux-user/arm/cpu_loop.c     | 1 -
 linux-user/m68k/cpu_loop.c    | 1 -
 linux-user/riscv/cpu_loop.c   | 1 -
 semihosting/arm-compat-semi.c | 6 +++++-
 6 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/linux-user/qemu.h b/linux-user/qemu.h
index 0b19fa43e65..b6621536b36 100644
--- a/linux-user/qemu.h
+++ b/linux-user/qemu.h
@@ -127,7 +127,6 @@ struct TaskState {
     abi_ulong heap_base;
     abi_ulong heap_limit;
 #endif
-    abi_ulong stack_base;
     int used; /* non zero if used */
     struct image_info *info;
     struct linux_binprm *bprm;
diff --git a/linux-user/aarch64/cpu_loop.c b/linux-user/aarch64/cpu_loop.c
index fea43cefa6b..b65999a75bf 100644
--- a/linux-user/aarch64/cpu_loop.c
+++ b/linux-user/aarch64/cpu_loop.c
@@ -168,7 +168,6 @@ void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
         qemu_guest_getrandom_nofail(&env->keys, sizeof(env->keys));
     }
 
-    ts->stack_base = info->start_stack;
     ts->heap_base = info->brk;
     /* This will be filled in on the first SYS_HEAPINFO call.  */
     ts->heap_limit = 0;
diff --git a/linux-user/arm/cpu_loop.c b/linux-user/arm/cpu_loop.c
index 33f63951a95..e40d6beafa2 100644
--- a/linux-user/arm/cpu_loop.c
+++ b/linux-user/arm/cpu_loop.c
@@ -504,7 +504,6 @@ void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
     arm_rebuild_hflags(env);
 #endif
 
-    ts->stack_base = info->start_stack;
     ts->heap_base = info->brk;
     /* This will be filled in on the first SYS_HEAPINFO call.  */
     ts->heap_limit = 0;
diff --git a/linux-user/m68k/cpu_loop.c b/linux-user/m68k/cpu_loop.c
index 5da91b997ae..3aaaf02ca4e 100644
--- a/linux-user/m68k/cpu_loop.c
+++ b/linux-user/m68k/cpu_loop.c
@@ -117,7 +117,6 @@ void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
     env->aregs[7] = regs->usp;
     env->sr = regs->sr;
 
-    ts->stack_base = info->start_stack;
     ts->heap_base = info->brk;
     /* This will be filled in on the first SYS_HEAPINFO call.  */
     ts->heap_limit = 0;
diff --git a/linux-user/riscv/cpu_loop.c b/linux-user/riscv/cpu_loop.c
index 3ac8bbfec1f..541de765ffa 100644
--- a/linux-user/riscv/cpu_loop.c
+++ b/linux-user/riscv/cpu_loop.c
@@ -109,7 +109,6 @@ void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
         exit(EXIT_FAILURE);
     }
 
-    ts->stack_base = info->start_stack;
     ts->heap_base = info->brk;
     /* This will be filled in on the first SYS_HEAPINFO call.  */
     ts->heap_limit = 0;
diff --git a/semihosting/arm-compat-semi.c b/semihosting/arm-compat-semi.c
index 86e5260e504..bc04b02eba8 100644
--- a/semihosting/arm-compat-semi.c
+++ b/semihosting/arm-compat-semi.c
@@ -696,7 +696,11 @@ void do_common_semihosting(CPUState *cs)
 
             retvals[0] = ts->heap_base;
             retvals[1] = ts->heap_limit;
-            retvals[2] = ts->stack_base;
+            /*
+             * Note that semihosting is *not* thread aware.
+             * Always return the stack base of the main thread.
+             */
+            retvals[2] = ts->info->start_stack;
             retvals[3] = 0; /* Stack limit.  */
 #else
             retvals[0] = info.heapbase;  /* Heap Base */
-- 
2.47.2


