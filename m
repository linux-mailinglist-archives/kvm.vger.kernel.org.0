Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E3D6E8482
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjDSWR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjDSWRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:17:47 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C1B26A2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:41 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-52019617020so245130a12.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942660; x=1684534660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YhmpWINWx68bxRl5iJymJMR8koMWZ3k0vMo650bJZTU=;
        b=ub984HbNYnZCS4cYMVeGAOsRXSkOK2FPD4icQUHZlHix4aKpIqyXeuVfQOuD1xHj9v
         vsKnnlhxdpBXKMy0/ROqMjpZOfEnWXQbDuHp5T383/Vm/+FQmuzlPZpnUGhvlMFFe7rt
         8HkCX+VPliU1MmnP1Ss2H9IInj7b1S/ZGGfNasP3k5lYx2EUDdBQbfa+gCsPCMfJr4EM
         doY/zh1GbMfgfCGSFTcIGG6F7Q7zICkSwwBAXaUPKIzJ8MoIZKG1DSX+I00o1o0F5UZi
         WiH33xlJMuVTKRgbJ22ofZQJq8VWsCC+jXY14LMcf4NAwgljQxOy08LcxeWTlGXumKfv
         zGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942660; x=1684534660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YhmpWINWx68bxRl5iJymJMR8koMWZ3k0vMo650bJZTU=;
        b=HMcUojfx4m9jNV4VSaeEg+bn+LhZzx+F9EHvLFgTYIrPR2vfjJFBHo/5vCdtD/ah95
         zGmOZfPhb733CRlULEEgwvh14gwTDQltfhaB6TVHL3g2dU+RP3L1q870CjPuaObMJNvy
         KqFJz+xWlM94Ccgqccto+UBZDJmTpFOAI+cQdTIBIoeO099Drlr64KEPjs+CQJobz1/A
         BAUPPaTj+AvNhxVBFpKj2jZjrXlQNYAEbp5TDRNfNF0u+Kv4msKxNGXXAEA/UAR0Iksx
         pbeBcsAplXG31EB5iVtuTKDeI5BBfftFcPbR8/W2iffAPFWd64fbST+7g02T46SEanPz
         8BDw==
X-Gm-Message-State: AAQBX9d7U7Xm5CNFNIy9K9MeqWmruNRnwCiu4s+UfDfPnJa1G1eYCcph
        bon17AEt5zHJxG/wSIk51si70Q==
X-Google-Smtp-Source: AKy350b9J0w/WoMpaq+FxHZfAsQ/ItbJjVOrBVDU6LQmeWRXpZ0GrubHeMgcOdfazZVEwzQcIEKGsA==
X-Received: by 2002:a17:90a:f696:b0:246:a782:d94 with SMTP id cl22-20020a17090af69600b00246a7820d94mr4315223pjb.7.1681942660612;
        Wed, 19 Apr 2023 15:17:40 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:17:40 -0700 (PDT)
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
Subject: [RFC 05/48] RISC-V: Add COVH SBI extensions definitions
Date:   Wed, 19 Apr 2023 15:16:33 -0700
Message-Id: <20230419221716.3603068-6-atishp@rivosinc.com>
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

RISC-V Confidential Virtualization Extension(COVE) specification defines
following 3 SBI extensions.

COVH (Host side interface)
COVG (Guest side interface)
COVI (Interrupt management interface)

Few acronyms introduced in this patch:

TSM - TEE Security Manager
TVM - TEE VM

This patch adds the definitions for COVH extension only.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 61 ++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 62d00c7..c5a5526 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -32,6 +32,7 @@ enum sbi_ext_id {
 	SBI_EXT_PMU = 0x504D55,
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_NACL = 0x4E41434C,
+	SBI_EXT_COVH = 0x434F5648,
 
 	/* Experimentals extensions must lie within this range */
 	SBI_EXT_EXPERIMENTAL_START = 0x08000000,
@@ -348,6 +349,66 @@ enum sbi_ext_nacl_feature {
 #define SBI_NACL_SHMEM_SRET_X(__i)		((__riscv_xlen / 8) * (__i))
 #define SBI_NACL_SHMEM_SRET_X_LAST		31
 
+/* SBI COVH extension data structures */
+enum sbi_ext_covh_fid {
+	SBI_EXT_COVH_TSM_GET_INFO = 0,
+	SBI_EXT_COVH_TSM_CONVERT_PAGES,
+	SBI_EXT_COVH_TSM_RECLAIM_PAGES,
+	SBI_EXT_COVH_TSM_INITIATE_FENCE,
+	SBI_EXT_COVH_TSM_LOCAL_FENCE,
+	SBI_EXT_COVH_CREATE_TVM,
+	SBI_EXT_COVH_FINALIZE_TVM,
+	SBI_EXT_COVH_DESTROY_TVM,
+	SBI_EXT_COVH_TVM_ADD_MEMORY_REGION,
+	SBI_EXT_COVH_TVM_ADD_PGT_PAGES,
+	SBI_EXT_COVH_TVM_ADD_MEASURED_PAGES,
+	SBI_EXT_COVH_TVM_ADD_ZERO_PAGES,
+	SBI_EXT_COVH_TVM_ADD_SHARED_PAGES,
+	SBI_EXT_COVH_TVM_CREATE_VCPU,
+	SBI_EXT_COVH_TVM_VCPU_RUN,
+	SBI_EXT_COVH_TVM_INITIATE_FENCE,
+};
+
+enum sbi_cove_page_type {
+	SBI_COVE_PAGE_4K,
+	SBI_COVE_PAGE_2MB,
+	SBI_COVE_PAGE_1GB,
+	SBI_COVE_PAGE_512GB,
+};
+
+enum sbi_cove_tsm_state {
+	/* TSM has not been loaded yet */
+	TSM_NOT_LOADED,
+	/* TSM has been loaded but not initialized yet */
+	TSM_LOADED,
+	/* TSM has been initialized and ready to run */
+	TSM_READY,
+};
+
+struct sbi_cove_tsm_info {
+	/* Current state of the TSM */
+	enum sbi_cove_tsm_state tstate;
+
+	/* Version of the loaded TSM */
+	uint32_t version;
+
+	/* Number of 4K pages required per TVM */
+	unsigned long tvm_pages_needed;
+
+	/* Maximum VCPUs supported per TVM */
+	unsigned long tvm_max_vcpus;
+
+	/* Number of 4K pages each vcpu per TVM */
+	unsigned long tvcpu_pages_needed;
+};
+
+struct sbi_cove_tvm_create_params {
+	/* Root page directory for TVM's page table management */
+	unsigned long tvm_page_directory_addr;
+	/* Confidential memory address used to store TVM state information. Must be page aligned */
+	unsigned long tvm_state_addr;
+};
+
 #define SBI_SPEC_VERSION_DEFAULT	0x1
 #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
 #define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
-- 
2.25.1

