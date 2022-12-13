Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DCE64B53D
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 13:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbiLMMgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 07:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbiLMMgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 07:36:07 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916CB164BD
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:36:06 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id o5-20020a05600c510500b003d21f02fbaaso951601wms.4
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kaPjbKdMr76WDvODBflVFVeFIfBaQyO5rZm5rUBpNuw=;
        b=O2ot/k263FnLwr6J9y4vgJFRt8gHLPGH+hYoc+NkfvsmnefXlPnGZlKV8VaoDFYsl2
         tn4cJPrjWf4augfmgq/yh0o+PlrKquNKGxM+vgRAO/pBZE4l5MZ84gzT313lx8kTdwHV
         K6FxQulbeRmrkFTTBqGMFUcyGs7iCYU5rNySfLLa/9pwV0TyJUgHwk7niUza6Riz0S4E
         exNt9PaeK9U176+7vydCwwzvZPiJ41xLFN5PRFEM6K/4lqmnr+M/uc8DzjHVI5S0MNyE
         fNme6kL5jj1uCRkbMgT1tQ1KaxfYfrrr6h9aQJTHxFSoxa8k6RLI2cKkO5Sr1fugKJtF
         8g0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kaPjbKdMr76WDvODBflVFVeFIfBaQyO5rZm5rUBpNuw=;
        b=erovyGyeBo3at2zf1626IvU70BiNht1hBLgF8z0RLZho1o+bvndC0mVwa8JKFcQnYp
         /8rw9r4lI7zy+r/oRI5/cvPgl7Fy+EgsEg9BHSeHhwN6OaeH0iS9DGEbWgEeNr1d+0iX
         lL2esXwNpcru5bVvrpEIq63cjqTs42FdMgLaxvivWB/j+p5ZeuIyPN+hhy54FQUuYgof
         v7zuB92rYNYzLE0FxPsnF/b/7cIu3MA4ehzA6YewG1ekPJBbmGp6jNXgvmLtjbElTHb2
         ClV2mJcfge1SnvUOmsAylC3fgZA6p027yVM3BhXTTYdWvCu1RBidjAcoc9fDoIKkHCar
         eiUg==
X-Gm-Message-State: ANoB5pli/dvuvDnLniMP20Tph6OrXgG10O5S++aeoykGR2fjndXi44Wz
        ZZ0NnLOTBeTnhlC56ptXuLOLBg==
X-Google-Smtp-Source: AA0mqf6vaK+43TBHB5IP98FncgtiD9SnBheWSw4weMDQLfnluEzaSymwtarl0qzMsoQxR8wgtmqdTQ==
X-Received: by 2002:a05:600c:4e46:b0:3d1:c8c8:fc0 with SMTP id e6-20020a05600c4e4600b003d1c8c80fc0mr15296436wmq.10.1670934964621;
        Tue, 13 Dec 2022 04:36:04 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id o3-20020a05600c4fc300b003cfbbd54178sm3375484wmq.2.2022.12.13.04.36.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Dec 2022 04:36:04 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-ppc@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-8.0 2/4] hw/ppc/vof: Do not include the full "cpu.h"
Date:   Tue, 13 Dec 2022 13:35:48 +0100
Message-Id: <20221213123550.39302-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221213123550.39302-1-philmd@linaro.org>
References: <20221213123550.39302-1-philmd@linaro.org>
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

"vof.h" doesn't need the full "cpu.h" to get the target_ulong
definition, including "exec/cpu-defs.h" is enough.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/vof.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/hw/ppc/vof.h b/include/hw/ppc/vof.h
index f8c0effcaf..d3f293da8b 100644
--- a/include/hw/ppc/vof.h
+++ b/include/hw/ppc/vof.h
@@ -9,7 +9,7 @@
 #include "qom/object.h"
 #include "exec/address-spaces.h"
 #include "exec/memory.h"
-#include "cpu.h"
+#include "exec/cpu-defs.h"
 
 typedef struct Vof {
     uint64_t top_addr; /* copied from rma_size */
-- 
2.38.1

