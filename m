Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B437B694F
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 14:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjJCMq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 08:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240058AbjJCMbO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 08:31:14 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA15ECE
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 05:31:09 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-40666aa674fso8377175e9.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 05:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696336268; x=1696941068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sreXSXDLh+LVLoU4Gk2cAKXN1sJ3KmjKke0mZhMO3w=;
        b=WJxD/L/lO3OUZEdKUZ7r2LTbXjn43HZrk96PibPFvedQMDktHgD+5zHwEUYrRuf+8Z
         Num7RYByAg1Gy5GVKTSEBoao/JK+UJfLNl9hWeaac24tkcb6OLILVN/Jq3TpjBuxzBHM
         lWCX8vSIr/TNms+eXeIAxb7B2xl51MW3qFWsRjgRYrYF7FGLbtRTTlpIUek8EW9JII6D
         mBfYBKbPRTgibID9NWBHap6qxuP8D9wqqsvnOtmqHaKiIO8UycJg7F/+xhJrc/SDJxZi
         mbZODn6oGUYJuBFtyVjQ7JOHRTgFHLjLLhrrthiVCA41H9HW17OPCAFNCJeKruSxvU30
         Mq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696336268; x=1696941068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0sreXSXDLh+LVLoU4Gk2cAKXN1sJ3KmjKke0mZhMO3w=;
        b=V8gZiVNNGFDRm3tD4crLvSDz3C0rNB13acvx7d/DPH6DATKnDyI6IkBiWbARno20sZ
         AEcbbyLItC443Wz4k4d1ym8kT3/Gqmh+wue2iDYgJruPK0x+5z7CT2cGXuUVNzS0M1Gu
         aGCBLthNjUHwwooCur6JTkuZtQVpWSXVtJX+1tSmO+qhLKfjWfepK7iumO298RvxVQkB
         IUSALXo8O4+7rB/14BiEFToEDDAVbx1rWS8NbIJMtGbM0x56DwIzYEHw5IDFBaWFOjCa
         yr4HfqNOXEy68rdkMaSwHwVHTWPXo8VfbqcIHJRANsv+vSmjugp++Bl6tymHc7OJlhIq
         vICg==
X-Gm-Message-State: AOJu0Yynz0hduQEoy+QJHmOETjmk0odqOB0NWKInUuCYOHnPdbwLAcD7
        4n2t+xs/IBTsmk4mz/e6gY2GPQ==
X-Google-Smtp-Source: AGHT+IGgHu14QLaTZHtaqcvyhvqRXWFUFqZQ+U9E3BYtwlGQ+0F6OAn0a/YOhlJcZqr8dsHhPOyqvg==
X-Received: by 2002:a7b:c858:0:b0:405:40c6:2ba4 with SMTP id c24-20020a7bc858000000b0040540c62ba4mr12060645wml.5.1696336268240;
        Tue, 03 Oct 2023 05:31:08 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003fc16ee2864sm1183607wmj.48.2023.10.03.05.31.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 05:31:07 -0700 (PDT)
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
Subject: [PATCH v2 6/7] accel/tcg: Have tcg_exec_realizefn() return a boolean
Date:   Tue,  3 Oct 2023 14:30:24 +0200
Message-ID: <20231003123026.99229-7-philmd@linaro.org>
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

Following the example documented since commit e3fe3988d7 ("error:
Document Error API usage rules"), have tcg_exec_realizefn() return
a boolean indicating whether an error is set or not.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Claudio Fontana <cfontana@suse.de>
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
index c724e8b6f1..60f1986b85 100644
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

