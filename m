Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF6979174C
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349705AbjIDMnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjIDMnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:43:39 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5598B103
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:43:35 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2bce552508fso20991531fa.1
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831413; x=1694436213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aJCm9ielSGbSry5cbeI+YJvG0psfGNIv8B+tATNPjpc=;
        b=nj1OQgtkeNKYr6/QUD5koOwS/jZxJ8I/vxqgE/lq1IF2tlLEgLaGTKNIlt06i3S/YN
         jaAQ55qJIOI84EG0u1/dgZgc7ED+DUSP2WSUHHBIx2omckZcda6Kry94/ZI8akKlNcgJ
         rPg/3gGJsKRRxVckLPehLOiIvHUdCDxOq5udvw9iJ9QuozOztZll4nGQudfUMP78paW9
         Y1Z5v4klZenzzbUvIEjJC3ta5DfbRRqW50t/t2o+6nOyjrdulwdUDYYZKDEvAYJqyQng
         w2pkYmMRHuTu4XPz1+Ex1P01Lp6BFG63l+yGWAMlgVTWQ/jzgmbKhzZ8of2vGmQHsu80
         hCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831413; x=1694436213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJCm9ielSGbSry5cbeI+YJvG0psfGNIv8B+tATNPjpc=;
        b=e3YF/VxRAfr6VneKEe9Ec8xrvdkR0EHCIeA9XezoHW4i6NxW7+kAfeC9pzgEAUjRre
         ngJUM/E+sSeDWfU5OZCWHHmVBuWJWbXxe0QvYHmQHdb/FFnjz4mbqpNqLGoDxgCLWgwO
         NZg8s8ObPEwqoGqp1b35y7R5AQLlI8Yd56WkEMX9dfYlUIE5SRef4hEPOx3K/cVf3RZl
         1mxo24xCkD8vHfc4RtfetAyOqvmIQXsNLfpK2+LxGPWNuReGu1ni29GJeWKB5EvQ4aZO
         AOyq9ic/IzCzpV/D11x8btyHQHT1zECuoVVIVxPOfclawqcmZuBcLoa3lSQQPL3BPkMb
         f6CA==
X-Gm-Message-State: AOJu0YzvNomuTLNKhM9ZLrcNSiqshWwT0MWebuiRFMt74ai0eZGDtz6b
        gCdJy1BdV8/2PC544xbWRdORWA==
X-Google-Smtp-Source: AGHT+IF1LC+yWQ0PhXvd9yzZgLb7+mH1K3LMUlqzrxxaMQCoDCfGxeabIkm0GVrCgphK+2vgyIMWHQ==
X-Received: by 2002:a2e:9a8e:0:b0:2bc:b0ae:a9e5 with SMTP id p14-20020a2e9a8e000000b002bcb0aea9e5mr7458665lji.42.1693831413634;
        Mon, 04 Sep 2023 05:43:33 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id f3-20020a170906824300b009786c8249d6sm6163671ejx.175.2023.09.04.05.43.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:43:33 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH 01/13] hw/i386/pc: Include missing 'sysemu/tcg.h' header
Date:   Mon,  4 Sep 2023 14:43:12 +0200
Message-ID: <20230904124325.79040-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904124325.79040-1-philmd@linaro.org>
References: <20230904124325.79040-1-philmd@linaro.org>
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

Since commit 6f529b7534 ("target/i386: move FERR handling
to target/i386") pc_q35_init() calls tcg_enabled() which
is declared in "sysemu/tcg.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/pc_q35.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 37c4814bed..43413dd1ac 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -34,6 +34,7 @@
 #include "hw/loader.h"
 #include "hw/i2c/smbus_eeprom.h"
 #include "hw/rtc/mc146818rtc.h"
+#include "sysemu/tcg.h"
 #include "sysemu/kvm.h"
 #include "hw/kvm/clock.h"
 #include "hw/pci-host/q35.h"
-- 
2.41.0

