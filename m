Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C3F6FD9A3
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbjEJIji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbjEJIjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:39:13 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0A410FA
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:38 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-54fd9c0e435so487151eaf.2
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1683707917; x=1686299917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HjOxqUEAXA51EuHpHwbjwPyrknL5nW6rIhKCbZ+yO0=;
        b=Pu/9nf7xq52NNfN/MAIwXlNcUSEkFblEW6bag2Zzfhwgsg+HX3zR0qKWF7hQafK1WC
         mBYsb8/ptNBksaJV0/RGlvUW05N07jYw149VNQUj/DhkA2oEX+R/jxgcLbThRjO1zCC5
         yqRGFTfGzMguJbw/S0xS0hyz/kSjiFPHi8JgLf6L48mobFmFD0kzxL4AXp98aGQL70yb
         WcfKu3JhEcKhdVek6RSomsQR4VtVaEuG7kjQHv3PmnfNtaQ95syYTul1jzCRubE0KyuP
         O8v44cdQF1GPCYu40z06RSDZye8XnX5cI52FtpwPKLP8/k7fRoZqHfFbm1i/r4d8upBn
         G1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683707917; x=1686299917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4HjOxqUEAXA51EuHpHwbjwPyrknL5nW6rIhKCbZ+yO0=;
        b=Xrk9WdBLIP490UrXY973B4P9D96QfP5ZI7l4qoC/8RqGiTo1ZMwXkeDZV2WZsNt7EQ
         kLJ3Js0OoiyWIw/+K50i2FgPoX3Uylk/ccttrE79xY3U0TKqCg+0OG4uVnjG5JAUhq13
         jF/c6Skyto+1C3DV2VyJrYzeElylyt5BlliTm2pk4G8bYVcTSrKO8ZX2wSpTnBtiYR/l
         SYGfffGjbYARgFNcxIkVucbxsLDz8WRyFGx1YoZfrb84ki2ia0x3oDOFlYrsuXx9anuL
         hE5X1cIbVE1bUrHVFGUPwcWhkocT9/1hcF1l6Sgz1z4eb7GTVAlgPw996IB+XQkRNibR
         CH/w==
X-Gm-Message-State: AC+VfDxXUdN4I1FeXmHZ3/ZwwEseDoLIxetAg/RdAm+0XZxUweeJlOtI
        a/oyIIhvnVyqzYbVf2xR69qXkw==
X-Google-Smtp-Source: ACHHUZ7AviZeS/UgPri0IkvH2z3CmhkH5XtCxoC8/0bfZGpaDbBjFNyhHyUcDOW1vbmh4yVbElWUMg==
X-Received: by 2002:a4a:301a:0:b0:547:6a79:18cb with SMTP id q26-20020a4a301a000000b005476a7918cbmr2344887oof.9.1683707917543;
        Wed, 10 May 2023 01:38:37 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n12-20020a9d64cc000000b006a65be836acsm6049711otl.16.2023.05.10.01.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 01:38:37 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 6/8] riscv: Add Zicboz extension support
Date:   Wed, 10 May 2023 14:07:46 +0530
Message-Id: <20230510083748.1056704-7-apatel@ventanamicro.com>
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

