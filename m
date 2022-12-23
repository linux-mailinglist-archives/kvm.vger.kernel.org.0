Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAA0654A4C
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 02:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbiLWBA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 20:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235845AbiLWA7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:59:49 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9623C31DD0
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:58:30 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id a72-20020a63904b000000b00489753edf13so1898902pge.21
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=F68NRl2pI2gfNuGgfMnIAWelg21w3HsZ2MQHgdeJqA4=;
        b=msOJNFnhoMnqI73ZE5Z/qzHzk1j1M17RXCGluQf+a1yGw+P+1l2k09p3c4nsLWzmnN
         pGJWlqgSqAKnQE3mahhPADrmGu8jPVkEdf0n9y9CcUlINRrJ+5so3C4FqghwM1Rjeeyr
         dO8UGzGKn9lb1P79acr83Jg8pns4LgY5d0brjPfAzfMfNjGLfV912nDbKkrVinnQzvaP
         jDbT/T79j+5jmmgUG3JcATGeYhCiOKtdGiG9lC69hUz4SGXmq4dZN5jaYHcfXLF5ZhVn
         NQs6RGxqIHtcjcBmeXaX4Av/w15ydZTZs/qHPs1i3mEu6rnjqULNOFXAC2qPXEVe/gdv
         PlxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F68NRl2pI2gfNuGgfMnIAWelg21w3HsZ2MQHgdeJqA4=;
        b=i7YJxi/RDzhN0l33zGvFR8gaN3FMika9+Ka3LfvJL1tnWvvLshF94hcTMMT0fB0Jg8
         7CY7WGSOkHse1tktktY3P62hXnoHHDsJq2Bi59ACh9lF1GzgTxgzbKcPhFCWBnAato6D
         Q1rwo3l04rALr0oMhJL86dgtDHGH7pvIR3VFr1okwGcCP3Q6ibtFA8U0PTBa4uF/vtM4
         vEErObNwlGo2hLh8oaoILeCKzi7+cdsimBmORdQkuqhvPl+ZuXZ3Z9FTJt3Yx/9QSuyC
         wZTK+ClWzR8yjhtSdFPL7ZDbwWc5LHKBif024AGoQLy7Uhpw9Zk6eC4fvbCRA3pMMveY
         yU5A==
X-Gm-Message-State: AFqh2kqM/H2hSL7f9jgm3/Kx9vamPXskD0pFBVJL92BN51SFH97KdeyO
        W1/RD+YCY1iwryO+hzRfsB2Nudjf0Dw=
X-Google-Smtp-Source: AMrXdXvbfGwlJd/u1wxfpzDD8Ky+xg1iXAqvTzrQ7pRY9+ichgHs9jry+/iz2oMhuB/PfPD8/qh+1mi/xP4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7d93:b0:189:680e:c2e5 with SMTP id
 a19-20020a1709027d9300b00189680ec2e5mr362426plm.51.1671757108048; Thu, 22 Dec
 2022 16:58:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Dec 2022 00:57:37 +0000
In-Reply-To: <20221223005739.1295925-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221223005739.1295925-26-seanjc@google.com>
Subject: [PATCH 25/27] KVM: x86/mmu: Handle KVM bookkeeping in page-track
 APIs, not callers
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get/put references to KVM when a page-track notifier is (un)registered
instead of relying on the caller to do so.  Forcing the caller to do the
bookkeeping is unnecessary and adds one more thing for users to get
wrong, e.g. see commit 9ed1fdee9ee3 ("drm/i915/gvt: Get reference to KVM
iff attachment to VM is successful").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_page_track.h | 10 ++++------
 arch/x86/kvm/mmu/page_track.c         | 18 ++++++++++++------
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 23 ++++++++++-------------
 3 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 415537ce45b4..66a0d7c34311 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -47,12 +47,10 @@ struct kvm_page_track_notifier_node {
 enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
 					       enum pg_level max_level);
 
-void
-kvm_page_track_register_notifier(struct kvm *kvm,
-				 struct kvm_page_track_notifier_node *n);
-void
-kvm_page_track_unregister_notifier(struct kvm *kvm,
-				   struct kvm_page_track_notifier_node *n);
+int kvm_page_track_register_notifier(struct kvm *kvm,
+				     struct kvm_page_track_notifier_node *n);
+void kvm_page_track_unregister_notifier(struct kvm *kvm,
+					struct kvm_page_track_notifier_node *n);
 
 int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn);
 int kvm_write_track_remove_gfn(struct kvm *kvm, gfn_t gfn);
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index bc54afc1919c..1af431a41f71 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -157,17 +157,22 @@ int kvm_page_track_init(struct kvm *kvm)
  * register the notifier so that event interception for the tracked guest
  * pages can be received.
  */
-void
-kvm_page_track_register_notifier(struct kvm *kvm,
-				 struct kvm_page_track_notifier_node *n)
+int kvm_page_track_register_notifier(struct kvm *kvm,
+				     struct kvm_page_track_notifier_node *n)
 {
 	struct kvm_page_track_notifier_head *head;
 
+	if (!kvm || kvm->mm != current->mm)
+		return -ESRCH;
+
+	kvm_get_kvm(kvm);
+
 	head = &kvm->arch.track_notifier_head;
 
 	write_lock(&kvm->mmu_lock);
 	hlist_add_head_rcu(&n->node, &head->track_notifier_list);
 	write_unlock(&kvm->mmu_lock);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_register_notifier);
 
@@ -175,9 +180,8 @@ EXPORT_SYMBOL_GPL(kvm_page_track_register_notifier);
  * stop receiving the event interception. It is the opposed operation of
  * kvm_page_track_register_notifier().
  */
-void
-kvm_page_track_unregister_notifier(struct kvm *kvm,
-				   struct kvm_page_track_notifier_node *n)
+void kvm_page_track_unregister_notifier(struct kvm *kvm,
+					struct kvm_page_track_notifier_node *n)
 {
 	struct kvm_page_track_notifier_head *head;
 
@@ -187,6 +191,8 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
 	hlist_del_rcu(&n->node);
 	write_unlock(&kvm->mmu_lock);
 	synchronize_srcu(&head->track_srcu);
+
+	kvm_put_kvm(kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
 
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index f9d21d29f533..e4227ac6ab58 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -670,30 +670,28 @@ static bool __kvmgt_vgpu_exist(struct intel_vgpu *vgpu)
 static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 {
 	struct intel_vgpu *vgpu = vfio_dev_to_vgpu(vfio_dev);
+	int ret;
 
 	if (vgpu->attached)
 		return -EEXIST;
 
-	if (!vgpu->vfio_device.kvm ||
-	    vgpu->vfio_device.kvm->mm != current->mm) {
-		gvt_vgpu_err("KVM is required to use Intel vGPU\n");
-		return -ESRCH;
-	}
-
 	if (__kvmgt_vgpu_exist(vgpu))
 		return -EEXIST;
 
+	vgpu->track_node.track_write = kvmgt_page_track_write;
+	vgpu->track_node.track_remove_region = kvmgt_page_track_remove_region;
+	ret = kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
+					       &vgpu->track_node);
+	if (ret) {
+		gvt_vgpu_err("KVM is required to use Intel vGPU\n");
+		return ret;
+	}
+
 	vgpu->attached = true;
 
 	kvmgt_protect_table_init(vgpu);
 	gvt_cache_init(vgpu);
 
-	vgpu->track_node.track_write = kvmgt_page_track_write;
-	vgpu->track_node.track_remove_region = kvmgt_page_track_remove_region;
-	kvm_get_kvm(vgpu->vfio_device.kvm);
-	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
-					 &vgpu->track_node);
-
 	debugfs_create_ulong(KVMGT_DEBUGFS_FILENAME, 0444, vgpu->debugfs,
 			     &vgpu->nr_cache_entries);
 
@@ -730,7 +728,6 @@ static void intel_vgpu_close_device(struct vfio_device *vfio_dev)
 
 	kvm_page_track_unregister_notifier(vgpu->vfio_device.kvm,
 					   &vgpu->track_node);
-	kvm_put_kvm(vgpu->vfio_device.kvm);
 
 	kvmgt_protect_table_destroy(vgpu);
 	gvt_cache_destroy(vgpu);
-- 
2.39.0.314.g84b9a713c41-goog

