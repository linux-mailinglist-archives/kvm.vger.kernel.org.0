Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B160515649
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 23:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381201AbiD2VEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 17:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381162AbiD2VD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 17:03:56 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E01D3AD7
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:00:36 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r9-20020a17090aa08900b001d8826816e6so4562491pjp.4
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=PGUqiH/JglfCNg66NlUe0oA1IPz5o9GrdggIDdddkRE=;
        b=s/vbE87ZICW9wq0xlvyre3d0eVPg+hDf89OEwfE8pjHkZ5PUqoD/1vk4hhdAJKIyHQ
         8rpJfCXFOB/J0SnSALJ4ick7jy62clfywkqsbYHNqegMPIM5RKcfaYdoboJ1/uyUk/QQ
         5QD5H/49BtbQaJdfUPDsoY/cXP0CcVkRIwfe17PKpsiFB7eW071pViEO7cKA4yBSN6b2
         1exe+gLb02QqzYQZCl1Oeljtj6nxa9ghPXX0HsMiFiuP0gCWnB5ZSC2iW+kiu94UQJle
         PEQhvzTFUVKe5Kp+QKMIhn4o4u87Tkobx7MOFs57gbj+LTg13JTxv4N9YxdvpaOUgAlp
         73cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=PGUqiH/JglfCNg66NlUe0oA1IPz5o9GrdggIDdddkRE=;
        b=r/DuYPHCTqfYyNiJb5vWaXdbdtA4obuvaObFy1xiiYoFTZYTy3C7rfFEeqT5A+vIgh
         N6fu9kPd7/iFtkEKL6ahcwqXqe89IZm7jD5lv6evsHTrhoTT0ZbT8dYbrOWgn2WGn07a
         9MEFw5qh+8YcaKIHKzs/uEgWDjiZBwJzAQ/K8GgNu1UALFdw4bDvgkBxdKNPCf5KIjV2
         j6TknPkWdQnIebitclPmg9tfc4fyTLpcrol0SvdKvu7CzWomi4Gp6aRQeloV69zxEGIH
         D+C5qI8iKlKlQCWwvn5HsXE/MeutKukCjC6oDxPu2Zp8flVome5yHaRIVswnXMpokaH4
         u8GQ==
X-Gm-Message-State: AOAM5313r2HDqB7bfjTS6bqgxoHKirVE53p/828qjQPddR97tedKzOqq
        W69Z1xzoffXC9Q/8+po675F3dM3tkmg=
X-Google-Smtp-Source: ABdhPJw+Ha/bmwyj6MBf0DPJjOjQzCpbQ3w89P8CYxsLPsL/ID7MWV7hYSLf9zEanA8oDKqLAG74+J5T8kc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:240f:b0:158:b871:33ac with SMTP id
 e15-20020a170903240f00b00158b87133acmr1131724plo.135.1651266036182; Fri, 29
 Apr 2022 14:00:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 21:00:21 +0000
In-Reply-To: <20220429210025.3293691-1-seanjc@google.com>
Message-Id: <20220429210025.3293691-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220429210025.3293691-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v3 4/8] KVM: Put the extra pfn reference when reusing a pfn in
 the gpc cache
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>
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

Put the struct page reference to pfn acquired by hva_to_pfn() when the
old and new pfns for a gfn=>pfn cache match.  The cache already has a
reference via the old/current pfn, and will only put one reference when
the cache is done with the pfn.

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index e05a6a1b8eff..40cbe90d52e0 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -206,6 +206,14 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 
 		if (gpc->usage & KVM_HOST_USES_PFN) {
 			if (new_pfn == old_pfn) {
+				/*
+				 * Reuse the existing pfn and khva, but put the
+				 * reference acquired hva_to_pfn_retry(); the
+				 * cache still holds a reference to the pfn
+				 * from the previous refresh.
+				 */
+				gpc_release_pfn_and_khva(kvm, new_pfn, NULL);
+
 				new_khva = old_khva;
 				old_pfn = KVM_PFN_ERR_FAULT;
 				old_khva = NULL;
-- 
2.36.0.464.gb9c8b46e94-goog

