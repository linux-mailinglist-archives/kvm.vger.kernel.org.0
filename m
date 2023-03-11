Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3966B56B9
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjCKA01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbjCKAZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:25:41 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91C2147746
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:24:22 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id ju20-20020a170903429400b0019ea5ea044aso3670522plb.21
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678494237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=x2tVYLFtu4+/4LAPARn3E33zkHftYTv9vOX58pVkWHM=;
        b=eCTAn9KE2O9xKHWOxj1VUE/UZXTx6Y1mDDTMlkwbdR0Y57s9PpUrM5h9i2cHbxsnki
         t0637AV0rExfo48KvvrqnyadfUnxBMwpuXsf8bzU9+CnuuH5alcmDXRXkCkOTywDKJEk
         XcU2Ssqaps8aM9ojs9FjhyBohQxSawze04pO8kWuerEOURvl7R99eb/R/ZcwEpa5D8mU
         TLGucsOnbjVeWTw9U9PMc6v0xVNdb3bFtznClK5hKBNddFaRNaHEDwN47WSFEGxmM3iV
         bkMq0Bn8TSiu6JuJ5U2kGO4Zf7ybt6AJeJqWZFsgqPjAfErV+ulDY+iqxXYTBp35bmjn
         a4Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678494237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x2tVYLFtu4+/4LAPARn3E33zkHftYTv9vOX58pVkWHM=;
        b=cl6yJatbeAstaMRc/W/RCdW6qVi2pTDMl6Bbgpox1RZn1XYYDJma3ZJ6yGdcM4mrUz
         tT/pkzX32oYAM2yyScXxTufHM9F2r99PvMTrKWV1E08YeonFjSxmeQ4A1oI4zAOKuP2i
         8tFVBvfHYYDjb3UBpZistwfk3dZMS9pEQZO9mGjBcemz2Ju82flWrlAqcCm9AWOK/ur/
         epMON47cx674nPeFwAX+2lmd0UN+gbdtv0yDt3/vF4E1HYGEMlk578p2HVkrNbMbe78M
         cgWdXh6EPjfjxiRdOGbo7h9f8P9SZtUUsCPm6DawX+N6dJcSCJEYv/abah3zniTilYd/
         3XWA==
X-Gm-Message-State: AO0yUKWtHAgICVScnChoBzTC3aoPfanJHIAtbkY0HmGS3D7YFwZECFQg
        5BwVTx2r+dsuXqvYb1xiMWKPVafDd4o=
X-Google-Smtp-Source: AK7set/9DiEaGFm/frdpvFkcKgynFsB7l9O/lCeTPJ5Btk1PEMlu/T/014QaQyiTK4eR3E2EyTqi6Wr5p4Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7783:b0:237:9029:c29b with SMTP id
 v3-20020a17090a778300b002379029c29bmr10323383pjk.0.1678494237678; Fri, 10 Mar
 2023 16:23:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:22:58 -0800
In-Reply-To: <20230311002258.852397-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311002258.852397-28-seanjc@google.com>
Subject: [PATCH v2 27/27] drm/i915/gvt: Drop final dependencies on KVM
 internal details
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

Open code gpa_to_gfn() in kvmgt_page_track_write() and drop KVMGT's
dependency on kvm_host.h, i.e. include only kvm_page_track.h.  KVMGT
assumes "gfn == gpa >> PAGE_SHIFT" all over the place, including a few
lines below in the same function with the same gpa, i.e. there's no
reason to use KVM's helper for this one case.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/gvt.h   | 3 ++-
 drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index 2d65800d8e93..53a0a42a50db 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -34,10 +34,11 @@
 #define _GVT_H_
 
 #include <uapi/linux/pci_regs.h>
-#include <linux/kvm_host.h>
 #include <linux/vfio.h>
 #include <linux/mdev.h>
 
+#include <asm/kvm_page_track.h>
+
 #include "i915_drv.h"
 #include "intel_gvt.h"
 
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index d16aced134b4..798d04481f03 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1599,7 +1599,7 @@ static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
 
 	mutex_lock(&info->vgpu_lock);
 
-	if (kvmgt_gfn_is_write_protected(info, gpa_to_gfn(gpa)))
+	if (kvmgt_gfn_is_write_protected(info, gpa >> PAGE_SHIFT))
 		intel_vgpu_page_track_handler(info, gpa,
 						     (void *)val, len);
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

