Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2FB6FD9A2
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbjEJIjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbjEJIjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:39:12 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476F2127
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:26 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6ab0a21dd01so1174187a34.0
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1683707905; x=1686299905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ur/4nc0WWZqL23flua+8noNR16SuSLq+XhY4yLBLAT8=;
        b=o79i6XdcYTSEeO4/8WCPaSWURNUD/nK2evnFN04SOMKw5I7HMIAGvkHo9wTvCNeRfM
         7wUPG8TfxJZbQxr/MZYSfPJxXpIW+e8V2M6Cwj7wxUVTsxTVw+l2+QsI6vtds31CU8mZ
         9BKuVxyaD2pFBUmJSAOh9vdPy5+Ts7DGQrzNMgYpEEMoN1ab77VeUCtqw+DwzggwCcI8
         Ki0qLmYWu2Nh7mEQ/NqyOnMSg+BgRgHMqCoVxZY0nuZScoH9y15pWJyRCTOATnEykS1c
         /xI2TprKygvct8ZvgOuTLGduvFRYjI/S8Ae1o4kh02ef+BWSdzrO0LL+hnve8Fohv9XQ
         v8Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683707905; x=1686299905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ur/4nc0WWZqL23flua+8noNR16SuSLq+XhY4yLBLAT8=;
        b=P37TbIe7ZMc3LQ2U+QLTdpGm8ahSC2CeB32iH7km23RfzuIOcdWOwibXpBeuXUzPTi
         9ACVu/ufgtMN7HUyAZKQtfREK11NNRILO0HFeH5EY7aLOaGgRulUacxwVhBWvgxj9j9m
         2XF1i+DfwOREA3g08REYaB+jBQYAQcz4Q1fe/jZeBMnRiwp5wcHHSIo49WAmjkV9dmFO
         t+FFRrAnkP4d2Z1rP5VcTWEoWC1fPNWDEet7jiG53cb0ekFKI3Tru/wzcl4t9ljUvAyn
         pSiwsWrmtTqYZxe2y6qS/n5c9+qVW/uu+Lrfzx/jcvjlKPumFeuVE4PGJAS0G5JVhNdu
         4YGA==
X-Gm-Message-State: AC+VfDwLAJD2WwuR6/URZazXyWipPsR1OjJhCPpuRGU5d0n83XYrYeSj
        a+yZC8v1X/Zv+dWLYmXahEDuGg==
X-Google-Smtp-Source: ACHHUZ4gbtEuQJOc5ozA/3ihYRfRjHth4EwBBYn8mebF9Gi4q2yR6qCZ148yx0CeXrpMfusPraIc7A==
X-Received: by 2002:a05:6830:13c9:b0:6a6:814:478c with SMTP id e9-20020a05683013c900b006a60814478cmr2613226otq.28.1683707905486;
        Wed, 10 May 2023 01:38:25 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n12-20020a9d64cc000000b006a65be836acsm6049711otl.16.2023.05.10.01.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 01:38:25 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 4/8] riscv: Sort the ISA extension array alphabetically
Date:   Wed, 10 May 2023 14:07:44 +0530
Message-Id: <20230510083748.1056704-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230510083748.1056704-1-apatel@ventanamicro.com>
References: <20230510083748.1056704-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let us follow alphabetical order for listing ISA extensions in
the isa_info_arr[] array.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 3cdb95c..977e962 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -15,11 +15,12 @@ struct isa_ext_info {
 };
 
 struct isa_ext_info isa_info_arr[] = {
-	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
+	/* sorted alphabetically */
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
-	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
+	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
+	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
-- 
2.34.1

