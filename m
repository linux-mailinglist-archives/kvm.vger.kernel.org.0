Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C9B791760
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347313AbjIDMos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352920AbjIDMor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:44:47 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33646E42
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:44:40 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-99bf3f59905so218083666b.3
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831478; x=1694436278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c18azMn+jtI1YAn3dB0AGJOCqMNVzX0REantB+5g0DU=;
        b=ySQ5g0lskI++33f4BGopafUSz5qwKzLDdgj3ibi91XFJaoBSFXLrvmqsNdslVKHdMi
         IhtMksW/W+MpJfOIu7WVC1CZzZW2K3W4CExqq63KNpk/9V61HkqHHTRYDHwDnOwwlDFs
         S7WPBpbDzqvTDohHdPD1yt/ggGrYg/BVWykegUjLbz29V/+j7oWl4F6APcfo7OjULHAF
         aRZ7HdshJp1gnRdj6dq7TNCQu+XPuK/lWLYCJ8+WtAv21I7cBz0PB/JhAUJiEV9zBFDH
         Xuyox9UBJ73rxjNvdMk3jk2vNPN8XpgjrEjCg1mztWZo3E1tzClk10SRD620CThfvShk
         +/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831478; x=1694436278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c18azMn+jtI1YAn3dB0AGJOCqMNVzX0REantB+5g0DU=;
        b=a6gm/w4+L+AXQ1P20xfWgGesYuRMA5eYm5/cuJq3MCsAWKNcPnVdU2L3gXj5A8duuG
         7MzFGF53LGQc+07BdGnxSNkW3v87+YxJS6O4/tWr8s1HkJ4A+AAl8T98xWy3HSDdA/hN
         JGKYnfSURrttUumcOPrsJb+VgDUycrHYuWD0pJQszolBi98bZw5BYbQyBnP83uOEjzGB
         ikCm3lBIstz1wAqMjipWeQy0JwcBJSt9fHXHXpiHU7gY2QYxL7NxN52rINhJyyQA0qZR
         b9yXiI6BsC5KQgoLVKxWCZTIiJxDcfPK6+/0+w8moIPMTKhZVRv9Az1704PQtlyvb11u
         sHwg==
X-Gm-Message-State: AOJu0Yy2mrTYsB0mr1WcN6qTC+/Rmon+/+wS/wZu5aznjo2KXx5hVidx
        drJn+skE1Hhq9oLrLdaSAl7vEQ==
X-Google-Smtp-Source: AGHT+IGkBWzlSRGBOELBpUf+dLc0WEpvu9JCETivRhredxbliVAZerUGcF4mTiM1Pqigg7YcHDOtcQ==
X-Received: by 2002:a17:906:5a6e:b0:9a2:24f9:fabe with SMTP id my46-20020a1709065a6e00b009a224f9fabemr6871711ejc.66.1693831478762;
        Mon, 04 Sep 2023 05:44:38 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id hb26-20020a170906b89a00b0098cf565d98asm6058630ejb.22.2023.09.04.05.44.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:44:38 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH 12/13] sysemu/kvm: Restrict kvm_has_pit_state2() to x86 targets
Date:   Mon,  4 Sep 2023 14:43:23 +0200
Message-ID: <20230904124325.79040-13-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904124325.79040-1-philmd@linaro.org>
References: <20230904124325.79040-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_has_pit_state2() is only defined for x86 targets (in
target/i386/kvm/kvm.c). Its declaration is pointless on
all other targets. Have it return a boolean.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h       | 1 -
 target/i386/kvm/kvm_i386.h | 1 +
 hw/i386/kvm/i8254.c        | 1 +
 target/i386/kvm/kvm.c      | 4 ++--
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 4326b53f90..147967422f 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -221,7 +221,6 @@ int kvm_has_vcpu_events(void);
 int kvm_has_robust_singlestep(void);
 int kvm_has_debugregs(void);
 int kvm_max_nested_state_length(void);
-int kvm_has_pit_state2(void);
 int kvm_has_many_ioeventfds(void);
 int kvm_has_gsi_routing(void);
 int kvm_has_intx_set_mask(void);
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index d4a1239c68..76e8f952e5 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -33,6 +33,7 @@
 bool kvm_has_smm(void);
 bool kvm_enable_x2apic(void);
 bool kvm_hv_vpindex_settable(void);
+bool kvm_has_pit_state2(void);
 
 bool kvm_enable_sgx_provisioning(KVMState *s);
 bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp);
diff --git a/hw/i386/kvm/i8254.c b/hw/i386/kvm/i8254.c
index 6a7383d877..a649b2b7ca 100644
--- a/hw/i386/kvm/i8254.c
+++ b/hw/i386/kvm/i8254.c
@@ -34,6 +34,7 @@
 #include "hw/timer/i8254_internal.h"
 #include "hw/qdev-properties-system.h"
 #include "sysemu/kvm.h"
+#include "target/i386/kvm/kvm_i386.h"
 #include "qom/object.h"
 
 #define KVM_PIT_REINJECT_BIT 0
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 639a242ad8..e5cd7cc806 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -154,9 +154,9 @@ static KVMMSRHandlers msr_handlers[KVM_MSR_FILTER_MAX_RANGES];
 static RateLimit bus_lock_ratelimit_ctrl;
 static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
 
-int kvm_has_pit_state2(void)
+bool kvm_has_pit_state2(void)
 {
-    return has_pit_state2;
+    return !!has_pit_state2;
 }
 
 bool kvm_has_smm(void)
-- 
2.41.0

