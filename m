Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E7C5EC5F0
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 16:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiI0OY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 10:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiI0OYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 10:24:55 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A076250
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 07:24:54 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id s14so15357517wro.0
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 07:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ICOJrCaCj9cyypnb7sgwStZZcWx3y8ZLrngrBB6RAFU=;
        b=qSrmH2UBqPGT3YtEKljR+7n1k28yT2fED4/Whs/vCufLDoNUyGR2oIWHc3iF6kxtwZ
         Rf9xybgycx5I2GGXrnIfEaM5kJ27o+t8ENJNXuhDR5i1jBff3sM0cjqZapc7l0/NWv6n
         yiP1gmijwk0D2UXxGGQ5OFCp0+pfAntQ6Ssqmbs+r1Z3MawYwRclGYKgi83oWCQWON9j
         ynEaFy0Ht2JCUvYTkL5L++MUyul44TYB6/pIVLZHVGkwRh6vZCEwEcqoNtia2ob4tnKJ
         OSkDYzpL2RfZ7weqMVIjGKxVOdRLPQipPI66BqdYGweZf4Siew6jqpHYfGouzsHl5pZA
         3urA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ICOJrCaCj9cyypnb7sgwStZZcWx3y8ZLrngrBB6RAFU=;
        b=zxAKMy2ycl7V0B6uBe2AulXFd7hF1FmXweXLlocZeFsNMR4DLF5013DJtl8H/wzBw6
         +KX3nXFWeRoqXDeLWdakK+xN1B4V35++wnFHPDk9/YGZG2VTNjoo9/1wGl2nqzCZyyrL
         bdVmFF0CDD/6ALI+6cpJHIADZxxNn8UvDnjNi8dsaSttJdDDwlIPZeIrf9/7r0uJLiIt
         aUSEYdWRa2h7yMzlmdrOgF/FRLoy/eaKB11ZloFLNkMk/1wMu15rL8W0SXlDbkai5aqO
         QiJplvYxLEhmDmkV9rFMVLGKtHwMDMdfG+vU7y8qY0QtXelwRxnJbCPxNjgvqeTj7zuT
         2pXg==
X-Gm-Message-State: ACrzQf2zzb3uySZQykiV9jQGlvandkX8vm+yppyJ46biJNBRZb5zlnwL
        r0sVbuKrf9CT6tgv8xtKABJTcg==
X-Google-Smtp-Source: AMsMyM78eAhXF2ahMqHq1PMcTmPHIebPxk1p3NIZidOuusykFalhDuQb+Ep6PMcUDHmQ/vd3Wzhlhw==
X-Received: by 2002:a5d:598f:0:b0:22a:f74d:ae24 with SMTP id n15-20020a5d598f000000b0022af74dae24mr17220870wri.544.1664288692690;
        Tue, 27 Sep 2022 07:24:52 -0700 (PDT)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id n43-20020a05600c502b00b003b486027c8asm14419123wmr.20.2022.09.27.07.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 07:24:51 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 4DFBC1FFBC;
        Tue, 27 Sep 2022 15:15:09 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-arm@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH  v3 15/15] accel/kvm: move kvm_update_guest_debug to inline stub
Date:   Tue, 27 Sep 2022 15:15:04 +0100
Message-Id: <20220927141504.3886314-16-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927141504.3886314-1-alex.bennee@linaro.org>
References: <20220927141504.3886314-1-alex.bennee@linaro.org>
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

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/sysemu/kvm.h   | 16 ++++++++++++++++
 accel/kvm/kvm-all.c    |  6 ------
 accel/stubs/kvm-stub.c |  5 -----
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 6e1bd01725..790d35ef78 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -247,7 +247,23 @@ int kvm_on_sigbus(int code, void *addr);
 
 void kvm_flush_coalesced_mmio_buffer(void);
 
+/**
+ * kvm_update_guest_debug(): ensure KVM debug structures updated
+ * @cs: the CPUState for this cpu
+ * @reinject_trap: KVM trap injection control
+ *
+ * There are usually per-arch specifics which will be handled by
+ * calling down to kvm_arch_update_guest_debug after the generic
+ * fields have been set.
+ */
+#ifdef KVM_CAP_SET_GUEST_DEBUG
 int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap);
+#else
+static inline int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
+{
+    return -EINVAL;
+}
+#endif
 
 /* internal API */
 
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 6ebff6e5a6..423fb1936f 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3395,12 +3395,6 @@ void kvm_remove_all_breakpoints(CPUState *cpu)
     }
 }
 
-#else /* !KVM_CAP_SET_GUEST_DEBUG */
-
-static int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
-{
-    return -EINVAL;
-}
 #endif /* !KVM_CAP_SET_GUEST_DEBUG */
 
 static int kvm_set_signal_mask(CPUState *cpu, const sigset_t *sigset)
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 2d79333143..5d2dd8f351 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -46,11 +46,6 @@ int kvm_has_many_ioeventfds(void)
     return 0;
 }
 
-int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
-{
-    return -ENOSYS;
-}
-
 int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr)
 {
     return 1;
-- 
2.34.1

