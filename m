Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A0F79C4B5
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 06:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbjILEXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 00:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbjILEXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 00:23:11 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF753ABA
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 18:48:57 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-500bbe3ef0eso6135580e87.1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 18:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694483336; x=1695088136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+fItrFBqz4pCpmjDHSDhxOZeNtPLgdWkJxbwSRsqucM=;
        b=TF5iM86nCwpQ4ApNgq56Gr9W6yf56URY2/0prsV6jGIW5y8D9cHwbJCZBq/RoxaprO
         nwRWMvurda5K4vxDIohW3daY/2up0NCJKLKH3+scBraQEyJSoJf9QKjzoCmHjGZWvYXk
         TZHqAs30jtnmHX7RmKc5drVvjBTqmrGdUL2mUMc1hny4O/0fkBvh2I5XH1XEuQDB6Txz
         t9frfNwPhsQDfKqcbWl8CrTAzfux34rq2f79vcexRBximpM+dWXuxqOMVwqvDZSESrMG
         MwJ54sCs0/GeH7wcjGt9ZWRU38FTrPm20hxoXp6ugdyidg6MnULU+Lx7ZY4XGC4jLYi5
         b8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694483336; x=1695088136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+fItrFBqz4pCpmjDHSDhxOZeNtPLgdWkJxbwSRsqucM=;
        b=p2O3m2rija6/XuRhYZjysWQkszHHVo87oAMjbJuIyw7qM2/YkxaDpvmRrxdHbnwPME
         B0juDTqHkFD3W0cGwoCuuYUSOiLVONLkSDb9L03Kse6tFE2yKmeAJDo4t8gCmEnCo8z7
         IOlNW/mvm/Qd+0s1DwwE0Ph1O2r1PDMIAUM/QepiL8dNCapjuHBsc4hRng9/pIkmmZfa
         ncjFwfSXuW+gqrHS6FF95KHJvy3zlJ8F7Qow4ZrlHVXxs8DvrDKxYmJ6tOQByLSV5JM/
         oj9oa+cQfLH0D/hTpXMp0tibKe/cZW+M18e4/rYXh5ufVwXhzwiM3T2Gf1hGmYBqDOdN
         iIeA==
X-Gm-Message-State: AOJu0YzCFyleOvM1jfuBFVzI7Qb46hSDJ2oj6YYKQinhGYR/2iLFMrb0
        PYNsWVgiKlzr4PZqt1t/qUgS/40t14d1PAo3GIk=
X-Google-Smtp-Source: AGHT+IGfByT/i1uRgqjMTCe03exo5MUd5hVuuL5bXU9pWThAdvv0M71SxBPmrWR8igy+0e5BQCrT7w==
X-Received: by 2002:a50:ee89:0:b0:523:37f0:2d12 with SMTP id f9-20020a50ee89000000b0052337f02d12mr1117871edr.17.1694466819175;
        Mon, 11 Sep 2023 14:13:39 -0700 (PDT)
Received: from m1x-phil.lan (tfy62-h01-176-171-221-76.dsl.sta.abo.bbox.fr. [176.171.221.76])
        by smtp.gmail.com with ESMTPSA id c18-20020aa7d612000000b005254b41f507sm5126392edr.32.2023.09.11.14.13.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Sep 2023 14:13:38 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Kevin Wolf <kwolf@redhat.com>
Subject: [PATCH v4 3/3] target/i386: Prohibit target specific KVM prototypes on user emulation
Date:   Mon, 11 Sep 2023 23:13:17 +0200
Message-ID: <20230911211317.28773-4-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911211317.28773-1-philmd@linaro.org>
References: <20230911211317.28773-1-philmd@linaro.org>
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
index 8b57708604..6be59c7b2b 100644
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

