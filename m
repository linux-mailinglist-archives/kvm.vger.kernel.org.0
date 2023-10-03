Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6DA7B6900
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 14:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjJCMay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 08:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbjJCMax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 08:30:53 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9026DB0
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 05:30:50 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-31427ddd3fbso914215f8f.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 05:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696336249; x=1696941049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+r9kD/biBFamNwbYJdkWZ0i3n7hbuMnWH0aEsGJ6SFw=;
        b=bRSHnVzSjOd3X3lo/EaxL1WUWZXX3RrMA4npO3XyOnijhD4zO/RBGk0710vgvInLEs
         9OLm7lBlEqaVU6tsKrZ0egfoZbU7mkO8LWgLZP8zb07NY5WZMhs+k/Ucw6XlZLaHsrHJ
         JG2qceQ7IciqA0Mxzcv/pjpQvfMcGsQm9nyWKh9zRdl8XHfQ6pys6qsBBqasmMzRbFvg
         umKQMumJOCUKfUOLfvYZmJdtLgvAitDN8vbX+kGiQbOqBuTeFA3BWbdgBpnHwo31TQ8v
         QzaFx0MgZ+hQWElTrjfsYIVWapGEmQgAFgJgtK+eec6CJX9G5JvG24w9kVpwC7M52gvj
         XevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696336249; x=1696941049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+r9kD/biBFamNwbYJdkWZ0i3n7hbuMnWH0aEsGJ6SFw=;
        b=NtUjxaa/kyhl+pLLQEJxRVFMhXKp3azB+KwazeIyu1/BxQhnUE1AW8Lx7QaX8DmLkH
         UWOgJLrgfxTu87LkBJg9U5P9II7V6/3pA37c5X+xHIIoxLyv/j3Qd/qvf+wdS5KJudrW
         FAYdwwpQTUGQDBnRi+emGnB/6sZoRhSv9zmVbYnQYLCH6pzwAJxcgRHYA+bK7Wl9J3A+
         XOKP45LwKc26BxIXHRVk/QaJ1aUV0TFDjWn4LErAlpP6o0gDAcRPCJftysbAn174+rH9
         27vyhSfOpzPUCpw7ie2X4rHFI6TZcnNxNxoEkKbgVOjphpqhXhrwE4W1B2/Rb21GonZP
         c2EA==
X-Gm-Message-State: AOJu0YzjSOhCLZ2MttvJjnoV1Pcc/ZbjhhHivCSSMkipcakly/3M3FN6
        Co5aOc9gfk9rqxUdyljvJMhWaA==
X-Google-Smtp-Source: AGHT+IHhblTpAoVK9JdeAoL6m9m3WTb9pwO1Prdgl3RZZc3YHqkdykddbrQQUTc7erRRAv19P/MBzw==
X-Received: by 2002:a05:6000:186c:b0:327:d08a:1fa2 with SMTP id d12-20020a056000186c00b00327d08a1fa2mr4920150wri.36.1696336248049;
        Tue, 03 Oct 2023 05:30:48 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id c16-20020a7bc850000000b0040303a9965asm9309683wml.40.2023.10.03.05.30.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 05:30:47 -0700 (PDT)
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
Subject: [PATCH v2 3/7] accel: Rename accel_cpu_realize() -> accel_cpu_common_realize()
Date:   Tue,  3 Oct 2023 14:30:21 +0200
Message-ID: <20231003123026.99229-4-philmd@linaro.org>
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

accel_cpu_realize() is a generic function working with CPUs
from any target. Rename it using '_common_' to emphasis it is
not target specific.

Suggested-by: Claudio Fontana <cfontana@suse.de>

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/qemu/accel.h      | 4 ++--
 accel/accel-common.c      | 2 +-
 cpu.c                     | 2 +-
 target/i386/kvm/kvm-cpu.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index cb64a07b84..898159c001 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -90,11 +90,11 @@ void accel_setup_post(MachineState *ms);
 void accel_cpu_instance_init(CPUState *cpu);
 
 /**
- * accel_cpu_realize:
+ * accel_cpu_common_realize:
  * @cpu: The CPU that needs to call accel-specific cpu realization.
  * @errp: currently unused.
  */
-bool accel_cpu_realize(CPUState *cpu, Error **errp);
+bool accel_cpu_common_realize(CPUState *cpu, Error **errp);
 
 /**
  * accel_supported_gdbstub_sstep_flags:
diff --git a/accel/accel-common.c b/accel/accel-common.c
index 2e30b9d8f0..53cf08a89a 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -119,7 +119,7 @@ void accel_cpu_instance_init(CPUState *cpu)
     }
 }
 
-bool accel_cpu_realize(CPUState *cpu, Error **errp)
+bool accel_cpu_common_realize(CPUState *cpu, Error **errp)
 {
     CPUClass *cc = CPU_GET_CLASS(cpu);
 
diff --git a/cpu.c b/cpu.c
index 61c9760e62..1e2649a706 100644
--- a/cpu.c
+++ b/cpu.c
@@ -136,7 +136,7 @@ void cpu_exec_realizefn(CPUState *cpu, Error **errp)
     /* cache the cpu class for the hotpath */
     cpu->cc = CPU_GET_CLASS(cpu);
 
-    if (!accel_cpu_realize(cpu, errp)) {
+    if (!accel_cpu_common_realize(cpu, errp)) {
         return;
     }
 
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 9a5e105e4e..56c72f3c45 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -35,7 +35,7 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
      * x86_cpu_realize():
      *  -> x86_cpu_expand_features()
      *  -> cpu_exec_realizefn():
-     *            -> accel_cpu_realize()
+     *            -> accel_cpu_common_realize()
      *               kvm_cpu_realizefn() -> host_cpu_realizefn()
      *  -> check/update ucode_rev, phys_bits, mwait
      */
-- 
2.41.0

