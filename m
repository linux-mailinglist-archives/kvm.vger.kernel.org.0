Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2697B5F94
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 05:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239092AbjJCDx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 23:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239029AbjJCDxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 23:53:22 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9780DCCA
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 20:53:10 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-5827f6d60aaso265238a12.3
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 20:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1696305190; x=1696909990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wscE/VATjNkVY1Hz8a3BGt+QWcAqJYfhFG+cRpEMwCY=;
        b=V5cqu9hKtsprSisU/UDECgPeMnk6LWXOOvjNGR3+PVsLfJjKJGg6MmbYeOXQeLf8dN
         IfUP0yRsHiKnvDVu203+WhzHe6HLYqTqbKaJB3hweaqwaP0sHx+t8g8acaZIkYngwLUt
         1nvZ79qym+KsARkqGVAovFQOb2jWIkR77HUQCRahR1lNa7sprrd4RFAvqE13Fk8bUqWr
         QKtvvLCrvI8ZDtfhD6dwFeCYbKucxT3MaJlzxtb7F8/4oKOtiyHfG1C2T7Ny+bdGUOxJ
         /uAYJbJPVQsuI4dGdzidN1vXUcsFwsBEigrhlSSon6TpVOz8OpB6rDNrAIGNchfIs1Td
         O7kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696305190; x=1696909990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wscE/VATjNkVY1Hz8a3BGt+QWcAqJYfhFG+cRpEMwCY=;
        b=tQA3f2MgA/A0HkHpnKs1AH7kOYR5BQ/2i3utdXY9hI+V6s7Oa5hg74h2Pzgjd1ei6B
         9YRMVr9InWnPrlmyNINx3DGK/FcH+w/GwuPspz8m8aBtoeAOQRi+ji8i351+7XeK8F+Y
         vreq1q7PhDhpvAFkPZgNgQV2dfCHB2X1KaGzge6AzioCWHFhsg4G89bqYNxypYKocYrP
         SxT8c49UezteCzNzfv+CEsnezrxziCqGGYQjfzydg28Yt7MRv1lt4P+colKTKSM7lqXT
         XuTup6d8tO+ngb8qoDbzSaJcAfSmspaRIlLm9jWHzMJRU6T/LAQ7upDKLy0DS87PKvQx
         Di3A==
X-Gm-Message-State: AOJu0YynBNlnw+yff/DowBzDKZJWeZK1UbeTurZsnXYF5WAQ+y1//g+h
        M6wppxBT1vkmKBoodg9n/UHBMw==
X-Google-Smtp-Source: AGHT+IGkzr82JWDhLVFUCV6JSAUgaCxQMIRqm/FYTV446+qx3qJIHp1jBs7+mM31fhfiKw48k352OQ==
X-Received: by 2002:a17:902:c40a:b0:1c7:5a63:43bb with SMTP id k10-20020a170902c40a00b001c75a6343bbmr7861019plk.8.1696305190011;
        Mon, 02 Oct 2023 20:53:10 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.84.132])
        by smtp.gmail.com with ESMTPSA id ja7-20020a170902efc700b001bf846dd2d0sm277381plb.13.2023.10.02.20.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 20:53:09 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Conor Dooley <conor@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     Andrew Jones <ajones@ventanamicro.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        devicetree@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 6/6] KVM: riscv: selftests: Add condops extensions to get-reg-list test
Date:   Tue,  3 Oct 2023 09:22:26 +0530
Message-Id: <20231003035226.1945725-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003035226.1945725-1-apatel@ventanamicro.com>
References: <20231003035226.1945725-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have a new conditional operations related ISA extensions so let us
add these extensions to get-reg-list test.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 .../testing/selftests/kvm/riscv/get-reg-list.c  | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 625118d53b74..77dc5221c465 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -48,6 +48,7 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICBOM:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICBOZ:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICNTR:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICOND:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICSR:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZIFENCEI:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZIHINTPAUSE:
@@ -361,6 +362,7 @@ static const char *isa_ext_id_to_str(__u64 id)
 		KVM_ISA_EXT_ARR(ZICBOM),
 		KVM_ISA_EXT_ARR(ZICBOZ),
 		KVM_ISA_EXT_ARR(ZICNTR),
+		KVM_ISA_EXT_ARR(ZICOND),
 		KVM_ISA_EXT_ARR(ZICSR),
 		KVM_ISA_EXT_ARR(ZIFENCEI),
 		KVM_ISA_EXT_ARR(ZIHINTPAUSE),
@@ -632,6 +634,10 @@ static __u64 zicntr_regs[] = {
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICNTR,
 };
 
+static __u64 zicond_regs[] = {
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICOND,
+};
+
 static __u64 zicsr_regs[] = {
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICSR,
 };
@@ -759,6 +765,8 @@ static __u64 fp_d_regs[] = {
 	{"zbs", .feature = KVM_RISCV_ISA_EXT_ZBS, .regs = zbs_regs, .regs_n = ARRAY_SIZE(zbs_regs),}
 #define ZICNTR_REGS_SUBLIST \
 	{"zicntr", .feature = KVM_RISCV_ISA_EXT_ZICNTR, .regs = zicntr_regs, .regs_n = ARRAY_SIZE(zicntr_regs),}
+#define ZICOND_REGS_SUBLIST \
+	{"zicond", .feature = KVM_RISCV_ISA_EXT_ZICOND, .regs = zicond_regs, .regs_n = ARRAY_SIZE(zicond_regs),}
 #define ZICSR_REGS_SUBLIST \
 	{"zicsr", .feature = KVM_RISCV_ISA_EXT_ZICSR, .regs = zicsr_regs, .regs_n = ARRAY_SIZE(zicsr_regs),}
 #define ZIFENCEI_REGS_SUBLIST \
@@ -864,6 +872,14 @@ static struct vcpu_reg_list zicntr_config = {
 	},
 };
 
+static struct vcpu_reg_list zicond_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	ZICOND_REGS_SUBLIST,
+	{0},
+	},
+};
+
 static struct vcpu_reg_list zicsr_config = {
 	.sublists = {
 	BASE_SUBLIST,
@@ -932,6 +948,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&zbb_config,
 	&zbs_config,
 	&zicntr_config,
+	&zicond_config,
 	&zicsr_config,
 	&zifencei_config,
 	&zihpm_config,
-- 
2.34.1

