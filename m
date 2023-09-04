Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5EA791758
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352874AbjIDMo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352862AbjIDMo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:44:26 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EA1E6A
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:44:17 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-52c9f1bd05dso2063521a12.3
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831456; x=1694436256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBy9B8/ychOxzyt4MqhLID6RA2iJpJf7s2rkxq992Dw=;
        b=t44XWowjpeyfurw0yOcHmsyLm/jX+WmVgbvxPAQLxdVXmD6VDmKTTJO1ft4wBn1M4E
         dqSmegvy1lRo/xXG+zBaoqs3WN0dyA0ys8q+ne15p90smxe4oZ+0cngFj5GnuUR1EuUd
         PFs4m3O5SjPiGLAoFRHvRrHMUzDD6PhDthYahUvUMhNGqE48Begg1KEj+fNJjU2nogB0
         nDLhi2G3Gc0EBXESPbCrdW88l83UUvEYhc24k2ojhQXVq/fA+T3U0WBeqGFa6KmMmTce
         18+fkzBcxkXY28drahp8Gv3BEb2Sz156s/H/TVGOqLUhKR3cxxL8W1DglyAppn3DpPGc
         n2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831456; x=1694436256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yBy9B8/ychOxzyt4MqhLID6RA2iJpJf7s2rkxq992Dw=;
        b=ObPC1wFAKDK36a+Y77UIj43P89HqYAOvWGsN9G6aE3dEC7hc1wvv11G0gum3GHV4IG
         JiAGMeW6lUJ/Zf3eovOPLC7SBPjq5NTBbwe4HNH0nUA/WeTCtt29hmoXFzbGkjOM0lXR
         /ol0V09wbbUECQGuKh7c2RG5Lp6WhVS6tqItFP1zCnzcmNtS6/WPqSVw2nM14TjBD7ac
         B6sykdttUXxevEsHZ1eIj5jIJeCNeMkIM92+1iDPSbTcBXV9mmWoSDyHmU+LaCr2Mpzp
         ZExo3ylmBPp/qdfuGCPz9xC3Aw2XW+p8gILjq00aAwTmtZvhh9razderziB2SHuujVw3
         wZYg==
X-Gm-Message-State: AOJu0YwYr+1l1x5biVZurwjba7DW6wwahatrG7ds5S4kDloLb5EucVOl
        Ff9r5F050izuLKTd3Vayuj6jgA==
X-Google-Smtp-Source: AGHT+IG4z1vB/QZFvcTz4ZepoUXgBUZve8udAT7n1n0cJ/4FcFU6pkPiPnNOm13Rql1ddwKB2By5rQ==
X-Received: by 2002:aa7:d3d2:0:b0:523:2dd6:62bf with SMTP id o18-20020aa7d3d2000000b005232dd662bfmr8674466edr.34.1693831455850;
        Mon, 04 Sep 2023 05:44:15 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id m7-20020aa7c2c7000000b00523a43f9b1dsm5777597edp.22.2023.09.04.05.44.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:44:15 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH 08/13] target/i386: Allow elision of kvm_hv_vpindex_settable()
Date:   Mon,  4 Sep 2023 14:43:19 +0200
Message-ID: <20230904124325.79040-9-philmd@linaro.org>
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

Call kvm_enabled() before kvm_hv_vpindex_settable()
to let the compiler elide its call.

kvm-stub.c is now empty, remove it.

Suggested-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/x86.c               |  2 +-
 target/i386/kvm/kvm-stub.c  | 18 ------------------
 target/i386/kvm/meson.build |  2 --
 3 files changed, 1 insertion(+), 21 deletions(-)
 delete mode 100644 target/i386/kvm/kvm-stub.c

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index d2920af792..ecf16ef402 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -424,7 +424,7 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
     cpu->thread_id = topo_ids.smt_id;
 
     if (hyperv_feat_enabled(cpu, HYPERV_FEAT_VPINDEX) &&
-        !kvm_hv_vpindex_settable()) {
+        kvm_enabled() && !kvm_hv_vpindex_settable()) {
         error_setg(errp, "kernel doesn't allow setting HyperV VP_INDEX");
         return;
     }
diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
deleted file mode 100644
index 62cccebee4..0000000000
--- a/target/i386/kvm/kvm-stub.c
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * QEMU KVM x86 specific function stubs
- *
- * Copyright Linaro Limited 2012
- *
- * Author: Peter Maydell <peter.maydell@linaro.org>
- *
- * This work is licensed under the terms of the GNU GPL, version 2 or later.
- * See the COPYING file in the top-level directory.
- *
- */
-#include "qemu/osdep.h"
-#include "kvm_i386.h"
-
-bool kvm_hv_vpindex_settable(void)
-{
-    return false;
-}
diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
index 40fbde96ca..5d9174bbb5 100644
--- a/target/i386/kvm/meson.build
+++ b/target/i386/kvm/meson.build
@@ -1,5 +1,3 @@
-i386_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
-
 i386_softmmu_kvm_ss = ss.source_set()
 
 i386_softmmu_kvm_ss.add(files(
-- 
2.41.0

