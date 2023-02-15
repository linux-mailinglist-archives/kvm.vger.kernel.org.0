Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F72169827D
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBORoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBORoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:44:03 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D733A85E
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:44:02 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id h16so19952563wrz.12
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=heFm5UqUphDjJpVI7Qv+ZKuvoLHrfHy/aAGqW6xSVEo=;
        b=w8OC715+aOMsi5OmhZ3/3915Wpmr4UaBPw/l9+UT6ZztgIO7uB/Cf1zJS51Erm39On
         M37AHEy0UPw6phGdnh8GuDzIiBqrVEvTrzrvJ31eX/0EcYLw39AR7GePTiNRgC4nVqZz
         Ng7qjUBYwlDO1Am7qbCjsaOJ9pYi5LOqB3rRz9qn0/72BR5PzypZRWcWZcjoZO4/wF8E
         j9ZrUM1nah63GXuse1P2N+h5+F39qljWEglEOYEu6L0t59OJH5G/7LW7XYJpLtNcLuTh
         R8N0vw6iS3jHRMrkxypkswbcI41eSWwNLObPQ+p+e8DMd1pwiuICQ+VyZ3jea78dtV0R
         Pp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=heFm5UqUphDjJpVI7Qv+ZKuvoLHrfHy/aAGqW6xSVEo=;
        b=FNh7DRMHEvLlrL7Ffqqe9UQ02hfoUtYyRChmoQvA6OoZnd7N/W/IFKdZ8BxTvBXCl5
         mR94jK7jC9iv+KeP6AFD7avG9bhMqbyz6cEcpgAeAm6Wd23+geABS7EmlRZ/IMu+qGnb
         l5ZfbKukhAEVvKAIw9QPCbtsXyyhclT7HsUmEXtewvrkv89eMFk/VCIH6/SRz7aE1/xz
         QSIscMbUxDecAud1Un8G4B92gbmzoKVtWCPkhcLxMaIRHJiLeUeKZRX/m2nubCwj7ILi
         VgiJNQ/nsLbydMQzh4WdX1vG6t+QW3kgth86Xqj/S26mOq7g+zDPN+CUa1CNiAxztlGJ
         17qg==
X-Gm-Message-State: AO0yUKWtrWSK4ksw8Td+gkuTbdU1oumfygDN67w7lV4sxZ2Y0hT5+SOQ
        tsy8pXQbGqR2HDGQmsXUzV03Mg==
X-Google-Smtp-Source: AK7set9QBzatX+iyzVMoe6/2+9iCbBIcnZ+Nl4ZdjUTu/yelgqHueAFwPIoLUgQyYvb7peWPRbfvPg==
X-Received: by 2002:adf:ce02:0:b0:2c5:50f2:fcbc with SMTP id p2-20020adfce02000000b002c550f2fcbcmr2514670wrn.21.1676483040963;
        Wed, 15 Feb 2023 09:44:00 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id u13-20020a5d468d000000b002c54c92e125sm12669586wrq.46.2023.02.15.09.43.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Feb 2023 09:44:00 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 1/5] hw/timer/hpet: Include missing 'hw/qdev-properties.h' header
Date:   Wed, 15 Feb 2023 18:43:49 +0100
Message-Id: <20230215174353.37097-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230215174353.37097-1-philmd@linaro.org>
References: <20230215174353.37097-1-philmd@linaro.org>
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

Avoid when refactoring unrelated headers:

  hw/timer/hpet.c:776:39: error: array has incomplete element type 'Property' (aka 'struct Property')
  static Property hpet_device_properties[] = {
                                        ^
  hw/timer/hpet.c:777:5: error: implicit declaration of function 'DEFINE_PROP_UINT8' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
      DEFINE_PROP_UINT8("timers", HPETState, num_timers, HPET_MIN_TIMERS),
      ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/timer/hpet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/timer/hpet.c b/hw/timer/hpet.c
index 9520471be2..214d6a0501 100644
--- a/hw/timer/hpet.c
+++ b/hw/timer/hpet.c
@@ -30,6 +30,7 @@
 #include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "qemu/timer.h"
+#include "hw/qdev-properties.h"
 #include "hw/timer/hpet.h"
 #include "hw/sysbus.h"
 #include "hw/rtc/mc146818rtc.h"
-- 
2.38.1

