Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7BA475064
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 02:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbhLOBQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 20:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbhLOBQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 20:16:02 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6501AC061574
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 17:16:02 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k11-20020a63d84b000000b003252e72da7eso11362996pgj.23
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 17:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Uv0feWR75U73TRbVFGvh3+7/mTjQfN9Y46WvkBDuVLQ=;
        b=QehVuUu9KayedcuKIC4Lp2doHPjEurYGVJza6/uvO8tYaUqEbw0niEhXiABMHPi91I
         ZrmKxb5xBqYT5fI2cEDn+f+mriVYwGfO6/y6OQDM/YzGNfVcDDPnFatD9wxUV1R2tY1v
         ZrXpOSIj2Hy22NCsofqsOyGTYtpCUPt8YO+u1OJIfjTLViJhnIva+USGhwWZSi4DCtS2
         BFEBk/Df2qRD5UXoqvhVeY7YqnFmULK4EfLuIcax9sCTRbFDmr2v6hhfjXMdevw8VBqu
         jVMD604O0YlJKVsWgPxOVAeewkajlFETV4FhxgPtV8at+Fw1ivDgSV7INhxehAOzdGDd
         QU9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Uv0feWR75U73TRbVFGvh3+7/mTjQfN9Y46WvkBDuVLQ=;
        b=ahI3cPlxzfE/sEhntHo0HtRSSPf6LQu/W0x5km8ewO3VrVwBXuGo/2fqD5purQ8Wk3
         VJT/wjY2brZ+rgW4klTC1tGmLTdHM4MXIuExNEv502ofyZ2IpdJpuGE1ANSPWszii5MY
         eGYWbSNaIFrud4ZYoQyikPrJctuqgo7wChl4icHrKzH0pw1dcXKEGZseXNbk8CYhFnW7
         jZHq/LatFCUEso60ZcX+FOKWUr+UliXQuQ5fCS9chKDcjE0DJgruYgHuZkXC28WaV4bY
         byHo4reWUSSBz7zg3f4KKC9sC1MyXRKGWlUJeCtQxk/ocx12wlLQh4A+vJ8XAdmAYLKa
         dH5w==
X-Gm-Message-State: AOAM531f6qNTuYvWbDxbCqyEtU64/GS8e0cnE3UgvagiYt8Kg5wjGIJY
        WLJVAB97DmREl+zH2vS0IWilQjN4gdY=
X-Google-Smtp-Source: ABdhPJzsnLCpDRStMnfUu8b2V7PFVsdYlw6+8uUbgBvG0pZ98cU6fkcv5Y5zFfED3sMMQbxrCHTUfRkLOFQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:789:: with SMTP id
 l9mr526684pjz.78.1639530961812; Tue, 14 Dec 2021 17:16:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Dec 2021 01:15:54 +0000
In-Reply-To: <20211215011557.399940-1-seanjc@google.com>
Message-Id: <20211215011557.399940-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211215011557.399940-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH 1/4] KVM: x86/mmu: Use common TDP MMU zap helper for MMU
 notifier unmap hook
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the common TDP MMU zap helper when handling an MMU notifier unmap
event, the two flows are semantically identical.  Consolidate the code in
preparation for a future bug fix, as both kvm_tdp_mmu_unmap_gfn_range()
and __kvm_tdp_mmu_zap_gfn_range() are guilty of not zapping SPTEs in
invalid roots.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7b1bc816b7c3..d320b56d5cd7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1032,13 +1032,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
-	struct kvm_mmu_page *root;
-
-	for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
-		flush = zap_gfn_range(kvm, root, range->start, range->end,
-				      range->may_block, flush, false);
-
-	return flush;
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, range->slot->as_id, range->start,
+					   range->end, range->may_block, flush);
 }
 
 typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
-- 
2.34.1.173.g76aa8bc2d0-goog

