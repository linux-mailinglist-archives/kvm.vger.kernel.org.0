Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A817B6901
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 14:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240034AbjJCMbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 08:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjJCMbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 08:31:00 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9101483
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 05:30:56 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-40566f8a093so8171035e9.3
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 05:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696336255; x=1696941055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gkc/bRL42O1meaWPMr7Z06ZuzQxfC9K3bpAdX8HhInA=;
        b=LNPZgVxfb7h0PfF0beabltDF/mGT8+8ZbEWHsWrZBcZ+kBkVDOFa+CLPO0DsfsmA2s
         PmO595WYeD/5hdBwCU2h8faa9psqyBXrFKcKiYtAxCOawzfdJ6PeJwqMhADDLJ3EcEsr
         mtIBa6XD9j4LWB7yDBRMbsiickfhd9o3dtbDF4WlW3pW7mXArU5gxdyxBFQmJQKMpEm5
         6xO7QRDsiEy0fuvOmZX7k1O7Offnmpqsfmso7nXCyHawkynHagzFOlF6Xt6rVTBaUvvM
         S2oq+Q4YZjXXV/Bh80KQPSC4HhwBjiAo40eRnwUhlcofK2W3xx8CZqKoqb6IxJD4A5Cz
         Q01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696336255; x=1696941055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gkc/bRL42O1meaWPMr7Z06ZuzQxfC9K3bpAdX8HhInA=;
        b=AtPXgM26VqfxP3ROCzLbOR5hi/YZMWU2qrUSw1GGOqI+VjI+pDzfgqjZ/PY+Alzy9c
         bohowBHhIYZuwxsH6B+3XY+9NSY3mgXqydH42OplU2RxCib8ijamlLDroqCZmCrRLNG9
         9s8/aUhOpzm046YswiOKsA9pbDKFbWo7NKbFovl2VWqEdHhcKOY48IkWa35oOoLIj1yM
         IeA0q09pH9GolkjDNesXiNCI+uAmA82V66ag7JtaGLc4aXMHFedI+5/zScDRttBMnys3
         o40VmlbXtCUXZu0IGSl3XkSwbEVucnUpzPgmK+UqurP7PxVFaGK16SUY3d//t0S1vKvN
         1png==
X-Gm-Message-State: AOJu0Yz0lO2/QhlUPHluGcgRV8sOX5Oq43n+AQdZPcHL3W2Nu5flalHt
        Ygv/fx6Nzykg/Z12F8+0oPEvFA==
X-Google-Smtp-Source: AGHT+IFfS3e/r6v/mLNthJlFSJF+tDApG8FXlkYKsMscRfx5bpnxKY35taTyrdcfQ0W4kLclXxkyLQ==
X-Received: by 2002:a05:600c:22c8:b0:405:3955:5872 with SMTP id 8-20020a05600c22c800b0040539555872mr11340217wmg.18.1696336254935;
        Tue, 03 Oct 2023 05:30:54 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id a12-20020a5d570c000000b00327bf4f2f16sm1480932wrv.30.2023.10.03.05.30.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 05:30:54 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <eduardo@habkost.net>,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Fabiano Rosas <farosas@suse.de>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v2 4/7] accel: Introduce accel_cpu_common_unrealize() stub
Date:   Tue,  3 Oct 2023 14:30:22 +0200
Message-ID: <20231003123026.99229-5-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231003123026.99229-1-philmd@linaro.org>
References: <20231003123026.99229-1-philmd@linaro.org>
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

Prepare the stub for parity with accel_cpu_common_realize().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/qemu/accel.h | 6 ++++++
 accel/accel-common.c | 4 ++++
 cpu.c                | 4 +++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index 898159c001..446153b145 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -96,6 +96,12 @@ void accel_cpu_instance_init(CPUState *cpu);
  */
 bool accel_cpu_common_realize(CPUState *cpu, Error **errp);
 
+/**
+ * accel_cpu_common_unrealize:
+ * @cpu: The CPU that needs to call accel-specific cpu unrealization.
+ */
+void accel_cpu_common_unrealize(CPUState *cpu);
+
 /**
  * accel_supported_gdbstub_sstep_flags:
  *
diff --git a/accel/accel-common.c b/accel/accel-common.c
index 53cf08a89a..e9548eac29 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -129,6 +129,10 @@ bool accel_cpu_common_realize(CPUState *cpu, Error **errp)
     return true;
 }
 
+void accel_cpu_common_unrealize(CPUState *cpu)
+{
+}
+
 int accel_supported_gdbstub_sstep_flags(void)
 {
     AccelState *accel = current_accel();
diff --git a/cpu.c b/cpu.c
index 1e2649a706..2a1eff948b 100644
--- a/cpu.c
+++ b/cpu.c
@@ -187,8 +187,10 @@ void cpu_exec_unrealizefn(CPUState *cpu)
     cpu_list_remove(cpu);
     /*
      * Now that the vCPU has been removed from the RCU list, we can call
-     * tcg_exec_unrealizefn, which may free fields using call_rcu.
+     * tcg_exec_unrealizefn and
+     * accel_cpu_common_unrealize, which may free fields using call_rcu.
      */
+    accel_cpu_common_unrealize(cpu);
     if (tcg_enabled()) {
         tcg_exec_unrealizefn(cpu);
     }
-- 
2.41.0

