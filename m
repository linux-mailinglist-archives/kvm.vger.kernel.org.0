Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401827A26D3
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 21:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbjIOTB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 15:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236983AbjIOTA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 15:00:58 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AF4AC
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:00:40 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2bcb89b4767so38397481fa.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694804439; x=1695409239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YgOXTjMw7CegRZgzm9gZgaFqpfOBfIJY+75/jhEK298=;
        b=LKiLfr1gA2uMk24cNtxKfESvIJQ6xdrh5hc/p4ErYbucvmluCBLWXxH2M/+VkuZr52
         nksjKV6JgkYJrPmj6B8oUxGXDyyhBaMBmQQL2n2H7cs7aVL8FxTHGDFj45r3riEWF/tz
         /j/XggP34YRIV2bQFxRGRcceAAC+wR8irVcemyIykDXTT79KW3SkzZQczZ8Oq07hdmZ8
         DxL1dW0ROq6Jhre9F1BhrFxHgrIr2hLFoX6FdAugJpEHVediXTEN1pAFBl0N7O8QOwHf
         BlKTKKlZnw28GGk456k6xLdxAqAvrIDqrrPvl3fwHFiM8CmUdqXXStSh9WYXJ5Yeoh4v
         62Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694804439; x=1695409239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YgOXTjMw7CegRZgzm9gZgaFqpfOBfIJY+75/jhEK298=;
        b=lM1mwXRt/tD9HUe0kQv++7MN0XhaaamavOlESo1yJ/KGgueR9dk+lBBMGgXt7ebu5i
         gpR28dVJzDSATRU4e6VDsVLSAVwsFKqZjUf/WQ6YhqWo2BmdCZbbPbST1rv/P8gYCQZ1
         oSzKOYRmTF6uHPasWmniNAjQJ+wkADAxxz30brflTt3Yj6fxMLhi0oHJQxA6GrQVbGDr
         sZ1m7AQryHeymLrnM1Y8Z5qaZQl3SyLsHOwCsUZd6CQP/mMhm/kGa+VXiMlMMvd6fgRE
         VjDPE9qHz2JBOobzS6YpUFfe3O6hQ6ezETnMvyZJCjIsiVtwYdHouskHMbWOf/H1NZ+1
         C23A==
X-Gm-Message-State: AOJu0Yy6tQQHtNe6oDOdPM4Emjo7rFVO+ZV44F0TidTqPput5S2KQRkR
        zoaNMRmN/d5G+OJgT3i+rLHmKg==
X-Google-Smtp-Source: AGHT+IFb62BREUPfjWbOVNIJ5iUEG9onYwiuiWAr/WJWgO5E/Rw3dRu3NysvQrmCzHvFT+lowhetpw==
X-Received: by 2002:a2e:b001:0:b0:2bc:b46b:686b with SMTP id y1-20020a2eb001000000b002bcb46b686bmr2330235ljk.34.1694804438711;
        Fri, 15 Sep 2023 12:00:38 -0700 (PDT)
Received: from m1x-phil.lan (6lp61-h01-176-171-209-234.dsl.sta.abo.bbox.fr. [176.171.209.234])
        by smtp.gmail.com with ESMTPSA id l21-20020a1709061c5500b009ad89697c86sm2771684ejg.144.2023.09.15.12.00.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 15 Sep 2023 12:00:38 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Eduardo Habkost <eduardo@habkost.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        kvm@vger.kernel.org, Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH 4/5] accel/tcg: Have tcg_exec_realizefn() return a boolean
Date:   Fri, 15 Sep 2023 21:00:07 +0200
Message-ID: <20230915190009.68404-5-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230915190009.68404-1-philmd@linaro.org>
References: <20230915190009.68404-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following the example documented since commit e3fe3988d7 ("error:
Document Error API usage rules"), have tcg_exec_realizefn() return
a boolean indicating whether an error is set or not.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/exec/cpu-all.h | 2 +-
 accel/tcg/cpu-exec.c   | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index c2c62160c6..1e5c530ee1 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -422,7 +422,7 @@ void dump_exec_info(GString *buf);
 
 /* accel/tcg/cpu-exec.c */
 int cpu_exec(CPUState *cpu);
-void tcg_exec_realizefn(CPUState *cpu, Error **errp);
+bool tcg_exec_realizefn(CPUState *cpu, Error **errp);
 void tcg_exec_unrealizefn(CPUState *cpu);
 
 /**
diff --git a/accel/tcg/cpu-exec.c b/accel/tcg/cpu-exec.c
index e2c494e75e..fa97e9f191 100644
--- a/accel/tcg/cpu-exec.c
+++ b/accel/tcg/cpu-exec.c
@@ -1088,7 +1088,7 @@ int cpu_exec(CPUState *cpu)
     return ret;
 }
 
-void tcg_exec_realizefn(CPUState *cpu, Error **errp)
+bool tcg_exec_realizefn(CPUState *cpu, Error **errp)
 {
     static bool tcg_target_initialized;
     CPUClass *cc = CPU_GET_CLASS(cpu);
@@ -1104,6 +1104,8 @@ void tcg_exec_realizefn(CPUState *cpu, Error **errp)
     tcg_iommu_init_notifier_list(cpu);
 #endif /* !CONFIG_USER_ONLY */
     /* qemu_plugin_vcpu_init_hook delayed until cpu_index assigned. */
+
+    return true;
 }
 
 /* undo the initializations in reverse order */
-- 
2.41.0

