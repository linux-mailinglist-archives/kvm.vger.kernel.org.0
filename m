Return-Path: <kvm+bounces-6439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C23F483202A
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0C99B263E2
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E602E82D;
	Thu, 18 Jan 2024 20:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cbzq4AnZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB6A2E826
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608455; cv=none; b=Emlk3+LdBom4xJvDpz0c1v5PNjUzoqBfo4tgmtS6Jceaivlv/9+izxoPRhQniBsyRSW/5klTyxQ34dhHoBGvkhb4iDHfxdx9mtZNkHYDaY0DnPg93SDVDUv8zXD5FInkM/TiNvZBKB2xA8F9mpuqBfiKxaBZRdJJhUhu/+qZZlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608455; c=relaxed/simple;
	bh=visIg9TDkX+JCM1hGXVUU37sRMCHb4KBubzA8FByllM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d8WHOkM9Uy5OL92ydPZYeMO1t6o5rfscndftWS8JmgAxK+pvfIxTJkbBBa71/Cx1EqfxKkIIHKLDYObG3Gr5ChNuGhZ9T5ouKklW9IZtqCIN2b4PFB4Q+YwKU19GuZjjjz09+Pp7dceGMz70JteZ/BCiPHsZkQKxSf187p7WYSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cbzq4AnZ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40e87d07c07so316235e9.1
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608452; x=1706213252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hzkrmNX2ysOo1dkZvzaMS1RLQpmfGYrCHnlQkXBKNY=;
        b=cbzq4AnZgrqaBTjSxSzcOVPM5f2F6ZpSopYpEBwZtMfW5yMhTqOXe7j8tjcj9bZ3vQ
         InjTjNTkD+60pCox4egM4OkZQX40GbyqfBzHdvf3AWy0H3RL6dQBBo6RhYPQ0mGrHIKO
         bm29+vJtZstDuV9hGwRT01FCt3fEXaWyJeQOvZJVqNvAM602sRlgGdGXhYL5bcVrlskw
         z2sI/riHh4ymHFjOBN92vKg4JhB+B3t529Jz2csACfgcAAool8hOtj07cKPlc1SF42kC
         t2XBU5JLXc0kr0NCoRi61YQLMLmKgpweyADEPeAiMgiG1AGYLyE8s7nfJOJuY1jecZzi
         x+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608452; x=1706213252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7hzkrmNX2ysOo1dkZvzaMS1RLQpmfGYrCHnlQkXBKNY=;
        b=E8P0stsy5hHsMWKmvb8a1c8fZQravP7pKEnn/FFUF+G9WSmwwkxo8UkCVFDRAQ3InL
         8J2xleDNnQ6RyDYpUA3Wwj89ZdNjGc5rddRrxo8DMNPjFm/6dXjABb5ULty431dLWEdA
         BvqhvpLgVtBATovnA0e12ot3Ztquu5KcaDvejpUoU/V0jzPctRnmW016GjxurtaLVPYx
         vZrp+b/3jsBDolkZB8yBufHr43QmaNMZz/PqIzubUGyx56y2z61T76RxrAvTMd9iYrEo
         4IPB+nZ49SYaitFTgZ8fKIazv6o6HTZjgzOH8d+/vh6hgpMaHppgvx+Vft8Sh8QugJQY
         rQtw==
X-Gm-Message-State: AOJu0YztSdhgXQQYfmkwJiVCZTeAUY1ho23fMxvWDrMoXnEZATjIDW8+
	HSWAeykzquUDgcoJa0bY6ZTiyRvywooFtWwrXuLxrZsQ39TNIDRbpUIjF/x2v7c=
X-Google-Smtp-Source: AGHT+IGiWJ01PrIIpUtFykW2Sm2jPJBpTM7EVQ4g3zt9d/zBQ0Fzxr+ryLJVC7MuKfPrdUNpBb4ptA==
X-Received: by 2002:a05:600c:2116:b0:40e:85e9:742b with SMTP id u22-20020a05600c211600b0040e85e9742bmr919818wml.161.1705608452264;
        Thu, 18 Jan 2024 12:07:32 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id h17-20020a05600c499100b0040d6e07a147sm25843127wmp.23.2024.01.18.12.07.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:07:31 -0800 (PST)
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
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH 08/20] target/arm: Rename arm_cpu_mp_affinity
Date: Thu, 18 Jan 2024 21:06:29 +0100
Message-ID: <20240118200643.29037-9-philmd@linaro.org>
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

From: Richard Henderson <richard.henderson@linaro.org>

Rename to arm_build_mp_affinity.  This frees up the name for
other usage, and emphasizes that the cpu object is not involved.

Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.h  | 2 +-
 hw/arm/npcm7xx.c  | 2 +-
 hw/arm/sbsa-ref.c | 2 +-
 hw/arm/virt.c     | 2 +-
 target/arm/cpu.c  | 6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index ec276fcd57..55a19e8539 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1171,7 +1171,7 @@ void arm_cpu_post_init(Object *obj);
     (ARM_AFF0_MASK | ARM_AFF1_MASK | ARM_AFF2_MASK | ARM_AFF3_MASK)
 #define ARM64_AFFINITY_INVALID (~ARM64_AFFINITY_MASK)
 
-uint64_t arm_cpu_mp_affinity(int idx, uint8_t clustersz);
+uint64_t arm_build_mp_affinity(int idx, uint8_t clustersz);
 
 #ifndef CONFIG_USER_ONLY
 extern const VMStateDescription vmstate_arm_cpu;
diff --git a/hw/arm/npcm7xx.c b/hw/arm/npcm7xx.c
index 15ff21d047..7fb0a233b2 100644
--- a/hw/arm/npcm7xx.c
+++ b/hw/arm/npcm7xx.c
@@ -474,7 +474,7 @@ static void npcm7xx_realize(DeviceState *dev, Error **errp)
     /* CPUs */
     for (i = 0; i < nc->num_cpus; i++) {
         object_property_set_int(OBJECT(&s->cpu[i]), "mp-affinity",
-                                arm_cpu_mp_affinity(i, NPCM7XX_MAX_NUM_CPUS),
+                                arm_build_mp_affinity(i, NPCM7XX_MAX_NUM_CPUS),
                                 &error_abort);
         object_property_set_int(OBJECT(&s->cpu[i]), "reset-cbar",
                                 NPCM7XX_GIC_CPU_IF_ADDR, &error_abort);
diff --git a/hw/arm/sbsa-ref.c b/hw/arm/sbsa-ref.c
index 477dca0637..b8857d1e9e 100644
--- a/hw/arm/sbsa-ref.c
+++ b/hw/arm/sbsa-ref.c
@@ -148,7 +148,7 @@ static const int sbsa_ref_irqmap[] = {
 static uint64_t sbsa_ref_cpu_mp_affinity(SBSAMachineState *sms, int idx)
 {
     uint8_t clustersz = ARM_DEFAULT_CPUS_PER_CLUSTER;
-    return arm_cpu_mp_affinity(idx, clustersz);
+    return arm_build_mp_affinity(idx, clustersz);
 }
 
 static void sbsa_fdt_add_gic_node(SBSAMachineState *sms)
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 2793121cb4..3fc144236b 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1676,7 +1676,7 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
             clustersz = GICV3_TARGETLIST_BITS;
         }
     }
-    return arm_cpu_mp_affinity(idx, clustersz);
+    return arm_build_mp_affinity(idx, clustersz);
 }
 
 static inline bool *virt_get_high_memmap_enabled(VirtMachineState *vms,
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 826ce842c0..0bbba48faa 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1307,7 +1307,7 @@ static void arm_cpu_dump_state(CPUState *cs, FILE *f, int flags)
     }
 }
 
-uint64_t arm_cpu_mp_affinity(int idx, uint8_t clustersz)
+uint64_t arm_build_mp_affinity(int idx, uint8_t clustersz)
 {
     uint32_t Aff1 = idx / clustersz;
     uint32_t Aff0 = idx % clustersz;
@@ -2113,8 +2113,8 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
      * so these bits always RAZ.
      */
     if (cpu->mp_affinity == ARM64_AFFINITY_INVALID) {
-        cpu->mp_affinity = arm_cpu_mp_affinity(cs->cpu_index,
-                                               ARM_DEFAULT_CPUS_PER_CLUSTER);
+        cpu->mp_affinity = arm_build_mp_affinity(cs->cpu_index,
+                                                 ARM_DEFAULT_CPUS_PER_CLUSTER);
     }
 
     if (cpu->reset_hivecs) {
-- 
2.41.0


