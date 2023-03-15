Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564786BBB2E
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbjCORoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjCORn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:56 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F7114208
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:50 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c8-20020a05600c0ac800b003ed2f97a63eso1574459wmr.3
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQqjfUQatIxdKkk1mS9vZHLNSiIHLiR1rCd25SjEL8w=;
        b=XznwCmfFONn50XJBkdukTR3kRWoDjilt1BeLxR2JZE5yxxl82IMwB9MIrWM67kHRpx
         ANp8HqjvO5QQdUmn5moo3SDGYRjEGkn4JWYU/t/NGeosWPuyijvwxKrF/7n0SWXBJjXR
         H2eJrsDyl8SOaFC4AcpB3EKp2PyMRZc2Ybda1OzbLbWuBHk262BNDsz95me2FnsV7IZm
         FMkdknNAVWs3S8ceZmnCnK563TbL3tPi6k0jtkZU9lfnxRGNw+dg/TdWMRe7oBq33MnE
         HRcAWalTYkaMCnIuORFCyQCYFe9SdzUX4HX3CSkqXLKpc4kil2Z+WWIQ4v7xGSlIQe0d
         q41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQqjfUQatIxdKkk1mS9vZHLNSiIHLiR1rCd25SjEL8w=;
        b=ubPyY4LKocQ6dggI1Wk5Vh0H554TZrwA8YlQAK1mvfxOCGmjCvIkniT9nGm8rv2oKv
         YMDrrCIjqhQOOL0+HPwCcRU5xrgPF0mXAQJ+ZF3u9XaMHZM8amHx+pJk3qHDObV/WO5/
         t76UO1i8uW0owXE0dLquU05Vo5yJnRwjnc4OxNl0++kdYix/6wr+d7JbiLdwKynpVdgs
         7UQ48/24Khr6HCwZ/4L4SoEIROnogVusEpziDSOfyLOs+Y+gBm/Wzctf+1XOioFHY+pB
         Q6hQQCYGVIaA2RnSM1o98+Pfhpjrmq9tKK8MtzWlDlybhMd8fxz7/6BaPbFBU+xzS2pz
         JMUA==
X-Gm-Message-State: AO0yUKUzEbLh01HW6LbbaIpFINZ28yFYwi/ledFF80SG74E9isN51ZIQ
        VLjUFTHrXZzaCM1ZBqCPHOc1Hw==
X-Google-Smtp-Source: AK7set9LuUIhKU6kk9tdCegJVIMu5mWEMbP1y+0HMXKeGMpA9W5c40o7/Dwwn27J4H75Z13JnC6hpQ==
X-Received: by 2002:a05:600c:45d2:b0:3ed:2a8f:e6dd with SMTP id s18-20020a05600c45d200b003ed2a8fe6ddmr7442941wmo.6.1678902229285;
        Wed, 15 Mar 2023 10:43:49 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c024400b003eb966d39desm2600527wmj.2.2023.03.15.10.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:47 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 62DC01FFCF;
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
Subject: [PATCH v2 24/32] iotests: register each I/O test separately with meson
Date:   Wed, 15 Mar 2023 17:43:23 +0000
Message-Id: <20230315174331.2959-25-alex.bennee@linaro.org>
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

Currently meson registers a single test that invokes an entire group of
I/O tests, hiding the test granularity from meson. There are various
downsides of doing this

 * You cannot ask 'meson test' to invoke a single I/O test
 * The meson test timeout can't be applied to the individual
   tests
 * Meson only gets a pass/fail for the overall I/O test group
   not individual tests
 * If a CI job gets killed by the GitLab timeout, we don't
   get visibility into how far through the I/O tests
   execution got.

This switches meson to perform test discovery by invoking 'check' in
dry-run mode. It then registers one meson test case for each I/O
test. Parallel execution remains disabled since the I/O tests do not
use self contained execution environments and thus conflict with
each other.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Hanna Czenczek <hreitz@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20230303160727.3977246-8-berrange@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qemu-iotests/meson.build | 35 ++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/tests/qemu-iotests/meson.build b/tests/qemu-iotests/meson.build
index 323a4acb6a..a162f683ef 100644
--- a/tests/qemu-iotests/meson.build
+++ b/tests/qemu-iotests/meson.build
@@ -32,16 +32,39 @@ foreach k, v : emulators
   endif
 endforeach
 
+qemu_iotests_check_cmd = files('check')
+
 foreach format, speed: qemu_iotests_formats
   if speed == 'quick'
     suites = 'block'
   else
     suites = ['block-' + speed, speed]
   endif
-  test('qemu-iotests ' + format, sh, args: [files('../check-block.sh'), format],
-       depends: qemu_iotests_binaries, env: qemu_iotests_env,
-       protocol: 'tap',
-       suite: suites,
-       timeout: 0,
-       is_parallel: false)
+
+  args = ['-tap', '-' + format]
+  if speed == 'quick'
+      args += ['-g', 'auto']
+  endif
+
+  rc = run_command(
+      [qemu_iotests_check_cmd] + args + ['-n'],
+      check: true,
+  )
+
+  foreach item: rc.stdout().strip().split()
+      args = ['-tap', '-' + format, item,
+              '--source-dir', meson.current_source_dir(),
+              '--build-dir', meson.current_build_dir()]
+      # Some individual tests take as long as 45 seconds
+      # Bump the timeout to 3 minutes for some headroom
+      # on slow machines to minimize spurious failures
+      test('io-' + format + '-' + item,
+           qemu_iotests_check_cmd,
+           args: args,
+           depends: qemu_iotests_binaries,
+           env: qemu_iotests_env,
+           protocol: 'tap',
+           timeout: 180,
+           suite: suites)
+  endforeach
 endforeach
-- 
2.39.2

