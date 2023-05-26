Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0CB711FD6
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 08:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242130AbjEZGZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 02:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjEZGZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 02:25:32 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F846198
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 23:25:30 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-528cdc9576cso254219a12.0
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 23:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685082330; x=1687674330;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dfZLHLenIMrmO0jB1mDUgnBqGDCRWU9RcEAKqrqYqAE=;
        b=i6YXnEHHRZcYV9PvNABDtI6eQRHR9T/UAF6RJlRt3uxKrS3FRQq4tSDVs8Pw6yeHFH
         yhWjiVXG3iWmkEqMCwvJTPXpLXPDQj56DTCdFQDYg4wu6jZOrjOStci38FHiHto7vLTY
         pBO9aUfBiRm9TnsZHWLyP6u32KsGDLRY0I+XxbeHjK1anUJG/xfc9CNn9EM3VBM8HEB/
         XlPNp6WQ7bA9kI3ErFRdjRDeMStVHXiAgYnQTUNFI/RyC7dtmFtAkw3tIIglof7ZKDyh
         FQrAKOoa1vfO/8N1RvOfn9EjtMb4t8qaxypBWFS/zHsZtKXWiRfvRmF6Qqs4oieM9FhO
         dIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685082330; x=1687674330;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dfZLHLenIMrmO0jB1mDUgnBqGDCRWU9RcEAKqrqYqAE=;
        b=JvbjeN3NrW0WyBt4Qi2EbKA1HX33JcbgeXP6fAOP8HACfp99JSILZfi6vEeiqI3S13
         L/S22oafSJfe2dZCvSbpllw+55gTPOMfy6duDIHGmlrWLPVSic9s0UyFlphsKNFleUTz
         iVYIy49lBRllHR/3uFPCePMgL+dFVFPDUEJOm2w5ak/vWhVq685+71vBHwxJ5hV6+fJ+
         34/7l07GEKjMY0NUt5+szPPaqmo9Qo48Fxk4XU0fNPOoqXQQipSFRjHe+DVAZqJ+iIDY
         EIjWXsZmazp+IqWBJMq0Yhbh2KVMMSgHRYgDcgF51CqbnLItuqyyWfYpocjuuf7Vx6qI
         a8mw==
X-Gm-Message-State: AC+VfDzA6RFuvVQM2mcc2ZrAdvZuqsss2kO6WeHV+3rz+q2q7vT/cfBQ
        0HD+wTFZdDtF9m8ZVlviTH1Kmw==
X-Google-Smtp-Source: ACHHUZ5WevrNwpEUd09OMlCMcDFl3OE+OQQn7rZ71gbWoj0Tp4n/zT3Iqf3ICCPuop30Pk2qUImn3A==
X-Received: by 2002:a17:902:eacb:b0:1af:a2a4:8386 with SMTP id p11-20020a170902eacb00b001afa2a48386mr1442476pld.38.1685082330441;
        Thu, 25 May 2023 23:25:30 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id m24-20020a170902bb9800b001a94a497b50sm2429150pls.20.2023.05.25.23.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 23:25:30 -0700 (PDT)
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
To:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org, rkanwal@rivosinc.com,
        anup@brainfault.org, dbarboza@ventanamicro.com,
        atishp@atishpatra.org, vincent.chen@sifive.com,
        greentime.hu@sifive.com, frank.chang@sifive.com, jim.shu@sifive.com
Cc:     Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 3/6] target/riscv: check the in-kernel irqchip support
Date:   Fri, 26 May 2023 06:25:03 +0000
Message-Id: <20230526062509.31682-4-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230526062509.31682-1-yongxuan.wang@sifive.com>
References: <20230526062509.31682-1-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We check the in-kernel irqchip support when using KVM acceleration.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Jim Shu <jim.shu@sifive.com>
---
 target/riscv/kvm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 0f932a5b96..eb469e8ca5 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -433,7 +433,18 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
 int kvm_arch_irqchip_create(KVMState *s)
 {
-    return 0;
+    if (kvm_kernel_irqchip_split()) {
+        error_report("-machine kernel_irqchip=split is not supported "
+                     "on RISC-V.");
+        exit(1);
+    }
+
+    /*
+     * If we can create the VAIA using the newer device control API, we
+     * let the device do this when it initializes itself, otherwise we
+     * fall back to the old API
+     */
+    return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
 }
 
 int kvm_arch_process_async_events(CPUState *cs)
-- 
2.17.1

