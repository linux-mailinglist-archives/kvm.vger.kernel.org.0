Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C2A186FB7
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731948AbgCPQND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:13:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:41389 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731545AbgCPQND (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:13:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZypQ8Ym2m02m1znfiemKRznaDVP8zp+ewV5H3Kv12cs=;
        b=HAbn5yp9MQfvJPFZFGEwRyBGCfL03+kIWisYzBSZnAX/rV5hdfgyYQt0N2sR7pwX5HHxom
        TdVGejp/zzqhjI3/zz9cFa5D8eewiBIAJAW1BMGikssbFHN86i6jC+JxfMqxjgLUph5Jah
        2vUGgHIKtIT9pRFt0rfDjt883yZjkJ4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-g6eHaAayN0azuWcS6d1vHA-1; Mon, 16 Mar 2020 12:06:49 -0400
X-MC-Unique: g6eHaAayN0azuWcS6d1vHA-1
Received: by mail-wr1-f70.google.com with SMTP id g4so1599259wrv.12
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:06:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZypQ8Ym2m02m1znfiemKRznaDVP8zp+ewV5H3Kv12cs=;
        b=nHFpVZTopQ46JbDAQOXEp47Y1OMCfJjaoUsYHMNg0JzKVGfWh0rgBhehgI/W+xvTGb
         LDb2zK0cYcxdVpYhaMjjfoyIEGOymQjaVcOqX1siIlbhYyFDS1HTQBPrOqFQzmkDfmMm
         QTDX1HTECCSAeLOv+bE81K6P/kiFS8yPLzURCgRYGbQpn4coOJZs6MTsNazVPsZm714X
         xXE7qzfWLJ+N5eLk9+RCYYqmrmPdXifAPc8XV8NyqSkkYupL8nTk82E/nPocqcHbvoqY
         ubgjwxqiBpub33iImG9/XeoDWQZM7f+A7N1HYwxr+IY//5ONW/VF+0v4HSNoHHID7MH1
         NnXg==
X-Gm-Message-State: ANhLgQ0WVTPiJKfG2mCBhLtOkIAA9cO5hSaU5TFiI9aSApbOljbTxZsy
        B+m/RROj6MqO2vYb8V/JpwtVpfde47N7IbvSuCOS8erpMOTgNeD/pzyeeHW4lan1e+n0UNodc0a
        F4kAQt/kuwGKL
X-Received: by 2002:a5d:6287:: with SMTP id k7mr52982wru.195.1584374808596;
        Mon, 16 Mar 2020 09:06:48 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvIxEdXRN1Eb4UdNMtDRQaogZc63ozPayx+X/+0N08mn+FZQszGY+8INmM9VEIFVn95PP+ZPA==
X-Received: by 2002:a5d:6287:: with SMTP id k7mr52955wru.195.1584374808384;
        Mon, 16 Mar 2020 09:06:48 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id b15sm498970wru.70.2020.03.16.09.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:06:47 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 02/19] target/arm: Make set_feature() available for other files
Date:   Mon, 16 Mar 2020 17:06:17 +0100
Message-Id: <20200316160634.3386-3-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

Move the common set_feature() and unset_feature() functions
from cpu.c and cpu64.c to internals.h.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Message-ID: <20190921150420.30743-2-thuth@redhat.com>
[PMD: Split Thomas's patch in two: set_feature, cpu_register (later)]
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/internals.h | 10 ++++++++++
 target/arm/cpu.c       | 10 ----------
 target/arm/cpu64.c     | 11 +----------
 3 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/target/arm/internals.h b/target/arm/internals.h
index e633aff36e..7341848e1d 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -27,6 +27,16 @@
 
 #include "hw/registerfields.h"
 
+static inline void set_feature(CPUARMState *env, int feature)
+{
+    env->features |= 1ULL << feature;
+}
+
+static inline void unset_feature(CPUARMState *env, int feature)
+{
+    env->features &= ~(1ULL << feature);
+}
+
 /* register banks for CPU modes */
 #define BANK_USRSYS 0
 #define BANK_SVC    1
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 3623ecefbd..c074364542 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -723,16 +723,6 @@ static bool arm_cpu_virtio_is_big_endian(CPUState *cs)
 
 #endif
 
-static inline void set_feature(CPUARMState *env, int feature)
-{
-    env->features |= 1ULL << feature;
-}
-
-static inline void unset_feature(CPUARMState *env, int feature)
-{
-    env->features &= ~(1ULL << feature);
-}
-
 static int
 print_insn_thumb1(bfd_vma pc, disassemble_info *info)
 {
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 62d36f9e8d..622082eae2 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -21,6 +21,7 @@
 #include "qemu/osdep.h"
 #include "qapi/error.h"
 #include "cpu.h"
+#include "internals.h"
 #include "qemu/module.h"
 #if !defined(CONFIG_USER_ONLY)
 #include "hw/loader.h"
@@ -29,16 +30,6 @@
 #include "kvm_arm.h"
 #include "qapi/visitor.h"
 
-static inline void set_feature(CPUARMState *env, int feature)
-{
-    env->features |= 1ULL << feature;
-}
-
-static inline void unset_feature(CPUARMState *env, int feature)
-{
-    env->features &= ~(1ULL << feature);
-}
-
 #ifndef CONFIG_USER_ONLY
 static uint64_t a57_a53_l2ctlr_read(CPUARMState *env, const ARMCPRegInfo *ri)
 {
-- 
2.21.1

