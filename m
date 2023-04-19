Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62416E8478
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjDSWRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjDSWRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:17:35 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D79D1718
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1a52667955dso5427045ad.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942654; x=1684534654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TviUiXCC6v39lMS4rfPLGE9Pfx0aaxYAF0PLkJZJ+44=;
        b=fw3FXTdDZVAQaqNcpqxhJ5jCbeJxZbbRCeUP7dUA0xboMzGhByaEInJPZwYw9bXQXk
         ARHWS0qP1pZrTXclentFqb6h5U2ua9sUZm6vZcXmwvDFczjrVihV2Nra1Jc2/WF5XyU2
         0JadbkEFEI0//guHLR6qxF3JNYLlwaQIZD991cfubV5PenBiFCNtb6hgKaPgRSq66vCg
         e+VFqjLE6civs190GuIRI3K+ZsW+0KEkHzSOhGggkx8qfJ2wZO5KlkmScX+zwalNjqk6
         RuMOo25mdsFietap8z25HKARP1geAiwoigenSaj60oBOp8w+6PxBWZ/NPdxHu1rx5LuB
         U5bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942654; x=1684534654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TviUiXCC6v39lMS4rfPLGE9Pfx0aaxYAF0PLkJZJ+44=;
        b=VVB9T4ggVw4aWYjwsgYhoxU5Q4oPMqnw81Yhs6lWm5U9F+48SORAbviSV2DAZm5pgv
         MZ+94X1BGNL8UwwTAtwwX24bitDtSDz8QJu4nLGaQ8HuasPD52LLp6xn+pP+D+gfM3QS
         +Mim9rQzXARfB4SlFCwzoVcIYAFaGLqQBJCSVNgoC06leGDMay6BeC7XCIIp1ABBwv05
         TcuguUklDLPTJC4QAQ984f82pMe6sxmAgDLi3ko61gpS6A3siJR5ccADDTza6t4AsQN5
         WUjXD7Bo4qmnm3hmtzfogvNiX+yMlpfsRFeZefkrTEVLFo+DqiA6quH/378ac//LrcuY
         YZLA==
X-Gm-Message-State: AAQBX9ds4aYXXVSRc7oV4kPwc1Oy8Qn9ZSBEoOERFOjl7540SGnc0xgJ
        YYfGiwHTm/n1VztUTYSgDvu9uA==
X-Google-Smtp-Source: AKy350bx72vsD2gx/qhvw+4gm1lk9ECFZlAAwd4+tDv5bxVSjJh5w7Co6h0FkmAoPJamfBpYhAs0yQ==
X-Received: by 2002:a17:902:e80a:b0:1a1:cc5a:b04 with SMTP id u10-20020a170902e80a00b001a1cc5a0b04mr8122719plg.3.1681942654045;
        Wed, 19 Apr 2023 15:17:34 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:17:33 -0700 (PDT)
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
Subject: [RFC 02/48] RISC-V: KVM: Improve KVM error reporting to the user space
Date:   Wed, 19 Apr 2023 15:16:30 -0700
Message-Id: <20230419221716.3603068-3-atishp@rivosinc.com>
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

This patch adds RISC-V specific cause for ioctl run failure.
For now, it will be used for the below two cases:

1. Insufficient IMSIC files if VM is configured to run in HWACCEL mode
2. TSM is unable to run run_vcpu SBI call for TVMs

KVM also uses a custom scause bit(48) to distinguish this case
from regular vcpu exit causes.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/csr.h      | 2 ++
 arch/riscv/include/uapi/asm/kvm.h | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 3176355..e78503a 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -96,6 +96,8 @@
 #define EXC_VIRTUAL_INST_FAULT		22
 #define EXC_STORE_GUEST_PAGE_FAULT	23
 
+#define EXC_CUSTOM_KVM_COVE_RUN_FAIL	48
+
 /* PMP configuration */
 #define PMP_R			0x01
 #define PMP_W			0x02
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index b41d0e7..11440df 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -245,6 +245,10 @@ enum KVM_RISCV_SBI_EXT_ID {
 /* One single KVM irqchip, ie. the AIA */
 #define KVM_NR_IRQCHIPS			1
 
+/* run->fail_entry.hardware_entry_failure_reason codes. */
+#define KVM_EXIT_FAIL_ENTRY_IMSIC_FILE_UNAVAILABLE (1ULL << 0)
+#define KVM_EXIT_FAIL_ENTRY_COVE_RUN_VCPU          (1ULL << 1)
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
-- 
2.25.1

