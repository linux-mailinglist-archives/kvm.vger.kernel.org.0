Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA9B23BAAD
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 14:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgHDMqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 08:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbgHDMoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 08:44:22 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7EBC061757
        for <kvm@vger.kernel.org>; Tue,  4 Aug 2020 05:44:22 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f18so2127333wmc.0
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 05:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kh3fLdhtAK8iltYl6aGsCpfSwDzQcJQDII6+Lr3Ir4w=;
        b=nMnqkLp9MyaD7mVBWPOdpipOJAA/A+eqGB2+7v2AnGvajHcTmtJGzfEa8AObnk3OGO
         X6yzj+zqibdmVd52uW6BsVLE1twlWOD8iHOgBNZ4VGgtFVF3pWYXGAqPfb8l+53YHRNG
         fkEUw2haM1Xyld8Y5Y4NGy7cZi9KRdEu+s1yEngpns9vBqo+5u5vyUfrDXyt3ivwb/rB
         clg/7E3xKGUCx24uRr1RBdN9jkogBMFaY3KQRg6bWxxmOvo5fYHBnXt+k0Nf+/PDBu2f
         s6HexrWOx4jElhs7Dd34qf7UdiQd6LCDGnCq2XOnNawU9uylFjuZkOHE2fgbsJFmSbff
         SnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kh3fLdhtAK8iltYl6aGsCpfSwDzQcJQDII6+Lr3Ir4w=;
        b=b2bwo30bVAE9CIBCoGFqIkXU3uuUN+UhO1eEyOnvxP7f4dcwXEum51MGmnfXHvykbY
         hq8d6OS59HiwQF/yUE6RNHsc8muWiX5AVx3VMpvi3fI97J43f0xhM+7nfyCMH/LEJQnm
         9NEH1WYKJ8HlyfWlJeDYWILDcGJ+pKXoZvxWdD9UuWUqoNrLvGqma3Vu5vETeaSM7tYR
         FQmQB6TtHph107xrLXYkXoc6bKa8lgZ8aWjFjLbhA+kQOipF3vuMfPfEca1gNBFnPwJ2
         m97xdWGL1cSuiFTrSP1jiBatfXl1jh3MQ9L62fHP5q8axozGcpIgZ84xufj5X50a6Cu7
         uUMg==
X-Gm-Message-State: AOAM530ftLk53awPgb66Bw4CRVkm35MH427ZjZvjSOy3bR4V8W/ZUJRR
        Zri/KpEZlTgZ3sfr4BUZTGf3Wg==
X-Google-Smtp-Source: ABdhPJxlETqHM58ekeF7YRtlEWgL6bu7W0dZE0N/3gry/XAbgEfMhCjsPaytXate5VOSsOPSdbiQrg==
X-Received: by 2002:a1c:7702:: with SMTP id t2mr3859731wmi.169.1596545060810;
        Tue, 04 Aug 2020 05:44:20 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id r206sm4554096wma.6.2020.08.04.05.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 05:44:18 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9218B1FF8C;
        Tue,  4 Aug 2020 13:44:17 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH  v1 2/3] arm64: gate the whole of pci-xgene on CONFIG_PCI_XGENE
Date:   Tue,  4 Aug 2020 13:44:16 +0100
Message-Id: <20200804124417.27102-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200804124417.27102-1-alex.bennee@linaro.org>
References: <20200804124417.27102-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a little weirder as bits of the file are already conditioned
on the exiting symbol. Either way they are not actually needed for
non-xgene machines saving another 12k:

-rwxr-xr-x 1 alex alex  86033880 Aug  3 16:39 vmlinux.orig*
-rwxr-xr-x 1 alex alex  85652472 Aug  3 16:54 vmlinux.rm-thunder*
-rwxr-xr-x 1 alex alex  85639808 Aug  3 17:12 vmlinux*

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 drivers/pci/controller/Makefile | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/controller/Makefile b/drivers/pci/controller/Makefile
index 8fad4781a5d3..3b9b72f5773a 100644
--- a/drivers/pci/controller/Makefile
+++ b/drivers/pci/controller/Makefile
@@ -47,6 +47,4 @@ obj-y				+= mobiveil/
 
 obj-$(CONFIG_PCI_THUNDER) += pci-thunder-ecam.o
 obj-$(CONFIG_PCI_THUNDER) += pci-thunder-pem.o
-ifdef CONFIG_PCI
-obj-$(CONFIG_ARM64) += pci-xgene.o
-endif
+obj-$(CONFIG_PCI_XGENE) += pci-xgene.o
-- 
2.20.1

