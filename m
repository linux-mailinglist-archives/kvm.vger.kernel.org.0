Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE55D6B5671
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjCKAXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjCKAXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:23:37 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC5D274AB
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:14 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id l10-20020a17090a598a00b0023b28afea55so470036pji.0
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678494193;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GxkVI4HQZUPjFtqWtq8zWKxzvCJDOEnAK71W0aJ+/Qw=;
        b=p2UvAf1DVD1I9Vv3IyqhkRPRi2ht61bry9FiYRjI1G9P2ZXtw/ThDSOk8tTC7ERcfy
         GYocsDfpOEp7b4OBhddgwPABFim5wgx2XnaAAlmczmszC5HUtG0Ou8RhddIcH0zFtTIK
         tUoTXo2GkZQNfpn4UE+t22hdQe0kzr3rVl+uhiNqcR6Y6q8CReaMqpPwSCtSsHmkgL+Y
         RS0eY2/Nc79o/TZQChAvsgVXQ6L31YHySo8tCZRAlDheLEaAH7j5Ux5F9PmWx7a1ufi2
         ZqOBTYZ1hM+mIHDi5SuFZKMCKlYtcDuhho/6juXL5ZItmBxXm9EL3vcETYxOt23otyU+
         Tc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678494193;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GxkVI4HQZUPjFtqWtq8zWKxzvCJDOEnAK71W0aJ+/Qw=;
        b=ks5rfCX41DOvwHjUaWKMCFcG3JHpeBD3zIliImgZ6KmPFgjdmLo63BunS0b2zx+8vp
         yLsYslFmLUDZoSSqthb5g5xApVJ29L5NuHL2jaB9F/db0MlW4VaAzhKjJeoRXVVXmZ84
         Ptn1sYaQQIT7b1ejTA/gHK8Xq73gVvAjytblpWBB3dxKKLSH0HnnmDxQVGszMBI+GSaV
         wRn6osOHUC9AeK8H7mnPuDTAlqz4xPSOW741FimWRky1Vwl3GwOyMhjui0lH4GqBvTXH
         HsYo5VczBRzV/u7EL/0987H6PReAL598eAKfSzFW5aJ2zwpjj7cxFMCfNuaQnQPBDBfE
         wDXQ==
X-Gm-Message-State: AO0yUKWNkbB88GhYJOL9ZkBYSTM+u0HVPGcYjswnVTWDr0RWGUWiLFV/
        IIUC3uCtlnSOIaaPjkAFuMxsXG6kkDY=
X-Google-Smtp-Source: AK7set83btvjSQZKjEV5leWaffCmnkftpRMOhK46UUzcSKRH6pCrd+ozRzIvde3BLDYjpzbSCL+vg/1+zvQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f7c4:b0:19a:f80f:9619 with SMTP id
 h4-20020a170902f7c400b0019af80f9619mr10451565plw.3.1678494193558; Fri, 10 Mar
 2023 16:23:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:22:35 -0800
In-Reply-To: <20230311002258.852397-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311002258.852397-5-seanjc@google.com>
Subject: [PATCH v2 04/27] drm/i915/gvt: Incorporate KVM memslot info into
 check for 2MiB GTT entry
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

Honor KVM's max allowed page size when determining whether or not a 2MiB
GTT shadow page can be created for the guest.  Querying KVM's max allowed
size is somewhat odd as there's no strict requirement that KVM's memslots
and VFIO's mappings are configured with the same gfn=>hva mapping, but
the check will be accurate if userspace wants to have a functional guest,
and at the very least checking KVM's memslots guarantees that the entire
2MiB range has been exposed to the guest.

Note, KVM may also restrict the mapping size for reasons that aren't
relevant to KVMGT, e.g. for KVM's iTLB multi-hit workaround or if the gfn
is write-tracked (KVM's write-tracking only handles writes from vCPUs).
However, such scenarios are unlikely to occur with a well-behaved guest,
and at worst will result in sub-optimal performance.

Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_page_track.h |  2 ++
 arch/x86/kvm/mmu/page_track.c         | 18 ++++++++++++++++++
 drivers/gpu/drm/i915/gvt/gtt.c        | 10 +++++++++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index eb186bc57f6a..3f72c7a172fc 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -51,6 +51,8 @@ void kvm_page_track_cleanup(struct kvm *kvm);
 
 bool kvm_page_track_write_tracking_enabled(struct kvm *kvm);
 int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot);
+enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
+					       enum pg_level max_level);
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
 int kvm_page_track_create_memslot(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 0a2ac438d647..e739dcc3375c 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -301,3 +301,21 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 			n->track_flush_slot(kvm, slot, n);
 	srcu_read_unlock(&head->track_srcu, idx);
 }
+
+enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
+					       enum pg_level max_level)
+{
+	struct kvm_memory_slot *slot;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
+		max_level = PG_LEVEL_4K;
+	else
+		max_level = kvm_mmu_max_slot_mapping_level(slot, gfn, max_level);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return max_level;
+}
+EXPORT_SYMBOL_GPL(kvm_page_track_max_mapping_level);
diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index f30922c55a0c..d59c7ab9d224 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1157,14 +1157,22 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
 	struct intel_gvt_gtt_entry *entry)
 {
 	const struct intel_gvt_gtt_pte_ops *ops = vgpu->gvt->gtt.pte_ops;
+	unsigned long gfn = ops->get_pfn(entry);
 	kvm_pfn_t pfn;
+	int max_level;
 
 	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
 		return 0;
 
 	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
 		return -EINVAL;
-	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
+
+	max_level = kvm_page_track_max_mapping_level(vgpu->vfio_device.kvm,
+						     gfn, PG_LEVEL_2M);
+	if (max_level < PG_LEVEL_2M)
+		return 0;
+
+	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, gfn);
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

