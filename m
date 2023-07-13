Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDA9751BFD
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 10:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbjGMIpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 04:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbjGMIo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 04:44:57 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4D2213C
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 01:44:23 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-3a36b309524so484357b6e.3
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 01:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1689237863; x=1691829863;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bRqQKtep7JWLgclLdUkli6/fChTnwWs+kTdTq5m30jU=;
        b=CTlKktPs+hY0cgE7CS2PUANVjOXYIGn9DpU2fh7mMW2HZEQy1ymS0r+QkdZU1bdjGB
         P2H/jtF17Wexhc+P++LOh0FtkHw9ToVJYYkmJ2R+46Pq+yCVcBYwEa6sNddZeYTAQG93
         F9Re91F5WlS3VTETLFEyPWpb8ZNnRWYnopTN/k1Y1tVgM4Q3WhYSiZEb5INzk1ZCWmZy
         Ht6uHxlWh/bDhXre4KQ3q292Ebz8ayR2ctMZrSgTwIWEJnL9HCOIKtH7CssMxSprI1gQ
         basdybVGjqRuPOKpJ+sCLh4s5/DYF6oxFOrVQwIq/hKuKNAcy/cCYqRf8VrmJrBEBlX/
         xwhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689237863; x=1691829863;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bRqQKtep7JWLgclLdUkli6/fChTnwWs+kTdTq5m30jU=;
        b=CdRuGkK+hLEEc8Pk/SJhKo9xM0BLGLMOIG3p2aVy6ztEXMOEeuFG9H2dMbATI3lAQE
         Ngbxe4Uo3EhkJ4eZHhZpXP0VQwvdpHxUcLnMojLCd0hCSdTMwLwPKraHSKVcL/5Gs4jS
         wAk1ESZTDzPxb0tvqfqpMWKNkoGeAodQ87bEKuibVqYvtWxKV8K9yyDn+xBNNpGtyZzY
         omhkpNNvwvmGglbBTYcIMF+Xsf+cFXqa3wrqUwuw0YcKJvZtdv5r0I+NUPTg1LtB6P5m
         BxZTinxEs2DbLcij9doPqZg2o+AAT3MdBj8fl+gCpyvlayGYvktzocyPoS+NJa/fE1DY
         AZ9g==
X-Gm-Message-State: ABy/qLaTWoqawal5yDEki1Z4rlf2uYIZ0Y+KeB9eMwtPbD2pDdgXPrYn
        90ErpFGsM9H+RYxfgf5WyN+QPg==
X-Google-Smtp-Source: APBJJlEwvjQxj7TZ0LJFULoNQDbfGWViUSUPEKbUpl3Uk7rotzEbi31NqIdsDVgZwphMV9Wf+7w6Vw==
X-Received: by 2002:a05:6358:70d:b0:133:26e4:afb2 with SMTP id e13-20020a056358070d00b0013326e4afb2mr2045730rwj.3.1689237863041;
        Thu, 13 Jul 2023 01:44:23 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id c10-20020a63724a000000b0055386b1415dsm4989198pgn.51.2023.07.13.01.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 01:44:22 -0700 (PDT)
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
Subject: [PATCH v5 2/5] target/riscv: check the in-kernel irqchip support
Date:   Thu, 13 Jul 2023 08:43:54 +0000
Message-Id: <20230713084405.24545-3-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230713084405.24545-1-yongxuan.wang@sifive.com>
References: <20230713084405.24545-1-yongxuan.wang@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

