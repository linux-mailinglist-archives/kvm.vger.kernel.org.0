Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72EA70131E
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241159AbjEMAg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241005AbjEMAgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:36:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B04159E4
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b9a805e82a9so23508545276.3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938173; x=1686530173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yTF+WvdTXOp88OUwMxHsF/SYvL5GAznXpvvOJVXr590=;
        b=6clpcNXwWNgtNSBv1Zuk/HmYC1Ks8Z/956BRzb0731I1kGR3sHKzRDOs8rAs55Rngl
         YjLuzIFPVOaWwOFhxj00mGWX5v6Y5zmAsUVKlXW9dSMnUWfihfWcGbsxx/I2Mc2dFlCS
         J+3sFb2ZQuySk4Nr8M3GUZT5mX/9hDwI6MGTbwWBC9pmh8tpW0cK1X1J7mShS6THXi8A
         gBFUR3R4cpv0GkJSakzcRj3FUOW+uJnd5/aAId1JxY0rey3Jwz0QtMgu91VHfSOlNnIq
         HDHMzpGoJrm3I37RuzzTHm+5Y46vQHC2/CO+XFbFRbayyHmQIA4qNF6KOlI4W61gzbsK
         1aVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938173; x=1686530173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yTF+WvdTXOp88OUwMxHsF/SYvL5GAznXpvvOJVXr590=;
        b=Rh3KDO/1gQqbEmhO09C61wTBfyPdySO3FuJkYi54uvz1B3iFEdW4EI7kVUwMeNxBty
         li/SlRrdRy3efOy//nr4y/mcdcT3xPjsF+vnyIOuERQmd+AHeS82LZ1uuHsLzWDeIuzA
         FWM9FP53AKl7Ygy9oYRG7bLIuR30hhpor+f8ItWnt4tY9fH3AZ2Ys3M3JbnvwRRBSFzt
         0aLUuF+Mvh6a90Rt0uE+Lqoiye44Wpxw6FGGkSm1qg6jVWuhtWa5jpWe9X9rtl0Hb8Nv
         ID96WzBV+mIm38P5URAne7sfgIDpOLLPHTueiT0cZ5vmjlOU1KlQnFkUDKgb/OY6uwZI
         Pufg==
X-Gm-Message-State: AC+VfDxxt0JeV3oIe7kdxDnKrDlYgl/oEBLXH+MVVI7Z1tG+us4/585o
        tlTiwrvhmoVm8WyyqpTS3djaq/ARXdE=
X-Google-Smtp-Source: ACHHUZ6sCXV5bYrQMueEEkeXbkChM3ieDdBL6hB5rVuoYaO/GqHC/qHdq6D5z3cP7chOjEQvwTelozt9YWI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:824f:0:b0:b92:25bf:a6ba with SMTP id
 d15-20020a25824f000000b00b9225bfa6bamr12046826ybn.6.1683938173689; Fri, 12
 May 2023 17:36:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:36 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-5-seanjc@google.com>
Subject: [PATCH v3 04/28] drm/i915/gvt: Put the page reference obtained by
 KVM's gfn_to_pfn()
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

Put the struct page reference acquired by gfn_to_pfn(), KVM's API is that
the caller is ultimately responsible for dropping any reference.

Note, kvm_release_pfn_clean() ensures the pfn is actually a refcounted
struct page before trying to put any references.

Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/gtt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index f30922c55a0c..5426a27c1b71 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1158,6 +1158,7 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
 {
 	const struct intel_gvt_gtt_pte_ops *ops = vgpu->gvt->gtt.pte_ops;
 	kvm_pfn_t pfn;
+	int ret;
 
 	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
 		return 0;
@@ -1171,7 +1172,9 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
 	if (!pfn_valid(pfn))
 		return -EINVAL;
 
-	return PageTransHuge(pfn_to_page(pfn));
+	ret = PageTransHuge(pfn_to_page(pfn));
+	kvm_release_pfn_clean(pfn);
+	return ret;
 }
 
 static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
-- 
2.40.1.606.ga4b1b128d6-goog

