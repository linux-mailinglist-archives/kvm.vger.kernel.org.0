Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB923649E6
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 20:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241110AbhDSSiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 14:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbhDSSiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 14:38:17 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FE0C06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:37:47 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id n7-20020a05620a2227b02902e3b6e9f887so2995210qkh.21
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+WY+blaIG7SHWZsjIU6gf30zUSW6OFhHYfMLmJiOTIs=;
        b=lsaPWWp1HFN4HCc1Ki750iUCiKMu3i+HX2sMUuf2qrhjuP56qdk34JuXrUNZ1jpTF+
         R+++3NN7WPymLlKHgr4F1arFPTZnetmeKoOZ5vv/d9K6C+C6rKcy7Mikrxu7chMS1cwg
         6SN7itDpaPomRZlF7UAGC6GOUQMCdddKiFpppxnJDfZsclcUtzdwfNOlTljqxFj+LRYE
         21Xil4UhrubR1HKWmGwBArPHPaNmssgE280bDJzSmzvhFvHzljjfkHCLUocc2r0emMbf
         ZZmYp0gJLLBO8Ww13k9UigPUDzQPSQyVQu6QDTj7tdP8GRlSWDsNk7VRoYON7c1NZQ02
         qrsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+WY+blaIG7SHWZsjIU6gf30zUSW6OFhHYfMLmJiOTIs=;
        b=YW97P8IFKJoMnhGud/hxeXseQJWek6sTRJZRlxz3Obl4dRrO1X/QsLoHrmONGFhHcX
         VfJYWGZtRbr5uqokgMvyY8mtmiQdAeRLmetiKVXu0udVMwnXlIQKuyMjh4hYRizI5yHW
         wZwlz04fBchs+qXYrZzwAWHJUVdjNlcvIE4Cfm2sujZS7Rhx6P1flDLCw4dfcejNGIZ4
         xA/V5Mr9aTI7HzctzhBTLf9TKaDl+zL2UVFohY7YIgwyGEnw//7V/z8FMZAx97lLKA7u
         6SqstxBIL2Ac0Hdd0NYbWR9BHumjR7QSs+E5WOHO0dy7ZtAQFt5/wSpFlbW0F+5Zc/D2
         S0dw==
X-Gm-Message-State: AOAM531xIVq57D/GgEmAHb0j9JlmYRrR/rJYFjsyoSFkpyZbhJVMpTAu
        N9XSsF51ztD/bPRR57xy9lmPojkp0XUo
X-Google-Smtp-Source: ABdhPJyRmGq41hMP+eyXKSvMD7OtpBBDqs4Owh6WeIPOsPRLBMsNDfXvDtbkUXPv9fHrBPu5VU85136eSOYG
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:8c52:76ef:67d7:24b1])
 (user=bgardon job=sendgmr) by 2002:a0c:f744:: with SMTP id
 e4mr23222467qvo.5.1618857466814; Mon, 19 Apr 2021 11:37:46 -0700 (PDT)
Date:   Mon, 19 Apr 2021 11:37:41 -0700
Message-Id: <20210419183742.901647-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH 1/2] KVM: x86/mmu: Wrap kvm_mmu_zap_all_fast TDP MMU code in ifdefs
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Ben Gardon <bgardon@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TDP MMU code in kvm_mmu_zap_all_fast is only needed with
CONFIG_X86_64 and creates a build error without that setting. Since the
TDP MMU can only be enabled with CONFIG_X86_64, wrap those code blocks
in ifdefs.

Fixes: 1336c692abad ("KVM: x86/mmu: Fast invalidation for TDP MMU")

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0f311c9bf9c6..3ae59c8e129b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5407,7 +5407,9 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
  */
 static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 {
+#ifdef CONFIG_X86_64
 	struct kvm_mmu_page *root;
+#endif /* CONFIG_X86_64 */
 
 	lockdep_assert_held(&kvm->slots_lock);
 
@@ -5424,6 +5426,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	kvm->arch.mmu_valid_gen = kvm->arch.mmu_valid_gen ? 0 : 1;
 
 
+#ifdef CONFIG_X86_64
 	if (is_tdp_mmu_enabled(kvm)) {
 		/*
 		 * Mark each TDP MMU root as invalid so that other threads
@@ -5456,6 +5459,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 			if (refcount_inc_not_zero(&root->tdp_mmu_root_count))
 				root->role.invalid = true;
 	}
+#endif /* CONFIG_X86_64 */
 
 	/*
 	 * Notify all vcpus to reload its shadow page table and flush TLB.
@@ -5471,11 +5475,13 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 	write_unlock(&kvm->mmu_lock);
 
+#ifdef CONFIG_X86_64
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
 		read_unlock(&kvm->mmu_lock);
 	}
+#endif /* CONFIG_X86_64 */
 }
 
 static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
-- 
2.31.1.368.gbe11c130af-goog

