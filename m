Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D31B734C7F
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 09:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjFSHmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 03:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjFSHmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 03:42:10 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390A6E58
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 00:42:09 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f907f311ccso20612565e9.1
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 00:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687160527; x=1689752527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YkXthOPn4E1631VSOfPiqw4sZJp9rt3aVw83F1yxbyc=;
        b=mzlfo3m5LYpvP4ytqd3u+umd3HUv3UoWTWvc+meiDxyIoj/bv6hlN6Se8YNnUVIEhR
         mx8ASvJWiAsEUqzZy5j+O4JwN+S+kRZU9g5SsK3aCw7Tw70pTYHokfMArDu79E8TQYBY
         hWNke8QI58l9K/UoHtT1hk89d1oFLoqQNrqL3k5x8no9HpYcrFSDB2d/ipK9wZN1pjxz
         /Nmex6QU/WLFXdmahMWe2jdHg2jhJNDeCdfAHITmr5kTSY7FUMJzmPkQYv6pCO8Cyolx
         VU+yfzB0KOuy5S5JplBAs09oZ/INK9XJrtiycK8Yb72XlTNLkSwNLC+qGZcWZs0FQVra
         2Gfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687160527; x=1689752527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YkXthOPn4E1631VSOfPiqw4sZJp9rt3aVw83F1yxbyc=;
        b=XnphDw7uYrg5ZgBxmrbZVeh8OxTv1W31j9jiEIcE4cOSPsoqrjMvlXkNbCQVtbQCXC
         5Iea7Y8uqGFrjdH45Pyihvb6lRWctxCM+sG2tdkE4D118ozxrN9C5XoworB1nVf61L8h
         8y4UnHfupGgLbq+CwNoGDlfr124tEepgeH5Cv01BhzOvg7qBRu9EXRKtwh8xuAI2Lxnl
         lEGxZogIhUr1cYaOJSNoyOVxCHRCYLYWH2MYU7XyNdbSXjpjLmZugDdkYI0xKEF+a6HE
         j3ex0M5WlhrFggAOGtIwHbcKVX/rDuxuPNwH2lyLgFOI55eiU+d08/WYPNXOcbhKqSoo
         b7iA==
X-Gm-Message-State: AC+VfDySjLGJLuJSShCfrLhtb/ymrFQ5vQRbSOJhLUCoFWG54X2aqOHx
        YLjwWjqSfjMsonmmQvEvBoXK5w==
X-Google-Smtp-Source: ACHHUZ47L7Xp2XRwbbnqOyPJdjdKWRKBBPrC1VaKIqRJhlqW5dHNQfb6Saq9edGPaTKEkzx7KWMvfg==
X-Received: by 2002:adf:f04c:0:b0:30f:c2a3:6281 with SMTP id t12-20020adff04c000000b0030fc2a36281mr7297532wro.64.1687160527690;
        Mon, 19 Jun 2023 00:42:07 -0700 (PDT)
Received: from localhost.localdomain (194.red-95-127-33.staticip.rima-tde.net. [95.127.33.194])
        by smtp.gmail.com with ESMTPSA id n6-20020a5d6b86000000b003111cbd8009sm9334752wrx.97.2023.06.19.00.42.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Jun 2023 00:42:07 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 2/4] hw/dma/etraxfs: Include missing 'exec/memory.h' header
Date:   Mon, 19 Jun 2023 09:41:51 +0200
Message-Id: <20230619074153.44268-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230619074153.44268-1-philmd@linaro.org>
References: <20230619074153.44268-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'fs_dma_ctrl' structure has a MemoryRegion 'mmio' field
which is initialized in etraxfs_dmac_init() calling
memory_region_init_io() and memory_region_add_subregion().

These functions are declared in "exec/memory.h", along with
the MemoryRegion structure. Include the missing header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/dma/etraxfs_dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/dma/etraxfs_dma.c b/hw/dma/etraxfs_dma.c
index a1068b19ea..9c0003de51 100644
--- a/hw/dma/etraxfs_dma.c
+++ b/hw/dma/etraxfs_dma.c
@@ -28,6 +28,7 @@
 #include "qemu/main-loop.h"
 #include "sysemu/runstate.h"
 #include "exec/address-spaces.h"
+#include "exec/memory.h"
 
 #include "hw/cris/etraxfs_dma.h"
 
-- 
2.38.1

