Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6823244E5B5
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 12:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhKLLuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 06:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbhKLLub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 06:50:31 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF538C061767
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 03:47:40 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso6701297wms.3
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 03:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UBTLYu0ovf90Ly8jIucNjZn0s6JSXdArNLPowmPdXjc=;
        b=nKa9tSnccFVDYKK9xreBf5E8U8DoM82aZKRzyJaAiVfBKT/M0igcWjFSqwJRmAzyH3
         /Ew5QtICgoZALTkGsvJY+v3rwwA/MyZWeZyHLaYJbIyRAaIlUtWtNmhwZVHMnU0M3Tim
         jDoFtQs3T5Su6YcUbiyDbdC2U0rnyn1ziDqio0DeO/bkjljkcIi/z8kuu2XxPvJr6JeG
         LMw1U+Nd5RbjSEU7wdVJiec+W5N8bwQvgzCd4chJG2TOKkvzbKqCNzW7x1PWbzx+7ljV
         VoIcbW9DobWIGLr0rOACJJoyz7zAcMxssMrTIMa1m9MbdhnzH+h6j5CjAJfpbr9wP9AO
         TLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UBTLYu0ovf90Ly8jIucNjZn0s6JSXdArNLPowmPdXjc=;
        b=qK1wZSNH6+Lqx1sRVGACtnVS9GLEglVH4hb7y38YD6rjUcUVcfOyw4+d7Z3g1z2FO0
         ccA7KlKrg5pHANkRSg5aHHUWcUx4r9cI8FSD2vagwZgVY8iCsqTVCNXbAA6o7dtyEHMs
         G0Gg/NSg5tRDSbm8+lEM1j9Q46gAUa8LRGO9lxqP52CUk706tssVJesxyF1hQswyrAuk
         qh2c+tlqHB1Fp/pcUFHtKj4+HZi3obbi2dSPw1Y1M1dzj2kMJXe0UBTItaDUpNCFfjCK
         13ZgbpKt0Sx5PZAbRtrLjoiroCy9NDwKEa4VUULy7dfr7qe4a0iNz+C2VbJS7vtUDFH+
         RusQ==
X-Gm-Message-State: AOAM530hlRGKniXhNAqBhtHug3DrQnUa+i2I6c1L6Bn1okAKlby9rtBA
        O9dp+gRnFteFWJo4KNnpwQEpkA==
X-Google-Smtp-Source: ABdhPJyX3niJmZryPUPfdglj9K551u5JXl+8T/X4Z4IMOgbZlZMCBWf27TVzU+y8SWuEhDAPHIgd9g==
X-Received: by 2002:a05:600c:290b:: with SMTP id i11mr33816680wmd.137.1636717659462;
        Fri, 12 Nov 2021 03:47:39 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id z7sm11185426wmi.33.2021.11.12.03.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 03:47:36 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 8615C1FF9A;
        Fri, 12 Nov 2021 11:47:34 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v3 3/3] arch-run: do not process ERRATA when running under TCG
Date:   Fri, 12 Nov 2021 11:47:34 +0000
Message-Id: <20211112114734.3058678-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211112114734.3058678-1-alex.bennee@linaro.org>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All the errata checking looks at the current host kernel version. For
TCG runs this is entirely irrelevant as the host kernel has no impact
on the behaviour of the guest. In fact we should set ERRATA_FORCE to
ensure we run those tests as QEMU doesn't attempt to model
non-confirming architectures.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 scripts/arch-run.bash | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 43da998..f1f4456 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -267,7 +267,9 @@ env_file ()
 
 env_errata ()
 {
-	if [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
+	if [ "$ACCEL" = "tcg" ]; then
+		eval export "ERRATA_FORCE=y"
+	elif [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
 		echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
 		return 2
 	elif [ "$ERRATATXT" ]; then
-- 
2.30.2

