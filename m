Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0D3CB154
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388998AbfJCVjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:39:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:52651 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388076AbfJCVjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:39:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051632"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:57 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 07/13] kvm: Add docs for KVM_CAP_EXECONLY_MEM
Date:   Thu,  3 Oct 2019 14:23:54 -0700
Message-Id: <20191003212400.31130-8-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add documentation for the KVM_CAP_EXECONLY_MEM capability and
KVM_MEM_EXECONLY memslot.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 Documentation/virt/kvm/api.txt | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 2d067767b617..a8001f996a8a 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -1096,6 +1096,7 @@ struct kvm_userspace_memory_region {
 /* for kvm_memory_region::flags */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_EXECONLY	(1UL << 2)
 
 This ioctl allows the user to create, modify or delete a guest physical
 memory slot.  Bits 0-15 of "slot" specify the slot id and this value
@@ -1123,12 +1124,15 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
-KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
-writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
-use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
-to make a new slot read-only.  In this case, writes to this memory will be
-posted to userspace as KVM_EXIT_MMIO exits.
+The flags field supports three flags: KVM_MEM_LOG_DIRTY_PAGES, KVM_MEM_READONLY
+and KVM_MEM_EXECONLY.  KVM_MEM_LOG_DIRTY_PAGES can be set to instruct KVM to
+keep track of writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to
+know how to use it.  KVM_MEM_READONLY can be set, if KVM_CAP_READONLY_MEM
+capability allows it, to make a new slot read-only.  In this case, writes to
+this memory will be posted to userspace as KVM_EXIT_MMIO exits. KVM_MEM_EXECONLY
+can be set, if KVM_CAP_EXECONLY_MEM capability allows it, to make a new slot
+exec-only. Guest read accesses to KVM_CAP_EXECONLY_MEM will trigger an
+appropriate fault injected into the guest, in support of X86_FEATURE_KVM_XO.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
-- 
2.17.1

