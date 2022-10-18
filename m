Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42B1602DFA
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 16:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiJROKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 10:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiJROKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 10:10:06 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918B93D581
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:54 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id d7-20020a17090a2a4700b0020d268b1f02so17483825pjg.1
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1cy0stZuu2l4nnpvXT4UlpcLfIirj5wSYAUm2mTZJyw=;
        b=ZZx8dwkeAOQf7yuhCmvnrUZkf8voMFX3tRc6mOr5UsDmxcn7Z2Ew7Du/cdEmYU8fdT
         uweTb8hDJ0yinDnxGVhLHwT8bsYSYou38ogth3IOupHQitKtISLKj3oz5CiOpyImw8AQ
         9G56yLF3DKMCiMOCM8LKhp49kcJio3P7+7cpckS0/JWq3CXp6pyPGqN7pwcLpa3aR4wU
         vEysuC/LqiMecsKNng9hJOMLMhSl0Nv3GIIL53CEvDVlDsAtEf/9Uj5CqvyYZ6mwgW+E
         hvB2l4rO7fpSkIn2YRYrm9fAcTO8dbFwdEQR30rBz7dZWn+8a+P4dPOTCQcGEvhx67gE
         41+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1cy0stZuu2l4nnpvXT4UlpcLfIirj5wSYAUm2mTZJyw=;
        b=4Hz3saNHQhHoVxrqjxqBIuKpBLGOY0CGVTa2MAtKHsQ2qjIB4t923QONdh9GK0Bgf+
         m8GmvZC9fPfGiODm/bwyGlSNxodR34Eih2HaXAAWOXBOd6vN5ut3NoAS+Q3AQ7T6Vwqr
         hhQqZuEoQqS+D/ECA9fh6qEYakhUoQHQhA9U7DMaoEooxjPRwyUQ/8pP7mtKMg6JCH7t
         Z3vz01yMomBvl8HF6scjjZpsQTO+cRfQTyzqeHpu1ciWVNEWZK+OkgiBQKq+54TwJuhs
         +UqKYl2HiUfFTS3L18HHflV+CetwtezweLLkKeW3s70NI8DPkS9TxCaCrdTa7b1Ye/SG
         eQOA==
X-Gm-Message-State: ACrzQf3fW9mY8XER1LvVV6cTtUBQxQGOPa31wn/y+N9RziAzA3/2hjxW
        K3pS8R7qVoeVhZDW0gxjwN66RQ==
X-Google-Smtp-Source: AMsMyM4dT3kMvVN4ur7grZ5s9q3k1fflzJgyU2QWiYWQIBD6hinpPqMooINWXzFZvvfqSAH5bRxcFg==
X-Received: by 2002:a17:90b:1c06:b0:20a:f070:9f3c with SMTP id oc6-20020a17090b1c0600b0020af0709f3cmr3884771pjb.151.1666102192414;
        Tue, 18 Oct 2022 07:09:52 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.86.161])
        by smtp.gmail.com with ESMTPSA id z15-20020a17090a170f00b002009db534d1sm8119913pjd.24.2022.10.18.07.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 07:09:51 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org,
        Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH kvmtool 5/6] riscv: Add Zicbom extension support
Date:   Tue, 18 Oct 2022 19:38:53 +0530
Message-Id: <20221018140854.69846-6-apatel@ventanamicro.com>
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

From: Andrew Jones <ajones@ventanamicro.com>

When the Zicbom extension is available expose it to the guest.
Also provide the guest the size of the cache block through DT.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 8d6da11..30d3460 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -19,6 +19,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
+	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
@@ -44,6 +45,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 	int cpu, pos, i, index, valid_isa_len;
 	const char *valid_isa_order = "IEMAFDQCLBJTPVNSUHKORWXYZG";
 	int arr_sz = ARRAY_SIZE(isa_info_arr);
+	unsigned long cbom_blksz = 0;
 
 	_FDT(fdt_begin_node(fdt, "cpus"));
 	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
@@ -78,6 +80,13 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 				/* This extension is not available in hardware */
 				continue;
 
+			if (isa_info_arr[i].ext_id == KVM_RISCV_ISA_EXT_ZICBOM && !cbom_blksz) {
+				reg.id = RISCV_CONFIG_REG(zicbom_block_size);
+				reg.addr = (unsigned long)&cbom_blksz;
+				if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+					die("KVM_GET_ONE_REG failed (config.zicbom_block_size)");
+			}
+
 			if ((strlen(isa_info_arr[i].name) + pos + 1) >= CPU_ISA_MAX_LEN) {
 				pr_warning("Insufficient space to append ISA exension\n");
 				break;
@@ -97,6 +106,8 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 			_FDT(fdt_property_string(fdt, "mmu-type",
 						 "riscv,sv32"));
 		_FDT(fdt_property_string(fdt, "riscv,isa", cpu_isa));
+		if (cbom_blksz)
+			_FDT(fdt_property_cell(fdt, "riscv,cbom-block-size", cbom_blksz));
 		_FDT(fdt_property_cell(fdt, "reg", cpu));
 		_FDT(fdt_property_string(fdt, "status", "okay"));
 
-- 
2.34.1

