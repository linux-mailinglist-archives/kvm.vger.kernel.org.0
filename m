Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E826D461F
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 15:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbjDCNt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 09:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbjDCNtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 09:49:25 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FF8728D
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 06:49:23 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id o24-20020a05600c511800b003ef59905f26so18134627wms.2
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 06:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680529762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mN816sNtX5Vdj2G92pvv8I3i5QnGeNTrX25n5LbvU4I=;
        b=O5sLqRX3o8wg3JSEuHWQfk7e53SjZslyalKpbNubzgxabPQbImJEAab9cWKIwTylAL
         WgcyZqFlockFyY+eZ0Bf7vXgYjz2ZTwNjuS2v73b4lgsIVnXRvHaM3qr2WnHPKUdJAQI
         5B7WEues0f+SO+CL77LGCSGQrN7h0W/Tk+GIroANmG1yd2r3D4iFC3sC8EHZrTpiedQM
         sCILzvAqFtezCm6x72Z0UwzZmMlakI+VNU2GyYzB0Ne1NYLNF4GJQVY+tueL2OS5ZQkU
         bx43IXHTD/y2FJ9UOtFFsIU3eYKPZNE6kaHy0DTyMLxFc6WvKs0qn0lonWM8EUzREfvE
         2wSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mN816sNtX5Vdj2G92pvv8I3i5QnGeNTrX25n5LbvU4I=;
        b=RO2kEyuW7swt1nlSNgLSC1iwCaj3Leb0blP2Dn1J4Seo9aj2xN9eKscseh9ZdRGtUF
         ZqmR6KyLI+nvNCBxbQ5eRs2HlO1DFDRpd/c/F1JATkaY1Ir53IetOPIkMpJZBGg4WQ4r
         uRY5yA9wQ8k44geiOtvU0GMJqEJi8d5jRz5Ggakc2mQaMNy6czrwi6qEAO3u1//0ZH6D
         bIqy2zQ+X7NZUrrgbbHjdPMDQ7OM01k2zgGxgfQfCMrm+PkLbG0KS1gpr682MiFV+gUN
         7b182g2chHJW9mUCQE3nJs7aAUGfauvPaxd/d3r5B2dfYSK9eCy+nei/BtOAto8ASUjb
         R7Yw==
X-Gm-Message-State: AAQBX9cE06GSC1jt+JrUeLAx2Nh7oS1NRg6iuIupSgAwsDlRMP0BtczW
        qt/xkzNgfZhuo2mHsKa/za+Y8w==
X-Google-Smtp-Source: AKy350ZwFB2r0eAYmFp0426BeiHDQwJvp+zag6ay5Q14nm/hpxxlQCHq0zP0DbsDmaKOiNfdE1IMxQ==
X-Received: by 2002:a7b:c045:0:b0:3ef:6fee:8057 with SMTP id u5-20020a7bc045000000b003ef6fee8057mr19211144wmc.25.1680529761833;
        Mon, 03 Apr 2023 06:49:21 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id l7-20020a05600c4f0700b003ef5deb4188sm19526828wmq.17.2023.04.03.06.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:49:21 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id E356F1FFBA;
        Mon,  3 Apr 2023 14:49:20 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Ryo ONODERA <ryoon@netbsd.org>, qemu-block@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>, Warner Losh <imp@bsdimp.com>,
        Beraldo Leal <bleal@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Kyle Evans <kevans@freebsd.org>, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v2 02/11] gdbstub: Only build libgdb_user.fa / libgdb_softmmu.fa if necessary
Date:   Mon,  3 Apr 2023 14:49:11 +0100
Message-Id: <20230403134920.2132362-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403134920.2132362-1-alex.bennee@linaro.org>
References: <20230403134920.2132362-1-alex.bennee@linaro.org>
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

From: Philippe Mathieu-Daudé <philmd@linaro.org>

It is pointless to build libgdb_user.fa in a system-only build
(or libgdb_softmmu.fa in a user-only build). Besides, in some
restricted build configurations, some APIs might be restricted /
not available. Example in a KVM-only builds where TCG is disabled:

  $ ninja qemu-system-x86_64
  [99/2187] Compiling C object gdbstub/libgdb_user.fa.p/user.c.o
  FAILED: gdbstub/libgdb_user.fa.p/user.c.o
  ../../gdbstub/user.c: In function ‘gdb_breakpoint_insert’:
  ../../gdbstub/user.c:438:19: error: implicit declaration of function ‘cpu_breakpoint_insert’; did you mean ‘gdb_breakpoint_insert’? [-Werror=implicit-function-declaration]
    438 |             err = cpu_breakpoint_insert(cpu, addr, BP_GDB, NULL);
        |                   ^~~~~~~~~~~~~~~~~~~~~
        |                   gdb_breakpoint_insert
  ../../gdbstub/user.c:438:19: error: nested extern declaration of ‘cpu_breakpoint_insert’ [-Werror=nested-externs]
  ../../gdbstub/user.c: In function ‘gdb_breakpoint_remove’:
  ../../gdbstub/user.c:459:19: error: implicit declaration of function ‘cpu_breakpoint_remove’; did you mean ‘gdb_breakpoint_remove’? [-Werror=implicit-function-declaration]
    459 |             err = cpu_breakpoint_remove(cpu, addr, BP_GDB);
        |                   ^~~~~~~~~~~~~~~~~~~~~
        |                   gdb_breakpoint_remove
  ../../gdbstub/user.c:459:19: error: nested extern declaration of ‘cpu_breakpoint_remove’ [-Werror=nested-externs]
  cc1: all warnings being treated as errors
  ninja: build stopped: subcommand failed.

Fixes: 61b2e136db ("gdbstub: only compile gdbstub twice for whole build")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20230329161852.84992-1-philmd@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20230330101141.30199-3-alex.bennee@linaro.org>
---
 gdbstub/meson.build | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/gdbstub/meson.build b/gdbstub/meson.build
index bd5c5cd67d..cdb4d28691 100644
--- a/gdbstub/meson.build
+++ b/gdbstub/meson.build
@@ -20,11 +20,13 @@ gdb_softmmu_ss = gdb_softmmu_ss.apply(config_host, strict: false)
 libgdb_user = static_library('gdb_user',
                              gdb_user_ss.sources() + genh,
                              name_suffix: 'fa',
-                             c_args: '-DCONFIG_USER_ONLY')
+                             c_args: '-DCONFIG_USER_ONLY',
+                             build_by_default: have_user)
 
 libgdb_softmmu = static_library('gdb_softmmu',
                                 gdb_softmmu_ss.sources() + genh,
-                                name_suffix: 'fa')
+                                name_suffix: 'fa',
+                                build_by_default: have_system)
 
 gdb_user = declare_dependency(link_whole: libgdb_user)
 user_ss.add(gdb_user)
-- 
2.39.2

