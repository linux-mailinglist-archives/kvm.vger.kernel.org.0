Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8505B73A58D
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjFVQIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjFVQIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:08:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCE119BE
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:08:42 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-31121494630so8420495f8f.3
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687450120; x=1690042120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+JIxHWMClVl6mvpALDoBK231PZeNGUQgT3foMweSwl8=;
        b=m+sOyJwBwsltlHfQ5plMWKOLIis+OEb+I+kYqnZLv4G8Ud23JDgwJFKc5QbUKlQQoS
         1zKSS1dPuy4yqZPNl6TAEFOkN/4qh6Z7q8wJxnI3w+xUocRyREHjcikLswb/B58iAjAw
         i0Kwl0CU2mChgimY0x1pocirTiLNpGhvP2OOxOZgzVdLhbaNm1KhLhoBCcbuNucTQQ3G
         RtyEsciQU1EctCDZTXKzkq/56Q8BpF4exuWzK5Zi9+g+wdZDHRqUsfqn3qJyaskO1hMN
         ORq6jEFNL0dLVh/Tn8LHeYLlV/JThI4azyQy/GqlByxiQt/VVPM3RXqUH7+Gq+EH6hC4
         YgBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687450120; x=1690042120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+JIxHWMClVl6mvpALDoBK231PZeNGUQgT3foMweSwl8=;
        b=MwLm86tc4AaqKFAPWKma+77PebxxvypeCLHig+V85865B5kXCeh3/Ii5BNGA92S6Vb
         NBJT98SLWtOLQLMWAQDI2DxJR58tX+opL67wnjkkYt+nyrez7G1YifMcMyrP3ElI0dUb
         Zr1OLM8+oUJsLeJRE7iEaRUua1S2cBvXaBUA4oB/r8s28YDzZy+fXscY2M0WrYnhKoX3
         b0K2YvtTDuyi99jHDMwpVAOJxHoBeLPiFK7MzGynUDwqSJxy+vkp1z01tru1PIxkWA/j
         PsMq0GZOazVFLAIex/aBY7JZDWkI2CBTWkfmZ6N5MTehhD2fosvZAclCH1f4TeFatRSz
         I4+Q==
X-Gm-Message-State: AC+VfDyaEESBHXO5wzXTFtZ2d+vFrLcddsu20QGICSYs/QD/vcZl8kDT
        21wnJJzOgefOQgmS5ujRKYncRQ==
X-Google-Smtp-Source: ACHHUZ6j9PL4gNb09NvEUjJSuIorrjesDgNKCq1cC1uX5pyBuSA6/zCj91wre6SrtXJc4I0XeTLuqQ==
X-Received: by 2002:a5d:67cd:0:b0:2ef:b052:1296 with SMTP id n13-20020a5d67cd000000b002efb0521296mr16834670wrw.22.1687450120463;
        Thu, 22 Jun 2023 09:08:40 -0700 (PDT)
Received: from localhost.localdomain (230.red-88-28-3.dynamicip.rima-tde.net. [88.28.3.230])
        by smtp.gmail.com with ESMTPSA id k7-20020a5d5187000000b0031128382ed0sm7377909wrv.83.2023.06.22.09.08.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Jun 2023 09:08:40 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Reinoud Zandijk <reinoud@netbsd.org>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Alexander Graf <agraf@csgraf.de>,
        Richard Henderson <richard.henderson@linaro.org>,
        xen-devel@lists.xenproject.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v2 01/16] MAINTAINERS: Update Roman Bolshakov email address
Date:   Thu, 22 Jun 2023 18:08:08 +0200
Message-Id: <20230622160823.71851-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230622160823.71851-1-philmd@linaro.org>
References: <20230622160823.71851-1-philmd@linaro.org>
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

r.bolshakov@yadro.com is bouncing: Update Roman's email address
using one found somewhere on the Internet; this way he can Ack-by.

(Reorder Taylor's line to keep the section sorted alphabetically).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 MAINTAINERS | 4 ++--
 .mailmap    | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f323cd2eb..1da135b0c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -497,14 +497,14 @@ F: target/arm/hvf/
 
 X86 HVF CPUs
 M: Cameron Esfahani <dirty@apple.com>
-M: Roman Bolshakov <r.bolshakov@yadro.com>
+M: Roman Bolshakov <rbolshakov@ddn.com>
 W: https://wiki.qemu.org/Features/HVF
 S: Maintained
 F: target/i386/hvf/
 
 HVF
 M: Cameron Esfahani <dirty@apple.com>
-M: Roman Bolshakov <r.bolshakov@yadro.com>
+M: Roman Bolshakov <rbolshakov@ddn.com>
 W: https://wiki.qemu.org/Features/HVF
 S: Maintained
 F: accel/hvf/
diff --git a/.mailmap b/.mailmap
index b57da4827e..64ef9f4de6 100644
--- a/.mailmap
+++ b/.mailmap
@@ -76,9 +76,10 @@ Paul Burton <paulburton@kernel.org> <pburton@wavecomp.com>
 Philippe Mathieu-Daudé <philmd@linaro.org> <f4bug@amsat.org>
 Philippe Mathieu-Daudé <philmd@linaro.org> <philmd@redhat.com>
 Philippe Mathieu-Daudé <philmd@linaro.org> <philmd@fungible.com>
+Roman Bolshakov <rbolshakov@ddn.com> <r.bolshakov@yadro.com>
 Stefan Brankovic <stefan.brankovic@syrmia.com> <stefan.brankovic@rt-rk.com.com>
-Yongbok Kim <yongbok.kim@mips.com> <yongbok.kim@imgtec.com>
 Taylor Simpson <ltaylorsimpson@gmail.com> <tsimpson@quicinc.com>
+Yongbok Kim <yongbok.kim@mips.com> <yongbok.kim@imgtec.com>
 
 # Also list preferred name forms where people have changed their
 # git author config, or had utf8/latin1 encoding issues.
-- 
2.38.1

