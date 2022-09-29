Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601745EF4E3
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 14:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiI2MAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 08:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbiI2MAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 08:00:04 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23871D0FD
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 05:00:02 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x15so1327648wrv.1
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 05:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=DHq1AQi9rI4q4IRUhBPRUGpA6QqNDihLOg2w93Jsa1M=;
        b=dO8Scfs3gyKI6/yrarry+x5ozfjeCSpMmMBfWkU3fulJ/IfH+mivqbXlavSpYddHBN
         4FU9FoUyKtrlra5Zp30rBHvxub98kRAeTAIbzV1dFAVEIN2SGp9ya20VT46D6eQIAZ0M
         pbBpci9fdrLV/dI/BHa8xYLnpbf+JeWw5cOITrvXdSu/2z506YuCaTaoy9Lf70RMiGpK
         BMaHaFrNN5P5XA2j10PIXkkUYGQx2yAWOrfsUPwCxJ0ARTcZb46ajzieh1EJHNh6SphE
         IX4vh+jyzbCstEIjXSnj5qGageTBJ0Wfdq6HdWuJChGA8RPQ0A3h7/w99lbVU2vFyHm6
         TI9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=DHq1AQi9rI4q4IRUhBPRUGpA6QqNDihLOg2w93Jsa1M=;
        b=zr4AGX77bjipgPFAOFHINioxz0qxe3J/UuMW+Z8jOrr4weNfAkNqLu6MePZweIjDoB
         PaK7/LNawedTN9UVjmUiA0qOwF1yk1HhvffZZGNlWgUlx7Mg6WOtZqP47jt9U5vAI8fg
         OXK5UamrzRtewpBMUswM+S4rt/F5r4XSy77IotncvwsFz+xlhyu75nBHACaoyxfO+zo2
         t338+55V4V07LMgDGluko+sXfQILsxZPoW9gngjnqklyFXzFPmsB/qGBOgxAF3VBSzN2
         Q2FubWMd9hrzG03OjQEVOg54XGz76gnulKRqmViC+MHvVL2iR7ylU1qLTDx1RAxv0FZN
         ukGQ==
X-Gm-Message-State: ACrzQf1Ig6l0CQuPXOFhIy2P++Cs9RSGl0KldKjcUGKGicH3J+opmkrT
        gBMKzZCPRmHEJE51d/h9M4sIXg==
X-Google-Smtp-Source: AMsMyM6FL9GsOgNciKCWqVH1+Dws2VSIrh9VSL9Fr+Xm7hfIhqfGWaaK/6iBvEEovrq6zc/JFSfvlw==
X-Received: by 2002:a05:6000:689:b0:228:e2cf:d20e with SMTP id bo9-20020a056000068900b00228e2cfd20emr1894309wrb.147.1664452801164;
        Thu, 29 Sep 2022 05:00:01 -0700 (PDT)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c510900b003a5c244fc13sm4817516wms.2.2022.09.29.04.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 04:59:55 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id C12E01FFDF;
        Thu, 29 Sep 2022 12:42:36 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     fam@euphon.net, berrange@redhat.com, f4bug@amsat.org,
        aurelien@aurel32.net, pbonzini@redhat.com, stefanha@redhat.com,
        crosa@redhat.com, minyihh@uci.edu, ma.mandourr@gmail.com,
        Luke.Craig@ll.mit.edu, cota@braap.org,
        aaron@os.amperecomputing.com, kuhn.chenqun@huawei.com,
        robhenry@microsoft.com, mahmoudabdalghany@outlook.com,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH  v1 46/51] accel/kvm: move kvm_update_guest_debug to inline stub
Date:   Thu, 29 Sep 2022 12:42:26 +0100
Message-Id: <20220929114231.583801-47-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220929114231.583801-1-alex.bennee@linaro.org>
References: <20220929114231.583801-1-alex.bennee@linaro.org>
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
Message-Id: <20220927141504.3886314-16-alex.bennee@linaro.org>
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

