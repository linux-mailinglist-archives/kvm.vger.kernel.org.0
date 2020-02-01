Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5438C14F9E7
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgBASzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:55:51 -0500
Received: from mga05.intel.com ([192.55.52.43]:37515 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbgBASwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075610"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 60/61] KVM: Drop largepages_enabled and its accessor/mutator
Date:   Sat,  1 Feb 2020 10:52:17 -0800
Message-Id: <20200201185218.24473-61-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop largepages_enabled, kvm_largepages_enabled() and
kvm_disable_largepages() now that all users are gone.

Note, largepages_enabled was an x86-only flag that got left in common
KVM code when KVM gained support for multiple architectures.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 include/linux/kvm_host.h |  2 --
 virt/kvm/kvm_main.c      | 13 -------------
 2 files changed, 15 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6d5331b0d937..50105b5c6370 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -683,8 +683,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
-bool kvm_largepages_enabled(void);
-void kvm_disable_largepages(void);
 /* flush all memory translations */
 void kvm_arch_flush_shadow_all(struct kvm *kvm);
 /* flush memory translations pointing to 'slot' */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eb3709d55139..5851a8c27a28 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -149,8 +149,6 @@ static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
-static bool largepages_enabled = true;
-
 #define KVM_EVENT_CREATE_VM 0
 #define KVM_EVENT_DESTROY_VM 1
 static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
@@ -1368,17 +1366,6 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 EXPORT_SYMBOL_GPL(kvm_clear_dirty_log_protect);
 #endif
 
-bool kvm_largepages_enabled(void)
-{
-	return largepages_enabled;
-}
-
-void kvm_disable_largepages(void)
-{
-	largepages_enabled = false;
-}
-EXPORT_SYMBOL_GPL(kvm_disable_largepages);
-
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
 	return __gfn_to_memslot(kvm_memslots(kvm), gfn);
-- 
2.24.1

