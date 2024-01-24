Return-Path: <kvm+bounces-6839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0709083ADD1
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 16:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A904128B00C
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 15:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 765697CF09;
	Wed, 24 Jan 2024 15:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KJXtL6PT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3C07C099
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 15:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706111679; cv=none; b=ej7w1YaY2xqOe9WFRVUcPloEzNXs3RQwI8vMmRcaARGnpdxarcq5RO/H8r/B4P/iZUrZgbGmLHl8hmBQNSjVvk9W//ENs4I/vBnBa4duxebJLrv63ExWPAkadOOprB8ZyJSIJ4NxNByHo/dXGdkbliBaV0N7BjvT0vLWfH9iCpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706111679; c=relaxed/simple;
	bh=SKOgljj8tqvzotY+IctNZWR7vUFNrp8VC2jaBA36fa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YYTMloIPXqb6h99Q5Q3gh4sGgpWcNrxcM3LQDMbHUI4RVroMJcObN4YCUNazzSXjXJr7QVb7mhngtg191/HQow00qCuCFFvR3vnyBCFhjrxQfcUcHIFM9hR0vHzS9FNQfxGBnsxsX5y23GczCm9lHsLvjFbBJ8QNfGYwBR9FKMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KJXtL6PT; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-337d05b8942so6372926f8f.3
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706111676; x=1706716476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aTb7XsL1n33B1zcbpZjICkUyxotK3fc0XdMkkBFWEgg=;
        b=KJXtL6PTVdK5qun8cPIu7Z8Co+BB9a3eRY3RX825Z6EwvHN0F5adjdXAoZmOpzGaJ/
         NaD+huNx17N6gPMZaKGxQ9mht+xiX4VRihSzpIRvP5fnDOAbQcYpR9C0mnBCrXKrA73u
         RnzVgQJk2bywNu9bck58GdRpWVGG9K1EqnjJhitz7tHhIMAqD9/PPRsq+OSvPpvq/c+e
         B0zZ9tWp1ATulrBfTRyp/t12awi2KfE+rdEJTPqR73fyI+Qj3zxBx8YXF6Be/2AlMIGi
         Wm/ZbWqcDmIG4bQu92u36EC+QGj5NYH1XUZtRezusJiljKAM2KNOwXwU2SVPTqDNAopk
         ARFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706111676; x=1706716476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aTb7XsL1n33B1zcbpZjICkUyxotK3fc0XdMkkBFWEgg=;
        b=d94XNK+OMsguURghlh9cer6xgPgRdnk4x80Zvq+BsRohVxVN0+0jA8tr+A3Jk3B9VE
         s4zoixSj09JoYNL0s0/9Yb0imublR4SfD+nb1K9hGrGC3F9qmd380pe4NpVVExuhWRtP
         qM7Owsd+VIU9g/Z8PTSlzaUveJDmQrWH1ifAK51XZhnA/aLObmli5Jv8F+waCTSzDr+Z
         jFkpsSTw7NhbiEAQ2DBSaKkM/8hntDeCBvkcqiNXIoPUE6aUI7IbGZTXdVkqJimEbAnu
         0/KN6tNpYsy4S0Q9omrogHMx9T/UMo4rxs5jBiWq++gpBrLm0vbfP5Yfizb8EVmA0ImP
         4Cng==
X-Gm-Message-State: AOJu0Yw+piJSNQCia/X8J23GlJkRpLcOmcpksSe8qgoup6BtHOiJfRbS
	1GWYV1TqsTXolZitSKCZ9mNfJ0H5lP7EfT90JPK6F/2BB23VDOC5+22G8V9a74M=
X-Google-Smtp-Source: AGHT+IEWNMk3AgOpr1E3McOSW2fz67zuR1pIW2mreBkz+XaNSy0I1MnJTEPBGceydnI2SuRckjj6QA==
X-Received: by 2002:adf:cc84:0:b0:337:6806:f919 with SMTP id p4-20020adfcc84000000b003376806f919mr854421wrj.107.1706111675960;
        Wed, 24 Jan 2024 07:54:35 -0800 (PST)
Received: from localhost.localdomain (lgp44-h02-176-184-8-67.dsl.sta.abo.bbox.fr. [176.184.8.67])
        by smtp.gmail.com with ESMTPSA id s16-20020a5d5110000000b0033763a9ea2dsm9921845wrt.63.2024.01.24.07.54.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 24 Jan 2024 07:54:35 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	qemu-riscv@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Song Gao <gaosong@loongson.cn>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bin.meng@windriver.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH 1/2] accel/kvm: Define KVM_ARCH_HAVE_MCE_INJECTION in each target
Date: Wed, 24 Jan 2024 16:54:24 +0100
Message-ID: <20240124155425.73195-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240124155425.73195-1-philmd@linaro.org>
References: <20240124155425.73195-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Instead of having KVM_HAVE_MCE_INJECTION optionally defined,
always define KVM_ARCH_HAVE_MCE_INJECTION for each target,
and set KVM_HAVE_MCE_INJECTION if it is not zero.

It is now clearer for KVM targets to detect if they lack the
MCE injection implementation. Also, moving headers around
is no more painful, because if a target neglects to define
KVM_ARCH_HAVE_MCE_INJECTION, the build will fail.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
I'd rather keep "cpu-param.h" simple/short.

Is a per-target "kvm-param.h" any better?
Or per-target "accel-param.h"? For example TCG_GUEST_DEFAULT_MO
is TCG specific and could also go there. Otherwise it will go
in "cpu-param.h".
---
 include/sysemu/kvm.h         | 5 +++++
 target/arm/cpu-param.h       | 5 +++++
 target/arm/cpu.h             | 4 ----
 target/i386/cpu-param.h      | 2 ++
 target/i386/cpu.h            | 2 --
 target/loongarch/cpu-param.h | 2 ++
 target/mips/cpu-param.h      | 2 ++
 target/ppc/cpu-param.h       | 2 ++
 target/riscv/cpu-param.h     | 2 ++
 target/s390x/cpu-param.h     | 2 ++
 10 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index d614878164..2e9aa2fc53 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -212,6 +212,7 @@ int kvm_on_sigbus(int code, void *addr);
 
 #ifdef NEED_CPU_H
 #include "cpu.h"
+#include "cpu-param.h"
 
 void kvm_flush_coalesced_mmio_buffer(void);
 
@@ -349,6 +350,10 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
 /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
 unsigned long kvm_arch_vcpu_id(CPUState *cpu);
 
+#if KVM_ARCH_HAVE_MCE_INJECTION
+#define KVM_HAVE_MCE_INJECTION
+#endif
+
 #ifdef KVM_HAVE_MCE_INJECTION
 void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
 #endif
diff --git a/target/arm/cpu-param.h b/target/arm/cpu-param.h
index f9b462a98f..d71cc29864 100644
--- a/target/arm/cpu-param.h
+++ b/target/arm/cpu-param.h
@@ -30,7 +30,12 @@
  */
 # define TARGET_PAGE_BITS_VARY
 # define TARGET_PAGE_BITS_MIN  10
+#endif
 
+#ifdef TARGET_AARCH64
+#define KVM_ARCH_HAVE_MCE_INJECTION 1
+#else
+#define KVM_ARCH_HAVE_MCE_INJECTION 0
 #endif
 
 #endif
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index ec276fcd57..f92c8d3b88 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -30,10 +30,6 @@
 /* ARM processors have a weak memory model */
 #define TCG_GUEST_DEFAULT_MO      (0)
 
-#ifdef TARGET_AARCH64
-#define KVM_HAVE_MCE_INJECTION 1
-#endif
-
 #define EXCP_UDEF            1   /* undefined instruction */
 #define EXCP_SWI             2   /* software interrupt */
 #define EXCP_PREFETCH_ABORT  3
diff --git a/target/i386/cpu-param.h b/target/i386/cpu-param.h
index 911b4cd51b..5933b0b756 100644
--- a/target/i386/cpu-param.h
+++ b/target/i386/cpu-param.h
@@ -24,4 +24,6 @@
 #endif
 #define TARGET_PAGE_BITS 12
 
+#define KVM_ARCH_HAVE_MCE_INJECTION 1
+
 #endif
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 7f0786e8b9..230ab1cded 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -33,8 +33,6 @@
 /* The x86 has a strong memory model with some store-after-load re-ordering */
 #define TCG_GUEST_DEFAULT_MO      (TCG_MO_ALL & ~TCG_MO_ST_LD)
 
-#define KVM_HAVE_MCE_INJECTION 1
-
 /* support for self modifying code even if the modified instruction is
    close to the modifying instruction */
 #define TARGET_HAS_PRECISE_SMC
diff --git a/target/loongarch/cpu-param.h b/target/loongarch/cpu-param.h
index cfe195db4e..f69a94e6b5 100644
--- a/target/loongarch/cpu-param.h
+++ b/target/loongarch/cpu-param.h
@@ -14,4 +14,6 @@
 
 #define TARGET_PAGE_BITS 12
 
+#define KVM_ARCH_HAVE_MCE_INJECTION 0
+
 #endif
diff --git a/target/mips/cpu-param.h b/target/mips/cpu-param.h
index 594c91a156..45c885e00e 100644
--- a/target/mips/cpu-param.h
+++ b/target/mips/cpu-param.h
@@ -30,4 +30,6 @@
 #define TARGET_PAGE_BITS_MIN 12
 #endif
 
+#define KVM_ARCH_HAVE_MCE_INJECTION 0
+
 #endif
diff --git a/target/ppc/cpu-param.h b/target/ppc/cpu-param.h
index 0a0416e0a8..9975ae73ab 100644
--- a/target/ppc/cpu-param.h
+++ b/target/ppc/cpu-param.h
@@ -33,4 +33,6 @@
 #endif
 #define TARGET_PAGE_BITS 12
 
+#define KVM_ARCH_HAVE_MCE_INJECTION 0
+
 #endif
diff --git a/target/riscv/cpu-param.h b/target/riscv/cpu-param.h
index b2a9396dec..e6199f4f6d 100644
--- a/target/riscv/cpu-param.h
+++ b/target/riscv/cpu-param.h
@@ -28,4 +28,6 @@
  *  - M mode HLV/HLVX/HSV 0b111
  */
 
+#define KVM_ARCH_HAVE_MCE_INJECTION 0
+
 #endif
diff --git a/target/s390x/cpu-param.h b/target/s390x/cpu-param.h
index 84ca08626b..4728b3957e 100644
--- a/target/s390x/cpu-param.h
+++ b/target/s390x/cpu-param.h
@@ -13,4 +13,6 @@
 #define TARGET_PHYS_ADDR_SPACE_BITS 64
 #define TARGET_VIRT_ADDR_SPACE_BITS 64
 
+#define KVM_ARCH_HAVE_MCE_INJECTION 0
+
 #endif
-- 
2.41.0


