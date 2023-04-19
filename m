Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B356E8489
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbjDSWSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbjDSWSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:18:16 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1CA7ECD
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:51 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63b7096e2e4so376823b3a.2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942669; x=1684534669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T59m5JAZKpRDJgvlPNnQtLbeFsduDf6TBzeyZHAxXV0=;
        b=qjxNMIrl8HnhfIp/ecw72oYKFII9UTAwql/uMAHKk/FXlEBEiMQ66OH7eiwjlGKtCq
         fOjlVW3CuH2HqfOiNP9XRTFCzDI4+lJmQdsac4GSSp3r+OkcygCfPaztbk/heRGDIhKM
         pnYeif4EQ7Prrd5kCwoWu5m8+1XOIOkSJ78OzpuHzmCbajgIzTGS3QZn2FEzSLBwhiSb
         6w7a2QMSx0oX83P6+RuntF3wYcXCE4rbF3duzd0QwdejxuKey4lt6WjYMDej+sLNVh9T
         6z0R8DizcoQpeT/MVd47bfnzAc938aOKta+516VE8cUvwIwwgAey2BJajvvIriSfLlPU
         8bjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942669; x=1684534669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T59m5JAZKpRDJgvlPNnQtLbeFsduDf6TBzeyZHAxXV0=;
        b=ZrCiGaES/8jSF17bKITYx6TJPm7/6+zYQYJGffQuw/JI0UEOScmHvyWplXXzEpKvfx
         Mrsutx6O8JNhfvIE5A7ROCp3zpGNxQZ5FIOp5OBai/sHQuBnsQkSTq4ouaV6uqUZrPTq
         6G3UXY+cZx2ukyIzBUgQiVRmvU+2STfrlLbdrSX9P+TH9L+C75HDKoMrGEPVTlnxojLr
         C13XlSUE96hqUefp10eHAd96xuhrqSJOE0uqIvTzmzg0IoqvDiiMRU822XAWrtXY/BFd
         F/4EP1fZwmG7oHMt+p/c7eB4+15ZNAnqe1eN5Bx+rP9gZAj2hjchqBcfS4EI5xJAphOK
         LdCw==
X-Gm-Message-State: AAQBX9dWNJHVJNSzJpt21UMwUyrLOAxQlbpEkqOVspYHxpXIV9eXW0vB
        LwNK3Shdb24/kz/ppvrchgyGjQ==
X-Google-Smtp-Source: AKy350a2O0VHJD6AXYzabb4g8786HYDihr3e7/POpprE3Ii6IVd/H8nE9VOR2CTMJgAkkR7C+O0Rjg==
X-Received: by 2002:a17:902:aa4a:b0:1a1:f0cb:1055 with SMTP id c10-20020a170902aa4a00b001a1f0cb1055mr6242462plr.28.1681942669632;
        Wed, 19 Apr 2023 15:17:49 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:17:49 -0700 (PDT)
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
Subject: [RFC 09/48] RISC-V: KVM: Add CoVE related nacl helpers
Date:   Wed, 19 Apr 2023 15:16:37 -0700
Message-Id: <20230419221716.3603068-10-atishp@rivosinc.com>
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

The NACL SBI extension allows the scratch area to be customizable
per SBI extension. As per the COVH SBI extension, the scratch
area stores the guest gpr state.

Add some helpers to read/write gprs easily.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_cove_sbi.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_cove_sbi.h b/arch/riscv/include/asm/kvm_cove_sbi.h
index 24562df..df7d88c 100644
--- a/arch/riscv/include/asm/kvm_cove_sbi.h
+++ b/arch/riscv/include/asm/kvm_cove_sbi.h
@@ -17,6 +17,21 @@
 #include <asm/csr.h>
 #include <asm/sbi.h>
 
+#include <asm/asm-offsets.h>
+
+/**
+ * CoVE SBI extensions defines the NACL scratch memory.
+ * uint64_t gprs[32]
+ * uint64_t reserved[224]
+ */
+#define get_scratch_gpr_offset(goffset) (goffset - KVM_ARCH_GUEST_ZERO)
+
+#define nacl_shmem_gpr_write_cove(__s, __g, __o) \
+	nacl_shmem_scratch_write_long(__s, get_scratch_gpr_offset(__g), __o)
+
+#define nacl_shmem_gpr_read_cove(__s, __g) \
+	nacl_shmem_scratch_read_long(__s, get_scratch_gpr_offset(__g))
+
 int sbi_covh_tsm_get_info(struct sbi_cove_tsm_info *tinfo_addr);
 int sbi_covh_tvm_initiate_fence(unsigned long tvmid);
 int sbi_covh_tsm_initiate_fence(void);
-- 
2.25.1

