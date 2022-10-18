Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF10B602DFC
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 16:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJROK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 10:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiJROKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 10:10:11 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB016BCF7
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:58 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h185so13391326pgc.10
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBfZW7huZRaUPHCG2pJCuC4fPZwNRaIcm45ZbImuxjw=;
        b=YKJlhWUIVRtbhA7RWD520FMIgOj6eHf3PqSSdsEdl5U2hpaO9vIMbakcJOMFBHkY7J
         5aqwMrNugYJoxaIwILiz6Z2VyIgsZ0eo4RjS/Ki3BFuCF/qLNzWLPTxkRLwgWR45vyBk
         wLurMDu33hjYgfzuomHUvXqHF++BA9JbDLttpsV8u1L4pbcdY+lUFbIffkioRzImFUfG
         g9xhMqo4gtX2Aa1mEYGXA0n4uQ97/jhiWyrlzXFsfEzmN5vUQJVMYt3pAmfON82Rymi6
         AoiF0Q4XSIHycMWEbxPZqJYYMRaPth1fsrQUeYV8eJnvD2x0fh11q1ouo0Q2kckIA/pG
         VwwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bBfZW7huZRaUPHCG2pJCuC4fPZwNRaIcm45ZbImuxjw=;
        b=cH6YLDnSAukl7ZNOlHaQAeqnT9ufA79GDdsaNkrN8BoaX+KfUXii9zsTPXmdFHN4gn
         X9jX8oWGLf8CFOZAM9T1pQdLHL0m9mKTsIizGZhzZ/+NJpd35rtBOgz95YSheVTE2Co/
         8vLCCr4+GNvayzGkwskVZ1RJHybf5PGo44yOE8DyKAr7Gsu0352zrlmZNkQP1V0W4ZCT
         AbOhm6wU0V2UDoWNzqUx1vopJq/2cjclvWhLFYl+OBwipbz4EfyoBsvwh/h69pIvzuhH
         aEk2FAEiuJ5mM2W6MODy/rUc8YjgqY8npIar10X7O5O4eRvyZ4CQTOPgMOU14GsWtpY8
         qM6A==
X-Gm-Message-State: ACrzQf2vErUovNiVQLzRuDgo4dlD85KIHV/VLtof+5rqK6pFhflaGQDB
        BGMBhIFbdxfIjvdAH91XbU7F2Q==
X-Google-Smtp-Source: AMsMyM7LY+/379v3cJTxQCUTe6dS8kHloHhPV0vLXNyljnYJBlP2Q5KTETHo8oIz+7x/bMvxZnEjdQ==
X-Received: by 2002:a05:6a00:1da1:b0:563:2e07:db1b with SMTP id z33-20020a056a001da100b005632e07db1bmr3391433pfw.22.1666102197120;
        Tue, 18 Oct 2022 07:09:57 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.86.161])
        by smtp.gmail.com with ESMTPSA id z15-20020a17090a170f00b002009db534d1sm8119913pjd.24.2022.10.18.07.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 07:09:56 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 6/6] riscv: Add --disable-<xyz> options to allow user disable extensions
Date:   Tue, 18 Oct 2022 19:38:54 +0530
Message-Id: <20221018140854.69846-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018140854.69846-1-apatel@ventanamicro.com>
References: <20221018140854.69846-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By default, the KVM RISC-V keeps all extensions available to VCPU
enabled and KVMTOOL does not disable any extension.

We add --disable-<xyz> command-line options in KVMTOOL RISC-V to
allow users explicitly disable certain extension if they don't
desire it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         |  8 ++++++++
 riscv/include/kvm/kvm-config-arch.h | 18 +++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 30d3460..3cdb95c 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -80,6 +80,14 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 				/* This extension is not available in hardware */
 				continue;
 
+			if (kvm->cfg.arch.ext_disabled[isa_info_arr[i].ext_id]) {
+				isa_ext_out = 0;
+				if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+					pr_warning("Failed to disable %s ISA exension\n",
+						   isa_info_arr[i].name);
+				continue;
+			}
+
 			if (isa_info_arr[i].ext_id == KVM_RISCV_ISA_EXT_ZICBOM && !cbom_blksz) {
 				reg.id = RISCV_CONFIG_REG(zicbom_block_size);
 				reg.addr = (unsigned long)&cbom_blksz;
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 526fca2..188125c 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -5,11 +5,27 @@
 
 struct kvm_config_arch {
 	const char	*dump_dtb_filename;
+	bool		ext_disabled[KVM_RISCV_ISA_EXT_MAX];
 };
 
 #define OPT_ARCH_RUN(pfx, cfg)						\
 	pfx,								\
 	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,		\
-		   ".dtb file", "Dump generated .dtb to specified file"),
+		   ".dtb file", "Dump generated .dtb to specified file"),\
+	OPT_BOOLEAN('\0', "disable-sstc",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSTC],	\
+		    "Disable Sstc Extension"),				\
+	OPT_BOOLEAN('\0', "disable-svinval",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVINVAL],	\
+		    "Disable Svinval Extension"),			\
+	OPT_BOOLEAN('\0', "disable-svpbmt",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
+		    "Disable Svpbmt Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zicbom",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOM],	\
+		    "Disable Zicbom Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zihintpause",			\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTPAUSE],\
+		    "Disable Zihintpause Extension"),
 
 #endif /* KVM__KVM_CONFIG_ARCH_H */
-- 
2.34.1

