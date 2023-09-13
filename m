Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE66B79E3BF
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbjIMJa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239011AbjIMJaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:30:55 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9500A10DF
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:30:51 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-403004a96eeso46197175e9.3
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694597450; x=1695202250; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtT3ML1tHJnWRfmIXQrD6YCHmxZTPOtervgh4drQU7s=;
        b=HDKj0+bAZBOT8gppGB8h8WhHtbtStGz1B/XEpAUhsuoWLvl1jtboHCQL+1Jfu/zlsO
         qhC1GFJHg/8Z1iWHQ5Wgv+RUrwwsvv1D1mCzGEXpW/cYrPai9O8uOQGFHMMEpwjAncBX
         LP0KG9GCJIAvxuA+uDs8htH91RDUJimjDaPnKagSX03NNrQk2l3qJi31D7SOGz9XlzKt
         hDq7+j8n668yG23WBPZcL+v/Hs2QV5tW04WU/g8rrVGVAYgcpShikSABpmehQMwK4t7u
         0HRIPL7XNDNwmocNeXuLGszYFPH3kyXqu7xmYEyM7+iXYV0daIEw5C9RyrC64Lw5h4WY
         tlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694597450; x=1695202250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jtT3ML1tHJnWRfmIXQrD6YCHmxZTPOtervgh4drQU7s=;
        b=me053Hniw5Laww1mB2y/1UPIQdbdwHcnAnZnjpI9r4uSuKita7Z7EcNRD/neK+CcMm
         gudBaMwXAMlhtpSLJIWdjjP4x9JN4fc5W0iTCO3/CE9cBSNEiamuSQfHk3bu1v+i3Goe
         b9YVslNhXXA8juxkneDucsWKBZNksgDYrzp6/qCdEhNIm/JczmLLls9lF5Jc3xRaaK9d
         tsgJ3LkKexCrh0nuv92dGPEiINXAAVwk2PcKlci/Ww7mo9s22lQZn75pFm7oHpWM84ce
         KwgsiJ4bfFL6JAnY+AjpPmlHGn4p9R4mHV1YRJ7AiTkdT+8LUthkL7cCLWZVmasblvbd
         hldQ==
X-Gm-Message-State: AOJu0YxFfR4oZx4MAAPvckfeSwMZqXPAXKJIc8O+YTj51/XJnOZ0JPac
        7yK/a0oupiSWJG58IYJe32juWA==
X-Google-Smtp-Source: AGHT+IGD2WPDLCyweINrRoQof3jTKC1mX87q6WXI/fyFE1kXJNwVQRZhwnclukg8a31JArVaogLfzA==
X-Received: by 2002:a7b:c397:0:b0:402:ea6f:e88f with SMTP id s23-20020a7bc397000000b00402ea6fe88fmr1496700wmj.5.1694597450118;
        Wed, 13 Sep 2023 02:30:50 -0700 (PDT)
Received: from m1x-phil.lan (176-131-211-241.abo.bbox.fr. [176.131.211.241])
        by smtp.gmail.com with ESMTPSA id l14-20020a1c790e000000b003fe4ca8decdsm1465100wme.31.2023.09.13.02.30.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Sep 2023 02:30:49 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Kevin Wolf <kwolf@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 6/6] target/i386: Prohibit target specific KVM prototypes on user emulation
Date:   Wed, 13 Sep 2023 11:30:08 +0200
Message-ID: <20230913093009.83520-7-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230913093009.83520-1-philmd@linaro.org>
References: <20230913093009.83520-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

None of these target-specific prototypes should be used
by user emulation. Remove their declaration there, so we
get a compile failure if ever used (instead of having to
deal with linker and its possible optimizations, such
dead code removal).

Suggested-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/kvm/kvm_i386.h | 4 ++++
 target/i386/cpu.c          | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 55d4e68c34..5ef73f0a1c 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -13,6 +13,10 @@
 
 #include "sysemu/kvm.h"
 
+#ifdef CONFIG_USER_ONLY
+#error Cannot include kvm_i386.h from user emulation
+#endif
+
 #ifdef CONFIG_KVM
 
 #define kvm_pit_in_kernel() \
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index c201ff26bd..db8ed6284d 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -26,7 +26,7 @@
 #include "tcg/helper-tcg.h"
 #include "sysemu/reset.h"
 #include "sysemu/hvf.h"
-#include "kvm/kvm_i386.h"
+#include "sysemu/kvm.h"
 #include "sev.h"
 #include "qapi/error.h"
 #include "qemu/error-report.h"
@@ -40,6 +40,7 @@
 #include "exec/address-spaces.h"
 #include "hw/boards.h"
 #include "hw/i386/sgx-epc.h"
+#include "kvm/kvm_i386.h"
 #endif
 
 #include "disas/capstone.h"
-- 
2.41.0

