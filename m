Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21C244E5B4
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 12:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbhKLLuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 06:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbhKLLub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 06:50:31 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D2DC061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 03:47:40 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so6551542wmz.2
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 03:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rJHCVCHL4U33PXMtgaMpIqvWP9Xc3PSo+Bd8gST00ts=;
        b=ekMdpRSWqlWSiVvgjeBT9YCV7iKV0LVPJ2/pvZ9fE1XNUmTdejv3hLY5TgCN2JeNmm
         RzFDxbABVIOcACSv0wagoMA+lSfGzkkDkkAN//LkyA56Ypv9xHW8vPC3hCOJYYyfV9eL
         QFBZn8oFKa/VYZpynM1yus3PggSbk0k8V0WPGs6Op3CMkIJSeNR+OBx/XOkDTqif+A78
         vmk+j6Awz8fC3m7xjtRDPa+Wddv349oYxfbkFrfZrYAY3XTBPzqxQnZlAVtGHdGfbG5b
         TPZm7b/CebLhI7lxQygEeCptWT0KPezGCjvkJGWc4r2qaGd7S2/ffGCtLeu5yumunjj+
         0ozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rJHCVCHL4U33PXMtgaMpIqvWP9Xc3PSo+Bd8gST00ts=;
        b=CAlHM5kLVbT1i2Se7DqcYJHaFqOztLfBseee6v68miFS78hJZbnuFks9+xNpDudeSi
         3QOR+U02qhk78hPgPDmpyupYsIGWVDaE7anj0adetI6on+pgp2/VfS4FkxzmCW4ybSzD
         MdxVSk0WrEX9WVdT/FA3yjh96DxnDN+8Mx/ze4WfZ95rWjLxgD0ZDWj0xlGR+jS8tUhg
         1iPyyaHF7FJWZXms8FdjmGeTQZwBFoEtZCEF0/DLRZgRAt81cQYULplhvTcVyNid8+zo
         fj4pVqo8ZM/unB0IwXBx71lTHvyfCvyJRJwZ26KbI7tDEtS0gVAa4xEa84BRYlkDaOFN
         WXMA==
X-Gm-Message-State: AOAM533Q86IhAQnib6IegttYfN+blMNu6dS0HMVoiYWYRAw1HxXegm9f
        aAfotvKzUrsYmC3CqZo+//JQJw==
X-Google-Smtp-Source: ABdhPJycSrQXrI5ANFDX5SP4MV9P9LBxdBIXWlPbv0YqQTSfXy6gbpG8wLqr2Do/3gKPIUsWbTPCWw==
X-Received: by 2002:a05:600c:221a:: with SMTP id z26mr34679356wml.20.1636717659036;
        Fri, 12 Nov 2021 03:47:39 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id c11sm7674349wmq.27.2021.11.12.03.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 03:47:34 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 704FF1FF99;
        Fri, 12 Nov 2021 11:47:34 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v3 2/3] arm64: enable its-migration tests for TCG
Date:   Fri, 12 Nov 2021 11:47:33 +0000
Message-Id: <20211112114734.3058678-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211112114734.3058678-1-alex.bennee@linaro.org>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
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

