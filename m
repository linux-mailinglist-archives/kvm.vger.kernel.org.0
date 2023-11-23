Return-Path: <kvm+bounces-2380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40EFA7F6651
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 19:36:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 737BD1C21069
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 18:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE0394D11A;
	Thu, 23 Nov 2023 18:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l2tNxw7E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BD9D7E
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:36:23 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-32faea0fa1fso685821f8f.1
        for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700764582; x=1701369382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h+SHiNudBaJoVQ05FaR4tXQE9WbV9fq8fmbm8eyNxHM=;
        b=l2tNxw7E2Ci0yc0E2BlGhCDFTMISd7lV5r8Pfvvt227jvsvFHSDj0jML5xZ3ONKqmK
         EPMM3wtvfQFhKn+gB56UXl0jODeTmy9bQkNsbZEgzwW6BJ3Qd1isqazyutDcvb3Ypf08
         /ZnSRbrw8a01JiCqHygwxfyaUUct0D5n+GzKaoxVjivrBvl051g7iHCxOOLHBZ+Sf2Aq
         EpGGAgZIIGY3eZ4nRD/O9gx3tfkiSVl1LlsXCWpGhGr8A+ixE1tFNXSqepRdnNZKIhMb
         2d7nce0dSgZ+LfZjOAgYh/aWYI/IbNnp0Y++wUvxne/R3GC84U8puepojFllF5jZBkJO
         K3Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700764582; x=1701369382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h+SHiNudBaJoVQ05FaR4tXQE9WbV9fq8fmbm8eyNxHM=;
        b=H8gKLwN5I1m3KUDBhDT1t2hUqhF4dxC3LrrVVb9v4R+5/o0vdCcg/Ue86kKlefHyNG
         zbyO2CHi02sPU1+RCobY+6k8K6tR0cAkMAXlm/yhInQbFEXIDtgwkecAbNzub0FxLFDw
         ashe32hZ6BQI/bYov2XT2xcreSJvKiGvhvaFGYIi+wjYjkWegT+zWdFY0SsIrq9RUocF
         /NhvpNO+kvb5ZIEa8mKIGNhFz8qIJDp9REqZR5c/yUA/Q0gTyDvvi2Yc3gwT8bd298Ud
         uergOu6cPil8ThzaMxCsyn71nGXcPjHMJryQl7Y1VaFX8yYb69kqTRkfd4X02En/tgr0
         3BTg==
X-Gm-Message-State: AOJu0YyC+PyliZAiGhzmzo6Y80jCYpvlGBvfYXQKMrWLwEbLRlbM0hI9
	hvYniA+lZ/6a8JJG5Ys4lwTG9LkOzxgj38Ij/nU=
X-Google-Smtp-Source: AGHT+IGQXfk+qml3Ss0hlOkQY//xmWL0biF8uHQpwCUZdUFgs8ebq6vM/C+/PFHbdhDwvJD77doXJg==
X-Received: by 2002:a05:6000:1ccd:b0:32d:c792:fcaf with SMTP id bf13-20020a0560001ccd00b0032dc792fcafmr2898941wrb.26.1700764581996;
        Thu, 23 Nov 2023 10:36:21 -0800 (PST)
Received: from m1x-phil.lan ([176.176.165.237])
        by smtp.gmail.com with ESMTPSA id d1-20020adfe881000000b00332c4055faesm2259393wrm.87.2023.11.23.10.36.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Nov 2023 10:36:21 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 11/16] target/arm/kvm: Have kvm_arm_vcpu_finalize take a ARMCPU argument
Date: Thu, 23 Nov 2023 19:35:12 +0100
Message-ID: <20231123183518.64569-12-philmd@linaro.org>
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
 target/arm/kvm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 854e423135..dba2c9c6a9 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -80,7 +80,7 @@ static int kvm_arm_vcpu_init(ARMCPU *cpu)
 
 /**
  * kvm_arm_vcpu_finalize:
- * @cs: CPUState
+ * @cpu: ARMCPU
  * @feature: feature to finalize
  *
  * Finalizes the configuration of the specified VCPU feature by
@@ -90,9 +90,9 @@ static int kvm_arm_vcpu_init(ARMCPU *cpu)
  *
  * Returns: 0 if success else < 0 error code
  */
-static int kvm_arm_vcpu_finalize(CPUState *cs, int feature)
+static int kvm_arm_vcpu_finalize(ARMCPU *cpu, int feature)
 {
-    return kvm_vcpu_ioctl(cs, KVM_ARM_VCPU_FINALIZE, &feature);
+    return kvm_vcpu_ioctl(CPU(cpu), KVM_ARM_VCPU_FINALIZE, &feature);
 }
 
 bool kvm_arm_create_scratch_host_vcpu(const uint32_t *cpus_to_try,
@@ -1923,7 +1923,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         if (ret) {
             return ret;
         }
-        ret = kvm_arm_vcpu_finalize(cs, KVM_ARM_VCPU_SVE);
+        ret = kvm_arm_vcpu_finalize(cpu, KVM_ARM_VCPU_SVE);
         if (ret) {
             return ret;
         }
-- 
2.41.0


