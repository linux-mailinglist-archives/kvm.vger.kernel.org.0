Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7EA767AFC
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbjG2BgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237557AbjG2BgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:36:08 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002A444A9
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:35:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c83284edf0eso2510910276.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594558; x=1691199358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+XjAGHd/pRUURJC5c+iD/2xPUGDJjhirgzMYmue5Z/k=;
        b=CKHIraU33muydXY8T11nRNSenZqtYLuDp2ZQytPMAEgN8FpFJtvv8c6QRBQGgm/m28
         5/Ef0IINErZFczYeoHyi2UfkWYU12OwKkPvWHaSFJrjUPZqGfUYERJutLB1aMadZV1Zn
         SbQEj3XAgke61HqppvVm0rMriHUMBVoTNCE2nLD2YyhY5gcfR1Rhx1wnLXfG2afabSK2
         pRkPRHhkAdYbj9t7TkumNFQMi0Xc34gB7AEzsmQRuKqF6zeV/+K8B4Kwdh97aMLi9utI
         7XQaYcFW2xHNzFDjGpWhfz4/Z7F4dsBgodxWkzRezSqVS7FOSN25NA1qNujI/xI62XWI
         jSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594558; x=1691199358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+XjAGHd/pRUURJC5c+iD/2xPUGDJjhirgzMYmue5Z/k=;
        b=BuogyYbZ+T9K6/KBi9npZ8z+ZRrUa5nh14+lHR0sNBCsJqsh6KfoBqHOFLuQufzxT3
         8eJRs7O3LulE/b+ssur+YSsJRyrzYzlzFO/CO8TFsoUrTGyB+dSEiiRlUlhVnHhWCpg4
         LOIDHUA6FzTe1vQyRb6/st8AZNugPaO3YoUBgpHMgk2D7yTkuv0ng5gmHKqgGp/e8bbj
         xUxt3N3k1NW2pCpLSTfLsnS0/zu7X8d3O+fUisvNnep2+dt4DxmKtFHiJ7BFYHu0oOsM
         3B/OhQQDdV2sbteluNKP9tZ5N30SRiTXLCSnTMB/a5lB/dfeuIPHjb2gG+TmDLCnJIsF
         cadw==
X-Gm-Message-State: ABy/qLZ/OZ3XMtCmPqzuB1o1gcHnwtCNiefc+lOyVNMOWmWrAbH8jQUS
        N7wC6dZbQdeEov4gm+sbxdobeP3w/6A=
X-Google-Smtp-Source: APBJJlFT9Nke5NL62NRh+Q2yKpoZkg5zH69bxdcqRsIUxtenGQRHYqPeN341DwjUJ6XKSWDHD2CKgLcKfrk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e7c8:0:b0:c67:975c:74ab with SMTP id
 e191-20020a25e7c8000000b00c67975c74abmr19106ybh.4.1690594558122; Fri, 28 Jul
 2023 18:35:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:13 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-8-seanjc@google.com>
Subject: [PATCH v4 07/29] drm/i915/gvt: Error out on an attempt to shadowing
 an unknown GTT entry type
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

Bail from ppgtt_populate_shadow_entry() if an unexpected GTT entry type
is encountered instead of subtly falling through to the common "direct
shadow" path.  Eliminating the default/error path's reliance on the common
handling will allow hoisting intel_gvt_dma_map_guest_page() into the case
statements so that the 2MiB case can try intel_gvt_dma_map_guest_page()
and fallback to splitting the entry on failure.

Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/gtt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index 2aed31b497c9..61e38acee2d5 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1306,6 +1306,7 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
 		return -EINVAL;
 	default:
 		GEM_BUG_ON(1);
+		return -EINVAL;
 	}
 
 	/* direct shadow */
-- 
2.41.0.487.g6d72f3e995-goog

