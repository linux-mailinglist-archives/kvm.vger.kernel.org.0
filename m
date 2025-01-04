Return-Path: <kvm+bounces-34553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA4FEA012DE
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 08:11:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B80CC7A13DC
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 07:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A81C14A639;
	Sat,  4 Jan 2025 07:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Z6bYRjn5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3AB13AD26
	for <kvm@vger.kernel.org>; Sat,  4 Jan 2025 07:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735974652; cv=none; b=DJ/fQYMuLaN4MWYfo4W+6sX/+Q1FUwAuJwkr0QaYuTV6ucf4b0m7/8L4jLFtIX8/hh573lv58DPIvGU1yzURv2F/UlkscnCh0ZHrl7n+mItupx23YUAfw9Ec8yIIShBTm3DN1lPbT/nbs2YgWlRlpafxBaVgho/KNNnAkz7cPmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735974652; c=relaxed/simple;
	bh=HxP4Adtu75MDwVxfFAefyzK8DXgmnOBXGSgkJ9QfHfc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=phtIV7qicNiaAkgvKrPMfvHi6cQL4qqWek47oUe9CQu837XCXJgiyIzVbhDC0LVCOFIT/r6/qsfYQBYdGIgemhinxWR87DTry2BgcuMuTtYBijq1Kv9Xa5q6DKpQe+fboB72uonHovoyI8Mg/+I4OzqITFP347xQhHrGE4MB6qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Z6bYRjn5; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-215770613dbso133860955ad.2
        for <kvm@vger.kernel.org>; Fri, 03 Jan 2025 23:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1735974650; x=1736579450; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ABNYI9qAA9SBf9uo6S4BLgQmvQh4QX0lH8r8/G8LADw=;
        b=Z6bYRjn5k4a/Tee0wzMSHJA4qytKDn8T+TsC5vS4YJ6WPiSQH4EGECw1RNN22bzCIS
         iH8bX0DFr8jawm501AzZXAVofbVvn3QE28R/mjtYT459mpMPx0GWGs17cHPB6lE2BjHh
         c2tiKEfnha8HugTKVjJUx9HxV5A6SQYKWQ3oBiRy+nIu1uyP0b0lI3EYfmoWkpL4htR2
         zWeNTdu7l3gP55Cg1uekMfZGBADLcsYwfEpihdz4HybxdkNwpOng8/elA+Blfehj1CTh
         Bn+P8TWZ77ftRJRnfiyJJbBUzm2YpBrYHqE162SjrmJtNNU5f+vCjbPGnyb9ff50gW1n
         X27g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735974650; x=1736579450;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABNYI9qAA9SBf9uo6S4BLgQmvQh4QX0lH8r8/G8LADw=;
        b=uiHEuG4Jhvtt11m3hjCfaQBBLsPIBE3YtqAwn87DSd6LPPmtHB7xGz7fSs37Qo8IlF
         gaLki0+Uf5Rg9ju3YPBXofssEQemL8XL3eiD9mBLm2NZdFTOC6LFDp3HeWm1qD12TfLH
         Wjm3WikTi2Nu95fW9pF0gnX3dF0HtAQcoN9tdMAQXEOj6y0zu2dEGD73imuoBjt+exzd
         yAbxR1DsLwPXc0MIMBuxM6s+AorCGdo96Obr2BOZHAMGc8W8AL5A06czctPP4Z3Cqj44
         oXG62ksU+xENR44Lc4KlF2DXYOgFO+bTuMuAFDL0LIO3Sezf1pDUtHE8MnNgy6nw5Km9
         oLcg==
X-Forwarded-Encrypted: i=1; AJvYcCWwX5N5C56W32IxMHhTtRFubIchXQAYu7qdDJ7TCc3DGq1HR89rmN+XCvzc2616l+fBuFA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxifgcHMVj5dAfeDLxoMAGtk8p/RlZghm/pPKmpLtN5TY726U6N
	t5D6dmwlwp/FkgCkfAU4DBwaKpPm86YhHbrIro9Nxw+eJ+RdNzlTeJ4ReikAnj0=
X-Gm-Gg: ASbGnct8tFESyymhm46szZ+7V6b10C8IgdFww6lZCSicFpO7xgblXWJ3CJlRwggvp+W
	DoJjIiKDlHjg6VpmjKc8R5Ovcwm9+oDDnIEOrmR3hFsAEYAJtuXaMn+DIufJOOVacrB4zDmAhY2
	7mc+UKk3ztp0ovGOW7OcHheBheE1RJHvqQ+lpfWEnSC4PRw/gJdr0Oztr1XZSCfpJdoRT3mtVSx
	T0Y7r5fBip6gXsn+YGxg9HxxnemT0X+n/AN30YmjB6FQIUUMS9pM6Njw2Fg
X-Google-Smtp-Source: AGHT+IH9cIovBdI7apBi49hnHAx268iqJjPX7q/SQxTwSH78rcby56/Ns0yD/ValOQ1tHuWl1FxSLA==
X-Received: by 2002:a17:902:cf12:b0:215:a2e2:53ff with SMTP id d9443c01a7336-219e6e85cc3mr769414135ad.11.1735974650031;
        Fri, 03 Jan 2025 23:10:50 -0800 (PST)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-219dc962933sm256517005ad.56.2025.01.03.23.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2025 23:10:49 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 04 Jan 2025 16:10:42 +0900
Subject: [PATCH v5] target/arm: Always add pmu property for Armv7-A/R+
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250104-pmu-v5-1-be9c8777c786@daynix.com>
X-B4-Tracking: v=1; b=H4sIAPHeeGcC/23MyQ6CMBSF4VchXVvT3o668j2Mi9JBumAIKIEQ3
 t0CCyW4PDf3+yfU+Tb6Dl2zCbW+j12sqzTEKUO2MNXT4+jSRkCAEwkX3JRvbJwIUnmwwhGUPpv
 Whzislfsj7SJ2r7od12hPl+ve9xQTrEBeKLBca8NvzoxVHM62LtES6OGLFJUbgoQC88zzHBxz4
 oDYH8QS0lZZqoU2AOqA+A8CsiGeEBjIQQeZEx12aJ7nDyAZT6I2AQAA
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 devel@daynix.com, Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

kvm-steal-time and sve properties are added for KVM even if the
corresponding features are not available. Always add pmu property for
Armv7+. Note that the property is added only for Armv7-A/R+ as QEMU
currently emulates PMU only for such versions, and a different
version may have a different definition of PMU or may not have one at
all.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
The "pmu" property is added only when the PMU is available. This makes
tests/qtest/arm-cpu-features.c fail as it reads the property to check
the availability. Always add the property when the architecture defines
the PMU even if it's not available to fix this.
---
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
 target/arm/cpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index dcedadc89eaf..e76d42398eb2 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1761,6 +1761,10 @@ void arm_cpu_post_init(Object *obj)
 
     if (!arm_feature(&cpu->env, ARM_FEATURE_M)) {
         qdev_property_add_static(DEVICE(obj), &arm_cpu_reset_hivecs_property);
+
+        if (arm_feature(&cpu->env, ARM_FEATURE_V7)) {
+            object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
+        }
     }
 
     if (arm_feature(&cpu->env, ARM_FEATURE_V8)) {
@@ -1790,7 +1794,6 @@ void arm_cpu_post_init(Object *obj)
 
     if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
         cpu->has_pmu = true;
-        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
     }
 
     /*

---
base-commit: 38d0939b86e2eef6f6a622c6f1f7befda0146595
change-id: 20240629-pmu-ad5f67e2c5d0

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


