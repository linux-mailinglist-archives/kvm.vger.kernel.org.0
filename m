Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D162945732B
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 17:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbhKSQkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 11:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236543AbhKSQkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 11:40:18 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D8EC061574
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 08:37:16 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d5so19185460wrc.1
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 08:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UBTLYu0ovf90Ly8jIucNjZn0s6JSXdArNLPowmPdXjc=;
        b=YafddRxj9VBjZzRlxSamFKtngp9kYQ/Om6EnwnudYXjJCJd722nl8E5+pxBa7+IsPc
         83efOXLfP236CvwaWzzAxIMlzCcdKh8S+J7sMw2Meb7MZYYiH5kb4BU1yowwH+TewDI6
         X2wl3xmG/2/4mjDUuRK1es7OGu0lWBR2jMsV4LVwHfKT7TPClcNFHc3W/2btWNjvNFJ7
         30Sp0dfQIc5SEF6NpuQjdaATSmdhExxfBHWU3/1SEebk+mYPT8aWAU+Y+5OkvC2aqV5u
         DHNOYSrn9t+mSyQymC+FIW69HipUe4ItdOnWD/ltILkAbB0qE3BAcY5B8wAx+UONSO6i
         3mPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UBTLYu0ovf90Ly8jIucNjZn0s6JSXdArNLPowmPdXjc=;
        b=5lSm1xHF0R15N8WbETlhHHOeFVW29pdF1iD416Hy6kfyPU+5r8h7Lon5Mc2oNY27WT
         CSqWP0qFUJ7P4FMq5DfQlUXylJPKB4X/S+bUCXO0WyK87C2TZ/Jc56P3OYGGBV3kf4g2
         jLiO4GyzvwbH3q/Amv8h1ARjaNYba6JAmqQk7/mqivoM78UuQSKt+HHECgqKqljaCDag
         H7S8QNm27vVhNNXE2CuPBVB0X0oict/I3ZYtfWZPvvYO7DFsxlPE3VQSopJJrNpWMP0V
         ruUOVWWrS5sBd1+9Kpdp/fgiiflw4YV8hERtK0S/Fvcj0aU2SrcJnpuTgqrIGFC/05Sq
         qUjg==
X-Gm-Message-State: AOAM533ozeScC6nLWkUzuIEmRpqGz7I53WnzkrwaxjfAEDqWgsoPdjLx
        3XsELJyfOesS8sxBlRJm5Qii+ODw1qHh8A==
X-Google-Smtp-Source: ABdhPJy8eUMgWTmXLHQO73lzwoAiNLaV22W1knajMZd2flThIs36ASzjzldkk3oB/MzzmN49Z8cxrQ==
X-Received: by 2002:a05:6000:143:: with SMTP id r3mr9139425wrx.236.1637339834937;
        Fri, 19 Nov 2021 08:37:14 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id r8sm328551wrz.43.2021.11.19.08.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 08:37:11 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 721D91FF9A;
        Fri, 19 Nov 2021 16:37:10 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com,
        maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v4 3/3] arch-run: do not process ERRATA when running under TCG
Date:   Fri, 19 Nov 2021 16:37:10 +0000
Message-Id: <20211119163710.974653-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211119163710.974653-1-alex.bennee@linaro.org>
References: <20211119163710.974653-1-alex.bennee@linaro.org>
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

