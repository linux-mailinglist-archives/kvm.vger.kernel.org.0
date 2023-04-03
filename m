Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDF26D4624
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 15:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbjDCNtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 09:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjDCNt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 09:49:27 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A906A1166C
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 06:49:26 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id d11-20020a05600c3acb00b003ef6e6754c5so14447126wms.5
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 06:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680529765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BNNm+hFhYmn6A4btsbTy8z3ys/wMqr7F5fsQ6UPTE0U=;
        b=uMZTW/+EF5o1W2A5JdfLs4oBqxYHeVBh65G8DF6NWJWPjReRFhKuCC/ncNpHwzh1qs
         mMEW2tZDNckEfFHS0GjWwR6IQexwG7ZXXRhicNL8f20z5m5Wdk3P5cQ8w/jkdpiCdqDL
         nLh92n6g0umdfLVI/eQbiF1cxRXgRItEeUiApK+mbKSMit9AUhnjl4hdTriQp+jk79nE
         6tFc8cnDjdFMut0KwN1OCHIduIw+ynMVFPZ/mXSo/w5MIZx1TOwiMx0bB0B/C3Z3gm0j
         6ePgrajdov1CzO49xyt1IvyKD+1XurKgKZaKP/PrY/1o3SOzUPkceYK5rLcstSpCjaYb
         OY9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BNNm+hFhYmn6A4btsbTy8z3ys/wMqr7F5fsQ6UPTE0U=;
        b=TE8fhL0YLriohDINRmkKmhXwaLGKWvo1FYpN+yFizNl5EtpMv25yqdXU8ZvSfPUzJ2
         rHPjteTYoEHvg17ubSk/wyAj97Pdk8w4SknH9Zs8yF3uD7wWVCfbR0L1b3goGpeCgQ3I
         AtMPxvXEG/0chhYgGs965B1s0a2OulyYViUn/xxG1FcT8fXs41Os/KnUj1dZ6R2ESifw
         jPP1wO8k5BzdcCoV7/1P7SFJ16or5MEdKij2scpLiD9hTlolIwpqw40sWbPe+XdJK/nR
         RIL0A1in3chHlNx2rlE/tfM+VRuI20PaFtOmmPBUeElQ2MFnHp9JY0PrZnQ29yXdL+dh
         teuA==
X-Gm-Message-State: AAQBX9fDGESQbn5H+z1+fya2bv+HgWHLMuNJuuioag8zkToDX4KmlssA
        /YtQ3etU7bB8BUa0bw5vQmdeuA==
X-Google-Smtp-Source: AKy350b3NNR46AzUUhLxuq4xz5tHpBeQaaVzMjYEw3SBCZ7bSYJ9UQeC7a2TmNiaH4Ew781UGyqx8w==
X-Received: by 2002:a7b:c4c7:0:b0:3ef:6ae7:8994 with SMTP id g7-20020a7bc4c7000000b003ef6ae78994mr21868141wmk.22.1680529765031;
        Mon, 03 Apr 2023 06:49:25 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id r16-20020a05600c35d000b003ee9f396dcesm19503795wmq.30.2023.04.03.06.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:49:23 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 7E9FF1FFB7;
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
Subject: [PATCH v2 08/11] tests/qemu-iotests: explicitly invoke 'check' via 'python'
Date:   Mon,  3 Apr 2023 14:49:17 +0100
Message-Id: <20230403134920.2132362-9-alex.bennee@linaro.org>
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

The 'check' script will use "#!/usr/bin/env python3" by default
to locate python, but this doesn't work in distros which lack a
bare 'python3' binary like NetBSD.

We need to explicitly invoke 'check' by referring to the 'python'
variable in meson, which resolves to the detected python binary
that QEMU intends to use.

This fixes a regression introduced by

  commit 51ab5f8bd795d8980351f8531e54995ff9e6d163
  Author: Daniel P. Berrangé <berrange@redhat.com>
  Date:   Wed Mar 15 17:43:23 2023 +0000

    iotests: register each I/O test separately with meson

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230329124539.822022-1-berrange@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20230330101141.30199-8-alex.bennee@linaro.org>
---
 tests/qemu-iotests/meson.build | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tests/qemu-iotests/meson.build b/tests/qemu-iotests/meson.build
index a162f683ef..9735071a29 100644
--- a/tests/qemu-iotests/meson.build
+++ b/tests/qemu-iotests/meson.build
@@ -47,19 +47,20 @@ foreach format, speed: qemu_iotests_formats
   endif
 
   rc = run_command(
-      [qemu_iotests_check_cmd] + args + ['-n'],
+      [python, qemu_iotests_check_cmd] + args + ['-n'],
       check: true,
   )
 
   foreach item: rc.stdout().strip().split()
-      args = ['-tap', '-' + format, item,
+      args = [qemu_iotests_check_cmd,
+              '-tap', '-' + format, item,
               '--source-dir', meson.current_source_dir(),
               '--build-dir', meson.current_build_dir()]
       # Some individual tests take as long as 45 seconds
       # Bump the timeout to 3 minutes for some headroom
       # on slow machines to minimize spurious failures
       test('io-' + format + '-' + item,
-           qemu_iotests_check_cmd,
+           python,
            args: args,
            depends: qemu_iotests_binaries,
            env: qemu_iotests_env,
-- 
2.39.2

