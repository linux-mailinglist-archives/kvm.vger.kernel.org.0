Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A73C765104
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 12:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbjG0KZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 06:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbjG0KZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 06:25:00 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF5C1FFA
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 03:24:54 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-348dfefd1a4so2729935ab.1
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 03:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1690453493; x=1691058293;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GfEVzfDMM3KV/MRFcXCu/fGQgJk4J1J61XVMjT70iMs=;
        b=cHmrInueGEngMD7UYGmB+iSXoktK/awClLPYSSKF/pxXfwAGRn+ArthLC/yhmHpuJB
         LswL/BReQY7IL6c2/yJXWuk09AYNEeR2QJscAvtNifHzohRaMFnzh7JCCOs+E/qsZn5n
         TS7CmIir0KqXVnwtD7qWEC8ZpYvZMPqiD2NQ3Vn+58/3ZCWF2Spok7iS6cAIvZaQ3h8H
         yMZJIHYAKXPamwly2j9kdO7kitEsCGSBFTRscnmDvQltEnV0RpJAfcpbrmq5R22FK8Q+
         slnlFFAe9ukcL6dPVpCUHcvwdNNeIatrHV5mkFebfpIzyIR6/kQjINlH/Qjb8WoywZcp
         WcCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690453493; x=1691058293;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GfEVzfDMM3KV/MRFcXCu/fGQgJk4J1J61XVMjT70iMs=;
        b=TtT0erQkNJqBdIn6LbPyHjRqujaVpgjtQjHBwGFkZp0CKX/ySOa66RFAW00mYaH5gV
         TFR3TbRGbLiF9SeE3v5wSHg8mKjOBCp0bKpt9lhppajHZgkn6jMFuJ2H1JM6SgFTP5cU
         Qml2aDtnbAPAaU0TNp17lYQbWNM3DnQ0bznik09bHEHczOL+OUA7qTZM316uMziF3Y+w
         vlTviS+NBKHSfcgsPKGF1TIK6zG5YGKN9XXvpEU+yZBrvFFFeKAsYQjlAIMaBbv/J1Oa
         hGP8ASNGbZckTi/9IDOeeRCs84Egxj8vYeMmJbQiGb0gjnqkURWb7nQ83y5wz23mFjEX
         paDw==
X-Gm-Message-State: ABy/qLZ+VnJ3IOQ9DarOd505Ei/NQeZKNXdg8Jx9JLDiCnmatXJOqv36
        /KJJL/qyVT17EL5R2f0PAq6tqg==
X-Google-Smtp-Source: APBJJlGmpqtL4QEdAiDixYp4kNbQW1CQ9NkC8foOTmxv9KtWAPuVL9V2HinYgjq9XtD2a/1AO9/O7w==
X-Received: by 2002:a05:6e02:1a6a:b0:345:fbdc:bb78 with SMTP id w10-20020a056e021a6a00b00345fbdcbb78mr5294262ilv.29.1690453493285;
        Thu, 27 Jul 2023 03:24:53 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id u8-20020a17090341c800b001b882880550sm1230139ple.282.2023.07.27.03.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 03:24:53 -0700 (PDT)
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
Subject: [PATCH v7 2/5] target/riscv: check the in-kernel irqchip support
Date:   Thu, 27 Jul 2023 10:24:34 +0000
Message-Id: <20230727102439.22554-3-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230727102439.22554-1-yongxuan.wang@sifive.com>
References: <20230727102439.22554-1-yongxuan.wang@sifive.com>
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

