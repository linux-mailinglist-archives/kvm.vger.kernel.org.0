Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E113E9DC4
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 07:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbhHLFHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 01:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbhHLFHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 01:07:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702DFC061798
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 22:07:25 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b4-20020a252e440000b0290593da85d104so5056230ybn.6
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 22:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tu2iufR9aI/LsGWpANNecIoICf6nuJGttYFfk37Urfg=;
        b=gDGO2ChgUCHmoQiOTXqkDMN+duj4YxkrJ/UzuL4FTogwGRv3AadGos1imJV/VsqrPt
         C6vf6hkGnjmL3GVWuhwyh4gpVwx/FranaKpxHrs5tF+lUSBQD6ia4eHmtLY5FAou4Gnw
         YVYYs2VUdqRTVUBRxx+rmWhnZSmcupoOyVBcuI7uQLQpZUomvt0+nndsPD+2HVyUKE3k
         itX9sVh8yuORhYy/81vNkmDMVNMX+rMsEzmioXflGzJJHVSjOxdlh1Na06g2bvG5xTtM
         1comgk7mTRjn/UWZ7FVcAwhwSpzvni+E4ZqS/JG9tuI4BGNjyE6OvY0rCoz9oPgDH4cY
         6cjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tu2iufR9aI/LsGWpANNecIoICf6nuJGttYFfk37Urfg=;
        b=gx8AP/bF6vsNyx9+ENtxSiZrCILOj6+xADGO0lTtDFQjAX6NquiaL/e3sN/BjXj0NR
         L3caf/EqPyznHrx0pt3Xcen2B+6H9IiOQQXbynU5Hatvt2/19kgPRH6Zo5XU29Ve7Ma/
         WvZmam557MfedB5MBEkUWKtMFodkjOb2fNyxfmqgTxw2fHjskmGE1egQ1tmIvEUU7Y45
         lyY6KltaJSSjWNWW4aP+asJXYMselOx6LoGthikj3znUDyxNpBjMscTee4WglNs7QWGr
         rBP1VW1+8BtM2iSUU0Nws1EQdj7IwYSXjCULiL7fj/0KaVC9TaB3dofBRRo5vcqpsn3D
         c8gw==
X-Gm-Message-State: AOAM533VCeCW/SO47vardqj4bZvSpCgdHniu7HeljadfyaqqF/AbREH4
        vyJzYIKtq1BIalvCEuAMjddwKIsUxo8=
X-Google-Smtp-Source: ABdhPJwo4nyZkn+Get9j6PRPE86bGaP9wEO/nOLVaL9BNhIMi0FbZA4hRJYqpD6njTHuRw69HmoA4NIxrAI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f150:c3bd:5e7f:59bf])
 (user=seanjc job=sendgmr) by 2002:a25:ba05:: with SMTP id t5mr2017139ybg.120.1628744844668;
 Wed, 11 Aug 2021 22:07:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 11 Aug 2021 22:07:17 -0700
In-Reply-To: <20210812050717.3176478-1-seanjc@google.com>
Message-Id: <20210812050717.3176478-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210812050717.3176478-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 2/2] KVM: x86/mmu: Don't step down in the TDP iterator when
 zapping all SPTEs
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

Set the min_level for the TDP iterator at the root level when zapping all
SPTEs so that the _iterator_ only processes top-level SPTEs.  Zapping a
non-leaf SPTE will recursively zap all its children, thus there is no
need for the iterator to attempt to step down.  This avoids rereading all
the top-level SPTEs after they are zapped by causing try_step_down() to
short-circuit.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6566f70a31c1..aec069c18d82 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -751,6 +751,16 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	bool zap_all = (end == ZAP_ALL_END);
 	struct tdp_iter iter;
+	int min_level;
+
+	/*
+	 * No need to step down in the iterator when zapping all SPTEs, zapping
+	 * the top-level non-leaf SPTEs will recurse on all their children.
+	 */
+	if (zap_all)
+		min_level = root->role.level;
+	else
+		min_level = PG_LEVEL_4K;
 
 	/*
 	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
@@ -763,7 +773,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_pte(iter, root, start, end) {
+	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
+				   min_level, start, end) {
 retry:
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
-- 
2.33.0.rc1.237.g0d66db33f3-goog

