Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81436D4625
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 15:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbjDCNth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 09:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbjDCNt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 09:49:27 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B706EAB
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 06:49:26 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d17so29403503wrb.11
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 06:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680529765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PldKx1qfpz7lDvG61jB68knTHdO2ooZN76NERNqkzDY=;
        b=tAaXPTuxrZUwgDhNs2VAA3i3A5sbpUS96TJNu9EnHiuS5McEnfl5cstLz9L8iPRyMm
         jWDWiyCo47qpsZoFmbQlC86I9o0KKIsuvTeq+G6EWzEJkwAAJpeHCXDuAQsCgp2zn9eX
         F4qqn5xVcYpsCdCgRKXYKrcLgDuVHj3/chtJPS5xOJaQqG0XSxlyHWqCpnnl5tDVrWwd
         EhL57J/td90pFXIrSsBfNC92WqwTVsqMuokr0Zsf2W5SUy3L5RWjqyLYARjjsoYgZyCW
         p7Jd4iSOaVHpFVYz33XRBz8xdSqji6nhgSHdB/Kbk3PNu/cm1fr86kp6okiP5IdY760a
         pjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PldKx1qfpz7lDvG61jB68knTHdO2ooZN76NERNqkzDY=;
        b=XhIEhIvr5a545QlT+kUPp7GYKsa/8aEH0Xe+15CqlLYn4uXJHFuDBnlODQkOTwpKEn
         HdhyNfL26Msz39J1KB7z5nN9FTe+uhtNOzRE9qfcdZya8UomZy1OQ321OiMDJ5FlJns3
         EaiFNvceXj085di/Wvqyf22f3M5bIz9NPebVaCeG94s3NMr+VQTi0cuCaXV9Sx671CMR
         +nbmXTRVZBpjv+zq+hX9BrlLERzLInODD28nFRx7UxdGpU5TGaWZVGcwLzRF1VjtLsp+
         JGkA73MXSWVDVvYaIisbLaNJN66kQK3UTlQ6ZVzhZGesa6+1wcaKY17R4t3HSD1lvWY2
         nVjw==
X-Gm-Message-State: AAQBX9c3cP/nJMbT6QBuHDxHyYuEJAxPvNaa9jO+cCwCCbdtMn/mcGI/
        RJZcmLoUQsrKTBlWFRwgvQLmrg==
X-Google-Smtp-Source: AKy350bQGOJWN5zGDlFHeOGdE2SUiSfVLxmAnGCX0rxA7lXuuoZ5vohL7JrbQpsr9aKTsRFQUoJkHg==
X-Received: by 2002:adf:e848:0:b0:2c7:fde:f7e0 with SMTP id d8-20020adfe848000000b002c70fdef7e0mr24295594wrn.65.1680529765220;
        Mon, 03 Apr 2023 06:49:25 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id p13-20020a05600c468d00b003ef7058ea02sm19327158wmo.29.2023.04.03.06.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:49:23 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 960301FFC0;
        Mon,  3 Apr 2023 14:49:21 +0100 (BST)
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
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH v2 09/11] tests/vm: use the default system python for NetBSD
Date:   Mon,  3 Apr 2023 14:49:18 +0100
Message-Id: <20230403134920.2132362-10-alex.bennee@linaro.org>
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

From: Daniel P. Berrangé <berrange@redhat.com>

Currently our NetBSD VM recipe requests instal of the python37 package
and explicitly tells QEMU to use that version of python. Since the
NetBSD base ISO was updated to version 9.3 though, the default system
python version is 3.9 which is sufficiently new for QEMU to rely on.
Rather than requesting an older python, just test against the default
system python which is what most users will have.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230329124601.822209-1-berrange@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20230330101141.30199-9-alex.bennee@linaro.org>
---
 tests/vm/netbsd | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/vm/netbsd b/tests/vm/netbsd
index aa54338dfa..0b9536ca17 100755
--- a/tests/vm/netbsd
+++ b/tests/vm/netbsd
@@ -30,7 +30,6 @@ class NetBSDVM(basevm.BaseVM):
         "git-base",
         "pkgconf",
         "xz",
-        "python37",
         "ninja-build",
 
         # gnu tools
@@ -66,7 +65,7 @@ class NetBSDVM(basevm.BaseVM):
         mkdir src build; cd src;
         tar -xf /dev/rld1a;
         cd ../build
-        ../src/configure --python=python3.7 --disable-opengl {configure_opts};
+        ../src/configure --disable-opengl {configure_opts};
         gmake --output-sync -j{jobs} {target} {verbose};
     """
     poweroff = "/sbin/poweroff"
-- 
2.39.2

