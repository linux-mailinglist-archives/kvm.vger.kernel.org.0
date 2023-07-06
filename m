Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A59174A33A
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 19:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjGFRjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 13:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjGFRjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 13:39:06 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052F2125
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 10:38:58 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-7835ffc53bfso22487939f.1
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 10:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688665137; x=1691257137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HjOxqUEAXA51EuHpHwbjwPyrknL5nW6rIhKCbZ+yO0=;
        b=flyuRw4Ma0QXbEBJiwGKuEp8NPPcV0uiK6v72h1HT8thNv2UUvMF09S63JzVahFL2h
         fTXjQDCuFf3+G5SKkqUNKdSzYUf+8VLrGSABOTcI4mp5eGS12xFEMJArBzhWPob485m6
         +JmhR6nhOapqglmUE50YHnVzs7f/9N29Gs40ORr0a2MqayP4wQ8zt80zSEkb4sMzM1aP
         NSPZL24ufaoPzDiR0XjlAf+t6+RFhj4VZ4LVCYZZXamY1kZoC5YZVEYEWe4VQdm5Hv6W
         wpX26HSPf/YO8j94uuM7Tt6pmbK3mXXRcSi014ARRpp65D+y952Q5uPnWsPHD/nDa4El
         IvvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688665137; x=1691257137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4HjOxqUEAXA51EuHpHwbjwPyrknL5nW6rIhKCbZ+yO0=;
        b=lg6+gtA1b1h53pnSljoWQXSo1XvxVEgqldUKL1c/tR7/8FhQXVZOfZAq/Icf6M4yoJ
         34LoMbc0vx1gEeRyrZCXd8HXPVnvZukLEppw/VefIaGAa4nVX4m5ct5yXsgfYhZLiagq
         DfPg3c356++3VkBhT7n9Xkh95luc4gP6oP7IXHsQl3Y3fBUJw5Hj8sxtA5Hvf7BHTOY6
         ThwtOpHsErkFFw3uVfQOZH1wuINcEizIQyoXPZRBJAFpDFvoN7Ch5nmBJHmd7JKw3b5g
         MQfUpP9ECPq1gor9kyapF8BHHk9Z5ppS2ojLum0opiC4uTVbw6nskG7yajRKGT0tEXDV
         nvbA==
X-Gm-Message-State: ABy/qLZCqE79kIpWSuS+AwYlCyJlCrk6TER4soro3mG6lWqawtxD43iX
        SEsPU8tw1DlhqUa3De9NWoa6eQ==
X-Google-Smtp-Source: APBJJlHzMMHGkMCSj7hjlckvZBsIn/FnBpZZWMrjnB//Ak8uvHz6+gU5aWbYIzmM6KUfzgQDCaTEhQ==
X-Received: by 2002:a05:6602:3990:b0:783:42bc:cc5f with SMTP id bw16-20020a056602399000b0078342bccc5fmr4171514iob.8.1688665137172;
        Thu, 06 Jul 2023 10:38:57 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id q8-20020a0566380ec800b0042b70c5d242sm633528jas.116.2023.07.06.10.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 10:38:56 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 6/8] riscv: Add Zicboz extension support
Date:   Thu,  6 Jul 2023 23:08:02 +0530
Message-Id: <20230706173804.1237348-7-apatel@ventanamicro.com>
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

From: Andrew Jones <ajones@ventanamicro.com>

When the Zicboz extension is available expose it to the guest.
Also provide the guest the size of the cache block through DT.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 12 +++++++++++-
 riscv/include/kvm/kvm-config-arch.h |  3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 17d6757..a76dc37 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -21,6 +21,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
+	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 };
 
@@ -47,7 +48,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 	int cpu, pos, i, index, valid_isa_len;
 	const char *valid_isa_order = "IEMAFDQCLBJTPVNSUHKORWXYZG";
 	int arr_sz = ARRAY_SIZE(isa_info_arr);
-	unsigned long cbom_blksz = 0;
+	unsigned long cbom_blksz = 0, cboz_blksz = 0;
 
 	_FDT(fdt_begin_node(fdt, "cpus"));
 	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
@@ -97,6 +98,13 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 					die("KVM_GET_ONE_REG failed (config.zicbom_block_size)");
 			}
 
+			if (isa_info_arr[i].ext_id == KVM_RISCV_ISA_EXT_ZICBOZ && !cboz_blksz) {
+				reg.id = RISCV_CONFIG_REG(zicboz_block_size);
+				reg.addr = (unsigned long)&cboz_blksz;
+				if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+					die("KVM_GET_ONE_REG failed (config.zicboz_block_size)");
+			}
+
 			if ((strlen(isa_info_arr[i].name) + pos + 1) >= CPU_ISA_MAX_LEN) {
 				pr_warning("Insufficient space to append ISA exension\n");
 				break;
@@ -118,6 +126,8 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 		_FDT(fdt_property_string(fdt, "riscv,isa", cpu_isa));
 		if (cbom_blksz)
 			_FDT(fdt_property_cell(fdt, "riscv,cbom-block-size", cbom_blksz));
+		if (cboz_blksz)
+			_FDT(fdt_property_cell(fdt, "riscv,cboz-block-size", cboz_blksz));
 		_FDT(fdt_property_cell(fdt, "reg", cpu));
 		_FDT(fdt_property_string(fdt, "status", "okay"));
 
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 8448b1a..b12605d 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -40,6 +40,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zicbom",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOM],	\
 		    "Disable Zicbom Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zicboz",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOZ],	\
+		    "Disable Zicboz Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zihintpause",			\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTPAUSE],\
 		    "Disable Zihintpause Extension"),			\
-- 
2.34.1

