Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B911A767AD7
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbjG2Bfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236363AbjG2Bfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:35:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435B110FC
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:35:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d27ac992539so1160246276.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594544; x=1691199344;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fW+zeLl0d3GvBZwCEAwlFx7jr5U4FE8sODZ9RvpbNnI=;
        b=ZP2Pl1U+VMG9eIcFe1thgUAFsc8cZjkOgPAjp9pDooSSsuJ2j1IZOS08mKcskS4QYf
         pOXDSlUcYjELo1efpHRXVtgHB5y7GpDNQUMco/ZqNeHucoPdW3Y+rlVQNz25meZc7hqq
         5RNNwpLrak8abUMmSRtmmh8AaDlM9YcDnXUwD6csXaCt+0zy1bTiHq7gwzTzbt28WWc8
         8QORYHFn6N2qOJveGmETgH9unGEwC9f/hkfDgCu1zRLzUBiNYnGBWnMbpgxn+2YTbBT0
         XSWD6sjGPelyY0Y3oKO6zCWGJa81RfHN/ZhFDivLtF2rE33X8pVMkHMndFMtf1evPZJb
         odwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594544; x=1691199344;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fW+zeLl0d3GvBZwCEAwlFx7jr5U4FE8sODZ9RvpbNnI=;
        b=ct1sotR+FiWP6hpLxm4nBAbA//6vNkwvc82ShmqK+iDB4vrB5v0Sm1v2MS2gdU0Vaf
         4vKeGhwYUqNkDAzozJayTxn+/ptQMZmqM20J+tQXEeBIvUBgNTLIq490QGG3kNHMtcYq
         a7Qe2tfr9bXYci4YuEckIg/A0J40RJlN6MmInjMOIZlIaCo5WFUh6vGuWEQf4HOeD43t
         Ls3E8XjGMh1wBOZNL3pju53QxRj6yctCVKm7uvT8DHfG9cUHn0mVyWQoZrZ2JGSBQKgV
         uBgpFPLd92J/budIAKywztA16yjMoTRGqAdMGVSDYF+l7skWOfFYui4EzAJF2QpGm0xO
         2hKg==
X-Gm-Message-State: ABy/qLa/RZ+wtsSyXHYSeGX4EgggFl5COfuwF5P1BnV5ogYT67QOpXro
        hyz2LmSh/cPFs/O+LFG9z0Ogh+fL6eU=
X-Google-Smtp-Source: APBJJlEMdfy+y58tC/xUBasIf3ZTmatdKbl/uuM/5Z7SlwY7B7FyHVWpyPUm13Npqe1zGQwR8s/AvTfClgo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2508:0:b0:d05:e080:63c6 with SMTP id
 l8-20020a252508000000b00d05e08063c6mr18632ybl.9.1690594544514; Fri, 28 Jul
 2023 18:35:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:07 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-2-seanjc@google.com>
Subject: [PATCH v4 01/29] drm/i915/gvt: Verify pfn is "valid" before
 dereferencing "struct page"
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

Check that the pfn found by gfn_to_pfn() is actually backed by "struct
page" memory prior to retrieving and dereferencing the page.  KVM
supports backing guest memory with VM_PFNMAP, VM_IO, etc., and so
there is no guarantee the pfn returned by gfn_to_pfn() has an associated
"struct page".

Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/gtt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index 4ec85308379a..58b9b316ae46 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1183,6 +1183,10 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
 	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
 	return PageTransHuge(pfn_to_page(pfn));
 }
 
-- 
2.41.0.487.g6d72f3e995-goog

