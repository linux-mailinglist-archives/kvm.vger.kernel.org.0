Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FBD6BBB20
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjCORnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjCORnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:45 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386338C53C
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:36 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso1809029wms.5
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6cCbPXzWfjZFi2jKGovhuePGEghRzJegWJl5AEsiLWo=;
        b=Zv5AlrWtlqOeC6rrBYqxcm+5QqEIJoB6SGEQMlNFhTcpC9+8OZGrVDmU/ShznUanyD
         EpzQr9EWPiA03iLAIwsqBzeG6ln+jBen2MxoDiqKM0pDQmWweXykRmHUDt942Rh0kan0
         QYfk415pYgADmHzhj2vuox+geh2tdhKo76E8nMLKLqc47xc7LyeFUQAITjo88RBOvyc3
         NrsITsIgwylhK4wQhvTHN0NR8gaC+8s183vtkvs+Jj3X3r0OCfELi801k6ABv2Po55ry
         O/8fED6q+FMYnfrd6qkzG9ITHf8oRXDNHDmAyFkA+ROLS57lg6EYXJLB3dzj2Lpngjk+
         ywJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6cCbPXzWfjZFi2jKGovhuePGEghRzJegWJl5AEsiLWo=;
        b=HUVLYSoE1A9mdRkKbtdHnbqZHG4vMcBwo3u0rB31JI278KrlKdo0yGVtFZ9ZvvF9Ke
         YFj4kebvCMQBdCNiPSYadB86BJuxzN1CrrptnMG8Rkb8hNFDiJ7tBU9apq5o4Fgz3lNg
         RaxyPi8LFaDKjoUgV+Bps5fa5ITiMTce5BBWevhVAq3NVjJl/vCb3kS/di3w9J45uOhy
         1+5FGY/lB2KoqkUdrqeHqHD45PtF7K+ASypRuT1E49kqGoP5QtZtfyojp/e/ozg0eZly
         DznQXiHNwoljMZ7nVj7KraGPSS6iPvLMjehYUNNUfBBmYx/UA46vl5w1ApjasXZNxGTt
         mDRA==
X-Gm-Message-State: AO0yUKXJYwS6TZ1J+HlZ2R5xepocDY6UgVJAdE+n9A3sl0EUfr+WgZ6C
        r54fU7l/H/31HXXu3dSUy1u8rg==
X-Google-Smtp-Source: AK7set/mv3MLq2BnnVutlWWFhaqCWMs8/pzCfLOoSdiwc62RpImdBKFEQU9oRBAtL4oSVuku54YOtA==
X-Received: by 2002:a05:600c:1e20:b0:3eb:376e:2bb7 with SMTP id ay32-20020a05600c1e2000b003eb376e2bb7mr18252033wmb.3.1678902214544;
        Wed, 15 Mar 2023 10:43:34 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id y16-20020a05600c365000b003ed2384566fsm2511142wmq.21.2023.03.15.10.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:33 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id A873D1FFBC;
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
Subject: [PATCH v2 04/32] scripts/ci: update gitlab-runner playbook to handle CentOS
Date:   Wed, 15 Mar 2023 17:43:03 +0000
Message-Id: <20230315174331.2959-5-alex.bennee@linaro.org>
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

This was broken when we moved to using the pre-built packages as we
didn't take care to ensure we used RPMs where required.

NB: I could never get this to complete on my test setup but I suspect
this was down to network connectivity and timeouts while downloading.

Fixes: 69c4befba1 (scripts/ci: update gitlab-runner playbook to use latest runner)
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 scripts/ci/setup/gitlab-runner.yml | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/scripts/ci/setup/gitlab-runner.yml b/scripts/ci/setup/gitlab-runner.yml
index 95d4199c03..1a1b270ff2 100644
--- a/scripts/ci/setup/gitlab-runner.yml
+++ b/scripts/ci/setup/gitlab-runner.yml
@@ -48,13 +48,29 @@
     - debug:
         msg: gitlab-runner arch is {{ gitlab_runner_arch }}
 
-    - name: Download the matching gitlab-runner
+    - name: Download the matching gitlab-runner (DEB)
       get_url:
         dest: "/root/"
         url: "https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_{{ gitlab_runner_arch }}.deb"
+      when:
+        - ansible_facts['distribution'] == 'Ubuntu'
+
+    - name: Download the matching gitlab-runner (RPM)
+      get_url:
+        dest: "/root/"
+        url: "https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_{{ gitlab_runner_arch }}.rpm"
+      when:
+        - ansible_facts['distribution'] == 'CentOS'
 
-    - name: Install gitlab-runner via package manager
+    - name: Install gitlab-runner via package manager (DEB)
       apt: deb="/root/gitlab-runner_{{ gitlab_runner_arch }}.deb"
+      when:
+        - ansible_facts['distribution'] == 'Ubuntu'
+
+    - name: Install gitlab-runner via package manager (RPM)
+      yum: name="/root/gitlab-runner_{{ gitlab_runner_arch }}.rpm"
+      when:
+        - ansible_facts['distribution'] == 'CentOS'
 
     - name: Register the gitlab-runner
       command: "/usr/bin/gitlab-runner register --non-interactive --url {{ gitlab_runner_server_url }} --registration-token {{ gitlab_runner_registration_token }} --executor shell --tag-list {{ ansible_facts[\"architecture\"] }},{{ ansible_facts[\"distribution\"]|lower }}_{{ ansible_facts[\"distribution_version\"] }} --description '{{ ansible_facts[\"distribution\"] }} {{ ansible_facts[\"distribution_version\"] }} {{ ansible_facts[\"architecture\"] }} ({{ ansible_facts[\"os_family\"] }})'"
-- 
2.39.2

