Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5AE5701357
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241814AbjEMAhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241687AbjEMAgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:36:54 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB267299
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:32 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-55d9a9d19c9so154150947b3.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938192; x=1686530192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OZEggBbNblRsi2erSP3Gdfhqb5e/8lV2CB/rQrFchS8=;
        b=4Igpt6TW9x4CyyUHgTyI0EJQh8OQLuCfDSzR+F/zcP5RMAUiMHo/cBjjxlYPZiOvhM
         l6EastCXgINOTBF6qg6msAVseFMbGgaxTzYYNK8z3nnqlGpxKRNNrk4f0un4E0WTW0k/
         bXYje+HsRbWsfEdjspnxU/HKpZR4p+S7IRQ+7gy2T3MFPfs/ZPE3HR0ZMCR0ZFyLdY34
         lziPt3Vo9sPl9mzf5Gcri32A+lbht/j8S27dICw2kk9xXd1S4hCNxcqRnoY84+22qeR8
         qu/bW0EoI5luvX0Jd6iL5ZfGf8LYhK6TeBzFNxYPHaHOZEzfX8sggfZxSyGzwDpOfArT
         7TPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938192; x=1686530192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OZEggBbNblRsi2erSP3Gdfhqb5e/8lV2CB/rQrFchS8=;
        b=jVKxOCEr4IU4FOPbpST2f/TEWtZhaZICdic9s4LC/w7T+eTEVUMtU6S7tJQJ5wsH1r
         WUnnBV+N85njDtwY+R22CtOHEDcJLlT/nWiIgDD+LGeA8+Ra/e+H2lcydatVX/plMNNt
         2b1lGJqiUryzMlKltJejLA4Ogjm65lfspppH7CcRLC5DReNwWk+c4WKH3Xi+QWxL0dbu
         eVN+c1WRZXbi9TH50prFKw4VxhBCV5C34zQZent4HMpF2gx3WNLP2AsYZmgciZBySZwc
         wOi+MdW+cwAIs8C1XHIO5O/2DuqjiSazOI2Xd6CMuf0xrSUYSw+39821mesPFYs0c8id
         8Gqw==
X-Gm-Message-State: AC+VfDwpvDZ4Knja3yRlPAqythg7SfOXlEYKSOktlTlcxBY0DkvC9r3q
        13kzFvUqmxSZ8pJWsW185zWFPeoCKE8=
X-Google-Smtp-Source: ACHHUZ5IL0mxanQb+3z0FkMZEYHAxx8lR74ouUyEdydLk2Ld178r8tywT4lRuzG7g2edgClIvXW+7Wli+8Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae65:0:b0:55d:f921:6bfa with SMTP id
 g37-20020a81ae65000000b0055df9216bfamr11964813ywk.5.1683938192252; Fri, 12
 May 2023 17:36:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:46 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-15-seanjc@google.com>
Subject: [PATCH v3 14/28] KVM: drm/i915/gvt: Drop @vcpu from KVM's
 ->track_write() hook
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

Drop @vcpu from KVM's ->track_write() hook provided for external users of
the page-track APIs now that KVM itself doesn't use the page-track
mechanism.

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_page_track.h |  5 ++---
 arch/x86/kvm/mmu/page_track.c         |  2 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 10 ++++------
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index eb186bc57f6a..8c4d216e3b2b 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -26,14 +26,13 @@ struct kvm_page_track_notifier_node {
 	 * It is called when guest is writing the write-tracked page
 	 * and write emulation is finished at that time.
 	 *
-	 * @vcpu: the vcpu where the write access happened.
 	 * @gpa: the physical address written by guest.
 	 * @new: the data was written to the address.
 	 * @bytes: the written length.
 	 * @node: this node
 	 */
-	void (*track_write)(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-			    int bytes, struct kvm_page_track_notifier_node *node);
+	void (*track_write)(gpa_t gpa, const u8 *new, int bytes,
+			    struct kvm_page_track_notifier_node *node);
 	/*
 	 * It is called when memory slot is being moved or removed
 	 * users can drop write-protection for the pages in that memory slot
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 23088c90d2fd..891e5cc52b45 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -272,7 +272,7 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
 				srcu_read_lock_held(&head->track_srcu))
 		if (n->track_write)
-			n->track_write(vcpu, gpa, new, bytes, n);
+			n->track_write(gpa, new, bytes, n);
 	srcu_read_unlock(&head->track_srcu, idx);
 
 	kvm_mmu_track_write(vcpu, gpa, new, bytes);
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 0785f9cb2c20..aaebb44c139f 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -106,9 +106,8 @@ struct gvt_dma {
 #define vfio_dev_to_vgpu(vfio_dev) \
 	container_of((vfio_dev), struct intel_vgpu, vfio_device)
 
-static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-		const u8 *val, int len,
-		struct kvm_page_track_notifier_node *node);
+static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
+				   struct kvm_page_track_notifier_node *node);
 static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		struct kvm_page_track_notifier_node *node);
@@ -1602,9 +1601,8 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
 	return 0;
 }
 
-static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-		const u8 *val, int len,
-		struct kvm_page_track_notifier_node *node)
+static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
+				   struct kvm_page_track_notifier_node *node)
 {
 	struct intel_vgpu *info =
 		container_of(node, struct intel_vgpu, track_node);
-- 
2.40.1.606.ga4b1b128d6-goog

