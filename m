Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C572A5031B2
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356124AbiDOWBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356170AbiDOWBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:47 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80211381B5
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:18 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id y19-20020a056e02119300b002c2d3ef05bfso5401442ili.18
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vop5IqucqvM+bii5zgbcIy+JPyxF0keenz7pMhv8m58=;
        b=jHJtFLgbxSnb6N3tLR+HWD/NrSJB2+DQfaJR6BV6mi7BHclXm3b5DYu3lRIqkK8ZCZ
         9Nsc5qvQWjHWPk7VT1sJ3wsYP6XTOuBtzzol+Dyx7Y/G8XVKzTeOZ0wTCYISer2gacY1
         1q7hF+P4I9XhHOxrOx0DwqCHp3nlNR7k1lS2WUuwKr6yrpl/wcv2QIQYdgxci9ERkbhN
         GjVhDkCkSw4jTSLDIZKUru4yoXAgzeVmoDz3uo26yb6h1LXdBYsBdQUdxT5prqHk01wm
         t/IKRZMZolVSXf5jGA0B71c/6Sed7CUrur83859QSKnETLM/2FiH2WcM4zCc5JAIz871
         u5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vop5IqucqvM+bii5zgbcIy+JPyxF0keenz7pMhv8m58=;
        b=uURHcPAyxJBkguNrNYSEAL3ovr75IsrHS8IUscCM6Q/fXgZSAvMRVFV6DbJ7x7hsJ9
         pvEmz/ILJnynQ1A6yFHgDIeP9ASiZBSrIF5+nLG1gu1JUVxF+edtg+KPd5cXPc2XPo61
         LHyNYGPFqgK/udynEKSG9IT0id0Y54rhCDc1hDS0VYxSUloTRcQ1R8jZpFvue+YzR1JP
         7dvC/vIBLZWB0fQH2PlVjrMDT+Rj/5RkbuaiMHBlcYOd+nTqaJl9RNHtsSmDTEfcfHDt
         6oP+p/5dTqKzcotACeBlieMSrOsWblipE+mkwLu7x1avPn8T+f6ZNs28LhJAeO7jb/vt
         JUPQ==
X-Gm-Message-State: AOAM533v/GuDAWP1cgILjZSvn33OftzuTCjMEcHqnqXahTIyt9UjFgka
        jo72ekshQei8ZLU/nI11iLMFPoRKE14=
X-Google-Smtp-Source: ABdhPJxNjcu2tnVJ1+/YbC82bpFAmroc7SBNGMAr2Bd/O0LGqLCc49cJVFBPbSuomBfNsod9gY/vH0O4fqo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:164b:b0:323:ac42:8d4b with SMTP id
 a11-20020a056638164b00b00323ac428d4bmr475237jat.75.1650059957848; Fri, 15 Apr
 2022 14:59:17 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:54 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-11-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 10/17] KVM: arm64: Assume a table pte is already owned in
 post-order traversal
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

For parallel walks that collapse a table into a block KVM ensures a
locked invalid pte is visible to all observers in pre-order traversal.
As such, there is no need to try breaking the pte again.

Directly set the pte if it has already been broken.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 146fc44acf31..121818d4c33e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -924,7 +924,7 @@ static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
 static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep, kvm_pte_t old,
 				      struct stage2_map_data *data,
-				      bool shared)
+				      bool shared, bool locked)
 {
 	kvm_pte_t new;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
@@ -948,7 +948,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (!stage2_pte_needs_update(old, new))
 		return -EAGAIN;
 
-	if (!stage2_try_break_pte(ptep, old, addr, level, shared, data))
+	if (!locked && !stage2_try_break_pte(ptep, old, addr, level, shared, data))
 		return -EAGAIN;
 
 	/* Perform CMOs before installation of the guest stage-2 PTE */
@@ -987,7 +987,8 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 }
 
 static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-				kvm_pte_t *old, struct stage2_map_data *data, bool shared)
+				kvm_pte_t *old, struct stage2_map_data *data, bool shared,
+				bool locked)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 	kvm_pte_t *childp, pte;
@@ -998,10 +999,13 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return 0;
 	}
 
-	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, *old, data, shared);
+	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, *old, data, shared, locked);
 	if (ret != -E2BIG)
 		return ret;
 
+	/* We should never attempt installing a table in post-order */
+	WARN_ON(locked);
+
 	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
@@ -1048,7 +1052,13 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 		childp = data->childp;
 		data->anchor = NULL;
 		data->childp = NULL;
-		ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared);
+
+		/*
+		 * We are guaranteed exclusive access to the pte in post-order
+		 * traversal since the locked value was made visible to all
+		 * observers in stage2_map_walk_table_pre.
+		 */
+		ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared, true);
 	} else {
 		childp = kvm_pte_follow(*old, mm_ops);
 	}
@@ -1087,7 +1097,7 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_
 	case KVM_PGTABLE_WALK_TABLE_PRE:
 		return stage2_map_walk_table_pre(addr, end, level, ptep, old, data, shared);
 	case KVM_PGTABLE_WALK_LEAF:
-		return stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared);
+		return stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared, false);
 	case KVM_PGTABLE_WALK_TABLE_POST:
 		return stage2_map_walk_table_post(addr, end, level, ptep, old, data, shared);
 	}
-- 
2.36.0.rc0.470.gd361397f0d-goog

