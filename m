Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6B6620BC1
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 10:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbiKHJHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 04:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbiKHJHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 04:07:09 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114801E3F0;
        Tue,  8 Nov 2022 01:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667898429; x=1699434429;
  h=from:to:cc:subject:date:message-id;
  bh=LJJFnczcEeMn0nte3m6151Gb7yapTGUV60MFhRsjZeo=;
  b=VUJDq89fa7dihyhJXSGJ6IpBwaEjAS6KVCVI8okK+YXtgOpPWVecbDVB
   89KkL3WlwDycZiqXzIMlSGFYe7JbTqrD/wCHcwTcfVKT5h0TdnUrjJIrR
   cBYIhzQf3Pnel4Fnn46uTVnxFYbc5niGY2dyPys6B0mPC8rTmJWMWHbKJ
   uB8h6LXeAnKR4xQhSfjIraK6FzEBCf4bvjcnoiz7pGZeB9VqLjsbqfedJ
   0VNZqQ12ERGeVpMb7H3F1Crg9ijDAfjTM4lkOZAn5KVH9bBcHFtg5qAqx
   ATw56WUbGKULHLJ6do6/FxjGS+8wkrvJBUWtbnLgNDf/d7okwd3R6aDkv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="291034619"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="291034619"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 01:07:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811172114"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="811172114"
Received: from yzhao56-desk.sh.intel.com ([10.238.200.254])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 01:07:07 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] KVM: move memslot invalidation later than possible failures
Date:   Tue,  8 Nov 2022 16:44:16 +0800
Message-Id: <20221108084416.11447-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For memslot delete and move, kvm_invalidate_memslot() is required before
the real changes committed.
Besides swapping to an inactive slot, kvm_invalidate_memslot() will call
kvm_arch_flush_shadow_memslot() and further kvm_page_track_flush_slot() in
arch x86.
And according to the definition in kvm_page_track_notifier_node, users can
drop write-protection for the pages in the memory slot on receiving
.track_flush_slot.

However, if kvm_prepare_memory_region() fails, the later
kvm_activate_memslot() will only swap back the original slot, leaving
previous write protection not recovered.

This may not be a problem for kvm itself as a page tracker user, but may
cause problem to other page tracker users, e.g. kvmgt, whose
write-protected pages are removed from the write-protected list and not
added back.

So call kvm_prepare_memory_region first for meta data preparation before
the slot invalidation so as to avoid failure and recovery.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 virt/kvm/kvm_main.c | 40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25d7872b29c1..5f29011f432d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1827,45 +1827,35 @@ static int kvm_set_memslot(struct kvm *kvm,
 	 */
 	mutex_lock(&kvm->slots_arch_lock);
 
-	/*
-	 * Invalidate the old slot if it's being deleted or moved.  This is
-	 * done prior to actually deleting/moving the memslot to allow vCPUs to
-	 * continue running by ensuring there are no mappings or shadow pages
-	 * for the memslot when it is deleted/moved.  Without pre-invalidation
-	 * (and without a lock), a window would exist between effecting the
-	 * delete/move and committing the changes in arch code where KVM or a
-	 * guest could access a non-existent memslot.
-	 *
-	 * Modifications are done on a temporary, unreachable slot.  The old
-	 * slot needs to be preserved in case a later step fails and the
-	 * invalidation needs to be reverted.
-	 */
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
 		invalid_slot = kzalloc(sizeof(*invalid_slot), GFP_KERNEL_ACCOUNT);
 		if (!invalid_slot) {
 			mutex_unlock(&kvm->slots_arch_lock);
 			return -ENOMEM;
 		}
-		kvm_invalidate_memslot(kvm, old, invalid_slot);
 	}
 
 	r = kvm_prepare_memory_region(kvm, old, new, change);
 	if (r) {
-		/*
-		 * For DELETE/MOVE, revert the above INVALID change.  No
-		 * modifications required since the original slot was preserved
-		 * in the inactive slots.  Changing the active memslots also
-		 * release slots_arch_lock.
-		 */
-		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-			kvm_activate_memslot(kvm, invalid_slot, old);
+		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
 			kfree(invalid_slot);
-		} else {
-			mutex_unlock(&kvm->slots_arch_lock);
-		}
+
+		mutex_unlock(&kvm->slots_arch_lock);
 		return r;
 	}
 
+	/*
+	 * Invalidate the old slot if it's being deleted or moved.  This is
+	 * done prior to actually deleting/moving the memslot to allow vCPUs to
+	 * continue running by ensuring there are no mappings or shadow pages
+	 * for the memslot when it is deleted/moved.  Without pre-invalidation
+	 * (and without a lock), a window would exist between effecting the
+	 * delete/move and committing the changes in arch code where KVM or a
+	 * guest could access a non-existent memslot.
+	 */
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
+		kvm_invalidate_memslot(kvm, old, invalid_slot);
+
 	/*
 	 * For DELETE and MOVE, the working slot is now active as the INVALID
 	 * version of the old slot.  MOVE is particularly special as it reuses
-- 
2.17.1

