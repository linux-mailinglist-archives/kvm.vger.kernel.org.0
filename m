Return-Path: <kvm+bounces-20726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE50691CCCD
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 14:51:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 716181F220E8
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 12:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ACCB7C6EB;
	Sat, 29 Jun 2024 12:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="WK/frdcM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706D72B9BE
	for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 12:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719665469; cv=none; b=uJJBEX1N0N2Cq3B1Uyj2dgEM/FtYfD25Ifdcw+kbm0aBrw0ZqPKo5H91HwmtaCplh+YIFUCwix5d0Ph0dy151IFEO9JmspQX63JBwMJu4XiGiMLYC23X8tSLYP2nIjDRj+M+PLAjBA7YVV9Iyl0KxOulgqsAnpqh6HJDwaLtURk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719665469; c=relaxed/simple;
	bh=k1k49SjjRKkxjnR5y8yDGKczXWO64Oj5yo/dBj0CY+0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IjVjefZSyzjaBN7THMq2ORwhUciImC+/SFDBtsch23IZIXDqoLcdYV9AOMxdlenAuu65G3GyjFxwbev+OSnz0pE/06Gem8gOjo4Ebj4MtfNl/7up5mhQK8I9nXPivtH6MiTDJ9jKR4ytLwkbRR9PwKUkc+50b3pVqVzfrnMyOlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=WK/frdcM; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-706a4a04891so1050962b3a.3
        for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 05:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1719665465; x=1720270265; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p3Ff167L5PnEkX8Hjv5zeODUS2Rm0iaQ73J60qa2lyQ=;
        b=WK/frdcMZeduuhrkeWkmgKdb7N0EUzWZxb0bKr14iiHh4fW3wEUmOzDr2bD10zCbkT
         DB21abUJkBpuw3mFIlfH8yyVuLhVohUzy2mPxJBoCJttZq8GWMzYZNzm/UfRqFZwha/j
         5QpsasRMCFB71n1yb5qOVTd8zG5aiwImJ7HRVHy+4Aqhcim9xwsJiyNYHlmuueSL9qLQ
         AlEPwxTMBW2O20rTljPR9PLxKELPXF2xutlJ+lvgxsROVsMxDokJ6mjih2SxTdHpcy+Q
         QR5p0aM5tFQG6G3uC3byYdyCrbj8F4nPvGmY3K3USOEHvgQ6qTg9M9MWc1hY35PCJixm
         bRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719665465; x=1720270265;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p3Ff167L5PnEkX8Hjv5zeODUS2Rm0iaQ73J60qa2lyQ=;
        b=P4eNAn+Q8FPFxUN9FsDvzTQmN6UVj4JnrKRz17NmQ94h2U5RMhvrjZqR3ZVfj+xFae
         YWuh5LWlPNogHeDgqRDMh3KvRj1WZTVK4RkAPJz4ccSFpFOMbThdbWd53aF/F5EBXnG3
         Uemgq85Y0ztsmSweGUOx779AD/Sd1wXxGsWJNS136VD6h2BzUIfX0VD6STfVUAcvKnHB
         OGQtTvN8L76C6l12RkB9Po5ILC8CXG+0gA24DtoR8zrUSW92FnOJISwBuTrLpKgKphFr
         Aokc/mNzQbWhSeeH6WvHQ/05EoJpuJVeJcURAA5FM7CMcDiONrEW+dtQUnUte192b17U
         vWLA==
X-Forwarded-Encrypted: i=1; AJvYcCVC4AFHyV0y7e3VBL9eoBIS3zx9tBNyp3+QTI+JtpJnqRuK2diweYj1qKDM0W4uuYzSuEZ0w98kfRVcjrtw2zhDX3aN
X-Gm-Message-State: AOJu0YwOGCl0/4Vt2LoNDIWptwbpteN8PtjPZHAD1WiXYm1cDCVa+V1f
	iuIy6Xo/AyP8nOng0u4IAQiirbUtRVFjBl5XGhw8VFkvVxwRyui1TUjGvphqlPY=
X-Google-Smtp-Source: AGHT+IFCiPS0/8zesPRbyIYow94YbPB6IyyS94I3YzDOLPGWwQAW7sXt9gryc2zlfG/1uWsWHnbXag==
X-Received: by 2002:a05:6a20:78a6:b0:1bd:2f6:e400 with SMTP id adf61e73a8af0-1bef624626bmr760352637.47.1719665464771;
        Sat, 29 Jun 2024 05:51:04 -0700 (PDT)
Received: from localhost ([157.82.204.135])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1fac1535b6esm31432145ad.156.2024.06.29.05.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Jun 2024 05:51:04 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 29 Jun 2024 21:50:33 +0900
Subject: [PATCH 2/3] target/arm: Always add pmu property
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240629-pmu-v1-2-7269123b88a4@daynix.com>
References: <20240629-pmu-v1-0-7269123b88a4@daynix.com>
In-Reply-To: <20240629-pmu-v1-0-7269123b88a4@daynix.com>
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
index 35fa281f1b98..0da72c12a5bd 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1770,9 +1770,10 @@ void arm_cpu_post_init(Object *obj)
 
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


