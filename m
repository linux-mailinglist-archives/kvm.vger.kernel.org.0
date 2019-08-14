Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2A78CC40
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 09:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfHNHDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 03:03:04 -0400
Received: from mga04.intel.com ([192.55.52.120]:42220 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbfHNHCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 03:02:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 00:02:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,384,1559545200"; 
   d="scan'208";a="181427139"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga006.jf.intel.com with ESMTP; 14 Aug 2019 00:02:31 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH RESEND v4 4/9] KVM: VMX: Introduce SPP access bitmap and operation functions
Date:   Wed, 14 Aug 2019 15:03:58 +0800
Message-Id: <20190814070403.6588-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190814070403.6588-1-weijiang.yang@intel.com>
References: <20190814070403.6588-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create access bitmap for SPP subpages, 4KB/128B = 32bits,
for each 4KB physical page, 32bits are required. The bitmap can
be easily accessed with a gfn. The initial access bitmap for each
physical page is 0xFFFFFFFF, meaning SPP is not enabled for the
subpages.

Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.c              | 50 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              | 11 ++++++++
 3 files changed, 62 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 98e5158287d5..44f6e1757861 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -790,6 +790,7 @@ struct kvm_lpage_info {
 
 struct kvm_arch_memory_slot {
 	struct kvm_rmap_head *rmap[KVM_NR_PAGE_SIZES];
+	u32 *subpage_wp_info;
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
 	unsigned short *gfn_track[KVM_PAGE_TRACK_MAX];
 };
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 494ad2038f36..16e390fd6e58 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1485,6 +1485,56 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 	return sptep;
 }
 
+#define FULL_SPP_ACCESS		((u32)((1ULL << 32) - 1))
+
+static int kvm_subpage_create_bitmaps(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	int i, j, ret;
+	u32 *buff;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(memslot, slots) {
+			buff = kvzalloc(memslot->npages*
+				sizeof(*memslot->arch.subpage_wp_info),
+				GFP_KERNEL);
+
+			if (!buff) {
+			      ret = -ENOMEM;
+			      goto out_free;
+			}
+			memslot->arch.subpage_wp_info = buff;
+
+			for(j = 0; j< memslot->npages; j++)
+			      buff[j] = FULL_SPP_ACCESS;
+		}
+	}
+
+	return 0;
+out_free:
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(memslot, slots) {
+			if (memslot->arch.subpage_wp_info) {
+				kvfree(memslot->arch.subpage_wp_info);
+				memslot->arch.subpage_wp_info = NULL;
+			}
+		}
+	}
+
+	return ret;
+}
+
+static u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	unsigned long idx;
+
+	idx = gfn_to_index(gfn, slot->base_gfn, PT_PAGE_TABLE_LEVEL);
+	return &slot->arch.subpage_wp_info[idx];
+}
+
 #define for_each_rmap_spte(_rmap_head_, _iter_, _spte_)			\
 	for (_spte_ = rmap_get_first(_rmap_head_, _iter_);		\
 	     _spte_; _spte_ = rmap_get_next(_iter_))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b5edc8e3ce1d..26e4c574731c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9317,6 +9317,17 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_hv_destroy_vm(kvm);
 }
 
+void kvm_subpage_free_memslot(struct kvm_memory_slot *free,
+			      struct kvm_memory_slot *dont)
+{
+
+	if (!dont || free->arch.subpage_wp_info !=
+	    dont->arch.subpage_wp_info) {
+		kvfree(free->arch.subpage_wp_info);
+		free->arch.subpage_wp_info = NULL;
+	}
+}
+
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont)
 {
-- 
2.17.2

