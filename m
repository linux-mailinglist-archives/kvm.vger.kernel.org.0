Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7475030EC
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354390AbiDOWBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244034AbiDOWBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135B637ABC
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t190-20020a25c3c7000000b006410799ab3dso7542870ybf.21
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Tyg2Q1CJQYh6kqJKn5I8WsZWhqynGf1zv3GZVnyVrPI=;
        b=bs/o3a1yI+YtQKTec7tfylXXQu4M6ad2QWFFL62JX+gXbwqO9FEus3pkH+ThX+JPAr
         JPEPreeCxgkfcEjZxuDSMTLLZUbJYuMNUMiPP28ZaBVQA8xAoGGJwyWWqjUTVOr9w+H1
         scbsRRQ4oV/0Ko6nzOrL8D58Z+zUc2quNieeYqKnL4/2GddH6EUAGmW8TUmhdokw0buR
         c0G9PrlnzO6Zct/R0EMtBthEbtbkFluRFT3bcL6Benpi1sBm1BLEUooH5TD8OFDM9SNB
         FGX1+tPIQqSDfmOl4/bgqfhcbkyjAEMmpAUImOqM0PuNfNbC+i60/UI9Bsp0mp7hYMtn
         Jqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Tyg2Q1CJQYh6kqJKn5I8WsZWhqynGf1zv3GZVnyVrPI=;
        b=kczd9ns9/U4CWq6ZSBPbq7eX/fTVaiRobOGdGtXtPG2RQku3YuzTdJ/XBouaF7o7Iv
         Zg0nWohPGGtvqcw8t6inzntyEwr07RE8TiNH/p0DOCZqXPMeNkTUyCm653ZN4X1ZcH24
         cc/0tOiVDhCjevbqAEoGCY/WXrz6nkAi2jOhObmTZ2pwhE4N+BOa/5wr/sV0USEZnC0z
         tfw+WQip3nlYW/EmlIumo+n4csFKnnllslY2WiOLbP632pB1hVEWxLIEJm/ulsl/UfXP
         /OHg5W4EeWNuGrDaDYc+ibYu0cPO8YlVvkkg9DUZeIk7LZZWihE7wSjVZzKnx0LqLCkl
         XLXg==
X-Gm-Message-State: AOAM530rHY8o7T2wN18sjAs3l0tTmXeebtwi6RL3FS2GcVhI44jW3A+c
        EkHuho8iv9OXc0Si5Jrpz/5gzon10Nw=
X-Google-Smtp-Source: ABdhPJxEvl0U3CkvkcrBAn3HsWtsYmV0z/JZVUMkoVOPtU1p1JiWR679eaZiC7C8eGZtheHJa4oZ8Gi2BLk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:544:b0:641:4007:1da8 with SMTP id
 z4-20020a056902054400b0064140071da8mr1070971ybs.195.1650059949262; Fri, 15
 Apr 2022 14:59:09 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:45 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-2-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 01/17] KVM: arm64: Directly read owner id field in stage2_pte_is_counted()
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

A subsequent change to KVM will make use of additional bits in invalid
ptes. Prepare for said change by explicitly checking the valid bit and
owner fields in stage2_pte_is_counted()

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2cb3867eb7c2..e1506da3e2fb 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -172,6 +172,11 @@ static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
 	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
 }
 
+static u8 kvm_invalid_pte_owner(kvm_pte_t pte)
+{
+	return FIELD_GET(KVM_INVALID_PTE_OWNER_MASK, pte);
+}
+
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
 				  u32 level, kvm_pte_t *ptep,
 				  enum kvm_pgtable_walk_flags flag)
@@ -679,7 +684,7 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 	 * encode ownership of a page to another entity than the page-table
 	 * owner, whose id is 0.
 	 */
-	return !!pte;
+	return kvm_pte_valid(pte) || kvm_invalid_pte_owner(pte);
 }
 
 static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
-- 
2.36.0.rc0.470.gd361397f0d-goog

