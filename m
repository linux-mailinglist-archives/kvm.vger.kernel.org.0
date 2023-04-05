Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5142D6D82EC
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239101AbjDEQFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239118AbjDEQFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:05:25 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66BE6E82
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:05:22 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id s13so21172384wmr.4
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680710721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5CSHrPIDjf1IWIN1nnp6I0uB6O25vizWYPyXq8gYKvo=;
        b=G6pPxv8mxmBXT/A7Fms6p48gVBPAVhCbwwptPPupZJfFBxICRxzF5EfjLYHeeUdIOM
         KuTVNoN2hg8Z3US/l5DXZyRgclnPh2Svov5K5NTEkQxYcjBSczhbLwslailyhLzmv6Hx
         91gp8FcyA1tMzQYLGb0/U7BSEeLNYMUXaL3U64SUPUMVKewIvfK4P2ZczU3Eu+z/zV/O
         nTNCHqofXowPBxAA4rcW8XP7R0rJ7wuGTOYWFborUVJW0xF27yen/vXwymcuMP8cWAbJ
         k89Nl96lVK8m1OUz0Xtgy2IppNpCw1q/fBG9RE/e5WdoX3T9mSBBSUEfBaVAMGEYLdkN
         N91w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5CSHrPIDjf1IWIN1nnp6I0uB6O25vizWYPyXq8gYKvo=;
        b=o6KzgHWa8IQx09nq7J6lDaEAuNTEUFdPd8wnxF8b0G0LXnzxYJSgJtetHAdwwg0/Lb
         bhOiVxm3vgESeSXcAgC+O9laAbs0DbAOCpPacJY2oPY6D+GvmXWX7vnG0olgFiYGFQjM
         +o6mF43PSq5KDBo6D5WYIPW/9CWJu0Y8WkqmX/zcxXNoBk3yn9mvYlI3XtOJxUUTTqSQ
         3lUc/fTTOqnZHab9xE0W0aYCSgIdAyvSVRqXlNoUgXAqVRjiHZ4I3ELDwd+YiFmsaryf
         b0TXElDElIdQlFfPdTUKuX5E/2XmKJ40bZVy3jFkJQ3jRI9MspNic0fdp6+9cEH3nFwE
         n+9g==
X-Gm-Message-State: AAQBX9exGJ21wE9LFyImypXWhNkIqKpppRv+7NeW+t+jZsBVNb1+EweS
        4/vF4q06LOsZ+T5iGjUVKWbUAzYRZrwsEcNBGhA=
X-Google-Smtp-Source: AKy350b2wk0eAixgIQgLvmWawSUCyvt3DQf5sn09y8olDFh7GE1/OjoIxJal0B3a+G4fHcJYO+q/Sg==
X-Received: by 2002:a7b:c4ca:0:b0:3ed:e5db:52e1 with SMTP id g10-20020a7bc4ca000000b003ede5db52e1mr5471510wmk.15.1680710721116;
        Wed, 05 Apr 2023 09:05:21 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id r15-20020a05600c458f00b003f03d483966sm2662576wmo.44.2023.04.05.09.05.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:05:20 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 04/10] hw/intc/arm_gic: Rename 'first_cpu' argument
Date:   Wed,  5 Apr 2023 18:04:48 +0200
Message-Id: <20230405160454.97436-5-philmd@linaro.org>
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

"hw/core/cpu.h" defines 'first_cpu' as QTAILQ_FIRST_RCU(&cpus).

arm_gic_common_reset_irq_state() calls its second argument
'first_cpu', producing a build failure when "hw/core/cpu.h"
is included:

  hw/intc/arm_gic_common.c:238:68: warning: omitting the parameter name in a function definition is a C2x extension [-Wc2x-extensions]
    static inline void arm_gic_common_reset_irq_state(GICState *s, int first_cpu,
                                                                       ^
  include/hw/core/cpu.h:451:26: note: expanded from macro 'first_cpu'
    #define first_cpu        QTAILQ_FIRST_RCU(&cpus)
                             ^

KISS, rename the function argument.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/intc/arm_gic_common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/hw/intc/arm_gic_common.c b/hw/intc/arm_gic_common.c
index 9702197856..889327a8cf 100644
--- a/hw/intc/arm_gic_common.c
+++ b/hw/intc/arm_gic_common.c
@@ -235,12 +235,13 @@ static void arm_gic_common_realize(DeviceState *dev, Error **errp)
     }
 }
 
-static inline void arm_gic_common_reset_irq_state(GICState *s, int first_cpu,
+static inline void arm_gic_common_reset_irq_state(GICState *s,
+                                                  int first_cpu_index,
                                                   int resetprio)
 {
     int i, j;
 
-    for (i = first_cpu; i < first_cpu + s->num_cpu; i++) {
+    for (i = first_cpu_index; i < first_cpu_index + s->num_cpu; i++) {
         if (s->revision == REV_11MPCORE) {
             s->priority_mask[i] = 0xf0;
         } else {
-- 
2.38.1

