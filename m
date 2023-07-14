Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255F0753549
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 10:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbjGNIpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 04:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235587AbjGNIov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 04:44:51 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62572726
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 01:44:44 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 46e09a7af769-6b91ad1f9c1so1339581a34.3
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 01:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1689324284; x=1691916284;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GfEVzfDMM3KV/MRFcXCu/fGQgJk4J1J61XVMjT70iMs=;
        b=e1yvwM1JnNOK5nmqmWByk3B6LXVJm4gsB0kJJZ93hMZynFWSjhMxwqLzsiDycAqsTS
         Ho45m6z2X0Qdy4obZJOdTzMMbJlyFvdYAQ/vR+xO+wNFVGjMEcqa7Gg64XnQXbV2VJc/
         hBDMNfOHTWFMphIHhbHberq8PAmG4bsnXX0yqUcKAsiiTYEj+dUm3LklVxRp4xVwBGTk
         nNohUxYuTc9bJGAZa3gmBuLvkrxlJZFO2hN50SMmpNS+2Xe51PuBbs9e62Gg8OOiJLuk
         ll9OSDidlJP9k6yMF4SoZfT+5GsUcQBa3boApro6qXRm/p0sC2S9FlrP5qv7DHNUSxcB
         RWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689324284; x=1691916284;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GfEVzfDMM3KV/MRFcXCu/fGQgJk4J1J61XVMjT70iMs=;
        b=hMqNnItxXs+p2RNq93BeCFAdKgqUVtWpr/MUAaVZ+kghUkejUgNZfA2e7ZMtWHcBFz
         I9+Z7pQPl8qOOZS7ghy4lRw0KdoXtsF5fhvL9Tfv9SRTb8u1TG+vllYnA4D2a0+NSkEp
         4yM4kX4G/jnDo3/9OfLxzuucV/C0mboEjew2tPtaCundk8qh+RgIVI/GLJ8S3zU7A8yi
         yXhsO5EnGX2cL+ZUJP1t4WLVlObNGzrpvKhbslT6tYxUjrFvJuU1q3zETokSBXL4/HoU
         XSaMXXI4+T9GdN9j8jGfGCD9fqzaLRc3nIKZCqCpAIaBFiJVriO1kzOF7PDaOhqcG83S
         C0bw==
X-Gm-Message-State: ABy/qLbykz2ZAlaHLTUz458IBbHyYy1VkFsbr0xmdNKPeQ51XtJ7YuIU
        D5sdbyztxk7DRjcV+mdSqJKVLg==
X-Google-Smtp-Source: APBJJlGarhaXYAwO0vEVi4wHfBWRjjM8l1WYOGhZJum/Z7QpEgy5OtqK8hLRoFYfq0TSANWd/P5IZQ==
X-Received: by 2002:a05:6358:714:b0:132:d0d2:7cdf with SMTP id e20-20020a056358071400b00132d0d27cdfmr4341137rwj.6.1689324283922;
        Fri, 14 Jul 2023 01:44:43 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id c19-20020aa781d3000000b006829b28b393sm6616305pfn.199.2023.07.14.01.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 01:44:43 -0700 (PDT)
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
To:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org
Cc:     rkanwal@rivosinc.com, anup@brainfault.org,
        dbarboza@ventanamicro.com, ajones@ventanamicro.com,
        atishp@atishpatra.org, vincent.chen@sifive.com,
        greentime.hu@sifive.com, frank.chang@sifive.com,
        jim.shu@sifive.com, Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v6 2/5] target/riscv: check the in-kernel irqchip support
Date:   Fri, 14 Jul 2023 08:44:24 +0000
Message-Id: <20230714084429.22349-3-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230714084429.22349-1-yongxuan.wang@sifive.com>
References: <20230714084429.22349-1-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
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
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 target/riscv/kvm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 9d8a8982f9..005e054604 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -914,7 +914,15 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
 int kvm_arch_irqchip_create(KVMState *s)
 {
-    return 0;
+    if (kvm_kernel_irqchip_split()) {
+        error_report("-machine kernel_irqchip=split is not supported on RISC-V.");
+        exit(1);
+    }
+
+    /*
+     * We can create the VAIA using the newer device control API.
+     */
+    return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
 }
 
 int kvm_arch_process_async_events(CPUState *cs)
-- 
2.17.1

