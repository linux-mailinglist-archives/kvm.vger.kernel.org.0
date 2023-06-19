Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E33734C82
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 09:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjFSHmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 03:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjFSHm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 03:42:27 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C5510D8
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 00:42:20 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f8f3786f1dso34316305e9.2
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 00:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687160539; x=1689752539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qnwofEvBkK7OFlWxUNT5Ph9UIp0ImxIpuwb9PIhQ0Pw=;
        b=EE51AOLwQ4vmbXoxwULbpzEAfT4nyAiurvU2yp39ByQgEXy0UKU7cnjCHdLEL0BvQP
         +6ReLwVlYfrLAZP9QUhirZaUU//1i1pJ5u5u3j49gbnHBSxe2mtVKwq3A0D3SQkyOQNQ
         2DhJXaFbkSpktv2h3yn4I0bChGkrqy7EOFFrAwH9eO41jBAoI+YS10X9Bsd682E9gk4c
         PLNGuCeS+Nx9h39sjMeOo2I0boySxK8xc08KTjdu4eSBFYlwJuMAe9YfOpTsVHDOhJaS
         YUicW8uWn0KYHl5xgQRX/sq+uflnQjGG8EZhzkuQVaGI1bNCIpl1NTHkBHYexPzWUTmD
         o0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687160539; x=1689752539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qnwofEvBkK7OFlWxUNT5Ph9UIp0ImxIpuwb9PIhQ0Pw=;
        b=UkwfEOlwlvqyWpzD3HHnKsu7yuy053BbXsSmNS5wC1iVrkaRu53wyPEF0eWC1SfmQB
         cWtyKg9ROxUdf1fKBl7TUjwabbfFR2q5lB+j6WmyNWQ60E3+/zfP7U3QNfi0hHYBlH/q
         53ilXPDKccY7wbITyMJgfG8D0WaIWVj+Dr/i+xzvs8Va/qLoM92TouiWbz+1h+nWmArf
         65yKPa24OW3W1qA/3sGpVa7qjiQDZua1flL+nWvNwT2eMcvwOrXtX3HaprSWVvmEWRA/
         UgA//7Ai1KYr6xSTk5hPiVcu00NEwH4ELXZ50PpCdjiJ1IAzgeAqCoSE6Wy/Se/Zpy/0
         K0Cw==
X-Gm-Message-State: AC+VfDwN0PqT9j26HAfTsDg68Ju4tcXeiri9tE6w0sidEu0CQWZFO6wL
        sLaa4FLjGXKfc+KjUIa8tv5M4A==
X-Google-Smtp-Source: ACHHUZ74l0mQgAwXCVkwLZ5Afzwn5E6CYM4Voj1ipWGLnlMT4kTiUVCtJiWHbcPXZVDWm+SV7huC2A==
X-Received: by 2002:a7b:cc8d:0:b0:3f7:3937:f5f2 with SMTP id p13-20020a7bcc8d000000b003f73937f5f2mr9607638wma.22.1687160538850;
        Mon, 19 Jun 2023 00:42:18 -0700 (PDT)
Received: from localhost.localdomain (194.red-95-127-33.staticip.rima-tde.net. [95.127.33.194])
        by smtp.gmail.com with ESMTPSA id v18-20020a5d43d2000000b0030ae93bd196sm30567287wrr.21.2023.06.19.00.42.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Jun 2023 00:42:18 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 4/4] sysemu/kvm: Re-include "exec/memattrs.h" header
Date:   Mon, 19 Jun 2023 09:41:53 +0200
Message-Id: <20230619074153.44268-5-philmd@linaro.org>
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

Commit 1e05888ab5 ("sysemu/kvm: Remove unused headers") was
a bit overzealous while cleaning "sysemu/kvm.h" headers:
kvm_arch_post_run() returns a MemTxAttrs type, so depends on
"exec/memattrs.h" for its definition.

Fixes: 1e05888ab5 ("sysemu/kvm: Remove unused headers")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 88f5ccfbce..528966b5a8 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -14,6 +14,7 @@
 #ifndef QEMU_KVM_H
 #define QEMU_KVM_H
 
+#include "exec/memattrs.h"
 #include "qemu/accel.h"
 #include "qom/object.h"
 
-- 
2.38.1

