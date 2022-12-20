Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87B26522C1
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbiLTOgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiLTOfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:35:53 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855D86396
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:35:52 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id ay40so8904369wmb.2
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCP5cZyT8xpPHd2CcQgqWCjvisflP6TbPUTdpLOWF1Y=;
        b=KzRe0Ud/a43NW5H7qYzcwe00FAFc4sTxo6J+P9yZlpZUvuCHUl7e9i3sIsAAQvi2y4
         5RJhpIveURRwX/02s011zFYUDubFk/edMbNob/YY8N/Lrt3kGLShyq7KxS3XQBU5v/fy
         FyYMNEpPMgKX+LJmbw9/bipCgFd2puaHmH0BLXt3gjX71CywG9ZJTkmu5KccqfCg/fmn
         JBJShSu6tfjMTEmPUTcbPU4w9aJX4fVtsmaCrUyAcpiLa/YIXCNoS1rjKXTCkhucr8YM
         hshnrlMag+kg2uSG3rk3ST2vxSYl1pI2MzfMZn1IA1684MLcP+2DvWmIFmnea2kefTxU
         VtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dCP5cZyT8xpPHd2CcQgqWCjvisflP6TbPUTdpLOWF1Y=;
        b=oMpbgbVSQ4O/x1M4npmKzXAnp5Op6GyKglzTXf+ImfdKFPS0GCKQms98dp/kmOM4Bl
         cddNPlrS+30TrGvQ9wCzNvc8g3zKGcwkFQgp4PbEFQANEN1MccqvwQtk2HWb8iFhoHT6
         L/eHs83y9cO91EshNbVaPvZoCyXdYZSctxB4EmoEelUMiJ7DelDxyP2VNEK5sHkYy5Oc
         vOlBSy6ycoOckFZPx6U6bcAAI0ItuDDppcqqB7hQOBHWS0WY8BiB70VnNrCT51dvZAhV
         /WgMSmHMeyw6WVNrHas5kD3QnXpIpJ9bDSrNl3A2suWdYvgXYBbVzrE/X0KdTsYz9bRj
         h3KQ==
X-Gm-Message-State: ANoB5pn6mUGsYxK7WxvdLRbchn99kT7o8K8deoUnaM7fxN0dUn9G5IC8
        YuZ+3y4blmSGVc3CbeA/fMLnmg==
X-Google-Smtp-Source: AA0mqf6F6t3bo/Ea/mNnCTSXbbu6OK1UfnteDWHluOQ+0KdZTZB/cVoCAv/MjUbmGCW6bqC/p9Lx3A==
X-Received: by 2002:a05:600c:2211:b0:3d2:259f:9061 with SMTP id z17-20020a05600c221100b003d2259f9061mr35596684wml.34.1671546951067;
        Tue, 20 Dec 2022 06:35:51 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id m34-20020a05600c3b2200b003d208eb17ecsm17185582wms.26.2022.12.20.06.35.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Dec 2022 06:35:50 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 3/3] softmmu: Silent -Wmissing-field-initializers warning
Date:   Tue, 20 Dec 2022 15:35:32 +0100
Message-Id: <20221220143532.24958-4-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221220143532.24958-1-philmd@linaro.org>
References: <20221220143532.24958-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Silent when compiling with -Wextra:

  ../softmmu/vl.c:886:12: warning: missing field 'flags' initializer [-Wmissing-field-initializers]
    { NULL },
           ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 softmmu/vl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/softmmu/vl.c b/softmmu/vl.c
index 798e1dc933..12c56d3b37 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -883,7 +883,7 @@ static const QEMUOption qemu_options[] = {
 #define ARCHHEADING(text, arch_mask)
 
 #include "qemu-options.def"
-    { NULL },
+    { /* end of list */ }
 };
 
 typedef struct VGAInterfaceInfo {
-- 
2.38.1

