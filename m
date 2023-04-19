Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7022C6E84A5
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbjDSWTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbjDSWTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:19:08 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0BB4C1B
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:29 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a6f0d8cdfeso4502055ad.2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942709; x=1684534709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0F6tHm2quQwLEvcCl5FI5ypn8ePvTg03kiPuCNoeNw=;
        b=B0z1LKxRqo0N/+B1Zq8uNd+jORsnBmdASeazIE6ba9jOD7NNAm6Y6Ydluna+vSisdS
         Ns9+QkyzZkHLKpqekwlR8LOXx0SmdbLDH70zYIU2tu7Ppm7uTfxUiNTzbORQk6jDkpwT
         wou9JJMc8eyykdjw9eDblXGrXRv3fHzY2QDwRPmwO1RqTVCF9ZjGycORqBMV7BBhXY2c
         4MNxDLzeWD+U/vLAXIW8MKmvELAjO/f9B7KULqHL5O/X2CES/rwKUq+7tYosSOcZcHDe
         RrEGZ8I2t0oPTTiBYWoZFiRl6ej+YFgKxG/VdR1RjRUQssQeFPlAP7g8lmfAqRhNq39Y
         qB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942709; x=1684534709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e0F6tHm2quQwLEvcCl5FI5ypn8ePvTg03kiPuCNoeNw=;
        b=XBBY2VMaxZSk+tU85lbYAfYwlUjAS8VdxjWPUQ+ZUNt88A5UinxyrD7bg9gfk6MQux
         gt/tkw075PABc6ibcqLCsAHGVQ0IYhqNODezZ5N8C+mc+jAF/4S1c2AWrmXjqdasMbd+
         UuAe+c4mPIoHTKZBGXH47I9qozHnPWXsJ8JObOP3NbLWXeCl49l3j/olMWQ7y1gjREb6
         4jAF3pgN5gZYb9Z6hk7Q6m92290JOXToTUCPKbMU2kmuyujXx+IRvkZuJDwBrVpK4MkS
         OnmpMFPcnAhaIS4Y3lDl4WSHbzPR8w/Ls0VyJC80ktA9JaVb5dxHoyN+0FSBLCmF2Joh
         v0Sw==
X-Gm-Message-State: AAQBX9fbAviGaGa8Y3c8z+Y5ICkEP506JZuT752qpmZaQWb7HbS/vaXg
        jqh2c6rrJHQZCazcsVK7UmVUbw==
X-Google-Smtp-Source: AKy350aSSLZmcJ6EGd9ViVcCgExeh8NfbY776YNFamx7qI4QWXSDqSo7VY1vzDz6CmaJhnexr4tP0w==
X-Received: by 2002:a17:902:be02:b0:1a3:c8c2:c322 with SMTP id r2-20020a170902be0200b001a3c8c2c322mr6340185pls.29.1681942709189;
        Wed, 19 Apr 2023 15:18:29 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:28 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
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
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 27/48] RISC-V: KVM: Implement COVI SBI extension
Date:   Wed, 19 Apr 2023 15:16:55 -0700
Message-Id: <20230419221716.3603068-28-atishp@rivosinc.com>
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

CoVE specification defines a separate SBI extension to manage interrupts
in TVM. This extension is known as COVI as both host & guest
interface access these functions.

This patch implements the functions defined by COVI.

Co-developed-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_cove_sbi.h |  20 ++++
 arch/riscv/kvm/cove_sbi.c             | 164 ++++++++++++++++++++++++++
 2 files changed, 184 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_cove_sbi.h b/arch/riscv/include/asm/kvm_cove_sbi.h
index df7d88c..0759f70 100644
--- a/arch/riscv/include/asm/kvm_cove_sbi.h
+++ b/arch/riscv/include/asm/kvm_cove_sbi.h
@@ -32,6 +32,7 @@
 #define nacl_shmem_gpr_read_cove(__s, __g) \
 	nacl_shmem_scratch_read_long(__s, get_scratch_gpr_offset(__g))
 
+/* Functions related to CoVE Host Interface (COVH) Extension */
 int sbi_covh_tsm_get_info(struct sbi_cove_tsm_info *tinfo_addr);
 int sbi_covh_tvm_initiate_fence(unsigned long tvmid);
 int sbi_covh_tsm_initiate_fence(void);
@@ -58,4 +59,23 @@ int sbi_covh_create_tvm_vcpu(unsigned long tvmid, unsigned long tvm_vcpuid,
 
 int sbi_covh_run_tvm_vcpu(unsigned long tvmid, unsigned long tvm_vcpuid);
 
+/* Functions related to CoVE Interrupt Management(COVI) Extension */
+int sbi_covi_tvm_aia_init(unsigned long tvm_gid, struct sbi_cove_tvm_aia_params *tvm_aia_params);
+int sbi_covi_set_vcpu_imsic_addr(unsigned long tvm_gid, unsigned long vcpu_id,
+				 unsigned long imsic_addr);
+int sbi_covi_convert_imsic(unsigned long imsic_addr);
+int sbi_covi_reclaim_imsic(unsigned long imsic_addr);
+int sbi_covi_bind_vcpu_imsic(unsigned long tvm_gid, unsigned long vcpu_id,
+			     unsigned long imsic_mask);
+int sbi_covi_unbind_vcpu_imsic_begin(unsigned long tvm_gid, unsigned long vcpu_id);
+int sbi_covi_unbind_vcpu_imsic_end(unsigned long tvm_gid, unsigned long vcpu_id);
+int sbi_covi_inject_external_interrupt(unsigned long tvm_gid, unsigned long vcpu_id,
+					unsigned long interrupt_id);
+int sbi_covi_rebind_vcpu_imsic_begin(unsigned long tvm_gid, unsigned long vcpu_id,
+				      unsigned long imsic_mask);
+int sbi_covi_rebind_vcpu_imsic_clone(unsigned long tvm_gid, unsigned long vcpu_id);
+int sbi_covi_rebind_vcpu_imsic_end(unsigned long tvm_gid, unsigned long vcpu_id);
+
+
+
 #endif
diff --git a/arch/riscv/kvm/cove_sbi.c b/arch/riscv/kvm/cove_sbi.c
index bf037f6..a8901ac 100644
--- a/arch/riscv/kvm/cove_sbi.c
+++ b/arch/riscv/kvm/cove_sbi.c
@@ -18,6 +18,170 @@
 
 #define RISCV_COVE_ALIGN_4KB (1UL << 12)
 
+int sbi_covi_tvm_aia_init(unsigned long tvm_gid,
+			  struct sbi_cove_tvm_aia_params *tvm_aia_params)
+{
+	struct sbiret ret;
+
+	unsigned long pa = __pa(tvm_aia_params);
+
+	ret = sbi_ecall(SBI_EXT_COVI, SBI_EXT_COVI_TVM_AIA_INIT, tvm_gid, pa,
+			sizeof(*tvm_aia_params), 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covi_set_vcpu_imsic_addr(unsigned long tvm_gid, unsigned long vcpu_id,
+				 unsigned long imsic_addr)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVI, SBI_EXT_COVI_TVM_CPU_SET_IMSIC_ADDR,
+			tvm_gid, vcpu_id, imsic_addr, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+/*
+ * Converts the guest interrupt file at `imsic_addr` for use with a TVM.
+ * The guest interrupt file must not be used by the caller until reclaim.
+ */
+int sbi_covi_convert_imsic(unsigned long imsic_addr)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVI, SBI_EXT_COVI_TVM_CONVERT_IMSIC,
+			imsic_addr, 0, 0, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covi_reclaim_imsic(unsigned long imsic_addr)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVI, SBI_EXT_COVI_TVM_RECLAIM_IMSIC,
+			imsic_addr, 0, 0, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+/*
+ * Binds a vCPU to this physical CPU and the specified set of confidential guest
+ * interrupt files.
+ */
+int sbi_covi_bind_vcpu_imsic(unsigned long tvm_gid, unsigned long vcpu_id,
+			     unsigned long imsic_mask)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVI, SBI_EXT_COVI_TVM_CPU_BIND_IMSIC, tvm_gid,
+			vcpu_id, imsic_mask, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+/*
+ * Begins the unbind process for the specified vCPU from this physical CPU and its guest
+ * interrupt files. The host must complete a TLB invalidation sequence for the TVM before
+ * completing the unbind with `unbind_vcpu_imsic_end()`.
+ */
+int sbi_covi_unbind_vcpu_imsic_begin(unsigned long tvm_gid,
+				     unsigned long vcpu_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVI, SBI_EXT_COVI_TVM_CPU_UNBIND_IMSIC_BEGIN,
+			tvm_gid, vcpu_id, 0, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+/*
+ * Completes the unbind process for the specified vCPU from this physical CPU and its guest
+ * interrupt files.
+ */
+int sbi_covi_unbind_vcpu_imsic_end(unsigned long tvm_gid, unsigned long vcpu_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVI, SBI_EXT_COVI_TVM_CPU_UNBIND_IMSIC_END,
+			tvm_gid, vcpu_id, 0, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+/*
+ * Injects an external interrupt into the specified vCPU. The interrupt ID must
+ * have been allowed with `allow_external_interrupt()` by the guest.
+ */
+int sbi_covi_inject_external_interrupt(unsigned long tvm_gid,
+				       unsigned long vcpu_id,
+				       unsigned long interrupt_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVI, SBI_EXT_COVI_TVM_CPU_INJECT_EXT_INTERRUPT,
+			tvm_gid, vcpu_id, interrupt_id, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covi_rebind_vcpu_imsic_begin(unsigned long tvm_gid,
+				     unsigned long vcpu_id,
+				     unsigned long imsic_mask)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVI, SBI_EXT_COVI_TVM_REBIND_IMSIC_BEGIN,
+			tvm_gid, vcpu_id, imsic_mask, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covi_rebind_vcpu_imsic_clone(unsigned long tvm_gid,
+				     unsigned long vcpu_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVI, SBI_EXT_COVI_TVM_REBIND_IMSIC_CLONE,
+			tvm_gid, vcpu_id, 0, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
+int sbi_covi_rebind_vcpu_imsic_end(unsigned long tvm_gid, unsigned long vcpu_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_COVI, SBI_EXT_COVI_TVM_REBIND_IMSIC_END,
+			tvm_gid, vcpu_id, 0, 0, 0, 0);
+	if (ret.error)
+		return sbi_err_map_linux_errno(ret.error);
+
+	return 0;
+}
+
 int sbi_covh_tsm_get_info(struct sbi_cove_tsm_info *tinfo_addr)
 {
 	struct sbiret ret;
-- 
2.25.1

