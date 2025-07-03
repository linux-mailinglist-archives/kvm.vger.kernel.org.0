Return-Path: <kvm+bounces-51449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 653BAAF715B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D381A483DFC
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D352E49BB;
	Thu,  3 Jul 2025 10:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OseI7n8S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2662E49AE
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540388; cv=none; b=HNJ/ZAt9Z68ZTt5qk+pnx+wrRAPo2CwbVQNgl6tg2w71htumGcf2oPZ4P7P01U8lfxAjuvgj/UO//QvOUpHsUl6OVPC+i8YS/CAx7UvJJYqsk/A5QOPEvpvD7MdQ2J837YXCHY2FS29nkYpVdNPfuXb4l5e6vfU2/Yyxh042mOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540388; c=relaxed/simple;
	bh=IDtXOQ5sr+z2/Oq8FmfvxwS+WesqaxQ/fAyYhH7kMUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nkn6+1BDLYZImvS8wvGgnk4pyDRRB1ip1yPGVB4Brymi3EHFKrxFp8pVKjYYCMtpWhM5dL3Nfc8Hup2WoBptxq5K4WHjZxqVxRgOxlVF9HGveR9sHDtWsJxY8oSzLPYZ59EyQhL9xceaUVJ0WTDWYMY3Jbau2q0WvzB6t2NCkpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=fail smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OseI7n8S; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a4f379662cso4654849f8f.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540385; x=1752145185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yvjGPIKQGEYeURH3HTUPhcPT6ROyPPS2REI2o53ZBAU=;
        b=OseI7n8Skwxkm+No+1EF3fCZvqLO4UjyMMlb4gSCWRWosuQoOBO594PQ8AhV5tbvwU
         wAz50uDrCSaUOJ8Wu+MVGel9VEgR+InYb+xrWkKixoz+EnZBqRXCrNagWl1C7C/XbVuA
         5T+Gg8X88IVJr21DJ0JLfPOVVGGn7igN12GdRIdPCZaxQENd3WjM2+gzv5njgL+kU3S5
         sqg5zYe742J23fQe+xWxD8bZfOzO8JC9MxpC6BX/FAo6b1E+dwH8RVEbgiC50yngsHxi
         96ESJrRJddgB/R9uToapfW/2H/WYn/CFkw9mhTGyDqNq5PaphASrE4ui3/Gumzbp9e24
         E+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540385; x=1752145185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yvjGPIKQGEYeURH3HTUPhcPT6ROyPPS2REI2o53ZBAU=;
        b=owpO+DRGj61TXNuQnM0n9xkMUVdhss/PzN6ToTvAr3k2p5TDHTwlgp4PXFb9MVSM/b
         keWwel6o0N8arPlSMJc/TKkM8hFKjEJxTEzKzt7gxnImr6/B5CJSdF3R1ZHrdmxrnAgL
         D2kV0GPoiGlK0OC79QGFcB1odb/VusZ0/TF+iM9GMjo6X9u5BLlgskWynwMXP57EMecy
         hfm3rOTGrbbg9drXdbOWrffGpP4NnX3Q0mwrvGfsLPSGQnhUCJeL1zaOf96bTFqlPVKy
         YTbbtjNW/M6k9dp8t7m+UxRsSs+C7fK7ExIvjWMzPMyCFDnbh8kLLvxZuaLSbLzoEM+m
         VSQw==
X-Forwarded-Encrypted: i=1; AJvYcCUkxC0qU2ro9lmNjHVyAzKIPIfmRvoRM9V3CDPLr92uS2v5PMspEYAZBNlRT4UeCZwGEXE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnKzj/CfReXzUuyfJn1nZTz3M3CT1HXWD/LMLiGzIrwqHlts1R
	Ukv2pUaCFidNg9c0FVO6zAhlMi/Z7naQVp1YovL6b/kYCAG+MhIic0mBiFG7wWOf4jU=
X-Gm-Gg: ASbGncsmVGohJ/U5tSOdNk7XjxH80/iYrUXo3xxMMiLoyQz/yOkmLBGO462oRyxvXnF
	bbzYD7xECf6dSkVjNKGOZINg8GCVQwfymhJod9nqN9VQTycW72WY0MgR0o9il+1Zocn/vDjoHmI
	y0adsyyamIFwgJeq4z3AqMpj+coE1ZYZXJPBo5321TL64QUckGmeTsIlloXtkkSrM4rb413+qMJ
	fc4G7VDtCgEJsgzb/HFQ6T4tSbrEp4hIX0CGwL9KFqemfey+ql5hKywIkYXkCygYsMRiSyptt5L
	FkyY9xkbnGFUTpe09c0HM4V6OCnf9aqbsK2tjIv2iFtyMh86BN6sE3/KGS79hEsdXY7HFX7L9UU
	Kqu94shQc51Kfa4je3fKR8g==
X-Google-Smtp-Source: AGHT+IFFe1vpP0h0GeInGGctD4CBQmH2oRt74qF+x5fBthfRdo/V9+4qQpVqJEAS4Y6Z8oDf+L/60g==
X-Received: by 2002:a05:6000:4028:b0:3a5:287b:da02 with SMTP id ffacd0b85a97d-3b200b4657bmr5027241f8f.40.1751540385416;
        Thu, 03 Jul 2025 03:59:45 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7e72b6sm18614690f8f.15.2025.07.03.03.59.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:59:44 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 46/69] accel/system: Introduce hwaccel_enabled() helper
Date: Thu,  3 Jul 2025 12:55:12 +0200
Message-ID: <20250703105540.67664-47-philmd@linaro.org>
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

hwaccel_enabled() return whether any hardware accelerator
is available.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/hw_accel.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/system/hw_accel.h b/include/system/hw_accel.h
index fa9228d5d2d..49556b026e0 100644
--- a/include/system/hw_accel.h
+++ b/include/system/hw_accel.h
@@ -39,4 +39,17 @@ void cpu_synchronize_pre_loadvm(CPUState *cpu);
 void cpu_synchronize_post_reset(CPUState *cpu);
 void cpu_synchronize_post_init(CPUState *cpu);
 
+/**
+ * hwaccel_enabled:
+ *
+ * Returns: %true if a hardware accelerator is enabled, %false otherwise.
+ */
+static inline bool hwaccel_enabled(void)
+{
+    return hvf_enabled()
+        || kvm_enabled()
+        || nvmm_enabled()
+        || whpx_enabled();
+}
+
 #endif /* QEMU_HW_ACCEL_H */
-- 
2.49.0


