Return-Path: <kvm+bounces-2374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F8297F664A
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 19:35:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6140D1C21012
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 18:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 844674C636;
	Thu, 23 Nov 2023 18:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cHDmArgC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923CCD68
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:35:50 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-3316d3d11e1so698119f8f.0
        for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700764549; x=1701369349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BbxwUSVkjdWQxr0WbjMFM/ALqAenG4WEeRbrPnMTydM=;
        b=cHDmArgChxL4e9KGlI4yt/GHEqbJcByrUZDPPxMF6SIfRoZ3gKYwKKWcvBBGotElcV
         +fdQm5imOgkZn5YdaA2mGMhgWtMu2ypQ+pvLOCSlM+wSs9xGYMoB9TQwNmL/AKRFNhkZ
         yzC2a/1E+UjAg/sqaQWJnZkwaOUgG3/KaRzH+bA4ND7cfWQAuVClzgHBwJqoAwsMT4a/
         tuOMHdft661fV1dSwUofhApE08FE4Rf1WBJcbc5I1U5nZLvA0UuSQuIyCdr3JuxzZJ9z
         6SJQbJuVM7CnmuZYdRYdstX+J2Lq/nsx61/z7tVkxZ0ZVDmbSwZojNK6RwKHNomhSTxQ
         vwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700764549; x=1701369349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BbxwUSVkjdWQxr0WbjMFM/ALqAenG4WEeRbrPnMTydM=;
        b=mFm2qodl4AaVusbIZ8vmAw6kDX5AfpAJucprJM9CcU884Ia+NhVH97THG582Uyiifp
         zip8S4eu/Sp7hz45wqZduwqft8sw4xAmnfIH4qzPs9TfYSy7JPmIfsIe+cuVpUwDIvnZ
         cOh2s1yGy0OXy2011UPK6H+r3TCrsIPVghX9Dj3lzwQKQjxoGVwMPkj+lCYiSmublDEX
         NbKYlnULF1S2H0shGECdruDl3fT7LSfHTqUREPkml8DwiBv6Udgm+ls1B8po32zXB63l
         Z8IfVO8Sl4mUjms6rZAYyJnj0/L438e4cwIDvM4yD/4KMJssgn1cNeRgJ8HF4MVOkvf+
         YkEg==
X-Gm-Message-State: AOJu0YzQQjSwzFEvQ6Btvi2Hj2KDUTZgYDfjH2FsUsF0VFCGcW7qpI2e
	1kS3OruAe7pQ/9IDsSPCubKJKA==
X-Google-Smtp-Source: AGHT+IHVpBW+fxUIX3fX8nnHCAT1wph7WRPj0AJYgOhwR4F2XpN2KJZ++ptoCV/AV5CvKejHxGVv1Q==
X-Received: by 2002:a5d:4ac8:0:b0:332:e2e5:46a5 with SMTP id y8-20020a5d4ac8000000b00332e2e546a5mr37511wrs.7.1700764549059;
        Thu, 23 Nov 2023 10:35:49 -0800 (PST)
Received: from m1x-phil.lan ([176.176.165.237])
        by smtp.gmail.com with ESMTPSA id f6-20020adfc986000000b0032d829e10c0sm2293981wrh.28.2023.11.23.10.35.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Nov 2023 10:35:48 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 05/16] target/arm/kvm: Have kvm_arm_sve_get_vls take a ARMCPU argument
Date: Thu, 23 Nov 2023 19:35:06 +0100
Message-ID: <20231123183518.64569-6-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231123183518.64569-1-philmd@linaro.org>
References: <20231123183518.64569-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
take a ARMCPU* argument. Use the CPU() QOM cast macro When
calling the generic vCPU API from "sysemu/kvm.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/kvm_arm.h | 6 +++---
 target/arm/cpu64.c   | 2 +-
 target/arm/kvm.c     | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 6fb8a5f67e..84f87f5ed7 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -129,13 +129,13 @@ void kvm_arm_destroy_scratch_host_vcpu(int *fdarray);
 
 /**
  * kvm_arm_sve_get_vls:
- * @cs: CPUState
+ * @cpu: ARMCPU
  *
  * Get all the SVE vector lengths supported by the KVM host, setting
  * the bits corresponding to their length in quadwords minus one
  * (vq - 1) up to ARM_MAX_VQ.  Return the resulting map.
  */
-uint32_t kvm_arm_sve_get_vls(CPUState *cs);
+uint32_t kvm_arm_sve_get_vls(ARMCPU *cpu);
 
 /**
  * kvm_arm_set_cpu_features_from_host:
@@ -278,7 +278,7 @@ static inline void kvm_arm_steal_time_finalize(ARMCPU *cpu, Error **errp)
     g_assert_not_reached();
 }
 
-static inline uint32_t kvm_arm_sve_get_vls(CPUState *cs)
+static inline uint32_t kvm_arm_sve_get_vls(ARMCPU *cpu)
 {
     g_assert_not_reached();
 }
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 1e9c6c85ae..8e30a7993e 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -66,7 +66,7 @@ void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
      */
     if (kvm_enabled()) {
         if (kvm_arm_sve_supported()) {
-            cpu->sve_vq.supported = kvm_arm_sve_get_vls(CPU(cpu));
+            cpu->sve_vq.supported = kvm_arm_sve_get_vls(cpu);
             vq_supported = cpu->sve_vq.supported;
         } else {
             assert(!cpu_isar_feature(aa64_sve, cpu));
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 71833a845a..766a077bcf 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1803,7 +1803,7 @@ bool kvm_arm_sve_supported(void)
 
 QEMU_BUILD_BUG_ON(KVM_ARM64_SVE_VQ_MIN != 1);
 
-uint32_t kvm_arm_sve_get_vls(CPUState *cs)
+uint32_t kvm_arm_sve_get_vls(ARMCPU *cpu)
 {
     /* Only call this function if kvm_arm_sve_supported() returns true. */
     static uint64_t vls[KVM_ARM64_SVE_VLS_WORDS];
-- 
2.41.0


