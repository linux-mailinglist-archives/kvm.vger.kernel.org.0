Return-Path: <kvm+bounces-44670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C69AA0183
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 491517A5E57
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A61274676;
	Tue, 29 Apr 2025 05:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iyvW2Vvd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8415A274645
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902823; cv=none; b=cJLfjzoZesqET67kGLObLY2A8kPVifFcnERjNVlR9wSXwZsG/S7zmRv2TO5ePkgOb3dKE7p5pVjN2+i2XZ6I4oCipENNPAfGCLp71YpZQh5DruewiWSM/RkvZR2hO7VKiLFrAQqqPmdOOiYcM489C4vJOenVvO6LLojL3hVN4cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902823; c=relaxed/simple;
	bh=ADsgcq4M8Ky9Z7NVEmbap3hkrYglgW4IgK6SBGnMgzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1PM8knvD2ODEIBOVk8XAxa+NJXZ9zq0PRjICPhDtQ3Z5v3OYeX+One0LAB1xJ/gngrwMnDN55Q4r3MloSspFqBXaWzp3tYdUrWDoGn0zqJkZ5xiaN6A/gxv9hLU9X61ycxpwsX+yGuhMcb1kwIK8r/+yXspJUUPdmRHx/kmG1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iyvW2Vvd; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2295d78b433so59631805ad.2
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902821; x=1746507621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2y4EwfHA2FmjYRfAFQnR46OcrZnAFzvzFB4cwR27V9E=;
        b=iyvW2Vvdc8phukETSaBOIhcSbUuw/5od37+8vh12rdx6CN9SI4uaWYvJQGgK9K19Jx
         Fwjwf6qCWQMnf/Xy60Xemgh94YAkK26RUQmgQzavrlanBfkKboL2wspTZJ3lxHFH0c8Q
         sODkzILO+O8JYmNN09ZtvNQ3FdUOwa3CPx43scvBxjE23uFsVqD8YIj4pr3k2eVLXtMP
         CBDX60WZhUz0Uacdf7mvJPhTw49ohArSHe683iFHmNimAoiw3flQZqt3Pn+NQi22Fi1d
         me0gKrqS7/SsT+NCfXfZ5RBpYp9AEuemiJjBkRuMBqaEpX0UgC9vEyylsFsWFA2cnh+F
         0nqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902821; x=1746507621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2y4EwfHA2FmjYRfAFQnR46OcrZnAFzvzFB4cwR27V9E=;
        b=OuacjHAplUL6KiWczsv9BvRq5jFEftAfUStloxe+SgzxTKEtG0M5eoNLB4tItmpoTB
         UaMwuJVsOty7VarcqzyE7E5I6VGuz/Q5VpP1YQJW3CHLE1J1ZvEQaSyG8JTAKCN93+Ih
         z5ACJ7i1bg7U6gMoEjyvpHcdb4gmtpVhpiTwWrlHbJ1A7E3ePeADgEY+3+K8zOdwO0dQ
         YoTFsbT3vscvy3GuC8IoQJYWPP1DqJyY6uN6nHif0qzrUFzBfOC5ZoCTXOoVpTgY4ZHP
         cXWwcTJ+CnyMOprHkf2ouIuMXn60puVdr0cW4CQRi9Z7po6tYCO5TVlFDxsPxgbUeZns
         bCcg==
X-Forwarded-Encrypted: i=1; AJvYcCXRAnj/45dhBPjzjZFgGJm/IATLw/twnJwiG2Msn7hCRP4S+TuqA0Omo2gwAI8hE6j3lyY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj3fv2+x8/RBNZI0lk3Fah/ZfxEKKr39hfwYCtDAhWgjgZi8tE
	UaZTY29lbaZ4JRwIYxbeZ9gFy1HrV99Kf/2Cug9OEZSlfETl3Q2JyIootJKFFDY=
X-Gm-Gg: ASbGncuh7GLvnfoHMkGZGdDpqzH0w21IobIyCW/rgPcLWcYAMg6fxfKZyAsngPMSrKC
	PYN6R/eHqah+t7SGrTBQvgLQlNv4h3IEibhLY3I64yG8dsQ80HBceJlqe/C4ztle3OAy6vZti8k
	vReW2RYP63WKnJDpVWrbzogMT0Hc7iuoqX3GvxsQtNR2Yt1KkMfQT9KkVbGZKly1dDrvfqvxU/y
	tp2Inrw9ks26U0CF4MJzzuHzQLh2oU1MW9P/b1rlbXW2OZVdzJ/u9fYgBL9+TZTByjq2rWdprrn
	NGfHZEoEG1+waBEkXlRCHNwPIEx6SjXK/PLGUlE5
X-Google-Smtp-Source: AGHT+IEwNOFrIwMalkdJgnwDx51xMBl3mnoMGbe6Ccc+Gkl6QjJBvRKnrZDMFU0w1C5V9X0F1g8RmA==
X-Received: by 2002:a17:902:e841:b0:224:f12:3735 with SMTP id d9443c01a7336-22dc6a09655mr168001025ad.31.1745902820862;
        Mon, 28 Apr 2025 22:00:20 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:20 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 05/13] target/arm/kvm_arm: copy definitions from kvm headers
Date: Mon, 28 Apr 2025 22:00:02 -0700
Message-ID: <20250429050010.971128-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"linux/kvm.h" is not included for code compiled without
COMPILING_PER_TARGET, and headers are different depending architecture
(arm, arm64).
Thus we need to manually expose some definitions that will
be used by target/arm, ensuring they are the same for arm amd aarch64.

As well, we must but prudent to not redefine things if code is already
including linux/kvm.h, thus the #ifndef COMPILING_PER_TARGET guard.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm_arm.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index c8ddf8beb2e..eedd081064c 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -16,6 +16,21 @@
 #define KVM_ARM_VGIC_V2   (1 << 0)
 #define KVM_ARM_VGIC_V3   (1 << 1)
 
+#ifndef COMPILING_PER_TARGET
+
+/* we copy those definitions from asm-arm and asm-aarch64, as they are the same
+ * for both architectures */
+#define KVM_ARM_IRQ_CPU_IRQ 0
+#define KVM_ARM_IRQ_CPU_FIQ 1
+#define KVM_ARM_IRQ_TYPE_CPU 0
+typedef unsigned int __u32;
+struct kvm_vcpu_init {
+    __u32 target;
+    __u32 features[7];
+};
+
+#endif /* COMPILING_PER_TARGET */
+
 /**
  * kvm_arm_register_device:
  * @mr: memory region for this device
-- 
2.47.2


