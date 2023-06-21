Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3BE73884C
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbjFUPCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbjFUPCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:02:02 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8973C423A
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 07:56:20 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-668730696a4so2213646b3a.1
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 07:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1687359325; x=1689951325;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nqH3aMkSK9qxiVaw0GmCtUqp8Wyz1u6/ws84JkvNEL0=;
        b=H5ViZUPQw9osR2VXps93zxn8IrqItIFx7TDj6ITC14iT112mUitwZVJMhKkxQ+EKGy
         L+BYQLQnjExqMU7PtP3NAQkInMPsZ3Bkq7Rgb+9JUUyP7x27tpG45eeA3p3DF5GvociK
         B5wmVSz6t1EuoU+W8hmoenwTWRzZJGl9y+OgEVBIetmbBtsDJpe73RO93YV0Lupoo1oA
         PWjeF+DpMAbMTFi15HIiUmq4Xf8eeMfrjFXr2QVcfaZcWgkrDBJG0jrE8u3NubdUOCU2
         bGhpA9noPs1EKDvESlEOpMAAvsIvq8NWlGGK1thwrfmT5eLZrQlvA6bOptW7+9C5+wxR
         F4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687359325; x=1689951325;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nqH3aMkSK9qxiVaw0GmCtUqp8Wyz1u6/ws84JkvNEL0=;
        b=JWe5QLKg5w98XwNmswR5EhbdIYAeXaYg0tNpDZhCy++w8INRp0ztjPvTgSYmCLLbVc
         DYCthfOBxbzmW8jKBJt+k2w0KCDSThQqgLxh3aCjLa+EjapxDM67DtrYtYpfmguh2iiy
         DEflqX/bOi5G+BwsbUN4D4kShlaWyIzUC6iJrs0AiOGCvlbH6K89SK3t7YRgpIxPCEeQ
         79SoLJkTlPkJrgufNhugpZRtzhG7y7HEA6brbM6HWUODz/x2BT6VFSpP+zhHKSCbYfi+
         74EsUFqr+WslILq48es5rvTaqJIgyhOzidAx3femb6QNxpyondqRLLyczADg8YJsQS8M
         5N9A==
X-Gm-Message-State: AC+VfDzSpyEQcFk8oL2wCwRSMM4cslNf+DOv7HDObqTQYnyzBGcn1U0Q
        HLQe9yd8tOcZ04WMakYc8m/BCw==
X-Google-Smtp-Source: ACHHUZ5AJbgoi1rYVfa6wEmMT+MdfVPa920a7WoPuofemVbiLB65tBYhIsRWNQD4axPlHfl+4W2h2Q==
X-Received: by 2002:a05:6a20:9144:b0:10c:513d:2bd9 with SMTP id x4-20020a056a20914400b0010c513d2bd9mr11519434pzc.50.1687359324631;
        Wed, 21 Jun 2023 07:55:24 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id v8-20020a62a508000000b0066a4e561beesm356762pfm.173.2023.06.21.07.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 07:55:24 -0700 (PDT)
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
To:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org
Cc:     rkanwal@rivosinc.com, anup@brainfault.org,
        dbarboza@ventanamicro.com, atishp@atishpatra.org,
        vincent.chen@sifive.com, greentime.hu@sifive.com,
        frank.chang@sifive.com, jim.shu@sifive.com,
        Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 3/6] target/riscv: check the in-kernel irqchip support
Date:   Wed, 21 Jun 2023 14:54:53 +0000
Message-Id: <20230621145500.25624-4-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230621145500.25624-1-yongxuan.wang@sifive.com>
References: <20230621145500.25624-1-yongxuan.wang@sifive.com>
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
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
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

