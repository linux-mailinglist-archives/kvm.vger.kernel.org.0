Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C269B6D8358
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbjDEQOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjDEQOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:14:36 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E940872A9
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:14:12 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v1so36755211wrv.1
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680711250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AeQZJldIaB/1zbNu3DV9kzUmDswJpW46rk6Q7NupZW4=;
        b=Jj6PRM82WrwNk30qUgHPYkD/CupV2v9dtjKlKSBDUTiqD/HY1boMe0z16ZthvltKrI
         6OBlRem4em2riWVCMinDtCGa74F0CPJxw4gn19+eIta0Ld+562Wtqb8ZymvxntgwjOYG
         jsiSachkDUS3JDBRSQAvFCYFygDbXZP5toRT1yfzg6Tz6tXaINtbnKY8SDoJyeu+5v8A
         9PKx52iYbL4AwfUTmTNH6ACdvU6IyabBBtG/LDB/Teyi72wAMxjoQNYxcCt5HSJXaV6O
         Bb8418Qrxzp/8s33AXF2RYDjazr8bgDkfM7b04aSps79FwhecISdEc0k9ztLsOKwThM+
         mB7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680711250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AeQZJldIaB/1zbNu3DV9kzUmDswJpW46rk6Q7NupZW4=;
        b=IwsdR9UMKVAgGpMrEA0Y/arcZS0Lwh22zhGcFf9jjxvyTx85YExcckjXurRLkLpte1
         Wf52qOn7l9ECrXdqS5jHYCLzCyguY85Jl4CMQHgwRWrBMBeBwtT23+h4e9yOPge+K769
         LNtPCQ07oBJ4JLSHrgmVMXcjHGLR7GKyRdRc5SBIVuu0dfxrMgQ6IcUouby1lVVla4Y8
         rqTdoEWkrh8RSKbN/GDcll6F8vgPK/e0X1vbHeN4PnVIAWpwcaPUJcl5SSAsKY+I1pMQ
         uq0qMiuQ2jW7SLcp0Y/Z8cZcDtw/+ZFou6Srndw3ht+Yd1fY2odbqB1rjXm78fTiM0Rx
         1GIg==
X-Gm-Message-State: AAQBX9cHDZ8++Wzilw42g6IfG/RBfMtyvgpyDlNwnVuVfGLpUNpAYJeV
        jkYaEWqJKjM52xC9AG2Fi6UA0w==
X-Google-Smtp-Source: AKy350Y6ALMh7Z7Kp0IY6mnGdmB+FjCWSj2doTPrJmE3yfwWgU0aUMSZwESpTe+CWuF918MaRYtvgg==
X-Received: by 2002:a5d:452f:0:b0:2c7:cdf:e548 with SMTP id j15-20020a5d452f000000b002c70cdfe548mr4108119wra.71.1680711250196;
        Wed, 05 Apr 2023 09:14:10 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d4d11000000b002da75c5e143sm15277695wrt.29.2023.04.05.09.14.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:14:09 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 2/2] accel/stubs: Build HAX/KVM/XEN stubs once
Date:   Wed,  5 Apr 2023 18:13:56 +0200
Message-Id: <20230405161356.98004-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405161356.98004-1-philmd@linaro.org>
References: <20230405161356.98004-1-philmd@linaro.org>
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

These stub files don't require any target-specific bit.
(TCG stubs do, so this file is left in specific_ss[]).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/stubs/meson.build | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/accel/stubs/meson.build b/accel/stubs/meson.build
index 0249b9258f..a67f21a964 100644
--- a/accel/stubs/meson.build
+++ b/accel/stubs/meson.build
@@ -1,7 +1,9 @@
+sysemu_stubs_specific_ss = ss.source_set()
+sysemu_stubs_specific_ss.add(when: 'CONFIG_TCG', if_false: files('tcg-stub.c'))
+specific_ss.add_all(when: ['CONFIG_SOFTMMU'], if_true: sysemu_stubs_specific_ss)
+
 sysemu_stubs_ss = ss.source_set()
 sysemu_stubs_ss.add(when: 'CONFIG_HAX', if_false: files('hax-stub.c'))
-sysemu_stubs_ss.add(when: 'CONFIG_XEN', if_false: files('xen-stub.c'))
 sysemu_stubs_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
-sysemu_stubs_ss.add(when: 'CONFIG_TCG', if_false: files('tcg-stub.c'))
-
-specific_ss.add_all(when: ['CONFIG_SOFTMMU'], if_true: sysemu_stubs_ss)
+sysemu_stubs_ss.add(when: 'CONFIG_XEN', if_false: files('xen-stub.c'))
+softmmu_ss.add_all(when: ['CONFIG_SOFTMMU'], if_true: sysemu_stubs_ss)
-- 
2.38.1

