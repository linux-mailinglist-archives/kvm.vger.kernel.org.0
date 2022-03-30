Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778814ECAF9
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 19:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349483AbiC3Rsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 13:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349610AbiC3RsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 13:48:21 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6881A136
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 10:46:36 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id d7-20020a17090ad98700b001c6834c71ffso273332pjv.1
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 10:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gp5/oqbk2fI6DwAcVjqyKO14WoJq46+G4sTbdYNQ4HM=;
        b=QOLiRpewW+t88OqSkBE63r2/Xntuf79cBo45qAE8JYSTK0gFn6pzIKL1x9gluakFAy
         fPCYzPwzm2OcKUaY49IZhe79HyD30+YtjVSc316U++wqEoBw5ipIoT8qVtRmIv+f9CGJ
         Ey41djoQ4ewLWYggnso4f50BhAeBb4vRooLgOM4aaQNuLMVVyAEbE6dOmNJqiROnrONH
         PwPJeerDRoceKY0rFF/V4yjJtcdzniRUtVff57IhatmV5yHuDCJ5K9BWdsSxNB8JGuWH
         aOushq/lf3mdpFZFFSQmzEUx5RCnFn07Av4Nv8ANl/gO3JThCAdYl96vwWXZ05p/II6b
         cNhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gp5/oqbk2fI6DwAcVjqyKO14WoJq46+G4sTbdYNQ4HM=;
        b=nWKmkcStdKUrj1CJQg9AgwL9vtiBgZNg+yqmaxLo96GT36ZtW0XG59DuulAmzDdkzB
         Foea2GfBDRTR31cJgbA8PpVYPvzgHTBnzk43IlZEMpoPSUOZHvLKkQJlQz2iZGwgmfX9
         FjDP+LTXsGhDK28BVs19Gk4G/ECQVgQX5+8s+ALNMZohnBGVAFUxEdg5gG7FCHJaM4qh
         ch9kAbxA5tgQ0zw06ggf+D4/0dAueIVeJ6QqavsxKXHvC4DIihHd5d/7kQ1UozO9eEvq
         xrsc43KP6w5dXGb14ML67I2dROc/HNs1zFhu6zzO8JIvRP+y1Ma+6hIs7Q1GZ0GU/hpe
         LAxQ==
X-Gm-Message-State: AOAM531hgBs4FpyUitlYJSTgniEDP/lhPCjlF+tZgi/193ZfTJSzEoWG
        OSs3N8NV+VKgij5tTLhS1z736ypYfYcY
X-Google-Smtp-Source: ABdhPJwTYFZ9uPFmUGU1PepEmiueCb2rVeROZuwOheKg8DQ1WHWEsnVB6IAWI0UaUa513KbYMjGTH2/uQTaO
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:7c53:ec2f:bd26:b69c])
 (user=bgardon job=sendgmr) by 2002:a17:90a:858b:b0:1c6:5bc8:781a with SMTP id
 m11-20020a17090a858b00b001c65bc8781amr110130pjn.0.1648662395639; Wed, 30 Mar
 2022 10:46:35 -0700 (PDT)
Date:   Wed, 30 Mar 2022 10:46:15 -0700
In-Reply-To: <20220330174621.1567317-1-bgardon@google.com>
Message-Id: <20220330174621.1567317-6-bgardon@google.com>
Mime-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v3 05/11] KVM: selftests: Improve error message in vm_phy_pages_alloc
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
        autolearn=ham autolearn_force=no version=3.4.6
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
index 09742a787546..9d72d1bb34fa 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2408,9 +2408,10 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	} while (pg && pg != base + num);
 
 	if (pg == 0) {
-		fprintf(stderr, "No guest physical page available, "
+		fprintf(stderr,
+			"Unable to find %ld contiguous guest physical pages. "
 			"paddr_min: 0x%lx page_size: 0x%x memslot: %u\n",
-			paddr_min, vm->page_size, memslot);
+			num, paddr_min, vm->page_size, memslot);
 		fputs("---- vm dump ----\n", stderr);
 		vm_dump(stderr, vm, 2);
 		abort();
-- 
2.35.1.1021.g381101b075-goog

