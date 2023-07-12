Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A3C750EA9
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjGLQf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbjGLQfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:35:25 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9042106
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:19 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-666e64e97e2so4083155b3a.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689179719; x=1691771719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4RvkKA5HMlJ9jiuvmt347v/0/0kHBcwrduLKYcFeXM=;
        b=i6bU3IdX6P3peZGO6s5aHiq7SdfIZPggBvx9AeZwgktOhBFfI0heBLmBIeQkauuuCa
         Zp4gGmatzh+yNvNTWEyNht8jL00dnTVZwioedx//YcP86vBj86p5Dhr4ad/Gg2gnc7oM
         cgjv5qBgNE5s96sB4gJvMgZjy/2/CCWRnusgb2Z6pxla2wc8hC5GDteGJfw1oAJs21Ay
         aSfzF8HGGUM0UCuDYDBfwaMSHYqyre6fq/xt0p7WoEwHVVSwTwR1GfDQsNlNH1cdB8PC
         FvhxMtyXbNWv/1k1jN4OUfewJQsv5DB8NYmQiTc6qL5rlEj3DE0MbII7woCIgUOWWjnw
         zBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689179719; x=1691771719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4RvkKA5HMlJ9jiuvmt347v/0/0kHBcwrduLKYcFeXM=;
        b=duZN46Sar37rR/RGjADPxCTcsNGgS7qvfK1veB8PW234T/Gt2888viLqNX1efXR+qV
         0nu+xCi3OKB9CSSEixBOiyaTLW8yeD7yDUeqSGNwvxFFSjStGJwXD+gAuwfUW4FNiJ7H
         +7z7PhUjgUxiTOgJM0IHBEKaFXk2Kv+9JtGtEgI929iS8wB6ck7l2O+H8yUPu6y3Y4AU
         3f7uqsCoRvAp/ztN647v0vHaB2XfyN67c9Li88427Rj2ON2HUGkNKNNCbkO5JFWVaOjF
         vDXckk7i9bAAorl07K89jlz1Nynbkj/mg0Zcby/5ngvsKo9jJQF6pCHR/eCozuaBh8R0
         ZXpQ==
X-Gm-Message-State: ABy/qLa5+UAShQsfINlyRhig3kCvHyZV3vtERWYAfi5yYZ5ScMogZCIB
        cXN7zGPcCcas7e+ANchP1yN9Mw==
X-Google-Smtp-Source: APBJJlE/hihhO8geMWnZ8IRIhgTyLw9ArOL5hqaCYHZUX6qB4c3bnpKgsyFmBNJb9T6KvG9g1fVuMg==
X-Received: by 2002:a05:6a20:6a1f:b0:132:7eee:184 with SMTP id p31-20020a056a206a1f00b001327eee0184mr4599856pzk.0.1689179719240;
        Wed, 12 Jul 2023 09:35:19 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b001b9df74ba5asm4172164pll.210.2023.07.12.09.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:35:18 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v4 3/9] riscv: Allow setting custom mvendorid, marchid, and mimpid
Date:   Wed, 12 Jul 2023 22:04:55 +0530
Message-Id: <20230712163501.1769737-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712163501.1769737-1-apatel@ventanamicro.com>
References: <20230712163501.1769737-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
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

