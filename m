Return-Path: <kvm+bounces-45301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A44EAA83F1
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAB29179F77
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FAD01624C2;
	Sun,  4 May 2025 05:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fpNhMJt2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413E4188907
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336569; cv=none; b=SZgue8ynskSNWm7sqnxMlondRpDWgTkEEz3+Kyp6Fem8uTejxXuo2N5BuVgpfXCO8lZrbE+Qse8/0bZDX4JDtarJHbE76adrnd+S3FNkJVbdxHz7VdePuO3BgNxxhGpbkqRfxXoocvvlpMF6oATOJtVwhQyi4umpC2/IoIZhQzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336569; c=relaxed/simple;
	bh=m1DRJ3QbS/3fqgC3jyFLitIJTXEb4Mtan93MiLUIBuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rsy8SYWVjnqkEWGAlbLGvBohbOgTrmPNCjJu9HBHLmaTOn9ryYtZmPa1VeF2agSN3MckkTd/NmYBdTYYGs3LWgjyXfWJuz+rlzN9azreaP+/UtFBKVAteW4t+FiV7miFu8o1Kv8jrITgywO7rZj4Xo8zqkorSzhgbRVxvC/gbS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fpNhMJt2; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-736bfa487c3so3067243b3a.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336567; x=1746941367; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gch+3DQ1xFSIgoe8nsFHA95PeotLzKWriKqshNx+4Kc=;
        b=fpNhMJt2T9yRORJhAW0vAwN95V8Bg1bTAIMdvbNHO0kSX37gHyMfY6I1bZZP8Uwtjd
         3aKTgAdxFP5DwM8htrjw7s7NR411kmlO4N/lP7Ut3IJQhiFKnhOJ+E3HCgWCspNvgNMi
         HieRwZSZXYtrrwxBnZRn1Ft+K86Ka6dC7Q5blC0Z9cECMldWax93JEsvV6ybCdhv/3QJ
         gcxblqufq7pScMSTsmT1sGzUKHw2X048me5u8aS1w4kqTd0ZeN3BJaFzRO9bp8cX07DU
         dLX7MdC0zrNQC3U8Vnhub6ETd9w+YbP0CFRLkB+2vsoeoa/SPu5hUiZh82GaCtasybEn
         IwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336567; x=1746941367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gch+3DQ1xFSIgoe8nsFHA95PeotLzKWriKqshNx+4Kc=;
        b=qoL1rk0P4ESO4XIN17Oejbt8d+3zas+7zpKYSSm0qp8fKatxaymSmi/zelBD24DOmP
         Xn7Y0nOvYKL09E4zi1lOEDZwXitac+aNICc1TUnFdb7/8zl8RE8Dltmwq+f3sn/Gx8qY
         S2NnItHTFy/CO/zTU6sfRM/abR53T6OjiNZcKaFuoTRZED1OWx9n96msmtE82ikgnEmL
         yvnCst8/7lbQG/131zS8RTlr3fVQCN1zVqWHAKP5X8aTQCP29MLDbGXJ/UAohOf8Lrsk
         Mk0lRxMgnLxgBGDsJveChnbn0FGpCtESokrZ+lzNnCKHb/hjiZKVYUdv227zA595DMUV
         wBMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUR/tiazzcgZXxIUMUAZXwZMsaPVz8COFoOJjKi1fyDlh62pICKCqmmu4oXSGZqSV86Iz4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6TF065TcYuEO9KaG2xgOlijEYF8o2TBPo7/O9qV4rpW/dPkER
	aEfQPKFy8OLnMG8TwqNQjH2CGgG6DIAadKlUR49EQjjkdmZzC/TObkXToNlUWLY=
X-Gm-Gg: ASbGncsFgJE1MJwRN1uTUM3l6hnyp/Cq84ok8YNgcbqP3a5nlHippocme08chK4K/qo
	7x1kku9UOZaXDhzIBxosnlHtkOoAKHInft+OoALkZWwuO1KS1I/GgVUx77zp5DKcIHi2CL0D3x0
	o1soDqNeTpAKInhSEn1U1hK+MgaZohmsCZDW4VeNtvfGrtFzGzAVtDwTDUsQ3xV7rKUlKC+SnJ4
	C4ClTCTKDOlXy+l2N+2cCc+Wm6IA5WRoC3KY4B2FLrwyIlPy/l/11P95JoBc7eZ82WnAYO8Ry/e
	z00m6umA8s2j96E8ZqHBLrAdoiTHfsyuu8ZolQ9s
X-Google-Smtp-Source: AGHT+IGXuGRVL3Kp8Tbnh2lq0xrBRJpVKeq6VuZp/yqp7m4DrchYSA4CAHT6B8T4OdtYK0I45HTlWA==
X-Received: by 2002:a05:6a21:158a:b0:1ee:d06c:cddc with SMTP id adf61e73a8af0-20e979c95eamr4856736637.30.1746336567495;
        Sat, 03 May 2025 22:29:27 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:27 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 08/40] accel/hvf: add hvf_enabled() for common code
Date: Sat,  3 May 2025 22:28:42 -0700
Message-ID: <20250504052914.3525365-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Other accelerators define a CONFIG_{accel}_IS_POSSIBLE when
COMPILING_PER_TARGET is not defined, except hvf.

Without this change, target/arm/cpu.c can't find hvf_enabled.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/hvf.h  | 14 +++++++++-----
 accel/hvf/hvf-stub.c  |  5 +++++
 accel/hvf/meson.build |  1 +
 3 files changed, 15 insertions(+), 5 deletions(-)
 create mode 100644 accel/hvf/hvf-stub.c

diff --git a/include/system/hvf.h b/include/system/hvf.h
index 356fced63e3..1ee2a4177d9 100644
--- a/include/system/hvf.h
+++ b/include/system/hvf.h
@@ -19,15 +19,19 @@
 
 #ifdef COMPILING_PER_TARGET
 #include "cpu.h"
+# ifdef CONFIG_HVF
+#  define CONFIG_HVF_IS_POSSIBLE
+# endif
+#else
+# define CONFIG_HVF_IS_POSSIBLE
+#endif
 
-#ifdef CONFIG_HVF
+#ifdef CONFIG_HVF_IS_POSSIBLE
 extern bool hvf_allowed;
 #define hvf_enabled() (hvf_allowed)
-#else /* !CONFIG_HVF */
+#else
 #define hvf_enabled() 0
-#endif /* !CONFIG_HVF */
-
-#endif /* COMPILING_PER_TARGET */
+#endif /* CONFIG_HVF_IS_POSSIBLE */
 
 #define TYPE_HVF_ACCEL ACCEL_CLASS_NAME("hvf")
 
diff --git a/accel/hvf/hvf-stub.c b/accel/hvf/hvf-stub.c
new file mode 100644
index 00000000000..7f8eaa59099
--- /dev/null
+++ b/accel/hvf/hvf-stub.c
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include "qemu/osdep.h"
+
+bool hvf_allowed;
diff --git a/accel/hvf/meson.build b/accel/hvf/meson.build
index fc52cb78433..7745b94e50f 100644
--- a/accel/hvf/meson.build
+++ b/accel/hvf/meson.build
@@ -5,3 +5,4 @@ hvf_ss.add(files(
 ))
 
 specific_ss.add_all(when: 'CONFIG_HVF', if_true: hvf_ss)
+common_ss.add(when: 'CONFIG_HVF', if_false: files('hvf-stub.c'))
-- 
2.47.2


