Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB535086E6
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378047AbiDTL23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378038AbiDTL2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:28:19 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5F05F5E
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:25:33 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id z16so1662861pfh.3
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2EYfKgcqlxuOnooxrLdWILH0tv0pWGBlD29VNkEAOIM=;
        b=TO+LW48QFXS3QD0O7Jjzyvt6UTzY0D0TmGGl5G4tEPIBixG7jvudXnWCmoz7KEq9rv
         Z7rmmBafNeUvqZ7FATVc/zgdJZ9L96pQRVNXGtn1vG928g2Q+A7vn0Gc7yLXBmrq9O0Q
         kevKlCITSWkdtSxzlM7SWBK9jLEyJA5PTCBoePJ18IVqLYPgUHS0cfxkU1pjHINpCXUi
         +Tisu8DP6PEi05Wo07i493iWZj4LgJvqFnHvzk2lQk6LBkmHbBs+jve6QShFwJooByWT
         rY+Qr0CVXKf5zJW4H0Me5+pal4Yp1gG2EO7VFWsVpCbttmOHbkBug/Km8RPn9S+8HL2M
         h38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2EYfKgcqlxuOnooxrLdWILH0tv0pWGBlD29VNkEAOIM=;
        b=3D30GemFIm/s+czOzIrvARejSmdw4au4VuX9KZnYMTXG12T5KyRCJKqNC2qT6Y5i5S
         zloRT53IHBqfPWcx6Cs7mFFDoS41Vo+0WIKrxvByMg0jwXlAWA3/+xENqeZVcyoclOnU
         OF5j7mBPAEPj+fEKDFhlhAcoDcMFjZG9YG/OZUgK89grIPB501Wl9qjPRqn9ajBHptpJ
         S9+2vHgEofgHw9qhcB1cECc6i02edCZc+V7eWxHCP5dyMU0lAEeitNrmifWjJZ2a8Oec
         C4mVnRFbCl0x0NQoBXn5DV5QLPrMFJPDhGDHdFjORMMbUm+zP5J1w0OprT6J1BCbPzr7
         W25Q==
X-Gm-Message-State: AOAM5337it590CK/U6UyXCejtKPcoU8NV1D4J0GWGP8o3F0b7L0TmIYR
        HRJCWLvWXrbr5lnRDPHoxwtrfA==
X-Google-Smtp-Source: ABdhPJz9fpRR8XgvDFGPI0R0U1yvNeSnPezLq8uPbEoEewCOLKg0ONM5TWPK4tpx2F3blDf1floEMg==
X-Received: by 2002:aa7:9255:0:b0:505:a44b:275c with SMTP id 21-20020aa79255000000b00505a44b275cmr22903451pfp.40.1650453933365;
        Wed, 20 Apr 2022 04:25:33 -0700 (PDT)
Received: from localhost.localdomain ([122.167.88.101])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090a890c00b001b8efcf8e48sm22529274pjn.14.2022.04.20.04.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 04:25:32 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 7/7] RISC-V: KVM: Cleanup stale TLB entries when host CPU changes
Date:   Wed, 20 Apr 2022 16:54:50 +0530
Message-Id: <20220420112450.155624-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220420112450.155624-1-apatel@ventanamicro.com>
References: <20220420112450.155624-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On RISC-V platforms with hardware VMID support, we share same
VMID for all VCPUs of a particular Guest/VM. This means we might
have stale G-stage TLB entries on the current Host CPU due to
some other VCPU of the same Guest which ran previously on the
current Host CPU.

To cleanup stale TLB entries, we simply flush all G-stage TLB
entries by VMID whenever underlying Host CPU changes for a VCPU.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h |  5 +++++
 arch/riscv/kvm/tlb.c              | 23 +++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c             | 11 +++++++++++
 3 files changed, 39 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index a40e88a9481c..94349a5ffd34 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -166,6 +166,9 @@ struct kvm_vcpu_arch {
 	/* VCPU ran at least once */
 	bool ran_atleast_once;
 
+	/* Last Host CPU on which Guest VCPU exited */
+	int last_exit_cpu;
+
 	/* ISA feature bits (similar to MISA) */
 	unsigned long isa;
 
@@ -256,6 +259,8 @@ void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
 				     unsigned long order);
 void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
 
+void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu);
+
 void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
 void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu);
 void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index c0f86d09c41d..1a76d0b1907d 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -215,6 +215,29 @@ void kvm_riscv_local_hfence_vvma_all(unsigned long vmid)
 	csr_write(CSR_HGATP, hgatp);
 }
 
+void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
+{
+	unsigned long vmid;
+
+	if (!kvm_riscv_gstage_vmid_bits() ||
+	    vcpu->arch.last_exit_cpu == vcpu->cpu)
+		return;
+
+	/*
+	 * On RISC-V platforms with hardware VMID support, we share same
+	 * VMID for all VCPUs of a particular Guest/VM. This means we might
+	 * have stale G-stage TLB entries on the current Host CPU due to
+	 * some other VCPU of the same Guest which ran previously on the
+	 * current Host CPU.
+	 *
+	 * To cleanup stale TLB entries, we simply flush all G-stage TLB
+	 * entries by VMID whenever underlying Host CPU changes for a VCPU.
+	 */
+
+	vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
+	kvm_riscv_local_hfence_gvma_vmid_all(vmid);
+}
+
 void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
 {
 	local_flush_icache_all();
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 9cd8f6e91c98..a86710fcd2e0 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -67,6 +67,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (loaded)
 		kvm_arch_vcpu_put(vcpu);
 
+	vcpu->arch.last_exit_cpu = -1;
+
 	memcpy(csr, reset_csr, sizeof(*csr));
 
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
@@ -735,6 +737,7 @@ static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
 	guest_state_enter_irqoff();
 	__kvm_riscv_switch_to(&vcpu->arch);
+	vcpu->arch.last_exit_cpu = vcpu->cpu;
 	guest_state_exit_irqoff();
 }
 
@@ -829,6 +832,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			continue;
 		}
 
+		/*
+		 * Cleanup stale TLB enteries
+		 *
+		 * Note: This should be done after G-stage VMID has been
+		 * updated using kvm_riscv_gstage_vmid_ver_changed()
+		 */
+		kvm_riscv_local_tlb_sanitize(vcpu);
+
 		guest_timing_enter_irqoff();
 
 		kvm_riscv_vcpu_enter_exit(vcpu);
-- 
2.25.1

