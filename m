Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D7E6E84A9
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbjDSWUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjDSWTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:19:35 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B6E9743
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:39 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1a6f0d8cdfeso4501435ad.2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942700; x=1684534700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nt9qr+Ng8JBl/RErKCxn2q3deom0MBnPuCU/gT00P20=;
        b=jzzLlLFeiMsuZ9XUDLcOQDkvHl7c/vkCVuAH/Y4TphDSd5Mc9u3gD9w9H9CFYzB5dB
         VNJgXnI5oLZMEQ3VG1XPXo2sPYkG3mVd4jlqIeNIyytoZFK4U8o75fSdl6rlgSdH8yDf
         9+C6A4ccVfr/Y6QMC1xbEc1A2Zj6A2nip5LOQdKpRlwCaJZa6zrc37kKkf6MblV8d0h+
         SCrca1krwloO92QhHfZeNzDRzfTX4CH3FwSkQPPGyJ+li1uF4S8MDV8rlQs97XcIZPKM
         ki/SaLm60kl0sQ2WGkbdIBtaAJDxWkY52gy3+Wk0TvSwU5O4fxtQHmdRQz9B0d/5bKvD
         GE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942700; x=1684534700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nt9qr+Ng8JBl/RErKCxn2q3deom0MBnPuCU/gT00P20=;
        b=SgUOf6AUtIDInimjN8C9raDFn+MsMhOhMyylizR9tqKF5Eiot8aYGlc+46ldS7UZ4a
         nMtqL/ODRB4hsK506l2rM3L7sHn0fMY5AJzzLG7/38EDH04bVKMJBl3soeGDXJR1JRaE
         M4KSC/aBvkgqvOhVmakL/AwrbUYcYACtSQeXuNAY/HgRwAs1zcSMArQrnFk7sTyBHYL6
         sctyGbv/1Ywe/hl9c5OtWxIEXABSZtMX0tI3zlH7rm9cs//qQXEAXwZJJdib1L8iH7xz
         +DCJ4RC21/L6ErRW8DXzaAseKFxnBi0wy92yULEDg1z5Sp3YlFZRH4KmAZxa4GsU4i11
         YWjw==
X-Gm-Message-State: AAQBX9eaMbrFipcgDAY4wbFE4q84QfDODcKUeiGFwc29rnsaMgpWNLkv
        ZfIxDZ7ZDgYJZqweRRwFT1DN8A==
X-Google-Smtp-Source: AKy350bclXeDaJm5NGd+baLQjNm1etLX+lLDzeTXzfOcBiZB99+UVCqjhPXny+Rg6qaFMwVObWbhvw==
X-Received: by 2002:a17:903:110e:b0:1a6:6fe3:df91 with SMTP id n14-20020a170903110e00b001a66fe3df91mr7814057plh.50.1681942700098;
        Wed, 19 Apr 2023 15:18:20 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:19 -0700 (PDT)
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
Subject: [RFC 23/48] RISC-V: KVM: Wireup TVM world switch
Date:   Wed, 19 Apr 2023 15:16:51 -0700
Message-Id: <20230419221716.3603068-24-atishp@rivosinc.com>
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

TVM worlds switch takes a different path from regular VM world switch as
it needs to make an ecall to TSM and TSM actually does the world switch.
The host doesn't need to save/restore any context as TSM is expected
to do that on behalf of the host. The TSM updatess the trap
information in the shared memory which host uses to figure out the
cause of the guest exit.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/cove.c      | 31 +++++++++++++++++++++++++++++--
 arch/riscv/kvm/vcpu.c      | 11 +++++++++++
 arch/riscv/kvm/vcpu_exit.c | 10 ++++++++++
 3 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/cove.c b/arch/riscv/kvm/cove.c
index c93de9b..c11db7a 100644
--- a/arch/riscv/kvm/cove.c
+++ b/arch/riscv/kvm/cove.c
@@ -275,9 +275,36 @@ int kvm_riscv_cove_gstage_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hv
 	return rc;
 }
 
-void kvm_riscv_cove_vcpu_switchto(struct kvm_vcpu *vcpu, struct kvm_cpu_trap *trap)
+void noinstr kvm_riscv_cove_vcpu_switchto(struct kvm_vcpu *vcpu, struct kvm_cpu_trap *trap)
 {
-	/* TODO */
+	int rc;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_cove_tvm_context *tvmc;
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	void *nshmem;
+
+	if (!kvm->arch.tvmc)
+		return;
+
+	tvmc = kvm->arch.tvmc;
+
+	nshmem = nacl_shmem();
+	/* Invoke finalize to mark TVM is ready run for the first time */
+	if (unlikely(!tvmc->finalized_done)) {
+
+		rc = sbi_covh_tsm_finalize_tvm(tvmc->tvm_guest_id, cntx->sepc, cntx->a1);
+		if (rc) {
+			kvm_err("TVM Finalized failed with %d\n", rc);
+			return;
+		}
+		tvmc->finalized_done = true;
+	}
+
+	rc = sbi_covh_run_tvm_vcpu(tvmc->tvm_guest_id, vcpu->vcpu_idx);
+	if (rc) {
+		trap->scause = EXC_CUSTOM_KVM_COVE_RUN_FAIL;
+		return;
+	}
 }
 
 void kvm_riscv_cove_vcpu_destroy(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 3e04b78..43a0b8c 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -1042,6 +1042,11 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_riscv_vcpu_timer_save(vcpu);
 
 	if (kvm_riscv_nacl_available()) {
+		/**
+		 * For TVMs, we don't need a separate case as TSM only updates
+		 * the required CSRs during the world switch. All other CSR
+		 * value should be zeroed out by TSM anyways.
+		 */
 		nshmem = nacl_shmem();
 		csr->vsstatus = nacl_shmem_csr_read(nshmem, CSR_VSSTATUS);
 		csr->vsie = nacl_shmem_csr_read(nshmem, CSR_VSIE);
@@ -1191,6 +1196,12 @@ static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 			gcntx->hstatus = csr_swap(CSR_HSTATUS, hcntx->hstatus);
 		}
 
+		trap->htval = nacl_shmem_csr_read(nshmem, CSR_HTVAL);
+		trap->htinst = nacl_shmem_csr_read(nshmem, CSR_HTINST);
+	} else if (is_cove_vcpu(vcpu)) {
+		nshmem = nacl_shmem();
+		kvm_riscv_cove_vcpu_switchto(vcpu, trap);
+
 		trap->htval = nacl_shmem_csr_read(nshmem, CSR_HTVAL);
 		trap->htinst = nacl_shmem_csr_read(nshmem, CSR_HTINST);
 	} else {
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 8944e29..c46e7f2 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -218,6 +218,15 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		else if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
 			ret = kvm_riscv_vcpu_sbi_ecall(vcpu, run);
 		break;
+	case EXC_CUSTOM_KVM_COVE_RUN_FAIL:
+		if (likely(is_cove_vcpu(vcpu))) {
+			ret = -EACCES;
+			run->fail_entry.hardware_entry_failure_reason =
+				KVM_EXIT_FAIL_ENTRY_COVE_RUN_VCPU;
+			run->fail_entry.cpu = vcpu->cpu;
+			run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		}
+		break;
 	default:
 		break;
 	}
@@ -225,6 +234,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	/* Print details in-case of error */
 	if (ret < 0) {
 		kvm_err("VCPU exit error %d\n", ret);
+		//TODO: These values are bogus/stale for a TVM. Improve it
 		kvm_err("SEPC=0x%lx SSTATUS=0x%lx HSTATUS=0x%lx\n",
 			vcpu->arch.guest_context.sepc,
 			vcpu->arch.guest_context.sstatus,
-- 
2.25.1

