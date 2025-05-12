Return-Path: <kvm+bounces-46243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE62AB42C1
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:26:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4746E178BB7
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7415F2C1E33;
	Mon, 12 May 2025 18:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PNUfhjTJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050C3298CDF
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073335; cv=none; b=QEXK9aqRrqWL1uOoYFqKM6qhg/puiJTarE859d2c2SKrkdTXo2b3T0mQtI9/d1Gx/P8tlAEJui7m+trczgwYpLW9prPwaNfeSzehgIqGucDkJv3/nxfzMHnY4sdPKHwsdwlHwSeZPuxmQCPQtKpkw3xyslmFEK9jlVlj9OOFGM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073335; c=relaxed/simple;
	bh=uXaB3hwAbzfSC1HxfR56hDPJjV76w4U3vHxihmJ2trg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGHENE9LlMXaKC/Rtqw1s5wZHJGtpjKy4jYwAEP8WxblXg312tX9jcdjwBrl0GOI1AlauF+AUh5RYWCAMxup0noPjozKj/+YIlZ5uK7H+ua93c37652++cYMCQ/NrC2MYQtRZIOA/mqBRQn6yHjo5JkZwJ4JVRL+YEoq8XxXjh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PNUfhjTJ; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7403f3ece96so6709733b3a.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073333; x=1747678133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jg06Y7bf5KiymTc5nVCG7BgUS7AMOOtDTvF6y7Zvpa0=;
        b=PNUfhjTJNx37Y5eg7Bwswrvw0KLPzzCX5F/HH4/KbpD99MxVhnnoALkXzm4N6LuzsZ
         rrREo4RDHXp0rOG61FKvj3HQZLKWUvuLuKgdE24qEUR1o28aqGFtQNZQCXDTXraR73zi
         5d3tbIoaNmJM/IUM3yZ+lg1+BRjQdON2J9+vKhAhnMwiwJcXlhaWDN8qTUvAKDVaQuM5
         b91ja/9ddp/S+RDCUdBs70tTHQdGnDkZvxlpTrAU2sG/jkT2GBVCYtP6rV5NnHjuuisM
         PJRgX0swkXeUE23QyKY/ZHaU4prcp/JzuIU5Y86njvmwmjnrFQes4kf0Zl2nd8db0q+N
         LgWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073333; x=1747678133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jg06Y7bf5KiymTc5nVCG7BgUS7AMOOtDTvF6y7Zvpa0=;
        b=P3EtDaUVYBvOte780Oq2hloKwBX/datFQLJClD7B0fMk5IxsArRN9mTskbI4g8nNHs
         3w8JXETGBjhrQ9cvWIZdOl4u+tA0ZP4PpqwdZVRLOCQPMOlyXqSRpjekObhGJXhQ/xwQ
         zzB9JogSRlG0CzVOPH7l4bW1j6SMRbOvnSltYVCiDRMhnwpCt0JPYwazMnm4jzinauv1
         un1k3E0bGif6I1IRyh8w49f/UZSgHp1FWDK+4eOpNNdKY+v5Xdr8rf156my+CcRn9O4I
         gOJpgv7+RCGnU5XzOVNfboVA4aQ76ynakN2XfrgGlf67r8qDChexcNgoBf2TQKlUt35m
         apfA==
X-Forwarded-Encrypted: i=1; AJvYcCUvvqKOYVlEBT8HFrS4Zg7rkUndF8iGf3zGBBAq3M/EMxxC0zzDlWoFbLBGPWwh5wsNm58=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmsnmFH3dbHkImuOSu+Sph6A765KlJUN8f4LoSfvFn5oBy6BFZ
	h8fQnSx4yUPP956U8NdTV+9gEr9iQaJc5SWiGdCJmYW3FeNqyOcFnvLUgJ06cQk=
X-Gm-Gg: ASbGncvP2sTsW3Lvh/IhrwgCLJfIR6NyerjA1dKYDaGE5d9Be9/tUHmvrFMnt5G8HWr
	6m84TEV8bMMHg3LrZYTNJs1ujMjlJzXYSln7i71/9/4f5GWHYM2odJNVFHEVx5EIdudMaMAUipA
	wJH3UgOy56gHaXo78jyyEq96rD3m6ko1FQCm20nzOJZl7ZjPhoeMoqz5udctQCtk/v3dyuwneCR
	h1jiB+h+13b+kKA7xlZu60MLkR9S8cPdIPiiWbC+x18QyLc/TjioUrdn8eMHPtnPoCyF+K2YQSn
	GetWtcWUTZdB1YFWFElcDL0kW0YqouDtT1vzOXbnHz5dF53I/hcFL1B490V+yg==
X-Google-Smtp-Source: AGHT+IGHrXcPyTqv6VhW9WMXMZ97evgV0lajrk9bhPAjWob6mO4Pzdy5MdI0DQPtkguqasDBwJu0yg==
X-Received: by 2002:a05:6a21:c91:b0:1ee:ef0b:7bf7 with SMTP id adf61e73a8af0-215abb3b979mr19692569637.19.1747073333215;
        Mon, 12 May 2025 11:08:53 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237705499sm6438580b3a.33.2025.05.12.11.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:08:52 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 41/48] target/arm/tcg/hflags: compile file twice (system, user)
Date: Mon, 12 May 2025 11:04:55 -0700
Message-ID: <20250512180502.2395029-42-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/hflags.c    | 4 +++-
 target/arm/tcg/meson.build | 8 +++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/hflags.c b/target/arm/tcg/hflags.c
index fd407a7b28e..1ccec63bbd4 100644
--- a/target/arm/tcg/hflags.c
+++ b/target/arm/tcg/hflags.c
@@ -9,11 +9,13 @@
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "exec/helper-proto.h"
 #include "exec/translation-block.h"
 #include "accel/tcg/cpu-ops.h"
 #include "cpregs.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 static inline bool fgt_svc(CPUARMState *env, int el)
 {
     /*
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 2f73eefe383..cee00b24cda 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -30,7 +30,6 @@ arm_ss.add(files(
   'translate-mve.c',
   'translate-neon.c',
   'translate-vfp.c',
-  'hflags.c',
   'iwmmxt_helper.c',
   'm_helper.c',
   'mve_helper.c',
@@ -66,3 +65,10 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 arm_common_ss.add(files(
   'crypto_helper.c',
 ))
+
+arm_common_system_ss.add(files(
+  'hflags.c',
+))
+arm_user_ss.add(files(
+  'hflags.c',
+))
-- 
2.47.2


