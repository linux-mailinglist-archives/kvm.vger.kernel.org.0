Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23EF6BBB21
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjCORnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjCORnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:46 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210951702
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:36 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id j42-20020a05600c1c2a00b003ed363619ddso866583wms.1
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZvCAx4F7D2VDKqlV3zkasos0ltqlJHomALeskNF44vQ=;
        b=AjlqOME2l5f+IqgDvgtW5+CkYeuA4/tKB9XBYxUgEu3ueBpIzfu96BCHEPiULHgBBL
         FooB/VtpQBdQkpDO4v/IMPVLvdKcTK9V3rZhZsuv5njFjvea8/ayGf6Ddg8gs8mTHDcv
         JqDUgd14PceCjhoW67Qm/a5tvXJCKKALZZUmxx0bbPVte135ngmbji6xTxt4R63yB7Ke
         X4LJ95o9cSH7pSfLjtP/bCLS+EbUhyoKKtO+2KOxARYp/cqT5VwwuTe451t3ohJopxwO
         THwgKaTxK8c/tq7dYBBCtPaGFqsHkWZ1PGaDTzHuokKCgaXI+K0G9Lk9/7yjBLi6ywlm
         E6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZvCAx4F7D2VDKqlV3zkasos0ltqlJHomALeskNF44vQ=;
        b=kHQ1+XPk4elSSCLUVqmFDpzlWnVq9BfthP/9fwtqBzm4FZhJmbxst/Io/zkVhrtEYs
         Z2NKIZQ76/3geR1IV+uTVD1TAlEJ+YEpDpCXlGTzLj9YKyeUa9uYDXxQK8Cj83TVOHd6
         TmNCUQqIF01PiiPpmAokbbE14oMVhrvcukwZC82/0ktxTQxuRrTqNELAnyjDHqH1qgqQ
         /+j1SnQ2KdgN0j7qRvekk7ESyaMiFSGRkZW7m9LI1seppEAYFOqm8rqgwD+2bUVxM3gQ
         l8IAKy5upD3tupDBCqwWQOSawuQb6tUY0RbyPcaa4JbUYbPLxYCXVTi7ZnNSGPOFnAcX
         f7KA==
X-Gm-Message-State: AO0yUKXlj3td11ltmDmY1cdlbYrJuXzr7NqzXx5c9WiKSukXWsv1l+7B
        /EAB9tdKpZityr1ZjYvnoJLgPQ==
X-Google-Smtp-Source: AK7set/QvBmnCQWLFbkQDn62n9s6z7/WvYo7gaJGoYmTE6pZtOtDDRbpgUQN1O5DPEBtWwAF9pu10g==
X-Received: by 2002:a05:600c:4f8f:b0:3df:db20:b0ae with SMTP id n15-20020a05600c4f8f00b003dfdb20b0aemr13905752wmq.17.1678902215370;
        Wed, 15 Mar 2023 10:43:35 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id v8-20020a5d43c8000000b002cefcac0c62sm5239986wrr.9.2023.03.15.10.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:33 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id C89341FFBD;
        Wed, 15 Mar 2023 17:43:31 +0000 (GMT)
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
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 05/32] gitlab: update centos-8-stream job
Date:   Wed, 15 Mar 2023 17:43:04 +0000
Message-Id: <20230315174331.2959-6-alex.bennee@linaro.org>
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

A couple of clean-ups here:

  - inherit from the custom runners job for artefacts
  - call check-avocado directly
  - add some comments to the top about setup

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 .../custom-runners/centos-stream-8-x86_64.yml  | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/.gitlab-ci.d/custom-runners/centos-stream-8-x86_64.yml b/.gitlab-ci.d/custom-runners/centos-stream-8-x86_64.yml
index 068b0c4335..367424db78 100644
--- a/.gitlab-ci.d/custom-runners/centos-stream-8-x86_64.yml
+++ b/.gitlab-ci.d/custom-runners/centos-stream-8-x86_64.yml
@@ -1,4 +1,9 @@
+# All centos-stream-8 jobs should run successfully in an environment
+# setup by the scripts/ci/setup/stream/8/build-environment.yml task
+# "Installation of extra packages to build QEMU"
+
 centos-stream-8-x86_64:
+ extends: .custom_runner_template
  allow_failure: true
  needs: []
  stage: build
@@ -8,15 +13,6 @@ centos-stream-8-x86_64:
  rules:
  - if: '$CI_PROJECT_NAMESPACE == "qemu-project" && $CI_COMMIT_BRANCH =~ /^staging/'
  - if: "$CENTOS_STREAM_8_x86_64_RUNNER_AVAILABLE"
- artifacts:
-   name: "$CI_JOB_NAME-$CI_COMMIT_REF_SLUG"
-   when: on_failure
-   expire_in: 7 days
-   paths:
-     - build/tests/results/latest/results.xml
-     - build/tests/results/latest/test-results
-   reports:
-     junit: build/tests/results/latest/results.xml
  before_script:
  - JOBS=$(expr $(nproc) + 1)
  script:
@@ -25,6 +21,4 @@ centos-stream-8-x86_64:
  - ../scripts/ci/org.centos/stream/8/x86_64/configure
    || { cat config.log meson-logs/meson-log.txt; exit 1; }
  - make -j"$JOBS"
- - make NINJA=":" check
-   || { cat meson-logs/testlog.txt; exit 1; } ;
- - ../scripts/ci/org.centos/stream/8/x86_64/test-avocado
+ - make NINJA=":" check check-avocado
-- 
2.39.2

