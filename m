Return-Path: <kvm+bounces-50069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF698AE1B70
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:07:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B6811BC0DB1
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812CC28C86D;
	Fri, 20 Jun 2025 13:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zKhNiXsP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B44728C868
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424846; cv=none; b=Ksfhw0mdJHOZwq8Jn4zakdAvlGY585Ycc6r4+NDEP2M4paeSudP9JIzPRSdGSnKCnZtMXQSm2riya195LN99wsAyrYCLo82Wv5O/WeYXQHZ11x63ewlZ1UCtV1cctHaEOddVz2v4H9cl/N270XU2NQHuKbgW78jofa4XbvmxeEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424846; c=relaxed/simple;
	bh=fSGp+c41HR52oM7gFMj4HyWMiHeD+/dBvHQVAfF4urY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LHlG9FKB+tj7jgt85t5MsldSk9iRY3y3dulAs+eAuxmp/StxbXFFlYU5s2FELex+0r7MQUIZIya7PWp6R8X7Sffk+rEXYPkZrsPV3xOB/x31NWuJeCmTH3EC+OtldGIh29y86CVYEVy30YcPMO0XrmhzAb2XDyW4jiN308c9rVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zKhNiXsP; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-451d6ade159so14451025e9.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424843; x=1751029643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=33tTruwtHJUDsLE1NQEO6k6TPJwHdavbHWnexaTt8VY=;
        b=zKhNiXsPRhd5z9MN/G0XOedg/WUVmzinsKp8MtK+oRGDUed+8TY+SJf4AK9vt+jkKp
         cGYLjGqJR/kqtTpZl5sfaGhsR4hcm+9EwdJtKbzuuh981in+3s/orL3DbxWcKsgMHgiw
         w21mp4zhh+4BqCrRIYtwrkBbK3nQM13udE6G52tDttE61TXQ9/M8BmTCP4Pe4d6G+BZl
         O3RmshOaR1PdW39X5F48OBzPhMi2H+6UhkCaXTGwlcnNp2q7+mzwdXZp4RYjq3E4WunQ
         AYWzvLNosew9vH/Z1EGQZLM939IpeFkq1D700bz/v8ZsDRj2yPmz7IoT+S3OApDCGqOc
         NVnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424843; x=1751029643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=33tTruwtHJUDsLE1NQEO6k6TPJwHdavbHWnexaTt8VY=;
        b=sNGDj/kXdbe87F3Lfm8SrJODwj9yqsEn6plcSLINhwvTZ6iJyjPD9p0O9E2nUXX178
         P6tBjSclCu/45fmi3eyewqEgFnvtFivaetl2sJnlXBIv8Y2uyfLy/8hXbKqEjmgLIvpa
         AKGxgyAjhKsa+mXG4mtxI3cSRVfKddpHuahC6LUekmVY+IAvpFjD5kKIG/5ONHJbqn09
         XHDw6mVRJcYFgjDXJR3z9v2dIUxhB16NlMoYFBDfE/wz/up0NCtEejgxEL8fw4/bi0kN
         5yzkGb4eq9dV5VcHBFhCxTHIk7WwVytCUooTr7PPUPL7vDFWnCXPcahcBntTBBrUwAzF
         sOMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpsBNAecy5H884ugruFOYLjRyL7LMdNn4av+uyc8Q9qE3EhSG3mDQGAntHEr0p90N0lk4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQZNvY3J6mdaRoHGh8cfbXB5FO6mjyDa0J8McjhZEcfSohsxRJ
	hsx8Zpx2s9uJqovnlUOjxDjHW1qgPFeJE3FbipjYMwbLTuc/Rb9SzbQJ4LQB8TrR8o4=
X-Gm-Gg: ASbGncseQ7uIawAZDTPJQAMTFtZokXx14jW1ht7zkLonyxSHkvKRZ3AYu/Q5v9SCF52
	Z8WpiypwMNx2UsHrEM7H2ayyeQpbnCzJabQRQ1PdpdMtiyI0eTWPduxKUzMQ4qxhjPEB577Ej3k
	D+7pV0JRb4Tw4EMi6Xgj5USIuIEfWfzQvJXHXawo4tDAQXA6v4g4EnOmHhGmXAxSFAX24rlxvNN
	119RjDjG2LdWJUWUsZjhdGdkSJYHPIi5k2Qhgl3oI8Lf3xhgCT1Jo2KmUI7BgH+hrsp6Y1aehfB
	ql14JinaifFSVdYkNA1pxerowXJkS2YwjKIUvjaUAfVVG1wCG4/2dR4ZyISL0QBh8Tec6NXox48
	GoQ2q1zIz+sJHpnVjWlMytKKVdnhUO2mw+GaG
X-Google-Smtp-Source: AGHT+IEPb6wrdygh9iEg1xDu0Enz1glDmMWW79h8+hZ9AnnXvHvnm2dPPn2ChqyV+PmW9BY7cS4i1g==
X-Received: by 2002:a05:600c:35c3:b0:450:d568:909b with SMTP id 5b1f17b1804b1-453653ba6a3mr28180435e9.14.1750424843244;
        Fri, 20 Jun 2025 06:07:23 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535e983c97sm60000735e9.9.2025.06.20.06.07.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:07:22 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 02/26] target/arm: Reduce arm_cpu_post_init() declaration scope
Date: Fri, 20 Jun 2025 15:06:45 +0200
Message-ID: <20250620130709.31073-3-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
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


