Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81C86E84C1
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbjDSWVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbjDSWVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:21:11 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4449AF0F
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:19:51 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b5c830d5eso338428b3a.2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942725; x=1684534725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V944izAfHfvPXt2SodYy8axfAv3FUhh/YjA49qCII3Y=;
        b=WToiBYM90+kXSHR4f4lcMC2do7CnNE609AkBJ9ILRsQSAqLQhvGE4fka9RZc7XkmOV
         nVSgbPgR0g26+R9aOz7prZ0ZYw39dV9KxvmHBGDvRgR8MR74QfL1ZHIt8XSWqAKcLN8r
         0f6Tq006zXgK2g4OuuillctnBCZLY1xVWuRZMqYQdfd3ybKvutxZLqu19QqqHmXC8ODS
         KoYa4jRQnyk9O92MghnQdSKIAU/AWL4fTpgXKATBvPLDFP59BwJ0oeGTqTbRTShwnDj2
         1+Ojob0S1CfD+/Tznk4BIbXVZIp9qmP+FcBhkm6vxxe63VSq5U1n2NJ31boDb5/Auf9y
         qI8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942725; x=1684534725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V944izAfHfvPXt2SodYy8axfAv3FUhh/YjA49qCII3Y=;
        b=Q8CzpHJECYXQEi/whlA8XX27BLP8eSMHTffMnqw5T1G86LgEKviHwWjTzCb1Kxucxh
         B9AIQ/bHPZjD5zo/A0pFRYptWCwM9TqdEMgUsOuIwwDkoWDwfve8pyeKymzjiZdLn/kO
         S0fUCOmW0nZ277jPO1CcPjFlQlYiVszGL+GwPk9WkL7uBEBYGza6/gVKxmccWkbOURWK
         p1e0RqbxkfGFLmJNH4rXmLU2YQvdi949u/H9yguEGWpscbSt2nongVjIynt+5IWVCgx9
         cyEJTM2VA6+knrxKTDiNvWCVNH1wcqhgtKajAkZOUVVTVyh6kCEZIwH8VBoGfebjiOc0
         va9A==
X-Gm-Message-State: AAQBX9cujvPl9JpajHX7/lwOQeu/4eIHwL+s66WycyI6oaLKrq1UcV8N
        2qfpxsDozHkEqQTx346DrUQvQQ==
X-Google-Smtp-Source: AKy350Z1qByMTGJhiqV3zdWqTg/zhHnUn1VfTimSG0DF0as79Rscca2Gz4ZKZ2NL/Pi2zbK61ibEFw==
X-Received: by 2002:a17:903:2409:b0:19e:839e:49d8 with SMTP id e9-20020a170903240900b0019e839e49d8mr6224177plo.59.1681942725072;
        Wed, 19 Apr 2023 15:18:45 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:44 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 34/48] RISC-V: KVM: Initialize CoVE
Date:   Wed, 19 Apr 2023 15:17:02 -0700
Message-Id: <20230419221716.3603068-35-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CoVE initialization depends on few underlying conditions that differs
from normal VMs.

1. RFENCE extension is no longer mandatory as TEEH APIs has its own set
of fence APIs.
2. SBI NACL is mandatory for TEE VMs to share memory between the host
and the TSM.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/main.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 842b78d..a059414 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -102,15 +102,12 @@ static int __init riscv_kvm_init(void)
 		return -ENODEV;
 	}
 
-	if (sbi_probe_extension(SBI_EXT_RFENCE) <= 0) {
-		kvm_info("require SBI RFENCE extension\n");
-		return -ENODEV;
-	}
-
 	rc = kvm_riscv_nacl_init();
 	if (rc && rc != -ENODEV)
 		return rc;
 
+	kvm_riscv_cove_init();
+
 	kvm_riscv_gstage_mode_detect();
 
 	kvm_riscv_gstage_vmid_detect();
@@ -121,6 +118,15 @@ static int __init riscv_kvm_init(void)
 		return rc;
 	}
 
+	/* TVM don't need RFENCE extension as hardware imsic support is mandatory for TVMs
+	 * TODO: This check should happen later if HW_ACCEL mode is not set as RFENCE
+	 * should only be mandatory in that case.
+	 */
+	if (!kvm_riscv_cove_enabled() && sbi_probe_extension(SBI_EXT_RFENCE) <= 0) {
+		kvm_info("require SBI RFENCE extension\n");
+		return -ENODEV;
+	}
+
 	kvm_info("hypervisor extension available\n");
 
 	if (kvm_riscv_nacl_available()) {
-- 
2.25.1

