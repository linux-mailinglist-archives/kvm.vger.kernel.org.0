Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9BC767AE7
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbjG2BgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237419AbjG2Bfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:35:53 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7CA3C26
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:35:52 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-583312344e7so27158597b3.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594551; x=1691199351;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BPHrGdmcO+kiKcILc6YcLgffMmTXNHFWJtVnnvxUR/s=;
        b=c4f+vKRihiToZJXS5OogN8iiE6FLuUvOKkmqCmSim7pH2z/utYWPDP2oVqSVGtkG1A
         SWNLm1/AyNWFIXSVTCeRRDtPCloczCV9BmHAm4TIQ+6TPoZlYUjmclmXhMw1bNsrwR1p
         cGrHFdYcS1vUrAfn8uUeNQJFhlilL3d092Hzgj5z4NjaAjqGJnBiMlVL5KIqDHhaenT7
         hpX4y8bbb2dzsC+vVyHxWZAym0YK1xIFqTSmPU3Monwr2Rr1dFQr0frCyiv8zIC9GDti
         Rl/ECx/Fm2afb9uLhum0iHbPNOuhnO2ahivtMk6neha9ZnlXt5q7XUu243mZR+KgHPzY
         VFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594551; x=1691199351;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BPHrGdmcO+kiKcILc6YcLgffMmTXNHFWJtVnnvxUR/s=;
        b=h+jfEOAAEaCDBSTCq6RKbc4dyh6/zuZ9ssEDgM3MSm7Qyb9DRwySD49uFkKphwvn9h
         /smmVToUPcYo2EpOjfwe0NmJvKTTjb0HmboHEEFjzr8E4Yq1RE3yrbz8hNbF8+A1rino
         u/6vh5MjeRW9fnczVIbaHUkS88JTvtzm6bpFz239G0my0kz9IQA2iK5vB4IZYEw54yDL
         LQi3aZifYgcU386+ZJT/x3vkhf6GJPlrnL4SwyiIMBe2c4o1/eDg9bjlvZjiir5yZExS
         rpZPZAcs151+IymnNlS2/G/I3/vxI3Imk8S/JPJzWPdAm5R5u/vbrK3aJnYAbkTAlSbJ
         b65A==
X-Gm-Message-State: ABy/qLY2mapDjgJcyimqkB0d+ag7CeyO3akj/3EflP8yOrba2fuGhNTt
        Qsq9Kpr1wE58DSPKDdwbzuKrnOs03Vk=
X-Google-Smtp-Source: APBJJlHeQ90nVnue4Lo7FJ5laVqHKjVRJxh5I5aaPeVZTHL2nHfUYF5rc5PadMFBFWRwxcMrAtXFpLgqUTE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:711:b0:583:591d:3d6c with SMTP id
 bs17-20020a05690c071100b00583591d3d6cmr26031ywb.0.1690594551561; Fri, 28 Jul
 2023 18:35:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:10 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-5-seanjc@google.com>
Subject: [PATCH v4 04/29] drm/i915/gvt: Don't try to unpin an empty page range
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yan Zhao <yan.y.zhao@intel.com>

Attempt to unpin pages in the error path of gvt_pin_guest_page() if and
only if at least one page was successfully pinned.  Unpinning doesn't
cause functional problems, but vfio_device_container_unpin_pages()
rightfully warns about being asked to unpin zero pages.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[sean: write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 429f0f993a13..0366a699baf5 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -172,7 +172,8 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
 	*page = base_page;
 	return 0;
 err:
-	gvt_unpin_guest_page(vgpu, gfn, npage * PAGE_SIZE);
+	if (npage)
+		gvt_unpin_guest_page(vgpu, gfn, npage * PAGE_SIZE);
 	return ret;
 }
 
-- 
2.41.0.487.g6d72f3e995-goog

