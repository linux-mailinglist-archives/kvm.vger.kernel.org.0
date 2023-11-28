Return-Path: <kvm+bounces-2622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8697B7FBD5F
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B76361C21423
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7BA5C088;
	Tue, 28 Nov 2023 14:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="NsrGMrP6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AE31BEF
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:54:45 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-285699ebabcso3658526a91.0
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183285; x=1701788085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AfMEYFNY4t0wNlr3hA5A82AOB/2KSEl3zEL3USkF3fk=;
        b=NsrGMrP6iaqZHR3mxy+8keIe+BfQPUPdJjoiQD8MlHSRLUhdgIjThBfZ84aRcGSnAT
         xCKfpaavnwehytlR1/3s6W+a5b+BMqZvC0mTuIb4xTg929VLcF+xrLWPqAGMj9JjmpSE
         ZbLyMxNnn4HNg/1Z2HMfxU2HrGYqtXDvxlHscwRrGc7AkxqAqQwAn+VepqvRrYqMf+du
         pARUIbiTNgquZf9Z3n6mfAxMo76o94DOSXcoWEZbD3TB/K2lrP6EBNF4/Q7wvTwLXwvx
         22fm1bf1eqSnNY88Gn/CgN/nBrkUPmcUELvD4fH417Y+shMzzNkZrSAeNYdkvs9Ptpqo
         Yt5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183285; x=1701788085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AfMEYFNY4t0wNlr3hA5A82AOB/2KSEl3zEL3USkF3fk=;
        b=rLktbY+iB49B71+XArmQhfhr7MeNXpLQCtHOdBaEtOHJG9Wt6HoQvEl40CKh9yQ0tq
         HWs40FUgyX2AGcTbsA7zZDEN/o8Gji4lcaXX4uH6Q/2h6KLkb5XwVN3U2zlFEXk2MkFx
         zpvVCxWyr0rPQ1KEDsom5foAcF20SG1jcpg9DNzjOUIijUmRgFQ4Vn1LAIJHaQCLFV8J
         e1pCxNJFas8ms9/W0MEs9V5bF578Cfs8rT++ErmeLYh50GEPF9wW5DduUoI762WWX87x
         Gr0Q6vp/l3SRcGFBs/77BUPRGyBd0it8vgKrhFW9V4eC48qWQaLaq8zUXgeY4gtFu6NZ
         2T9A==
X-Gm-Message-State: AOJu0Yw+/RNIlA0UsjbIjLT0YoRiPMP4kH7LfV2bpNJXO4F8U+cprHlr
	XwtOpLaqUb+VJPdYk5q6Vr2Egg==
X-Google-Smtp-Source: AGHT+IE6h2fUA1tLYkF7nxYU5YCCr84rmf1flbtFaYMziBR2dmaX4sBzK4UtuEfEDYJpjxQHNuwUGw==
X-Received: by 2002:a17:90b:1b07:b0:285:9cce:a63f with SMTP id nu7-20020a17090b1b0700b002859ccea63fmr17562386pjb.23.1701183284854;
        Tue, 28 Nov 2023 06:54:44 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001bf11cf2e21sm10281552plg.210.2023.11.28.06.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:54:44 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Anup Patel <anup@brainfault.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 07/15] KVM: riscv: selftests: Add vector crypto extensions to get-reg-list test
Date: Tue, 28 Nov 2023 20:23:49 +0530
Message-Id: <20231128145357.413321-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128145357.413321-1-apatel@ventanamicro.com>
References: <20231128145357.413321-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM RISC-V allows vector crypto extensions for Guest/VM so let us
add these extensions to get-reg-list test. This includes extensions
Zvbb, Zvbc, Zvkb, Zvkg, Zvkned, Zvknha, Zvknhb, Zvksed, Zvksh, and Zvkt.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 .../selftests/kvm/riscv/get-reg-list.c        | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index aabc05e4b02b..04ff8836c474 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -64,6 +64,16 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZKSED:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZKSH:
 	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZKT:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZVBB:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZVBC:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZVKB:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZVKG:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZVKNED:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZVKNHA:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZVKNHB:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZVKSED:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZVKSH:
+	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZVKT:
 		return true;
 	/* AIA registers are always available when Ssaia can't be disabled */
 	case KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_AIA | KVM_REG_RISCV_CSR_AIA_REG(siselect):
@@ -392,6 +402,16 @@ static const char *isa_ext_id_to_str(const char *prefix, __u64 id)
 		KVM_ISA_EXT_ARR(ZKSED),
 		KVM_ISA_EXT_ARR(ZKSH),
 		KVM_ISA_EXT_ARR(ZKT),
+		KVM_ISA_EXT_ARR(ZVBB),
+		KVM_ISA_EXT_ARR(ZVBC),
+		KVM_ISA_EXT_ARR(ZVKB),
+		KVM_ISA_EXT_ARR(ZVKG),
+		KVM_ISA_EXT_ARR(ZVKNED),
+		KVM_ISA_EXT_ARR(ZVKNHA),
+		KVM_ISA_EXT_ARR(ZVKNHB),
+		KVM_ISA_EXT_ARR(ZVKSED),
+		KVM_ISA_EXT_ARR(ZVKSH),
+		KVM_ISA_EXT_ARR(ZVKT),
 	};
 
 	if (reg_off >= ARRAY_SIZE(kvm_isa_ext_reg_name))
@@ -781,6 +801,16 @@ KVM_ISA_EXT_SIMPLE_CONFIG(zkr, ZKR);
 KVM_ISA_EXT_SIMPLE_CONFIG(zksed, ZKSED);
 KVM_ISA_EXT_SIMPLE_CONFIG(zksh, ZKSH);
 KVM_ISA_EXT_SIMPLE_CONFIG(zkt, ZKT);
+KVM_ISA_EXT_SIMPLE_CONFIG(zvbb, ZVBB);
+KVM_ISA_EXT_SIMPLE_CONFIG(zvbc, ZVBC);
+KVM_ISA_EXT_SIMPLE_CONFIG(zvkb, ZVKB);
+KVM_ISA_EXT_SIMPLE_CONFIG(zvkg, ZVKG);
+KVM_ISA_EXT_SIMPLE_CONFIG(zvkned, ZVKNED);
+KVM_ISA_EXT_SIMPLE_CONFIG(zvknha, ZVKNHA);
+KVM_ISA_EXT_SIMPLE_CONFIG(zvknhb, ZVKNHB);
+KVM_ISA_EXT_SIMPLE_CONFIG(zvksed, ZVKSED);
+KVM_ISA_EXT_SIMPLE_CONFIG(zvksh, ZVKSH);
+KVM_ISA_EXT_SIMPLE_CONFIG(zvkt, ZVKT);
 
 struct vcpu_reg_list *vcpu_configs[] = {
 	&config_aia,
@@ -814,5 +844,15 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_zksed,
 	&config_zksh,
 	&config_zkt,
+	&config_zvbb,
+	&config_zvbc,
+	&config_zvkb,
+	&config_zvkg,
+	&config_zvkned,
+	&config_zvknha,
+	&config_zvknhb,
+	&config_zvksed,
+	&config_zvksh,
+	&config_zvkt,
 };
 int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.34.1


