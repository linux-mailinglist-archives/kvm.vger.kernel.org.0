Return-Path: <kvm+bounces-2373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E92ED7F6649
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 19:35:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EFC81C208DC
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 18:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A144A4AF71;
	Thu, 23 Nov 2023 18:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YyrwSaN4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A88D43
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:35:44 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-332e545e852so427821f8f.1
        for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700764543; x=1701369343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+UF32mbiOniogqxmnEO/G/4hA+3MFqbkOICeJQxcwIQ=;
        b=YyrwSaN4m+Bo00dgBGmFuwh5ojnY3DiQ5GNFCT9N7xWySYBsbsWddc2WD192Myiyd0
         jTuDX+Pj4Rm7U3/5RGGo/PgvI4ayM0E/hruE/Ipw42qVzPhIZSgRDSmPRC//vmrRavaU
         vj/0O+ZlO0M7OkZzt2mx4VkG/VbV2jPtR0cmjUJwjPyxB87LcU+ji/CvbtH+9/tuimTe
         sCbtCIaZQDnp8ijrX8nvQtMQeGgZqkgcaf1MphPpMbLC0wkei7OhQ+kTjhGg05LndJlF
         8gj5nGC2KeQN6xMIt+CanCDpl0yYbGkdlLU1HxXKV4qGwKCac1bCJkPXlZLGRhD2vplo
         bt2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700764543; x=1701369343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+UF32mbiOniogqxmnEO/G/4hA+3MFqbkOICeJQxcwIQ=;
        b=gfooypR7cJ7yxA9fc1kLWwCkGRIXxsO4TXSaGmbIgCO/c93al+GL9KzAIoL7hNern+
         p2NFXan8B4+EfigGAWSwlWE+qHJEg9hOspdr0DoHv3t1xMjAiPiIp1SP870ZPPUmFQTb
         C1oieDVjCSxw1Y7bWqCOttaVHyg71yOpBaGAdGz/ODdjr1feAv3NtdfBKU737GE2akIj
         1/jZdYN+usUmtfZ7Ytbek7XwFN+Uv3bAlwk+SUc0fXwIyyzPNUEQqlTphOqHPcE1ArUY
         bX2/3+RN5332c4c1sDdQQcf7qdKexRG9sRy3RxtTmJshC3hkbX03A2U1i2sWV8Ig4F6P
         ThzA==
X-Gm-Message-State: AOJu0YxPMh4AVfTz2q5ALelpVX4kiUCi75iNQFiJA5hkFW85ieggJ8Qo
	x8TJy5tinOUjuql/JiOIpf8Qww==
X-Google-Smtp-Source: AGHT+IGltS3KwJOeq5TCm3ydg30w+N35sZn3hV62TeTHE6Z8rqYBJAB1D8TeLnzmMQ7S92iGYMJJ4Q==
X-Received: by 2002:adf:e981:0:b0:332:c9f5:e5b5 with SMTP id h1-20020adfe981000000b00332c9f5e5b5mr54137wrm.0.1700764543126;
        Thu, 23 Nov 2023 10:35:43 -0800 (PST)
Received: from m1x-phil.lan ([176.176.165.237])
        by smtp.gmail.com with ESMTPSA id k15-20020a5d628f000000b0031ad5fb5a0fsm2315722wru.58.2023.11.23.10.35.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Nov 2023 10:35:42 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 04/16] target/arm/kvm: Have kvm_arm_sve_set_vls take a ARMCPU argument
Date: Thu, 23 Nov 2023 19:35:05 +0100
Message-ID: <20231123183518.64569-5-philmd@linaro.org>
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
 target/arm/kvm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 03195f5627..71833a845a 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1857,14 +1857,13 @@ uint32_t kvm_arm_sve_get_vls(CPUState *cs)
     return vls[0];
 }
 
-static int kvm_arm_sve_set_vls(CPUState *cs)
+static int kvm_arm_sve_set_vls(ARMCPU *cpu)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
     uint64_t vls[KVM_ARM64_SVE_VLS_WORDS] = { cpu->sve_vq.map };
 
     assert(cpu->sve_max_vq <= KVM_ARM64_SVE_VQ_MAX);
 
-    return kvm_set_one_reg(cs, KVM_REG_ARM64_SVE_VLS, &vls[0]);
+    return kvm_set_one_reg(CPU(cpu), KVM_REG_ARM64_SVE_VLS, &vls[0]);
 }
 
 #define ARM_CPU_ID_MPIDR       3, 0, 0, 0, 5
@@ -1921,7 +1920,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     }
 
     if (cpu_isar_feature(aa64_sve, cpu)) {
-        ret = kvm_arm_sve_set_vls(cs);
+        ret = kvm_arm_sve_set_vls(cpu);
         if (ret) {
             return ret;
         }
-- 
2.41.0


