Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3DE58B072
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241464AbiHETk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241421AbiHETkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:40:53 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C3511468
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:40:52 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id x39so4755374lfu.7
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=0bqeAVxOv1cvt506AIyaShQcLeSdfwwBjFLTn7gNzK4=;
        b=f+F1IOVIZjUPQzuXQjLojG+pXD/2sSikKxH++DYAxDArMLZIaUoZP8lbDkzAlcjMUE
         3W1VS4h7HTzzTgV8Rsi/LHB//SqzkqQmMnYRFk+p6ziWmHaNhHKVonZ9XA3/AE4MwK9I
         RajpOltnDRXaQ71wGyWRXMWHkU3GeLbwsqgBIKwzfTf41/bYJGWldMdHFUc2Pj1ml54W
         Ct6J49rpys0VfRvRk2Y6jZ95BcFSOOONBGH9pE/h/2FpmdEh6vH3BckAFsVmkP8CT4mB
         VfTaB4xrqr7TKe5Zv+rWY706d7g9ZLpEJL6Q7hBB2/gtLGPEpL+GsgEkfiIjln+JgsL9
         dsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=0bqeAVxOv1cvt506AIyaShQcLeSdfwwBjFLTn7gNzK4=;
        b=gvg5Y3iza4o7U3mhfryantrrDTdsgOGtD2soqGbqvx4iEF1js+jTA7nsLJQtpKTHkf
         Ol0uUtaL12U53B1IkPn/VmW5r8cOCsq/FUSaQkJcdG7Pd33ps0NlGioMkUbRA40bRP3f
         B0K1CDWyEyrHYK+pdUxK/LaLC2JY9yFagv0TZ7SdK8+Jkxt9uK3phTU00+UOKSZEcc09
         PpcXue43ZhOqu8mbv2+R2q4K0SWk/U2KopCep2QmdAaXgetX0V55kcTE2KBfpgFI+7Io
         x2ge7K/dwIAO4wfbjX+O/6t5slgMGofCnVOLvusJiyn4NdAdBSYROVBHHlru+mc+65BL
         m+oA==
X-Gm-Message-State: ACgBeo1ZM6NeZgTGXt5iO8SesbX2wirMuE3l2JVtrH3ZSyOsUqcZ9jE0
        qtAzFYgKQooqftsUIcl97cp0zA==
X-Google-Smtp-Source: AA6agR76FJBZdHn7btHunKBLYS4zn4FmHKBrHNCN2JU1T8z3s5vYHmzhIOcyrYHULuYztfgrwHMXQg==
X-Received: by 2002:a05:6512:1283:b0:48b:9817:ce2b with SMTP id u3-20020a056512128300b0048b9817ce2bmr206194lfs.417.1659728451592;
        Fri, 05 Aug 2022 12:40:51 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id o4-20020a056512230400b0048a407f41bbsm560079lfu.238.2022.08.05.12.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:40:51 -0700 (PDT)
From:   Dmytro Maluka <dmy@semihalf.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>,
        Dmytro Maluka <dmy@semihalf.com>
Subject: [PATCH v2 1/5] KVM: x86: Move irq mask notifiers from x86 to generic KVM
Date:   Fri,  5 Aug 2022 21:39:15 +0200
Message-Id: <20220805193919.1470653-2-dmy@semihalf.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
In-Reply-To: <20220805193919.1470653-1-dmy@semihalf.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
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

Currently irq mask notifiers are used only internally in the x86 code
for PIT emulation. However they are not really arch specific. We are
going to use them in the generic irqfd code, for postponing resampler
irqfd notification until the interrupt is unmasked. So move the
implementation of mask notifiers to the generic code, to allow irqfd to
register its mask notifiers.

Note that calling mask notifiers via calling kvm_fire_mask_notifiers()
is still implemented for x86 only, so registering mask notifiers on
other architectures will have no effect for now.

Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
---
 arch/x86/include/asm/kvm_host.h | 16 ----------------
 arch/x86/kvm/irq_comm.c         | 33 ---------------------------------
 arch/x86/kvm/x86.c              |  1 -
 include/linux/kvm_host.h        | 15 +++++++++++++++
 virt/kvm/eventfd.c              | 33 +++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c             |  1 +
 6 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9217bd6cf0d1..dc76617f11c1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1198,9 +1198,6 @@ struct kvm_arch {
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
-	/* reads protected by irq_srcu, writes by irq_lock */
-	struct hlist_head mask_notifier_list;
-
 	struct kvm_hv hyperv;
 	struct kvm_xen xen;
 
@@ -1688,19 +1685,6 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  const void *val, int bytes);
 
-struct kvm_irq_mask_notifier {
-	void (*func)(struct kvm_irq_mask_notifier *kimn, bool masked);
-	int irq;
-	struct hlist_node link;
-};
-
-void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
-				    struct kvm_irq_mask_notifier *kimn);
-void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
-				      struct kvm_irq_mask_notifier *kimn);
-void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
-			     bool mask);
-
 extern bool tdp_enabled;
 
 u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 0687162c4f22..f27e4c9c403e 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -234,39 +234,6 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 	mutex_unlock(&kvm->irq_lock);
 }
 
-void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
-				    struct kvm_irq_mask_notifier *kimn)
-{
-	mutex_lock(&kvm->irq_lock);
-	kimn->irq = irq;
-	hlist_add_head_rcu(&kimn->link, &kvm->arch.mask_notifier_list);
-	mutex_unlock(&kvm->irq_lock);
-}
-
-void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
-				      struct kvm_irq_mask_notifier *kimn)
-{
-	mutex_lock(&kvm->irq_lock);
-	hlist_del_rcu(&kimn->link);
-	mutex_unlock(&kvm->irq_lock);
-	synchronize_srcu(&kvm->irq_srcu);
-}
-
-void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
-			     bool mask)
-{
-	struct kvm_irq_mask_notifier *kimn;
-	int idx, gsi;
-
-	idx = srcu_read_lock(&kvm->irq_srcu);
-	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
-	if (gsi != -1)
-		hlist_for_each_entry_rcu(kimn, &kvm->arch.mask_notifier_list, link)
-			if (kimn->irq == gsi)
-				kimn->func(kimn, mask);
-	srcu_read_unlock(&kvm->irq_srcu, idx);
-}
-
 bool kvm_arch_can_set_irq_routing(struct kvm *kvm)
 {
 	return irqchip_in_kernel(kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5fa335a4ea7..a0a776f5c42f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11818,7 +11818,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_page_track;
 
-	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 90a45ef7203b..dd5f14e31996 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -760,7 +760,10 @@ struct kvm {
 	struct kvm_irq_routing_table __rcu *irq_routing;
 #endif
 #ifdef CONFIG_HAVE_KVM_IRQFD
+	/* reads protected by irq_srcu, writes by irq_lock */
 	struct hlist_head irq_ack_notifier_list;
+	/* reads protected by irq_srcu, writes by irq_lock */
+	struct hlist_head irq_mask_notifier_list;
 #endif
 
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
@@ -1581,6 +1584,12 @@ struct kvm_irq_ack_notifier {
 	void (*irq_acked)(struct kvm_irq_ack_notifier *kian);
 };
 
+struct kvm_irq_mask_notifier {
+	void (*func)(struct kvm_irq_mask_notifier *kimn, bool masked);
+	int irq;
+	struct hlist_node link;
+};
+
 int kvm_irq_map_gsi(struct kvm *kvm,
 		    struct kvm_kernel_irq_routing_entry *entries, int gsi);
 int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin);
@@ -1599,6 +1608,12 @@ void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
 void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
+void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
+				    struct kvm_irq_mask_notifier *kimn);
+void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
+				      struct kvm_irq_mask_notifier *kimn);
+void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
+			     bool mask);
 int kvm_request_irq_source_id(struct kvm *kvm);
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2a3ed401ce46..39403d9fbdcc 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -518,6 +518,39 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 	synchronize_srcu(&kvm->irq_srcu);
 	kvm_arch_post_irq_ack_notifier_list_update(kvm);
 }
+
+void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
+				    struct kvm_irq_mask_notifier *kimn)
+{
+	mutex_lock(&kvm->irq_lock);
+	kimn->irq = irq;
+	hlist_add_head_rcu(&kimn->link, &kvm->irq_mask_notifier_list);
+	mutex_unlock(&kvm->irq_lock);
+}
+
+void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
+				      struct kvm_irq_mask_notifier *kimn)
+{
+	mutex_lock(&kvm->irq_lock);
+	hlist_del_rcu(&kimn->link);
+	mutex_unlock(&kvm->irq_lock);
+	synchronize_srcu(&kvm->irq_srcu);
+}
+
+void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
+			     bool mask)
+{
+	struct kvm_irq_mask_notifier *kimn;
+	int idx, gsi;
+
+	idx = srcu_read_lock(&kvm->irq_srcu);
+	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
+	if (gsi != -1)
+		hlist_for_each_entry_rcu(kimn, &kvm->irq_mask_notifier_list, link)
+			if (kimn->irq == gsi)
+				kimn->func(kimn, mask);
+	srcu_read_unlock(&kvm->irq_srcu, idx);
+}
 #endif
 
 void
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a49df8988cd6..5ca7fb0b8257 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1144,6 +1144,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 #ifdef CONFIG_HAVE_KVM_IRQFD
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
+	INIT_HLIST_HEAD(&kvm->irq_mask_notifier_list);
 #endif
 
 	r = kvm_init_mmu_notifier(kvm);
-- 
2.37.1.559.g78731f0fdb-goog

