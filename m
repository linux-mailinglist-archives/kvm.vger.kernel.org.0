Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D57FF192025
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 05:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgCYE0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 00:26:49 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39234 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726206AbgCYE0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 00:26:49 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 15AD56D2D2F65F81D46A;
        Wed, 25 Mar 2020 12:26:44 +0800 (CST)
Received: from linux-kDCJWP.huawei.com (10.175.104.212) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 25 Mar 2020 12:26:33 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jay Zhou <jianjay.zhou@huawei.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH 1/3] KVM/memslot: Move the initial set of dirty bitmap to arch
Date:   Wed, 25 Mar 2020 12:24:21 +0800
Message-ID: <20200325042423.12181-2-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200325042423.12181-1-zhukeqian1@huawei.com>
References: <20200325042423.12181-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.212]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, when KVM_DIRTY_LOG_INITIALLY_SET is enabled, the initial set
of memslot dirty bitmap is located at arch shared path. By making this
implementation be architecture depended, we can realize some architecture
depended optimizations (e.g. Only mark dirty for these pages with valid
translation entries, then userspace can use this information to only send
these pages during migration).

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/x86/kvm/x86.c  | 3 +++
 virt/kvm/kvm_main.c | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e54c6ad628a8..ccab8b56bc7c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10031,6 +10031,9 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * See the comments in fast_page_fault().
 	 */
 	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			bitmap_set(new->dirty_bitmap, 0, new->npages);
+
 		if (kvm_x86_ops->slot_enable_log_dirty) {
 			kvm_x86_ops->slot_enable_log_dirty(kvm, new);
 		} else {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 28eae681859f..531d96c6871e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1289,9 +1289,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		r = kvm_alloc_dirty_bitmap(&new);
 		if (r)
 			return r;
-
-		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
-			bitmap_set(new.dirty_bitmap, 0, new.npages);
 	}
 
 	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
-- 
2.19.1

