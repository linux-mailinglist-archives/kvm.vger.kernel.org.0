Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDD368F03F
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 15:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjBHOCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 09:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjBHOCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 09:02:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3990171F
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 06:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675864890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xaX8AFU4eXpjF5vFLIr2G/vAGGTB312aKfxgXhyjr+Q=;
        b=h2lKHYdHMX6oupcq2tpLyPZ5PjRPomTk/ztEWUOmcqUslHK7DHYzo0TKO38HNOwW+DgO82
        Y8MEtDo4cKGtrOAhPWbvTWDcGlxAb0AWS5o2iL6/0kTXAlm6dnTqcNgbzAJnmnlaP3Dqgf
        Yhp0oW0NROYH+G3gvhH99Xqj9MynYCc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-ewBUSS54Nx6yfoiILEwowg-1; Wed, 08 Feb 2023 09:01:28 -0500
X-MC-Unique: ewBUSS54Nx6yfoiILEwowg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF29F824018;
        Wed,  8 Feb 2023 14:01:23 +0000 (UTC)
Received: from thuth.com (unknown [10.39.193.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 146481415113;
        Wed,  8 Feb 2023 14:01:19 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 1/6] KVM: PPC: Standardize on "int" return types in the powerpc KVM code
Date:   Wed,  8 Feb 2023 15:01:00 +0100
Message-Id: <20230208140105.655814-2-thuth@redhat.com>
In-Reply-To: <20230208140105.655814-1-thuth@redhat.com>
References: <20230208140105.655814-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most functions that are related to kvm_arch_vm_ioctl() already use
"int" as return type to pass error values back to the caller. Some
outlier functions use "long" instead for no good reason (they do not
really require long values here). Let's standardize on "int" here to
avoid casting the values back and forth between the two types.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h  | 14 +++++++-------
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 14 +++++++-------
 arch/powerpc/kvm/book3s_64_vio.c    |  4 ++--
 arch/powerpc/kvm/book3s_hv.c        |  6 +++---
 arch/powerpc/kvm/book3s_pr.c        |  4 ++--
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index eae9619b6190..41ab4ebdc1ee 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -157,7 +157,7 @@ extern void kvmppc_map_magic(struct kvm_vcpu *vcpu);
 
 extern int kvmppc_allocate_hpt(struct kvm_hpt_info *info, u32 order);
 extern void kvmppc_set_hpt(struct kvm *kvm, struct kvm_hpt_info *info);
-extern long kvmppc_alloc_reset_hpt(struct kvm *kvm, int order);
+extern int kvmppc_alloc_reset_hpt(struct kvm *kvm, int order);
 extern void kvmppc_free_hpt(struct kvm_hpt_info *info);
 extern void kvmppc_rmap_reset(struct kvm *kvm);
 extern void kvmppc_map_vrma(struct kvm_vcpu *vcpu,
@@ -171,7 +171,7 @@ extern int kvmppc_switch_mmu_to_hpt(struct kvm *kvm);
 extern int kvmppc_switch_mmu_to_radix(struct kvm *kvm);
 extern void kvmppc_setup_partition_table(struct kvm *kvm);
 
-extern long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
+extern int kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 				struct kvm_create_spapr_tce_64 *args);
 #define kvmppc_ioba_validate(stt, ioba, npages)                         \
 		(iommu_tce_check_ioba((stt)->page_shift, (stt)->offset, \
@@ -212,10 +212,10 @@ extern void kvmppc_bookehv_exit(void);
 extern int kvmppc_prepare_to_enter(struct kvm_vcpu *vcpu);
 
 extern int kvm_vm_ioctl_get_htab_fd(struct kvm *kvm, struct kvm_get_htab_fd *);
-extern long kvm_vm_ioctl_resize_hpt_prepare(struct kvm *kvm,
-					    struct kvm_ppc_resize_hpt *rhpt);
-extern long kvm_vm_ioctl_resize_hpt_commit(struct kvm *kvm,
+extern int kvm_vm_ioctl_resize_hpt_prepare(struct kvm *kvm,
 					   struct kvm_ppc_resize_hpt *rhpt);
+extern int kvm_vm_ioctl_resize_hpt_commit(struct kvm *kvm,
+					  struct kvm_ppc_resize_hpt *rhpt);
 
 int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt *irq);
 
@@ -287,8 +287,8 @@ struct kvmppc_ops {
 	int (*emulate_mtspr)(struct kvm_vcpu *vcpu, int sprn, ulong spr_val);
 	int (*emulate_mfspr)(struct kvm_vcpu *vcpu, int sprn, ulong *spr_val);
 	void (*fast_vcpu_kick)(struct kvm_vcpu *vcpu);
-	long (*arch_vm_ioctl)(struct file *filp, unsigned int ioctl,
-			      unsigned long arg);
+	int (*arch_vm_ioctl)(struct file *filp, unsigned int ioctl,
+			     unsigned long arg);
 	int (*hcall_implemented)(unsigned long hcall);
 	int (*irq_bypass_add_producer)(struct irq_bypass_consumer *,
 				       struct irq_bypass_producer *);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 7006bcbc2e37..1f4896de58ca 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -124,9 +124,9 @@ void kvmppc_set_hpt(struct kvm *kvm, struct kvm_hpt_info *info)
 		 info->virt, (long)info->order, kvm->arch.lpid);
 }
 
-long kvmppc_alloc_reset_hpt(struct kvm *kvm, int order)
+int kvmppc_alloc_reset_hpt(struct kvm *kvm, int order)
 {
-	long err = -EBUSY;
+	int err = -EBUSY;
 	struct kvm_hpt_info info;
 
 	mutex_lock(&kvm->arch.mmu_setup_lock);
@@ -1468,8 +1468,8 @@ static void resize_hpt_prepare_work(struct work_struct *work)
 	mutex_unlock(&kvm->arch.mmu_setup_lock);
 }
 
-long kvm_vm_ioctl_resize_hpt_prepare(struct kvm *kvm,
-				     struct kvm_ppc_resize_hpt *rhpt)
+int kvm_vm_ioctl_resize_hpt_prepare(struct kvm *kvm,
+				    struct kvm_ppc_resize_hpt *rhpt)
 {
 	unsigned long flags = rhpt->flags;
 	unsigned long shift = rhpt->shift;
@@ -1534,13 +1534,13 @@ static void resize_hpt_boot_vcpu(void *opaque)
 	/* Nothing to do, just force a KVM exit */
 }
 
-long kvm_vm_ioctl_resize_hpt_commit(struct kvm *kvm,
-				    struct kvm_ppc_resize_hpt *rhpt)
+int kvm_vm_ioctl_resize_hpt_commit(struct kvm *kvm,
+				   struct kvm_ppc_resize_hpt *rhpt)
 {
 	unsigned long flags = rhpt->flags;
 	unsigned long shift = rhpt->shift;
 	struct kvm_resize_hpt *resize;
-	long ret;
+	int ret;
 
 	if (flags != 0 || kvm_is_radix(kvm))
 		return -EINVAL;
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 95e738ef9062..93b695b289e9 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -288,8 +288,8 @@ static const struct file_operations kvm_spapr_tce_fops = {
 	.release	= kvm_spapr_tce_release,
 };
 
-long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
-				   struct kvm_create_spapr_tce_64 *args)
+int kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
+				  struct kvm_create_spapr_tce_64 *args)
 {
 	struct kvmppc_spapr_tce_table *stt = NULL;
 	struct kvmppc_spapr_tce_table *siter;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6ba68dd6190b..cd139a1edc67 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5779,12 +5779,12 @@ static void kvmppc_irq_bypass_del_producer_hv(struct irq_bypass_consumer *cons,
 }
 #endif
 
-static long kvm_arch_vm_ioctl_hv(struct file *filp,
-				 unsigned int ioctl, unsigned long arg)
+static int kvm_arch_vm_ioctl_hv(struct file *filp,
+				unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm __maybe_unused = filp->private_data;
 	void __user *argp = (void __user *)arg;
-	long r;
+	int r;
 
 	switch (ioctl) {
 
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 9fc4dd8f66eb..5908b514bfb6 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -2042,8 +2042,8 @@ static int kvmppc_core_check_processor_compat_pr(void)
 	return 0;
 }
 
-static long kvm_arch_vm_ioctl_pr(struct file *filp,
-				 unsigned int ioctl, unsigned long arg)
+static int kvm_arch_vm_ioctl_pr(struct file *filp,
+				unsigned int ioctl, unsigned long arg)
 {
 	return -ENOTTY;
 }
-- 
2.31.1

