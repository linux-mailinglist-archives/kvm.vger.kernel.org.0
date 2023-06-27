Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E5C73FB66
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 13:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjF0LwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 07:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjF0LwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 07:52:04 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE45E71
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:51:58 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-991b7a4d2e8so272814866b.1
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687866717; x=1690458717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VO9Kit1sdoJ392FVmc33R5cx+Y6OihE9F+t/ncxHt8c=;
        b=YT5YuAOOsTqqfatWHVtR5bkFlY0OTtUHvz/0s46L5ULvuQ9jKzUP8DdeP4Gvihrma4
         p3ihWqPzfDEhIHOOPHC+rsh5mMYQeIQ3JnTnrFzesbzAqWnLmlojrINFWAaITg2IsoRa
         fFIVnpjnh0gaHLZeA0mtf9bEsjWc7j+R1jKgwpen8bJanw32gRd8dXnt/1Jln2WieGxc
         SfADtn16kwQiMn1ONmCxcXlGIEhWJ91N3aoLX3XCIWTMHMS7sJOPVwM7N15G+1CRoRf0
         cb1rzlPPnpb0DCmjSUxVMvNUof956VdbGliqmdPEL8p2bsAS8PUXfgobj2cWf3KG5MOu
         rvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687866717; x=1690458717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VO9Kit1sdoJ392FVmc33R5cx+Y6OihE9F+t/ncxHt8c=;
        b=QRdszwrP9tTeVRc754Pvp/RTzhDUU7AIYKj19GgDBNb9nNMRlqND0u47nprDbmNwwW
         zeSwQsaH0XZeCGqLE0ukSylPy1GPoZ8VQtOGJ3Q8ri2KTJJ2WXd1DkffJrxYL1tC1xo4
         EZV83BsAxCOaNFjgwGyYLxAy5eyXwxTWWJzXD954b9Pbx8/uVGd89IMDWzMcHulre+zB
         UuiZhLhQPEnRaeMXQrtZThIXiqLMPQxHEawii5ZRdO7nBbzoMbPYTUlp9cN9Bd2Ot34n
         1iiAtovxr4E0zbfy7k7LoHTQx4Qy8fA+wpwduVardVqsPJ/SkTLg84ewQu/fD5Pj0xRI
         Yfpw==
X-Gm-Message-State: AC+VfDy4FqwaQp1WJErWQzHpGtsD40A/vGzyX5RKDDxJbexbk57C4KOh
        9PWeAgv9h678yMGvi8tdFxabfQ==
X-Google-Smtp-Source: ACHHUZ5LgZQOdPi8vbeWTXXgBKtBWYxquWJPWcOG+nXOG6pwEQj7QCL4ybEz91QzLvRj1pWiyaIm9A==
X-Received: by 2002:a17:907:9450:b0:989:3670:3696 with SMTP id dl16-20020a170907945000b0098936703696mr17867636ejc.58.1687866717193;
        Tue, 27 Jun 2023 04:51:57 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.199.204])
        by smtp.gmail.com with ESMTPSA id a2-20020a1709065f8200b009827b97c89csm4455614eju.102.2023.06.27.04.51.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Jun 2023 04:51:56 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v3 5/6] target/ppc: Restrict 'kvm_ppc.h' to sysemu in cpu_init.c
Date:   Tue, 27 Jun 2023 13:51:23 +0200
Message-Id: <20230627115124.19632-6-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230627115124.19632-1-philmd@linaro.org>
References: <20230627115124.19632-1-philmd@linaro.org>
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

User emulation shouldn't need any of the KVM prototypes
declared in "kvm_ppc.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/cpu_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index aeff71d063..f2afb539eb 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -21,7 +21,6 @@
 #include "qemu/osdep.h"
 #include "disas/dis-asm.h"
 #include "gdbstub/helpers.h"
-#include "kvm_ppc.h"
 #include "sysemu/cpus.h"
 #include "sysemu/hw_accel.h"
 #include "sysemu/tcg.h"
@@ -49,6 +48,7 @@
 #ifndef CONFIG_USER_ONLY
 #include "hw/boards.h"
 #include "hw/intc/intc.h"
+#include "kvm_ppc.h"
 #endif
 
 /* #define PPC_DEBUG_SPR */
-- 
2.38.1

