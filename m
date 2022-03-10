Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38B64D4F94
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243624AbiCJQra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241490AbiCJQrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:47:12 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9C71688C0
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:03 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id j1-20020a170903028100b0014b1f9e0068so2976885plr.8
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZtMt2wyNKjtAiC88Q9bMZ9sXYSFZv/d9rVnBJi58YjE=;
        b=kF1znJ85tnfKN1AqdnzwfECAQ2Bujq/sYB5jsXv9223OEp8oLI7a4GjXMMqiXdJKwt
         XHQV3yyoMv/foJR1ICm6OepAwP6nQRV8LErs/I5gGumDWU9qzwjTbRTW9HCR0PWgqlB6
         x8vNVZLqVGy4eHLzBawQNrARD/WxTyRhjgI0bjLQqJrLR6X/F3L+HVwfArLVEC7cniWG
         7SH/D9MddLJkIEnASvtVy9Mo6CLqaZoFYjpXIH5hBRa/UrxhjeqnwXd0mw+5K2HBtRrx
         7giUtfK0uwxO9EitJUz30MABR9jtP1s0OzhBmWmD+N8hOkBUrnF9WOvqqhVh0Gts5EHk
         VFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZtMt2wyNKjtAiC88Q9bMZ9sXYSFZv/d9rVnBJi58YjE=;
        b=X4/0/Y6l71IskZ1RIHQPTDMiexE9688Q+tD42bRofrW9I0AAmy9TXXJzJ5YQF/7QnA
         m35Kh0Ck/droECo+udUYmUgT+TMSwUagvsmxVijwCkGc4Xpz+LR1jxNYmce1HOIy2wGn
         l5sO1gf5v71TgspLArJEmUs3izbnCx6UFLDH15lU7rx23yAvhkEPulTjDzHrJSUwmD3j
         MF3yvYGZCjQi8PktXIdw1ECRXNVRPKHiwN8SWZtSGY/Vpm65e7+nls1X05i08dVDKzKB
         2OEGJbHrQuYbQ3hOFszSHHXW5Wd4FiEi8H/b5ye64oOhHw7SU8cK8YDBBiB/S9U38Mt8
         39Xw==
X-Gm-Message-State: AOAM532BwK0uTh1B4LJ4w9BFIhRwvXxAS4GWVfkrS4ShypVFAgSB63Pq
        8dtV2MqywhdWtm3fttg/dTEIGiQU4Nak
X-Google-Smtp-Source: ABdhPJyoHfbF8RQ9sOUvgKO7WeX+jxEC0rLnHPaqY5crXjjYxoTQBF0iZZpOSN7klvCidjTmaT7hiCOEyKeL
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:2296:b0:4e1:905f:46b6 with SMTP
 id f22-20020a056a00229600b004e1905f46b6mr5914762pfe.16.1646930762732; Thu, 10
 Mar 2022 08:46:02 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:25 -0800
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
Message-Id: <20220310164532.1821490-7-bgardon@google.com>
Mime-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 06/13] selftests: KVM: Improve error message in vm_phy_pages_alloc
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Make an error message in vm_phy_pages_alloc more specific, and log the
number of pages requested in the allocation.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a10bee651191..f9591dad1010 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2408,9 +2408,10 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	} while (pg && pg != base + num);
 
 	if (pg == 0) {
-		fprintf(stderr, "No guest physical page available, "
+		fprintf(stderr,
+			"Unable to find %ld contiguous guest physical pages. "
 			"paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
-			paddr_min, vm->page_size, memslot.id);
+			num, paddr_min, vm->page_size, memslot.id);
 		fputs("---- vm dump ----\n", stderr);
 		vm_dump(stderr, vm, 2);
 		abort();
-- 
2.35.1.616.g0bdcbb4464-goog

