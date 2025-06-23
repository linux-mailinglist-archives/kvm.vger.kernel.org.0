Return-Path: <kvm+bounces-50328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8117AE3FF5
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D706417833F
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0031C24A055;
	Mon, 23 Jun 2025 12:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gS3jRqlA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C702472B0
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681218; cv=none; b=FbnUmF141xM1V7UGHlyr6u7kFXxzHqw2a+cBQBlMcm3KAD+Qraep/OS336q5RPY+rN/vayJikp3zXcOzqOzj4AQUrORtZv3/QQ+Zklv4Y+lPvnB9uQec+j8N2XUOypJfwYIJIRyF/bFKQs7bAC1kva4/0sO5BrO6Aeeo6sZGJqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681218; c=relaxed/simple;
	bh=2RBkFcYe6adt6N/lEYhQY7JRojJuhB3pWLTixzDtiYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CkfkNacMbDfoJH1sRSI4q1y4BRNfCEN/9JIPRDmY3hAEzk01knlIcrSAl9aX40Pv00/BfCHBHub33oRtrxtiDODpNC+Orgbs9qUkDWrPfN1gJcejHtWgWPn2M23e+/kFeCZHxNz0Bvtws7whNk7NwV9IinPOeRCyGpuubGQvaD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gS3jRqlA; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-451d6ade159so30800405e9.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681215; x=1751286015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NW0Hu04oFurHIvjEpsNrwT15qBihdHLv3c5t8qKFRhE=;
        b=gS3jRqlA1+1gUQarJw1gWREsqMzS3WP0upPhgpIJIKm+fM2r2HK5HRrW2r6wSppLOR
         VDvX65o1EzyBxKfvyDYinWmuq8Vhu7MBnxaWVv8ZRRwKnbvTfmFR78NcJYYgmacV2FR8
         WDbYHgeqlEJ3HdAvEB1WMMlQpUxo0A6Euqt/OzASIdaEM/QQaNoSUeiBWZs/3QtLcs5r
         lPGTdkkJG9B/q3d1QyCXpaKgn8zdxaXMlT3avAjpvwPk5ZGk6ntgVAEGkwY+uSMQ+3Ge
         TcpsK7IcwqM1/h6JkhpMHwwdkb1JbbtFwiqbMWBu25RvT0KE4PAMzHsEW/UWOghxESUE
         swew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681215; x=1751286015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NW0Hu04oFurHIvjEpsNrwT15qBihdHLv3c5t8qKFRhE=;
        b=hgr8bdFTvMybDmtGli208rGh4eXj3zOzAFphb1uzVs6161hzcqZXED5D0yfe5a0Npy
         Fe30Lw4uGnkzV57Tp3A2rQTJrST1B7TGCygEZQTnrX/b/4EDAN0Hi3N48rrI8sJGGsSJ
         aOBvEGIdRKvVl7vmYSFb7m70xHGOMkUVL7+k+grZZAo7EfQnQBqb1ePauj+pjERzl/9K
         FGpr/mVt015PIwOB/of4D/YLf3cQ+JAphaNNtT/mO0bLVmHmLDdkQ2EpXkne5kJYmU8j
         Zkdb2qLSWT5vnQQil8iZnrdBBg/Oupi+Vnue4zxRa1fVesQ6Nkd5MnkIs3k4cuinOFg3
         6KPw==
X-Forwarded-Encrypted: i=1; AJvYcCX7FsUbX4PN0PKXb8SqZI9rba572oscD/Ppm950nWSXPaugSZqucsWMV2M0b/SatZzx91I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3CSeNQPkzEZ9DB4qpVhczcHFhwELtNn7Z5Yn5HrdyiN4bvTtI
	JrppffMSjuk1XxDwsHDZfPJHVII3BbuaiDiMxL/uizCzqsf6yU02NPHqlXaMe3Lq/D4=
X-Gm-Gg: ASbGncsoVhs+WTlWAIzpIg2pKpwT9Ur1yN70w44C2ETubgZkeMl7H9kIcod8CMIqoSY
	+Zae33gT2Obk0VWQTtZLmHrvCr+Dqw/OzXEN8HEjR4/e40zjLul3igmU540xvTJERbczDVXVfDw
	FyW9EkuBmVGUFWbE3ksN+idscYTEj2BFQKADYQCXwsy1zedrADI/4GPfWGmtVOY+vCeS66VBmAh
	BJ6R+Ys12XSRWUoWz+4ZOOuwyrpLzSjZuHjaKRuhILK9VVg1FYCUmKbQE4bZOZCeRyoLSrMviqi
	+d33DRjM7ZHmSOs7POA0jqNobz4jyxC/klup3WqiZd1osbZQCqDw1ZfWmKWmAtgMY0h0mVKxUm/
	s4yyXN6it7xI64Q3MUpUPynJi9h6en+POUTLQ
X-Google-Smtp-Source: AGHT+IFf+qYjcOwhbvT72NmXzsm0w8Ys9vtpByCOFfjMZimo/xqX2xIjROq90NsVmzqznUgThHB+QQ==
X-Received: by 2002:a05:600c:548a:b0:442:e03b:589d with SMTP id 5b1f17b1804b1-453656c2b8emr119430815e9.24.1750681214699;
        Mon, 23 Jun 2025 05:20:14 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45365af83easm103189385e9.25.2025.06.23.05.20.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:20:14 -0700 (PDT)
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
Subject: [PATCH v3 17/26] target/arm/hvf: Really set Generic Timer counter frequency
Date: Mon, 23 Jun 2025 14:18:36 +0200
Message-ID: <20250623121845.7214-18-philmd@linaro.org>
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

Setting ARMCPU::gt_cntfrq_hz in hvf_arch_init_vcpu() is
not correct because the timers have already be initialized
with the default frequency.

Set it earlier in the AccelOpsClass::cpu_target_realize()
handler instead, and assert the value is correct when
reaching hvf_arch_init_vcpu().

Fixes: a1477da3dde ("hvf: Add Apple Silicon support")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/hvf/hvf.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index fd493f45af1..52199c4ff9d 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1004,6 +1004,13 @@ cleanup:
     return ret;
 }
 
+static uint64_t get_cntfrq_el0(void)
+{
+    uint64_t freq_hz = 0;
+    asm volatile("mrs %0, cntfrq_el0" : "=r"(freq_hz));
+    return freq_hz;
+}
+
 int hvf_arch_init_vcpu(CPUState *cpu)
 {
     ARMCPU *arm_cpu = ARM_CPU(cpu);
@@ -1015,7 +1022,9 @@ int hvf_arch_init_vcpu(CPUState *cpu)
     int i;
 
     env->aarch64 = true;
-    asm volatile("mrs %0, cntfrq_el0" : "=r"(arm_cpu->gt_cntfrq_hz));
+
+    /* system count frequency sanity check */
+    assert(arm_cpu->gt_cntfrq_hz == get_cntfrq_el0());
 
     /* Allocate enough space for our sysreg sync */
     arm_cpu->cpreg_indexes = g_renew(uint64_t, arm_cpu->cpreg_indexes,
@@ -1084,6 +1093,10 @@ int hvf_arch_init_vcpu(CPUState *cpu)
 
 bool hvf_arch_cpu_realize(CPUState *cs, Error **errp)
 {
+    ARMCPU *cpu = ARM_CPU(cs);
+
+    cpu->gt_cntfrq_hz = get_cntfrq_el0();
+
     return true;
 }
 
-- 
2.49.0


