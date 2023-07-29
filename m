Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E56767AF7
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbjG2BgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237543AbjG2BgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:36:05 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D123C2A
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:35:56 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bbd4f526caso20385255ad.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594556; x=1691199356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xRti94I88xI36VdJ1C9pM+DO3reoJ85WhIcKAlj3P2A=;
        b=JzVeSbakvBsITk4WCc6SvXMXZXpKg1sKgNCLCg329z4+CwqicRWa18ItETELkleHut
         Yv4X8wRd3Le9uqQGPUWs5BUQkj7TQJDt9Eb5fhMjb23YSABFTjI2bzN/glzKpBumIzEs
         fTGh7mmm0I6apNNmDAUz1eyleS73AlS2QlY8+8eRKCJtqc/P/YOG5SqsNHXCud5EkzFP
         jE1ZE8Vnryd4Dn0nEp5qJTOVH3Wyqn42CpQxKf2W0v6q+EQhwJBTSDxzWFjjb+QZElus
         ssNGr64x9a3IHDfdFolrvWOyeULaX7kmUyN6RPwtI37uS4WYyBbIw//m00wT14Fxuhox
         HQgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594556; x=1691199356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xRti94I88xI36VdJ1C9pM+DO3reoJ85WhIcKAlj3P2A=;
        b=DKlE1tn0ZnToQKJg9EWQWf5elRQvsrpuy4XmmQtsCZzUJIFwqVjA2Q3DBhN/mMdYuE
         ToI9M9q6OUCxBTR15VDMfZt+JmQoEsqIGWMJ2ZGQpQYiLMRNcFr4ripogSfdCdKeAu4S
         I5xnW/uV6/FYXgmEN1QbSFDfXxGREVQfrgI3D2s7SgplXRPU46ETN/Q/AklJ+5m4hUhF
         +PKzmsdtVgpL3h3+gZjFPBQyJoWm/SwnBVxFnFjuZrFQAYsVy7Csdb/yjzbxFuyXXM91
         5CVCLrWHhWupjn9iSqJ2AlhyB1tByAPibLRwUEfUPNqSrsRIh8SQn3eZ2jWfbh8YLQWD
         WJ6A==
X-Gm-Message-State: ABy/qLZbDw3G9g7/79O1HcHGmG2aO7NYIrXNkar1x4b7H4upgFtzGoq4
        fQDdX7L0j8qu7aYerc+HgpcigLPF7Jk=
X-Google-Smtp-Source: APBJJlGLaYng3bx/UmtgPECyQBQ2iUlUJH1kZl0/YE/Hn7IX+/6SrxIFl/3qUim+xESr+hSwSKOan6hQzyM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:230b:b0:1b9:e338:a8b7 with SMTP id
 d11-20020a170903230b00b001b9e338a8b7mr13091plh.5.1690594556187; Fri, 28 Jul
 2023 18:35:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:12 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-7-seanjc@google.com>
Subject: [PATCH v4 06/29] drm/i915/gvt: Explicitly check that vGPU is attached
 before shadowing
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the check that a vGPU is attacked from is_2MB_gtt_possible() all the
way up to shadow_ppgtt_mm() to avoid unnecessary work, and to make it more
obvious that a future cleanup of is_2MB_gtt_possible() isn't introducing a
bug.

is_2MB_gtt_possible() has only one caller, ppgtt_populate_shadow_entry(),
and all paths in ppgtt_populate_shadow_entry() eventually check for
attachment by way of intel_gvt_dma_map_guest_page().

And of the paths that lead to ppgtt_populate_shadow_entry(),
shadow_ppgtt_mm() is the only one that doesn't already check for
INTEL_VGPU_STATUS_ACTIVE or INTEL_VGPU_STATUS_ATTACHED.

  workload_thread() <= pick_next_workload() => INTEL_VGPU_STATUS_ACTIVE
  |
  -> dispatch_workload()
     |
     |-> prepare_workload()
         |
         -> intel_vgpu_sync_oos_pages()
         |  |
         |  |-> ppgtt_set_guest_page_sync()
         |      |
         |      |-> sync_oos_page()
         |          |
         |          |-> ppgtt_populate_shadow_entry()
         |
         |-> intel_vgpu_flush_post_shadow()
             |
  1:         |-> ppgtt_handle_guest_write_page_table()
                 |
                 |-> ppgtt_handle_guest_entry_add()
                     |
  2:                 | -> ppgtt_populate_spt_by_guest_entry()
                     |    |
                     |    |-> ppgtt_populate_spt()
                     |        |
                     |        |-> ppgtt_populate_shadow_entry()
                     |            |
                     |            |-> ppgtt_populate_spt_by_guest_entry() [see 2]
                     |
                     |-> ppgtt_populate_shadow_entry()

  kvmgt_page_track_write()  <= KVM callback => INTEL_VGPU_STATUS_ATTACHED
  |
  |-> intel_vgpu_page_track_handler()
      |
      |-> ppgtt_write_protection_handler()
          |
          |-> ppgtt_handle_guest_write_page_table_bytes()
              |
              |-> ppgtt_handle_guest_write_page_table() [see 1]

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/gtt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index 5426a27c1b71..2aed31b497c9 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1163,8 +1163,6 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
 	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
 		return 0;
 
-	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
-		return -EINVAL;
 	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
@@ -1277,6 +1275,9 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
 	if (!pte_ops->test_present(ge))
 		return 0;
 
+	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
+		return -EINVAL;
+
 	gfn = pte_ops->get_pfn(ge);
 
 	switch (ge->type) {
-- 
2.41.0.487.g6d72f3e995-goog

