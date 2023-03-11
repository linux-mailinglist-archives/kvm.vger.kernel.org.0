Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF886B567D
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjCKAXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjCKAXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:23:39 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC724D617
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:19 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id i7-20020a626d07000000b005d29737db06so3632138pfc.15
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678494199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dV8sNcyAW0n6X3OiA2R9lVjH4Ll5YuXDWn2FowKm87g=;
        b=h2hFNdoiZHdwrWGNcaEB/AQu51ahfugVa0zZizoS7QsJE89HqVuLJVyqNvgvd88iBK
         me0aSbiLd3m9jQAdP4be16J3EamKef/zkhiZ8H9I0++QXNGVvaBX4JlCjBNkrV770IxF
         vK1qcoDgiG8eG9uN5BbJ+1pd1X2/slSmvHRy2d94KJ6TkaYyfiHjZiawDoOz4oNTgtmQ
         wMEFUehtwWmzdnnBcBDczYp5PNvPGlhNrUUV21FjS3Zvc6w8s7J3JJNCFk5eteKW5Teh
         6afgrwW4K8+pvEJ6iE8UxjDcodkIbeov5HFbNu6p7Rc9ulZEZVy7KSIyqswaDsXCzWLl
         1n7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678494199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dV8sNcyAW0n6X3OiA2R9lVjH4Ll5YuXDWn2FowKm87g=;
        b=6OflhyXWFfucLb608o/YZDYU14rmIM4tIo/ftKlxq7OrJwHJzPTxmbxy3XaORePoyZ
         j55YcgrV1YiBNH8Y+1Mub3d+I4WdN8z3h8ic2uIQkflgyI8rvi2apmYfusibOUsxBUUu
         wq2lYdf8OkJv0kxwmUExgQsSZhQAKN4LyMMAK9qed9LJRTyn4TsdwT5DqwL7dxR9Z5E6
         0ISH2nJ5flHbPsXIvTiG4Do1M2VmD0cHwB+cyrL8Ilh7ICa+kHIJGYATy6OrEZn9rIrG
         SCYfzcgSGjMrr9+3i/4GOuE//Wd/fCARCmFYu5kszwMWaCJ2D2XRDNlzmwsGt60H3xwG
         MvVA==
X-Gm-Message-State: AO0yUKUnSmz4vb/mvsuc3sA12HYb5ijgJhCQuqFiEgRGa9Qak3OB8qdw
        65rPVkJlll0LV+8HTSSRylhu3ty+3aw=
X-Google-Smtp-Source: AK7set+oTUQVQ98NL8nLmkTce37rt0J2X5Ciq9/ekBdbpCSBWIX/zJhgQ4enOFiT3EdM+nyqTe7FZ4gAxDQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f98d:b0:19a:80b9:78ce with SMTP id
 ky13-20020a170902f98d00b0019a80b978cemr1675508plb.0.1678494199278; Fri, 10
 Mar 2023 16:23:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:22:38 -0800
In-Reply-To: <20230311002258.852397-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311002258.852397-8-seanjc@google.com>
Subject: [PATCH v2 07/27] drm/i915/gvt: Don't rely on KVM's gfn_to_pfn() to
 query possible 2M GTT
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

Now that gvt_pin_guest_page() explicitly verifies the pinned PFN is a
transparent hugepage page, don't use KVM's gfn_to_pfn() to pre-check if a
2M GTT entry is possible and instead just try to map the GFN with a 2MB
entry.  Using KVM to query pfn that is ultimately managed through VFIO is
odd, and KVM's gfn_to_pfn() is not intended for non-KVM consumption; it's
exported only because of KVM vendor modules (x86 and PPC).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/gtt.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index 15848b041a0d..e60bcce241f8 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1146,21 +1146,19 @@ static inline void ppgtt_generate_shadow_entry(struct intel_gvt_gtt_entry *se,
 }
 
 /*
- * Check if can do 2M page
+ * Try to map a 2M gtt entry.
  * @vgpu: target vgpu
  * @entry: target pfn's gtt entry
  *
- * Return 1 if 2MB huge gtt shadowing is possible, 0 if miscondition,
- * negative if found err.
+ * Return 1 if 2MB huge gtt shadow was creation, 0 if the entry needs to be
+ * split, negative if found err.
  */
-static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
-	struct intel_gvt_gtt_entry *entry)
+static int try_map_2MB_gtt_entry(struct intel_vgpu *vgpu,
+	struct intel_gvt_gtt_entry *entry, dma_addr_t *dma_addr)
 {
 	const struct intel_gvt_gtt_pte_ops *ops = vgpu->gvt->gtt.pte_ops;
 	unsigned long gfn = ops->get_pfn(entry);
-	kvm_pfn_t pfn;
 	int max_level;
-	int ret;
 
 	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
 		return 0;
@@ -1173,16 +1171,7 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
 	if (max_level < PG_LEVEL_2M)
 		return 0;
 
-	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, gfn);
-	if (is_error_noslot_pfn(pfn))
-		return -EINVAL;
-
-	if (!pfn_valid(pfn))
-		return -EINVAL;
-
-	ret = PageTransHuge(pfn_to_page(pfn));
-	kvm_release_pfn_clean(pfn);
-	return ret;
+	return intel_gvt_dma_map_guest_page(vgpu, gfn, I915_GTT_PAGE_SIZE_2M, dma_addr);
 }
 
 static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
@@ -1278,7 +1267,7 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
 {
 	const struct intel_gvt_gtt_pte_ops *pte_ops = vgpu->gvt->gtt.pte_ops;
 	struct intel_gvt_gtt_entry se = *ge;
-	unsigned long gfn, page_size = PAGE_SIZE;
+	unsigned long gfn;
 	dma_addr_t dma_addr;
 	int ret;
 
@@ -1301,13 +1290,12 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
 		return split_64KB_gtt_entry(vgpu, spt, index, &se);
 	case GTT_TYPE_PPGTT_PTE_2M_ENTRY:
 		gvt_vdbg_mm("shadow 2M gtt entry\n");
-		ret = is_2MB_gtt_possible(vgpu, ge);
+		ret = try_map_2MB_gtt_entry(vgpu, ge, &dma_addr);
 		if (ret == 0)
 			return split_2MB_gtt_entry(vgpu, spt, index, &se);
 		else if (ret < 0)
 			return ret;
-		page_size = I915_GTT_PAGE_SIZE_2M;
-		break;
+		goto set_shadow_entry;
 	case GTT_TYPE_PPGTT_PTE_1G_ENTRY:
 		gvt_vgpu_err("GVT doesn't support 1GB entry\n");
 		return -EINVAL;
@@ -1316,10 +1304,11 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
 	}
 
 	/* direct shadow */
-	ret = intel_gvt_dma_map_guest_page(vgpu, gfn, page_size, &dma_addr);
+	ret = intel_gvt_dma_map_guest_page(vgpu, gfn, PAGE_SIZE, &dma_addr);
 	if (ret)
 		return -ENXIO;
 
+set_shadow_entry:
 	pte_ops->set_pfn(&se, dma_addr >> PAGE_SHIFT);
 	ppgtt_set_shadow_entry(spt, &se, index);
 	return 0;
-- 
2.40.0.rc1.284.g88254d51c5-goog

