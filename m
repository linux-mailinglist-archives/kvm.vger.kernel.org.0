Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC5B70133C
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241666AbjEMAgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241505AbjEMAgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:36:31 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D1A559F
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:22 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-643aeb66f4bso5439246b3a.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938182; x=1686530182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xOh8270aHmhQkt9lEUjS49SPgiz7MiCgITarxX9E6A4=;
        b=0jqUD1zjEi55ZfhAIwMWNWENT9MRrpNqKPwfQ1O+9RvhBF4O2kdCyXExTphM2+/m9k
         /jnyyeFCDa3H2au4xyKDmwQ25q0BQadY/AQ5keaYUsgrQKFeyRVTbA64tAv2mHUVd79F
         MA1woP6wnOSriWMc3ixbrjlmsjIvDoDt2FMBhOh/vWdW0IYpXN+YySWq8QleQOn1OCNY
         zaA45ZWqVu8O+rYagST5vwdnd2n7ifjmb0xsLWIRl0HT3SzfiTn9LZMpvRUt0vUY023R
         scxbCiPEhmmQYIdSQSSJVaEk7yZ8fAWjNetppIAeHmtlBBJ2ncdcrr67LCrk49c7ptKV
         AVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938182; x=1686530182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xOh8270aHmhQkt9lEUjS49SPgiz7MiCgITarxX9E6A4=;
        b=A2oQFreQPQCS1vdFKlQbMSf0bRmdqZaChmy/j/0D/Cs+Ge2wytTb8gwkkMbQKup4ST
         LJ7/mp+MRPzDzR/57KnAjV4HqAPegw3x7iiOgSFODTpBcP6Fvs5DX3OQidwJBmh1QCw3
         AwJPAbC7qb4RPNVh6rLXk462AunZl9HFGbWcR1SsfKNsY37PqcYi1UQn+QlkPe7E4F5S
         QwWebwBpZn7C/+TwIJ0D4T6kyX9kli7D+qRUxds2wAltHqeog/KZ5JqzrnDgKJS7hZPV
         I+rW39Hc3APuN2lObZemZKR81Tvw4CIeW6hKnOuidxYHS7ZnL+vCZTROrgnzeFiVMHdr
         Zxtg==
X-Gm-Message-State: AC+VfDwm7q+l9b566d2IOtZJfgvSwLRCc+btRxQUjvnqvu2a493l5c7n
        liTBAE+Rn64juqaU9zVrpx1k0Y0x9TU=
X-Google-Smtp-Source: ACHHUZ4jgx7mBorgy6buawkOwqeHbNOdHMLcx00pmvGCjodnLruorEbphmkbg9mH6m6+8x0sTFFO0bzj3qo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1790:b0:64a:f4ac:3433 with SMTP id
 s16-20020a056a00179000b0064af4ac3433mr565273pfg.6.1683938181992; Fri, 12 May
 2023 17:36:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:40 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-9-seanjc@google.com>
Subject: [PATCH v3 08/28] drm/i915/gvt: Use an "unsigned long" to iterate over
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use an "unsigned long" instead of an "int" when iterating over the gfns
in a memslot.  The number of pages in the memslot is tracked as an
"unsigned long", e.g. KVMGT could theoretically break if a KVM memslot
larger than 16TiB were deleted (2^32 * 4KiB).

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 92ceefe1e6fb..117bac85ac2c 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1619,7 +1619,7 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		struct kvm_page_track_notifier_node *node)
 {
-	int i;
+	unsigned long i;
 	gfn_t gfn;
 	struct intel_vgpu *info =
 		container_of(node, struct intel_vgpu, track_node);
-- 
2.40.1.606.ga4b1b128d6-goog

