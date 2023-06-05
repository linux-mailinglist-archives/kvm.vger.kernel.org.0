Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8BC72281A
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbjFEOCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbjFEOCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:02:44 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BA7E8
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 07:02:30 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1a27ffe9dcdso4538363fac.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 07:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1685973749; x=1688565749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4RvkKA5HMlJ9jiuvmt347v/0/0kHBcwrduLKYcFeXM=;
        b=o8zXo6I2enEhYoq6xCVzWR+61NgSWEADvYkoeXeWwgVXrFLO/osOBK1W9kPhuEBeRn
         Ad0fZmdfSdw4HEIn7DXaI0b5wF2T4XJiHXMMUD73QcwR3aBC6Y7EnwG7RdGCSFLYAv1l
         C9JPZflXEAfFYVNBCCvO7cMtuysosPMgKHtRiZ8DZuNdAl1SOyV0pce9tfEXeZa/HEs2
         uaqSBR1vRdfk7BnhqnFuYdpOXLL7m9/5h6CtyK5wBos3kI0n9kUdVCHGTg+ZEhQnBxEE
         SaSoAt9E56d1R4QozhDjUpv1QXN3cj+5S6NlF8UG8s/l3xi+I/h+vTQ/iWLdXz86fKDu
         2n8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685973749; x=1688565749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4RvkKA5HMlJ9jiuvmt347v/0/0kHBcwrduLKYcFeXM=;
        b=XbnasLLkooNj9Cg3+s30ghSoNQvTSmIeS0ResJwMz6n+dhZd5N6OWxe7l+TvTIHH7D
         kA1YUzrKL1QUOQggZM8fne9rH58rUu7GMfNcMgUf+qw+ZN3Mkczztey1l8vjvu5zIsfg
         07F4upJb869dNuawAY/kIgP1x8c2L5nXODRfQ+a5anj/5Cs4mVMXhKyXyH8qcIxGM4VI
         sN4/kQb81a0XIav8hnaeTKSY/Iz9Z7kK0ClKTk+cLvUeZPAtJC3ad92IKgcHTsBRqxbr
         4VGLf9tPc1U8aKLozYeBiYk7GhdZztS1wo8YI+nIuBiENE1RZmHGMdr3SlLBqDFk5h+s
         NDEA==
X-Gm-Message-State: AC+VfDwNWRMemVEM6NfwXb4/TUZzIg0qzzuX9e0sKO1xUSHlgSjBVKu5
        BiOj7YKOMB51kHfzqN0/CsXHXEipE2FUqGHhXTtrjg==
X-Google-Smtp-Source: ACHHUZ7lcWZTWvQoUMzo5DxUPH9Nfg4IozbEh8CJ57qToq9u42py0flQCRmZa4eeEvxgbuEFj/94sQ==
X-Received: by 2002:a05:6870:1ab3:b0:1a2:c149:99c7 with SMTP id ef51-20020a0568701ab300b001a2c14999c7mr6245946oab.11.1685973749219;
        Mon, 05 Jun 2023 07:02:29 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id f12-20020a4ace8c000000b0055ab0abaf31sm454787oos.19.2023.06.05.07.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 07:02:28 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 2/8] riscv: Allow setting custom mvendorid, marchid, and mimpid
Date:   Mon,  5 Jun 2023 19:32:02 +0530
Message-Id: <20230605140208.272027-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230605140208.272027-1-apatel@ventanamicro.com>
References: <20230605140208.272027-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add command-line parameter to set custom mvendorid, marchid, and
mimpid so that users can show fake CPU type to Guest/VM which does
not match underlying Host CPU.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/include/kvm/kvm-config-arch.h | 12 ++++++++++++
 riscv/kvm-cpu.c                     | 26 +++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 188125c..e64e3ca 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -5,6 +5,9 @@
 
 struct kvm_config_arch {
 	const char	*dump_dtb_filename;
+	u64		custom_mvendorid;
+	u64		custom_marchid;
+	u64		custom_mimpid;
 	bool		ext_disabled[KVM_RISCV_ISA_EXT_MAX];
 };
 
@@ -12,6 +15,15 @@ struct kvm_config_arch {
 	pfx,								\
 	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,		\
 		   ".dtb file", "Dump generated .dtb to specified file"),\
+	OPT_U64('\0', "custom-mvendorid",				\
+		&(cfg)->custom_mvendorid,				\
+		"Show custom mvendorid to Guest VCPU"),			\
+	OPT_U64('\0', "custom-marchid",					\
+		&(cfg)->custom_marchid,					\
+		"Show custom marchid to Guest VCPU"),			\
+	OPT_U64('\0', "custom-mimpid",					\
+		&(cfg)->custom_mimpid,					\
+		"Show custom mimpid to Guest VCPU"),			\
 	OPT_BOOLEAN('\0', "disable-sstc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSTC],	\
 		    "Disable Sstc Extension"),				\
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index f98bd7a..89122b4 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -22,7 +22,7 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
 	struct kvm_cpu *vcpu;
 	u64 timebase = 0;
-	unsigned long isa = 0;
+	unsigned long isa = 0, id = 0;
 	int coalesced_offset, mmap_size;
 	struct kvm_one_reg reg;
 
@@ -64,6 +64,30 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
 		die("KVM_SET_ONE_REG failed (config.isa)");
 
+	if (kvm->cfg.arch.custom_mvendorid) {
+		id = kvm->cfg.arch.custom_mvendorid;
+		reg.id = RISCV_CONFIG_REG(mvendorid);
+		reg.addr = (unsigned long)&id;
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+			die("KVM_SET_ONE_REG failed (config.mvendorid)");
+	}
+
+	if (kvm->cfg.arch.custom_marchid) {
+		id = kvm->cfg.arch.custom_marchid;
+		reg.id = RISCV_CONFIG_REG(marchid);
+		reg.addr = (unsigned long)&id;
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+			die("KVM_SET_ONE_REG failed (config.marchid)");
+	}
+
+	if (kvm->cfg.arch.custom_mimpid) {
+		id = kvm->cfg.arch.custom_mimpid;
+		reg.id = RISCV_CONFIG_REG(mimpid);
+		reg.addr = (unsigned long)&id;
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+			die("KVM_SET_ONE_REG failed (config.mimpid)");
+	}
+
 	/* Populate the vcpu structure. */
 	vcpu->kvm		= kvm;
 	vcpu->cpu_id		= cpu_id;
-- 
2.34.1

