Return-Path: <kvm+bounces-48130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F19D6AC9B68
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 16:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9C4F4A038E
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 14:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A6E23A9A3;
	Sat, 31 May 2025 14:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="ltwYBkG0"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2732515442C
	for <kvm@vger.kernel.org>; Sat, 31 May 2025 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748703350; cv=none; b=gsDgLfG2HT+90aHAp9DZL7ekB/nYZj2fo4Rs7gXJc36WgTkndzJNu5aj82e5Cpoz+nf+vueFEAECIE5OlRUb9O8fcyFmss9MC7ttxDS/jHYVa6x3+N5cHA5bmlEfNG0Mh2ixix8sHrxHxvz6NQw+4hk8avLW2Zdy9lkWqNbu4vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748703350; c=relaxed/simple;
	bh=p6BmCRjVDDsF1AIJIfZSgZ9h6XfSxUXFKJbG7dwMxD4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=BsqxPR9oSin4K4/yfgA4alnh0iCImZrl8v0Q/stbjYpu2LfFlBijLEOJENBL6PqwgFWBIEcNf8NOqNbu4S7XeUMp6Hlapqpkrr+UVzA1K+8K/cEpFSwXnjLD+StBaQ5BbAatQYuJ8Q1jSjjZtIjsVgmOrsmTfOGn1/HHAXcL+sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=ltwYBkG0 reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [192.168.10.111] (p865013-ipoe.ipoe.ocn.ne.jp [153.242.222.12])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 54VED0ol067517
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 31 May 2025 23:13:07 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=UkwKDJFg/2nSSMYcw1889kv5A0ScloG0EqY5LY7JDfs=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1748700787; v=1;
        b=ltwYBkG0Qc8Sl2niNXO+7jf7CRes01PkK8BZctGJy4pRV1TPwfF8izuB5ImDRB0Z
         fYsciEZfW9BlltCyZFPYBb07JC0FxTL9lcH3ECYXBj80l6/VjV5hfKScGt/p/yUt
         +eZ7dKyKuqdAT1GMlvjzR+ubDa2Tq40KoGG8/1dH5qhDW6o3jsFOJYgQYSZBECuz
         XSc2qBuvUiO6ymWTPjLUZ86PL/vTLXOh4UNFSTgSySH5acBdCTTR5uYl7bMLoEw9
         gObkoFiJuoBAKEW5Mee7HaZ1C0U3Ok+f2mGXScwk8uHaFtTTyGDCfUuX//YYO/Ib
         EFXuC4b+/ONRVgvj0dOWIQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Sat, 31 May 2025 23:12:56 +0900
Subject: [PATCH v6] target/arm: Always add pmu property for host
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250531-pmu-v6-1-2bb6c828ade3@rsg.ci.i.u-tokyo.ac.jp>
X-B4-Tracking: v=1; b=H4sIAGcOO2gC/23My07DMBCF4VepvMbIHl9mwor3qLrwZUy9aFIlE
 LWq8u64jRBUYXlG8/03MfFYeRJvu5sYea5THfo2/MtOpGPoP1jW3LYABVZ56OT59CVDdsUjQ3J
 ZifZ5HrnUy6OyP7R9rNPnMF4f0Vnfr89+1lJJBN9pMJEo2Pccrn29vKbhJO6BGX4Rar8iaKgYN
 mwjZJPdBpl/kGmIEiZNjgIAbpD9g0CtyDYEASJQ8VFR2SD3g5zSyq7ISS0jd4kQMSH5J7Qsyzc
 Aqv+XawEAAA==
X-Change-ID: 20240629-pmu-ad5f67e2c5d0
To: Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        devel@daynix.com, Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-edae6

kvm-steal-time and sve properties are added for KVM even if the
corresponding features are not available. Always add pmu property for
"host".

Note that we still don't add the property for other CPUs that lack PMU.
This is because we do not know what a PMU version should be enabled
when the user sets the property to true while it is defined as an
an error for the "host" CPU when the host doesn't have a PMU.

This fixes qtest-aarch64/arm-cpu-features on the hosts that supports
KVM but doesn't support PMU emulation.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
kvm-steal-time and sve properties are added for KVM even if the
corresponding features are not available. Always add pmu property for
"host".

Note that we still don't add the property for other CPUs that lack PMU.
This is because we do not know what a PMU version should be enabled
when the user sets the property to true while it is defined as an
an error for the "host" CPU when the host doesn't have a PMU.
---
Changes in v6:
- Limited the scope of the change to the "host" CPU.
- Link to v5: https://lore.kernel.org/r/20250104-pmu-v5-1-be9c8777c786@daynix.com

Changes in v5:
- Rebased.
- Link to v4: https://lore.kernel.org/r/20240720-pmu-v4-0-2a2b28f6b08f@daynix.com

Changes in v4:
- Split patch "target/arm/kvm: Fix PMU feature bit early" into
  "target/arm/kvm: Set PMU for host only when available" and
  "target/arm/kvm: Do not silently remove PMU".
- Changed to define PMU also for Armv7.
- Changed not to define PMU for M.
- Extracted patch "hvf: arm: Raise an exception for sysreg by default"
  from "hvf: arm: Properly disable PMU".
- Rebased.
- Link to v3: https://lore.kernel.org/r/20240716-pmu-v3-0-8c7c1858a227@daynix.com

Changes in v3:
- Dropped patch "target/arm: Do not allow setting 'pmu' for hvf".
- Dropped patch "target/arm: Allow setting 'pmu' only for host and max".
- Dropped patch "target/arm/kvm: Report PMU unavailability".
- Added patch "target/arm/kvm: Fix PMU feature bit early".
- Added patch "hvf: arm: Do not advance PC when raising an exception".
- Added patch "hvf: arm: Properly disable PMU".
- Changed to check for Armv8 before adding PMU property.
- Link to v2: https://lore.kernel.org/r/20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com

Changes in v2:
- Restricted writes to 'pmu' to host and max.
- Prohibited writes to 'pmu' for hvf.
- Link to v1: https://lore.kernel.org/r/20240629-pmu-v1-0-7269123b88a4@daynix.com
---
 target/arm/cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index ca5ed7892e4e..c99d65e9bf05 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1716,6 +1716,7 @@ static void arm_cpu_propagate_feature_implications(ARMCPU *cpu)
 void arm_cpu_post_init(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    ARMCPUClass *acc = ARM_CPU_GET_CLASS(obj);
 
     /*
      * Some features imply others. Figure this out now, because we
@@ -1767,6 +1768,9 @@ void arm_cpu_post_init(Object *obj)
 
     if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
         cpu->has_pmu = true;
+    }
+
+    if (cpu->has_pmu || !strcmp(acc->info->name, "host")) {
         object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
     }
 

---
base-commit: f0737158b483e7ec2b2512145aeab888b85cc1f7
change-id: 20240629-pmu-ad5f67e2c5d0

Best regards,
-- 
Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>


