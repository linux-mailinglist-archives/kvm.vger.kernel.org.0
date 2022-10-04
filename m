Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6525F4429
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 15:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiJDNU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 09:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiJDNUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 09:20:05 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D7912AF8
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 06:19:58 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u10so21172081wrq.2
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 06:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=b0sEFTUmJhxsrwZtNY2dwzSSYrDaPd1jMbAkb2SEAj0=;
        b=vIu7p2D4/PA+O48mA3YTJjk3rwfNYUqK0kafegq6m8TaT3o7XQFOyP0Tinz7SLTV1y
         0lQjyHkjAJKcnrULbAEMUhB1W3vHkz5YlSyHjHGMrykMNSTZULApTT3cRPTIPslkajAt
         H3CS15n8h6ORbA05inrC5PEnPEDk5bsD+1nFQW5h/nq88j19yeyk1Qt98LWLScg8RLje
         z8XKqXfvT77rSY92NxULi8wq+BqrQ7GAhZyysyhCBJh1zMcPOX+B00Ii298DZ09WgQal
         IC12YbM/cv1vh+jkTkB8pkaZc9s3BYknWgmEw84jn1BNTfNKPgb81zUenqLxoNXuhM8e
         UiTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=b0sEFTUmJhxsrwZtNY2dwzSSYrDaPd1jMbAkb2SEAj0=;
        b=fHH7mtzF83AnLHgDrrpSb+2BBhnlX0QkJ0cxiYqVbbCJTmUKYMTF7TLHwRAYPZHC1r
         LcqyXGwdETjaaMU7s1eR2WAiNg920X7/f1vLA2olpiTWaJa634lqOspNkaEECbUBdLU3
         ygBck4VNs1jSoGvbxIfQ1MJY1vP2eiuG0AIyOHRFxHN7AxIGHYfSMMkYJhXKwrrYFuPM
         ytm3HR/RS/YJ8ObinocwVJDlrpGugyqsk7CyhcfF4VcPvuH2w931mTHNz/b9n4+iT0qF
         yqUJx47ijXmZTlxg5UMiJhgMlL3vKXX0oPvb+U98AzuiB+3enYmXuksQtsQNKvLQYr5I
         I6zw==
X-Gm-Message-State: ACrzQf0fdSDlok/fnAXHA8Nwt/WmeAdC1T02C8/r/Dp6fHvvonRVUsAe
        Hqew3zHB3412pVfGnnQMK6FGGQ==
X-Google-Smtp-Source: AMsMyM6LpEOaNdWuHo+1ALxMdHCazPOJF5Ba6dP5BMdxx7Ft0Nh6nIfdHrXXmpTFGzCL1MKYnz91vQ==
X-Received: by 2002:a5d:47c2:0:b0:22e:4911:6925 with SMTP id o2-20020a5d47c2000000b0022e49116925mr3277651wrc.403.1664889596606;
        Tue, 04 Oct 2022 06:19:56 -0700 (PDT)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id a22-20020a05600c349600b003b33de17577sm14808748wmq.13.2022.10.04.06.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 06:19:54 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id B07E61FFE1;
        Tue,  4 Oct 2022 14:01:43 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     stefanha@redhat.com,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PULL 46/54] accel/kvm: move kvm_update_guest_debug to inline stub
Date:   Tue,  4 Oct 2022 14:01:30 +0100
Message-Id: <20221004130138.2299307-47-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221004130138.2299307-1-alex.bennee@linaro.org>
References: <20221004130138.2299307-1-alex.bennee@linaro.org>
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
Message-Id: <20220929114231.583801-47-alex.bennee@linaro.org>

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

