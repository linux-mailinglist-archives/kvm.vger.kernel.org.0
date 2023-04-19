Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB856E84BD
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbjDSWVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbjDSWVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:21:01 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304BEA27E
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:19:41 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a6762fd23cso4485805ad.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942721; x=1684534721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+zj7OnzXIW11i/huBWKMb2xqgovx7dUnUv6Tzb0tqU=;
        b=kKffrnrLJhT1F2qbpdEGRZ8TTdXO/ezDgOuiwNxMV5iPfOJqI4IDxFqpw9pAeQ5RyL
         txc+F1a0ERaLPbEf/eIAQ97QF+P0vW9KXEXQJVk4MAG0hZ5UHvM8iR+j9FWY80tzoRv/
         i18leGEtafNSkE1v0+pd0Hfx2PDQbn2laJSCgiLJbhWUmlq3l8lS0EIHC495U1w/1Sbo
         lQtTZAz+qIu3/rAdq8eTemzM8D2U0sbpzmAeqpgkGt5b1+8A50H+erFvF/kq3fNWeSd/
         Aaooy2SRdRuS8o6rl9qDP37Xbl9koaQ1p1+GFSXg8xMxaIolOUWU6ET8zb1xeekSFWHq
         oPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942721; x=1684534721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+zj7OnzXIW11i/huBWKMb2xqgovx7dUnUv6Tzb0tqU=;
        b=fhFX8rZ2w7ZnSenMefAQ2yP6voYnOk+vXnmNtjc505kGxzWFPTH1O4M/Tf/Dedvqny
         yojhgAN+9ZSM1vJ6eyqtoeR5Hb4AGrCqOxKiV/kZTBCB6sUmYKM96RlKekzhrEKW9Iql
         bO8c1u4OmLhRSBBTmEVZcNGvbCyoEYW2WJ+3v8XFqldfMuNA6B9TlVhuJHYpE5R9tDDQ
         1GFGXbCtSvYs28uWoZVtQ3ZBnleVtvsZFtrGdDvFMkuEvyapY5RMDIE2UctlaKm/mhiT
         btFdzfCPX5yzZa1oSBsRc/cV0SufvshmWA6AjGFuhicW591tv54WH82keWKA2zJm7V3k
         3O5w==
X-Gm-Message-State: AAQBX9fNU15NW4xW1O3XiYI+eUiEVe1S/KQ7uSsAru89lQGoA51rBoI9
        V2CEPj6WNXXtmJk0rqCPhj5bJQ==
X-Google-Smtp-Source: AKy350YAhdUYSn6knSbdmrvNKc2nBR1+eLVyT4UOeUtVo2MC/0v8WULeVwQQVk7jPKicbrdK5dLY6w==
X-Received: by 2002:a17:902:a58a:b0:1a5:153f:2442 with SMTP id az10-20020a170902a58a00b001a5153f2442mr6421815plb.52.1681942720765;
        Wed, 19 Apr 2023 15:18:40 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:39 -0700 (PDT)
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
Subject: [RFC 32/48] RISC-V: KVM: Add AIA support for TVMs
Date:   Wed, 19 Apr 2023 15:17:00 -0700
Message-Id: <20230419221716.3603068-33-atishp@rivosinc.com>
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

The AIA support for TVMs are split between the host and the TSM.
While the host allocates the vsfile, the TSM controls the gstage mapping
and any updates to it. The host must not be able to inject interrupt
to a TVM. Thus, the interrupt injection has to happen via the TSM only
for the interrupts allowed by the guest.

The swfile maintained by the host is not useful for the TVMs as well
as the TVMs only work for HW_ACCEL mode. The TSM does maintain a swfile
for the vcpu internally. The swfile allocation in the host is kept
as is to avoid further bifurcation of the code.

Co-developed-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_cove.h |   6 +-
 arch/riscv/kvm/aia.c              |  84 +++++++++++++++++---
 arch/riscv/kvm/aia_device.c       |  41 +++++++---
 arch/riscv/kvm/aia_imsic.c        | 127 +++++++++++++++++++++---------
 4 files changed, 195 insertions(+), 63 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_cove.h b/arch/riscv/include/asm/kvm_cove.h
index 74bad2f..4367281 100644
--- a/arch/riscv/include/asm/kvm_cove.h
+++ b/arch/riscv/include/asm/kvm_cove.h
@@ -61,7 +61,7 @@ struct kvm_riscv_cove_page {
 	unsigned long gpa;
 };
 
-struct imsic_tee_state {
+struct imsic_cove_state {
 	bool bind_required;
 	bool bound;
 	int vsfile_hgei;
@@ -73,7 +73,7 @@ struct kvm_cove_tvm_vcpu_context {
 	struct kvm_riscv_cove_page vcpu_state;
 
 	/* Per VCPU imsic state */
-	struct imsic_tee_state imsic;
+	struct imsic_cove_state imsic;
 };
 
 struct kvm_cove_tvm_context {
@@ -181,7 +181,7 @@ static inline int kvm_riscv_cove_vm_measure_pages(struct kvm *kvm,
 }
 static inline int kvm_riscv_cove_gstage_map(struct kvm_vcpu *vcpu,
 					    gpa_t gpa, unsigned long hva) {return -1; }
-/* AIA related TEE functions */
+/* TVM interrupt managenet via AIA functions */
 static inline int kvm_riscv_cove_aia_init(struct kvm *kvm) { return -1; }
 static inline int kvm_riscv_cove_vcpu_inject_interrupt(struct kvm_vcpu *vcpu,
 						       unsigned long iid) { return -1; }
diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index e3da661..88b91b5 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -20,6 +20,8 @@
 struct aia_hgei_control {
 	raw_spinlock_t lock;
 	unsigned long free_bitmap;
+	/* Tracks if a hgei is converted to confidential mode */
+	unsigned long nconf_bitmap;
 	struct kvm_vcpu *owners[BITS_PER_LONG];
 };
 static DEFINE_PER_CPU(struct aia_hgei_control, aia_hgei);
@@ -391,34 +393,96 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
 int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
 			     void __iomem **hgei_va, phys_addr_t *hgei_pa)
 {
-	int ret = -ENOENT;
-	unsigned long flags;
+	int ret = -ENOENT, rc;
+	bool reclaim_needed = false;
+	unsigned long flags, tmp_bitmap;
 	const struct imsic_local_config *lc;
 	struct aia_hgei_control *hgctrl = per_cpu_ptr(&aia_hgei, cpu);
+	phys_addr_t imsic_hgei_pa;
 
 	if (!kvm_riscv_aia_available())
 		return -ENODEV;
 	if (!hgctrl)
 		return -ENODEV;
 
+	lc = imsic_get_local_config(cpu);
 	raw_spin_lock_irqsave(&hgctrl->lock, flags);
 
-	if (hgctrl->free_bitmap) {
-		ret = __ffs(hgctrl->free_bitmap);
-		hgctrl->free_bitmap &= ~BIT(ret);
-		hgctrl->owners[ret] = owner;
+	if (!hgctrl->free_bitmap) {
+		raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
+		goto done;
+	}
+
+	if (!is_cove_vcpu(owner)) {
+		/* Find a free one that is not converted */
+		tmp_bitmap = hgctrl->free_bitmap & hgctrl->nconf_bitmap;
+		if (tmp_bitmap > 0)
+			ret = __ffs(tmp_bitmap);
+		else {
+			/* All free ones have been converted in the past. Reclaim one now */
+			ret = __ffs(hgctrl->free_bitmap);
+			reclaim_needed = true;
+		}
+	} else {
+		/* First try to find a free one that is already converted */
+		tmp_bitmap = hgctrl->free_bitmap & !hgctrl->nconf_bitmap;
+		if (tmp_bitmap > 0)
+			ret = __ffs(tmp_bitmap);
+		else
+			ret = __ffs(hgctrl->free_bitmap);
 	}
 
+	hgctrl->free_bitmap &= ~BIT(ret);
+	hgctrl->owners[ret] = owner;
 	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
 
-	lc = imsic_get_local_config(cpu);
 	if (lc && ret > 0) {
 		if (hgei_va)
 			*hgei_va = lc->msi_va + (ret * IMSIC_MMIO_PAGE_SZ);
-		if (hgei_pa)
-			*hgei_pa = lc->msi_pa + (ret * IMSIC_MMIO_PAGE_SZ);
+		imsic_hgei_pa = lc->msi_pa + (ret * IMSIC_MMIO_PAGE_SZ);
+
+		if (reclaim_needed) {
+			rc = kvm_riscv_cove_aia_claim_imsic(owner, imsic_hgei_pa);
+			if (rc) {
+				kvm_err("Reclaim of imsic pa %pa failed for vcpu %d pcpu %d ret %d\n",
+					&imsic_hgei_pa, owner->vcpu_idx, smp_processor_id(), ret);
+				kvm_riscv_aia_free_hgei(cpu, ret);
+				return rc;
+			}
+		}
+
+		/*
+		 * Clear the free_bitmap here instead in case relcaim was necessary.
+		 * Do it here instead of above because it we should only set the nconf
+		 * bitmap after the claim is successful.
+		 */
+		raw_spin_lock_irqsave(&hgctrl->lock, flags);
+		if (reclaim_needed)
+			set_bit(ret, &hgctrl->nconf_bitmap);
+		raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
+
+		if (is_cove_vcpu(owner) && test_bit(ret, &hgctrl->nconf_bitmap)) {
+			/*
+			 * Convert the address to confidential mode.
+			 * This may need to send IPIs to issue global fence. Hence,
+			 * enable interrupts temporarily for irq processing
+			 */
+			rc = kvm_riscv_cove_aia_convert_imsic(owner, imsic_hgei_pa);
+
+			if (rc) {
+				kvm_riscv_aia_free_hgei(cpu, ret);
+				ret = rc;
+			} else {
+				raw_spin_lock_irqsave(&hgctrl->lock, flags);
+				clear_bit(ret, &hgctrl->nconf_bitmap);
+				raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
+			}
+		}
 	}
 
+	if (hgei_pa)
+		*hgei_pa = imsic_hgei_pa;
+done:
 	return ret;
 }
 
@@ -495,6 +559,8 @@ static int aia_hgei_init(void)
 			hgctrl->free_bitmap &= ~BIT(0);
 		} else
 			hgctrl->free_bitmap = 0;
+		/* By default all vsfiles are to be used for non-confidential mode */
+		hgctrl->nconf_bitmap = hgctrl->free_bitmap;
 	}
 
 	/* Find INTC irq domain */
diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index 3556e82..ecf6734 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -11,6 +11,7 @@
 #include <linux/irqchip/riscv-imsic.h>
 #include <linux/kvm_host.h>
 #include <linux/uaccess.h>
+#include <asm/kvm_cove.h>
 
 static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
 {
@@ -103,6 +104,10 @@ static int aia_config(struct kvm *kvm, unsigned long type,
 			default:
 				return -EINVAL;
 			};
+			/* TVM must have a physical vs file */
+			if (is_cove_vm(kvm) && *nr != KVM_DEV_RISCV_AIA_MODE_HWACCEL)
+				return -EINVAL;
+
 			aia->mode = *nr;
 		} else
 			*nr = aia->mode;
@@ -264,18 +269,24 @@ static int aia_init(struct kvm *kvm)
 	if (kvm->created_vcpus != atomic_read(&kvm->online_vcpus))
 		return -EBUSY;
 
-	/* Number of sources should be less than or equals number of IDs */
-	if (aia->nr_ids < aia->nr_sources)
-		return -EINVAL;
+	if (!is_cove_vm(kvm)) {
+		/* Number of sources should be less than or equals number of IDs */
+		if (aia->nr_ids < aia->nr_sources)
+			return -EINVAL;
+		/* APLIC base is required for non-zero number of sources only for non TVMs*/
+		if (aia->nr_sources && aia->aplic_addr == KVM_RISCV_AIA_UNDEF_ADDR)
+			return -EINVAL;
 
-	/* APLIC base is required for non-zero number of sources */
-	if (aia->nr_sources && aia->aplic_addr == KVM_RISCV_AIA_UNDEF_ADDR)
-		return -EINVAL;
+		/* Initialize APLIC */
+		ret = kvm_riscv_aia_aplic_init(kvm);
+		if (ret)
+			return ret;
 
-	/* Initialze APLIC */
-	ret = kvm_riscv_aia_aplic_init(kvm);
-	if (ret)
-		return ret;
+	} else {
+		ret = kvm_riscv_cove_aia_init(kvm);
+		if (ret)
+			return ret;
+	}
 
 	/* Iterate over each VCPU */
 	kvm_for_each_vcpu(idx, vcpu, kvm) {
@@ -650,8 +661,14 @@ void kvm_riscv_aia_init_vm(struct kvm *kvm)
 	 */
 
 	/* Initialize default values in AIA global context */
-	aia->mode = (kvm_riscv_aia_nr_hgei) ?
-		KVM_DEV_RISCV_AIA_MODE_AUTO : KVM_DEV_RISCV_AIA_MODE_EMUL;
+	if (is_cove_vm(kvm)) {
+		if (!kvm_riscv_aia_nr_hgei)
+			return;
+		aia->mode = KVM_DEV_RISCV_AIA_MODE_HWACCEL;
+	} else {
+		aia->mode = (kvm_riscv_aia_nr_hgei) ?
+			KVM_DEV_RISCV_AIA_MODE_AUTO : KVM_DEV_RISCV_AIA_MODE_EMUL;
+	}
 	aia->nr_ids = kvm_riscv_aia_max_ids - 1;
 	aia->nr_sources = 0;
 	aia->nr_group_bits = 0;
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 419c98d..8db1e29 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -15,6 +15,7 @@
 #include <linux/swab.h>
 #include <kvm/iodev.h>
 #include <asm/csr.h>
+#include <asm/kvm_cove.h>
 
 #define IMSIC_MAX_EIX	(IMSIC_MAX_ID / BITS_PER_TYPE(u64))
 
@@ -583,7 +584,7 @@ static void imsic_vsfile_local_update(int vsfile_hgei, u32 nr_eix,
 	csr_write(CSR_VSISELECT, old_vsiselect);
 }
 
-static void imsic_vsfile_cleanup(struct imsic *imsic)
+static void imsic_vsfile_cleanup(struct kvm_vcpu *vcpu, struct imsic *imsic)
 {
 	int old_vsfile_hgei, old_vsfile_cpu;
 	unsigned long flags;
@@ -604,8 +605,12 @@ static void imsic_vsfile_cleanup(struct imsic *imsic)
 
 	memset(imsic->swfile, 0, sizeof(*imsic->swfile));
 
-	if (old_vsfile_cpu >= 0)
+	if (old_vsfile_cpu >= 0) {
+		if (is_cove_vcpu(vcpu))
+			kvm_riscv_cove_vcpu_imsic_unbind(vcpu, old_vsfile_cpu);
+
 		kvm_riscv_aia_free_hgei(old_vsfile_cpu, old_vsfile_hgei);
+	}
 }
 
 static void imsic_swfile_extirq_update(struct kvm_vcpu *vcpu)
@@ -688,27 +693,30 @@ void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
 	 * the old IMSIC VS-file so we first re-direct all interrupt
 	 * producers.
 	 */
+	if (!is_cove_vcpu(vcpu)) {
+		/* Purge the G-stage mapping */
+		kvm_riscv_gstage_iounmap(vcpu->kvm,
+					 vcpu->arch.aia_context.imsic_addr,
+					 IMSIC_MMIO_PAGE_SZ);
 
-	/* Purge the G-stage mapping */
-	kvm_riscv_gstage_iounmap(vcpu->kvm,
-				 vcpu->arch.aia_context.imsic_addr,
-				 IMSIC_MMIO_PAGE_SZ);
-
-	/* TODO: Purge the IOMMU mapping ??? */
+		/* TODO: Purge the IOMMU mapping ??? */
 
-	/*
-	 * At this point, all interrupt producers have been re-directed
-	 * to somewhere else so we move register state from the old IMSIC
-	 * VS-file to the IMSIC SW-file.
-	 */
+		/*
+		 * At this point, all interrupt producers have been re-directed
+		 * to somewhere else so we move register state from the old IMSIC
+		 * VS-file to the IMSIC SW-file.
+		 */
 
-	/* Read and clear register state from old IMSIC VS-file */
-	memset(&tmrif, 0, sizeof(tmrif));
-	imsic_vsfile_read(old_vsfile_hgei, old_vsfile_cpu, imsic->nr_hw_eix,
-			  true, &tmrif);
+		/* Read and clear register state from old IMSIC VS-file */
+		memset(&tmrif, 0, sizeof(tmrif));
+		imsic_vsfile_read(old_vsfile_hgei, old_vsfile_cpu, imsic->nr_hw_eix,
+				  true, &tmrif);
 
-	/* Update register state in IMSIC SW-file */
-	imsic_swfile_update(vcpu, &tmrif);
+		/* Update register state in IMSIC SW-file */
+		imsic_swfile_update(vcpu, &tmrif);
+	} else {
+		kvm_riscv_cove_vcpu_imsic_unbind(vcpu, old_vsfile_cpu);
+	}
 
 	/* Free-up old IMSIC VS-file */
 	kvm_riscv_aia_free_hgei(old_vsfile_cpu, old_vsfile_hgei);
@@ -747,7 +755,7 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
 		/* For HW acceleration mode, we can't continue */
 		if (kvm->arch.aia.mode == KVM_DEV_RISCV_AIA_MODE_HWACCEL) {
 			run->fail_entry.hardware_entry_failure_reason =
-								CSR_HSTATUS;
+					KVM_EXIT_FAIL_ENTRY_IMSIC_FILE_UNAVAILABLE;
 			run->fail_entry.cpu = vcpu->cpu;
 			run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 			return 0;
@@ -762,22 +770,24 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
 	}
 	new_vsfile_hgei = ret;
 
-	/*
-	 * At this point, all interrupt producers are still using
-	 * to the old IMSIC VS-file so we first move all interrupt
-	 * producers to the new IMSIC VS-file.
-	 */
-
-	/* Zero-out new IMSIC VS-file */
-	imsic_vsfile_local_clear(new_vsfile_hgei, imsic->nr_hw_eix);
-
-	/* Update G-stage mapping for the new IMSIC VS-file */
-	ret = kvm_riscv_gstage_ioremap(kvm, vcpu->arch.aia_context.imsic_addr,
-				       new_vsfile_pa, IMSIC_MMIO_PAGE_SZ,
-				       true, true);
-	if (ret)
-		goto fail_free_vsfile_hgei;
-
+	/* TSM only maintains the gstage mapping. Skip vsfile updates & ioremap */
+	if (!is_cove_vcpu(vcpu)) {
+		/*
+		 * At this point, all interrupt producers are still using
+		 * to the old IMSIC VS-file so we first move all interrupt
+		 * producers to the new IMSIC VS-file.
+		 */
+
+		/* Zero-out new IMSIC VS-file */
+		imsic_vsfile_local_clear(new_vsfile_hgei, imsic->nr_hw_eix);
+
+		/* Update G-stage mapping for the new IMSIC VS-file */
+		ret = kvm_riscv_gstage_ioremap(kvm, vcpu->arch.aia_context.imsic_addr,
+					       new_vsfile_pa, IMSIC_MMIO_PAGE_SZ,
+					       true, true);
+		if (ret)
+			goto fail_free_vsfile_hgei;
+	}
 	/* TODO: Update the IOMMU mapping ??? */
 
 	/* Update new IMSIC VS-file details in IMSIC context */
@@ -788,12 +798,32 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
 	imsic->vsfile_pa = new_vsfile_pa;
 	write_unlock_irqrestore(&imsic->vsfile_lock, flags);
 
+	/* Now bind the new vsfile for the TVMs */
+	if (is_cove_vcpu(vcpu) && vcpu->arch.tc) {
+		vcpu->arch.tc->imsic.vsfile_hgei = new_vsfile_hgei;
+		if (old_vsfile_cpu >= 0) {
+			if (vcpu->arch.tc->imsic.bound) {
+				ret = kvm_riscv_cove_vcpu_imsic_rebind(vcpu, old_vsfile_cpu);
+				if (ret) {
+					kvm_err("imsic rebind failed for vcpu %d ret %d\n",
+						 vcpu->vcpu_idx, ret);
+					goto fail_free_vsfile_hgei;
+				}
+			}
+			kvm_riscv_aia_free_hgei(old_vsfile_cpu, old_vsfile_hgei);
+		} else {
+			/* Bind if it is not a migration case */
+			vcpu->arch.tc->imsic.bind_required = true;
+		}
+		/* Skip the oldvsfile and swfile update process as it is managed by TSM */
+		goto done;
+	}
+
 	/*
 	 * At this point, all interrupt producers have been moved
 	 * to the new IMSIC VS-file so we move register state from
 	 * the old IMSIC VS/SW-file to the new IMSIC VS-file.
 	 */
-
 	memset(&tmrif, 0, sizeof(tmrif));
 	if (old_vsfile_cpu >= 0) {
 		/* Read and clear register state from old IMSIC VS-file */
@@ -946,6 +976,7 @@ int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
 	unsigned long flags;
 	struct imsic_mrif_eix *eix;
 	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
+	int ret;
 
 	/* We only emulate one IMSIC MMIO page for each Guest VCPU */
 	if (!imsic || !iid || guest_index ||
@@ -960,7 +991,14 @@ int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
 	read_lock_irqsave(&imsic->vsfile_lock, flags);
 
 	if (imsic->vsfile_cpu >= 0) {
-		writel(iid, imsic->vsfile_va + IMSIC_MMIO_SETIPNUM_LE);
+		/* TSM can only inject the external interrupt if it is allowed by the guest */
+		if (is_cove_vcpu(vcpu)) {
+			ret = kvm_riscv_cove_vcpu_inject_interrupt(vcpu, iid);
+			if (ret)
+				kvm_err("External interrupt %d injection failed\n", iid);
+		} else {
+			writel(iid, imsic->vsfile_va + IMSIC_MMIO_SETIPNUM_LE);
+		}
 		kvm_vcpu_kick(vcpu);
 	} else {
 		eix = &imsic->swfile->eix[iid / BITS_PER_TYPE(u64)];
@@ -1039,6 +1077,17 @@ int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
 	imsic->swfile = page_to_virt(swfile_page);
 	imsic->swfile_pa = page_to_phys(swfile_page);
 
+	/* No need to setup iodev ops for TVMs. Swfile will also not be used for
+	 * TVMs. However, allocate it for now as to avoid different path during
+	 * free.
+	 */
+	if (is_cove_vcpu(vcpu)) {
+		ret = kvm_riscv_cove_vcpu_imsic_addr(vcpu);
+		if (ret)
+			goto fail_free_swfile;
+		return 0;
+	}
+
 	/* Setup IO device */
 	kvm_iodevice_init(&imsic->iodev, &imsic_iodoev_ops);
 	mutex_lock(&kvm->slots_lock);
@@ -1069,7 +1118,7 @@ void kvm_riscv_vcpu_aia_imsic_cleanup(struct kvm_vcpu *vcpu)
 	if (!imsic)
 		return;
 
-	imsic_vsfile_cleanup(imsic);
+	imsic_vsfile_cleanup(vcpu, imsic);
 
 	mutex_lock(&kvm->slots_lock);
 	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &imsic->iodev);
-- 
2.25.1

