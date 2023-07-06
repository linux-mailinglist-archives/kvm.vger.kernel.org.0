Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5169B74A335
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 19:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjGFRi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 13:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjGFRir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 13:38:47 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBED1FE8
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 10:38:37 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-345df4e68afso3549645ab.0
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 10:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688665116; x=1691257116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4RvkKA5HMlJ9jiuvmt347v/0/0kHBcwrduLKYcFeXM=;
        b=a/wMiLR/Fj10x0KocTj8ukW8achJVs0fD21O8+oelLoE1eJAqX/bnE7SjMbhi2xfW6
         OlRQMdnmIEvTfbOr/UNp6X9FF6dZ6bX0j6/HD5U8IzoZcBlNSX1i+vP/qrEL6G5Yu1wZ
         1VNNOXceekZUs/DNt1DWVDxUTZowuXM2FfUTCGLwHzet0s1LAs3ZLn0CBr9rOdLq+Zgn
         34zW05zHOyD8MP7CKxwljz3pBYxSIbOzxz0XyjKwoJm9zRKdfMTw5OhTqPVCOESj+WPh
         aw1XexQ3AdkMKAUC6/9bmBhi43OGo0mlD/G3FHHQDk1Nj799dagrd7Gp6kUxOWff/Fu3
         IGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688665116; x=1691257116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4RvkKA5HMlJ9jiuvmt347v/0/0kHBcwrduLKYcFeXM=;
        b=Bt08ZbdiQVrHVAX6RRRB67Tw21bmKja+m0oobY1f9re1/vSEvEunDNj9dNhBO8qAdG
         vIfOiftZpxfUKgBpJ6fTyHb9OzLITOKaLlGu/mCuat/M8ODeQ7m9I/FGrB7okpue4FR/
         MKLaOkfzeiJh7raQ+5bGjfV0QWi3UhyDB4wJyLrlcIy2VEHtfGfp6A924zCFdnOrkADY
         feUQbp2fUUcztGu5aeuUjaj4QrAT2w4J6/9UXJw2fFkmwxDRqHD6fTcafa6Yh7e8ehoI
         gzKt7alkmMkxU8+GR22L02NNra6Chj55ek6ZX3swmtYRBoCULDkI1+ajjmp+pAOjOBuD
         9mNw==
X-Gm-Message-State: ABy/qLbkenR7txrzGWA0sxV07/gRLLiQS6LK+q8I1LZCj6RHLXqXkGxs
        OJLxGE2eGEF8NiJ5Wql2U6COqg==
X-Google-Smtp-Source: APBJJlHPi63G4ghKH2j2yUusZJg9UQGqLOCn/QM9/Ch6a2hDUV8cfzA7Y7DbI7AAWZEVbGqbBJ9oPg==
X-Received: by 2002:a92:c6cf:0:b0:345:ab58:5afd with SMTP id v15-20020a92c6cf000000b00345ab585afdmr2752499ilm.16.1688665116617;
        Thu, 06 Jul 2023 10:38:36 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id q8-20020a0566380ec800b0042b70c5d242sm633528jas.116.2023.07.06.10.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 10:38:36 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 2/8] riscv: Allow setting custom mvendorid, marchid, and mimpid
Date:   Thu,  6 Jul 2023 23:07:58 +0530
Message-Id: <20230706173804.1237348-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230706173804.1237348-1-apatel@ventanamicro.com>
References: <20230706173804.1237348-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

