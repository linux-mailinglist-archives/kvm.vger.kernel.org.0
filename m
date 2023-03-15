Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566C46BBB28
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjCORoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbjCORny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:54 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F059270C
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:48 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id bh21-20020a05600c3d1500b003ed1ff06fb0so1819378wmb.3
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RIvbfo0IIlc3X5pccePnUec4yCPh7dln0aorBfnrbhQ=;
        b=QRGJf3yo39nlVeahj8Lp9NaZDSwquXrLTwIb/t4B9gkjzWQDgqBKG8QTo09F8dXsZ7
         hB1H/PN0GN8IwDvY8VOdymgBj36108d1Jb74hOi4HT9fZOdKBsOxzyB1UPIT47YLy56x
         /gqBIA2Zwb+Rkoph5ksfCL+dbcU1ZrYmGN1CH6PFmWiNygiPwJvX4hSSyUAQQuTiX7Aj
         9fXSVtZIu1D5tfuG2QmL5VD4CWddpUjUVCS3wYfGZKpvDKCjXEcRygCr1o8h2HdC6Ipm
         hTaxNl8n03dxk/hDwgXtbLuE6CGVSuH0x4fKDmu6hxqkZwyGclbL5zj88b6Cmn12gV51
         skug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RIvbfo0IIlc3X5pccePnUec4yCPh7dln0aorBfnrbhQ=;
        b=q4qS/AmX8z3Sub46leoAB/3oUf4e7MqlC3ajEMFvJJn0GuBvA2wThRHZ/HpX7zGHLo
         UdL/BXB14VHV2QGtTbKIGQBaFkprS8sCZ9HybR+yTWwjCnoLaqvpkAj6FULCVdXGNmxD
         cppOur4DwQjGbtAToFYBOTys4n5Znka1pGfGyGsFEv0IkF0ynGrTPX/9C1Yp0zFlZChF
         z1C6uO5GLhlpoQLN2Zgb6Imb4y3VxJQzetfshL3dBE+MGi+LcNu6Kf7thhhCmHzEyvgo
         ds0iEQB9ELqckiGnqCvaoRdN5aWI2gS8NIXJXGsSH+cxTGKI9JDw+1bIK1WFRyDbQ4Zr
         65Jw==
X-Gm-Message-State: AO0yUKXKILWsgTUZ2so0UGboA3vxKMKsCBPTzL0lHzJi+SBUi9SiUBA2
        AYG5EdMlM1XxCbTSKYT4zByCUQ==
X-Google-Smtp-Source: AK7set9f0XMr7oGynhnye8x2SLeIft+bzBIK2xRCx6/Zyw8zRbB5YYvhQyHi2KbmFiBzIIBjDeP7MA==
X-Received: by 2002:a05:600c:cc6:b0:3ed:2949:9847 with SMTP id fk6-20020a05600c0cc600b003ed29499847mr8736758wmb.10.1678902226964;
        Wed, 15 Mar 2023 10:43:46 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003e21f959453sm2460976wmc.32.2023.03.15.10.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:45 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id C9E531FFCB;
        Wed, 15 Mar 2023 17:43:43 +0000 (GMT)
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
Subject: [PATCH v2 19/32] iotests: allow test discovery before building
Date:   Wed, 15 Mar 2023 17:43:18 +0000
Message-Id: <20230315174331.2959-20-alex.bennee@linaro.org>
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

The 'check' script can be invoked in "dry run" mode, in which case it
merely does test discovery and prints out all their names. Despite only
doing test discovery it still validates that the various QEMU binaries
can be found. This makes it impossible todo test discovery prior to
building QEMU. This is a desirable feature to support, because it will
let meson discover tests.

Fortunately the code in the TestEnv constructor is ordered in a way
that makes this fairly trivial to achieve. We can just short circuit
the constructor after the basic directory paths have been set.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Acked-by: Hanna Czenczek <hreitz@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20230303160727.3977246-3-berrange@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qemu-iotests/check      | 3 ++-
 tests/qemu-iotests/testenv.py | 7 ++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tests/qemu-iotests/check b/tests/qemu-iotests/check
index da7e8a87fe..bb294ef556 100755
--- a/tests/qemu-iotests/check
+++ b/tests/qemu-iotests/check
@@ -145,7 +145,8 @@ if __name__ == '__main__':
                   aiomode=args.aiomode, cachemode=args.cachemode,
                   imgopts=args.imgopts, misalign=args.misalign,
                   debug=args.debug, valgrind=args.valgrind,
-                  gdb=args.gdb, qprint=args.print)
+                  gdb=args.gdb, qprint=args.print,
+                  dry_run=args.dry_run)
 
     if len(sys.argv) > 1 and sys.argv[-len(args.tests)-1] == '--':
         if not args.tests:
diff --git a/tests/qemu-iotests/testenv.py b/tests/qemu-iotests/testenv.py
index aa9d735414..9a37ad9152 100644
--- a/tests/qemu-iotests/testenv.py
+++ b/tests/qemu-iotests/testenv.py
@@ -178,7 +178,8 @@ def __init__(self, source_dir: str, build_dir: str,
                  debug: bool = False,
                  valgrind: bool = False,
                  gdb: bool = False,
-                 qprint: bool = False) -> None:
+                 qprint: bool = False,
+                 dry_run: bool = False) -> None:
         self.imgfmt = imgfmt
         self.imgproto = imgproto
         self.aiomode = aiomode
@@ -218,6 +219,10 @@ def __init__(self, source_dir: str, build_dir: str,
         self.build_root = os.path.join(self.build_iotests, '..', '..')
 
         self.init_directories()
+
+        if dry_run:
+            return
+
         self.init_binaries()
 
         self.malloc_perturb_ = os.getenv('MALLOC_PERTURB_',
-- 
2.39.2

