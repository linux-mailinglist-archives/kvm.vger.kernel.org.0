Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8AB6EC860
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 11:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbjDXJHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 05:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjDXJHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 05:07:47 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B11410F0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 02:07:41 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1a6762fd23cso36796805ad.3
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 02:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1682327260; x=1684919260;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Fua0B/nbmKUJP9K04TOuYhl26KH1ZTyjvPcnsj/T2bE=;
        b=k7EoDrjMFvWCasc6+7i/ZJAEukqdW68vCJFzSTMnXxSdO3useorqP56qd63TTfYkf5
         geY0pVq2k+aw+XUGk978QNA4fTpJDrMpvbHClMxamDSCWt5+Jy/FHO9rUaCG2JnyUtyw
         LocLBJezivMbnF7V6KrOSoO2qAMEUQ1v+jeRlXIqgqCF+j0IGAhlONKkpt+/LwLHtMpr
         bJs3pngJo8lOiIVuZ9xTeP6lH2xawBfW2mbDNEf+GnjxmFTaPCnutT9zoK8WNIUA9dGa
         cR41Slzq78Ohn+jMeYgr4ZVgplRoZhz/2ryiK5U4Ireutdtfr5w9B2vDp2nIBWCtE2Uo
         827A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682327260; x=1684919260;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fua0B/nbmKUJP9K04TOuYhl26KH1ZTyjvPcnsj/T2bE=;
        b=RF3nqz5ELqRPzlBfhGYOj9g4ZHyb2dPWZRIKu0Z28QKexYa2lQU03lV1SESVVyhF/w
         e4+4PeUELWy6W3t8c7S3r32jFPLP57GXCBad+qwK2sngLeq5oOsrT0fK1f4/IIYD3tRv
         Tt1C86iHblrvCvLCF+3KQUGrxOqPaSns7T2DEmmqbhMF2ikblEkYkAUxEbMwoEpUTAo1
         ierWVqAUtmIPOfOBkQnC0NwCWmfxuEipUIuq9iOwpqmJPIHR8ER7IEQklvazXz/yLO8b
         QMgvMAeheKd0t6M/H4+ICgKc05S5XLeHC9Eo13L+KVBPGgPRdtWLIXKufV3hGTaWgIum
         pPfQ==
X-Gm-Message-State: AAQBX9eIiNZ5c1MD+Zm9V+Xe0DWC+vq/8rV/sGKyineDOG3VcdFyEg1l
        AHUK36d3iM6/60pp/8nj7LYFrQ==
X-Google-Smtp-Source: AKy350Y0kVgXK6MzgqOE+iENhZhpis8rzzeUu2s5kgPtN4XeCpSsdsoSS99vmnY0iNRjzTZaFcPT9Q==
X-Received: by 2002:a17:902:ec86:b0:1a9:5674:282e with SMTP id x6-20020a170902ec8600b001a95674282emr10310838plg.14.1682327260677;
        Mon, 24 Apr 2023 02:07:40 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jf2-20020a170903268200b001a207906418sm6234820plb.23.2023.04.24.02.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 02:07:40 -0700 (PDT)
From:   Yong-Xuan Wang <yongxuan.wang@sifive.com>
To:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org
Cc:     rkanwal@rivosinc.com, anup@brainfault.org,
        dbarboza@ventanamicro.com, atishp@atishpatra.org,
        vincent.chen@sifive.com, greentime.hu@sifive.com,
        frank.chang@sifive.com, Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 3/6] target/riscv: check the in-kernel irqchip support
Date:   Mon, 24 Apr 2023 09:07:05 +0000
Message-Id: <20230424090716.15674-4-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230424090716.15674-1-yongxuan.wang@sifive.com>
References: <20230424090716.15674-1-yongxuan.wang@sifive.com>
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
index 30f21453d6..6aad25bbc3 100644
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

