Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FF3701344
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241725AbjEMAgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241290AbjEMAgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:36:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3DC59ED
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba2526a8918so14116921276.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938183; x=1686530183;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kGWzOGNnYX/vPHab7hWTlXeNk8DC7e1HwcSSdi2i4zw=;
        b=cSZ/VlxdW4Pvbsz3re6QAwL7WZtCGSlM3rK2fKtPlroG7b/uYLspYK3BUBxjTTVT5H
         rExIRgrg9h7XNVV7S8JfLCc6hKMFeVMPfqlR+bwL2034YQgp2h3wOyvRQhcjmYy/0CWV
         Tb+gGu3prYb0KrHv7Vpt1Y+ROsVp45lgtRd9usk1mFWD3GZrX5I8Fe1G/lbZAI8o3lEr
         mWJgGWPW0bvh34EiK1V42Nbd2UJvbVYh21LbBL0Z3RhkD6kdDit2UIz+fEakFenDOmre
         edXxYiugm9t9TfwtH8lYTgo0OpSfKkvacHAeaJpt4SGriTEuFWd6Nrv6Y3L/CUCP08tz
         nGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938183; x=1686530183;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kGWzOGNnYX/vPHab7hWTlXeNk8DC7e1HwcSSdi2i4zw=;
        b=L2V/xjNAIzPNM8UvLvXZBoR+vhgjNCQK2EshWndoJt/rKwEX1pErZt4NYKYVH7Dl95
         0PTla3Fawa3ruI2eXXFrsJItN8si3HlU52XIGRw3cfufRj5bUnB6Z3mvl03zxSWmYcrx
         ZuQH4t+qihJJlbLDBbkqwC0RXZa2+4CW9/s8AcZebWh0PmkuRX+EdQbiKpc3eLA5UZx4
         tkKV24F1c1JutM9D8N9LUCJ/E263l57swmUwv/uVPyAQ/WArX//oImcjuMB0K5Qh9gnp
         2IYgqbZEPbJxpEgHUhJVGPsGMCNqnFQJD+2Do8Ge6GySkCAws7n7XfSxcDil2W/BDiHp
         CTBQ==
X-Gm-Message-State: AC+VfDx3PJxSEpLm6mehdsvl0YD8eNT4SPKHzCKmQt8qQjd+ilUH9qgX
        QJOAMdFM5d+FWBBLohyMdW9BN6lW4vY=
X-Google-Smtp-Source: ACHHUZ44XO16MxtzD/w1KoYsys54d1K4j5Ud62MPtg/R3svFiezEkhnbaVUuOmGlNoGAUGi8FiukEJhRUEo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4a9:b0:ba7:6620:4caa with SMTP id
 r9-20020a05690204a900b00ba766204caamr88646ybs.4.1683938183796; Fri, 12 May
 2023 17:36:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:41 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-10-seanjc@google.com>
Subject: [PATCH v3 09/28] drm/i915/gvt: Drop unused helper intel_vgpu_reset_gtt()
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

Drop intel_vgpu_reset_gtt() as it no longer has any callers.  In addition
to eliminating dead code, this eliminates the last possible scenario where
__kvmgt_protect_table_find() can be reached without holding vgpu_lock.
Requiring vgpu_lock to be held when calling __kvmgt_protect_table_find()
will allow a protecting the gfn hash with vgpu_lock without too much fuss.

No functional change intended.

Fixes: ba25d977571e ("drm/i915/gvt: Do not destroy ppgtt_mm during vGPU D3->D0.")
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/gtt.c | 18 ------------------
 drivers/gpu/drm/i915/gvt/gtt.h |  1 -
 2 files changed, 19 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index f505be9e647a..c3c623b929ce 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -2817,24 +2817,6 @@ void intel_vgpu_reset_ggtt(struct intel_vgpu *vgpu, bool invalidate_old)
 	ggtt_invalidate(gvt->gt);
 }
 
-/**
- * intel_vgpu_reset_gtt - reset the all GTT related status
- * @vgpu: a vGPU
- *
- * This function is called from vfio core to reset reset all
- * GTT related status, including GGTT, PPGTT, scratch page.
- *
- */
-void intel_vgpu_reset_gtt(struct intel_vgpu *vgpu)
-{
-	/* Shadow pages are only created when there is no page
-	 * table tracking data, so remove page tracking data after
-	 * removing the shadow pages.
-	 */
-	intel_vgpu_destroy_all_ppgtt_mm(vgpu);
-	intel_vgpu_reset_ggtt(vgpu, true);
-}
-
 /**
  * intel_gvt_restore_ggtt - restore all vGPU's ggtt entries
  * @gvt: intel gvt device
diff --git a/drivers/gpu/drm/i915/gvt/gtt.h b/drivers/gpu/drm/i915/gvt/gtt.h
index a3b0f59ec8bd..4cb183e06e95 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.h
+++ b/drivers/gpu/drm/i915/gvt/gtt.h
@@ -224,7 +224,6 @@ void intel_vgpu_reset_ggtt(struct intel_vgpu *vgpu, bool invalidate_old);
 void intel_vgpu_invalidate_ppgtt(struct intel_vgpu *vgpu);
 
 int intel_gvt_init_gtt(struct intel_gvt *gvt);
-void intel_vgpu_reset_gtt(struct intel_vgpu *vgpu);
 void intel_gvt_clean_gtt(struct intel_gvt *gvt);
 
 struct intel_vgpu_mm *intel_gvt_find_ppgtt_mm(struct intel_vgpu *vgpu,
-- 
2.40.1.606.ga4b1b128d6-goog

