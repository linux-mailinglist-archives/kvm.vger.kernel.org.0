Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5D56E84A7
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbjDSWUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbjDSWT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:19:26 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371B14C13
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:33 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-517bfdf55c3so183417a12.2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942698; x=1684534698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pex4ariWnXDdKnos4XH43DasA78+EqfUbH0Wh8CR5w4=;
        b=di7chbqLiC3SvYTY8G+fGI2cGV6/NplXfCh5v5XyNgDlngesP2y27MIvOHwrp1X4yx
         4JsJle4v6NILzYjrBdQfclQHMQ1y+XkUvrnKfQUj0Ry5xsz9RSAaP7xk6bNe/vd52w3q
         C3nd14GGW5Qj94glYyk3NSDPRmLJqvozvF8lGdcOkQJDY2HZ2XGm6lNAbX6/JmUwtYhH
         cJH7ZmbN28BevOjXzCzDy6LpP/+8QR1qPGxigpkkPQjHRv6qA67df2bzJD5EJMK27xPT
         x2yJWlQYdkRTzgVvhswp/3TbWfU5x7nor5CBTVJeRFUg+I3fFtPgIMfjV7YwcmwCLtW3
         tRuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942698; x=1684534698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pex4ariWnXDdKnos4XH43DasA78+EqfUbH0Wh8CR5w4=;
        b=JGNpakmqA86rkbmUcUgEXTnMKeDE90p8IO3ITas2PXovcWmiLiBke+FWpwBAcTObNp
         Jkfl/vs4dM+hcMugYtj1FwhpCbhWvMrU5bqaK+dwrQ1O82VeCFKLuQWDxilDfTAi4DgN
         lv1SHVHthJHSuBaYMveNI66lKWh8DDoQj3ISRE8/Sw9dMb2grrLMDCQqt2FSO441T1s4
         wCeVhMxs9ntk/Gwy9VRI/QMDH4eO1NY1AyiT031ZHF19uneWlsKAM46FxxHFitWHUP9o
         Rfqdvg0zIytogMfIwkZz0IZNI6mwys79810AMuOSqsBLCETlpSESPTCuIVRvLxT5NyBE
         W+zw==
X-Gm-Message-State: AAQBX9fIFAjUp7for4/7YS/YGV84jKugtZtjEh+MlSVzuJuuNnWPdzV8
        /6UkCHEexXc8rMubhUtMmAPU/A==
X-Google-Smtp-Source: AKy350bAGBT2wDySHdJsoaBivRKAhhoN6FGmg4/i0kk3x7CE/96pMKWgvriPwXlMHgJNkHUROr/6AQ==
X-Received: by 2002:a17:903:1210:b0:1a6:4a64:4d27 with SMTP id l16-20020a170903121000b001a64a644d27mr7784281plh.40.1681942697893;
        Wed, 19 Apr 2023 15:18:17 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:17 -0700 (PDT)
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
Subject: [RFC 22/48] RISC-V: KVM: Implement vcpu load/put functions for CoVE guests
Date:   Wed, 19 Apr 2023 15:16:50 -0700
Message-Id: <20230419221716.3603068-23-atishp@rivosinc.com>
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

The TSM takes care of most of the H extension CSR/fp save/restore
for any guest running in CoVE. It may choose to do the fp save/restore
lazily as well. The host has to do minimal operations such timer
save/restore and interrupt state restore during vcpu load/put.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/cove.c | 12 ++++++++++--
 arch/riscv/kvm/vcpu.c | 12 +++++++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/cove.c b/arch/riscv/kvm/cove.c
index 87fa04b..c93de9b 100644
--- a/arch/riscv/kvm/cove.c
+++ b/arch/riscv/kvm/cove.c
@@ -139,12 +139,20 @@ __always_inline bool kvm_riscv_cove_enabled(void)
 
 void kvm_riscv_cove_vcpu_load(struct kvm_vcpu *vcpu)
 {
-	/* TODO */
+	kvm_riscv_vcpu_timer_restore(vcpu);
 }
 
 void kvm_riscv_cove_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	/* TODO */
+	void *nshmem;
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+
+	kvm_riscv_vcpu_timer_save(vcpu);
+	/* NACL is mandatory for CoVE */
+	nshmem = nacl_shmem();
+
+	/* Only VSIE needs to be read to manage the interrupt stuff */
+	csr->vsie = nacl_shmem_csr_read(nshmem, CSR_VSIE);
 }
 
 int kvm_riscv_cove_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 8cf462c..3e04b78 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -972,6 +972,11 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	u64 henvcfg = kvm_riscv_vcpu_get_henvcfg(vcpu->arch.isa);
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 
+	if (is_cove_vcpu(vcpu)) {
+		kvm_riscv_cove_vcpu_load(vcpu);
+		goto skip_load;
+	}
+
 	if (kvm_riscv_nacl_sync_csr_available()) {
 		nshmem = nacl_shmem();
 		nacl_shmem_csr_write(nshmem, CSR_VSSTATUS, csr->vsstatus);
@@ -1010,9 +1015,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
 	kvm_riscv_vcpu_guest_fp_restore(&vcpu->arch.guest_context,
 					vcpu->arch.isa);
-
 	kvm_riscv_vcpu_aia_load(vcpu, cpu);
 
+skip_load:
 	vcpu->cpu = cpu;
 }
 
@@ -1023,6 +1028,11 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 	vcpu->cpu = -1;
 
+	if (is_cove_vcpu(vcpu)) {
+		kvm_riscv_cove_vcpu_put(vcpu);
+		return;
+	}
+
 	kvm_riscv_vcpu_aia_put(vcpu);
 
 	kvm_riscv_vcpu_guest_fp_save(&vcpu->arch.guest_context,
-- 
2.25.1

