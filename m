Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED8F654A02
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 01:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbiLWA6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 19:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiLWA55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:57:57 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6403A222B9
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:57:54 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id h6-20020a17090aa88600b00223fccff2efso4000095pjq.6
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NBTVXhB5C1LBSgUVZgx9DDnSqNxpCLvQp+2Tt7daAzY=;
        b=PlfdJuINIz79VbNXj96aWe6+xyqOcNWgoFfBKXO69TEmccmX1942p1Kyzpar864asr
         XDLlrV4h/z3yt7ub3l4JawTQViMgB+vso07ZoO5qPG8HZ8ZwZ79n9sNsdI9q2RoIwbeG
         AbHqwyDWwx9IAhFNAoqcInUGxLMtyU01VX9lvM0rmbSOQgWKiNnfERh1rh/elzAovs+8
         3y70iyzOvz/NxL9S/TaVq/aBs6+nmTg/gOUzTp23eWU84817bdw4cPSr/sXHXzdSEx8S
         P4Mp5+sUcRqXpTl/uiqPGeug+OSUTglz8ISXwjwtbnXBQir9/d83nYa1sF0t6p/+TDh4
         ciOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NBTVXhB5C1LBSgUVZgx9DDnSqNxpCLvQp+2Tt7daAzY=;
        b=w355jLr1QdeOgJL5Jo9pwdm+ZxE5jzDGLrpEGGdbGdH+tHmkeXLn5bv4xk/nibTCmb
         EHIDpZ0fyGBXZLZNrrIJSFs+k4MLXTysABBUNbI0SsGakeh9RmMubl3FvNgLp4LbTHoB
         SfjBkuIhm17+00558A5n98wY9pJp2EaKYDHXonEQvZKc6/iiLLVsebA6AYlw1cylAciI
         Fhd+8gYH9mIkusdtndmQgcSs0hRbGmKEJnj0wLbWxHzL0x4/+XxiGv7Y5lBRTir5Tvyb
         szUCWAFPDSHXZ5ge9r28Ps9aKnvY1hQEz9jfU6jOjNhjb6LYl1zuoCR34IMv2K+8eEmv
         z3uw==
X-Gm-Message-State: AFqh2ko9TAoxep4hyBHXSNGTJG/I4+X2OZY97fjjOfVdwXYlWDgPxb6f
        GRMIJAVdNzwujYiSb2/ZlEMRrYfWgMk=
X-Google-Smtp-Source: AMrXdXtuJpzQAA6YsAARKoo86Ndko68Bw/8PzP0Po4HgPrkiwdi87VkArdRLlydeD02n3c8sF2p0uUxApik=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c155:b0:189:9a71:109b with SMTP id
 21-20020a170902c15500b001899a71109bmr561626plj.171.1671757073922; Thu, 22 Dec
 2022 16:57:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Dec 2022 00:57:17 +0000
In-Reply-To: <20221223005739.1295925-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221223005739.1295925-6-seanjc@google.com>
Subject: [PATCH 05/27] drm/i915/gvt: Put the page reference obtained by KVM's gfn_to_pfn()
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

Put the struct page reference acquired by gfn_to_pfn(), KVM's API is that
the caller is ultimately responsible for dropping any reference.

Note, kvm_release_pfn_clean() ensures the pfn is actually a refcounted
struct page before trying to put any references.

Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/gtt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index 6736d7bd94ea..9936f8bd19af 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1181,6 +1181,7 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
 	unsigned long gfn = ops->get_pfn(entry);
 	kvm_pfn_t pfn;
 	int max_level;
+	int ret;
 
 	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
 		return 0;
@@ -1200,7 +1201,9 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
 	if (!pfn_valid(pfn))
 		return -EINVAL;
 
-	return PageTransHuge(pfn_to_page(pfn));
+	ret = PageTransHuge(pfn_to_page(pfn));
+	kvm_release_pfn_clean(pfn);
+	return ret;
 }
 
 static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
-- 
2.39.0.314.g84b9a713c41-goog

