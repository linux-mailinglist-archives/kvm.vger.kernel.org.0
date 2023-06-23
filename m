Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D6A73B780
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 14:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjFWMhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 08:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbjFWMhT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 08:37:19 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBF31FFD
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 05:37:17 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53ba38cf091so1069229a12.1
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 05:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687523836; x=1690115836;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fd3vI91Bi20e0/64LfLhBjelNf+fuRGGJ2P96Ea5T/E=;
        b=Ub46IDulhZqUG4MHliCSdbS5uFDuJXYua2mYgbnWdlIvu8deDjCkByLLOced5OmtAG
         aVLEef9k+da+MduYUJeKhQDbDJQxaan6NznxtaAaVpQwnFzch/SObSd0hFYl64sHpwn/
         Yru0Cr2a/BVva6Nn2L0U39sEEWpX8vlGWWGAjAGgYcdAmic7XlEXg7nxx6Lk0XxGCDFM
         gGZClkbJTh79mbqZ+I03BmduiTtBO1JunvMCsu3Z6SNNNognJcWXHvYcK+d9zC8GsdnK
         X02VI+IV10naw5IQCV6K+GccU1Qz26kN4TC2KxeISVZP28k9241CXGcAl8k4XdYxT+WI
         mCbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687523836; x=1690115836;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fd3vI91Bi20e0/64LfLhBjelNf+fuRGGJ2P96Ea5T/E=;
        b=dsiyYRdrReDbha9eZaJV+izr2ndkOTZiwlR7g3ln3jYDnt9ybilWMJHAYKWJDMAyFo
         CmTaUNqnEqLHiJXBE/Ufk9zOa9gYI1aDf9ZkC4Xc05OFMrFvsfLxBtK8C3phO9CQ/jZu
         CMHJtIGpIy1h1P6kiNdUUdCvB+vzK4EsOJ/lMEXy+bI7W0Wyp7eFJqU0c+EU4Etv0uJF
         4i3jZvEkimBvQMBP8yTizq17nx15b/8SyEYBa1lCPjotukbJ1Uh3rjpuY9ICzrlMreIO
         EXqlLi+2/aVAFyM/3JB6cjihXMat4344VbkuZcgiuYNmvKkU7NGTlx7O9m8P8DgjkZK5
         MFpQ==
X-Gm-Message-State: AC+VfDwsfv5bGgQdmx1TzxNaS5yZZuKKsbpKZ7wbh2uYz44/I8vAXMUr
        Pe5lWt6/64wZvJutaO7Z4vn+plXVVHyYZBWPOGwCIPLGBPe6JM2ldmNxhHgUlj0Tm55fB1oWNgP
        FkGXynHBjS+813XSRBBlan8Md3bJKh87nJnBPosCahkovdkJKXwnZRdgz0wVbglLD0RRd
X-Google-Smtp-Source: ACHHUZ5/dlcyfBcf2otC/XYl7dZGdoFQSzBbFBxEtvoZwQwyXNxHvojMNPwX1y/dQWkIh5BGswfFGkJe0X5daEc6
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:ecd2:b0:1ae:531f:366a with SMTP
 id a18-20020a170902ecd200b001ae531f366amr4437969plh.5.1687523836598; Fri, 23
 Jun 2023 05:37:16 -0700 (PDT)
Date:   Fri, 23 Jun 2023 12:35:23 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.178.g377b9f9a00-goog
Message-ID: <20230623123522.4185651-2-aaronlewis@google.com>
Subject: [PATCH] KVM: x86/pmu: SRCU protect the PMU event filter in the fast path
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

When running KVM's fast path it is possible to get into a situation
where the PMU event filter is dereferenced without grabbing KVM's SRCU
read lock.

The following callstack demonstrates how that is possible.

Call Trace:
  dump_stack+0x85/0xdf
  lockdep_rcu_suspicious+0x109/0x120
  pmc_event_is_allowed+0x165/0x170
  kvm_pmu_trigger_event+0xa5/0x190
  handle_fastpath_set_msr_irqoff+0xca/0x1e0
  svm_vcpu_run+0x5c3/0x7b0 [kvm_amd]
  vcpu_enter_guest+0x2108/0x2580

Fix that by explicitly grabbing the read lock before dereferencing the
PMU event filter.

Fixes: dfdeda67ea2d ("KVM: x86/pmu: Prevent the PMU from counting disallowed events")

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/pmu.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index bf653df86112..2b2247f74ab7 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -381,18 +381,29 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 {
 	struct kvm_x86_pmu_event_filter *filter;
 	struct kvm *kvm = pmc->vcpu->kvm;
+	bool allowed;
+	int idx;
 
 	if (!static_call(kvm_x86_pmu_hw_event_available)(pmc))
 		return false;
 
+	idx = srcu_read_lock(&kvm->srcu);
+
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
-	if (!filter)
-		return true;
+	if (!filter) {
+		allowed = true;
+		goto out;
+	}
 
 	if (pmc_is_gp(pmc))
-		return is_gp_event_allowed(filter, pmc->eventsel);
+		allowed = is_gp_event_allowed(filter, pmc->eventsel);
+	else
+		allowed = is_fixed_event_allowed(filter, pmc->idx);
+
+out:
+	srcu_read_unlock(&kvm->srcu, idx);
 
-	return is_fixed_event_allowed(filter, pmc->idx);
+	return allowed;
 }
 
 static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
-- 
2.41.0.178.g377b9f9a00-goog

