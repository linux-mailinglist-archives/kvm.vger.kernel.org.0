Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4318B73CC2E
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 19:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjFXRnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 13:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjFXRnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 13:43:02 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACB32101
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:42:55 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f9b627c1b8so23198425e9.1
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687628573; x=1690220573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lnzdpi/SMqQKnah+FjHhFaYorhth+hVWT4q3k+G9Eas=;
        b=Rl+gIz/1qET6eDxSMKBlhgEu7TmyZ3qVvdZ/pF7ESuaDiAgqa0TRaV3uHvFx81SIeJ
         qV48l02FA5t/FTKOknHNBLfCx5Ba1eIp6WEdUkWmn7UkdBYryX6Psh7GsUfx5W+xyxkL
         3c8KjhetLy0GIjWOUWB3ntdnDUeOwr94g+1P+m5shTihxl+S6wUTSEMW3Qlx3DI6NP2l
         vrLr9dXR9+akQkWnsGaMqcGp/3u5JivD0nZdZrXF6pZOBFyTPj2x9FDEPXRcn+qIk9nD
         5gqJesBceAKK2qgsqePd5rhjrvRO65NK/VxnJZ9g/MTCIDd+ugMpSpYXChqlyNwCrEuQ
         lcrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687628573; x=1690220573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lnzdpi/SMqQKnah+FjHhFaYorhth+hVWT4q3k+G9Eas=;
        b=joCKQYVQOeQhySi2WK1D1h3X2G2TKtN7fIp71KKZJks/zFQ9U0ezxk9Hk/dWLshXdz
         8LTjuP271097/yURPQ4Gfei8TWRd+2z/7jSGoM1TWYmJtb1Mmhws6SXqD5bGAokog6uL
         CObFKZzGc/flEdMa/Ewgug0SdjkQCiv79DS+7TNUkgogY+W1aIaHAHrCnHetde1Hf5os
         wmN1pngn4w5x6mfKPwEe4TP7Hhernk7Es/Phb56+H0q5zOY8eRD2lRlySs1RWhiHdf6z
         qQ5W/NxEHZnU/+SXQHbTzjzunWFBul8ey0KKvVbANRPV/rho6NQuc5lF7F0QQzZLpLtX
         IYjg==
X-Gm-Message-State: AC+VfDxCWDZVX2OvQymtdXMv0s85BzWkDGNO0KIuX7eE0ez9ggsVQJrN
        J5JkcVQ3nlLdvzTpPkAKe4DSfg==
X-Google-Smtp-Source: ACHHUZ54XAa6Du/8XTOzNhZjWrdIxzwHN95ahuIY8Dglo2ED7aclOY9r3VnonPY6Q+CxQ2enFMDFBQ==
X-Received: by 2002:a5d:4c49:0:b0:307:9702:dfc8 with SMTP id n9-20020a5d4c49000000b003079702dfc8mr21407001wrt.48.1687628573655;
        Sat, 24 Jun 2023 10:42:53 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.217.150])
        by smtp.gmail.com with ESMTPSA id i5-20020a05600c290500b003f9b66a9376sm5651642wmd.42.2023.06.24.10.42.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 24 Jun 2023 10:42:53 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>, qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 12/16] accel: Remove WHPX unreachable error path
Date:   Sat, 24 Jun 2023 19:41:17 +0200
Message-Id: <20230624174121.11508-13-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230624174121.11508-1-philmd@linaro.org>
References: <20230624174121.11508-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

g_new0() can not fail. Remove the unreachable error path.

https://developer-old.gnome.org/glib/stable/glib-Memory-Allocation.html#glib-Memory-Allocation.description

Reported-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/i386/whpx/whpx-all.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 410b34d8ec..cad7bd0f88 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -2179,12 +2179,6 @@ int whpx_init_vcpu(CPUState *cpu)
 
     vcpu = g_new0(struct whpx_vcpu, 1);
 
-    if (!vcpu) {
-        error_report("WHPX: Failed to allocte VCPU context.");
-        ret = -ENOMEM;
-        goto error;
-    }
-
     hr = whp_dispatch.WHvEmulatorCreateEmulator(
         &whpx_emu_callbacks,
         &vcpu->emulator);
-- 
2.38.1

