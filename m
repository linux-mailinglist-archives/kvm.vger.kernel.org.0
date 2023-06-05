Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40CE72281F
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbjFEOCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbjFEOCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:02:51 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F4DED
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 07:02:48 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-19f3550bcceso4460330fac.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 07:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1685973768; x=1688565768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HjOxqUEAXA51EuHpHwbjwPyrknL5nW6rIhKCbZ+yO0=;
        b=lW9cvtfZskkGp5uk6upxO2QtwNTY00FHKRX1ph8h+MGKrbMkQtzh/rXaShFp2KWSJp
         eDwZMwt/wKJFXnVpI7NOuagXjkqUVWxZ0Qr8nPWbsAa96GCjlWHFlPDwnvc/c1VYT6WB
         JK3YG9ym8bYC/3PcvOwv+OYgKIA1bp9c845XKVKY4INyUpaYyhLd/Tp+/YXpsybgcc3d
         fhbQ3Umlcan6EQvm64aWyQqyv9AELM5du0wXANTREZUKGhgvYQRrlpi5GbOixDc1ltOG
         PEmqKVz+tj4EQC6m0xY/stmGE95nzXylM86loye/DWJr5GkxIlACwYdULEBwlhGJ8CLy
         vCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685973768; x=1688565768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4HjOxqUEAXA51EuHpHwbjwPyrknL5nW6rIhKCbZ+yO0=;
        b=ahFoAgdmgBdYj32Ou0FQ0eDBIEtKjOlqNayaua2xF6exfzZmrAY3+ma4+kPbbjtVdH
         Lg2dpw58IpyBgmt7PwvrGV0u1n4XvOVt4+Lgb6MUYoD3D+L5w7BStcSB/LIDXvqPq05P
         WExmJ6X3UUEGTQoi2jJopY+V2Xtv6FY8rTge20iKBwiYtHEkVtS151DRofp37ojJv8C+
         90OuuIpisIsOa40tQseFBcA3MBwJyR/G/PZjXiU3VDyElzU5lgWblwuIwNwbVAgOYwsw
         IcU0tgy1ktIq7G6B/d0f0Ag1SR6rSsf6PqkKQ0lT/3HKmWnVXFtrA4JijD5tRRSAWkBp
         C5GA==
X-Gm-Message-State: AC+VfDwzLGpLPU8X2301L15Q2lZD+6nCqyccjYe+ZgunaXpzVEOw6HF8
        D8JrQm4okwaaawa9pkkbH79yow==
X-Google-Smtp-Source: ACHHUZ5S3ezKBU24Z7ud3Aie/qSd4sz3SGXpgFD598/z9lcxRbvJ1aP6/Bv1pXLMlx3AJq6OVOjfoQ==
X-Received: by 2002:a05:6870:4295:b0:19e:d407:a753 with SMTP id y21-20020a056870429500b0019ed407a753mr9471865oah.46.1685973767948;
        Mon, 05 Jun 2023 07:02:47 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id f12-20020a4ace8c000000b0055ab0abaf31sm454787oos.19.2023.06.05.07.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 07:02:47 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 6/8] riscv: Add Zicboz extension support
Date:   Mon,  5 Jun 2023 19:32:06 +0530
Message-Id: <20230605140208.272027-7-apatel@ventanamicro.com>
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

