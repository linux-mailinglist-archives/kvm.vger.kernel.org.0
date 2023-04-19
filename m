Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFAC6E84AC
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbjDSWUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbjDSWTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:19:41 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD417685
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:45 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b5fca48bcso384957b3a.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942703; x=1684534703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFCr/CCby/ixIZR1vcNNYtJI+Hn/JpPKkTFrcmf/240=;
        b=o8cl3vLFW0T/UgdJpNmsgqy/trLWjUKDtYhD18vtn6zFmKJnhCVb3UEfS7g11Yxo6v
         70pgYAJ/oiEoiEaIzaXTTARUDuEe0wemxcSCjeDS0me1n4QkzpJpeXfeqrgbXd5cjW+8
         mPLL2Zixb1wKKpwdABmEKJb6AdfFo9aF/CARiWba1a9ZO3iyrr6WtwnggyEbtMKiFH3H
         d5ALpqRY6NcLK/kvZ5gIdFQLtEIiUaW/W6h18t9SJVK+nkmzEtEqwMweSnvDyUAtFakX
         ItHgUeBEX6SFRd5as2TzksX5YG1nm8yDIWTd3Rsk2EmExawcoSXVI008NBflAu//NIVj
         OPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942703; x=1684534703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vFCr/CCby/ixIZR1vcNNYtJI+Hn/JpPKkTFrcmf/240=;
        b=EA5TDzZpzZxkmzy64oRwmtYiMAUSgtOy7Gt2kj5EIXks96gzwzQhFxtOc+K6xov1/q
         rlvKJYfwS8cKXrRMMPtoFcwkvNrL6tIuO2LG+2UT5dQkNb4tUfx/PVskpopLC2HxrH4W
         Txqmh8YSITltbol4IqKa2cjs5iBVlCvfwme7Far0TBDDzvUyiPGqLZGC3vyBEf0LjLsm
         bcTUNK7tsyTHT0x+GlJzHUI2rzp73p8jwYDICJFZnQXc2r+7aXVs1kmShkQ55hTzQPRL
         twctm4W2vN7KI97WDzw6S8XC4FLzcnPxmKbwlNtnQzHJCVSqN23aL5bwZK7zFvnYB2aL
         LzJg==
X-Gm-Message-State: AAQBX9f7ZAgfPiKmGsh3errgRHa8aHOpiCIYuQGFm/Uuno3Z+v+8Ib9p
        DXW2zzOeK3Dxh6Nml8PWjeVghg==
X-Google-Smtp-Source: AKy350YqF/4+akV7tQXSVqBJeeYYqMrxklqGFMYEM4KYqKrP5PB2sjQSY1CZVqN7qH3odtWcRYYeog==
X-Received: by 2002:a17:903:290:b0:19d:b02:cca5 with SMTP id j16-20020a170903029000b0019d0b02cca5mr6589575plr.12.1681942702695;
        Wed, 19 Apr 2023 15:18:22 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:22 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Atish Patra <atishp@rivosinc.com>,
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
Subject: [RFC 24/48] RISC-V: KVM: Update timer functionality for TVMs.
Date:   Wed, 19 Apr 2023 15:16:52 -0700
Message-Id: <20230419221716.3603068-25-atishp@rivosinc.com>
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

From: Rajnesh Kanwal <rkanwal@rivosinc.com>

TSM manages the htimedelta/vstimecmp for the TVM and shares it
with the host to properly schedule hrtimer to keep timer interrupt ticking.
TSM only sets htimedetla when first VCPU is run to make sure host
is not able to control the start time of the VM. TSM updates vstimemcp
at every vmexit and ignores any write to vstimecmp from the host.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/cove.c       |  8 ++++++++
 arch/riscv/kvm/vcpu_timer.c | 26 +++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/cove.c b/arch/riscv/kvm/cove.c
index c11db7a..4a8a8db 100644
--- a/arch/riscv/kvm/cove.c
+++ b/arch/riscv/kvm/cove.c
@@ -282,6 +282,7 @@ void noinstr kvm_riscv_cove_vcpu_switchto(struct kvm_vcpu *vcpu, struct kvm_cpu_
 	struct kvm_cove_tvm_context *tvmc;
 	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
 	void *nshmem;
+	struct kvm_guest_timer *gt = &kvm->arch.timer;
 
 	if (!kvm->arch.tvmc)
 		return;
@@ -305,6 +306,13 @@ void noinstr kvm_riscv_cove_vcpu_switchto(struct kvm_vcpu *vcpu, struct kvm_cpu_
 		trap->scause = EXC_CUSTOM_KVM_COVE_RUN_FAIL;
 		return;
 	}
+
+	/* Read htimedelta from shmem. Given it's written by TSM only when we
+	 * run first VCPU, we need to update this here rather than in timer
+	 * init.
+	 */
+	if (unlikely(!gt->time_delta))
+		gt->time_delta = nacl_shmem_csr_read(nshmem, CSR_HTIMEDELTA);
 }
 
 void kvm_riscv_cove_vcpu_destroy(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index 71a4560..f059e14 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -14,6 +14,7 @@
 #include <asm/delay.h>
 #include <asm/kvm_nacl.h>
 #include <asm/kvm_vcpu_timer.h>
+#include <asm/kvm_cove.h>
 
 static u64 kvm_riscv_current_cycles(struct kvm_guest_timer *gt)
 {
@@ -71,6 +72,10 @@ static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
 
 static int kvm_riscv_vcpu_update_vstimecmp(struct kvm_vcpu *vcpu, u64 ncycles)
 {
+	/* Host is not allowed to update the vstimecmp for the TVM */
+	if (is_cove_vcpu(vcpu))
+		return 0;
+
 #if defined(CONFIG_32BIT)
 	nacl_csr_write(CSR_VSTIMECMP, ncycles & 0xFFFFFFFF);
 	nacl_csr_write(CSR_VSTIMECMPH, ncycles >> 32);
@@ -221,6 +226,11 @@ int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
 		ret = -EOPNOTSUPP;
 		break;
 	case KVM_REG_RISCV_TIMER_REG(time):
+		/* For trusted VMs we can not update htimedelta. We can just
+		 * read it from shared memory.
+		 */
+		if (is_cove_vcpu(vcpu))
+			return -EOPNOTSUPP;
 		gt->time_delta = reg_val - get_cycles64();
 		break;
 	case KVM_REG_RISCV_TIMER_REG(compare):
@@ -287,6 +297,7 @@ static void kvm_riscv_vcpu_update_timedelta(struct kvm_vcpu *vcpu)
 {
 	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
 
+
 #if defined(CONFIG_32BIT)
 	nacl_csr_write(CSR_HTIMEDELTA, (u32)(gt->time_delta));
 	nacl_csr_write(CSR_HTIMEDELTAH, (u32)(gt->time_delta >> 32));
@@ -299,6 +310,10 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
 
+	/* While in CoVE, HOST must not manage HTIMEDELTA or VSTIMECMP for TVM */
+	if (is_cove_vcpu(vcpu))
+		goto skip_hcsr_update;
+
 	kvm_riscv_vcpu_update_timedelta(vcpu);
 
 	if (!t->sstc_enabled)
@@ -311,6 +326,7 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
 	nacl_csr_write(CSR_VSTIMECMP, t->next_cycles);
 #endif
 
+skip_hcsr_update:
 	/* timer should be enabled for the remaining operations */
 	if (unlikely(!t->init_done))
 		return;
@@ -358,5 +374,13 @@ void kvm_riscv_guest_timer_init(struct kvm *kvm)
 	struct kvm_guest_timer *gt = &kvm->arch.timer;
 
 	riscv_cs_get_mult_shift(&gt->nsec_mult, &gt->nsec_shift);
-	gt->time_delta = -get_cycles64();
+	if (is_cove_vm(kvm)) {
+		/* For TVMs htimedelta is managed by TSM and it's communicated using
+		 * NACL shmem interface when first time VCPU is run. so we read it in
+		 * kvm_riscv_cove_vcpu_switchto() where we enter VCPUs.
+		 */
+		gt->time_delta = 0;
+	} else {
+		gt->time_delta = -get_cycles64();
+	}
 }
-- 
2.25.1

