Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80DD5764ED
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbiGOQBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 12:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiGOQAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 12:00:50 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DA76D2CE
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:00:49 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id r9so8498112lfp.10
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DgAPxu68EVPkc4OcXPg6lrRhMAAc/3X1Z7wfY7wDJ3U=;
        b=c3pigEntsf04zOudkz13PWuERnOm3JGaha7ZtSo12Gx0iyVKVLLJh3nx2XmwUpW9Qk
         IFJ+8W8MojdtRDFQzuXoiNwWT4R1e2Q88A3f6VJTTEo4tdP+6DNhfXtXntUSFcSCEmrj
         SSaFXTA4JJk1KIL0oWbMeJKCB4i1hirIOMoJDDvKNim6/L6oHM7/J3Rfu651Z+cL92AX
         TY9gwcdrrmo5QKFS0T60fL+PQVyflyCqwHDEtTrb2RQVviPUP6pk1W+Sd47Oo8XrbPxZ
         oviuJkuZVCskdPfHbtvpXN2jKncLjlXyZ/fNL8uhpS4yYc2j0oLHRSP8wDmeT3099Yot
         LeBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DgAPxu68EVPkc4OcXPg6lrRhMAAc/3X1Z7wfY7wDJ3U=;
        b=SXGsCh1YP2dbRRwXDJycMx32ANXYz6j6AAiDTVNEl6k+YNhr+oDM3Tg9iPmvbVdkK/
         /Cc6Ugrmdvk1z34GuAaFDDL3Nlb3TUwQe6NO/3joih1dHVZ9qdn2sEYKPO84qgW/pEH5
         eU9q+DyavIpEWC4eXv52ZzUt6e9ACl4dl7hvBtUjg604XJQzQSXbt/3FMIB15ofpP1+M
         L9j0YWWEgt2cMtXbETUIbkDk3Bi5Qm/5prNgdSkErx/vQs0JUWHOG1OCDGx8VHFR5qTT
         uYE9Ayv7y8AdxKhZA5b5rueYK2eqRfa9mMvrDKliTt4Rj5r443z1pOfVLOfUt36GNn1s
         EmGQ==
X-Gm-Message-State: AJIora/s3f29BuUKgjLgcwr2G77DNwqWoVqK0I7grw4DC8DQhxqvTPik
        idJIQpojmHYctGyXptuvkxs60A==
X-Google-Smtp-Source: AGRyM1sbzYJhb18o98f9MdFFNNzGM12AOEM2tI0+vol9eP8w3ZZxCYT6S++sWpvSZ4Fj5mVDm4ghnw==
X-Received: by 2002:a05:6512:1096:b0:489:cbad:de4f with SMTP id j22-20020a056512109600b00489cbadde4fmr8499188lfg.164.1657900847021;
        Fri, 15 Jul 2022 09:00:47 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id c12-20020a056512238c00b0047968606114sm959772lfv.111.2022.07.15.09.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 09:00:46 -0700 (PDT)
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
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>,
        Dmytro Maluka <dmy@semihalf.com>
Subject: [PATCH 1/3] KVM: x86: Move kvm_(un)register_irq_mask_notifier() to generic KVM
Date:   Fri, 15 Jul 2022 17:59:26 +0200
Message-Id: <20220715155928.26362-2-dmy@semihalf.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220715155928.26362-1-dmy@semihalf.com>
References: <20220715155928.26362-1-dmy@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for implementing postponing resamplefd event until the
interrupt is unmasked, move kvm_(un)register_irq_mask_notifier() from
x86 to arch-independent code to make it usable by irqfd.

Note that calling mask notifiers is still implemented for x86 only, so
registering mask notifiers on non-x86 will have no effect.

Link: https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com/
Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
---
 arch/x86/include/asm/kvm_host.h | 10 ----------
 arch/x86/kvm/irq_comm.c         | 18 ------------------
 include/linux/kvm_host.h        | 10 ++++++++++
 virt/kvm/eventfd.c              | 18 ++++++++++++++++++
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9217bd6cf0d1..39a867d68721 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1688,16 +1688,6 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
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
 void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
 			     bool mask);
 
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 0687162c4f22..43e13892ed34 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -234,24 +234,6 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
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
 void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
 			     bool mask)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 90a45ef7203b..9e12ef503157 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1581,6 +1581,12 @@ struct kvm_irq_ack_notifier {
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
@@ -1599,6 +1605,10 @@ void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
 void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
+void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
+				    struct kvm_irq_mask_notifier *kimn);
+void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
+				      struct kvm_irq_mask_notifier *kimn);
 int kvm_request_irq_source_id(struct kvm *kvm);
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2a3ed401ce46..50ddb1d1a7f0 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -520,6 +520,24 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 }
 #endif
 
+void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
+				    struct kvm_irq_mask_notifier *kimn)
+{
+	mutex_lock(&kvm->irq_lock);
+	kimn->irq = irq;
+	hlist_add_head_rcu(&kimn->link, &kvm->arch.mask_notifier_list);
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
 void
 kvm_eventfd_init(struct kvm *kvm)
 {
-- 
2.37.0.170.g444d1eabd0-goog

