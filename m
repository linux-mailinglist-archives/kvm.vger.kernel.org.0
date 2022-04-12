Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858DA4FDDCB
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 13:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352284AbiDLL1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 07:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352864AbiDLLZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 07:25:43 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69372C650
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 03:08:52 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y8so11903848pfw.0
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 03:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yXtNQf1O3SKUPSpa9YMRsp47BPaP+h4RQyOydNIm7O4=;
        b=ikLO936EH9QhrnQ1zw0CeSj2VX45d86cFav9inAh9URTyohi5V0aOLuPDPVdPMGnbG
         h45tzCFKVNKWXtjD8+HNXHbOq8p/VIvJnzJbLGY6ngwfsL/MAKUVaJpjLRsm2tqyrVEa
         bSbzNXszjBfqqmfxrdXnocEC0jJ3ha+6GdBqQn/Oq39XTHdcJmzrOH7fNgamQBe+BAzC
         vQIA4dsTK/riEDaw/+62diEYLPtztDGN3lJv+LhyYcQ2PLrmID75s7MCYbdRhT79b3xX
         NlS1d5mcoHBiQI/uOuxz4CO8u5zvdE8furvdRDC1vVv6e/OOp+1gPZU2herh+rFqLteN
         XJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yXtNQf1O3SKUPSpa9YMRsp47BPaP+h4RQyOydNIm7O4=;
        b=moXffrw8eLw/BK0RttSMgGlzTBzhrWlQlvTaDBeizl9DgffK5uOxyxUB+9Ar+ktFBb
         bQi+TsVjofSxz3JStTNK/RWz9uU441PmYRnRWUu+kuLhseQAFeJ32fXVQxOrzCONHfUs
         i/mqRfuE2c5kWM0YdeeyOYc5jYylm0mFCQ9cKJJJ2qph6h6as1jnhyfgRZXcvhWm7bjB
         NWrTNYxqGxcyob9Zc1NI5P6SfCKxX+r2WVHL4rQZnxwjK3B7ZOOoUhiVwCGnt2GL6Y6V
         C+C3q18AJdd49xwV+sEsDzdU+Dm3XgtiW7tJ0XIK4KSozmNa3fIXMvVHVSeaZ/+BXXmz
         9BMw==
X-Gm-Message-State: AOAM531pcwgU8p9bFxRjmitGHNnb4E9jqAe2VIDtpfZngYF9R1gMTMmm
        mEBVw6UtuBlgWCRdj6rYHgcGtQ==
X-Google-Smtp-Source: ABdhPJyeff3n1WyoFaR/EAh90XNAqPsiytK5NCRevafwUxcU5s9+y/uOHexJvc52q0Nw4XKoaQR28A==
X-Received: by 2002:a63:1f21:0:b0:39d:1ee8:784e with SMTP id f33-20020a631f21000000b0039d1ee8784emr12199761pgf.591.1649758132044;
        Tue, 12 Apr 2022 03:08:52 -0700 (PDT)
Received: from localhost.localdomain ([122.182.197.47])
        by smtp.gmail.com with ESMTPSA id j9-20020a056a00130900b004f73df40914sm37515088pfu.82.2022.04.12.03.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:08:51 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 6/6] RISC-V: KVM: Add remote HFENCE functions based on VCPU requests
Date:   Tue, 12 Apr 2022 15:37:13 +0530
Message-Id: <20220412100713.1415094-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412100713.1415094-1-apatel@ventanamicro.com>
References: <20220412100713.1415094-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The generic KVM has support for VCPU requests which can be used
to do arch-specific work in the run-loop. We introduce remote
HFENCE functions which will internally use VCPU requests instead
of host SBI calls.

Advantages of doing remote HFENCEs as VCPU requests are:
1) Multiple VCPUs of a Guest may be running on different Host CPUs
   so it is not always possible to determine the Host CPU mask for
   doing Host SBI call. For example, when VCPU X wants to do HFENCE
   on VCPU Y, it is possible that VCPU Y is blocked or in user-space
   (i.e. vcpu->cpu < 0).
2) To support nested virtualization, we will be having a separate
   shadow G-stage for each VCPU and a common host G-stage for the
   entire Guest/VM. The VCPU requests based remote HFENCEs helps
   us easily synchronize the common host G-stage and shadow G-stage
   of each VCPU without any additional IPI calls.

This is also a preparatory patch for upcoming nested virtualization
support where we will be having a shadow G-stage page table for
each Guest VCPU.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h |  59 ++++++++
 arch/riscv/kvm/mmu.c              |  33 +++--
 arch/riscv/kvm/tlb.c              | 227 +++++++++++++++++++++++++++++-
 arch/riscv/kvm/vcpu.c             |  24 +++-
 arch/riscv/kvm/vcpu_sbi_replace.c |  34 ++---
 arch/riscv/kvm/vcpu_sbi_v01.c     |  35 +++--
 arch/riscv/kvm/vmid.c             |  10 +-
 7 files changed, 369 insertions(+), 53 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 61d8b40e3d82..a40e88a9481c 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/kvm.h>
 #include <linux/kvm_types.h>
+#include <linux/spinlock.h>
 #include <asm/csr.h>
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_timer.h>
@@ -26,6 +27,31 @@
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(1)
 #define KVM_REQ_UPDATE_HGATP		KVM_ARCH_REQ(2)
+#define KVM_REQ_FENCE_I			\
+	KVM_ARCH_REQ_FLAGS(3, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_HFENCE_GVMA_VMID_ALL	KVM_REQ_TLB_FLUSH
+#define KVM_REQ_HFENCE_VVMA_ALL		\
+	KVM_ARCH_REQ_FLAGS(4, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_HFENCE			\
+	KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+
+enum kvm_riscv_hfence_type {
+	KVM_RISCV_HFENCE_UNKNOWN = 0,
+	KVM_RISCV_HFENCE_GVMA_VMID_GPA,
+	KVM_RISCV_HFENCE_VVMA_ASID_GVA,
+	KVM_RISCV_HFENCE_VVMA_ASID_ALL,
+	KVM_RISCV_HFENCE_VVMA_GVA,
+};
+
+struct kvm_riscv_hfence {
+	enum kvm_riscv_hfence_type type;
+	unsigned long asid;
+	unsigned long order;
+	gpa_t addr;
+	gpa_t size;
+};
+
+#define KVM_RISCV_VCPU_MAX_HFENCE	64
 
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
@@ -178,6 +204,12 @@ struct kvm_vcpu_arch {
 	/* VCPU Timer */
 	struct kvm_vcpu_timer timer;
 
+	/* HFENCE request queue */
+	spinlock_t hfence_lock;
+	unsigned long hfence_head;
+	unsigned long hfence_tail;
+	struct kvm_riscv_hfence hfence_queue[KVM_RISCV_VCPU_MAX_HFENCE];
+
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
@@ -224,6 +256,33 @@ void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
 				     unsigned long order);
 void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
 
+void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
+void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu);
+void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
+void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu);
+
+void kvm_riscv_fence_i(struct kvm *kvm,
+		       unsigned long hbase, unsigned long hmask);
+void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
+				    unsigned long hbase, unsigned long hmask,
+				    gpa_t gpa, gpa_t gpsz,
+				    unsigned long order);
+void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
+				    unsigned long hbase, unsigned long hmask);
+void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
+				    unsigned long hbase, unsigned long hmask,
+				    unsigned long gva, unsigned long gvsz,
+				    unsigned long order, unsigned long asid);
+void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
+				    unsigned long hbase, unsigned long hmask,
+				    unsigned long asid);
+void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
+			       unsigned long hbase, unsigned long hmask,
+			       unsigned long gva, unsigned long gvsz,
+			       unsigned long order);
+void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
+			       unsigned long hbase, unsigned long hmask);
+
 int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 1e07603c905b..1c00695ebee7 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -18,7 +18,6 @@
 #include <asm/csr.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/sbi.h>
 
 #ifdef CONFIG_64BIT
 static unsigned long gstage_mode = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
@@ -73,13 +72,25 @@ static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
 	return -EINVAL;
 }
 
-static int gstage_level_to_page_size(u32 level, unsigned long *out_pgsize)
+static int gstage_level_to_page_order(u32 level, unsigned long *out_pgorder)
 {
 	if (gstage_pgd_levels < level)
 		return -EINVAL;
 
-	*out_pgsize = 1UL << (12 + (level * gstage_index_bits));
+	*out_pgorder = 12 + (level * gstage_index_bits);
+	return 0;
+}
 
+static int gstage_level_to_page_size(u32 level, unsigned long *out_pgsize)
+{
+	int rc;
+	unsigned long page_order = PAGE_SHIFT;
+
+	rc = gstage_level_to_page_order(level, &page_order);
+	if (rc)
+		return rc;
+
+	*out_pgsize = BIT(page_order);
 	return 0;
 }
 
@@ -114,21 +125,13 @@ static bool gstage_get_leaf_entry(struct kvm *kvm, gpa_t addr,
 
 static void gstage_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr)
 {
-	unsigned long size = PAGE_SIZE;
-	struct kvm_vmid *vmid = &kvm->arch.vmid;
+	unsigned long order = PAGE_SHIFT;
 
-	if (gstage_level_to_page_size(level, &size))
+	if (gstage_level_to_page_order(level, &order))
 		return;
-	addr &= ~(size - 1);
+	addr &= ~(BIT(order) - 1);
 
-	/*
-	 * TODO: Instead of cpu_online_mask, we should only target CPUs
-	 * where the Guest/VM is running.
-	 */
-	preempt_disable();
-	sbi_remote_hfence_gvma_vmid(cpu_online_mask, addr, size,
-				    READ_ONCE(vmid->vmid));
-	preempt_enable();
+	kvm_riscv_hfence_gvma_vmid_gpa(kvm, -1UL, 0, addr, BIT(order), order);
 }
 
 static int gstage_set_pte(struct kvm *kvm, u32 level,
diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index f817d3921973..9b5dacd44b56 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -3,11 +3,14 @@
  * Copyright (c) 2022 Ventana Micro Systems Inc.
  */
 
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
+#include <linux/cpumask.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/smp.h>
 #include <linux/kvm_host.h>
+#include <asm/cacheflush.h>
 #include <asm/csr.h>
 
 /* Page sizes supported in G-stage TLB entries */
@@ -229,3 +232,225 @@ void kvm_riscv_local_hfence_vvma_all(unsigned long vmid)
 
 	csr_write(CSR_HGATP, hgatp);
 }
+
+void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
+{
+	local_flush_icache_all();
+}
+
+void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vmid *vmid;
+
+	vmid = &vcpu->kvm->arch.vmid;
+	kvm_riscv_local_hfence_gvma_vmid_all(READ_ONCE(vmid->vmid));
+}
+
+void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vmid *vmid;
+
+	vmid = &vcpu->kvm->arch.vmid;
+	kvm_riscv_local_hfence_vvma_all(READ_ONCE(vmid->vmid));
+}
+
+static bool vcpu_hfence_dequeue(struct kvm_vcpu *vcpu,
+				struct kvm_riscv_hfence *out_data)
+{
+	bool ret = false;
+	struct kvm_vcpu_arch *varch = &vcpu->arch;
+
+	spin_lock(&varch->hfence_lock);
+
+	if (varch->hfence_queue[varch->hfence_head].type) {
+		memcpy(out_data, &varch->hfence_queue[varch->hfence_head],
+		       sizeof(*out_data));
+		varch->hfence_queue[varch->hfence_head].type = 0;
+
+		varch->hfence_head++;
+		if (varch->hfence_head == KVM_RISCV_VCPU_MAX_HFENCE)
+			varch->hfence_head = 0;
+
+		ret = true;
+	}
+
+	spin_unlock(&varch->hfence_lock);
+
+	return ret;
+}
+
+static bool vcpu_hfence_enqueue(struct kvm_vcpu *vcpu,
+				const struct kvm_riscv_hfence *data)
+{
+	bool ret = false;
+	struct kvm_vcpu_arch *varch = &vcpu->arch;
+
+	spin_lock(&varch->hfence_lock);
+
+	if (!varch->hfence_queue[varch->hfence_tail].type) {
+		memcpy(&varch->hfence_queue[varch->hfence_tail],
+		       data, sizeof(*data));
+
+		varch->hfence_tail++;
+		if (varch->hfence_tail == KVM_RISCV_VCPU_MAX_HFENCE)
+			varch->hfence_tail = 0;
+
+		ret = true;
+	}
+
+	spin_unlock(&varch->hfence_lock);
+
+	return ret;
+}
+
+void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
+{
+	struct kvm_riscv_hfence d = { 0 };
+	struct kvm_vmid *v = &vcpu->kvm->arch.vmid;
+
+	while (vcpu_hfence_dequeue(vcpu, &d)) {
+		switch (d.type) {
+		case KVM_RISCV_HFENCE_UNKNOWN:
+			break;
+		case KVM_RISCV_HFENCE_GVMA_VMID_GPA:
+			kvm_riscv_local_hfence_gvma_vmid_gpa(
+						READ_ONCE(v->vmid),
+						d.addr, d.size, d.order);
+			break;
+		case KVM_RISCV_HFENCE_VVMA_ASID_GVA:
+			kvm_riscv_local_hfence_vvma_asid_gva(
+						READ_ONCE(v->vmid), d.asid,
+						d.addr, d.size, d.order);
+			break;
+		case KVM_RISCV_HFENCE_VVMA_ASID_ALL:
+			kvm_riscv_local_hfence_vvma_asid_all(
+						READ_ONCE(v->vmid), d.asid);
+			break;
+		case KVM_RISCV_HFENCE_VVMA_GVA:
+			kvm_riscv_local_hfence_vvma_gva(
+						READ_ONCE(v->vmid),
+						d.addr, d.size, d.order);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void make_xfence_request(struct kvm *kvm,
+				unsigned long hbase, unsigned long hmask,
+				unsigned int req, unsigned int fallback_req,
+				const struct kvm_riscv_hfence *data)
+{
+	unsigned long i;
+	struct kvm_vcpu *vcpu;
+	unsigned int actual_req = req;
+	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
+
+	bitmap_clear(vcpu_mask, 0, KVM_MAX_VCPUS);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (hbase != -1UL) {
+			if (vcpu->vcpu_id < hbase)
+				continue;
+			if (!(hmask & (1UL << (vcpu->vcpu_id - hbase))))
+				continue;
+		}
+
+		bitmap_set(vcpu_mask, i, 1);
+
+		if (!data || !data->type)
+			continue;
+
+		/*
+		 * Enqueue hfence data to VCPU hfence queue. If we don't
+		 * have space in the VCPU hfence queue then fallback to
+		 * a more conservative hfence request.
+		 */
+		if (!vcpu_hfence_enqueue(vcpu, data))
+			actual_req = fallback_req;
+	}
+
+	kvm_make_vcpus_request_mask(kvm, actual_req, vcpu_mask);
+}
+
+void kvm_riscv_fence_i(struct kvm *kvm,
+		       unsigned long hbase, unsigned long hmask)
+{
+	make_xfence_request(kvm, hbase, hmask, KVM_REQ_FENCE_I,
+			    KVM_REQ_FENCE_I, NULL);
+}
+
+void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
+				    unsigned long hbase, unsigned long hmask,
+				    gpa_t gpa, gpa_t gpsz,
+				    unsigned long order)
+{
+	struct kvm_riscv_hfence data;
+
+	data.type = KVM_RISCV_HFENCE_GVMA_VMID_GPA;
+	data.asid = 0;
+	data.addr = gpa;
+	data.size = gpsz;
+	data.order = order;
+	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
+			    KVM_REQ_HFENCE_GVMA_VMID_ALL, &data);
+}
+
+void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
+				    unsigned long hbase, unsigned long hmask)
+{
+	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE_GVMA_VMID_ALL,
+			    KVM_REQ_HFENCE_GVMA_VMID_ALL, NULL);
+}
+
+void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
+				    unsigned long hbase, unsigned long hmask,
+				    unsigned long gva, unsigned long gvsz,
+				    unsigned long order, unsigned long asid)
+{
+	struct kvm_riscv_hfence data;
+
+	data.type = KVM_RISCV_HFENCE_VVMA_ASID_GVA;
+	data.asid = asid;
+	data.addr = gva;
+	data.size = gvsz;
+	data.order = order;
+	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
+			    KVM_REQ_HFENCE_VVMA_ALL, &data);
+}
+
+void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
+				    unsigned long hbase, unsigned long hmask,
+				    unsigned long asid)
+{
+	struct kvm_riscv_hfence data;
+
+	data.type = KVM_RISCV_HFENCE_VVMA_ASID_ALL;
+	data.asid = asid;
+	data.addr = data.size = data.order = 0;
+	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
+			    KVM_REQ_HFENCE_VVMA_ALL, &data);
+}
+
+void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
+			       unsigned long hbase, unsigned long hmask,
+			       unsigned long gva, unsigned long gvsz,
+			       unsigned long order)
+{
+	struct kvm_riscv_hfence data;
+
+	data.type = KVM_RISCV_HFENCE_VVMA_GVA;
+	data.asid = 0;
+	data.addr = gva;
+	data.size = gvsz;
+	data.order = order;
+	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
+			    KVM_REQ_HFENCE_VVMA_ALL, &data);
+}
+
+void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
+			       unsigned long hbase, unsigned long hmask)
+{
+	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE_VVMA_ALL,
+			    KVM_REQ_HFENCE_VVMA_ALL, NULL);
+}
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index dbf6b8d73e23..6d81c0a30ef3 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -76,6 +76,10 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
 	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 
+	vcpu->arch.hfence_head = 0;
+	vcpu->arch.hfence_tail = 0;
+	memset(vcpu->arch.hfence_queue, 0, sizeof(vcpu->arch.hfence_queue));
+
 	/* Reset the guest CSRs for hotplug usecase */
 	if (loaded)
 		kvm_arch_vcpu_load(vcpu, smp_processor_id());
@@ -99,6 +103,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Setup ISA features available to VCPU */
 	vcpu->arch.isa = riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED;
 
+	/* Setup VCPU hfence queue */
+	spin_lock_init(&vcpu->arch.hfence_lock);
+
 	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
 	cntx = &vcpu->arch.guest_reset_context;
 	cntx->sstatus = SR_SPP | SR_SPIE;
@@ -689,8 +696,21 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_UPDATE_HGATP, vcpu))
 			kvm_riscv_gstage_update_hgatp(vcpu);
 
-		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
-			kvm_riscv_local_hfence_gvma_all();
+		if (kvm_check_request(KVM_REQ_FENCE_I, vcpu))
+			kvm_riscv_fence_i_process(vcpu);
+
+		/*
+		 * The generic KVM_REQ_TLB_FLUSH is same as
+		 * KVM_REQ_HFENCE_GVMA_VMID_ALL
+		 */
+		if (kvm_check_request(KVM_REQ_HFENCE_GVMA_VMID_ALL, vcpu))
+			kvm_riscv_hfence_gvma_vmid_all_process(vcpu);
+
+		if (kvm_check_request(KVM_REQ_HFENCE_VVMA_ALL, vcpu))
+			kvm_riscv_hfence_vvma_all_process(vcpu);
+
+		if (kvm_check_request(KVM_REQ_HFENCE, vcpu))
+			kvm_riscv_hfence_process(vcpu);
 	}
 }
 
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 3c1dcd38358e..4c034d8a606a 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -81,37 +81,31 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 				      struct kvm_cpu_trap *utrap, bool *exit)
 {
 	int ret = 0;
-	unsigned long i;
-	struct cpumask cm;
-	struct kvm_vcpu *tmp;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 	unsigned long hmask = cp->a0;
 	unsigned long hbase = cp->a1;
 	unsigned long funcid = cp->a6;
 
-	cpumask_clear(&cm);
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
-		if (hbase != -1UL) {
-			if (tmp->vcpu_id < hbase)
-				continue;
-			if (!(hmask & (1UL << (tmp->vcpu_id - hbase))))
-				continue;
-		}
-		if (tmp->cpu < 0)
-			continue;
-		cpumask_set_cpu(tmp->cpu, &cm);
-	}
-
 	switch (funcid) {
 	case SBI_EXT_RFENCE_REMOTE_FENCE_I:
-		ret = sbi_remote_fence_i(&cm);
+		kvm_riscv_fence_i(vcpu->kvm, hbase, hmask);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
-		ret = sbi_remote_hfence_vvma(&cm, cp->a2, cp->a3);
+		if (cp->a2 == 0 && cp->a3 == 0)
+			kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, hmask);
+		else
+			kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask,
+						  cp->a2, cp->a3, PAGE_SHIFT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
-		ret = sbi_remote_hfence_vvma_asid(&cm, cp->a2,
-						  cp->a3, cp->a4);
+		if (cp->a2 == 0 && cp->a3 == 0)
+			kvm_riscv_hfence_vvma_asid_all(vcpu->kvm,
+						       hbase, hmask, cp->a4);
+		else
+			kvm_riscv_hfence_vvma_asid_gva(vcpu->kvm,
+						       hbase, hmask,
+						       cp->a2, cp->a3,
+						       PAGE_SHIFT, cp->a4);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
index da4d6c99c2cf..8a91a14e7139 100644
--- a/arch/riscv/kvm/vcpu_sbi_v01.c
+++ b/arch/riscv/kvm/vcpu_sbi_v01.c
@@ -23,7 +23,6 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	int i, ret = 0;
 	u64 next_cycle;
 	struct kvm_vcpu *rvcpu;
-	struct cpumask cm;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 
@@ -80,19 +79,29 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (utrap->scause)
 			break;
 
-		cpumask_clear(&cm);
-		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
-			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
-			if (rvcpu->cpu < 0)
-				continue;
-			cpumask_set_cpu(rvcpu->cpu, &cm);
-		}
 		if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
-			ret = sbi_remote_fence_i(&cm);
-		else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
-			ret = sbi_remote_hfence_vvma(&cm, cp->a1, cp->a2);
-		else
-			ret = sbi_remote_hfence_vvma_asid(&cm, cp->a1, cp->a2, cp->a3);
+			kvm_riscv_fence_i(vcpu->kvm, 0, hmask);
+		else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA) {
+			if (cp->a1 == 0 && cp->a2 == 0)
+				kvm_riscv_hfence_vvma_all(vcpu->kvm,
+							  0, hmask);
+			else
+				kvm_riscv_hfence_vvma_gva(vcpu->kvm,
+							  0, hmask,
+							  cp->a1, cp->a2,
+							  PAGE_SHIFT);
+		} else {
+			if (cp->a1 == 0 && cp->a2 == 0)
+				kvm_riscv_hfence_vvma_asid_all(vcpu->kvm,
+							       0, hmask,
+							       cp->a3);
+			else
+				kvm_riscv_hfence_vvma_asid_gva(vcpu->kvm,
+							       0, hmask,
+							       cp->a1, cp->a2,
+							       PAGE_SHIFT,
+							       cp->a3);
+		}
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 8987e76aa6db..9f764df125db 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -11,9 +11,9 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/smp.h>
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
-#include <asm/sbi.h>
 
 static unsigned long vmid_version = 1;
 static unsigned long vmid_next;
@@ -63,6 +63,11 @@ bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid)
 			READ_ONCE(vmid_version));
 }
 
+static void __local_hfence_gvma_all(void *info)
+{
+	kvm_riscv_local_hfence_gvma_all();
+}
+
 void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu)
 {
 	unsigned long i;
@@ -101,7 +106,8 @@ void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu)
 		 * running, we force VM exits on all host CPUs using IPI and
 		 * flush all Guest TLBs.
 		 */
-		sbi_remote_hfence_gvma(cpu_online_mask, 0, 0);
+		on_each_cpu_mask(cpu_online_mask, __local_hfence_gvma_all,
+				 NULL, 1);
 	}
 
 	vmid->vmid = vmid_next;
-- 
2.25.1

