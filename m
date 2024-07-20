Return-Path: <kvm+bounces-22007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 37C58938073
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 11:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2FA51F22235
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 09:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3903283CC8;
	Sat, 20 Jul 2024 09:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Gk1EPqYU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5EF78283
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 09:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721467880; cv=none; b=BNM1cFhari+KhAWPQFOFwKr1+9unUvaGFe+YH31xkDUM/WyjdPqWFDx/1gauYDpCOg1RtVfIUk7V1Ox1mAexsNBExyK9x5n/9PQr8rNeelmXfsaNFZvTRiQo56VXo1+ZS3bQK5l3Tl+LncfkG/ucMKIpwe0jnEw99xbZ/l9VlHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721467880; c=relaxed/simple;
	bh=KENOuYqZaiHFs1K/nBKMlxR3X2ehbrO7EpqhimHM6Zs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OnMHIUdxMISv8uZ/xdMhcD5g1/mfdN/K5KNBMkcRguFCwW2TSwSIxi6e2NPnfDOtl2VrruKnOv0dYYAxPSfioa63PflAhWRgoOSa+ZnVXuO+/uR4Qc3O8LQU09WdvMTTZa2GqrgjeH7zeO9Hn7tdE5ZpgF4+ymHmb/Ya6duBV+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Gk1EPqYU; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fc587361b6so24665685ad.2
        for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 02:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721467878; x=1722072678; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uuvru8O1Lbu3d3+4LM3J/KSbEI4f7QyyvTpp+vjJrRQ=;
        b=Gk1EPqYUx6KMFaZECbiGxpHR8qaDmWfXcPOC+xmZd1BSwsgl6C0Kc5PacR2q6Ip4ap
         MtqGyfQG2VP2wmXyXBcTW/pFftkT6bwssuL/jNOlwFXLQGOwZnLcmuTtE3kWIDnBzuQu
         y59Db7axNpsgOntrDobvWEI6uvjjuhGJRxo0WG9DZNcihotQYKfl25YmGrx4EeE7HP61
         6tTrVFJcT11p1uL5utXrbBEhUQGhrhOnUWJS7Rl833r74TXZl2kyHdm7HTPsWNa+yHl1
         1GV5w6mYi7xsdjS6IQ9yO/xbZ6OpcjfvzwdLsdiQF6tLkUNUjs1coote+FnRLC0c3ZLU
         eDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721467878; x=1722072678;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uuvru8O1Lbu3d3+4LM3J/KSbEI4f7QyyvTpp+vjJrRQ=;
        b=mZI5ir1bgrstqKAi8FhykA74R3nGRvLKgjXS2vhOyNgURsld6gi2PVVfXkPzoTqJ1/
         5xLQ7o9J7625hImtLmkY93vOsPw5ezL97P7obGikMKYOv4gL1ciV59iat7PdgLquOjly
         tFlmdbVhWdqO5jTrE7gJ11qedjqxt0RfwWs9/Z56GN7h/y62/e4jxg2DTMIMmcdoUzMQ
         jAchERR1PnRUKwRJaEP/IOBLSzK2NCy08KR5Rfq0W6lpKuWQ8MOmI6ApyglysgjVmyFt
         nNotf89Jv5nV1yXSnRZfMc09xBqAJknQuq+RECuNPmrOC1NCgwB8hy/MqVX8kgOL1NJx
         jIgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUx3wFxzYJaDcew+kZ4ftYwUIVXoWIkghKrk2zGWu9lv0eOoT6Yb4f1TDP2ffAiVcusdKpgDvpNs9BNb7iVG5xRoI/a
X-Gm-Message-State: AOJu0YxonPmud9TqFdfvBASxqwXAQiyaGarjj7hkuNL1bFRS5PLd91JN
	P1k32aFn0m0vBSrY5SqeLGwmEk4aaiWmjTeDAtcqkjklprou6Drw2dqr0zBinRM=
X-Google-Smtp-Source: AGHT+IGDxYBQ+UI3zCis37W9PvPyH5SIE5p+oC1cjVEarHMW9QkebJPnPHpAqlSz9NjhoUTUJSYbFQ==
X-Received: by 2002:a17:902:c405:b0:1fd:73e6:83b8 with SMTP id d9443c01a7336-1fd745977bamr21122635ad.14.1721467878255;
        Sat, 20 Jul 2024 02:31:18 -0700 (PDT)
Received: from localhost ([157.82.204.122])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1fd6f28f518sm18251415ad.69.2024.07.20.02.31.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jul 2024 02:31:17 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 20 Jul 2024 18:30:50 +0900
Subject: [PATCH v4 2/6] target/arm/kvm: Do not silently remove PMU
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240720-pmu-v4-2-2a2b28f6b08f@daynix.com>
References: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
In-Reply-To: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

kvm_arch_init_vcpu() used to remove PMU when it is not available even
if the CPU model needs one. It is semantically incorrect, and may
continue execution on a misbehaving host that advertises a CPU model
while lacking its PMU. Keep the PMU when the CPU model needs one, and
let kvm_arm_vcpu_init() fail if the KVM implementation mismatches with
our expectation.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/kvm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index b20a35052f41..849e2e21b304 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1888,13 +1888,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (!arm_feature(env, ARM_FEATURE_AARCH64)) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_EL1_32BIT;
     }
-    if (!kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PMU_V3)) {
-        cpu->has_pmu = false;
-    }
     if (cpu->has_pmu) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
-    } else {
-        env->features &= ~(1ULL << ARM_FEATURE_PMU);
     }
     if (cpu_isar_feature(aa64_sve, cpu)) {
         assert(kvm_arm_sve_supported());

-- 
2.45.2


