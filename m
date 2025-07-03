Return-Path: <kvm+bounces-51446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6646FAF7145
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0DC84E4DB3
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49A862E3B03;
	Thu,  3 Jul 2025 10:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="up+uCPbP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B391C29B789
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540373; cv=none; b=CD5immdLSKcKA8C+wtA8636r5P2wlpDXsHwTWQBR3sAzb+/oa2i8EfNDj0O/s+3dmQLp8MZjnQLA+zFXHLNLbl0sj3qqoglfOrxf8IyBGKwGj73C1IRh2n4x6tqFdYz+XEk+3YiJpxCUx1c9PVGJWgtOwfofwol1YnCOhNd/rIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540373; c=relaxed/simple;
	bh=XPpx+hLDxWmmeVoGYL7uQeEhoMV97UEFb/KHKg/I/j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oenJ43dQ0sOpSxqimSJj5Z7G41y2BRhCKMOTAy7OB6i3SqKEA7OEl82lUpUYjS5AczKbuHZM23sfROSVzPu5tnj1L/yB78kZjnbgJmYq3Nmiaxpd25GBrR7eMwiTqogWuwBj6HtyDltokZ5IEjPHYSU16E9axR4w8YFOWuOy4fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=up+uCPbP; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a4ef2c2ef3so4774455f8f.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540370; x=1752145170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZcPe3nYMdLPvpkVihaPaKQWmWCYPUgBDgbI5JlWA4I=;
        b=up+uCPbPpl9xynjuvQ3ZqnyKhm2Itj97gy21hJe4kyqWkxQ+/iK1t/QjhxoGFuvV/K
         f2k98XP356FCLsM+35eNkUXsOrFMYLkdz2ODQDAwoAvw+fgc0mKUJHi5+FwYi8DX2t+E
         AJTv26Rd3ovm2aRUgsb6+ZkTgrPdVGI+fI8ds3bI0sWyT7h4s6FL5e1oJzIS+2EHC5uM
         3L5dTl/eJkOH8WkeyVk7nrpDW81tu10zvjyzH6L4fwLkKqaPkU4/nUfRxbFOy2aohVBa
         ebhxxjEEa6AOxWLHDz41TQdk+MX1GKIIBriqhN0NDd4W/mOfDZiOoPiIQ5Tc9VbjjUa3
         nI7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540370; x=1752145170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SZcPe3nYMdLPvpkVihaPaKQWmWCYPUgBDgbI5JlWA4I=;
        b=aCiP6DASAdh93ycmG5k4Ekwb7BmnxKxzGWpoJAxrdLTGWwkHqrbaeb0kEowbXUZ3MX
         ijAmNDXcj5RY6DqWtUAlU+9D6ofvbeJYdNOjJC4DPpAQq/9jEzP73MVsxxrpxCwZ4gfR
         A8Q/8QsFfN9y9OlcH0THuV0xuoEYCSGiYW2AhEElsFRV8D+N4gaLkfRGZipYgGesXzlV
         PiztZh8wK1JdfeazCTjlaENaHjzW5yKxAngOFnwGDJm+KT3f8eIhePS++EPaaTFxyZLQ
         8cGk/laTrM1T2WEcq3i+sRtbE4/J5UoBDcN5n2+wRoeSp5JBJm6O5/5gbN/s+IdLv9E7
         q+tA==
X-Forwarded-Encrypted: i=1; AJvYcCUzcMDeNFDrmkxMXVw6ypgbyZxqq3MHu7S/DHGYQDx2EMl7sv7X3tl+2VhGy/5wld3HzLY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKbhNxjYmVkfDSMTJeEFJU2YsC8QfMcKrQRxo5IcFzQp6oY7+Q
	3ea4KrWBoPN5uyfjjGnNJIvEZ4ET7Eggvxw7Pb0n+wGd6P8MSR5aRshudtP6G5JaN6Q=
X-Gm-Gg: ASbGnctEBqHEoktxp4dtS60Z9eixiRQlHkH9zqIrt+06irL3Z5WAcpG89jS751pOJY+
	wWngTj8/pqyvQN6ImspPVTWJ3CEoA7qowqhkk+s/u6N/qj3roIAuGPeaJszSqCul11xnpIpvmXn
	2lHHcDbdRX32Sq/RlbFjwyWfffg2YDEhAv5adjL5xkNnxN82/48cHKtCo+dBuyCOcnsvjQcx4uJ
	ACTNsv0MxlSqJKf1FZLjxJGuswNX18tKWm90NR7W6TU8dZMCHG1ocLoPcIhH1ExjB3izRykMErR
	4YZChqU63x7dhh6VHhT0eONM4o/bl8X5LdltkdliVprtiG/f9g35bFg+JSP6+8jkV2/9p6TAmBV
	z5MHMrcW9ylnKqPEH8YY/lw==
X-Google-Smtp-Source: AGHT+IFwze08KXrOCaSqmcyC/CFjfj8WXq9xrhVTjrBsf+XDLBCCaa31XIZMiSWUsLRl+UJN8QFeBw==
X-Received: by 2002:a05:6000:4013:b0:3a4:cb4f:ac2a with SMTP id ffacd0b85a97d-3b1feb84b5fmr5425886f8f.21.1751540369971;
        Thu, 03 Jul 2025 03:59:29 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e5f8b6sm18670570f8f.91.2025.07.03.03.59.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:59:29 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 43/69] accel/system: Document cpu_synchronize_state_post_init/reset()
Date: Thu,  3 Jul 2025 12:55:09 +0200
Message-ID: <20250703105540.67664-44-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/accel-ops.h | 8 ++++++++
 include/system/hw_accel.h  | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index ac0283cffba..77bd3f586bd 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -43,6 +43,14 @@ struct AccelOpsClass {
     void (*kick_vcpu_thread)(CPUState *cpu);
     bool (*cpu_thread_is_idle)(CPUState *cpu);
 
+    /**
+     * synchronize_post_reset:
+     * synchronize_post_init:
+     * @cpu: The vCPU to synchronize.
+     *
+     * Request to synchronize QEMU vCPU registers to the hardware accelerator
+     * (QEMU is the reference).
+     */
     void (*synchronize_post_reset)(CPUState *cpu);
     void (*synchronize_post_init)(CPUState *cpu);
     /**
diff --git a/include/system/hw_accel.h b/include/system/hw_accel.h
index 574c9738408..fa9228d5d2d 100644
--- a/include/system/hw_accel.h
+++ b/include/system/hw_accel.h
@@ -28,6 +28,14 @@
 void cpu_synchronize_state(CPUState *cpu);
 void cpu_synchronize_pre_loadvm(CPUState *cpu);
 
+/**
+ * cpu_synchronize_post_reset:
+ * cpu_synchronize_post_init:
+ * @cpu: The vCPU to synchronize.
+ *
+ * Request to synchronize QEMU vCPU registers to the hardware accelerator
+ * (QEMU is the reference).
+ */
 void cpu_synchronize_post_reset(CPUState *cpu);
 void cpu_synchronize_post_init(CPUState *cpu);
 
-- 
2.49.0


