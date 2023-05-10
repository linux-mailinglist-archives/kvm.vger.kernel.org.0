Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E74D6FD99F
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236754AbjEJIjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236756AbjEJIjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:39:12 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F2E7295
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:14 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 46e09a7af769-6ab028260f8so2271747a34.3
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1683707894; x=1686299894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4RvkKA5HMlJ9jiuvmt347v/0/0kHBcwrduLKYcFeXM=;
        b=DTQ0yY9TJi7yvJqp5vPKDUqpu6nKpgJaTTOwcreSy88+V9VkyMdk8e9HcPVPqkVEp6
         zXeFQa9vMSM2N/c9jc7bLreMAXnHohtxZgT13jgSxQnw+hIxNhgTvnwSGBP6bBeOlRVO
         zif7/pw3wBfO5ai3QBu3ZMCjpF8SHIuKCLzp8WpCNllH2fU5+k1ox583JHSsdiEqueK0
         vSeFcjq9o9mH+7jpmUup1zcp6ziUZTAdeLSAlsVM4kSh97kuHHh/kNIIbu5xf/h+zasA
         +/Ty5a14nmbjk5CqcRgtBf9CEgStm5L7iCYyXvi/cRCvUi0a6V6bEGEjIsBBwGWQ8Nse
         e/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683707894; x=1686299894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4RvkKA5HMlJ9jiuvmt347v/0/0kHBcwrduLKYcFeXM=;
        b=GVan1RkIXooK+Bl+QJg/w+8j5Ma6r7yDcD2FXKyU3ouVmm0Rq52dryafIm/WuX1SJi
         h7/jicbiNlHXj+lR3puZxcGY+Fzg2pQ5Y7hm/y+kpr4jHYnrLEo6Mb2dwRnEs1SRxE4E
         PJaAdrWOHGLcy3IGJzNLkbExgh8W05kZhRSp4kBXOC6oHm8I3TD7eevhZo2ItV9fU78N
         cHY0sZacqarieJtf7IgFsO2t9fKlyqXbz3IKgpryqlX7MAm/NlML+dBh4egDiuMkvFrh
         c/mzlX9rJ1UyEFyJFcY2e2cpvf2Qip6Cka0achdfgLFGLBV+rTlDDTBfJIP+rCGYfsaI
         KBVA==
X-Gm-Message-State: AC+VfDwceh/q+woFg1sj6uPYKNuaFQPPKPmd8ohsGBHvNvFALfP1X9OG
        PJHWOyu4HD1OaqB9cSZH8tzQEA==
X-Google-Smtp-Source: ACHHUZ6/tMvYvyRRTVtNNnKEidxzHrU87OtybXKSJHZcPBMLLRjj2Jl/l7tXINaB99wPaocChgzxuQ==
X-Received: by 2002:a05:6830:1256:b0:6ab:1a07:e61a with SMTP id s22-20020a056830125600b006ab1a07e61amr2497994otp.9.1683707893810;
        Wed, 10 May 2023 01:38:13 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n12-20020a9d64cc000000b006a65be836acsm6049711otl.16.2023.05.10.01.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 01:38:13 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 2/8] riscv: Allow setting custom mvendorid, marchid, and mimpid
Date:   Wed, 10 May 2023 14:07:42 +0530
Message-Id: <20230510083748.1056704-3-apatel@ventanamicro.com>
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

