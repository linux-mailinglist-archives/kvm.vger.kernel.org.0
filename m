Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9662545732A
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 17:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbhKSQkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 11:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbhKSQkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 11:40:16 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3ABC061574
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 08:37:14 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id a9so19132026wrr.8
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 08:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rJHCVCHL4U33PXMtgaMpIqvWP9Xc3PSo+Bd8gST00ts=;
        b=e15kIey1b4CZx3A2gFh3YGoEOOBLANHzES+s8ynrUIMrcIxhZ0RAzYbF33oUmrV6Zq
         FEo1FNJhvaGLwU86/nNt1Swt54YDhfpByOlduRXtxoEUUZ/CRPocMNxR7EjpmxXEZsq9
         t0xLpT3icgEc+CdaWEjtmAm1l5rw4/4pWXHtOffG8Ugx1MwBWB6cjEqJryM6WVfEDiA/
         TSRH8Xos8BfwkRMZz+JRZadeyCekVhdPidAbfrcxzNvl5EVVyuD/qPMYVI0N/Met20Cx
         cCX4GzDT/6DSWrdWTuOHUKahUMw4lIDkaox1a7B9WoA39hMjvHKqiuGk0RulBnxjw3fZ
         opDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rJHCVCHL4U33PXMtgaMpIqvWP9Xc3PSo+Bd8gST00ts=;
        b=B5+kyRMU3JhUAb2x6no96qUyWz+75fK0Bj+zAzJRmdWEmwFdnMNZSUx9w3G/2qokzk
         yFhPQZMdbxwKiZRMq2BdI4SfGeTlqQrylOzCMrrxQxO2hz2LA3RyH5qwtH7gMg4s2OEF
         FjVIXf/DVgnOsCbK+J5B9utta1nW2EZQwCObZLcT3rbv4yfvYO29wttolmi9nD45szPJ
         9nf7XnP0wNKKeqHIxcT3NACC2ZYxXdk4KqauJGWZdxB2lXcIaNpOeQjSpUCD5Yoj4X8v
         pKXp6KyEdR5O8y2VblHF6ZmGmpiybdH+AdnexhnyFqy4lfrNe2KtJ581YniQaOuQZpgF
         T8AA==
X-Gm-Message-State: AOAM5301TiPlHYGcqsOgRiLjWyH8W1fUD11sGsQQ2LRl0151Vt8wwwef
        nnN7GQ6dJTyC4pMuFooZww8iCQ==
X-Google-Smtp-Source: ABdhPJxD6Qo2C/M31secZFHpzSFy6cyq1TjHV99JAV9UnTNvIRrWR9sjgHQorI8fYuot9nYzW+MgfA==
X-Received: by 2002:a5d:6d0c:: with SMTP id e12mr9307168wrq.94.1637339832664;
        Fri, 19 Nov 2021 08:37:12 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id a141sm12027233wme.37.2021.11.19.08.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 08:37:11 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 704E91FF99;
        Fri, 19 Nov 2021 16:37:10 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com,
        maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Shashi Mallela <shashi.mallela@linaro.org>
Subject: [kvm-unit-tests PATCH v4 2/3] arm64: enable its-migration tests for TCG
Date:   Fri, 19 Nov 2021 16:37:09 +0000
Message-Id: <20211119163710.974653-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211119163710.974653-1-alex.bennee@linaro.org>
References: <20211119163710.974653-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the support for TCG emulated GIC we can also test these now.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Cc: Shashi Mallela <shashi.mallela@linaro.org>
Message-Id: <20210525172628.2088-4-alex.bennee@linaro.org>

---
v3
  - add its-migrate-unmapped-collection
---
 arm/unittests.cfg | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index f776b66..21474b8 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -194,7 +194,6 @@ arch = arm64
 [its-migration]
 file = gic.flat
 smp = $MAX_SMP
-accel = kvm
 extra_params = -machine gic-version=3 -append 'its-migration'
 groups = its migration
 arch = arm64
@@ -202,7 +201,6 @@ arch = arm64
 [its-pending-migration]
 file = gic.flat
 smp = $MAX_SMP
-accel = kvm
 extra_params = -machine gic-version=3 -append 'its-pending-migration'
 groups = its migration
 arch = arm64
@@ -210,7 +208,6 @@ arch = arm64
 [its-migrate-unmapped-collection]
 file = gic.flat
 smp = $MAX_SMP
-accel = kvm
 extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
 groups = its migration
 arch = arm64
-- 
2.30.2

