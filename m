Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D8150314E
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355699AbiDOWBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244152AbiDOWBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA57377F8
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n10-20020a25da0a000000b0064149e56ecaso7651087ybf.2
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rJSIRdYzlgGDLU7B2Sk5nACgnVsuidWq4rds0LFJzOM=;
        b=SkrQ1f8DZ8O/NnR7vbyJvJQIHE/etfmq3uFO690m3CAYnbo6y2Ixqb7gAvpAOTVELL
         6wOSAg7n/y+F6WeMp05hmHl1fcyiWC8VoNMxEO4OeOYzRlFDvzzQ7jFGCTtm845QHSoG
         LccB7cLdd71eA0BI0Ru81TgjWmc8dS30Ot2pDg0Hy1uI1b5zb05v+/GrUfnWCauhOnPJ
         NySizl2te/E7Y0lMCQzjXVzUzPthbWsjhBBncJtixhl5pRXhKQ3taAldhzHbsTSuXMOE
         rm5tR4TfdW/tfw/Uf8GxBSY3l4Dd0OpWCNbMfnbvgCpEtN0cME8Q2ExGtfE12VB6U/GX
         +VFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rJSIRdYzlgGDLU7B2Sk5nACgnVsuidWq4rds0LFJzOM=;
        b=G+3hRbYGjYRm2NKwWMIAm94QseQDBfgmWEkLbHK5qdiNSRAChfPODxHMFGIkyIpBAP
         SSunruvgX2mPh8WjhMSD//TL4lKoyRLzmCLVxTVL8mZQ+HzlVc+6oRtmpCzWCq74BlGG
         1n+ZqUbEzoNuhNLz65w2TPXLguaV9lapVUTHASxmXjsTX8kRjcEdy4YL/cQgYM2PEw3e
         XuLKFAvTuH1sjVOiCGBv3u7z5dxgw4q6hO1X17EfZhPp4S3cUwlKBR2xGbCr+YVE6kdL
         lm+HKxdRXDRMROCEsMKniIDocIOi2G8kuTqaD8vUJMaXTBxq4xkmf88jksg0IK0cqlvz
         NIDQ==
X-Gm-Message-State: AOAM531wfoMTh0KgHFSQOtA2OZBZ6CmVqo+SvZltjnSl4a0VXYlgwTh+
        Sd6ovPowFCakB34FECbtcOBJ8JUulv0=
X-Google-Smtp-Source: ABdhPJwz4sx5L43ob0Z3jNzyJVyA2Jzsl+sCY5ofO1Xxk9cu0zlH1igqV35RpwEAUlFfB8+y4wm6MGToMi4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:6f55:0:b0:63e:7447:7c19 with SMTP id
 k82-20020a256f55000000b0063e74477c19mr1036666ybc.551.1650059951469; Fri, 15
 Apr 2022 14:59:11 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:47 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-4-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 03/17] KVM: arm64: Return the next table from map callbacks
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
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

The stage-2 and hyp stage-1 map walkers install new page tables during
their traversal. In order to support parallel table walks, make callers
return the next table to traverse.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index ad911cd44425..5b64fbca8a93 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -205,13 +205,12 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 	if (!table && (flags & KVM_PGTABLE_WALK_LEAF)) {
 		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
 					     KVM_PGTABLE_WALK_LEAF);
-		pte = *ptep;
-		table = kvm_pte_table(pte, level);
 	}
 
 	if (ret)
 		goto out;
 
+	table = kvm_pte_table(pte, level);
 	if (!table) {
 		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
 		data->addr += kvm_granule_size(level);
@@ -429,6 +428,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte
 
 	kvm_set_table_pte(ptep, childp, mm_ops);
 	mm_ops->get_page(ptep);
+	*old = *ptep;
 	return 0;
 }
 
@@ -828,7 +828,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 
 	kvm_set_table_pte(ptep, childp, mm_ops);
 	mm_ops->get_page(ptep);
-
+	*old = *ptep;
 	return 0;
 }
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

