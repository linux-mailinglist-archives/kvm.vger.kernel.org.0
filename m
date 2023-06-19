Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C515734C7D
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 09:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjFSHmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 03:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjFSHmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 03:42:04 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84145FF
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 00:42:03 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f8f3786f1dso34314265e9.2
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 00:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687160522; x=1689752522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KL2PYuIs1BVHjdvTGwm0sXveXI5cCApLPfoCdqJW9L8=;
        b=fWsyd2ggatUTsIkjcwt5g1ZFmfbEYT42HpkS7K9Vjb1M1J28yMN6FBZOUOdi44fhFg
         xS0RUZvl5bZWbYbk3m8JXNMo4W0Gu33O2eIg0Gct8lhXlmVOl3eHEgJjM5RhScMjqJU3
         cx5seoqpzZi3GyiSTavTvlu1xp0vWECE65z8xoBFESVRvWiJ8LL9cQwi2yd1+C0Di3PB
         2+JXhcWBfwI7somsJ3co4ABECoq9uGUHOZuK9prd29JPfYXri2IU/lfyYKPzzokD4Fdm
         UmirV6yTdr3aEUilCwlVaXC20kNAcghWzLCShHzAYjqxnBhnSD7kA+qMKQZQ9xloimgt
         Mi9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687160522; x=1689752522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KL2PYuIs1BVHjdvTGwm0sXveXI5cCApLPfoCdqJW9L8=;
        b=FSo4Gggi/a/7eV3JhuFtPMfAlATL68chFe7tDBwb2b+krVJxV9smydmvyuhGxKknAd
         oWZ3Wv5iJEmOCi81rhN6YUskMn74tj/COHvpy5w+adwcCsgbeKvmPSU/z3GAKpqd42Aa
         5g6BcK3f6ZL0lQv52DfZENGBZNSgaoPiMn8d5ylv6x3glEnDqXtJ4ZGZ53PzRIfjJpWG
         HI7X1ICkj7KJ0E27+Nz24qlYxT1vbMmL+c9YxqAeyisJ7/7IjjFTrCzXs6ZhBjxB1R4+
         h17DiKx1UvMpwWJb5QwM7oWMevLdJpvFgnBgVa/tHNv7Mt7vjHFiq+rtcDf/m3Z5QHEw
         Ik8w==
X-Gm-Message-State: AC+VfDwxo76OZTR91a2BMQr3mlHRG96k9X//cWoRUcmQFfbwX5ewrF/8
        2f4xGLsQxIgTLEB9G/0PIjTJpA==
X-Google-Smtp-Source: ACHHUZ7gX1n45U+7t5jyD0FLAsJQGp97z0VG30yfL07LGEFIFabAZA+C4XfZuySz3dX9WB5Bi8z/qw==
X-Received: by 2002:a7b:cb56:0:b0:3f7:e48b:974d with SMTP id v22-20020a7bcb56000000b003f7e48b974dmr10200835wmj.27.1687160522051;
        Mon, 19 Jun 2023 00:42:02 -0700 (PDT)
Received: from localhost.localdomain (194.red-95-127-33.staticip.rima-tde.net. [95.127.33.194])
        by smtp.gmail.com with ESMTPSA id e6-20020a05600c218600b003f9b3588192sm704769wme.8.2023.06.19.00.42.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Jun 2023 00:42:01 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 1/4] hw/net/i82596: Include missing 'exec/address-spaces.h' header
Date:   Mon, 19 Jun 2023 09:41:50 +0200
Message-Id: <20230619074153.44268-2-philmd@linaro.org>
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

hw/net/i82596.c access the global 'address_space_memory'
calling the ld/st_phys() API. address_space_memory is
declared in "exec/address-spaces.h". Currently this header
is indirectly pulled in via another header. Explicitly include
it to avoid when refactoring unrelated headers:

  hw/net/i82596.c:91:23: error: use of undeclared identifier 'address_space_memory'; did you mean 'address_space_destroy'?
    return ldub_phys(&address_space_memory, addr);
                      ^~~~~~~~~~~~~~~~~~~~
                      address_space_destroy

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/net/i82596.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/net/i82596.c b/hw/net/i82596.c
index ec21e2699a..9b9e3aa792 100644
--- a/hw/net/i82596.c
+++ b/hw/net/i82596.c
@@ -15,6 +15,7 @@
 #include "hw/irq.h"
 #include "hw/qdev-properties.h"
 #include "migration/vmstate.h"
+#include "exec/address-spaces.h"
 #include "qemu/module.h"
 #include "trace.h"
 #include "i82596.h"
-- 
2.38.1

