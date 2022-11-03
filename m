Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3D26189C3
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 21:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiKCUo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 16:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKCUoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 16:44:25 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C171CFD2
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 13:44:24 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3691846091fso28374877b3.9
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 13:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gZjxMa2o2lIB5f0O5ApzvKQHK+nnAzaO63nl4HV7qcs=;
        b=A2dNWW/lB3vYSRcyXKgrHJacIauqYZ+0M3sRvwzySRRmQFDF6DOv2TCEaLd/CqiBTv
         i21uh3/5YqZRVYVjgGcNGrr/7XoDGxdOQKM+5K7Q+imbT78CTUG4Jz8eg+eYTt8sJf/r
         oBYIOANOWoQ4nDjldGOIEm6N4+n4VBJFOBC/GiebE4xZCqFGrGXFSKKajFx7oIJnH37d
         ZdEKo/IdW2ky/MFm7kQzLiEWBWHnE0VMvCHfIscMEPe1lHYqDmRQ71r4sOlMkic8rvAZ
         xZwcLmkj2g5dJe9LvkrkSAJvp20NzD7gzCCcH8wOo4GgPx8xoB4uoOLo0KYlTV5PLehk
         5zig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gZjxMa2o2lIB5f0O5ApzvKQHK+nnAzaO63nl4HV7qcs=;
        b=UoQ+JxaA705/+49Ik7Cv07SbPY4/C/Wv/Lc/0ybdtQzKy4K7FTLHkaXAdSBh1Z75sB
         WPyaetoCs85Frw8Hq5H+zb2pPvTdjP05OnjzERge8hO9cZhzlGKUlBJpobWIWrY13epT
         L79daJdgfQaWzN02UE9zeZ/4lZEkZniqTp6nwFb3BSfYNbsfOU9wV+R59Ibilx9EsYEh
         f8691WSZoM//DTyB8vWxf3CA1INgtuHi608pe/O0jerooRq7bCkYedTLkY6u1lDAZzWP
         kTIfhcuH8uGRlCxT1iQ2etkln/6HwZHiP/McEhLH+gmUrSdaoBw4MAUJcOgXQtm7YVd/
         AcjA==
X-Gm-Message-State: ACrzQf0tea1qFeihdXvq5Bt7tbDX4V5EqaMMqb1aMxFDxwEqsjkpLVxq
        Y/REYIIhdDN+vdA1ccPrW2VWmhTJ0KbwBg==
X-Google-Smtp-Source: AMsMyM62Ze2/sy8ru2ONW0J6MhUJeLkrFvpyiMx+TZkoPd+xklnnDCEjmL8mKxR91ipAQ0vWX/UvWcz/Aa2stw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:5807:0:b0:36a:b20c:a88a with SMTP id
 m7-20020a815807000000b0036ab20ca88amr29731998ywb.324.1667508263503; Thu, 03
 Nov 2022 13:44:23 -0700 (PDT)
Date:   Thu,  3 Nov 2022 13:44:21 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221103204421.1146958-1-dmatlack@google.com>
Subject: [PATCH v2] KVM: x86/mmu: Do not recover dirty-tracked NX Huge Pages
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
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

Do not recover (i.e. zap) an NX Huge Page that is being dirty tracked,
as it will just be faulted back in at the same 4KiB granularity when
accessed by a vCPU. This may need to be changed if KVM ever supports
2MiB (or larger) dirty tracking granularity, or faulting huge pages
during dirty tracking for reads/executes. However for now, these zaps
are entirely wasteful.

This commit does nominally increase the CPU usage of the NX recover
worker by about 1% when testing with a VM with 16 slots.

Signed-off-by: David Matlack <dmatlack@google.com>
---
In order to check if this commit increases the CPU usage of the NX
recovery worker thread I used a modified version of execute_perf_test
[1] that supports splitting guest memory into multiple slots and reports
/proc/pid/schedstat:se.sum_exec_runtime for the NX recovery worker just
before tearing down the VM. The goal was to force a large number of NX
Huge Page recoveries and see if the recovery worker used any more CPU.

Test Setup:

  echo 1000 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
  echo 10 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio

Test Command:

  ./execute_perf_test -v64 -s anonymous_hugetlb_1gb -x 16 -o

        | kvm-nx-lpage-re:se.sum_exec_runtime      |
        | ---------------------------------------- |
Run     | Before             | After               |
------- | ------------------ | ------------------- |
1       | 730.084105         | 724.375314          |
2       | 728.751339         | 740.581988          |
3       | 736.264720         | 757.078163          |

Comparing the median results, this commit results in about a 1% increase
CPU usage of the NX recovery worker.

[1] https://lore.kernel.org/kvm/20221019234050.3919566-2-dmatlack@google.com/

v2:
 - Only skip NX Huge Pages that are actively being dirty tracked [Paolo]

v1: https://lore.kernel.org/kvm/20221027200316.2221027-1-dmatlack@google.com/

 arch/x86/kvm/mmu/mmu.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 82bc6321e58e..1c443f9aeb4b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6831,6 +6831,7 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 {
 	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
+	struct kvm_memory_slot *slot;
 	int rcu_idx;
 	struct kvm_mmu_page *sp;
 	unsigned int ratio;
@@ -6865,7 +6866,21 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 				      struct kvm_mmu_page,
 				      possible_nx_huge_page_link);
 		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
-		if (is_tdp_mmu_page(sp))
+		WARN_ON_ONCE(!sp->role.direct);
+
+		slot = gfn_to_memslot(kvm, sp->gfn);
+		WARN_ON_ONCE(!slot);
+
+		/*
+		 * Unaccount and do not attempt to recover any NX Huge Pages
+		 * that are being dirty tracked, as they would just be faulted
+		 * back in as 4KiB pages. The NX Huge Pages in this slot will be
+		 * recovered, along with all the other huge pages in the slot,
+		 * when dirty logging is disabled.
+		 */
+		if (slot && kvm_slot_dirty_track_enabled(slot))
+			unaccount_nx_huge_page(kvm, sp);
+		else if (is_tdp_mmu_page(sp))
 			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
 		else
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);

-- 
2.38.1.431.g37b22c650d-goog

