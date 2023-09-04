Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF679174E
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352847AbjIDMnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350864AbjIDMnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:43:53 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6A2CDD
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:43:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-99bcfe28909so205850166b.3
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831426; x=1694436226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EAX70gb1DRp0U5HpIrsPRfVqNXXnjE75o2367gc+/Ss=;
        b=WZaxS/0OLLL9irzltuc0NlABLYaNHFpRDlv4HHODyIt+4XlO+Ckldldhp4siGJGON8
         LTayCQ1PlaXfsleHEyGx9l63zqSzhXgyA2WcZIA1CJhglih1YmbUTpP7GCE/NBe+p5i5
         IFEVetKPw8YuDRJhOXS+mom9wPWqpuos5n06xvjAX6g4ekvcMwHw70NOhMnLno6Ue7Tm
         vkxcx7HC3QLgpFsGIZ5zSECTir/Kus3HKHU4GOPiRceHVu9cRZ2GyLkKzQ38l4oYLdrP
         oARe6AoWf0lH4fvAcu1JN+YjkxopnIydS+OZ/qESn6mXTkRTETozRvNIq/mQ1Bg+1IkL
         7W5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831426; x=1694436226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EAX70gb1DRp0U5HpIrsPRfVqNXXnjE75o2367gc+/Ss=;
        b=dYsuNcdeqReggtilkg5L1FOYzXJcjVLyh/XkoZgHo/ff7X7GbeLRBB9KBXb5zEofOu
         WBgAUM11EaIORRsZCi5ZrecZMp54dT0MTJpLExIq+0mwYBrfcWMjbrpQkRSzSFjvsZGy
         fAPy7rm06hFf+l+hBh/tckh8XvAzfqTfncW3Mq/YSj66h5V03yZuHuoB3hNTt7rtRGSq
         8WbUYjiDOgTr3z16sOcZgrHISN98+1ZCCAQqy4nZAMLQ0NWsrYyLDU64RdglXkofYHxC
         xMuHQsidvdCZh1tla0TDBGlalCQwlppjdi8dI9t9++uTULCU/1vUn1u1C/oe0qWgp7Ge
         TR4Q==
X-Gm-Message-State: AOJu0Yxns8zdxgcT41zVljeTTIxg2RbD5G0PVjzsRXrdyAvFSOdMURpK
        QwMdPeNYeIBl8qal9fonUPZsAQ==
X-Google-Smtp-Source: AGHT+IFkSqJnsshKBauxCddr+GUPT4A6KXmj88c6crUPHo9OljUs8uCyfcujmDG6A70sYs/Xauvxnw==
X-Received: by 2002:a17:906:30c1:b0:993:d5bd:a757 with SMTP id b1-20020a17090630c100b00993d5bda757mr7133775ejb.19.1693831425876;
        Mon, 04 Sep 2023 05:43:45 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id pv9-20020a170907208900b00993470682e5sm6063351ejb.32.2023.09.04.05.43.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:43:45 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH 03/13] hw/i386/fw_cfg: Include missing 'cpu.h' header
Date:   Mon,  4 Sep 2023 14:43:14 +0200
Message-ID: <20230904124325.79040-4-philmd@linaro.org>
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

fw_cfg_build_feature_control() uses CPUID_EXT_VMX which is
defined in "target/i386/cpu.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/fw_cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
index 72a42f3c66..7362daa45a 100644
--- a/hw/i386/fw_cfg.c
+++ b/hw/i386/fw_cfg.c
@@ -24,6 +24,7 @@
 #include "kvm/kvm_i386.h"
 #include "qapi/error.h"
 #include CONFIG_DEVICES
+#include "target/i386/cpu.h"
 
 struct hpet_fw_config hpet_cfg = {.count = UINT8_MAX};
 
-- 
2.41.0

