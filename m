Return-Path: <kvm+bounces-6446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC03F832031
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0C451C24B91
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0D3321BA;
	Thu, 18 Jan 2024 20:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KvuvzeEy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF9C321AD
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608495; cv=none; b=VoyszFsSmCIdkSw2WE0LN53lQFiN1+DRtzqr5c8787zoSlhc3C02FhWVf7oWasjbRbNEQTdqXyPCKxIu/d+iFe+hm0z8L36aHc0hYOA33rYKMmb208fiqB+OfM12g3BUsrEgDT4hyTGPaAvsKd2ylRD0ZjW6ziNsVoP8cS3jny0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608495; c=relaxed/simple;
	bh=+lY2v9EH/JVH+KmAUGLxQJ2KHUR61n4xD7XCeSIX2GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HczrPuk1hLVEYjGzibZcNbAGW8zBHVYNBSCou0rubhIagqi47ZY9042B7WdbGF2n0XMm2p1UCVgvteSkt67riT0Qe+Byc7X4FHLOf2ozx2Yq9YS/iE4bu9DOQw2JH7mdV3Toh0TlCwQwvUJMiXjGavA94yZo2omPS/tuGItP4zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KvuvzeEy; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-337cf4eabc9so788615f8f.3
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608492; x=1706213292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RZro+jmubrqox1BtgtSrk1gGKfZgwoa/a4ZCw9lbhM=;
        b=KvuvzeEyLNOnmNyy5N8QfNlai0eyM5Z5YjG5D0GcuYzi0iLSbgz63ZFjIlPx0BPFZf
         oFI+yyhhy9tlSdFWJK8xfHFx2kIZzFh2EukWcPf5GBTN86lw+GuVqnAL7qh8pkdgrTtX
         XN999xatpSVsECtohYTY+UbLX2n0+g6Ex07UBpByV++4n0SfhZEk1h8JQ93etF96BIxy
         KCoaHo/mZqgQyf8J+JG0b9Z1FPF79pkZP8Qp5a5pTWPew9e2EJNRHNY/8714+SiS39Bw
         vUjtd7p+eKPPCeAIrbbxaGSIsjC0eNqjq/k/rdBWbVdpqT3ISsZbbaMyz6YyqI9r4WY4
         91EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608492; x=1706213292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7RZro+jmubrqox1BtgtSrk1gGKfZgwoa/a4ZCw9lbhM=;
        b=gPuJpHrwkAo4gmj0/uXO7oBRx92+xm4THjtcigPlvQKGoKisuapgO/jpBDIWB4Rcrc
         8yNRqhXRk9b0GRrbmS1ca4rgpIrSrKKQUap+iHRO7HRnvfv87Hwb+IVE2XXQZpcdE+1/
         n9tHRr1zOoDgfPmTzmo8gw/9GjTe1jvR8BllDr4quzaZ06l1BEqomAnu3Kgc4r+uaHHt
         eMmzwsRRFE946yAOLy1JsrJZ0vgtL0zx4Vmvq02jYrUk3sRh/u9XqCZxDvHd7jcsq1v3
         9A+x+zFv5xSPju6vevs5SBoDh/WRCmCNajUKoNM9d5nfBXhmh4hvhs6C44UrQmLJg2US
         +r9g==
X-Gm-Message-State: AOJu0YwrFkk+B/j9IW4+reH+iph5czYHNK3SG0uYjc3bHx8qMGf3UOUS
	kOmiWZAznAC7klLrauDl5rDH3AGhkobijffigfXNGAkE/AfQwGyUcNXRF02C1XY=
X-Google-Smtp-Source: AGHT+IHIrINmTnOMQD26Vbji91c115tW9Eh48P+DEoBgJUUBMuSZ053+kSt00YTqu9nRONkczU/a4Q==
X-Received: by 2002:a5d:6106:0:b0:336:7a58:39da with SMTP id v6-20020a5d6106000000b003367a5839damr872886wrt.106.1705608492322;
        Thu, 18 Jan 2024 12:08:12 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id d19-20020adf9c93000000b003365aa39d30sm4762614wre.11.2024.01.18.12.08.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:08:11 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Igor Mitsyanko <i.mitsyanko@gmail.com>,
	qemu-arm@nongnu.org,
	Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Eric Auger <eric.auger@redhat.com>,
	Niek Linnenbank <nieklinnenbank@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jan Kiszka <jan.kiszka@web.de>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Tyrone Ting <kfting@nuvoton.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	Alexander Graf <agraf@csgraf.de>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Ani Sinha <anisinha@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Joel Stanley <joel@jms.id.au>,
	Hao Wu <wuhaotsh@google.com>,
	kvm@vger.kernel.org
Subject: [PATCH 15/20] target/arm: Expose M-profile register bank index definitions
Date: Thu, 18 Jan 2024 21:06:36 +0100
Message-ID: <20240118200643.29037-16-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240118200643.29037-1-philmd@linaro.org>
References: <20240118200643.29037-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The ARMv7M QDev container accesses the QDev SysTickState
by its secure/non-secure bank index. In order to make
the "hw/intc/armv7m_nvic.h" header target-agnostic in
the next commit, first move the M-profile bank index
definitions to "target/arm/cpu-qom.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
Or do we want these in a more specific header?
---
 target/arm/cpu-qom.h | 15 +++++++++++++++
 target/arm/cpu.h     | 15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/target/arm/cpu-qom.h b/target/arm/cpu-qom.h
index f795994135..77bbc1f13c 100644
--- a/target/arm/cpu-qom.h
+++ b/target/arm/cpu-qom.h
@@ -36,4 +36,19 @@ DECLARE_CLASS_CHECKERS(AArch64CPUClass, AARCH64_CPU,
 #define ARM_CPU_TYPE_SUFFIX "-" TYPE_ARM_CPU
 #define ARM_CPU_TYPE_NAME(name) (name ARM_CPU_TYPE_SUFFIX)
 
+/* For M profile, some registers are banked secure vs non-secure;
+ * these are represented as a 2-element array where the first element
+ * is the non-secure copy and the second is the secure copy.
+ * When the CPU does not have implement the security extension then
+ * only the first element is used.
+ * This means that the copy for the current security state can be
+ * accessed via env->registerfield[env->v7m.secure] (whether the security
+ * extension is implemented or not).
+ */
+enum {
+    M_REG_NS = 0,
+    M_REG_S = 1,
+    M_REG_NUM_BANKS = 2,
+};
+
 #endif
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 41659d0ef1..d6a79482ad 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -73,21 +73,6 @@
 #define ARMV7M_EXCP_PENDSV  14
 #define ARMV7M_EXCP_SYSTICK 15
 
-/* For M profile, some registers are banked secure vs non-secure;
- * these are represented as a 2-element array where the first element
- * is the non-secure copy and the second is the secure copy.
- * When the CPU does not have implement the security extension then
- * only the first element is used.
- * This means that the copy for the current security state can be
- * accessed via env->registerfield[env->v7m.secure] (whether the security
- * extension is implemented or not).
- */
-enum {
-    M_REG_NS = 0,
-    M_REG_S = 1,
-    M_REG_NUM_BANKS = 2,
-};
-
 /* ARM-specific interrupt pending bits.  */
 #define CPU_INTERRUPT_FIQ   CPU_INTERRUPT_TGT_EXT_1
 #define CPU_INTERRUPT_VIRQ  CPU_INTERRUPT_TGT_EXT_2
-- 
2.41.0


