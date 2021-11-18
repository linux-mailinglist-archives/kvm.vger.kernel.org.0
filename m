Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2334562DB
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhKRSuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbhKRSuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:50:07 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67536C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:47:06 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id r8so13409304wra.7
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ZUZgHuD8NGUtXmK8AnZStWJy8xmbLtZriXcWFhy400=;
        b=tPWuwxoTarEuAMs1Cr0K1Krqok8qufGx6RqHKdovs46l6HbP+r9r+bOksExQa0YZDG
         AsoaKRil8lZWbPR012ZeNS/eQgdcSSwBTND/DHsfkJinAESipF/l47RgYCK7D9yD4Aio
         T8Y6P6sbDUNwqrn8MTUeJG7y6AvFCKD712kKLPvPaWNNtvKuinZplyk7fjbgm3kZsqRJ
         N3v3Jwa1Mfhb2Zk6CWQ2MOZQdSA3rbX5NknoDw2paAGO4VWketi0gk3I3DnClywHpIkE
         dGDdijAlG9Mj05jaZ8QvkdqOixKg8+Bx2d5lVU+Dt2aHvZ+f0HRxD75WSkOJoV62yoac
         BBGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ZUZgHuD8NGUtXmK8AnZStWJy8xmbLtZriXcWFhy400=;
        b=s66QVMhN2W+F8hU4TR8B5rHwUrGYGp4GDnjz1iz62uZtrwGGdK0jJXdYZt4VdPbQfq
         7jHoMx7OwPw3z7LW2JUAJFhcQC8RF5sO8xL6PTmjVazvqr0OfL0PsoLzCnhYFpSxcT74
         FIzBD1jDCFcV/+KIRqf2BE7dtvqCbc8MoSJJp9g2XOxX4YUaJMjemdnlSaNRvWSTDEfC
         uiEctrVDHuIWzMD/FE6fYsesOM8vhVRkTFY77r+gAy8HDrkKAkus9rTRbIMj6j0NitP9
         TzuuNuRyVYiwuZVd/QyabJkCx3rp0uYX+Cb0OyMoagc21nTBf/k6a2MwERdQ4G/xeQcn
         b9lA==
X-Gm-Message-State: AOAM530QOVHP9Q6kLfT6Fuk3FDyzf3zzImjb4yZfORv/MKpYz9jjSuj1
        yUTT2ggelw495jWRYjzYL8RVmw==
X-Google-Smtp-Source: ABdhPJwrdug8tImztTIg3ZfiYXxvh9yFWUBC2psfMHONmasEUnH8rpbLxJaonSmjf5pZLT3W2NFuZw==
X-Received: by 2002:a05:6000:2a3:: with SMTP id l3mr34560244wry.415.1637261225009;
        Thu, 18 Nov 2021 10:47:05 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id y142sm458082wmc.40.2021.11.18.10.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:47:04 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 8504A1FFA5;
        Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     idan.horowitz@gmail.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v8 09/10] arm/run: use separate --accel form
Date:   Thu, 18 Nov 2021 18:46:49 +0000
Message-Id: <20211118184650.661575-10-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118184650.661575-1-alex.bennee@linaro.org>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will allow TCG tests to alter things such as tb-size.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 arm/run | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/run b/arm/run
index a390ca5..73c6c83 100755
--- a/arm/run
+++ b/arm/run
@@ -58,8 +58,8 @@ if $qemu $M -device '?' 2>&1 | grep pci-testdev > /dev/null; then
 	pci_testdev="-device pci-testdev"
 fi
 
-M+=",accel=$ACCEL"
-command="$qemu -nodefaults $M -cpu $processor $chr_testdev $pci_testdev"
+A="-accel $ACCEL"
+command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
 command+=" -display none -serial stdio -kernel"
 command="$(migration_cmd) $(timeout_cmd) $command"
 
-- 
2.30.2

