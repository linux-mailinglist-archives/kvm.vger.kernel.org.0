Return-Path: <kvm+bounces-44673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52C61AA0186
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:01:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BA8517F873
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716D3270EB2;
	Tue, 29 Apr 2025 05:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="npo0IHXY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFB52749C1
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902825; cv=none; b=hobUWkZ4rUa72kS6KDhGFQv6UgPpadogrozOzM1CMycKoOZBaRkbIzVPU2SwqsUJFyTKrqB7UsLwokkgjYeA56QAD7ncUhgIFHMDvmRUG8v+e3/Qd0247xBywCTmbVxht6vwnoyQlmffEUQKwmT/UC56ir9F8TXf+4zDtoe5eGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902825; c=relaxed/simple;
	bh=bBx3RVCAvu/zswHe4Bte7YzW7LyWednFjmKafsS3qjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKLyplm6ZqEBt01Y/4UgniR4ZfdddP5uVyagsmoYqBOmaJbXxJsAUBCdxJ5IbNNvqlMKo5Cgyi3b9JdAy3CX4D3neos/T6am3v+yrX50tuTBnXgaLy9/yZ6+VtMDwTbW+sCkFAW6GL2LenMRb8rUMLCjE4wZYViGYc1JndyFEzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=npo0IHXY; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-225df540edcso66043725ad.0
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902823; x=1746507623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gyyYrSBpMjZGqDtX9J3tyJffb7EP1/gzXVNNR0hz1h4=;
        b=npo0IHXYjtw9cX+YctERLcC0dxpZ3xKEC8G0GOY5Yq1j/nf2RxytZDfQz3cNXoBANb
         EoRQvmf23b7VB303eue7Wh+8qYYvcE4XeYWfZf1cWwbsg/GvU5bxdIdbzf7kxNKaxb+j
         k3ORPm5vYLKbMccoFQVrCURg6Bg/rnNGGzlHf2270eRFLVsecuuZt9YfpdCsexwVtHUs
         S9f2GNZFWPJ2xn9Plt/rquHnMlab3Nqb79zsAEBUzfrtOeIX7PndZVppn1xWQwVAkLf3
         gLFY13ki+xo2qgnc57JK0G098npapAhFFc8G1EanTMKiKwAEuJakBLC0WNaTEvW9yX2N
         eo7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902823; x=1746507623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gyyYrSBpMjZGqDtX9J3tyJffb7EP1/gzXVNNR0hz1h4=;
        b=TpP0eMgj543IIsR5uZiPhSeWLTc2SEiL+tDgzGGFgJEaVnfJl6TWzy5tI7GngUfJcj
         +dnfSsYG3ESoOKxBZaQsOGmZ5OVqfgB0TcHfjrxnuYkPF4KrrSmvXKNxjCiRpbJjrcV2
         tJtyDAD74ImLvYWbjcTj57/VHuuE3n0AqhEFN/zmu4u6qUu84igsi148Jp0NK244et0T
         wxgjvPMMrsKn7UYarMSyd2dBfQ2ELVTVkTDrHreyFoYAawZCqzc0CSmh0F3a8aEucKsC
         I87ii/VvUqXrw1wX2jhEyjtUEjbg2XdV1xlKXwv9hD/InmR7jhy/LRdTH33LznuZ4bGI
         eq8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUOfmDzi2OP9oef6T/fGSH3KLiy+GlvjGA5kIny1IPrwQKuPAsfZr9CqQdFlxfyB3Ku5a4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCQuru4HBSt//PFPEqvAzwxDxkzZOhF5ijK27+YXHyH8DJgPAA
	gw/PjORp7qmj7ACHr3DwYRPtlHc0wF3nDB9OOizycay7HQsQo9SMIDFFdBSwDJ8=
X-Gm-Gg: ASbGnctgc0HCTBctXRBBEnGkZ7Xxy5RHFkZLxrioa1XNdC7kqofAlfW/Ydz3WYSH4Cg
	E0lzFvfx1cAuHcz/3iwP4Vx3Hb6qKnNUQf2d4aVoIlNIbKzL70+vMO5J2vk8pasY5ewmETYST8t
	ENhZXoorXeA01sfUPftR3fcRJxp7HC5IwIDVqEKqgLtEMwOc5vlZ+7U41tOadrCgDckp2+N9X1B
	xAZK96QjNmEIGTfEgjZmCLjRH0mJq+k6JRnPBaE6ZbaYnpNuxYxajudZqZ/FrcPiee9KKhK6TPA
	WqXOzGl7nzoOVMWfAwvrLCbGPWjxAMz/bE9Q0vfV
X-Google-Smtp-Source: AGHT+IGe2Vt41jFcsiUP8gtDdpGA+OGNZ8jHnyxm346MtXJL2horun4dC7fIa/fI75EdFBPvs9YjeA==
X-Received: by 2002:a17:903:230a:b0:215:742e:5cff with SMTP id d9443c01a7336-22de6c1e39emr23981905ad.16.1745902823374;
        Mon, 28 Apr 2025 22:00:23 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:23 -0700 (PDT)
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
Subject: [PATCH 08/13] accel/hvf: add hvf_enabled() for common code
Date: Mon, 28 Apr 2025 22:00:05 -0700
Message-ID: <20250429050010.971128-9-pierrick.bouvier@linaro.org>
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

Other accelerators define a CONFIG_{accel}_IS_POSSIBLE when
COMPILING_PER_TARGET is not defined, except hvf.

Without this change, target/arm/cpu.c can't find hvf_enabled.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/hvf.h  | 14 +++++++++-----
 accel/hvf/hvf-stub.c  |  3 +++
 accel/hvf/meson.build |  1 +
 3 files changed, 13 insertions(+), 5 deletions(-)
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
index 00000000000..22e2f50c01d
--- /dev/null
+++ b/accel/hvf/hvf-stub.c
@@ -0,0 +1,3 @@
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


