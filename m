Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FDE6BBB2D
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjCORoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbjCORn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:56 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C818B319
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:51 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso1592328wmb.0
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UdK4L7buRJRBhWENt6vEwjRP9U71/totQZg0N/PH0dY=;
        b=VJavgRpjNl+lnh3kFqwKpe7fnRIXzKD9392iUbwY4hnRGvu8+4vDH1se9719XWXx5g
         RyO0cb5h/IPh+eXxszwi/SeBM5n6RHMO5Mdj6aNTSdiSw3nWxrwyzOd6GfqgzmtJj0UW
         VgRZJor5hgLvYTRJZHs4OCIlbw/lQm0cYLGD+YLCSdB2fp5dXEgyfW3DBY/ZynBHHrAn
         xNWAQGx/H2McaFDUngA2kt7MQnfUSgRVj2Ah2rXcio3wKC+bMVLshBx65KDietAUUa9n
         4f396oOToqwXJsVm7cFzlKBYF50uGNHwyu796MOzlJRm9Yi/vrOgx24JB22LUBKG6Wxk
         cCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UdK4L7buRJRBhWENt6vEwjRP9U71/totQZg0N/PH0dY=;
        b=yaLsc2poJDXMpmQ/1vUYWqQ8F6W2AUhY5NIQLxr8Xvl0vKnP7XVd1SJmRtGIE6GN4Q
         c9Q1G613prKb7nZSQPMS4fORIuyP6VcL2ncSAtw0shR3Gs7M9OCmMERp55Mq6LPyk695
         bzoF5xJ4JCQKnT49YDZTVg8ByR++GFjLTVkwGuzl2gDrxVQiesKJxLmexpNooxiRPtej
         HRRLtw0WzAptHVDdwZsp2DbYn8WH2mkWMVvTqxLvKiN+SNkEed9e2xP9pFb+sHEqGXks
         aymlytjn+gpTn0sqdp7iOJaNkvVrysJTMKmawmWwL64PYBPZ3iWb/8DxYcrxG45/DeQz
         Cixg==
X-Gm-Message-State: AO0yUKXl27J9r1ceJaZSfdnJ9edu75jN6BINLDnEjuFTWTBOjNyqBt+q
        zPNiHMLZLe/NbAql7TvU6vNX4A==
X-Google-Smtp-Source: AK7set9O1L/vrhU8vZCb6AjGeasCwTmf0oa90zZb5SZ4ix92TJi2a9m2I5adlre6Ev/Ekb04avtaOw==
X-Received: by 2002:a05:600c:470e:b0:3eb:29fe:734a with SMTP id v14-20020a05600c470e00b003eb29fe734amr18821157wmo.39.1678902229510;
        Wed, 15 Mar 2023 10:43:49 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id j15-20020adff00f000000b002cea9d931e6sm5333889wro.78.2023.03.15.10.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:47 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 7E9E11FFD0;
        Wed, 15 Mar 2023 17:43:44 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Akihiko Odaki <akihiko.odaki@gmail.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        qemu-riscv@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Wu <wuhaotsh@google.com>, Cleber Rosa <crosa@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, qemu-ppc@nongnu.org,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stafford Horne <shorne@gmail.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Thomas Huth <huth@tuxfamily.org>,
        Vijai Kumar K <vijai@behindbytes.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Song Gao <gaosong@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Niek Linnenbank <nieklinnenbank@gmail.com>,
        Greg Kurz <groug@kaod.org>, Laurent Vivier <laurent@vivier.eu>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-block@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>, qemu-s390x@nongnu.org,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Bandan Das <bsd@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Paul Durrant <paul@xen.org>, Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH v2 25/32] iotests: remove the check-block.sh script
Date:   Wed, 15 Mar 2023 17:43:24 +0000
Message-Id: <20230315174331.2959-26-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315174331.2959-1-alex.bennee@linaro.org>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Daniel P. Berrangé <berrange@redhat.com>

Now that meson directly invokes the individual I/O tests, the
check-block.sh wrapper script is no longer required.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Hanna Czenczek <hreitz@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20230303160727.3977246-9-berrange@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/check-block.sh | 43 -------------------------------------------
 1 file changed, 43 deletions(-)
 delete mode 100755 tests/check-block.sh

diff --git a/tests/check-block.sh b/tests/check-block.sh
deleted file mode 100755
index 5de2c1ba0b..0000000000
--- a/tests/check-block.sh
+++ /dev/null
@@ -1,43 +0,0 @@
-#!/bin/sh
-
-if [ "$#" -eq 0 ]; then
-    echo "Usage: $0 fmt..." >&2
-    exit 99
-fi
-
-# Honor the SPEED environment variable, just like we do it for "meson test"
-format_list="$@"
-if [ "$SPEED" = "slow" ] || [ "$SPEED" = "thorough" ]; then
-    group=
-else
-    group="-g auto"
-fi
-
-skip() {
-    echo "1..0 #SKIP $*"
-    exit 0
-}
-
-if [ -z "$(find . -name 'qemu-system-*' -print)" ]; then
-    skip "No qemu-system binary available ==> Not running the qemu-iotests."
-fi
-
-cd tests/qemu-iotests
-
-# QEMU_CHECK_BLOCK_AUTO is used to disable some unstable sub-tests
-export QEMU_CHECK_BLOCK_AUTO=1
-export PYTHONUTF8=1
-# If make was called with -jN we want to call ./check with -j N. Extract the
-# flag from MAKEFLAGS, so that if it absent (or MAKEFLAGS is not defined), JOBS
-# would be an empty line otherwise JOBS is prepared string of flag with value:
-# "-j N"
-# Note, that the following works even if make was called with "-j N" or even
-# "--jobs N", as all these variants becomes simply "-jN" in MAKEFLAGS variable.
-JOBS=$(echo "$MAKEFLAGS" | sed -n 's/\(^\|.* \)-j\([0-9]\+\)\( .*\|$\)/-j \2/p')
-
-ret=0
-for fmt in $format_list ; do
-    ${PYTHON} ./check $JOBS -tap -$fmt $group || ret=1
-done
-
-exit $ret
-- 
2.39.2

