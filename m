Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A46070135D
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240499AbjEMAhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241743AbjEMAg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:36:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220A27D9E
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba2526a8918so14117249276.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938200; x=1686530200;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aMthFZfKChU24b3VOtsPFEPGDJzFR8scEpj8KdiOvI8=;
        b=zbEDkdjmJSYEa7+2zJhAe0a7HkBu9+tNiGcX0MT4Tal0cts0MOzLKi/QabrNqilpFq
         sPCRpl3ELRdYwnALKfuWd7zqA+8dYlFnanetule9PDq8aDyPVdPMJER3XnmLii5YTQLf
         tA5gvnsaDAIlHf7jrAKr8ie2kC57iNFKr75qA19cY61LffWA2EQ0bhCe7sgySld4WMBj
         Lw5WUKgIAjNdWqZCjJpdll6dtw/eZ8gBdU5C8SI/08mCrL0z9aPXcRHM7a+XYaks6Gdp
         HH+dfL+CQVXOxC8Ja6k97C+2hQI4MAo+wxW/BqscEvqevBQMqflqcIEnZvQdcAB34TNC
         b9LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938200; x=1686530200;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aMthFZfKChU24b3VOtsPFEPGDJzFR8scEpj8KdiOvI8=;
        b=bvxdMVA8qhtH1PIosit2yPV+K6TzTn/te/+X4NNSbX2JrI12msqRwAMU04J5Tsfzwb
         Wc24YrJlwiy4U5W4FjApnzG2OL9r02VTavkfZnCP2kXtpfhzuTZbGqPPuNOmz5RHpfgn
         rY1c5W2hd62K+cEq6ysK2axC6ZD4NTt80rk8+qy/vHIetyRg2BXEpYLjL1jTbZNSGdlw
         YuMAgH6Vj98zWjIX6Lhm/V9ZHYvUBCTBlONAUjMcayNdb5Fj3oWOBa6dPxmt+GBbBs71
         iGE5G6ly9YDqRUq5C0h26MYOTmmyXEpMGnfDGPTXMOMw7qAY+QCeiU15Rk6ymYokZcH0
         pMtA==
X-Gm-Message-State: AC+VfDzOr3OOLTHp+gAeEb8GsLKbgJ15vtn2AB8abWavv4oISqa/X9j/
        hj1jPb4TGjk6CaS8jpgtVZGVyCEbJhI=
X-Google-Smtp-Source: ACHHUZ4bjKLP+LCjU4jHWIA0lMCPLaFJEVV60B48H4+JRWdMR/qA7lphanX8VZ/t6d8lDlH244f3Acb/LK0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:1c02:0:b0:b8b:f584:6b73 with SMTP id
 c2-20020a251c02000000b00b8bf5846b73mr11687288ybc.10.1683938199874; Fri, 12
 May 2023 17:36:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:50 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-19-seanjc@google.com>
Subject: [PATCH v3 18/28] drm/i915/gvt: switch from ->track_flush_slot() to ->track_remove_region()
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

From: Yan Zhao <yan.y.zhao@intel.com>

Switch from the poorly named and flawed ->track_flush_slot() to the newly
introduced ->track_remove_region().  From KVMGT's perspective, the two
hooks are functionally equivalent, the only difference being that
->track_remove_region() is called only when KVM is 100% certain the
memory region will be removed, i.e. is invoked slightly later in KVM's
memslot modification flow.

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[sean: handle name change, massage changelog, rebase]
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index c309a77f495f..2e65901270ca 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -108,9 +108,8 @@ struct gvt_dma {
 
 static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
 				   struct kvm_page_track_notifier_node *node);
-static void kvmgt_page_track_flush_slot(struct kvm *kvm,
-		struct kvm_memory_slot *slot,
-		struct kvm_page_track_notifier_node *node);
+static void kvmgt_page_track_remove_region(gfn_t gfn, unsigned long nr_pages,
+					   struct kvm_page_track_notifier_node *node);
 
 static ssize_t intel_vgpu_show_description(struct mdev_type *mtype, char *buf)
 {
@@ -665,7 +664,7 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 		return -EEXIST;
 
 	vgpu->track_node.track_write = kvmgt_page_track_write;
-	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
+	vgpu->track_node.track_remove_region = kvmgt_page_track_remove_region;
 	kvm_get_kvm(vgpu->vfio_device.kvm);
 	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
 					 &vgpu->track_node);
@@ -1616,22 +1615,20 @@ static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
 	mutex_unlock(&info->vgpu_lock);
 }
 
-static void kvmgt_page_track_flush_slot(struct kvm *kvm,
-		struct kvm_memory_slot *slot,
-		struct kvm_page_track_notifier_node *node)
+static void kvmgt_page_track_remove_region(gfn_t gfn, unsigned long nr_pages,
+					   struct kvm_page_track_notifier_node *node)
 {
 	unsigned long i;
-	gfn_t gfn;
 	struct intel_vgpu *info =
 		container_of(node, struct intel_vgpu, track_node);
 
 	mutex_lock(&info->vgpu_lock);
 
-	for (i = 0; i < slot->npages; i++) {
-		gfn = slot->base_gfn + i;
-		if (kvmgt_gfn_is_write_protected(info, gfn))
-			kvmgt_protect_table_del(info, gfn);
+	for (i = 0; i < nr_pages; i++) {
+		if (kvmgt_gfn_is_write_protected(info, gfn + i))
+			kvmgt_protect_table_del(info, gfn + i);
 	}
+
 	mutex_unlock(&info->vgpu_lock);
 }
 
-- 
2.40.1.606.ga4b1b128d6-goog

