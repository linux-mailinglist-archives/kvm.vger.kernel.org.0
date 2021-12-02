Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E934662CA
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 12:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346479AbhLBL5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346473AbhLBL5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 06:57:20 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDDEC061757
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 03:53:56 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id az34-20020a05600c602200b0033bf8662572so3382313wmb.0
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 03:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+UeYzBMgRKj6oO+ZQIPz1JkXMR6XE0UYsSwgh092H/8=;
        b=wLyJSdkNKX9i2jQbWvNzS7ISoGlxZrNXXkVv5wrju7EPmYlUj6jhV9VkuYhwL4tMd1
         4LWL1z1HnSuRTBMq6aOS7vkRSQhxWIYDQDM6IIzmdY3uJiPQod4+pjQGC5eURjd/7j2W
         NqBWiyzoiNCFFWEXXR5GTy1Af8CWVEevJThpm8dnEt8xPSFxKmTmdd2tAy5HI6UdWv8j
         eKg4WjBj5qZgPN/FoyAaqum6XWYyZwWx7VT6pYrVH/VnlaqL5u1D3IS/zhwR9sCeJ/vu
         u7f6g7Yxzn6kpgSnJHiQjqW5iWn1EAUejstfYzCIPvCkprfKUq4atQhjq3WkUbeDWBM0
         /ecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+UeYzBMgRKj6oO+ZQIPz1JkXMR6XE0UYsSwgh092H/8=;
        b=avxPUvIUTOLSwpT0P8EDqpqNEqZ8gsUdvwAyKwofZOevKYjnh/iDlGO127TG3MIl5U
         4924m3cK0sGTBNzGMCVkE8LXIvwoHVgDKFEL0odWlv1gqc2GWa9N7KYtXQp+byFLhYPr
         wDrP8B9dtYu2r7mGPMYmfQ2RHMebWau1RVE8pRwI7TxW++VN+rC50vrLqbc4gYs/QHAn
         62HMttIOO8z1kn8cU7E4ceJFLqct1MSkMPv1mRsiJtuCscXIAMrvJGOGqONL0PswiSal
         zGwxirWEyw9X1a5sv0zQME/tOqcp17/p0VsP7TWnnZdCG5UMhD3bXA1q+acmjLYnKrd/
         /cdQ==
X-Gm-Message-State: AOAM530/4KII+HUBAgyc6InXTZsBqmbRVHwfPTfCzXbZXVZt9s2eCWU/
        5c++yO8QAWDW5HkKPHavwXZxsg==
X-Google-Smtp-Source: ABdhPJwVNmlD8zuKLw5J+ryv5dY1uQUg+XGqJlUenngQf9X/voMaDW/6oELSYsp15xkyfMOXK+Zmcw==
X-Received: by 2002:a05:600c:3647:: with SMTP id y7mr5816276wmq.39.1638446035103;
        Thu, 02 Dec 2021 03:53:55 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id z8sm2493015wrh.54.2021.12.02.03.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 03:53:53 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 874C31FF98;
        Thu,  2 Dec 2021 11:53:52 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     pbonzini@redhat.com, drjones@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v9 1/9] docs: mention checkpatch in the README
Date:   Thu,  2 Dec 2021 11:53:44 +0000
Message-Id: <20211202115352.951548-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211202115352.951548-1-alex.bennee@linaro.org>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Acked-by: Andrew Jones <drjones@redhat.com>
Message-Id: <20211118184650.661575-2-alex.bennee@linaro.org>
Acked-by: Thomas Huth <thuth@redhat.com>

---
v9
  - slightly more weaselly statement about checkpatch
---
 README.md | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/README.md b/README.md
index 6e6a9d04..245052b4 100644
--- a/README.md
+++ b/README.md
@@ -182,3 +182,6 @@ the code files.  We also start with common code and finish with unit test
 code. git-diff's orderFile feature allows us to specify the order in a
 file.  The orderFile we use is `scripts/git.difforder`; adding the config
 with `git config diff.orderFile scripts/git.difforder` enables it.
+
+We strive to follow the Linux kernels coding style so it's recommended
+to run the kernel's ./scripts/checkpatch.pl on new patches.
-- 
2.30.2

