Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A7E750EAC
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjGLQfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjGLQfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:35:40 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077831FFC
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:30 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b89600a37fso37726565ad.2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689179729; x=1691771729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPQWdMrB3vJlDcEi+yFf+uGq+ry4kW1YJbGepQr4/gM=;
        b=lcSLMNp3NdZBtHRGGCIbnFSQh7alKEgA3HzPsViaL2g/Wvj0RnAyYmiq3uR3tAgt0x
         U0P6l6+nBzww1XpQuKfZTBPZ+wSNNr8tsgubUWmq7fcj3EUygdsqryL31Lew3+0UjxBO
         1998PH9eYGoaj3z2XPHLlEFxupZUs7GDbKwSo89ImRkhHrtMggVqGR2W9tkZRwZmzpMh
         6QzmtdcCFDAw8NNflQGVI3SNctINbTlWNsnMkFjXFtQxwnMiLPJkQC+zmhvihi2nwI+E
         H7y0Zunao0aHjhakNhhGftlaM9vqcLw5kEyVifS5c+qlJ7kx5mzndZAoizky0KAsDg3+
         oX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689179729; x=1691771729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPQWdMrB3vJlDcEi+yFf+uGq+ry4kW1YJbGepQr4/gM=;
        b=OHTUROHqc2EAdIeKPvNTdRsaqV0vPVPSYbUA2esAgidlcWQK4iTuJ02SZJISolqK6I
         ajcm6V4pjI8tbzqS+D4BLaA2vTDdAQwDMhxIk89feZAroYBC5y2MEIOJEfAhdp+eFf9U
         c3EDCGim8dWi1QUDToymGj+J3ScgUktsefCH7HMA/nfUVxSj2mCQFyX6o2j9L6mZmNZA
         9SZGpnvVUh8qWeS6vnfMhkAymt3Nb0o9YA9ESM3DkPZpdGxkpEVfFqudeXsHFxal8hgo
         5WA/b1lshhfK4sIyKS/My4WVGdbyAZTuhvwLZqLmdaNEHL/1f9Hu9YV5BJJ4bl1SnoC6
         OSFQ==
X-Gm-Message-State: ABy/qLYO9S1AMC0cMbu5x1/CHdRkRLxFQD6NciKfQ+qKsKOcEApNxipl
        O+m+M4wdsWdph7qEqrmbIXDp/g==
X-Google-Smtp-Source: APBJJlEDkvoUIHO/D0QhEZRCX3+nqqe/itGjyvSt7V/a2lVWXheDA0dv8ubFiF3wyt4woukOy9JCdw==
X-Received: by 2002:a17:902:ec88:b0:1b8:59f0:c748 with SMTP id x8-20020a170902ec8800b001b859f0c748mr19557145plg.2.1689179728775;
        Wed, 12 Jul 2023 09:35:28 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b001b9df74ba5asm4172164pll.210.2023.07.12.09.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:35:28 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v4 6/9] riscv: Add zbb extension support
Date:   Wed, 12 Jul 2023 22:04:58 +0530
Message-Id: <20230712163501.1769737-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712163501.1769737-1-apatel@ventanamicro.com>
References: <20230712163501.1769737-1-apatel@ventanamicro.com>
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

The zbb extension allows software to use basic bitmanip instructions.
Let us add the zbb extension to the Guest device tree whenever it is
supported by the host.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 977e962..17d6757 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -19,6 +19,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
+	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 };
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 56676e3..8448b1a 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -34,6 +34,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svpbmt",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
 		    "Disable Svpbmt Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zbb",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBB],	\
+		    "Disable Zbb Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zicbom",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOM],	\
 		    "Disable Zicbom Extension"),			\
-- 
2.34.1

