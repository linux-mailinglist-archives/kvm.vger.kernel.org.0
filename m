Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68485654A09
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 01:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235828AbiLWA62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 19:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiLWA6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:58:02 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0952189D
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:57:57 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id pi14-20020a17090b1e4e00b0021d20da7a51so4013530pjb.2
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8k64KFPY2FFl58dlOKiSt/6ffoasCJxRfQQP/flk2s8=;
        b=ADGdSRhE19CpKn3Mx8Gw1o4OLrTbUVUIoTOjSZyGWqJNQL1SN7v8qQsh4q5cXqj6ZL
         hD6fxxwCTl4y/NNCwu4uuodODhWf/UAdCQYUzyxbDjQPykN+rUTv5icpILVoRgxBnOw/
         yeOcWPtNLNwR3Y/uk6j76NAwfZg7MRzWvFz7ko8kkCzO6CB+8LvhG1Xfv7qgN06BwTPR
         tE+2BbMHDSCHA/Y16iC2bZMsqqlYWqoBvXSOH7eVW1O1/dc8s+Fc+brkRiaAncEhUjUu
         kRfRqXhHbJkZXcp9gW5MeZZhEQ+HG6DbvBb/0kC1i/PgW4/d5vbzVWUhK143REl6RJgm
         KT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8k64KFPY2FFl58dlOKiSt/6ffoasCJxRfQQP/flk2s8=;
        b=6WqTHYRyjPF4KS4/40bPYK6DE49oq+6t0zJva4VlfwqsZAOwnx3+WZEDI3URPnLssJ
         pKelE2nOuvla7I4+BntYBHHx68hVU1APAg2t8cTMan5HXLKRfuPRdLm8C5wAMbKL42g1
         MGzRC5W+DQzw/UODGcro6T8qEUUTRKEsCwS28du5oQ05FFhauxKmtDXVhvxxJG5BlL8S
         EVicsllPQaGxT0KMKtYhIu63+eAFA7fzVsLuT6tVhDPADjuWQDaGwnNX+zsPMRgX9+sr
         WkIwaOlT9YEeTroCfBUwSVxWF8YshTm88zvPceUDHlHWGnSppSwg/8kYSM8rn52gH5jN
         RaIw==
X-Gm-Message-State: AFqh2krEHvsXJN+sC5SFlKthmsB6L+OAHW0o33V5GOww3JFsDzBNlEZ9
        UDNRzamwaLifO87le5N0lrVhwYlnM6E=
X-Google-Smtp-Source: AMrXdXtZzqXSfhAfIWlCK+WT2T5JZRV5LJOH9tPTZxKT6bo1HSjiqq3ll6wCTHVFE26Ee59g4OXn+ZR2sNc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7794:b0:189:6936:7031 with SMTP id
 o20-20020a170902779400b0018969367031mr457317pll.31.1671757077092; Thu, 22 Dec
 2022 16:57:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Dec 2022 00:57:19 +0000
In-Reply-To: <20221223005739.1295925-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221223005739.1295925-8-seanjc@google.com>
Subject: [PATCH 07/27] drm/i915/gvt: Use an "unsigned long" to iterate over
 memslot gfns
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

Use an "unsigned long" instead of an "int" when iterating over the gfns
in a memslot.  The number of pages in the memslot is tracked as an
"unsigned long", e.g. KVMGT could theoretically break if a KVM memslot
larger than 16TiB were deleted (2^32 * 4KiB).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 6f358b4fe406..5d0e029d60d7 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1635,7 +1635,7 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		struct kvm_page_track_notifier_node *node)
 {
-	int i;
+	unsigned long i;
 	gfn_t gfn;
 	struct intel_vgpu *info =
 		container_of(node, struct intel_vgpu, track_node);
-- 
2.39.0.314.g84b9a713c41-goog

