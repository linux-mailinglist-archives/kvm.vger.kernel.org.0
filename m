Return-Path: <kvm+bounces-21692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 546979321CC
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 10:28:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1296282629
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 08:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362935FBBA;
	Tue, 16 Jul 2024 08:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="rdUBMAUG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352DE502B1
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 08:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721118521; cv=none; b=pCUwOzexA88H9TWlVCmFuGup2SH5D9B4F1ka9bobkYa62og1S2JnjoVuWskqUteSOxG1vXsTI/KBURjoMZMqZPWJY3c7vB5j1I3GlXnYW0r4sD3jpBgqzAwEvkkZnIJoyDHNBItabYKsCdXHK5VDAwUeUcjoOCSUxv/+Us00oFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721118521; c=relaxed/simple;
	bh=r4LklVSQBJdNnKbC3afcFb6NZPieSYOqMCDcO+aKjE0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BCCkzuXEKwyNQ3+KtfBu1x49x1sNgVo/oZdNBATQ9NZi3bGkX5m8DyY3iXtpU0SP+lR68t+ZQe1XsKcrw/66jAZHSBkQtgkWOibCWtEftaMVOPaEMhBx87K+TyY1lr28KCPcE/9H31QtRbxSHRovDKXs6e0JzGV/N7quXjwTYfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=rdUBMAUG; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fbfb7cdb54so24450275ad.2
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 01:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721118519; x=1721723319; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1KxAC9/Pxe3NsDzOqPZpbEql5jfhTTEPjoaJwE6M8sE=;
        b=rdUBMAUGDbsHE0de72/LH5C8/rhD8Cjso8O9I6gCks/DmZIXks0eiFXnichdgRt0pH
         68NW0zPlgQZGEZXiloo4zMIsfffpji1o/XBQst2kIg845Ri1bnUzFPt+5r2YKQtV/8qH
         eog9owjxNKEeUhtLfGSv66rtrVGsTKxYJJWsGRilJsgtU4HyjTUjCVt0Lw/rY6WFDBZ0
         g0Kwk3JlaCUF+OudECdubUNZtfYEhKWUxsYgSc4YlW66kSo5tgKKPXXgtQPw3c4c3qnJ
         qXtS1GEXSClAasj2Fsti72e5keQu0CdAlU/ouhV/Czp4LTa4rkGAJhTKTiXSrWwZlROg
         Eg6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721118519; x=1721723319;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1KxAC9/Pxe3NsDzOqPZpbEql5jfhTTEPjoaJwE6M8sE=;
        b=oFngvcyneHbo0xTE4rX8NtM/mWcXbCwd0XU+zdiEVD+vBkNU0K/K/zh9dL8pmrAlf5
         K3lI1auWyrrevVgJRh37CmT6EpEFoq5flnvSaP1ggVWgvdQz3rx+hdsjrOX+/bw5fXYA
         ydWBewW/lHad7A5i5un6w3bj27R4cnt8MaMG/GDwbb6TXdZvNkYUFRt5Aq/8T/PJf6BV
         9B+KrOY0E349KMTsDgJm4B8Bc8caBDI627L0WKGbkKkZkF6ipmLvBXV5YQ3eoW4i47WU
         Du5lLofhPuo8lhY8Izo9sU8nOCwbnEzwh9IJBB40NvNngHvg7dR+P9484WsgS48c00S1
         pq5g==
X-Forwarded-Encrypted: i=1; AJvYcCXmQq2zu5XVMzWfb9twqVUewFQdEhbuVaVKwDRJ9gztDhMGKzniTwyj0x1GwaeRlROPaHyQ8mKFnNCNDFqYIU+mVl7O
X-Gm-Message-State: AOJu0Yx1vZig7uI0/P3SOjOZARbwixjxJsUaP9pJnwjBOpqxEQ4PoDkk
	NyauZ0D6gQ2YEBw0R0W7bi3g/ZmCZnSt7e0SHnWIDXsXrKzQI/D8m6uHPaVq3pM=
X-Google-Smtp-Source: AGHT+IFrqJjHfkW1n1U+uCFdO309idp+NxLuzCYnpw8ARqcXhMW5rN8oEf3Ut488eOfutxc39v5t2g==
X-Received: by 2002:a17:903:234e:b0:1fb:b35:2fcb with SMTP id d9443c01a7336-1fc3d92d0c7mr11461215ad.2.1721118519582;
        Tue, 16 Jul 2024 01:28:39 -0700 (PDT)
Received: from localhost ([157.82.128.7])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1fc0bb6ffdesm54720525ad.53.2024.07.16.01.28.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 01:28:39 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Tue, 16 Jul 2024 17:28:17 +0900
Subject: [PATCH v2 5/5] target/arm/kvm: Report PMU unavailability
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240716-pmu-v2-5-f3e3e4b2d3d5@daynix.com>
References: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com>
In-Reply-To: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

target/arm/kvm.c checked PMU availability but claimed PMU is
available even if it is not. In fact, Asahi Linux supports KVM but lacks
PMU support. Only advertise PMU availability only when it is really
available.

Fixes: dc40d45ebd8e ("target/arm/kvm: Move kvm_arm_get_host_cpu_features and unexport")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 70f79eda33cd..b20a35052f41 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -280,6 +280,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     if (kvm_arm_pmu_supported()) {
         init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
         pmu_supported = true;
+        features |= 1ULL << ARM_FEATURE_PMU;
     }
 
     if (!kvm_arm_create_scratch_host_vcpu(cpus_to_try, fdarray, &init)) {
@@ -448,7 +449,6 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     features |= 1ULL << ARM_FEATURE_V8;
     features |= 1ULL << ARM_FEATURE_NEON;
     features |= 1ULL << ARM_FEATURE_AARCH64;
-    features |= 1ULL << ARM_FEATURE_PMU;
     features |= 1ULL << ARM_FEATURE_GENERIC_TIMER;
 
     ahcf->features = features;

-- 
2.45.2


