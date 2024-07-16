Return-Path: <kvm+bounces-21691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1FD9321CB
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 10:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9CBA1F228C4
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 08:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF306CDC8;
	Tue, 16 Jul 2024 08:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="lGL4kPLZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A836502B1
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 08:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721118517; cv=none; b=BZXfpnuFh4GK3cZ0TyTlrGCeUNZuBQhFi1Cfwciuv41GBVMzI8k58uof3Qe/o9E48dz1czQHtHM51qrC/CoP/dipXtLiGJpkctvdyNJaulRTN2e7LdO8WqzRVW9NaRC0qAHg6+Z+DkOgIMdUn5tzSyocNyWzI3jnyEjF27R168U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721118517; c=relaxed/simple;
	bh=d13S3u6zvOUNam380BtLBXtLj2ddDqg65Tj7QN5dUj8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=X4/aW4qj64j12tKtLfJXwsB1m2WFopTiIeAys/pDiDxjwIcIrcjvOgqH5Qyj4WS4Zoa06CdqQ42x1Hlw9l9PmDFpx2ajZ+m9mKbF/d+9lZVMG5MRW73O2lHDmnyNasEjZC8zicjv0XeJmQqyEXwnziZaHfpqD4sQODF41camt6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=lGL4kPLZ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70b1207bc22so4388367b3a.3
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 01:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721118515; x=1721723315; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MzrJ2SIc0b0nCcptbEys+0+C2juhcCeb9eqlhLMneTY=;
        b=lGL4kPLZZLAWoNicTjO8N2WRv1dDpsVaBCOY1OPmwl1qcHjxlJpjaFJvTFFl0tCtKc
         TTCm8YmVnbEzJecbmXNu0gnfRyomvXnkoAO3CoQ5utoiZ2ZYlobeVMwh5F3N+rOS2cvZ
         rpZJ3IoqyhKwoPg3853UA/ot7iHqtVI6y2Vu3JDPH4WGdRdxq4mBlMfXK3R4Cavu/LU/
         bGUF3Z2q6a0wwkHvIwaViqmAnzur+S5fuVw53oAhP2cjcAQXslbsE/h6OuTItpgxNIUr
         Pdjbc2ZJtvHrrJr2Gz4i7/PEB1fgQGPpPnehSHGnIKfjRqwvuy5IeOZnATOT5Q+nwvDM
         CGMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721118515; x=1721723315;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzrJ2SIc0b0nCcptbEys+0+C2juhcCeb9eqlhLMneTY=;
        b=YA59anZlSltZBoTDu5A5cujsuPnX+b3xKHdavKfBRJCLhCbd2dauQquMb+DK4z0jhL
         CHPbUnBlwAb3UTUr7fpgoBYPmE8ci6MA1P5whj6kY3xK1vK/l3LfUUXvlVlDJJD3VIqX
         Kr1w014PjZFehy9QAZAW818WsQMgQKB6NREXbFsKzVBlEzgbVd/e9Gy935xJ4OOKOYs2
         pQC9bLrukn0GDv/m1gM9g+iM5IWyt+6Hg2MuyEQj7tXtKUIP6oM8tF1ZwVqg1oAVRFyR
         VAyZOuIA/XiRNAidG84z+kXoxfUDsGRKwXPXQ/F60ILGmDwJkbuAc9KDrNBT75gavH8a
         /8FA==
X-Forwarded-Encrypted: i=1; AJvYcCU3zpxBM8MLWjWvnNpdve0/Fjzgfm2biwabnYgOqj7wv+iL3WZ/Nf+DKQK+x//OQzaC1EJOuBeX8JCYY9l9Yxfp4lfK
X-Gm-Message-State: AOJu0YyPswM4onNB0tnijmvQVhvIPcsBNn5OqB9wwVn4/Tk7b1L4z6vL
	VOEWqFO4JwDZy7oFzbuAF+E/Vrm2Ux3ByE4Wn1q6SpqYt2NubzcuYp+XVChNbkg=
X-Google-Smtp-Source: AGHT+IEMIQeQRXNUb8ccsuZ8VrtU3dndgT6Vd8nvN3x21ZLqX5Ahg/3t5RVankt3OZCxhbx/gbmsPA==
X-Received: by 2002:a05:6a21:6da9:b0:1c0:e629:3912 with SMTP id adf61e73a8af0-1c3f12a2231mr1826892637.48.1721118515601;
        Tue, 16 Jul 2024 01:28:35 -0700 (PDT)
Received: from localhost ([157.82.128.7])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1fc0bbc2e0csm52710255ad.106.2024.07.16.01.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 01:28:35 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Tue, 16 Jul 2024 17:28:16 +0900
Subject: [PATCH v2 4/5] target/arm: Always add pmu property
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240716-pmu-v2-4-f3e3e4b2d3d5@daynix.com>
References: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com>
In-Reply-To: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

kvm-steal-time and sve properties are added for KVM even if the
corresponding features are not available. Always add pmu property too.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/cpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 9e1d15701468..32508644aee7 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1781,9 +1781,10 @@ void arm_cpu_post_init(Object *obj)
 
     if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
         cpu->has_pmu = true;
-        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
     }
 
+    object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
+
     /*
      * Allow user to turn off VFP and Neon support, but only for TCG --
      * KVM does not currently allow us to lie to the guest about its

-- 
2.45.2


