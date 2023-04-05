Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98526D82ED
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbjDEQFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239084AbjDEQFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:05:32 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76A86E9B
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:05:28 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id j18-20020a05600c1c1200b003ee5157346cso24048518wms.1
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680710727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2hst+C2Hubq09FNgBe92GHruUqjFSuaPIAbKjAIoI8=;
        b=hnCYq5Dzl/7iLI0rQYbkc9CUi17FFpKYPMxOnHcemCexKvxTdFYuaru2TQEImK5o9e
         jTn4K6Pp9zXxdmmJsMb8gD9S2GQ92Q72Ifh8L6RxwgBOR83AYlvxa/V/6Fh3hPXQBoiV
         z9gKOGSH8bAn5zRrapQGO1yAInmO8o8qVZTpVMRyYOG1CV9m59KTFXQeJKBj8sjGVuru
         vuCXHX5KYhKDn13HSZVsP5Lq2Qz50f1zC2IoyROHSYrzPF6xJDEsucHmTbgNlZ1jt64p
         EjINJfxYuBjgAhCrq5BfDf3e2GoiGGEqH9e7WYG8IshZ6uH7iubAr54kkd/PnEXO2Hgf
         kVGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z2hst+C2Hubq09FNgBe92GHruUqjFSuaPIAbKjAIoI8=;
        b=AOImJAYvUSOAHz+1dKqZTvqKo58JAfM0zQozUZEbkMPBjJXandpETpJ41F7bzp4TBB
         xFgkHbBrY7f7okp/kGuTGTQ80kNZic7nDdZjdBHK5JFCkseZRPGJtPkaQRm2SO6ir0n8
         mnEK63jCDO6V7i0cO4BfPnsaDcwSnTlm/mLQ7I5qIDROEtQolLOVz29JbqjYKoXFsg9r
         Tias3PX/BE4Eqsy1jTuIN1b7Y1GNM3i7RJK5COYvm6L19qE/RVaWOls6Ryi9N5LJEqwj
         NSBE59Oi79rCH1wYDPA05HQZTxSVtPL4lIs54Li1aeUkRYdxinhbbyOag5eIZro7YdIH
         mBRA==
X-Gm-Message-State: AAQBX9dWzFLC01U1w8wqYMioavqfdaHT2PRmyEF1qiBHJjnC7UmURE3e
        XwXHihbVyzL2205GbTOgMOdcgg==
X-Google-Smtp-Source: AKy350ZJ+dZx4arE1dDvn+93xqmfAgQekaQ5sdLBd5m5/mFFyw1t5hipklNUBAa6v3f8yS67ujRRZg==
X-Received: by 2002:a05:600c:253:b0:3eb:3f2d:f237 with SMTP id 19-20020a05600c025300b003eb3f2df237mr5280415wmj.6.1680710726924;
        Wed, 05 Apr 2023 09:05:26 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id y9-20020a1c4b09000000b003edf2dc7ca3sm2586415wma.34.2023.04.05.09.05.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:05:26 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Leif Lindholm <quic_llindhol@quicinc.com>
Subject: [PATCH 05/10] hw/arm/sbsa-ref: Include missing 'sysemu/kvm.h' header
Date:   Wed,  5 Apr 2023 18:04:49 +0200
Message-Id: <20230405160454.97436-6-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405160454.97436-1-philmd@linaro.org>
References: <20230405160454.97436-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"sysemu/kvm.h" is indirectly pulled in. Explicit its
inclusion to avoid when refactoring include/:

  hw/arm/sbsa-ref.c:693:9: error: implicit declaration of function 'kvm_enabled' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
    if (kvm_enabled()) {
        ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/arm/sbsa-ref.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/arm/sbsa-ref.c b/hw/arm/sbsa-ref.c
index 0b93558dde..7df4d7b712 100644
--- a/hw/arm/sbsa-ref.c
+++ b/hw/arm/sbsa-ref.c
@@ -26,6 +26,7 @@
 #include "sysemu/numa.h"
 #include "sysemu/runstate.h"
 #include "sysemu/sysemu.h"
+#include "sysemu/kvm.h"
 #include "exec/hwaddr.h"
 #include "kvm_arm.h"
 #include "hw/arm/boot.h"
-- 
2.38.1

