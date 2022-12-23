Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC2B6549E6
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 01:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbiLWA5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 19:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiLWA5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:57:51 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86F021E0F
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:57:50 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u15-20020a170902e5cf00b001899d29276eso2403101plf.10
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=j9glXQlCcjBPy6z6EtMDUxvhVYrjcVK6NuBTr5d5jMM=;
        b=mkY/HDRSL1Z6rYMsp5aXb9DxEbw3gk63aqofEQZb3aH6jx7uKj9w6DLcqGi4YUt4GK
         USLw0pllD+LT2V0T4rKGxQ4b/Lblx2DVggISei1TzjSVCnc8zMjn1lio4lsBy9BbecDd
         1OQVdcI3QScS20VMK/rqf/8ZZwsNlbifWB5BVSA/j7sCaOREjYXVLJMn61rP+5G+CLVb
         XgXuOIs4pXoXR8H4Mu8tIH7tMRiw3NgBhXAaeIbbagBzgXz4ricByiRWhna+M7g7iLFh
         37Mo0NbuZa1D2jhxiZvNFCoF/tNc67hLo5Iiu6h+YklyXPtB7Jlz3JOEXdZfa3yDJTWx
         11GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j9glXQlCcjBPy6z6EtMDUxvhVYrjcVK6NuBTr5d5jMM=;
        b=pvN3l6AmEfP5OMCgh/4K/ferlQpPvRKvMDSRhmGo6wkUvg5ADFqbb0+EGqh6Ws4v+V
         yXtc/oqorcUfXdx1t4vfSdzMCodGqAvVGty5/2QkXCfEBifzIAUBU8Us+pTFnOO5DDbB
         pbX6p5uvdhiu68UTDgrPx2aQTFOufnwLIDrhtIsEXH5oKaY6SmFOenj+jsJT/YUJccjH
         S+JvyYR6ujvQWwy2No/19eTE5mXkt1S8K8dghg/z9YKsJJHomwA0ieoSHzwoCxaN2+qR
         3EDP/jg4AdtbGYMCQ9eh/jg/kJc1HUk4k0KqadplhufvCWC8jMyVyes+lAoLXhG6hT32
         kA4g==
X-Gm-Message-State: AFqh2kpBdZriW35prJqCdyl7PeKozzTQu0a5lx00rpYEvPPXTO1khERF
        dVwtIQJpGEMTxm+RQJSwPY1Bi44cKX0=
X-Google-Smtp-Source: AMrXdXtMbZNNIlGG/KYBUr4YpZKchMqLawm/s6Awbw8/z1k3argf7yO0AX13QDZvc3DFh6qwcnZWOCffa1w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:6242:0:b0:580:9554:d267 with SMTP id
 w63-20020a626242000000b005809554d267mr23193pfb.20.1671757070371; Thu, 22 Dec
 2022 16:57:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Dec 2022 00:57:15 +0000
In-Reply-To: <20221223005739.1295925-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221223005739.1295925-4-seanjc@google.com>
Subject: [PATCH 03/27] drm/i915/gvt: Incorporate KVM memslot info into check
 for 2MiB GTT entry
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
index 2e09d1b6249f..69ea16c31859 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -300,3 +300,21 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
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
index d0fca53a3563..6736d7bd94ea 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1178,14 +1178,22 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
 	struct intel_gvt_gtt_entry *entry)
 {
 	const struct intel_gvt_gtt_pte_ops *ops = vgpu->gvt->gtt.pte_ops;
+	unsigned long gfn = ops->get_pfn(entry);
 	kvm_pfn_t pfn;
+	int max_level;
 
 	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
 		return 0;
 
 	if (!vgpu->attached)
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
2.39.0.314.g84b9a713c41-goog

