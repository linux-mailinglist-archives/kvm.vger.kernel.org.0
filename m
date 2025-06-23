Return-Path: <kvm+bounces-50313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6AB2AE3FDC
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:24:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57FAC188FF93
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B395246BAA;
	Mon, 23 Jun 2025 12:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dBChloNC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F9A244663
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681141; cv=none; b=U0vUI6ERe0FOMLjNjv2DjrMT4M2qzYsmJ8osX9N1LFigyntvme+arbFPoroscAHhGevC++DvyTCJsoOMmOcKA+XCgo/pL6C0b3EtLAaWJnsPzl/XH3pkbvtd0u7bOOXr3torKQMSKBX7T8HoL/bQvhvMBBCNzgoskhHdh4KszQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681141; c=relaxed/simple;
	bh=fSGp+c41HR52oM7gFMj4HyWMiHeD+/dBvHQVAfF4urY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OxK0H/O7i0FRyfHRC3y/hY2I/5h3djwjGZwB3dFUB9wRiIN2TmPKq31DpbKNQMTDXExMc9dZWgYgQ9cs+K0Acra1pJJTgX664uY5P3TExvSsm/hJAHmQyB3xczxlcopJ6ikQ1s8OG2yjyjHPrRWk11/58Y3c2wmDLM8qRQS1+OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dBChloNC; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a588da60dfso2485352f8f.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681138; x=1751285938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=33tTruwtHJUDsLE1NQEO6k6TPJwHdavbHWnexaTt8VY=;
        b=dBChloNCfDJdNYR0o82fwTE4OBwc1Vz4s5/s1jxs0Ti5J2ASm0IG9nA8kWkSkFzkX0
         JbnmkNGJkp764tlNavb3lvR+52Hs671YlW6S4A5hy14jFv5VapvgkH7iwbCvqIrW1sxF
         QLTU8iambqW95Trhozm7oRbe1rnmBhrkUhcDUlsP2U8whl/DC+msV2njmsSSS4VqWdTg
         kxmAOM8OkwPcEpefGU8SRovpc3ltwwTrzS2gN4JOl+UJCyhgP5/7l0azM7DMEzqHW3eZ
         6hecndKj0u5JvmsmbCcq6ZOMuF4f4sBywLBW7VqCQkN9ehbvsxT19BDjVh0z2bKTMj0S
         JVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681138; x=1751285938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=33tTruwtHJUDsLE1NQEO6k6TPJwHdavbHWnexaTt8VY=;
        b=PBWTCvINBjcjMNkKt3AUUo30Cyuzu7ofuMkUcTg13gAfnaECD3QktCpmD68uOFrWSo
         4xd/kA61ZOrO9fcsmbQppTexONoHPUqT3UaL53MNB4IJ176ZBOEhQqXYwFLwhfc0LB3y
         5/QjxWLy6++Krcjr4VSYW1+OHKRnDOTz4KVCNC7hayFGWZKLGqJu5FJo9tZT/kVl7Hmg
         n8Y/nDNwtfqWUMYuaItMWcEidkdSp5q+ZTP+7Qube8Il9ovL4nC/mFl4HjYtD+NeDJoi
         qn3Dfjpjn/bfTuaWzAKmrldhY1OI1ipfEBCgbJ3/WHWk/AKPllMz9a0hQSphWBgQV0Hf
         HzQA==
X-Forwarded-Encrypted: i=1; AJvYcCUUMkoIXvwsMXIXDIx9JfSRKtPNOtYCrDMa+PhHA/+V0F4paoudaRldhD/GKrULmfIGQ5k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLmqy/TVCPCWwLx4VYAzIt5wAgMUnXxxKrGv9GWa9oU1IQ3iFV
	OPXVpsd3bVym/OWFBrMvA5gIva7mNA0xNBMznbpUNuziu8whuShy4sdqyG1W9FtHxEs=
X-Gm-Gg: ASbGnct/D/xARTLI/IpogrbZ5qZ4Ieyc46WZ2bjM/LYKmP27jGew4TzFSlS6wjhrZLo
	Nrs33Bcd9ak2I/hmQq1wGpVKogjO8+MSUNLJIP91M+mkThSr5ZHkaUq1B3ezakO4YbMGUH5eg4L
	V/e+uA/V0m3pfNSdPhvpQYC9OIEUn1vh9ZSopABDgO867b1Gbf/YdiZjWKWylMCR8ve6uLg1pwL
	TZuwEayj4kdKlnG82eL8XlThbPPd9zhiR5ZCpLAOaGcisk+wpPbYlgmDKroVTpFF1IGr0VPJs7j
	XJRrqX1Dc02djNJmRcexgBUcM1vvwKcojZ8cUNdrLiEVd/LeQ7DT73p/XnBRHlk9iqgYAizpyKM
	kR4REV8+yU8vwfvULxz7bPC3+VHwcDzapGotBlyCatp2ASCY=
X-Google-Smtp-Source: AGHT+IEjVwbsAMNAS5by9E9W3i2mS1agngW0TG97TbFd4Y+XoqUdKx/v5toxL2DXWSaOw2EUWfZl2A==
X-Received: by 2002:a05:6000:471e:b0:3a4:dfc2:bb60 with SMTP id ffacd0b85a97d-3a6d12a9a5amr7627210f8f.26.1750681138080;
        Mon, 23 Jun 2025 05:18:58 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d118a1f2sm9166243f8f.83.2025.06.23.05.18.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:18:57 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 02/26] target/arm: Reduce arm_cpu_post_init() declaration scope
Date: Mon, 23 Jun 2025 14:18:21 +0200
Message-ID: <20250623121845.7214-3-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

arm_cpu_post_init() is only used within the same file unit.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/cpu.h | 2 --
 target/arm/cpu.c | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 302c24e2324..c31f69912b8 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1150,8 +1150,6 @@ void arm_gt_sel2vtimer_cb(void *opaque);
 unsigned int gt_cntfrq_period_ns(ARMCPU *cpu);
 void gt_rme_post_el_change(ARMCPU *cpu, void *opaque);
 
-void arm_cpu_post_init(Object *obj);
-
 #define ARM_AFF0_SHIFT 0
 #define ARM_AFF0_MASK  (0xFFULL << ARM_AFF0_SHIFT)
 #define ARM_AFF1_SHIFT 8
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index e025e241eda..eb0639de719 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1713,7 +1713,7 @@ static void arm_cpu_propagate_feature_implications(ARMCPU *cpu)
     }
 }
 
-void arm_cpu_post_init(Object *obj)
+static void arm_cpu_post_init(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
 
-- 
2.49.0


