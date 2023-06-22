Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C0373A5B4
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjFVQKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjFVQKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:10:11 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C6C1BD6
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:10:02 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-3128fcd58f3so2076190f8f.1
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687450201; x=1690042201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0HtP5OMiHV1uHyCREuOsPgXLNdWuwc5y+seBeAIuir0=;
        b=fD2yFKYVUSbELRWkgGW0danFEJd49UvIoHVUaoL+iV8IqYQvNfiml31iLxtBJeKK+2
         BhYPg4qUhHRzjckRgaA9Y7ICZhNcCZMhqc202pVq8XOrpxWtk6WoH7hxA67ck5XYCSA2
         a1mUXkxpR3fQsnOmFzfz0iq4qYue5q1tdAT5/kH9rAuDXlR9gqshBZLvQbP2e7xh87Rz
         116ue4dKX7z8nRG43aPZMWOGjKu3Mtzz5LGCpfwr8CqoismIj/q6QyBXeNO1kiC0U6lz
         /+jW94I7TghlhujpjnaWLHWAqKt+jU29K9hKNOv+XTxyLGAUr4jy4FnAEonFW8sot8W/
         zLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687450201; x=1690042201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0HtP5OMiHV1uHyCREuOsPgXLNdWuwc5y+seBeAIuir0=;
        b=d9RHWVA7UUkAC2UzLwck+i8goRaDst48keYIasz3crzCkvs4bI5m5cmOz8CzfHfmvB
         qNTz4JttwiJuxQ9xS6AuoMqXRJ6kjWGKpVIkhPrg1v5cS0P6r0dir0pkCTo9LYd/O7ga
         oQbxmIbUsALp3cyqjfdkbtquQJ02W/iqs+jwIFvGKs385vyBUnoWHscqjHoKszo6cKJ2
         KTxWuL006AblGvhp4RvuUSdp7til1aGWGqNtHcspkRyd27IWElN7POpSEusY58ewd5GN
         ngHwNH28uH7oUfYGwaPs6J4ecebAdeE01iYF/+Bp1OXEQSF99UpFM3gFEfJZd8CQyznW
         8LOQ==
X-Gm-Message-State: AC+VfDxFLACqGQpHXLtZuKpTG62Yq4d06pxaB9UrWJeUY6JBj1n9KNFX
        gBFvG2tu+OP9vpr99wm/jGv2Pw==
X-Google-Smtp-Source: ACHHUZ63Fuzhm8d41+KEQTBgPUOc0gqnijkCpCOihqOKQVjSB4IS+fg+O0ZMGvIAchJ0HLw7tqsoww==
X-Received: by 2002:adf:e611:0:b0:309:fcbe:748a with SMTP id p17-20020adfe611000000b00309fcbe748amr17046247wrm.11.1687450201085;
        Thu, 22 Jun 2023 09:10:01 -0700 (PDT)
Received: from localhost.localdomain (230.red-88-28-3.dynamicip.rima-tde.net. [88.28.3.230])
        by smtp.gmail.com with ESMTPSA id 18-20020a05600c231200b003f9063fc3cbsm15728619wmo.44.2023.06.22.09.09.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Jun 2023 09:10:00 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Reinoud Zandijk <reinoud@netbsd.org>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Alexander Graf <agraf@csgraf.de>,
        Richard Henderson <richard.henderson@linaro.org>,
        xen-devel@lists.xenproject.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v2 09/16] accel: Remove NVMM unreachable error path
Date:   Thu, 22 Jun 2023 18:08:16 +0200
Message-Id: <20230622160823.71851-10-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230622160823.71851-1-philmd@linaro.org>
References: <20230622160823.71851-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

g_malloc0() can not fail. Remove the unreachable error path.

https://developer-old.gnome.org/glib/stable/glib-Memory-Allocation.html#glib-Memory-Allocation.description

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/nvmm/nvmm-all.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index 50b96ced45..0588a328ae 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -943,10 +943,6 @@ nvmm_init_vcpu(CPUState *cpu)
     }
 
     qcpu = g_malloc0(sizeof(*qcpu));
-    if (qcpu == NULL) {
-        error_report("NVMM: Failed to allocate VCPU context.");
-        return -ENOMEM;
-    }
 
     ret = nvmm_vcpu_create(mach, cpu->cpu_index, &qcpu->vcpu);
     if (ret == -1) {
-- 
2.38.1

