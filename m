Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE766BBB5F
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbjCORuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbjCORtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:49:40 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7AC2B615
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:26 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id x22so7660096wmj.3
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jq6hxeJvtxl+2hc076HR0v7mq5ZkbtUv1Uhl1DVVlCE=;
        b=JoW+jfgH2ZSGaEGWNB1c86mJrHTmFwhbNALMh5n0IgddNo1vkrMorDjqVZvR5zDYyB
         E9D/TRIOKM7zII0KRnTs69PFwi21fI+mmi4y0l+s+TcHEz4bTD7IVx4mhIymk5s+coD7
         wGyBe3LliNocveapx/qlv2jek+6eEVPeVHepiYeI+7KYQqv7i+fGYtHYFkNRb9JmXRUJ
         dGOOwPnuVj6PCrbQNUqXEEinXq4f9Fivg6UUQi0y3DXAk2sUoHrjGUG9rGPPts+yij6+
         S91MVP53BG1C93gVX/WpyA0fmjtHXIZ0jTCb07KyHGfypwOxB3dr418TLIsLPWXw6hfi
         lM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jq6hxeJvtxl+2hc076HR0v7mq5ZkbtUv1Uhl1DVVlCE=;
        b=o+qzDRwJo2ibjqZ3YS7y2Ec+WqOSS+TT6w6q+8V0m7LCwVYOmh5qI9tJgebURhrIq7
         60YwFxQOQ3j0YZXsgZbh5B1XyfDLVTIJl/GTaH7fHC8ygG4uxpTGC8MRS9BrstWIfcGT
         lokmay3A3UyLTVLFQmPyrojGNxFUO9rm+gmBJGI3MbQhUtktQ8TVGgO5krmYSvLm5OdY
         /OLzvjfbcLcsaUWP0GUmv9YrLxqtpiDij+hGIHbncfyuVXNZIc9qx/Hj2KFFhRAQTyH+
         cMCwuoerObLxCKKNoBTERGXlUw0FmDnuBSbDCXnYj1m6xQN/PXnZNJ9rY2quoJsbSL5p
         BABw==
X-Gm-Message-State: AO0yUKXfHDcJsNuLeBjkArNQ7Bo0JCU8htdnGY6E/jzfGzwwPpgShGAo
        qpal/vHt9oIrDmkz4ejql5GTmg==
X-Google-Smtp-Source: AK7set8+7+vGSNMfAVAD3aOFQHK1DspDT2fMCXhb1Ossl4jav7nNbjq2ozGoRtLmcVQCfNOfFUZQtQ==
X-Received: by 2002:a05:600c:34c1:b0:3eb:383c:1876 with SMTP id d1-20020a05600c34c100b003eb383c1876mr18700431wmq.6.1678902564742;
        Wed, 15 Mar 2023 10:49:24 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id t8-20020a1c7708000000b003ed2276cd0dsm2502818wmi.38.2023.03.15.10.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:49:22 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 4650A1FFCE;
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
Subject: [PATCH v2 23/32] iotests: always use a unique sub-directory per test
Date:   Wed, 15 Mar 2023 17:43:22 +0000
Message-Id: <20230315174331.2959-24-alex.bennee@linaro.org>
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

The current test runner is only safe against parallel execution within
a single instance of the 'check' process, and only if -j is given a
value greater than 2. This prevents running multiple copies of the
'check' process for different test scenarios.

This change switches the output / socket directories to always include
the test name, image format and image protocol. This should allow full
parallelism of all distinct test scenarios. eg running both qcow2 and
raw tests at the same time, or both file and nbd tests at the same
time.

It would be possible to allow for parallelism of the same test scenario
by including the pid, but that would potentially let many directories
accumulate over time on failures, so is not done.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Hanna Czenczek <hreitz@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20230303160727.3977246-7-berrange@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qemu-iotests/testrunner.py | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tests/qemu-iotests/testrunner.py b/tests/qemu-iotests/testrunner.py
index 81519ed6e2..7b322272e9 100644
--- a/tests/qemu-iotests/testrunner.py
+++ b/tests/qemu-iotests/testrunner.py
@@ -228,13 +228,11 @@ def find_reference(self, test: str) -> str:
 
         return f'{test}.out'
 
-    def do_run_test(self, test: str, mp: bool) -> TestResult:
+    def do_run_test(self, test: str) -> TestResult:
         """
         Run one test
 
         :param test: test file path
-        :param mp: if true, we are in a multiprocessing environment, use
-                   personal subdirectories for test run
 
         Note: this method may be called from subprocess, so it does not
         change ``self`` object in any way!
@@ -257,12 +255,14 @@ def do_run_test(self, test: str, mp: bool) -> TestResult:
 
         args = [str(f_test.resolve())]
         env = self.env.prepare_subprocess(args)
-        if mp:
-            # Split test directories, so that tests running in parallel don't
-            # break each other.
-            for d in ['TEST_DIR', 'SOCK_DIR']:
-                env[d] = os.path.join(env[d], f_test.name)
-                Path(env[d]).mkdir(parents=True, exist_ok=True)
+
+        # Split test directories, so that tests running in parallel don't
+        # break each other.
+        for d in ['TEST_DIR', 'SOCK_DIR']:
+            env[d] = os.path.join(
+                env[d],
+                f"{self.env.imgfmt}-{self.env.imgproto}-{f_test.name}")
+            Path(env[d]).mkdir(parents=True, exist_ok=True)
 
         test_dir = env['TEST_DIR']
         f_bad = Path(test_dir, f_test.name + '.out.bad')
@@ -347,7 +347,7 @@ def run_test(self, test: str,
             testname = os.path.basename(test)
             print(f'# running {self.env.imgfmt} {testname}')
 
-        res = self.do_run_test(test, mp)
+        res = self.do_run_test(test)
 
         end = datetime.datetime.now().strftime('%H:%M:%S')
         self.test_print_one_line(test=test,
-- 
2.39.2

