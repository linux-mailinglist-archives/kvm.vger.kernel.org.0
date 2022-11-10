Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C989E623921
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiKJBpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbiKJBpO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:45:14 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6A928E27;
        Wed,  9 Nov 2022 17:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668044713; x=1699580713;
  h=from:to:cc:subject:date:message-id;
  bh=Yu7AhOcppEOEMu7RqmcY9BM0Dgnu0f+ahhlPn/ItzqA=;
  b=O/qmz2G+XLSAahxrybAYwFXgPqp+syXXP+/wD81V42JZL5UQASzHiYMY
   IEzVdK5Ez0QMeWEqkLNZp00IxgM0eKe0PS0sTT7GEZhguhjmaWCzU5LYM
   8k11rUv3Mp34r35s9fd05pzdJ7QVg5jHl3HWU7krvLE62WhGV8B0GzrD6
   hJXOf/tfc8vZmBv5X9y8oI2x7xMpdRImGu+ssfbtW8w8Tu2HLdpLNhvMV
   9JOECregw6r0Y4SqgpLM3mMIAi6o+TZONmAn4RcCH1595x9V1/eY01Z0i
   kiQ+rA+e0gpAdo42RX+IUEeWhracNMQz6js4E/MDUR/YDAqi1ZBSEtJ56
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="312305678"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="312305678"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 17:44:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="882158088"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="882158088"
Received: from yzhao56-desk.sh.intel.com ([10.238.200.254])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 17:44:55 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] KVM: do not prepare new memslot for KVM_MR_DELETE
Date:   Thu, 10 Nov 2022 09:22:04 +0800
Message-Id: <20221110012204.3919-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_prepare_memory_region() is not useful for KVM_MR_DELETE,
and each kvm_arch_prepare_memory_region() does nothing more than returning
0 for KVM_MR_DELETE.
So, just don't call into kvm_prepare_memory_region() to avoid unnecessary
error handling for KVM_MR_DELETE.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 virt/kvm/kvm_main.c | 52 ++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25d7872b29c1..44e7fb1c376b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1612,19 +1612,17 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 	 * new and KVM isn't using a ring buffer, allocate and initialize a
 	 * new bitmap.
 	 */
-	if (change != KVM_MR_DELETE) {
-		if (!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
-			new->dirty_bitmap = NULL;
-		else if (old && old->dirty_bitmap)
-			new->dirty_bitmap = old->dirty_bitmap;
-		else if (!kvm->dirty_ring_size) {
-			r = kvm_alloc_dirty_bitmap(new);
-			if (r)
-				return r;
+	if (!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
+		new->dirty_bitmap = NULL;
+	else if (old && old->dirty_bitmap)
+		new->dirty_bitmap = old->dirty_bitmap;
+	else if (!kvm->dirty_ring_size) {
+		r = kvm_alloc_dirty_bitmap(new);
+		if (r)
+			return r;
 
-			if (kvm_dirty_log_manual_protect_and_init_set(kvm))
-				bitmap_set(new->dirty_bitmap, 0, new->npages);
-		}
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			bitmap_set(new->dirty_bitmap, 0, new->npages);
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, old, new, change);
@@ -1849,21 +1847,23 @@ static int kvm_set_memslot(struct kvm *kvm,
 		kvm_invalidate_memslot(kvm, old, invalid_slot);
 	}
 
-	r = kvm_prepare_memory_region(kvm, old, new, change);
-	if (r) {
-		/*
-		 * For DELETE/MOVE, revert the above INVALID change.  No
-		 * modifications required since the original slot was preserved
-		 * in the inactive slots.  Changing the active memslots also
-		 * release slots_arch_lock.
-		 */
-		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-			kvm_activate_memslot(kvm, invalid_slot, old);
-			kfree(invalid_slot);
-		} else {
-			mutex_unlock(&kvm->slots_arch_lock);
+	if (change != KVM_MR_DELETE) {
+		r = kvm_prepare_memory_region(kvm, old, new, change);
+		if (r) {
+			/*
+			 * For MOVE, revert the above INVALID change. No
+			 * modifications required since the original slot was preserved
+			 * in the inactive slots.  Changing the active memslots also
+			 * release slots_arch_lock.
+			 */
+			if (change == KVM_MR_MOVE) {
+				kvm_activate_memslot(kvm, invalid_slot, old);
+				kfree(invalid_slot);
+			} else {
+				mutex_unlock(&kvm->slots_arch_lock);
+			}
+			return r;
 		}
-		return r;
 	}
 
 	/*
-- 
2.17.1

