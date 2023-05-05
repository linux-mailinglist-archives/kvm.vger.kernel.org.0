Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36986F822D
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 13:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbjEELlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 07:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjEELlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 07:41:47 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B982128
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 04:41:46 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-643a1656b79so410517b3a.3
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 04:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683286906; x=1685878906;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dfZLHLenIMrmO0jB1mDUgnBqGDCRWU9RcEAKqrqYqAE=;
        b=LlxWXzRxPsu/Zf887gNeofPH/AQsExSMDhntWJFtLJMfDxhCpTrCWJFmfXd1kJRip+
         2ojyE7WYLcUgWc1D3oF/fHM3otfc0ts20eDeRT6G4MQHCnDaa/AWCHpi7EsGKLCQRlyh
         2jEkRlAAtPktcmTM8X804GxTr8Dpw6BVW8xJfGs1jW61N1jEmkn6cs+kA3ZPKLGSWGMz
         +kLekCM0mTYXvsTjC4kz1sDipU0jh5LmXqZ8G4NIlVmuOejORWJzoRDJAIi1uuoFnxOL
         rOSgrp6IgQXdGpsjhE4nGfKPFwHzn17oeJ62XiApnCN1Nhok2IdDXacwf2kJ/V1AwJ+a
         2RAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683286906; x=1685878906;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dfZLHLenIMrmO0jB1mDUgnBqGDCRWU9RcEAKqrqYqAE=;
        b=RFnpe+NFthJlKOgKoUMK2bY38lnLLtz7OCMR6qwL8zLlOJkJenxulp+KpA3+KB44BZ
         2JawVdS5W8xPCTe0qD5PcMDp2hBVqiJCkPJp/It1Pm3MXcZxWfNwX8LrOLjuhlsiYFay
         jQaXK4aE0Ya4e2mqhn++3y7FTGFupB8lah6reXQ2q5SypHY6CTs6c48xufXi6Gxxyurw
         hkEMfMInNE63PB5Sl/OSUez2JwpcaUkKhpSCqNNhAsJ/1RyXrFeYbrmjj9au/4vsSUQc
         4SRTh4yWOHQE/Jz8qzeS0R/eh25w/J5pMD0+M4gGsPq7srsR3sGA0Rh29LJ13a4lEXe/
         qctg==
X-Gm-Message-State: AC+VfDwnL7Jm9iMLwNhMjcpFPmJ3oX9aNYSOJqGpXMcdvu3VnBthNkTs
        XtflG2yS1NDgo/Z6RXUzT2jBZA==
X-Google-Smtp-Source: ACHHUZ60oAWwoYwGWJq8xhJ6z0TRojE2bzwtt5KpXa4gHSrvPQJkDYPcivV2Mvy23oM6Xg9pdCtZxg==
X-Received: by 2002:a05:6a00:1409:b0:643:8d7:7bda with SMTP id l9-20020a056a00140900b0064308d77bdamr1997578pfu.21.1683286905902;
        Fri, 05 May 2023 04:41:45 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id y17-20020aa78051000000b0062d859a33d1sm1448171pfm.84.2023.05.05.04.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 04:41:45 -0700 (PDT)
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
Subject: [PTACH v2 3/6] target/riscv: check the in-kernel irqchip support
Date:   Fri,  5 May 2023 11:39:38 +0000
Message-Id: <20230505113946.23433-4-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230505113946.23433-1-yongxuan.wang@sifive.com>
References: <20230505113946.23433-1-yongxuan.wang@sifive.com>
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

