Return-Path: <kvm+bounces-50332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2D46AE3FFF
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B209178E39
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E44246BB9;
	Mon, 23 Jun 2025 12:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oYnyNiCM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886BB242D97
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681239; cv=none; b=ld5Jomwb+yoMXg4i57zQDeoMQETVZEqxVX8100thUJO+PcmPoLcfLw8JYd0gDY0LCF03QHHDoxm69o2IhSZZySu1TtyMrY2wrCGiK+lPuBNvFs21rqVkQ5/LB+Qv7razuI3OcJWeetDVJvnQRm5rW7fudHoavviu3CwoTz8gv4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681239; c=relaxed/simple;
	bh=BH5TW8NKSCUDEXocBuKe5C1XkYtpy0XxhVDuA1K39pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LOCpyNDiGVs46NxQ6bromiifl7FT3IRszgiGYNMxvMkld0LugEW64Y+qEIyMu5mwlJcURxvE5C3ha6RWLO7xmRtaVCm3gxf0FNzML20HGMb0AFPDPReGxnp/sy2FT6vvvrDsvqh4/VdPib/8XQWoVmNDR1y9Q3CydzqQBPbHg+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oYnyNiCM; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a50fc7ac4dso2235345f8f.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681235; x=1751286035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X1avEvgULJGN3+NnzgbjknnR4xz+wRJgrCM6KmdqT58=;
        b=oYnyNiCMP0NWOV4JmMD642J/pCcLEzoyL/V1BWnmkXbnnF4Nly+g44uJLi7X14zyg0
         Vda1RelfdzK92UckQdEwnNoYm0En+zpT8kT78oOmZrFrbtpGqTxq5HdGTnJh08kUoIVw
         jf/fjjiXR8PuM32VO4aFi7CZbvc3BhyU0Oshc4pJrpzptIeDdjbbfs450lrRmFBJLTun
         wbSgDuVAc6YyLgWxvxamOjD9XxaUoul5jpm/VdXUkjf2J0fcSV6g1yDPxGf0kcCEv1gp
         N6rlsXD0uVejFHUGoC7WiulTPoJOmF+hM1lVSdw1D7vWc9XNLw3NvofWN96+bx7CfHKq
         HCwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681235; x=1751286035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X1avEvgULJGN3+NnzgbjknnR4xz+wRJgrCM6KmdqT58=;
        b=LNLZCA0hF9igzSKoqgh/+cNMM9DYZ07Pe+bm3gt9MJ/PlXIUBfhgxXHga+zyJP948n
         KdxQPrPEy8otSy1oOoPcj+4f6PYNzFjtUQxrJxzKwxOclxH9VdplqwlaCwI+j8XhNf2e
         lmJFIiIWzs5AWFcUSbvv335MmaMnb3R7MjcVdoTjn6D81qVrbTOxKeBjAxhkAYZ13PI6
         dx8Gp0VXqk3VaB2Xynk4ZED20ByKMWFq+y9ZEJTyJGy2eCqdvOlHCQH16+HHtWvlIDi+
         9/zn9DJq+jy3RlyDLBj3DVbYpeAALX/AfypjORvjNEOxgQDEHuMTFb6d5BokyMGmiP2Q
         TsZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmagfuvrwG+pHoN6Eh1YZoA6c5ZCFS4S5mMeNji1A129OG7lDOHgJvcZ7bFgupKcXbxHQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8ev3pYF1hjAXozvXlHExxU6VEGJHD1YFG/6HiPxmWCWJg4Ucf
	O5W8/EyboxhAlEwFV8U/foA9eGSYxOmxFBwHO5PR2vFas6qIOxxZgmjvulyvNG8Cw6s=
X-Gm-Gg: ASbGncsiqyG43QQ6gzYS8j9v/j6BOtwtbkrCKNniGoTEyXiWZBMe7xvSkDqRwkRns6N
	1RzwHoXDXjsmblMcUxQQhX+HHCRu+D4CdzvlTh8H7IVIsJ/GU3BYC+TE70PGj/DETHGK2pAVPWf
	EgpZ/yK4xqM2+lDzkeAsiNM+qbFTOXg8Miukw0Q3YMcEl6oe427799QIXk79O3NO34/PRweTG3K
	QIRj8G/V8aswwlijwYHC2P8zKgydQE6HXDjGdVIiWh+WFqN/gKkTN136Xb7AsEM1iGCQ6UoXQwT
	NW8I4y8MwNsy82MjrEMPIo/a43Y1KWFBxqxgC5y116Sutn4rKIkJd8Mre/vR061sJrZkyVIDAaJ
	RaSJXp6/H0skKlVHnWPAu2I+dKHpqYzu1zBaV
X-Google-Smtp-Source: AGHT+IGfmWKuPWWupTZ/ZnEeVOjJmb/p1NM+3sPwfupLNJuwEpOvWNKETdLlJnkiht7JLvtuJ9EAAg==
X-Received: by 2002:a05:6000:40c9:b0:3a4:e2d8:75e2 with SMTP id ffacd0b85a97d-3a6d132fbfamr8548741f8f.50.1750681234897;
        Mon, 23 Jun 2025 05:20:34 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f18a29sm9449877f8f.36.2025.06.23.05.20.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:20:34 -0700 (PDT)
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
Subject: [PATCH v3 21/26] hw/arm/sbsa-ref: Tidy up use of RAMLIMIT_GB definition
Date: Mon, 23 Jun 2025 14:18:40 +0200
Message-ID: <20250623121845.7214-22-philmd@linaro.org>
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

Define RAMLIMIT_BYTES using the TiB definition and display
the error parsed with size_to_str():

  $ qemu-system-aarch64-unsigned -M sbsa-ref -m 9T
  qemu-system-aarch64-unsigned: sbsa-ref: cannot model more than 8 TiB of RAM

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 hw/arm/sbsa-ref.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/hw/arm/sbsa-ref.c b/hw/arm/sbsa-ref.c
index deae5cf9861..15c1ff4b140 100644
--- a/hw/arm/sbsa-ref.c
+++ b/hw/arm/sbsa-ref.c
@@ -19,6 +19,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/cutils.h"
 #include "qemu/datadir.h"
 #include "qapi/error.h"
 #include "qemu/error-report.h"
@@ -53,8 +54,7 @@
 #include "target/arm/cpu-qom.h"
 #include "target/arm/gtimer.h"
 
-#define RAMLIMIT_GB 8192
-#define RAMLIMIT_BYTES (RAMLIMIT_GB * GiB)
+#define RAMLIMIT_BYTES (8 * TiB)
 
 #define NUM_IRQS        256
 #define NUM_SMMU_IRQS   4
@@ -756,7 +756,9 @@ static void sbsa_ref_init(MachineState *machine)
     sms->smp_cpus = smp_cpus;
 
     if (machine->ram_size > sbsa_ref_memmap[SBSA_MEM].size) {
-        error_report("sbsa-ref: cannot model more than %dGB RAM", RAMLIMIT_GB);
+        char *size_str = size_to_str(RAMLIMIT_BYTES);
+
+        error_report("sbsa-ref: cannot model more than %s of RAM", size_str);
         exit(1);
     }
 
-- 
2.49.0


