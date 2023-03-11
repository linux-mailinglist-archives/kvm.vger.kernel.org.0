Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16886B56A5
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjCKAZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCKAYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:24:34 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9E713E53A
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:52 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id pl10-20020a17090b268a00b00239ed042afcso5048438pjb.4
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678494218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OMGdyparKm8+Gefw73vC5jleoqDZScQomW9SzOoSMJg=;
        b=ajb/7CAdzoT35PUWdYahi131IY8cxIXYUmWbU3wxwnKIBxxsHK89VejSvnX9gPFXKV
         8T8M2MQ5qLFEJwFF7065/DtXjrWK5KDid68DBsbQqdbuHpDsBapRoTQnssTg9iU7v9aO
         W3O661JIaer2LspHtmzrEw/PzdpLM0tWNomDVlVvK3UMOXkliymk4EGDN1m1+ZzJbIjo
         z0JXfNMR+7wnIFuzi/4ZXa9UxnYm0l+lrGMAJWIXD0F1irQaKal08+zi3JQ1zRDeUz75
         gC+HwThfWZZ7qParKjPirjREefLcpYQcsbDTVSHvU3UunCBdpe0aH1RzH5c9Fl9Suirg
         0Tjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678494218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OMGdyparKm8+Gefw73vC5jleoqDZScQomW9SzOoSMJg=;
        b=gHaTeZKOafrlApPSGt4td93dzOZi4+ON86hewL2lkf6PdLikWboG1thibZWh2AzmJ5
         iVE71eIqSmo0lpx7pBUij1AboeMqNldrbWt/aoz0F4gzsVhtHdH1ws7n5bnO4Y1G7rC1
         bPTPqcOpTBHJTnktBIRoS1Ovtfc8APNeBV6Ww4UWPUSViDl2gVxvkXVzc0bmTjRazfUo
         bKUm8WsXr3nIFX8z5SZVaQQJCV/A5USDaTLyRXvkrXET454vD5U2zNtlOHyZjw7BAlFt
         mMhw5MV2/Oq7xpqRhwBQKbGzHviTPNzE5oS2dkdJJ2K+bNUZDPDtqB3AmdfPRIYY0Jgk
         6uBQ==
X-Gm-Message-State: AO0yUKXTlf5/KISnUz/sQfTCub5HFT5mlYuQqZnQHOSPJiI/oO23vue3
        4c8IvhJQMJlzpMv2Ys/KchLrlm0eI4I=
X-Google-Smtp-Source: AK7set88pl2QPb1K0bOmfg6auaZYvfaRkd4edAczPhcZ95QVckYZlY7Ht+z9TDRm6nMSKMQOyXp7Q1oMlgc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f543:0:b0:4fb:9902:fc4a with SMTP id
 e3-20020a63f543000000b004fb9902fc4amr9411181pgk.10.1678494217911; Fri, 10 Mar
 2023 16:23:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:22:48 -0800
In-Reply-To: <20230311002258.852397-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311002258.852397-18-seanjc@google.com>
Subject: [PATCH v2 17/27] drm/i915/gvt: switch from ->track_flush_slot() to ->track_remove_region()
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 577712ea4893..9f188b6c3edf 100644
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
@@ -680,7 +679,7 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 		return -EEXIST;
 
 	vgpu->track_node.track_write = kvmgt_page_track_write;
-	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
+	vgpu->track_node.track_remove_region = kvmgt_page_track_remove_region;
 	kvm_get_kvm(vgpu->vfio_device.kvm);
 	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
 					 &vgpu->track_node);
@@ -1631,22 +1630,20 @@ static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
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
2.40.0.rc1.284.g88254d51c5-goog

