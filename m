Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF5A7B6902
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 14:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbjJCMbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 08:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbjJCMbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 08:31:06 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7C0CC
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 05:31:02 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-313e742a787so506293f8f.1
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 05:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696336261; x=1696941061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ng85okrWO1D5JYqF8LxeoCeovtEEGpWasH+P/ldXs4E=;
        b=bHZBbTKhvXVZMbaaeYuczzHYDSvRiREy19rj/vTZ3lqg2v5/iERp7KNw9v3GkKOynP
         g0Kzg2LaUHbXWiNQamERpVk1vqnD3YcLOzTTiWoJCoDBITS88CX+yOGVsUDqrdi55IMx
         SDddha3Ijt9IqnWciGZSi4XFRSzPauSDHVwnaK7vGH0eIVI1IIzOVGvAZexOIWRbClZI
         dwP7fk0SkOr6dsQtTVYlF0CH9VD3flfXRcS6QJZ4TnHzgn5ajYDVEPI9nO9RzCvOUaQh
         ENBJzKu1ToAu+1Is8RUZQUqDk6rWHV74WzIpywdPFsgAcNp+wiPBStuAWV6pxCZpkCFI
         /XXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696336261; x=1696941061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ng85okrWO1D5JYqF8LxeoCeovtEEGpWasH+P/ldXs4E=;
        b=wehKMvasDgHEdkWWs8fHWMSBhxRywuGCXmFpLefiOVXTKBZiGqfxtYggHz62O/mMsy
         rXGfL1TJ4po0ONL7Lrvx6SVty5fvPHk/GZ/M28Dw3d9ffuOUYNyWLObFoGBFthqaEGMh
         giyJJMBqgdat+B/b7jbkwZO/+YGaY8wDQWMHHIbFzDPG3IH2pgHvqVr7pRFxxtJ3Xupy
         Z9fihX8mR20mNg8YeslQkp0wT9ck3Lkcen8aaX+REV3D/6LoRUFJcJeFJqsW0MwkI+gD
         VI/AQySNB85Td2jgxtl7O+Ti5R+rM8F5SvpWPfSS3RYWc+KnvfDSlLAPWb1AKXiqkFrx
         dZ6Q==
X-Gm-Message-State: AOJu0YxJIlW092Ok9060JitLVEy1fuRZ84CQgZn2RGH94t5VL58OOM5B
        u2P3W5XovK2RaQpBugrcbM4Mfg==
X-Google-Smtp-Source: AGHT+IFSCFREFPhFrsIUBRMw43PEOKH8JJmdGJKi759Gs6/x70jH8Kzl+IQNSQVo5P0jTRrSQFmORg==
X-Received: by 2002:adf:e806:0:b0:31f:fa48:2056 with SMTP id o6-20020adfe806000000b0031ffa482056mr1881057wrm.27.1696336261304;
        Tue, 03 Oct 2023 05:31:01 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id w6-20020a5d6806000000b003196b1bb528sm1483694wru.64.2023.10.03.05.30.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 05:31:00 -0700 (PDT)
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
Subject: [PATCH v2 5/7] accel: Declare AccelClass::cpu_common_[un]realize() handlers
Date:   Tue,  3 Oct 2023 14:30:23 +0200
Message-ID: <20231003123026.99229-6-philmd@linaro.org>
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

Currently accel_cpu_realize() only performs target-specific
realization. Introduce the cpu_common_[un]realize fields in
the base AccelClass to be able to perform target-agnostic
[un]realization of vCPUs.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/qemu/accel.h |  2 ++
 accel/accel-common.c | 21 +++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index 446153b145..972a849a2b 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -43,6 +43,8 @@ typedef struct AccelClass {
     bool (*has_memory)(MachineState *ms, AddressSpace *as,
                        hwaddr start_addr, hwaddr size);
 #endif
+    bool (*cpu_common_realize)(CPUState *cpu, Error **errp);
+    void (*cpu_common_unrealize)(CPUState *cpu);
 
     /* gdbstub related hooks */
     int (*gdbstub_supported_sstep_flags)(void);
diff --git a/accel/accel-common.c b/accel/accel-common.c
index e9548eac29..11d74b4ad7 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -122,15 +122,32 @@ void accel_cpu_instance_init(CPUState *cpu)
 bool accel_cpu_common_realize(CPUState *cpu, Error **errp)
 {
     CPUClass *cc = CPU_GET_CLASS(cpu);
+    AccelState *accel = current_accel();
+    AccelClass *acc = ACCEL_GET_CLASS(accel);
 
-    if (cc->accel_cpu && cc->accel_cpu->cpu_target_realize) {
-        return cc->accel_cpu->cpu_target_realize(cpu, errp);
+    /* target specific realization */
+    if (cc->accel_cpu && cc->accel_cpu->cpu_target_realize
+        && !cc->accel_cpu->cpu_target_realize(cpu, errp)) {
+        return false;
     }
+
+    /* generic realization */
+    if (acc->cpu_common_realize && !acc->cpu_common_realize(cpu, errp)) {
+        return false;
+    }
+
     return true;
 }
 
 void accel_cpu_common_unrealize(CPUState *cpu)
 {
+    AccelState *accel = current_accel();
+    AccelClass *acc = ACCEL_GET_CLASS(accel);
+
+    /* generic unrealization */
+    if (acc->cpu_common_unrealize) {
+        acc->cpu_common_unrealize(cpu);
+    }
 }
 
 int accel_supported_gdbstub_sstep_flags(void)
-- 
2.41.0

