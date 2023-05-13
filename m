Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F7D701378
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241939AbjEMAjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241928AbjEMAiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:38:46 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C57A7AB2
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:37:28 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-559d8e22306so190399197b3.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938217; x=1686530217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JNrfeJQhf8GBrzF44ZxoDWsbNWIJ6qq7bttFhehTPo8=;
        b=gyYCYHBppv4q5C30N34xjVsUqOTwcR5LO/NnZUg5RU7dbT8lmuSit1brMff3VpdB0S
         YNidnKn6sQGj6dWNDoxMmoCNCVmwtGNxNi9QJLGfzEspqYPZjG3PAco/x3+WEC0HhqG8
         LfiLOm5rtwh/hKI71qJdMu7rqVbHhrmsvt9P9BWZrpT9QAR0YFU+DW3g4oKVDY2yYbNd
         DUOUPWvitY6cHjt57eh+3Z6lDrApGzd9x9lLz82/IVIOgX+pDNCihmioMJRp4kmW85zZ
         zoib+t4dVzxWEiZ6XXM9m2sCioH6O7G41MaLvRG0GcFt4C43Y4TxQD+kD6XIFLnN5LVS
         ml1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938217; x=1686530217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JNrfeJQhf8GBrzF44ZxoDWsbNWIJ6qq7bttFhehTPo8=;
        b=FI9sbJB1CCSQyRBC6QFNpdHTAW4iLB+xxHyxMLwnG5Ef1zqI43426ZHsSkTDs7ZqVF
         V8SX+pc32VguhZP0GkfhpeT48kk9ga91X9uOmzEgjefueeibvtizV217C1qA6i2/4Zns
         lagdP76q3NLfArARwz2Wqd9F257CAyQaQroZkjJBhnDZp6/yp0mmpvg6tflzJRr44Sa1
         BMYRTSr8cAqQIsTAvLb8Oa2ilgyEMYyO1HXw+6+pNHQuqyIe9NI8oU7GZ6OOp6US3sz8
         aCSDFMpYNtf89YglrFbLDon9VY3AnTWGXtDWHtrxmf2IbikHp0gePF79snzar0K5BpE5
         3BnQ==
X-Gm-Message-State: AC+VfDyhvIAhshVWMbw5oLsDw37GIpnc3YS+Q9UAD8e/HJ6MLuzV1cJi
        1gIA0HTGMckJws9LBMiczKSthPXTG0U=
X-Google-Smtp-Source: ACHHUZ6DnKGAo0TrUNDjih/4q1woz7p4BSEFtPuiqzJr7+6S9VdM8qvZEblUkpyjUQi4/ciglH3dGpkLhow=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ec0f:0:b0:561:185e:2301 with SMTP id
 j15-20020a81ec0f000000b00561185e2301mr2635399ywm.5.1683938216884; Fri, 12 May
 2023 17:36:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:59 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-28-seanjc@google.com>
Subject: [PATCH v3 27/28] KVM: x86/mmu: Handle KVM bookkeeping in page-track
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_page_track.h | 11 +++++------
 arch/x86/kvm/mmu/page_track.c         | 18 ++++++++++++------
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 17 +++++++----------
 3 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 4afab697e21c..3d040741044b 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -44,12 +44,11 @@ struct kvm_page_track_notifier_node {
 				    struct kvm_page_track_notifier_node *node);
 };
 
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
+
 int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn);
 int kvm_write_track_remove_gfn(struct kvm *kvm, gfn_t gfn);
 #else
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 2a64df38ccab..fd04e618ad2d 100644
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
index b995d75a19c3..597ffc9d12fd 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -653,21 +653,19 @@ static bool __kvmgt_vgpu_exist(struct intel_vgpu *vgpu)
 static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 {
 	struct intel_vgpu *vgpu = vfio_dev_to_vgpu(vfio_dev);
-
-	if (!vgpu->vfio_device.kvm ||
-	    vgpu->vfio_device.kvm->mm != current->mm) {
-		gvt_vgpu_err("KVM is required to use Intel vGPU\n");
-		return -ESRCH;
-	}
+	int ret;
 
 	if (__kvmgt_vgpu_exist(vgpu))
 		return -EEXIST;
 
 	vgpu->track_node.track_write = kvmgt_page_track_write;
 	vgpu->track_node.track_remove_region = kvmgt_page_track_remove_region;
-	kvm_get_kvm(vgpu->vfio_device.kvm);
-	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
-					 &vgpu->track_node);
+	ret = kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
+					       &vgpu->track_node);
+	if (ret) {
+		gvt_vgpu_err("KVM is required to use Intel vGPU\n");
+		return ret;
+	}
 
 	set_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status);
 
@@ -702,7 +700,6 @@ static void intel_vgpu_close_device(struct vfio_device *vfio_dev)
 
 	kvm_page_track_unregister_notifier(vgpu->vfio_device.kvm,
 					   &vgpu->track_node);
-	kvm_put_kvm(vgpu->vfio_device.kvm);
 
 	kvmgt_protect_table_destroy(vgpu);
 	gvt_cache_destroy(vgpu);
-- 
2.40.1.606.ga4b1b128d6-goog

