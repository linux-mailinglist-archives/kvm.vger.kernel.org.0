Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCCA4EE84A
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 08:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245479AbiDAGis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 02:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245464AbiDAGih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 02:38:37 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9548318F206
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:36:47 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id x32-20020a631720000000b003981337c300so1188886pgl.5
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jEiThSY5io7iqeivSdVrWS3wQB6IdCOB+6U4bME4fgY=;
        b=sps9qGKyNmf+5b3n2bkwDIVDtx5Yq0BVKRxCnUepqnxV9GAILe7KG+LbBRCJa2lkL6
         9w3aOe7cIwtMG+dVHztyRSADk6zzm+RzxFs2RqBUjRZFhzBcDPP+bMyJO5n+y5qQrGjG
         QleH2pwjAoMZvRLAqoN3H2Lqqi8a1K3rFRYd4lJxspD5FIXKG6bI/t/K6jfKLoTJlvGq
         2lEMI4HhR1zQdkFyWlulmdZ1HO2BFJAcAbDfe9C2+ey8lgx+IID3v/ZTBJFFcfQSuo+Z
         u6pHXykmiIgt0F+X2Zfbs9HgoOsZmzPqGI+C0URmCxzcJ0IEoxuoykh5zxJgWo8xIr9e
         1kfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jEiThSY5io7iqeivSdVrWS3wQB6IdCOB+6U4bME4fgY=;
        b=xuTZvb0d2oAuf1WUXY5gUiLBGmz258djYKfyQfGma2dU1sMWP6WX0r0GuxyfCbLyGJ
         RfHmUzxPZWVSy4fluZsV/dlzGZHpropjkvloqFPrUjIj6Omgz9N5ggMeVlsnB11aI+BV
         j5EBZ/rocLIvbsP975IwJmRVm14PMXuYUgvyXHga0ieIMUyhv+w1YZVdYhA2DHlHLmZv
         AkHoDWkhTf9ybqtLmGHGTSi02UIQk+3P5CNqEjSAieZ02fYAYrncatysLr/aq8biGmIh
         pFx3zk6oL9W91dogn6zYLRzy4gUdkT6a7pGyX1ulUkRFGEDUipf6TOvbsbz0p5Ss3ekh
         VVqQ==
X-Gm-Message-State: AOAM531DytiHuU7Dk3RMY92Or6z21ZE6lPBCG5IZJUqJtKLOzXFwtg3K
        2L9Yb5XrAUgyEX605dJiiray3IDXOt2e
X-Google-Smtp-Source: ABdhPJwo9sODgkPXK77NyeA2JigKrPu7Ax7hOoyKYNGMGTjTyYZjOrtTdGXzsPU1XHtnHlWu9KuX2om/jf0v
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:2908:b0:4fa:9297:f631 with SMTP
 id cg8-20020a056a00290800b004fa9297f631mr42950687pfb.3.1648795007009; Thu, 31
 Mar 2022 23:36:47 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri,  1 Apr 2022 06:36:33 +0000
In-Reply-To: <20220401063636.2414200-1-mizhang@google.com>
Message-Id: <20220401063636.2414200-4-mizhang@google.com>
Mime-Version: 1.0
References: <20220401063636.2414200-1-mizhang@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 3/6] KVM: x86/mmu: explicitly check nx_hugepage in disallowed_hugepage_adjust()
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly check if a NX huge page is disallowed when determining if a page
fault needs to be forced to use a smaller sized page. KVM incorrectly
assumes that the NX huge page mitigation is the only scenario where KVM
will create a shadow page instead of a huge page. Any scenario that causes
KVM to zap leaf SPTEs may result in having a SP that can be made huge
without violating the NX huge page mitigation. E.g. disabling of dirty
logging, zapping from mmu_notifier due to page migration, guest MTRR
changes that affect the viability of a huge page, etc...

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5cb845fae56e..033609e8b332 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2896,6 +2896,16 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	    cur_level == fault->goal_level &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
+		struct kvm_mmu_page *sp;
+		u64 page_mask;
+
+		sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
+
+		/* Prevent lpage_disallowed read from moving ahead. */
+		smp_rmb();
+
+		if (!sp->lpage_disallowed)
+			return;
 		/*
 		 * A small SPTE exists for this pfn, but FNAME(fetch)
 		 * and __direct_map would like to create a large PTE
@@ -2903,8 +2913,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 		 * patching back for them into pfn the next 9 bits of
 		 * the address.
 		 */
-		u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
-				KVM_PAGES_PER_HPAGE(cur_level - 1);
+		page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
+			KVM_PAGES_PER_HPAGE(cur_level - 1);
 		fault->pfn |= fault->gfn & page_mask;
 		fault->goal_level--;
 	}
-- 
2.35.1.1094.g7c7d902a7c-goog

