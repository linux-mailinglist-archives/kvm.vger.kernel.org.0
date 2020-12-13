Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6648C2D9065
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404092AbgLMUV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393142AbgLMUV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:26 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2EDC061285
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:04 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id w206so7881384wma.0
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U1U85wbWiHYedQBnfCehC7vZG2diuqNh/zEf3sAbatk=;
        b=mbQ3Z2kBPsaAeNkAQKlf/Uqc+U93xRoHgnDONlAQ92t4i03Hzh6EQALZI3Y2KEc3U+
         o1H1TjPOani/Sz3yMY3hKY0n4Iz4FeNkEvoziMZBhVWPvaAKITTeu44/mfWZKwfWa0I4
         /T/ovt9++wGDAVVgNaxc87M6DLv7/29iSOO5+y5mmpzQKXzDAstTpYhBBdpnhsqyy+JI
         xRRTW0sZVAuSoU6T7YTvOgQbY3LDniMGS6RyWJroOc9o4kEmKD0NqLGZr4oPM7YSPIMn
         IPXHhDCwvsP6b4T/7/VJQrFU++XjnyBZwrmpSRQizF+pFmOmSQAF3ZXYlKC0BEfn25V7
         qyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=U1U85wbWiHYedQBnfCehC7vZG2diuqNh/zEf3sAbatk=;
        b=jS7viDQ0XTjmSIqBP/LA1LVmEDqjnA2e3g/tOj6By3p3jANWFETZj+FgMw0hufBkJJ
         WDb7XI+z/tFrSRttFpLsWr8qP4g1J85NqybgwfzjV3k8TrwsrmfwemUlom0b447AtPcf
         XDOA3xYdOnd4Jljb8N295tckWc/Oes13Q00cZoDExAvzwLamok6AMZN21FuhZw06XDgi
         lZ1yrkWonKm7ScgtBIvfR1JK3DmC6RHEPym/Ga5Kx7bvr47gxNfEFmW++1nGFPsiFc60
         r19zcVCP+jZm9Jw1DETDrL2lzzQoZdoGGiAzuqNMT0fMHm7MLUzOWABJax6TBqR2t6wS
         C6yw==
X-Gm-Message-State: AOAM531TWnzYNSdofLOAAnAcoN9EE4cobPI46taAoIYDSQmd72sG64YQ
        lGjv28If1lI14M2VD1C4III=
X-Google-Smtp-Source: ABdhPJzNHgtxhEQNX7DznNzRimsoGP5ISuhO0bLMbYb6QifZ7mqmtSXaufbgDyGau189eqa0XDfA4Q==
X-Received: by 2002:a1c:43c5:: with SMTP id q188mr24563275wma.163.1607890863692;
        Sun, 13 Dec 2020 12:21:03 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id h5sm30144342wrp.56.2020.12.13.12.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:21:03 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 15/26] target/mips: Remove unused headers from op_helper.c
Date:   Sun, 13 Dec 2020 21:19:35 +0100
Message-Id: <20201213201946.236123-16-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-6-f4bug@amsat.org>
---
 target/mips/op_helper.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/mips/op_helper.c b/target/mips/op_helper.c
index 5184a1838be..5aa97902e98 100644
--- a/target/mips/op_helper.c
+++ b/target/mips/op_helper.c
@@ -19,15 +19,11 @@
  */
 
 #include "qemu/osdep.h"
-#include "qemu/main-loop.h"
 #include "cpu.h"
 #include "internal.h"
-#include "qemu/host-utils.h"
 #include "exec/helper-proto.h"
 #include "exec/exec-all.h"
-#include "exec/cpu_ldst.h"
 #include "exec/memop.h"
-#include "sysemu/kvm.h"
 
 
 /*****************************************************************************/
-- 
2.26.2

