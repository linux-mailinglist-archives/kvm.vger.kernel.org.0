Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146286D83B3
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjDEQaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbjDEQaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:30:20 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBF540F4
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:30:18 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e18so36794024wra.9
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680712217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PrAcn5qN38B5YaoSS7J2RY/lmyONQENb+5lQU26NZ94=;
        b=ltah4l+p7FJg9oAXXwCVBTw0T1SM3CGmlUjbZnWSMo+SWFV02mqjr/KQ0SOeD1mHlo
         0fwAhWUy80/AAZfa6r0U2GiGZrIYk1eglek0E2nytTJwN1bnmj+yzSFwVKvh1PvEUpny
         MF9LCkH7wBWmM9aWOgcwUz4K+5zjltGVQ2EtPzJGP9UWF+VctR/sRiZZwUsabMgRg/jS
         t5kUbvD6v6PmbJ1beYmnS3+qDEj1EOcvKCK/wDvTWQjL96fdXiHcg9IWbqyD1mFVgQ0o
         Xke5O4fLv2nu9Y+mVedL7ITgOHXOPQyha5158IQ2/KU34Hg8y3y3ZIQ5PwrKsE06vH5E
         5sbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680712217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PrAcn5qN38B5YaoSS7J2RY/lmyONQENb+5lQU26NZ94=;
        b=fe58Wtd+rY1BDU2gQ6K46h+FFhQ9lQ8nsyhcW+00MVAvJ0Cb6BrdPQBh5GsovBljFY
         v86i/VkQGPjHlP9PemUuUXNZmCaUy01jCijsNo+zVR8/1gObPd6I5/Exm22eum9lIVel
         TtmJBfXwhzz9CoriIIFo47e3xMd+RYgWXxZ9EDs8opxN9vh4Qu+W7fsNN9tSE1sqypi/
         JiB74Ue9LBzt8h91lrcR3eE1TmnRhBMu4vOkD6TAOZGKzZimmb+QH8q2okryQ7tpdqHg
         Hs+HFKZAoID2njDRcZ1dOQBd/HyZ5zAb5Dzp0OVETY6ZIW7VVtROeVUlFsfuq+UqfXTj
         v68Q==
X-Gm-Message-State: AAQBX9eiDR+dzhqauVvBXtp1+wkJtkPvrAk4SRkOPdp/Q58I+CQrVpE5
        7cpw/AvAyhLvqRAEE6DQZW9fDA==
X-Google-Smtp-Source: AKy350Y2yAbPetqipghkBmPJH5S/kDUXef+cfNvb+FySnoKcKAQS57QTIxv/gOkBb4n41gqOQPnE6g==
X-Received: by 2002:a05:6000:1364:b0:2ce:a7b3:1c73 with SMTP id q4-20020a056000136400b002cea7b31c73mr4244101wrz.21.1680712217198;
        Wed, 05 Apr 2023 09:30:17 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id a5-20020adffb85000000b002c794495f6fsm15280822wrr.117.2023.04.05.09.30.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:30:16 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH 2/2] accel/kvm: Declare kvm_arch_irqchip_create() in 'sysemu/kvm_int.h'
Date:   Wed,  5 Apr 2023 18:30:01 +0200
Message-Id: <20230405163001.98573-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405163001.98573-1-philmd@linaro.org>
References: <20230405163001.98573-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_arch_irqchip_create() is irrelevant for hardware device
models (files under the hw/ directory), it is meant for the
generic KVM code (files in accel/kvm/) and the target
implementation (files under target/ directory).

"sysemu/kvm.h" header is meant to contain the 'external' KVM
API. Move kvm_arch_irqchip_create() prototype declaration to
"sysemu/kvm_int.h" which should contain the KVM 'internal' API.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h     | 12 ------------
 include/sysemu/kvm_int.h | 13 +++++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 32e223a368..540f6f04a8 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -453,18 +453,6 @@ void kvm_cpu_synchronize_state(CPUState *cpu);
 
 void kvm_init_cpu_signals(CPUState *cpu);
 
-/**
- * kvm_arch_irqchip_create:
- * @KVMState: The KVMState pointer
- *
- * Allow architectures to create an in-kernel irq chip themselves.
- *
- * Returns: < 0: error
- *            0: irq chip was not created
- *          > 0: irq chip was created
- */
-int kvm_arch_irqchip_create(KVMState *s);
-
 /**
  * kvm_set_one_reg - set a register value in KVM via KVM_SET_ONE_REG ioctl
  * @id: The register ID
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index a641c974ea..4a46b661e2 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -140,4 +140,17 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size);
  * Return: None.
  */
 void kvm_hwpoison_page_add(ram_addr_t ram_addr);
+
+/**
+ * kvm_arch_irqchip_create:
+ * @KVMState: The KVMState pointer
+ *
+ * Allow architectures to create an in-kernel irq chip themselves.
+ *
+ * Returns: < 0: error
+ *            0: irq chip was not created
+ *          > 0: irq chip was created
+ */
+int kvm_arch_irqchip_create(KVMState *s);
+
 #endif
-- 
2.38.1

