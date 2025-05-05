Return-Path: <kvm+bounces-45355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 628FEAA8AB6
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63A8D189348C
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977E31991A9;
	Mon,  5 May 2025 01:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MA9OwJsh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE0B1A4F2F
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409957; cv=none; b=Ly/Fv8mYRga+J0/GJQOzjgCVPEGdflp8yqfPFBHupV+BJF0KRjBgH73x/oeQDVE3ZOHG502zZ0iOazNXyiCVqBNBbLO8uECUtpeHIkFwCgRK2n57NEsq6yhZ9/Sy59WgAoH6dgNQW4v9BcAcguF3NGWPoU4b4jsFQPHi/3xURzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409957; c=relaxed/simple;
	bh=m1DRJ3QbS/3fqgC3jyFLitIJTXEb4Mtan93MiLUIBuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3UI5UVHEOc8o9skomG0bj6+zHjnrSiwJUDmVz8DSgdjkDITfA7uBe7wUdLYODj2JWdBT2jue3qTxwrV1chpBWv9VHoX+13eUqBvElMF7VaHSjZ7V/SnYXIuyaoDAlR6A2xBOqE4PlPUvgf+Pk6/0A96GRKFuFKXSjyfz0xW5Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MA9OwJsh; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7376dd56eccso4378317b3a.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409955; x=1747014755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gch+3DQ1xFSIgoe8nsFHA95PeotLzKWriKqshNx+4Kc=;
        b=MA9OwJshpJ1HwmhaZ2XZHdtT2dL6/2+6Fqy2a/zmdoD2Ht0S3YX0xO+/FDo8YtSnPK
         obAda0E4cvDth0Sxu7FVAUnkX9TMDfumOj5Izdr3HMaK49GHwLAwqDhBtyYNuLutiqA4
         m9+6luRfhONQl5JHGVWPztStXE8PAMgyEpsZSg9YPso2iJa7Tyr9q5FUlkjgKTcvuWDu
         8HLv5ybxEhWtOUKJ54+giUDfRsk3phwMrFhfIgrOyxKwzyqlgYsvPKa96dDJZwbDqVx3
         sYeDpn8KM+m+F6HLkgQN5zzgugPDYyhSCCVsBde6uYuJbGduLQwDAVuqR+SaDXoFWwcb
         CYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409955; x=1747014755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gch+3DQ1xFSIgoe8nsFHA95PeotLzKWriKqshNx+4Kc=;
        b=MnS3KoD6lW3gtREEdkA2MoR/t0615dbiVnvUFiTd3fiDILb+5Stx47bNUEcWhZSeKv
         ftkPS7wVv5HX0DVgymTw7c30ws1nKxAYy92KRSu7kC6BLHUw3sQAEOwkJGG4UBZGqzKa
         joNq1YT8llzD42QC1eEmHo7qo46r8zihLY5cH1ON5v2kyFCd9lTp1GN8vhIUYrUk5kwA
         bBgJEaEEpixNys9s3yQE5ZrqK0oln/cnsFosTaqlsNus9Z4Y0lj0NlA2M/L8Z70vldcg
         jvfT7vbNYqQAIu4OaHR5Axi+ikwwErXYAN6li/sccWB7W8KKTTt0rDFbcamFEjki6dJ3
         yUaA==
X-Forwarded-Encrypted: i=1; AJvYcCURHZ3Q3QYNBLcd3/BD90ilsg/HJUAPnsrnkOXOKNdeqZbgwlHDRfd3Nd6E4bQ44YyBqu8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw9+rqEtLHA5KCb1JoQMx/LqKLwOh4D4vHw1UcZJD1zdsTRk+w
	nQ5wtVjx7eDBJj+7W6colxiV8UGzOW3Ncvsltgu4fN6lGnvgBN0EzPwW2hJtq6M=
X-Gm-Gg: ASbGncvZv7H6QvtBFUIP5ZKyh5VucfQBAyw+tXMy0mBJye6ONqA2x1G0cuMvT+GoUov
	/F0xf/8YSiBY6i+Bv6uL3gLL+lwIAH3wSV0Wf1DdJcfKZAlEF1K/XZ7/Gzn/l/Eql0aSnuD24vM
	TNG4ObLgwMa2fxM4pISRNdNEqE6WJidqDuHl1KYPUoNNuSccOWw8IsoB4H/pX2e4kyHIjXeLnmv
	yuu7SLUmSf6FSf/YO5d/iTCtjt6yDIQGobs8KDSC5Mcjh3J3jrqWnCWgpXQb5VhgOH8WHBxWDUn
	FPpSVzKw+x9HgEdVGXtiICucLMlry4gSfFP0EFDQ
X-Google-Smtp-Source: AGHT+IG3mk4YchgUCP/a9nj/YMSOA0RTdRB6Fap1pC1sILKdC2nI/TnxlESmc9cZlPoV9aa77RPxEw==
X-Received: by 2002:a05:6a21:3a4a:b0:1f5:67e2:7790 with SMTP id adf61e73a8af0-20e966057a6mr6754727637.17.1746409955584;
        Sun, 04 May 2025 18:52:35 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:34 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 08/48] accel/hvf: add hvf_enabled() for common code
Date: Sun,  4 May 2025 18:51:43 -0700
Message-ID: <20250505015223.3895275-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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


